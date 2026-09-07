Profile: Vaccine
Parent: Medication
Id: Vaccine
Title: "Vaccine"
Description: "A vaccine product as CDC's supporting data describes one: the CVX, the trade name, the ages between which it is a preferable vaccine, and its type. Note that beginAge and endAge are FHIR Age values, which must be positive (age-1), so CDC's \"0 days\" cannot be carried; a begin age of 0 days is expressed by omitting beginAge."
// The canonical is the IG's own, not example.org, which the publisher
// reports as a URL mismatch against the resource's actual location.
* ^url = "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/Vaccine"

* extension contains BeginAge named beginAge 0..1
* extension contains EndAge named endAge 0..1
* extension contains VaccineType named vaccineType 0..1

// The trade name is CDC's "Trade Name (MVX)" column. It is sliced on the
// identifier system, an IG-local URI, because Identifier.type is bound to
// v2-0203 which has no code for a trade name; the old pattern `type =
// #official` was a coding with no system.
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains tradeName 0..1
* identifier[tradeName].system = "http://fhirfli.dev/fhir/ig/cicada/identifier/trade-name"
* identifier[tradeName] ^short = "The vaccine's trade name"

Extension: BeginAge
Id: begin-age
Title: "Begin Age"
Description: "The age at which the vaccine becomes applicable."
* value[x] only Age // Assuming you want to store age, using FHIR's Age datatype

Extension: EndAge
Id: end-age
Title: "End Age"
Description: "The age at which the vaccine is no longer applicable."
* value[x] only Age // Similarly, using Age datatype

Extension: VaccineType
Id: vaccine-type
Title: "Vaccine Type"
Description: "Type of the vaccine."
* value[x] only CodeableConcept // Assuming you want to store a coded type of vaccine
