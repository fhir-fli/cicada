import 'dart:convert';
import 'dart:io';
import 'package:cicada/cicada.dart';
import 'package:cicada_generator/antigen_sheet_parser.dart';
import 'package:cicada_generator/schedule_sheet_parser.dart';

void main(List<String> args) {
  // 1) Identify your source directory
  final sourceDir = Directory('cicada_generator/lib/Version_4.61-508/Excel');
  if (!sourceDir.existsSync()) {
    print("Directory not found: ${sourceDir.path}");
    return;
  }

  // 2) Create output directory if desired
  final outputDir = Directory('cicada_generator/lib/generated_files');
  if (!outputDir.existsSync()) {
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

      if (filePath.contains('AntigenSupportingData')) {
        // Parse as an antigen
        final antigenData = antigenParser.parseFile(filePath);
        allAntigenData.add(antigenData);

        // Write JSON
        final jsonPath = '${outputDir.path}/${antigenData.targetDisease}.json';
        File(jsonPath).writeAsStringSync(jsonPrettyPrint(antigenData.toJson()));
        print('Wrote $jsonPath');
      } else if (filePath.contains('ScheduleSupportingData')) {
        // Parse as schedule
        scheduleData = scheduleParser.parseFile(filePath, scheduleData);
      } else {
        // Possibly a test-cases file or something else
        print('Unrecognized file (not Antigen nor Schedule): $filePath');
      }
    }
  }

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

class AntigenClass {
  AntigenClass(this.diseaseName, this.fileName, this.className);
  final String diseaseName;
  final String fileName;
  final String className;
}
