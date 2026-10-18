import 'package:cicada/cicada.dart';
import 'package:test/test.dart';

/// CDSi Logic Specification v4.6 (logic-spec-acip-rec-4.6.txt): Date of
/// Birth is an attribute of Table 5-2 (select relevant patient series),
/// Table 6-14 (evaluate age) and Table 7-2 (evidence of immunity), and in
/// each its "Assumed Value if Empty" is "-", none; Gender's, beside it in
/// Table 5-2, is "Unknown". Every age the engine computes is the date of
/// birth plus an interval (Table 3-6, CALCDTAGE-4: "A patient's minimum age
/// date must be calculated as the patient's date of birth plus the minimum
/// age").
///
/// fhirant REVIEW-2026-10-17 finding 7: a Patient with no birthDate was
/// forecast as if born 1900-01-01, a date no specification names (16
/// recommendations returned). With no date of birth there is no age to
/// evaluate or forecast from, so the engine refuses, as it does for a
/// missing Patient.
void main() {
  Map<String, dynamic> parameters(Map<String, dynamic> patient) => {
    'resourceType': 'Parameters',
    'parameter': [
      {'name': 'assessmentDate', 'valueDate': '2026-10-18'},
      {'name': 'patient', 'resource': patient},
    ],
  };

  for (final mode in ForecastMode.values) {
    test('$mode: a Patient with no birthDate is refused', () {
      expect(
        () => forecastFromMap(
          parameters({'resourceType': 'Patient', 'id': 'nobd'}),
          mode: mode,
        ),
        throwsA(anything),
      );
    });

    test('$mode: control, a Patient with a birthDate is forecast', () {
      final result = forecastFromMap(
        parameters({
          'resourceType': 'Patient',
          'id': 'bd',
          'birthDate': '2025-01-01',
        }),
        mode: mode,
      );
      expect(result.parameter, isNotEmpty);
    });
  }
}
