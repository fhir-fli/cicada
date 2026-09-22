// Everything about one CDSi test case, in one place, for a human to check.
//
// The suites compare the engine against generated expectations, and the
// generator transcribes CDC's workbook. That is two transcriptions between the
// published spreadsheet and a pass/fail, and neither is visible when a case
// passes. This prints all four layers for one case so they can be read against
// each other by eye:
//
//   1. CDC's workbook row, every populated column, exactly as published
//   2. the input the engine is actually given (the NDJSON case)
//   3. what the engine answered — every dose in every series it was evaluated
//      against, and every vaccine group forecast
//   4. the generated expectations the suite compares against, and whether each
//      compared field matches
//
// Usage: dart cicada_generator/lib/audit_case.dart <caseId> [caseId...]
//
// Output goes to stdout and to scratch/audit-<caseId>.txt, appended a line at a
// time so a killed run still leaves everything it had reached.
import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/test_condition_doses.dart';
import 'package:cicada/generated_files/test_condition_forecasts.dart';
import 'package:cicada/generated_files/test_doses.dart';
import 'package:cicada/generated_files/test_forecasts.dart';
import 'package:cicada_generator/cdc_row_collapse.dart';
import 'package:cicada_generator/repo_root.dart';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:fhir_r4/fhir_r4.dart';

late File log;

void say(String line) {
  log.writeAsStringSync('$line\n', mode: FileMode.append);
  stdout.writeln(line);
}

String cell(List<Data?> row, int i) =>
    i < row.length ? (row[i]?.value?.toString() ?? '').trim() : '';

/// Dates arrive from Excel as full ISO timestamps; the time is never
/// meaningful.
String tidy(String v) {
  final d = DateTime.tryParse(v);
  if (d == null) return v;
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

/// Excel vaccine-group label → engine vaccine-group name, both workbooks.
const Map<String, String> groupMap = <String, String>{
  'DTAP': 'DTaP/Tdap/Td',
  'Td': 'DTaP/Tdap/Td',
  'FLU': 'Influenza',
  'HIB': 'Hib',
  'MCV': 'Meningococcal',
  'MENB': 'Meningococcal B',
  'PCV': 'Pneumococcal',
  'POL': 'Polio',
  'ROTA': 'Rotavirus',
  'VAR': 'Varicella',
  'ZOSTER': 'Zoster',
  'DTaP': 'DTaP/Tdap/Td',
  'Flu': 'Influenza',
  'IPOL': 'Polio',
  'Rota': 'Rotavirus',
};

class Suite {
  const Suite(
    this.name,
    this.ndjson,
    this.xlsx,
    this.sheet,
    this.forecasts,
    this.doses,
  );

  final String name;
  final String ndjson;
  final String xlsx;
  final String sheet;
  final Map<String, List<Map<String, String>>> forecasts;
  final Map<String, List<Map<String, Object>>> doses;
}

final List<Suite> suites = <Suite>[
  Suite(
    'healthy childhood and adult (v4.46)',
    repoPath('cicada/test/healthyTestCases.ndjson'),
    repoPath(
      'cicada_generator/lib/test_cases/'
      'cdsi-healthy-childhood-and-adult-test-cases-v4.46.xlsx',
    ),
    'FITS Exported TestCases',
    testForecasts,
    testDoses,
  ),
  Suite(
    'underlying conditions (v4.6)',
    repoPath('cicada/test/conditionTestCases.ndjson'),
    repoPath(
      'cicada_generator/lib/test_cases/'
      'CDSi-underlying-conditions-test-cases-v4.6.xlsx',
    ),
    'Underlying Condition Test Cases',
    testConditionForecasts,
    testConditionDoses,
  ),
];

/// The raw NDJSON line for [id], so the input can be read as the engine gets
/// it.
Map<String, dynamic>? rawCase(String path, String id) {
  if (!File(path).existsSync()) return null;
  for (final line in File(path).readAsLinesSync()) {
    if (line.trim().isEmpty) continue;
    final decoded = jsonDecode(line) as Map<String, dynamic>;
    for (final dynamic p
        in (decoded['parameter'] as List<dynamic>? ?? <dynamic>[])) {
      final param = p as Map<String, dynamic>;
      if (param.containsKey('resource')) {
        final r = param['resource'] as Map<String, dynamic>;
        if (r['resourceType'] == 'Immunization' && !r.containsKey('status')) {
          r['status'] = 'completed';
        }
        if (r['resourceType'] == 'Patient' && r['id']?.toString() == id) {
          return decoded;
        }
      }
    }
  }
  return null;
}

/// Marks a compared field, so a wrong answer cannot be read as a right one.
String verdict(String expected, String actual) {
  if (expected.isEmpty) return '(not tested)';
  return expected == actual ? 'MATCH' : '*** DIFFERS ***';
}

void auditOne(String id) {
  log = File(repoPath('scratch/audit-$id.txt'));
  log.parent.createSync(recursive: true);
  log.writeAsStringSync('');

  Suite? suite;
  Map<String, dynamic>? raw;
  for (final s in suites) {
    raw = rawCase(s.ndjson, id);
    if (raw != null) {
      suite = s;
      break;
    }
  }
  if (suite == null || raw == null) {
    say('no case "$id" in either test-case file');
    return;
  }

  say('═══ $id — ${suite.name}');
  say('');

  // ---- 1. CDC's workbook row, as published -------------------------------
  say('──── 1. CDC workbook row (${suite.xlsx.split("/").last})');
  final excel = Excel.decodeBytes(File(suite.xlsx).readAsBytesSync());
  final sheet = excel.tables[suite.sheet];
  if (sheet == null) {
    say('  sheet "${suite.sheet}" not in the workbook');
  } else {
    final headers =
        sheet.rows.first
            .map((c) => (c?.value?.toString() ?? '').trim())
            .toList();
    final row = sheet.rows
        .skip(1)
        .firstWhereOrNull(
          (r) => cell(r, 0) == id || cell(r, 0) == id.trim(),
        );
    if (row == null) {
      say('  no row with this id');
    } else {
      for (var i = 0; i < headers.length; i++) {
        final h = headers[i];
        final v = cell(row, i);
        if (h.isEmpty || v.isEmpty) continue;
        final isDate =
            h.toLowerCase().contains('date') || h.toLowerCase() == 'dob';
        say('  ${h.padRight(26)} ${isDate ? tidy(v) : v}');
      }
    }
  }
  say('');

  // ---- 2. what the engine is actually given ------------------------------
  say(
    '──── 2. input as the engine receives it (${suite.ndjson.split("/").last})',
  );
  final parameters = raw['parameter'] as List<dynamic>? ?? <dynamic>[];
  for (final dynamic p in parameters) {
    final param = p as Map<String, dynamic>;
    final r = param['resource'] as Map<String, dynamic>?;
    if (r == null) {
      say('  assessment date parameter: ${param["name"]}');
      continue;
    }
    switch (r['resourceType']) {
      case 'Patient':
        say('  Patient    dob=${r["birthDate"]}  gender=${r["gender"]}');
      case 'Immunization':
        final codings =
            ((r['vaccineCode'] as Map<String, dynamic>?)?['coding']
                as List<dynamic>?) ??
            <dynamic>[];
        String codeFor(String system) =>
            (codings.firstWhereOrNull(
                      (dynamic c) => (c as Map<String, dynamic>)['system']
                          .toString()
                          .contains(system),
                    )
                    as Map<String, dynamic>?)?['code']
                ?.toString() ??
            '-';
        say(
          '  Immunization ${r["id"]}  given=${r["occurrenceDateTime"]}  '
          'cvx=${codeFor("cvx")}  mvx=${codeFor("mvx")}  '
          'status=${r["status"]}',
        );
      case 'Condition':
        final codings =
            ((r['code'] as Map<String, dynamic>?)?['coding']
                as List<dynamic>?) ??
            <dynamic>[];
        for (final dynamic c in codings) {
          final coding = c as Map<String, dynamic>;
          say(
            '  Condition   ${coding["code"]}  ${coding["display"]}  '
            '(${coding["system"]})',
          );
        }
      default:
        say('  ${r["resourceType"]}');
    }
  }
  say('');

  // ---- 3. what the engine answered ---------------------------------------
  final params = Parameters.fromJson(raw);
  final result = evaluateForForecast(params);

  say('──── 3. engine output');
  say(
    '  patient dob=${result.patient.birthdate} '
    'assessment=${result.patient.assessmentDate} '
    'gender=${result.patient.gender}',
  );
  say('');
  say('  dose evaluation, every series each dose was tried against:');
  var anyDose = false;
  result.agMap.forEach((antigenName, antigen) {
    antigen.groups.forEach((_, group) {
      for (final series in group.series) {
        for (final dose in series.doses) {
          if (dose.evalStatus == null) continue;
          anyDose = true;
          say(
            '    $antigenName / ${series.series.seriesName} '
            '[${series.series.seriesType}]',
          );
          say(
            '        ${dose.doseId} given=${dose.dateGiven} '
            'cvx=${dose.cvx} mvx=${dose.mvx ?? "-"} '
            'targetDose=${dose.targetDoseSatisfied}',
          );
          say(
            '        status=${dose.evalStatus} reason=${dose.evalReason} '
            'age=${dose.validAgeReason} '
            'prefInt=${dose.preferredIntervalReason} '
            'allowInt=${dose.allowedIntervalReason} '
            'prefVax=${dose.preferredVaccine} allowVax=${dose.allowedVaccine} '
            'conflict=${dose.conflict} inadvertent=${dose.inadvertent}',
          );
        }
      }
    });
  });
  if (!anyDose) say('    (no dose was evaluated in any series)');
  say('');
  say('  vaccine group forecasts:');
  if (result.vaccineGroupForecasts.isEmpty) say('    (none)');
  result.vaccineGroupForecasts.forEach((
    groupName,
    fs,
  ) {
    // A group can carry a risk forecast and a standard one. Show both.
    for (final f in fs) {
      final kind =
          fs.length == 1 ? '' : (f.isRiskForecast ? ' [risk]' : ' [standard]');
      say(
        '    ${groupName.padRight(16)}$kind status=${f.status} '
        'dose#=${f.doseNumber} earliest=${f.earliestDate} '
        'recommended=${f.recommendedDate} pastDue=${f.pastDueDate}',
      );
    }
  });
  say('');

  // ---- 4. the expectations the suite compares against --------------------
  say('──── 4. generated expectations, and every field the suite compares');
  final expectedDoses = suite.doses[id] ?? const <Map<String, Object>>[];
  if (expectedDoses.isEmpty) say('  no expected doses for this case');
  for (final doseMap in expectedDoses) {
    final expected = VaxDose.fromJson(doseMap);
    final expectedSeriesType = doseMap['seriesType'] as String?;
    final actuals = <String>[];
    result.agMap.forEach((antigenName, antigen) {
      if (!expected.antigens
          .map((s) => s.toLowerCase())
          .contains(antigenName.toLowerCase())) {
        return;
      }
      antigen.groups.forEach((_, group) {
        for (final series in group.series) {
          if (expectedSeriesType != null && series.series.seriesType != null) {
            final actualType =
                series.series.seriesType.toString().toLowerCase();
            if (actualType != expectedSeriesType) continue;
          }
          final actual = series.doses.firstWhereOrNull(
            (d) => d.doseId == expected.doseId,
          );
          if (actual == null || actual.evalStatus == null) continue;
          actuals.add(
            '${series.series.seriesName}: '
            '${actual.evalStatus}/${actual.evalReason}',
          );
        }
      });
    });
    say(
      '  dose ${expected.doseId} given=${expected.dateGiven} '
      'seriesType=${expectedSeriesType ?? "-"}',
    );
    say(
      '      CDC expects ${expected.evalStatus}'
      '${expected.evalReason == null ? "" : "/${expected.evalReason}"}',
    );
    say(
      '      engine gave ${actuals.isEmpty ? "NOTHING — dose was not "
              "evaluated in any matching series" : actuals.join("; ")}',
    );
  }
  say('');
  final expectedForecasts =
      suite.forecasts[id] ?? const <Map<String, String>>[];
  if (expectedForecasts.isEmpty) say('  no expected forecasts for this case');
  for (final expected in expectedForecasts) {
    final excelGroup = expected['vaccineGroup']!.trim();
    final engineGroup = groupMap[excelGroup] ?? excelGroup;
    final all = result.vaccineGroupForecasts[engineGroup];
    // CDC records one row per group, so compare against the collapsed one.
    final f = collapseForComparison(all);
    say('  [$excelGroup → $engineGroup]');
    if (all != null && all.length > 1) {
      say(
        '      engine emitted ${all.length} forecasts for this group '
        '(risk and standard); comparing against the '
        '${f!.isRiskForecast ? "risk" : "standard"} one',
      );
    }
    if (f == null) {
      say('      engine produced NO forecast for this vaccine group');
      continue;
    }
    void line(String label, String expectedValue, String actualValue) {
      final expected = expectedValue.isEmpty ? '-' : expectedValue;
      final actual = actualValue.isEmpty ? '-' : actualValue;
      say(
        '      ${label.padRight(12)} expected=$expected'
        '  actual=$actual  '
        '${verdict(expectedValue, actualValue)}',
      );
    }

    line(
      'status',
      expected['seriesStatus']?.toLowerCase() ?? '',
      f.status.toString().toLowerCase(),
    );
    final expectedNum = expected['forecastNum'] ?? '';
    line(
      'dose #',
      expectedNum == '-' ? '' : expectedNum,
      f.doseNumber?.toString() ?? '',
    );
    line(
      'earliest',
      expected['earliestDate'] ?? '',
      f.earliestDate?.toString() ?? '',
    );
    line(
      'recommended',
      expected['recommendedDate'] ?? '',
      f.recommendedDate?.toString() ?? '',
    );
    line(
      'past due',
      expected['pastDueDate'] ?? '',
      f.pastDueDate?.toString() ?? '',
    );
  }
  say('');
  say('written to ${log.path}');
  say('');
}

void main(List<String> args) {
  if (args.isEmpty) {
    stdout.writeln('usage: audit_case.dart <caseId> [caseId...]');
    exit(64);
  }
  args.forEach(auditOne);
}
