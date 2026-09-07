CodeSystem: VaccineRecommendationCategoryCS
Id: vaccine-recommendation-category
Title: "Vaccine Recommendation Category"
Description: "The three categories of CDC's Vaccine Recommendation Category Determination (CDSi supporting data 4.65): the type of recommendation a Best Patient Series carries for a patient who is recommended further doses. Displays are CDC's own words."
* ^caseSensitive = true
* ^content = #complete
* #routine "Routine" "An age-based recommendation for the general population."
* #high-risk "High-Risk" "A recommendation because of a risk factor the patient has (a risk-based series, or an included indication)."
* #scdm "SCDM" "Shared clinical decision making: the recommendation depends on a discussion between the patient and the clinician."

ValueSet: VaccineRecommendationCategoryVS
Id: vaccine-recommendation-category-vs
Title: "Vaccine Recommendation Category Value Set"
Description: "All codes from the Vaccine Recommendation Category code system."
* include codes from system VaccineRecommendationCategoryCS
