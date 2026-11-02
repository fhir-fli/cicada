import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

/// Each forecast mode evaluates the antigens of its own supporting data:
/// CDC mode the CDSi 4.65 antigen set, WHO mode the WHO set. Until
/// 2026-11-01 the antigen map read the CDC list in both modes, so
/// `$immds-forecast-who` returned the CDC forecast (Zoster, RSV,
/// Meningococcal B and Varicella present, Tuberculosis absent).
void main() {
  final parameters = Parameters.fromJson({
    'resourceType': 'Parameters',
    'parameter': [
      {'name': 'assessmentDate', 'valueDate': '2026-01-15'},
      {
        'name': 'patient',
        'resource': {
          'resourceType': 'Patient',
          'id': 'example-infant',
          'gender': 'female',
          'birthDate': '2025-07-01',
        },
      },
      {
        'name': 'immunization',
        'resource': {
          'resourceType': 'Immunization',
          'id': 'hepb-birth',
          'status': 'completed',
          'vaccineCode': {
            'coding': [
              {'system': 'http://hl7.org/fhir/sid/cvx', 'code': '08'},
            ],
          },
          'patient': {'reference': 'Patient/example-infant'},
          'occurrenceDateTime': '2025-07-01',
        },
      },
    ],
  });

  Set<String> evaluated(ForecastMode mode) =>
      evaluateForForecast(parameters, mode: mode).agMap.keys.toSet();

  tearDown(() => setForecastMode(ForecastMode.cdc));

  test('WHO mode evaluates exactly the WHO antigen set', () {
    expect(
      evaluated(ForecastMode.who),
      whoAntigenSupportingDataMap.keys.toSet(),
    );
  });

  test('WHO mode includes Tuberculosis and none of the CDC-only antigens', () {
    final who = evaluated(ForecastMode.who);
    expect(who, contains('Tuberculosis'));
    for (final cdcOnly in ['Zoster', 'RSV', 'Meningococcal B', 'Varicella']) {
      expect(who, isNot(contains(cdcOnly)), reason: cdcOnly);
    }
  });

  test('CDC mode evaluates exactly the CDC antigen set', () {
    expect(evaluated(ForecastMode.cdc), antigenSupportingDataMap.keys.toSet());
  });

  test('WHO mode schedules HepB from the WHO series, not the CDC ones', () {
    final used = [
      for (final group
          in evaluateForForecast(
            parameters,
            mode: ForecastMode.who,
          ).agMap['HepB']!.groups.values)
        for (final vaxSeries in group.series) vaxSeries.series,
    ];
    final who = whoAntigenSupportingDataMap['HepB']!.series!;
    final cdc = antigenSupportingDataMap['HepB']!.series!;
    expect(used, isNotEmpty);
    for (final series in used) {
      expect(who.any((s) => identical(s, series)), isTrue);
      expect(cdc.any((s) => identical(s, series)), isFalse);
    }
  });
}
