import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:cicada_generator/antigen_sheet_parser.dart';
import 'package:cicada_generator/repo_root.dart';
import 'package:cicada_generator/schedule_sheet_parser.dart';
import 'package:dart_literal/dart_literal.dart';

void main(List<String> args) {
  final cdcOnly = args.contains('--cdc');
  final whoOnly = args.contains('--who');

  if (cdcOnly) {
    _generateCdc();
  } else if (whoOnly) {
    _generateWho();
  } else {
    // Default: generate both
    _generateCdc();
    _generateWho();
  }
  _formatGenerated();
}

/// The emitted files must pass the package's own lint gate
/// (very_good_analysis) with no ignore_for_file header, so the data is
/// written as Dart literals by [dartLiteral] and formatted here. Added
/// 2026-09-22 when the gate first ran on cicada: the old JSON-as-Dart
/// output carried 34,882 lint hits.
void _formatGenerated() {
  final result = Process.runSync(
    'dart',
    ['format', repoPath('cicada/lib/generated_files')],
  );
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    throw StateError('dart format failed with exit ${result.exitCode}');
  }
}

// =============================================================================
//  CDC Mode (original pipeline)
// =============================================================================

void _generateCdc() {
  // 1) Auto-detect source directory
  final sourceDir = Directory(_findVersionSubdir('Excel'));
  if (!sourceDir.existsSync()) {
    stdout.writeln('Directory not found: ${sourceDir.path}');
    return;
  }

  // 2) Create output directory, clearing old JSON to avoid stale data
  final outputDir = Directory(repoPath('cicada_generator/lib/generated_files'));
  if (outputDir.existsSync()) {
    for (final f in outputDir.listSync()) {
      if (f is File && f.path.endsWith('.json')) f.deleteSync();
    }
  } else {
    outputDir.createSync(recursive: true);
  }

  final antigenParser = AntigenSheetParser();
  final scheduleParser = ScheduleSheetParser();

  // In case you want to collect them in memory:
  final allAntigenData = <AntigenSupportingData>[];
  var scheduleData = ScheduleSupportingData();

  // 3) Iterate over files
  for (final fileEntity in sourceDir.listSync()) {
    if (fileEntity is File && fileEntity.path.endsWith('.xlsx')) {
      final filePath = fileEntity.path;
      stdout.writeln('Processing file: $filePath');

      try {
        if (filePath.contains('AntigenSupportingData')) {
          // Parse as an antigen
          final antigenData = antigenParser.parseFile(filePath);
          _assertParsedNotHeaders(antigenData, filePath);
          allAntigenData.add(antigenData);

          // Write JSON
          final jsonPath =
              '${outputDir.path}/${antigenData.targetDisease}.json';
          File(
            jsonPath,
          ).writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
          stdout.writeln('Wrote $jsonPath');
        } else if (filePath.contains('ScheduleSupportingData')) {
          // Parse as schedule
          scheduleData = scheduleParser.parseFile(filePath, scheduleData);
        } else {
          // Possibly a test-cases file or something else
          stdout.writeln(
            'Unrecognized file (not Antigen nor Schedule): $filePath',
          );
        }
      } catch (e) {
        // No fallback. Until 2026-09-06 a parse failure fell back to CDC's
        // XML rendering of the same workbook, silently: all 30 antigen
        // workbooks failed on the 4.65 layout and the engine was generated
        // from the XML for weeks while the log printed 30 errors and the
        // script exited 0. The Excel is the source of record (it is what
        // experts and other programmes can edit), so a workbook that does
        // not parse stops the run. cicada_generator/lib/check_excel_vs_xml.dart
        // proves the parse against the XML rendering.
        throw StateError('Cannot parse $filePath: $e');
      }
    }
  }

  // Merge supplementary crosswalk coded values into observations
  scheduleData = _mergeCrosswalk(scheduleData);

  // Correct CDC's own typos before anything downstream reads them.
  final scheduleJson = _correctCdcCodes(
    scheduleData.toJson(),
  );

  // Write JSON
  final jsonPath = '${outputDir.path}/schedule_supporting_data.json';
  File(jsonPath).writeAsStringSync(jsonPrettyPrint(scheduleJson));

  final scheduleWriter = DartLiteralWriter();
  final scheduleBody = scheduleWriter.literal(scheduleJson);
  final scheduleSupportingString = '''
${scheduleWriter.header}import 'package:cicada/cicada.dart';

final scheduleSupportingData = ScheduleSupportingData.fromJson(
$scheduleBody);
''';

  File(
    'cicada/lib/generated_files/schedule_supporting_data.dart',
  ).writeAsStringSync(scheduleSupportingString);

  stdout.writeln('Wrote $jsonPath');

  // Only the antigen JSON becomes a Dart file. The directory also holds the
  // FML map written by generate_observation_map_entries.dart; wrapping that
  // produced vaccine_observation_codes_map.map.dart, which broke dart format.
  for (final file in outputDir.listSync()) {
    if (file is File &&
        file.path.endsWith('.json') &&
        !file.path.contains('schedule')) {
      final fileJson =
          json.decode(file.readAsStringSync()) as Map<String, dynamic>;
      final fileName = file.path
          .split('/')
          .last
          .replaceAll('.json', '')
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_');
      final className = snakeCaseToCamelCase(fileName);
      final writer = DartLiteralWriter();
      final body = writer.literal(fileJson);
      final dartString = '''
${writer.header}import 'package:cicada/cicada.dart';

final AntigenSupportingData $className = AntigenSupportingData.fromJson(
$body);
''';
      File(
        'cicada/lib/generated_files/$fileName.dart',
      ).writeAsStringSync(dartString);
      stdout.writeln('Generated file: ${file.path}');
    }
  }

  final antigenOutputString =
      StringBuffer()..writeln("import 'package:cicada/cicada.dart';");
  final fileNames = <String>[];
  for (final agData in allAntigenData) {
    fileNames.add(
      agData.targetDisease!
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_'),
    );
  }
  for (final fileName in fileNames.toList()..sort()) {
    antigenOutputString.writeln(
      "import 'package:cicada/generated_files/$fileName.dart';",
    );
  }
  antigenOutputString.writeln(
    '\nfinal List<AntigenSupportingData> antigenSupportingData = [',
  );
  final classNames = fileNames.map(snakeCaseToCamelCase).toList();
  for (final className in classNames) {
    antigenOutputString.writeln('  $className,');
  }
  antigenOutputString
    ..writeln('];\n')
    ..writeln(
      'final Map<String, AntigenSupportingData> antigenSupportingDataMap = {',
    );
  for (final agData in allAntigenData) {
    antigenOutputString.write("  '${agData.targetDisease}': ");
    final className = snakeCaseToCamelCase(
      agData.targetDisease!
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_'),
    );
    antigenOutputString.writeln('$className,');
  }
  antigenOutputString.writeln('};\n');
  File(
    'cicada/lib/generated_files/antigen_supporting_data.dart',
  ).writeAsStringSync(antigenOutputString.toString());
}

// =============================================================================
//  WHO Mode
// =============================================================================

void _generateWho() {
  final antigenDir = Directory(repoPath('cicada_generator/lib/WHO/antigen'));
  final scheduleDir = Directory(repoPath('cicada_generator/lib/WHO/schedule'));

  if (!antigenDir.existsSync()) {
    stdout.writeln('WHO antigen directory not found: ${antigenDir.path}');
    return;
  }

  // Create output directories
  final outputJsonDir = Directory(
    repoPath('cicada_generator/lib/generated_files/who'),
  );
  if (outputJsonDir.existsSync()) {
    for (final f in outputJsonDir.listSync()) {
      if (f is File && f.path.endsWith('.json')) f.deleteSync();
    }
  } else {
    outputJsonDir.createSync(recursive: true);
  }

  final dartOutputDir = Directory('cicada/lib/generated_files/who');
  if (!dartOutputDir.existsSync()) {
    dartOutputDir.createSync(recursive: true);
  }

  final antigenParser = AntigenSheetParser();
  final scheduleParser = ScheduleSheetParser();
  // Use a map to deduplicate by targetDisease (xlsx takes precedence over JSON)
  final antigenByDisease = <String, AntigenSupportingData>{};
  var scheduleData = ScheduleSupportingData();

  // ---------- Process antigen files ----------
  // Process json first, then xlsx (so xlsx overwrites json for same disease)
  final files =
      antigenDir.listSync().whereType<File>().toList()..sort((a, b) {
        // json before xlsx so xlsx takes precedence
        final aIsXlsx = a.path.endsWith('.xlsx') ? 1 : 0;
        final bIsXlsx = b.path.endsWith('.xlsx') ? 1 : 0;
        return aIsXlsx.compareTo(bIsXlsx);
      });

  for (final fileEntity in files) {
    final filePath = fileEntity.path;

    if (filePath.endsWith('.xlsx')) {
      stdout.writeln('Processing WHO antigen Excel: $filePath');
      try {
        final antigenData = antigenParser.parseFile(filePath);
        final disease = antigenData.targetDisease;
        if (disease != null) {
          antigenByDisease[disease] = antigenData;
          final jsonPath = '${outputJsonDir.path}/$disease.json';
          File(
            jsonPath,
          ).writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
          stdout.writeln('Wrote $jsonPath');
        }
      } on Object catch (e) {
        stderr.writeln('ERROR processing $filePath: $e');
        exitCode = 1;
      }
    } else if (filePath.endsWith('.json')) {
      stdout.writeln('Processing WHO antigen JSON: $filePath');
      try {
        final jsonData =
            json.decode(File(filePath).readAsStringSync())
                as Map<String, dynamic>;
        var antigenData = AntigenSupportingData.fromJson(jsonData);
        if (antigenData.targetDisease == null &&
            antigenData.series != null &&
            antigenData.series!.isNotEmpty) {
          antigenData = antigenData.copyWith(
            targetDisease: antigenData.series!.first.targetDisease,
            vaccineGroup: antigenData.series!.first.vaccineGroup,
          );
        }
        final disease = antigenData.targetDisease;
        if (disease != null) {
          antigenByDisease[disease] = antigenData;
          final jsonPath = '${outputJsonDir.path}/$disease.json';
          File(
            jsonPath,
          ).writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
          stdout.writeln('Wrote $jsonPath');
        }
      } on Object catch (e) {
        stderr.writeln('ERROR processing $filePath: $e');
        exitCode = 1;
      }
    }
  }

  final allAntigenData = antigenByDisease.values.toList();

  // ---------- Process schedule files ----------
  if (scheduleDir.existsSync()) {
    // Sort: json first, then xlsx (so xlsx overwrites json)
    final schedFiles =
        scheduleDir.listSync().whereType<File>().toList()..sort((a, b) {
          final aIsXlsx = a.path.endsWith('.xlsx') ? 1 : 0;
          final bIsXlsx = b.path.endsWith('.xlsx') ? 1 : 0;
          return aIsXlsx.compareTo(bIsXlsx);
        });
    for (final fileEntity in schedFiles) {
      final filePath = fileEntity.path;

      if (filePath.endsWith('.xlsx')) {
        stdout.writeln('Processing WHO schedule Excel: $filePath');
        try {
          scheduleData = scheduleParser.parseFile(filePath, scheduleData);
        } on Object catch (e) {
          stderr.writeln('ERROR processing $filePath: $e');
          exitCode = 1;
        }
      } else if (filePath.endsWith('.json')) {
        stdout.writeln('Processing WHO schedule JSON: $filePath');
        try {
          final jsonData =
              json.decode(File(filePath).readAsStringSync())
                  as Map<String, dynamic>;
          final partial = ScheduleSupportingData.fromJson(jsonData);
          scheduleData = ScheduleSupportingData(
            liveVirusConflicts:
                partial.liveVirusConflicts ?? scheduleData.liveVirusConflicts,
            vaccineGroups: partial.vaccineGroups ?? scheduleData.vaccineGroups,
            vaccineGroupToAntigenMap:
                partial.vaccineGroupToAntigenMap ??
                scheduleData.vaccineGroupToAntigenMap,
            cvxToAntigenMap:
                partial.cvxToAntigenMap ?? scheduleData.cvxToAntigenMap,
            observations: partial.observations ?? scheduleData.observations,
          );
        } on Object catch (e) {
          stderr.writeln('ERROR processing $filePath: $e');
          exitCode = 1;
        }
      }
    }
  }

  // ---------- Write schedule Dart ----------
  final scheduleJsonPath =
      '${outputJsonDir.path}/schedule_supporting_data.json';
  File(
    scheduleJsonPath,
  ).writeAsStringSync(jsonPrettyPrint(scheduleData.toJson()));

  final scheduleWriter = DartLiteralWriter();
  final scheduleBody = scheduleWriter.literal(scheduleData.toJson());
  final scheduleDartString = '''
${scheduleWriter.header}import 'package:cicada/cicada.dart';

final whoScheduleSupportingData = ScheduleSupportingData.fromJson(
$scheduleBody);
''';

  File(
    '${dartOutputDir.path}/who_schedule_supporting_data.dart',
  ).writeAsStringSync(scheduleDartString);
  stdout.writeln('Wrote WHO schedule supporting data');

  // ---------- Write antigen Dart files ----------
  for (final file in outputJsonDir.listSync()) {
    if (file is File &&
        file.path.endsWith('.json') &&
        !file.path.contains('schedule')) {
      final fileJson =
          json.decode(file.readAsStringSync()) as Map<String, dynamic>;
      final fileName = file.path
          .split('/')
          .last
          .replaceAll('.json', '')
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_');
      final camel = snakeCaseToCamelCase(fileName);
      final className =
          'who${camel.replaceRange(0, 1, camel[0].toUpperCase())}';
      final writer = DartLiteralWriter();
      final body = writer.literal(fileJson);
      final dartString = '''
${writer.header}import 'package:cicada/cicada.dart';

final AntigenSupportingData $className = AntigenSupportingData.fromJson(
$body);
''';
      File(
        '${dartOutputDir.path}/$fileName.dart',
      ).writeAsStringSync(dartString);
      stdout.writeln('Generated WHO file: $fileName.dart');
    }
  }

  // ---------- Write barrel file ----------
  final antigenOutputString =
      StringBuffer()..writeln("import 'package:cicada/cicada.dart';");
  final fileNames = <String>[];
  for (final agData in allAntigenData) {
    fileNames.add(
      agData.targetDisease!
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_'),
    );
  }
  for (final fileName in fileNames.toList()..sort()) {
    antigenOutputString.writeln(
      "import 'package:cicada/generated_files/who/$fileName.dart';",
    );
  }
  // Schedule is imported separately; not needed in the barrel file.

  // List
  antigenOutputString.writeln(
    '\nfinal List<AntigenSupportingData> whoAntigenSupportingData = [',
  );
  final classNames =
      fileNames.map((e) {
        final camel = snakeCaseToCamelCase(e);
        return 'who${camel.replaceRange(0, 1, camel[0].toUpperCase())}';
      }).toList();
  for (final className in classNames) {
    antigenOutputString.writeln('  $className,');
  }
  antigenOutputString
    ..writeln('];\n')
    // Map
    ..writeln(
      'final Map<String, AntigenSupportingData> '
      'whoAntigenSupportingDataMap = {',
    );
  for (var i = 0; i < allAntigenData.length; i++) {
    antigenOutputString.writeln(
      "  '${allAntigenData[i].targetDisease}': ${classNames[i]},",
    );
  }
  antigenOutputString.writeln('};\n');

  File(
    '${dartOutputDir.path}/who_antigen_supporting_data.dart',
  ).writeAsStringSync(antigenOutputString.toString());

  stdout
    ..writeln('\nWHO generation complete:')
    ..writeln('  ${allAntigenData.length} antigens')
    ..writeln('  Output: ${dartOutputDir.path}/');
}

// =============================================================================
//  Shared Utilities
// =============================================================================

const jsonEncoder = JsonEncoder.withIndent('    ');

String jsonPrettyPrint(Map<String, dynamic> map) => jsonEncoder.convert(map);

String snakeCaseToCamelCase(String snakeCaseString) {
  final parts = snakeCaseString.split('_');
  if (parts.isEmpty) {
    return '';
  }
  if (parts.length == 1) {
    if (parts.first.isNotEmpty) {
      if (parts.first.length == 1) {
        return parts.first.toLowerCase();
      } else {
        return parts.first[0].toLowerCase() + parts.first.substring(1);
      }
    }
    return parts.first;
  }
  final camelCaseString = StringBuffer(parts.first.toLowerCase());
  for (var i = 1; i < parts.length; i++) {
    final part = parts[i];
    if (part.isEmpty) {
      continue;
    }
    camelCaseString.write(
      part[0].toUpperCase() + part.substring(1).toLowerCase(),
    );
  }
  return camelCaseString.toString();
}

/// Merges supplementary crosswalk data (ICD-10-CM, LOINC, RxNorm, CPT) into
/// the observation coded values parsed from the CDC Excel.
ScheduleSupportingData _mergeCrosswalk(ScheduleSupportingData data) {
  final crosswalkFile = File(
    repoPath('cicada_generator/lib/crosswalk/observation_crosswalk.json'),
  );
  if (!crosswalkFile.existsSync()) {
    stdout.writeln('No crosswalk file found, skipping merge.');
    return data;
  }

  final crosswalk =
      json.decode(crosswalkFile.readAsStringSync()) as Map<String, dynamic>;
  final observations = data.observations?.observation;
  if (observations == null || observations.isEmpty) return data;

  final updatedObs = <VaxObservation>[];
  for (final obs in observations) {
    final obsCode = obs.observationCode;
    final crosswalkEntry =
        obsCode != null ? crosswalk[obsCode] as Map<String, dynamic>? : null;
    if (crosswalkEntry == null) {
      updatedObs.add(obs);
      continue;
    }

    final existingCoded = List<CodedValue>.from(
      obs.codedValues?.codedValue ?? [],
    );

    for (final entry in crosswalkEntry.entries) {
      final codeSystem = entry.key;
      if (codeSystem.startsWith('_')) continue; // skip _comment etc.
      final codes = entry.value as List<dynamic>;
      for (final codeEntry in codes) {
        final codeMap = codeEntry as Map<String, dynamic>;
        existingCoded.add(
          CodedValue(
            code: codeMap['code'] as String?,
            codeSystem: codeSystem,
            text: codeMap['text'] as String?,
          ),
        );
      }
    }

    updatedObs.add(
      obs.copyWith(
        codedValues: CodedValues(codedValue: existingCoded),
      ),
    );
  }

  return ScheduleSupportingData(
    liveVirusConflicts: data.liveVirusConflicts,
    vaccineGroups: data.vaccineGroups,
    vaccineGroupToAntigenMap: data.vaccineGroupToAntigenMap,
    cvxToAntigenMap: data.cvxToAntigenMap,
    observations: VaxObservations(observation: updatedObs),
  );
}

class AntigenClass {
  AntigenClass(this.diseaseName, this.fileName, this.className);
  final String diseaseName;
  final String fileName;
  final String className;
}

/// Auto-detect the Version_* directory containing [subdir] (e.g. 'Excel').
String _findVersionSubdir(String subdir) {
  final baseDir = Directory('cicada_generator/lib');
  final matches =
      baseDir
          .listSync()
          .whereType<Directory>()
          .where(
            (d) =>
                d.path.split('/').last.startsWith('Version_') &&
                Directory('${d.path}/$subdir').existsSync(),
          )
          .toList();
  if (matches.isEmpty) {
    throw StateError('No Version_* directory with $subdir/ found');
  }
  if (matches.length > 1) {
    throw StateError(
      'Multiple Version_* directories with $subdir/ found: ${matches.map((d) => d.path).join(', ')}',
    );
  }
  return '${matches.first.path}/$subdir';
}

/// Column labels that must never survive into parsed data.
///
/// The sheets are matched by name, and their column layout is not part of any
/// contract — CDSi 4.65 merged "Risk 1-dose" and "Risk 4-dose" into a single
/// "Risk series" sheet, which the `contains('dose')` detector missed. The
/// parser then fell through to a looser branch and read the header row as
/// values, producing series whose seriesGroupName was literally "Series Group
/// Name". It compiled, it analyzed clean, and 776 tests failed.
///
/// A header string appearing as data means the sheet moved under the parser.
/// Fail here rather than write it out.
const List<String> _headerLabels = <String>[
  'Series Group Name',
  'Series Group',
  'Minimum Age To Start',
  'Maximum Age To Start',
  'Series Name',
  'Series Type',
  'Dose Number',
  'Vaccine Group',
  'Target Disease',
];

void _assertParsedNotHeaders(AntigenSupportingData data, String filePath) {
  final encoded = jsonPrettyPrint(data.toJson());
  for (final label in _headerLabels) {
    if (encoded.contains('": "$label"')) {
      throw StateError(
        'Parsed "$label" as a VALUE from $filePath.\n'
        'That is a column header, so the sheet layout has moved under the '
        'parser and the output would be garbage. Fix '
        'antigen_sheet_parser.dart for this CDSi release before regenerating.',
      );
    }
  }
}

/// Corrections to codes CDC publishes that exist in no SNOMED edition.
///
/// Each entry is a verified typo, not a judgement: the published code resolves
/// nowhere, and the replacement carries CDC's own text as its display. Applied
/// in the generator rather than by hand so a regeneration cannot quietly
/// reinstate them. Every one is also reported to CDC.
///
/// 2219088009 -> 219088009. CDC labels it "Adverse reaction to meningococcal
/// vaccine [disorder]", which is the exact display of 219088009; their code
/// carries an extra leading 2 and resolves in no edition, checked against
/// tx.fhir.org for International and for the US edition 731000124108 on
/// 2026-09-04. It sits on observation 095, "Severe allergic reaction after
/// previous dose of Meningococcal", so while it is wrong a patient with a
/// documented reaction to a meningococcal vaccine matches nothing and the
/// engine forecasts MenACWY for them.
const Map<String, String> _cdcCodeCorrections = <String, String>{
  '2219088009': '219088009',
};

/// Applies [_cdcCodeCorrections] to every SNOMED coded value in the schedule
/// supporting data, working on the JSON because the model is immutable.
Map<String, dynamic> _correctCdcCodes(Map<String, dynamic> json) {
  var corrected = 0;
  final observations =
      (json['observations'] as Map<String, dynamic>?)?['observation']
          as List<dynamic>?;
  for (final o in observations ?? <dynamic>[]) {
    final obs = o as Map<String, dynamic>;
    final coded =
        (obs['codedValues'] as Map<String, dynamic>?)?['codedValue']
            as List<dynamic>?;
    for (final c in coded ?? <dynamic>[]) {
      final cv = c as Map<String, dynamic>;
      final fixed = _cdcCodeCorrections[cv['code']];
      if (cv['codeSystem'] == 'SNOMED' && fixed != null) {
        stdout.writeln(
          '  correcting CDC code ${cv['code']} -> $fixed on '
          'observation ${obs['observationCode']}',
        );
        cv['code'] = fixed;
        corrected++;
      }
    }
  }
  stdout.writeln('Applied $corrected CDC code correction(s).');
  return json;
}
