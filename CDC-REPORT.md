# Four defects to report to CDC — CDSi 4.65-508

Found while running cicada against the published test cases. Three are defects in
the **supporting data**; the fourth is a defective **test expectation**. Each was
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

**Cases:** none currently failing — surfaced via `2016-UC-0198`

"Meningococcal ACWY risk 2-23 month" carries **no maximum age to start**, and
none of its doses carries a maximum age. Nothing ages a patient out of it. A
39-year-old microbiologist therefore remains scorable in it, and because it holds
the higher series priority in its group it wins SELECTSCORE-2 outright — an adult
is handed an infant schedule beginning in his seventh month of life.

ACIP gives that patient one MenACWY dose boosted every five years (MMWR 69(9)).

cicada works around this by preferring, among risk series of differing priority
in one series group, the one whose applicable indication begins latest in life. A
maximum age to start on the infant series would make the workaround unnecessary.

**Fix:** add a maximum age to start (24 months) to the 2–23 month series.

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
`AntigenSupportingData- HepB-508.xml` carries the `inadvertentVaccine` element on
**all 62** of its target doses and **every one is empty**. No conformant engine —
CDC's included — can emit that reason for a hepatitis B dose. For contrast, in
the same release Polio populates 93, COVID-19 90, Tetanus and Diphtheria 36 each,
RSV 34, Pneumococcal 15, HPV 14, Pertussis 6.

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

Full working, including CDC's own row for each case and cicada's answer, is in
`CDSI-OE-QUERIES.md` — sections 3, 6, 11 and 12 respectively.
