Profile: VaxDose
Parent: Immunization
Id: vax-dose
Title: "Dose of a Vaccine"
Description: "Detailed information about each vaccination dose."
* ^url = "http://example.org/fhir/StructureDefinition/vax-dose"
* status from EvalStatusVS (required)
* statusReason from EvalReasonVS (extensible)
* vaccineCode from VaccineCodesCvxMvx (required)
* occurrenceDateTime 1..1
* patient 1..1
* doseQuantity 0..1
* manufacturer only Reference(Organization)
* subpotentReason from http://hl7.org/fhir/ValueSet/immunization-subpotent-reason (required)

* protocolApplied ^slicing.discriminator.type = #pattern
* protocolApplied ^slicing.discriminator.path = "doseNumberPositiveInt"
* protocolApplied ^slicing.rules = #open
// * protocolApplied contains VaxDoseProtocol 0..* named vaxDoseProtocol
// * protocolApplied[VaxDoseProtocol].doseNumberPositiveInt 1..1
// * protocolApplied[VaxDoseProtocol].seriesDosesPositiveInt 0..1

// Define extensions
* extension contains AssessmentDate named assessmentDate 0..1
* extension contains InadvertentAdministrationStatus named inadvertentAdministration 0..1
* extension contains ValidAgeStatus named validAgeStatus 0..1
* extension contains ValidAgeReason named validAgeReason 0..1
* extension contains PreferredIntervalStatus named preferredIntervalStatus 0..1
* extension contains PreferredIntervalReason named preferredIntervalReason 0..1
* extension contains AllowedIntervalStatus named allowedIntervalStatus 0..1
* extension contains AllowedIntervalReason named allowedIntervalReason 0..1
* extension contains VaccinationConflict named vaccinationConflict 0..1
* extension contains PreferredVaccineStatus named preferredVaccineStatus 0..1
* extension contains PreferredVaccineReason named preferredVaccineReason 0..1
* extension contains AllowedVaccineStatus named allowedVaccineStatus 0..1
* extension contains AllowedVaccineReason named allowedVaccineReason 0..1

Extension: InadvertentAdministrationStatus
Id: inadvertent-administration-status
Title: "Inadvertent Administration Status"
Description: "Indicates if the vaccine was administered inadvertently."
* value[x] only boolean

Extension: ValidAgeStatus
Id: valid-age-status
Title: "Valid Age Status"
Description: "Indicates if the vaccine was administered at the correct age."
* value[x] only boolean

Extension: ValidAgeReason
Id: valid-age-reason
Title: "Valid Age Reason"
Description: "Captures the reason why the vaccine was administered at a particular age."
* value[x] from ValidAgeReasonVS (required)

Extension: PreferredIntervalStatus
Id: preferred-interval-status
Title: "Preferred Interval Status"
Description: "Indicates if the vaccine was administered at the preferred interval."
* value[x] only boolean

Extension: PreferredIntervalReason
Id: preferred-interval-reason
Title: "Preferred Interval Reason"
Description: "Captures the reason for the preferred interval between vaccine doses."
* value[x] from IntervalReasonVS (required)

Extension: AllowedIntervalStatus
Id: allowed-interval-status
Title: "Allowed Interval Status"
Description: "Captures the status of the allowed interval for vaccination."
* value[x] only boolean

Extension: AllowedIntervalReason
Id: allowed-interval-reason
Title: "Allowed Interval Reason"
Description: "Captures the reason for the allowed interval between vaccine doses."
* value[x] from IntervalReasonVS (required)

Extension: VaccinationConflict
Id: vaccination-conflict
Title: "Vaccination Conflict"
Description: "Indicates any conflicts with other vaccinations."
* value[x] only boolean

Extension: PreferredVaccineStatus
Id: preferred-vaccine-status
Title: "Preferred Vaccine Status"
Description: "Indicates if the vaccine administered is the preferred vaccine."
* value[x] only boolean

Extension: PreferredVaccineReason
Id: preferred-vaccine-reason
Title: "Preferred Vaccine Reason"
Description: "Captures the reason why a particular vaccine is preferred."
* value[x] from PreferredAllowedReasonVS (required)

Extension: AllowedVaccineStatus
Id: allowed-vaccine-status
Title: "Allowed Vaccine Status"
Description: "Indicates if the vaccine administered is allowed under certain conditions."
* value[x] only boolean

Extension: AllowedVaccineReason
Id: allowed-vaccine-reason
Title: "Allowed Vaccine Reason"
Description: "Captures the reason why a particular vaccine is allowed."
* value[x] from PreferredAllowedReasonVS (required)
