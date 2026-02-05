import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod/riverpod.dart';

import '../generated_files/test_doses.dart';
import '../cicada.dart';

Bundle forecastFromMap(Map<String, dynamic> parameters) {
  if (parameters['resourceType'] == 'Parameters') {
    final Parameters newParameters = Parameters.fromJson(parameters);
    return forecastFromParameters(newParameters);
  }
  return const Bundle(type: BundleType.transaction);
}

Bundle forecastFromParameters(Parameters parameters) {
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
    // print('k: $k');
    v.groups.forEach((String key, VaxGroup value) {
      // print('key: $key');
      container
          .read(seriesGroupCompleteProvider.notifier)
          .newSeriesGroup(k, key);
    });
  });

  /// Evaluate
  agMap.forEach((String k, VaxAntigen v) => v.evaluate());

  /// Forecast
  agMap.forEach((String k, VaxAntigen v) => v.forecast());

  final List<VaxDose>? evaluatedDoses = testDoses[patient.patient.id.toString()]
      ?.map((Map<String, Object> e) => VaxDose.fromJson(e))
      .toList();

  bool disagree = false;
  agMap.forEach((String k, VaxAntigen v) {
    if (evaluatedDoses != null &&
        evaluatedDoses.isNotEmpty &&
        evaluatedDoses.first.antigens
            .map((String e) => e.toLowerCase())
            .toList()
            .contains(k.toLowerCase())) {
      print(k);
      v.groups.forEach((String key, VaxGroup value) {
        final List<VaxSeries>? bestSeries;
        if (value.bestSeries != null) {
          bestSeries = <VaxSeries>[value.bestSeries!];
        } else {
          bestSeries = value.prioritizedSeries;
        }

        for (final VaxSeries element in bestSeries) {
          for (int i = 0; i < element.evaluatedDoses.length; i++) {
            if (evaluatedDoses[i].validity !=
                    element.evaluatedDoses[i].validity &&
                !element.evaluatedDoses[i].validity.startsWith(
                  evaluatedDoses[i].validity,
                )) {
              disagree = true;
              throw Exception(
                '${element.series.seriesName}\n'
                'Mismatch on patient ${patient.patient.id} - Dose: ${i + 1}\n'
                'Official: ${evaluatedDoses[i].validity}\n'
                'Cicada: ${element.evaluatedDoses[i].validity}\n',
              );
            }
          }
        }
      });
    }
  });

  return Bundle(
    id: (disagree ? '1' : '0').toFhirString,
    type: BundleType.transaction,
  );
}
