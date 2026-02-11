import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/forecast/forecast.dart';

void main() {
  final lines = File('conditionTestCases.ndjson').readAsLinesSync();
  final targets = {
    '2016-UC-0057', '2016-UC-0068', '2016-UC-0072',
  };

  final targetAntigens = <String, Set<String>>{
    '2016-UC-0057': {'Hib'},
    '2016-UC-0068': {'Hib'},
    '2016-UC-0072': {'Hib'},
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

    print('=== Patient: $id (DOB: ${patient?.birthDate}) ===');

    final result = evaluateForForecast(parameters);

    print('Observations:');
    for (final obs in result.patient.observations.observation ?? []) {
      print('  ${obs.observationCode}: ${obs.observationTitle}');
    }

    final myAntigens = targetAntigens[id]!;
    for (final antigen in result.agMap.values) {
      if (myAntigens.isNotEmpty && !myAntigens.contains(antigen.targetDisease)) continue;

      print('\n--- Antigen: ${antigen.targetDisease} ---');
      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        print('\nGroup key="${groupEntry.key}":');

        // Show all series with equiv
        for (final s in group.series) {
          final esg = s.series.equivalentSeriesGroups;
          print('  Series: ${s.series.seriesName}'
              ' [${s.series.seriesType}]'
              ' status=${s.seriesStatus}'
              ' equiv=$esg'
              ' seriesGroup=${s.series.selectSeries?.seriesGroup}');
        }

        // Show prioritized
        if (group.prioritizedSeries.isNotEmpty) {
          final ps = group.prioritizedSeries.first;
          print('  PRIORITIZED: ${ps.series.seriesName}'
              ' [${ps.series.seriesType}]'
              ' status=${ps.seriesStatus}'
              ' equiv=${ps.series.equivalentSeriesGroups}');
          print('    earliest=${ps.candidateEarliestDate}'
              ' rec=${ps.adjustedRecommendedDate}'
              ' pastDue=${ps.adjustedPastDueDate}');
          for (final d in ps.doses) {
            print('    dose ${d.dateGiven}: CVX=${d.cvx}'
                ' status=${d.evalStatus} reason=${d.evalReason}');
          }
          // Show indications for risk series
          if (ps.series.seriesType == SeriesType.risk) {
            for (final ind in ps.series.indication ?? []) {
              print('    indication: ${ind.observationCode?.text}');
            }
          }
        } else {
          print('  PRIORITIZED: none');
        }

        print('  bestSeries: ${group.bestSeries?.series.seriesName ?? "NONE"}');
      }
    }

    // Show VG forecasts
    final vgKey = {
      '2016-UC-0057': 'Hib',
      '2016-UC-0068': 'Hib',
      '2016-UC-0072': 'Hib',
    }[id]!;
    final vg = result.vaccineGroupForecasts[vgKey];
    if (vg != null) {
      print('\nVG "$vgKey" -> ${vg.status}'
          ' earliest=${vg.earliestDate}'
          ' rec=${vg.recommendedDate}');
    } else {
      print('\nVG "$vgKey" -> MISSING');
    }

    print('\n========================================\n');
  }
}
