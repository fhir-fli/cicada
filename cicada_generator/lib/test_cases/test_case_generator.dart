import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';

Future<void> main() async {
  final excelPath = _findTestCaseExcel();
  print('Using test case file: $excelPath');
  await createPatients(excelPath, scheduleSupportingData);
}

/// Auto-detect the healthy test cases Excel file.
String _findTestCaseExcel() {
  final dir = Directory('cicada_generator/lib/test_cases');
  final matches = dir
      .listSync()
      .whereType<File>()
      .where((f) =>
          f.path.contains('cdsi-healthy-childhood-and-adult-test-cases') &&
          f.path.endsWith('.xlsx'))
      .toList();
  if (matches.isEmpty) {
    throw StateError('No cdsi-healthy-childhood-and-adult-test-cases-*.xlsx found');
  }
  if (matches.length > 1) {
    throw StateError(
        'Multiple test case files found: ${matches.map((f) => f.path).join(', ')}');
  }
  return matches.first.path;
}

/// Reads the "FITS Exported TestCases" sheet directly from an Excel file,
/// parses patients, immunizations, and conditions, and writes out
/// both an NDJSON of Parameters bundles and a JSON of test doses.
Future<void> createPatients(
  String excelPath,
  ScheduleSupportingData scheduleSupportingData,
) async {
  // Load workbook and select sheet
  final bytes = File(excelPath).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel['FITS Exported TestCases'];

  // Read headers
  final headers = sheet.rows.first
      .map((cell) => cell?.value?.toString() ?? '')
      .toList();

  // Containers for output
  final Map<String, List<Map<String, dynamic>>> testDoses = {};
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
        final adminDate = dateVal.toString().substring(0, 10);
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

        // Evaluate with Cicada
        final dose = VaxDose.fromImmunization(
          imm,
          VaxDate.fromDateTime(patient.birthDate!.valueDateTime!),
        );
        if (evalStatus != null)
          dose.evalStatus = EvalStatus.fromJson(evalStatus);
        if (evalReason != null)
          dose.evalReason = EvalReason.fromJson(evalReason);

        vaxDoses.add(dose);
      }
    }

    // Dynamically find observation columns
    final obsTextCols = headers.where((h) => h == 'Med_History_Text');
    for (var textCol in obsTextCols) {
      final textVal = rowMap[textCol]?.toString() ?? '';
      final codeVal = rowMap['Med_History_Code']?.toString() ?? '';
      if (textVal.isNotEmpty) {
        final obsCode = codeVal.padLeft(3, '0');
        final obsList = scheduleSupportingData.observations?.observation ?? [];
        final match = obsList.firstWhere(
          (o) => o.observationCode == obsCode,
          orElse: () => throw Exception('Obs code $obsCode not found'),
        );
        conditions.add(
          Condition(
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
                  display: textVal.toFhirString,
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
          ),
        );
      }
    }

    // Store test doses JSON
    testDoses[patient.id.toString()] = vaxDoses.map((d) => d.toJson()).toList();

    // Build Parameters bundle
    parametersList.add(
      Parameters(
        id: 'parameters-${patient.id}'.toFhirString,
        parameter: [
          ParametersParameter(
            name: rowMap['Assessment_Date']
                .toString()
                .substring(0, 10)
                .toFhirString,
          ),
          ParametersParameter(name: 'Patient'.toFhirString, resource: patient),
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
  await File(
    'cicada_generator/lib/test_cases/test_doses.json',
  ).writeAsString(jsonEncode(testDoses));
  final ndjson = parametersList.map((p) => jsonEncode(p.toJson())).join('\n');
  await File(
    'cicada_generator/lib/test_cases/test_cases.ndjson',
  ).writeAsString(ndjson);

  // Write NDJSON to test directory
  await File('cicada/test/healthyTestCases.ndjson').writeAsString(ndjson);
  print('Wrote cicada/test/healthyTestCases.ndjson '
      '(${parametersList.length} cases)');

  // Generate test_doses.dart
  _writeTestDosesDart(testDoses);
  print('Wrote cicada/lib/generated_files/test_doses.dart '
      '(${testDoses.length} patients)');
}

/// Writes the testDoses map as a Dart file matching the existing format.
void _writeTestDosesDart(Map<String, List<Map<String, dynamic>>> testDoses) {
  final sb = StringBuffer();
  sb.writeln('final Map<String, List<Map<String, Object>>> testDoses =');
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

  File('cicada/lib/generated_files/test_doses.dart')
      .writeAsStringSync(sb.toString());
}

void _writeDoseEntry(StringBuffer sb, Map<String, dynamic> dose) {
  // Write fields in a stable order matching the existing format
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
      final items = value.map((e) => "'${_escapeString(e as String)}'").join(', ');
      return '<String>[$items]';
    }
    return '$value';
  }
  return "'$value'";
}

String _escapeString(String s) => s.replaceAll("'", "\\'");

/// Helper to build a Patient from a row map
Patient _buildPatient(Map<String, dynamic> row) {
  return Patient(
    id: row['CDC_Test_ID'].toString().toFhirString,
    name: [HumanName(family: row['Test_Case_Name']?.toString().toFhirString)],
    birthDate: FhirDate.fromString(row['DOB'].toString().substring(0, 10)),
    gender: (row['gender']?.toString().toLowerCase().contains('f') ?? false)
        ? AdministrativeGender.female
        : (row['gender']?.toString().toLowerCase().contains('t') ?? false)
        ? AdministrativeGender('transgender')
        : (row['gender']?.toString().toLowerCase().contains('m') ?? false)
        ? AdministrativeGender.male
        : AdministrativeGender.unknown,
  );
}
