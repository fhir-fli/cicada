// Rewrites the WHO antigen workbooks in CDC's CDSi 4.65 layout, and proves
// the round trip before touching anything.
//
//   dart run lib/write_who_workbooks.dart          # WHO: write to results/, compare
//   dart run lib/write_who_workbooks.dart --apply  # ... and replace lib/WHO/antigen
//   dart run lib/write_who_workbooks.dart --cdc    # round-trip CDC's 30 into results/
//
// For every workbook: parse it (AntigenSheetParser), write the model through
// AntigenWorkbookWriter, parse the written file, and diff the two models as
// JSON. --cdc never replaces CDC's files; it exists because CDC's workbooks
// carry contraindications, immunity, indications and conditional skips that
// the WHO ones do not, so they are the real test of the writer.
// Results go to results/<mode>_roundtrip.tsv, one row per workbook as it
// finishes; exit code is non-zero if any workbook differs.
import 'dart:io';

import 'package:cicada_generator/antigen_sheet_parser.dart';
import 'package:cicada_generator/antigen_workbook_writer.dart';
import 'package:cicada_generator/json_diff.dart';
import 'package:cicada_generator/repo_root.dart';

void main(List<String> args) {
  final cdc = args.contains('--cdc');
  final apply = args.contains('--apply') && !cdc;
  final Directory sourceDir;
  if (cdc) {
    final version = Directory(repoPath('cicada_generator/lib'))
        .listSync()
        .whereType<Directory>()
        .firstWhere((d) => d.path.split('/').last.startsWith('Version_'));
    sourceDir = Directory('${version.path}/Excel');
  } else {
    sourceDir = Directory(repoPath('cicada_generator/lib/WHO/antigen'));
  }
  final mode = cdc ? 'cdc' : 'who';
  final outDir = Directory(repoPath('cicada_generator/results/${mode}_roundtrip'))
    ..createSync(recursive: true);
  final tsv = File(repoPath('cicada_generator/results/${mode}_roundtrip.tsv'))
      .openWrite()
    ..writeln('workbook\tstatus\tdifferences\tfirst');
  final parser = AntigenSheetParser();
  final writer = AntigenWorkbookWriter();
  var failures = 0;

  final files = sourceDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.xlsx') && (!cdc || f.path.contains('AntigenSupportingData')))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final xlsx in files) {
    final name = xlsx.path.split('/').last;
    final written = File('${outDir.path}/$name');
    String status;
    var diffs = <String>[];
    try {
      final before = parser.parseFile(xlsx.path);
      written.writeAsBytesSync(writer.write(before).encode()!);
      final after = parser.parseFile(written.path);
      diffs = jsonDiff(before.toJson(), after.toJson());
      status = diffs.isEmpty ? 'MATCH' : 'DIFFERS';
    } catch (e, st) {
      status = 'FAILED: $e';
      stdout.writeln(st.toString().split('\n').take(4).join('\n'));
    }
    if (status != 'MATCH') failures++;
    tsv.writeln('$name\t$status\t${diffs.length}\t${diffs.isEmpty ? '' : diffs.first}');
    stdout.writeln('$name: $status${diffs.isEmpty ? '' : ' (${diffs.length})'}');
    for (final d in diffs.take(6)) {
      stdout.writeln('    $d');
    }
    if (apply && status == 'MATCH') {
      written.copySync(xlsx.path);
    }
  }
  tsv.close();
  stdout.writeln('${files.length} workbooks, $failures not round-tripping'
      '${apply ? ', matching ones replaced in ${sourceDir.path}' : ''}.');
  exit(failures == 0 ? 0 : 1);
}
