import 'package:cicada_flutter/src/models/forecast_category.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:cicada_flutter/src/models/sample_patients.dart';
import 'package:cicada_flutter/src/services/forecast_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// The app's forecast service over the engine, on the sample patients the
/// app ships: each answer is asserted, nothing is printed.
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
    for (final f in result.vaccineGroupForecasts.values.expand((l) => l)) {
      expect(
        () => categorize(f, result.patient.assessmentDate),
        returnsNormally,
        reason: f.vaccineGroupName,
      );
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
    for (final f in result.vaccineGroupForecasts.values.expand((l) => l)) {
      final cat = categorize(f, result.patient.assessmentDate);
      cats.putIfAbsent(cat, () => []).add(f.vaccineGroupName);
    }

    // Baby should have SOME due now and SOME upcoming — not all due.
    final actionable = cats.entries
        .where((e) => e.key.isActionable)
        .expand((e) => e.value);
    final upcoming = cats[ForecastCategory.upcoming] ?? [];

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
    for (final f in result.vaccineGroupForecasts.values.expand((l) => l)) {
      final cat = categorize(f, result.patient.assessmentDate);
      cats.putIfAbsent(cat, () => []).add(f.vaccineGroupName);
    }

    final complete = [
      ...cats[ForecastCategory.complete] ?? [],
      ...cats[ForecastCategory.immune] ?? [],
    ];
    expect(complete, isNotEmpty, reason: 'Adult should have completed series');
  });
}
