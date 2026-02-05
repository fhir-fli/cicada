import 'dart:io';
import 'package:excel/excel.dart';
import 'package:cicada/cicada.dart';

/// A parser that reads an Excel file (Antigen Supporting Data)
/// and constructs an [AntigenSupportingData] object.
class AntigenSheetParser {
  /// Reads an Excel file from [excelPath], parses it fully, and returns
  /// an [AntigenSupportingData].
  ///
  /// This includes:
  /// - Antigen Series Overview
  /// - Change History
  /// - FAQ
  /// - Immunity
  /// - Contraindications
  /// - One or more Series tabs (e.g., "1-dose", "2-dose")
  AntigenSupportingData parseFile(String excelPath) {
    final bytes = File(excelPath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    // Start with an empty, immutable object
    var data = AntigenSupportingData();

    // Go through each sheet in the workbook
    for (final sheetName in excel.tables.keys) {
      final sheet = excel.tables[sheetName]!;
      final rows = sheet.rows
          .map(
            (row) => row
                .map(
                  (cell) =>
                      cell?.value?.toString().replaceAll('\n', ' ').trim() ??
                      '',
                )
                .toList(),
          )
          .toList();

      // 1) Antigen Series Overview tab
      if (sheetName == 'Antigen Series Overview') {
        // Store multiline text or parse further if needed
        // final overviewText = _parseSheetAsPlainText(rows);
      }
      // 2) Change History tab
      else if (sheetName == 'Change History') {
        // final changeHistoryText = _parseSheetAsPlainText(rows);
      }
      // 3) FAQ tab
      else if (sheetName == 'FAQ') {
        // final faqText = _parseSheetAsPlainText(rows);
      }
      // 4) Immunity tab
      else if (sheetName == 'Immunity') {
        final imm = _parseImmunityRows(rows);
        if (!imm.isEmpty()) {
          data = data.copyWith(immunity: imm);
        }
      }
      // 5) Contraindications tab
      else if (sheetName == 'Contraindications') {
        final contraindications = _parseContraindicationsRows(rows);
        data = data.copyWith(contraindications: contraindications);
      }
      // 6) Series tab(s)
      //
      //    We look for tabs that either have “dose” in the name,
      //    or at least one row containing “Series Name”.
      //    Adjust as needed to detect your actual series tabs.
      else if (sheetName.toLowerCase().contains('dose') ||
          rows.any((r) => r.any((cell) => cell.contains('Series Name')))) {
        final singleSeries = _parseSeriesRows(rows);

        // Combine with any existing series
        final existingSeries = data.series?.toList() ?? <Series>[];
        existingSeries.add(singleSeries);

        data = data.copyWith(series: existingSeries);

        // Optionally, copy disease and vaccineGroup from the series if not yet set
        data = data.copyWith(
          targetDisease: data.targetDisease ?? singleSeries.targetDisease,
          vaccineGroup: data.vaccineGroup ?? singleSeries.vaccineGroup,
        );
      }
      // Else if you have other tabs you want to parse, add them here
      else {
        // If there's a tab you don't care about, you can ignore it
        // or store it as plain text.
      }
    }

    return data;
  }

  /// -----------------------------------------------------------
  ///           1) Helper: Parse any tab as plain text
  /// -----------------------------------------------------------
  ///
  /// For “Antigen Series Overview,” “Change History,” or “FAQ”,
  /// you might just store them as multiline strings.
  /// Adjust if you need more structured parsing.
  // String _parseSheetAsPlainText(List<List<String>> rows) {
  //   final buffer = StringBuffer();
  //   for (final row in rows) {
  //     buffer.writeln(row.join('\t'));
  //   }
  //   return buffer.toString();
  // }

  /// -----------------------------------------------------------
  ///         2) Helper: Parse "Immunity" rows
  /// -----------------------------------------------------------
  Immunity _parseImmunityRows(List<List<String>> rows) {
    // Start with an empty (immutable) object
    var imm = Immunity();

    for (final row in rows) {
      if (row.isEmpty) continue;

      final firstCell = row[0].trim();

      // Example logic: if the row says "Clinical History Immunity"
      // store [row[1]] as something like "Adverse Reaction (080)"
      if (firstCell == 'Clinical History Immunity' && row.length > 1) {
        final col1 = row[1];
        if (col1.isNotEmpty &&
            !col1.contains('n/a') &&
            !col1.contains('Immunity Guideline')) {
          final (code, text) = _extractCodeAndText(col1);

          final existingList =
              imm.clinicalHistory?.toList() ?? <ClinicalHistory>[];
          existingList.add(
            ClinicalHistory(guidelineCode: code, guidelineTitle: text),
          );
          imm = imm.copyWith(clinicalHistory: existingList);
        }
      }
      // If the row says "Birth Date Immunity" => parse birth date, country, exclusion condition
      else if (firstCell == 'Birth Date Immunity') {
        final date = row.length > 1 ? row[1] : '';
        final country = row.length > 2 ? row[2] : '';
        // If there's no dateOfBirth yet, initialize it
        var dob = imm.dateOfBirth?.copyWith();
        if (dob == null) {
          dob = DateOfBirth(
            immunityBirthDate: date,
            birthCountry: country.contains('n/a') || country.isEmpty
                ? null
                : country,
            exclusion: const [],
          );
        }

        // Possibly parse exclusion in row[3]
        if (row.length > 3 &&
            row[3].isNotEmpty &&
            !row[3].contains('n/a') &&
            !row[3].contains('Immunity Exclusion Condition')) {
          final (exclusionCode, exclusionTitle) = _extractCodeAndText(row[3]);
          final exclusions = dob.exclusion?.toList() ?? <Exclusion>[];
          exclusions.add(
            Exclusion(
              exclusionCode: exclusionCode,
              exclusionTitle: exclusionTitle,
            ),
          );
          dob = dob.copyWith(exclusion: exclusions);
          imm = imm.copyWith(dateOfBirth: dob);
        }
      }
    }

    return imm;
  }

  /// -----------------------------------------------------------
  ///       3) Helper: Parse "Contraindications" rows
  /// -----------------------------------------------------------
  Contraindications _parseContraindicationsRows(List<List<String>> rows) {
    // Initialize with empty lists
    var contras = Contraindications();

    // Temporary storage for all "antigen" contraindications
    final antigenList = <GroupContraindication>[];

    // We’ll use a map to collect all “vaccine” contraindications keyed by observationCode.
    // This ensures multiple rows with the same code get merged into one object.
    final vaccineContraMap = <String, VaccineContraindication>{};

    for (final row in rows) {
      if (row.isEmpty) continue;
      final firstCell = row[0].trim();

      //
      // =========== Antigen Contraindication ===========
      //
      if (firstCell.contains('Antigen Contraindication') && row.length > 1) {
        final (code, text) = _extractCodeAndText(row[1]);
        final desc = row.length > 2 ? row[2] : '';
        final guidance = (row.length > 3 && !row[3].contains('n/a'))
            ? row[3]
            : null;
        final beginAge = (row.length > 4 && !row[4].contains('n/a'))
            ? row[4]
            : null;
        final endAge = (row.length > 5 && !row[5].contains('n/a'))
            ? row[5]
            : null;

        // Avoid adding a dummy item if 'Code' or 'n/a'
        if (code.isNotEmpty && code != 'Code') {
          antigenList.add(
            GroupContraindication(
              observationCode: code,
              observationTitle: text,
              contraindicationText: desc,
              contraindicationGuidance: guidance == null || guidance.isEmpty
                  ? null
                  : guidance,
              beginAge: beginAge,
              endAge: endAge,
            ),
          );
        }
      }
      //
      // =========== Vaccine Contraindication ===========
      //
      else if (firstCell.contains('Vaccine Contraindication') &&
          row.length > 1) {
        final (code, text) = _extractCodeAndText(row[1]);
        final desc = row.length > 2 ? row[2] : '';
        final guidance = (row.length > 3 && !row[3].contains('n/a'))
            ? row[3]
            : null;

        // If you store "vaccineType" and "cvx" in columns [4] and [5], for example:
        final (cvx, vaccineType) = row.length > 4
            ? _extractCodeAndText(row[4].trim())
            : (null, null);

        // Retrieve any existing 'VaccineContraindication' with the same code
        var existingContra = vaccineContraMap[code];
        if (existingContra == null) {
          existingContra = VaccineContraindication(
            observationCode: code,
            observationTitle: text,
            contraindicationText: desc,
            contraindicationGuidance: guidance == null || guidance.isEmpty
                ? null
                : guidance,
            contraindicatedVaccine: const [],
          );
        }

        // If the row has a non-empty vaccineType/cvx, attach it as a new 'contraindicatedVaccine'
        if ((vaccineType?.isNotEmpty ?? false) &&
            !vaccineType!.contains('n/a')) {
          final beginAge = (row.length > 5 && !row[5].contains('n/a'))
              ? row[5]
              : null;
          final endAge = (row.length > 6 && !row[6].contains('n/a'))
              ? row[6]
              : null;
          final newVac = Vaccine(
            vaccineType: vaccineType,
            cvx: cvx,
            beginAge: beginAge,
            endAge: endAge,
          );
          final updatedVacList =
              existingContra.contraindicatedVaccine?.toList() ?? <Vaccine>[];
          updatedVacList.add(newVac);

          // Overwrite the existing entry in the map
          existingContra = existingContra.copyWith(
            contraindicatedVaccine: updatedVacList,
          );
        }

        // Store (or update) in the map by observation code
        if (code.isNotEmpty && code != 'Code') {
          vaccineContraMap[code] = existingContra;
        }
      }
    }

    // Build final arrays:
    final vaccineContraList = vaccineContraMap.values.toList();

    // Combine them back into 'contras'
    contras = contras.copyWith(
      vaccineGroup: antigenList.isEmpty
          ? null
          : VaccineGroupContraindications(contraindication: antigenList),
      vaccine: vaccineContraList.isEmpty
          ? null
          : VaccineContraindications(contraindication: vaccineContraList),
    );

    return contras;
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

  /// -----------------------------------------------------------
  ///         4) Helper: Parse a "Series" tab (rows)
  /// -----------------------------------------------------------
  Series _parseSeriesRows(List<List<String>> rows) {
    // We'll accumulate data in a mutable local Series, but it's declared final in Cicada,
    // so we reassign with .copyWith each time we update.
    var series = Series();

    // We'll keep track of the "current dose" while we parse
    // to attach intervals/vaccines. We store them in a local list,
    // then copy them back into the series each time.
    List<SeriesDose> doseList = [];

    // Pointers to the "current" dose object
    SeriesDose? currentDose;

    var skipMap = <String, ConditionalSkip>{};

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final firstCell = row[0].trim();

      // 4.a) Basic series info
      if (firstCell == 'Series Name' && row.length > 1) {
        series = series.copyWith(seriesName: row[1]);
      } else if (firstCell == 'Target Disease' && row.length > 1) {
        series = series.copyWith(targetDisease: row[1]);
      } else if (firstCell == 'Vaccine Group' && row.length > 1) {
        series = series.copyWith(vaccineGroup: row[1]);
      } else if (firstCell == 'Series Type' && row.length > 1) {
        // Example: standard, risk, etc. Adjust as needed
        final st = row[1].isNotEmpty && !row[1].contains('n/a')
            ? SeriesType.fromString(row[1])
            : null;
        series = series.copyWith(seriesType: st);
      } else if (firstCell == 'Equivalent Series Groups' && row.length > 1) {
        if (!row[1].contains('n/a')) {
          series = series.copyWith(
            equivalentSeriesGroups: EquivalentSeriesGroups.fromJson(row[1]),
          );
        }
      }
      // 4.b) Administrative Guidance lines
      else if (firstCell.contains('Administrative Guidance') &&
          row.length > 1) {
        final text = row[1];
        if (text.isNotEmpty && text != 'n/a' && text != 'Text') {
          final adminGuidance =
              series.seriesAdminGuidance?.toList() ?? <String>[];
          adminGuidance.add(text);
          series = series.copyWith(seriesAdminGuidance: adminGuidance);
        }
      }
      // 4.c) Gender lines (if any)
      else if (firstCell == 'Gender' && row.length > 1) {
        final genderStr = row[1];
        if (!genderStr.contains('n/a') && genderStr.isNotEmpty) {
          final existingGender = series.requiredGender?.toList() ?? <Gender>[];
          final g = Gender.fromJson(genderStr);
          if (g != null) existingGender.add(g);
          if (existingGender.isNotEmpty) {
            series = series.copyWith(requiredGender: existingGender);
          }
        }
      }
      // 4.d) Select Patient Series lines
      else if (firstCell.contains('Select Patient Series') && row.length > 7) {
        // row[1] => defaultSeries, row[2] => productPath, row[3] => seriesGroupName,
        // row[4] => seriesGroup, row[5] => seriesPriority, row[6] => seriesPreference,
        // row[7] => minAgeToStart, row[8] => maxAgeToStart, etc.
        final newSelectSeries = SelectSeries(
          defaultSeries: Binary.fromJson(row[1]),
          productPath: Binary.fromJson(row[2]),
          seriesGroupName: row[3],
          seriesGroup: row[4],
          seriesPriority: SeriesPriority.fromJson(row[5]),
          seriesPreference: SeriesPreference.fromJson(row[6]),
          minAgeToStart: _nullIfNA(row[7]),
          maxAgeToStart: _nullIfNA(row.length > 8 ? row[8] : ''),
        );
        series = series.copyWith(selectSeries: newSelectSeries);
      }
      // 4.e) Indication lines
      else if (firstCell == 'Indication' && row.length > 1) {
        // row[1] => "Observation (Code)"
        // row[2] => description, row[3] => beginAge, row[4] => endAge, row[5] => guidance
        final obsCell = row[1];
        final (code, text) = _extractCodeAndText(obsCell);
        final desc = (row.length > 2 && !row[2].contains('n/a'))
            ? row[2]
            : null;
        final beginAge = (row.length > 3 && !row[3].contains('n/a'))
            ? row[3]
            : null;
        final endAge = (row.length > 4 && !row[4].contains('n/a'))
            ? row[4]
            : null;
        final guidance = (row.length > 5 && !row[5].contains('n/a'))
            ? row[5]
            : null;

        final existingInd = series.indication?.toList() ?? [];
        if (code == 'Code' || code.isEmpty) {
          continue;
        }
        existingInd.add(
          Indication(
            observationCode: ObservationCode(code: code, text: text),
            description: desc,
            beginAge: beginAge,
            endAge: endAge,
            guidance: guidance,
          ),
        );
        series = series.copyWith(indication: existingInd);
      }
      // 4.f) Series Dose lines
      else if (firstCell.contains('Series Dose') && row.length > 1) {
        if (currentDose != null && skipMap.isNotEmpty) {
          // Convert skipMap.values → List<ConditionalSkip>
          final mergedSkips = skipMap.values.toList();
          currentDose = currentDose.copyWith(conditionalSkip: mergedSkips);
          doseList[doseList.length - 1] = currentDose;
          skipMap.clear();
        }

        // Start a new SeriesDose
        var newDose = SeriesDose(doseNumber: DoseNumber.fromString(row[1]));
        doseList.add(newDose);
        currentDose = newDose;
      }
      // 4.g) Age lines for current dose
      else if (firstCell.contains('Age') && currentDose != null) {
        if (row.length > 1 &&
            !(_nullIfNA(row[1])?.contains('Absolute Minimum Age') ?? false)) {
          final vaxAge = VaxAge(
            absMinAge: _nullIfNA(row[1]),
            minAge: _nullIfNA(row[2]),
            earliestRecAge: _nullIfNA(row[3]),
            latestRecAge: _nullIfNA(row[4]),
            maxAge: _nullIfNA(row[5]),
            effectiveDate: _nullIfNA(
              row.length > 6 ? row[6] : '',
            )?.simplifyDate,
            cessationDate: _nullIfNA(
              row.length > 7 ? row[7] : '',
            )?.simplifyDate,
          );
          // Replace the current dose with an updated copy
          final updatedAges = currentDose.age?.toList() ?? <VaxAge>[];
          if (vaxAge.toJson().isNotEmpty) updatedAges.add(vaxAge);
          if (updatedAges.isNotEmpty) {
            currentDose = currentDose.copyWith(age: updatedAges);
          }
          doseList[doseList.length - 1] = currentDose;
        }
      }
      // 4.h) Preferable Interval
      else if (firstCell.contains('Preferable Interval') &&
          currentDose != null) {
        if (row.length > 1 &&
            !(_nullIfNA(
                  row[1],
                )?.contains('From Immediate Previous Dose Administered?') ??
                false)) {
          final obsString = _nullIfNA(row.length > 4 ? row[4] : '');
          final (code, text) = obsString == null || obsString.isEmpty
              ? (null, null)
              : _extractCodeAndText(obsString);
          final newInterval = Interval(
            fromPrevious: _nullIfNA(row[1]),
            fromTargetDose: int.tryParse(row[2]),
            fromMostRecent: _nullIfNA(row[3]),
            fromRelevantObs: code == null && text == null
                ? null
                : ObservationCode(code: code, text: text),
            absMinInt: _nullIfNA(row.length > 5 ? row[5] : ''),
            minInt: _nullIfNA(row.length > 6 ? row[6] : ''),
            earliestRecInt: _nullIfNA(row.length > 7 ? row[7] : ''),
            latestRecInt: _nullIfNA(row.length > 8 ? row[8] : ''),
            intervalPriority: _nullIfNA(row.length > 9 ? row[9] : ''),
            effectiveDate: _nullIfNA(
              row.length > 10 ? row[10] : '',
            )?.simplifyDate,
            cessationDate: _nullIfNA(
              row.length > 11 ? row[11] : '',
            )?.simplifyDate,
          );
          if (!newInterval.isEmpty()) {
            final updatedPrefInt =
                currentDose.preferableInterval?.toList() ?? <Interval>[];
            updatedPrefInt.add(newInterval);
            currentDose = currentDose.copyWith(
              preferableInterval: updatedPrefInt,
            );
            doseList[doseList.length - 1] = currentDose;
          }
        }
      }
      // 4.i) Allowable Interval
      else if (firstCell.contains('Allowable Interval') &&
          currentDose != null &&
          !(_nullIfNA(
                row[1],
              )?.contains('From Immediate Previous Dose Administered?') ??
              false)) {
        final newInterval = Interval(
          fromPrevious: _nullIfNA(row[1]),
          fromTargetDose: int.tryParse(row[2]),
          absMinInt: _nullIfNA(row.length > 3 ? row[3] : ''),
          effectiveDate: _nullIfNA(row.length > 4 ? row[4] : '')?.simplifyDate,
          cessationDate: _nullIfNA(row.length > 5 ? row[5] : '')?.simplifyDate,
        );
        if (!newInterval.isEmpty()) {
          currentDose = currentDose.copyWith(allowableInterval: newInterval);
          doseList[doseList.length - 1] = currentDose;
        }
      }
      // 4.j) Preferable Vaccine
      else if (firstCell.contains('Preferable Vaccine') &&
          currentDose != null &&
          row.length > 1) {
        final (cvxCode, vaccineType) = _extractCodeAndText(row[1]);
        final (mvxCode, tradeName) = row.length > 4
            ? _extractCodeAndText(row[4])
            : (null, null);
        if (!vaccineType.contains('Vaccine Type') &&
            !vaccineType.contains('n/a')) {
          final vac = Vaccine(
            vaccineType: vaccineType,
            cvx: cvxCode,
            beginAge: _nullIfNA(row.length > 2 ? row[2] : ''),
            endAge: _nullIfNA(row.length > 3 ? row[3] : ''),
            tradeName:
                tradeName == null ||
                    tradeName.isEmpty ||
                    tradeName.contains('n/a')
                ? null
                : tradeName,
            mvx: mvxCode == null || mvxCode.isEmpty || mvxCode.contains('n/a')
                ? null
                : mvxCode,
            volume: _nullIfNA(row.length > 5 ? row[5] : ''),
            forecastVaccineType: _nullIfNA(row.length > 6 ? row[6] : ''),
          );

          final existingPrefVac =
              currentDose.preferableVaccine?.toList() ?? <Vaccine>[];
          existingPrefVac.add(vac);
          currentDose = currentDose.copyWith(
            preferableVaccine: existingPrefVac,
          );
          doseList[doseList.length - 1] = currentDose;
        }
      }
      // 4.k) Allowable Vaccine
      else if (firstCell.contains('Allowable Vaccine') &&
          currentDose != null &&
          row.length > 1) {
        final (cvxCode, vaccineType) = _extractCodeAndText(row[1]);
        if (!vaccineType.contains('Vaccine Type') &&
            !vaccineType.contains('n/a')) {
          final vac = Vaccine(
            vaccineType: vaccineType,
            cvx: cvxCode,
            beginAge: _nullIfNA(row.length > 2 ? row[2] : ''),
            endAge: _nullIfNA(row.length > 3 ? row[3] : ''),
          );
          final existingAllVac =
              currentDose.allowableVaccine?.toList() ?? <Vaccine>[];
          existingAllVac.add(vac);
          currentDose = currentDose.copyWith(allowableVaccine: existingAllVac);
          doseList[doseList.length - 1] = currentDose;
        }
      }
      // 4.l) Inadvertent Vaccine
      else if (firstCell.contains('Inadvertent Vaccine') &&
          currentDose != null &&
          row.length > 1) {
        final (cvxCode, vaccineType) = _extractCodeAndText(row[1]);
        if (!vaccineType.contains('Vaccine Type') &&
            !vaccineType.contains('n/a')) {
          final vac = Vaccine(vaccineType: vaccineType, cvx: cvxCode);
          final existingInvVac =
              currentDose.inadvertentVaccine?.toList() ?? <Vaccine>[];
          existingInvVac.add(vac);
          currentDose = currentDose.copyWith(
            inadvertentVaccine: existingInvVac,
          );
          doseList[doseList.length - 1] = currentDose;
        }
      }
      // 4.m) Conditional Skip
      else if (firstCell.contains('Conditional Skip') &&
          currentDose != null &&
          row.length > 2) {
        // We do NOT directly add to currentDose here.
        // Instead, we parse & store in a local dictionary.

        if (!row[1].toLowerCase().contains('n/a')) {
          final skipContext = SkipContext.fromString(row[1]);
          final setLogic = row[2];

          // We skip the row if it’s just a header (e.g., “Set Logic”)
          if (!setLogic.contains('Set Logic')) {
            // Basic set-level fields
            final setId = row.length > 3 ? row[3] : null;
            final setDesc = row.length > 4 ? row[4] : null;
            final effectiveDate = (row.length > 5 && !row[5].contains('n/a'))
                ? row[5]
                : null;

            final cessationDate = (row.length > 6 && !row[6].contains('n/a'))
                ? row[6]
                : null;

            final condLogic = (row.length > 7 && !row[7].contains('n/a'))
                ? row[7]
                : null;

            // Condition-level fields
            final condID =
                (row.length > 8 && row[8].isNotEmpty && !row[8].contains('n/a'))
                ? row[8]
                : null;
            final condType =
                (row.length > 9 && row[9].isNotEmpty && !row[9].contains('n/a'))
                ? row[9]
                : null;
            final startDate =
                (row.length > 10 &&
                    row[10].isNotEmpty &&
                    !row[10].contains('n/a'))
                ? row[10]
                : null;
            final endDate =
                (row.length > 11 &&
                    row[11].isNotEmpty &&
                    !row[11].contains('n/a'))
                ? row[11]
                : null;
            final beginAge =
                (row.length > 12 &&
                    row[12].isNotEmpty &&
                    !row[12].contains('n/a'))
                ? row[12]
                : null;
            final endAge =
                (row.length > 13 &&
                    row[13].isNotEmpty &&
                    !row[13].contains('n/a'))
                ? row[13]
                : null;
            final interval =
                (row.length > 14 &&
                    row[14].isNotEmpty &&
                    !row[14].contains('n/a'))
                ? row[14]
                : null;
            final doseCount =
                (row.length > 15 &&
                    row[15].isNotEmpty &&
                    !row[15].contains('n/a'))
                ? row[15]
                : null;
            final doseType =
                (row.length > 16 &&
                    row[16].isNotEmpty &&
                    !row[16].contains('n/a'))
                ? DoseType.fromJson(row[16])
                : null;
            final doseCountLogic =
                (row.length > 17 &&
                    row[17].isNotEmpty &&
                    !row[17].contains('n/a'))
                ? row[17]
                : null;
            final vaccineTypes =
                (row.length > 18 &&
                    row[18].isNotEmpty &&
                    !row[18].contains('n/a'))
                ? row[18]
                : null;
            final seriesGroups =
                (row.length > 19 &&
                    row[19].isNotEmpty &&
                    !row[19].contains('n/a'))
                ? row[19]
                : null;

            // Build a single VaxCondition object if condID/condType are valid
            VaxCondition? newCondition;
            if (condID != null &&
                condType != null &&
                condType != 'Condition Type') {
              newCondition = VaxCondition(
                conditionID: condID,
                conditionType: condType,
                startDate: startDate?.simplifyDate,
                endDate: endDate?.simplifyDate,
                beginAge: beginAge,
                endAge: endAge,
                interval: interval,
                doseCount: doseCount,
                doseType: doseType,
                doseCountLogic: doseCountLogic,
                vaccineTypes: vaccineTypes,
                seriesGroups: seriesGroups,
              );
            }

            // Prepare a dictionary key that uniquely identifies a single skip:
            // If you might have multiple sets under the same (skipContext, setLogic),
            // also include setId in the key:
            final skipKey = '${skipContext?.name}|$setLogic';

            // Check if we already have a ConditionalSkip for this key
            var existingSkip = skipMap[skipKey];
            if (existingSkip == null) {
              // Create a new empty skip
              existingSkip = ConditionalSkip(
                context: skipContext,
                setLogic: setLogic,
                set_: [],
              );
            }

            // Inside that skip, find (or create) the correct VaxSet by setId
            final existingSets = existingSkip.set_?.toList() ?? <VaxSet>[];
            VaxSet? targetSet = existingSets.firstWhere(
              (s) => s.setID == setId,
              orElse: () => VaxSet(
                setID: setId,
                setDescription: setDesc,
                effectiveDate: effectiveDate?.simplifyDate,
                cessationDate: cessationDate?.simplifyDate,
                conditionLogic: condLogic,
                condition: const [],
              ),
            );

            // If we newly created targetSet from orElse, we should add it to the list
            if (!existingSets.contains(targetSet)) {
              existingSets.add(targetSet);
            }

            // If setDescription or conditionLogic are blank on the first row, fill them from the row
            targetSet = targetSet.copyWith(
              setDescription: targetSet.setDescription?.isNotEmpty == true
                  ? targetSet.setDescription
                  : setDesc,
              conditionLogic: targetSet.conditionLogic?.isNotEmpty == true
                  ? targetSet.conditionLogic
                  : condLogic,
            );

            // Add the new condition if we have one
            if (newCondition != null) {
              final condList =
                  targetSet.condition?.toList() ?? <VaxCondition>[];
              condList.add(newCondition);
              targetSet = targetSet.copyWith(condition: condList);
            }

            // Now put the updated set back into existingSets
            final setIndex = existingSets.indexWhere((s) => s.setID == setId);
            existingSets[setIndex] = targetSet;

            // Finally, store the updated skip
            existingSkip = existingSkip.copyWith(set_: existingSets);
            skipMap[skipKey] = existingSkip;
          }
        }
      }
      // 4.n) Recurring Dose
      else if (firstCell.contains('Recurring Dose') &&
          currentDose != null &&
          row.length > 1) {
        final recDose = Binary.fromJson(row[1]);
        currentDose = currentDose.copyWith(recurringDose: recDose);
        doseList[doseList.length - 1] = currentDose;
      }
      // 4.o) Seasonal Recommendation
      else if (firstCell.contains('Seasonal Recommendation') &&
          currentDose != null) {
        var start = (row.length > 1 && !row[1].contains('n/a')) ? row[1] : null;

        var end = (row.length > 2 && !row[2].contains('n/a')) ? row[2] : null;

        if (start?.contains('Start Date') ?? false) {
          start = null;
        }
        if (end?.contains('End Date') ?? false) {
          end = null;
        }
        if (start == null && end == null) {
          continue;
        }
        start = start?.simplifyDate;
        end = end?.simplifyDate;
        final seasRec = SeasonalRecommendation(startDate: start, endDate: end);
        currentDose = currentDose.copyWith(seasonalRecommendation: seasRec);
        doseList[doseList.length - 1] = currentDose;
      }
    }

    if (currentDose != null && skipMap.isNotEmpty) {
      final mergedSkips = skipMap.values.toList();
      currentDose = currentDose.copyWith(conditionalSkip: mergedSkips);
      doseList[doseList.length - 1] = currentDose;
      skipMap.clear();
    }

    // After the loop, put the final doseList into the series
    series = series.copyWith(seriesDose: doseList);
    return series;
  }

  /// -----------------------------------------------------------
  ///   Utility: Return null if a string is empty or "n/a"
  /// -----------------------------------------------------------
  String? _nullIfNA(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty || trimmed == 'n/a') {
      return null;
    }
    return input.trim();
  }
}

extension SimplifyDate on String {
  String get simplifyDate {
    return this.substring(0, 10);
  }
}
