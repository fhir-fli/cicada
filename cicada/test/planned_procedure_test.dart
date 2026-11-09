// A planned splenectomy reaches CDSi observation 002 from an open order.
//
// CDSi 4.65 lists no code for 002 "Undergoing elective splenectomy"; its
// clarifying text is "Vaccination 14 or more days before splenectomy is
// suggested". Read 2026-11-09 at hl7.org/fhir/R4B/servicerequest.html, Scope
// and Usage: ServiceRequest is "a record of a request for a procedure or
// diagnostic or other service to be planned, proposed, or performed".
// OpenEvidence 2026-11-09 (CDSI-OE-ADJUDICATED.md section 18): drive 002 from
// an active ServiceRequest; leave partial splenectomy and splenorrhaphy out.
// Grey 2026-10-18: CPT 38100, 38102 and 38120 are total splenectomy (160 when
// completed).
import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

Map<String, dynamic> _patient() => {
  'resourceType': 'Patient',
  'id': 'p1',
  'birthDate': '1990-01-01',
  'gender': 'female',
};

Map<String, dynamic> _order(
  String cpt, {
  String status = 'active',
  String intent = 'order',
  bool? doNotPerform,
  String? occurrence,
}) => {
  'resourceType': 'ServiceRequest',
  'id': 'order-$cpt-$status-$intent',
  'status': status,
  'intent': intent,
  if (doNotPerform != null) 'doNotPerform': doNotPerform,
  'code': {
    'coding': [
      {'system': 'http://www.ama-assn.org/go/cpt', 'code': cpt},
    ],
  },
  'subject': {'reference': 'Patient/p1'},
  if (occurrence != null) 'occurrenceDateTime': occurrence,
};

Map<String, dynamic> _completedSplenectomy() => {
  'resourceType': 'Procedure',
  'id': 'splenectomy-done',
  'status': 'completed',
  'code': {
    'coding': [
      {'system': 'http://www.ama-assn.org/go/cpt', 'code': '38100'},
    ],
  },
  'subject': {'reference': 'Patient/p1'},
  'performedDateTime': '2026-12-01',
};

VaxPatient _run(List<Map<String, dynamic>> resources) {
  final parameters = Parameters.fromJson({
    'resourceType': 'Parameters',
    'parameter': [
      {'name': 'assessmentDate', 'valueDate': '2026-11-09'},
      {'name': 'patient', 'resource': _patient()},
      for (final r in resources) {'name': 'resource', 'resource': r},
    ],
  });
  return evaluateForForecast(parameters).patient;
}

List<String> _codes(VaxPatient p) => [
  for (final o in p.observations.observation ?? const <VaxObservation>[])
    o.observationCode ?? '',
];

void main() {
  group('an open order for a total splenectomy is 002, not 160', () {
    for (final cpt in ['38100', '38102', '38120']) {
      test('CPT $cpt', () {
        expect(_codes(_run([_order(cpt)])), ['002']);
      });
    }
  });

  group('ServiceRequest.intent', () {
    for (final intent in ['proposal', 'plan', 'order', 'original-order']) {
      test('$intent is 002', () {
        expect(_codes(_run([_order('38100', intent: intent)])), ['002']);
      });
    }
    test('option is not', () {
      expect(_codes(_run([_order('38100', intent: 'option')])), isEmpty);
    });
  });

  group('ServiceRequest.status', () {
    for (final status in [
      'draft',
      'on-hold',
      'revoked',
      'completed',
      'entered-in-error',
      'unknown',
    ]) {
      test('$status is not 002', () {
        expect(_codes(_run([_order('38100', status: status)])), isEmpty);
      });
    }
  });

  test('doNotPerform true is not 002', () {
    expect(_codes(_run([_order('38100', doNotPerform: true)])), isEmpty);
  });

  group('a partial splenectomy or splenorrhaphy order is not 002', () {
    for (final cpt in ['38101', '38115']) {
      test('CPT $cpt', () {
        expect(_codes(_run([_order(cpt)])), isEmpty);
      });
    }
  });

  test('an order for another mapped procedure asserts nothing', () {
    // CPT 69930 cochlear implantation is 011 when performed; an order is not.
    expect(_codes(_run([_order('69930')])), isEmpty);
  });

  test('the order is the supporting resource for 002', () {
    final patient = _run([_order('38100')]);
    expect(
      patient.observationSources['002']?.map((s) => s.reference),
      contains('ServiceRequest/order-38100-active-order'),
    );
  });

  test('the occurrence date starts the observation period', () {
    final obs =
        _run([
          _order('38100', occurrence: '2026-12-01'),
        ]).observations.observation!.single;
    expect(obs.period?.start?.valueString, '2026-12-01');
  });

  test('an order and the completed splenectomy assert 002 and 160', () {
    expect(
      _codes(_run([_order('38100'), _completedSplenectomy()]))..sort(),
      ['002', '160'],
    );
  });
}
