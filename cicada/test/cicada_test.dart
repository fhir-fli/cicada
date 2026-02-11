import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_bulk/fhir_r4_bulk.dart';
import 'package:cicada/forecast/forecast.dart';

Future<void> main() async {
  final List<Resource> parameters =
      await FhirBulk.fromFile('healthyTestCases.ndjson');
  for (int i = 0; i < parameters.length; i++) {
    final Patient? patient = (parameters[i] as Parameters)
        .parameter
        ?.firstWhereOrNull((ParametersParameter e) => e.resource is Patient)
        ?.resource as Patient?;
    print('ID: ${patient?.id}');
    final Parameters result =
        forecastFromParameters(parameters[i] as Parameters);
    // Verify the output contains a recommendation
    final hasRecommendation = result.parameter?.any(
            (p) => p.name?.toString() == 'recommendation') ??
        false;
    if (!hasRecommendation) {
      print('  WARNING: No recommendation in output');
    }
  }
  print('Done');
}
