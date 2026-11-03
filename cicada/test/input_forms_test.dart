import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

/// Every form the published guides use to send what cicada reads
/// (TEST-RESOURCE-REVIEW.md). The CDC suites are built the way most guides
/// build resources; this file covers the other forms, one test each.
void main() {
  const dob = '2020-01-01';
  final birth = VaxDate.fromDateTime(DateTime(2020));

  Immunization dose(Map<String, dynamic> extra) => Immunization.fromJson({
    'resourceType': 'Immunization',
    'id': 'd1',
    'status': 'completed',
    'vaccineCode': {
      'coding': [
        {'system': 'http://hl7.org/fhir/sid/cvx', 'code': '43'},
      ],
    },
    'patient': {'reference': 'Patient/p'},
    'occurrenceDateTime': '2026-01-01',
    ...extra,
  });

  String? mvx(
    Map<String, dynamic> extra, [
    Map<String, Organization> orgs = const {},
  ]) => VaxDose.fromImmunization(dose(extra), birth, organizations: orgs).mvx;

  group('manufacturer', () {
    test('control: no manufacturer gives no MVX', () {
      expect(mvx({}), isNull);
    });

    for (final system in mvxSystems) {
      test('manufacturer.identifier with system $system', () {
        expect(
          mvx({
            'manufacturer': {
              'identifier': {'system': system, 'value': 'MSD'},
            },
          }),
          'MSD',
        );
      });
    }

    test('contained Organization, identifier with no system (FITS)', () {
      expect(
        mvx({
          'contained': [
            {
              'resourceType': 'Organization',
              'id': '1',
              'identifier': [
                {'value': 'MSD'},
              ],
            },
          ],
          'manufacturer': {'reference': '#1'},
        }),
        'MSD',
      );
    });

    test('contained Organization known only by name', () {
      expect(
        mvx({
          'contained': [
            {
              'resourceType': 'Organization',
              'id': 'm',
              'name': mvxDisplays['MSD'],
            },
          ],
          'manufacturer': {'reference': '#m'},
        }),
        'MSD',
      );
    });

    test('literal reference to an Organization sent with the request', () {
      final org = Organization.fromJson({
        'resourceType': 'Organization',
        'id': 'merck',
        'identifier': [
          {'system': 'http://hl7.org/fhir/sid/mvx', 'value': 'MSD'},
        ],
      });
      expect(
        mvx(
          {
            'manufacturer': {'reference': 'Organization/merck'},
          },
          {'Organization/merck': org},
        ),
        'MSD',
      );
    });

    test('display only, the company name (UK Core, AU, EU Base)', () {
      expect(
        mvx({
          'manufacturer': {'display': mvxDisplays['MSD']},
        }),
        'MSD',
      );
    });

    test('a display that names no MVX manufacturer gives none', () {
      expect(
        mvx({
          'manufacturer': {'display': 'Example Vaccine Manufacturer'},
        }),
        isNull,
      );
    });

    test('MVX coding in vaccineCode (older senders)', () {
      expect(
        mvx({
          'vaccineCode': {
            'coding': [
              {'system': 'http://hl7.org/fhir/sid/cvx', 'code': '43'},
              {'system': 'http://hl7.org/fhir/sid/mvx', 'code': 'MSD'},
            ],
          },
        }),
        'MSD',
      );
    });
  });

  group('clinical history', () {
    Map<String, dynamic> input(List<Map<String, dynamic>> resources) => {
      'resourceType': 'Parameters',
      'parameter': [
        {'name': 'assessmentDate', 'valueDate': '2026-06-01'},
        {
          'name': 'patient',
          'resource': {
            'resourceType': 'Patient',
            'id': 'p',
            'gender': 'female',
            'birthDate': dob,
          },
        },
        for (final r in resources)
          {'name': (r['resourceType'] as String).toLowerCase(), 'resource': r},
      ],
    };

    Set<String?> observed(List<Map<String, dynamic>> resources) =>
        evaluateForForecast(Parameters.fromJson(input(resources)))
            .patient
            .observations
            .observation!
            .map((o) => o.observationCode)
            .toSet();

    Map<String, dynamic> condition(String status) => {
      'resourceType': 'Condition',
      'id': 'c',
      'verificationStatus': {
        'coding': [
          {
            'system':
                'http://terminology.hl7.org/CodeSystem/condition-ver-status',
            'code': status,
          },
        ],
      },
      'code': {
        'coding': [
          {'system': 'http://snomed.info/sct', 'code': '707147002'},
        ],
      },
      'subject': {'reference': 'Patient/p'},
    };

    test('confirmed Condition asserts its observation (160 asplenia)', () {
      expect(observed([condition('confirmed')]), contains('160'));
    });

    test('provisional Condition counts', () {
      expect(observed([condition('provisional')]), contains('160'));
    });

    test('refuted Condition asserts nothing', () {
      expect(observed([condition('refuted')]), isNot(contains('160')));
    });

    test('entered-in-error Condition asserts nothing', () {
      expect(
        observed([condition('entered-in-error')]),
        isNot(contains('160')),
      );
    });

    test('pregnancy as an Observation (LOINC 82810-3, value pregnant)', () {
      expect(
        observed([
          {
            'resourceType': 'Observation',
            'id': 'o',
            'status': 'final',
            'code': {
              'coding': [
                {'system': 'http://loinc.org', 'code': '82810-3'},
              ],
            },
            'subject': {'reference': 'Patient/p'},
            'valueCodeableConcept': {
              'coding': [
                {'system': 'http://snomed.info/sct', 'code': '77386006'},
              ],
            },
          },
        ]),
        contains('007'),
      );
    });

    Map<String, dynamic> measlesIgG(String result) => {
      'resourceType': 'Observation',
      'id': 'lab',
      'status': 'final',
      'code': {
        'coding': [
          {'system': 'http://loinc.org', 'code': '7962-4'},
        ],
      },
      'subject': {'reference': 'Patient/p'},
      'valueCodeableConcept': {
        'coding': [
          {'system': 'http://snomed.info/sct', 'code': result},
        ],
      },
    };

    test('positive measles IgG asserts 020 immunity', () {
      expect(observed([measlesIgG('10828004')]), contains('020'));
    });

    test('negative measles IgG asserts no immunity', () {
      expect(observed([measlesIgG('260385009')]), isNot(contains('020')));
    });

    test('a not-done Procedure asserts nothing', () {
      Map<String, dynamic> hsct(String status) => {
        'resourceType': 'Procedure',
        'id': 'pr',
        'status': status,
        'code': {
          'coding': [
            {'system': 'http://snomed.info/sct', 'code': '234336002'},
          ],
        },
        'subject': {'reference': 'Patient/p'},
      };
      expect(observed([hsct('completed')]), contains('004'));
      expect(observed([hsct('not-done')]), isNot(contains('004')));
    });

    test('an Observation date reaches the observation period', () {
      final result = evaluateForForecast(
        Parameters.fromJson(
          input([
            {
              'resourceType': 'Observation',
              'id': 'd',
              'status': 'final',
              'code': {
                'coding': [
                  {
                    'system':
                        'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes',
                    'code': '171',
                  },
                ],
              },
              'subject': {'reference': 'Patient/p'},
              'effectiveDateTime': '2025-03-04',
            },
          ]),
        ),
      );
      final hsctDate = result.patient.observations.observation!.firstWhere(
        (o) => o.observationCode == '171',
      );
      expect(hsctDate.period?.start?.valueDateTime, DateTime(2025, 3, 4));
    });
  });

  test('a Bundle of records is accepted as input (Swiss ch-vacd request)', () {
    final result = forecastFromMap({
      'resourceType': 'Bundle',
      'type': 'collection',
      'entry': [
        {
          'resource': {
            'resourceType': 'Patient',
            'id': 'p',
            'gender': 'female',
            'birthDate': dob,
          },
        },
        {
          'resource': {
            'resourceType': 'Immunization',
            'id': 'd1',
            'status': 'completed',
            'vaccineCode': {
              'coding': [
                {'system': 'http://hl7.org/fhir/sid/cvx', 'code': '08'},
              ],
            },
            'patient': {'reference': 'Patient/p'},
            'occurrenceDateTime': '2020-01-01',
          },
        },
      ],
    });
    final names = result.parameter!.map((p) => p.name.valueString).toSet();
    expect(names, containsAll(['evaluation', 'recommendation']));
  });
}
