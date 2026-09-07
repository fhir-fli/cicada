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
import 'package:cicada_generator/json_diff.dart';
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
      diffs = jsonDiff(fromXml, fromExcel);
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
