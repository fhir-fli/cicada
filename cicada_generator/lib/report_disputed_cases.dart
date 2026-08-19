// Generates CDSI-DISPUTED-CASES.md.
//
// For every case where cicada disagrees with the CDC test data, print CDC's own
// row verbatim: every populated column with its header, exactly as published.
// Then one line for what cicada answered, so the disagreement is visible.
//
// Usage: dart cicada_generator/lib/report_disputed_cases.dart [conditionIds...]
// The healthy ids are the list below; update it when the failures change.
//
// Writes with a synchronous append per line — an IOSink with a per-line
// flush() throws "StreamSink is bound to a stream", and piping the run through
// head truncates the pipe and leaves an empty file. Both happened.
import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:fhir_r4/fhir_r4.dart';

late File out;

void say(String line) => out.writeAsStringSync('$line\n', mode: FileMode.append);

String cell(List<Data?> row, int i) =>
    i < row.length ? (row[i]?.value?.toString() ?? '').trim() : '';

/// Dates arrive as full ISO timestamps; the time is never meaningful here.
String tidy(String v) {
  final d = DateTime.tryParse(v);
  if (d == null) return v;
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

Map<String, Parameters> loadCases(String path) {
  final cases = <String, Parameters>{};
  for (final line in File(path).readAsLinesSync()) {
    if (line.trim().isEmpty) continue;
    final decoded = jsonDecode(line) as Map<String, dynamic>;
    for (final p in (decoded['parameter'] as List<dynamic>? ?? <dynamic>[])) {
      final param = p as Map<String, dynamic>;
      if (param.containsKey('resource')) {
        final r = param['resource'] as Map<String, dynamic>;
        if (r['resourceType'] == 'Immunization' && !r.containsKey('status')) {
          r['status'] = 'completed';
        }
      }
    }
    final params = Parameters.fromJson(decoded);
    final patient = params.parameter
        ?.firstWhereOrNull((e) => e.resource is Patient)
        ?.resource as Patient?;
    final id = patient?.id?.toString();
    if (id != null) cases[id] = params;
  }
  return cases;
}

const groupMap = <String, String>{
  'DTAP': 'DTaP/Tdap/Td',
  'Td': 'DTaP/Tdap/Td',
  'FLU': 'Influenza',
  'Flu': 'Influenza',
  'HIB': 'Hib',
  'MCV': 'Meningococcal',
  'MENB': 'Meningococcal B',
  'PCV': 'Pneumococcal',
  'POL': 'Polio',
  'IPOL': 'Polio',
  'ROTA': 'Rotavirus',
  'Rota': 'Rotavirus',
  'VAR': 'Varicella',
  'ZOSTER': 'Zoster',
};

void emit(
  String title,
  String xlsxPath,
  String sheetName,
  String ndjsonPath,
  int groupCol,
  List<String> ids,
) {
  final excel = Excel.decodeBytes(File(xlsxPath).readAsBytesSync());
  final sheet = excel.tables[sheetName]!;
  final headers =
      sheet.rows.first.map((c) => (c?.value?.toString() ?? '').trim()).toList();
  final rows = <String, List<Data?>>{};
  for (final row in sheet.rows.skip(1)) {
    final id = cell(row, 0);
    if (id.isNotEmpty) rows[id] = row;
  }
  final cases = loadCases(ndjsonPath);

  say('\n## $title\n');
  say('Source: `${xlsxPath.split("/").last}`, sheet "$sheetName".\n');

  for (final id in ids) {
    final row = rows[id];
    say('### $id\n');
    if (row == null) {
      say('Not present in this workbook.\n');
      continue;
    }

    say('CDC row, every populated column:\n');
    say('```');
    for (var i = 0; i < headers.length; i++) {
      final h = headers[i];
      final v = cell(row, i);
      if (h.isEmpty || v.isEmpty) continue;
      // Only tidy real date columns: a case id like "2018-0019" parses as a
      // date and came out as 2017-12-19.
      final isDate = h.toLowerCase().contains('date') ||
          h.toLowerCase() == 'dob';
      say('${h.padRight(24)} ${isDate ? tidy(v) : v}');
    }
    say('```\n');

    final params = cases[id];
    if (params == null) {
      say('cicada: case not loadable from the NDJSON.\n');
      continue;
    }
    final result = evaluateForForecast(params);
    final excelGroup = cell(row, groupCol);
    final f = result.vaccineGroupForecasts[groupMap[excelGroup] ?? excelGroup];
    if (f == null) {
      say('**cicada produces no forecast for $excelGroup.**\n');
    } else {
      say('**cicada answers:** status `${f.status}`, forecast #`${f.doseNumber}`'
          ', earliest `${f.earliestDate}`, recommended `${f.recommendedDate}`'
          ', past due `${f.pastDueDate}`.\n');
    }
  }
}

void main(List<String> args) {
  out = File('/home/grey/dev/fhir/cicada/CDSI-DISPUTED-CASES.md');
  out.writeAsStringSync('');

  say('# CDSi test cases where cicada disagrees with the CDC data');
  say('');
  say('cicada implements the CDSi logic specification v4.6 against supporting '
      'data 4.65-508 (August 2026). Each case below is printed as CDC '
      'published it — every populated column of their row — followed by what '
      'cicada answers. The question is which answer is clinically correct.');
  say('');
  say('**Version note.** The healthy cases are v4.46 (August 2026) and match '
      'the supporting data. The underlying-conditions cases are v4.6 '
      '(September 2025) and predate it, so some of those disagreements may be '
      'the two documents describing different seasons or thresholds rather '
      'than an error by either side — the RSV ones especially: the shipped '
      'data carries only the 2025-26 season (infant series opens 2025-10-01, '
      'maternal 2025-09-01) while those cases were written against 2023-24.');
  say('');

  emit(
    'Healthy childhood and adult cases (v4.46 — versions match, so these are '
    'the sharpest)',
    'cicada_generator/lib/test_cases/'
        'cdsi-healthy-childhood-and-adult-test-cases-v4.46.xlsx',
    'FITS Exported TestCases',
    'cicada/test/healthyTestCases.ndjson',
    54,
    <String>[
      '2018-0019',
      '2024-0102',
      '2023-0034',
      '2025-0009',
      '2013-0111',
      '2018-0022',
      '2013-0503',
    ],
  );

  if (args.isNotEmpty) {
    emit(
      'Underlying-conditions cases (v4.6 — predate the supporting data)',
      'cicada_generator/lib/test_cases/'
          'CDSi-underlying-conditions-test-cases-v4.6.xlsx',
      'Underlying Condition Test Cases',
      'cicada/test/conditionTestCases.ndjson',
      68,
      args,
    );
  }

  stdout.writeln('wrote ${out.path}');
}
