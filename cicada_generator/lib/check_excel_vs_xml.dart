// Proves that the Excel parse of every CDC antigen workbook matches CDC's
// XML rendering of the same data.
//
// CDC publishes each antigen twice, as AntigenSupportingData- X-508.xlsx and
// .xml. The Excel is our source of record (experts can edit a workbook); the
// XML, converted by xml_to_json.dart into Version_*/JSON/, is the independent
// check. Both are loaded through AntigenSupportingData and compared as JSON,
// so field order and wrapping do not matter. Anything the Excel parse adds
// that the XML lacks (the Vaccine Recommendation Category sheet, which has
// no XML counterpart) is reported separately, not as a difference.
//
//   cd cicada_generator && dart run lib/check_excel_vs_xml.dart
//
// Writes results/excel_vs_xml.tsv, one row per antigen, as it goes, and exits
// non-zero if any antigen differs or fails to parse.
import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:cicada_generator/antigen_sheet_parser.dart';
import 'package:cicada_generator/repo_root.dart';

void main() {
  final versionDir = Directory(repoPath('cicada_generator/lib'))
      .listSync()
      .whereType<Directory>()
      .firstWhere((d) => d.path.split('/').last.startsWith('Version_'));
  final excelDir = Directory('${versionDir.path}/Excel');
  final jsonDir = Directory('${versionDir.path}/JSON');
  final out = File(repoPath('cicada_generator/results/excel_vs_xml.tsv'))
    ..createSync(recursive: true);
  final sink = out.openWrite()
    ..writeln('antigen\tstatus\tdifferences\tfirst_difference');
  final parser = AntigenSheetParser();
  var failures = 0;

  final files = excelDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.xlsx') && f.path.contains('AntigenSupportingData'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final xlsx in files) {
    final name = xlsx.path.split('/').last.replaceAll('.xlsx', '');
    final antigen = name.replaceFirst('AntigenSupportingData- ', '').replaceFirst('-508', '');
    String status;
    var diffs = <String>[];
    try {
      final fromExcel = parser.parseFile(xlsx.path).toJson();
      final jsonFile = File('${jsonDir.path}/$name.json');
      var xmlModel = AntigenSupportingData.fromJson(
          jsonDecode(jsonFile.readAsStringSync()) as Map<String, dynamic>);
      // The XML carries targetDisease and vaccineGroup only inside each
      // series; main.dart's old XML path copied series[0]'s up. Do the same
      // so the comparison is about data, not wrapping.
      if (xmlModel.targetDisease == null && (xmlModel.series?.isNotEmpty ?? false)) {
        xmlModel = xmlModel.copyWith(
          targetDisease: xmlModel.series!.first.targetDisease,
          vaccineGroup: xmlModel.series!.first.vaccineGroup,
        );
      }
      final fromXml = xmlModel.toJson();
      // The category sheet has no XML counterpart; report it, do not diff it.
      final categories =
          (fromExcel.remove('vaccineRecommendationCategory') as List?)?.length ?? 0;
      diffs = _diff(fromXml, fromExcel, '');
      status = diffs.isEmpty ? 'MATCH (categories=$categories)' : 'DIFFERS';
    } catch (e) {
      status = 'PARSE FAILED: $e';
    }
    if (status != 'MATCH' && !status.startsWith('MATCH')) failures++;
    sink.writeln('$antigen\t$status\t${diffs.length}\t${diffs.isEmpty ? '' : diffs.first}');
    stdout.writeln('$antigen: $status${diffs.isEmpty ? '' : ' (${diffs.length})'}');
    for (final d in diffs.take(8)) {
      stdout.writeln('    $d');
    }
  }
  sink.close();
  stdout.writeln('${files.length} workbooks, $failures not matching. ${out.path}');
  exit(failures == 0 ? 0 : 1);
}

/// Every leaf where [xml] and [excel] disagree, as "path: xml -> excel".
List<String> _diff(dynamic xml, dynamic excel, String path) {
  final out = <String>[];
  if (xml is Map && excel is Map) {
    for (final k in {...xml.keys, ...excel.keys}) {
      out.addAll(_diff(xml[k], excel[k], '$path/$k'));
    }
  } else if (xml is List && excel is List) {
    final n = xml.length > excel.length ? xml.length : excel.length;
    for (var i = 0; i < n; i++) {
      out.addAll(_diff(i < xml.length ? xml[i] : null,
          i < excel.length ? excel[i] : null, '$path[$i]'));
    }
  } else if (xml != excel && !_sameNumber(xml, excel)) {
    out.add('$path: ${_short(xml)} -> ${_short(excel)}');
  }
  return out;
}

/// The XML writes a numeric cell as "100.0" where the workbook holds 100;
/// the same number is not a difference.
bool _sameNumber(dynamic a, dynamic b) {
  if (a is! String || b is! String) return false;
  final x = double.tryParse(a);
  final y = double.tryParse(b);
  return x != null && y != null && x == y;
}

String _short(dynamic v) {
  final s = v == null ? 'null' : jsonEncode(v);
  return s.length > 70 ? '${s.substring(0, 70)}…' : s;
}
