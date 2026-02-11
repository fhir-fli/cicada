# Evaluate Vaccine Dose Administered - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Evaluate Vaccine Dose Administered**

## Evaluate Vaccine Dose Administered

Table of Evaluation Process Steps

* Activity: Evaluate Dose Administered Condition
  * Goal: Determine if this dose is expired or subpotent (some reason it shouldn't be evaluated)
* Activity: Evaluate Conditional Skip
  * Goal: The goal of this step is to determine if the target dose can be skipped due to a patient's age or immunization history
* Activity: Evaluate For Inadvertent Vaccine
  * Goal: The goal of this step is to determine if the vaccine dose administered was an inadvertent administration due to the vaccine type that was administered.
* Activity: Evaluate Age
  * Goal: Was it given at the appropriate age
* Activity: Evaluate Preferable Interval
  * Goal: Was it given within the preferred interval from the last dose
* Activity: Evaluate Allowable Interval
  * Goal: Was it given within the allowed interval from the last dose
* Activity: Evaluate Live Virus Conflict
  * Goal: Is there a conflict between this dose and any live virus vaccines
* Activity: Evaluate For Preferable Vaccine
  * Goal: If there are preferred vaccines available for this dose, is it one of them
* Activity: Evaluate For Allowable Vaccine
  * Goal: Is it an allowed vaccine for this dose
* Activity: Satisfy Target Dose
  * Goal: Is the target dose satisfied

### Evaluate Dose Administered Condition

This one is pretty easy. Was the vaccine expired before it was given? Is the vaccine subpotent for some reason? If the answer is yes to either of these, the dose can't be evaluated. Of note, we actually do this slightly earlier when we're first sorting the vaccines. When we're first assigning the vaccine doses given to the individual antigens, we bucket them at that point as either subpar or available for evaluation. This just saves us the trouble of looking at them as we evaluate each series, and we only look at the valid ones.

Also, a brief note on how FHIR handles this. With the Immunization resource there is a field where it notes the `expirationDate` of the vaccine, which can be compared to the `occurrence[x]` which is the date the vaccine was given. There is also a boolean field, `isSubpotent` that indicates whether or not it is. There is also a list of CodeableConcepts in a field `subpotentReason` that can list why. The CDC manual lists examples such as sub-potent and recall, FHIR uses an [Immunization Subpotent Reason ValueSet](https://build.fhir.org/valueset-immunization-subpotent-reason.html) that contains partialdose, coldchainbreak, recall, adversestorage, and expired.

### Evaluate Skip Condition

Can the dose be skipped? Not the most complicated logic, but some of the terms, as usual, I found unclear. But the idea behind this is that there are times when you can skip a dose. This may be part of catch-up dosing, or the patient may have aged out. There is also skip logic, at both the set level and the condition level. Sets are lists of conditions. For a list of Conditions, we may have "AND" logic or "OR" logic. This is about what you'd expect. "AND" means that all of the listed conditions have to be true for that Set to be true. "OR" means that if any of the conditions are true, that set is true. Likewise, while it rarely happens, you can have set logic, also "AND" or "OR" with similar specifications. Now, the types of conditions that can define a skip come in 5 choices, so let's look at all the options, shall we?

**Important note on recurring doses**: if a target dose is marked as a recurring dose (like the annual Influenza dose), conditional skip should NOT be evaluated during the evaluation phase. The skip logic for recurring doses is only used during forecasting, not when evaluating past doses.

#### CONDITIONAL AGE

* Conditions: Is the Conditional Skip End Age Date > Conditional Skip Reference Date >= Conditional Skip Begin Age Date?
  * Rules: Yes
  * ?: No
* Conditions: Outcomes
  * Rules: Yes, the condition is met
  * ?: No, the condition is not met

You should be given a start and end age for this one. I think what confused me about this one is that you need a reference date. Since you're evaluating each targetDose in a series, there's not exactly a reference date. So instead, what you do is take the next dose you're evaluating and use the date administered as the reference date. If that lets you skip, you can skip that targetDose and use THE SAME dose administered that you were just looking at to see if it satisfies the next targetDose.

Still confused? Try this. Dragonpox is a 3-dose vaccine series. Johnny got a dragonpox vaccine when he was 3 years old. For the first dose in the series, there is an age skip condition, with a start age of 2 years and end age of 4 years. Since Johnny's first dose falls within this period, we can mark the 1st targetDose in the series as skipped. Then, using that same vaccine that Johnny got at 3 years old, we can see if that dose satisfies the 2nd targetDose in the series.

#### CONDITIONAL TYPE OF COMPLETED SERIES

* Conditions: Does the Conditional Skip Series Group identify a Series Group with at least one series with a status of 'Complete'
  * Rules: Yes
  * : No
* Conditions: Outcomes
  * Rules: Yes, the condition is met
  * : No, the condition is not met

This condition should specify a Series Group. If there is a series in that series group that is complete, this condition has been met.

#### CONDITIONAL TYPE OF INTERVAL

* Conditions: Has at least one dose been administered to the patient?
  * Rules: Yes
  * : No
  * : No
* Conditions: Is the Conditional Skip Reference Date ≥ Conditional Skip Interval Date
  * Rules: Yes
  * : No
  * : -
* Conditions: Outcomes
  * Rules: Yes, the condition is met
  * : No, the condition is not met
  * : No, the condition is not met

An interval is given. Does the dose that you're evaluating fall within the given interval compared to the last dose given? Note, this does not specify if the last dose needs to be valid or not, so I'm including them.

#### CONDITIONAL TYPE OF VACCINE COUNT BY AGE OR DATE

* Dose Count Logic: Greater Than
  * # Doses Given > "doseCount": Yes, the condition is met
  * # Doses Given == "doseCount": No, the condition is not met
  * # Doses Given < "doseCount": No, the condition is not met
* Dose Count Logic: Equal
  * # Doses Given > "doseCount": No, the condition is not met
  * # Doses Given == "doseCount": Yes, the condition is met
  * # Doses Given < "doseCount": No, the condition is not met
* Dose Count Logic: Less Than
  * # Doses Given > "doseCount": No, the condition is not met
  * # Doses Given == "doseCount": No, the condition is not met
  * # Doses Given < "doseCount": Yes, the condition is met

#### Count by Age

There's a list of CVX codes, a start and end age, a count, a specification of "greater than", "less than", or "equal to", and a specification of "VALID" or "TOTAL". First, we must look back through the previous doses see if they are included in the list of CVX codes. If the vaccine types list is empty, ALL doses count (not zero). If they are included, we look to see if they have to be valid ("VALID") or we can count any past doses ("TOTAL"). If all of that's true, then we look to see if the dose was given before the end age, or after (or on) the start age. If the answer is yes, then we add that to our total count. Finally, once we have that tally, we check if that count is "greater than", "less than", or "equal to" the count that is given. If the answer is again yes, then the condition is true.

**Important**: "Greater Than" means strictly greater (>), not greater-than-or-equal. "Less Than" means strictly less (<). This matters when the count exactly equals the threshold.

#### Count by Date

Exactly the same as above, except that instead of specifying ages, it specifies dates. Otherwise, the logic is the same.

#### Consistency in terms

This is one of my favorite things about the manual. While trying to maintain exact consistency in terminology, they have ended up with sentences such as: "The Date Administered of the vaccine dose administered when evaluating a vaccine dose administered."

"How much wood could a woodchuck chuck, if a woodchuck could chuck wood?" anyone?

### Inadvertent Administration

There's a list of possible inadvertent vaccines for each seriesDose. If the dose you're evaluating is one of them, then it's marked as inadvertent and not valid, and we move onto the next dose that was given.

### Valid Age

Probably makes the most sense. It's just calculated given date of birth, plus minimum and maximum ages. If the vaccine was given within that time period, it is valid under the age criteria.

* Conditions: Date given < absolute minimum age date?
  * Rules: Yes
  * ?: No
  * ?: No
  * ?: No
  * ?: No
  * ?: No
* Conditions: Absolute minimum age date ≤ date given < minimum age date
  * Rules: No
  * ?: Yes
  * ?: Yes
  * ?: Yes
  * ?: No
  * ?: No
* Conditions: Minimum age date ≤ date given < maximum age date
  * Rules: No
  * ?: No
  * ?: No
  * ?: No
  * ?: Yes
  * ?: No
* Conditions: Date given ≥ maximum age date
  * Rules: No
  * ?: No
  * ?: No
  * ?: No
  * ?: No
  * ?: Yes
* Conditions: First target dose in series
  * Rules: -
  * ?: No
  * ?: No
  * ?: Yes
  * ?: -
  * ?: -
* Conditions: Evaluation of the previous dose 'not valid' due to age or interval recommendations?
  * Rules: -
  * ?: Yes
  * ?: No
  * ?: -
  * ?: -
  * ?: -
* Conditions: 
* Conditions: Outcomes
* Conditions: Age Validity
  * Rules: Invalid
  * ?: Invalid
  * ?: Valid
  * ?: Valid
  * ?: Valid
  * ?: Invalid
* Conditions: Evaluation reason
  * Rules: 'too young'
  * ?: 'too young'
  * ?: 'grace period'
  * ?: 'grace period'
  * ?: 'valid age'
  * ?: 'too old'

The "grace period" is the range between the absolute minimum age and the minimum age. If the dose falls in this range, it may still be valid if it's the first dose in the series or if the previous dose was evaluated as valid. When a dose is given at or above the maximum age, it is marked as extraneous (not invalid) since repeating it won't help.

### Evaluate Preferable Interval

Intervals also make sense, they're just more complicated. There are certain conditions (such as pregnancy) that affect when to give certain vaccines, and intervals can be calculated from observations as well as previous doses.

**Important**: If multiple preferable intervals are specified for a target dose (e.g., one from the previous dose and one from a specific target dose), then **ALL** intervals must be satisfied. This is AND logic, not OR logic. However, only intervals that are relevant per the RELEVANT-1 business rule (based on effective/cessation dates) are considered.

* Conditions: Date Given < absolute minimum interval date*
  * Rules: Yes
  * ?: No
  * ?: No
  * ?: No
  * ?: No
* Conditions: Absolute minimum interval date ≤date given < minimum interval date
  * Rules: No
  * ?: Yes
  * ?: Yes
  * ?: Yes
  * ?: No
* Conditions: Minimum Interval date ≤ date given
  * Rules: -
  * ?: No
  * ?: No
  * ?: Yes
  * ?: -
* Conditions: Evaluation of the previous dose 'not valid' due to age or interval recommendations?
  * Rules: -
  * ?: Yes
  * ?: No
  * ?: -
  * ?: -
* Conditions: Interval Validity
  * Rules: Invalid
  * ?: Invalid
  * ?: Valid
  * ?: Valid
  * ?: Valid
* Conditions: Evaluation reason
  * Rules: 'too soon'
  * ?: 'too soon'
  * ?: 'grace period'
  * ?: 'grace period'
  * ?: 'preferable interval'

*As long as this requirement is met, the dose has an allowable interval, even if it is not a preferable interval.

This is certainly more complicated logic. If the interval for that dose is null, then the interval is valid. If no reference dose can be determined (e.g., there is no previous dose to measure from), skip the interval check rather than failing it. Otherwise, it loops through the list of intervals, checking each one. If the interval is from the previous dose, we look at the previous valid or not-valid (non-inadvertent) dose. If from a target dose, we look at the dose that satisfied that specific target dose number.

### Evaluate Allowable Interval

This is the fallback. If the preferable interval check fails, we check the allowable interval. Unlike preferable intervals (which can be a list), there is only one allowable interval per target dose (it's optional and many series don't have one). The same absolute minimum interval logic applies, but using the allowable interval's values. If either the preferable OR the allowable interval passes, the dose passes the interval check.

The CDC instructions only refer to previous doses given for the allowable interval, not observations.

### Evaluate Live Virus Conflicts

So now we get into where the manual relies too heavily on consistent terminology to make any sense:

1. **Is the current vaccine type of the vaccine dose administered one of the supporting data defined live virus conflict current vaccine types?**Seriously? Who writes like that?
1. **Is the vaccine type of the previous vaccine dose administered the same as one of the supporting data defined live virus conflict previous vaccine types when the current vaccine dose administered type is the same as the live virus conflict current vaccine type?**Drowning…in…adjectives…

First, it's helpful to know about the supporting data. In the supporting data, there is a list of live virus conflicts. Each of these has a current type and a previous type.

1. So, the supporting data has a list of live virus conflict types. Is the type of the current dose being evaluated included in this list?
1. Make a list of each entry where the current type is the same as the dose being evaluated. For each entry in this list, look at the type defined in the previous field. Check ALL previous live virus doses the patient has received (not just the immediately previous dose, and not just within the same series — this is a cross-antigen check). If any previous dose matches the previous type in a conflict entry, check if there is a conflict using the dates.

* Conditions: Is current dose being evaluated one of the "current" entries in the liveVirusConflict list?
  * Rules: No
  * ?: Yes
  * ?: Yes
  * ?: Yes
  * ?: Yes
* Conditions: Does the patient have any previous live virus vaccines?
  * Rules: -
  * ?: No
  * ?: Yes
  * ?: Yes
  * ?: Yes
* Conditions: For each matching conflict entry, has the patient previously received the corresponding "previous" vaccine type?
  * Rules: -
  * ?: -
  * ?: No
  * ?: Yes
  * ?: Yes
* Conditions: Is the conflict begin interval date ≤ date given < conflict end interval date?
  * Rules: -
  * ?: -
  * ?: -
  * ?: No
  * ?: Yes
* Conditions: Is there a conflict?
  * Rules: No
  * ?: No
  * ?: No
  * ?: No
  * ?: Yes

Note on conflict end interval: if the previous dose has an evaluation status of **valid**, use the `minConflictEndInterval`. If the previous dose does **not** have an evaluation status of valid, use the `conflictEndInterval` (which is longer).

### Evaluate for Preferable Vaccine

There are vaccines that are allowed, and those that are preferred. This checks if the dose being evaluated is one of the latter. It's mostly used for scoring the series during the next few steps, and it DOES make use of the MVX codes.

* Conditions: Is the dose given a preferable vaccine for the current target dose in the series? (cvx)
  * Rules: Yes
  * ?: Yes
  * ?: Yes
  * ?: Yes
  * ?: No
* Conditions: Preferable vaccine type begin age date ≤ date administered < preferable vaccine type end age date?
  * Rules: Yes
  * ?: Yes
  * ?: Yes
  * ?: No
  * ?: -
* Conditions: Is the trade name of the current dose the same as the trade name of the preferable vaccine? (mvx)
  * Rules: Yes
  * ?: Yes
  * ?: No
  * ?: -
  * ?: -
* Conditions: Is the volume of the current dose ≥ volume of the preferable vaccine
  * Rules: Yes
  * ?: No
  * ?: -
  * ?: -
  * ?: -
* Conditions: Outcomes
  * Rules: Preferable vaccine
  * ?: Preferable Vaccine, butEval Reason: volume administered < than recommended volume
  * ?: Not preferable, wrong trade name
  * ?: Not preferable, given out of preferred age range
  * ?: Not preferable vaccine

### Evaluate for Allowable Vaccine

Similar to the above, except this time the dose must be one of the allowable vaccines to be considered valid. Note that the same CVX code may appear multiple times in the allowable vaccine list with different age ranges, so all matching entries should be checked.

* Conditions: Is the dose given an allowable vaccine for the current target dose in the series? (cvx)
  * Rules: Yes
  * ?: Yes
  * ?: No
* Conditions: Allowable vaccine type begin age date ≤ date administered < Allowable vaccine type end age date?
  * Rules: Yes
  * ?: No
  * ?: -
* Conditions: Outcomes
  * Rules: Allowable vaccine
  * ?: Not allowable, given outside of allowable age range
  * ?: Not allowable

### Satisfy Target Dose

Finally, we've made it through evaluating all the individual checks. Now we combine the results to determine if the target dose is satisfied.

The checks are evaluated in this order, and the first failure stops the evaluation:

* Conditions: Was the dose given at a valid age?
  * Rules: Yes
  * ?: Extraneous*
  * ?: No
  * ?: -
  * ?: -
* Conditions: Was the dose given at a preferable or allowable interval?
  * Rules: Yes
  * ?: -
  * ?: -
  * ?: No
  * ?: -
* Conditions: Was the dose administered in conflict with previous live virus doses?
  * Rules: No
  * ?: -
  * ?: -
  * ?: -
  * ?: Yes
* Conditions: Was the dose an allowable or preferable vaccine?
  * Rules: Yes
  * ?: -
  * ?: -
  * ?: -
  * ?: -
* Conditions: 
* Conditions: Outcomes
* Conditions: Target Dose Status
  * Rules: 'satisfied'
  * ?: 'not satisfied'
  * ?: 'not satisfied'
  * ?: 'not satisfied'
  * ?: 'not satisfied'
* Conditions: Evaluation status
  * Rules: 'valid'
  * ?: 'extraneous'
  * ?: 'not valid'
  * ?: 'not valid'
  * ?: 'not valid'

*If a dose is given at or above the maximum age, it's marked as extraneous rather than "not valid" because repeating it won't help (the patient has aged out of that series position).

### Mark Extraneous Doses

After all doses have been evaluated against all target doses in a series, any doses that still have no evaluation status (they weren't matched to any target dose, and weren't caught by any of the above checks) are marked as **extraneous**. These are simply extra doses that don't contribute to the series but don't need to be repeated.

