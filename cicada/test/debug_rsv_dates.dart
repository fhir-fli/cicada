import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/forecast/forecast.dart';

void main() {
  final lines = File('conditionTestCases.ndjson').readAsLinesSync();
  final targets = {
    '2023-UC-0047',
    '2023-UC-0048',
    '2023-UC-0050',
    '2023-UC-0051',
  };

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;
    final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
    final paramList = decoded['parameter'] as List<dynamic>?;
    if (paramList == null) continue;

    // Add "status": "completed" to Immunizations missing it
    for (final p in paramList) {
      final param = p as Map<String, dynamic>;
      if (param.containsKey('resource')) {
        final resource = param['resource'] as Map<String, dynamic>;
        if (resource['resourceType'] == 'Immunization' &&
            !resource.containsKey('status')) {
          resource['status'] = 'completed';
        }
      }
    }

    final parameters = Parameters.fromJson(decoded);
    final Patient? patient = parameters.parameter
        ?.firstWhereOrNull(
            (ParametersParameter e) => e.resource is Patient)
        ?.resource as Patient?;
    final id = patient?.id?.toString() ?? '';
    if (!targets.contains(id)) continue;

    print('========================================');
    print('Patient: $id');
    print('DOB: ${patient?.birthDate}');

    final result = evaluateForForecast(parameters);

    // 1. DOB and observations
    print('\n--- Observations ---');
    for (final obs in result.patient.observations.observation ?? []) {
      print('  ${obs.observationCode}: ${obs.observationTitle}');
    }

    // 2. Administered doses
    print('\n--- Administered Doses ---');
    for (final dose in result.patient.pastDoses) {
      print('  ${dose.dateGiven} CVX=${dose.cvx} MVX=${dose.mvx}'
          ' antigens=${dose.antigens}');
    }

    // Print all agMap keys for the first patient to find the RSV key
    if (id == targets.first) {
      print('\n--- All agMap keys ---');
      for (final key in result.agMap.keys) {
        print('  "$key" (vaccineGroupName=${result.agMap[key]!.vaccineGroupName})');
      }
    }

    // 3. RSV antigen detail - try common key variants
    final rsvKeys = result.agMap.keys
        .where((k) => k.toLowerCase().contains('rsv'))
        .toList();
    if (rsvKeys.isEmpty) {
      print('\n*** No RSV antigen found in agMap! ***');
    }
    for (final rsvKey in rsvKeys) {
      final antigen = result.agMap[rsvKey]!;
      print('\n--- Antigen: ${antigen.targetDisease}'
          ' (VG=${antigen.vaccineGroupName}) ---');
      print('contraindication: ${antigen.contraindication}');
      print('evidenceOfImmunity: ${antigen.evidenceOfImmunity}');

      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        print('\n  Group key="${groupEntry.key}"'
            ' vaccineGroup=${group.vaccineGroup}'
            ' vaccineGroupName=${group.vaccineGroupName}');
        print('  Series count: ${group.series.length}');

        for (final s in group.series) {
          print('\n    Series: ${s.series.seriesName}');
          print('      seriesType: ${s.series.seriesType}');
          print('      equivalentSeriesGroups: ${s.series.equivalentSeriesGroups}');
          print('      seriesStatus: ${s.seriesStatus}');
          print('      targetDose: ${s.targetDose}/${s.series.seriesDose?.length ?? 0}');
          print('      evaluatedDoses: ${s.evaluatedDoses.length}');
          print('      doses: ${s.doses.length}');
          print('      candidateEarliestDate: ${s.candidateEarliestDate}');
          print('      adjustedRecommendedDate: ${s.adjustedRecommendedDate}');
          print('      adjustedPastDueDate: ${s.adjustedPastDueDate}');
          print('      latestDate: ${s.latestDate}');
          print('      score: ${s.score}');
          // Show indication if risk
          if (s.series.seriesType == SeriesType.risk &&
              s.series.indication != null) {
            for (final ind in s.series.indication!) {
              print('      indication: obsCode=${ind.observationCode?.text}'
                  ' desc=${ind.description}');
            }
          }
          // Show evaluated dose statuses
          for (final d in s.doses) {
            print('      dose: ${d.dateGiven} CVX=${d.cvx}'
                ' status=${d.evalStatus} reason=${d.evalReason}'
                ' targetDoseSatisfied=${d.targetDoseSatisfied}');
          }
        }

        // Prioritized series
        print('\n  Prioritized series (${group.prioritizedSeries.length}):');
        for (final ps in group.prioritizedSeries) {
          print('    ${ps.series.seriesName}'
              ' [type=${ps.series.seriesType}]'
              ' status=${ps.seriesStatus}'
              ' candidateEarliest=${ps.candidateEarliestDate}'
              ' adjustedRec=${ps.adjustedRecommendedDate}'
              ' adjustedPastDue=${ps.adjustedPastDueDate}');
        }
        if (group.bestSeries != null) {
          print('  bestSeries: ${group.bestSeries!.series.seriesName}'
              ' [${group.bestSeries!.series.seriesType}]'
              ' -> ${group.bestSeries!.seriesStatus}');
        } else {
          print('  bestSeries: NONE');
        }
      }
    }

    // 5. VG forecast for RSV
    print('\n--- Vaccine Group Forecasts ---');
    for (final vgEntry in result.vaccineGroupForecasts.entries) {
      final vg = vgEntry.value;
      print('  ${vgEntry.key}:'
          ' status=${vg.status}'
          ' earliest=${vg.earliestDate}'
          ' recommended=${vg.recommendedDate}'
          ' pastDue=${vg.pastDueDate}'
          ' latest=${vg.latestDate}'
          ' antigenNames=${vg.antigenNames}');
    }

    print('\n========================================\n');
  }
}
