import 'dart:io';

import 'package:test/test.dart';

/// `collapseForComparison` exists twice: canonically in
/// `cicada/test/cdc_row_collapse.dart`, and copied into
/// `cicada_generator/lib/cdc_row_collapse.dart` so the disputed-case report and
/// the case auditor pick the same forecast the suite compares against.
///
/// They are copies because a relative import cannot cross a package boundary
/// and the two packages cannot depend on each other: cicada_generator needs
/// `excel`, which pins `archive` 3.x, while cicada needs `fhir_r4_bulk`, which
/// needs `archive` 4.x.
///
/// If they drift, the suite and the report disagree about which cases fail.
/// This test makes that impossible to do quietly.
void main() {
  test('the two copies of collapseForComparison are identical', () {
    final canonical = File('test/cdc_row_collapse.dart');
    final copy = File('../cicada_generator/lib/cdc_row_collapse.dart');

    expect(canonical.existsSync(), isTrue,
        reason: 'canonical copy missing at ${canonical.path}');
    expect(copy.existsSync(), isTrue,
        reason: 'generator copy missing at ${copy.path}');

    String body(File f) {
      final text = f.readAsStringSync();
      final start = text.indexOf("/// Collapse a vaccine group's forecasts");
      expect(start, greaterThanOrEqualTo(0),
          reason: '${f.path} no longer contains collapseForComparison');
      return text.substring(start).trim();
    }

    expect(body(copy), equals(body(canonical)),
        reason: 'cicada_generator/lib/cdc_row_collapse.dart has drifted from '
            'the canonical cicada/test/cdc_row_collapse.dart. Copy the '
            'canonical version over it.');
  });
}
