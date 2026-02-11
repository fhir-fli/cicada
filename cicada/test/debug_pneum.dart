import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/forecast/forecast.dart';

void main() {
  final lines = File('conditionTestCases.ndjson').readAsLinesSync();
  // Pneumococcal date mismatches: exactly 1 year off
  final targets = {'2016-UC-0165', '2016-UC-0178'};

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

    print('Observations:');
    for (final obs in result.patient.observations.observation ?? []) {
      print('  ${obs.observationCode}: ${obs.observationTitle}');
    }

    print('\nAll administered doses:');
    for (final dose in result.patient.pastDoses) {
      print('  ${dose.dateGiven}: CVX=${dose.cvx} MVX=${dose.mvx}');
    }

    // Show VG Pneumococcal forecast
    print('\nVG Forecasts:');
    final pneuVG = result.vaccineGroupForecasts['Pneumococcal'];
    if (pneuVG != null) {
      print('  Pneumococcal -> ${pneuVG.status}'
          ' earliest=${pneuVG.earliestDate}'
          ' rec=${pneuVG.recommendedDate}'
          ' pastDue=${pneuVG.pastDueDate}');
    }

    for (final antigen in result.agMap.values) {
      if (antigen.targetDisease != 'Pneumococcal') continue;
      print('\n--- Antigen: Pneumococcal ---');
      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        print('\nGroup key=${groupEntry.key}:');
        print('  prioritizedSeries (${group.prioritizedSeries.length}):');
        for (final ps in group.prioritizedSeries) {
          print('    ${ps.series.seriesName} [${ps.series.seriesType}]'
              ' status=${ps.seriesStatus}'
              ' equiv=${ps.series.equivalentSeriesGroups}'
              ' targetDose=${ps.targetDose}/${ps.series.seriesDose?.length ?? 0}'
              ' evalDoses=${ps.evaluatedDoses.length}');
          print('    earliest=${ps.candidateEarliestDate}'
              ' rec=${ps.adjustedRecommendedDate}'
              ' pastDue=${ps.adjustedPastDueDate}');
          for (final d in ps.doses) {
            print('      ${d.dateGiven}: CVX=${d.cvx}'
                ' status=${d.evalStatus} reason=${d.evalReason}');
          }
          if (ps.series.seriesType == SeriesType.risk) {
            for (final ind in ps.series.indication ?? []) {
              print('    indication: ${ind.observationCode?.text}');
            }
          }
        }
        print('  bestSeries: ${group.bestSeries?.series.seriesName ?? "NONE"}');
        print('  All series (${group.series.length}):');
        for (final s in group.series) {
          print('    ${s.series.seriesName} [${s.series.seriesType}]'
              ' -> ${s.seriesStatus}'
              ' equiv=${s.series.equivalentSeriesGroups}'
              ' earliest=${s.candidateEarliestDate}'
              ' rec=${s.adjustedRecommendedDate}');
        }
      }
    }
    print('\n========================================\n');
  }
}
