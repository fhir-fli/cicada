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

/// Get the best series for an antigen (same logic as VaxGroup.forecast uses)
VaxSeries? _getBestSeriesForAntigen(VaxAntigen antigen) {
  VaxSeries? completeSeries;
  VaxSeries? activeSeries;
  VaxSeries? agedOutSeries;
  VaxSeries? fallback;
  for (final group in antigen.groups.values) {
    for (final ps in group.prioritizedSeries) {
      if (ps.seriesStatus == SeriesStatus.complete ||
          ps.seriesStatus == SeriesStatus.immune) {
        completeSeries ??= ps;
      } else if (ps.seriesStatus == SeriesStatus.agedOut) {
        agedOutSeries ??= ps;
      } else {
        activeSeries ??= ps;
      }
    }
    if (group.bestSeries != null) {
      if (group.bestSeries!.seriesStatus == SeriesStatus.complete ||
          group.bestSeries!.seriesStatus == SeriesStatus.immune) {
        completeSeries ??= group.bestSeries;
      } else if (group.bestSeries!.seriesStatus == SeriesStatus.agedOut) {
        agedOutSeries ??= group.bestSeries;
      } else {
        activeSeries ??= group.bestSeries;
      }
    }
    if (group.series.isNotEmpty) {
      fallback ??= group.series.first;
    }
  }
  return completeSeries ?? activeSeries ?? agedOutSeries ?? fallback;
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
      // Single-antigen group: pass through best series data
      final antigen = antigens.first;
      final best = _getBestSeriesForAntigen(antigen);
      if (best != null) {
        result[groupName] = VaccineGroupForecast(
          vaccineGroupName: groupName,
          status: best.seriesStatus,
          earliestDate: best.candidateEarliestDate,
          recommendedDate: best.adjustedRecommendedDate,
          pastDueDate: best.adjustedPastDueDate,
          latestDate: best.latestDate,
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

    for (final antigen in antigens) {
      final best = _getBestSeriesForAntigen(antigen);
      if (best == null) continue;
      antigenNames.add(antigen.targetDisease);
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
      final VaxSeries? best = _getBestSeriesForAntigen(antigen);
      if (best != null && _isPriorityForecast(best)) {
        anyPriority = true;
        break;
      }
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
