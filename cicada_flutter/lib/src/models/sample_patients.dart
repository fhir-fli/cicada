import 'package:cicada_flutter/src/models/entered_dose.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';

/// A pre-loaded sample patient for the demo.
class SamplePatient {
  const SamplePatient({
    required this.name,
    required this.description,
    required this.info,
    required this.doses,
  });

  final String name;
  final String description;
  final PatientInfo info;
  final List<EnteredDose> doses;
}

/// Pre-built sample patients demonstrating different scenarios.
List<SamplePatient> getSamplePatients() {
  final now = DateTime.now();

  // 6-month-old infant — has had birth + 2mo + 4mo visits
  final infantBirth = DateTime(now.year, now.month - 6, now.day);
  final twoMonths = DateTime(infantBirth.year, infantBirth.month + 2, 15);
  final fourMonths = DateTime(infantBirth.year, infantBirth.month + 4, 15);

  // 5-year-old with partial series
  final childBirth = DateTime(now.year - 5, 3, 10);

  // 30-year-old adult
  final adultBirth = DateTime(now.year - 30, 7, 22);

  return [
    SamplePatient(
      name: 'Baby Jordan (6 months)',
      description:
          'Infant with birth, 2-month, and 4-month visits complete. '
          'Due for 6-month doses.',
      info: PatientInfo(birthDate: infantBirth, sex: PatientSex.male),
      doses: [
        // Birth visit
        EnteredDose(
          vaccineId: 'hepb',
          vaccineLabel: 'HepB',
          cvx: '08',
          dateGiven: DateTime(
            infantBirth.year,
            infantBirth.month,
            infantBirth.day + 1,
          ),
        ),
        // 2-month visit
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: twoMonths,
        ),
        EnteredDose(
          vaccineId: 'ipv',
          vaccineLabel: 'IPV',
          cvx: '10',
          dateGiven: twoMonths,
        ),
        EnteredDose(
          vaccineId: 'hib',
          vaccineLabel: 'Hib',
          cvx: '17',
          dateGiven: twoMonths,
        ),
        EnteredDose(
          vaccineId: 'pcv',
          vaccineLabel: 'PCV',
          cvx: '152',
          dateGiven: twoMonths,
        ),
        EnteredDose(
          vaccineId: 'rotavirus',
          vaccineLabel: 'Rotavirus',
          cvx: '122',
          dateGiven: twoMonths,
        ),
        EnteredDose(
          vaccineId: 'hepb',
          vaccineLabel: 'HepB',
          cvx: '08',
          dateGiven: twoMonths,
        ),
        // 4-month visit
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: fourMonths,
        ),
        EnteredDose(
          vaccineId: 'ipv',
          vaccineLabel: 'IPV',
          cvx: '10',
          dateGiven: fourMonths,
        ),
        EnteredDose(
          vaccineId: 'hib',
          vaccineLabel: 'Hib',
          cvx: '17',
          dateGiven: fourMonths,
        ),
        EnteredDose(
          vaccineId: 'pcv',
          vaccineLabel: 'PCV',
          cvx: '152',
          dateGiven: fourMonths,
        ),
        EnteredDose(
          vaccineId: 'rotavirus',
          vaccineLabel: 'Rotavirus',
          cvx: '122',
          dateGiven: fourMonths,
        ),
      ],
    ),
    SamplePatient(
      name: 'Mia Chen (5 years)',
      description:
          'Child with incomplete series — missed some doses. '
          'Needs catch-up vaccines.',
      info: PatientInfo(birthDate: childBirth, sex: PatientSex.female),
      doses: [
        // Only got birth HepB and some 2-month doses
        EnteredDose(
          vaccineId: 'hepb',
          vaccineLabel: 'HepB',
          cvx: '08',
          dateGiven: DateTime(
            childBirth.year,
            childBirth.month,
            childBirth.day + 1,
          ),
        ),
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: DateTime(childBirth.year, childBirth.month + 2, 15),
        ),
        EnteredDose(
          vaccineId: 'ipv',
          vaccineLabel: 'IPV',
          cvx: '10',
          dateGiven: DateTime(childBirth.year, childBirth.month + 2, 15),
        ),
        // Got MMR #1 at 12 months
        EnteredDose(
          vaccineId: 'mmr',
          vaccineLabel: 'MMR',
          cvx: '03',
          dateGiven: DateTime(childBirth.year + 1, childBirth.month, 15),
        ),
        // Got Varicella #1 at 12 months
        EnteredDose(
          vaccineId: 'varicella',
          vaccineLabel: 'Varicella',
          cvx: '21',
          dateGiven: DateTime(childBirth.year + 1, childBirth.month, 15),
        ),
      ],
    ),
    SamplePatient(
      name: 'Alex Rivera (30 years)',
      description:
          'Healthy adult — had childhood vaccines, needs routine '
          'boosters and annual vaccines.',
      info: PatientInfo(birthDate: adultBirth, sex: PatientSex.male),
      doses: [
        // Childhood series (approximate dates)
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: DateTime(adultBirth.year, adultBirth.month + 2, 15),
        ),
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: DateTime(adultBirth.year, adultBirth.month + 4, 15),
        ),
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: DateTime(adultBirth.year, adultBirth.month + 6, 15),
        ),
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: DateTime(adultBirth.year + 1, adultBirth.month + 3, 15),
        ),
        EnteredDose(
          vaccineId: 'dtap',
          vaccineLabel: 'DTaP',
          cvx: '20',
          dateGiven: DateTime(adultBirth.year + 4, 9),
        ),
        EnteredDose(
          vaccineId: 'ipv',
          vaccineLabel: 'IPV',
          cvx: '10',
          dateGiven: DateTime(adultBirth.year, adultBirth.month + 2, 15),
        ),
        EnteredDose(
          vaccineId: 'ipv',
          vaccineLabel: 'IPV',
          cvx: '10',
          dateGiven: DateTime(adultBirth.year, adultBirth.month + 4, 15),
        ),
        EnteredDose(
          vaccineId: 'ipv',
          vaccineLabel: 'IPV',
          cvx: '10',
          dateGiven: DateTime(adultBirth.year + 1, adultBirth.month + 3, 15),
        ),
        EnteredDose(
          vaccineId: 'ipv',
          vaccineLabel: 'IPV',
          cvx: '10',
          dateGiven: DateTime(adultBirth.year + 4, 9),
        ),
        EnteredDose(
          vaccineId: 'mmr',
          vaccineLabel: 'MMR',
          cvx: '03',
          dateGiven: DateTime(adultBirth.year + 1, adultBirth.month, 15),
        ),
        EnteredDose(
          vaccineId: 'mmr',
          vaccineLabel: 'MMR',
          cvx: '03',
          dateGiven: DateTime(adultBirth.year + 4, 9),
        ),
        EnteredDose(
          vaccineId: 'hepb',
          vaccineLabel: 'HepB',
          cvx: '08',
          dateGiven: DateTime(adultBirth.year, adultBirth.month, 23),
        ),
        EnteredDose(
          vaccineId: 'hepb',
          vaccineLabel: 'HepB',
          cvx: '08',
          dateGiven: DateTime(adultBirth.year, adultBirth.month + 1, 22),
        ),
        EnteredDose(
          vaccineId: 'hepb',
          vaccineLabel: 'HepB',
          cvx: '08',
          dateGiven: DateTime(adultBirth.year, adultBirth.month + 6, 22),
        ),
        EnteredDose(
          vaccineId: 'varicella',
          vaccineLabel: 'Varicella',
          cvx: '21',
          dateGiven: DateTime(adultBirth.year + 1, adultBirth.month, 15),
        ),
        EnteredDose(
          vaccineId: 'varicella',
          vaccineLabel: 'Varicella',
          cvx: '21',
          dateGiven: DateTime(adultBirth.year + 4, 9),
        ),
        // Tdap booster at age 22
        EnteredDose(
          vaccineId: 'tdap',
          vaccineLabel: 'Tdap',
          cvx: '115',
          dateGiven: DateTime(adultBirth.year + 22, 3, 15),
        ),
      ],
    ),
  ];
}
