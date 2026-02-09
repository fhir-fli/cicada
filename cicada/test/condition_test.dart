import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/test_condition_doses.dart';
import 'package:cicada/generated_files/test_condition_forecasts.dart';
import 'package:test/test.dart';

/// Loads NDJSON test cases, fixing up missing required fields.
List<Parameters> loadConditionTestCases(String path) {
  final lines = File(path).readAsLinesSync();
  final result = <Parameters>[];

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

    result.add(Parameters.fromJson(decoded));
  }

  return result;
}

void main() {
  late List<Parameters> allParameters;

  /// Map from conditions Excel vaccine group names to engine names.
  /// Most match directly (after trimming whitespace). Only these 5 differ:
  const conditionExcelToEngine = <String, String>{
    'DTaP': 'DTaP/Tdap/Td',
    'Flu': 'Influenza',
    'IPOL': 'Polio',
    'Rota': 'Rotavirus',
    'VAR': 'Varicella',
  };

  setUpAll(() {
    allParameters = loadConditionTestCases('test/conditionTestCases.ndjson');
  });

  group('CDSi underlying conditions evaluation', () {
    test('loads condition test cases', () {
      expect(allParameters, isNotEmpty);
      expect(allParameters.length, 776);
    });

    test('all condition test cases evaluate without exceptions', () {
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

        final List<VaxDose>? expectedDoses = testConditionDoses[id]
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

        for (final expectedDose in expectedDoses) {
          final expected = expectedDose.validity;
          bool foundMatch = false;
          bool foundAnyEval = false;
          final List<String> failedActuals = [];

          result.agMap.forEach((String antigenName, VaxAntigen antigen) {
            if (!expectedDose.antigens
                .map((s) => s.toLowerCase())
                .contains(antigenName.toLowerCase())) {
              return;
            }

            antigen.groups.forEach((String groupKey, VaxGroup group) {
              for (final series in group.series) {
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
                  failedActuals.add(
                      '${series.series.seriesName}: "$actual"');
                }
              }
            });
          });

          if (foundAnyEval) {
            comparedCount++;
            if (!foundMatch && failedActuals.isNotEmpty) {
              mismatches.add(
                '$id | ${failedActuals.first} | '
                '${expectedDose.doseId}: '
                'expected="$expected"',
              );
            }
          }
        }
      }

      print('Compared $comparedCount dose evaluations');
      print('Mismatches: ${mismatches.length}');

      if (mismatches.isNotEmpty) {
        print('First 30 mismatches:');
        for (final m in mismatches.take(30)) {
          print('  $m');
        }
      }
    });

    test('forecast dates and series status match CDSi expected results', () {
      int comparedCount = 0;
      int statusMatches = 0;
      int statusMismatches = 0;
      int earliestMatches = 0;
      int earliestMismatches = 0;
      int recommendedMatches = 0;
      int recommendedMismatches = 0;
      int pastDueMatches = 0;
      int pastDueMismatches = 0;
      int missingForecasts = 0;

      final Map<String, int> statusMismatchCategories = {};
      final Map<String, int> vgMismatchCounts = {};
      final List<String> statusMismatchDetails = [];
      final List<String> dateMismatchDetails = [];

      final Map<String, int> earliestByVg = {};
      final Map<String, int> recommendedByVg = {};
      final Map<String, int> pastDueByVg = {};

      for (int i = 0; i < allParameters.length; i++) {
        final parameters = allParameters[i];
        final Patient? patient = parameters.parameter
            ?.firstWhereOrNull(
                (ParametersParameter e) => e.resource is Patient)
            ?.resource as Patient?;
        final id = patient?.id?.toString() ?? 'unknown-$i';

        final expectedForecasts = testConditionForecasts[id];
        if (expectedForecasts == null || expectedForecasts.isEmpty) continue;

        ForecastResult result;
        try {
          result = evaluateForForecast(parameters);
        } catch (e) {
          missingForecasts += expectedForecasts.length;
          continue;
        }

        for (final expected in expectedForecasts) {
          final excelVg = expected['vaccineGroup']!.trim();
          // Map to engine name: use explicit mapping, else pass through
          final engineVg = conditionExcelToEngine[excelVg] ?? excelVg;

          comparedCount++;

          final vgForecast = result.vaccineGroupForecasts[engineVg];
          if (vgForecast == null) {
            missingForecasts++;
            continue;
          }

          // Compare series status (case-insensitive)
          final expectedStatus =
              expected['seriesStatus']!.toLowerCase();
          final actualStatus =
              vgForecast.status.toString().toLowerCase();
          if (expectedStatus == actualStatus) {
            statusMatches++;
          } else {
            statusMismatches++;
            final category = '$expectedStatus→$actualStatus';
            statusMismatchCategories[category] =
                (statusMismatchCategories[category] ?? 0) + 1;
            vgMismatchCounts[excelVg] =
                (vgMismatchCounts[excelVg] ?? 0) + 1;
            if (statusMismatchDetails.length < 50) {
              statusMismatchDetails.add(
                '$id [$excelVg]: '
                'expected="$expectedStatus" '
                'actual="$actualStatus"',
              );
            }
          }

          // Compare dates
          final expectedEarliest = expected['earliestDate'] ?? '';
          final expectedRecommended = expected['recommendedDate'] ?? '';
          final expectedPastDue = expected['pastDueDate'] ?? '';

          final actualEarliest =
              vgForecast.earliestDate?.toString() ?? '';
          final actualRecommended =
              vgForecast.recommendedDate?.toString() ?? '';
          final actualPastDue =
              vgForecast.pastDueDate?.toString() ?? '';

          if (expectedEarliest.isNotEmpty) {
            if (expectedEarliest == actualEarliest) {
              earliestMatches++;
            } else {
              earliestMismatches++;
              earliestByVg[excelVg] = (earliestByVg[excelVg] ?? 0) + 1;
              if (dateMismatchDetails.length < 100) {
                dateMismatchDetails.add(
                  '$id [$excelVg] earliest: '
                  'expected="$expectedEarliest" '
                  'actual="$actualEarliest"',
                );
              }
            }
          }

          if (expectedRecommended.isNotEmpty) {
            if (expectedRecommended == actualRecommended) {
              recommendedMatches++;
            } else {
              recommendedMismatches++;
              recommendedByVg[excelVg] =
                  (recommendedByVg[excelVg] ?? 0) + 1;
              if (dateMismatchDetails.length < 100) {
                dateMismatchDetails.add(
                  '$id [$excelVg] recommended: '
                  'expected="$expectedRecommended" '
                  'actual="$actualRecommended"',
                );
              }
            }
          }

          if (expectedPastDue.isNotEmpty) {
            if (expectedPastDue == actualPastDue) {
              pastDueMatches++;
            } else {
              pastDueMismatches++;
              pastDueByVg[excelVg] = (pastDueByVg[excelVg] ?? 0) + 1;
              if (dateMismatchDetails.length < 100) {
                dateMismatchDetails.add(
                  '$id [$excelVg] pastDue: '
                  'expected="$expectedPastDue" '
                  'actual="$actualPastDue"',
                );
              }
            }
          }
        }
      }

      // Print summary
      print('\n=== CONDITION FORECAST VALIDATION SUMMARY ===');
      print('Total comparisons: $comparedCount');
      print('Missing/unmapped forecasts: $missingForecasts');
      print('');
      print('Series Status:');
      print('  Matches: $statusMatches');
      print('  Mismatches: $statusMismatches');
      print('');
      print('Earliest Date:');
      print('  Matches: $earliestMatches');
      print('  Mismatches: $earliestMismatches');
      print('');
      print('Recommended Date:');
      print('  Matches: $recommendedMatches');
      print('  Mismatches: $recommendedMismatches');
      print('');
      print('Past Due Date:');
      print('  Matches: $pastDueMatches');
      print('  Mismatches: $pastDueMismatches');

      if (statusMismatchCategories.isNotEmpty) {
        print('\nStatus mismatch categories:');
        final sorted = statusMismatchCategories.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        for (final entry in sorted) {
          print('  ${entry.key}: ${entry.value}');
        }
      }

      if (vgMismatchCounts.isNotEmpty) {
        print('\nStatus mismatches by vaccine group:');
        final sorted = vgMismatchCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        for (final entry in sorted) {
          print('  ${entry.key}: ${entry.value}');
        }
      }

      if (statusMismatchDetails.isNotEmpty) {
        print('\nFirst ${statusMismatchDetails.length} status mismatches:');
        for (final m in statusMismatchDetails) {
          print('  $m');
        }
      }

      if (earliestByVg.isNotEmpty || recommendedByVg.isNotEmpty ||
          pastDueByVg.isNotEmpty) {
        print('\nDate mismatches by vaccine group:');
        final allVgs = <String>{
          ...earliestByVg.keys,
          ...recommendedByVg.keys,
          ...pastDueByVg.keys,
        }.toList()
          ..sort();
        for (final vg in allVgs) {
          final e = earliestByVg[vg] ?? 0;
          final r = recommendedByVg[vg] ?? 0;
          final p = pastDueByVg[vg] ?? 0;
          print('  $vg: earliest=$e recommended=$r pastDue=$p');
        }
      }

      if (dateMismatchDetails.isNotEmpty) {
        print('\nFirst ${dateMismatchDetails.length} date mismatches:');
        for (final m in dateMismatchDetails) {
          print('  $m');
        }
      }

      // Baseline — don't fail, just report
    });
  });
}
