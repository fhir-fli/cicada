import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod/riverpod.dart';

import '../cicada.dart';

typedef ForecastResult = ({VaxPatient patient, Map<String, VaxAntigen> agMap});

Bundle forecastFromMap(Map<String, dynamic> parameters) {
  if (parameters['resourceType'] == 'Parameters') {
    final Parameters newParameters = Parameters.fromJson(parameters);
    return forecastFromParameters(newParameters);
  }
  return const Bundle(type: BundleType.transaction);
}

ForecastResult evaluateForForecast(Parameters parameters) {
  final ProviderContainer container = ProviderContainer();

  /// Parse out and organize all of the information from input parameters
  final VaxPatient patient = container.read(
    patientForAssessmentProvider(parameters),
  );

  container.read(observationsProvider.notifier).setValue(patient.observations);

  /// Create an agMap that we can work from to evaluate past vaccines
  /// we pass in a list of all past vaccines, the patient's gender
  final Map<String, VaxAntigen> agMap = antigenMap(patient);

  /// Sort into groups
  agMap.forEach((String k, VaxAntigen v) {
    v.groups.forEach((String key, VaxGroup value) {
      container
          .read(seriesGroupCompleteProvider.notifier)
          .newSeriesGroup(k, key);
    });
  });

  /// Evaluate
  agMap.forEach((String k, VaxAntigen v) => v.evaluate());

  /// Forecast
  agMap.forEach((String k, VaxAntigen v) => v.forecast());

  return (patient: patient, agMap: agMap);
}

Bundle forecastFromParameters(Parameters parameters) {
  evaluateForForecast(parameters);
  return Bundle(type: BundleType.transaction);
}
