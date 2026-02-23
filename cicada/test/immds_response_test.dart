import 'dart:convert';
import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:test/test.dart';

/// Load the first N test cases from the NDJSON file.
List<Parameters> _loadFirstN(String path, int n) {
  final lines = File(path).readAsLinesSync();
  final result = <Parameters>[];

  for (final line in lines) {
    if (result.length >= n) break;
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

/// Helper to get the string value from a FhirCode (which uses toString()).
String? codeStr(FhirCode? code) => code?.toString();

/// Helper to get the string value from a FhirUri (which uses toString()).
String? uriStr(FhirUri? uri) => uri?.toString();

void main() {
  late Parameters noDoseCase; // 2013-0001: newborn, no immunizations
  late Parameters withDosesCase; // 2013-0002: patient with 2 doses
  late ForecastResult noDoseResult;
  late ForecastResult withDosesResult;
  late Parameters noDoseResponse;
  late Parameters withDosesResponse;

  setUpAll(() {
    final cases = _loadFirstN('test/healthyTestCases.ndjson', 2);
    noDoseCase = cases[0];
    withDosesCase = cases[1];

    noDoseResult = evaluateForForecast(noDoseCase);
    withDosesResult = evaluateForForecast(withDosesCase);

    noDoseResponse = buildImmdsResponse(noDoseResult);
    withDosesResponse = buildImmdsResponse(withDosesResult);
  });

  group('buildImmdsResponse structure', () {
    test('returns a Parameters resource', () {
      expect(noDoseResponse, isA<Parameters>());
      expect(noDoseResponse.parameter, isNotNull);
      expect(noDoseResponse.parameter, isNotEmpty);
    });

    test('has exactly one recommendation parameter', () {
      final recParams = noDoseResponse.parameter!
          .where((p) => p.name.valueString == 'recommendation')
          .toList();
      expect(recParams.length, 1);
      expect(recParams.first.resource, isA<ImmunizationRecommendation>());
    });

    test('no-dose case has zero evaluation parameters', () {
      final evalParams = noDoseResponse.parameter!
          .where((p) => p.name.valueString == 'evaluation')
          .toList();
      expect(evalParams, isEmpty);
    });

    test('with-doses case has evaluation parameters', () {
      final evalParams = withDosesResponse.parameter!
          .where((p) => p.name.valueString == 'evaluation')
          .toList();
      expect(evalParams, isNotEmpty);
      for (final ep in evalParams) {
        expect(ep.resource, isA<ImmunizationEvaluation>());
      }
    });
  });

  group('ImmunizationRecommendation structure', () {
    test('has patient reference', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;
      expect(rec.patient.reference, isNotNull);
      expect(rec.patient.reference!.valueString, contains('Patient/'));
    });

    test('has date', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;
      expect(rec.date, isNotNull);
    });

    test('has recommendations list', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;
      expect(rec.recommendation, isNotEmpty);
    });

    test('each recommendation has required fields', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      for (final r in rec.recommendation) {
        // targetDisease with text
        expect(r.targetDisease, isNotNull,
            reason: 'recommendation missing targetDisease');
        expect(r.targetDisease!.text, isNotNull,
            reason: 'targetDisease missing text');

        // forecastStatus
        expect(r.forecastStatus.coding, isNotNull);
        expect(r.forecastStatus.coding, isNotEmpty);

        // vaccineCode with group CVX first
        expect(r.vaccineCode, isNotNull,
            reason: 'recommendation missing vaccineCode');
        expect(r.vaccineCode, isNotEmpty);
        // First vaccineCode should have CVX system
        final firstVc = r.vaccineCode!.first;
        expect(firstVc.coding, isNotNull);
        expect(uriStr(firstVc.coding!.first.system),
            'http://hl7.org/fhir/sid/cvx');
      }
    });

    test('Not Complete recommendations have dateCriteria', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      for (final r in rec.recommendation) {
        final statusCode = codeStr(r.forecastStatus.coding?.first.code);
        if (statusCode == 'Not Complete') {
          expect(r.dateCriterion, isNotNull,
              reason:
                  'Not Complete recommendation should have dateCriteria');
          expect(r.dateCriterion, isNotEmpty);
        }
      }
    });

    test('doseNumberString is present for Not Complete recommendations', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      for (final r in rec.recommendation) {
        final statusCode = codeStr(r.forecastStatus.coding?.first.code);
        if (statusCode == 'Not Complete') {
          expect(r.doseNumberString, isNotNull,
              reason:
                  'Not Complete recommendation should have doseNumberString');
        }
      }
    });
  });

  group('ImmunizationEvaluation structure', () {
    test('each evaluation has required fields', () {
      final evalParams = withDosesResponse.parameter!
          .where((p) => p.name.valueString == 'evaluation')
          .toList();

      for (final ep in evalParams) {
        final eval = ep.resource as ImmunizationEvaluation;

        expect(eval.patient.reference, isNotNull,
            reason: 'evaluation missing patient reference');
        expect(eval.targetDisease, isNotNull,
            reason: 'evaluation missing targetDisease');
        expect(eval.immunizationEvent.reference, isNotNull,
            reason: 'evaluation missing immunizationEvent reference');
        expect(eval.immunizationEvent.reference!.valueString,
            contains('Immunization/'),
            reason: 'immunizationEvent should reference an Immunization');
        expect(eval.doseStatus.coding, isNotNull);
        // First coding is CDSi-compatible, second is HL7 standard
        final hl7DoseStatus = eval.doseStatus.coding!.where((c) =>
            uriStr(c.system) ==
            'http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status');
        expect(hl7DoseStatus, isNotEmpty,
            reason: 'doseStatus should have HL7 standard coding');
      }
    });

    test('not-valid evaluations have doseStatusReason', () {
      final evalParams = withDosesResponse.parameter!
          .where((p) => p.name.valueString == 'evaluation')
          .toList();

      for (final ep in evalParams) {
        final eval = ep.resource as ImmunizationEvaluation;
        final statusCode = codeStr(eval.doseStatus.coding?.first.code);
        if (statusCode == 'Not Valid' ||
            statusCode == 'Extraneous' ||
            statusCode == 'Sub standard') {
          expect(eval.doseStatusReason, isNotNull,
              reason: 'notvalid evaluation should have doseStatusReason');
          expect(eval.doseStatusReason, isNotEmpty);
          expect(
              uriStr(eval.doseStatusReason!.first.coding?.first.system),
              'http://hl7.org/fhir/us/immds/CodeSystem/StatusReason');
        }
      }
    });
  });

  group('Code system mappings', () {
    test('forecastStatus has CDSi, HL7, and LOINC codings', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      const cdsiSystem =
          'http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus';
      const hl7System =
          'http://terminology.hl7.org/CodeSystem/immunization-recommendation-status';
      final cdsiCodes = {
        'Not Complete',
        'Complete',
        'Immune',
        'Contraindicated',
        'Aged Out',
        'Not Recommended',
      };
      final hl7Codes = {
        'due',
        'overdue',
        'immune',
        'contraindicated',
        'complete',
        'agedout',
      };
      final loincCodes = {
        'LA13421-5', // Complete
        'LA13422-3', // On schedule
        'LA13423-1', // Overdue
        'LA13424-9', // Too old
        'LA27183-5', // Immune
        'LA4216-3', // Contraindicated
        'LA4695-8', // Not Recommended
      };

      for (final r in rec.recommendation) {
        final codings = r.forecastStatus.coding!;

        // First coding should be CDSi-compatible
        final cdsiCoding =
            codings.where((c) => uriStr(c.system) == cdsiSystem);
        expect(cdsiCoding, isNotEmpty,
            reason: 'forecastStatus should have CDSi coding');
        expect(cdsiCodes, contains(codeStr(cdsiCoding.first.code)),
            reason: 'CDSi code "${codeStr(cdsiCoding.first.code)}" '
                'not valid');

        // Should have LOINC coding
        final loincCoding =
            codings.where((c) => uriStr(c.system) == 'http://loinc.org');
        expect(loincCoding, isNotEmpty,
            reason: 'forecastStatus should have LOINC coding');
        expect(loincCodes, contains(codeStr(loincCoding.first.code)),
            reason: 'LOINC code "${codeStr(loincCoding.first.code)}" '
                'not in LL940-8');

        // For statuses with an HL7 standard code, verify it
        final hl7Coding =
            codings.where((c) => uriStr(c.system) == hl7System);
        if (hl7Coding.isNotEmpty) {
          expect(hl7Codes, contains(codeStr(hl7Coding.first.code)),
              reason: 'HL7 code "${codeStr(hl7Coding.first.code)}" not valid');
        }
      }
    });

    test('targetDisease uses SNOMED CT system', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      for (final r in rec.recommendation) {
        if (r.targetDisease?.coding != null &&
            r.targetDisease!.coding!.isNotEmpty) {
          for (final coding in r.targetDisease!.coding!) {
            expect(uriStr(coding.system), 'http://snomed.info/sct',
                reason: 'targetDisease should use SNOMED CT');
            expect(coding.code, isNotNull,
                reason: 'SNOMED coding should have a code');
          }
        }
      }
    });

    test('vaccineCode uses CVX system', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      for (final r in rec.recommendation) {
        if (r.vaccineCode != null) {
          for (final vc in r.vaccineCode!) {
            expect(vc.coding, isNotNull);
            expect(uriStr(vc.coding!.first.system),
                'http://hl7.org/fhir/sid/cvx',
                reason: 'vaccineCode should use CVX system');
          }
        }
      }
    });

    test('dateCriterion uses LOINC codes', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      final validLoincCodes = {'30981-5', '30980-7', '59778-1', '59777-3'};

      for (final r in rec.recommendation) {
        if (r.dateCriterion != null) {
          for (final dc in r.dateCriterion!) {
            expect(dc.code.coding, isNotNull);
            final coding = dc.code.coding!.first;
            expect(uriStr(coding.system), 'http://loinc.org',
                reason: 'dateCriterion should use LOINC');
            expect(validLoincCodes, contains(codeStr(coding.code)),
                reason:
                    'dateCriterion LOINC code "${codeStr(coding.code)}" '
                    'not valid');
            expect(dc.value, isNotNull,
                reason: 'dateCriterion must have a value');
          }
        }
      }
    });
  });

  group('Sentinel date filtering', () {
    test('VaxDate.min() and VaxDate.max() are excluded from output', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      for (final r in rec.recommendation) {
        if (r.dateCriterion != null) {
          for (final dc in r.dateCriterion!) {
            final dateStr = dc.value.toString();
            expect(dateStr, isNot(contains('1900')),
                reason: 'sentinel VaxDate.min() leaked into output');
            expect(dateStr, isNot(contains('2999')),
                reason: 'sentinel VaxDate.max() leaked into output');
          }
        }
      }
    });
  });

  group('Vaccine group CVX mapping', () {
    test('all vaccine groups have a group-level CVX code first', () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      // The known group CVX codes from the _vaccineGroupCvx map
      // (CDC official: https://www2a.cdc.gov/vaccines/iis/iisstandards/vaccines.asp?rpt=vg)
      final knownGroupCvx = <String>{
        '26', '213', '330', '107', '214', '85', '45', '17', '137', '88',
        '129', '108', '164', '03', '325', '152', '89', '90', '122', '304',
        '222', '91', '21', '184', '188',
      };

      for (final r in rec.recommendation) {
        if (r.vaccineCode != null && r.vaccineCode!.isNotEmpty) {
          final firstCode = codeStr(r.vaccineCode!.first.coding!.first.code);
          expect(knownGroupCvx, contains(firstCode),
              reason: 'First vaccineCode "$firstCode" for '
                  '"${r.targetDisease?.text?.valueString}" '
                  'should be a group-level CVX');
        }
      }
    });
  });

  group('JSON roundtrip', () {
    test('buildImmdsResponse output survives JSON roundtrip', () {
      final json = noDoseResponse.toJson();
      final jsonStr = jsonEncode(json);
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final roundtripped = Parameters.fromJson(decoded);

      // Verify key structural elements survive
      expect(roundtripped.parameter, isNotNull);
      final recParam = roundtripped.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation');
      expect(recParam.resource, isA<ImmunizationRecommendation>());

      final rec = recParam.resource as ImmunizationRecommendation;
      expect(rec.recommendation.length,
          (noDoseResponse.parameter!
                  .firstWhere(
                      (p) => p.name.valueString == 'recommendation')
                  .resource as ImmunizationRecommendation)
              .recommendation
              .length);
    });
  });
}
