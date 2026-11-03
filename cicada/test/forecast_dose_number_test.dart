import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

/// FORECASTDN-1: the forecast dose number is the count of satisfied target
/// doses plus 1. Chapter 6 evaluation step 5a: if the target dose is a
/// recurring dose, "initialize a new target dose identical to the current
/// target dose" (quoted verbatim from logic-spec-acip-rec-4.6.txt, read
/// 2026-11-03), so each recurrence is its own target dose and is counted.
/// FORECASTDN-2: a vaccine group with the administer full vaccine group flag
/// 'Y' takes the minimum over its patient series forecasts.
///
/// Found on NIST FITS AART-DTAP-9 ("Dose 8 at 31 years", 2026-11-03): eight
/// valid doses, two of them adult boosters of the recurring tetanus and
/// diphtheria dose, forecast dose 8 where FITS expects 9.
void main() {
  String? dtapDoseNumber(String dob, List<(String, String)> doses) {
    final out = forecastFromMap({
      'resourceType': 'Parameters',
      'parameter': [
        {'name': 'assessmentDate', 'valueDate': '2026-11-03'},
        {
          'name': 'patient',
          'resource': {
            'resourceType': 'Patient',
            'id': 'p',
            'gender': 'female',
            'birthDate': dob,
          },
        },
        for (final (i, (cvx, date)) in doses.indexed)
          {
            'name': 'immunization',
            'resource': {
              'resourceType': 'Immunization',
              'id': 'd$i',
              'status': 'completed',
              'vaccineCode': {
                'coding': [
                  {'system': 'http://hl7.org/fhir/sid/cvx', 'code': cvx},
                ],
              },
              'patient': {'reference': 'Patient/p'},
              'occurrenceDateTime': date,
            },
          },
      ],
    });
    final rec =
        out.parameter!
            .map((p) => p.resource)
            .whereType<ImmunizationRecommendation>()
            .single;
    return rec.recommendation
        .singleWhere(
          (r) =>
              r.vaccineCode?.any(
                (c) =>
                    c.coding?.any((x) => x.code?.valueString == '107') ?? false,
              ) ??
              false,
        )
        .doseNumberString
        ?.valueString;
  }

  const childhood = [
    ('107', '1996-01-03'),
    ('107', '1996-03-03'),
    ('107', '1996-05-03'),
    ('107', '1997-02-03'),
    ('107', '1999-11-03'),
    ('115', '2006-11-03'),
  ];

  test('one adult booster: 7 valid doses forecast dose 8 (AART-DTAP-8)', () {
    expect(
      dtapDoseNumber('1995-11-03', [...childhood, ('113', '2016-11-03')]),
      '8',
    );
  });

  test('two adult boosters: 8 valid doses forecast dose 9 (AART-DTAP-9)', () {
    expect(
      dtapDoseNumber('1995-11-03', [
        ...childhood,
        ('113', '2016-11-03'),
        ('115', '2026-11-03'),
      ]),
      '9',
    );
  });
}
