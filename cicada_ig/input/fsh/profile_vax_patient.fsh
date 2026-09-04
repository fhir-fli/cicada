// Define the VaxPatient profile that extends the base Patient resource
Profile: VaxPatient
Parent: Patient
Id: vax-patient
Title: "Vaccination Patient"
Description: "A profile that extends the base FHIR Patient resource to include detailed vaccination-related information."

// Patient.gender is NOT rebound. R4 binds it required to
// administrative-gender: male | female | other | unknown. This profile bound
// it to VaccineGenderVS, which adds `transgender`, and a required binding
// cannot be widened. Administrative gender is also the wrong element for it:
// its own definition calls it administrative, not clinical or biological.
//
// CDSi uses gender to select series, and the engine reads Patient.gender for
// that today. Where a patient's sex differs from the administrative value, the
// Gender Harmony elements are the place for it, not a widened base binding.

// Apply the AssessmentDate extension to the VaxPatient profile
* extension contains AssessmentDate named assessmentDate 0..1

* birthDate 1..1