/// Generates WHO Excel files from existing WHO JSON source files.
///
/// This is a one-time migration tool that reads the JSON antigen definitions
/// and schedule data, then creates CDC-format Excel workbooks that
/// AntigenSheetParser and ScheduleSheetParser can parse.
///
/// After running, the Excel files become the human-editable source of truth.
///
/// Run with: dart cicada_generator/lib/generate_who_excel.dart
/// Then:     dart cicada_generator/lib/main.dart --who
import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';

void main() {
  final antigenDir = 'cicada_generator/lib/WHO/antigen';
  final scheduleDir = 'cicada_generator/lib/WHO/schedule';

  // Generate antigen Excel files from JSON
  _generateAntigenExcel(antigenDir);

  // Generate schedule Excel files from JSON
  _generateScheduleExcel(scheduleDir);

  print('\nDone. Excel files are now the source of truth.');
  print('Next: delete JSON files, then run: dart cicada_generator/lib/main.dart --who');
}

// =============================================================================
//  Cell helpers
// =============================================================================

TextCellValue _t(String value) => TextCellValue(value);

List<CellValue?> _row(List<String> cells) => cells.map(_t).toList();

/// Return "n/a" for null/empty values (parser's _nullIfNA treats as null).
String _na(String? value) =>
    (value == null || value.isEmpty) ? 'n/a' : value;

/// Format "text (code)" — parser's _extractCodeAndText uses lastIndexOf('(').
String _codeText(String? code, String? text) {
  if (code == null || code.isEmpty) return text ?? '';
  return '${text ?? ''} ($code)';
}

// =============================================================================
//  Antigen Excel generation
// =============================================================================

void _generateAntigenExcel(String antigenDir) {
  final dir = Directory(antigenDir);
  if (!dir.existsSync()) {
    print('Antigen directory not found: $antigenDir');
    return;
  }

  var count = 0;
  for (final file in dir.listSync().whereType<File>()) {
    if (!file.path.endsWith('.json')) continue;

    final jsonData =
        json.decode(file.readAsStringSync()) as Map<String, dynamic>;
    final disease = jsonData['targetDisease'] as String? ?? 'Unknown';

    final excel = Excel.createExcel();
    // Remove default sheet
    excel.delete('Sheet1');

    // Immunity sheet
    final immunity = jsonData['immunity'] as Map<String, dynamic>?;
    if (immunity != null) {
      _writeImmunitySheet(excel, immunity);
    }

    // Contraindications sheet
    final contraindications =
        jsonData['contraindications'] as Map<String, dynamic>?;
    if (contraindications != null) {
      _writeContraindicationsSheet(excel, contraindications);
    }

    // Series sheet(s)
    final seriesList = jsonData['series'] as List<dynamic>? ?? [];
    final usedNames = <String>{};
    for (var i = 0; i < seriesList.length; i++) {
      final series = seriesList[i] as Map<String, dynamic>;
      final doseCount =
          (series['seriesDose'] as List<dynamic>?)?.length ?? 0;
      var sheetName = '$doseCount-dose series';
      if (usedNames.contains(sheetName)) {
        sheetName = '$sheetName (${i + 1})';
      }
      usedNames.add(sheetName);
      _writeSeriesSheet(excel, series, sheetName);
    }

    final excelPath = '$antigenDir/$disease.xlsx';
    File(excelPath).writeAsBytesSync(excel.encode()!);
    print('Wrote $excelPath');
    count++;
  }
  print('Generated $count antigen Excel files.');
}

void _writeImmunitySheet(Excel excel, Map<String, dynamic> immunity) {
  final sheet = excel['Immunity'];

  // Clinical History entries
  final clinicalHistory = immunity['clinicalHistory'] as List<dynamic>? ?? [];
  for (final ch in clinicalHistory) {
    final entry = ch as Map<String, dynamic>;
    sheet.appendRow(_row([
      'Clinical History Immunity',
      _codeText(
        entry['guidelineCode'] as String?,
        entry['guidelineTitle'] as String?,
      ),
    ]));
  }

  // Date of Birth immunity
  final dob = immunity['dateOfBirth'] as Map<String, dynamic>?;
  if (dob != null) {
    final date = dob['immunityBirthDate'] as String? ?? '';
    final country = dob['birthCountry'] as String? ?? 'n/a';
    final exclusions = dob['exclusion'] as List<dynamic>? ?? [];
    if (exclusions.isEmpty) {
      sheet.appendRow(_row([
        'Birth Date Immunity',
        date,
        country,
        'n/a',
      ]));
    } else {
      for (final excl in exclusions) {
        final ex = excl as Map<String, dynamic>;
        sheet.appendRow(_row([
          'Birth Date Immunity',
          date,
          country,
          _codeText(
            ex['exclusionCode'] as String?,
            ex['exclusionTitle'] as String?,
          ),
        ]));
      }
    }
  }
}

void _writeContraindicationsSheet(
  Excel excel,
  Map<String, dynamic> contraindications,
) {
  final sheet = excel['Contraindications'];

  // Antigen (group) contraindications
  final vaccineGroup =
      contraindications['vaccineGroup'] as Map<String, dynamic>?;
  if (vaccineGroup != null) {
    final contras =
        vaccineGroup['contraindication'] as List<dynamic>? ?? [];
    for (final c in contras) {
      final entry = c as Map<String, dynamic>;
      sheet.appendRow(_row([
        'Antigen Contraindication',
        _codeText(
          entry['observationCode'] as String?,
          entry['observationTitle'] as String?,
        ),
        _na(entry['contraindicationText'] as String?),
        _na(entry['contraindicationGuidance'] as String?),
        _na(entry['beginAge'] as String?),
        _na(entry['endAge'] as String?),
      ]));
    }
  }

  // Vaccine contraindications
  final vaccine = contraindications['vaccine'] as Map<String, dynamic>?;
  if (vaccine != null) {
    final contras = vaccine['contraindication'] as List<dynamic>? ?? [];
    for (final c in contras) {
      final entry = c as Map<String, dynamic>;
      final obsCode = entry['observationCode'] as String?;
      final obsTitle = entry['observationTitle'] as String?;
      final desc = entry['contraindicationText'] as String?;
      final guidance = entry['contraindicationGuidance'] as String?;
      final vaccines =
          entry['contraindicatedVaccine'] as List<dynamic>? ?? [];
      if (vaccines.isEmpty) {
        sheet.appendRow(_row([
          'Vaccine Contraindication',
          _codeText(obsCode, obsTitle),
          _na(desc),
          _na(guidance),
          'n/a',
          'n/a',
          'n/a',
        ]));
      } else {
        for (final v in vaccines) {
          final vac = v as Map<String, dynamic>;
          sheet.appendRow(_row([
            'Vaccine Contraindication',
            _codeText(obsCode, obsTitle),
            _na(desc),
            _na(guidance),
            _codeText(
              vac['cvx'] as String?,
              vac['vaccineType'] as String?,
            ),
            _na(vac['beginAge'] as String?),
            _na(vac['endAge'] as String?),
          ]));
        }
      }
    }
  }
}

void _writeSeriesSheet(
  Excel excel,
  Map<String, dynamic> series,
  String sheetName,
) {
  final sheet = excel[sheetName];

  // Basic series info
  sheet.appendRow(
    _row(['Series Name', series['seriesName'] as String? ?? '']),
  );
  sheet.appendRow(
    _row(['Target Disease', series['targetDisease'] as String? ?? '']),
  );
  sheet.appendRow(
    _row(['Vaccine Group', series['vaccineGroup'] as String? ?? '']),
  );
  sheet.appendRow(
    _row(['Series Type', series['seriesType'] as String? ?? 'Standard']),
  );

  // Equivalent Series Groups
  final eqGroups = series['equivalentSeriesGroups'];
  sheet.appendRow(
    _row(['Equivalent Series Groups', eqGroups?.toString() ?? 'n/a']),
  );

  // Required Gender
  final genders = series['requiredGender'] as List<dynamic>?;
  if (genders != null) {
    for (final g in genders) {
      sheet.appendRow(_row(['Gender', g.toString()]));
    }
  }

  // Select Patient Series
  final sel = series['selectSeries'] as Map<String, dynamic>?;
  if (sel != null) {
    sheet.appendRow(_row([
      'Select Patient Series',
      sel['defaultSeries'] as String? ?? 'No',
      sel['productPath'] as String? ?? 'No',
      sel['seriesGroupName'] as String? ?? '',
      sel['seriesGroup'] as String? ?? '',
      sel['seriesPriority'] as String? ?? '',
      sel['seriesPreference'] as String? ?? '',
      _na(sel['minAgeToStart'] as String?),
      _na(sel['maxAgeToStart'] as String?),
    ]));
  }

  // Indications
  final indications = series['indication'] as List<dynamic>?;
  if (indications != null) {
    for (final ind in indications) {
      final indication = ind as Map<String, dynamic>;
      final obsCode =
          indication['observationCode'] as Map<String, dynamic>?;
      sheet.appendRow(_row([
        'Indication',
        _codeText(
          obsCode?['code'] as String?,
          obsCode?['text'] as String?,
        ),
        _na(indication['description'] as String?),
        _na(indication['beginAge'] as String?),
        _na(indication['endAge'] as String?),
        _na(indication['guidance'] as String?),
      ]));
    }
  }

  // Series Doses
  final doses = series['seriesDose'] as List<dynamic>? ?? [];
  for (final d in doses) {
    final dose = d as Map<String, dynamic>;

    // Dose header
    sheet.appendRow(
      _row(['Series Dose', dose['doseNumber'] as String? ?? '']),
    );

    // Age
    final ages = dose['age'] as List<dynamic>? ?? [];
    for (final a in ages) {
      final age = a as Map<String, dynamic>;
      sheet.appendRow(_row([
        'Age',
        _na(age['absMinAge'] as String?),
        _na(age['minAge'] as String?),
        _na(age['earliestRecAge'] as String?),
        _na(age['latestRecAge'] as String?),
        _na(age['maxAge'] as String?),
        _na(age['effectiveDate'] as String?),
        _na(age['cessationDate'] as String?),
      ]));
    }

    // Preferable Interval (JSON key is "interval" or "preferableInterval")
    final prefIntervals = dose['interval'] as List<dynamic>? ??
        dose['preferableInterval'] as List<dynamic>? ??
        [];
    for (final intv in prefIntervals) {
      final interval = intv as Map<String, dynamic>;
      final fromRelevantObs =
          interval['fromRelevantObs'] as Map<String, dynamic>?;
      sheet.appendRow(_row([
        'Preferable Interval',
        _na(interval['fromPrevious'] as String?),
        interval['fromTargetDose']?.toString() ?? 'n/a',
        _na(interval['fromMostRecent'] as String?),
        fromRelevantObs != null
            ? _codeText(
                fromRelevantObs['code'] as String?,
                fromRelevantObs['text'] as String?,
              )
            : 'n/a',
        _na(interval['absMinInt'] as String?),
        _na(interval['minInt'] as String?),
        _na(interval['earliestRecInt'] as String?),
        _na(interval['latestRecInt'] as String?),
        _na(interval['intervalPriority'] as String?),
        _na(interval['effectiveDate'] as String?),
        _na(interval['cessationDate'] as String?),
      ]));
    }

    // Allowable Interval
    final allowInterval =
        dose['allowableInterval'] as Map<String, dynamic>?;
    if (allowInterval != null) {
      sheet.appendRow(_row([
        'Allowable Interval',
        _na(allowInterval['fromPrevious'] as String?),
        allowInterval['fromTargetDose']?.toString() ?? 'n/a',
        _na(allowInterval['absMinInt'] as String?),
        _na(allowInterval['effectiveDate'] as String?),
        _na(allowInterval['cessationDate'] as String?),
      ]));
    }

    // Preferable Vaccine
    final prefVaccines =
        dose['preferableVaccine'] as List<dynamic>? ?? [];
    for (final v in prefVaccines) {
      final vac = v as Map<String, dynamic>;
      sheet.appendRow(_row([
        'Preferable Vaccine',
        _codeText(vac['cvx'] as String?, vac['vaccineType'] as String?),
        _na(vac['beginAge'] as String?),
        _na(vac['endAge'] as String?),
        vac['tradeName'] != null
            ? _codeText(
                vac['mvx'] as String?,
                vac['tradeName'] as String?,
              )
            : 'n/a',
        _na(vac['volume'] as String?),
        _na(vac['forecastVaccineType'] as String?),
      ]));
    }

    // Allowable Vaccine
    final allowVaccines =
        dose['allowableVaccine'] as List<dynamic>? ?? [];
    for (final v in allowVaccines) {
      final vac = v as Map<String, dynamic>;
      sheet.appendRow(_row([
        'Allowable Vaccine',
        _codeText(vac['cvx'] as String?, vac['vaccineType'] as String?),
        _na(vac['beginAge'] as String?),
        _na(vac['endAge'] as String?),
      ]));
    }

    // Inadvertent Vaccine
    final inadVertVaccines =
        dose['inadvertentVaccine'] as List<dynamic>? ?? [];
    for (final v in inadVertVaccines) {
      final vac = v as Map<String, dynamic>;
      sheet.appendRow(_row([
        'Inadvertent Vaccine',
        _codeText(vac['cvx'] as String?, vac['vaccineType'] as String?),
      ]));
    }

    // Conditional Skip
    final conditionalSkips =
        dose['conditionalSkip'] as List<dynamic>? ?? [];
    for (final cs in conditionalSkips) {
      final skip = cs as Map<String, dynamic>;
      final context = skip['context'] as String? ?? 'n/a';
      final setLogic = skip['setLogic'] as String? ?? '';
      final sets = skip['set'] as List<dynamic>? ??
          skip['set_'] as List<dynamic>? ??
          [];
      for (final s in sets) {
        final setMap = s as Map<String, dynamic>;
        final setId = setMap['setID'] as String? ?? '';
        final setDesc = setMap['setDescription'] as String? ?? '';
        final effectiveDate = setMap['effectiveDate'] as String?;
        final cessationDate = setMap['cessationDate'] as String?;
        final condLogic = setMap['conditionLogic'] as String?;
        final conditions =
            setMap['condition'] as List<dynamic>? ?? [];
        if (conditions.isEmpty) {
          sheet.appendRow(_row([
            'Conditional Skip',
            context,
            setLogic,
            setId,
            setDesc,
            _na(effectiveDate),
            _na(cessationDate),
            _na(condLogic),
            'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a',
            'n/a', 'n/a', 'n/a', 'n/a', 'n/a',
          ]));
        } else {
          for (final cond in conditions) {
            final c = cond as Map<String, dynamic>;
            sheet.appendRow(_row([
              'Conditional Skip',
              context,
              setLogic,
              setId,
              setDesc,
              _na(effectiveDate),
              _na(cessationDate),
              _na(condLogic),
              _na(c['conditionID'] as String?),
              _na(c['conditionType'] as String?),
              _na(c['startDate'] as String?),
              _na(c['endDate'] as String?),
              _na(c['beginAge'] as String?),
              _na(c['endAge'] as String?),
              _na(c['interval'] as String?),
              _na(c['doseCount'] as String?),
              _na(c['doseType'] as String?),
              _na(c['doseCountLogic'] as String?),
              _na(c['vaccineTypes'] as String?),
              _na(c['seriesGroups'] as String?),
            ]));
          }
        }
      }
    }

    // Recurring Dose
    sheet.appendRow(
      _row(['Recurring Dose', dose['recurringDose'] as String? ?? 'No']),
    );

    // Seasonal Recommendation
    final seasonal =
        dose['seasonalRecommendation'] as Map<String, dynamic>?;
    if (seasonal != null) {
      sheet.appendRow(_row([
        'Seasonal Recommendation',
        _na(seasonal['startDate'] as String?),
        _na(seasonal['endDate'] as String?),
      ]));
    }
  }
}

// =============================================================================
//  Schedule Excel generation
// =============================================================================

void _generateScheduleExcel(String scheduleDir) {
  final scheduleFile = File('$scheduleDir/schedule_supporting_data.json');
  if (!scheduleFile.existsSync()) {
    print('Schedule file not found: ${scheduleFile.path}');
    return;
  }

  final scheduleData = json.decode(scheduleFile.readAsStringSync())
      as Map<String, dynamic>;

  _writeCodedObservationsExcel(scheduleDir, scheduleData);
  _writeCvxToAntigenMapExcel(scheduleDir, scheduleData);
  _writeLiveVirusConflictsExcel(scheduleDir, scheduleData);
  _writeVaccineGroupToAntigenMapExcel(scheduleDir, scheduleData);
  _writeVaccineGroupsExcel(scheduleDir, scheduleData);

  print('Generated 5 schedule Excel files.');
}

void _writeCodedObservationsExcel(
  String dir,
  Map<String, dynamic> scheduleData,
) {
  final excel = Excel.createExcel();
  excel.delete('Sheet1');
  final sheet = excel['Conditions'];

  // Header row (parser skips row 0)
  sheet.appendRow(_row([
    'Observation Code',
    'Observation Title',
    'Indication Text',
    'Contraindication Text',
    'Clarifying Text',
    'SNOMED',
    'CVX',
    'CDCPHINVS',
  ]));

  final observations =
      scheduleData['observations'] as Map<String, dynamic>?;
  final obsList = observations?['observation'] as List<dynamic>? ?? [];

  for (final obs in obsList) {
    final o = obs as Map<String, dynamic>;
    final codedValues = o['codedValues'] as Map<String, dynamic>?;
    final codedValueList =
        codedValues?['codedValue'] as List<dynamic>? ?? [];

    // Group coded values by system
    final snomed = <String>[];
    final cvx = <String>[];
    final cdcphinvs = <String>[];
    for (final cv in codedValueList) {
      final coded = cv as Map<String, dynamic>;
      final system = coded['codeSystem'] as String? ?? '';
      final code = coded['code'] as String? ?? '';
      final text = coded['text'] as String? ?? '';
      final formatted = _codeText(code, text);
      switch (system) {
        case 'SNOMED':
          snomed.add(formatted);
        case 'CVX':
          cvx.add(formatted);
        case 'CDCPHINVS':
          cdcphinvs.add(formatted);
      }
    }

    sheet.appendRow(_row([
      o['observationCode'] as String? ?? '',
      o['observationTitle'] as String? ?? '',
      o['indicationText'] as String? ?? '',
      o['contraindicationText'] as String? ?? '',
      o['clarifyingText'] as String? ?? '',
      snomed.join(';'),
      cvx.join(';'),
      cdcphinvs.join(';'),
    ]));
  }

  final path = '$dir/WHO Coded Observations.xlsx';
  File(path).writeAsBytesSync(excel.encode()!);
  print('Wrote $path');
}

void _writeCvxToAntigenMapExcel(
  String dir,
  Map<String, dynamic> scheduleData,
) {
  final excel = Excel.createExcel();
  excel.delete('Sheet1');
  final sheet = excel['CVX to Antigen Map'];

  // Header
  sheet.appendRow(_row([
    'CVX',
    'Short Description',
    'Antigen',
    'Association Begin Age',
    'Association End Age',
  ]));

  final cvxMap =
      scheduleData['cvxToAntigenMap'] as Map<String, dynamic>?;
  final cvxList = cvxMap?['cvxMap'] as List<dynamic>? ?? [];

  for (final entry in cvxList) {
    final cvxEntry = entry as Map<String, dynamic>;
    final cvxCode = cvxEntry['cvx'] as String? ?? '';
    final shortDesc = cvxEntry['shortDescription'] as String? ?? '';
    final associations =
        cvxEntry['association'] as List<dynamic>? ?? [];
    for (final assoc in associations) {
      final a = assoc as Map<String, dynamic>;
      sheet.appendRow(_row([
        cvxCode,
        shortDesc,
        a['antigen'] as String? ?? '',
        _na(a['associationBeginAge'] as String?),
        _na(a['associationEndAge'] as String?),
      ]));
    }
  }

  final path = '$dir/WHO CVX to Antigen Map.xlsx';
  File(path).writeAsBytesSync(excel.encode()!);
  print('Wrote $path');
}

void _writeLiveVirusConflictsExcel(
  String dir,
  Map<String, dynamic> scheduleData,
) {
  final excel = Excel.createExcel();
  excel.delete('Sheet1');
  final sheet = excel['Live Virus Conflicts'];

  // Header
  sheet.appendRow(_row([
    'Previous Vaccine Type (CVX)',
    'Current Vaccine Type (CVX)',
    'Conflict Begin Interval',
    'Min Conflict End Interval',
    'Conflict End Interval',
  ]));

  final conflicts =
      scheduleData['liveVirusConflicts'] as Map<String, dynamic>?;
  final conflictList =
      conflicts?['liveVirusConflict'] as List<dynamic>? ?? [];

  for (final c in conflictList) {
    final conflict = c as Map<String, dynamic>;
    final prev = conflict['previous'] as Map<String, dynamic>?;
    final curr = conflict['current'] as Map<String, dynamic>?;
    sheet.appendRow(_row([
      prev != null
          ? _codeText(
              prev['cvx'] as String?,
              prev['vaccineType'] as String?,
            )
          : '',
      curr != null
          ? _codeText(
              curr['cvx'] as String?,
              curr['vaccineType'] as String?,
            )
          : '',
      conflict['conflictBeginInterval'] as String? ?? '',
      conflict['minConflictEndInterval'] as String? ?? '',
      conflict['conflictEndInterval'] as String? ?? '',
    ]));
  }

  final path = '$dir/WHO Live Virus Conflicts.xlsx';
  File(path).writeAsBytesSync(excel.encode()!);
  print('Wrote $path');
}

void _writeVaccineGroupToAntigenMapExcel(
  String dir,
  Map<String, dynamic> scheduleData,
) {
  final excel = Excel.createExcel();
  excel.delete('Sheet1');
  final sheet = excel['Vaccine Group to Antigen Map'];

  // Header
  sheet.appendRow(_row([
    'Vaccine Group',
    'Antigen',
  ]));

  final groupMap =
      scheduleData['vaccineGroupToAntigenMap'] as Map<String, dynamic>?;
  final groupList =
      groupMap?['vaccineGroupMap'] as List<dynamic>? ?? [];

  for (final entry in groupList) {
    final group = entry as Map<String, dynamic>;
    final name = group['name'] as String? ?? '';
    final antigens = group['antigen'] as List<dynamic>? ?? [];
    for (final antigen in antigens) {
      sheet.appendRow(_row([name, antigen.toString()]));
    }
  }

  final path = '$dir/WHO Vaccine Group to Antigen Map.xlsx';
  File(path).writeAsBytesSync(excel.encode()!);
  print('Wrote $path');
}

void _writeVaccineGroupsExcel(
  String dir,
  Map<String, dynamic> scheduleData,
) {
  final excel = Excel.createExcel();
  excel.delete('Sheet1');
  final sheet = excel['Vaccine Groups'];

  // Header
  sheet.appendRow(_row([
    'Vaccine Group Name',
    'Administer Full Vaccine Group',
  ]));

  final groups =
      scheduleData['vaccineGroups'] as Map<String, dynamic>?;
  final groupList =
      groups?['vaccineGroup'] as List<dynamic>? ?? [];

  for (final entry in groupList) {
    final group = entry as Map<String, dynamic>;
    sheet.appendRow(_row([
      group['name'] as String? ?? '',
      group['administerFullVaccineGroup'] as String? ?? 'No',
    ]));
  }

  final path = '$dir/WHO Vaccine Group.xlsx';
  File(path).writeAsBytesSync(excel.encode()!);
  print('Wrote $path');
}
