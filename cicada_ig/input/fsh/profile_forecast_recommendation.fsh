// A vaccine group can produce more than one forecast.
//
// CDSi FORECASTVG-1 scopes a vaccine group forecast to a *series group*, and a
// vaccine group can hold several — typically a standard one and a risk one. The
// Chapter 9 introduction states the consequence: a patient "may end up with more
// than 1 vaccine group forecast for a given vaccine group (e.g., a travel-based
// MMR forecast and an age-based MMR forecast)."
//
// Core ImmunizationRecommendation already carries the series identity in
// `recommendation.series` ("One possible path to achieve presumed immunity
// against a disease - within the context of an authority"), so no extension is
// needed for that. Nothing in core FHIR, and nothing in the US ImmDS IG, says
// whether a recommendation came from a standard or a risk series group — which
// is what a client needs to tell two same-disease recommendations apart. Hence
// the extension below.

CodeSystem: SeriesTypeCS
Id: series-type
Title: "Series Type Code System"
Description: "CDSi series type: whether a patient series is the routine schedule, one indicated by a risk condition, or evaluation-only. Mirrors the seriesType attribute of the CDSi antigen supporting data."
* ^caseSensitive = true
* ^content = #complete
* #standard "Standard" "The routine, age-based series."
* #risk "Risk" "A series indicated by a patient risk condition, such as travel, occupation, pregnancy, or a chronic medical condition."
* #evaluation-only "Evaluation Only" "A series used only to evaluate administered doses; it never produces a forecast."

ValueSet: SeriesTypeVS
Id: series-type-vs
Title: "Series Type Value Set"
Description: "Series types a forecast can be scoped to. In practice a forecast carries standard or risk: CDSi Table 8-14 excludes Evaluation Only series from best patient series."
* include codes from system SeriesTypeCS

Extension: SeriesType
Id: series-type-ext
Title: "Series Type"
Description: "Whether this recommendation came from the standard series group or a risk series group. Present so a client receiving two recommendations for one vaccine group can tell which pathway each describes."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationRecommendation.recommendation"
* value[x] only CodeableConcept
* valueCodeableConcept from SeriesTypeVS (required)

Profile: CicadaImmunizationRecommendation
Parent: ImmunizationRecommendation
Id: cicada-immunization-recommendation
Title: "Cicada Immunization Recommendation"
Description: "The forecast cicada returns. Constrains ImmunizationRecommendation to say which series group each recommendation belongs to, so that more than one recommendation for a single vaccine group can be told apart."
* ^url = "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/cicada-immunization-recommendation"
* patient 1..1
* date 1..1

// More than one recommendation may share a targetDisease: one per series group.
* recommendation 1..*
* recommendation.targetDisease MS
* recommendation.forecastStatus from ForecastStatusVS (extensible)

// The series group this recommendation is scoped to (CDSi FORECASTVG-1).
* recommendation.series MS

* recommendation.extension contains SeriesType named seriesType 0..1
* recommendation.extension[seriesType] MS
