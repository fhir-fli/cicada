import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cicada.dart';

part 'patient_for_assessment.g.dart';

@riverpod
class PatientForAssessment extends _$PatientForAssessment {
  @override
  VaxPatient build(Parameters parameters) {
    final VaxPatient? patient = patientFromParameters(parameters);
    if (patient == null) {
      throw Exception('Patient or birthdate not found');
    }
    return patient;
  }

  VaxPatient? patientFromParameters(Parameters parameters) {
    DateTime? assessmentDate;
    Patient? patient;
    VaxDate? birthdate;
    final List<Immunization> immunizations = <Immunization>[];
    final List<Condition> conditions = <Condition>[];
    final List<AllergyIntolerance> allergies = <AllergyIntolerance>[];
    final List<VaxDose> pastDoses = <VaxDose>[];
    // The code alone is not enough: `supportingPatientInformation` has to
    // reference the resource that carried it, so keep the reference with it.
    final List<({CodeableConcept code, String? reference})> otherResourceCodes =
        <({CodeableConcept code, String? reference})>[];

    parameters.parameter?.forEach((ParametersParameter parameter) {
      if (parameter.name == 'assessmentDate' &&
          (parameter.valueDate?.valueDateTime != null)) {
        assessmentDate = parameter.valueDate!.valueDateTime;
      } else if (parameter.resource != null) {
        switch (parameter.resource) {
          case Patient _:
            {
              patient = parameter.resource as Patient?;
              birthdate = (patient?.birthDate?.valueDateTime != null)
                  ? VaxDate.fromDateTime(patient!.birthDate!.valueDateTime!)
                  : null;
              break;
            }
          case Condition _:
            {
              conditions.add(parameter.resource! as Condition);
              break;
            }
          case AllergyIntolerance _:
            {
              allergies.add(parameter.resource! as AllergyIntolerance);
              break;
            }
          case Immunization _:
            {
              final Immunization immunization =
                  parameter.resource! as Immunization;
              immunizations.add(immunization);
              pastDoses.add(VaxDose.fromImmunization(
                  immunization, birthdate ?? VaxDate(1900, 1, 1)));
              break;
            }
          case Observation _:
            {
              final observation = parameter.resource! as Observation;
              otherResourceCodes.add((
                code: observation.code,
                reference: observation.id == null
                    ? null
                    : 'Observation/${observation.id}',
              ));
              break;
            }
          case Procedure _:
            {
              final resource = parameter.resource! as Procedure;
              final code = resource.code;
              if (code != null) {
                otherResourceCodes.add((
                  code: code,
                  reference:
                      resource.id == null ? null : 'Procedure/${resource.id}',
                ));
              }
              break;
            }
          case MedicationStatement _:
            {
              final resource = parameter.resource! as MedicationStatement;
              final code = resource.medicationCodeableConcept;
              if (code != null) {
                otherResourceCodes.add((
                  code: code,
                  reference: resource.id == null
                      ? null
                      : 'MedicationStatement/${resource.id}',
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
                  reference: resource.id == null
                      ? null
                      : 'MedicationRequest/${resource.id}',
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
                  reference: resource.id == null
                      ? null
                      : 'MedicationAdministration/${resource.id}',
                ));
              }
              break;
            }
          default:
            break;
        }
      }
    });

    // Fallback: test data encodes assessment date as the parameter name itself
    if (assessmentDate == null) {
      for (final parameter in parameters.parameter ?? []) {
        if (parameter.resource == null && parameter.name != null) {
          final parsed = DateTime.tryParse(parameter.name.toString());
          if (parsed != null) {
            assessmentDate = parsed;
            break;
          }
        }
      }
    }

    if (patient == null) {
      ref
          .read(operationOutcomesProvider.notifier)
          .addError('No Patient was found in the parameters');
      return null;
    } else {
      return _createVaxPatient(patient!, assessmentDate, birthdate, conditions,
          immunizations, allergies, pastDoses, otherResourceCodes);
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
      List<({CodeableConcept code, String? reference})> otherResourceCodes) {
    final bd = birthdate ?? VaxDate(1900, 01, 01);
    final List<VaxObservation> observations =
        observationsFromConditions(conditions, bd);
    // Add observations from AllergyIntolerance resources
    observations.addAll(observationsFromAllergies(allergies));
    // Add observations from Observation, Procedure, Medication* resources
    for (final pair in otherResourceCodes) {
      final obs = observationFromCodeableConcept(pair.code);
      if (obs != null) observations.add(obs);
    }

    // Which resource asserted each CDSi observation, so a risk-driven
    // recommendation can point at it via supportingPatientInformation.
    // A resource with no id cannot be referenced and is left out.
    final Map<String, Set<SupportingResource>> observationSources =
        <String, Set<SupportingResource>>{};
    void index(VaxObservation? obs, String? reference, CodeableConcept? code) {
      final String? observationCode = obs?.observationCode;
      if (observationCode == null) return;
      final String? display = _displayOf(code);
      if (reference == null && display == null) return;
      (observationSources[observationCode] ??= <SupportingResource>{})
          .add((reference: reference, display: display));
    }

    for (final Condition condition in conditions) {
      index(
        observationFromCodeableConcept(condition.code),
        condition.id == null ? null : 'Condition/${condition.id}',
        condition.code,
      );
    }
    for (final AllergyIntolerance allergy in allergies) {
      final String? ref =
          allergy.id == null ? null : 'AllergyIntolerance/${allergy.id}';
      index(observationFromCodeableConcept(allergy.code), ref, allergy.code);
      for (final reaction in allergy.reaction ?? []) {
        index(observationFromCodeableConcept(reaction.substance), ref,
            reaction.substance);
      }
    }
    for (final pair in otherResourceCodes) {
      index(
          observationFromCodeableConcept(pair.code), pair.reference, pair.code);
    }
    return VaxPatient(
      assessmentDate: assessmentDate == null
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
    );
  }
}

/// Human-readable name for a coded concept, for a Reference that has no target.
String? _displayOf(CodeableConcept? code) {
  final String? text = code?.text?.valueString;
  if (text != null && text.isNotEmpty) return text;
  for (final Coding coding in code?.coding ?? <Coding>[]) {
    final String? display = coding.display?.valueString;
    if (display != null && display.isNotEmpty) return display;
  }
  return null;
}
