Profile: VaxDose
Parent: Immunization
Id: vax-dose
Title: "Dose of a Vaccine"
Description: "An administered dose as the engine reads it: the vaccine as CVX, the date, the patient, and optionally the dose volume, the manufacturer and a subpotency reason. The engine's evaluation of the dose is returned on ImmunizationEvaluation (target-dose-status-ext, evaluation-detail-ext), not written back onto the Immunization; until 2026-09-07 this profile declared thirteen evaluation extensions nothing ever emitted."
// The canonical is the IG's own, not example.org, which was a URL mismatch
// against every other artefact here.
* ^url = "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vax-dose"

// Immunization.status is NOT rebound. It is bound required in R4 to
// completed | entered-in-error | not-done, which is the status of the
// administration. This profile used to bind it to EvalStatusVS —
// valid | notvalid | extraneous | sub-standard — which is the CDSi
// EVALUATION status of a dose, a different thing about a different act. A
// required binding cannot be widened, and the engine already reports the
// evaluation status where R4 puts it: ImmunizationEvaluation.doseStatus.
* statusReason from EvalReasonVS (extensible)
* vaccineCode from VaccineCodesCvxMvx (required)
* occurrenceDateTime 1..1
* patient 1..1
* doseQuantity 0..1
* manufacturer only Reference(Organization)
* subpotentReason from http://hl7.org/fhir/ValueSet/immunization-subpotent-reason (required)

// No slicing on protocolApplied. It declared a pattern discriminator on
// `doseNumberPositiveInt`, which is not an element: R4 has `doseNumber[x]`, and
// a discriminator names the choice, not one of its types. The slices it was
// written for were commented out, so this was a slicing declaration with
// nothing sliced.
// * protocolApplied[VaxDoseProtocol].seriesDosesPositiveInt 0..1

// Define extensions
