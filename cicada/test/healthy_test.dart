// The CDSi healthy childhood and adult test cases (v4.46). Comparison
// semantics live in cdc_suite.dart, shared with condition_test.dart; only the
// data is here. Before this suite existed, test/cicada_test.dart ran these
// 1,064 cases and asserted nothing: the expected results were generated all
// along and never read, so "1010/1014 (99.6%)" in CLAUDE.md came from nothing
// in the repo.
//
// This suite is the one whose cases match the supporting data in version:
// v4.46 test cases and 4.65-508 data are both August 2026.

import 'package:cicada/generated_files/test_doses.dart';
import 'package:cicada/generated_files/test_forecasts.dart';

import 'cdc_suite.dart';

/// Map from the healthy-suite Excel vaccine group labels to engine names.
///
/// The two CDSi workbooks label the same groups differently — conditions says
/// "DTaP", healthy says "DTAP" — so this cannot be shared with
/// condition_test.dart. When the healthy suite was first derived from the
/// conditions one it used the conditions map, every lookup fell through to a
/// key the engine does not have, and 621 cases reported "no forecast
/// produced". That was the harness, not the engine.
const healthyExcelToEngine = <String, String>{
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
  // COVID-19, HPV, HepA, HepB, MMR and RSV already match the engine's names.
};

void main() {
  runCdcSuite(
    name: 'CDSi healthy childhood and adult test cases',
    casesPath: 'test/healthyTestCases.ndjson',
    caseCount: 1064,
    expectedDoses: testDoses,
    expectedForecasts: testForecasts,
    excelToEngine: healthyExcelToEngine,
  );
}
