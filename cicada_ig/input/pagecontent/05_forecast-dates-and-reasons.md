### Evaluate Conditional Skip

We've already gone through this. There are a couple of rule changes: the context is "Forecast" instead of "Evaluation", and we use a different reference date. During forecasting, the reference date is the later of: the assessment date, and the earliest date the next dose in the series can be given. Otherwise, it's the same logic we used during the Evaluation process.

### Determine Evidence of Immunity

We use this information to determine if the patient has evidence of immunity. It's important to note, the *guidelineCode* and *exclusionCode* are the same as *observationCode*. Why they decided to give them different names is beyond me. Anyway, we use these codes to see if the patient has any conditions that apply for immunity.

<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="5">Rules</th>
  </tr>
  <tr>
    <td>Does the patient have a condition that's identified in one of the guidelineCodes for that series?</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Is the patient's DOB &lt; immunity birth date?</td>
    <td>-</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Does the patient have an exclusion condition?</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is the patient's country of birth the same as the birthCountry?</td>
    <td>-</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
  </tr>
  <tr>
    <th>Evidence of Immunity?</th>
    <td>Yes</td>
    <td>No</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
  </tr>
</table>


I think there are two things to note about this logic (please let me know if you disagree with it). Also, the order here is important, but aligns with the CDC guidelines. The first is that if the patient has **ANY** immunity defined condition, then they have evidence of immunity. Otherwise, they **MUST** have been born prior to the defined birthdate. The immunity exclusion criteria must then be reviewed. If the patient has **ANY** of these criteria, then they **DO NOT** have evidence of immunity. Lastly, they must be born in the designated country.

### Determine Contraindications

Contraindications come in two flavors: **group-level** and **vaccine-level**.

- **Group-level contraindications** apply to the entire antigen. If the patient has a condition (mapped via the observation crosswalk to a CDSi observation code) that matches a group contraindication for the antigen, then the entire antigen is contraindicated. No more vaccines for that antigen should be given.

- **Vaccine-level contraindications** apply only to a specific vaccine type (CVX). If the patient has a matching condition, only that specific vaccine is contraindicated, but other vaccines for the same antigen may still be given.

The logic is: for each contraindication in the supporting data, check if the patient has a matching observation code. If so, check if the assessment date falls within the contraindication's begin and end age dates (DOB + begin age, DOB + end age). If both are true, the contraindication applies.

If there's already a group-level contraindication, there's no need to check individual vaccine-level contraindications for that antigen.

### Determine Forecast Need

This is summarizing the information we have up to this point about each of the series and using it to decide if the patient needs another dose.
<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="7">Rules</th>
  </tr>
  <tr>
    <td>Has the patient completed all doses in the series? <br/> Is there at least one target dose 'not satisfied'?</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is there at least one dose with a status of satisfied?</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is there evidence of immunity?</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
    <td>Yes</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is the series contraindicated?</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Yes</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is the assessment date &lt; maximum age date?</td>
    <td>Yes</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>No</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is the assessment date &lt;= seasonal recommendation end date?</td>
    <td>Yes</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Needs another dose?</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <th>Series Status</th>
    <td>'not complete'</td>
    <td>'complete'</td>
    <td>'not recommended'</td>
    <td>'immune'</td>
    <td>'contraindicated'</td>
    <td>'aged out'</td>
    <td>'not complete'</td>
  </tr>
  <tr>
    <th>Forecast Reason</th>
    <td>-</td>
    <td>'series is complete'</td>
    <td>'not recommended due to past immunization hx'</td>
    <td>'patient has evidence of immunity'</td>
    <td>'patient has contraindication'</td>
    <td>'patient has exceeded maximum age'</td>
    <td>'past seasonal recommendation end date'</td>
  </tr>
</table>

Most of these are straight forward except the final one. Also, I chose to do my logic in a slightly different order to the official questions. I start out asking if someone is immune. If they are, nothing else matters, they're finished that series. After, I look if it's contraindicated. If it is, they shouldn't get any more. Then I go through the rest of the branching logic. As I said, it's only the final one that I have trouble with. Mostly because some of what they're asking (such as intervals and ages) are lists, and it wasn't clear to me if I choose the first one in the list, or go through and test it for each entry in the list. I went with the latter.

### Generate Forecast Dates and Recommended Vaccines

This is where we determine when the next dose, if any, for that particular antigen/series is needed and when it is due. So far we've been through each antigen that could be applicable to the patient. Within each antigen we've evaluated all of the possible series that exist, and decided which of those were appropriate for the patient. We evaluated each of the doses given to the patient against each series to see how many doses are valid within the constraints of that series. Just above we decided if the patient needs another dose in that series. If they do, we create a recommended dose for that series.

<table border="1">
  <tr>
    <th>Attribute Type</th>
    <th>Attribute Name</th>
    <th>Assumed Value if Empty</th>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Minimum Age Date</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Earliest Recommended Age Date</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Latest Recommended Age Date</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Maximum Age Date</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Minimum Interval Date(s)</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Earliest Recommended Interval Date(s)</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Latest Recommended Interval Date(s)</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Calculated date</td>
    <td>Latest Conflict End Interval Date</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Supporting Data (Seasonal Recommendation)</td>
    <td>Seasonal Recommendation Start Date</td>
    <td>01/01/1900</td>
  </tr>
  <tr>
    <td>Supporting Data (Preferable Vaccine)</td>
    <td>Vaccine Type (CVX)</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Supporting Data (Preferable Vaccine)</td>
    <td>Forecast Vaccine Type Flag</td>
    <td>N</td>
  </tr>
</table>

From these calculated dates, the key forecast dates are derived:

- **Earliest Date**: the **latest** of: minimum age date, latest minimum interval date, latest conflict end interval date, seasonal recommendation start date, and latest inadvertent administration date. This is the soonest the next dose can possibly be given.

- **Unadjusted Recommended Date**: the earliest recommended age date. If null, use the latest of all earliest recommended interval dates. If still null, use the earliest date.

- **Unadjusted Past Due Date**: the latest recommended age date minus 1 day. If null, use the latest of all latest recommended interval dates minus 1 day. If still null, this date is null.

- **Latest Date**: if maximum age date is null, this is null. Otherwise, maximum age date minus 1 day.

- **Adjusted Recommended Date**: whichever comes later between the earliest date and the unadjusted recommended date.

- **Adjusted Past Due Date**: if the unadjusted past due date is not present, this is null. Otherwise, whichever comes later between the earliest date and the unadjusted past due date.

### Validate Recommendation

Once the forecast dates are generated, they need to be validated.

**Can the target dose be skipped?** If the conditional skip logic (using the "Forecast" context and the forecast reference date) says the dose can be skipped, then we skip to the next target dose and generate forecast dates for that one instead.

**Is the patient aged out?** If the earliest date is later than or equal to the latest date in the series, it means the patient will not be able to receive the dose before aging out. In this case:
- Patient series status is 'aged out'
- Forecast reason is 'patient is unable to finish the series prior to the maximum age'
- All forecast dates (earliest, adjusted recommended, adjusted past due, latest) are cleared
