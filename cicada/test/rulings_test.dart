import 'package:test/test.dart';

import 'cdc_suite.dart';
import 'rulings.dart';

/// A ruling that names no case in either workbook asserts nothing and hides
/// a deleted or renamed case; a ruling with no mismatch lines would pass a
/// case that matches CDC's row while calling it ruled.
void main() {
  test('every ruling names a case in one of the two workbooks', () {
    final ids = <String>{};
    for (final path in [
      'test/conditionTestCases.ndjson',
      'test/healthyTestCases.ndjson',
    ]) {
      final cases = loadCdcTestCases(path);
      for (var i = 0; i < cases.length; i++) {
        ids.add(cdcCaseId(cases[i], i));
      }
    }
    final orphans = rulings.keys.where((id) => !ids.contains(id)).toList();
    expect(orphans, isEmpty, reason: 'rulings for no case: $orphans');
  });

  test('every ruling records at least one mismatch and a citation', () {
    for (final entry in rulings.entries) {
      expect(entry.value.mismatches, isNotEmpty, reason: entry.key);
      expect(
        entry.value.citation,
        anyOf(
          contains('CDSI-OE-ADJUDICATED.md'),
          contains('CDC-REPORT.md'),
          contains('CDSI-DISPUTED-CASES.md'),
        ),
        reason: entry.key,
      );
    }
  });
}
