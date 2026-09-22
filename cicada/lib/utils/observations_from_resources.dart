import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';

/// The system URIs a CDSi observation code may arrive under: the IG's own
/// CodeSystem canonical, and the CDC page URL the condition test cases used
/// before the IG existed. Both name the same codes.
const _cdsiSystemUris = <String>{
  'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes',
  'https://www.cdc.gov/vaccines/programs/iis/cdsi.html',
};

/// SNOMED CT, the one system in the crosswalk that is a hierarchy.
const _snomedSystemUri = 'http://snomed.info/sct';

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
  List<Condition> conditions,
  VaxDate birthdate,
) {
  final observations = <VaxObservation>[];
  for (final condition in conditions) {
    final obs = _matchCodingsToObservation(
      condition.code?.coding,
    );
    if (obs != null) {
      observations.add(
        obs.copyWith(period: periodOfCondition(condition, birthdate)),
      );
    }
  }
  return observations;
}

/// Extracts CDSi observations from a list of FHIR AllergyIntolerance resources.
///
/// Checks both [AllergyIntolerance.code] and each
/// [AllergyIntolerance.reaction.substance] for matching coded values.
List<VaxObservation> observationsFromAllergies(
  List<AllergyIntolerance> allergies,
) {
  final observations = <VaxObservation>[];
  final seen = <String>{};
  for (final allergy in allergies) {
    // Check AllergyIntolerance.code
    final obs = _matchCodingsToObservation(
      allergy.code?.coding,
    );
    if (obs != null && seen.add(obs.observationCode ?? '')) {
      observations.add(obs);
    }
    // Check each reaction.substance
    if (allergy.reaction != null) {
      for (final reaction in allergy.reaction!) {
        final reactionObs = _matchCodingsToObservation(
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
  final allObservations = activeScheduleData.observations?.observation;
  if (allObservations == null || allObservations.isEmpty) return null;

  // Check for direct CDSi observation code (bypasses crosswalk)
  for (final coding in codings) {
    final systemUri = coding.system?.toString();
    final code = coding.code?.toString();
    if (_cdsiSystemUris.contains(systemUri) && code != null) {
      for (var i = 0; i < allObservations.length; i++) {
        if (allObservations[i].observationCode == code) {
          return allObservations[i];
        }
      }
    }
  }

  for (final coding in codings) {
    final systemUri = coding.system?.toString();
    final code = coding.code?.toString();
    if (systemUri == null || code == null) continue;

    final cdsiSystem = _fhirSystemToCdsi[systemUri];
    if (cdsiSystem == null) continue;

    for (var i = 0; i < allObservations.length; i++) {
      final codedValues = allObservations[i].codedValues?.codedValue;
      if (codedValues == null) continue;
      for (final cv in codedValues) {
        if (cv.codeSystem == cdsiSystem && cv.code == code) {
          return allObservations[i];
        }
      }
    }
  }

  // Nothing matched exactly. SNOMED is a hierarchy and clinicians record
  // specific concepts, so try the listed concepts this code falls under.
  //
  // Without this a patient recorded as, say, sickle cell disease does not match
  // CDSi's `Disorder of hematopoietic structure`, the observation is silently
  // absent, and the forecast reads as though they carried no risk condition.
  // Measured 2026-09-03: 7,975 concepts sit under the 132 listed SNOMED codes
  // that have descendants.
  //
  // Only SNOMED. The other systems the crosswalk carries are enumerations, not
  // hierarchies, and ICD-10-CM's dotted codes are not a subsumption axis.
  for (final coding in codings) {
    if (coding.system?.toString() != _snomedSystemUri) continue;
    final code = coding.code?.toString();
    if (code == null) continue;
    for (final ancestor in snomedClosure[code] ?? const <String>[]) {
      for (var i = 0; i < allObservations.length; i++) {
        final codedValues = allObservations[i].codedValues?.codedValue;
        if (codedValues == null) continue;
        for (final cv in codedValues) {
          if (cv.codeSystem == 'SNOMED' && cv.code == ancestor) {
            return allObservations[i];
          }
        }
      }
    }
  }
  return null;
}
