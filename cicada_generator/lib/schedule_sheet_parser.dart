import 'dart:io';
import 'package:excel/excel.dart';
import 'package:cicada/cicada.dart';

/// A parser that reads a single Excel file for one piece of the
/// Schedule Supporting Data, then merges it into an existing
/// [ScheduleSupportingData] object.
///
/// Each file is expected to have only one relevant tab:
///  - "Coded Observations" file -> "Conditions" tab
///  - "CVX to Antigen Map" file -> "CVX to Antigen Map" tab
///  - "Live Virus Conflicts" file -> "Live Virus Conflicts" tab
///  - "Vaccine Group to Antigen Map" file -> "Vaccine Group to Antigen Map" tab
///  - "Vaccine Group" file -> "Vaccine Groups" tab
class ScheduleSheetParser {
  /// Parse the Excel file at [path], reading only the relevant tab,
  /// merging the parsed data into [oldScheduleData], and returning
  /// the updated object.
  ///
  /// The [path] filename determines which parse logic we use:
  ///  - If it contains "Coded Observations" -> parse "Conditions" tab
  ///  - If it contains "CVX to Antigen Map" -> parse "CVX to Antigen Map" tab
  ///  - If it contains "Live Virus Conflicts" -> parse "Live Virus Conflicts" tab
  ///  - If it contains "Vaccine Group to Antigen Map" -> parse "Vaccine Group to Antigen Map" tab
  ///  - If it contains "Vaccine Group" -> parse "Vaccine Groups" tab
  ///
  /// If the filename doesn't match, we just return [oldScheduleData] unchanged.
  ScheduleSupportingData parseFile(
    String path,
    ScheduleSupportingData oldScheduleData,
  ) {
    // 1) Read Excel
    final bytes = File(path).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    // We'll create a local "partial" result, then merge it into oldScheduleData
    var partial = ScheduleSupportingData();

    // 2) Check which type of file we have
    final lower = path.toLowerCase();
    if (lower.contains('coded observations')) {
      // We'll parse the "Conditions" tab
      final tabName = 'Conditions';
      if (excel.tables.keys.contains(tabName)) {
        final sheet = excel.tables[tabName]!;
        final rows = _sheetToRows(sheet);
        final obsList = _parseConditionsTab(rows);
        partial = partial.copyWith(
          observations:
              partial.observations?.copyWith(observation: obsList) ??
              VaxObservations(observation: obsList),
        );
      }
    } else if (lower.contains('cvx to antigen map')) {
      // We'll parse the "CVX to Antigen Map" tab
      final tabName = 'CVX to Antigen Map';
      if (excel.tables.keys.contains(tabName)) {
        final sheet = excel.tables[tabName]!;
        final rows = _sheetToRows(sheet);
        final cvxList = _parseCvxToAntigenMapTab(rows);
        partial = partial.copyWith(
          cvxToAntigenMap:
              partial.cvxToAntigenMap?.copyWith(cvxMap: cvxList) ??
              CvxToAntigenMap(cvxMap: cvxList),
        );
      }
    } else if (lower.contains('live virus conflicts')) {
      // We'll parse the "Live Virus Conflicts" tab
      final tabName = 'Live Virus Conflicts';
      if (excel.tables.keys.contains(tabName)) {
        final sheet = excel.tables[tabName]!;
        final rows = _sheetToRows(sheet);
        final conflicts = _parseLiveVirusConflictsTab(rows);
        partial = partial.copyWith(liveVirusConflicts: conflicts);
      }
    } else if (lower.contains('vaccine group to antigen map')) {
      // We'll parse the "Vaccine Group to Antigen Map" tab
      final tabName = 'Vaccine Group to Antigen Map';
      if (excel.tables.keys.contains(tabName)) {
        final sheet = excel.tables[tabName]!;
        final rows = _sheetToRows(sheet);
        final groupMaps = _parseVaccineGroupToAntigenMapTab(rows);
        partial = partial.copyWith(
          vaccineGroupToAntigenMap:
              partial.vaccineGroupToAntigenMap?.copyWith(
                vaccineGroupMap: groupMaps,
              ) ??
              VaccineGroupToAntigenMap(vaccineGroupMap: groupMaps),
        );
      }
    } else if (lower.contains('vaccine group') &&
        !lower.contains('antigen map')) {
      // We'll parse the "Vaccine Groups" tab
      final tabName = 'Vaccine Groups';
      if (excel.tables.keys.contains(tabName)) {
        final sheet = excel.tables[tabName]!;
        final rows = _sheetToRows(sheet);
        final groupData = _parseVaccineGroupsTab(rows);
        partial = partial.copyWith(vaccineGroups: groupData);
      }
    } else {
      // If filename doesn't match any known pattern, do nothing
      print('parseFile: $path does not match a known schedule file type.');
    }

    // 3) Merge partial data into oldScheduleData
    return _mergeSchedules(oldScheduleData, partial);
  }

  /// Utility to convert an Excel sheet to a List<List<String>> of row data
  List<List<String>> _sheetToRows(Sheet sheet) {
    return sheet.rows
        .map(
          (row) => row
              .map(
                (cell) =>
                    cell?.value?.toString().replaceAll('\n', ' ').trim() ?? '',
              )
              .toList(),
        )
        .toList();
  }

  // ---------------------------------------------------------------------------
  //   1) Parse "Conditions" tab (Coded Observations)
  // ---------------------------------------------------------------------------
  ///
  /// Example columns (customize to your actual layout):
  /// [0] Observation Code
  /// [1] Observation Title
  /// [2] Indication Text
  /// [3] Contraindication Text
  /// [4] Clarifying Text
  /// ...
  List<VaxObservation> _parseConditionsTab(List<List<String>> rows) {
    final obsList = <VaxObservation>[];
    if (rows.isEmpty) return obsList;

    // Assume first row might be headers, so start from row 1
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final obsCode = row[0].trim();
      final obsTitle = row.length > 1 ? row[1].trim() : '';
      final indication = row.length > 2 ? row[2].trim() : '';
      final contra = row.length > 3 ? row[3].trim() : '';
      final clarify = row.length > 4 ? row[4].trim() : '';
      final codedValues = <CodedValue>[];

      if (row.length > 5 && row[5].trim().isNotEmpty) {
        final codeStrings = row[5].trim().split(';');
        for (final codeString in codeStrings) {
          final (code, text) = _extractCodeAndText(codeString);
          if (code.isNotEmpty) {
            codedValues.add(
              CodedValue(code: code, text: text, codeSystem: 'SNOMED'),
            );
          }
        }
      }

      if (row.length > 6 && row[6].trim().isNotEmpty) {
        final codeStrings = row[6].trim().split(';');
        for (final codeString in codeStrings) {
          final (code, text) = _extractCodeAndText(codeString);
          if (code.isNotEmpty) {
            codedValues.add(
              CodedValue(code: code, text: text, codeSystem: 'CVX'),
            );
          }
        }
      }

      if (row.length > 7 && row[7].trim().isNotEmpty) {
        final codeStrings = row[7].trim().split(';');
        for (final codeString in codeStrings) {
          final (code, text) = _extractCodeAndText(codeString);
          if (code.isNotEmpty) {
            codedValues.add(
              CodedValue(code: code, text: text, codeSystem: 'CDCPHINVS'),
            );
          }
        }
      }

      final observation = VaxObservation(
        observationCode: obsCode,
        observationTitle: obsTitle,
        indicationText: indication.isNotEmpty && indication != 'n/a'
            ? indication
            : null,
        contraindicationText: contra.isNotEmpty && contra != 'n/a'
            ? contra
            : null,
        clarifyingText: clarify.isNotEmpty && clarify != 'n/a' ? clarify : null,
        codedValues: codedValues.isNotEmpty
            ? CodedValues(codedValue: codedValues)
            : null,
      );

      obsList.add(observation);
    }
    return obsList;
  }

  // ---------------------------------------------------------------------------
  //   2) Parse "CVX to Antigen Map" tab
  // ---------------------------------------------------------------------------
  ///
  /// Example columns:
  /// [0] CVX
  /// [1] Short Description
  /// [2] Antigen
  /// [3] Association Begin Age
  /// [4] Association End Age
  List<CvxMap> _parseCvxToAntigenMapTab(List<List<String>> rows) {
    final cvxList = <CvxMap>[];
    if (rows.isEmpty) return cvxList;

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final cvx = row[0].trim();
      final shortDesc = row.length > 1 ? row[1].trim() : '';
      final antigenVal = row.length > 2 ? row[2].trim() : '';
      final beginAge = row.length > 3 ? row[3].trim() : null;
      final endAge = row.length > 4 ? row[4].trim() : null;

      final cvxIndex = cvxList.indexWhere((c) => c.cvx == cvx);

      if (cvxIndex == -1) {
        final assoc = <Association>[
          Association(
            antigen: antigenVal,
            associationBeginAge: beginAge == null || beginAge == 'n/a'
                ? null
                : beginAge,
            associationEndAge: endAge == null || endAge == 'n/a'
                ? null
                : endAge,
          ),
        ];

        cvxList.add(
          CvxMap(cvx: cvx, shortDescription: shortDesc, association: assoc),
        );
      } else {
        final existing = cvxList[cvxIndex];
        final assoc = existing.association?.toList() ?? <Association>[];
        assoc.add(
          Association(
            antigen: antigenVal,
            associationBeginAge: beginAge == null || beginAge == 'n/a'
                ? null
                : beginAge,
            associationEndAge: endAge == null || endAge == 'n/a'
                ? null
                : endAge,
          ),
        );

        final updated = existing.copyWith(association: assoc);
        cvxList[cvxIndex] = updated;
      }
    }
    return cvxList;
  }

  // ---------------------------------------------------------------------------
  //   3) Parse "Live Virus Conflicts" tab
  // ---------------------------------------------------------------------------
  ///
  /// Example columns:
  /// [0] Previous Vaccine Type (CVX)
  /// [1] Current Vaccine Type (CVX)
  /// [2] Conflict Begin Interval
  /// [3] Min Conflict End Interval
  /// [4] Conflict End Interval
  LiveVirusConflicts _parseLiveVirusConflictsTab(List<List<String>> rows) {
    final list = <LiveVirusConflict>[];
    if (rows.isEmpty) return LiveVirusConflicts(liveVirusConflict: list);

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final (previousCvx, previousType) = _extractCodeAndText(row[0].trim());
      final (currentCvx, currentType) = row.length > 1
          ? _extractCodeAndText(row[1].trim())
          : (null, null);
      final beginInt = row.length > 2 ? row[2].trim() : '';
      final minEnd = row.length > 3 ? row[3].trim() : '';
      final endInt = row.length > 4 ? row[4].trim() : '';

      final previousVac = previousType.isEmpty && previousCvx.isEmpty
          ? null
          : Vaccine(vaccineType: previousType, cvx: previousCvx);
      Vaccine(vaccineType: previousType, cvx: previousCvx);
      final currentVac =
          (currentType == null || currentType.isEmpty) &&
              (currentCvx == null || currentCvx.isEmpty)
          ? null
          : Vaccine(vaccineType: currentType, cvx: currentCvx);

      list.add(
        LiveVirusConflict(
          previous: previousVac,
          current: currentVac,
          conflictBeginInterval: beginInt,
          minConflictEndInterval: minEnd,
          conflictEndInterval: endInt,
        ),
      );
    }
    return LiveVirusConflicts(liveVirusConflict: list);
  }

  // ---------------------------------------------------------------------------
  //   4) Parse "Vaccine Group to Antigen Map" tab
  // ---------------------------------------------------------------------------
  ///
  /// Example columns:
  /// [0] Vaccine Group
  /// [1] Antigen
  List<VaccineGroupMap> _parseVaccineGroupToAntigenMapTab(
    List<List<String>> rows,
  ) {
    final list = <VaccineGroupMap>[];
    if (rows.isEmpty) return list;

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final groupName = row[0].trim();
      final antigen = row.length > 1 ? row[1].trim() : '';

      final existing = list.firstWhere(
        (m) => m.name == groupName,
        orElse: () => VaccineGroupMap(name: groupName, antigen: []),
      );

      if (!list.contains(existing)) {
        list.add(existing);
      }

      final antList = existing.antigen?.toList() ?? <String>[];
      antList.add(antigen);

      final updated = existing.copyWith(antigen: antList);
      final idx = list.indexOf(existing);
      list[idx] = updated;
    }

    return list;
  }

  // ---------------------------------------------------------------------------
  //   5) Parse "Vaccine Groups" tab
  // ---------------------------------------------------------------------------
  ///
  /// Example columns:
  /// [0] Vaccine Group Name
  /// [1] Administer Full Vaccine Group (Yes/No or "n/a")
  VaccineGroups _parseVaccineGroupsTab(List<List<String>> rows) {
    final list = <VaccineGroup>[];
    if (rows.isEmpty) return VaccineGroups(vaccineGroup: list);

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final groupName = row[0].trim();
      final adminStr = row.length > 1 ? row[1].trim() : '';
      final bin = Binary.fromJson(adminStr);

      list.add(VaccineGroup(name: groupName, administerFullVaccineGroup: bin));
    }

    return VaccineGroups(vaccineGroup: list);
  }

  /// Merge two `ScheduleSupportingData` objects:
  /// if `partial` has a non-null field, it overwrites the `base` field.
  ScheduleSupportingData _mergeSchedules(
    ScheduleSupportingData base,
    ScheduleSupportingData partial,
  ) {
    return ScheduleSupportingData(
      liveVirusConflicts: partial.liveVirusConflicts ?? base.liveVirusConflicts,
      vaccineGroups: partial.vaccineGroups ?? base.vaccineGroups,
      vaccineGroupToAntigenMap:
          partial.vaccineGroupToAntigenMap ?? base.vaccineGroupToAntigenMap,
      cvxToAntigenMap: partial.cvxToAntigenMap ?? base.cvxToAntigenMap,
      observations: partial.observations ?? base.observations,
    );
  }
}

/// Helper to parse code+text from a string like "Allergic reaction (187)"
(String, String) _extractCodeAndText(String fullString) {
  final openParen = fullString.lastIndexOf('(');
  final closeParen = fullString.lastIndexOf(')');
  if (openParen == -1 || closeParen == -1 || closeParen <= openParen) {
    return ('', fullString.trim());
  }
  final code = fullString.substring(openParen + 1, closeParen).trim();
  final text = fullString.substring(0, openParen).trim();
  return (code, text);
}
