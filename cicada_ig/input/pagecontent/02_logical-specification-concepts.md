There are a number of concepts that are involved in the evaluation and prediction of immunizations. Some of these terms make logical sense, but others do not. Here's a description of some of them. Again, this was all taken from the [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/iis/cdsi/).

## Target Dose

#### A TargetDose is said to be 'unsatisfied' until a dose matches all of its required criteria. At that time, the TargetDose is incremented by one. Below is a basic example from the CDC

How a Vaccine Dose Administered Satisfies a Target Dose - TODO (add image) ![Satisfy a Target Dose](dose_satisfies_target.png)

- Target dose - this is a term that makes some intrinsic sense, and then has been used in confusing ways, at least I thought so. The target dose is the next recommended dose in a series. When we evaluate past vaccines, we check to see if a particular vaccine that was given meets the requirements of the target dose. If it does, that target dose is considered satisfied, and we move onto the next target dose.

A patient series is considered complete when the TargetDose index is >= the total number of doses in the series.

#### *As a side note, anytime you see the term 'Vaccine Dose Administered' replace it with 'Dose Given', and it makes much more sense

### Statuses

<div xmlns="http://www.w3.org/1999/xhtml">
    <table border="1">
        <caption>TABLE DOSE STATUS: recorded for each dose within each series</caption>
        <tr>
            <th>Status</th>
            <th>Meaning</th>
        </tr>
        <tr>
            <td>Extraneous</td>
            <td>Meaning the dose doesn't count towards the series, but doesn't need to be repeated (including maximum age and extra doses)</td>
        </tr>
        <tr>
            <td>Not Valid</td>
            <td>Not administered according to ACIP recommendations, does not count towards the series, will need to be repeated</td>
        </tr>
        <tr>
            <td>Sub-standard</td>
            <td>Dose had a condition (e.g., expired, sub-potent, and recall) making it invalid, will need to be repeated</td>
        </tr>
        <tr>
            <td>Valid</td>
            <td>Meets ACIP requirements for that dose</td>
        </tr>
    </table>
</div>


<div xmlns="http://www.w3.org/1999/xhtml">
    <table border="1">
        <caption>TABLE TARGET DOSE STATUSES: recorded for each dose within each series.</caption>
        <tr>
            <th>Status</th>
            <th>Meaning</th>
        </tr>
        <tr>
            <td>Not Satisfied</td>
            <td>No dose given meets the target dose requirements</td>
        </tr>
        <tr>
            <td>Satisfied</td>
            <td>A dose has been given that meets target dose requirements</td>
        </tr>
        <tr>
            <td>Skipped</td>
            <td>No dose given meets requirements, but due to age/previous doses/other reasons, this target dose does not need to be satisfied and is skipped</td>
        </tr>
    </table>
</div>


<div xmlns="http://www.w3.org/1999/xhtml">
    <table border="1">
        <caption>TABLE PATIENT SERIES STATUSES: recorded for each series within the antigen group.</caption>
        <tr>
            <th>Status</th>
            <th>Meaning</th>
        </tr>
        <tr>
            <td>Aged Out</td>
            <td>Patient exceeded the maximum age prior to completing this series</td>
        </tr>
        <tr>
            <td>Complete</td>
            <td>Patient has met all of the ACIP recommendations for this series</td>
        </tr>
        <tr>
            <td>Contraindicated</td>
            <td>Patient history indicates no more immunizations in this series should be given</td>
        </tr>
        <tr>
            <td>Immune</td>
            <td>Patient has evidence of immunity, no further immunizations are needed for this series</td>
        </tr>
        <tr>
            <td>Not Complete</td>
            <td>Patient has not met all of the ACIP recommendations for this series</td>
        </tr>
        <tr>
            <td>Not Recommended</td>
            <td>Patient's immunization history provides sufficient immunity, and further doses in this series are not recommended</td>
        </tr>
    </table>
</div>


### Selecting Supporting Data

Much of the CDSi supporting data includes effective dates and cessation dates. These are used to determine whether a particular rule or component is relevant at the time of evaluation. This is critical: before evaluating any rule (age, interval, vaccine type, etc.), you must first check whether it is relevant based on these dates.

<div xmlns="http://www.w3.org/1999/xhtml">
    <table border="1">
        <caption>TABLE Is the Logical Component Relevant?</caption>
        <tr>
            <th>Business Rule ID</th>
            <th>Business Rule</th>
        </tr>
        <tr>
            <td>RELEVANT-1</td>
            <td>A component applies to a previously given vaccination if there is no Effective Date or Cessation Date, they are both "n/a", or the date given is between the two. Default effective date: 01/01/1900. Default cessation date: 12/31/2999.</td>
        </tr>
        <tr>
            <td>RELEVANT-2</td>
            <td>A component applies to forecasting a vaccination if there is no Effective Date or Cessation Date, they are both "n/a", or the assessment date is between the two. Default effective date: 01/01/1900. Default cessation date: 12/31/2999.</td>
        </tr>
    </table>
</div>

These rules apply broadly: intervals, vaccine types, conditional skip conditions, and other supporting data components all have effective/cessation dates that must be checked before using them.

### Date Calculations

As anyone who has worked with dates can tell you, they're a huge pain in the ass. I've created a dedicated class for dealing with them called VaxDate. The CDC has stated how they expect for dates to be processed, I've reproduced this below.

<div xmlns="http://www.w3.org/1999/xhtml">
    <table border="1">
        <caption>TABLE DATE RULES</caption>
        <tr>
            <th>Business Rule</th>
            <th>Example</th>
        </tr>
        <tr>
            <td>When adding only years, <br/> month and days stay constant</td>
            <td>01/01/2000 + 3 years = 01/01/2003</td>
        </tr>
        <tr>
            <td>When adding months, <br/> day must stay constant</td>
            <td>01/01/2000 + 6 months = 07/01/2000 <br/> 11/01/2000 + 6 months = 05/01/2001</td>
        </tr>
        <tr>
            <td>When adding weeks or days, <br/> add that total number of days <br/> to the existing date</td>
            <td>01/01/2000 + 3 days = 01/04/2000 <br/> 01/01/2000 + 3 weeks = 01/22/2000 <br/> 02/01/2000 + 5 weeks = 03/07/2000 (leap year) <br/> 02/01/2001 + 5 weeks = 03/08/2001 (not a leap year)</td>
        </tr>
        <tr>
            <td>Subtracting days is just subtracting <br/> days from the date (negative addition)</td>
            <td>01/15/2000 - 4 days = 01/11/2000</td>
        </tr>
        <tr>
            <td>If the calculated date isn't a real date, <br/> it is moved to the first of the next month</td>
            <td>03/31/2000 + 6 months = 10/01/2000 (September 31 does not exist) <br/> 08/31/2000 + 6 months = 03/01/2001 (February 31 does not exist)</td>
        </tr>
        <tr>
            <td>Dates must be calculated by first adding years, <br/> then months, then weeks/days</td>
            <td>01/31/2000 + 6 months - 4 days = 07/27/2000</td>
        </tr>
    </table>
</div>


It's important to note, and it took me a while to catch onto their wording, there are ages and age dates. They are what they say they are, but I struggled with them at first. An age (or an interval) is a string description of a period of time ('4 years', '19 years - 4 days', etc). These are supposed to be added (or subtracted) to a date (usually the DOB, although sometimes the date given of the previous dose). Also, these terms probably won't all make as much sense until you work through it some more.

<div xmlns="http://www.w3.org/1999/xhtml">
    <table border="1">
        <caption>TABLE LOGICAL COMPONENT DATE RULES</caption>
        <tr>
            <th>Business Rule</th>
            <th>Calculation</th>
        </tr>
        <tr>
            <td>Maximum age date</td>
            <td>DOB + maximum age</td>
        </tr>
        <tr>
            <td>Latest recommended age date</td>
            <td>DOB + latest recommended age</td>
        </tr>
        <tr>
            <td>Earliest recommended age date</td>
            <td>DOB + earliest recommended age</td>
        </tr>
        <tr>
            <td>Minimum age date</td>
            <td>DOB + minimum age</td>
        </tr>
        <tr>
            <td>Absolute minimum age date</td>
            <td>DOB + absolute minimum age</td>
        </tr>
        <tr>
            <td>Allowable vaccine type begin age date</td>
            <td>DOB + vaccine type begin age (only applied for allowable vaccines)</td>
        </tr>
        <tr>
            <td>Allowable vaccine type end age date</td>
            <td>DOB + vaccine type end age (only applied for allowable vaccines)</td>
        </tr>
        <tr>
            <td>Contraindication begin age date</td>
            <td>DOB + contraindication begin age (for either an antigen or a vaccine)</td>
        </tr>
        <tr>
            <td>Contraindication end age date</td>
            <td>DOB + contraindication end age (for either an antigen or a vaccine)</td>
        </tr>
        <tr>
            <td>Indication begin age date</td>
            <td>DOB + indication begin age</td>
        </tr>
        <tr>
            <td>Indication end age date</td>
            <td>DOB + indication end age</td>
        </tr>
        <tr>
            <td colspan="2"><strong>Reference dose date</strong>: when evaluating intervals, sometimes this is from the previous dose, sometimes from another dose in the series (usually the first).</td>
        </tr>
        <tr>
            <td colspan="2"><strong>From Previous Dose</strong>: The reference date is calculated from the immediate previous dose if: <br/> - the interval entry's "fromPrevious" is "Y" <br/> - the previous dose has status of 'Valid' or 'Not Valid' <br/> - the current dose is not an inadvertent administration. <br/> Example: <code>"interval": [{"fromPrevious": "Y", "fromTargetDose": null, "minInt": "4 weeks"}]</code></td>
        </tr>
        <tr>
            <td colspan="2"><strong>From Target Dose</strong>: The reference date is calculated from a specific dose in the series if: <br/> - "fromPrevious" is "N" <br/> - "fromTargetDose" is not null. <br/> Example: <code>"interval": [{"fromPrevious": "N", "fromTargetDose": "1", "minInt": "6 months"}]</code></td>
        </tr>
        <tr>
            <td colspan="2"><strong>From Most Recent</strong>: The reference date is calculated from the most recent dose of the same vaccine type if: <br/> - "fromPrevious" is "N" <br/> - "fromMostRecent" is not null <br/> - the current dose is not an inadvertent administration. <br/> Example: <code>"interval": [{"fromPrevious": "N", "fromTargetDose": null, "fromMostRecent": "21; 94; 121", "absMinInt": "0 days", "minInt": "8 weeks"}]</code></td>
        </tr>
        <tr>
            <td colspan="2"><strong>From Relevant Observation</strong>: The reference date is calculated from an observation date if: <br/> - "fromPrevious" is "N" <br/> - "fromRelevantObs" is not null. <br/> Example: <code>"interval": [{"fromPrevious": "N", "fromTargetDose": null, "fromMostRecent": null, "fromRelevantObs": {"text": "Date of hematopoietic stem cell transplant", "code": "171"}, "earliestRecInt": "6 months", "latestRecInt": "12 months"}]</code></td>
        </tr>
        <tr>
            <td>Absolute minimum interval date</td>
            <td>Date reference dose was given + absolute minimum interval.</td>
        </tr>
        <tr>
            <td>Minimum interval date</td>
            <td>Date reference dose was given + minimum interval.</td>
        </tr>
        <tr>
            <td>Earliest recommended interval date</td>
            <td>Date reference dose was given + earliest recommended interval.</td>
        </tr>
        <tr>
            <td>Latest recommended interval date</td>
            <td>Date reference dose was given + latest recommended interval.</td>
        </tr>
        <tr>
            <td>Latest minimum interval date</td>
            <td>If there is more than one interval specified (such as from previous and from a target dose), whichever comes later.</td>
        </tr>
        <tr>
            <td>Conflict begin interval date</td>
            <td>Date given of the conflicting dose + live virus conflict begin interval.</td>
        </tr>
        <tr>
            <td>Conflict end interval date (valid conflicting dose)</td>
            <td>Date given of the conflicting dose + live virus <strong>MINIMUM CONFLICT</strong> end interval if the conflicting dose <strong>HAS</strong> evaluation status of valid.</td>
        </tr>
        <tr>
            <td>Conflict end interval date (invalid conflicting dose)</td>
            <td>Date given of the conflicting dose + live virus <strong>CONFLICT</strong> end interval if the conflicting dose <strong>DOES NOT HAVE</strong> evaluation status of valid.</td>
        </tr>
        <tr>
            <td>Latest conflict end interval date</td>
            <td>If there is more than one conflict interval calculated (such as from multiple previous live virus doses), whichever comes later.</td>
        </tr>
        <tr>
            <td>Preferable vaccine type begin age date</td>
            <td>DOB + vaccine type begin age of a preferable vaccine.</td>
        </tr>
        <tr>
            <td>Conditional skip begin age date</td>
            <td>DOB + begin age of the conditional skip condition.</td>
        </tr>
        <tr>
            <td>Conditional skip end age date</td>
            <td>DOB + end age of the conditional skip condition.</td>
        </tr>
        <tr>
            <td>Conditional skip interval date</td>
            <td>Date given of the immediate previous dose + interval of the conditional skip condition.</td>
        </tr>
    </table>
</div>

