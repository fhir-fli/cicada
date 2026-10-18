import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';

/// The system URIs a CDSi observation code may arrive under: the IG's own
/// CodeSystem canonical, and the CDC page URL the condition test cases used
/// before the IG existed. Both name the same codes.
const _cdsiSystemUris = <String>{
  'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes',
  'https://www.cdc.gov/vaccines/programs/iis/cdsi.html',
};

/// SNOMED CT, the one system in the map that is a hierarchy.
const _snomedSystemUri = 'http://snomed.info/sct';

/// Incoming system URIs that name a system the map keys under another URI.
/// CDC's PHIN VS codes arrive under either; the map uses the OID.
const Map<String, String> _systemAliases = {
  'http://www.cdc.gov/vaccines/acip': 'urn:oid:2.16.840.1.114222.4.5.274',
};

/// The CDSi coded-value system names WHO's schedule data uses, as FHIR URIs.
const Map<String, String> _cdsiSystemToFhir = {
  'SNOMED': 'http://snomed.info/sct',
  'CVX': 'http://hl7.org/fhir/sid/cvx',
  'CDCPHINVS': 'urn:oid:2.16.840.1.114222.4.5.274',
  'ICD10CM': 'http://hl7.org/fhir/sid/icd-10-cm',
  'LOINC': 'http://loinc.org',
  'RXNORM': 'http://www.nlm.nih.gov/research/umls/rxnorm',
  'CPT': 'http://www.ama-assn.org/go/cpt',
};

/// WHO mode has its own observation numbers (1010-1071) and no ConceptMap,
/// so its schedule data's own coded values are read as 'equivalent' rows,
/// which is how they were matched before the map existed.
final Map<String, Map<String, List<ObservationMapTarget>>> _whoMap = () {
  final map = <String, Map<String, List<ObservationMapTarget>>>{};
  for (final obs
      in whoScheduleSupportingData.observations?.observation ??
          const <VaxObservation>[]) {
    final obsCode = obs.observationCode;
    if (obsCode == null) continue;
    for (final cv in obs.codedValues?.codedValue ?? const <CodedValue>[]) {
      final system = _cdsiSystemToFhir[cv.codeSystem];
      final code = cv.code;
      if (system == null || code == null) continue;
      ((map[system] ??= {})[code] ??= []).add(
        ObservationMapTarget(obsCode, 'equivalent'),
      );
    }
  }
  return map;
}();

Map<String, Map<String, List<ObservationMapTarget>>> get _activeMap =>
    currentForecastMode == ForecastMode.who ? _whoMap : observationConceptMap;

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
///
/// [results] are the (system, code) results the resource carries, for map
/// rows that hold only with a result: a laboratory antibody test is evidence
/// of immunity only when it is positive. See [resultsOfObservation].
List<VaxObservation> observationsFromCodeableConcept(
  CodeableConcept? code, {
  Set<(String, String)> results = const <(String, String)>{},
}) {
  return _matchCodingsToObservations(code?.coding, results: results);
}

/// The (system, code) results an [Observation] carries for map rows that
/// depend on one: its interpretation codings and its valueCodeableConcept
/// codings.
///
/// Only a final, amended or corrected Observation has a result to count.
/// Quoted from R4B CodeSystem-observation-status.json, read 2026-10-18:
/// preliminary is "an initial or interim observation: data may be incomplete
/// or unverified"; registered has "no result yet available". Cancelled and
/// entered-in-error are not results.
Set<(String, String)> resultsOfObservation(Observation observation) {
  const reportable = <String>{'final', 'amended', 'corrected'};
  if (!reportable.contains(observation.status.toString())) {
    return const <(String, String)>{};
  }
  return <(String, String)>{
    for (final concept in [
      ...?observation.interpretation,
      if (observation.valueX is CodeableConcept)
        observation.valueX! as CodeableConcept,
    ])
      for (final coding in concept.coding ?? const <Coding>[])
        if (coding.system != null && coding.code != null)
          (coding.system.toString(), coding.code.toString()),
  };
}

/// Core matching: every CDSi observation the map asserts for one of
/// [codings], each returned once, in supporting-data order.
///
/// Every observation, not the first: the patient history holds a SET of
/// patient observations (logic spec 4.6 Table A-2, DEFPATIENT-008), and one
/// code can stand for several (SNOMED 13645005 COPD is both 017 chronic lung
/// disease and 214 COPD). Stopping at the first match kept only the
/// lowest-numbered one: measured 2026-10-18 with
/// tool/probe_crosswalk_keying.dart, ICD-10 B20 reached only 026.
///
/// A map row asserts only when its grade does (ObservationMapTarget.asserts)
/// and, for rows that depend on a result, when [results] holds one of them.
///
/// Three passes, each used only when the one before asserted nothing:
/// 1. a direct CDSi observation code (the IG's CodeSystem or CDC's page URL);
/// 2. the map's row for the exact (system, code);
/// 3. the map's rows for the SNOMED concepts this code falls under.
List<VaxObservation> _matchCodingsToObservations(
  List<Coding>? codings, {
  Set<(String, String)> results = const <(String, String)>{},
}) {
  if (codings == null || codings.isEmpty) return const <VaxObservation>[];
  final allObservations = activeScheduleData.observations?.observation;
  if (allObservations == null || allObservations.isEmpty) {
    return const <VaxObservation>[];
  }

  // The observations whose codes are in [codes], in supporting-data order.
  List<VaxObservation> inOrder(Set<String> codes) => [
    for (final obs in allObservations)
      if (codes.contains(obs.observationCode)) obs,
  ];

  // The observation codes the map asserts for (system, code).
  Iterable<String> asserted(String system, String code) =>
      (_activeMap[system]?[code] ?? const <ObservationMapTarget>[])
          .where((t) => t.assertsWith(results))
          .map((t) => t.observationCode);

  // Pass 1: a direct CDSi observation code bypasses the map.
  final direct = <String>{
    for (final coding in codings)
      if (_cdsiSystemUris.contains(coding.system?.toString()) &&
          coding.code != null)
        coding.code.toString(),
  };
  if (direct.isNotEmpty) {
    final found = inOrder(direct);
    if (found.isNotEmpty) return found;
  }

  // Pass 2: the exact (system, code).
  final exact = <String>{
    for (final coding in codings)
      if (coding.system != null && coding.code != null)
        ...asserted(
          _systemAliases[coding.system.toString()] ?? coding.system.toString(),
          coding.code.toString(),
        ),
  };
  if (exact.isNotEmpty) return inOrder(exact);

  // Pass 3: nothing asserted exactly. SNOMED is a hierarchy and clinicians
  // record specific concepts, so try the listed concepts this code falls under.
  //
  // Without this a patient recorded as, say, sickle cell disease does not match
  // CDSi's `Disorder of hematopoietic structure`, the observation is silently
  // absent, and the forecast reads as though they carried no risk condition.
  // Measured 2026-09-03: 7,975 concepts sit under the 132 listed SNOMED codes
  // that have descendants.
  //
  // Only SNOMED. The other systems the map carries are enumerations, not
  // hierarchies, and ICD-10-CM's dotted codes are not a subsumption axis.
  final viaAncestors = <String>{
    for (final coding in codings)
      if (coding.system?.toString() == _snomedSystemUri && coding.code != null)
        for (final ancestor
            in snomedClosure[coding.code.toString()] ?? const <String>[])
          ...asserted(_snomedSystemUri, ancestor),
  };
  return inOrder(viaAncestors);
}
