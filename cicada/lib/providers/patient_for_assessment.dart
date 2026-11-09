import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patient_for_assessment.g.dart';

@riverpod
class PatientForAssessment extends _$PatientForAssessment {
  @override
  VaxPatient build(Parameters parameters) {
    final patient = patientFromParameters(parameters);
    if (patient == null) {
      throw Exception(
        'The parameters cannot be assessed: no Patient, a Patient with no '
        'birthDate, or a dose with no date administered or no id',
      );
    }
    return patient;
  }

  VaxPatient? patientFromParameters(Parameters parameters) {
    DateTime? assessmentDate;
    Patient? patient;
    VaxDate? birthdate;
    final immunizations = <Immunization>[];
    final conditions = <Condition>[];
    final allergies = <AllergyIntolerance>[];
    final pastDoses = <VaxDose>[];
    final implausibleDoses = <ImplausibleDose>[];
    final dosesAfterAssessment = <VaxDose>[];
    // The code alone is not enough: `supportingPatientInformation` has to
    // reference the resource that carried it, so keep the reference with it.
    final otherResourceCodes =
        <
          ({
            CodeableConcept code,
            String? reference,
            Period? period,
            Set<(String, String)> results,
          })
        >[];
    // Organizations sent with the request, so a manufacturer given as a
    // literal reference (`Organization/x`) can be resolved.
    final organizations = <String, Organization>{};

    parameters.parameter?.forEach((parameter) {
      if (parameter.name.valueString == 'assessmentDate' &&
          (parameter.valueDate?.valueDateTime != null)) {
        assessmentDate = parameter.valueDate!.valueDateTime;
      } else if (parameter.resource != null) {
        switch (parameter.resource) {
          case Patient _:
            {
              patient = parameter.resource as Patient?;
              birthdate =
                  (patient?.birthDate?.valueDateTime != null)
                      ? VaxDate.fromDateTime(patient!.birthDate!.valueDateTime!)
                      : null;
              break;
            }
          case Organization _:
            {
              final organization = parameter.resource! as Organization;
              final id = organization.id?.valueString;
              if (id != null) {
                organizations['Organization/$id'] = organization;
                organizations[id] = organization;
              }
              break;
            }
          case Condition _:
            {
              final condition = parameter.resource! as Condition;
              if (_isInvalidAssertion(condition.verificationStatus)) break;
              conditions.add(condition);
              break;
            }
          case AllergyIntolerance _:
            {
              final allergy = parameter.resource! as AllergyIntolerance;
              if (_isInvalidAssertion(allergy.verificationStatus)) break;
              allergies.add(allergy);
              break;
            }
          case Immunization _:
            {
              final immunization = parameter.resource! as Immunization;
              // Only a completed immunization is a dose administered.
              // Quoted from R4B StructureDefinition-Immunization.json, read
              // 2026-10-18: status is a modifier "because it is a status
              // element that contains statuses entered-in-error and not-done
              // which means that the resource should not be treated as
              // valid". Measured the same day: a not-done MMR counted as a
              // dose (test/invalid_status_test.dart).
              if (immunization.status.toString() != 'completed') break;
              immunizations.add(immunization);
              // Doses are built after the loop, not here. A dose needs the
              // birth date, and the Patient parameter is not guaranteed to
              // arrive before the Immunization ones; building inline dated
              // every earlier dose from 1900-01-01.
              break;
            }
          case Observation _:
            {
              final observation = parameter.resource! as Observation;
              final code = _observationConcept(observation);
              if (code != null) {
                otherResourceCodes.add((
                  code: code,
                  reference:
                      observation.id == null
                          ? null
                          : 'Observation/${observation.id}',
                  period: _periodOf(observation.effectiveX),
                  // A laboratory row counts only with a positive result.
                  results: resultsOfObservation(observation),
                ));
              }
              break;
            }
          case Procedure _:
            {
              final resource = parameter.resource! as Procedure;
              // Only a completed procedure has happened. R4B
              // CodeSystem-event-status.json, read 2026-10-18: preparation,
              // in-progress, on-hold, not-done and stopped have not concluded
              // ("stopped": terminated "prior to the full completion"), and
              // status is a modifier for entered-in-error
              // (StructureDefinition-Procedure.json).
              if (resource.status.toString() != 'completed') break;
              final code = resource.code;
              if (code != null) {
                otherResourceCodes.add((
                  code: code,
                  reference:
                      resource.id == null ? null : 'Procedure/${resource.id}',
                  period: _periodOf(resource.performedX),
                  results: const <(String, String)>{},
                ));
              }
              break;
            }
          case MedicationStatement _:
            {
              final resource = parameter.resource! as MedicationStatement;
              final code = resource.medicationCodeableConcept;
              if (code != null &&
                  !const {
                    'entered-in-error',
                    'not-taken',
                  }.contains(resource.status.toString())) {
                otherResourceCodes.add((
                  code: code,
                  reference:
                      resource.id == null
                          ? null
                          : 'MedicationStatement/${resource.id}',
                  period: _periodOf(resource.effectiveX),
                  results: const <(String, String)>{},
                ));
              }
              break;
            }
          case MedicationRequest _:
            {
              final resource = parameter.resource! as MedicationRequest;
              final code = resource.medicationCodeableConcept;
              if (code != null) {
                otherResourceCodes.add((
                  code: code,
                  reference:
                      resource.id == null
                          ? null
                          : 'MedicationRequest/${resource.id}',
                  period: null,
                  results: const <(String, String)>{},
                ));
              }
              break;
            }
          case MedicationAdministration _:
            {
              final resource = parameter.resource! as MedicationAdministration;
              final code = resource.medicationCodeableConcept;
              if (code != null) {
                otherResourceCodes.add((
                  code: code,
                  reference:
                      resource.id == null
                          ? null
                          : 'MedicationAdministration/${resource.id}',
                  period: _periodOf(resource.effectiveX),
                  results: const <(String, String)>{},
                ));
              }
              break;
            }
          default:
            break;
        }
      }
    });

    // Build the doses now that the birth date and assessment date are known.
    //
    // 🛑 DELIBERATE DEVIATION FROM CDSi, adjudicated by OpenEvidence
    // 2026-09-21 (CDSI-OE-ADJUDICATED.md section 17). A dose dated before
    // birth is withheld from evaluation and reported in an OperationOutcome.
    // The spec has no rule for it; its process alone would return Not Valid,
    // Too Young, whose remedy is to repeat a dose that was never given to this
    // patient on that date. No CDC case carries one (0 of 2,957 doses across
    // 1,401 cases, scanned 2026-09-21), so no conformance case depends on it.
    //
    // A dose dated after the assessment date IS evaluated. Evaluation anchors
    // on the date administered (Logic Spec v4.6 section 3.3, CONDSKIP-2); the
    // assessment date drives forecasting, and "current date" is only its
    // assumed value when empty (Tables 6-4, 7-9). CDC healthy cases 2026-0043,
    // -0050, -0052 and -0060 expect such doses Valid. It is noted, not dropped.
    // A dose the engine cannot evaluate is refused, not given a date.
    // CDSi Logic Spec v4.6 Table 3-4 and Table 6-2: Date Administered,
    // "Assumed Value if Empty" "-" (none); evaluation is anchored on it
    // (section 3.3). R4B allows Immunization.occurrence[x] to be a string,
    // and the engine used to put such a dose at 2999-01-01. A dose with no
    // id cannot be named: R4B ImmunizationEvaluation.immunizationEvent is
    // 1..1 and the response names each dose by id; the engine used to stop
    // on a null check (fhirant REVIEW-2026-10-17, phone run).
    for (final immunization in immunizations) {
      if (immunization.occurrenceDateTime?.valueDateTime == null) {
        ref
            .read(operationOutcomesProvider.notifier)
            .addError(
              'Immunization/${immunization.id} has no occurrenceDateTime; '
              'CDSi assumes no date administered',
            );
        return null;
      }
      if (immunization.id == null) {
        ref
            .read(operationOutcomesProvider.notifier)
            .addError(
              'An Immunization has no id; each evaluation names the dose '
              'it evaluates (ImmunizationEvaluation.immunizationEvent 1..1)',
            );
        return null;
      }
    }

    final effectiveDob = birthdate ?? VaxDate(1900, 1, 1);
    final effectiveAssessment =
        assessmentDate == null
            ? VaxDate.now()
            : VaxDate.fromDateTime(assessmentDate!);
    for (final immunization in immunizations) {
      final dose = VaxDose.fromImmunization(
        immunization,
        effectiveDob,
        organizations: organizations,
      );
      if (birthdate != null && dose.dateGiven < birthdate!) {
        implausibleDoses.add((
          dose: dose,
          reason: ImplausibleDoseReason.beforeBirth,
        ));
      } else {
        if (dose.dateGiven > effectiveAssessment) {
          dosesAfterAssessment.add(dose);
        }
        pastDoses.add(dose);
      }
    }

    if (patient == null) {
      ref
          .read(operationOutcomesProvider.notifier)
          .addError('No Patient was found in the parameters');
      return null;
    } else if (birthdate == null) {
      // CDSi Logic Spec v4.6 Tables 5-2, 6-14 and 7-2: Date of Birth,
      // "Assumed Value if Empty" "-" (none; Gender's is "Unknown"), and
      // CALCDTAGE-1..5 (Table 3-6) compute every age date from it. With no
      // date of birth there is nothing to evaluate or forecast from. The
      // engine used to substitute 1900-01-01, which no specification names,
      // and returned a full forecast (fhirant REVIEW-2026-10-17 finding 7).
      ref
          .read(operationOutcomesProvider.notifier)
          .addError(
            'The Patient has no birthDate; CDSi computes every age '
            'from the date of birth and assumes none',
          );
      return null;
    } else {
      return _createVaxPatient(
        patient!,
        assessmentDate,
        birthdate,
        conditions,
        immunizations,
        allergies,
        pastDoses,
        otherResourceCodes,
        implausibleDoses,
        dosesAfterAssessment,
      );
    }
  }

  VaxPatient _createVaxPatient(
    Patient patient,
    DateTime? assessmentDate,
    VaxDate? birthdate,
    List<Condition> conditions,
    List<Immunization> immunizations,
    List<AllergyIntolerance> allergies,
    List<VaxDose> pastDoses,
    List<
      ({
        CodeableConcept code,
        String? reference,
        Period? period,
        Set<(String, String)> results,
      })
    >
    otherResourceCodes,
    List<ImplausibleDose> implausibleDoses,
    List<VaxDose> dosesAfterAssessment,
  ) {
    final bd = birthdate ?? VaxDate(1900, 01, 01);
    // Observations from Condition resources, then AllergyIntolerance.
    final observations = observationsFromConditions(conditions, bd)
      ..addAll(observationsFromAllergies(allergies));
    // Add observations from Observation, Procedure, Medication* resources
    for (final pair in otherResourceCodes) {
      for (final obs in observationsFromCodeableConcept(
        pair.code,
        results: pair.results,
      )) {
        observations.add(
          pair.period == null ? obs : obs.copyWith(period: pair.period),
        );
      }
    }

    // Which resource asserted each CDSi observation, so a risk-driven
    // recommendation can point at it via supportingPatientInformation.
    // A resource with no id cannot be referenced and is left out.
    final observationSources = <String, Set<SupportingResource>>{};
    void index(
      String? reference,
      CodeableConcept? code, {
      Set<(String, String)> results = const <(String, String)>{},
    }) {
      final display = _displayOf(code);
      if (reference == null && display == null) return;
      for (final obs in observationsFromCodeableConcept(
        code,
        results: results,
      )) {
        final observationCode = obs.observationCode;
        if (observationCode == null) continue;
        (observationSources[observationCode] ??= <SupportingResource>{}).add((
          reference: reference,
          display: display,
        ));
      }
    }

    for (final condition in conditions) {
      index(
        condition.id == null ? null : 'Condition/${condition.id}',
        condition.code,
      );
    }
    for (final allergy in allergies) {
      final ref =
          allergy.id == null ? null : 'AllergyIntolerance/${allergy.id}';
      index(ref, allergy.code);
      for (final reaction
          in allergy.reaction ?? const <AllergyIntoleranceReaction>[]) {
        index(ref, reaction.substance);
      }
    }
    for (final pair in otherResourceCodes) {
      index(pair.reference, pair.code, results: pair.results);
    }
    return VaxPatient(
      assessmentDate:
          assessmentDate == null
              ? VaxDate.now()
              : VaxDate.fromDateTime(assessmentDate),
      birthdate: birthdate ?? VaxDate(1900, 01, 01),
      patient: patient,
      gender: genderFromPatient(patient),
      conditions: conditions,
      immunizations: immunizations,
      observations: VaxObservations(observation: observations),
      allergies: allergies,
      pastDoses: pastDoses,
      observationSources: observationSources,
      implausibleDoses: implausibleDoses,
      dosesAfterAssessment: dosesAfterAssessment,
    );
  }
}

/// Human-readable name for a coded concept, for a Reference that has no target.
String? _displayOf(CodeableConcept? code) {
  final text = code?.text?.valueString;
  if (text != null && text.isNotEmpty) return text;
  for (final coding in code?.coding ?? <Coding>[]) {
    final display = coding.display?.valueString;
    if (display != null && display.isNotEmpty) return display;
  }
  return null;
}

/// Whether a Condition or AllergyIntolerance verificationStatus marks the
/// record as not valid.
///
/// Quoted from R4B StructureDefinition-Condition.json, read 2026-10-18:
/// verificationStatus is a modifier "because the status contains the code
/// refuted and entered-in-error that mark the Condition as not currently
/// valid". AllergyIntolerance's verification codes include the same two
/// (CodeSystem-allergyintolerance-verification.json). Measured the same day:
/// a refuted asplenia still asserted 160 (test/invalid_status_test.dart).
///
/// Unconfirmed, provisional and differential are not excluded here: the
/// base specification does not mark them invalid.
bool _isInvalidAssertion(CodeableConcept? verificationStatus) =>
    (verificationStatus?.coding ?? const <Coding>[]).any(
      (c) =>
          c.code?.toString() == 'refuted' ||
          c.code?.toString() == 'entered-in-error',
    );

/// The concept an Observation asserts, as the published guides send it
/// (TEST-RESOURCE-REVIEW.md):
/// - a social-history Observation (occupation LOINC 11341-5, smoking status
///   72166-2, pregnancy status 82810-3) asserts its coded value;
/// - an Observation whose code the observation map asserts on asserts its
///   code. A laboratory row asserts only with a positive result
///   (ObservationMapTarget.resultAnyOf: interpretation POS/DET/RR, or value
///   SNOMED 10828004 and its kin), which [resultsOfObservation] supplies;
/// - any other Observation asserts its coded value, then its code.
/// Cancelled and entered-in-error Observations assert nothing.
CodeableConcept? _observationConcept(Observation observation) {
  if (const {
    'cancelled',
    'entered-in-error',
  }.contains(observation.status.toString())) {
    return null;
  }
  final value =
      observation.valueX is CodeableConcept
          ? observation.valueX! as CodeableConcept
          : null;
  final codes = observation.code.coding ?? const <Coding>[];
  final isLoinc = codes.any((c) => c.system?.toString() == 'http://loinc.org');
  const valueBearing = {'11341-5', '72166-2', '82810-3'};
  if (isLoinc && codes.any((c) => valueBearing.contains(c.code?.toString()))) {
    return value;
  }
  if (observationsFromCodeableConcept(
    observation.code,
    results: resultsOfObservation(observation),
  ).isNotEmpty) {
    return observation.code;
  }
  return value ?? observation.code;
}

/// The dates a resource's `effective[x]` or `performed[x]` carries, as the
/// observation's period: a dateTime or instant starts it, a Period gives
/// both ends. CDSi date observations (120 "Begin Date of antiviral therapy",
/// 171 "Date of hematopoietic stem cell transplant") are read from here when
/// they arrive on an Observation, Procedure or medication record rather
/// than as a Condition's onset.
Period? _periodOf(dynamic value) => switch (value) {
  FhirDateTime d => Period(start: d),
  FhirInstant i => Period(start: FhirDateTime.tryParse(i.valueString)),
  Period p => p,
  _ => null,
};
