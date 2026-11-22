import 'package:cicada/cicada.dart';
import 'package:cicada_ehr/cicada_ehr.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

/// A girl born 2025-01-15 given hepatitis B vaccine (CVX 08) at birth, two
/// months and six months, assessed 2026-11-19.
///
/// Every interval clears CDSi's HepB series (supporting data 4.66,
/// "HepB 3-dose series"): dose 2 at 59 days after dose 1 (minimum 4 weeks),
/// dose 3 at 181 days of age (minimum 24 weeks), 122 days after dose 2
/// (minimum 8 weeks) and 181 days after dose 1 (minimum 16 weeks). So the
/// series is complete and all three doses are valid.
Parameters _chart() {
  final patient = Patient(
    id: 'p1'.toFhirString,
    gender: AdministrativeGender.female,
    birthDate: FhirDate.fromString('2025-01-15'),
  );
  Immunization dose(String id, String date) => Immunization(
    id: id.toFhirString,
    status: ImmunizationStatusCodes.completed,
    vaccineCode: CodeableConcept(
      coding: [
        Coding(
          system: 'http://hl7.org/fhir/sid/cvx'.toFhirUri,
          code: '08'.toFhirCode,
        ),
      ],
    ),
    patient: Reference(reference: 'Patient/p1'.toFhirString),
    occurrenceX: FhirDateTime.fromString(date),
  );
  return Parameters(
    parameter: [
      ParametersParameter(
        name: 'assessmentDate'.toFhirString,
        valueDate: FhirDate.fromString('2026-11-19'),
      ),
      ParametersParameter(name: 'patient'.toFhirString, resource: patient),
      for (final (id, date) in [
        ('i1', '2025-01-15'),
        ('i2', '2025-03-15'),
        ('i3', '2025-07-15'),
      ])
        ParametersParameter(
          name: 'immunization'.toFhirString,
          resource: dose(id, date),
        ),
    ],
  );
}

/// A woman born 1983-05-01 with an active pregnancy Condition (SNOMED CT
/// 77386006, one of the codes CDSi supporting data 4.66 lists for its
/// pregnancy observation), assessed 2026-11-19.
(Parameters, Patient) _pregnant() {
  final patient = Patient(
    id: 'p2'.toFhirString,
    gender: AdministrativeGender.female,
    birthDate: FhirDate.fromString('1983-05-01'),
  );
  return (
    Parameters(
      parameter: [
        ParametersParameter(
          name: 'assessmentDate'.toFhirString,
          valueDate: FhirDate.fromString('2026-11-19'),
        ),
        ParametersParameter(name: 'patient'.toFhirString, resource: patient),
        ParametersParameter(
          name: 'condition'.toFhirString,
          resource: Condition(
            id: 'c1'.toFhirString,
            subject: Reference(reference: 'Patient/p2'.toFhirString),
            clinicalStatus: CodeableConcept(
              coding: [
                Coding(
                  system:
                      'http://terminology.hl7.org/CodeSystem/condition-clinical'
                          .toFhirUri,
                  code: 'active'.toFhirCode,
                ),
              ],
            ),
            code: CodeableConcept(
              coding: [
                Coding(
                  system: 'http://snomed.info/sct'.toFhirUri,
                  code: '77386006'.toFhirCode,
                  display: 'Pregnant'.toFhirString,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    patient,
  );
}

void main() {
  final parameters = _chart();
  final patient =
      parameters.parameter!
              .firstWhere((p) => p.name.valueString == 'patient')
              .resource!
          as Patient;
  final result = evaluateForForecast(parameters);
  final view = ForecastView.of(result, patient);
  final cards = view.sections.expand((s) => s.cards).toList();

  test('every forecast the engine made is on the page, once', () {
    final forecasts = result.vaccineGroupForecasts.values
        .expand((l) => l)
        .toList();
    expect(forecasts, isNotEmpty);
    expect(cards, hasLength(forecasts.length));
  });

  test('the banner gives age, sex, birth date and assessment date', () {
    expect(view.banner, [
      'Age 1 year, 10 months',
      'Female',
      'DOB Jan 15, 2025',
      'Assessment Nov 19, 2026',
    ]);
  });

  test('a complete HepB series is under Complete and says so', () {
    final complete = view.sections.singleWhere((s) => s.title == 'Complete');
    final hepB = complete.cards.singleWhere((c) => c.title == 'HepB');
    expect(hepB.category, ForecastCategory.complete);
    expect(hepB.notes, ['${ForecastReason.patientSeriesIsComplete}.']);
    // A complete series has no next dose to date.
    expect(hepB.rows.map((r) => r.label), isNot(contains('Recommended')));
  });

  test('the three HepB doses are listed as evaluated', () {
    final group = view.doseEvaluations.singleWhere(
      (g) => g.title.startsWith('HepB'),
    );
    expect(group.rows.map((r) => (r.date, r.cvx, r.status)), [
      ('Jan 15, 2025', '08', EvalStatus.valid.toString()),
      ('Mar 15, 2025', '08', EvalStatus.valid.toString()),
      ('Jul 15, 2025', '08', EvalStatus.valid.toString()),
    ]);
  });

  test('a series still due shows its dates and the vaccines to give', () {
    // This child has had no MMR; CDSi's MMR series is due from 12 months.
    final mmr = cards.firstWhere((c) => c.title == 'MMR');
    expect(mmr.category.isActionable, isTrue);
    expect(
      mmr.rows.map((r) => r.label),
      containsAll(<String>['Next dose', 'Earliest', 'Recommended']),
    );
    expect(
      mmr.rows.singleWhere((r) => r.label == 'Next dose').value,
      'Dose 1',
    );
  });

  test('a standard and a risk forecast of one group get a card each', () {
    // CDSi Logic Specification v4.6 Table 9-2 FORECASTVG-1 scopes a
    // forecast to a series group; DTaP/Tdap/Td has a standard and an
    // increased-risk (pregnancy) series group.
    final (parameters, patient) = _pregnant();
    final view = ForecastView.of(evaluateForForecast(parameters), patient);
    final tdap = view.sections
        .expand((s) => s.cards)
        .where((c) => c.title == 'DTaP/Tdap/Td')
        .toList();
    expect(tdap, hasLength(2));
    // The risk card names its series group and the chart entry that put
    // the patient on it (CDSi Table 5-4 indication); the standard one does
    // not.
    expect(
      tdap.where((c) => c.subtitles.contains('Increased Risk: Pregnant')),
      hasLength(1),
    );
    expect(
      tdap.where((c) => c.subtitles.any((s) => s.contains('Risk'))),
      hasLength(1),
    );
  });

  group('formatAge', () {
    test('counts whole months, a month ending on the birth day', () {
      final born = DateTime(2025, 1, 15);
      expect(ForecastView.formatAge(born, DateTime(2025, 2, 14)), '0 months');
      expect(ForecastView.formatAge(born, DateTime(2025, 2, 15)), '1 month');
      expect(
        ForecastView.formatAge(born, DateTime(2027, 1, 15)),
        '2 years, 0 months',
      );
      expect(
        ForecastView.formatAge(born, DateTime(2028, 1, 14)),
        '2 years, '
        '11 months',
      );
      expect(ForecastView.formatAge(born, DateTime(2028, 1, 15)), '3 years');
    });
  });
}
