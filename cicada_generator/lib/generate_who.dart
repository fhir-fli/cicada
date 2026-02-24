/// Generates WHO immunization antigen and schedule JSON files.
///
/// Run with: dart cicada_generator/lib/generate_who.dart
/// Then: dart cicada_generator/lib/main.dart --who
import 'dart:convert';
import 'dart:io';

void main() {
  final antigenDir = 'cicada_generator/lib/WHO/antigen';
  final scheduleDir = 'cicada_generator/lib/WHO/schedule';

  Directory(antigenDir).createSync(recursive: true);
  Directory(scheduleDir).createSync(recursive: true);

  // Write antigen JSON files
  for (final entry in whoAntigens.entries) {
    final path = '$antigenDir/${entry.key}.json';
    File(path).writeAsStringSync(_pp(entry.value));
    print('Wrote $path');
  }

  // Write schedule JSON
  File('$scheduleDir/schedule_supporting_data.json')
      .writeAsStringSync(_pp(whoScheduleData));
  print('Wrote schedule supporting data');

  print('\nGenerated ${whoAntigens.length} antigen files + schedule data.');
  print('Run: dart cicada_generator/lib/main.dart --who');
}

String _pp(Map<String, dynamic> m) =>
    const JsonEncoder.withIndent('    ').convert(m);

// =============================================================================
//  Helper constructors
// =============================================================================

Map<String, dynamic> _ag(
  String disease,
  String group, {
  Map<String, dynamic>? immunity,
  Map<String, dynamic>? contraindications,
  required List<Map<String, dynamic>> series,
}) =>
    {
      'targetDisease': disease,
      'vaccineGroup': group,
      if (immunity != null) 'immunity': immunity,
      if (contraindications != null) 'contraindications': contraindications,
      'series': series,
    };

Map<String, dynamic> _series(
  String name,
  String disease,
  String group, {
  String type = 'Standard',
  String? eqGroups,
  List<String>? gender,
  required Map<String, dynamic> select,
  List<Map<String, dynamic>>? indications,
  required List<Map<String, dynamic>> doses,
}) =>
    {
      'seriesName': name,
      'targetDisease': disease,
      'vaccineGroup': group,
      'seriesType': type,
      if (eqGroups != null) 'equivalentSeriesGroups': eqGroups,
      if (gender != null) 'requiredGender': gender,
      'selectSeries': select,
      if (indications != null) 'indication': indications,
      'seriesDose': doses,
    };

Map<String, dynamic> _sel({
  String def = 'Yes',
  String prod = 'No',
  String groupName = 'Standard',
  String group = '1',
  String priority = 'A',
  String preference = '1',
  String? minAge,
  String? maxAge,
}) =>
    {
      'defaultSeries': def,
      'productPath': prod,
      'seriesGroupName': groupName,
      'seriesGroup': group,
      'seriesPriority': priority,
      'seriesPreference': preference,
      if (minAge != null) 'minAgeToStart': minAge,
      if (maxAge != null) 'maxAgeToStart': maxAge,
    };

Map<String, dynamic> _dose(
  String num, {
  Map<String, dynamic>? age,
  List<Map<String, dynamic>>? intervals,
  Map<String, dynamic>? allowableInterval,
  List<Map<String, dynamic>>? prefVax,
  List<Map<String, dynamic>>? allowVax,
  List<Map<String, dynamic>>? inadvertentVax,
  List<Map<String, dynamic>>? conditionalSkip,
  String recurring = 'No',
}) =>
    {
      'doseNumber': num,
      if (age != null) 'age': [age],
      if (intervals != null) 'interval': intervals,
      if (allowableInterval != null) 'allowableInterval': allowableInterval,
      if (prefVax != null) 'preferableVaccine': prefVax,
      if (allowVax != null) 'allowableVaccine': allowVax,
      if (inadvertentVax != null) 'inadvertentVaccine': inadvertentVax,
      if (conditionalSkip != null) 'conditionalSkip': conditionalSkip,
      'recurringDose': recurring,
    };

Map<String, dynamic> _a({
  String? absMin,
  String? min,
  String? rec,
  String? latestRec,
  String? max,
}) =>
    {
      if (absMin != null) 'absMinAge': absMin,
      if (min != null) 'minAge': min,
      if (rec != null) 'earliestRecAge': rec,
      if (latestRec != null) 'latestRecAge': latestRec,
      if (max != null) 'maxAge': max,
    };

Map<String, dynamic> _int({
  String from = 'Y',
  String? absMin,
  String? min,
  String? rec,
  String? latestRec,
}) =>
    {
      'fromPrevious': from,
      if (absMin != null) 'absMinInt': absMin,
      if (min != null) 'minInt': min,
      if (rec != null) 'earliestRecInt': rec,
      if (latestRec != null) 'latestRecInt': latestRec,
    };

Map<String, dynamic> _v(
  String type,
  String cvx, {
  String? beginAge,
  String? endAge,
  String? volume,
  String forecast = 'N',
}) =>
    {
      'vaccineType': type,
      'cvx': cvx,
      if (beginAge != null) 'beginAge': beginAge,
      if (endAge != null) 'endAge': endAge,
      if (volume != null) 'volume': volume,
      'forecastVaccineType': forecast,
    };

Map<String, dynamic> _av(String type, String cvx,
        {String? beginAge, String? endAge}) =>
    {
      'vaccineType': type,
      'cvx': cvx,
      if (beginAge != null) 'beginAge': beginAge,
      if (endAge != null) 'endAge': endAge,
    };

Map<String, dynamic> _ind(String code, String text,
        {String? beginAge, String? endAge}) =>
    {
      'observationCode': {'code': code, 'text': text},
      if (beginAge != null) 'beginAge': beginAge,
      if (endAge != null) 'endAge': endAge,
    };

Map<String, dynamic> _gc(String code, String title, String text,
        {String? beginAge, String? endAge}) =>
    {
      'observationCode': code,
      'observationTitle': title,
      'contraindicationText': text,
      if (beginAge != null) 'beginAge': beginAge,
      if (endAge != null) 'endAge': endAge,
    };

// =============================================================================
//  WHO Antigen Definitions
// =============================================================================

final whoAntigens = <String, Map<String, dynamic>>{
  // Phase 1 - Core EPI
  'Tuberculosis': _whoBcg,
  'HepB': _whoHepB,
  'Diphtheria': _whoDiphtheria,
  'Tetanus': _whoTetanus,
  'Pertussis': _whoPertussis,
  'Hib': _whoHib,
  'Polio': _whoPolio,
  'Measles': _whoMeasles,
  'Rubella': _whoRubella,
  'Pneumococcal': _whoPcv,
  'Rotavirus': _whoRotavirus,
  'HPV': _whoHpv,
  // Phase 2 - Context-dependent
  'HepA': _whoHepA,
  'Yellow Fever': _whoYellowFever,
  'Japanese Encephalitis': _whoJe,
  'Meningococcal': _whoMeningococcal,
  'Typhoid': _whoTyphoid,
  'Cholera': _whoCholera,
  'Rabies': _whoRabies,
  'Mumps': _whoMumps,
  'Influenza': _whoInfluenza,
  'COVID-19': _whoCovid,
};

// ======================== BCG ========================
// WHO: Single dose at birth. No booster.
final _whoBcg = _ag('Tuberculosis', 'BCG', series: [
  _series('WHO Tuberculosis 1-dose series', 'Tuberculosis', 'BCG',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '0 days', min: '0 days', rec: '0 days',
                max: '12 months'),
            prefVax: [_v('BCG', '19', beginAge: '0 days', forecast: 'Y')],
            allowVax: [_av('BCG', '19', beginAge: '0 days')]),
      ]),
]);

// ======================== Hepatitis B ========================
// WHO: Birth dose within 24h + 2 more doses (as monovalent or pentavalent)
final _whoHepB = _ag('HepB', 'HepB',
    immunity: {
      'clinicalHistory': [
        {
          'guidelineCode': '1070',
          'guidelineTitle': 'Serologic evidence of immunity (anti-HBs ≥10 mIU/mL)'
        }
      ]
    },
    series: [
      _series('WHO HepB 3-dose series', 'HepB', 'HepB',
          select: _sel(),
          doses: [
            _dose('Dose 1',
                age: _a(
                    absMin: '0 days',
                    min: '0 days',
                    rec: '0 days',
                    latestRec: '24 hours'),
                prefVax: [
                  _v('Hep B, adolescent or pediatric', '08',
                      beginAge: '0 days', forecast: 'Y'),
                ],
                allowVax: [
                  _av('Hep B, adolescent or pediatric', '08',
                      beginAge: '0 days'),
                  _av('Hep B, adult', '43', beginAge: '0 days'),
                  _av('Hep B, unspecified', '45', beginAge: '0 days'),
                  _av('Hep B-Hib', '51', beginAge: '6 weeks'),
                  _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
                ]),
            _dose('Dose 2',
                age: _a(
                    absMin: '4 weeks', min: '4 weeks', rec: '6 weeks'),
                intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '6 weeks')],
                prefVax: [
                  _v('DTP-HepB-Hib (Pentavalent)', '198',
                      beginAge: '6 weeks', forecast: 'Y'),
                  _v('Hep B, adolescent or pediatric', '08',
                      beginAge: '0 days'),
                ],
                allowVax: [
                  _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
                  _av('Hep B, adolescent or pediatric', '08',
                      beginAge: '0 days'),
                  _av('Hep B, adult', '43', beginAge: '0 days'),
                  _av('Hep B-Hib', '51', beginAge: '6 weeks'),
                ]),
            _dose('Dose 3',
                age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks'),
                intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '8 weeks')],
                prefVax: [
                  _v('DTP-HepB-Hib (Pentavalent)', '198',
                      beginAge: '6 weeks', forecast: 'Y'),
                  _v('Hep B, adolescent or pediatric', '08',
                      beginAge: '0 days'),
                ],
                allowVax: [
                  _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
                  _av('Hep B, adolescent or pediatric', '08',
                      beginAge: '0 days'),
                  _av('Hep B, adult', '43', beginAge: '0 days'),
                  _av('Hep B-Hib', '51', beginAge: '6 weeks'),
                ]),
          ]),
    ]);

// ======================== Diphtheria ========================
// WHO: 3 primary (6w/10w/14w) + 3 boosters (12-23m, 4-7y, 9-15y)
final _whoDiphtheria = _ag('Diphtheria', 'DTP', series: [
  _series('WHO Diphtheria 6-dose series', 'Diphtheria', 'DTP',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 weeks', min: '6 weeks', rec: '6 weeks'),
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
              _v('DTP', '01', beginAge: '6 weeks'),
              _v('DTaP', '20', beginAge: '6 weeks'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('DTaP-IPV/Hib', '120', beginAge: '6 weeks'),
              _av('DTaP-IPV', '130', beginAge: '6 weeks'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '10 weeks', min: '10 weeks', rec: '10 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('DTaP-IPV/Hib', '120', beginAge: '6 weeks'),
              _av('DTaP-IPV', '130', beginAge: '6 weeks'),
            ]),
        _dose('Dose 3',
            age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('DTaP-IPV/Hib', '120', beginAge: '6 weeks'),
              _av('DTaP-IPV', '130', beginAge: '6 weeks'),
            ]),
        _dose('Dose 4',
            age: _a(absMin: '12 months', min: '12 months', rec: '12 months',
                latestRec: '23 months'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '6 months')],
            prefVax: [
              _v('DTP', '01', beginAge: '12 months', forecast: 'Y'),
              _v('DTaP', '20', beginAge: '12 months'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
            ]),
        _dose('Dose 5',
            age: _a(absMin: '4 years', min: '4 years', rec: '4 years',
                latestRec: '7 years'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '3 years')],
            prefVax: [
              _v('DTP', '01', beginAge: '4 years', forecast: 'Y'),
              _v('DTaP', '20', beginAge: '4 years'),
              _v('Td', '138', beginAge: '4 years'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('Td', '138', beginAge: '4 years'),
              _av('Td adult', '09', beginAge: '7 years'),
              _av('Tdap', '115', beginAge: '4 years'),
            ]),
        _dose('Dose 6',
            age: _a(absMin: '9 years', min: '9 years', rec: '9 years',
                latestRec: '15 years'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '5 years')],
            prefVax: [
              _v('Td', '138', beginAge: '7 years', forecast: 'Y'),
              _v('Td adult', '09', beginAge: '7 years'),
              _v('Tdap', '115', beginAge: '7 years'),
            ],
            allowVax: [
              _av('Td', '138', beginAge: '7 years'),
              _av('Td adult', '09', beginAge: '7 years'),
              _av('Tdap', '115', beginAge: '7 years'),
            ]),
      ]),
]);

// ======================== Tetanus ========================
// WHO: Same as Diphtheria (given together as DTP)
final _whoTetanus = _ag('Tetanus', 'DTP', series: [
  _series('WHO Tetanus 6-dose series', 'Tetanus', 'DTP',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 weeks', min: '6 weeks', rec: '6 weeks'),
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('Td', '138', beginAge: '6 weeks'),
              _av('Td adult', '09', beginAge: '7 years'),
              _av('Tdap', '115', beginAge: '6 weeks'),
              _av('TT', '35', beginAge: '6 weeks'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '10 weeks', min: '10 weeks', rec: '10 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('Td', '138', beginAge: '6 weeks'),
              _av('Td adult', '09', beginAge: '7 years'),
              _av('Tdap', '115', beginAge: '6 weeks'),
              _av('TT', '35', beginAge: '6 weeks'),
            ]),
        _dose('Dose 3',
            age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('Td', '138', beginAge: '6 weeks'),
              _av('Tdap', '115', beginAge: '6 weeks'),
              _av('TT', '35', beginAge: '6 weeks'),
            ]),
        _dose('Dose 4',
            age: _a(absMin: '12 months', min: '12 months', rec: '12 months',
                latestRec: '23 months'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '6 months')],
            prefVax: [
              _v('DTP', '01', beginAge: '12 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('Td', '138', beginAge: '6 weeks'),
              _av('Tdap', '115', beginAge: '6 weeks'),
              _av('TT', '35', beginAge: '6 weeks'),
            ]),
        _dose('Dose 5',
            age: _a(absMin: '4 years', min: '4 years', rec: '4 years',
                latestRec: '7 years'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '3 years')],
            prefVax: [
              _v('Td', '138', beginAge: '4 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('Td', '138', beginAge: '4 years'),
              _av('Td adult', '09', beginAge: '7 years'),
              _av('Tdap', '115', beginAge: '4 years'),
              _av('TT', '35', beginAge: '6 weeks'),
            ]),
        _dose('Dose 6',
            age: _a(absMin: '9 years', min: '9 years', rec: '9 years',
                latestRec: '15 years'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '5 years')],
            prefVax: [
              _v('Td', '138', beginAge: '7 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('Td', '138', beginAge: '7 years'),
              _av('Td adult', '09', beginAge: '7 years'),
              _av('Tdap', '115', beginAge: '7 years'),
              _av('TT', '35', beginAge: '6 weeks'),
            ]),
      ]),
]);

// ======================== Pertussis ========================
// WHO: 3 primary + 2 boosters (no pertussis in final Td booster)
final _whoPertussis = _ag('Pertussis', 'DTP', series: [
  _series('WHO Pertussis 5-dose series', 'Pertussis', 'DTP',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 weeks', min: '6 weeks', rec: '6 weeks'),
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('DTaP-IPV/Hib', '120', beginAge: '6 weeks'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '10 weeks', min: '10 weeks', rec: '10 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('DTaP-IPV/Hib', '120', beginAge: '6 weeks'),
            ]),
        _dose('Dose 3',
            age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('DTP-HepB-Hib', '198', beginAge: '6 weeks'),
              _av('DTaP-IPV/Hib', '120', beginAge: '6 weeks'),
            ]),
        _dose('Dose 4',
            age: _a(absMin: '12 months', min: '12 months', rec: '12 months',
                latestRec: '23 months'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '6 months')],
            prefVax: [
              _v('DTP', '01', beginAge: '12 months', forecast: 'Y'),
              _v('DTaP', '20', beginAge: '12 months'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('Tdap', '115', beginAge: '6 weeks'),
            ]),
        _dose('Dose 5',
            age: _a(absMin: '4 years', min: '4 years', rec: '4 years',
                latestRec: '7 years'),
            intervals: [_int(absMin: '6 months', min: '6 months', rec: '3 years')],
            prefVax: [
              _v('DTP', '01', beginAge: '4 years', forecast: 'Y'),
              _v('DTaP', '20', beginAge: '4 years'),
            ],
            allowVax: [
              _av('DTP', '01', beginAge: '6 weeks'),
              _av('DTaP', '20', beginAge: '6 weeks'),
              _av('Tdap', '115', beginAge: '4 years'),
            ]),
      ]),
]);

// ======================== Hib ========================
// WHO: 3 primary doses at 6/10/14 weeks (usually as pentavalent)
final _whoHib = _ag('Hib', 'Hib', series: [
  _series('WHO Hib 3-dose series', 'Hib', 'Hib',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 weeks', min: '6 weeks', rec: '6 weeks',
                max: '5 years'),
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', endAge: '5 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('Hib (PRP-T)', '48', beginAge: '6 weeks', endAge: '5 years'),
              _av('Hib (HbOC)', '47', beginAge: '6 weeks', endAge: '5 years'),
              _av('Hib, unspecified', '17',
                  beginAge: '6 weeks', endAge: '5 years'),
              _av('DTP-HepB-Hib', '198',
                  beginAge: '6 weeks', endAge: '5 years'),
              _av('Hep B-Hib', '51',
                  beginAge: '6 weeks', endAge: '5 years'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '10 weeks', min: '10 weeks', rec: '10 weeks',
                max: '5 years'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', endAge: '5 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('Hib (PRP-T)', '48', beginAge: '6 weeks', endAge: '5 years'),
              _av('Hib (HbOC)', '47', beginAge: '6 weeks', endAge: '5 years'),
              _av('Hib, unspecified', '17',
                  beginAge: '6 weeks', endAge: '5 years'),
              _av('DTP-HepB-Hib', '198',
                  beginAge: '6 weeks', endAge: '5 years'),
            ]),
        _dose('Dose 3',
            age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks',
                max: '5 years'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('DTP-HepB-Hib (Pentavalent)', '198',
                  beginAge: '6 weeks', endAge: '5 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('Hib (PRP-T)', '48', beginAge: '6 weeks', endAge: '5 years'),
              _av('Hib (HbOC)', '47', beginAge: '6 weeks', endAge: '5 years'),
              _av('Hib, unspecified', '17',
                  beginAge: '6 weeks', endAge: '5 years'),
              _av('DTP-HepB-Hib', '198',
                  beginAge: '6 weeks', endAge: '5 years'),
            ]),
      ]),
]);

// ======================== Polio ========================
// WHO: bOPV birth dose + 3 bOPV primary (6w/10w/14w) + 2 IPV (14w, 9m)
// Modeled as 4-dose series: birth(bOPV), 6w(IPV), 10w(bOPV), 14w(IPV)
final _whoPolio = _ag('Polio', 'Polio', series: [
  _series('WHO Polio 5-dose series', 'Polio', 'Polio',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '0 days', min: '0 days', rec: '0 days'),
            prefVax: [
              _v('OPV, bivalent', '178', beginAge: '0 days', forecast: 'Y'),
            ],
            allowVax: [
              _av('OPV, bivalent', '178', beginAge: '0 days'),
              _av('OPV, trivalent', '02', beginAge: '0 days'),
              _av('IPV', '10', beginAge: '0 days'),
              _av('Polio, unspecified', '89', beginAge: '0 days'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '6 weeks', min: '6 weeks', rec: '6 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '6 weeks')],
            prefVax: [
              _v('IPV', '10', beginAge: '6 weeks', forecast: 'Y'),
              _v('OPV, bivalent', '178', beginAge: '6 weeks'),
            ],
            allowVax: [
              _av('IPV', '10', beginAge: '6 weeks'),
              _av('OPV, bivalent', '178', beginAge: '0 days'),
              _av('OPV, trivalent', '02', beginAge: '0 days'),
              _av('DTaP-IPV', '130', beginAge: '6 weeks'),
              _av('DTaP-IPV/Hib', '120', beginAge: '6 weeks'),
            ]),
        _dose('Dose 3',
            age: _a(absMin: '10 weeks', min: '10 weeks', rec: '10 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('OPV, bivalent', '178', beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('OPV, bivalent', '178', beginAge: '0 days'),
              _av('OPV, trivalent', '02', beginAge: '0 days'),
              _av('IPV', '10', beginAge: '6 weeks'),
            ]),
        _dose('Dose 4',
            age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('IPV', '10', beginAge: '14 weeks', forecast: 'Y'),
              _v('OPV, bivalent', '178', beginAge: '6 weeks'),
            ],
            allowVax: [
              _av('IPV', '10', beginAge: '6 weeks'),
              _av('OPV, bivalent', '178', beginAge: '0 days'),
              _av('OPV, trivalent', '02', beginAge: '0 days'),
              _av('DTaP-IPV', '130', beginAge: '6 weeks'),
            ]),
        _dose('Dose 5',
            age: _a(absMin: '9 months', min: '9 months', rec: '9 months'),
            intervals: [_int(absMin: '4 months', min: '4 months', rec: '4 months')],
            prefVax: [
              _v('IPV', '10', beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('IPV', '10', beginAge: '6 weeks'),
              _av('OPV, bivalent', '178', beginAge: '0 days'),
            ]),
      ]),
]);

// ======================== Measles ========================
// WHO: 2 doses. MCV1 at 9 months, MCV2 at 15-18 months
final _whoMeasles = _ag('Measles', 'MR',
    immunity: {
      'clinicalHistory': [
        {
          'guidelineCode': '1071',
          'guidelineTitle': 'Laboratory evidence of immunity for Measles'
        }
      ]
    },
    series: [
      _series('WHO Measles 2-dose series', 'Measles', 'MR',
          select: _sel(),
          doses: [
            _dose('Dose 1',
                age: _a(
                    absMin: '6 months',
                    min: '9 months',
                    rec: '9 months',
                    latestRec: '12 months'),
                prefVax: [
                  _v('Measles/Rubella (MR)', '04',
                      beginAge: '9 months', forecast: 'Y'),
                  _v('MMR', '03', beginAge: '9 months'),
                ],
                allowVax: [
                  _av('Measles/Rubella (MR)', '04', beginAge: '6 months'),
                  _av('MMR', '03', beginAge: '6 months'),
                  _av('Measles', '05', beginAge: '6 months'),
                  _av('MMRV', '94', beginAge: '12 months'),
                ]),
            _dose('Dose 2',
                age: _a(
                    absMin: '15 months',
                    min: '15 months',
                    rec: '15 months',
                    latestRec: '18 months'),
                intervals: [
                  _int(absMin: '4 weeks', min: '4 weeks', rec: '6 months')
                ],
                prefVax: [
                  _v('Measles/Rubella (MR)', '04',
                      beginAge: '9 months', forecast: 'Y'),
                  _v('MMR', '03', beginAge: '9 months'),
                ],
                allowVax: [
                  _av('Measles/Rubella (MR)', '04', beginAge: '6 months'),
                  _av('MMR', '03', beginAge: '6 months'),
                  _av('Measles', '05', beginAge: '6 months'),
                  _av('MMRV', '94', beginAge: '12 months'),
                ]),
          ]),
    ]);

// ======================== Rubella ========================
// WHO: 1-2 doses combined with measles as MR
final _whoRubella = _ag('Rubella', 'MR', series: [
  _series('WHO Rubella 2-dose series', 'Rubella', 'MR',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(
                absMin: '6 months',
                min: '9 months',
                rec: '9 months',
                latestRec: '12 months'),
            prefVax: [
              _v('Measles/Rubella (MR)', '04',
                  beginAge: '9 months', forecast: 'Y'),
              _v('MMR', '03', beginAge: '9 months'),
            ],
            allowVax: [
              _av('Measles/Rubella (MR)', '04', beginAge: '6 months'),
              _av('MMR', '03', beginAge: '6 months'),
              _av('Rubella', '06', beginAge: '6 months'),
              _av('MMRV', '94', beginAge: '12 months'),
            ]),
        _dose('Dose 2',
            age: _a(
                absMin: '15 months',
                min: '15 months',
                rec: '15 months',
                latestRec: '18 months'),
            intervals: [
              _int(absMin: '4 weeks', min: '4 weeks', rec: '6 months')
            ],
            prefVax: [
              _v('Measles/Rubella (MR)', '04',
                  beginAge: '9 months', forecast: 'Y'),
              _v('MMR', '03', beginAge: '9 months'),
            ],
            allowVax: [
              _av('Measles/Rubella (MR)', '04', beginAge: '6 months'),
              _av('MMR', '03', beginAge: '6 months'),
              _av('Rubella', '06', beginAge: '6 months'),
              _av('MMRV', '94', beginAge: '12 months'),
            ]),
      ]),
]);

// ======================== PCV (Pneumococcal) ========================
// WHO: 2+1 schedule: 6w, 14w, booster at 9-18m
final _whoPcv = _ag('Pneumococcal', 'PCV', series: [
  _series('WHO Pneumococcal 2+1 series', 'Pneumococcal', 'PCV',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 weeks', min: '6 weeks', rec: '6 weeks'),
            prefVax: [
              _v('PCV13', '133', beginAge: '6 weeks', forecast: 'Y'),
              _v('PCV15', '152', beginAge: '6 weeks'),
            ],
            allowVax: [
              _av('PCV13', '133', beginAge: '6 weeks'),
              _av('PCV15', '152', beginAge: '6 weeks'),
              _av('PCV20', '215', beginAge: '6 weeks'),
              _av('Pneumococcal conjugate, unspecified', '152',
                  beginAge: '6 weeks'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '8 weeks', rec: '8 weeks')],
            prefVax: [
              _v('PCV13', '133', beginAge: '6 weeks', forecast: 'Y'),
              _v('PCV15', '152', beginAge: '6 weeks'),
            ],
            allowVax: [
              _av('PCV13', '133', beginAge: '6 weeks'),
              _av('PCV15', '152', beginAge: '6 weeks'),
              _av('PCV20', '215', beginAge: '6 weeks'),
            ]),
        _dose('Dose 3',
            age: _a(
                absMin: '9 months',
                min: '9 months',
                rec: '9 months',
                latestRec: '18 months'),
            intervals: [_int(absMin: '4 weeks', min: '4 months', rec: '4 months')],
            prefVax: [
              _v('PCV13', '133', beginAge: '6 weeks', forecast: 'Y'),
              _v('PCV15', '152', beginAge: '6 weeks'),
            ],
            allowVax: [
              _av('PCV13', '133', beginAge: '6 weeks'),
              _av('PCV15', '152', beginAge: '6 weeks'),
              _av('PCV20', '215', beginAge: '6 weeks'),
            ]),
      ]),
  // 3+0 alternative
  _series('WHO Pneumococcal 3+0 series', 'Pneumococcal', 'PCV',
      select: _sel(
          def: 'No', groupName: 'Standard', group: '2',
          preference: '2'),
      eqGroups: '1',
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 weeks', min: '6 weeks', rec: '6 weeks'),
            prefVax: [
              _v('PCV13', '133', beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('PCV13', '133', beginAge: '6 weeks'),
              _av('PCV15', '152', beginAge: '6 weeks'),
              _av('PCV20', '215', beginAge: '6 weeks'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '10 weeks', min: '10 weeks', rec: '10 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('PCV13', '133', beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('PCV13', '133', beginAge: '6 weeks'),
              _av('PCV15', '152', beginAge: '6 weeks'),
              _av('PCV20', '215', beginAge: '6 weeks'),
            ]),
        _dose('Dose 3',
            age: _a(absMin: '14 weeks', min: '14 weeks', rec: '14 weeks'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('PCV13', '133', beginAge: '6 weeks', forecast: 'Y'),
            ],
            allowVax: [
              _av('PCV13', '133', beginAge: '6 weeks'),
              _av('PCV15', '152', beginAge: '6 weeks'),
              _av('PCV20', '215', beginAge: '6 weeks'),
            ]),
      ]),
]);

// ======================== Rotavirus ========================
// WHO: 2 doses (Rotarix/RV1) or 3 doses (RotaTeq/RV5)
final _whoRotavirus = _ag('Rotavirus', 'Rotavirus', series: [
  _series('WHO Rotavirus 2-dose series (RV1)', 'Rotavirus', 'Rotavirus',
      select: _sel(prod: 'Yes'),
      doses: [
        _dose('Dose 1',
            age: _a(
                absMin: '6 weeks',
                min: '6 weeks',
                rec: '6 weeks',
                max: '15 weeks'),
            prefVax: [
              _v('Rotavirus, monovalent (RV1)', '116',
                  beginAge: '6 weeks', endAge: '8 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Rotavirus, monovalent (RV1)', '116',
                  beginAge: '6 weeks', endAge: '8 months'),
              _av('Rotavirus, unspecified', '122',
                  beginAge: '6 weeks', endAge: '8 months'),
            ]),
        _dose('Dose 2',
            age: _a(
                absMin: '10 weeks',
                min: '10 weeks',
                rec: '10 weeks',
                max: '8 months'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('Rotavirus, monovalent (RV1)', '116',
                  beginAge: '6 weeks', endAge: '8 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Rotavirus, monovalent (RV1)', '116',
                  beginAge: '6 weeks', endAge: '8 months'),
              _av('Rotavirus, unspecified', '122',
                  beginAge: '6 weeks', endAge: '8 months'),
            ]),
      ]),
  _series('WHO Rotavirus 3-dose series (RV5)', 'Rotavirus', 'Rotavirus',
      select: _sel(
          def: 'No', prod: 'Yes', group: '2', preference: '2'),
      eqGroups: '1',
      doses: [
        _dose('Dose 1',
            age: _a(
                absMin: '6 weeks',
                min: '6 weeks',
                rec: '6 weeks',
                max: '15 weeks'),
            prefVax: [
              _v('Rotavirus, pentavalent (RV5)', '119',
                  beginAge: '6 weeks', endAge: '8 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Rotavirus, pentavalent (RV5)', '119',
                  beginAge: '6 weeks', endAge: '8 months'),
              _av('Rotavirus, unspecified', '122',
                  beginAge: '6 weeks', endAge: '8 months'),
            ]),
        _dose('Dose 2',
            age: _a(
                absMin: '10 weeks',
                min: '10 weeks',
                rec: '10 weeks',
                max: '8 months'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('Rotavirus, pentavalent (RV5)', '119',
                  beginAge: '6 weeks', endAge: '8 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Rotavirus, pentavalent (RV5)', '119',
                  beginAge: '6 weeks', endAge: '8 months'),
              _av('Rotavirus, unspecified', '122',
                  beginAge: '6 weeks', endAge: '8 months'),
            ]),
        _dose('Dose 3',
            age: _a(
                absMin: '14 weeks',
                min: '14 weeks',
                rec: '14 weeks',
                max: '8 months'),
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('Rotavirus, pentavalent (RV5)', '119',
                  beginAge: '6 weeks', endAge: '8 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Rotavirus, pentavalent (RV5)', '119',
                  beginAge: '6 weeks', endAge: '8 months'),
              _av('Rotavirus, unspecified', '122',
                  beginAge: '6 weeks', endAge: '8 months'),
            ]),
      ]),
]);

// ======================== HPV ========================
// WHO 2022: 1 dose for girls 9-14; 2 doses if >=15 at first dose
final _whoHpv = _ag('HPV', 'HPV', series: [
  _series('WHO HPV 1-dose series', 'HPV', 'HPV',
      select: _sel(minAge: '9 years', maxAge: '15 years'),
      gender: ['Female'],
      doses: [
        _dose('Dose 1',
            age: _a(
                absMin: '9 years',
                min: '9 years',
                rec: '9 years',
                latestRec: '14 years',
                max: '15 years'),
            prefVax: [
              _v('HPV, 9-valent', '165',
                  beginAge: '9 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('HPV, 9-valent', '165', beginAge: '9 years'),
              _av('HPV, quadrivalent', '62', beginAge: '9 years'),
              _av('HPV, bivalent', '118', beginAge: '9 years'),
            ]),
      ]),
  _series('WHO HPV 2-dose series (>=15y)', 'HPV', 'HPV',
      type: 'Standard',
      select: _sel(
          def: 'No', groupName: 'Standard', group: '2',
          preference: '2', minAge: '15 years'),
      eqGroups: '1',
      gender: ['Female'],
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '9 years', min: '15 years', rec: '15 years'),
            prefVax: [
              _v('HPV, 9-valent', '165',
                  beginAge: '9 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('HPV, 9-valent', '165', beginAge: '9 years'),
              _av('HPV, quadrivalent', '62', beginAge: '9 years'),
              _av('HPV, bivalent', '118', beginAge: '9 years'),
            ]),
        _dose('Dose 2',
            age: _a(absMin: '15 years + 5 months'),
            intervals: [_int(absMin: '5 months', min: '6 months', rec: '6 months')],
            prefVax: [
              _v('HPV, 9-valent', '165',
                  beginAge: '9 years', forecast: 'Y'),
            ],
            allowVax: [
              _av('HPV, 9-valent', '165', beginAge: '9 years'),
              _av('HPV, quadrivalent', '62', beginAge: '9 years'),
              _av('HPV, bivalent', '118', beginAge: '9 years'),
            ]),
      ]),
]);

// ======================== HepA ========================
// WHO: 2 doses in endemic/high-risk areas; dose 1 at 12m, dose 2 at 18-24m
final _whoHepA = _ag('HepA', 'HepA', series: [
  _series('WHO HepA 2-dose series', 'HepA', 'HepA',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '12 months', min: '12 months', rec: '12 months'),
            prefVax: [
              _v('HepA, pediatric/adolescent', '83',
                  beginAge: '12 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('HepA, pediatric/adolescent', '83',
                  beginAge: '12 months'),
              _av('HepA, adult', '52', beginAge: '19 years'),
              _av('HepA-HepB (Twinrix)', '104', beginAge: '18 years'),
            ]),
        _dose('Dose 2',
            age: _a(
                absMin: '18 months',
                min: '18 months',
                rec: '18 months',
                latestRec: '24 months'),
            intervals: [
              _int(absMin: '6 months', min: '6 months', rec: '6 months')
            ],
            prefVax: [
              _v('HepA, pediatric/adolescent', '83',
                  beginAge: '12 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('HepA, pediatric/adolescent', '83',
                  beginAge: '12 months'),
              _av('HepA, adult', '52', beginAge: '19 years'),
              _av('HepA-HepB (Twinrix)', '104', beginAge: '18 years'),
            ]),
      ]),
]);

// ======================== Yellow Fever ========================
// WHO: 1 dose at 9 months; lifelong protection
final _whoYellowFever = _ag('Yellow Fever', 'Yellow Fever', series: [
  _series('WHO Yellow Fever 1-dose series', 'Yellow Fever', 'Yellow Fever',
      type: 'Risk',
      select: _sel(def: 'No', groupName: 'Increased Risk', group: '1'),
      indications: [_ind('1012', 'Lives in or traveling to YF endemic area')],
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 months', min: '9 months', rec: '9 months'),
            prefVax: [
              _v('Yellow Fever', '37',
                  beginAge: '9 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Yellow Fever', '37', beginAge: '6 months'),
            ]),
      ]),
]);

// ======================== Japanese Encephalitis ========================
// WHO: Live attenuated 1 dose; or inactivated 2 doses
final _whoJe = _ag('Japanese Encephalitis', 'JE', series: [
  _series(
      'WHO JE 2-dose series (inactivated)', 'Japanese Encephalitis', 'JE',
      type: 'Risk',
      select: _sel(def: 'No', groupName: 'Increased Risk', group: '1'),
      indications: [_ind('1011', 'Lives in or traveling to JE endemic area')],
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '2 months', min: '2 months', rec: '8 months'),
            prefVax: [
              _v('JE, inactivated (Ixiaro)', '134',
                  beginAge: '2 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('JE, inactivated (Ixiaro)', '134', beginAge: '2 months'),
              _av('JE, unspecified', '39', beginAge: '2 months'),
            ]),
        _dose('Dose 2',
            intervals: [_int(absMin: '7 days', min: '28 days', rec: '28 days')],
            prefVax: [
              _v('JE, inactivated (Ixiaro)', '134',
                  beginAge: '2 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('JE, inactivated (Ixiaro)', '134', beginAge: '2 months'),
              _av('JE, unspecified', '39', beginAge: '2 months'),
            ]),
      ]),
]);

// ======================== Meningococcal ========================
// WHO: MenA conjugate 1 dose (meningitis belt); MenACWY for travelers
final _whoMeningococcal = _ag('Meningococcal', 'Meningococcal', series: [
  _series('WHO MenA conjugate 1-dose series', 'Meningococcal',
      'Meningococcal',
      type: 'Risk',
      select: _sel(def: 'No', groupName: 'Increased Risk', group: '1'),
      indications: [_ind('1010', 'Lives in meningitis belt')],
      doses: [
        _dose('Dose 1',
            age: _a(
                absMin: '9 months',
                min: '9 months',
                rec: '9 months',
                latestRec: '18 months'),
            prefVax: [
              _v('MenA conjugate (MenAfriVac)', '163',
                  beginAge: '9 months', forecast: 'Y'),
              _v('Meningococcal ACWY', '108', beginAge: '9 months'),
            ],
            allowVax: [
              _av('MenA conjugate (MenAfriVac)', '163',
                  beginAge: '9 months'),
              _av('Meningococcal ACWY', '108', beginAge: '9 months'),
              _av('Meningococcal ACWY (Menactra)', '114',
                  beginAge: '9 months'),
              _av('Meningococcal ACWY (Menveo)', '136',
                  beginAge: '2 months'),
            ]),
      ]),
]);

// ======================== Typhoid ========================
// WHO: TCV 1 dose from 6 months
final _whoTyphoid = _ag('Typhoid', 'Typhoid', series: [
  _series('WHO Typhoid conjugate 1-dose series', 'Typhoid', 'Typhoid',
      type: 'Risk',
      select: _sel(def: 'No', groupName: 'Increased Risk', group: '1'),
      indications: [_ind('1014', 'Lives in typhoid endemic area')],
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 months', min: '6 months', rec: '9 months'),
            prefVax: [
              _v('Typhoid conjugate (TCV)', '190',
                  beginAge: '6 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Typhoid conjugate (TCV)', '190', beginAge: '6 months'),
              _av('Typhoid Vi polysaccharide', '101', beginAge: '2 years'),
              _av('Typhoid oral (Ty21a)', '25', beginAge: '6 years'),
            ]),
      ]),
]);

// ======================== Cholera ========================
// WHO: 2 oral doses, 2 weeks apart; risk-based
final _whoCholera = _ag('Cholera', 'Cholera', series: [
  _series('WHO Cholera oral 2-dose series', 'Cholera', 'Cholera',
      type: 'Risk',
      select: _sel(def: 'No', groupName: 'Increased Risk', group: '1'),
      indications: [
        _ind('1013', 'Lives in or traveling to cholera endemic/outbreak area')
      ],
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '1 year', min: '1 year', rec: '1 year'),
            prefVax: [
              _v('Cholera, oral (BivWC)', '26',
                  beginAge: '1 year', forecast: 'Y'),
            ],
            allowVax: [
              _av('Cholera, oral (BivWC)', '26', beginAge: '1 year'),
            ]),
        _dose('Dose 2',
            intervals: [
              _int(absMin: '2 weeks', min: '2 weeks', rec: '2 weeks',
                  latestRec: '6 weeks')
            ],
            prefVax: [
              _v('Cholera, oral (BivWC)', '26',
                  beginAge: '1 year', forecast: 'Y'),
            ],
            allowVax: [
              _av('Cholera, oral (BivWC)', '26', beginAge: '1 year'),
            ]),
      ]),
]);

// ======================== Rabies ========================
// WHO 2018: Pre-exposure 2 doses at days 0, 7
final _whoRabies = _ag('Rabies', 'Rabies', series: [
  _series('WHO Rabies pre-exposure 2-dose series', 'Rabies', 'Rabies',
      type: 'Risk',
      select: _sel(def: 'No', groupName: 'Increased Risk', group: '1'),
      indications: [_ind('1015', 'High risk of rabies exposure')],
      doses: [
        _dose('Dose 1',
            prefVax: [
              _v('Rabies, IM', '18', forecast: 'Y'),
              _v('Rabies, ID', '40'),
            ],
            allowVax: [
              _av('Rabies, IM', '18'),
              _av('Rabies, ID', '40'),
              _av('Rabies, unspecified', '90'),
            ]),
        _dose('Dose 2',
            intervals: [_int(absMin: '7 days', min: '7 days', rec: '7 days')],
            prefVax: [
              _v('Rabies, IM', '18', forecast: 'Y'),
              _v('Rabies, ID', '40'),
            ],
            allowVax: [
              _av('Rabies, IM', '18'),
              _av('Rabies, ID', '40'),
              _av('Rabies, unspecified', '90'),
            ]),
      ]),
]);

// ======================== Mumps ========================
// WHO: 2 doses as MMR (where mumps vaccination is a priority)
final _whoMumps = _ag('Mumps', 'MMR', series: [
  _series('WHO Mumps 2-dose series', 'Mumps', 'MMR',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(
                absMin: '12 months',
                min: '12 months',
                rec: '12 months',
                latestRec: '15 months'),
            prefVax: [
              _v('MMR', '03', beginAge: '12 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('MMR', '03', beginAge: '12 months'),
              _av('Mumps', '07', beginAge: '12 months'),
              _av('MMRV', '94', beginAge: '12 months'),
            ]),
        _dose('Dose 2',
            age: _a(
                absMin: '15 months',
                min: '15 months',
                rec: '15 months',
                latestRec: '6 years'),
            intervals: [
              _int(absMin: '4 weeks', min: '4 weeks', rec: '3 months')
            ],
            prefVax: [
              _v('MMR', '03', beginAge: '12 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('MMR', '03', beginAge: '12 months'),
              _av('Mumps', '07', beginAge: '12 months'),
              _av('MMRV', '94', beginAge: '12 months'),
            ]),
      ]),
]);

// ======================== Influenza ========================
// WHO: Annual; 2 doses first year for children 6m-8y, then annual
final _whoInfluenza = _ag('Influenza', 'Influenza', series: [
  _series('WHO Influenza annual series', 'Influenza', 'Influenza',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 months', min: '6 months', rec: '6 months'),
            prefVax: [
              _v('Influenza, injectable, quadrivalent', '150',
                  beginAge: '6 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Influenza, injectable, quadrivalent', '150',
                  beginAge: '6 months'),
              _av('Influenza, injectable', '141', beginAge: '6 months'),
              _av('Influenza, live intranasal', '149', beginAge: '2 years'),
            ]),
        _dose('Dose 2',
            intervals: [_int(absMin: '4 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('Influenza, injectable, quadrivalent', '150',
                  beginAge: '6 months', forecast: 'Y'),
            ],
            allowVax: [
              _av('Influenza, injectable, quadrivalent', '150',
                  beginAge: '6 months'),
              _av('Influenza, injectable', '141', beginAge: '6 months'),
              _av('Influenza, live intranasal', '149', beginAge: '2 years'),
            ],
            recurring: 'Yes'),
      ]),
]);

// ======================== COVID-19 ========================
// WHO: Primary series per product; boosters for high-risk groups
final _whoCovid = _ag('COVID-19', 'COVID-19', series: [
  _series('WHO COVID-19 primary series', 'COVID-19', 'COVID-19',
      select: _sel(),
      doses: [
        _dose('Dose 1',
            age: _a(absMin: '6 months', min: '6 months', rec: '6 months'),
            prefVax: [
              _v('COVID-19, mRNA (Pfizer)', '208',
                  beginAge: '6 months', forecast: 'Y'),
              _v('COVID-19, mRNA (Moderna)', '207', beginAge: '6 months'),
            ],
            allowVax: [
              _av('COVID-19, mRNA (Pfizer)', '208', beginAge: '6 months'),
              _av('COVID-19, mRNA (Moderna)', '207', beginAge: '6 months'),
              _av('COVID-19, viral vector (J&J)', '212', beginAge: '18 years'),
              _av('COVID-19, protein subunit (Novavax)', '211',
                  beginAge: '12 years'),
            ]),
        _dose('Dose 2',
            intervals: [_int(absMin: '3 weeks', min: '4 weeks', rec: '4 weeks')],
            prefVax: [
              _v('COVID-19, mRNA (Pfizer)', '208',
                  beginAge: '6 months', forecast: 'Y'),
              _v('COVID-19, mRNA (Moderna)', '207', beginAge: '6 months'),
            ],
            allowVax: [
              _av('COVID-19, mRNA (Pfizer)', '208', beginAge: '6 months'),
              _av('COVID-19, mRNA (Moderna)', '207', beginAge: '6 months'),
              _av('COVID-19, protein subunit (Novavax)', '211',
                  beginAge: '12 years'),
            ]),
      ]),
]);

// =============================================================================
//  WHO Schedule Supporting Data
// =============================================================================

final whoScheduleData = <String, dynamic>{
  'observations': {
    'observation': [
      _obs('1010', 'Lives in meningitis belt',
          indication: 'Patient lives in the African meningitis belt',
          snomed: '161152002'),
      _obs('1011', 'Lives in JE endemic area',
          indication:
              'Patient lives in or is traveling to a Japanese Encephalitis endemic area',
          snomed: '161152002'),
      _obs('1012', 'Lives in or traveling to YF endemic area',
          indication:
              'Patient lives in or is traveling to a Yellow Fever endemic area',
          snomed: '161152002'),
      _obs('1013', 'Lives in cholera endemic/outbreak area',
          indication:
              'Patient lives in or is traveling to a cholera endemic or outbreak area',
          snomed: '161152002'),
      _obs('1014', 'Lives in typhoid endemic area',
          indication:
              'Patient lives in or is traveling to a typhoid endemic area',
          snomed: '161152002'),
      _obs('1015', 'High risk of rabies exposure',
          indication:
              'Patient has high risk of rabies exposure (occupational, animal contact, travel)',
          snomed: '170497006'),
      _obs('1070', 'Serologic evidence of HepB immunity',
          indication:
              'Serologic evidence of immunity (anti-HBs ≥10 mIU/mL)',
          snomed: '365861007'),
      _obs('1071', 'Laboratory evidence of Measles immunity',
          indication: 'Laboratory evidence of immunity for Measles',
          snomed: '365861007'),
    ],
  },
  'cvxToAntigenMap': {
    'cvxMap': [
      _cvx('19', 'BCG', [_assoc('Tuberculosis')]),
      _cvx('08', 'Hep B, adolescent or pediatric', [_assoc('HepB')]),
      _cvx('43', 'Hep B, adult', [_assoc('HepB')]),
      _cvx('45', 'Hep B, unspecified', [_assoc('HepB')]),
      _cvx('01', 'DTP',
          [_assoc('Diphtheria'), _assoc('Tetanus'), _assoc('Pertussis')]),
      _cvx('20', 'DTaP',
          [_assoc('Diphtheria'), _assoc('Tetanus'), _assoc('Pertussis')]),
      _cvx('198', 'DTP-HepB-Hib (Pentavalent)', [
        _assoc('Diphtheria'),
        _assoc('Tetanus'),
        _assoc('Pertussis'),
        _assoc('HepB'),
        _assoc('Hib'),
      ]),
      _cvx('51', 'Hep B-Hib', [_assoc('HepB'), _assoc('Hib')]),
      _cvx('120', 'DTaP-IPV/Hib', [
        _assoc('Diphtheria'),
        _assoc('Tetanus'),
        _assoc('Pertussis'),
        _assoc('Polio'),
        _assoc('Hib'),
      ]),
      _cvx('130', 'DTaP-IPV', [
        _assoc('Diphtheria'),
        _assoc('Tetanus'),
        _assoc('Pertussis'),
        _assoc('Polio'),
      ]),
      _cvx('09', 'Td adult', [_assoc('Diphtheria'), _assoc('Tetanus')]),
      _cvx('138', 'Td, unspecified', [_assoc('Diphtheria'), _assoc('Tetanus')]),
      _cvx('115', 'Tdap',
          [_assoc('Diphtheria'), _assoc('Tetanus'), _assoc('Pertussis')]),
      _cvx('35', 'TT', [_assoc('Tetanus')]),
      _cvx('17', 'Hib, unspecified', [_assoc('Hib')]),
      _cvx('47', 'Hib (HbOC)', [_assoc('Hib')]),
      _cvx('48', 'Hib (PRP-T)', [_assoc('Hib')]),
      _cvx('10', 'IPV', [_assoc('Polio')]),
      _cvx('02', 'OPV, trivalent', [_assoc('Polio')]),
      _cvx('178', 'OPV, bivalent', [_assoc('Polio')]),
      _cvx('89', 'Polio, unspecified', [_assoc('Polio')]),
      _cvx('03', 'MMR',
          [_assoc('Measles'), _assoc('Mumps'), _assoc('Rubella')]),
      _cvx('04', 'Measles/Rubella (MR)',
          [_assoc('Measles'), _assoc('Rubella')]),
      _cvx('05', 'Measles', [_assoc('Measles')]),
      _cvx('06', 'Rubella', [_assoc('Rubella')]),
      _cvx('07', 'Mumps', [_assoc('Mumps')]),
      _cvx('94', 'MMRV',
          [_assoc('Measles'), _assoc('Mumps'), _assoc('Rubella')]),
      _cvx('133', 'PCV13', [_assoc('Pneumococcal')]),
      _cvx('152', 'PCV15', [_assoc('Pneumococcal')]),
      _cvx('215', 'PCV20', [_assoc('Pneumococcal')]),
      _cvx('116', 'Rotavirus, monovalent (RV1)', [_assoc('Rotavirus')]),
      _cvx('119', 'Rotavirus, pentavalent (RV5)', [_assoc('Rotavirus')]),
      _cvx('122', 'Rotavirus, unspecified', [_assoc('Rotavirus')]),
      _cvx('165', 'HPV, 9-valent', [_assoc('HPV')]),
      _cvx('62', 'HPV, quadrivalent', [_assoc('HPV')]),
      _cvx('118', 'HPV, bivalent', [_assoc('HPV')]),
      _cvx('83', 'HepA, pediatric/adolescent', [_assoc('HepA')]),
      _cvx('52', 'HepA, adult', [_assoc('HepA')]),
      _cvx('104', 'HepA-HepB (Twinrix)', [_assoc('HepA'), _assoc('HepB')]),
      _cvx('37', 'Yellow Fever', [_assoc('Yellow Fever')]),
      _cvx('134', 'JE, inactivated (Ixiaro)', [_assoc('Japanese Encephalitis')]),
      _cvx('39', 'JE, unspecified', [_assoc('Japanese Encephalitis')]),
      _cvx('163', 'MenA conjugate (MenAfriVac)', [_assoc('Meningococcal')]),
      _cvx('108', 'Meningococcal ACWY', [_assoc('Meningococcal')]),
      _cvx('114', 'Meningococcal ACWY (Menactra)', [_assoc('Meningococcal')]),
      _cvx('136', 'Meningococcal ACWY (Menveo)', [_assoc('Meningococcal')]),
      _cvx('190', 'Typhoid conjugate (TCV)', [_assoc('Typhoid')]),
      _cvx('101', 'Typhoid Vi polysaccharide', [_assoc('Typhoid')]),
      _cvx('25', 'Typhoid oral (Ty21a)', [_assoc('Typhoid')]),
      _cvx('26', 'Cholera, oral (BivWC)', [_assoc('Cholera')]),
      _cvx('18', 'Rabies, IM', [_assoc('Rabies')]),
      _cvx('40', 'Rabies, ID', [_assoc('Rabies')]),
      _cvx('90', 'Rabies, unspecified', [_assoc('Rabies')]),
      _cvx('150', 'Influenza, injectable, quadrivalent',
          [_assoc('Influenza')]),
      _cvx('141', 'Influenza, injectable', [_assoc('Influenza')]),
      _cvx('149', 'Influenza, live intranasal', [_assoc('Influenza')]),
      _cvx('208', 'COVID-19, mRNA (Pfizer)', [_assoc('COVID-19')]),
      _cvx('207', 'COVID-19, mRNA (Moderna)', [_assoc('COVID-19')]),
      _cvx('212', 'COVID-19, viral vector (J&J)', [_assoc('COVID-19')]),
      _cvx('211', 'COVID-19, protein subunit (Novavax)',
          [_assoc('COVID-19')]),
    ],
  },
  'liveVirusConflicts': {
    'liveVirusConflict': [
      _lvc('178', 'OPV, bivalent', '178', 'OPV, bivalent',
          '1 day', '24 days', '28 days'),
      _lvc('178', 'OPV, bivalent', '04', 'Measles/Rubella (MR)',
          '1 day', '24 days', '28 days'),
      _lvc('04', 'Measles/Rubella (MR)', '178', 'OPV, bivalent',
          '1 day', '24 days', '28 days'),
      _lvc('04', 'Measles/Rubella (MR)', '04', 'Measles/Rubella (MR)',
          '1 day', '24 days', '28 days'),
      _lvc('04', 'Measles/Rubella (MR)', '03', 'MMR',
          '1 day', '24 days', '28 days'),
      _lvc('03', 'MMR', '04', 'Measles/Rubella (MR)',
          '1 day', '24 days', '28 days'),
      _lvc('03', 'MMR', '03', 'MMR', '1 day', '24 days', '28 days'),
      _lvc('37', 'Yellow Fever', '04', 'Measles/Rubella (MR)',
          '1 day', '24 days', '28 days'),
      _lvc('04', 'Measles/Rubella (MR)', '37', 'Yellow Fever',
          '1 day', '24 days', '28 days'),
      _lvc('37', 'Yellow Fever', '03', 'MMR',
          '1 day', '24 days', '28 days'),
      _lvc('03', 'MMR', '37', 'Yellow Fever',
          '1 day', '24 days', '28 days'),
      _lvc('116', 'Rotavirus, monovalent (RV1)', '178', 'OPV, bivalent',
          '1 day', '24 days', '28 days'),
      _lvc('178', 'OPV, bivalent', '116', 'Rotavirus, monovalent (RV1)',
          '1 day', '24 days', '28 days'),
      _lvc('19', 'BCG', '19', 'BCG', '1 day', '24 days', '28 days'),
    ],
  },
  'vaccineGroups': {
    'vaccineGroup': [
      _vg('BCG', 'No'),
      _vg('HepB', 'No'),
      _vg('DTP', 'Yes'),
      _vg('Hib', 'No'),
      _vg('Polio', 'No'),
      _vg('MR', 'Yes'),
      _vg('MMR', 'Yes'),
      _vg('PCV', 'No'),
      _vg('Rotavirus', 'No'),
      _vg('HPV', 'No'),
      _vg('HepA', 'No'),
      _vg('Yellow Fever', 'No'),
      _vg('JE', 'No'),
      _vg('Meningococcal', 'No'),
      _vg('Typhoid', 'No'),
      _vg('Cholera', 'No'),
      _vg('Rabies', 'No'),
      _vg('Influenza', 'No'),
      _vg('COVID-19', 'No'),
    ],
  },
  'vaccineGroupToAntigenMap': {
    'vaccineGroupMap': [
      _vgam('BCG', ['Tuberculosis']),
      _vgam('HepB', ['HepB']),
      _vgam('DTP', ['Diphtheria', 'Tetanus', 'Pertussis']),
      _vgam('Hib', ['Hib']),
      _vgam('Polio', ['Polio']),
      _vgam('MR', ['Measles', 'Rubella']),
      _vgam('MMR', ['Measles', 'Mumps', 'Rubella']),
      _vgam('PCV', ['Pneumococcal']),
      _vgam('Rotavirus', ['Rotavirus']),
      _vgam('HPV', ['HPV']),
      _vgam('HepA', ['HepA']),
      _vgam('Yellow Fever', ['Yellow Fever']),
      _vgam('JE', ['Japanese Encephalitis']),
      _vgam('Meningococcal', ['Meningococcal']),
      _vgam('Typhoid', ['Typhoid']),
      _vgam('Cholera', ['Cholera']),
      _vgam('Rabies', ['Rabies']),
      _vgam('Influenza', ['Influenza']),
      _vgam('COVID-19', ['COVID-19']),
    ],
  },
};

// Schedule helpers
Map<String, dynamic> _obs(String code, String title,
        {String? indication, String? contra, String? snomed}) =>
    {
      'observationCode': code,
      'observationTitle': title,
      if (indication != null) 'indicationText': indication,
      if (contra != null) 'contraindicationText': contra,
      if (snomed != null)
        'codedValues': {
          'codedValue': [
            {'code': snomed, 'codeSystem': 'SNOMED', 'text': title}
          ]
        },
    };

Map<String, dynamic> _cvx(
        String cvx, String desc, List<Map<String, dynamic>> assocs) =>
    {'cvx': cvx, 'shortDescription': desc, 'association': assocs};

Map<String, dynamic> _assoc(String antigen,
        {String? beginAge, String? endAge}) =>
    {
      'antigen': antigen,
      if (beginAge != null) 'associationBeginAge': beginAge,
      if (endAge != null) 'associationEndAge': endAge,
    };

Map<String, dynamic> _lvc(String prevCvx, String prevType, String curCvx,
        String curType, String begin, String minEnd, String end) =>
    {
      'previous': {'vaccineType': prevType, 'cvx': prevCvx},
      'current': {'vaccineType': curType, 'cvx': curCvx},
      'conflictBeginInterval': begin,
      'minConflictEndInterval': minEnd,
      'conflictEndInterval': end,
    };

Map<String, dynamic> _vg(String name, String adminFull) =>
    {'name': name, 'administerFullVaccineGroup': adminFull};

Map<String, dynamic> _vgam(String name, List<String> antigens) => {
      'name': name,
      'antigen': antigens,
    };
