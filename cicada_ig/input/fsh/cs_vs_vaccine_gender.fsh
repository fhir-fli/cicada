// Define the Vaccine Gender CodeSystem
CodeSystem: VaccineGenderCS
Id: VaccineGender
Title: "Vaccine Gender"
Description: "Value set for gender categories relevant to vaccination data."
* #female "Female" "Female" 
* #transgender "Transgender" "Transgender" 
* #unknown "Unknown" "Unknown" 
* #male "Male" "Male" 

// Define the Vaccine Status ValueSet
ValueSet: VaccineGenderVS
Id: vaccine-gender
Title: "Vaccine Gender"
Description: "Value set for gender categories relevant to vaccination data."
* VaccineGender#female "Female"
* VaccineGender#transgender "Transgender"
* VaccineGender#unknown "Unknown"
* VaccineGender#male "Male"