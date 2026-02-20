import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/test_doses.dart';
import 'package:cicada/generated_files/test_forecasts.dart';
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
  buffer.writeln('=== Diagnostic Output ===');
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

String categorizeMismatch(EvalStatus? expectedStatus, EvalStatus? actualStatus,
    EvalReason? expectedReason, EvalReason? actualReason) {
  if (expectedStatus == EvalStatus.valid &&
      actualStatus != EvalStatus.valid) {
    if (actualReason == EvalReason.ageTooYoung ||
        actualReason == EvalReason.ageTooOld) {
      return 'too-strict:age';
    }
    if (actualStatus == EvalStatus.extraneous) {
      return 'too-strict:extraneous-cascade';
    }
    if (actualReason == EvalReason.notPreferableOrAllowable) {
      return 'too-strict:vaccine-type';
    }
    if (actualReason == EvalReason.intervalTooShort) {
      return 'too-strict:interval';
    }
    if (actualReason == EvalReason.liveVirusConflict) {
      return 'too-strict:live-virus';
    }
    return 'too-strict:other';
  }
  if ((expectedStatus == EvalStatus.not_valid ||
          expectedStatus == EvalStatus.extraneous) &&
      actualStatus == EvalStatus.valid) {
    if (expectedReason == EvalReason.intervalTooShort) {
      return 'too-permissive:interval';
    }
    if (expectedReason == EvalReason.ageTooYoung ||
        expectedReason == EvalReason.ageTooOld) {
      return 'too-permissive:age';
    }
    return 'too-permissive:other';
  }
  if (expectedStatus == EvalStatus.extraneous) {
    return 'too-permissive:extraneous-expected';
  }
  return 'other';
}

/// Checks internal consistency of dose sub-step fields against evalStatus
/// and evalReason. Returns a list of violation descriptions (empty = ok).
List<String> checkDoseConsistency(VaxDose dose) {
  final violations = <String>[];

  if (dose.evalReason == EvalReason.ageTooYoung &&
      dose.validAgeReason != ValidAgeReason.tooYoung) {
    violations.add(
        'evalReason=ageTooYoung but validAgeReason=${dose.validAgeReason}');
  }

  if (dose.evalReason == EvalReason.ageTooOld &&
      dose.validAgeReason != ValidAgeReason.tooOld) {
    violations.add(
        'evalReason=ageTooOld but validAgeReason=${dose.validAgeReason}');
  }

  if (dose.evalReason == EvalReason.intervalTooShort &&
      dose.allowedIntervalReason != IntervalReason.tooShort &&
      dose.preferredIntervalReason != IntervalReason.tooShort) {
    violations.add(
        'evalReason=intervalTooShort but '
        'allowedIntervalReason=${dose.allowedIntervalReason}, '
        'preferredIntervalReason=${dose.preferredIntervalReason}');
  }

  if (dose.evalReason == EvalReason.liveVirusConflict &&
      dose.conflict != true) {
    violations.add(
        'evalReason=liveVirusConflict but conflict=${dose.conflict}');
  }

  if (dose.evalReason == EvalReason.notPreferableOrAllowable &&
      dose.allowedVaccine != false) {
    violations.add(
        'evalReason=notPreferableOrAllowable but '
        'allowedVaccine=${dose.allowedVaccine}');
  }

  if (dose.evalStatus == EvalStatus.valid) {
    if (dose.validAgeReason == ValidAgeReason.tooYoung ||
        dose.validAgeReason == ValidAgeReason.tooOld) {
      violations.add(
          'evalStatus=valid but validAgeReason=${dose.validAgeReason}');
    }
    if (dose.conflict == true) {
      violations.add('evalStatus=valid but conflict=true');
    }
    if (dose.allowedVaccine == false) {
      violations.add('evalStatus=valid but allowedVaccine=false');
    }
  }

  return violations;
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
      final List<String> statusMismatches = [];
      final List<String> reasonMismatches = [];
      final List<String> consistencyViolations = [];
      int comparedCount = 0;
      int statusMatchCount = 0;
      int reasonComparedCount = 0;
      int reasonMatchCount = 0;
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
          statusMismatches.add('$id: threw exception: $e');
          continue;
        }

        // Compare per expected dose: a dose matches if ANY antigen series
        // produces the expected evaluation. This is correct because combo
        // vaccines are evaluated independently per antigen, and the CDSi
        // test data provides one evaluation per dose.
        for (final expectedDose in expectedDoses) {
          bool foundStatusMatch = false;
          bool foundReasonMatch = false;
          bool foundAnyEval = false;
          final List<Map<String, dynamic>> failedSeriesInfo = [];
          bool hasExpectedReason = expectedDose.evalReason != null;

          result.agMap.forEach((String antigenName, VaxAntigen antigen) {
            if (!expectedDose.antigens.map((s) => s.toLowerCase())
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

                // Check internal consistency of sub-step fields
                final violations = checkDoseConsistency(actualDose);
                for (final v in violations) {
                  final msg = '$id | ${series.series.seriesName} | '
                      '${actualDose.doseId}: $v';
                  if (!consistencyViolations.contains(msg)) {
                    consistencyViolations.add(msg);
                  }
                }

                // Exact evalStatus comparison
                if (actualDose.evalStatus == expectedDose.evalStatus) {
                  foundStatusMatch = true;
                  // Exact evalReason comparison (when expected has one)
                  if (hasExpectedReason) {
                    if (actualDose.evalReason == expectedDose.evalReason) {
                      foundReasonMatch = true;
                    }
                  }
                } else {
                  failedSeriesInfo.add({
                    'seriesName': series.series.seriesName,
                    'actualStatus': actualDose.evalStatus,
                    'actualReason': actualDose.evalReason,
                    'actual': actualDose.validity,
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
            if (foundStatusMatch) {
              statusMatchCount++;
            }
            if (hasExpectedReason) {
              reasonComparedCount++;
              if (foundReasonMatch) {
                reasonMatchCount++;
              } else if (foundStatusMatch) {
                // Status matched but reason didn't — track separately
                reasonMismatches.add(
                  '$id | ${expectedDose.doseId}: '
                  'expectedReason="${expectedDose.evalReason}" '
                  'status matched (${expectedDose.evalStatus})',
                );
              }
            }
            if (!foundStatusMatch && failedSeriesInfo.isNotEmpty) {
              final firstFail = failedSeriesInfo.first;
              final category = categorizeMismatch(
                expectedDose.evalStatus,
                firstFail['actualStatus'] as EvalStatus?,
                expectedDose.evalReason,
                firstFail['actualReason'] as EvalReason?,
              );
              statusMismatches.add(
                '$id | ${firstFail['seriesName']} | '
                '${expectedDose.doseId}: '
                'expected="${expectedDose.evalStatus}" '
                'actual="${firstFail['actualStatus']}" '
                '[$category]',
              );

              diagnostics.putIfAbsent(id, () => []);
              diagnostics[id]!.add({
                'doseId': expectedDose.doseId,
                'expected': expectedDose.validity,
                'failedSeries': failedSeriesInfo,
                'category': category,
              });
            }
          }
        }
      }

      // Print summary
      print('Compared $comparedCount dose evaluations');
      print('EvalStatus matches: $statusMatchCount / $comparedCount');
      print('EvalStatus mismatches: ${statusMismatches.length}');
      print('EvalReason matches: $reasonMatchCount / $reasonComparedCount');
      print('EvalReason mismatches: ${reasonMismatches.length}');
      print('Consistency violations: ${consistencyViolations.length}');

      if (statusMismatches.isNotEmpty) {
        print('\nFirst 30 status mismatches:');
        for (final m in statusMismatches.take(30)) {
          print('  $m');
        }
      }

      if (reasonMismatches.isNotEmpty) {
        print('\nFirst 20 reason mismatches (status matched, reason did not):');
        for (final m in reasonMismatches.take(20)) {
          print('  $m');
        }
      }

      if (consistencyViolations.isNotEmpty) {
        print('\nFirst 20 consistency violations:');
        for (final v in consistencyViolations.take(20)) {
          print('  $v');
        }
      }

      // Write detailed diagnostics
      if (diagnostics.isNotEmpty) {
        final diagPath = '/tmp/cicada_forecast_diagnostics.txt';
        try {
          File(diagPath).parent.createSync(recursive: true);
          writeDiagnostics(diagnostics, diagPath);
          print('Diagnostics written to: $diagPath');
        } catch (e) {
          print('Could not write diagnostics: $e');
        }
      }

      // Regression thresholds based on current baseline
      expect(statusMismatches.length, lessThanOrEqualTo(0),
          reason: 'evalStatus mismatches regressed (baseline: 0)');
    });

    test('forecast dates and series status match CDSi expected results', () {
      // Map from Excel vaccine group abbreviations to engine vaccineGroupName
      const excelToEngine = <String, String>{
        'DTAP': 'DTaP/Tdap/Td',
        'FLU': 'Influenza',
        'HIB': 'Hib',
        'HPV': 'HPV',
        'HepA': 'HepA',
        'HepB': 'HepB',
        'MCV': 'Meningococcal',
        'MENB': 'Meningococcal B',
        'MMR': 'MMR',
        'PCV': 'Pneumococcal',
        'POL': 'Polio',
        'ROTA': 'Rotavirus',
        'RSV': 'RSV',
        'VAR': 'Varicella',
        'ZOSTER': 'Zoster',
        'COVID-19': 'COVID-19',
      };

      int comparedCount = 0;
      int statusMatches = 0;
      int statusMismatches = 0;
      int doseNumMatches = 0;
      int doseNumMismatches = 0;
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

      // Per-vaccine-group date mismatch counters
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

        final expectedForecasts = testForecasts[id];
        if (expectedForecasts == null || expectedForecasts.isEmpty) continue;

        ForecastResult result;
        try {
          result = evaluateForForecast(parameters);
        } catch (e) {
          missingForecasts += expectedForecasts.length;
          continue;
        }

        for (final expected in expectedForecasts) {
          final excelVg = expected['vaccineGroup']!;
          final engineVg = excelToEngine[excelVg];
          if (engineVg == null) {
            missingForecasts++;
            continue;
          }

          comparedCount++;

          // Look up the vaccine group forecast (aggregated per Chapter 9)
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

          // Compare dose number
          final expectedDoseNum = expected['forecastNum'] ?? '';
          if (expectedDoseNum.isNotEmpty && expectedDoseNum != '-') {
            final actualDoseNum = vgForecast.doseNumber?.toString() ?? '';
            if (expectedDoseNum == actualDoseNum) {
              doseNumMatches++;
            } else {
              doseNumMismatches++;
              if (dateMismatchDetails.length < 100) {
                dateMismatchDetails.add(
                  '$id [$excelVg] doseNum: '
                  'expected="$expectedDoseNum" '
                  'actual="$actualDoseNum"',
                );
              }
            }
          }

          // Compare dates (only when expected has them)
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
      print('\n=== FORECAST VALIDATION SUMMARY ===');
      print('Total comparisons: $comparedCount');
      print('Missing/unmapped forecasts: $missingForecasts');
      print('');
      print('Series Status:');
      print('  Matches: $statusMatches');
      print('  Mismatches: $statusMismatches');
      print('');
      print('Dose Number:');
      print('  Matches: $doseNumMatches');
      print('  Mismatches: $doseNumMismatches');
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

      // Per-vaccine-group date mismatch breakdown
      if (earliestByVg.isNotEmpty || recommendedByVg.isNotEmpty ||
          pastDueByVg.isNotEmpty) {
        print('\nDate mismatches by vaccine group:');
        final allVgs = <String>{
          ...earliestByVg.keys,
          ...recommendedByVg.keys,
          ...pastDueByVg.keys,
        }.toList()..sort();
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

      // Regression thresholds based on current baseline
      expect(statusMismatches, lessThanOrEqualTo(1),
          reason: 'forecast status mismatches regressed (baseline: 1)');
      expect(earliestMismatches, lessThanOrEqualTo(0),
          reason: 'earliest date mismatches regressed (baseline: 0)');
      expect(recommendedMismatches, lessThanOrEqualTo(0),
          reason: 'recommended date mismatches regressed (baseline: 0)');
      expect(pastDueMismatches, lessThanOrEqualTo(0),
          reason: 'past due date mismatches regressed (baseline: 0)');
    });
  });
}
