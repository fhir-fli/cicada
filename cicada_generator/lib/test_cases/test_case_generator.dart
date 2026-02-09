import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';

/// Which observation column style the Excel uses.
enum ObservationStyle {
  /// Healthy file: Med_History_Text / Med_History_Code (single pair)
  medHistory,

  /// Conditions file: Observation_Code_1/2/3, Observation_Text_1/2/3,
  /// Observation_Date_1/2/3
  observationCode,
}

/// Configuration for generating test case output from a specific Excel file.
class TestCaseConfig {
  const TestCaseConfig({
    required this.excelPath,
    required this.sheetName,
    required this.observationStyle,
    required this.ndjsonPath,
    required this.testNdjsonPath,
    required this.dosesDartPath,
    required this.forecastsDartPath,
    required this.dosesJsonPath,
    required this.label,
  });

  final String excelPath;
  final String sheetName;
  final ObservationStyle observationStyle;
  final String ndjsonPath;
  final String testNdjsonPath;
  final String dosesDartPath;
  final String forecastsDartPath;
  final String dosesJsonPath;
  final String label;
}

Future<void> main() async {
  // Healthy test cases
  final healthyPath = _findExcel('cdsi-healthy-childhood-and-adult-test-cases');
  if (healthyPath == null) {
    throw StateError(
        'No cdsi-healthy-childhood-and-adult-test-cases-*.xlsx found');
  }
  print('Using healthy test case file: $healthyPath');
  await _generateTestCases(TestCaseConfig(
    excelPath: healthyPath,
    sheetName: 'FITS Exported TestCases',
    observationStyle: ObservationStyle.medHistory,
    ndjsonPath: 'cicada_generator/lib/test_cases/test_cases.ndjson',
    testNdjsonPath: 'cicada/test/healthyTestCases.ndjson',
    dosesDartPath: 'cicada/lib/generated_files/test_doses.dart',
    forecastsDartPath: 'cicada/lib/generated_files/test_forecasts.dart',
    dosesJsonPath: 'cicada_generator/lib/test_cases/test_doses.json',
    label: 'healthy',
  ));

  // Underlying conditions test cases
  final conditionPath = _findExcel('CDSi-underlying-conditions-test-cases',
      caseSensitive: false);
  if (conditionPath != null) {
    print('\nUsing condition test case file: $conditionPath');
    await _generateTestCases(TestCaseConfig(
      excelPath: conditionPath,
      sheetName: 'Underlying Condition Test Cases',
      observationStyle: ObservationStyle.observationCode,
      ndjsonPath:
          'cicada_generator/lib/test_cases/condition_test_cases.ndjson',
      testNdjsonPath: 'cicada/test/conditionTestCases.ndjson',
      dosesDartPath: 'cicada/lib/generated_files/test_condition_doses.dart',
      forecastsDartPath:
          'cicada/lib/generated_files/test_condition_forecasts.dart',
      dosesJsonPath:
          'cicada_generator/lib/test_cases/condition_test_doses.json',
      label: 'condition',
    ));
  } else {
    print('\nNo underlying conditions test case Excel found — skipping.');
  }
}

/// Auto-detect an Excel file by partial name in the test_cases directory.
/// Returns null if [required] is false and nothing found.
String? _findExcel(String nameFragment, {bool caseSensitive = true}) {
  final dir = Directory('cicada_generator/lib/test_cases');
  final matches = dir
      .listSync()
      .whereType<File>()
      .where((f) {
        final name = f.path.split('/').last;
        if (caseSensitive) {
          return name.contains(nameFragment) && name.endsWith('.xlsx');
        }
        return name.toLowerCase().contains(nameFragment.toLowerCase()) &&
            name.endsWith('.xlsx');
      })
      .toList();
  if (matches.isEmpty) return null;
  if (matches.length > 1) {
    throw StateError(
        'Multiple "$nameFragment" files found: '
        '${matches.map((f) => f.path).join(', ')}');
  }
  return matches.first.path;
}

/// Main generation logic for a single Excel file.
Future<void> _generateTestCases(TestCaseConfig config) async {
  final bytes = File(config.excelPath).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel[config.sheetName];

  // Read headers
  final headers = sheet.rows.first
      .map((cell) => cell?.value?.toString() ?? '')
      .toList();

  // Containers for output
  final Map<String, List<Map<String, dynamic>>> testDoses = {};
  final Map<String, List<Map<String, String>>> testForecasts = {};
  final List<Parameters> parametersList = [];

  // Process each data row
  for (final row in sheet.rows.skip(1)) {
    // Skip empty rows
    if (row.every((c) => c == null || c.value.toString().trim().isEmpty)) {
      continue;
    }

    // Build a map of header -> cell value
    final rowMap = <String, dynamic>{};
    for (var i = 0; i < headers.length; i++) {
      rowMap[headers[i]] = row.length > i ? row[i]?.value : null;
    }

    // Create Patient
    final patient = _buildPatient(rowMap);
    final immunizations = <Immunization>[];
    final vaxDoses = <VaxDose>[];
    final conditions = <Condition>[];

    // Dynamically find dose columns
    final doseCols = headers.where((h) => h.startsWith('Date_Administered_'));
    for (var i = 0; i < doseCols.length; i++) {
      final idx = i + 1;
      final dateVal = rowMap['Date_Administered_$idx'];
      if (dateVal != null && dateVal.toString().isNotEmpty) {
        final adminDate = _extractDateStr(dateVal);
        final vaccineName = rowMap['Vaccine_Name_$idx']?.toString() ?? '';
        final cvx = rowMap['CVX_$idx']?.toString() ?? '';
        final mvx = rowMap['MVX_$idx']?.toString();
        final evalStatus = rowMap['Evaluation_Status_$idx']?.toString();
        final evalReason = rowMap['Evaluation_Reason_$idx']?.toString();

        // Build Immunization
        final imm = Immunization(
          id: '${patient.id}_dose$idx'.toFhirString,
          patient: patient.thisReference,
          status: ImmunizationStatusCodes.completed,
          vaccineCode: CodeableConcept(
            coding: [
              Coding(
                system: FhirUri('http://hl7.org/fhir/sid/cvx'),
                code: FhirCode(cvx),
                display: vaccineName.toFhirString,
              ),
              if (mvx != null && mvx.isNotEmpty)
                Coding(
                  system: FhirUri('http://hl7.org/fhir/sid/mvx'),
                  code: FhirCode(mvx),
                  display: vaccineName.toFhirString,
                ),
            ],
          ),
          occurrenceX: FhirDateTime.fromString(adminDate),
        );
        immunizations.add(imm);

        // Build VaxDose with expected evaluation
        final dose = VaxDose.fromImmunization(
          imm,
          VaxDate.fromDateTime(patient.birthDate!.valueDateTime!),
        );
        if (evalStatus != null) {
          dose.evalStatus = EvalStatus.fromJson(evalStatus);
        }
        if (evalReason != null) {
          dose.evalReason = EvalReason.fromJson(evalReason);
        }

        vaxDoses.add(dose);
      }
    }

    // Parse observations/conditions based on style
    switch (config.observationStyle) {
      case ObservationStyle.medHistory:
        _parseMedHistoryObservations(rowMap, headers, conditions, patient);
      case ObservationStyle.observationCode:
        _parseObservationCodeColumns(rowMap, conditions, patient);
    }

    // Store test doses JSON
    testDoses[patient.id.toString()] =
        vaxDoses.map((d) => d.toJson()).toList();

    // Extract forecast data — trim whitespace from vaccine group
    final patientId = patient.id.toString();
    final vaccineGroup =
        (rowMap['Vaccine_Group']?.toString() ?? '').trim();
    final seriesStatus = rowMap['Series_Status']?.toString() ?? '';
    final forecastNum = rowMap['Forecast_#']?.toString() ?? '';
    final earliestDate = _extractDate(rowMap['Earliest_Date']);
    final recommendedDate = _extractDate(rowMap['Recommended_Date']);
    final pastDueDate = _extractDate(rowMap['Past_Due_Date']);

    if (vaccineGroup.isNotEmpty) {
      testForecasts.putIfAbsent(patientId, () => []);
      testForecasts[patientId]!.add(<String, String>{
        'vaccineGroup': vaccineGroup,
        'seriesStatus': seriesStatus,
        'forecastNum': forecastNum,
        if (earliestDate.isNotEmpty) 'earliestDate': earliestDate,
        if (recommendedDate.isNotEmpty) 'recommendedDate': recommendedDate,
        if (pastDueDate.isNotEmpty) 'pastDueDate': pastDueDate,
      });
    }

    // Build Parameters bundle
    parametersList.add(
      Parameters(
        id: 'parameters-${patient.id}'.toFhirString,
        parameter: [
          ParametersParameter(
            name: _extractDateStr(rowMap['Assessment_Date']).toFhirString,
          ),
          ParametersParameter(
              name: 'Patient'.toFhirString, resource: patient),
          ...immunizations.map(
            (i) => ParametersParameter(
              name: 'immunization'.toFhirString,
              resource: i,
            ),
          ),
          ...conditions.map(
            (c) => ParametersParameter(
              name: 'condition'.toFhirString,
              resource: c,
            ),
          ),
        ],
      ),
    );
  }

  // Write outputs
  await File(config.dosesJsonPath).writeAsString(jsonEncode(testDoses));
  final ndjson =
      parametersList.map((p) => jsonEncode(p.toJson())).join('\n');
  await File(config.ndjsonPath).writeAsString(ndjson);

  // Write NDJSON to test directory
  await File(config.testNdjsonPath).writeAsString(ndjson);
  print('Wrote ${config.testNdjsonPath} '
      '(${parametersList.length} cases)');

  // Generate test_doses.dart
  _writeTestDosesDart(testDoses, config.dosesDartPath, config.label);
  print('Wrote ${config.dosesDartPath} '
      '(${testDoses.length} patients)');

  // Generate test_forecasts.dart
  _writeTestForecastsDart(
      testForecasts, config.forecastsDartPath, config.label);
  final totalForecasts =
      testForecasts.values.fold<int>(0, (sum, list) => sum + list.length);
  print('Wrote ${config.forecastsDartPath} '
      '(${testForecasts.length} patients, $totalForecasts forecasts)');
}

/// Parse Med_History_Text / Med_History_Code columns (healthy Excel style).
void _parseMedHistoryObservations(
  Map<String, dynamic> rowMap,
  List<String> headers,
  List<Condition> conditions,
  Patient patient,
) {
  final obsTextCols = headers.where((h) => h == 'Med_History_Text');
  for (var textCol in obsTextCols) {
    final textVal = rowMap[textCol]?.toString() ?? '';
    final codeVal = rowMap['Med_History_Code']?.toString() ?? '';
    if (textVal.isNotEmpty) {
      conditions.add(_buildConditionFromObsCode(
        codeVal,
        textVal,
        null,
        patient,
      ));
    }
  }
}

/// Parse Observation_Code_1/2/3 columns (conditions Excel style).
void _parseObservationCodeColumns(
  Map<String, dynamic> rowMap,
  List<Condition> conditions,
  Patient patient,
) {
  for (var idx = 1; idx <= 3; idx++) {
    final codeVal = rowMap['Observation_Code_$idx']?.toString() ?? '';
    final textVal = rowMap['Observation_Text_$idx']?.toString() ?? '';
    if (codeVal.isEmpty && textVal.isEmpty) continue;

    final dateVal = rowMap['Observation_Date_$idx'];
    final dateStr = dateVal != null && dateVal.toString().isNotEmpty
        ? dateVal.toString().substring(0, 10)
        : null;

    conditions.add(_buildConditionFromObsCode(
      codeVal,
      textVal,
      dateStr,
      patient,
    ));
  }
}

/// Build a FHIR Condition from a CDSi observation code, with crosswalk codings.
Condition _buildConditionFromObsCode(
  String rawCode,
  String displayText,
  String? onsetDate,
  Patient patient,
) {
  final obsCode = rawCode.padLeft(3, '0');
  final obsList =
      scheduleSupportingData.observations?.observation ?? [];
  final match = obsList.firstWhere(
    (o) => o.observationCode == obsCode,
    orElse: () => throw Exception('Obs code $obsCode not found'),
  );

  return Condition(
    clinicalStatus: CodeableConcept(
      coding: [
        Coding(
          system: FhirUri(
            'http://terminology.hl7.org/CodeSystem/condition-clinical',
          ),
          code: FhirCode('active'),
        ),
      ],
    ),
    subject: patient.thisReference,
    code: CodeableConcept(
      coding: [
        Coding(
          system: FhirUri(
            'https://www.cdc.gov/vaccines/programs/iis/cdsi.html',
          ),
          code: FhirCode(obsCode),
          display: displayText.toFhirString,
        ),
        ...?match.codedValues?.codedValue
            ?.where((cv) => cv.codeSystem == 'SNOMED')
            .map(
              (cv) => Coding(
                system: FhirUri('http://snomed.info/sct'),
                code: FhirCode(cv.code!),
                display: cv.text?.toFhirString,
              ),
            ),
      ],
    ),
    onsetX: onsetDate != null ? FhirDateTime.fromString(onsetDate) : null,
  );
}

/// Writes the testDoses map as a Dart file.
void _writeTestDosesDart(
  Map<String, List<Map<String, dynamic>>> testDoses,
  String outputPath,
  String label,
) {
  final varName = label == 'healthy' ? 'testDoses' : 'testConditionDoses';
  final sb = StringBuffer();
  sb.writeln(
      'final Map<String, List<Map<String, Object>>> $varName =');
  sb.writeln('    <String, List<Map<String, Object>>>{');

  final patientIds = testDoses.keys.toList()..sort();
  for (final patientId in patientIds) {
    final doses = testDoses[patientId]!;
    if (doses.isEmpty) {
      sb.writeln("  '$patientId': <Map<String, Object>>[],");
      continue;
    }
    sb.writeln("  '$patientId': <Map<String, Object>>[");
    for (final dose in doses) {
      sb.writeln('    <String, Object>{');
      _writeDoseEntry(sb, dose);
      sb.writeln('    },');
    }
    sb.writeln('  ],');
  }
  sb.writeln('};');

  File(outputPath).writeAsStringSync(sb.toString());
}

void _writeDoseEntry(StringBuffer sb, Map<String, dynamic> dose) {
  final orderedKeys = [
    'doseId',
    'volume',
    'dateGiven',
    'cvx',
    'mvx',
    'antigens',
    'dob',
    'targetDisease',
    'targetDoseSatisfied',
    'index',
    'inadvertent',
    'validAgeReason',
    'preferredInterval',
    'preferredIntervalReason',
    'allowedInterval',
    'allowedIntervalReason',
    'conflict',
    'conflictReason',
    'preferredVaccine',
    'preferredVaccineReason',
    'allowedVaccine',
    'allowedVaccineReason',
    'evalStatus',
    'evalReason',
  ];
  for (final key in orderedKeys) {
    if (!dose.containsKey(key) || dose[key] == null) continue;
    final value = dose[key];
    sb.write("      '$key': ");
    sb.writeln('${_dartLiteral(value)},');
  }
}

String _dartLiteral(dynamic value) {
  if (value is String) return "'${_escapeString(value)}'";
  if (value is int) return '$value';
  if (value is bool) return '$value';
  if (value is List) {
    if (value.every((e) => e is String)) {
      final items =
          value.map((e) => "'${_escapeString(e as String)}'").join(', ');
      return '<String>[$items]';
    }
    return '$value';
  }
  return "'$value'";
}

String _escapeString(String s) => s.replaceAll("'", "\\'");

/// Extracts a date string in yyyy-MM-dd format from a cell value.
String _extractDateStr(dynamic value) {
  if (value == null) return '';
  final s = value.toString();
  return s.length >= 10 ? s.substring(0, 10) : s;
}

/// Extracts a date string in yyyy/MM/dd format from a cell value.
String _extractDate(dynamic value) {
  if (value == null) return '';
  final s = value.toString();
  if (s.isEmpty) return '';
  final dateStr = s.length >= 10 ? s.substring(0, 10) : s;
  return dateStr.replaceAll('-', '/');
}

/// Writes the testForecasts map as a Dart file.
void _writeTestForecastsDart(
  Map<String, List<Map<String, String>>> testForecasts,
  String outputPath,
  String label,
) {
  final varName =
      label == 'healthy' ? 'testForecasts' : 'testConditionForecasts';
  final sb = StringBuffer();
  sb.writeln(
      'final Map<String, List<Map<String, String>>> $varName =');
  sb.writeln('    <String, List<Map<String, String>>>{');

  final patientIds = testForecasts.keys.toList()..sort();
  for (final patientId in patientIds) {
    final forecasts = testForecasts[patientId]!;
    if (forecasts.isEmpty) {
      sb.writeln("  '$patientId': <Map<String, String>>[],");
      continue;
    }
    sb.writeln("  '$patientId': <Map<String, String>>[");
    for (final forecast in forecasts) {
      sb.writeln('    <String, String>{');
      for (final entry in forecast.entries) {
        sb.writeln(
            "      '${entry.key}': '${_escapeString(entry.value)}',");
      }
      sb.writeln('    },');
    }
    sb.writeln('  ],');
  }
  sb.writeln('};');

  File(outputPath).writeAsStringSync(sb.toString());
}

/// Helper to build a Patient from a row map.
/// Handles both 'gender' (healthy) and 'Gender' (conditions) column names.
Patient _buildPatient(Map<String, dynamic> row) {
  final genderVal =
      row['gender']?.toString() ?? row['Gender']?.toString() ?? '';
  final dobStr = row['DOB']?.toString() ?? '';
  final dob = dobStr.length >= 10 ? dobStr.substring(0, 10) : dobStr;
  return Patient(
    id: row['CDC_Test_ID'].toString().toFhirString,
    name: [HumanName(family: row['Test_Case_Name']?.toString().toFhirString)],
    birthDate: dob.isNotEmpty ? FhirDate.fromString(dob) : null,
    gender: genderVal.toLowerCase().contains('f')
        ? AdministrativeGender.female
        : genderVal.toLowerCase().contains('t')
            ? AdministrativeGender('transgender')
            : genderVal.toLowerCase().contains('m')
                ? AdministrativeGender.male
                : AdministrativeGender.unknown,
  );
}
