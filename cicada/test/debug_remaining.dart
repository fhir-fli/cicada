import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/forecast/forecast.dart';

void main() {
  final lines = File('conditionTestCases.ndjson').readAsLinesSync();
  final targets = {
    '2016-UC-0130', // DTaP - dates decades in past
    '2017-UC-0015', // Cholera - 16 years off
    '2016-UC-0198', // Meningococcal - 2 years off
    '2023-UC-0047', // RSV - 75 years in future
    '2023-UC-0048', // RSV - 75 years in future
    '2023-UC-0050', // RSV
    '2023-UC-0051', // RSV
    '2016-UC-0153', // Pneumococcal
    '2016-UC-0165', // Pneumococcal
  };

  final targetVG = <String, String>{
    '2016-UC-0130': 'DTaP/Tdap/Td',
    '2017-UC-0015': 'Cholera',
    '2016-UC-0198': 'Meningococcal',
    '2023-UC-0047': 'RSV',
    '2023-UC-0048': 'RSV',
    '2023-UC-0050': 'RSV',
    '2023-UC-0051': 'RSV',
    '2016-UC-0153': 'Pneumococcal',
    '2016-UC-0165': 'Pneumococcal',
  };

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;
    final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
    final paramList = decoded['parameter'] as List<dynamic>?;
    if (paramList == null) continue;

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

    final result = evaluateForForecast(parameters);

    print('=== Patient: $id (DOB: ${result.patient.birthdate}) ===');
    print('Observations (${result.patient.observations.observation?.length ?? 0}):');
    for (final obs in result.patient.observations.observation ?? []) {
      print('  Code=${obs.observationCode}: ${obs.observationTitle}');
      if (obs.period != null) {
        print('    Period: ${obs.period?.start} - ${obs.period?.end}');
      }
    }
    print('Doses (${result.patient.pastDoses.length}):');
    for (final d in result.patient.pastDoses) {
      print('  ${d.dateGiven}: CVX=${d.cvx}');
    }

    final vgName = targetVG[id]!;
    final vg = result.vaccineGroupForecasts[vgName];
    if (vg != null) {
      print('VG "$vgName": status=${vg.status}'
          ' earliest=${vg.earliestDate}'
          ' rec=${vg.recommendedDate}'
          ' pastDue=${vg.pastDueDate}');
    } else {
      print('VG "$vgName": MISSING');
      print('  Available: ${result.vaccineGroupForecasts.keys.toList()}');
    }

    // Show relevant antigen details
    for (final antigen in result.agMap.values) {
      if (antigen.vaccineGroupName != vgName) continue;
      print('\nAntigen: ${antigen.targetDisease}');
      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        print('  Group "${groupEntry.key}":');
        for (final s in group.series) {
          if (s.seriesStatus == SeriesStatus.agedOut &&
              s.series.seriesType == SeriesType.standard) {
            print('    ${s.series.seriesName} [${s.series.seriesType}] = ${s.seriesStatus} (skipped)');
            continue;
          }
          print('    ${s.series.seriesName} [${s.series.seriesType}]'
              ' status=${s.seriesStatus}'
              ' targetDose=${s.targetDose}/${s.series.seriesDose?.length ?? 0}'
              ' earliest=${s.candidateEarliestDate}'
              ' rec=${s.adjustedRecommendedDate}'
              ' pastDue=${s.adjustedPastDueDate}');
          if (s.evaluatedDoses.isNotEmpty) {
            for (final d in s.evaluatedDoses) {
              print('      dose ${d.dateGiven} CVX=${d.cvx} status=${d.evalStatus}');
            }
          }
          // Check intervals for fromRelevantObs
          if (s.targetDose < (s.series.seriesDose?.length ?? 0)) {
            final sd = s.series.seriesDose![s.targetDose];
            for (final interval in sd.preferableInterval ?? <Interval>[]) {
              if (interval.fromRelevantObs != null) {
                print('      ** fromRelevantObs: code=${interval.fromRelevantObs!.code}'
                    ' text=${interval.fromRelevantObs!.text}');
              }
            }
          }
        }
        print('    bestSeries: ${group.bestSeries?.series.seriesName ?? "NONE"}');
      }
    }
    print('\n');
  }
}
