import 'package:cicada/cicada.dart';
import 'package:cicada_ehr/cicada_ehr.dart';
import 'package:cicada_flutter/src/services/forecast_service.dart';
import 'package:cicada_flutter/src/widgets/vaccine_group_card.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// A pregnant adult with no doses: the DTaP/Tdap/Td vaccine group holds a
/// standard and a risk series group, so the engine returns two forecasts for
/// it (CDSi Logic Specification v4.6, Table 9-2 FORECASTVG-1). Found on
/// Epic's sandbox 2026-11-20: the dashboard showed two "DTaP/Tdap/Td" cards
/// that only the antigen line told apart.
Parameters _pregnantAdult() => Parameters.fromJson(<String, dynamic>{
  'resourceType': 'Parameters',
  'parameter': <Map<String, dynamic>>[
    {'name': 'assessmentDate', 'valueDate': '2026-11-20'},
    {
      'name': 'patient',
      'resource': <String, dynamic>{
        'resourceType': 'Patient',
        'id': '1',
        'birthDate': '1983-09-09',
        'gender': 'female',
      },
    },
    {
      'name': 'condition',
      'resource': <String, dynamic>{
        'resourceType': 'Condition',
        'id': 'preg',
        'clinicalStatus': {
          'coding': [
            {
              'system':
                  'http://terminology.hl7.org/CodeSystem/condition-clinical',
              'code': 'active',
            },
          ],
        },
        'verificationStatus': {
          'coding': [
            {
              'system':
                  'http://terminology.hl7.org/CodeSystem/condition-ver-status',
              'code': 'confirmed',
            },
          ],
        },
        'subject': {'reference': 'Patient/1'},
        'code': {
          'coding': [
            {
              'system': 'http://snomed.info/sct',
              'code': '77386006',
              'display': 'Pregnancy',
            },
          ],
        },
      },
    },
  ],
});

Future<void> _pump(WidgetTester tester, List<VaccineGroupForecast> fs) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            for (final f in fs)
              VaccineGroupCard(
                forecast: f,
                assessmentDate: VaxDate(2026, 11, 20),
                category: categorize(f, VaxDate(2026, 11, 20)),
              ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  late List<VaccineGroupForecast> dtap;

  setUpAll(() {
    final result = ForecastService.runForecastOnChart(_pregnantAdult());
    dtap = result.vaccineGroupForecasts.values
        .expand((l) => l)
        .where((f) => f.vaccineGroupName == 'DTaP/Tdap/Td')
        .toList();
  });

  test(
    'the engine returns one standard and one risk DTaP/Tdap/Td forecast',
    () {
      expect(dtap.map((f) => f.isRiskForecast).toList()..sort(_falseFirst), [
        false,
        true,
      ]);
    },
  );

  testWidgets('the risk card says it is the risk series and why', (
    tester,
  ) async {
    await _pump(tester, dtap.where((f) => f.isRiskForecast).toList());
    final risk = dtap.firstWhere((f) => f.isRiskForecast);
    expect(
      find.text('${risk.seriesGroupName}: Pregnancy'),
      findsOneWidget,
      reason: 'the chart entry that put the patient on the risk series',
    );
  });

  testWidgets('the standard card claims no risk', (tester) async {
    await _pump(tester, dtap.where((f) => !f.isRiskForecast).toList());
    expect(find.textContaining('Pregnancy'), findsNothing);
    expect(find.textContaining('Risk'), findsNothing);
  });
}

int _falseFirst(bool a, bool b) => (a ? 1 : 0) - (b ? 1 : 0);
