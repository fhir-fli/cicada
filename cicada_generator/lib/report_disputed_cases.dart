// Generates CDSI-DISPUTED-CASES.md.
//
// For every case where cicada disagrees with the CDC test data, print CDC's own
// row verbatim: every populated column with its header, exactly as published.
// Then one line for what cicada answered, so the disagreement is visible.
//
// Usage: dart cicada_generator/lib/report_disputed_cases.dart
//
// The case list is derived, never typed. It used to be passed in on the command
// line, and `2016-UC-0110` was left out of it — that case then went untriaged
// through the whole audit, because its id carries a trailing space and does not
// survive a copy-paste out of the suite output. This report is what the
// adjudication reads, so it works out for itself which cases disagree.
//
// Writes with a synchronous append per line — an IOSink with a per-line
// flush() throws "StreamSink is bound to a stream", and piping the run through
// head truncates the pipe and leaves an empty file. Both happened.
import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/test_condition_doses.dart';
import 'package:cicada/generated_files/test_condition_forecasts.dart';
import 'package:cicada/generated_files/test_doses.dart';
import 'package:cicada/generated_files/test_forecasts.dart';
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

/// Excel vaccine-group label → engine vaccine-group name.
///
/// The two workbooks label the same groups differently and BOTH sets must be
/// here. Dropping `DTaP` (conditions) while keeping `DTAP` (healthy) made this
/// report claim "cicada produces no forecast for DTaP" on cases where it
/// produces one — and that false line was then adjudicated as an engine bug.
const groupMap = <String, String>{
  // healthy workbook
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
  // conditions workbook
  'DTaP': 'DTaP/Tdap/Td',
  'Flu': 'Influenza',
  'IPOL': 'Polio',
  'Rota': 'Rotavirus',
  // COVID-19, HPV, HepA, HepB, MMR, RSV, Chikungunya, Cholera, Dengue, Ebola,
  // Japanese Encephalitis, Meningococcal, Meningococcal B, Orthopoxvirus,
  // Pneumococcal, Rabies, TBE, Typhoid, Yellow Fever, Zoster already match.
};

/// Whether [dose]'s sub-step fields contradict its own evalStatus/evalReason.
///
/// Mirrors checkDoseConsistency in the two suites. A case that trips this is a
/// case cicada fails, so it belongs in the report even though the quarrel is
/// with itself rather than with CDC.
bool inconsistent(VaxDose dose) {
  if (dose.evalReason == EvalReason.ageTooYoung &&
      dose.validAgeReason != ValidAgeReason.tooYoung) return true;
  if (dose.evalReason == EvalReason.ageTooOld &&
      dose.validAgeReason != ValidAgeReason.tooOld) return true;
  if (dose.evalReason == EvalReason.intervalTooShort &&
      dose.allowedIntervalReason != IntervalReason.tooShort &&
      dose.preferredIntervalReason != IntervalReason.tooShort) return true;
  if (dose.evalReason == EvalReason.liveVirusConflict &&
      dose.conflict != true) return true;
  if (dose.evalReason == EvalReason.notPreferableOrAllowable &&
      dose.allowedVaccine != false) return true;
  if (dose.evalStatus == EvalStatus.valid) {
    if (dose.validAgeReason == ValidAgeReason.tooYoung ||
        dose.validAgeReason == ValidAgeReason.tooOld) return true;
    if (dose.conflict == true) return true;
    if (dose.allowedVaccine == false) return true;
  }
  return false;
}

/// Whether cicada's answer for [id] differs from what CDC's data expects.
///
/// The comparison mirrors test/condition_test.dart and test/healthy_test.dart
/// exactly — same dose matching, same seriesType filter, same "only compare a
/// populated column" rule — so the ids this yields are the ids those suites
/// fail. Anything looser would let a disagreement go unreported again.
bool disagrees(
  String id,
  Parameters params,
  Map<String, List<Map<String, String>>> expectedForecasts,
  Map<String, List<Map<String, Object>>> expectedDoses,
) {
  final result = evaluateForForecast(params);

  for (final doseMap in expectedDoses[id] ?? const <Map<String, Object>>[]) {
    final expected = VaxDose.fromJson(doseMap);
    final expectedSeriesType = doseMap['seriesType'] as String?;
    final hasExpectedReason = expected.evalReason != null;
    var foundAnyEval = false;
    var foundStatusMatch = false;
    var foundReasonMatch = false;
    var sawInconsistency = false;

    result.agMap.forEach((String antigenName, VaxAntigen antigen) {
      if (!expected.antigens
          .map((String s) => s.toLowerCase())
          .contains(antigenName.toLowerCase())) {
        return;
      }
      antigen.groups.forEach((String _, VaxGroup group) {
        for (final series in group.series) {
          if (expectedSeriesType != null && series.series.seriesType != null) {
            final actualType =
                series.series.seriesType.toString().toLowerCase();
            if (actualType != expectedSeriesType) continue;
          }
          final actual = series.doses
              .firstWhereOrNull((VaxDose d) => d.doseId == expected.doseId);
          if (actual == null || actual.evalStatus == null) continue;
          foundAnyEval = true;
          if (inconsistent(actual)) sawInconsistency = true;
          if (actual.evalStatus == expected.evalStatus) {
            foundStatusMatch = true;
            // evalReasons, plural, exactly as the suites compare — Table 6-31
            // sets the status with evaluation reasons and CDC's column holds
            // one of them.
            if (hasExpectedReason &&
                actual.evalReasons.contains(expected.evalReason)) {
              foundReasonMatch = true;
            }
          }
        }
      });
    });

    if (sawInconsistency) return true;
    if (!foundAnyEval && expected.evalStatus != null) return true;
    if (foundAnyEval && !foundStatusMatch) return true;
    if (foundAnyEval &&
        foundStatusMatch &&
        hasExpectedReason &&
        !foundReasonMatch) {
      return true;
    }
  }

  for (final expected
      in expectedForecasts[id] ?? const <Map<String, String>>[]) {
    final excelGroup = expected['vaccineGroup']!.trim();
    final forecast =
        result.vaccineGroupForecasts[groupMap[excelGroup] ?? excelGroup];
    if (forecast == null) return true;
    if (expected['seriesStatus']!.toLowerCase() !=
        forecast.status.toString().toLowerCase()) {
      return true;
    }
    final expectedDoseNum = expected['forecastNum'] ?? '';
    if (expectedDoseNum.isNotEmpty &&
        expectedDoseNum != '-' &&
        expectedDoseNum != (forecast.doseNumber?.toString() ?? '')) {
      return true;
    }
    final columns = <List<String>>[
      <String>[
        expected['earliestDate'] ?? '',
        forecast.earliestDate?.toString() ?? '',
      ],
      <String>[
        expected['recommendedDate'] ?? '',
        forecast.recommendedDate?.toString() ?? '',
      ],
      <String>[
        expected['pastDueDate'] ?? '',
        forecast.pastDueDate?.toString() ?? '',
      ],
    ];
    for (final column in columns) {
      if (column.first.isNotEmpty && column.first != column.last) return true;
    }
  }

  return false;
}

/// Every case in [cases] cicada answers differently, in the file's own order.
List<String> disagreeingIds(
  Map<String, Parameters> cases,
  Map<String, List<Map<String, String>>> expectedForecasts,
  Map<String, List<Map<String, Object>>> expectedDoses,
) =>
    cases.entries
        .where((MapEntry<String, Parameters> e) =>
            disagrees(e.key, e.value, expectedForecasts, expectedDoses))
        .map((MapEntry<String, Parameters> e) => e.key)
        .toList();

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
    // Some case ids carry a trailing space in the NDJSON ("2016-UC-0110 ") but
    // not in the workbook's own column, so look the row up both ways.
    final row = rows[id] ?? rows[id.trim()];
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

void main() {
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

  const healthyNdjson = 'cicada/test/healthyTestCases.ndjson';
  const conditionNdjson = 'cicada/test/conditionTestCases.ndjson';

  final healthyIds = disagreeingIds(
      loadCases(healthyNdjson), testForecasts, testDoses);
  final conditionIds = disagreeingIds(
      loadCases(conditionNdjson), testConditionForecasts, testConditionDoses);
  stdout.writeln('${healthyIds.length} healthy and ${conditionIds.length} '
      'underlying-conditions cases disagree');

  emit(
    'Healthy childhood and adult cases (v4.46 — versions match, so these are '
    'the sharpest)',
    'cicada_generator/lib/test_cases/'
        'cdsi-healthy-childhood-and-adult-test-cases-v4.46.xlsx',
    'FITS Exported TestCases',
    healthyNdjson,
    54,
    healthyIds,
  );

  emit(
    'Underlying-conditions cases (v4.6 — predate the supporting data)',
    'cicada_generator/lib/test_cases/'
        'CDSi-underlying-conditions-test-cases-v4.6.xlsx',
    'Underlying Condition Test Cases',
    conditionNdjson,
    68,
    conditionIds,
  );

  stdout.writeln('wrote ${out.path}');
}
