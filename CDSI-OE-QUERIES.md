# ONE ITEM OPEN — paste the section under "OPEN" below into OpenEvidence

Everything under CLOSED is settled and **must not be pasted again**. OE has
twice re-answered a question that was still sitting in this file after it had
been ruled on.

---

# OPEN

## Tdap in pregnancy is gated on recorded sex as well as on pregnancy

CDSi 4.65-508 defines a "Pertussis risk 1-dose series" with two conditions on
it at once:

* `requiredGender`: **Female** and **Unknown**
* an indication on observation **007, Pregnant**, whose own text reads
  *"Administer to women who are pregnant."*

An engine applies both, so a pregnant patient whose record carries
`Patient.gender = male` satisfies the indication and is excluded by the gender
gate. They receive no Tdap risk recommendation. Recorded as `other`, `unknown`,
or with the element absent, they receive it, because CDC lists Unknown beside
Female.

`Patient.gender` is bound required in FHIR R4 to male | female | other |
unknown and its own definition calls the element administrative. CDSi does not
say what its Gender attribute means: the glossary reads "Patient Gender: the
patient's gender".

**Our reading:** the pregnancy is what makes Tdap apply. The gender gate adds
no information on this series and can only exclude, and the patient it excludes
is one whose recorded sex does not match their anatomy. We have therefore made
pregnancy outrank the gender gate for this series only, and we would like that
checked.

**The questions:**

1. Is there any patient for whom the `requiredGender` on this series changes the
   right answer, given that observation 007 is already required?
2. Should a pregnant patient whose record says `male` receive Tdap?
3. If yes, is the defect in CDSi's supporting data, or is an engine expected to
   apply `requiredGender` strictly and leave this to a clinician override?

Of the eleven gender-gated series in 4.65-508 this is the only one whose
indication is the qualifying state itself. The other ten are HPV, gated on age
or immunocompromise, and exist as duplicated male and non-male pairs with
identical doses, ages and intervals.

---

# CLOSED — rulings only, questions deleted

Fourteen sections were adjudicated between 2026-08-19 and 2026-08-28. The
question write-ups are gone; what follows is what was decided and where it was
applied. Full working is in the git history of this file.

## ✅ ADJUDICATED 2026-08-19 — all seven

Grey ran every section through OpenEvidence with ACIP/MMWR citations.
**cicada is right against current ACIP in six of the seven; the meningococcal
case is a real defect in cicada.**

| section | verdict | nature |
|---|---|---|
| 1. `2016-UC-0130` Tdap year | **cicada** | no ACIP basis for a Tdap dated before conception; CDC cell defective |
| 1./2. past-due minus-1-day | **cicada** (convention) | ACIP defines no overdue date; it is CDSi's FORECASTDT-3, and CDC applies it elsewhere |
| 3. orthopox HCP (obs 235) | **recommendation stands → CDSi data defect** | ACIP 2022 still lists HCP caring for orthopox patients (SCDM); report to CDC |
| 4. RSV chronic lung disease | **cicada / current data** | the criterion is CLD **of prematurity requiring medical support**, not generic CLD |
| 5. cholera minimum age | **cicada** | ACIP extended CVD 103-HgR to ages 2–17 in Feb 2022; the 18-year row predates it |
| 6. `2016-UC-0198` meningococcal | 🔴 **CDC row — cicada was clinically wrong** | a 39-year-old microbiologist gets **1 MenACWY dose**, boosted every 5 years; not an infant schedule — **fixed in `228b8935`** |
| 7. pneumococcal 5-year anchor | **cicada** | current ACIP: PCV20/PCV21 ≥5 years after the **last** pneumococcal dose; the PPSV23 anchoring is superseded |

Sources: MMWR — pertussis 67(2) and 69(3); ACOG Committee Opinion 718; JYNNEOS
71(22); nirsevimab 72(34) with the 2025 child schedule; cholera 71(2);
meningococcal 69(9) with the 2025 adult schedule; pneumococcal 72(3) and
74(1).

**Three things to report to CDC** (the third added 2026-08-25), all
supporting-data defects rather than
engine defects:

1. Observation **235** (healthcare personnel caring for patients infected with
   more virulent orthopoxviruses) is defined in the schedule supporting data
   and named by no series in 4.65-508, though ACIP still recommends JYNNEOS
   pre-exposure vaccination for that group on a shared-clinical-decision-making
   basis.
2. The **"Meningococcal ACWY risk 2-23 month" series carries no maximum age to
   start**, and none of its doses carry a maximum age, so a 39-year-old is
   scorable in it — and it outranks the adult 1-dose series on series priority.
   See section 6. cicada now works around this by preferring, among risk series
   of *differing* priority in one series group, the one whose applicable
   indication begins latest in life (`228b8935`); a maximum age to start on the
   infant series would make the workaround unnecessary.

3. **The "Pneumococcal risk 2-5 years Chronic Medical Conditions" series serves
   two different children on one dose, and gates both with an absolute age.**
   Its first dose carries an interval (8 weeks from the most recent PCV) *and*
   an absolute minimum age of 2 years with no grace. FORECASTDTCAN-1 is an AND —
   the earliest date is the latest of every constraint — so a child who is
   already **mid-series** inherits an age gate written for the child *starting*
   the pathway at 24 months with no countable conjugate dose, and is pushed to a
   date with no clinical basis for her. ACIP is explicit that interrupting the
   schedule does not restart it, so her earlier dose counts and the next is due
   on the interval from it. CDC's own test row `2016-UC-0153` reports the
   interval date and ignores the age floor its data publishes, which is the
   contradiction in miniature.

   **The fix is not to delete the 2-year floor** — the fresh-start child still
   needs it — **but to make it conditional on dose history**, exactly as the
   vaccine-group aggregation already conditions the forecast dose *number* on
   the union of valid doses across series. Today a countable prior dose carries
   into the **count** and not into the **schedule**, and that asymmetry is what
   produces the defect. Alternatively, split the pathway into a starting series
   and a continuing series.

   Verified against 4.64 as well as 4.65-508, so it is not new to this release.
   cicada already computes the clinically correct date — its standard
   "Pneumococcal dose 2 at 7 months series" forecasts 2013-06-05 for this child
   — but the risk series takes the vaccine group forecast, so that answer is not
   the one reported.

**And one defective test row, reported separately** — not a data defect, because
the data is self-consistent. `2018-0022` expects a HepB dose to evaluate as
"Inadvertent Vaccine", and `AntigenSupportingData- HepB-508.xml` carries that
element on all 62 of its target doses with **every one empty**. No conformant
engine can produce that reason for hepatitis B. OE adjudicated the clinically
correct reason as **"Age: Too Young"** anyway (§12), so the fix is to correct the
row, not to add an inadvertent-vaccine definition. Lesser severity than the three
above.

---

## ✅ ADJUDICATED 2026-08-24 — sections 8, 9 and 10

Grey ran the three new sections through OpenEvidence. **cicada is clinically
correct in all three**; each CDC row is stale against the current supporting
data, or — in section 10 — testing a patient whose dates contradict its own
name. No engine change follows from any of them.

| section | verdict | basis |
|---|---|---|
| 8. `2016-UC-0110` MenACWY 4th dose | **cicada** — the 4th dose is anchored to **12 months of age**, not to dose 3 + 6 months | asplenia MenACWY-CRM primary series is 2, 4, 6 and 12 months (MMWR 69(9); MenQuadfi label gives 2, 4, 6, 12–18 months). There is no ACIP basis for a dose ten days before the first birthday |
| 9. HPV, history of sexual abuse (`2016-UC-0079`) | **cicada** — routine, not a risk series | ACIP recommends **routine** HPV from age 9 for this history: a routine-age trigger, not separate dosing. Past the routine start age the child is simply in catch-up (MMWR 65(49)) |
| 9. HPV, MSM (`2016-UC-0087`, `2016-UC-0088`) | **cicada** — routine/catch-up, no distinct schedule | HPV "as for all males", catch-up through 26, SCDM 27–45 (MMWR 65(49), 68(32)) |
| 9. MenB "seeks protection" (`2020-UC-0003`) | **cicada** — SCDM **standard** series, not risk | MenB at 16–23 is shared clinical decision-making; risk-based MenB is reserved for asplenia, complement deficiency or inhibitor use, microbiologists and outbreaks (MMWR 69(9), 73(49)) |
| 9. contraindication codes (`2016-UC-0203`, `2025-UC-0010`) | **cicada** | 116 and 172 indicate no series; Contraindicated with no forecast is right, and the status already matched CDC |
| 9. `2016-UC-0032`, `2022-UC-0017` | **cicada** | interval and latest-recommended conventions settled in the earlier batch; the recommended dates already match CDC |
| 10. `2016-UC-0057` Hib at 5 months | **cicada** — routine infant schedule | the high-risk Hib provision (2 doses 8 weeks apart for 0–1 prior doses) applies **only at 12–59 months** — a catch-up rule that does not begin until the first birthday (MMWR 63(RR-01)). A 5-month-old with one dose continues the routine primary series |

**On the group question in section 9:** current ACIP does **not** define distinct
risk schedules for these behavioural and exposure groups separate from the
routine or SCDM recommendation. The rows are stale against CDC's own newer
supporting data.

Sources: MMWR 69(9) meningococcal · 73(49) MenB-4C · 65(49) and 68(32) HPV ·
63(RR-01) Hib · MenQuadfi label · ACIP child/adolescent and adult schedules
(addenda updated 2 July 2025).

---

## 11. 🔴 `2016-UC-0153` — ADJUDICATED AGAINST cicada, twice

**Re-ruled 2026-08-25 on the full evidence** (the interval anchor and the age
floor both put to OE). The verdict stands and sharpens:

- **cicada's 2015-01-08 is clinically wrong.** ACIP does not defer a partially
  vaccinated high-risk child's next PCV dose to the second birthday. Interruption
  "does not require reinstitution of the entire series or the addition of extra
  doses" — her 4-month PCV13 counts, and the interval anchors to it (MMWR 71(37)).
- **The minimum interval is 8 weeks, or 4 weeks for a dose given in infancy**, so
  her next dose was due around **2013-06-05** — earlier even than CDC's row. By
  the 2016 assessment she is simply overdue.
- 🔑 **The 2-year floor on that series' dose 1 is the underlying DATA defect, not
  just a stale test row.** It is right for a child *initiating* the 2–5-year risk
  pathway with no countable prior conjugate dose, and wrong as a gate on a child
  already mid-series. **Report to CDC:** the risk series needs a countable
  childhood PCV dose to carry into the *schedule*, not only into the dose count,
  so the interval anchors to it rather than to the age floor.

🛑 **MEASURED AND REJECTED — do not retry the obvious fix.** Bypassing the
minimum age whenever an interval anchors to a countable prior dose was
prototyped and run against both suites:

| | before | after |
|---|---|---|
| healthy | 1 failure | **150 failures** |
| condition | 24 failures | 26 failures |
| `2016-UC-0153` | failing | **still failing** |

It breaks 149 healthy cases, adds 2 condition failures, and does not even fix
the case it was written for — because the **recommended** date is gated
separately by `earliestRecAge`, also 2 years, so a full conform would need a
second deviation on top of the first. A minimum age is load-bearing across the
whole schedule (MMR at 12 months, HPV at 9, MenACWY dose 2 at 16); a countable
prior dose is far too common a condition to hang a bypass on.

⚠️ Also found while measuring: the minimum age date is applied **twice** in
`_computeCandidateEarliestDate` — once initialising the candidate and again
after the other contributors. Harmless (the same value maxed in twice) but it
silently undoes any change made between the two, which invalidated the first
run of this experiment.

🔑 **The clinically right answer is already in cicada's output — the series
structure hides it.** OE puts the true interval at **4 weeks**, not 8, for a dose
given in infancy, i.e. about **2013-06-05**. cicada's own standard pathway
produces exactly that: the "Pneumococcal dose 2 at 7 months series" counts her
infant dose and forecasts `earliest=2013/06/05`. So the engine computes the
correct catch-up date and then reports the risk series' date instead, because a
risk series that still needs a dose takes the vaccine group forecast.

That is worth putting in the CDC report: the collision is between **two rules
written for two different children living on the same series dose** — the
2-year floor belongs to the child *initiating* the 2–5-year pathway with no
countable conjugate dose, and there is no separate pathway for the child who is
already mid-series. Splitting those, or making the floor conditional on the
absence of a countable prior dose, would resolve it in the data where it
belongs.

**Disposition: cicada is left conformant to CDSi, and the defect is reported to
CDC as a data problem.** The risk series needs a way for a countable childhood
PCV dose to carry into the *schedule* rather than only the dose count — either a
second series for the mid-series child, or an age floor that does not apply once
a prior conjugate dose exists. `2016-UC-0153` stays a known, documented
non-conformance.

### The case

The last of the failing cases never put to OE. A child born 2013-01-08 with
**cochlear implants** (observation 011) received a single PCV13 (CVX 133) on
2013-05-08, at 4 months of age, and is **assessed on 2016-02-12, aged 3 years
1 month**. Both candidate answers are therefore dates in the past; the question
is which schedule she is on now.

| | date | what it is |
|---|---|---|
| CDC's row | **2013-07-03** | her infant dose plus 8 weeks — the next dose of the routine infant PCV series |
| cicada | **2015-01-08** | her **second birthday** — the start of the 2-to-5-year high-risk series |

**Why cicada answers that.** Two patient series survive selection. The standard
"Pneumococcal 4-dose series" counted her infant dose and forecasts its next
target dose; the risk series *"Pneumococcal risk 2-5 years Chronic Medical
Conditions PCV-PCV-PPSV"* is indicated by observation 011 and carries a minimum
age to start of **2 years** (maximum 6), with dose 1 at an absolute minimum age
of 2 years and dose 2 eight weeks later. Her single infant dose does not count
in that series — it was given at 4 months, below its 2-year minimum — so the
series is unstarted and its first dose is dated to her second birthday. Where a
risk series still needs a dose, the vaccine group forecast takes it, so the
group answers 2015-01-08.

Neither answer is a defect in arithmetic: CDC's is exactly 8 weeks after her
infant dose, cicada's is exactly her second birthday, and each follows the
series it comes from.

**Question for OE:** a child with a cochlear implant who received one PCV13 at 4
months and is now 3 years old — does current ACIP have her complete the routine
infant PCV catch-up (the next dose 8 weeks after the first), or does she move to
the 2-to-5-year high-risk schedule for cochlear implants, whose first dose
cannot be given before 24 months? The answer decides whether CDC's row is stale
in the same way as the eleven in section 9, or whether cicada is choosing the
wrong series for an incompletely vaccinated high-risk child.

---

## 12. ✅ `2018-0022` — ADJUDICATED FOR cicada, 2026-08-25

**"Age: Too Young" is the better description; CDC's "Inadvertent Vaccine" is
both the weaker clinical fit and impossible to produce from their own data.**

- *Too young* says the **right product** was given before the patient reached
  its minimum age — a timing error. *Inadvertent* says the **wrong product** was
  given. Heplisav-B is the correct adult HepB product in the correct series; she
  is five days short of 18. That is a timing defect, not a product defect.
- The pair `2018-0019` (−4 days, Valid on the grace) and `2018-0022` (−5 days,
  Not Valid) exists to test the **age grace boundary**. Age is the only variable
  that changes between them; nothing about product selection does. A reason of
  "inadvertent" would fail the second case for something the pair does not vary.
- The labels imply different corrective actions. *Too young* means repeat the
  same product once she is old enough — which is exactly what both engines
  forecast (2026-08-05, immediately, as she is now of age). *Inadvertent* invites
  the reviewer to reconsider **which** vaccine to use, which is actively
  misleading here.


The last failing healthy case, and the only one of the 1,064 that disagrees.
Previously filed as "not our bug" in the 37-case batch; raised again because the
reason CDC asserts is one their own supporting data cannot produce.

A patient born 2008-08-10 receives her **first** Heplisav-B (CVX 189, MVX DVX)
on 2026-08-05 — **18 years minus 5 days** — and is assessed the same day.

**CDC and cicada agree on everything except the reason:**

| field | CDC | cicada |
|---|---|---|
| series status | Not complete | Not complete ✅ |
| forecast # | 1 | 1 ✅ |
| earliest / recommended / past due | 2026-08-05 | all three ✅ |
| dose evaluation status | **Not Valid** | **Not Valid** ✅ |
| dose evaluation **reason** | **Inadvertent Vaccine** | *Age: Too Young* (Heplisav-B series) / *Not a preferable or allowable vaccine* (the others) |

**Why cicada says what it says.** Heplisav-B is licensed from 18 years, and the
"HepB Heplisav-B 2-dose series" carries a minimum age of 18 years with the usual
four-day grace. Five days early falls outside that grace, so the dose is not
valid on age. This case is deliberately paired with `2018-0019`, the same
scenario at **18 years minus 4 days**, where the grace does apply and the dose is
Valid — cicada gets that one right, and gets the *status* right here too.

🔑 **The reason CDC asserts does not exist in their data for this antigen** —
checked in CDC's published XML, not in our generated copy of it.
`AntigenSupportingData- HepB-508.xml` carries the `inadvertentVaccine` element
on **every** target dose, **62 of them, and every one is empty**
(`<inadvertentVaccine/>`); **not one is populated**. For contrast, in the same
release Polio populates 93, COVID-19 90, Tetanus and Diphtheria 36 each, RSV 34,
Pneumococcal 15, HPV 14 and Pertussis 6.

So the slot is present for hepatitis B and deliberately left blank, and no CDSi
engine reading this data can return "Inadvertent Vaccine" for a HepB dose —
CDC's own included. Our generator is faithful here: it emits zero for HepB,
matching the source.

**And cicada handles inadvertent vaccines correctly everywhere the data supports
them.** 15 healthy cases assert an "Inadvertent Vaccine" evaluation; **14 pass**.
The only failure is this one, the only HepB case among them. So this is not a
missing capability in the engine — it is the one antigen where CDC's test row
asks for a reason CDC's own data does not define.

**Questions for OE:**

1. Clinically, for a first Heplisav-B given 5 days before the 18th birthday: is
   the right characterisation that the patient was **too young** for the product,
   or that the **wrong product** was administered for her age band — i.e.
   inadvertent? Both make the dose invalid; they say different things to a
   reviewer reading the record, and they differ in what should be done next.
2. If "inadvertent" is right, then 4.65-508's HepB supporting data is missing an
   inadvertent-vaccine definition that CDC's own test row depends on, and this
   is a fourth data defect to report alongside orthopox observation 235.

🔑 **Report this as a defective test EXPECTATION, not as missing data.** The HepB
supporting data is self-consistent: it defines no inadvertent vaccines, and no
conformant engine can emit that reason for a HepB dose. Since "too young" is the
clinically correct reason anyway, there is **no reason to populate an
inadvertent-vaccine definition** to satisfy the row — the row's reason is simply
wrong. That makes it a **lesser-severity** finding than the orthopox
observation-235 gap, where the data really is missing something ACIP recommends.

**Do not conform.** cicada is right on status, forecast number, all three dates and the reason.

---

## 13. ✅ ADJUDICATED 2026-08-28 — the date administered is clinically forced

**OE: a genuine specification gap, and the clinically correct reading is the
date administered of the dose being evaluated — the reference date Tables 6-6
and 6-8 already carry. Table 6-7 omitting it is a drafting omission, not a
deliberate "end-state" instruction.**

All three candidate reference points give different answers, and only
date-administered satisfies both governing cases at once:

- **Dialysis HepB (`2024-UC-0019`) is decisive.** ACIP maintains a *separate*
  4-dose hemodialysis/immunocompromised HepB schedule as a distinct special
  situation from the routine 3-dose adult series (MMWR 72(6)). All four doses
  must count toward the risk series, and the standard group reaching Complete
  part-way through them must not suppress them.
- **Polio lab worker (`2016-UC-0133`) fails the opposite way** under an
  end-state reading: a single adult IPV booster given decades after a completed
  childhood series must not seed a fresh risk series as its dose 1.

🔴 **Consequence of the removal.** cicada's date-anchored behaviour was removed
for spec fidelity on 2026-08-28 (`842f89ad`). OE's note: that is defensible as
fidelity to the literal text, but **it knowingly produces a clinically wrong
evaluation for the dialysis patient** until CDC corrects Table 6-7. That
conformance-versus-correctness trade-off is a decision for the owner, not a
silent default.

**Report to CDC:** Table 6-7 needs the Conditional Skip Reference Date that
Tables 6-6 and 6-8 have.

---

## 14. ✅ ADJUDICATED 2026-08-28 — the spec is clearer than our implementation

**OE: two forecasts is the intended output.** On the three questions:

1. **Yes.** Per FORECASTVG-1 and Chapter 9, a patient with an active risk
   indication is intended to receive two forecasts for one vaccine group. The
   MMR traveller in the spec's own example is the paradigm case.
2. **No "present only one" rule exists.** The spec assumes both are returned;
   choosing one to display is left to the implementation or the consumer.
3. **No spec-blessed tie-break**, so cicada's risk-priority-with-conditions
   heuristic is an invented convention.

Clinically this is why the model exists: the routine age-based schedule and the
risk/travel schedule are different recommendations that can coexist and diverge
— the early-infant MMR travel dose that does not count toward the routine
2-dose series is the textbook case — and ACIP presents routine and special
situations in parallel, not merged.

🔑 **If we conform, the two cases that drove our heuristic stop being arguments
for suppressing a forecast and become arguments for how to label and order two.**
Each series group reports its own status independently, which is what the
two-forecast model gives.

✅ **Done 2026-08-28.** `vaccineGroupForecasts` is now
`Map<String, List<VaccineGroupForecast>>` — one entry per series group — and
`$immds-forecast` emits a recommendation for each. Measured over the condition
suite: 181 cases have a vaccine group carrying two forecasts, and the response
carries one recommendation per forecast in every one.

---
