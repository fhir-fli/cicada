import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_bulk/fhir_r4_bulk.dart';
import 'package:cicada/forecast/forecast.dart';

Future<void> main() async {
  final List<Resource> parameters =
      await FhirBulk.fromFile('healthyTestCases.ndjson');
  int totalDisagreements = 0;
  for (int i = 0; i < parameters.length; i++) {
    final Patient? patient = (parameters[i] as Parameters)
        .parameter
        ?.firstWhereOrNull((ParametersParameter e) => e.resource is Patient)
        ?.resource as Patient?;
    print('ID: ${patient?.id}');
    final Bundle bundle = forecastFromParameters(parameters[i] as Parameters);
    totalDisagreements += int.parse(bundle.id?.toString() ?? '0');
  }
  print('Total Disagreements: $totalDisagreements');
}
