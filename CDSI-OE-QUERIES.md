# 1 QUESTION OPEN

Paste the section below into OpenEvidence. When the ruling comes back, move it
to the adjudicated archive with the ruling and delete it from here. Do not
paste anything from the archive; OE has twice re-answered a settled question
that was still sitting in a queue.

## Can a dose dated after the assessment date be evaluated as Valid?

**Background.** CDC's CDSi Logic Specification for ACIP Recommendations v4.6
lists the Assessment Date as runtime data whose source is "current date", and
defines it as "the date for which a forecast is determined". The evaluation
process operates on each "vaccine dose administered". The specification has no
rule that says what to do with a dose whose date falls after the assessment
date.

**CDC's test rows.** Four cases in CDC's healthy childhood and adult test cases
(v4.46), all Gardasil (HPV):

| case | date of birth | assessment date | doses given | CDC expects |
|---|---|---|---|---|
| 2026-0043 | 2004-07-12 | 2015-02-13 | 2015-09-13, 2016-02-13 | both doses Valid, HPV series complete |
| 2026-0050 | 2004-07-12 | 2015-02-13 | 2015-09-13, 2016-02-13 | both doses Valid, HPV series complete |
| 2026-0052 | 2004-05-03 | 2016-01-17 | 2015-07-21, 2015-12-16, 2016-03-09 | all three Valid, HPV series complete |
| 2026-0060 | 1999-11-03 | 2016-04-01 | 2015-11-02, 2015-12-02, 2016-05-02 | all three Valid, HPV series complete |

The other 1,002 cases in the set place every dose on or before the assessment
date.

**Our answer.** Because the assessment date is the current date, a dose dated
after it has not been given. We do not evaluate it and do not count it toward
the series. We return it with a warning that its date is after the assessment
date. So for these four patients we report HPV as not complete, based only on
the doses dated on or before the assessment date.

**Questions.**
1. Is it clinically correct to refuse to count a dose dated after the
   assessment date, and to report the series as not complete on that date?
2. Or should an immunization forecaster evaluate every recorded dose whatever
   its date, as CDC's expected results require?
3. If our reading is right, are these four rows best described as a defect in
   CDC's test data (an assessment date that was not moved when the dose dates
   were)?
