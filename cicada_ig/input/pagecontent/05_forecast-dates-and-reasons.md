### Evaluate Conditional Skip

We've already gone through this. There's a couple of rule changes, like the context is Forecast instead of Evaluation, and we use a different reference date. Otherwise, it's the same logic we used during the Evaluation process.

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

This one actually isn't too bad either. There are just a few things to note. The first is that contraindications come in Groups or Vaccines. If a patient has a contraindication at the group level, that means any vaccine that pertains to that Antigen is contraindicated. Contraindications at the vaccine level only apply to a single Vaccine, so just because one is contraindicated doesn't mean taht they all are. Also, for the logic is slightly out of order compared to the CDC booklet, and I don't calculate any vaccine contraindications if there's already a group/antigen level contraindication.

### Determine Forecast Need

This is summarizing the information we have up to this point about each of the series and using it to decide if the patient needs another dose.
<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="7">Rules</th>
  </tr>
  <tr>
    <td>Has the patient completed all doses in the series? <br> Is there at least one target dose 'not satisfied'?</td>
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
    <td>-</td>
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

There are some of these that have been defined I'm not convinced are actually needed. That probably means I haven't figured it out completely yet.

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
