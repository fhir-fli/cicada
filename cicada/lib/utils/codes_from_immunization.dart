import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';

String? cvxFromImmunization(Immunization immunization) =>
    codeFromImmunization(
      immunization,
      FhirUri('http://hl7.org/fhir/sid/cvx'),
    ) ??
    // vaccineCode is bound to CVX in the US (US Core / ImmDS IG). Accept the
    // first code when the system URI is absent — real-world callers (including
    // FITS) often omit it.
    immunization.vaccineCode.coding?.firstOrNull?.code?.toString();

/// The URIs an MVX code may carry (hl7.terminology.r4 7.5.0,
/// NamingSystem-MVX uniqueId: two preferred, two others).
const mvxSystems = <String>{
  'http://hl7.org/fhir/sid/mvx',
  'urn:oid:2.16.840.1.113883.12.227',
  'urn:oid:2.16.840.1.113883.6.60',
  'http://terminology.hl7.org/CodeSystem/MVX',
};

/// The manufacturer's MVX code, read every way the published guides send it
/// (TEST-RESOURCE-REVIEW.md, 272 Immunization examples in 31 sources).
///
/// `Immunization.manufacturer` is a Reference(Organization). HL7 V2-to-FHIR
/// maps RXA-17 there, the MVX code to `Organization.identifier.value` and the
/// name to `Organization.name`. Accepted, in order:
/// 1. `manufacturer.identifier` with an MVX system, or with none;
/// 2. a contained Organization (`#id`), by identifier, then by name (FITS
///    sends this, with no identifier system);
/// 3. a literal reference to an Organization supplied with the request
///    ([organizations], keyed `Organization/<id>` and `<id>`);
/// 4. `manufacturer.display`, matched to an MVX name (UK Core, AU, EU Base
///    examples send only the company name);
/// 5. an MVX coding in `vaccineCode` (no guide does this; older senders,
///    including cicada's own test data until 2026-11-02, did).
String? mvxFromImmunization(
  Immunization immunization, {
  Map<String, Organization> organizations = const {},
}) {
  final manufacturer = immunization.manufacturer;
  if (manufacturer != null) {
    final fromIdentifier = _mvxFromIdentifiers([
      if (manufacturer.identifier != null) manufacturer.identifier!,
    ]);
    if (fromIdentifier != null) return fromIdentifier;

    final reference = manufacturer.reference?.valueString;
    Organization? organization;
    if (reference != null && reference.startsWith('#')) {
      organization =
          immunization.contained
              ?.whereType<Organization>()
              .where((o) => o.id?.valueString == reference.substring(1))
              .firstOrNull;
    } else if (reference != null) {
      organization =
          organizations[reference] ?? organizations[reference.split('/').last];
    }
    if (organization != null) {
      final code =
          _mvxFromIdentifiers(organization.identifier ?? const []) ??
          _mvxFromName(organization.name?.valueString);
      if (code != null) return code;
    }

    final fromDisplay = _mvxFromName(manufacturer.display?.valueString);
    if (fromDisplay != null) return fromDisplay;
  }

  for (final coding in immunization.vaccineCode.coding ?? const <Coding>[]) {
    final system = coding.system?.toString();
    final code = coding.code?.toString();
    if (code != null && mvxSystems.contains(system)) return code;
  }
  return null;
}

/// An MVX code from identifiers: one with an MVX system, else one with no
/// system whose value is a known MVX code.
String? _mvxFromIdentifiers(List<Identifier> identifiers) {
  for (final identifier in identifiers) {
    final value = identifier.value?.valueString?.trim();
    if (value == null || value.isEmpty) continue;
    final system = identifier.system?.toString();
    if (system != null && mvxSystems.contains(system)) return value;
    if (system == null && mvxDisplays.containsKey(value.toUpperCase())) {
      return value.toUpperCase();
    }
  }
  return null;
}

/// An MVX code from a manufacturer's name, matched case-insensitively to the
/// MVX table's names. Returns null when the name matches no entry or more
/// than one.
String? _mvxFromName(String? name) {
  final wanted = name?.trim().toLowerCase();
  if (wanted == null || wanted.isEmpty) return null;
  final matches = [
    for (final entry in mvxDisplays.entries)
      if (entry.value.trim().toLowerCase() == wanted) entry.key,
  ];
  return matches.length == 1 ? matches.single : null;
}

String? codeFromImmunization(Immunization immunization, FhirUri url) {
  final index = immunization.vaccineCode.coding?.indexWhere(
    (element) => element.system == url && element.code != null,
  );
  if (index == null || index == -1) {
    return null;
  } else {
    return immunization.vaccineCode.coding![index].code!.toString();
  }
}

EvalReason? subpotentReason(Immunization immunization) {
  int? codingIndex;
  final subpotentIndex = immunization.subpotentReason?.indexWhere((
    codeableConcept,
  ) {
    codingIndex = codeableConcept.coding?.indexWhere(
      (coding) =>
          coding.system ==
              FhirUri(
                'http://terminology.hl7.org/CodeSystem/immunization-subpotent-reason',
              ) &&
          (coding.display != null || coding.code != null),
    );
    return !(codingIndex == null || codingIndex == -1);
  });
  if (subpotentIndex == null ||
      subpotentIndex == -1 ||
      codingIndex == null ||
      codingIndex == -1) {
    return null;
  } else {
    if (immunization
            .subpotentReason![subpotentIndex]
            .coding![codingIndex!]
            .code !=
        null) {
      final evalReason = EvalReason.fromCode(
        immunization
            .subpotentReason![subpotentIndex]
            .coding![codingIndex!]
            .code
            ?.valueString,
      );
      if (evalReason != null) {
        return evalReason;
      } else {
        return EvalReason.fromJson(
          immunization
              .subpotentReason![subpotentIndex]
              .coding![codingIndex!]
              .display!
              .valueString,
        );
      }
    } else {
      return null;
    }
  }
}
