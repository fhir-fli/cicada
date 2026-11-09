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

    // Some CDC SNOMED codes are broader than the observation they are filed
    // under (observation_map_policy.json broad_codes, 2026-10-21). Before,
    // 400047006 Peripheral vascular disease alone put 586 vessel injuries
    // under 254 chronic cardiovascular disease. A code reached only through
    // a broad code now counts only on a reviewed yes. Each pair below is one
    // code that stopped counting and one that still counts.
    group('a broad CDC code alone asserts nothing', () {
      const cases = <String, ({String no, String yes})>{
        '017': (no: 'J32.8', yes: 'J42'), // chronic sinusitis; bronchitis
        '254': (no: 'S65.009A', yes: 'Q21.3'), // artery injury; tetralogy
        '258': (no: 'L03.021', yes: 'D61.3'), // lymphangitis; aplastic anemia
        '016': (no: 'M48.9', yes: 'I42.9'), // spondylopathy; cardiomyopathy
        '269': (no: 'T86.8401', yes: 'T86.11'), // corneal; kidney transplant
        '080': (no: 'T50.B95A', yes: 'T80.52XA'), // adverse effect; anaphylaxis
      };
      cases.forEach((observation, pair) {
        test(observation, () {
          expect(_codes(_icd10, pair.no), isNot(contains(observation)));
          expect(_codes(_icd10, pair.yes), contains(observation));
        });
      });

      test('venous thrombosis is not chronic cardiovascular disease', () {
        expect(_codes(_icd10, 'I82.211'), isNot(contains('254')));
      });

      // SNOMED files adenosine deaminase deficiency under SCID; OpenEvidence
      // 2026-10-19: unspecified ADA deficiency is not SCID.
      test('unspecified ADA deficiency is not SCID', () {
        expect(_codes(_icd10, 'D81.30'), isNot(contains('013')));
      });

      // OpenEvidence 2026-10-21: other psychoactive substance does not
      // establish an illegal drug.
      test('other psychoactive substance use is not illicit drug use', () {
        expect(_codes(_icd10, 'F19.939'), isNot(contains('040')));
      });

      // OpenEvidence 2026-10-21 (policy question): 254 is the RSV condition,
      // cardiac plus chronic arterial and aortic disease; the pneumococcal
      // "chronic heart disease" wording belongs to 016. Celiac artery
      // compression is external compression, not vessel disease.
      test('chronic arterial disease is 254, external compression is not', () {
        expect(_codes(_icd10, 'I70.0'), contains('254'));
        expect(_codes(_icd10, 'I71.9'), contains('254'));
        expect(_codes(_icd10, 'I77.4'), isNot(contains('254')));
      });
    });

    // OpenEvidence 2026-10-21 rulings on the broad-code rows that differ
    // from Claude's tentative answers.
    group('OpenEvidence 2026-10-21', () {
      // Types 4a-c and 5 follow coronary revascularization (Thygesen 2018).
      test('other myocardial infarction type is chronic heart disease', () {
        expect(_codes(_icd10, 'I21.A9'), contains('016'));
      });

      test('patent foramen ovale is not chronic cardiovascular disease', () {
        expect(_codes(_icd10, 'Q21.12'), isNot(contains('254')));
      });

      // Cerebrovascular disease has its own CDSi condition.
      test('cerebrovascular syphilis is 206, not 254', () {
        final found = _codes(_icd10, 'A52.04');
        expect(found, contains('206'));
        expect(found, isNot(contains('254')));
      });

      // ACIP files hematologic malignancy under immunocompromise; the code
      // still reaches CDC's cancer observations.
      test('leukemia is not a chronic hematologic disorder', () {
        final found = _codes(_icd10, 'C91.10');
        expect(found, isNot(contains('258')));
        expect(found, containsAll(<String>['178', '198']));
      });

      test('iron deficiency is not a chronic hematologic disorder', () {
        expect(_codes(_icd10, 'D50.1'), isNot(contains('258')));
      });

      // CDC names most DiGeorge syndrome as a partial defect; a complete
      // defect needs immunologic evidence the code does not carry.
      test('DiGeorge syndrome is a partial T-lymphocyte defect', () {
        expect(_codes(_icd10, 'D82.1'), contains('148'));
      });

      // CDC lists 77128003 under both 147 and 148: the concept can be
      // either, but the code alone is not a complete defect.
      test('SNOMED DiGeorge sequence is partial, not complete', () {
        final found = _codes(_snomed, '77128003');
        expect(found, contains('148'));
        expect(found, isNot(contains('147')));
      });

      // The three transplant conditions are nested: stem cell -> 004 + 269,
      // solid organ -> 157 + 269, unspecified or other tissue -> 269 only;
      // skin, bone and corneal grafts need no lasting immunosuppression.
      // Every billable T86 and Z94 code in ICD-10-CM (UMLS 2025AB).
      test(
        'every transplant code reaches exactly its transplant conditions',
        () {
          const stemCell = {'004', '269'};
          const solidOrgan = {'157', '269'};
          const transplantOnly = {'269'};
          const none = <String>{};
          final expected = <String, Set<String>>{
            for (final c in [
              'T86.00', 'T86.01', 'T86.02', 'T86.03', 'T86.09', 'T86.5', //
              'Z94.81', 'Z94.84',
            ])
              c: stemCell,
            for (final c in [
              'T86.10', 'T86.11', 'T86.12', 'T86.13', 'T86.19', 'Z94.0', //
              'T86.20', 'T86.21', 'T86.22', 'T86.23', 'T86.290', 'T86.298',
              'Z94.1', 'T86.30', 'T86.31', 'T86.32', 'T86.33', 'T86.39',
              'Z94.3', 'T86.40', 'T86.41', 'T86.42', 'T86.43', 'T86.49',
              'Z94.4', 'T86.810', 'T86.811', 'T86.812', 'T86.818', 'T86.819',
              'Z94.2', 'T86.850', 'T86.851', 'T86.852', 'T86.858', 'T86.859',
              'Z94.82', 'Z94.83',
            ])
              c: solidOrgan,
            for (final c in [
              'T86.890',
              'T86.891',
              'T86.892',
              'T86.898',
              'T86.899',
              'Z94.89', //
              'T86.90', 'T86.91', 'T86.92', 'T86.93', 'T86.99', 'Z94.9',
            ])
              c: transplantOnly,
            for (final c in [
              'T86.820', 'T86.821', 'T86.822', 'T86.828', 'T86.829', 'Z94.5', //
              'T86.830', 'T86.831', 'T86.832', 'T86.838', 'T86.839', 'Z94.6',
              'T86.8401', 'T86.8402', 'T86.8403', 'T86.8409', 'T86.8411',
              'T86.8412', 'T86.8413', 'T86.8419', 'T86.8421', 'T86.8422',
              'T86.8423', 'T86.8429', 'T86.8481', 'T86.8482', 'T86.8483',
              'T86.8489', 'T86.8491', 'T86.8492', 'T86.8493', 'T86.8499',
              'Z94.7',
            ])
              c: none,
          };
          expect(expected, hasLength(91));
          for (final MapEntry(key: code, value: want) in expected.entries) {
            final found =
                _codes(
                  _icd10,
                  code,
                ).where(const {'004', '157', '269'}.contains).toSet();
            expect(found, want, reason: code);
          }
        },
      );
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
