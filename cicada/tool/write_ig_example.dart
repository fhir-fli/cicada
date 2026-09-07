// Regenerates the IG's ImmunizationRecommendation example from the engine.
//
// The example (cicada_ig/input/resources/ImmunizationRecommendation-
// cicada-forecast-example.json) is the engine's real forecast for CDSi
// condition case 2016-UC-0032, all 17 recommendations. It was first produced
// by hand on 2026-08-28 (82ad790a); this tool exists so that any change to
// what the engine emits is carried into the IG by running it again, instead
// of editing the JSON.
//
//   cd cicada/cicada && dart run tool/write_ig_example.dart [output-path]
//
// With no argument it writes straight into cicada_ig/input/resources.
import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';

const String caseId = 'parameters-2016-UC-0032';
const String exampleId = 'cicada-forecast-example';
const String profile =
    'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/cicada-immunization-recommendation';

void main(List<String> args) {
  final outPath = args.isNotEmpty
      ? args.first
      : '../cicada_ig/input/resources/ImmunizationRecommendation-$exampleId.json';

  final line = File('test/conditionTestCases.ndjson')
      .readAsLinesSync()
      .firstWhere((l) => l.contains('"$caseId"'));
  final decoded = jsonDecode(line) as Map<String, dynamic>;
  // Same normalisation the test suite applies: CDC rows omit Immunization.status.
  for (final p in decoded['parameter'] as List<dynamic>) {
    final param = p as Map<String, dynamic>;
    final resource = param['resource'] as Map<String, dynamic>?;
    if (resource != null &&
        resource['resourceType'] == 'Immunization' &&
        !resource.containsKey('status')) {
      resource['status'] = 'completed';
    }
  }

  final result = evaluateForForecast(Parameters.fromJson(decoded));
  final response = buildImmdsResponse(result);
  final rec = response.parameter!
      .firstWhere((p) => p.name.valueString == 'recommendation')
      .resource! as ImmunizationRecommendation;

  final out = rec.copyWith(
    id: exampleId.toFhirString,
    meta: FhirMeta(profile: [profile.toFhirCanonical]),
    patient: Reference(reference: 'Patient/2016-UC-0032'.toFhirString),
  );
  final json = const JsonEncoder.withIndent('  ').convert(out.toJson());
  File(outPath).writeAsStringSync('$json\n');
  stdout.writeln('wrote ${out.recommendation.length} recommendations to $outPath');
}
