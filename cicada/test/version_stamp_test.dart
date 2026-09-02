import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:test/test.dart';

void main() {
  group('version stamp', () {
    // The constant is what gets written into every response. If it drifts from
    // the published package version, a stored forecast names a version of the
    // engine that never produced it, which is worse than naming none.
    test('cicadaEngineVersion matches pubspec.yaml', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final match =
          RegExp(r'^version:\s*(\S+)', multiLine: true).firstMatch(pubspec);
      expect(match, isNotNull, reason: 'pubspec.yaml has no version:');
      expect(cicadaEngineVersion, match!.group(1));
    });

    // The generator builds the antigen files from a numbered CDSi release. If
    // that release changes without this constant changing, every response
    // misreports the schedule it was computed against.
    test('cdsiSupportingDataVersion is the release the docs name', () {
      final claudeMd = File('../CLAUDE.md').readAsStringSync();
      expect(claudeMd, contains('Version_$cdsiSupportingDataVersion'),
          reason: 'CLAUDE.md names a different CDSi release than the constant');
    });
  });
}
