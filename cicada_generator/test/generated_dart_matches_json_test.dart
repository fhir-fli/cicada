/// The generator writes each antigen and schedule twice: as JSON under
/// cicada_generator/lib/generated_files and as a Dart literal under
/// cicada/lib/generated_files. This proves the two carry the same data, so
/// a change to how the Dart is emitted (2026-09-22: single-quoted literals,
/// formatted, no ignore_for_file) cannot alter the engine's inputs.
library;

import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';

const _eq = DeepCollectionEquality();

/// `dart test` runs with the package directory as cwd; the JSON lives in it.
String repoPath(String relative) =>
    '${Directory.current.parent.path}/$relative';

Map<String, dynamic> _readJson(String path) =>
    json.decode(File(path).readAsStringSync()) as Map<String, dynamic>;

List<File> _jsonFiles(String dir) =>
    Directory(repoPath(dir))
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

void main() {
  group('CDC', () {
    final files =
        _jsonFiles(
          'cicada_generator/lib/generated_files',
        ).where((f) => !f.path.contains('schedule')).toList();
    test('there is one JSON file per generated antigen', () {
      expect(files, isNotEmpty);
      expect(files.length, antigenSupportingDataMap.length);
    });
    for (final file in files) {
      test('${file.uri.pathSegments.last} matches its Dart literal', () {
        final fromJson = AntigenSupportingData.fromJson(_readJson(file.path));
        final generated = antigenSupportingDataMap[fromJson.targetDisease];
        expect(
          generated,
          isNotNull,
          reason: 'no generated antigen for ${fromJson.targetDisease}',
        );
        expect(_eq.equals(generated!.toJson(), fromJson.toJson()), isTrue);
      });
    }
    test('schedule matches its Dart literal', () {
      final fromJson = ScheduleSupportingData.fromJson(
        _readJson(
          repoPath(
            'cicada_generator/lib/generated_files/'
            'schedule_supporting_data.json',
          ),
        ),
      );
      expect(
        _eq.equals(scheduleSupportingData.toJson(), fromJson.toJson()),
        isTrue,
      );
    });
  });

  group('WHO', () {
    final files =
        _jsonFiles(
          'cicada_generator/lib/generated_files/who',
        ).where((f) => !f.path.contains('schedule')).toList();
    test('there is one JSON file per generated antigen', () {
      expect(files, isNotEmpty);
      expect(files.length, whoAntigenSupportingDataMap.length);
    });
    for (final file in files) {
      test('${file.uri.pathSegments.last} matches its Dart literal', () {
        final fromJson = AntigenSupportingData.fromJson(_readJson(file.path));
        final generated = whoAntigenSupportingDataMap[fromJson.targetDisease];
        expect(
          generated,
          isNotNull,
          reason: 'no generated WHO antigen for ${fromJson.targetDisease}',
        );
        expect(_eq.equals(generated!.toJson(), fromJson.toJson()), isTrue);
      });
    }
    test('schedule matches its Dart literal', () {
      final fromJson = ScheduleSupportingData.fromJson(
        _readJson(
          repoPath(
            'cicada_generator/lib/generated_files/who/'
            'schedule_supporting_data.json',
          ),
        ),
      );
      expect(
        _eq.equals(whoScheduleSupportingData.toJson(), fromJson.toJson()),
        isTrue,
      );
    });
  });
}
