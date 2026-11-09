// Records FHIR marks as not valid must not reach the forecast.
//
// Quoted from R4B StructureDefinition-Immunization.json, read 2026-10-18:
// Immunization.status is a modifier "because it is a status element that
// contains statuses entered-in-error and not-done which means that the
// resource should not be treated as valid". Quoted from R4B
// StructureDefinition-Condition.json: Condition.verificationStatus is a
// modifier "because the status contains the code refuted and
// entered-in-error that mark the Condition as not currently valid".
// AllergyIntolerance.verificationStatus carries the same two codes
// (CodeSystem-allergyintolerance-verification.json).
import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

Map<String, dynamic> _patient() => {
  'resourceType': 'Patient',
  'id': 'p1',
  'birthDate': '2020-01-01',
  'gender': 'female',
};

Map<String, dynamic> _mmr(String status) => {
  'resourceType': 'Immunization',
  'id': 'mmr-$status',
  'status': status,
  'vaccineCode': {
    'coding': [
      {'system': 'http://hl7.org/fhir/sid/cvx', 'code': '03'},
    ],
  },
  'patient': {'reference': 'Patient/p1'},
  'occurrenceDateTime': '2021-01-15',
};

Map<String, dynamic> _asplenia(String verification) => {
  'resourceType': 'Condition',
  'id': 'asplenia-$verification',
  'verificationStatus': {
    'coding': [
      {
        'system': 'http://terminology.hl7.org/CodeSystem/condition-ver-status',
        'code': verification,
      },
    ],
  },
  'code': {
    'coding': [
      {'system': 'http://snomed.info/sct', 'code': '707147002'},
    ],
  },
  'subject': {'reference': 'Patient/p1'},
  'onsetDateTime': '2021-01-01',
};

Map<String, dynamic> _mmrAllergy(String verification) => {
  'resourceType': 'AllergyIntolerance',
  'id': 'mmr-allergy-$verification',
  'verificationStatus': {
    'coding': [
      {
        'system':
            'http://terminology.hl7.org/CodeSystem/allergyintolerance-verification',
        'code': verification,
      },
    ],
  },
  'code': {
    'coding': [
      {'system': 'http://hl7.org/fhir/sid/cvx', 'code': '03'},
    ],
  },
  'patient': {'reference': 'Patient/p1'},
};

Map<String, dynamic> _splenectomy(String status, String cpt) => {
  'resourceType': 'Procedure',
  'id': 'splenectomy-$status-$cpt',
  'status': status,
  'code': {
    'coding': [
      {'system': 'http://www.ama-assn.org/go/cpt', 'code': cpt},
    ],
  },
  'subject': {'reference': 'Patient/p1'},
  'performedDateTime': '2024-03-01',
};

VaxPatient _run(List<Map<String, dynamic>> resources) {
  final parameters = Parameters.fromJson({
    'resourceType': 'Parameters',
    'parameter': [
      {'name': 'assessmentDate', 'valueDate': '2026-10-18'},
      {'name': 'patient', 'resource': _patient()},
      for (final r in resources) {'name': 'resource', 'resource': r},
    ],
  });
  return evaluateForForecast(parameters).patient;
}

List<String> _observationCodes(VaxPatient p) => [
  for (final o in p.observations.observation ?? const <VaxObservation>[])
    o.observationCode ?? '',
];

void main() {
  group('Immunization.status', () {
    test('a completed dose counts', () {
      expect(_run([_mmr('completed')]).pastDoses, hasLength(1));
    });
    test('a not-done dose does not count', () {
      expect(_run([_mmr('not-done')]).pastDoses, isEmpty);
    });
    test('an entered-in-error dose does not count', () {
      expect(_run([_mmr('entered-in-error')]).pastDoses, isEmpty);
    });
  });

  group('Condition.verificationStatus', () {
    test('a confirmed asplenia is 160', () {
      expect(
        _observationCodes(_run([_asplenia('confirmed')])),
        contains('160'),
      );
    });
    test('a refuted asplenia is not', () {
      expect(_observationCodes(_run([_asplenia('refuted')])), isEmpty);
    });
    test('an entered-in-error asplenia is not', () {
      expect(_observationCodes(_run([_asplenia('entered-in-error')])), isEmpty);
    });
  });

  group('AllergyIntolerance.verificationStatus', () {
    test('a confirmed MMR allergy reaches the measles allergy observation', () {
      expect(
        _observationCodes(_run([_mmrAllergy('confirmed')])),
        contains('091'),
      );
    });
    test('a refuted MMR allergy does not', () {
      expect(_observationCodes(_run([_mmrAllergy('refuted')])), isEmpty);
    });
    test('an entered-in-error MMR allergy does not', () {
      expect(
        _observationCodes(_run([_mmrAllergy('entered-in-error')])),
        isEmpty,
      );
    });
  });

  // R4B CodeSystem-event-status.json: only 'completed' has concluded.
  group('Procedure.status', () {
    test('a completed total splenectomy is 160', () {
      expect(
        _observationCodes(_run([_splenectomy('completed', '38100')])),
        contains('160'),
      );
    });
    for (final status in [
      'preparation',
      'not-done',
      'stopped',
      'entered-in-error',
    ]) {
      test('a $status total splenectomy is not', () {
        expect(
          _observationCodes(_run([_splenectomy(status, '38100')])),
          isEmpty,
        );
      });
    }
    test('a completed partial splenectomy is not', () {
      expect(
        _observationCodes(_run([_splenectomy('completed', '38101')])),
        isEmpty,
      );
    });
  });
}
