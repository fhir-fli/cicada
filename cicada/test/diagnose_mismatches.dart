import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/test_forecasts.dart';

const excelToEngine = {
  'DTAP': 'DTaP/Tdap/Td',
  'FLU': 'Influenza',
  'HIB': 'Hib',
  'HPV': 'HPV',
  'HepA': 'HepA',
  'HepB': 'HepB',
  'MCV': 'Meningococcal',
  'MENB': 'Meningococcal B',
  'MMR': 'MMR',
  'PCV': 'Pneumococcal',
  'POL': 'Polio',
  'ROTA': 'Rotavirus',
  'RSV': 'RSV',
  'VAR': 'Varicella',
  'ZOSTER': 'Zoster',
  'COVID-19': 'COVID-19',
};

// Multi-antigen groups
const multiAntigenGroups = {
  'DTaP/Tdap/Td': ['Diphtheria', 'Tetanus', 'Pertussis'],
};

Future<List<Parameters>> loadTestCases(String filePath) async {
  final file = File(filePath);
  final lines = await file.readAsLines();
  final testCases = <Parameters>[];

  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    final json = jsonDecode(line) as Map<String, dynamic>;

    // Fix missing status in Immunization resources
    if (json['parameter'] != null) {
      final params = json['parameter'] as List;
      for (final param in params) {
        if (param['resource']?['resourceType'] == 'Immunization') {
          param['resource']['status'] ??= 'completed';
        }
      }
    }

    testCases.add(Parameters.fromJson(json));
  }

  return testCases;
}

String getSeriesStatusFromResult(
  ForecastResult result,
  String excelVg,
) {
  final engineVg = excelToEngine[excelVg];
  if (engineVg == null) return 'Not Complete';

  // Find ALL matching antigens for this vaccine group.
  // For each antigen, pick the best series across its groups
  // (prefer complete/immune from prioritizedSeries or bestSeries,
  // then non-complete, then fallback). Then among antigen
  // representatives, pick least complete for multi-antigen
  // groups (e.g., DTaP has Diphtheria, Tetanus, Pertussis).
  final Map<String, VaxSeries> antigenRepresentatives = {};
  for (final antigen in result.agMap.values) {
    if (antigen.vaccineGroupName != engineVg) continue;
    VaxSeries? completeSeries;
    VaxSeries? activeSeries;
    VaxSeries? agedOutSeries;
    VaxSeries? fallback;
    for (final group in antigen.groups.values) {
      // Check prioritizedSeries first (engine's primary output)
      for (final ps in group.prioritizedSeries) {
        if (ps.seriesStatus == SeriesStatus.complete ||
            ps.seriesStatus == SeriesStatus.immune) {
          completeSeries ??= ps;
        } else if (ps.seriesStatus == SeriesStatus.agedOut) {
          agedOutSeries ??= ps;
        } else {
          activeSeries ??= ps;
        }
      }
      // Also check bestSeries (secondary, only set in edge cases)
      if (group.bestSeries != null) {
        if (group.bestSeries!.seriesStatus == SeriesStatus.complete ||
            group.bestSeries!.seriesStatus == SeriesStatus.immune) {
          completeSeries ??= group.bestSeries;
        } else if (group.bestSeries!.seriesStatus == SeriesStatus.agedOut) {
          agedOutSeries ??= group.bestSeries;
        } else {
          activeSeries ??= group.bestSeries;
        }
      }
      if (group.series.isNotEmpty) {
        fallback ??= group.series.first;
      }
    }
    final best = completeSeries ?? activeSeries ?? agedOutSeries ?? fallback;
    if (best != null) {
      antigenRepresentatives[antigen.targetDisease] = best;
    }
  }

  // Among antigen representatives, pick least complete
  // (multi-antigen groups like DTaP need all antigens complete)
  VaxSeries? bestSeries;
  if (antigenRepresentatives.isNotEmpty) {
    final notComplete = antigenRepresentatives.values
        .where((s) => s.seriesStatus != SeriesStatus.complete
            && s.seriesStatus != SeriesStatus.immune).toList();
    bestSeries = notComplete.isNotEmpty
        ? notComplete.first
        : antigenRepresentatives.values.first;
  }

  if (bestSeries == null) return 'Not Complete';

  return bestSeries.seriesStatus.toString().toLowerCase();
}

bool _isLessComplete(SeriesStatus a, SeriesStatus b) {
  const order = {
    SeriesStatus.notComplete: 0,
    SeriesStatus.agedOut: 1,
    SeriesStatus.complete: 2,
    SeriesStatus.immune: 3,
  };
  return (order[a] ?? 0) < (order[b] ?? 0);
}

void printSeriesDetails(VaxSeries series, String indent, {bool isBest = false, bool isPrioritized = false}) {
  final marker = isBest ? ' [BEST]' : (isPrioritized ? ' [PRIORITIZED]' : '');
  print('$indent- ${series.series.seriesName}$marker');
  print('$indent  Type: ${series.series.seriesType}');
  print('$indent  Status: ${series.seriesStatus}');
  print('$indent  TargetDose: ${series.targetDose}');
  print('$indent  Evaluated doses: ${series.evaluatedDoses.length}');
  final validDoses = series.evaluatedDoses.where((d) => d.evalStatus == EvalStatus.valid).length;
  print('$indent  Valid doses: $validDoses');
  print('$indent  Score: ${series.score}');

  // Show evaluated target dose map
  if (series.evaluatedTargetDose.isNotEmpty) {
    print('$indent  Evaluated target doses:');
    for (final entry in series.evaluatedTargetDose.entries) {
      print('$indent    Dose ${entry.key}: ${entry.value}');
    }
  }
}

void analyzeMismatch(
  String patientId,
  String vaccineGroup,
  String expected,
  String actual,
  ForecastResult result,
) {
  print('\n${'=' * 80}');
  print('Patient: $patientId');
  print('Vaccine Group: $vaccineGroup');
  print('Expected: $expected');
  print('Actual: $actual');
  print('${'=' * 80}');

  final engineGroup = excelToEngine[vaccineGroup] ?? vaccineGroup;

  // For multi-antigen groups
  if (multiAntigenGroups.containsKey(engineGroup)) {
    final antigens = multiAntigenGroups[engineGroup]!;
    print('\nMULTI-ANTIGEN GROUP: $engineGroup');
    print('Antigens: ${antigens.join(', ')}');

    for (final antigenName in antigens) {
      final ag = result.agMap.values
          .firstWhereOrNull((a) => a.targetDisease == antigenName);
      if (ag == null) {
        print('\n  Antigen: $antigenName - NOT FOUND');
        continue;
      }

      print('\n  Antigen: $antigenName');
      final groups = ag.groups.values.where((g) => g.vaccineGroupName == engineGroup);

      for (final group in groups) {
        print('\n    Group: ${group.vaccineGroupName}');
        print('    Total series: ${group.series.length}');
        print('    Prioritized series: ${group.prioritizedSeries.length}');
        print('    Best series: ${group.bestSeries?.series.seriesName ?? "NONE"}');

        print('\n    All series:');
        for (final series in group.series) {
          final isBest = series == group.bestSeries;
          final isPrioritized = group.prioritizedSeries.contains(series);
          printSeriesDetails(series, '      ', isBest: isBest, isPrioritized: isPrioritized);
          print('');
        }
      }
    }
    return;
  }

  // Single antigen groups
  final ag = result.agMap.values.firstWhereOrNull(
    (a) => a.vaccineGroupName == engineGroup,
  );

  if (ag == null) {
    print('\nAntigen for $engineGroup NOT FOUND in result');
    print('Available antigens:');
    for (final antigen in result.agMap.values) {
      print('  - ${antigen.targetDisease} (${antigen.vaccineGroupName})');
    }
    return;
  }

  print('\nAntigen: ${ag.targetDisease}');

  // Show ALL groups for this antigen (important for PCV/COVID-19)
  print('\nAll groups for this antigen:');
  for (final groupEntry in ag.groups.entries) {
    final group = groupEntry.value;
    print('\n  Group: ${group.vaccineGroupName} (Key: ${groupEntry.key})');
    print('  Total series: ${group.series.length}');
    print('  Prioritized series: ${group.prioritizedSeries.length}');
    print('  Best series: ${group.bestSeries?.series.seriesName ?? "NONE"}');

    print('\n  All series:');
    for (final series in group.series) {
      final isBest = series == group.bestSeries;
      final isPrioritized = group.prioritizedSeries.contains(series);
      printSeriesDetails(series, '    ', isBest: isBest, isPrioritized: isPrioritized);
      print('');
    }
  }
}

void main() async {
  final testCases = await loadTestCases('test/healthyTestCases.ndjson');
  print('Loaded ${testCases.length} test cases\n');

  var mismatchCount = 0;
  final mismatchesByType = <String, int>{};
  final mismatchesByGroup = <String, int>{};

  for (final testCase in testCases) {
    // Get patient ID from Patient resource, not from parameter
    final Patient? patient = testCase.parameter
        ?.firstWhereOrNull((ParametersParameter e) => e.resource is Patient)
        ?.resource as Patient?;
    final patientId = patient?.id?.toString();

    if (patientId == null) continue;

    final expected = testForecasts[patientId];
    if (expected == null) continue;

    final result = evaluateForForecast(testCase);

    for (final forecast in expected) {
      final seriesStatus = forecast['seriesStatus'];
      if (seriesStatus == null) continue;

      final expectedStatus = seriesStatus.toLowerCase();
      final vaccineGroup = forecast['vaccineGroup'] ?? '';
      final actualStatus = getSeriesStatusFromResult(result, vaccineGroup);

      if (expectedStatus != actualStatus) {
        mismatchCount++;
        final mismatchType = '$expectedStatus→$actualStatus';
        mismatchesByType[mismatchType] = (mismatchesByType[mismatchType] ?? 0) + 1;
        mismatchesByGroup[vaccineGroup] = (mismatchesByGroup[vaccineGroup] ?? 0) + 1;

        // Analyze this mismatch
        analyzeMismatch(
          patientId,
          vaccineGroup,
          expectedStatus,
          actualStatus,
          result,
        );
      }
    }
  }

  print('\n${'=' * 80}');
  print('SUMMARY');
  print('${'=' * 80}');
  print('Total mismatches: $mismatchCount');
  print('\nBy type:');
  for (final entry in mismatchesByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))) {
    print('  ${entry.key}: ${entry.value}');
  }
  print('\nBy vaccine group:');
  for (final entry in mismatchesByGroup.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))) {
    print('  ${entry.key}: ${entry.value}');
  }
}
