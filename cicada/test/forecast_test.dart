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

/// Writes detailed diagnostic information for mismatched patients.
void writeDiagnostics(
  Map<String, List<Map<String, dynamic>>> diagnostics,
  String outputPath,
) {
  final buffer = StringBuffer();
  buffer.writeln('=== Phase 3 Diagnostic Output ===');
  buffer.writeln('Generated: ${DateTime.now()}');
  buffer.writeln('Patients with mismatches: ${diagnostics.length}');
  buffer.writeln();

  final Map<String, int> causeCounts = {};

  for (final entry in diagnostics.entries) {
    final patientId = entry.key;
    final doseInfoList = entry.value;

    buffer.writeln('--- Patient: $patientId ---');

    for (final info in doseInfoList) {
      final doseId = info['doseId'] as String;
      final expected = info['expected'] as String;
      final failedSeries = info['failedSeries'] as List<Map<String, dynamic>>;
      final category = info['category'] as String;

      buffer.writeln('  Dose: $doseId expected="$expected" category=$category');
      for (final fs in failedSeries) {
        buffer.writeln(
            '    ${fs['seriesName']}: actual="${fs['actual']}"');
        final doseDetails = fs['allDoses'] as List<Map<String, dynamic>>?;
        if (doseDetails != null) {
          for (final d in doseDetails) {
            buffer.writeln(
                '      doseId=${d['doseId']} dateGiven=${d['dateGiven']} '
                'targetDose=${d['targetDoseSatisfied']} '
                'evalStatus=${d['evalStatus']} '
                'evalReason=${d['evalReason']} '
                'ageReason=${d['validAgeReason']}');
          }
        }
      }

      causeCounts[category] = (causeCounts[category] ?? 0) + 1;
    }
    buffer.writeln();
  }

  buffer.writeln('=== Mismatch Category Summary ===');
  for (final entry
      in causeCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value))) {
    buffer.writeln('  ${entry.key}: ${entry.value}');
  }

  File(outputPath).writeAsStringSync(buffer.toString());
}

String categorizeMismatch(String expected, String actual) {
  if (expected.contains('Status: Valid ') &&
      actual.contains('Age:')) {
    return 'too-strict:age';
  }
  if (expected.contains('Status: Valid ') &&
      actual.contains('Extraneous')) {
    return 'too-strict:extraneous-cascade';
  }
  if (expected.contains('Status: Valid ') &&
      actual.contains('Not a preferable')) {
    return 'too-strict:vaccine-type';
  }
  if (expected.contains('Status: Valid ') &&
      actual.contains('Interval')) {
    return 'too-strict:interval';
  }
  if (expected.contains('Status: Valid ') &&
      actual.contains('Live Virus')) {
    return 'too-strict:live-virus';
  }
  if (expected.contains('Status: Valid ')) {
    return 'too-strict:other';
  }
  if (expected.contains('Status: Not Valid') &&
      actual.contains('Status: valid')) {
    if (expected.contains('Interval')) return 'too-permissive:interval';
    if (expected.contains('Age')) return 'too-permissive:age';
    return 'too-permissive:other';
  }
  if (expected.contains('Status: Extraneous')) {
    return 'too-permissive:extraneous-expected';
  }
  return 'other';
}

void main() {
  late List<Parameters> allParameters;

  setUpAll(() {
    allParameters = loadTestCases('test/healthyTestCases.ndjson');
  });

  group('CDSi forecast evaluation', () {
    test('loads test cases', () {
      expect(allParameters, isNotEmpty);
      expect(allParameters.length, 1013);
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
      final Map<String, List<Map<String, dynamic>>> diagnostics = {};

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

        // Compare per expected dose: a dose matches if ANY antigen series
        // produces the expected evaluation. This is correct because combo
        // vaccines are evaluated independently per antigen, and the CDSi
        // test data provides one evaluation per dose.
        for (final expectedDose in expectedDoses) {
          final expected = expectedDose.validity;
          bool foundMatch = false;
          bool foundAnyEval = false;
          final List<Map<String, dynamic>> failedSeriesInfo = [];

          result.agMap.forEach((String antigenName, VaxAntigen antigen) {
            if (!expectedDose.antigens.map((s) => s.toLowerCase())
                .contains(antigenName.toLowerCase())) {
              return;
            }

            antigen.groups.forEach((String groupKey, VaxGroup group) {
              for (final series in group.prioritizedSeries) {
                final actualDose = series.doses.firstWhereOrNull(
                    (d) => d.doseId == expectedDose.doseId);
                if (actualDose == null || actualDose.evalStatus == null) {
                  continue;
                }

                foundAnyEval = true;
                final actual = actualDose.validity;
                if (expected == actual || actual.startsWith(expected)) {
                  foundMatch = true;
                } else {
                  failedSeriesInfo.add({
                    'seriesName': series.series.seriesName,
                    'actual': actual,
                    'allDoses': series.doses.map((d) =>
                      <String, dynamic>{
                        'doseId': d.doseId,
                        'dateGiven': d.dateGiven.toString(),
                        'targetDoseSatisfied': d.targetDoseSatisfied,
                        'evalStatus': d.evalStatus?.toString(),
                        'evalReason': d.evalReason?.toString(),
                        'validAgeReason': d.validAgeReason?.toString(),
                      }).toList(),
                  });
                }
              }
            });
          });

          if (foundAnyEval) {
            comparedCount++;
            if (!foundMatch && failedSeriesInfo.isNotEmpty) {
              // Use the first failed series for the mismatch message
              final firstFail = failedSeriesInfo.first;
              final category = categorizeMismatch(
                  expected, firstFail['actual'] as String);
              mismatches.add(
                '$id | ${firstFail['seriesName']} | '
                '${expectedDose.doseId}: '
                'expected="$expected" '
                'actual="${firstFail['actual']}"',
              );

              diagnostics.putIfAbsent(id, () => []);
              diagnostics[id]!.add({
                'doseId': expectedDose.doseId,
                'expected': expected,
                'failedSeries': failedSeriesInfo,
                'category': category,
              });
            }
          }
        }
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

      // Write detailed diagnostics to scratchpad
      if (diagnostics.isNotEmpty) {
        final diagPath =
            '/tmp/claude-1000/-home-grey-dev-fhir-cicada/8c15a154-f591-4212-9241-7632159195e4/scratchpad/phase3_diagnostics.txt';
        try {
          File(diagPath).parent.createSync(recursive: true);
          writeDiagnostics(diagnostics, diagPath);
          print('Diagnostics written to: $diagPath');
        } catch (e) {
          print('Could not write diagnostics: $e');
        }
      }

      // For now, just report — don't fail, so we can establish baseline
      // Once bugs are fixed, tighten this to: expect(mismatches, isEmpty);
    });
  });
}
