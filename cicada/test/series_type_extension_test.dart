import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:test/test.dart';

const String seriesTypeExtUrl =
    'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/series-type-ext';

/// CDSi FORECASTVG-1 scopes a vaccine group forecast to a series group, so a
/// vaccine group holding both a standard and a risk series group returns two
/// recommendations with the same target disease. Core FHIR has no element that
/// says which pathway a recommendation describes, and neither does the US ImmDS
/// IG, so without the cicada series-type extension a client receiving an MMR
/// "Complete" and an MMR "Not Complete" cannot tell which is which.
///
/// This test uses `2016-UC-0032`, whose MMR group forecasts risk=Not Complete
/// alongside standard=Complete.
/// Every recommendation in the ImmDS response Parameters.
List<ImmunizationRecommendationRecommendation> _recommendationsOf(
    Parameters response) {
  return response.parameter
          ?.map((ParametersParameter p) => p.resource)
          .whereType<ImmunizationRecommendation>()
          .expand((ImmunizationRecommendation r) => r.recommendation)
          .toList() ??
      <ImmunizationRecommendationRecommendation>[];
}

void main() {
  late Parameters params;

  setUpAll(() {
    Map<String, dynamic>? found;
    for (final String line
        in File('test/conditionTestCases.ndjson').readAsLinesSync()) {
      if (line.trim().isEmpty) continue;
      final decoded = jsonDecode(line) as Map<String, dynamic>;
      for (final dynamic p
          in decoded['parameter'] as List<dynamic>? ?? <dynamic>[]) {
        final param = p as Map<String, dynamic>;
        if (!param.containsKey('resource')) continue;
        final r = param['resource'] as Map<String, dynamic>;
        if (r['resourceType'] == 'Immunization' && !r.containsKey('status')) {
          r['status'] = 'completed';
        }
        if (r['resourceType'] == 'Patient' && r['id'] == '2016-UC-0032') {
          found = decoded;
        }
      }
    }
    expect(found, isNotNull, reason: 'case 2016-UC-0032 not in the NDJSON');
    params = Parameters.fromJson(found!);
  });

  String? seriesTypeOf(ImmunizationRecommendationRecommendation r) {
    final ext = r.extension_
        ?.where((FhirExtension e) => e.url.valueString == seriesTypeExtUrl);
    if (ext == null || ext.isEmpty) return null;
    return ext.first.valueCodeableConcept?.coding?.first.code?.valueString;
  }

  test('a doubled vaccine group returns two distinguishable recommendations',
      () {
    final result = evaluateForForecast(params);
    final mmr = result.vaccineGroupForecasts['MMR'];
    expect(mmr, isNotNull);
    expect(mmr!.length, 2,
        reason: 'MMR should carry a risk and a standard forecast');

    final response = buildImmdsResponse(result);
    final recs = _recommendationsOf(response)
        .where((r) => r.targetDisease?.text?.valueString == 'MMR')
        .toList();
    expect(recs.length, 2, reason: 'both forecasts must reach the response');

    final types = recs.map(seriesTypeOf).toList();
    expect(types, containsAll(<String>['risk', 'standard']),
        reason: 'the two MMR recommendations must be told apart by '
            'the series-type extension, got $types');

    // The distinction has to be load-bearing: the two disagree on status.
    final statuses = recs
        .map((r) => r.forecastStatus.coding?.first.display?.valueString)
        .toSet();
    expect(statuses.length, 2,
        reason: 'this case is only a useful test while the two statuses '
            'differ; got $statuses');
  });

  test('every recommendation carries a series type', () {
    final response = buildImmdsResponse(evaluateForForecast(params));
    for (final r in _recommendationsOf(response)) {
      expect(seriesTypeOf(r), isNotNull,
          reason: 'recommendation for '
              '${r.targetDisease?.text?.valueString} has no series type');
    }
  });
}
