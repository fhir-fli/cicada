/// One target of the chart-code to CDSi-observation ConceptMap
/// (cicada_generator/lib/crosswalk/ConceptMap-cdsi-observations.json).
///
/// [equivalence] is FHIR R4 ConceptMap equivalence, read from target to
/// source (R4B StructureDefinition-ConceptMap,
/// ConceptMap.group.element.target.equivalence): 'wider' means the CDSi
/// observation is wider than the chart code. Only 'equivalent', 'equal',
/// 'wider' and 'subsumes' assert the observation; 'narrower' and 'relatedto'
/// record a link that needs clinical judgement.
///
/// [resultAnyOf] carries the map's dependsOn. The ConceptMap lists one target
/// per qualifying result, which FHIR reads as alternatives, so the generator
/// folds them into one target that holds when the resource carries ANY of
/// these (system, code) results. Empty means the code alone is enough.
class ObservationMapTarget {
  /// A target with no result condition.
  const ObservationMapTarget(
    this.observationCode,
    this.equivalence, {
    this.resultAnyOf = const <(String, String)>{},
  });

  /// The CDSi observation code.
  final String observationCode;

  /// R4 ConceptMap equivalence, target to source.
  final String equivalence;

  /// (system, code) results, any one of which the resource must carry.
  final Set<(String, String)> resultAnyOf;

  /// Whether this target asserts the observation on its own grade.
  bool get asserts => const <String>{
    'equivalent',
    'equal',
    'wider',
    'subsumes',
  }.contains(equivalence);

  /// Whether this target asserts the observation for a resource carrying
  /// [results].
  bool assertsWith(Set<(String, String)> results) =>
      asserts && (resultAnyOf.isEmpty || resultAnyOf.any(results.contains));
}
