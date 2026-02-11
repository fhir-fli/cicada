# Logical Specification Concepts - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Logical Specification Concepts**

## Logical Specification Concepts

There are a number of concepts that are involved in the evaluation and prediction of immunizations. Some of these terms make logical sense, but others do not. Here's a description of some of them. Again, this was all taken from the [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/iis/cdsi/).

## Target Dose

#### A TargetDose is said to be 'unsatisfied' until a dose matches all of its required criteria. At that time, the TargetDose is incremented by one. Below is a basic example from the CDC

How a Vaccine Dose Administered Satisfies a Target Dose - TODO (add image) ![](dose_satisfies_target.png)

* Target dose - this is a term that makes some intrinsic sense, and then has been used in confusing ways, at least I thought so. The target dose is the next recommended dose in a series. When we evaluate past vaccines, we check to see if a particular vaccine that was given meets the requirements of the target dose. If it does, that target dose is considered satisfied, and we move onto the next target dose.

A patient series is considered complete when the TargetDose index is >= the total number of doses in the series.

#### *As a side note, anytime you see the term 'Vaccine Dose Administered' replace it with 'Dose Given', and it makes much more sense

### Statuses

* Status: Extraneous
  * Meaning: Meaning the dose doesn't count towards the series, but doesn't need to be repeated (including maximum age and extra doses)
* Status: Not Valid
  * Meaning: Not administered according to ACIP recommendations, does not count towards the series, will need to be repeated
* Status: Sub-standard
  * Meaning: Dose had a condition (e.g., expired, sub-potent, and recall) making it invalid, will need to be repeated
* Status: Valid
  * Meaning: Meets ACIP requirements for that dose

* Status: Not Satisfied
  * Meaning: No dose given meets the target dose requirements
* Status: Satisfied
  * Meaning: A dose has been given that meets target dose requirements
* Status: Skipped
  * Meaning: No dose given meets requirements, but due to age/previous doses/other reasons, this target dose does not need to be satisfied and is skipped

* Status: Aged Out
  * Meaning: Patient exceeded the maximum age prior to completing this series
* Status: Complete
  * Meaning: Patient has met all of the ACIP recommendations for this series
* Status: Contraindicated
  * Meaning: Patient history indicates no more immunizations in this series should be given
* Status: Immune
  * Meaning: Patient has evidence of immunity, no further immunizations are needed for this series
* Status: Not Complete
  * Meaning: Patient has not met all of the ACIP recommendations for this series
* Status: Not Recommended
  * Meaning: Patient's immunization history provides sufficient immunity, and further doses in this series are not recommended

### Selecting Supporting Data

Much of the CDSi supporting data includes effective dates and cessation dates. These are used to determine whether a particular rule or component is relevant at the time of evaluation. This is critical: before evaluating any rule (age, interval, vaccine type, etc.), you must first check whether it is relevant based on these dates.

* Business Rule ID: RELEVANT-1
  * Business Rule: A component applies to a previously given vaccination if there is no Effective Date or Cessation Date, they are both "n/a", or the date given is between the two. Default effective date: 01/01/1900. Default cessation date: 12/31/2999.
* Business Rule ID: RELEVANT-2
  * Business Rule: A component applies to forecasting a vaccination if there is no Effective Date or Cessation Date, they are both "n/a", or the assessment date is between the two. Default effective date: 01/01/1900. Default cessation date: 12/31/2999.

These rules apply broadly: intervals, vaccine types, conditional skip conditions, and other supporting data components all have effective/cessation dates that must be checked before using them.

### Date Calculations

As anyone who has worked with dates can tell you, they're a huge pain in the ass. I've created a dedicated class for dealing with them called VaxDate. The CDC has stated how they expect for dates to be processed, I've reproduced this below.

* Business Rule: When adding only years,month and days stay constant
  * Example: 01/01/2000 + 3 years = 01/01/2003
* Business Rule: When adding months,day must stay constant
  * Example: 01/01/2000 + 6 months = 07/01/200011/01/2000 + 6 months = 05/01/2001
* Business Rule: When adding weeks or days,add that total number of daysto the existing date
  * Example: 01/01/2000 + 3 days = 01/04/200001/01/2000 + 3 weeks = 01/22/200002/01/2000 + 5 weeks = 03/07/2000 (leap year)02/01/2001 + 5 weeks = 03/08/2001 (not a leap year)
* Business Rule: Subtracting days is just subtractingdays from the date (negative addition)
  * Example: 01/15/2000 - 4 days = 01/11/2000
* Business Rule: If the calculated date isn't a real date,it is moved to the first of the next month
  * Example: 03/31/2000 + 6 months = 10/01/2000 (September 31 does not exist)08/31/2000 + 6 months = 03/01/2001 (February 31 does not exist)
* Business Rule: Dates must be calculated by first adding years,then months, then weeks/days
  * Example: 01/31/2000 + 6 months - 4 days = 07/27/2000

It's important to note, and it took me a while to catch onto their wording, there are ages and age dates. They are what they say they are, but I struggled with them at first. An age (or an interval) is a string description of a period of time ('4 years', '19 years - 4 days', etc). These are supposed to be added (or subtracted) to a date (usually the DOB, although sometimes the date given of the previous dose). Also, these terms probably won't all make as much sense until you work through it some more.

* Business Rule: Maximum age date
  * Calculation: DOB + maximum age
* Business Rule: Latest recommended age date
  * Calculation: DOB + latest recommended age
* Business Rule: Earliest recommended age date
  * Calculation: DOB + earliest recommended age
* Business Rule: Minimum age date
  * Calculation: DOB + minimum age
* Business Rule: Absolute minimum age date
  * Calculation: DOB + absolute minimum age
* Business Rule: Allowable vaccine type begin age date
  * Calculation: DOB + vaccine type begin age (only applied for allowable vaccines)
* Business Rule: Allowable vaccine type end age date
  * Calculation: DOB + vaccine type end age (only applied for allowable vaccines)
* Business Rule: Contraindication begin age date
  * Calculation: DOB + contraindication begin age (for either an antigen or a vaccine)
* Business Rule: Contraindication end age date
  * Calculation: DOB + contraindication end age (for either an antigen or a vaccine)
* Business Rule: Indication begin age date
  * Calculation: DOB + indication begin age
* Business Rule: Indication end age date
  * Calculation: DOB + indication end age
* Business Rule: **Reference dose date**: when evaluating intervals, sometimes this is from the previous dose, sometimes from another dose in the series (usually the first).
* Business Rule: **From Previous Dose**: The reference date is calculated from the immediate previous dose if:- the interval entry's "fromPrevious" is "Y"- the previous dose has status of 'Valid' or 'Not Valid'- the current dose is not an inadvertent administration.Example:`"interval": [{"fromPrevious": "Y", "fromTargetDose": null, "minInt": "4 weeks"}]`
* Business Rule: **From Target Dose**: The reference date is calculated from a specific dose in the series if:- "fromPrevious" is "N"- "fromTargetDose" is not null.Example:`"interval": [{"fromPrevious": "N", "fromTargetDose": "1", "minInt": "6 months"}]`
* Business Rule: **From Most Recent**: The reference date is calculated from the most recent dose of the same vaccine type if:- "fromPrevious" is "N"- "fromMostRecent" is not null- the current dose is not an inadvertent administration.Example:`"interval": [{"fromPrevious": "N", "fromTargetDose": null, "fromMostRecent": "21; 94; 121", "absMinInt": "0 days", "minInt": "8 weeks"}]`
* Business Rule: **From Relevant Observation**: The reference date is calculated from an observation date if:- "fromPrevious" is "N"- "fromRelevantObs" is not null.Example:`"interval": [{"fromPrevious": "N", "fromTargetDose": null, "fromMostRecent": null, "fromRelevantObs": {"text": "Date of hematopoietic stem cell transplant", "code": "171"}, "earliestRecInt": "6 months", "latestRecInt": "12 months"}]`
* Business Rule: Absolute minimum interval date
  * Calculation: Date reference dose was given + absolute minimum interval.
* Business Rule: Minimum interval date
  * Calculation: Date reference dose was given + minimum interval.
* Business Rule: Earliest recommended interval date
  * Calculation: Date reference dose was given + earliest recommended interval.
* Business Rule: Latest recommended interval date
  * Calculation: Date reference dose was given + latest recommended interval.
* Business Rule: Latest minimum interval date
  * Calculation: If there is more than one interval specified (such as from previous and from a target dose), whichever comes later.
* Business Rule: Conflict begin interval date
  * Calculation: Date given of the conflicting dose + live virus conflict begin interval.
* Business Rule: Conflict end interval date (valid conflicting dose)
  * Calculation: Date given of the conflicting dose + live virus**MINIMUM CONFLICT**end interval if the conflicting dose**HAS**evaluation status of valid.
* Business Rule: Conflict end interval date (invalid conflicting dose)
  * Calculation: Date given of the conflicting dose + live virus**CONFLICT**end interval if the conflicting dose**DOES NOT HAVE**evaluation status of valid.
* Business Rule: Latest conflict end interval date
  * Calculation: If there is more than one conflict interval calculated (such as from multiple previous live virus doses), whichever comes later.
* Business Rule: Preferable vaccine type begin age date
  * Calculation: DOB + vaccine type begin age of a preferable vaccine.
* Business Rule: Conditional skip begin age date
  * Calculation: DOB + begin age of the conditional skip condition.
* Business Rule: Conditional skip end age date
  * Calculation: DOB + end age of the conditional skip condition.
* Business Rule: Conditional skip interval date
  * Calculation: Date given of the immediate previous dose + interval of the conditional skip condition.

