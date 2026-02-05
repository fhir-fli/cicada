Profile: ReactionProfile
Parent: AllergyIntolerance
Title: "Allergy Intolerance Profile with Vaccine Codes"
Description: "Profile for allergy intolerances where the offending agent must have a CVX or MVX code."

* reaction.exists()  // Ensures that the reaction element exists
* reaction.substance.exists()  // Ensures that the substance within the reaction exists
* reaction.substance.coding.exists()  // Ensures that the coding for the substance exists
* reaction.substance.coding from VaccineCodesCvxMvx  // Binds the coding system to the VaccineCodesCvxMvx ValueSet
