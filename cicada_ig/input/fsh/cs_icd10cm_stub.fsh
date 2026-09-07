// ICD-10-CM is not defined here and is not distributed here. This is a
// content-not-present placeholder, the same shape hl7.terminology uses for
// external code systems, and it exists for one measured reason:
//
// Without any local CodeSystem for this URL the IG publisher asks the
// terminology registry for one, receives the complete ICD-10-CM from
// tx.fhir.org (28.7 MB, 98,505 concepts, cached under
// input-cache/txcache), and then attaches that whole resource as a
// tx-resource parameter on validate-code calls. tx.fhir.org never answers
// that request; Ontoserver takes 3 min 36 s. Every stalled build of this IG
// parked there (2026-09-01 to 09-06).
//
// The publisher only attaches CodeSystems whose content is complete or
// fragment, so a not-present stub is found locally, never fetched, and
// never sent. Validation of the ICD-10-CM codes in
// vaccine-condition-codes-icd10 still happens on the terminology server.
CodeSystem: Icd10Cm
Id: icd-10-cm
Title: "ICD-10-CM (external, content not present)"
Description: "Placeholder for the International Classification of Diseases, Tenth Revision, Clinical Modification, maintained by the US National Center for Health Statistics. No concepts are carried here; codes are validated by the terminology server."
* ^url = "http://hl7.org/fhir/sid/icd-10-cm"
* ^status = #active
* ^experimental = false
* ^caseSensitive = false
* ^content = #not-present
