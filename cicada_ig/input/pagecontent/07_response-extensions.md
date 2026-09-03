### What cicada returns beyond the standard

The `$immds-forecast` response is a `Parameters` resource holding the ImmDS
operation's own output — `evaluation` and `recommendation` — plus one
`immunization` parameter per administered dose, so the literal
`Immunization/<id>` references in the evaluations resolve inside a response with
no server behind it.

The engine works out more than R4 and the US ImmDS IG have elements for. None of
what follows changes a dose's validity or a series' status; each says something
the standard resources cannot.

#### On the evaluation

| Extension | What it carries |
|---|---|
| [Target Dose Status](StructureDefinition-target-dose-status-ext.html) | Whether the target dose this dose was evaluated against ended up satisfied, not satisfied or skipped. R4 carries only `doseNumber`, derived from it, so a skipped target dose and a satisfied one otherwise read the same. |
| [Evaluation Sub-step Detail](StructureDefinition-evaluation-detail-ext.html) | The Chapter 6 sub-step outcomes behind the coded reason: age, both interval checks, conflict, and both vaccine checks, with the rule that failed. |
| [Engine and Supporting Data Version](StructureDefinition-engine-version-ext.html) | The engine build and the CDSi release that produced the answer. |

`doseStatusReason` carries **every** reason the evaluation found, not one. CDSi
Table 6-31 sets the status "with evaluation reasons", plural, and R4 types the
element `0..*`.

#### On each recommendation

| Extension | What it carries |
|---|---|
| [Series Type](StructureDefinition-series-type-ext.html) | Whether this recommendation came from the standard or the risk series group. |
| [Series Group](StructureDefinition-series-group-ext.html) | The series group the forecast is scoped to, per FORECASTVG-1. |
| [Antigen Needing a Dose](StructureDefinition-antigen-needing-dose-ext.html) | Which antigens of a multi-antigen group actually need the dose. |
| [Doses Remaining](StructureDefinition-doses-remaining-ext.html) | How many doses are left, or `Recurring` where the series never ends. |
| [Contributing Series Detail](StructureDefinition-series-detail-ext.html) | Per contributing series: its own status, its own four dates, and the component dates behind them — minimum and maximum age, the recommended age and interval windows, and the seasonal start. |
| [Engine and Supporting Data Version](StructureDefinition-engine-version-ext.html) | As above. |

`vaccineCode` carries the group code first and then each specific product that
satisfies the next target dose. `contraindicatedVaccineCode` carries the
products a contraindication ruled out. `description` carries the series'
administrative guidance from the CDSi supporting data.

#### Forecast reasons

`forecastReason` uses the ImmDS ForecastReason code system where a concept
exists, and the [Cicada Forecast Reason](CodeSystem-forecast-reason.html) code
system otherwise. The ImmDS binding is example strength, so the four reasons
ImmDS has no concept for — evidence of immunity, contraindication, unable to
finish before the maximum age, below the minimum age to start — travel as a
second coding rather than being dropped.

Two codes deserve a note.

**Complete for the season** is a deliberate deviation from CDSi, which has no
such reason: its only seasonal reason is *past seasonal recommendation end
date*. An adult who has had this year's influenza dose returns Complete, which
without this is indistinguishable from complete for good. ACIP defines influenza
and RSV recommendations by season, so the distinction is real. The series status
is unchanged.

**Recommended by shared clinical decision-making** marks a series ACIP
recommends by discussion rather than routinely, so an alert or a quality measure
does not read it as a care gap. It is taken from CDC's own marking in the series
name — four MenB and two COVID-19 series — and, for HPV, from the 27–45 year
band CDC states in that series' guidance. Series whose guidance mentions shared
decision-making for only part of their range are **not** marked, because they
are routine for the rest and the supporting data has no scoped attribute to
read.

#### Records that cannot be evaluated

CDSi evaluates a *vaccine dose administered*, and defines the assessment date as
the current date. A dose dated after the assessment date has not been
administered; a dose dated before birth was not administered to this patient.
Neither can be evaluated, and neither is a clinical verdict, so neither becomes
an invalid dose. They are excluded from evaluation and forecasting and reported
in an `OperationOutcome` returned as an `outcome` parameter, coded from the
[Cicada Data Integrity](CodeSystem-data-integrity.html) code system, carrying
both conflicting dates and what to check. The `Immunization` still returns in
its own parameter, so nothing is dropped silently.
