# 1 QUESTION OPEN

Paste the section below into OpenEvidence. When the ruling comes back, move it
to the adjudicated archive with the ruling and delete it from here. Do not
paste anything from the archive; OE has twice re-answered a settled question
that was still sitting in a queue.

## Should a dose dated before the date of birth be evaluated?

**Background.** In CDC's CDSi Logic Specification for ACIP Recommendations v4.6,
evaluation tests each vaccine dose administered against its target dose using
minimum and maximum ages, intervals and other conditions. The specification has
no rule that removes a dose from evaluation because it is dated before the
patient's date of birth. Evaluated normally, such a dose fails the minimum age
and comes back Not Valid, reason Too Young.

**Our answer.** We do not evaluate a dose dated before birth. We leave it out of
evaluation and forecasting and return a warning that names the dose, both dates,
and says to check the birth date, the administration date and that the record
belongs to this patient. Our reasoning: such a dose was not given to this
patient, and a Not Valid / Too Young result points a clinician at repeating an
injection that may never have happened, or hides a record filed under the wrong
patient.

You ruled recently that a dose dated after the assessment date must be evaluated
like any other, because nothing in the specification withholds evaluation on the
basis of a date. The same reasoning may apply here.

**Questions.**
1. Is it clinically correct to withhold evaluation of a dose dated before birth
   and report it as a data problem, or should it be evaluated and returned as
   Not Valid, Too Young, as the specification's process would produce?
2. If it should be evaluated, is a separate data-quality warning alongside the
   Not Valid result still appropriate?
3. Does any CDC or AIRA guidance for immunization information systems address
   doses dated before birth?
