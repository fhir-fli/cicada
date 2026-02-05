import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

class VaxPatient {
  VaxPatient({
    required this.assessmentDate,
    required this.birthdate,
    required this.patient,
    required this.gender,
    required this.immunizations,
    required this.conditions,
    required this.observations,
    required this.allergies,
    required this.pastDoses,
  });

  VaxPatient copyWith({
    VaxDate? assessmentDate,
    VaxDate? birthdate,
    Patient? patient,
    Gender? gender,
    List<Condition>? conditions,
    List<Immunization>? immunizations,
    VaxObservations? observations,
    List<AllergyIntolerance>? allergies,
    List<VaxDose>? pastDoses,
  }) =>
      VaxPatient(
        assessmentDate: assessmentDate ?? this.assessmentDate,
        birthdate: birthdate ?? this.birthdate,
        patient: patient ?? this.patient,
        gender: gender ?? this.gender,
        immunizations: immunizations ?? this.immunizations,
        conditions: conditions ?? this.conditions,
        observations: observations ?? this.observations,
        allergies: allergies ?? this.allergies,
        pastDoses: pastDoses ?? this.pastDoses,
      );

  final VaxDate assessmentDate;
  final VaxDate birthdate;
  final Patient patient;
  final Gender gender;
  final List<Immunization> immunizations;
  final List<Condition> conditions;
  final VaxObservations observations;
  final List<AllergyIntolerance> allergies;
  final List<VaxDose> pastDoses;
}
