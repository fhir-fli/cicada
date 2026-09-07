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
// With no argument it writes straight into cicada_ig/input/resources, and
// alongside the recommendation writes the rest of the case as examples of
// the request and response profiles: the Patient (vax-patient), the
// Immunization (vax-dose), the Condition (VaccineConditionFhir), and every
// ImmunizationEvaluation the engine returned (target-dose-status-ext,
// evaluation-detail-ext). With an argument only the recommendation is
// written, to that path.
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
  if (args.isNotEmpty) return;

  const sd = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition';
  final dir = '../cicada_ig/input/resources';
  void write(String name, Map<String, dynamic> j) {
    File('$dir/$name.json').writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(j)}\n');
    stdout.writeln('wrote $name');
  }

  // The request side, straight from the CDC case, with the profile stamped.
  for (final p in decoded['parameter'] as List<dynamic>) {
    final r = (p as Map<String, dynamic>)['resource'] as Map<String, dynamic>?;
    if (r == null) continue;
    switch (r['resourceType']) {
      case 'Patient':
        r['meta'] = {'profile': ['$sd/vax-patient']};
        write('Patient-${r['id']}', r);
      case 'Immunization':
        // CDC's ids carry an underscore, which the FHIR id pattern
        // [A-Za-z0-9\-\.]{1,64} does not allow; the evaluations below refer
        // to the renamed id.
        r['id'] = (r['id'] as String).replaceAll('_', '-');
        r['meta'] = {'profile': ['$sd/vax-dose']};
        write('Immunization-${r['id']}', r);
      case 'Condition':
        final codings = (r['code'] as Map)['coding'] as List;
        final code = codings.first as Map;
        // CDC writes SNOMED displays with the semantic tag, "Healthcare
        // professional [occupation]"; the term itself is the display.
        for (final c in codings) {
          final d = (c as Map)['display'];
          if (c['system'] == 'http://snomed.info/sct' && d is String) {
            c['display'] = d.replaceAll(RegExp(r'\s*\[[^\]]*\]\s*$'), '');
          }
        }
        r['id'] = '2016-UC-0032-${code['code']}';
        r['meta'] = {'profile': ['$sd/VaccineConditionFhir']};
        r['subject'] = {'reference': 'Patient/2016-UC-0032'};
        write('Condition-${r['id']}', r);
    }
  }

  // The response side: every evaluation the engine returned for the case.
  var n = 0;
  for (final p in response.parameter!) {
    if (p.name.valueString != 'evaluation') continue;
    final e = p.resource! as ImmunizationEvaluation;
    n++;
    final j = e.copyWith(id: '2016-UC-0032-$n'.toFhirString).toJson();
    // Point at the renamed Immunization example (underscore to hyphen).
    final ev = j['immunizationEvent'] as Map<String, dynamic>?;
    if (ev != null && ev['reference'] is String) {
      ev['reference'] = (ev['reference'] as String).replaceAll('_', '-');
    }
    write('ImmunizationEvaluation-2016-UC-0032-$n', j);
  }
}
