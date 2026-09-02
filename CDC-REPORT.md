# Seven defects to report to CDC — CDSi 4.65-508

Found while running cicada against the published test cases. Three are defects in
the **supporting data**, one is a defective **test expectation**, one is an
indication asked for by a test and carried by no series that could apply to that
patient, and one is the underlying-conditions workbook as a whole being older
than the data it is tested against. Each was
checked in the published **Excel** supporting data — the authoritative form, and
the one cicada's generator builds from — and cross-checked against the XML and
the 4.64 release, so none is new to this version.

---

## 1. Orthopox observation 235 is defined but named by no series

**Cases:** `2022-UC-0030`, `2022-UC-0031`

**The data already carries the recommendation in prose and fails to wire it to a
series.** `ScheduleSupportingData- Coded Observations` defines observation 235 —
"Healthcare personnel who care for patients infected with more virulent
orthopoxviruses (e.g., Variola virus or mpox virus)" — with the instruction
spelled out in its own `indicationText`: *"Administer to healthcare personnel who
care for patients infected with more virulent orthopoxviruses."*

But no series names it. Across the four risk series in
`AntigenSupportingData- Orthopoxvirus-508`, the indications name observations
**232, 233, 234, 236, 237, 238, 239, 241, 242, 247 and 248** — and not 235. So a
patient carrying 235 gets no orthopox recommendation at all, while the
supporting data shipped alongside says plainly that they should be vaccinated.
ACIP agrees (MMWR 71(22), shared clinical decision-making).

The two halves of the package contradict each other, which also makes this cheap
to fix: the clinical decision is already made and written down.

**Fix:** name observation 235 in the indications of the "more virulent" risk
series.

---

## 2. The meningococcal 2–23 month series has no maximum age to start

**Case:** `2016-UC-0198` — currently failing, and correctly so

"Meningococcal ACWY risk 2-23 month" carries **no maximum age to start**, and
none of its doses carries a maximum age. Nothing ages a patient out of it. A
39-year-old microbiologist therefore remains scorable in it, and because it holds
the higher series priority in its group it wins SELECTSCORE-2 outright — an adult
is handed an infant schedule beginning in his seventh month of life.

ACIP gives that patient one MenACWY dose boosted every five years (MMWR 69(9)).

cicada previously worked around this by preferring, among risk series of
differing priority in one series group, the one whose applicable indication
begins latest in life. **That workaround has been removed**: CDSi defines no
such rule, and an engine that invents one is no longer implementing the
specification. With it gone the engine follows SELECTSCORE-2 as written and
`2016-UC-0198` fails — which is the correct behaviour for supporting data that
cannot express the patient's age.

**Fix:** add a maximum age to start (24 months) to the 2–23 month series. Until
then any conformant engine will hand this adult an infant's schedule.

---

## 3. The pneumococcal 2–5 year risk series serves two different children on one dose

**Case:** `2016-UC-0153`

Dose 1 of "Pneumococcal risk 2-5 years Chronic Medical Conditions PCV-PCV-PPSV"
carries **both** an interval — 8 weeks from the most recent PCV — **and** an
absolute minimum age of **2 years with no grace**. FORECASTDTCAN-1 takes the
latest of all constraints, so the age floor always wins for a child who already
has an infant dose.

That floor is correct for the child *initiating* this pathway at 24 months with
no countable conjugate dose. It is wrong for the child already **mid-series**:
ACIP is explicit that interrupting the schedule does not restart it (MMWR
71(37)), so a prior dose counts and the next is due on the interval from it.

The asymmetry is visible in the data itself — a countable prior dose carries into
the dose **count** but not into the **schedule**.

**Fix:** make the age floor conditional on dose history, or split the pathway
into a starting series and a continuing series. Do **not** simply delete the
floor; the fresh-start child still needs it.

---

## 4. `2018-0022` expects an evaluation reason the data cannot produce

**Case:** `2018-0022` — *defective test row, not a data defect. Lower severity.*

The row expects a HepB dose to evaluate as **"Inadvertent Vaccine"**.
`AntigenSupportingData- HepB-508` carries an **Inadvertent Vaccine** row on all
**62** of its target doses, and **not one names a vaccine** — every one is
`n/a`. No conformant engine, CDC's included, can emit that reason for a
hepatitis B dose. For contrast in the same release: Polio names a vaccine on
**31 of 31** such rows, COVID-19 on **37 of 46**.

The clinically correct reason is **"Age: Too Young"**. The patient received her
first Heplisav-B five days before her 18th birthday: the *right product*, before
its licensed minimum age. "Inadvertent" asserts the *wrong product* was given,
which is a different finding and implies a different correction. The paired case
`2018-0019`, the same scenario at four days before the birthday where the grace
period rescues the dose, shows the pair exists to test the **age boundary** —
age is the only variable that changes between them.

**Fix:** correct the row's expected reason to "Age: Too Young". The HepB data is
self-consistent and needs no inadvertent-vaccine definition added.

---

## 5. The underlying-conditions test cases predate the supporting data

**Cases:** `2016-UC-0032`, `2016-UC-0057`, `2016-UC-0079`, `2016-UC-0087`,
`2016-UC-0088`, `2016-UC-0110`, `2016-UC-0130`, `2016-UC-0173`, `2016-UC-0178`,
`2016-UC-0203`, `2017-UC-0015`, `2020-UC-0003`, `2022-UC-0017`, `2025-UC-0010`,
`2025-UC-0015`, and the RSV cases `2023-UC-0047`, `2023-UC-0048`, `2023-UC-0050`,
`2023-UC-0051` — nineteen, reported as one finding.

Each of these rows asks for a series, an interval or an evaluation reason that
the current supporting data no longer contains. A conformant engine reading
4.65-508 cannot produce the expected answer, because the rule the row tests is
gone. Examples:

- **The risk series was retired.** No HPV risk series is indicated by observation
  036 any more, so `2016-UC-0087` and `2016-UC-0088` cannot evaluate a dose in
  one. The same for observation 177 and MenB (`2020-UC-0003`), and for the
  contraindication codes 116 and 172 (`2016-UC-0203`, `2025-UC-0010`).
- **The indication window narrowed.** The HPV sexual-abuse indication now ends at
  11 years; `2016-UC-0079`'s patient is 12 at assessment, and Table 5-4 tests the
  assessment date.
- **The interval was replaced.** `2016-UC-0110` expects a MenACWY fourth dose six
  months after dose 3; that interval exists nowhere in the series now.
  `2022-UC-0017` expects 8 weeks where the dose carries `minInt: 1 year`.
- **The attribute was removed.** `2016-UC-0032` expects an MMR past-due date six
  years out; that dose carries no latest recommended interval at all.
- **The season moved on.** Every RSV series in 4.65-508 carries the 2025-26
  season: `2025-10-01` to `2026-03-31` for the standard and the under-20-months
  risk series, `2025-09-01` to `2026-01-31` for the pregnancy series. The four
  RSV cases are 2023-season rows expecting 2023 dates. cicada answers with the
  season it was given, two years later than the row, and for `2023-UC-0048`
  (cystic fibrosis, five days old) and `2023-UC-0050` (American Indian or
  Alaskan Native, 19 months) that pushes the earliest date past the series'
  20-month maximum age, so the correct reading of the current data is that the
  child ages out before the season opens. Same month and day as the expected
  answer in each case, two years on.

All fifteen were reviewed against current ACIP by an independent evidence review,
which found **cicada's answer clinically correct in every one** and the CDC row
stale. Each was also checked against the 4.64 release, so none is new to
4.65-508.

**Fix:** regenerate or retire the underlying-conditions test cases against the
current supporting data. They are dated v4.6 (September 2025) while the data is
August 2026, and the healthy childhood and adult cases (v4.46) do not show this
problem — cicada passes 1063 of 1064 of those.

---

## 6. `2023-UC-0047` sends an observation no RSV series can apply to that child

**Case:** `2023-UC-0047` — chronic lung disease, age 9 months 21 days at
assessment. Independent of the season problem above.

The case carries CDSi observation **017 "Chronic lung disease"**. In
`AntigenSupportingData- RSV-508`, observation 017 is named by exactly one series,
**"RSV risk 50-74 years 1-dose series"**, with `beginAge` 50 years and `endAge`
75 years. The series that covers infants, **"RSV risk under 20 months series"**,
names observations **280 "Chronic lung disease of prematurity"**, **200 "Cystic
fibrosis"**, **245 "American Indian or Alaskan Native"** and **246 "Severe
immunocompromise"** — not 017.

So a nine-month-old carrying 017 matches no RSV series: the only series indicated
by that observation begins at 50 years. The row nevertheless expects a dose 1
forecast. A conformant engine reading this data cannot produce it, and no reading
of the data makes 017 select the infant series.

Either the test case should send 280, or the under-20-months series should also
name 017. The sibling cases show which is intended: `2023-UC-0048` sends 200 and
`2023-UC-0050` sends 245, both of which the infant series does name, so
`2023-UC-0047` looks like the odd one out rather than the data being wrong.

**Fix:** send observation 280 in `2023-UC-0047`, or add 017 to the indications of
the under-20-months series if a chronic lung disease that is not of prematurity
is meant to qualify.

---

## 7. Four healthy cases administer a dose after their own assessment date

**Cases:** `2026-0043`, `2026-0050`, `2026-0052`, `2026-0060` — four of 1,006.

| case | assessment date | dose dates |
|---|---|---|
| 2026-0043 | 2015-02-13 | 2015-09-13, 2016-02-13 |
| 2026-0050 | 2015-02-13 | 2015-09-13, 2016-02-13 |
| 2026-0052 | 2016-01-17 | 2016-03-09 |
| 2026-0060 | 2016-04-01 | 2016-05-02 |

Each expects those doses evaluated as Valid and the series complete.

The logic spec defines the assessment date as the **current date** (v4.6, three
places). Everything the evaluation process consumes is a *vaccine dose
administered*. A dose dated after the current date has not been administered, so
a conformant engine has nothing to evaluate: it cannot be Valid, and it cannot
count toward completing a series. Reading the rows as written means an engine
must treat a future event as history.

cicada now excludes such doses and reports them in an `OperationOutcome`, so
these four rows fail. The remaining 1,002 healthy cases are unaffected, which is
why this looks like four rows whose assessment date was not moved when their
dose dates were, rather than a deliberate design.

⚠️ **Unverified provenance.** These dates are read from our generated NDJSON,
not from CDC's own workbook: the healthy cases are the v4.46 set and that
workbook is not in this repo, so the assessment date could not be checked
against the source. If CDC's workbook carries a later assessment date for these
rows, the defect is ours and not theirs.

**Fix:** move the assessment date after the last dose in each of the four rows,
or confirm that CDSi intends future-dated doses to be evaluated, in which case
the definition of assessment date needs to say so.

---

Full working, including CDC's own row for each case and cicada's answer, is in
`CDSI-OE-QUERIES.md` — sections 3, 6, 11, 12 and 8/9/10 respectively.
