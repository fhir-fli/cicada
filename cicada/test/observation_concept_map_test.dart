// Real chart codes through the matcher, checked against CDC's Coded
// Observations data, HL7's code systems and the reviewed policy
// (cicada_generator/lib/crosswalk/observation_map_policy.json), not against
// what the matcher happens to return.
//
// Written 2026-10-18. Before it, the hand-typed crosswalk filed asplenia
// (ICD-10 D73.0) under 018, laboratory evidence of hepatitis A immunity, and
// the matcher kept only the first observation a code reached. CDC's test
// cases send CDSi observation codes directly and never reach this path,
// which is how both survived.
import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

const _snomed = 'http://snomed.info/sct';
const _icd10 = 'http://hl7.org/fhir/sid/icd-10-cm';
const _loinc = 'http://loinc.org';
const _rxnorm = 'http://www.nlm.nih.gov/research/umls/rxnorm';
const _cvx = 'http://hl7.org/fhir/sid/cvx';
const _phinvs = 'urn:oid:2.16.840.1.114222.4.5.274';
const _interp =
    'http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation';

List<String> _codes(
  String system,
  String code, {
  Set<(String, String)> results = const <(String, String)>{},
}) =>
    observationsFromCodeableConcept(
      CodeableConcept(
        coding: [Coding(system: FhirUri(system), code: FhirCode(code))],
      ),
      results: results,
    ).map((o) => o.observationCode ?? '').toList();

Observation _lab(String loinc, String status, String interpretation) =>
    Observation.fromJson(<String, dynamic>{
      'resourceType': 'Observation',
      'status': status,
      'code': {
        'coding': [
          {'system': _loinc, 'code': loinc},
        ],
      },
      'interpretation': [
        {
          'coding': [
            {'system': _interp, 'code': interpretation},
          ],
        },
      ],
    });

void main() {
  setUp(() => setForecastMode(ForecastMode.cdc));

  group("CDC's own codes", () {
    // Coded Observations 4.65-508: 707147002 Asplenia is 160's code.
    test('SNOMED asplenia is 160', () {
      expect(_codes(_snomed, '707147002'), ['160']);
    });

    // CDC files 13645005 COPD under both 017 and 214. A patient's
    // observations are a set (logic spec 4.6 Table A-2, DEFPATIENT-008).
    test('COPD reaches both observations CDC files it under', () {
      expect(_codes(_snomed, '13645005'), containsAll(<String>['017', '214']));
    });

    // CDC files 86406008 under 026 and 186. 026 also needs perinatal
    // infection, CD4 and MMR before therapy, which no code carries.
    test('HIV infection is 186 and never 026 from a code', () {
      final found = _codes(_snomed, '86406008');
      expect(found, contains('186'));
      expect(found, isNot(contains('026')));
    });

    // CDC files AIDS (62479008) under 154 and 155, which differ by CD4.
    // AIDS is a subtype of HIV infection in SNOMED, so it reaches 186.
    test('AIDS asserts neither severity and reaches HIV infection', () {
      final found = _codes(_snomed, '62479008');
      expect(found, isNot(contains('154')));
      expect(found, isNot(contains('155')));
      expect(found, contains('186'));
    });

    // VXC20 is "allergy to previous dose of THIS vaccine" and names none.
    test('VXC20 alone asserts no vaccine allergy', () {
      expect(_codes(_phinvs, 'VXC20'), isEmpty);
    });

    // CDC files CVX 110 (DTaP-HepB-IPV) under the allergy observation of
    // each of its antigens.
    test('a CVX code reaches every antigen CDC files it under', () {
      expect(
        _codes(_cvx, '110'),
        containsAll(<String>['081', '086', '087', '088', '097']),
      );
    });
  });

  group('ICD-10-CM', () {
    test('asplenia is never hepatitis A immunity', () {
      for (final code in ['D73.0', 'Q89.01', 'Z90.81']) {
        expect(_codes(_icd10, code), isNot(contains('018')), reason: code);
      }
    });

    test('chronic kidney disease is never hepatitis B immunity', () {
      expect(_codes(_icd10, 'N18.4'), isNot(contains('019')));
    });

    // NLM maps every SNOMED concept that lands on N18.4 from under CDC's
    // chronic kidney disease codes.
    test('CKD stage 4 is 161', () {
      expect(_codes(_icd10, 'N18.4'), contains('161'));
    });

    // A15.1 is a WHO ICD-10 code, not ICD-10-CM. Until 2026-10-18 the
    // derivation also read NLM's SNOMED to WHO ICD-10 map set, and A15.1
    // asserted 031 tuberculosis in the ICD-10-CM group.
    test('a WHO-only ICD-10 code asserts nothing as ICD-10-CM', () {
      expect(_codes(_icd10, 'A15.1'), isEmpty);
    });

    // NLM writes T80.52X? for "any 7th character"; the chart carries
    // T80.52XA. The expanded code must be in the map. Anaphylaxis after a
    // vaccine is 080, "Adverse reaction to vaccine component".
    test('placeholder 7th characters are expanded to real codes', () {
      expect(_codes(_icd10, 'T80.52XA'), ['080']);
      expect(observationConceptMap[_icd10], contains('T80.52XA'));
      expect(observationConceptMap[_icd10], isNot(contains('T80.52X?')));
    });

    // 080 contraindicates every vaccine. OpenEvidence 2026-10-19: an adverse
    // effect of any kind is not a severe allergy to a vaccine component.
    test('an unspecified vaccine adverse effect is not 080', () {
      expect(_codes(_icd10, 'T50.A95A'), isEmpty);
      expect(_codes(_icd10, 'T50.Z95A'), isEmpty);
    });

    // OpenEvidence 2026-10-20: ACIP's chronic renal failure is stage 4-5
    // or ESRD; an unstaged CKD code is chronic kidney disease only.
    test('unstaged CKD is 161, not chronic renal failure', () {
      for (final code in ['I12.9', 'N18.9']) {
        final found = _codes(_icd10, code);
        expect(found, contains('161'), reason: code);
        expect(found, isNot(contains('066')), reason: code);
      }
    });

    // OpenEvidence 2026-10-20: the DTaP/Tdap precaution holds until the
    // encephalopathy is documented static (Liang 2018, MMWR RR 67(2)).
    test('unspecified encephalopathy is 076 until shown static', () {
      for (final code in ['G93.40', 'G93.49', 'P91.811']) {
        expect(_codes(_icd10, code), contains('076'), reason: code);
      }
      expect(_codes(_icd10, 'P91.819'), isNot(contains('076')));
    });

    test('HIV disease is never travel, Ebola work or perinatal HIV', () {
      final found = _codes(_icd10, 'B20');
      for (final wrong in ['026', '142', '183']) {
        expect(found, isNot(contains(wrong)), reason: wrong);
      }
    });
  });

  group('laboratory results', () {
    Set<(String, String)> results(String loinc, String status, String i) =>
        resultsOfObservation(_lab(loinc, status, i));

    test('a positive hepatitis B surface antibody is 019, not 024', () {
      final found = _codes(
        _loinc,
        '16935-9',
        results: results('16935-9', 'final', 'POS'),
      );
      expect(found, ['019']);
    });

    test('a positive hepatitis A IgG is 018, not 025', () {
      final found = _codes(
        _loinc,
        '32018-4',
        results: results('32018-4', 'final', 'POS'),
      );
      expect(found, ['018']);
    });

    test('a negative measles IgG is not immunity', () {
      expect(
        _codes(_loinc, '7962-4', results: results('7962-4', 'final', 'NEG')),
        isEmpty,
      );
    });

    test('a measles IgG with no result is not immunity', () {
      expect(_codes(_loinc, '7962-4'), isEmpty);
    });

    // R4B observation-status: preliminary may be incomplete or unverified.
    test('a preliminary positive is not yet immunity', () {
      expect(
        _codes(
          _loinc,
          '7962-4',
          results: results('7962-4', 'preliminary', 'POS'),
        ),
        isEmpty,
      );
    });

    // v3 ObservationInterpretation RR is Reactive, a presence finding.
    test('a reactive rubella IgG is immunity', () {
      expect(
        _codes(_loinc, '8014-3', results: results('8014-3', 'final', 'RR')),
        ['022'],
      );
    });
  });

  group('medications', () {
    // CDC's 033 is influenza antivirals; acyclovir treats herpes viruses.
    test('acyclovir is not an influenza antiviral', () {
      expect(_codes(_rxnorm, '281'), isEmpty);
    });

    // 033 needs the date: "within the previous 48 hours".
    test('oseltamivir alone does not assert 033', () {
      expect(_codes(_snomed, '412261005'), isEmpty);
    });
  });

  test('a code the map does not hold asserts nothing', () {
    expect(_codes(_icd10, 'S52.501A'), isEmpty);
    expect(_codes('http://example.org/unknown', '160'), isEmpty);
  });

  test('a direct CDSi observation code still passes through', () {
    expect(
      _codes(
        'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes',
        '160',
      ),
      ['160'],
    );
  });

  test("WHO mode reads WHO's own codes", () {
    setForecastMode(ForecastMode.who);
    addTearDown(() => setForecastMode(ForecastMode.cdc));
    expect(_codes(_snomed, '161152002'), contains('1010'));
  });
}
