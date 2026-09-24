// The CDSi underlying-conditions test cases (v4.6). Comparison semantics live
// in cdc_suite.dart, shared with healthy_test.dart; only the data is here.

import 'package:cicada/generated_files/test_condition_doses.dart';
import 'package:cicada/generated_files/test_condition_forecasts.dart';

import 'cdc_suite.dart';

/// Map from conditions Excel vaccine group names to engine names.
const conditionExcelToEngine = <String, String>{
  'DTaP': 'DTaP/Tdap/Td',
  'Flu': 'Influenza',
  'IPOL': 'Polio',
  'Rota': 'Rotavirus',
  'VAR': 'Varicella',
};

void main() {
  runCdcSuite(
    name: 'CDSi condition test cases',
    casesPath: 'test/conditionTestCases.ndjson',
    caseCount: 337,
    expectedDoses: testConditionDoses,
    expectedForecasts: testConditionForecasts,
    excelToEngine: conditionExcelToEngine,
  );
}
