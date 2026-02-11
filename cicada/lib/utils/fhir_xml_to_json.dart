import 'package:xml/xml.dart';

/// Converts a FHIR R4 XML string to a FHIR JSON [Map].
///
/// Implements the FHIR XML-to-JSON mapping rules:
/// - Root element name → `resourceType`
/// - `value` attributes → primitive values
/// - `<resource>` / `<contained>` wrappers → unwrapped with `resourceType`
/// - Context-aware array detection (parent.child lookup)
/// - `url` attribute on extensions → `url` property
/// - `<div>` → serialized XHTML string
Map<String, dynamic> fhirXmlToJson(String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final root = document.rootElement;

  final resourceType = root.name.local;
  final result = <String, dynamic>{};
  result['resourceType'] = resourceType;
  _convertChildren(root, result, resourceType);
  return result;
}

/// Group child elements by name and convert, using [parentName] for array
/// detection context.
void _convertChildren(
    XmlElement parent, Map<String, dynamic> result, String parentName) {
  final groups = <String, List<XmlElement>>{};
  for (final child in parent.childElements) {
    groups.putIfAbsent(child.name.local, () => []).add(child);
  }

  for (final entry in groups.entries) {
    final name = entry.key;
    final elements = entry.value;
    final isArray = elements.length > 1 || _isArray(parentName, name);

    if (isArray) {
      result[name] = elements.map((e) => _convertElement(e, name)).toList();
    } else {
      result[name] = _convertElement(elements.first, name);
    }
  }
}

/// Convert a single XML element to its JSON representation.
dynamic _convertElement(XmlElement element, String elementName) {
  final name = element.name.local;

  // <div> (XHTML narrative) — serialize the entire element as a string.
  if (name == 'div') {
    return element.toXmlString();
  }

  // <resource> wrapper (Parameters.parameter, Bundle.entry) and
  // <contained> wrapper — unwrap to expose the child resource.
  if (name == 'resource' || name == 'contained') {
    if (element.childElements.isEmpty) return <String, dynamic>{};
    final resourceChild = element.childElements.first;
    final resourceType = resourceChild.name.local;
    final json = <String, dynamic>{};
    json['resourceType'] = resourceType;
    _convertChildren(resourceChild, json, resourceType);
    return json;
  }

  final valueAttr = element.getAttribute('value');
  final hasChildren = element.childElements.isNotEmpty;

  // Pure primitive: value attribute, no children.
  if (valueAttr != null && !hasChildren) {
    return valueAttr;
  }

  // Complex element (BackboneElement, DataType, Resource, etc.)
  final result = <String, dynamic>{};

  // Preserve url attribute (extension / modifierExtension).
  final urlAttr = element.getAttribute('url');
  if (urlAttr != null) {
    result['url'] = urlAttr;
  }

  // Preserve id attribute (Element.id on any backbone/datatype element).
  final idAttr = element.getAttribute('id');
  if (idAttr != null) {
    result['id'] = idAttr;
  }

  // Primitive-with-extensions: has value attribute AND children.
  if (valueAttr != null && hasChildren) {
    result['value'] = valueAttr;
  }

  _convertChildren(element, result, elementName);
  return result;
}

/// Whether [childName] should be a JSON array when nested under [parentName].
bool _isArray(String parentName, String childName) {
  // Always-array elements regardless of context.
  if (_globalArrayElements.contains(childName)) return true;
  // Context-specific: "Parent.child".
  return _contextArrayElements.contains('$parentName.$childName');
}

/// Elements that are ALWAYS arrays regardless of parent context.
const _globalArrayElements = <String>{
  'extension',
  'modifierExtension',
  'contained',
  'coding',
};

/// Context-specific array elements keyed as "parentElement.childElement".
const _contextArrayElements = <String>{
  // Parameters
  'Parameters.parameter',
  'parameter.part',

  // Patient
  'Patient.identifier',
  'Patient.name',
  'Patient.telecom',
  'Patient.address',
  'Patient.contact',
  'Patient.communication',
  'Patient.link',
  'Patient.generalPractitioner',

  // HumanName
  'name.given',
  'name.prefix',
  'name.suffix',

  // Address
  'address.line',

  // Identifier
  'identifier.type', // CodeableConcept is single, but type.coding is global

  // Immunization
  'Immunization.identifier',
  'Immunization.performer',
  'Immunization.note',
  'Immunization.reasonCode',
  'Immunization.reasonReference',
  'Immunization.reaction',
  'Immunization.protocolApplied',
  'Immunization.education',
  'Immunization.programEligibility',
  'Immunization.subpotentReason',

  // ImmunizationEvaluation
  'ImmunizationEvaluation.identifier',
  'ImmunizationEvaluation.doseStatusReason',

  // ImmunizationRecommendation
  'ImmunizationRecommendation.identifier',
  'ImmunizationRecommendation.recommendation',
  'recommendation.vaccineCode',
  'recommendation.dateCriterion',
  'recommendation.forecastReason',
  'recommendation.contraindicatedVaccineCode',

  // Meta
  'meta.profile',
  'meta.tag',
  'meta.security',

  // Bundle
  'Bundle.entry',
  'Bundle.link',
  'entry.link',

  // CapabilityStatement
  'CapabilityStatement.format',
  'CapabilityStatement.rest',
  'rest.resource',
  'rest.operation',
  'rest.interaction',
  'rest.searchParam',
  'resource.interaction',
  'resource.searchParam',

  // OperationOutcome
  'OperationOutcome.issue',
  'issue.location',
  'issue.expression',

  // Observation (for condition tests)
  'Observation.identifier',
  'Observation.category',
  'Observation.component',
  'Observation.interpretation',
  'Observation.referenceRange',

  // Condition
  'Condition.identifier',
  'Condition.category',
  'Condition.bodySite',
  'Condition.evidence',
  'evidence.code',
  'evidence.detail',

  // AllergyIntolerance
  'AllergyIntolerance.identifier',
  'AllergyIntolerance.category',
  'AllergyIntolerance.reaction',
  'reaction.manifestation',

  // Procedure
  'Procedure.identifier',
  'Procedure.reasonCode',
  'Procedure.reasonReference',
  'Procedure.performer',
  'Procedure.note',

  // MedicationStatement / MedicationRequest / MedicationAdministration
  'MedicationStatement.identifier',
  'MedicationStatement.reasonCode',
  'MedicationRequest.identifier',
  'MedicationRequest.reasonCode',
  'MedicationAdministration.identifier',
  'MedicationAdministration.reasonCode',
};
