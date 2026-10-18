import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

/// Found on the fhirant phone run of REVIEW-2026-10-17 (2026-10-18).
///
/// A dose with no date. R4B Immunization.occurrence[x] is 1..1, dateTime or
/// string (profiles-resources.json). CDSi Logic Specification v4.6 gives
/// Date Administered no assumed value: Table 3-4 and Table 6-2, "Assumed
/// Value if Empty" "-" (logic-spec-acip-rec-4.6.txt). Every evaluation is
/// anchored on it (section 3.3). The engine used to put such a dose at
/// 2999-01-01 and evaluate it there; it now refuses, as for a Patient with no
/// birthDate.
///
/// A dose with no id. R4B ImmunizationEvaluation.immunizationEvent is 1..1:
/// each evaluation names the dose it evaluates, and the engine names it by
/// id. The engine used to stop on a null check (`immunization.id!`) and the
/// caller saw a crash; it now refuses.
///
/// The refusal is the parser returning no patient, as for a missing Patient
/// or birthDate, which the provider raises. (`OperationOutcomes.addError`
/// records nothing, so the reason given there is not observable; that is a
/// separate defect.)
void main() {
  VaxPatient parsed(Map<String, dynamic> json) {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container.read(
      patientForAssessmentProvider(Parameters.fromJson(json)),
    );
  }

  // The parser's refusal, as the provider reports it.
  final refused = throwsA(
    predicate((e) => '$e'.contains('cannot be assessed')),
  );

  Map<String, dynamic> parameters(Map<String, dynamic> immunization) => {
    'resourceType': 'Parameters',
    'parameter': [
      {'name': 'assessmentDate', 'valueDate': '2026-10-18'},
      {
        'name': 'patient',
        'resource': {
          'resourceType': 'Patient',
          'id': 'p',
          'birthDate': '2025-01-01',
        },
      },
      {'name': 'immunization', 'resource': immunization},
    ],
  };

  Map<String, dynamic> dose({String? id, Map<String, dynamic>? occurrence}) => {
    'resourceType': 'Immunization',
    if (id != null) 'id': id,
    'status': 'completed',
    'vaccineCode': {
      'coding': [
        {'system': 'http://hl7.org/fhir/sid/cvx', 'code': '08'},
      ],
    },
    'patient': {'reference': 'Patient/p'},
    ...?occurrence,
  };

  test('a dose dated only as text is refused', () {
    expect(
      () => parsed(
        parameters(
          dose(id: 'd1', occurrence: {'occurrenceString': 'spring, some year'}),
        ),
      ),
      refused,
    );
  });

  test('a dose dated only as text, with an expiration date, is refused', () {
    final d = dose(id: 'd1', occurrence: {'occurrenceString': 'unknown'})
      ..['expirationDate'] = '2026-01-01';
    expect(() => parsed(parameters(d)), refused);
  });

  test('a dose with no id is refused', () {
    expect(
      () => parsed(
        parameters(dose(occurrence: {'occurrenceDateTime': '2025-03-01'})),
      ),
      refused,
    );
  });

  test('control: a dated dose with an id is parsed', () {
    final patient = parsed(
      parameters(
        dose(id: 'd1', occurrence: {'occurrenceDateTime': '2025-03-01'}),
      ),
    );
    expect(patient.pastDoses.single.doseId, 'd1');
  });

  for (final mode in ForecastMode.values) {
    test('$mode: control, the same request is forecast', () {
      final result = forecastFromMap(
        parameters(
          dose(id: 'd1', occurrence: {'occurrenceDateTime': '2025-03-01'}),
        ),
        mode: mode,
      );
      expect(
        result.parameter!.where((p) => p.name.valueString == 'evaluation'),
        isNotEmpty,
      );
    });
  }
}
