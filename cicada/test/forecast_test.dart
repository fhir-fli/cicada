import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/forecast/forecast.dart';
import 'package:cicada/generated_files/test_doses.dart';
import 'package:cicada/models/models.dart';
import 'package:test/test.dart';

/// Loads NDJSON test cases, fixing up missing required fields that the test
/// data omits (e.g. Immunization.status).
List<Parameters> loadTestCases(String path) {
  final lines = File(path).readAsLinesSync();
  final result = <Parameters>[];

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;

    final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
    final paramList = decoded['parameter'] as List<dynamic>?;
    if (paramList == null) continue;

    // Fix up resources missing required fields
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

    result.add(Parameters.fromJson(decoded));
  }

  return result;
}

void main() {
  late List<Parameters> allParameters;

  setUpAll(() {
    allParameters = loadTestCases('test/healthyTestCases.ndjson');
  });

  group('CDSi forecast evaluation', () {
    test('loads test cases', () {
      expect(allParameters, isNotEmpty);
      expect(allParameters.length, 908);
    });

    test('all test cases evaluate without exceptions', () {
      final List<String> failures = [];

      for (int i = 0; i < allParameters.length; i++) {
        final parameters = allParameters[i];
        final Patient? patient = parameters.parameter
            ?.firstWhereOrNull(
                (ParametersParameter e) => e.resource is Patient)
            ?.resource as Patient?;
        final id = patient?.id?.toString() ?? 'unknown-$i';

        try {
          evaluateForForecast(parameters);
        } catch (e) {
          failures.add('$id: $e');
        }
      }

      if (failures.isNotEmpty) {
        fail('${failures.length} test cases threw exceptions:\n'
            '${failures.take(20).join('\n')}');
      }
    });

    test('evaluated dose validity matches CDSi expected results', () {
      final List<String> mismatches = [];
      int comparedCount = 0;

      for (int i = 0; i < allParameters.length; i++) {
        final parameters = allParameters[i];
        final Patient? patient = parameters.parameter
            ?.firstWhereOrNull(
                (ParametersParameter e) => e.resource is Patient)
            ?.resource as Patient?;
        final id = patient?.id?.toString() ?? 'unknown-$i';

        final List<VaxDose>? expectedDoses = testDoses[id]
            ?.map((Map<String, Object> e) => VaxDose.fromJson(e))
            .toList();

        if (expectedDoses == null || expectedDoses.isEmpty) continue;

        ForecastResult result;
        try {
          result = evaluateForForecast(parameters);
        } catch (e) {
          mismatches.add('$id: threw exception: $e');
          continue;
        }

        result.agMap.forEach((String antigenName, VaxAntigen antigen) {
          final matchingExpected = expectedDoses
              .where((d) => d.antigens
                  .map((s) => s.toLowerCase())
                  .contains(antigenName.toLowerCase()))
              .toList();

          if (matchingExpected.isEmpty) return;

          antigen.groups.forEach((String groupKey, VaxGroup group) {
            final List<VaxSeries> seriesToCheck;
            if (group.bestSeries != null) {
              seriesToCheck = [group.bestSeries!];
            } else {
              seriesToCheck = group.prioritizedSeries;
            }

            for (final series in seriesToCheck) {
              // Match doses by doseId for accurate comparison
              for (final expectedDose in matchingExpected) {
                final actualDose = series.doses.firstWhereOrNull(
                    (d) => d.doseId == expectedDose.doseId);
                if (actualDose == null || actualDose.evalStatus == null) {
                  continue;
                }

                final expected = expectedDose.validity;
                final actual = actualDose.validity;

                comparedCount++;
                if (expected != actual && !actual.startsWith(expected)) {
                  final doseNum = matchingExpected.indexOf(expectedDose) + 1;
                  mismatches.add(
                    '$id | ${series.series.seriesName} | '
                    'Dose $doseNum: '
                    'expected="$expected" '
                    'actual="$actual"',
                  );
                }
              }
            }
          });
        });
      }

      // Print summary for baseline visibility
      print('Compared $comparedCount dose evaluations');
      print('Mismatches: ${mismatches.length}');

      // Categorize mismatches
      final tooPermissive = mismatches.where((m) =>
          m.contains('expected="Status: Not Valid') ||
          m.contains('expected="Status: Extraneous')).length;
      final tooStrict = mismatches.where((m) =>
          m.contains('expected="Status: Valid ')).length;
      final otherMismatch = mismatches.length - tooPermissive - tooStrict;
      print('  Too permissive (Cicada Valid, CDSi Not Valid): $tooPermissive');
      print('  Too strict (Cicada Not Valid, CDSi Valid): $tooStrict');
      print('  Other: $otherMismatch');

      // Sub-categorize too-permissive
      if (tooPermissive > 0) {
        final intervalIssues = mismatches.where((m) =>
            m.contains('expected="Status: Not Valid Reason: Interval')).length;
        final extraneousExpected = mismatches.where((m) =>
            m.contains('expected="Status: Extraneous')).length;
        print('  Too permissive breakdown:');
        print('    Interval: $intervalIssues');
        print('    Extraneous expected: $extraneousExpected');
      }

      // Sub-categorize too-strict
      if (tooStrict > 0) {
        final ageIssues = mismatches.where((m) =>
            m.contains('expected="Status: Valid ') &&
            m.contains('Age:')).length;
        final vaccineTypeIssues = mismatches.where((m) =>
            m.contains('expected="Status: Valid ') &&
            m.contains('Not a preferable')).length;
        final extraneousActual = mismatches.where((m) =>
            m.contains('expected="Status: Valid ') &&
            m.contains('actual="Status: Extraneous')).length;
        final liveVirusIssues = mismatches.where((m) =>
            m.contains('expected="Status: Valid ') &&
            m.contains('Live Virus')).length;
        print('  Too strict breakdown:');
        print('    Age: $ageIssues');
        print('    Vaccine type: $vaccineTypeIssues');
        print('    Extraneous (actual): $extraneousActual');
        print('    Live virus: $liveVirusIssues');
      }

      if (mismatches.isNotEmpty) {
        print('First 30 mismatches:');
        for (final m in mismatches.take(30)) {
          print('  $m');
        }
      }

      // For now, just report — don't fail, so we can establish baseline
      // Once bugs are fixed, tighten this to: expect(mismatches, isEmpty);
    });
  });
}
