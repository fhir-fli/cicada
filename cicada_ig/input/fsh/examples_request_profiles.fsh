// Examples of the request-side profiles no CDC test case carries. Each is a
// resource the engine reads (providers/patient_for_assessment.dart sorts the
// request by these types). Codes are ones CDC's supporting data or this IG's
// value sets already name; displays are omitted where the code system's own
// display was not looked up.

Instance: observation-immunocompromised
InstanceOf: VaccineObservationFhir
Usage: #example
Title: "Observation: patient immunocompromised"
Description: "A coded observation carrying CDSi observation 003, Immunocompromised, as its SNOMED coded value 370388006."
* status = #final
* code = http://snomed.info/sct#370388006 "Patient immunocompromised"
* subject = Reference(Patient/2016-UC-0032)
* performer = Reference(Practitioner/practitioner-recording)
* effectiveDateTime = "2015-04-30"

Instance: procedure-stem-cell-transplant
InstanceOf: ProcedureProfile
Usage: #example
Title: "Procedure: haemopoietic stem cell transplant"
Description: "A procedure the engine reads as an immunization-relevant history item: SNOMED 234336002, one of the roots of the immunization procedures value set."
* status = #completed
* code = http://snomed.info/sct#234336002
* subject = Reference(Patient/2016-UC-0032)
* performedDateTime = "2014-11-02"

Instance: allergy-vaccine-reaction
InstanceOf: ReactionProfile
Usage: #example
Title: "AllergyIntolerance: adverse reaction to a vaccine"
Description: "An allergy record the engine reads as a contraindication candidate: SNOMED 293104008, Vaccines adverse reaction, the root of the vaccine reaction concepts in the condition value set, with the substance as the CVX of the vaccine reacted to."
* clinicalStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical#active
* code = http://snomed.info/sct#293104008
* patient = Reference(Patient/2016-UC-0032)
* reaction.substance = http://hl7.org/fhir/sid/cvx#08 "Hep B, adolescent or pediatric"
* reaction.manifestation = http://snomed.info/sct#39579001 "Anaphylaxis"
* reaction.severity = #severe

Instance: medication-statement-hepb
InstanceOf: MedicationStatementProfile
Usage: #example
Title: "MedicationStatement: a vaccine recorded as a medication"
Description: "A hepatitis B dose recorded as a MedicationStatement, which the engine accepts as an administered dose."
* status = #completed
* medicationCodeableConcept = http://hl7.org/fhir/sid/cvx#08 "Hep B, adolescent or pediatric"
* subject = Reference(Patient/2016-UC-0032)
* effectiveDateTime = "1998-03-10"

Instance: medication-request-hepb
InstanceOf: MedicationRequestProfile
Usage: #example
Title: "MedicationRequest: a vaccine ordered as a medication"
Description: "A hepatitis B dose ordered as a MedicationRequest."
* status = #completed
* intent = #order
* medicationCodeableConcept = http://hl7.org/fhir/sid/cvx#08 "Hep B, adolescent or pediatric"
* subject = Reference(Patient/2016-UC-0032)
* authoredOn = "1998-03-10"

Instance: medication-administration-hepb
InstanceOf: MedicationAdministrationProfile
Usage: #example
Title: "MedicationAdministration: a vaccine given as a medication"
Description: "A hepatitis B dose recorded as a MedicationAdministration, which the engine accepts as an administered dose."
* status = #completed
* medicationCodeableConcept = http://hl7.org/fhir/sid/cvx#08 "Hep B, adolescent or pediatric"
* subject = Reference(Patient/2016-UC-0032)
* effectiveDateTime = "1998-03-10"

Instance: medication-dispense-hepb
InstanceOf: MedicationDispenseProfile
Usage: #example
Title: "MedicationDispense: a vaccine dispensed as a medication"
Description: "A hepatitis B dose dispensed as a MedicationDispense."
* status = #completed
* medicationCodeableConcept = http://hl7.org/fhir/sid/cvx#08 "Hep B, adolescent or pediatric"
* subject = Reference(Patient/2016-UC-0032)
* whenHandedOver = "1998-03-10"

Instance: vaccine-dtap
InstanceOf: Vaccine
Usage: #example
Title: "Medication: DTaP"
Description: "A vaccine product as a Medication: CVX 20 with a trade name, the ages between which CDC's Diphtheria standard series lists it as a preferable vaccine (6 weeks to 7 years), and its vaccine type. CDC's \"0 days\" begin ages cannot be examples here: FHIR's Age datatype requires a positive value (age-1)."
* code = http://hl7.org/fhir/sid/cvx#20 "DTaP"
* identifier[tradeName].value = "Infanrix"
* extension[beginAge].valueAge = 6 'wk' "weeks"
* extension[endAge].valueAge = 7 'a' "years"
* extension[vaccineType].valueCodeableConcept = http://hl7.org/fhir/sid/cvx#20 "DTaP"

Instance: practitioner-recording
InstanceOf: Practitioner
Usage: #example
Title: "Practitioner: the recorder of the example observation"
Description: "The performer of observation-immunocompromised. Practitioner is not profiled by this IG; the example exists so that the observation can carry a performer, as the base specification recommends."
* name.family = "Okello"
* name.given = "Grace"
