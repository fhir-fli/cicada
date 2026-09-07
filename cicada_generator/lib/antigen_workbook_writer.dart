// Writes an [AntigenSupportingData] as a workbook in CDC's CDSi 4.65 layout.
//
// The layout is copied from CDC's own AntigenSupportingData- X-508.xlsx files
// (Version_4.65-508/Excel), sheet by sheet and row by row: the sheet order,
// the header row of every block, the column names, "n/a" for an empty cell,
// a label written once per block with the rows below it left blank, and one
// row per condition in a conditional skip with the set's cells written on
// its first row only. AntigenSheetParser reads the result; the round trip
// (model -> workbook -> model) is proved by write_who_workbooks.dart.
//
// This exists so that the WHO workbooks, and any programme's edited copy of
// them, look exactly like CDC's: one layout for everyone who opens a
// supporting-data workbook, and one parser.
import 'package:cicada/cicada.dart';
import 'package:excel/excel.dart';

class AntigenWorkbookWriter {
  AntigenWorkbookWriter({
    this.overview = const [],
    this.changeHistory = const [],
    this.faq = const [],
  });

  /// Rows for the Antigen Series Overview sheet, after CDC's A="Overview".
  final List<String> overview;

  /// Rows for the Change History sheet as [version, date, change, reason].
  final List<List<String>> changeHistory;

  /// Rows for the FAQ sheet as [question, answer, reference, manifestation].
  final List<List<String>> faq;

  /// Builds the workbook. [sheetNameFor] names each series sheet; Excel
  /// limits a sheet name to 31 characters.
  Excel write(
    AntigenSupportingData data, {
    String Function(Series series, int index)? sheetNameFor,
  }) {
    final excel = Excel.createExcel();
    _overviewSheet(excel, data);
    _changeHistorySheet(excel);
    _faqSheet(excel);
    _categorySheet(excel, data.vaccineRecommendationCategory ?? const []);
    _immunitySheet(excel, data.immunity);
    _contraindicationsSheet(excel, data.contraindications);
    final series = data.series ?? const <Series>[];
    final used = <String>{};
    for (var i = 0; i < series.length; i++) {
      var name = (sheetNameFor ?? _defaultSheetName)(series[i], i);
      // Excel limits sheet names to 31 characters, and CDC's COVID-19 and
      // Pneumococcal series names share their first 31, so a collision
      // would merge two series into one sheet. Number the repeats.
      var n = 2;
      while (!used.add(name)) {
        final suffix = ' ($n)';
        final base = (sheetNameFor ?? _defaultSheetName)(series[i], i);
        name = base.length + suffix.length > 31
            ? base.substring(0, 31 - suffix.length).trim() + suffix
            : base + suffix;
        n++;
      }
      _seriesSheet(excel[name], series[i]);
    }
    // createExcel() starts with "Sheet1"; delete() is a no-op while it is
    // the only sheet, which is why the 2025 WHO workbooks kept it.
    excel.delete('Sheet1');
    return excel;
  }

  static String _defaultSheetName(Series s, int i) {
    var name = s.seriesName ?? 'Series ${i + 1}';
    for (final prefix in ['WHO ', '${s.targetDisease ?? ''} ']) {
      if (prefix.trim().isNotEmpty && name.startsWith(prefix)) {
        name = name.substring(prefix.length);
      }
    }
    name = name.replaceAll(RegExp(r'[\[\]\*\?/\\:]'), ' ').trim();
    if (name.isEmpty) name = 'Series ${i + 1}';
    return name.length > 31 ? name.substring(0, 31).trim() : name;
  }

  // ---------------------------------------------------------------- sheets

  void _overviewSheet(Excel excel, AntigenSupportingData data) {
    final sheet = excel['Antigen Series Overview'];
    final lines = overview.isEmpty
        ? [
            'This workbook holds the immunization supporting data for '
                '${data.targetDisease ?? 'one antigen'}: the series a patient '
                'may be on, the doses in each series, and the evidence of '
                'immunity and contraindications that apply. It follows the '
                'layout of the CDC CDSi Antigen Supporting Data workbooks '
                '(version 4.65), so that one parser reads every workbook.',
          ]
        : overview;
    var first = true;
    for (final line in lines) {
      _add(sheet, [first ? 'Overview' : '', line]);
      _add(sheet, const []);
      first = false;
    }
  }

  void _changeHistorySheet(Excel excel) {
    final sheet = excel['Change History'];
    if (changeHistory.isEmpty) {
      _add(sheet, ['Version', 'n/a', 'Publication Date: n/a']);
      _add(sheet, _changeHeader);
      return;
    }
    String? version;
    var n = 0;
    for (final row in changeHistory) {
      if (row[0] != version) {
        if (version != null) _add(sheet, const []);
        version = row[0];
        n = 0;
        _add(sheet, ['Version', version, 'Publication Date: ${row[1]}']);
        _add(sheet, _changeHeader);
      }
      n++;
      _add(sheet, ['', '$n', row.length > 4 ? row[4] : 'n/a', 'n/a', row[2], row[3]]);
    }
  }

  static const _changeHeader = [
    'Change', 'Change #', 'Area', 'Previous', 'Change', 'Reason for Change',
  ];

  void _faqSheet(Excel excel) {
    final sheet = excel['FAQ'];
    _add(sheet, ['FAQs', 'Question', 'Answer', 'Reference', 'CDSi Manifestation']);
    for (final row in faq) {
      _add(sheet, ['', ...row.map(_na)]);
    }
  }

  void _categorySheet(Excel excel, List<VaccineRecommendationCategory> rows) {
    final sheet = excel['Vaccine Recommendation Category'];
    _add(sheet, [
      '',
      'If the Best Patient Series for the patient is…',
      "AND the patient's current age is on or after the Begin Age and before the End Age…",
      '',
      'AND the Target Dose being forecasted is…',
      "AND the patient's risk factor is one of the Included Indications (and not one of the Excluded Indications)…",
      '',
      'THEN the Vaccine Recommendation Category is…',
      'Vaccine Recommendation Category Specific Material',
    ]);
    _add(sheet, [
      'Excel Worksheet Name', 'Best Patient Series Name', 'Patient Begin Age',
      'Patient End Age (less than)', 'Forecast Target Dose Number',
      'Included Indication', 'Excluded Indication',
      'Vaccine Recommendation Category', 'Additional Material',
    ]);
    for (final r in rows) {
      _add(sheet, [
        _na(r.worksheetName), _na(r.seriesName), _na(r.patientBeginAge),
        _na(r.patientEndAge), _na(r.forecastTargetDose),
        _na(r.includedIndication), _na(r.excludedIndication),
        _na(r.category), _na(r.additionalMaterial),
      ]);
    }
  }

  void _immunitySheet(Excel excel, Immunity? imm) {
    final sheet = excel['Immunity'];
    _add(sheet, ['Clinical History Immunity', 'Immunity Guideline']);
    final ch = imm?.clinicalHistory ?? const <ClinicalHistory>[];
    if (ch.isEmpty) {
      _add(sheet, ['', 'n/a']);
    } else {
      for (final c in ch) {
        _add(sheet, ['', _codeText(c.guidelineTitle, c.guidelineCode)]);
      }
    }
    _add(sheet, const []);
    _add(sheet, [
      'Birth Date Immunity', 'Immunity Birth Date', 'Immunity Country of Birth',
      'Immunity Exclusion Condition',
    ]);
    final dob = imm?.dateOfBirth;
    if (dob == null) {
      _add(sheet, ['', 'n/a', 'n/a', 'n/a']);
    } else {
      final ex = dob.exclusion ?? const <Exclusion>[];
      if (ex.isEmpty) {
        _add(sheet, ['', _na(dob.immunityBirthDate), _na(dob.birthCountry), 'n/a']);
      } else {
        for (final e in ex) {
          _add(sheet, [
            '', _na(dob.immunityBirthDate), _na(dob.birthCountry),
            _codeText(e.exclusionTitle, e.exclusionCode),
          ]);
        }
      }
    }
  }

  void _contraindicationsSheet(Excel excel, Contraindications? c) {
    final sheet = excel['Contraindications'];
    _add(sheet, [
      'Antigen Contraindication', 'Contraindication (Code)', 'Text Description',
      'Administrative Guidance', 'Contraindication Begin Age',
      'Contraindication End Age (less than)',
    ]);
    final group = c?.vaccineGroup?.contraindication ?? const <GroupContraindication>[];
    if (group.isEmpty) {
      _add(sheet, ['', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a']);
    } else {
      for (final g in group) {
        _add(sheet, [
          '', _codeText(g.observationTitle, g.observationCode),
          _na(g.contraindicationText), _na(g.contraindicationGuidance),
          _na(g.beginAge), _na(g.endAge),
        ]);
      }
    }
    _add(sheet, const []);
    _add(sheet, [
      'Vaccine Contraindication', 'Contraindication (Code)', 'Text Description',
      'Administrative Guidance', 'Vaccine Type (CVX)',
      'Contraindication Begin Age', 'Contraindication End Age (less than)',
    ]);
    final vac = c?.vaccine?.contraindication ?? const <VaccineContraindication>[];
    if (vac.isEmpty) {
      _add(sheet, ['', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a']);
    } else {
      for (final v in vac) {
        final products = v.contraindicatedVaccine ?? const <Vaccine>[];
        if (products.isEmpty) {
          _add(sheet, [
            '', _codeText(v.observationTitle, v.observationCode),
            _na(v.contraindicationText), _na(v.contraindicationGuidance),
            'n/a', 'n/a', 'n/a',
          ]);
          continue;
        }
        var first = true;
        for (final p in products) {
          _add(sheet, [
            '',
            first ? _codeText(v.observationTitle, v.observationCode) : '',
            first ? _na(v.contraindicationText) : '',
            first ? _na(v.contraindicationGuidance) : '',
            _codeText(p.vaccineType, p.cvx), _na(p.beginAge), _na(p.endAge),
          ]);
          first = false;
        }
      }
    }
  }

  void _seriesSheet(Sheet sheet, Series s) {
    _add(sheet, ['Series Name', _na(s.seriesName)]);
    _add(sheet, ['Target Disease', _na(s.targetDisease)]);
    _add(sheet, ['Vaccine Group', _na(s.vaccineGroup)]);
    _add(sheet, ['Administrative Guidance', 'Text']);
    final guidance = s.seriesAdminGuidance ?? const <String>[];
    if (guidance.isEmpty) {
      _add(sheet, ['', 'n/a']);
    } else {
      for (final g in guidance) {
        _add(sheet, ['', g]);
      }
    }
    _add(sheet, ['Series Type', 'Type']);
    _add(sheet, ['', _na(s.seriesType?.toString())]);
    _add(sheet, ['Equivalent Series Groups', 'Series Groups']);
    _add(sheet, ['', _na(s.equivalentSeriesGroups?.toString())]);
    _add(sheet, ['Gender', 'Required Gender']);
    final genders = s.requiredGender ?? const <Gender>[];
    if (genders.isEmpty) {
      _add(sheet, ['', 'n/a']);
    } else {
      for (final g in genders) {
        _add(sheet, ['', g.toString()]);
      }
    }
    _add(sheet, [
      'Select Patient Series', 'Default Series', 'Product Path',
      'Series Group Name', 'Series Group', 'Series Priority',
      'Series Preference', 'Minimum Age To Start', 'Maximum Age To Start',
    ]);
    final sel = s.selectSeries;
    _add(sheet, [
      '', _na(sel?.defaultSeries?.toString()), _na(sel?.productPath?.toString()),
      _na(sel?.seriesGroupName), _na(sel?.seriesGroup),
      _na(sel?.seriesPriority?.toString()), _na(sel?.seriesPreference?.toString()),
      _na(sel?.minAgeToStart), _na(sel?.maxAgeToStart),
    ]);
    _add(sheet, [
      'Indication', 'Observation (Code)', 'Text Description',
      'Indication Begin Age', 'Indication End Age (less than)',
      'Administrative Guidance',
    ]);
    final ind = s.indication ?? const <Indication>[];
    if (ind.isEmpty) {
      _add(sheet, ['', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a']);
    } else {
      for (final i in ind) {
        _add(sheet, [
          '', _codeText(i.observationCode?.text, i.observationCode?.code),
          _na(i.description), _na(i.beginAge), _na(i.endAge), _na(i.guidance),
        ]);
      }
    }
    for (final d in s.seriesDose ?? const <SeriesDose>[]) {
      _add(sheet, const []);
      _dose(sheet, d);
    }
  }

  void _dose(Sheet sheet, SeriesDose d) {
    _add(sheet, ['Series Dose', _na(d.doseNumber?.toString())]);
    _add(sheet, [
      'Age', 'Absolute Minimum Age', 'Minimum Age', 'Earliest Recommended Age',
      'Latest Recommended Age (less than)', 'Maximum Age (less than)',
      'Effective Date', 'Cessation Date',
    ]);
    final ages = d.age ?? const <VaxAge>[];
    if (ages.isEmpty) {
      _add(sheet, ['', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a']);
    } else {
      for (final a in ages) {
        _add(sheet, [
          '', _na(a.absMinAge), _na(a.minAge), _na(a.earliestRecAge),
          _na(a.latestRecAge), _na(a.maxAge), _na(a.effectiveDate),
          _na(a.cessationDate),
        ]);
      }
    }
    _add(sheet, [
      'Preferable Interval', 'From Immediate Previous Dose Administered? Y/N',
      'From Target Dose # in Series', 'From Most Recent (CVX List)',
      'From Relevant Observation (Code)', 'Absolute Minimum Interval',
      'Minimum Interval', 'Earliest Recommended Interval',
      'Latest Recommended Interval (less than)', 'Interval Priority Flag',
      'Effective Date', 'Cessation Date',
    ]);
    final pref = d.preferableInterval ?? const <Interval>[];
    if (pref.isEmpty) {
      _add(sheet, ['', ...List.filled(11, 'n/a')]);
    } else {
      for (final i in pref) {
        _add(sheet, [
          '', _na(i.fromPrevious), _na(i.fromTargetDose?.toString()),
          _na(i.fromMostRecent),
          _codeText(i.fromRelevantObs?.text, i.fromRelevantObs?.code),
          _na(i.absMinInt), _na(i.minInt), _na(i.earliestRecInt),
          _na(i.latestRecInt), _na(i.intervalPriority), _na(i.effectiveDate),
          _na(i.cessationDate),
        ]);
      }
    }
    _add(sheet, [
      'Allowable Interval', 'From Immediate Previous Dose Administered? Y/N',
      'From Target Dose # in Series', 'Absolute Minimum Interval',
      'Effective Date', 'Cessation Date',
    ]);
    final allow = d.allowableInterval;
    _add(sheet, [
      '', _na(allow?.fromPrevious), _na(allow?.fromTargetDose?.toString()),
      _na(allow?.absMinInt), _na(allow?.effectiveDate), _na(allow?.cessationDate),
    ]);
    _add(sheet, [
      'Preferable Vaccine', 'Vaccine Type (CVX)', 'Vaccine Type Begin Age',
      'Vaccine Type End Age (less than)', 'Trade Name (MVX)', 'Volume (in ml)',
      'Forecast Vaccine Type (Y/N)',
    ]);
    final pv = d.preferableVaccine ?? const <Vaccine>[];
    if (pv.isEmpty) {
      _add(sheet, ['', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a']);
    } else {
      for (final v in pv) {
        _add(sheet, [
          '', _codeText(v.vaccineType, v.cvx), _na(v.beginAge), _na(v.endAge),
          _codeText(v.tradeName, v.mvx), _na(v.volume), _na(v.forecastVaccineType),
        ]);
      }
    }
    _add(sheet, [
      'Allowable Vaccine', 'Vaccine Type (CVX)', 'Vaccine Type Begin Age',
      'Vaccine Type End Age (less than)',
    ]);
    final av = d.allowableVaccine ?? const <Vaccine>[];
    if (av.isEmpty) {
      _add(sheet, ['', 'n/a', 'n/a', 'n/a']);
    } else {
      for (final v in av) {
        _add(sheet, ['', _codeText(v.vaccineType, v.cvx), _na(v.beginAge), _na(v.endAge)]);
      }
    }
    _add(sheet, ['Inadvertent Vaccine', 'Vaccine Type (CVX)']);
    final iv = d.inadvertentVaccine ?? const <Vaccine>[];
    if (iv.isEmpty) {
      _add(sheet, ['', 'n/a']);
    } else {
      for (final v in iv) {
        _add(sheet, ['', _codeText(v.vaccineType, v.cvx)]);
      }
    }
    _add(sheet, [
      'Conditional Skip', 'Skip Context', 'Set Logic', 'Set ID', 'Description',
      'Effective Date', 'Cessation Date', 'Condition Logic', 'Condition ID',
      'Type', 'Start Date', 'End Date', 'Begin Age', 'End Age (less than)',
      'Interval', 'Dose Count', 'Dose Type', 'Dose Count Logic',
      'Vaccine Types (CVX List)', 'Series Group',
    ]);
    final skips = d.conditionalSkip ?? const <ConditionalSkip>[];
    if (skips.isEmpty) {
      _add(sheet, ['', ...List.filled(19, 'n/a')]);
    } else {
      for (final skip in skips) {
        var firstSet = true;
        for (final set in skip.set_ ?? const <VaxSet>[]) {
          var firstCondition = true;
          final conditions = set.condition ?? const <VaxCondition>[];
          for (final cond in conditions) {
            _add(sheet, [
              '',
              firstSet && firstCondition ? _na(skip.context?.toString()) : '',
              firstSet && firstCondition ? _na(skip.setLogic) : '',
              firstCondition ? _na(set.setID) : '',
              firstCondition ? _na(set.setDescription) : '',
              firstCondition ? _na(set.effectiveDate) : '',
              firstCondition ? _na(set.cessationDate) : '',
              firstCondition ? _na(set.conditionLogic) : '',
              _na(cond.conditionID), _na(cond.conditionType), _na(cond.startDate),
              _na(cond.endDate), _na(cond.beginAge), _na(cond.endAge),
              _na(cond.interval), _na(cond.doseCount), _na(cond.doseType?.toString()),
              _na(cond.doseCountLogic), _na(cond.vaccineTypes), _na(cond.seriesGroups),
            ]);
            firstCondition = false;
            firstSet = false;
          }
        }
      }
    }
    _add(sheet, ['Recurring Dose', 'Recurring Dose (Yes/No)']);
    _add(sheet, ['', d.recurringDose?.toString() ?? 'No']);
    _add(sheet, ['Seasonal Recommendation', 'Start Date', 'End Date']);
    _add(sheet, [
      '', _na(d.seasonalRecommendation?.startDate),
      _na(d.seasonalRecommendation?.endDate),
    ]);
  }

  // --------------------------------------------------------------- helpers

  static void _add(Sheet sheet, List<String> cells) {
    sheet.appendRow(cells.map<CellValue?>(TextCellValue.new).toList());
  }

  static String _na(String? v) => v == null || v.isEmpty ? 'n/a' : v;

  /// "text (code)" as CDC writes coded cells; "n/a" when both are empty.
  static String _codeText(String? text, String? code) {
    if ((code == null || code.isEmpty) && (text == null || text.isEmpty)) {
      return 'n/a';
    }
    if (code == null || code.isEmpty) return text!;
    return '${text ?? ''} ($code)'.trim();
  }
}
