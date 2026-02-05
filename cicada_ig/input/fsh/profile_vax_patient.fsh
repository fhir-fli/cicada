// Define the VaxPatient profile that extends the base Patient resource
Profile: VaxPatient
Parent: Patient
Id: vax-patient
Title: "Vaccination Patient"
Description: "A profile that extends the base FHIR Patient resource to include detailed vaccination-related information."

// Assuming VaccineGender is a ValueSet that exists
* gender from VaccineGenderVS (required)

// Apply the AssessmentDate extension to the VaxPatient profile
* extension contains AssessmentDate named assessmentDate 0..1

* birthDate 1..1