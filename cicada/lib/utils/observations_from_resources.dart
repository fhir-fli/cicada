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
/// Every observation a Condition's code is filed under is returned, each
/// carrying the Condition's period. See [observationsFromCodeableConcept].
List<VaxObservation> observationsFromConditions(
  List<Condition> conditions,
  VaxDate birthdate,
) {
  final observations = <VaxObservation>[];
  for (final condition in conditions) {
    final period = periodOfCondition(condition, birthdate);
    for (final obs in _matchCodingsToObservations(condition.code?.coding)) {
      observations.add(obs.copyWith(period: period));
    }
  }
  return observations;
}

/// Extracts CDSi observations from a list of FHIR AllergyIntolerance resources.
///
/// Checks both [AllergyIntolerance.code] and each
/// [AllergyIntolerance.reaction.substance] for matching coded values. Each
/// observation is returned once, however many allergies assert it.
List<VaxObservation> observationsFromAllergies(
  List<AllergyIntolerance> allergies,
) {
  final observations = <VaxObservation>[];
  final seen = <String>{};
  void addAll(List<Coding>? codings) {
    for (final obs in _matchCodingsToObservations(codings)) {
      if (seen.add(obs.observationCode ?? '')) observations.add(obs);
    }
  }

  for (final allergy in allergies) {
    addAll(allergy.code?.coding);
    for (final reaction
        in allergy.reaction ?? const <AllergyIntoleranceReaction>[]) {
      addAll(reaction.substance?.coding);
    }
  }
  return observations;
}

/// Extracts CDSi observations from a [CodeableConcept] (used for
/// Observation, Procedure, MedicationStatement, etc.).
List<VaxObservation> observationsFromCodeableConcept(CodeableConcept? code) {
  return _matchCodingsToObservations(code?.coding);
}

/// Core matching: every CDSi observation in [activeScheduleData] that one of
/// [codings] is filed under, each returned once, in supporting-data order.
///
/// Why every one and not the first: the spec's patient history holds a SET of
/// patient observations (Table A-2, DEFPATIENT-008), and CDC's Coded
/// Observations supporting data files one code under several observations
/// (46 of its 369 codes in 4.65-508; SNOMED 86406008 HIV infection is under
/// both 026 and 186). Stopping at the first match kept only the
/// lowest-numbered one: an ICD-10 B20 HIV patient became 026 "perinatal HIV
/// vaccinated with MMR before ART" and never 186 "HIV Infection". Measured
/// 2026-10-18 with tool/probe_crosswalk_keying.dart.
///
/// Three passes, each used only when the one before found nothing:
/// 1. a direct CDSi observation code (the IG's CodeSystem or CDC's page URL);
/// 2. an exact code in any system the supporting data carries;
/// 3. a SNOMED ancestor of the code.
List<VaxObservation> _matchCodingsToObservations(List<Coding>? codings) {
  if (codings == null || codings.isEmpty) return const <VaxObservation>[];
  final allObservations = activeScheduleData.observations?.observation;
  if (allObservations == null || allObservations.isEmpty) {
    return const <VaxObservation>[];
  }

  // Collects, in supporting-data order, the observations whose coded values
  // satisfy [matches].
  List<VaxObservation> where(bool Function(VaxObservation obs) matches) => [
    for (final obs in allObservations)
      if (matches(obs)) obs,
  ];

  // Pass 1: a direct CDSi observation code bypasses the crosswalk.
  final direct = <String>{
    for (final coding in codings)
      if (_cdsiSystemUris.contains(coding.system?.toString()) &&
          coding.code != null)
        coding.code.toString(),
  };
  if (direct.isNotEmpty) {
    final found = where((obs) => direct.contains(obs.observationCode));
    if (found.isNotEmpty) return found;
  }

  // Pass 2: exact (system, code) pairs.
  final exact = <(String, String)>{
    for (final coding in codings)
      if (_fhirSystemToCdsi[coding.system?.toString()] != null &&
          coding.code != null)
        (_fhirSystemToCdsi[coding.system.toString()]!, coding.code.toString()),
  };
  if (exact.isNotEmpty) {
    final found = where(
      (obs) => (obs.codedValues?.codedValue ?? const []).any(
        (cv) => exact.contains((cv.codeSystem ?? '', cv.code ?? '')),
      ),
    );
    if (found.isNotEmpty) return found;
  }

  // Pass 3: nothing matched exactly. SNOMED is a hierarchy and clinicians
  // record specific concepts, so try the listed concepts this code falls under.
  //
  // Without this a patient recorded as, say, sickle cell disease does not match
  // CDSi's `Disorder of hematopoietic structure`, the observation is silently
  // absent, and the forecast reads as though they carried no risk condition.
  // Measured 2026-09-03: 7,975 concepts sit under the 132 listed SNOMED codes
  // that have descendants.
  //
  // Only SNOMED. The other systems the crosswalk carries are enumerations, not
  // hierarchies, and ICD-10-CM's dotted codes are not a subsumption axis.
  final ancestors = <String>{
    for (final coding in codings)
      if (coding.system?.toString() == _snomedSystemUri && coding.code != null)
        ...snomedClosure[coding.code.toString()] ?? const <String>[],
  };
  if (ancestors.isEmpty) return const <VaxObservation>[];
  return where(
    (obs) => (obs.codedValues?.codedValue ?? const []).any(
      (cv) => cv.codeSystem == 'SNOMED' && ancestors.contains(cv.code),
    ),
  );
}
