import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

/// CDSi observation code system URI used in condition test cases.
const _cdsiSystemUri = 'https://www.cdc.gov/vaccines/programs/iis/cdsi.html';

/// Maps FHIR coding system URIs to CDSi codeSystem identifiers.
const Map<String, String> _fhirSystemToCdsi = {
  'http://snomed.info/sct': 'SNOMED',
  'http://hl7.org/fhir/sid/cvx': 'CVX',
  'urn:oid:2.16.840.1.114222.4.5.274': 'CDCPHINVS',
  'http://www.cdc.gov/vaccines/acip': 'CDCPHINVS',
  'http://hl7.org/fhir/sid/icd-10-cm': 'ICD10CM',
  'http://loinc.org': 'LOINC',
  'http://www.nlm.nih.gov/research/umls/rxnorm': 'RXNORM',
  'http://www.ama-assn.org/go/cpt': 'CPT',
};

/// Extracts CDSi observations from a list of FHIR Conditions.
///
/// Iterates all codings on each Condition and matches against all codedValues
/// on each observation in the schedule supporting data.
List<VaxObservation> observationsFromConditions(
    List<Condition> conditions, VaxDate birthdate) {
  final List<VaxObservation> observations = <VaxObservation>[];
  for (final Condition condition in conditions) {
    final VaxObservation? obs = _matchCodingsToObservation(
      condition.code?.coding,
    );
    if (obs != null) {
      observations
          .add(obs.copyWith(period: periodOfCondition(condition, birthdate)));
    }
  }
  return observations;
}

/// Extracts CDSi observations from a list of FHIR AllergyIntolerance resources.
///
/// Checks both [AllergyIntolerance.code] and each
/// [AllergyIntolerance.reaction.substance] for matching coded values.
List<VaxObservation> observationsFromAllergies(
    List<AllergyIntolerance> allergies) {
  final List<VaxObservation> observations = <VaxObservation>[];
  final Set<String> seen = {};
  for (final AllergyIntolerance allergy in allergies) {
    // Check AllergyIntolerance.code
    final VaxObservation? obs = _matchCodingsToObservation(
      allergy.code?.coding,
    );
    if (obs != null && seen.add(obs.observationCode ?? '')) {
      observations.add(obs);
    }
    // Check each reaction.substance
    if (allergy.reaction != null) {
      for (final AllergyIntoleranceReaction reaction in allergy.reaction!) {
        final VaxObservation? reactionObs = _matchCodingsToObservation(
          reaction.substance?.coding,
        );
        if (reactionObs != null &&
            seen.add(reactionObs.observationCode ?? '')) {
          observations.add(reactionObs);
        }
      }
    }
  }
  return observations;
}

/// Extracts CDSi observations from a [CodeableConcept] (used for
/// Observation, Procedure, MedicationStatement, etc.).
VaxObservation? observationFromCodeableConcept(CodeableConcept? code) {
  return _matchCodingsToObservation(code?.coding);
}

/// Core matching: takes a list of FHIR [Coding]s and finds the first
/// matching CDSi observation from [scheduleSupportingData].
///
/// Iterates every coding on the resource, maps its system URI to a CDSi
/// codeSystem string, then checks all observations for a codedValue match.
VaxObservation? _matchCodingsToObservation(List<Coding>? codings) {
  if (codings == null || codings.isEmpty) return null;
  final allObservations =
      scheduleSupportingData.observations?.observation;
  if (allObservations == null || allObservations.isEmpty) return null;

  // Check for direct CDSi observation code (bypasses crosswalk)
  for (final Coding coding in codings) {
    final String? systemUri = coding.system?.toString();
    final String? code = coding.code?.toString();
    if (systemUri == _cdsiSystemUri && code != null) {
      for (int i = 0; i < allObservations.length; i++) {
        if (allObservations[i].observationCode == code) {
          return allObservations[i];
        }
      }
    }
  }

  for (final Coding coding in codings) {
    final String? systemUri = coding.system?.toString();
    final String? code = coding.code?.toString();
    if (systemUri == null || code == null) continue;

    final String? cdsiSystem = _fhirSystemToCdsi[systemUri];
    if (cdsiSystem == null) continue;

    for (int i = 0; i < allObservations.length; i++) {
      final codedValues = allObservations[i].codedValues?.codedValue;
      if (codedValues == null) continue;
      for (final CodedValue cv in codedValues) {
        if (cv.codeSystem == cdsiSystem && cv.code == code) {
          return allObservations[i];
        }
      }
    }
  }
  return null;
}
