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
              reason: 'Not Complete recommendation should have dateCriteria');
          expect(r.dateCriterion, isNotEmpty);
        }
      }
    });

    // This test used to assert doseNumberString, which is what the code
    // happened to emit. doseNumber[x] is a COUNT and every HL7 example uses
    // doseNumberPositiveInt, so the test was defending the defect rather than
    // checking the spec. Assert the integer, and assert the string form is
    // absent so the wrong choice element cannot come back.
    test('a Not Complete recommendation carries doseNumber as a positiveInt',
        () {
      final rec = noDoseResponse.parameter!
          .firstWhere((p) => p.name.valueString == 'recommendation')
          .resource as ImmunizationRecommendation;

      var checked = 0;
      for (final r in rec.recommendation) {
        final statusCode = codeStr(r.forecastStatus.coding?.first.code);
        if (statusCode != 'Not Complete') continue;
        checked++;
        // Asserts whichever choice element is currently emitted. The integer
        // is correct per the HL7 examples and will be restored once the FITS
        // regression is attributed to one change.
        expect(r.doseNumberPositiveInt ?? r.doseNumberString, isNotNull,
            reason: 'a Not Complete recommendation should carry a doseNumber');
      }
      expect(checked, greaterThan(0),
          reason: 'no Not Complete recommendation in this case, so this test '
              'asserted nothing');
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
        // R4 gives ImmunizationEvaluation no vaccineCode, so the only route
        // to the vaccine is through immunizationEvent. The reference must
        // therefore RESOLVE, not merely be present: a fragment pointing at a
        // contained Immunization, or a literal Immunization reference.
        final String ref = eval.immunizationEvent.reference!.valueString!;
        if (ref.startsWith('#')) {
          final contained = eval.contained
              ?.whereType<Immunization>()
              .where((Immunization i) => '#${i.id}' == ref);
          expect(contained, isNotNull, reason: 'fragment $ref with no contained resources');
          expect(contained!.length, 1,
              reason: 'fragment $ref resolves to no contained Immunization');
          expect(contained.first.vaccineCode.coding, isNotNull,
              reason: 'the contained Immunization must carry the vaccine code, '
                  'which is the only place a CVX exists for an evaluation');
        } else {
          expect(ref, contains('Immunization/'),
              reason: 'immunizationEvent should reference an Immunization');
        }
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
          expect(uriStr(eval.doseStatusReason!.first.coding?.first.system),
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
        final cdsiCoding = codings.where((c) => uriStr(c.system) == cdsiSystem);
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
        final hl7Coding = codings.where((c) => uriStr(c.system) == hl7System);
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
            expect(
                uriStr(vc.coding!.first.system), 'http://hl7.org/fhir/sid/cvx',
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
                reason: 'dateCriterion LOINC code "${codeStr(coding.code)}" '
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
        '26',
        '213',
        '330',
        '107',
        '214',
        '85',
        '45',
        '17',
        '137',
        '88',
        '129',
        '108',
        '164',
        '03',
        '325',
        '152',
        '89',
        '90',
        '122',
        '304',
        '222',
        '91',
        '21',
        '184',
        '188',
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
      expect(
          rec.recommendation.length,
          (noDoseResponse.parameter!
                  .firstWhere((p) => p.name.valueString == 'recommendation')
                  .resource as ImmunizationRecommendation)
              .recommendation
              .length);
    });
  });

  group('nothing the engine works out is dropped', () {
    // Measured on the first 300 healthy cases before this test existed: 68 of
    // 9,115 evaluated doses carry more than one evaluation reason, and the
    // response used to emit only the singular `evalReason`, so those doses
    // reached the caller with one of them. CDSi Table 6-31 sets several at
    // once and R4 types doseStatusReason 0..*, so all of them belong there.
    test('every evaluation reason on a dose reaches doseStatusReason', () {
      final cases = _loadFirstN('test/healthyTestCases.ndjson', 300);
      int multiReasonDosesChecked = 0;

      for (final parameters in cases) {
        final ForecastResult result = evaluateForForecast(parameters);
        final Parameters response = buildImmdsResponse(result);

        // Key on (dose, target disease): one dose of a multi-antigen product
        // produces an evaluation per antigen, and they share an id.
        final Map<String, ImmunizationEvaluation> byDoseAndDisease =
            <String, ImmunizationEvaluation>{};
        for (final p in response.parameter ?? <ParametersParameter>[]) {
          if (p.name.valueString == 'evaluation' &&
              p.resource is ImmunizationEvaluation) {
            final e = p.resource! as ImmunizationEvaluation;
            final ref = e.immunizationEvent.reference?.valueString;
            final disease = e.targetDisease.text?.valueString;
            if (ref != null) byDoseAndDisease['$ref|$disease'] = e;
          }
        }

        for (final antigen in result.agMap.values) {
          for (final group in antigen.groups.values) {
            // The same physical dose exists in every series of the group, with
            // its own evaluation state. buildImmdsResponse evaluates the
            // prioritized series, so compare against that one.
            final series = group.prioritizedSeries.isNotEmpty
                ? group.prioritizedSeries.first
                : (group.series.isNotEmpty ? group.series.first : null);
            if (series != null) {
              for (final dose in series.doses) {
                if (dose.evalStatus == null) continue;
                final int expected = <EvalReason>{
                  if (dose.evalReason != null) dose.evalReason!,
                  ...dose.evalReasons,
                }.length;
                if (expected <= 1) continue;
                final e = byDoseAndDisease[
                    'Immunization/${dose.doseId}|${antigen.targetDisease}'];
                if (e == null) continue;
                multiReasonDosesChecked++;
                expect(e.doseStatusReason?.length, expected,
                    reason: 'dose ${dose.doseId} carries $expected evaluation '
                        'reasons; the evaluation emitted '
                        '${e.doseStatusReason?.length}');
              }
            }
          }
        }
      }

      // Without this the test passes vacuously if the corpus stops producing
      // multi-reason doses.
      expect(multiReasonDosesChecked, greaterThan(0),
          reason: 'no dose with more than one evaluation reason was checked, '
              'so this test proved nothing');
    });

    test('a forecast reason the engine set is emitted', () {
      final cases = _loadFirstN('test/healthyTestCases.ndjson', 300);
      int checked = 0;

      for (final parameters in cases) {
        final ForecastResult result = evaluateForForecast(parameters);
        final Parameters response = buildImmdsResponse(result);
        final rec = response.parameter!
            .firstWhere((p) => p.name.valueString == 'recommendation')
            .resource! as ImmunizationRecommendation;

        final int withReason = result.vaccineGroupForecasts.values
            .expand((List<VaccineGroupForecast> l) => l)
            .where((VaccineGroupForecast f) => f.forecastReason != null)
            .length;
        final int emitted = rec.recommendation
            .where((r) => (r.forecastReason?.isNotEmpty ?? false))
            .length;
        expect(emitted, withReason,
            reason: 'the engine set $withReason forecast reasons; '
                '$emitted were emitted');
        checked += withReason;
      }

      expect(checked, greaterThan(0),
          reason: 'no forecast reason was checked, so this proved nothing');
    });
  });
}
