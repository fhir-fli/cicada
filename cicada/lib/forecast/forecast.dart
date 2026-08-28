import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod/riverpod.dart';

import '../cicada.dart';

typedef ForecastResult = ({
  VaxPatient patient,
  Map<String, VaxAntigen> agMap,
  Map<String, List<VaccineGroupForecast>> vaccineGroupForecasts,
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
    this.forecastCvxCodes = const [],
    this.forecastVaccineDescriptions = const [],
    this.doseNumber,
    this.isRiskForecast = false,
    this.seriesGroupName,
    this.antigensNeedingDose = const [],
  });

  final String vaccineGroupName;
  final SeriesStatus status;
  final VaxDate? earliestDate;
  final VaxDate? recommendedDate;
  final VaxDate? pastDueDate;
  final VaxDate? latestDate;
  final List<String> antigenNames;

  /// CVX codes from preferableVaccine where forecastVaccineType == 'Y'
  final List<String> forecastCvxCodes;

  /// Corresponding vaccineType descriptions for each CVX code
  final List<String> forecastVaccineDescriptions;

  /// Target dose number (1-indexed)
  final int? doseNumber;

  /// Whether this forecast came from risk series.
  ///
  /// CDSi Chapter 9 intro blends "risk with risk and standard with standard",
  /// so a vaccine group holding both kinds of series group yields one forecast
  /// of each. This says which one this is.
  final bool isRiskForecast;

  /// The series group this forecast is scoped to (FORECASTVG-1), when it came
  /// from a single series group. Null when it aggregates several.
  final String? seriesGroupName;

  /// Target diseases in this forecast whose best patient series still needs
  /// another dose. A fact about the series, reported so callers can see which
  /// antigens drive the forecast rather than only the blended status.
  final List<String> antigensNeedingDose;
}

/// Multi-antigen vaccine groups derived from the active schedule data.
/// Falls back to CDSi defaults if the map is not available.
Map<String, List<String>> get _multiAntigenGroups {
  final derived = activeMultiAntigenGroups;
  if (derived.isNotEmpty) return derived;
  // CDSi fallback
  return const {
    'DTaP/Tdap/Td': ['Diphtheria', 'Tetanus', 'Pertussis'],
    'MMR': ['Measles', 'Mumps', 'Rubella'],
  };
}

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
  // If no prioritized series exists (e.g., the antigen is contraindicated
  // and forecast() was never called), fall back to the first series to
  // preserve the contraindicated status at the VG level.
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
  prioritizedByGroup.forEach((String groupKey, VaxSeries pri) {
    ForecastTrace.current?.log(
      '8.14 best patient series',
      '${antigen.targetDisease} group $groupKey',
      'prioritized="${pri.series.seriesName}" type=${pri.series.seriesType} '
          'status=${pri.seriesStatus} equiv=${groupToEquiv[groupKey]}',
    );
  });

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
    // However, when the prioritized series in a risk group is aged out but
    // other non-aged-out risk series exist in the same group, use one of
    // those as a fallback (the patient still qualifies for the risk series
    // but the scoring picked an age-restricted product series).
    if (pri.seriesStatus == SeriesStatus.agedOut ||
        pri.seriesStatus == SeriesStatus.notRecommended) {
      if (pri.series.seriesType == SeriesType.risk) {
        final group = antigen.groups[groupKey];
        if (group != null) {
          final candidates = group.series
              .where((s) =>
                  s != pri &&
                  s.series.seriesType == SeriesType.risk &&
                  s.seriesStatus == SeriesStatus.notComplete)
              .toList();
          if (candidates.isNotEmpty) {
            // Prefer the candidate with the latest candidateEarliestDate
            // (most age-appropriate for the patient).
            VaxSeries fallback = candidates.first;
            for (final c in candidates.skip(1)) {
              if (c.candidateEarliestDate != null &&
                  (fallback.candidateEarliestDate == null ||
                      c.candidateEarliestDate! >
                          fallback.candidateEarliestDate!)) {
                fallback = c;
              }
            }
            bestSeries.add(fallback);
            continue;
          }
        }
      }
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

  ForecastTrace.current?.log(
    '8.14 best patient series',
    antigen.targetDisease,
    'best=${bestSeries.map((VaxSeries e) => e.series.seriesName).toList()}',
  );
  return bestSeries;
}

/// FORECASTPRIORITY-1: A patient series forecast is a priority forecast if
/// the target dose includes at least one preferable interval and each
/// preferable interval has an interval priority flag of 'Y'.
/// Note: CDSi v4.64 supporting data uses "override" instead of "Y" for all
/// interval priorities, so we treat both values as satisfying the condition.
/// FORECASTPRIORITY-1: a patient series forecast is a *priority* forecast when
/// the target dose it forecasts includes at least one preferable interval and
/// every preferable interval for that dose has an interval priority flag of 'Y'.
bool _isPriorityForecast(VaxSeries series) {
  final int td = series.targetDose;
  if (td >= (series.series.seriesDose?.length ?? 0)) return false;
  final SeriesDose seriesDose = series.series.seriesDose![td];
  final List<Interval>? prefIntervals = seriesDose.preferableInterval;
  if (prefIntervals == null || prefIntervals.isEmpty) return false;
  return prefIntervals.every((Interval i) =>
      i.intervalPriority == 'Y' || i.intervalPriority == 'override');
}

/// Table 9-4: what is the vaccine group status of a vaccine group forecast for
/// a multiple antigen vaccine group? Its condition rows are asked in this
/// order — Contraindicated, then Aged Out, then Not Recommended, then Not
/// Complete — and the tests below follow them.
///
/// Previously labelled FORECASTVG-1, which is a different rule: that one says
/// which patient series forecasts are *contained in* a vaccine group forecast,
/// and says nothing about deriving a status.
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
  if (statuses
      .every((s) => s == SeriesStatus.complete || s == SeriesStatus.immune)) {
    return SeriesStatus.complete;
  }
  return SeriesStatus.notComplete;
}

/// Extracts forecast CVX codes, descriptions, and dose number from a series.
///
/// FORECASTRECVAC-1: a series dose vaccine is a *recommended* series dose
/// vaccine only if it is a preferable vaccine, its forecast vaccine type flag
/// is 'Y', no vaccine contraindication involves its vaccine type, and the
/// forecast's earliest or adjusted recommended date falls inside its begin/end
/// age range. Table 7-12 assumes that flag is 'N' when empty, so a vaccine that
/// is not marked is deliberately not recommended.
///
/// There is deliberately no fallback when nothing carries the flag: the
/// recommended set is empty, which is what FORECASTRECVAC-1 gives. A fallback
/// to the first preferable vaccine used to sit here, justified by NIST FITS
/// expecting at least one vaccineCode per recommendation — a conformance
/// tester's requirement, not a rule — and it recommended vaccines the
/// supporting data does not mark as forecastable. Removed 2026-08-28; revisit
/// only against FITS itself, and as a response-shaping concern rather than by
/// changing what the engine recommends.
({List<String> cvx, List<String> desc, int? doseNum})
    _extractForecastVaccineInfo(VaxSeries series) {
  final int td = series.targetDose;
  final seriesDoses = series.series.seriesDose;
  if (seriesDoses == null || td >= seriesDoses.length) {
    return (cvx: <String>[], desc: <String>[], doseNum: null);
  }
  final prefVaccines = seriesDoses[td].preferableVaccine;
  final List<String> cvxCodes = [];
  final List<String> descriptions = [];
  if (prefVaccines != null) {
    for (final v in prefVaccines) {
      if (v.forecastVaccineType == 'Y' && v.cvx != null) {
        cvxCodes.add(v.cvx!);
        descriptions.add(v.vaccineType ?? '');
      }
    }
  }
  // FORECASTDN-1: The forecast dose number is calculated by counting
  // satisfied target doses, but for seasonal series doses only those whose
  // administered date is on or after the seasonal recommendation start date.
  int satisfiedCount = 0;
  for (final entry in series.evaluatedTargetDose.entries) {
    if (entry.value != TargetDoseStatus.satisfied) continue;
    final tdIdx = entry.key;
    final sdose = tdIdx < seriesDoses.length ? seriesDoses[tdIdx] : null;
    final seasonalStart = sdose?.seasonalRecommendation?.startDate;
    if (seasonalStart != null && seasonalStart.isNotEmpty) {
      // Seasonal: only count if administered date >= seasonal start date.
      // Use lastWhere because recurring doses may satisfy the same target
      // dose multiple times — we want the most recent administered dose.
      final adminDose = series.evaluatedDoses.cast<VaxDose?>().lastWhere(
          (d) => d!.targetDoseSatisfied == tdIdx,
          orElse: () => null);
      if (adminDose != null) {
        final startDt = VaxDate.fromString(seasonalStart);
        if (adminDose.dateGiven >= startDt) {
          satisfiedCount++;
        }
      }
    } else {
      // Non-seasonal: always count
      satisfiedCount++;
    }
  }
  final int doseNum = satisfiedCount + 1;
  return (cvx: cvxCodes, desc: descriptions, doseNum: doseNum);
}

/// Build vaccine group forecasts from per-antigen results
Map<String, List<VaccineGroupForecast>> _aggregateVaccineGroupForecasts(
    Map<String, VaxAntigen> agMap) {
  // Group antigens by vaccineGroupName
  final Map<String, List<VaxAntigen>> byGroup = {};
  for (final antigen in agMap.values) {
    byGroup.putIfAbsent(antigen.vaccineGroupName, () => []).add(antigen);
  }

  final Map<String, List<VaccineGroupForecast>> result = {};

  for (final entry in byGroup.entries) {
    final groupName = entry.key;
    final antigens = entry.value;
    final isMultiAntigen = _multiAntigenGroups.containsKey(groupName);

    if (!isMultiAntigen || antigens.length <= 1) {
      // Single-antigen group: collect all best patient series (Table 8-14).
      // Multiple best series can exist from non-equivalent groups.
      final antigen = antigens.first;
      var bestList = _determineBestPatientSeries(antigen);
      if (bestList.isEmpty) {
        // No best series — but if all prioritized series are aged out or
        // not recommended, emit a VG forecast with that terminal status
        // so consumers know the patient has aged out of this vaccine group.
        final allPrioritized = <VaxSeries>[];
        for (final group in antigen.groups.values) {
          if (group.prioritizedSeries.isNotEmpty) {
            allPrioritized.add(group.prioritizedSeries.first);
          } else if (group.series.isNotEmpty) {
            allPrioritized.add(group.series.first);
          }
        }
        if (allPrioritized.isNotEmpty) {
          final statuses = allPrioritized.map((s) => s.seriesStatus).toList();
          final aggregated = _aggregateStatus(statuses);
          if (aggregated == SeriesStatus.agedOut ||
              aggregated == SeriesStatus.notRecommended) {
            (result[groupName] ??= <VaccineGroupForecast>[])
                .add(VaccineGroupForecast(
              vaccineGroupName: groupName,
              status: aggregated,
              antigenNames: [antigen.targetDisease],
            ));
          }
        }
        continue;
      }

      // CDSi Chapter 9 intro: "For antigens which contain non-equivalent
      // series groups (e.g., multiple best patient series), it is important
      // to only blend best patient series of the same series type (e.g.,
      // risk with risk and standard with standard). Patients in this
      // situation may end up with more than 1 vaccine group forecast."
      //
      // So partition the best patient series by series type and emit one
      // vaccine group forecast per partition. The engine does not choose
      // between them — the spec says the patient has both, and FORECASTVG-1
      // scopes a forecast to a series group, not to a vaccine group.
      final List<VaxSeries> riskBest = bestList
          .where((s) => s.series.seriesType == SeriesType.risk)
          .toList();
      final List<VaxSeries> standardBest = bestList
          .where((s) => s.series.seriesType != SeriesType.risk)
          .toList();

      // When both kinds are present the risk series may not see childhood
      // doses, which were given before its minimum age. Count its dose
      // number from the union of valid doses across all best series so a
      // prior valid dose counts whichever series evaluated it.
      int? riskUnionDoseNum;
      if (riskBest.isNotEmpty && standardBest.isNotEmpty) {
        final Set<String> uniqueValidDoseIds = {};
        for (final s in bestList) {
          for (final d in s.evaluatedDoses) {
            uniqueValidDoseIds.add(d.doseId);
          }
        }
        riskUnionDoseNum = uniqueValidDoseIds.length + 1;
      }

      final List<List<VaxSeries>> partitions = <List<VaxSeries>>[];
      if (riskBest.isNotEmpty) partitions.add(riskBest);
      if (standardBest.isNotEmpty) {
        // Exclude aged-out series from the standard forecast unless every
        // standard series is aged out.
        final List<VaxSeries> nonAgedOut = standardBest
            .where((s) => s.seriesStatus != SeriesStatus.agedOut)
            .toList();
        partitions.add(nonAgedOut.isNotEmpty ? nonAgedOut : standardBest);
      }

      for (final List<VaxSeries> part in partitions) {
        final bool partIsRisk = part.first.series.seriesType == SeriesType.risk;
        final int? partDoseNum = partIsRisk ? riskUnionDoseNum : null;

        if (part.length == 1) {
          // SINGLEANTVG-1: single best → use its status and dates directly.
          final best = part.first;
          final vaxInfo = _extractForecastVaccineInfo(best);
          (result[groupName] ??= <VaccineGroupForecast>[])
              .add(VaccineGroupForecast(
            vaccineGroupName: groupName,
            status: best.seriesStatus,
            earliestDate: best.candidateEarliestDate,
            recommendedDate: best.adjustedRecommendedDate,
            pastDueDate: best.adjustedPastDueDate,
            latestDate: best.latestDate,
            antigenNames: [antigen.targetDisease],
            forecastCvxCodes: vaxInfo.cvx,
            forecastVaccineDescriptions: vaxInfo.desc,
            doseNumber: partDoseNum ?? vaxInfo.doseNum,
            isRiskForecast: partIsRisk,
            seriesGroupName: best.series.selectSeries?.seriesGroupName,
            antigensNeedingDose: best.shouldRecieveAnotherDose
                ? <String>[antigen.targetDisease]
                : const <String>[],
          ));
        } else {
          // Several best series of the SAME type from non-equivalent series
          // groups. Aggregate status per Table 9-4, dates per SINGLEANTVG-2.
          final statuses = part.map((s) => s.seriesStatus).toList();
          final status = _aggregateStatus(statuses);

          VaxDate? earliest;
          VaxDate? recommended;
          VaxDate? pastDue;
          VaxDate? latest;
          for (final s in part) {
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

          final vaxInfo = _extractForecastVaccineInfo(part.first);
          (result[groupName] ??= <VaccineGroupForecast>[])
              .add(VaccineGroupForecast(
            vaccineGroupName: groupName,
            status: status,
            earliestDate: earliest,
            recommendedDate: recommended,
            pastDueDate: pastDue,
            latestDate: latest,
            antigenNames: [antigen.targetDisease],
            forecastCvxCodes: vaxInfo.cvx,
            forecastVaccineDescriptions: vaxInfo.desc,
            doseNumber: partDoseNum ?? vaxInfo.doseNum,
            isRiskForecast: partIsRisk,
            antigensNeedingDose: part.any((s) => s.shouldRecieveAnotherDose)
                ? <String>[antigen.targetDisease]
                : const <String>[],
          ));
        }
      }
      continue;
    }

    // Multi-antigen group: aggregate per CDSi Chapter 9

    // Cache best series per antigen for reuse in priority check.
    final Map<String, List<VaxSeries>> bestByAntigen = {};
    for (final antigen in antigens) {
      bestByAntigen[antigen.targetDisease] =
          _determineBestPatientSeries(antigen);
    }

    // CDSi Chapter 9 intro, and section 4.4 for this exact vaccine group:
    // "For vaccine groups which contain non-equivalent series groups, it is
    // important to only blend best patient series of the same series type
    // (e.g., risk with risk and standard with standard). Patients in this
    // situation may end up with more than 1 vaccine group forecast."
    //
    // Blending across types produced nonsense. A 28-year-old pregnant patient
    // has a pertussis risk series forecasting during the pregnancy and a
    // childhood standard series that can never age out — its doses carry no
    // maxAge — still forecasting from her 7th birthday in 1995. Blending took
    // the earliest of the two, so the vaccine group answered 1995.
    //
    // So run the aggregation once per series type present and emit a forecast
    // for each. The engine does not choose between them; the last sentence of
    // the passage says the patient has both.
    bool typePresent({required bool risk}) =>
        antigens.any((VaxAntigen a) => bestByAntigen[a.targetDisease]!.any(
            (VaxSeries s) => (s.series.seriesType == SeriesType.risk) == risk));
    final List<bool> passes = <bool>[
      if (typePresent(risk: true)) true,
      if (typePresent(risk: false)) false,
    ];

    for (final bool forRisk in passes) {
      final Map<String, List<VaxSeries>> passBest = <String, List<VaxSeries>>{
        for (final VaxAntigen a in antigens)
          a.targetDisease: bestByAntigen[a.targetDisease]!
              .where((VaxSeries s) =>
                  (s.series.seriesType == SeriesType.risk) == forRisk)
              .toList(),
      };

      final List<SeriesStatus> statuses = [];
      final List<VaxDate> earliestDates = [];
      final List<VaxDate> recommendedDates = [];
      final List<VaxDate> pastDueDates = [];
      final List<VaxDate> latestDates = [];
      final List<String> antigenNames = [];
      final List<String> antigensNeedingDose = [];

      for (final antigen in antigens) {
        final List<VaxSeries> bestList = passBest[antigen.targetDisease]!;
        if (bestList.isEmpty) continue;
        antigenNames.add(antigen.targetDisease);
        if (bestList.any((VaxSeries s) => s.shouldRecieveAnotherDose)) {
          antigensNeedingDose.add(antigen.targetDisease);
        }
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

      ForecastTrace.current?.log(
        '9 vaccine group aggregation',
        groupName,
        'antigens=${antigens.map((VaxAntigen a) => a.targetDisease).toList()} '
            'statuses=$statuses earliest=$earliestDates '
            'recommended=$recommendedDates',
      );
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
        for (final best in passBest[antigen.targetDisease]!) {
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
          vgEarliest =
              earliestDates.reduce((VaxDate a, VaxDate b) => a < b ? a : b);
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
          vgEarliest =
              earliestDates.reduce((VaxDate a, VaxDate b) => a > b ? a : b);
        }
      }

      // FORECASTVG-2: recommended = max(min(all recommendeds), vgEarliest)
      VaxDate? vgRecommended;
      if (recommendedDates.isNotEmpty) {
        final minRecommended = recommendedDates.reduce((a, b) => a < b ? a : b);
        if (vgEarliest != null) {
          vgRecommended =
              vgEarliest > minRecommended ? vgEarliest : minRecommended;
        } else {
          vgRecommended = minRecommended;
        }
      }

      // FORECASTVG-3: past due = max(min(all past dues), vgEarliest)
      VaxDate? vgPastDue;
      if (pastDueDates.isNotEmpty) {
        final minPastDue = pastDueDates.reduce((a, b) => a < b ? a : b);
        if (vgEarliest != null) {
          vgPastDue = vgEarliest > minPastDue ? vgEarliest : minPastDue;
        } else {
          vgPastDue = minPastDue;
        }
      }

      // FORECASTVG-4: latest = min(all latest dates)
      VaxDate? vgLatest;
      if (latestDates.isNotEmpty) {
        vgLatest = latestDates.reduce((a, b) => a < b ? a : b);
      }

      // For multi-antigen groups, collect vaccine info from each antigen.
      // FORECASTDN-2: use min doseNum when administerFullVaccineGroup='Y',
      // max when 'N'.
      // When both risk and non-risk best series exist for an antigen, use
      // the union of unique valid doses across ALL best series + 1 so that
      // prior valid doses from the standard series are counted even when the
      // risk series can't see them (e.g., ART re-vaccination).
      var multiVaxInfo =
          (cvx: <String>[], desc: <String>[], doseNum: null as int?);
      final List<int> doseNums = [];
      for (final antigen in antigens) {
        final List<VaxSeries> allBest = bestByAntigen[antigen.targetDisease]!;
        final List<VaxSeries> bestList = passBest[antigen.targetDisease]!;
        if (bestList.isNotEmpty) {
          // Determine which series to use for vaccine info.
          // Prefer a Not Complete risk series; fall back to any Not Complete
          // series; last resort is bestList.first (may be Complete → null
          // doseNum, handled below).
          final riskBest = allBest
              .where((s) => s.series.seriesType == SeriesType.risk)
              .toList();
          final notCompleteRisk = riskBest
              .where((s) =>
                  s.seriesStatus != SeriesStatus.complete &&
                  s.seriesStatus != SeriesStatus.immune)
              .toList();
          final infoSeries = notCompleteRisk.isNotEmpty
              ? notCompleteRisk.first
              : bestList.firstWhere(
                  (s) =>
                      s.seriesStatus != SeriesStatus.complete &&
                      s.seriesStatus != SeriesStatus.immune,
                  orElse: () => bestList.first);
          final info = _extractForecastVaccineInfo(infoSeries);
          if (info.cvx.isNotEmpty && multiVaxInfo.cvx.isEmpty) {
            multiVaxInfo = info;
          }
          // When mixed risk + non-risk best series exist, count unique valid
          // doses across ALL best series so prior valid doses are reflected
          // regardless of which series evaluated them. Two specific cases:
          // 1. Risk series has no evaluated doses (ART re-vaccination: prior
          //    standard doses count toward the risk forecast).
          // 2. Risk series is Complete (e.g., 1-dose travel series finished;
          //    its valid doses should count toward the standard forecast).
          int? antigenDoseNum = info.doseNum;
          if (riskBest.isNotEmpty &&
              riskBest.length < allBest.length &&
              (riskBest.first.evaluatedDoses.isEmpty ||
                  riskBest.first.seriesStatus == SeriesStatus.complete ||
                  riskBest.first.seriesStatus == SeriesStatus.immune)) {
            final Set<String> uniqueValidDoseIds = {};
            for (final s in allBest) {
              for (final d in s.evaluatedDoses) {
                uniqueValidDoseIds.add(d.doseId);
              }
            }
            antigenDoseNum = uniqueValidDoseIds.length + 1;
          }
          if (antigenDoseNum != null) {
            doseNums.add(antigenDoseNum);
          }
        }
      }
      if (doseNums.isNotEmpty) {
        // Look up administerFullVaccineGroup flag
        final vgList = activeScheduleData.vaccineGroups?.vaccineGroup
            ?.where((g) => g.name == groupName);
        final vgDef =
            (vgList != null && vgList.isNotEmpty) ? vgList.first : null;
        final bool useMin =
            vgDef?.administerFullVaccineGroup?.toString() == 'Yes';
        final int aggregatedDoseNum = useMin
            ? doseNums.reduce((a, b) => a < b ? a : b)
            : doseNums.reduce((a, b) => a > b ? a : b);
        multiVaxInfo = (
          cvx: multiVaxInfo.cvx,
          desc: multiVaxInfo.desc,
          doseNum: aggregatedDoseNum
        );
      }

      (result[groupName] ??= <VaccineGroupForecast>[]).add(VaccineGroupForecast(
        vaccineGroupName: groupName,
        status: vgStatus,
        earliestDate: vgEarliest,
        recommendedDate: vgRecommended,
        pastDueDate: vgPastDue,
        latestDate: vgLatest,
        antigenNames: antigenNames,
        forecastCvxCodes: multiVaxInfo.cvx,
        forecastVaccineDescriptions: multiVaxInfo.desc,
        doseNumber: multiVaxInfo.doseNum,
        isRiskForecast: forRisk,
        antigensNeedingDose: antigensNeedingDose,
      ));
    }
  }

  return result;
}

Parameters forecastFromMap(Map<String, dynamic> parameters,
    {ForecastMode mode = ForecastMode.cdc}) {
  if (parameters['resourceType'] == 'Parameters') {
    final Parameters newParameters = Parameters.fromJson(parameters);
    return forecastFromParameters(newParameters, mode: mode);
  }
  return const Parameters();
}

ForecastResult evaluateForForecast(Parameters parameters,
    {ForecastMode mode = ForecastMode.cdc}) {
  setForecastMode(mode);
  final ProviderContainer container = ProviderContainer();

  /// Parse out and organize all of the information from input parameters
  final VaxPatient patient = container.read(
    patientForAssessmentProvider(parameters),
  );

  container.read(observationsProvider.notifier).setValue(patient.observations);

  /// Create an agMap that we can work from to evaluate past vaccines
  /// we pass in a list of all past vaccines, the patient's gender
  final Map<String, VaxAntigen> agMap = antigenMap(patient);

  /// Build shared series group completion map and set up per-series state
  final Map<String, Map<String, bool>> seriesGroupCompletion =
      <String, Map<String, bool>>{};
  final Map<String, Map<String, VaxDate>> seriesGroupCompletionDate =
      <String, Map<String, VaxDate>>{};
  agMap.forEach((String k, VaxAntigen v) {
    seriesGroupCompletion[k] = <String, bool>{};
    seriesGroupCompletionDate[k] = <String, VaxDate>{};
    v.groups.forEach((String key, VaxGroup group) {
      seriesGroupCompletion[k]![key] = false;
      for (final VaxSeries series in group.series) {
        series.allPatientDoses = patient.pastDoses;
        series.observations = patient.observations;
        series.seriesGroupKey = key;
        series.seriesGroupCompletion = seriesGroupCompletion;
        series.seriesGroupCompletionDate = seriesGroupCompletionDate;
      }
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

Parameters forecastFromParameters(Parameters parameters,
    {ForecastMode mode = ForecastMode.cdc}) {
  final result = evaluateForForecast(parameters, mode: mode);
  return buildImmdsResponse(result);
}
