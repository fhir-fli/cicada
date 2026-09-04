Profile: Vaccine
Parent: Medication
Id: Vaccine
Title: "Vaccine"
Description: "Simple vaccine to easily obtain needed information for forecasting"
// The canonical is the IG's own, not example.org, which the publisher
// reports as a URL mismatch against the resource's actual location.
* ^url = "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/Vaccine"

* extension contains BeginAge named beginAge 0..1
* extension contains EndAge named endAge 0..1
* extension contains VaccineType named vaccineType 0..1

* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier contains tradeName 0..1
* identifier[tradeName].type = #official // or whatever type suits your needs

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
