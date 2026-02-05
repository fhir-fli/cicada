Table Evaluate Process Steps
<table border="1">
  <tr>
    <th>Activity</th>
    <th>Goal</th>
  </tr>
  <tr>
    <td>Evaluate Dose Administered Condition</td>
    <td>Determine if this dose is expired or subpotent (some reason it shouldn't be evaluated)</td>
  </tr>
  <tr>
    <td>Evaluate Conditional Skip</td>
    <td>The goal of this step is to determine if the target dose can be skipped due to a patient’s age or immunization history</td>
  </tr>
  <tr>
    <td>Evaluate For Inadvertent Vaccine</td>
    <td>The goal of this step is to determine if the vaccine dose administered was an inadvertent administration due to the vaccine type that was administered.</td>
  </tr>
  <tr>
    <td>Evaluate Age</td>
    <td>Was it given at the appropriate age</td>
  </tr>
  <tr>
    <td>Evaluate Preferable Interval</td>
    <td>Was it given within the preferred interval from the last dose</td>
  </tr>
  <tr>
    <td>Evaluate Allowable Interval</td>
    <td>Was it given within the allowed interval from the last dose</td>
  </tr>
  <tr>
    <td>Evaluate Live Virus Conflict</td>
    <td>Is there a conflict between this dose and any live virus vaccines</td>
  </tr>
  <tr>
    <td>Evaluate For Preferable Vaccine</td>
    <td>If there are preferred vaccines available for this dose, is it one of them</td>
  </tr>
  <tr>
    <td>Evaluate For Allowable Vaccine</td>
    <td>Is it an allowed vaccine for this dose</td>
  </tr>
  <tr>
    <td>Satisfy Target Dose</td>
    <td>Is the target dose satisfied</td>
  </tr>
</table>

###  Evaluate Dose Administered Condition

This one is pretty easy. Was the vaccine expired before it was given? Is the vaccine subpotent for some reason? If the answer is yes to either of these, the dose can't be evaluated. Of note, we actually do this slightly earlier when we're first sorting the vaccines. When we're first assigning the vaccine doses given to the individual antigens, we bucket them at that point as either subpar or available for evaluation. This just saves us the trouble of looking at them as we evaluate each series, and we only look at the valid ones.

Also, a brief note on how FHIR handles this. It's very similar. With the [Immunization resource] there is a field where it notes the ```expirationDate``` of the vaccine, which can be compared to the ```occurrence[x]``` which is the date the vaccine was given. There is also a boolean field, ```isSubpotent``` that indicates whether or not it is. There is also a list of CodeableConcepts in a field ```subpotentReason``` that can list why. The CDC manual lists examples such as sub-potent and recall, FHIR uses an [Immunization Subpotent Reason ValueSet](https://build.fhir.org/valueset-immunization-subpotent-reason.html) that contains partialdose, coldchainbreak, recall, adversestorage, and expired.

###  Evaluate Skip Condition

Can the dose be skipped? Not the most complicated logic, but some of the terms, as usual, I found unclear. But the idea behind this is that there are times when you can skip a dose. This may be part of catch-up dosing, or the patient may have aged out. There is also skip logic, at both the set level and the condition level. Sets are lists of conditions. For a list of Conditions, we may have "AND" logic or "OR" logic. This is about what you'd expect. "AND" means that all of the listed conditions have to be true for that Set to be true. "OR" means that if any of the conditions are true, that set is true. Likewise, while it rarely happens, you can have set logic, also "AND" or "OR" with similar specifications. Now, the types of conditions that can define a skip come in 5 choices, so let's look at all the options, shall we?

#### **CONDITIONAL AGE**

<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="2" style="text-align:center;">Rules</th>
  </tr>
  <tr>
    <td>Is the Conditional Skip End Age Date &gt; Conditional Skip Reference Date &gt;= Conditional Skip Begin Age Date?</td>
    <td style="text-align:center;">Yes</td>
    <td style="text-align:center;">No</td>
  </tr>
  <tr>
    <th>Outcomes</th>
    <td style="text-align:center;">Yes, the condition is met</td>
    <td style="text-align:center;">No, the condition is not met</td>
  </tr>
</table>

You should be given a start and end age for this one. I think what confused me about this one is that you need a reference date. Since you're evaluating each targetDose in a series, there's not exactly a reference date. So instead, what you do is take the next dose you're evaluating and use the date administered as the reference date. If that lets you skip, you can skip that targetDose and use THE SAME dose administered that you were just looking at to see if it satisfies the next targetDose.

Still confused? Try this. Dragonpox is a 3-dose vaccine series. Johnny got a dragonpox vaccine when he was 3 years old. For the first dose in the series, there is an age skip condition, with a start age of 2 years and end age of 4 years. Since Johnny's first dose falls within this period, we can mark the 1st targetDose in the series as skipped. Then, using that same vaccine that Johnny got at 3 years old, we can see if that dose satisfies the 2nd targetDose in the series.

#### **CONDITIONAL TYPE OF COMPLETED SERIES**

<table border="1">
  <tr>
    <th>Conditions</th>
    <th>Rules</th>
    <th></th>
  </tr>
  <tr>
    <td>Does the Conditional Skip Series Group identify a Series Group with at least one series with a status of 'Complete'</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Outcomes</td>
    <td>Yes, the condition is met</td>
    <td>No, the condition is not met</td>
  </tr>
</table>


This condition should specify a Series Group. If there is a series in that series group that is complete, this condition has been met.

#### **CONDITIONAL TYPE OF INTERVAL**

<table border="1">
  <tr>
    <th>Conditions</th>
    <th>Rules</th>
    <th></th>
    <th></th>
  </tr>
  <tr>
    <td>Has at least one dose been administered to the patient?</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Is the Conditional Skip Reference Date &ge; Conditional Skip Interval Date</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Outcomes</td>
    <td>Yes, the condition is met</td>
    <td>No, the condition is not met</td>
    <td>No, the condition is not met</td>
  </tr>
</table>


An interval is given. Does the dose that you're evaluating fall within the given interval compared to the last dose given? Note, this does not specify if the last dose needs to be valid or not, so I'm including them.

#### **CONDITIONAL TYPE OF VACCINE COUNT BY AGE OR DATE**

<table border="1">
  <tr>
    <th>Dose Count Logic</th>
    <th># Doses Given &gt; "doseCount"</th>
    <th># Doses Given == "doseCount"</th>
    <th># Doses Given &lt; "doseCount"</th>
  </tr>
  <tr>
    <td>Greater Than</td>
    <td>Yes, the condition is met</td>
    <td>No, the condition is not met</td>
    <td>No, the condition is not met</td>
  </tr>
  <tr>
    <td>Equal</td>
    <td>No, the condition is not met</td>
    <td>Yes, the condition is met</td>
    <td>No, the condition is not met</td>
  </tr>
  <tr>
    <td>Less Than</td>
    <td>No, the condition is not met</td>
    <td>No, the condition is not met</td>
    <td>Yes, the condition is met</td>
  </tr>
</table>


#### Count by Age

There's a list of CVX codes, a start and end age, a count, a specification of "greater than", "lower than", or "equal to", and a specification of "VALID" or "TOTAL". First, we must look back through the previous doses see if they are included in the list of CVX codes. If they are, we look to see if they have to be valid ("VALID") or we can count any past doses ("TOTAL"). If all of that's true, then we look to see if the dose was given before the end age, or after (or on) the start age. If the answer is yes, then we add that to our total count. Finally, once we have that tally, we check if that count is "greater than", "lower than", or "equal to" the count that is given. If the answer is again yes, then the condition is true.

#### Count by Date

Exactly the same as above, except that instead of specifying ages, it specifies dates. Otherwise, the
logic is the same.

#### Consistency in terms

This is one of my favorite things about the manual. While trying to maintain exact consistency in terminology, they have ended up with sentences such as:
The Date Administered of the vaccine dose administered when evaluating a vaccine dose
administered.

"How much wood could a woodchuck chuck, if a woodchuck could chuck wood?" anyone?

###  Inadvertent Adminsitration

There's a list of possible inadvertent vaccines for each seriesDose. If the dose you're evaluating is one of them, then it's marked as inadvertent and not valid, and we move onto the next dose that was given.

###  Valid Age

Probably makes the most sense. It's just calculated given date of birth, plus minimum and maximum ages. If the vaccine was given within that time period, it is valid under the age criteria.
<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="6">Rules</th>
  </tr>
  <tr>
    <td>Date given &lt; absolute minimum age date?</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Absolute minimum age date &le; date given &lt; minimum age date</td>
    <td>No</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Minimum age date &le; date given &lt; maximum age date</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Date given &ge; maximum age date</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>First target dose in series</td>
    <td>-</td>
    <td>No</td>
    <td>No</td>
    <td>Yes</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Evaluation of the previous dose 'not valid' due to age or interval recommendations?</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td colspan="7"></td> <!-- Blank row for separation -->
  </tr>
  <tr>
    <th colspan="7">Outcomes</th>
  </tr>
  <tr>
    <th>Age Validity</th>
    <td>Invalid</td>
    <td>Invalid</td>
    <td>Valid</td>
    <td>Valid</td>
    <td>Valid</td>
    <td>Invalid</td>
  </tr>
  <tr>
    <th>Evaluation reason</th>
    <td>'too young'</td>
    <td>'too young'</td>
    <td>'grace period'</td>
    <td>'grace period'</td>
    <td>'valid age'</td>
    <td>'too old'</td>
  </tr>
</table>


###  Evalute Preferable Interval

Intervals also make sense, they're just more complicated. Currently I only perform logic for previous vaccine doses, not observations. There are certain conditions (such as pregnancy) that effect when to give certain vaccines. And the vaccines are supposed to be given a certain time period after the condition.
<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="5">Rules</th>
  </tr>
  <tr>
    <td>Date Given &lt; absolute minimum interval date*</td>
    <td>Yes</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Absolute minimum interval date &le; <br> date given &lt; minimum interval date</td>
    <td>No</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Minimum Interval date &le; date given</td>
    <td>-</td>
    <td>No</td>
    <td>No</td>
    <td>Yes</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Evaluation of the previous dose 'not valid' due to age or interval recommendations?</td>
    <td>-</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <th>Interval Validity</th>
    <td>Invalid</td>
    <td>Invalid</td>
    <td>Valid</td>
    <td>Valid</td>
    <td>Valid</td>
  </tr>
  <tr>
    <th>Evaluation reason</th>
    <td>'too soon'</td>
    <td>'too soon'</td>
    <td>'grace period'</td>
    <td>'grace period'</td>
    <td>'preferable interval'</td>
  </tr>
</table>


*As long as this requirement is met, the dose has an allowable interval, even if it is not a preferable interval.

This is certainly more complicated logic. If the interval for that dose is null, then the interval is valid. If it is the first in the series it is also valid. Otherwise, it loops through the list of intervals, and first checks to see if the interval listed is from the previous dose or another dose, then checks the interval compared to that dose. Allowable and preferable intervals are closely intertwined, so the logic for both is encapsulated in the same function.

###  Evalute Allowable Interval

This one's easy. Is the date given less than the absolute minimum interval date? If so, then you're good to go. The CDC instructions only refer to previous doses given for this one, not observations, so for the time being intervals from observations are not part of this logic. This logic IS however, baked into the above logic, since it's part of that process as well.

###  Evaluate Live Virus Conflicts

So now we get into where the manual relies too heavily on consistent terminology to make any sense:

1. *Is the current vaccine type of the vaccine dose administered one of the supporting data defined live virus conflict current vaccine types?* Seriously? Who writes like that?
2. *Is the vaccine type of the previous vaccine dose administered the same as one of the supporting data defined live virus conflict previous vaccine types when the current vaccine dose administered type is the same as the live virus conflict current vaccine type?* Drowning...in...adjectives...

First, it's helpful to know about the supporting data. In the supporting data, there is a list of live virus conflicts. Each of these has a current type and a previous type. And we apply these to the dose being evaluated.

1. So, the supporting data has a list of live virus conflict types. Is the type of the current dose being evaluated included in this list?
2. Make a list of each entry where the current type is the same as the dose being evaluated. For each of entry in this list, look at the type defined in the previous field. If it is indeed the same as the previously given dose, then you have to check if there is a conflict using the dates given in that entry.

###  Evaluate for Preferable Vaccine

There are vaccines that are allowed, and those that are preferred. This checks if the dose being evaluated is one of the latter. It's mostly used for scoring the series during the next few steps, and it DOES makes use of the MVX codes.

<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="5">Rules</th>
  </tr>
  <tr>
    <td>Is the dose given a preferable vaccine for the current target dose in the series? (cvx)</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Preferable vaccine type begin age date &le; date administered &lt; preferable vaccine type end age date?</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is the trade name of the current dose the same as the trade name of the preferable vaccine? (mvx)</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Is the volume of the current dose &ge; volume of the preferable vaccine</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <th>Outcomes</th>
    <td>Preferable vaccine</td>
    <td>Preferable Vaccine, but <br> Eval Reason: volume administered &lt; than recommended volume</td>
    <td>Not preferable, wrong trade name</td>
    <td>Not preferable, given out of preferred age range</td>
    <td>Not preferable vaccine</td>
  </tr>
</table>


###  Evaluate for Allowable Vaccine

Similar to the above, except this time it has to be one of these to be considered a valid dose.

<table border="1">
  <tr>
    <th>Conditions</th>
    <th colspan="3">Rules</th>
  </tr>
  <tr>
    <td>Is the dose given an allowable vaccine for the current target dose in the series? (cvx)</td>
    <td>Yes</td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td>Allowable vaccine type begin age date &le; date administered &lt; Allowable vaccine type end age date?</td>
    <td>Yes</td>
    <td>No</td>
    <td>-</td>
  </tr>
  <tr>
    <th>Outcomes</th>
    <td>Allowable vaccine</td>
    <td>Not allowable, given outside of allowable age range</td>
    <td>Not allowable</td>
  </tr>
</table>

