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

/// Map from Excel vaccine group abbreviations to engine vaccineGroupName.
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

String _patientId(Parameters parameters, int index) {
  final Patient? patient = parameters.parameter
      ?.firstWhereOrNull(
          (ParametersParameter e) => e.resource is Patient)
      ?.resource as Patient?;
  return patient?.id?.toString() ?? 'unknown-$index';
}

void main() {
  final allParameters = loadTestCases('test/healthyTestCases.ndjson');

  group('CDSi healthy test cases', () {
    test('loaded ${allParameters.length} test cases', () {
      expect(allParameters.length, 1013);
    });

    for (int i = 0; i < allParameters.length; i++) {
      final parameters = allParameters[i];
      final id = _patientId(parameters, i);

      test(id, () {
        // --- Evaluate ---
        final result = evaluateForForecast(parameters);
        final mismatches = <String>[];

        // --- Dose evaluation ---
        final expectedDoses = testDoses[id]
            ?.map((Map<String, Object> e) => VaxDose.fromJson(e))
            .toList();

        if (expectedDoses != null) {
          for (final expectedDose in expectedDoses) {
            bool foundStatusMatch = false;
            bool foundReasonMatch = false;
            bool foundAnyEval = false;
            final bool hasExpectedReason = expectedDose.evalReason != null;

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

                  // Consistency check
                  final violations = checkDoseConsistency(actualDose);
                  for (final v in violations) {
                    mismatches.add(
                        'consistency: ${actualDose.doseId} $v');
                  }

                  if (actualDose.evalStatus == expectedDose.evalStatus) {
                    foundStatusMatch = true;
                    if (hasExpectedReason &&
                        actualDose.evalReason == expectedDose.evalReason) {
                      foundReasonMatch = true;
                    }
                  }
                }
              });
            });

            if (!foundAnyEval && expectedDose.evalStatus != null) {
              mismatches.add(
                  'dose ${expectedDose.doseId}: '
                  'not found in any evaluated series '
                  '(expected ${expectedDose.evalStatus})');
            } else if (foundAnyEval && !foundStatusMatch) {
              mismatches.add(
                  'dose ${expectedDose.doseId}: '
                  'evalStatus expected=${expectedDose.evalStatus} '
                  'reason=${expectedDose.evalReason}');
            }
            if (foundAnyEval && foundStatusMatch && hasExpectedReason &&
                !foundReasonMatch) {
              mismatches.add(
                  'dose ${expectedDose.doseId}: '
                  'evalReason expected=${expectedDose.evalReason}');
            }
          }
        }

        // --- Forecast ---
        final expectedForecasts = testForecasts[id];

        if (expectedForecasts != null) {
          for (final expected in expectedForecasts) {
            final excelVg = expected['vaccineGroup']!;
            final engineVg = excelToEngine[excelVg];
            if (engineVg == null) continue;

            final vgForecast = result.vaccineGroupForecasts[engineVg];
            if (vgForecast == null) {
              mismatches.add('[$excelVg] no forecast produced');
              continue;
            }

            // Series status
            final expectedStatus = expected['seriesStatus']!.toLowerCase();
            final actualStatus = vgForecast.status.toString().toLowerCase();
            if (expectedStatus != actualStatus) {
              mismatches.add(
                  '[$excelVg] status: '
                  'expected=$expectedStatus actual=$actualStatus');
            }

            // Dose number
            final expectedDoseNum = expected['forecastNum'] ?? '';
            if (expectedDoseNum.isNotEmpty && expectedDoseNum != '-') {
              final actualDoseNum =
                  vgForecast.doseNumber?.toString() ?? '';
              if (expectedDoseNum != actualDoseNum) {
                mismatches.add(
                    '[$excelVg] doseNum: '
                    'expected=$expectedDoseNum actual=$actualDoseNum');
              }
            }

            // Dates
            final expectedEarliest = expected['earliestDate'] ?? '';
            final expectedRecommended = expected['recommendedDate'] ?? '';
            final expectedPastDue = expected['pastDueDate'] ?? '';

            final actualEarliest =
                vgForecast.earliestDate?.toString() ?? '';
            final actualRecommended =
                vgForecast.recommendedDate?.toString() ?? '';
            final actualPastDue =
                vgForecast.pastDueDate?.toString() ?? '';

            if (expectedEarliest.isNotEmpty &&
                expectedEarliest != actualEarliest) {
              mismatches.add(
                  '[$excelVg] earliest: '
                  'expected=$expectedEarliest actual=$actualEarliest');
            }
            if (expectedRecommended.isNotEmpty &&
                expectedRecommended != actualRecommended) {
              mismatches.add(
                  '[$excelVg] recommended: '
                  'expected=$expectedRecommended actual=$actualRecommended');
            }
            if (expectedPastDue.isNotEmpty &&
                expectedPastDue != actualPastDue) {
              mismatches.add(
                  '[$excelVg] pastDue: '
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
