import 'package:fhir_r4/fhir_r4.dart' show fhirFieldMap;
import 'package:xml/xml.dart';

/// Converts a FHIR R4 XML string to a FHIR JSON [Map].
///
/// Uses [fhirFieldMap] from the fhir_r4 package for type-aware conversion:
/// - Knows which fields are lists vs scalars via `FhirField.isList`
/// - Knows the FHIR type of each field for recursive child conversion
/// - Properly unwraps `<resource>` / `<contained>` wrappers
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

/// Group child elements by name and convert, using [fhirTypeName] to look up
/// field definitions in [fhirFieldMap] for array detection and child types.
void _convertChildren(
    XmlElement parent, Map<String, dynamic> result, String fhirTypeName) {
  final typeFields = fhirFieldMap[fhirTypeName];

  final groups = <String, List<XmlElement>>{};
  for (final child in parent.childElements) {
    groups.putIfAbsent(child.name.local, () => []).add(child);
  }

  for (final entry in groups.entries) {
    final name = entry.key;
    final elements = entry.value;
    final fieldDef = typeFields?[name];

    // Use fhirFieldMap if available, fall back to hardcoded sets.
    final isArray = elements.length > 1 ||
        (fieldDef != null ? fieldDef.isList : _isArrayFallback(name));

    // Get the FHIR type for recursing into children.
    final childType = fieldDef?.type;

    if (isArray) {
      result[name] =
          elements.map((e) => _convertElement(e, name, childType)).toList();
    } else {
      result[name] = _convertElement(elements.first, name, childType);
    }
  }
}

/// Convert a single XML element to its JSON representation.
/// [fhirTypeName] is the FHIR type of this element (from parent's field def).
dynamic _convertElement(
    XmlElement element, String elementName, String? fhirTypeName) {
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

  _convertChildren(element, result, fhirTypeName ?? elementName);
  return result;
}

/// Fallback array detection for elements not found in [fhirFieldMap].
/// Only used when the parent type or child field is unknown to fhirFieldMap.
bool _isArrayFallback(String childName) {
  return _globalArrayElements.contains(childName);
}

/// Elements that are ALWAYS arrays regardless of parent context.
const _globalArrayElements = <String>{
  'extension',
  'modifierExtension',
  'contained',
  'coding',
};
