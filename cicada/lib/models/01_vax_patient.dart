import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

/// A resource that asserted a CDSi observation, as a FHIR Reference can carry
/// it: a literal reference when the resource had an id, a display otherwise.
typedef SupportingResource = ({String? reference, String? display});

/// Why a dose could not be evaluated as a record of an administration.
///
/// Not a clinical verdict. A dose dated before birth was not administered to
/// this patient, so it is not a statement about immunity and does not belong
/// in an evaluation's doseStatus. 🛑 DELIBERATE DEVIATION FROM CDSi, which has
/// no rule for it; see the note where these are built in
/// `patient_for_assessment.dart`.
///
/// A dose dated after the assessment date is NOT one of these: evaluation
/// anchors on the date administered (Logic Spec v4.6 section 3.3, CONDSKIP-2),
/// and "current date" is only the assessment date's assumed value when empty
/// (Tables 6-4, 7-9). Such a dose is evaluated; see
/// [VaxPatient.dosesAfterAssessment].
enum ImplausibleDoseReason {
  /// Administered before the patient's date of birth.
  beforeBirth,
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
    this.dosesAfterAssessment = const <VaxDose>[],
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
    List<VaxDose>? dosesAfterAssessment,
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
        dosesAfterAssessment: dosesAfterAssessment ?? this.dosesAfterAssessment,
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

  /// Doses dated after the assessment date. They are in [pastDoses] and are
  /// evaluated like any other; this list only lets the response note the
  /// date, since a forecast "as of" a date before a recorded dose is unusual.
  final List<VaxDose> dosesAfterAssessment;
}
