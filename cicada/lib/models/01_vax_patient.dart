import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

/// A resource that asserted a CDSi observation, as a FHIR Reference can carry
/// it: a literal reference when the resource had an id, a display otherwise.
typedef SupportingResource = ({String? reference, String? display});

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
    this.observationSources = const <String, Set<SupportingResource>>{},
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
    Map<String, Set<SupportingResource>>? observationSources,
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
        observationSources: observationSources ?? this.observationSources,
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

  /// CDSi observation code to the resources that asserted it. Each entry is a
  /// literal reference (`Condition/123`) when the resource carried an id, and
  /// otherwise just a display string naming it — a FHIR Reference is allowed to
  /// carry `display` alone, and a request whose resources have no ids can still
  /// say which condition drove a risk series.
  final Map<String, Set<SupportingResource>> observationSources;
}
