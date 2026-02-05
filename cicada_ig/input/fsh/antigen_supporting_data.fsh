Resource: AntigenSupportingData
Id: antigen-supporting-data
Parent: Resource
Title: "Antigen Supporting Data"
Description: "A resource to store supporting data for antigens including target disease, vaccine groups, immunity criteria, contraindications, and vaccination series."
* ^baseDefinition = "http://hl7.org/fhir/StructureDefinition/Element"

// Define the elements specific to each disease
* targetDisease 0..1 CodeableConcept "The disease that the vaccine targets."
* vaccineGroup 0..1 CodeableConcept "The vaccine group associated with the target disease."

// Immunity section
* immunity 0..1 BackboneElement "Information about immunity from clinical history or birth data."
* immunity.clinicalHistory 0..* BackboneElement "List of clinical guidelines that describe circumstances of immunity."
* immunity.clinicalHistory.guidelineCode 1..1 string "Code of the guideline."
* immunity.clinicalHistory.guidelineTitle 1..1 string "Title of the guideline."
* immunity.dateOfBirth 0..1 BackboneElement "Birth date related immunity information."
* immunity.dateOfBirth.immunityBirthDate 1..1 date "Date conferring automatic immunity."
* immunity.dateOfBirth.birthCountry 1..1 string "Country of birth relevant to immunity."
* immunity.dateOfBirth.exclusion 0..* BackboneElement "Exclusions based on certain criteria."
* immunity.dateOfBirth.exclusion.exclusionCode 1..1 string "Code for the exclusion criteria."
* immunity.dateOfBirth.exclusion.exclusionTitle 1..1 string "Title of the exclusion criteria."

// Contraindications section
* contraindications 0..1 BackboneElement "Information about contraindications for the vaccine."
* contraindications.vaccineGroup 0..1 BackboneElement "Contraindications specific to the vaccine group."
* contraindications.vaccineGroup.contraindication 0..* BackboneElement "List of contraindications."
* contraindications.vaccineGroup.contraindication.observationCode 1..1 string "Code identifying the contraindication."
* contraindications.vaccineGroup.contraindication.observationTitle 1..1 string "Title of the contraindication."
* contraindications.vaccineGroup.contraindication.contraindicationText 1..1 string "Description of the contraindication."

// Series section
* series 0..* BackboneElement "Information about the vaccination series."
* series.seriesName 1..1 string "Name of the vaccination series."
* series.targetDisease 1..1 CodeableConcept "Disease targeted by the series."
* series.vaccineGroup 1..1 CodeableConcept "Vaccine group for the series."
* series.seriesType 1..1 string "Type of series (standard, risk-based, etc.)."
* series.selectSeries 0..1 BackboneElement "Selection criteria for the series."
* series.selectSeries.defaultSeries 1..1 boolean "If this is the default series."
* series.selectSeries.productPath 1..1 boolean "If the series has a specific product path."
* series.selectSeries.seriesGroupName 1..1 string "Name of the series group."
* series.selectSeries.seriesGroup 1..1 string "Group number of the series."
* series.selectSeries.seriesPriority 1..1 string "Priority of the series."
* series.selectSeries.seriesPreference 1..1 string "Preference number within the group."
* series.selectSeries.maxAgeToStart 1..1 string "Maximum age to start the series."

// Doses within the series
* series.seriesDose 0..* BackboneElement "Doses within the series."
* series.seriesDose.doseNumber 1..1 string "Number of the dose in the series."
* series.seriesDose.age 0..* BackboneElement "Age recommendations for the dose."
* series.seriesDose.age.absMinAge 1..1 string "Absolute minimum age for the dose."
* series.seriesDose.age.minAge 1..1 string "Minimum recommended age for the dose."
* series.seriesDose.age.earliestRecAge 1..1 string "Earliest recommended age for the dose."
* series.seriesDose.age.latestRecAge 1..1 string "Latest recommended age for the dose."
* series.seriesDose.preferableVaccine 0..* BackboneElement "Preferable vaccines for the dose."
* series.seriesDose.preferableVaccine.vaccineType 1..1 string "Type of the vaccine."
* series.seriesDose.preferableVaccine.cvx 1..1 string "CVX code for the vaccine."
* series.seriesDose.preferableVaccine.beginAge 1..1 string "Beginning age for the vaccine."
* series.seriesDose.preferableVaccine.endAge 1..1 string "Ending age for the vaccine."
* series.seriesDose.preferableVaccine.volume 1..1 decimal "Volume of the vaccine to be administered."
* series.seriesDose.preferableVaccine.forecastVaccineType 1..1 string "Forecast type of the vaccine."
* series.seriesDose.preferableVaccine.tradeName 0..1 string "Trade name of the vaccine."
* series.seriesDose.preferableVaccine.mvx 0..1 string "Manufacturer's vaccine code."

// Additional elements as needed for intervals and allowable vaccines
* series.seriesDose.allowableVaccine 0..* BackboneElement "Allowable vaccines if preferable vaccines are not available."
* series.seriesDose.allowableVaccine.vaccineType 1..1 string "Type of allowable vaccine."
* series.seriesDose.allowableVaccine.cvx 1..1 string "CVX code for allowable vaccine."
* series.seriesDose.allowableVaccine.beginAge 1..1 string "Beginning age for allowable vaccine."
* series.seriesDose.allowableVaccine.endAge 1..1 string "Ending age for allowable vaccine."

// Additional elements as needed for seasonal recommendations
* series.seriesDose.seasonalRecommendation 0..1 BackboneElement "Seasonal recommendation for the vaccine dose."
* series.seriesDose.seasonalRecommendation.startDate 1..1 string "Start date for the seasonal recommendation."
* series.seriesDose.seasonalRecommendation.endDate 1..1 string "End date for the seasonal recommendation."
