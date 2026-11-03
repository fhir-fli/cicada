import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:excel/excel.dart';
import 'package:fhir_r4/fhir_r4.dart';

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
      'No cdsi-healthy-childhood-and-adult-test-cases-*.xlsx found',
    );
  }
  stdout.writeln('Using healthy test case file: $healthyPath');
  await _generateTestCases(
    TestCaseConfig(
      excelPath: healthyPath,
      sheetName: 'FITS Exported TestCases',
      observationStyle: ObservationStyle.medHistory,
      ndjsonPath: 'cicada_generator/lib/test_cases/test_cases.ndjson',
      testNdjsonPath: 'cicada/test/healthyTestCases.ndjson',
      dosesDartPath: 'cicada/lib/generated_files/test_doses.dart',
      forecastsDartPath: 'cicada/lib/generated_files/test_forecasts.dart',
      dosesJsonPath: 'cicada_generator/lib/test_cases/test_doses.json',
      label: 'healthy',
    ),
  );

  // Underlying conditions test cases
  final conditionPath = _findExcel(
    'CDSi-underlying-conditions-test-cases',
    caseSensitive: false,
  );
  if (conditionPath != null) {
    stdout.writeln('\nUsing condition test case file: $conditionPath');
    await _generateTestCases(
      TestCaseConfig(
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
      ),
    );
  } else {
    stdout.writeln(
      '\nNo underlying conditions test case Excel found — skipping.',
    );
  }
}

/// Auto-detect an Excel file by partial name in the test_cases directory.
/// Returns null if [required] is false and nothing found.
String? _findExcel(String nameFragment, {bool caseSensitive = true}) {
  final dir = Directory('cicada_generator/lib/test_cases');
  final matches =
      dir.listSync().whereType<File>().where((f) {
        final name = f.path.split('/').last;
        if (caseSensitive) {
          return name.contains(nameFragment) && name.endsWith('.xlsx');
        }
        return name.toLowerCase().contains(nameFragment.toLowerCase()) &&
            name.endsWith('.xlsx');
      }).toList();
  if (matches.isEmpty) return null;
  if (matches.length > 1) {
    throw StateError(
      'Multiple "$nameFragment" files found: '
      '${matches.map((f) => f.path).join(', ')}',
    );
  }
  return matches.first.path;
}

/// Main generation logic for a single Excel file.
Future<void> _generateTestCases(TestCaseConfig config) async {
  final bytes = File(config.excelPath).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel[config.sheetName];

  // Read headers
  final headers =
      sheet.rows.first.map((cell) => cell?.value?.toString() ?? '').toList();

  // Containers for output
  final testDoses = <String, List<Map<String, dynamic>>>{};
  final testForecasts = <String, List<Map<String, String>>>{};
  final parametersList = <Parameters>[];

  // Process each data row
  for (final row in sheet.rows.skip(1)) {
    // Skip empty rows.
    //
    // A cell can exist with a null value — Excel materialises them for
    // formatting — and `c.value.toString()` on one yields the *string* "null",
    // which is not empty, so a row of them used to survive this guard. The
    // conditions workbook carries 439 such ghost rows after its last real
    // case, and every one became a test case: a patient with no birth date, no
    // doses, no conditions and the id "null" (see _buildPatient, where
    // `null.toString()` did the same thing again). The suite named those cases
    // `case-N`, found no expectations under that name, and asserted nothing —
    // 439 of the 777 condition "tests" were no-ops, and the headline 752/777
    // counted every one of them as a pass.
    if (row.every(
      (c) => c == null || c.value == null || c.value.toString().trim().isEmpty,
    )) {
      continue;
    }

    // Build a map of header -> cell value
    final rowMap = <String, dynamic>{};
    for (var i = 0; i < headers.length; i++) {
      rowMap[headers[i]] = row.length > i ? row[i]?.value : null;
    }

    // A row with no case id cannot be compared against anything, so it is not
    // a test case. Never let one through as the patient id "null".
    final caseId = rowMap['CDC_Test_ID']?.toString().trim() ?? '';
    if (caseId.isEmpty || caseId == 'null') {
      continue;
    }

    // Create Patient
    final patient = _buildPatient(rowMap);
    final immunizations = <Immunization>[];
    final vaxDoses = <VaxDose>[];
    final history = <Resource>[];

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

        // Build Immunization the way the published examples do
        // (TEST-RESOURCE-REVIEW.md): the CVX coding carries CVX's own
        // display and CDC's product name goes in vaccineCode.text; the
        // manufacturer goes in Immunization.manufacturer, as an MVX
        // identifier (HL7 V2-to-FHIR RXA-17: CWE.1 -> identifier.value,
        // CWE.3 -> identifier.system) with the company name as display.
        // It never goes in vaccineCode: no example, profile or mapping in
        // 31 sources puts it there.
        final imm = Immunization(
          id: '${patient.id}_dose$idx'.toFhirString,
          patient: patient.thisReference,
          status: ImmunizationStatusCodes.completed,
          vaccineCode: CodeableConcept(
            coding: [
              Coding(
                system: FhirUri('http://hl7.org/fhir/sid/cvx'),
                code: FhirCode(cvx),
                display: cvxDisplays[cvx]?.toFhirString,
              ),
            ],
            text: vaccineName.isEmpty ? null : vaccineName.toFhirString,
          ),
          manufacturer:
              mvx == null || mvx.trim().isEmpty
                  ? null
                  : Reference(
                    identifier: Identifier(
                      system: FhirUri('http://hl7.org/fhir/sid/mvx'),
                      value: mvx.trim().toFhirString,
                    ),
                    display: mvxDisplays[mvx.trim()]?.toFhirString,
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
        _parseMedHistoryObservations(rowMap, headers, history, patient);
      case ObservationStyle.observationCode:
        _parseObservationCodeColumns(rowMap, history, patient);
    }

    // Store test doses JSON
    final doseJsonList = vaxDoses.map((d) => d.toJson()).toList();
    // Add Series_Type per dose (condition Excel only)
    if (config.observationStyle == ObservationStyle.observationCode) {
      for (var i = 0; i < doseJsonList.length; i++) {
        final idx = i + 1;
        final seriesType = rowMap['Series_Type_$idx']?.toString();
        if (seriesType != null && seriesType.trim().isNotEmpty) {
          doseJsonList[i]['seriesType'] = seriesType.trim().toLowerCase();
        }
      }
    }
    testDoses[patient.id.toString()] = doseJsonList;

    // Extract forecast data — trim whitespace from vaccine group
    final patientId = patient.id.toString();
    final vaccineGroup = (rowMap['Vaccine_Group']?.toString() ?? '').trim();
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
          // ImmDS $immds-forecast inputs: assessmentDate (date), patient,
          // immunization. ImmDS has no input for clinical history; those
          // resources follow, one parameter each, named by resource type.
          ParametersParameter(
            name: 'assessmentDate'.toFhirString,
            valueX: FhirDate.fromString(
              _extractDateStr(rowMap['Assessment_Date']),
            ),
          ),
          ParametersParameter(name: 'patient'.toFhirString, resource: patient),
          ...immunizations.map(
            (i) => ParametersParameter(
              name: 'immunization'.toFhirString,
              resource: i,
            ),
          ),
          ...history.map(
            (r) => ParametersParameter(
              name: _parameterName(r).toFhirString,
              resource: r,
            ),
          ),
        ],
      ),
    );
  }

  // Write outputs
  await File(config.dosesJsonPath).writeAsString(jsonEncode(testDoses));
  final ndjson = parametersList.map((p) => jsonEncode(p.toJson())).join('\n');
  await File(config.ndjsonPath).writeAsString(ndjson);

  // Write NDJSON to test directory
  await File(config.testNdjsonPath).writeAsString(ndjson);
  stdout.writeln(
    'Wrote ${config.testNdjsonPath} '
    '(${parametersList.length} cases)',
  );

  // Generate test_doses.dart
  _writeTestDosesDart(testDoses, config.dosesDartPath, config.label);
  stdout.writeln(
    'Wrote ${config.dosesDartPath} '
    '(${testDoses.length} patients)',
  );

  // Generate test_forecasts.dart
  _writeTestForecastsDart(
    testForecasts,
    config.forecastsDartPath,
    config.label,
  );
  final totalForecasts = testForecasts.values.fold<int>(
    0,
    (sum, list) => sum + list.length,
  );
  stdout.writeln(
    'Wrote ${config.forecastsDartPath} '
    '(${testForecasts.length} patients, $totalForecasts forecasts)',
  );
}

/// Parse Med_History_Text / Med_History_Code columns (healthy Excel style).
void _parseMedHistoryObservations(
  Map<String, dynamic> rowMap,
  List<String> headers,
  List<Resource> history,
  Patient patient,
) {
  final textVal = rowMap['Med_History_Text']?.toString() ?? '';
  final codeVal = rowMap['Med_History_Code']?.toString() ?? '';
  if (textVal.isNotEmpty) {
    history.add(_buildHistoryResource(codeVal, null, patient, history.length));
  }
}

/// Parse Observation_Code_1/2/3 columns (conditions Excel style).
void _parseObservationCodeColumns(
  Map<String, dynamic> rowMap,
  List<Resource> history,
  Patient patient,
) {
  for (var idx = 1; idx <= 3; idx++) {
    final codeVal = rowMap['Observation_Code_$idx']?.toString() ?? '';
    final textVal = rowMap['Observation_Text_$idx']?.toString() ?? '';
    if (codeVal.isEmpty && textVal.isEmpty) continue;

    final dateVal = rowMap['Observation_Date_$idx'];
    final dateStr =
        dateVal != null && dateVal.toString().isNotEmpty
            ? dateVal.toString().substring(0, 10)
            : null;

    history.add(
      _buildHistoryResource(codeVal, dateStr, patient, history.length),
    );
  }
}

/// How each CDSi observation is sent: the resource a chart would hold and
/// the codes CDC lists for it. Built by
/// `tool/ig_compare/build_observation_resource_map.py` from the evidence in
/// TEST-RESOURCE-REVIEW.md. Read once.
final Map<String, dynamic> _observationResourceMap =
    jsonDecode(
          File(
            'cicada_generator/lib/test_cases/observation_resource_map.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>;

CodeableConcept _concept(List<dynamic> codings) => CodeableConcept(
  coding: [
    for (final c in codings.cast<Map<String, dynamic>>())
      Coding(
        system: FhirUri(c['system'] as String),
        code: FhirCode(c['code'] as String),
        display: (c['display'] as String?)?.toFhirString,
      ),
  ],
);

CodeableConcept _hl7Concept(String system, String code) => CodeableConcept(
  coding: [Coding(system: FhirUri(system), code: FhirCode(code))],
);

/// Builds the FHIR resource for one CDSi observation on a test case.
///
/// Statuses and categories follow the guides' examples: Conditions and
/// AllergyIntolerances are active and confirmed (11 and more guides send
/// verificationStatus), Conditions are problem-list items, Observations are
/// final. A planned procedure ("Undergoing ...") is in preparation; any
/// other is completed. The observation date is the onset, the effective
/// date, or the performed date, as the resource names it.
Resource _buildHistoryResource(
  String rawCode,
  String? date,
  Patient patient,
  int index,
) {
  final obsCode = rawCode.padLeft(3, '0');
  final entry = _observationResourceMap[obsCode] as Map<String, dynamic>?;
  if (entry == null) {
    throw StateError('CDSi observation $obsCode is not in the resource map');
  }
  final id = '${patient.id}_obs${index + 1}'.toFhirString;
  final code = _concept(entry['code'] as List<dynamic>);
  final when = date == null ? null : FhirDateTime.fromString(date);
  switch (entry['resource'] as String) {
    case 'Condition':
      return Condition(
        id: id,
        clinicalStatus: _hl7Concept(
          'http://terminology.hl7.org/CodeSystem/condition-clinical',
          'active',
        ),
        verificationStatus: _hl7Concept(
          'http://terminology.hl7.org/CodeSystem/condition-ver-status',
          'confirmed',
        ),
        category: [
          _hl7Concept(
            'http://terminology.hl7.org/CodeSystem/condition-category',
            'problem-list-item',
          ),
        ],
        code: code,
        subject: patient.thisReference,
        onsetX: when,
      );
    case 'AllergyIntolerance':
      return AllergyIntolerance(
        id: id,
        clinicalStatus: _hl7Concept(
          'http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical',
          'active',
        ),
        verificationStatus: _hl7Concept(
          'http://terminology.hl7.org/CodeSystem/allergyintolerance-verification',
          'confirmed',
        ),
        code: code,
        patient: patient.thisReference,
        onsetX: when,
      );
    case 'Procedure':
      final planned = (entry['title'] as String).toLowerCase().startsWith(
        'undergoing',
      );
      return Procedure(
        id: id,
        status: planned ? EventStatus.preparation : EventStatus.completed,
        code: code,
        subject: patient.thisReference,
        performedX: when,
      );
    case 'MedicationStatement':
      return MedicationStatement(
        id: id,
        status: MedicationStatementStatusCodes.active,
        medicationX: code,
        subject: patient.thisReference,
        effectiveX: when,
      );
    case 'Immunization':
      // Immunization.occurrence[x] is min 1, max 1 ("Vaccine administration
      // date"; R4 immunization.profile.json snapshot). No date in the
      // workbook means the case cannot be built faithfully, so stop rather
      // than invent one.
      if (when == null) {
        throw StateError('$obsCode is an Immunization and needs a date');
      }
      return Immunization(
        id: id,
        status: ImmunizationStatusCodes.completed,
        vaccineCode: code,
        patient: patient.thisReference,
        occurrenceX: when,
      );
    case 'Observation':
      final category = entry['category'] as String?;
      final value = entry['value'] as List<dynamic>?;
      return Observation(
        id: id,
        status: ObservationStatus.final_,
        category:
            category == null
                ? null
                : [
                  _hl7Concept(
                    'http://terminology.hl7.org/CodeSystem/observation-category',
                    category,
                  ),
                ],
        code: code,
        subject: patient.thisReference,
        effectiveX: when,
        valueX: value == null ? null : _concept(value),
      );
  }
  throw StateError('Unknown resource ${entry['resource']} for $obsCode');
}

/// The Parameters name for a clinical-history resource. ImmDS defines none;
/// the resource type, lower camel case, says what the parameter holds.
String _parameterName(Resource r) {
  final type = r.resourceType.toString();
  return type[0].toLowerCase() + type.substring(1);
}

/// Writes the testDoses map as a Dart file.
void _writeTestDosesDart(
  Map<String, List<Map<String, dynamic>>> testDoses,
  String outputPath,
  String label,
) {
  final varName = label == 'healthy' ? 'testDoses' : 'testConditionDoses';
  final sb =
      StringBuffer()
        ..writeln('final Map<String, List<Map<String, Object>>> $varName =')
        ..writeln('    <String, List<Map<String, Object>>>{');

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
    'seriesType',
  ];
  for (final key in orderedKeys) {
    if (!dose.containsKey(key) || dose[key] == null) continue;
    final value = dose[key];
    sb
      ..write("      '$key': ")
      ..writeln('${_dartLiteral(value)},');
  }
}

String _dartLiteral(dynamic value) {
  if (value is String) return "'${_escapeString(value)}'";
  if (value is int) return '$value';
  if (value is bool) return '$value';
  if (value is List) {
    if (value.every((e) => e is String)) {
      final items = value
          .map((e) => "'${_escapeString(e as String)}'")
          .join(', ');
      return '<String>[$items]';
    }
    return '$value';
  }
  return "'$value'";
}

String _escapeString(String s) => s.replaceAll("'", r"\'");

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
  final sb =
      StringBuffer()
        ..writeln('final Map<String, List<Map<String, String>>> $varName =')
        ..writeln('    <String, List<Map<String, String>>>{');

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
        sb.writeln("      '${entry.key}': '${_escapeString(entry.value)}',");
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
    // Trimmed: `2016-UC-0110 ` is published with a trailing space, and that
    // space then reached the NDJSON, the generated expectations and every id
    // printed by the tools — but not the workbook's own id column, so the case
    // could not be looked up there. It went untriaged for the whole audit
    // because the id did not survive a copy-paste. The id is CDC's, the
    // whitespace is not.
    id: row['CDC_Test_ID'].toString().trim().toFhirString,
    // No name: the workbook's Test_Case_Name is a description of the case,
    // not a person's name. Gender is AdministrativeGender: the workbooks
    // carry only F and M.
    birthDate: dob.isNotEmpty ? FhirDate.fromString(dob) : null,
    gender:
        genderVal.toLowerCase().startsWith('f')
            ? AdministrativeGender.female
            : genderVal.toLowerCase().startsWith('m')
            ? AdministrativeGender.male
            : AdministrativeGender.unknown,
  );
}
