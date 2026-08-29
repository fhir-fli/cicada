import 'package:cicada/cicada.dart';
import 'package:cicada_flutter/src/models/forecast_category.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:cicada_flutter/src/models/sample_patients.dart';
import 'package:cicada_flutter/src/services/forecast_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('forecast runs for empty dose list (newborn)', () {
    final result = ForecastService.runForecast(
      patientInfo: PatientInfo(
        birthDate: DateTime(2025, 9, 22),
        sex: PatientSex.male,
      ),
      doses: [],
    );

    expect(result.vaccineGroupForecasts, isNotEmpty);
    print('Vaccine groups: ${result.vaccineGroupForecasts.length}');
    for (final f in result.vaccineGroupForecasts.values
        .expand((List<VaccineGroupForecast> l) => l)) {
      final cat = categorize(f, result.patient.assessmentDate);
      print('  ${f.vaccineGroupName}: ${cat.displayLabel}');
    }
  });

  test('baby categorization separates due now from upcoming', () {
    final samples = getSamplePatients();
    final baby = samples.first;

    final result = ForecastService.runForecast(
      patientInfo: baby.info,
      doses: baby.doses,
    );

    final cats = <ForecastCategory, List<String>>{};
    for (final f in result.vaccineGroupForecasts.values
        .expand((List<VaccineGroupForecast> l) => l)) {
      final cat = categorize(f, result.patient.assessmentDate);
      cats.putIfAbsent(cat, () => []).add(f.vaccineGroupName);
    }

    print('\n--- ${baby.name} ---');
    for (final entry in cats.entries) {
      print('  ${entry.key.displayLabel}: ${entry.value.join(", ")}');
    }

    // Baby should have SOME due now and SOME upcoming — not all due.
    final actionable =
        cats.entries.where((e) => e.key.isActionable).expand((e) => e.value);
    final upcoming = cats[ForecastCategory.upcoming] ?? [];

    print('\n  Actionable: ${actionable.length}');
    print('  Upcoming: ${upcoming.length}');

    expect(actionable, isNotEmpty, reason: 'Baby should have some due now');
    expect(upcoming, isNotEmpty, reason: 'Baby should have some upcoming');
  });

  test('adult categorization shows complete vaccines', () {
    final samples = getSamplePatients();
    final adult = samples.last;

    final result = ForecastService.runForecast(
      patientInfo: adult.info,
      doses: adult.doses,
    );

    final cats = <ForecastCategory, List<String>>{};
    for (final f in result.vaccineGroupForecasts.values
        .expand((List<VaccineGroupForecast> l) => l)) {
      final cat = categorize(f, result.patient.assessmentDate);
      cats.putIfAbsent(cat, () => []).add(f.vaccineGroupName);
    }

    print('\n--- ${adult.name} ---');
    for (final entry in cats.entries) {
      print('  ${entry.key.displayLabel}: ${entry.value.join(", ")}');
    }

    final complete = [
      ...cats[ForecastCategory.complete] ?? [],
      ...cats[ForecastCategory.immune] ?? [],
    ];
    expect(complete, isNotEmpty, reason: 'Adult should have completed series');
  });
}
