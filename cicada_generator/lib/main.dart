import 'dart:convert';
import 'dart:io';
import 'package:cicada/cicada.dart';
import 'package:cicada_generator/antigen_sheet_parser.dart';
import 'package:cicada_generator/schedule_sheet_parser.dart';

void main(List<String> args) {
  final whoMode = args.contains('--who');

  if (whoMode) {
    _generateWho();
  } else {
    _generateCdc();
  }
}

// =============================================================================
//  CDC Mode (original pipeline)
// =============================================================================

void _generateCdc() {
  // 1) Auto-detect source directory
  final sourceDir = Directory(_findVersionSubdir('Excel'));
  if (!sourceDir.existsSync()) {
    print("Directory not found: ${sourceDir.path}");
    return;
  }

  // 2) Create output directory, clearing old JSON to avoid stale data
  final outputDir = Directory('cicada_generator/lib/generated_files');
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
  final List<AntigenSupportingData> allAntigenData = [];
  var scheduleData = ScheduleSupportingData();

  // 3) Iterate over files
  for (final fileEntity in sourceDir.listSync()) {
    if (fileEntity is File && fileEntity.path.endsWith('.xlsx')) {
      final filePath = fileEntity.path;
      print('Processing file: $filePath');

      try {
        if (filePath.contains('AntigenSupportingData')) {
          // Parse as an antigen
          final antigenData = antigenParser.parseFile(filePath);
          allAntigenData.add(antigenData);

          // Write JSON
          final jsonPath =
              '${outputDir.path}/${antigenData.targetDisease}.json';
          File(jsonPath)
              .writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
          print('Wrote $jsonPath');
        } else if (filePath.contains('ScheduleSupportingData')) {
          // Parse as schedule
          scheduleData = scheduleParser.parseFile(filePath, scheduleData);
        } else {
          // Possibly a test-cases file or something else
          print('Unrecognized file (not Antigen nor Schedule): $filePath');
        }
      } catch (e) {
        print('ERROR processing $filePath: $e');
        if (filePath.contains('AntigenSupportingData')) {
          // Fall back to XML-derived JSON
          final jsonDir = _findVersionSubdir('JSON');
          final jsonFileName = filePath
              .split('/')
              .last
              .replaceAll('.xlsx', '.json');
          final jsonFile = File('$jsonDir/$jsonFileName');
          if (jsonFile.existsSync()) {
            print('Falling back to XML-derived JSON: ${jsonFile.path}');
            final jsonData =
                json.decode(jsonFile.readAsStringSync()) as Map<String, dynamic>;
            var antigenData = AntigenSupportingData.fromJson(jsonData);
            // XML format may not set targetDisease at top level; extract from series
            if (antigenData.targetDisease == null &&
                antigenData.series != null &&
                antigenData.series!.isNotEmpty) {
              antigenData = antigenData.copyWith(
                targetDisease: antigenData.series!.first.targetDisease,
                vaccineGroup: antigenData.series!.first.vaccineGroup,
              );
            }
            allAntigenData.add(antigenData);
            final outPath =
                '${outputDir.path}/${antigenData.targetDisease}.json';
            File(outPath)
                .writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
            print('Wrote $outPath (from XML fallback)');
          } else {
            print('No XML fallback found, skipping.');
          }
        } else {
          print('Skipping this file.');
        }
      }
    }
  }

  // Merge supplementary crosswalk coded values into observations
  scheduleData = _mergeCrosswalk(scheduleData);

  // Write JSON
  final jsonPath = '${outputDir.path}/schedule_supporting_data.json';
  File(jsonPath).writeAsStringSync(jsonPrettyPrint(scheduleData.toJson()));

  final scheduleSupportingString =
      '''
import 'package:cicada/cicada.dart';

final scheduleSupportingData = ScheduleSupportingData.fromJson(
${jsonPrettyPrint(scheduleData.toJson())});
''';

  File(
    'cicada/lib/generated_files/schedule_supporting_data.dart',
  ).writeAsStringSync(scheduleSupportingString);

  print('Wrote $jsonPath');

  for (final file in outputDir.listSync()) {
    if (file is File && !file.path.contains('schedule')) {
      final fileString = file.readAsStringSync();
      final fileName = file.path
          .split('/')
          .last
          .replaceAll('.json', '')
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_');
      final className = snakeCaseToCamelCase(fileName);
      final dartString =
          '''
// ignore_for_file: prefer_single_quotes, always_specify_types

import '../cicada.dart';

final AntigenSupportingData $className = AntigenSupportingData.fromJson(
$fileString);
''';
      File(
        'cicada/lib/generated_files/$fileName.dart',
      ).writeAsStringSync(dartString);
      print('Generated file: ${file.path}');
    }
  }

  final antigenOutputString = StringBuffer();
  final fileNames = <String>[];
  for (final agData in allAntigenData) {
    fileNames.add(
      agData.targetDisease!
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_'),
    );
  }
  for (final fileName in fileNames) {
    antigenOutputString.writeln("import '$fileName.dart';");
  }
  antigenOutputString.writeln('\n\nfinal antigenSupportingData = [');
  final classNames = fileNames.map((e) => snakeCaseToCamelCase(e)).toList();
  for (final className in classNames) {
    antigenOutputString.writeln('  $className,');
  }
  antigenOutputString.writeln('];\n');
  antigenOutputString.writeln('final antigenSupportingDataMap = {');
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
  final antigenDir = Directory('cicada_generator/lib/WHO/antigen');
  final scheduleDir = Directory('cicada_generator/lib/WHO/schedule');

  if (!antigenDir.existsSync()) {
    print('WHO antigen directory not found: ${antigenDir.path}');
    return;
  }

  // Create output directories
  final outputJsonDir = Directory('cicada_generator/lib/generated_files/who');
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
  // Use a map to deduplicate by targetDisease (JSON takes precedence over xlsx)
  final Map<String, AntigenSupportingData> antigenByDisease = {};
  var scheduleData = ScheduleSupportingData();

  // ---------- Process antigen files ----------
  // Process xlsx first, then json (so json overwrites xlsx for same disease)
  final files = antigenDir.listSync().whereType<File>().toList()
    ..sort((a, b) {
      // xlsx before json so json takes precedence
      final aIsJson = a.path.endsWith('.json') ? 1 : 0;
      final bIsJson = b.path.endsWith('.json') ? 1 : 0;
      return aIsJson.compareTo(bIsJson);
    });

  for (final fileEntity in files) {
    final filePath = fileEntity.path;

    if (filePath.endsWith('.xlsx')) {
      print('Processing WHO antigen Excel: $filePath');
      try {
        final antigenData = antigenParser.parseFile(filePath);
        final disease = antigenData.targetDisease;
        if (disease != null) {
          antigenByDisease[disease] = antigenData;
          final jsonPath = '${outputJsonDir.path}/$disease.json';
          File(jsonPath)
              .writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
          print('Wrote $jsonPath');
        }
      } catch (e) {
        print('ERROR processing $filePath: $e');
      }
    } else if (filePath.endsWith('.json')) {
      print('Processing WHO antigen JSON: $filePath');
      try {
        final jsonData = json.decode(File(filePath).readAsStringSync())
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
          File(jsonPath)
              .writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
          print('Wrote $jsonPath');
        }
      } catch (e) {
        print('ERROR processing $filePath: $e');
      }
    }
  }

  final allAntigenData = antigenByDisease.values.toList();

  // ---------- Process schedule files ----------
  if (scheduleDir.existsSync()) {
    for (final fileEntity in scheduleDir.listSync()) {
      if (fileEntity is! File) continue;
      final filePath = fileEntity.path;

      if (filePath.endsWith('.xlsx')) {
        print('Processing WHO schedule Excel: $filePath');
        try {
          scheduleData = scheduleParser.parseFile(filePath, scheduleData);
        } catch (e) {
          print('ERROR processing $filePath: $e');
        }
      } else if (filePath.endsWith('.json')) {
        print('Processing WHO schedule JSON: $filePath');
        try {
          final jsonData = json.decode(File(filePath).readAsStringSync())
              as Map<String, dynamic>;
          final partial = ScheduleSupportingData.fromJson(jsonData);
          scheduleData = ScheduleSupportingData(
            liveVirusConflicts:
                partial.liveVirusConflicts ?? scheduleData.liveVirusConflicts,
            vaccineGroups:
                partial.vaccineGroups ?? scheduleData.vaccineGroups,
            vaccineGroupToAntigenMap: partial.vaccineGroupToAntigenMap ??
                scheduleData.vaccineGroupToAntigenMap,
            cvxToAntigenMap:
                partial.cvxToAntigenMap ?? scheduleData.cvxToAntigenMap,
            observations:
                partial.observations ?? scheduleData.observations,
          );
        } catch (e) {
          print('ERROR processing $filePath: $e');
        }
      }
    }
  }

  // ---------- Write schedule Dart ----------
  final scheduleJsonPath =
      '${outputJsonDir.path}/schedule_supporting_data.json';
  File(scheduleJsonPath)
      .writeAsStringSync(jsonPrettyPrint(scheduleData.toJson()));

  final scheduleDartString = '''
// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final whoScheduleSupportingData = ScheduleSupportingData.fromJson(
${jsonPrettyPrint(scheduleData.toJson())});
''';

  File('${dartOutputDir.path}/who_schedule_supporting_data.dart')
      .writeAsStringSync(scheduleDartString);
  print('Wrote WHO schedule supporting data');

  // ---------- Write antigen Dart files ----------
  for (final file in outputJsonDir.listSync()) {
    if (file is File &&
        file.path.endsWith('.json') &&
        !file.path.contains('schedule')) {
      final fileString = file.readAsStringSync();
      final fileName = file.path
          .split('/')
          .last
          .replaceAll('.json', '')
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_');
      final className = 'who${snakeCaseToCamelCase(fileName).replaceRange(0, 1, snakeCaseToCamelCase(fileName)[0].toUpperCase())}';
      final dartString = '''
// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData $className = AntigenSupportingData.fromJson(
$fileString);
''';
      File('${dartOutputDir.path}/$fileName.dart')
          .writeAsStringSync(dartString);
      print('Generated WHO file: $fileName.dart');
    }
  }

  // ---------- Write barrel file ----------
  final antigenOutputString = StringBuffer();
  final fileNames = <String>[];
  for (final agData in allAntigenData) {
    fileNames.add(
      agData.targetDisease!
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('-', '_'),
    );
  }
  for (final fileName in fileNames) {
    antigenOutputString.writeln("import '$fileName.dart';");
  }
  // Schedule is imported separately; not needed in the barrel file.

  // List
  antigenOutputString.writeln('\n\nfinal whoAntigenSupportingData = [');
  final classNames = fileNames.map((e) {
    final camel = snakeCaseToCamelCase(e);
    return 'who${camel.replaceRange(0, 1, camel[0].toUpperCase())}';
  }).toList();
  for (final className in classNames) {
    antigenOutputString.writeln('  $className,');
  }
  antigenOutputString.writeln('];\n');

  // Map
  antigenOutputString.writeln('final whoAntigenSupportingDataMap = {');
  for (var i = 0; i < allAntigenData.length; i++) {
    antigenOutputString.writeln(
        "  '${allAntigenData[i].targetDisease}': ${classNames[i]},");
  }
  antigenOutputString.writeln('};\n');

  File('${dartOutputDir.path}/who_antigen_supporting_data.dart')
      .writeAsStringSync(antigenOutputString.toString());

  print('\nWHO generation complete:');
  print('  ${allAntigenData.length} antigens');
  print('  Output: ${dartOutputDir.path}/');
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
  final crosswalkFile =
      File('cicada_generator/lib/crosswalk/observation_crosswalk.json');
  if (!crosswalkFile.existsSync()) {
    print('No crosswalk file found, skipping merge.');
    return data;
  }

  final crosswalk = json.decode(crosswalkFile.readAsStringSync())
      as Map<String, dynamic>;
  final observations = data.observations?.observation;
  if (observations == null || observations.isEmpty) return data;

  final updatedObs = <VaxObservation>[];
  for (final obs in observations) {
    final obsCode = obs.observationCode;
    final crosswalkEntry = obsCode != null
        ? crosswalk[obsCode] as Map<String, dynamic>?
        : null;
    if (crosswalkEntry == null) {
      updatedObs.add(obs);
      continue;
    }

    final existingCoded =
        List<CodedValue>.from(obs.codedValues?.codedValue ?? []);

    for (final entry in crosswalkEntry.entries) {
      final codeSystem = entry.key;
      if (codeSystem.startsWith('_')) continue; // skip _comment etc.
      final codes = entry.value as List<dynamic>;
      for (final codeEntry in codes) {
        final codeMap = codeEntry as Map<String, dynamic>;
        existingCoded.add(CodedValue(
          code: codeMap['code'] as String?,
          codeSystem: codeSystem,
          text: codeMap['text'] as String?,
        ));
      }
    }

    updatedObs.add(obs.copyWith(
      codedValues: CodedValues(codedValue: existingCoded),
    ));
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
  final matches = baseDir
      .listSync()
      .whereType<Directory>()
      .where((d) =>
          d.path.split('/').last.startsWith('Version_') &&
          Directory('${d.path}/$subdir').existsSync())
      .toList();
  if (matches.isEmpty) {
    throw StateError('No Version_* directory with $subdir/ found');
  }
  if (matches.length > 1) {
    throw StateError(
        'Multiple Version_* directories with $subdir/ found: ${matches.map((d) => d.path).join(', ')}');
  }
  return '${matches.first.path}/$subdir';
}
