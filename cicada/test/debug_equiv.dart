import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/forecast/forecast.dart';

void main() {
  final lines = File('conditionTestCases.ndjson').readAsLinesSync();
  // Compare Hib 0061 (expects Complete) vs Hib 0055 (expects NC)
  // And IPOL 0133 (expects Complete) vs IPOL 0132 (expects NC from regression)
  final targets = {
    '2016-UC-0061', '2016-UC-0055', // Hib
    '2016-UC-0133', '2016-UC-0132', // IPOL
    '2016-UC-0048', // HepB (expects NC from regression)
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

    print('Patient: $id (DOB: ${patient?.birthDate})');

    final result = evaluateForForecast(parameters);

    // Show observations
    print('Observations:');
    for (final obs in result.patient.observations.observation ?? []) {
      print('  ${obs.observationCode}: ${obs.observationTitle}');
    }

    // Show VG forecast results
    print('\nVG Forecasts:');
    for (final vgEntry in result.vaccineGroupForecasts.entries) {
      print('  ${vgEntry.key} -> ${vgEntry.value.status}'
          ' earliest=${vgEntry.value.earliestDate}'
          ' rec=${vgEntry.value.recommendedDate}');
    }

    // Map patient → target antigens
    final targetVGs = <String, Set<String>>{
      '2016-UC-0061': {'Haemophilus Influenzae Type b'},
      '2016-UC-0055': {'Haemophilus Influenzae Type b'},
      '2016-UC-0133': {'Polio'},
      '2016-UC-0132': {'Polio'},
      '2016-UC-0048': {'Hepatitis B'},
    };
    final myVGs = targetVGs[id] ?? {};
    for (final antigen in result.agMap.values) {
      if (!myVGs.contains(antigen.targetDisease)) continue;
      print('\n--- Antigen: ${antigen.targetDisease} (VG=${antigen.vaccineGroupName}) ---');
      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        print('\nGroup key=${groupEntry.key}:');
        print('  prioritizedSeries (${group.prioritizedSeries.length}):');
        for (final ps in group.prioritizedSeries) {
          final esg = ps.series.equivalentSeriesGroups;
          print('    ${ps.series.seriesName} [type=${ps.series.seriesType}]'
              ' status=${ps.seriesStatus}'
              ' equiv=$esg');
          if (ps.series.seriesType == SeriesType.risk) {
            for (final ind in ps.series.indication ?? []) {
              print('    indication: ${ind.observationCode?.text}');
            }
          }
        }
        print('  bestSeries: ${group.bestSeries?.series.seriesName ?? "NONE"}'
            ' [${group.bestSeries?.series.seriesType ?? "-"}]'
            ' -> ${group.bestSeries?.seriesStatus ?? "-"}');
        print('  All series (${group.series.length}):');
        for (final s in group.series) {
          print('    ${s.series.seriesName} [${s.series.seriesType}]'
              ' -> ${s.seriesStatus}'
              ' equiv=${s.series.equivalentSeriesGroups}');
        }
      }
    }
    print('\n========================================\n');
  }
}
