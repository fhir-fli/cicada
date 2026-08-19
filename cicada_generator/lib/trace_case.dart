// Runs one CDSi test case with the engine's trace switched on, and prints what
// the engine decided at each step of the specification's pipeline — so a wrong
// answer can be located at the step where it first diverged.
//
// The trace itself lives in the engine (`ForecastTrace`, cicada/lib/utils),
// off by default. This tool just turns it on, runs a case, and renders it
// alongside what CDC expects.
//
// Usage:
//   dart cicada_generator/lib/trace_case.dart <caseId> [subjectFilter]
//
// The filter narrows to entries whose subject contains the text — usually an
// antigen ("Pertussis") or a vaccine group ("DTaP"). Output goes to stdout and
// to scratch/trace-<caseId>.txt, written with a synchronous append per line so
// a truncated pipe cannot lose it.
import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';

late File log;

void say(String line) {
  log.writeAsStringSync('$line\n', mode: FileMode.append);
  stdout.writeln(line);
}

Parameters? findCase(String id) {
  for (final String path in <String>[
    'cicada/test/healthyTestCases.ndjson',
    'cicada/test/conditionTestCases.ndjson',
  ]) {
    final File file = File(path);
    if (!file.existsSync()) continue;
    for (final String line in file.readAsLinesSync()) {
      if (line.trim().isEmpty) continue;
      final Map<String, dynamic> decoded =
          jsonDecode(line) as Map<String, dynamic>;
      for (final dynamic p
          in (decoded['parameter'] as List<dynamic>? ?? <dynamic>[])) {
        final Map<String, dynamic> param = p as Map<String, dynamic>;
        if (param.containsKey('resource')) {
          final Map<String, dynamic> r =
              param['resource'] as Map<String, dynamic>;
          if (r['resourceType'] == 'Immunization' && !r.containsKey('status')) {
            r['status'] = 'completed';
          }
        }
      }
      final Parameters params = Parameters.fromJson(decoded);
      final Patient? patient = params.parameter
          ?.firstWhereOrNull((ParametersParameter e) => e.resource is Patient)
          ?.resource as Patient?;
      if (patient?.id?.toString() == id) {
        say('case found in $path');
        return params;
      }
    }
  }
  return null;
}

void main(List<String> args) {
  if (args.isEmpty) {
    stdout.writeln('usage: trace_case.dart <caseId> [subjectFilter]');
    exit(64);
  }
  final String id = args.first;
  final String? filter = args.length > 1 ? args[1] : null;

  log = File('scratch/trace-$id.txt');
  log.parent.createSync(recursive: true);
  log.writeAsStringSync('');

  say('CDSi trace for $id'
      '${filter == null ? "" : "  (subject filter: $filter)"}');

  final Parameters? params = findCase(id);
  if (params == null) {
    say('no such case in either test-case file');
    exit(1);
  }

  final ForecastTrace trace = ForecastTrace.begin();
  final result = evaluateForForecast(params);
  ForecastTrace.end();

  say('');
  say('birthdate  ${result.patient.birthdate}');
  say('assessment ${result.patient.assessmentDate}');
  say('gender     ${result.patient.gender}');
  say('');

  say(trace.render(subjectFilter: filter));

  say('──────────── final vaccine group forecasts');
  if (result.vaccineGroupForecasts.isEmpty) say('  none');
  result.vaccineGroupForecasts.forEach((String groupName, f) {
    if (filter != null &&
        !groupName.toLowerCase().contains(filter.toLowerCase())) {
      return;
    }
    say('  $groupName  status=${f.status}  dose#=${f.doseNumber}');
    say('      earliest=${f.earliestDate}  recommended=${f.recommendedDate}  '
        'pastDue=${f.pastDueDate}');
  });

  say('');
  say('written to ${log.path}');
}
