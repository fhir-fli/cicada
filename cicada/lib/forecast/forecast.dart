import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod/riverpod.dart';

import '../cicada.dart';

typedef ForecastResult = ({
  VaxPatient patient,
  Map<String, VaxAntigen> agMap,
  Map<String, VaccineGroupForecast> vaccineGroupForecasts,
});

class VaccineGroupForecast {
  VaccineGroupForecast({
    required this.vaccineGroupName,
    required this.status,
    this.earliestDate,
    this.recommendedDate,
    this.pastDueDate,
    this.latestDate,
    required this.antigenNames,
  });

  final String vaccineGroupName;
  final SeriesStatus status;
  final VaxDate? earliestDate;
  final VaxDate? recommendedDate;
  final VaxDate? pastDueDate;
  final VaxDate? latestDate;
  final List<String> antigenNames;
}

/// Multi-antigen vaccine groups per CDSi spec Chapter 9
const _multiAntigenGroups = <String, List<String>>{
  'DTaP/Tdap/Td': ['Diphtheria', 'Tetanus', 'Pertussis'],
  'MMR': ['Measles', 'Mumps', 'Rubella'],
};

/// CDSi Section 8.8 — Determine Best Patient Series (Table 8-14).
///
/// For each series group that has a prioritized patient series (from steps
/// 8.1–8.7), determines whether that prioritized series qualifies as a
/// "best patient series." Returns ALL best patient series for the antigen.
///
/// Multiple best series can coexist when they come from non-equivalent
/// series groups (e.g., a completed standard series and a not-complete risk
/// series). Table 8-14 rules:
///   Rule 1: Complete → best.
///   Rule 2: Not complete, not Evaluation Only, series type Risk → best.
///   Rule 3: Not complete, not Evaluation Only, not Risk, and no Risk
///           prioritized series in an equivalent series group → best.
///   Default: No best patient series for the series group.
List<VaxSeries> _determineBestPatientSeries(VaxAntigen antigen) {
  // Collect ONE prioritized series per series group.
  // prioritizedSeries is populated by VaxGroup.forecast() (steps 8.1–8.7).
  // If a group has no prioritized series, it means scoring could not
  // identify a representative — skip it (Table 8-14 only applies to groups
  // with a prioritized series). Exception: contraindicated antigens where
  // forecast() was not called — fall back to the first series to preserve
  // the contraindicated status.
  final Map<String, VaxSeries> prioritizedByGroup = {};
  for (final entry in antigen.groups.entries) {
    final group = entry.value;
    final VaxSeries? pri = group.prioritizedSeries.isNotEmpty
        ? group.prioritizedSeries.first
        : (antigen.contraindication && group.series.isNotEmpty
            ? group.series.first
            : null);
    if (pri != null) {
      prioritizedByGroup[entry.key] = pri;
    }
  }

  // Build mapping: groupKey → equivalentSeriesGroups value.
  // All series in a group should share the same value; use the first
  // non-null, non-none value.
  final Map<String, EquivalentSeriesGroups> groupToEquiv = {};
  for (final entry in antigen.groups.entries) {
    for (final s in entry.value.series) {
      final esg = s.series.equivalentSeriesGroups;
      if (esg != null && esg != EquivalentSeriesGroups.none) {
        groupToEquiv[entry.key] = esg;
        break;
      }
    }
  }

  // Apply Table 8-14 to each prioritized series.
  final List<VaxSeries> bestSeries = [];

  for (final entry in prioritizedByGroup.entries) {
    final groupKey = entry.key;
    final pri = entry.value;

    // Rule 1: Is the prioritized patient series a complete patient series?
    if (pri.seriesStatus == SeriesStatus.complete ||
        pri.seriesStatus == SeriesStatus.immune) {
      bestSeries.add(pri);
      continue;
    }

    // Find equivalent group keys: other groups with the same
    // equivalentSeriesGroups value as this group.
    final myEquiv = groupToEquiv[groupKey];
    final Set<String> equivalentGroupKeys = {};
    if (myEquiv != null) {
      for (final e in groupToEquiv.entries) {
        if (e.key != groupKey && e.value == myEquiv) {
          equivalentGroupKeys.add(e.key);
        }
      }
    }

    // Is there a prioritized patient series that is a complete patient
    // series in an equivalent series group?
    bool completeInEquivalent = false;
    for (final eqKey in equivalentGroupKeys) {
      final eqPri = prioritizedByGroup[eqKey];
      if (eqPri != null &&
          (eqPri.seriesStatus == SeriesStatus.complete ||
              eqPri.seriesStatus == SeriesStatus.immune)) {
        completeInEquivalent = true;
        break;
      }
    }

    if (completeInEquivalent) {
      // Default: no best (equivalent group already complete).
      continue;
    }

    // Is the series type 'Evaluation Only'?
    if (pri.series.seriesType == SeriesType.evaluationOnly) {
      // Default: no best.
      continue;
    }

    // Series that are Aged Out or Not Recommended are not active — they
    // represent dismissed series (patient outside age range or conditions
    // not met) and should not propagate to the vaccine group level.
    if (pri.seriesStatus == SeriesStatus.agedOut ||
        pri.seriesStatus == SeriesStatus.notRecommended) {
      continue;
    }

    // Rule 2: Is the series type 'Risk'?
    if (pri.series.seriesType == SeriesType.risk) {
      bestSeries.add(pri);
      continue;
    }

    // Rule 3: Is there a prioritized patient series with a series type
    // of 'Risk' in an equivalent series group?
    bool riskInEquivalent = false;
    for (final eqKey in equivalentGroupKeys) {
      final eqPri = prioritizedByGroup[eqKey];
      if (eqPri != null && eqPri.series.seriesType == SeriesType.risk) {
        riskInEquivalent = true;
        break;
      }
    }

    if (!riskInEquivalent) {
      // Rule 3: No risk in equivalent → this is a best series.
      bestSeries.add(pri);
      continue;
    }

    // Default: no best (a risk series in an equivalent group takes
    // precedence over this non-complete standard series).
  }

  return bestSeries;
}

/// FORECASTPRIORITY-1: A patient series forecast is a priority forecast if
/// the target dose includes at least one preferable interval and each
/// preferable interval has an interval priority flag of 'Y'.
/// Note: CDSi v4.64 supporting data uses "override" instead of "Y" for all
/// interval priorities, so we treat both values as satisfying the condition.
bool _isPriorityForecast(VaxSeries series) {
  final int td = series.targetDose;
  if (td >= (series.series.seriesDose?.length ?? 0)) return false;
  final SeriesDose seriesDose = series.series.seriesDose![td];
  final List<Interval>? prefIntervals = seriesDose.preferableInterval;
  if (prefIntervals == null || prefIntervals.isEmpty) return false;
  return prefIntervals.every((Interval i) =>
      i.intervalPriority == 'Y' || i.intervalPriority == 'override');
}

/// FORECASTVG-1: Determine vaccine group status from antigen statuses
SeriesStatus _aggregateStatus(List<SeriesStatus> statuses) {
  // Contraindicated if any
  if (statuses.any((s) => s == SeriesStatus.contraindicated)) {
    return SeriesStatus.contraindicated;
  }
  // Aged out if any
  if (statuses.any((s) => s == SeriesStatus.agedOut)) {
    return SeriesStatus.agedOut;
  }
  // Not recommended if any
  if (statuses.any((s) => s == SeriesStatus.notRecommended)) {
    return SeriesStatus.notRecommended;
  }
  // Not complete if any
  if (statuses.any((s) => s == SeriesStatus.notComplete)) {
    return SeriesStatus.notComplete;
  }
  // Immune if all immune
  if (statuses.every((s) => s == SeriesStatus.immune)) {
    return SeriesStatus.immune;
  }
  // Complete if all complete or immune
  if (statuses.every(
      (s) => s == SeriesStatus.complete || s == SeriesStatus.immune)) {
    return SeriesStatus.complete;
  }
  return SeriesStatus.notComplete;
}

/// Build vaccine group forecasts from per-antigen results
Map<String, VaccineGroupForecast> _aggregateVaccineGroupForecasts(
    Map<String, VaxAntigen> agMap) {
  // Group antigens by vaccineGroupName
  final Map<String, List<VaxAntigen>> byGroup = {};
  for (final antigen in agMap.values) {
    byGroup.putIfAbsent(antigen.vaccineGroupName, () => []).add(antigen);
  }

  final Map<String, VaccineGroupForecast> result = {};

  for (final entry in byGroup.entries) {
    final groupName = entry.key;
    final antigens = entry.value;
    final isMultiAntigen = _multiAntigenGroups.containsKey(groupName);

    if (!isMultiAntigen || antigens.length <= 1) {
      // Single-antigen group: collect all best patient series (Table 8-14).
      // Multiple best series can exist from non-equivalent groups.
      final antigen = antigens.first;
      var bestList = _determineBestPatientSeries(antigen);
      if (bestList.isEmpty) continue;

      // CDSi Chapter 9 intro: "For antigens which contain non-equivalent
      // series groups (e.g., multiple best patient series), it is important
      // to only blend best patient series of the same series type (e.g.,
      // risk with risk and standard with standard). Patients in this
      // situation may end up with more than 1 vaccine group forecast."
      //
      // When multiple best series exist from non-equivalent groups of
      // different types, separate by series type and use the risk forecast
      // as the primary VG forecast (the patient has conditions that
      // activated a risk series, so the risk pathway is determinative).
      if (bestList.length > 1) {
        final riskBest = bestList
            .where((s) => s.series.seriesType == SeriesType.risk)
            .toList();
        if (riskBest.isNotEmpty) {
          // Risk series exist — use risk series for the VG forecast.
          bestList = riskBest;
        } else {
          // No risk series. Exclude aged-out series from standard-only
          // aggregation unless ALL are aged out.
          final nonAgedOut = bestList
              .where((s) => s.seriesStatus != SeriesStatus.agedOut)
              .toList();
          if (nonAgedOut.isNotEmpty) bestList = nonAgedOut;
        }
      }

      if (bestList.length == 1) {
        // SINGLEANTVG-1: single best → use its status and dates directly.
        final best = bestList.first;
        result[groupName] = VaccineGroupForecast(
          vaccineGroupName: groupName,
          status: best.seriesStatus,
          earliestDate: best.candidateEarliestDate,
          recommendedDate: best.adjustedRecommendedDate,
          pastDueDate: best.adjustedPastDueDate,
          latestDate: best.latestDate,
          antigenNames: [antigen.targetDisease],
        );
      } else {
        // Multiple best series of the same type from non-equivalent
        // groups. Aggregate status per Table 9-4, dates per SINGLEANTVG-2.
        final statuses = bestList.map((s) => s.seriesStatus).toList();
        final status = _aggregateStatus(statuses);

        VaxDate? earliest;
        VaxDate? recommended;
        VaxDate? pastDue;
        VaxDate? latest;
        for (final s in bestList) {
          if (s.candidateEarliestDate != null &&
              (earliest == null || s.candidateEarliestDate! < earliest)) {
            earliest = s.candidateEarliestDate;
          }
          if (s.adjustedRecommendedDate != null &&
              (recommended == null ||
                  s.adjustedRecommendedDate! < recommended)) {
            recommended = s.adjustedRecommendedDate;
          }
          if (s.adjustedPastDueDate != null &&
              (pastDue == null || s.adjustedPastDueDate! < pastDue)) {
            pastDue = s.adjustedPastDueDate;
          }
          if (s.latestDate != null &&
              (latest == null || s.latestDate! < latest)) {
            latest = s.latestDate;
          }
        }

        result[groupName] = VaccineGroupForecast(
          vaccineGroupName: groupName,
          status: status,
          earliestDate: earliest,
          recommendedDate: recommended,
          pastDueDate: pastDue,
          latestDate: latest,
          antigenNames: [antigen.targetDisease],
        );
      }
      continue;
    }

    // Multi-antigen group: aggregate per CDSi Chapter 9
    final List<SeriesStatus> statuses = [];
    final List<VaxDate> earliestDates = [];
    final List<VaxDate> recommendedDates = [];
    final List<VaxDate> pastDueDates = [];
    final List<VaxDate> latestDates = [];
    final List<String> antigenNames = [];

    // Cache best series per antigen for reuse in priority check.
    final Map<String, List<VaxSeries>> bestByAntigen = {};
    for (final antigen in antigens) {
      bestByAntigen[antigen.targetDisease] =
          _determineBestPatientSeries(antigen);
    }

    for (final antigen in antigens) {
      final bestList = bestByAntigen[antigen.targetDisease]!;
      if (bestList.isEmpty) continue;
      antigenNames.add(antigen.targetDisease);
      for (final best in bestList) {
        statuses.add(best.seriesStatus);
        if (best.candidateEarliestDate != null) {
          earliestDates.add(best.candidateEarliestDate!);
        }
        if (best.adjustedRecommendedDate != null) {
          recommendedDates.add(best.adjustedRecommendedDate!);
        }
        if (best.adjustedPastDueDate != null) {
          pastDueDates.add(best.adjustedPastDueDate!);
        }
        if (best.latestDate != null) {
          latestDates.add(best.latestDate!);
        }
      }
    }

    if (statuses.isEmpty) continue;

    // FORECASTVG-1: status
    final vgStatus = _aggregateStatus(statuses);

    // MULTIANTVG-1: earliest date per CDSi Table 9-5.
    // Two branches depending on whether any forecast is a "priority
    // patient series forecast" (FORECASTPRIORITY-1).
    //
    // Branch 1 (any priority): the later of
    //   (a) the earliest date of all patient series forecasts, and
    //   (b) the latest dose date administered for a vaccine in this group.
    //
    // Branch 2 (no priority): the latest earliest date of all patient
    //   series forecasts (i.e., max of per-antigen earliest dates).
    bool anyPriority = false;
    for (final antigen in antigens) {
      for (final best in bestByAntigen[antigen.targetDisease]!) {
        if (_isPriorityForecast(best)) {
          anyPriority = true;
          break;
        }
      }
      if (anyPriority) break;
    }

    VaxDate? vgEarliest;
    if (earliestDates.isNotEmpty) {
      if (anyPriority) {
        // Branch 1: min of all earliests, floored at latest dose date
        vgEarliest = earliestDates.reduce((VaxDate a, VaxDate b) =>
            a < b ? a : b);
        VaxDate? latestDoseDate;
        for (final antigen in antigens) {
          for (final group in antigen.groups.values) {
            for (final s in group.series) {
              for (final dose in s.doses) {
                if (latestDoseDate == null ||
                    dose.dateGiven > latestDoseDate) {
                  latestDoseDate = dose.dateGiven;
                }
              }
            }
          }
        }
        if (latestDoseDate != null && vgEarliest < latestDoseDate) {
          vgEarliest = latestDoseDate;
        }
      } else {
        // Branch 2: max of all earliests (latest earliest date)
        vgEarliest = earliestDates.reduce((VaxDate a, VaxDate b) =>
            a > b ? a : b);
      }
    }

    // FORECASTVG-2: recommended = max(min(all recommendeds), vgEarliest)
    VaxDate? vgRecommended;
    if (recommendedDates.isNotEmpty) {
      final minRecommended = recommendedDates.reduce(
          (a, b) => a < b ? a : b);
      if (vgEarliest != null) {
        vgRecommended = vgEarliest > minRecommended
            ? vgEarliest
            : minRecommended;
      } else {
        vgRecommended = minRecommended;
      }
    }

    // FORECASTVG-3: past due = max(min(all past dues), vgEarliest)
    VaxDate? vgPastDue;
    if (pastDueDates.isNotEmpty) {
      final minPastDue = pastDueDates.reduce(
          (a, b) => a < b ? a : b);
      if (vgEarliest != null) {
        vgPastDue = vgEarliest > minPastDue ? vgEarliest : minPastDue;
      } else {
        vgPastDue = minPastDue;
      }
    }

    // FORECASTVG-4: latest = min(all latest dates)
    VaxDate? vgLatest;
    if (latestDates.isNotEmpty) {
      vgLatest = latestDates.reduce(
          (a, b) => a < b ? a : b);
    }

    result[groupName] = VaccineGroupForecast(
      vaccineGroupName: groupName,
      status: vgStatus,
      earliestDate: vgEarliest,
      recommendedDate: vgRecommended,
      pastDueDate: vgPastDue,
      latestDate: vgLatest,
      antigenNames: antigenNames,
    );
  }

  return result;
}

Bundle forecastFromMap(Map<String, dynamic> parameters) {
  if (parameters['resourceType'] == 'Parameters') {
    final Parameters newParameters = Parameters.fromJson(parameters);
    return forecastFromParameters(newParameters);
  }
  return const Bundle(type: BundleType.transaction);
}

ForecastResult evaluateForForecast(Parameters parameters) {
  final ProviderContainer container = ProviderContainer();

  /// Parse out and organize all of the information from input parameters
  final VaxPatient patient = container.read(
    patientForAssessmentProvider(parameters),
  );

  container.read(observationsProvider.notifier).setValue(patient.observations);

  /// Create an agMap that we can work from to evaluate past vaccines
  /// we pass in a list of all past vaccines, the patient's gender
  final Map<String, VaxAntigen> agMap = antigenMap(patient);

  /// Set allPatientDoses on all series for cross-antigen live virus checks
  agMap.forEach((String k, VaxAntigen v) {
    v.groups.forEach((String key, VaxGroup group) {
      for (final VaxSeries series in group.series) {
        series.allPatientDoses = patient.pastDoses;
        series.observations = patient.observations;
      }
    });
  });

  /// Sort into groups
  agMap.forEach((String k, VaxAntigen v) {
    v.groups.forEach((String key, VaxGroup value) {
      container
          .read(seriesGroupCompleteProvider.notifier)
          .newSeriesGroup(k, key);
    });
  });

  /// Evaluate
  agMap.forEach((String k, VaxAntigen v) => v.evaluate());

  /// Forecast
  agMap.forEach((String k, VaxAntigen v) => v.forecast());

  /// Aggregate vaccine group forecasts (Chapter 9)
  final vaccineGroupForecasts = _aggregateVaccineGroupForecasts(agMap);

  return (
    patient: patient,
    agMap: agMap,
    vaccineGroupForecasts: vaccineGroupForecasts,
  );
}

Bundle forecastFromParameters(Parameters parameters) {
  evaluateForForecast(parameters);
  return Bundle(type: BundleType.transaction);
}
