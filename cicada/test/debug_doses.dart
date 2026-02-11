import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/forecast/forecast.dart';

void main() {
  final lines = File('conditionTestCases.ndjson').readAsLinesSync();
  final targets = {'2016-UC-0132', '2016-UC-0133'};

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

    for (final antigen in result.agMap.values) {
      if (antigen.targetDisease != 'Polio') continue;
      print('\n--- Antigen: Polio ---');
      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        print('\nGroup key=${groupEntry.key}:');
        for (final s in group.series) {
          print('  ${s.series.seriesName} [${s.series.seriesType}]'
              ' -> ${s.seriesStatus}'
              ' targetDose=${s.targetDose}/${s.series.seriesDose?.length ?? 0}');
          for (final d in s.doses) {
            print('    ${d.dateGiven}: CVX=${d.cvx}'
                ' status=${d.evalStatus} reason=${d.evalReason}');
          }
        }
      }
    }
    print('\n========================================\n');
  }
}
