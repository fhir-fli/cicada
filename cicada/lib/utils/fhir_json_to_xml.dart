import 'package:fhir_r4/fhir_r4.dart' show FhirField, fhirFieldMap;
import 'package:xml/xml.dart';

const _fhirNs = 'http://hl7.org/fhir';
const _xhtmlNs = 'http://www.w3.org/1999/xhtml';

/// Converts a FHIR R4 JSON [Map] to a FHIR XML string.
///
/// Uses [fhirFieldMap] from the fhir_r4 package for type-aware conversion:
/// - Knows which fields are lists vs scalars
/// - Knows which fields are primitives (→ `value` attribute) vs complex types
/// - Properly wraps inline resources in `<resource>` / `<contained>` elements
String fhirJsonToXml(Map<String, dynamic> json) {
  final resourceType = json['resourceType'] as String?;
  if (resourceType == null) {
    throw ArgumentError('JSON map must contain a "resourceType" key');
  }

  final root = XmlElement(
    XmlName(resourceType),
    [XmlAttribute(XmlName('xmlns'), _fhirNs)],
  );
  _addChildren(root, json, resourceType);

  final doc = XmlDocument([
    XmlProcessing('xml', 'version="1.0" encoding="UTF-8"'),
    root,
  ]);
  return doc.toXmlString(pretty: true);
}

/// Add child XML elements to [parent] based on [json] fields, using
/// [fhirTypeName] for type context lookup in [fhirFieldMap].
void _addChildren(
    XmlElement parent, Map<String, dynamic> json, String fhirTypeName) {
  final typeFields = fhirFieldMap[fhirTypeName];

  for (final entry in json.entries) {
    final key = entry.key;
    final value = entry.value;

    if (key == 'resourceType') continue;
    if (key.startsWith('_')) continue;

    final FhirField? fieldDef = typeFields?[key];
    final underscoreValue = json['_$key'];

    if (value is List) {
      final List? underscoreList =
          underscoreValue is List ? underscoreValue : null;
      for (int i = 0; i < value.length; i++) {
        final item = value[i];
        final usItem = underscoreList != null && i < underscoreList.length
            ? underscoreList[i]
            : null;
        _addElement(parent, key, item, fieldDef, underscoreValue: usItem);
      }
    } else {
      _addElement(parent, key, value, fieldDef,
          underscoreValue: underscoreValue);
    }
  }
}

/// Add a single XML element to [parent] for a JSON key/value pair.
void _addElement(
    XmlElement parent, String key, dynamic value, FhirField? fieldDef,
    {dynamic underscoreValue}) {
  if (value == null && underscoreValue == null) return;

  // Narrative div — parse XHTML string and embed directly.
  if (key == 'div' && value is String) {
    try {
      final parsed = XmlDocumentFragment.parse(value);
      for (final node in parsed.children) {
        parent.children.add(node.copy());
      }
    } catch (_) {
      final div = XmlElement(XmlName('div'), [
        XmlAttribute(XmlName('xmlns'), _xhtmlNs),
      ]);
      div.children.add(XmlText(value.toString()));
      parent.children.add(div);
    }
    return;
  }

  // Inline resource wrappers (resource, contained).
  if (key == 'resource' || key == 'contained') {
    if (value is Map<String, dynamic>) {
      final childType = value['resourceType'] as String?;
      if (childType != null) {
        final wrapper = XmlElement(XmlName(key));
        final resourceEl = XmlElement(XmlName(childType), [
          XmlAttribute(XmlName('xmlns'), _fhirNs),
        ]);
        _addChildren(resourceEl, value, childType);
        wrapper.children.add(resourceEl);
        parent.children.add(wrapper);
        return;
      }
    }
  }

  final fieldType = fieldDef?.type;

  if (value is Map<String, dynamic>) {
    final el = XmlElement(XmlName(key));
    if (value.containsKey('resourceType')) {
      final innerType = value['resourceType'] as String;
      final resourceEl = XmlElement(XmlName(innerType));
      _addChildren(resourceEl, value, innerType);
      el.children.add(resourceEl);
    } else {
      _addChildren(el, value, fieldType ?? key);
    }
    parent.children.add(el);
  } else if (value is String || value is num || value is bool) {
    final el = XmlElement(XmlName(key), [
      XmlAttribute(XmlName('value'), _primitiveToString(value)),
    ]);
    if (underscoreValue is Map<String, dynamic>) {
      _addChildren(el, underscoreValue, 'Element');
    }
    parent.children.add(el);
  } else if (value == null && underscoreValue is Map<String, dynamic>) {
    final el = XmlElement(XmlName(key));
    _addChildren(el, underscoreValue, 'Element');
    parent.children.add(el);
  }
}

String _primitiveToString(dynamic value) {
  if (value is bool) return value ? 'true' : 'false';
  return value.toString();
}
