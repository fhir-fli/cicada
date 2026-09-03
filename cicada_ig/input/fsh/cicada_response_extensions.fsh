// Everything cicada adds to an $immds-forecast response beyond core FHIR and
// the US ImmDS IG.
//
// The engine works out more than those two resources have elements for: why it
// forecast what it did, which target dose each administered dose satisfied,
// which Chapter 6 sub-step failed, the component dates behind each forecast
// date, and per-series detail where a vaccine group blends several series.
// None of that has a home in core FHIR, so each travels as an extension here.
//
// Nothing below changes a dose's validity or a series' status.

// ---------------------------------------------------------------------------
// Forecast reason
// ---------------------------------------------------------------------------

CodeSystem: CicadaForecastReasonCS
Id: forecast-reason
Title: "Cicada Forecast Reason Code System"
Description: "Why the engine forecast what it did. The ImmDS ForecastReason code system covers four of these; the rest have no ImmDS concept, and the ImmDS binding on ImmunizationRecommendation.recommendation.forecastReason is example strength, so they travel as a second coding rather than being dropped."
* ^caseSensitive = true
* ^content = #complete
* #series-complete "Patient series is complete" "Every target dose in the series is satisfied. Maps to ImmDS #complete."
* #not-recommended-history "Not recommended at this time due to past immunization history" "Maps to ImmDS #notRecommended."
* #exceeded-maximum-age "Patient has exceeded the maximum age" "Maps to ImmDS #maximumAge."
* #past-seasonal-end "Past seasonal recommendation end date" "Maps to ImmDS #seasonalPast."
* #complete-for-the-season "Patient is complete for the season" "The series is complete for the current season and a further dose falls in a later one. Maps to ImmDS #seasonalComplete. A deliberate deviation from CDSi, which has no such reason: ACIP defines influenza and RSV recommendations by season, and without this a patient who has had this year's dose is indistinguishable from one who never needs another."
* #evidence-of-immunity "Patient has evidence of immunity" "No ImmDS concept."
* #contraindication "Patient has a contraindication" "No ImmDS concept."
* #cannot-finish-before-maximum-age "Patient is unable to finish the series prior to the maximum age" "No ImmDS concept."
* #below-minimum-age-to-start "Patient has not reached the minimum age to start" "No ImmDS concept."
* #shared-clinical-decision-making "Recommended by shared clinical decision-making" "ACIP recommends this series by shared clinical decision-making rather than routinely, so it is not a care gap. Read from CDC's own marking in the series name, and for HPV from the 27-45 year band CDC states in its guidance. No CDSi or ImmDS concept; ICE calls it CLINICAL_PATIENT_DISCRETION."

ValueSet: CicadaForecastReasonVS
Id: forecast-reason-vs
Title: "Cicada Forecast Reason Value Set"
Description: "Forecast reasons the engine can report."
* include codes from system CicadaForecastReasonCS

// ---------------------------------------------------------------------------
// Target dose status
// ---------------------------------------------------------------------------

CodeSystem: TargetDoseStatusCS
Id: target-dose-status
Title: "Target Dose Status Code System"
Description: "CDSi Table 3-2. The status of the target dose an administered dose was evaluated against. R4 ImmunizationEvaluation carries only doseNumber, derived from this, so a skipped target dose and a satisfied one are otherwise indistinguishable."
* ^caseSensitive = true
* ^content = #complete
* #satisfied "Satisfied" "The target dose was satisfied by a vaccine dose administered."
* #not-satisfied "Not Satisfied" "The target dose was not satisfied."
* #skipped "Skipped" "The target dose was skipped, per a conditional skip in the series."

ValueSet: TargetDoseStatusVS
Id: target-dose-status-vs
Title: "Target Dose Status Value Set"
Description: "CDSi target dose statuses."
* include codes from system TargetDoseStatusCS

Extension: TargetDoseStatus
Id: target-dose-status-ext
Title: "Target Dose Status"
Description: "The CDSi target dose status this administered dose produced."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationEvaluation"
* value[x] only CodeableConcept
* valueCodeableConcept from TargetDoseStatusVS (required)

// ---------------------------------------------------------------------------
// Data integrity
// ---------------------------------------------------------------------------

CodeSystem: DataIntegrityCS
Id: data-integrity
Title: "Cicada Data Integrity Code System"
Description: "Records that cannot describe an administration. CDSi evaluates a vaccine dose administered and defines the assessment date as the current date, so these doses are excluded from evaluation and forecasting and reported in an OperationOutcome. They are statements about the data, never about the patient's immunity, which is why they are not evaluation statuses."
* ^caseSensitive = true
* ^content = #complete
* #dose-before-birth "Dose dated before the date of birth" "The administration date precedes the patient's date of birth, so the dose was not given to this patient. Check the birth date, the administration date, and that the record belongs to this patient."
* #dose-after-assessment "Dose dated after the assessment date" "The administration date is after the assessment date, so the administration has not happened. A planned dose belongs in an ImmunizationRecommendation."

ValueSet: DataIntegrityVS
Id: data-integrity-vs
Title: "Cicada Data Integrity Value Set"
Description: "Reasons a dose was reported rather than evaluated."
* include codes from system DataIntegrityCS

// ---------------------------------------------------------------------------
// Provenance of the answer
// ---------------------------------------------------------------------------

Extension: EngineVersion
Id: engine-version-ext
Title: "Engine and Supporting Data Version"
Description: "The engine build and the CDSi supporting-data release that produced this resource. A forecast is a function of both, so a stored response naming neither cannot be traced to what produced it. Parameters is not a DomainResource and carries no extension, so the stamp sits on each evaluation and on each recommendation."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationEvaluation"
* ^context[1].type = #element
* ^context[1].expression = "ImmunizationRecommendation.recommendation"
* extension contains
    engine 1..1 and
    supportingData 1..1
* extension[engine] ^short = "Engine name and version, e.g. cicada/0.0.1"
* extension[engine].value[x] only string
* extension[supportingData] ^short = "CDSi supporting-data release, e.g. CDSi 4.65-508"
* extension[supportingData].value[x] only string

// ---------------------------------------------------------------------------
// What the evaluation worked out beyond the coded reason
// ---------------------------------------------------------------------------

Extension: EvaluationDetail
Id: evaluation-detail-ext
Title: "Evaluation Sub-step Detail"
Description: "The CDSi Chapter 6 sub-step outcomes behind a dose's evaluation: which of age, interval, conflict and vaccine choice passed, and for those that failed, which rule failed. doseStatusReason carries ten ImmDS codes; the engine knows more than that."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationEvaluation"
* extension contains
    inadvertent 0..1 and
    validAgeReason 0..1 and
    preferredInterval 0..1 and
    preferredIntervalReason 0..1 and
    allowedInterval 0..1 and
    allowedIntervalReason 0..1 and
    conflict 0..1 and
    conflictReason 0..1 and
    preferredVaccine 0..1 and
    preferredVaccineReason 0..1 and
    allowedVaccine 0..1 and
    allowedVaccineReason 0..1
* extension[inadvertent].value[x] only boolean
* extension[validAgeReason].value[x] only string
* extension[preferredInterval].value[x] only boolean
* extension[preferredIntervalReason].value[x] only string
* extension[allowedInterval].value[x] only boolean
* extension[allowedIntervalReason].value[x] only string
* extension[conflict].value[x] only boolean
* extension[conflictReason].value[x] only string
* extension[preferredVaccine].value[x] only boolean
* extension[preferredVaccineReason].value[x] only string
* extension[allowedVaccine].value[x] only boolean
* extension[allowedVaccineReason].value[x] only string

// ---------------------------------------------------------------------------
// What the forecast was built from
// ---------------------------------------------------------------------------

Extension: SeriesGroup
Id: series-group-ext
Title: "Series Group"
Description: "The series group this forecast is scoped to, per CDSi FORECASTVG-1. recommendation.series names the series; core FHIR has nowhere for the group."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationRecommendation.recommendation"
* value[x] only string

Extension: AntigenNeedingDose
Id: antigen-needing-dose-ext
Title: "Antigen Needing a Dose"
Description: "An antigen within this vaccine group that needs the forecast dose. A multi-antigen group forecasts as one recommendation, so without this a caller cannot tell whether all of MMR is due or only the measles component. Repeats, one per antigen."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationRecommendation.recommendation"
* value[x] only string

Extension: DosesRemaining
Id: doses-remaining-ext
Title: "Doses Remaining"
Description: "How many doses remain in the series after the one being forecast, or 'Recurring' where the series ends in a recurring dose. seriesDoses and doseNumber allow a reader to subtract, but no arithmetic says the series never ends."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationRecommendation.recommendation"
* value[x] only string

Extension: SeriesDetail
Id: series-detail-ext
Title: "Contributing Series Detail"
Description: "One contributing series: its own status, its own four dates, and the component dates that produced them. A vaccine group forecast reports the aggregate over several series, so without this a group covered by more than one reports a single answer for all of them, and a due date arrives with no way to see whether age or interval produced it. Repeats, one per series."
* ^context[0].type = #element
* ^context[0].expression = "ImmunizationRecommendation.recommendation"
* extension contains
    seriesName 0..1 and
    seriesGroupName 0..1 and
    seriesType 0..1 and
    status 0..1 and
    targetDoseNumber 0..1 and
    earliestDate 0..1 and
    recommendedDate 0..1 and
    pastDueDate 0..1 and
    latestDate 0..1 and
    minimumAgeDate 0..1 and
    maximumAgeDate 0..1 and
    earliestRecommendedAgeDate 0..1 and
    latestRecommendedAgeDate 0..1 and
    earliestRecommendedIntervalDate 0..1 and
    latestRecommendedIntervalDate 0..1 and
    seasonalRecommendationStartDate 0..1
* extension[seriesName].value[x] only string
* extension[seriesGroupName].value[x] only string
* extension[seriesType].value[x] only string
* extension[status].value[x] only CodeableConcept
* extension[targetDoseNumber].value[x] only positiveInt
* extension[earliestDate].value[x] only dateTime
* extension[recommendedDate].value[x] only dateTime
* extension[pastDueDate].value[x] only dateTime
* extension[latestDate].value[x] only dateTime
* extension[minimumAgeDate].value[x] only dateTime
* extension[maximumAgeDate].value[x] only dateTime
* extension[earliestRecommendedAgeDate].value[x] only dateTime
* extension[latestRecommendedAgeDate].value[x] only dateTime
* extension[earliestRecommendedIntervalDate].value[x] only dateTime
* extension[latestRecommendedIntervalDate].value[x] only dateTime
* extension[seasonalRecommendationStartDate].value[x] only dateTime
