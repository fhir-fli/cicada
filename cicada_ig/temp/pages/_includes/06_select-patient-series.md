### A quick note on Series Groups

Before diving in, this section is going to start using the Series Group as part of the logic. There are Vaccine Groups (MMR, Tdap, etc), which are broken down into antigens. Each antigen has multiple series that apply to it. However, these series can be grouped together. At the beginning of each series, it looks something like:

```json
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

2. **Minimum age**: The patient must meet the starting age requirements. Each series has a `minAgeToStart` field.

3. **Maximum age**: The date administered of the first valid dose in the series must have been given before the maximum age to start date. If this is the first dose (no doses given yet), then the patient must be younger than the maximum age to start date.

### Identify One Prioritized Patient Series

Before scoring, we check if there's an obvious winner. If there is, we can skip the whole scoring process for that series group.

<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="6">Rules</th>
  </tr>
  <tr>
    <td>There are no scorable series for the antigen, but 1 relevant series is identified as the default</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>There is only 1 scorable series for that antigen</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>There is only 1 complete series for that antigen</td>
    <td>-</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>There is only 1 in-process series and no complete series for the antigen</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>There are no series with any valid doses, but one of the series is the default</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <th>Which series should be prioritized?</th>
    <td>Default series</td>
    <td>Lone scorable series</td>
    <td>Lone complete series</td>
    <td>Lone in-process series</td>
    <td>Default series</td>
    <td>None: proceed to scoring</td>
  </tr>
</table>

Some definitions:
- A **complete** series has a status of 'complete' (all target doses satisfied)
- The **default** series is the one with `"defaultSeries": "Yes"`
- An **in-process** series has at least one target dose that has been satisfied, but the series is not yet complete

If a prioritized series is found, that's the winner for that series group, and we don't need to score the others (for that group). If there are other series groups for the antigen, we do still evaluate those.

### Classify Scorable Patient Series

If there isn't a prioritized series, we need to score them. But first, we classify them to determine which scoring rules to use.

<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="3">Rules</th>
  </tr>
  <tr>
    <td>&ge; 2 complete series?</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>&ge; 2 in-process series, and 0 complete series?</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Do all series have 0 valid doses?</td>
    <td>-</td>
    <td>No</td>
    <td>Yes</td>
  </tr>
  <tr>
    <th>Outcomes</th>
    <td>Score only the complete series</td>
    <td>Score only the in-process series</td>
    <td>Score all series</td>
  </tr>
</table>

### Score Complete Patient Series

For each scoring criterion, the math works the same way:
- If **only 1** scorable series meets the condition, it gets **positive** points
- If **2 or more** meet the condition, none get awarded extra points (but they don't lose any either)
- If a series **does not** meet the condition, it gets **negative** points

<table border="1">
  <tr>
    <th>Conditions</th>
    <th>True for only 1 scorable series</th>
    <th>True for &ge; 2 scorable series</th>
    <th>Not true for scorable series</th>
  </tr>
  <tr>
    <td>Scorable series has the most valid doses</td>
    <td>+1</td>
    <td>-</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>Scorable series is a product series and has all valid doses</td>
    <td>+1</td>
    <td>-</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>Scorable series is earliest to complete</td>
    <td>+2</td>
    <td>+1</td>
    <td>-1</td>
  </tr>
</table>

Note that "earliest to complete" gives +1 even when tied (unlike the other criteria). This gives extra weight to finishing sooner.

### Score In-Process Patient Series

<table border="1">
  <tr>
    <th>Conditions</th>
    <th>True for only 1 scorable series</th>
    <th>True for &ge; 2 scorable series</th>
    <th>Not true for scorable series</th>
  </tr>
  <tr>
    <td>Scorable series is a product series and has all valid doses</td>
    <td>+2</td>
    <td>-</td>
    <td>-2</td>
  </tr>
  <tr>
    <td>Scorable series is completeable (patient can still finish it)</td>
    <td>+3</td>
    <td>-</td>
    <td>-3</td>
  </tr>
  <tr>
    <td>Scorable series has the most valid doses</td>
    <td>+2</td>
    <td>-</td>
    <td>-2</td>
  </tr>
  <tr>
    <td>Scorable series is closest to completion (fewest remaining doses)</td>
    <td>+2</td>
    <td>-</td>
    <td>-2</td>
  </tr>
  <tr>
    <td>Scorable series can finish earliest</td>
    <td>+1</td>
    <td>-</td>
    <td>-1</td>
  </tr>
</table>

"Completeable" is the heaviest weight here (+3/-3), because if a series can't be completed, there's no point recommending it.

### Score No Valid Doses

When no series has any valid doses yet, the scoring is different:

<table border="1">
  <tr>
    <th>Conditions</th>
    <th>True for only 1 scorable series</th>
    <th>True for &ge; 2 scorable series</th>
    <th>Not true for scorable series</th>
  </tr>
  <tr>
    <td>Scorable series can start earliest</td>
    <td>+1</td>
    <td>-</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>Scorable series is completeable</td>
    <td>+1</td>
    <td>-</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>Scorable series is a product patient series</td>
    <td>-1</td>
    <td>-</td>
    <td>+1</td>
  </tr>
</table>

Note that product series scoring is **inverted** here: being a product series is a **disadvantage** when there are no valid doses. This is because product series are more restrictive (they require a specific product/manufacturer), and when starting fresh, a more flexible series is preferred.

### Select the Prioritized Patient Series

This one is easy. After all the scoring is done, the series with the highest score wins. If there's a tie, the series with the higher preference value (from `seriesPreference` in the supporting data) takes priority.

The winning series becomes the **prioritized patient series** for that series group. Its forecast is what gets recommended to the patient for that antigen.
