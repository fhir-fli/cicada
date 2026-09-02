import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

/// A resource that asserted a CDSi observation, as a FHIR Reference can carry
/// it: a literal reference when the resource had an id, a display otherwise.
typedef SupportingResource = ({String? reference, String? display});

/// Why a dose could not be evaluated as a record of an administration.
///
/// Not clinical verdicts. CDSi evaluates a *vaccine dose administered*, and
/// defines the assessment date as the current date, so a dose dated after it
/// has not been administered and a dose dated before birth was not
/// administered to this patient. Neither is a statement about immunity, so
/// neither belongs in an evaluation's doseStatus.
enum ImplausibleDoseReason {
  /// Administered before the patient's date of birth.
  beforeBirth,

  /// Administered after the assessment date, which CDSi defines as the current
  /// date, so the administration has not happened.
  afterAssessment,
}

/// A dose left out of evaluation and forecasting because its date is
/// impossible, kept so the response can say so rather than dropping it.
typedef ImplausibleDose = ({VaxDose dose, ImplausibleDoseReason reason});

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
    this.implausibleDoses = const <ImplausibleDose>[],
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
    List<ImplausibleDose>? implausibleDoses,
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
        implausibleDoses: implausibleDoses ?? this.implausibleDoses,
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

  /// Doses excluded from evaluation because their dates are impossible.
  final List<ImplausibleDose> implausibleDoses;
}
