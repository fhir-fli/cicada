// Healthy childhood and adult CDSi test cases.
//
// Derived by substitution from condition_test.dart so the comparison semantics
// are identical — only the data sources differ. Before this existed,
// test/cicada_test.dart ran these 1,064 cases and asserted nothing: it printed
// each id and warned only when a case produced no recommendation at all. The
// expected results (testDoses, testForecasts) were generated all along and
// never read, so "1010/1014 (99.6%)" in CLAUDE.md came from nothing in the
// repo.
//
// This suite is the one whose cases match the supporting data in version:
// v4.46 test cases and 4.65-508 data are both August 2026.

import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/test_doses.dart';
import 'package:cicada/generated_files/test_forecasts.dart';
import 'package:test/test.dart';

/// Loads NDJSON test cases, fixing up missing required fields.
List<Parameters> loadHealthyTestCases(String path) {
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
    violations
        .add('evalReason=ageTooOld but validAgeReason=${dose.validAgeReason}');
  }

  if (dose.evalReason == EvalReason.intervalTooShort &&
      dose.allowedIntervalReason != IntervalReason.tooShort &&
      dose.preferredIntervalReason != IntervalReason.tooShort) {
    violations.add('evalReason=intervalTooShort but '
        'allowedIntervalReason=${dose.allowedIntervalReason}, '
        'preferredIntervalReason=${dose.preferredIntervalReason}');
  }

  if (dose.evalReason == EvalReason.liveVirusConflict &&
      dose.conflict != true) {
    violations
        .add('evalReason=liveVirusConflict but conflict=${dose.conflict}');
  }

  if (dose.evalReason == EvalReason.notPreferableOrAllowable &&
      dose.allowedVaccine != false) {
    violations.add('evalReason=notPreferableOrAllowable but '
        'allowedVaccine=${dose.allowedVaccine}');
  }

  if (dose.evalStatus == EvalStatus.valid) {
    if (dose.validAgeReason == ValidAgeReason.tooYoung ||
        dose.validAgeReason == ValidAgeReason.tooOld) {
      violations
          .add('evalStatus=valid but validAgeReason=${dose.validAgeReason}');
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

/// Map from the healthy-suite Excel vaccine group labels to engine names.
///
/// The two CDSi workbooks label the same groups differently — conditions says
/// "DTaP", healthy says "DTAP" — so this cannot be shared with
/// condition_test.dart. Deriving this test by substitution left it using the
/// conditions map, every lookup fell through to a key the engine does not
/// have, and 621 cases reported "no forecast produced". That was the harness,
/// not the engine.
const healthyExcelToEngine = <String, String>{
  'DTAP': 'DTaP/Tdap/Td',
  'Td': 'DTaP/Tdap/Td',
  'FLU': 'Influenza',
  'HIB': 'Hib',
  'MCV': 'Meningococcal',
  'MENB': 'Meningococcal B',
  'PCV': 'Pneumococcal',
  'POL': 'Polio',
  'ROTA': 'Rotavirus',
  'VAR': 'Varicella',
  'ZOSTER': 'Zoster',
  // COVID-19, HPV, HepA, HepB, MMR and RSV already match the engine's names.
};

String _patientId(Parameters parameters, int index) {
  final Patient? patient = parameters.parameter
      ?.firstWhereOrNull((ParametersParameter e) => e.resource is Patient)
      ?.resource as Patient?;
  final id = patient?.id?.toString();
  if (id == null || id == 'null') return 'case-$index';
  return id;
}

void main() {
  final allParameters =
      loadHealthyTestCases('test/healthyTestCases.ndjson');

  group('CDSi healthy childhood and adult test cases', () {
    test('loaded ${allParameters.length} test cases', () {
      expect(allParameters.length, greaterThan(1000));
    });

    for (int i = 0; i < allParameters.length; i++) {
      final parameters = allParameters[i];
      final id = _patientId(parameters, i);

      test(id, () {
        // --- Evaluate ---
        final result = evaluateForForecast(parameters);
        final mismatches = <String>[];

        // --- Dose evaluation ---
        final expectedDoseMaps = testDoses[id];
        if (expectedDoseMaps != null) {
          for (final doseMap in expectedDoseMaps) {
            final expectedDose = VaxDose.fromJson(doseMap);
            final expectedSeriesType = doseMap['seriesType'] as String?;
            bool foundStatusMatch = false;
            bool foundReasonMatch = false;
            bool foundAnyEval = false;
            final bool hasExpectedReason = expectedDose.evalReason != null;
            final Set<EvalReason?> actualReasons = {};

            result.agMap.forEach((String antigenName, VaxAntigen antigen) {
              if (!expectedDose.antigens
                  .map((s) => s.toLowerCase())
                  .contains(antigenName.toLowerCase())) {
                return;
              }

              antigen.groups.forEach((String groupKey, VaxGroup group) {
                for (final series in group.series) {
                  // If expected dose has a seriesType, only match
                  // against series of that type.
                  if (expectedSeriesType != null &&
                      series.series.seriesType != null) {
                    final actualType =
                        series.series.seriesType.toString().toLowerCase();
                    if (actualType != expectedSeriesType) continue;
                  }

                  final actualDose = series.doses
                      .firstWhereOrNull((d) => d.doseId == expectedDose.doseId);
                  if (actualDose == null || actualDose.evalStatus == null) {
                    continue;
                  }

                  foundAnyEval = true;

                  // Consistency check
                  final violations = checkDoseConsistency(actualDose);
                  for (final v in violations) {
                    mismatches.add('consistency: ${actualDose.doseId} $v');
                  }

                  if (actualDose.evalStatus == expectedDose.evalStatus) {
                    foundStatusMatch = true;
                    actualReasons.add(actualDose.evalReason);
                    if (hasExpectedReason &&
                        actualDose.evalReason == expectedDose.evalReason) {
                      foundReasonMatch = true;
                    }
                  }
                }
              });
            });

            if (!foundAnyEval && expectedDose.evalStatus != null) {
              mismatches.add('dose ${expectedDose.doseId}: '
                  'not found in any evaluated series '
                  '(expected ${expectedDose.evalStatus}'
                  '${expectedSeriesType != null ? ', seriesType=$expectedSeriesType' : ''})');
            } else if (foundAnyEval && !foundStatusMatch) {
              mismatches.add('dose ${expectedDose.doseId}: '
                  'evalStatus expected=${expectedDose.evalStatus} '
                  'reason=${expectedDose.evalReason}'
                  '${expectedSeriesType != null ? ' seriesType=$expectedSeriesType' : ''}');
            }
            if (foundAnyEval &&
                foundStatusMatch &&
                hasExpectedReason &&
                !foundReasonMatch) {
              mismatches.add('dose ${expectedDose.doseId}: '
                  'evalReason expected=${expectedDose.evalReason} '
                  'actual=${actualReasons.join(",")}');
            }
          }
        }

        // --- Forecast ---
        final expectedForecasts = testForecasts[id];

        if (expectedForecasts != null) {
          for (final expected in expectedForecasts) {
            final excelVg = expected['vaccineGroup']!.trim();
            final engineVg = healthyExcelToEngine[excelVg] ?? excelVg;

            final vgForecast = result.vaccineGroupForecasts[engineVg];
            if (vgForecast == null) {
              mismatches.add('[$excelVg] no forecast produced');
              continue;
            }

            // Series status
            final expectedStatus = expected['seriesStatus']!.toLowerCase();
            final actualStatus = vgForecast.status.toString().toLowerCase();
            if (expectedStatus != actualStatus) {
              mismatches.add('[$excelVg] status: '
                  'expected=$expectedStatus actual=$actualStatus');
            }

            // Dose number
            final expectedDoseNum = expected['forecastNum'] ?? '';
            if (expectedDoseNum.isNotEmpty && expectedDoseNum != '-') {
              final actualDoseNum = vgForecast.doseNumber?.toString() ?? '';
              if (expectedDoseNum != actualDoseNum) {
                mismatches.add('[$excelVg] doseNum: '
                    'expected=$expectedDoseNum actual=$actualDoseNum');
              }
            }

            // Dates
            final expectedEarliest = expected['earliestDate'] ?? '';
            final expectedRecommended = expected['recommendedDate'] ?? '';
            final expectedPastDue = expected['pastDueDate'] ?? '';

            final actualEarliest = vgForecast.earliestDate?.toString() ?? '';
            final actualRecommended =
                vgForecast.recommendedDate?.toString() ?? '';
            final actualPastDue = vgForecast.pastDueDate?.toString() ?? '';

            if (expectedEarliest.isNotEmpty &&
                expectedEarliest != actualEarliest) {
              mismatches.add('[$excelVg] earliest: '
                  'expected=$expectedEarliest actual=$actualEarliest');
            }
            if (expectedRecommended.isNotEmpty &&
                expectedRecommended != actualRecommended) {
              mismatches.add('[$excelVg] recommended: '
                  'expected=$expectedRecommended actual=$actualRecommended');
            }
            if (expectedPastDue.isNotEmpty &&
                expectedPastDue != actualPastDue) {
              mismatches.add('[$excelVg] pastDue: '
                  'expected=$expectedPastDue actual=$actualPastDue');
            }
          }
        }

        if (mismatches.isNotEmpty) {
          fail('${mismatches.length} mismatches:\n${mismatches.join('\n')}');
        }
      });
    }
  });
}
