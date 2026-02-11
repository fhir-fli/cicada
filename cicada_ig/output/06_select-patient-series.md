# Select Patient Series - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Select Patient Series**

## Select Patient Series

### A quick note on Series Groups

Before diving in, this section is going to start using the Series Group as part of the logic. There are Vaccine Groups (MMR, Tdap, etc), which are broken down into antigens. Each antigen has multiple series that apply to it. However, these series can be grouped together. At the beginning of each series, it looks something like:

```
{
    "seriesName": "HepA 2-dose series",
    "targetDisease": "HepA",
    "seriesVaccineGroup": "HepA",
    "seriesType": "Standard",
    "equivalentSeriesGroups": "2",
    "defaultSeries": "Yes",
    "productPath": "No",
    "seriesGroupName": "Standard",
    "seriesGroup": "1",
    "seriesPriority": "A",
    "seriesPreference": "1",
    "minAgeToStart": null,
    "maxAgeToStart": "19 years"
}

```

The `seriesGroup` is what we'll be working with. Series within the same group are compared against each other during scoring.

### Pre-filter Patient Series

A relevant patient series (one we determined was applicable to the patient earlier) must be considered a **scorable** patient series if **all** of the following are true:

1. **Priority**: The series must have the same or greater priority as other series being considered. Each series has a `seriesPriority` field marked with letters ("A", "B", "C", etc). If any possible series has an "A" seriesPriority, then only series with "A" priority are considered. If the highest is "B", then only "B" series are considered, etc.
1. **Minimum age**: The patient must meet the starting age requirements. Each series has a `minAgeToStart` field.
1. **Maximum age**: The date administered of the first valid dose in the series must have been given before the maximum age to start date. If this is the first dose (no doses given yet), then the patient must be younger than the maximum age to start date.

### Identify One Prioritized Patient Series

Before scoring, we check if there's an obvious winner. If there is, we can skip the whole scoring process for that series group.

* Conditions: There are no scorable series for the antigen, but 1 relevant series is identified as the default
  * Rules: Yes
  * ?: No
  * ?: No
  * ?: No
  * ?: No
  * ?: No
* Conditions: There is only 1 scorable series for that antigen
  * Rules: -
  * ?: Yes
  * ?: No
  * ?: No
  * ?: No
  * ?: No
* Conditions: There is only 1 complete series for that antigen
  * Rules: -
  * ?: -
  * ?: Yes
  * ?: No
  * ?: No
  * ?: No
* Conditions: There is only 1 in-process series and no complete series for the antigen
  * Rules: -
  * ?: -
  * ?: -
  * ?: Yes
  * ?: No
  * ?: No
* Conditions: There are no series with any valid doses, but one of the series is the default
  * Rules: -
  * ?: -
  * ?: -
  * ?: -
  * ?: Yes
  * ?: No
* Conditions: Which series should be prioritized?
  * Rules: Default series
  * ?: Lone scorable series
  * ?: Lone complete series
  * ?: Lone in-process series
  * ?: Default series
  * ?: None: proceed to scoring

Some definitions:

* A **complete** series has a status of 'complete' (all target doses satisfied)
* The **default** series is the one with `"defaultSeries": "Yes"`
* An **in-process** series has at least one target dose that has been satisfied, but the series is not yet complete

If a prioritized series is found, that's the winner for that series group, and we don't need to score the others (for that group). If there are other series groups for the antigen, we do still evaluate those.

### Classify Scorable Patient Series

If there isn't a prioritized series, we need to score them. But first, we classify them to determine which scoring rules to use.

* Conditions: ≥ 2 complete series?
  * Rules: Yes
  * ?: No
  * ?: No
* Conditions: ≥ 2 in-process series, and 0 complete series?
  * Rules: -
  * ?: Yes
  * ?: No
* Conditions: Do all series have 0 valid doses?
  * Rules: -
  * ?: No
  * ?: Yes
* Conditions: Outcomes
  * Rules: Score only the complete series
  * ?: Score only the in-process series
  * ?: Score all series

### Score Complete Patient Series

For each scoring criterion, the math works the same way:

* If **only 1** scorable series meets the condition, it gets **positive** points
* If **2 or more** meet the condition, none get awarded extra points (but they don't lose any either)
* If a series **does not** meet the condition, it gets **negative** points

* Conditions: Scorable series has the most valid doses
  * True for only 1 scorable series: +1
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -1
* Conditions: Scorable series is a product series and has all valid doses
  * True for only 1 scorable series: +1
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -1
* Conditions: Scorable series is earliest to complete
  * True for only 1 scorable series: +2
  * True for ≥ 2 scorable series: +1
  * Not true for scorable series: -1

Note that "earliest to complete" gives +1 even when tied (unlike the other criteria). This gives extra weight to finishing sooner.

### Score In-Process Patient Series

* Conditions: Scorable series is a product series and has all valid doses
  * True for only 1 scorable series: +2
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -2
* Conditions: Scorable series is completeable (patient can still finish it)
  * True for only 1 scorable series: +3
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -3
* Conditions: Scorable series has the most valid doses
  * True for only 1 scorable series: +2
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -2
* Conditions: Scorable series is closest to completion (fewest remaining doses)
  * True for only 1 scorable series: +2
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -2
* Conditions: Scorable series can finish earliest
  * True for only 1 scorable series: +1
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -1

"Completeable" is the heaviest weight here (+3/-3), because if a series can't be completed, there's no point recommending it.

### Score No Valid Doses

When no series has any valid doses yet, the scoring is different:

* Conditions: Scorable series can start earliest
  * True for only 1 scorable series: +1
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -1
* Conditions: Scorable series is completeable
  * True for only 1 scorable series: +1
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: -1
* Conditions: Scorable series is a product patient series
  * True for only 1 scorable series: -1
  * True for ≥ 2 scorable series: -
  * Not true for scorable series: +1

Note that product series scoring is **inverted** here: being a product series is a **disadvantage** when there are no valid doses. This is because product series are more restrictive (they require a specific product/manufacturer), and when starting fresh, a more flexible series is preferred.

### Select the Prioritized Patient Series

This one is easy. After all the scoring is done, the series with the highest score wins. If there's a tie, the series with the higher preference value (from `seriesPreference` in the supporting data) takes priority.

The winning series becomes the **prioritized patient series** for that series group. Its forecast is what gets recommended to the patient for that antigen.

