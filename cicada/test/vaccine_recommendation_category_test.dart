// CDC's four worked examples from "Vaccine Recommendation Category
// Determination" (CDSi supporting data 4.65), run against the real
// supporting data. CDC's "HPV standard series" is HPV 3-dose series here: a
// 28-year-old who has just started HPV is on the three-dose schedule, and
// the two category rows CDC quotes (Routine to 27 years, SCDM 27 to 46) are
// that series' rows.
import 'package:cicada/cicada.dart';
import 'package:test/test.dart';

VaccineRecommendationCategoryResult? run({
  required String antigen,
  required String series,
  required String age,
  required int dose,
  Set<String> codes = const {},
  SeriesStatus status = SeriesStatus.notComplete,
}) {
  final data = antigenSupportingDataMap[antigen]!;
  final s = data.series!.firstWhere((s) => s.seriesName == series);
  final birth = VaxDate(2000, 1, 1);
  return determineVaccineRecommendationCategory(
    antigen: data,
    seriesName: series,
    status: status,
    forecastTargetDoseNumber: dose,
    birthdate: birth,
    assessmentDate: birth.change(age),
    patientObservationCodes: codes,
    seriesIndications: s.indication ?? const [],
  );
}

void main() {
  test('Basic Example: Pneumococcal 4-dose, 4 months, dose 2, no risk -> Routine',
      () {
    final r = run(
        antigen: 'Pneumococcal',
        series: 'Pneumococcal 4-dose series',
        age: '4 months',
        dose: 2);
    expect(r?.category, 'Routine');
    expect(r?.material.single, contains('cdc.gov/pneumococcal'));
  });

  test('Intermediate Example: HPV, 28 years, dose 2, no risk -> SCDM', () {
    final r = run(
        antigen: 'HPV', series: 'HPV 3-dose series', age: '28 years', dose: 2);
    expect(r?.category, 'SCDM');
  });

  test('the same series at 26 years is Routine (End Age is "less than")', () {
    expect(
        run(antigen: 'HPV', series: 'HPV 3-dose series', age: '26 years', dose: 2)
            ?.category,
        'Routine');
    expect(
        run(antigen: 'HPV', series: 'HPV 3-dose series', age: '27 years', dose: 2)
            ?.category,
        'SCDM');
  });

  test('Complex Example #1: HepB risk 3-dose, 60 years, Diabetes only -> SCDM',
      () {
    final r = run(
        antigen: 'HepB',
        series: 'HepB risk 3-dose series',
        age: '60 years',
        dose: 1,
        codes: {'014'});
    expect(r?.category, 'SCDM');
  });

  test('Complex Example #2: HepB risk 3-dose, 60 years, Diabetes + HIV -> High-Risk',
      () {
    final r = run(
        antigen: 'HepB',
        series: 'HepB risk 3-dose series',
        age: '60 years',
        dose: 1,
        codes: {'014', '186'});
    expect(r?.category, 'High-Risk');
  });

  test('No Rows Determined: a series with no row for the patient has no category',
      () {
    // The HepB risk 3-dose rows begin at 60 years.
    final r = run(
        antigen: 'HepB',
        series: 'HepB risk 3-dose series',
        age: '40 years',
        dose: 1,
        codes: {'014', '186'});
    expect(r, isNull);
  });

  test('Patient Not Recommended Further Vaccination: only Not Complete has one',
      () {
    for (final status in SeriesStatus.values) {
      final r = run(
          antigen: 'Pneumococcal',
          series: 'Pneumococcal 4-dose series',
          age: '4 months',
          dose: 2,
          status: status);
      expect(r == null, status != SeriesStatus.notComplete,
          reason: 'status $status');
    }
  });
}
