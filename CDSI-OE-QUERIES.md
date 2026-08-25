# CDSi cases where cicada says the CDC test row is wrong — for OpenEvidence

Companion to `CDSI-DISPUTED-CASES.md`. That file lists every case where cicada
and the CDC data differ. This one holds only the cases where, after checking
the workbook and the logic specification, **we concluded the CDC row itself is
defective** — the claims that most need an outside adjudicator, because the
CDC test suite is otherwise the reference.

Each entry gives CDC's published row, cicada's answer, our reasoning, and the
question to put to OE.

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
| 9. HPV, MSM (`2016-UC-0087`, `-0088`) | **cicada** — routine/catch-up, no distinct schedule | HPV "as for all males", catch-up through 26, SCDM 27–45 (MMWR 65(49), 68(32)) |
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

## 1. `2016-UC-0130` — pregnancy Tdap, forecast dated before the pregnancy

**CDC's published row** (underlying-conditions workbook v4.6, read from the
xlsx itself, not from our generated copy):

```
Test_Case_Name    Patient is pregnant, and at 27 weeks of gestation, and has
                  not received the Pertussis vaccine (Tdap)
DOB               1988-06-23        Gender  F
Observation_1     007  Pregnant
Observation_2     170  Onset of pregnancy   Observation_Date_2  2016-08-22
Assessment_Date   2016-08-22
Series_Status     Not Complete      Forecast_#  1
Earliest_Date     2016-02-27
Recommended_Date  2016-02-27
Past_Due_Date     2017-05-01
Admin_Guidance    Administer during each pregnancy (preferably during 27 to 36
                  weeks' gestation) regardless of interval since prior Td/Tdap.
Reason_For_Change v4.5: Added a forecast earliest date.
```

**Supporting data** (Pertussis risk 1-dose series, dose 1) sets the interval
from the "Onset of pregnancy" observation: absolute minimum 0 days, minimum and
earliest-recommended **27 weeks**, latest-recommended **36 weeks**.

**cicada answers:** earliest and recommended `2017-02-27`, past due
`2017-04-30`.

**Our reasoning:**

- Onset 2016-08-22 + 27 weeks = **2017-02-27**. CDC's 2016-02-27 is one year
  earlier — and therefore about six months *before* the onset of pregnancy
  recorded in their own row, i.e. a Tdap recommended before conception.
- Their own past-due column is 2017-05-01 = onset + 36 weeks exactly, so the
  anchor and the window are not in dispute; only the year in the earliest and
  recommended cells.
- On the past due: the logic specification (FORECASTDT-3) makes the past due
  date the latest recommended date **minus one day**, which gives 2017-04-30.
  CDC's cell is the un-decremented 2017-05-01.

**Questions for OE:**

1. For a patient whose pregnancy began 2016-08-22, does ACIP support a Tdap
   forecast dated 2016-02-27 — six months before that pregnancy began — or
   should the recommendation fall at 27 weeks' gestation (2017-02-27)?
2. ACIP recommends Tdap "preferably during the early part of gestational weeks
   27–36." If a dose is recommended across gestational weeks 27–36, on what
   date should the patient be considered *overdue*: the last day of that window
   (36 weeks, 2017-05-01) or the day after the window's last recommended day
   (2017-04-30)?

---

## 2. `2025-UC-0015` — HPV dose 3 past-due date, one day

**CDC's published row** (same workbook):

```
Test_Case_Name    Patient is female, 38 years of age, undergoing radiation
                  therapy, and has been administered the second dose of HPV
DOB               1986-08-03        Gender  F
Observation_1     159  Radiation therapy
Dose 1  2024-11-02  9vHPV (CVX 165)  Valid  risk
Dose 2  2024-11-30  9vHPV (CVX 165)  Valid  risk
Assessment_Date   2024-11-30
Series_Status     Not Complete      Forecast_#  3
Earliest_Date     2025-04-02
Recommended_Date  2025-05-02
Past_Due_Date     2025-06-30
```

**Supporting data** (HPV risk 3-dose series, dose 3) intervals from dose 1:
absolute minimum 5 months − 4 days, minimum 5 months, earliest recommended
6 months, latest recommended **7 months + 4 weeks**.

**cicada answers:** earliest `2025-04-02` and recommended `2025-05-02` — both
matching CDC — past due `2025-06-29`.

**Our reasoning:** dose 1 (2024-11-02) + 7 months + 4 weeks = 2025-06-30, and
FORECASTDT-3 subtracts one day → 2025-06-29. CDC's cell is the un-decremented
date. CDC applies the subtraction in other rows (`2015-UC-0012`,
`2016-UC-0032`), so this row and `2016-UC-0130` are the outliers: 3 past-due
mismatches in ~1,800 cases.

**Question for OE:** this is a convention question rather than a clinical one —
if the last recommended day for HPV dose 3 is 2025-06-30, is the patient
"overdue" *on* that date or the day after? Is there an ACIP or IIS convention
for when an interval-based dose becomes past due?

---

## How to use this file

Paste one section at a time. Any case where OE says the CDC row is right is a
cicada defect to fix; any case where OE agrees the row is defective should be
reported to CDC rather than conformed to.

---

## 3. `2022-UC-0030` / `-0031` — orthopox indication for healthcare personnel dropped

CDC's 2022 cases give the patient observation **235, "Healthcare personnel who
care for patients infected with more virulent orthopoxviruses (e.g., Variola
virus or mpox virus)"**, and expect a JYNNEOS (CVX 206) dose to be valid in a
risk series with a booster forecast two years later.

In the current supporting data (4.65-508, read from CDC's own
`AntigenSupportingData- Orthopoxvirus-508.xml`), the "Orthopoxvirus risk more
virulent 2-dose series" is indicated by **232** (research laboratory
personnel), **233** (clinical laboratory personnel) and **234** (designated
response team members) only. Observation 235 still exists in the schedule
supporting data, with the indication text "Administer to healthcare personnel
who care for patients infected with more virulent orthopoxviruses" — but no
series names it. cicada therefore produces no orthopox series at all for these
patients, which follows the data it was given.

**Question for OE:** does ACIP still recommend JYNNEOS pre-exposure vaccination
for healthcare personnel who care for patients infected with more virulent
orthopoxviruses, or has that recommendation been narrowed to laboratory and
response-team personnel? If it stands, CDSi's supporting data has dropped an
indication it still defines, and that is worth reporting to CDC.

---

## 4. `2023-UC-0047` — infant RSV risk indication: chronic lung disease

CDC's 2023 case gives an 8-month-old observation **017, "Chronic lung
disease"**, and expects a nirsevimab forecast at the season start.

In 4.65-508 the infant series ("RSV risk under 20 months series") is indicated
by **280, "Chronic lung disease of prematurity"**, together with cystic
fibrosis, American Indian or Alaska Native, and severe immunocompromise. Plain
017 now belongs to the *adult* "RSV risk 50-74 years" series. cicada selects no
infant series for this patient.

**Question for OE:** for the second-season nirsevimab recommendation in
children aged 8–19 months at increased risk, is the qualifying condition
chronic lung disease **of prematurity** specifically (requiring medical support
in the 6 months before the second season), or chronic lung disease generally?

---

## 5. `2017-UC-0015` — cholera minimum age, 2 years or 18 years

CDC's 2017 case is a 35-year-old travelling to an area of active cholera
transmission (observation 008), and expects the first dose to be forecast at
**18 years** of age (2000-02-17 for a patient born 1982-02-17).

CDSi's current supporting data says **2 years**: `AntigenSupportingData-
Cholera-508.xml` gives the "Cholera 1-dose series" dose 1 an absolute minimum
age of 2 years − 4 days and a minimum age of 2 years, which is what cicada
forecasts (1984-02-17). The case predates that; Vaxchora was licensed for
adults 18–64 when it was written.

**Question for OE:** what is the current ACIP-recommended minimum age for
Vaxchora (CVX 174, lyophilized CVD 103-HgR) — 2 years or 18? If it is 2 years,
CDC's test row is simply stale and cicada matches their own current data.

---

## 6. `2016-UC-0198` — which meningococcal risk series applies to a 39-year-old

**This one we have not resolved, and it is not a data-version question.**

The patient is a 39-year-old microbiologist routinely exposed to *Neisseria
meningitidis* (observation 050) who also travels to countries where
meningococcal disease is hyperendemic (observation 164). Both observations are
active; no doses administered.

Two risk series in the same series group are relevant, and the current
supporting data gives them:

| series | series priority | minimum age to start | indication ages |
|---|---|---|---|
| Meningococcal ACWY risk 2-23 month | **A** | none | 164 from 2 months, no end age |
| Meningococcal ACWY risk 1-dose series | B | 2 years | 050 from 19 years; 164 from 2 years |

CDC expects earliest and recommended **1979-07-13** — the patient's second
birthday, i.e. the *1-dose* (priority B) series. cicada answers from the
**2-23 month** series, forecasting dose 4 at the patient's seventh month of
life (1978-02-13), because the logic specification's SELECTSCORE-2 makes only
the highest-priority risk series scorable, and that is priority A.

The infant series carries no maximum age to start and none of its doses carry
a maximum age, so nothing in the data ages a 39-year-old out of it; its
conditional skips are dose-count conditions, not age conditions.

**Questions for OE:**

1. For a 39-year-old microbiologist with routine exposure to *N. meningitidis*
   who also travels to hyperendemic areas, what does ACIP recommend — a single
   MenACWY dose (with boosters), or the infant 2–23-month multi-dose schedule?
   (We are confident of the answer; it is worth stating for the record.)
2. Is there any published CDSi guidance for choosing between two risk series in
   one series group when the higher-priority series is written for infants and
   carries no maximum age? This looks like a gap in the supporting data — the
   infant series has no maximum age to start — rather than a defect in either
   engine.

---

## 7. `2016-UC-0173` and `-0178` — what does the pneumococcal 5-year interval run from?

Both cases are immunocompromised adults in the "Pneumococcal risk 19+ years
immunocompromised PPSV-PCV-PPSV" series whose most recent dose is a PCV13
given after their PPSV23:

| case | doses | CDC expects | cicada answers |
|---|---|---|---|
| 2016-UC-0173 | PPSV23 2016-08-21, PCV13 2017-08-21 | dose 3 on **2021-08-21** (5y after the PPSV23) | 2022-08-21 (5y after the PCV13) |
| 2016-UC-0178 | PPSV23 2006-08-03, PPSV23 2011-08-03, PCV13 2012-08-03 | dose 4 on **2016-08-03** (5y after the last PPSV23) | 2017-08-03 (5y after the PCV13) |

CDC's own change note on the first case says "Updated earliest and recommended
forecast date to 5 years after most previous dose of PPSV23" (v4.1, 2019).

But the current supporting data does not say that. In `AntigenSupportingData-
Pneumococcal-508.xml` that series' dose 3 carries a single interval —
`fromPrevious = Y`, minimum and earliest recommended interval 5 years — i.e.
five years from **whatever dose came last**, which is what cicada forecasts.
The series was also rebuilt for the PCV20/PCV21 era, and its forecast vaccine
is now PCV20 or PCV21 rather than a second PPSV23.

**Question for OE:** for an immunocompromised adult who received PPSV23 and
then PCV13, when is the next pneumococcal dose due under current ACIP — five
years after the PPSV23, five years after the most recent dose whatever it was,
or has the PCV20/PCV21 recommendation replaced this sequencing altogether? The
answer decides whether these two rows are stale or whether the supporting data
is wrong.

---

## 8. ✅ `2016-UC-0110` — infant MenACWY 4th dose: 6 months after dose 3, or at 12 months of age?

**This case was never triaged.** It failed the condition suite from the start
and was left out of `CDSI-DISPUTED-CASES.md` because that report's case list was
typed by hand and this id carries a trailing space (`'2016-UC-0110 '`), so it
does not survive a copy-paste out of the suite output. The report now derives
its own list, and the case has been checked at every commit of the defect-fix
session — it never passed, so nothing we changed caused it.

An infant with anatomical or functional asplenia (observation 160), born
2015-02-14, given MenACWY-O (CVX 136, MVX NOV) at 2015-04-14, 2015-06-09 and
2015-08-04; assessed the day of the third dose.

| column | CDC | cicada |
|---|---|---|
| series status | Not Complete | Not Complete ✅ |
| forecast # | 4 | 4 ✅ |
| **earliest** | **2016-02-04** (dose 3 + 6 months) | **2016-02-14** |
| recommended | 2016-02-14 (the first birthday) | 2016-02-14 ✅ |

Only the earliest date differs, by ten days, and cicada's is the later — the
more conservative — of the two.

**Why they differ.** CDC's row is labelled `Forecast_Test_Type: Recommended
based on interval` and was last touched in v4.2 (2021-06-11): their earliest is
driven by a six-month interval from dose 3. The supporting data no longer has
that interval. In 4.65-508 — and identically in 4.64, so this is not a
regression from the version bump — "Meningococcal ACWY risk 2-23 month" runs to
seven doses, and:

- dose 4 carries a conditional skip, *"not required if more than 2 doses have
  been administered between 2 and 7 months OR at least 1 dose on or after 7
  months"*. This patient's three doses all fall between 2 and 7 months, so it
  is skipped;
- dose 5 — the 12-month dose — carries minimum age 12 months and a minimum
  interval of 12 weeks from the previous dose.

Per FORECASTDTCAN-1 the candidate earliest date is the latest of the **minimum**
age date and the minimum interval dates (absolute minimums belong to evaluation,
not forecasting), so it is 2016-02-14 — the first birthday — and the six-month
interval CDC's row is testing exists nowhere in the current series. cicada's
answer also matches the ACIP Menveo infant schedule of 2, 4, 6 and 12 months.

**Question for OE:** for an infant with asplenia who completed MenACWY-O at 2, 4
and 6 months, may the fourth dose be given six months after the third — i.e. ten
days before the first birthday — or does current ACIP require 12 months of age?
The answer decides whether CDC's row is simply stale against their own newer
supporting data, which is what we believe, or whether the data dropped an
interval it should still carry.

---

## 9. ✅ Eleven condition rows that ask for a series the supporting data no longer has

Found by classifying every failing case on 2026-08-24. These are **not** engine
disagreements: in each one cicada follows the supporting data it ships and the
spec rule named, and CDC's row encodes an older version of the data. Each was
checked against **4.64 as well as 4.65-508**, so none is a regression from the
version upgrade. Grouped because one question settles most of them.

| case | CDC's row wants | what the current data says |
|---|---|---|
| `2016-UC-0079` | HPV dose evaluated in a **risk** series (history of sexual abuse, obs 169) | that indication now **ends at 11 years**; the patient is 12 at assessment, and Table 5-4 tests the **assessment date** |
| `2016-UC-0087`, `-0088` | HPV risk series for MSM (obs 036) | **no** HPV risk series is indicated by 036 any more |
| `2020-UC-0003` | MenB risk 2-dose series (obs 177, "seeks MenB protection") | 177 drives no risk series; MenB is now four **Standard** shared-clinical-decision-making series |
| `2016-UC-0203` | MenB dose in a risk series (obs 116) | 116 is a contraindication code and indicates no series. cicada's status **is** Contraindicated, matching CDC |
| `2025-UC-0010` | Zoster dose in a risk series (obs 172) | same shape |
| `2016-UC-0032` | MMR past due six years out | that dose carries **no latest recommended interval** in either data version |
| `2022-UC-0017` | pneumococcal earliest 8 weeks after PCV15 | the dose carries `minInt: 1 year`. cicada's **recommended** date matches CDC exactly; only the earliest differs |
| `2016-UC-0110` | MenACWY 4th dose 6 months after dose 3 | see section 8 |

**Question for OE (one covers the group):** for each of these — a patient with a
history of sexual abuse aged over 11, a man who has sex with men, an adult
seeking MenB protection, an adult who had PCV15 — does current ACIP still
define a *distinct risk schedule*, or has that group been folded into the
routine recommendation? If it has, CDC's rows are simply stale against their own
newer supporting data, which is what we believe.

## 10. ✅ `2016-UC-0057` — a row that contradicts its own dates

The test name says the patient is **18 months** old; the row's own DOB
(2014-08-10) and assessment date (2015-01-10) make her **5 months**. She has
persistent complement/properdin/factor B deficiency (obs 151) and one Hib dose,
given the day of assessment.

CDC expects the next Hib dose at **2015-08-10**, exactly her first birthday.
That is the begin age of the risk indication, and the minimum age of the "Hib
risk child 2-dose series" — a **12-month-to-5-year booster** series. Table 5-4
says an indication applies only when its begin age date ≤ **assessment date**,
and at 5 months she has not reached it, so cicada keeps her on the routine
infant schedule and forecasts her next dose 4 weeks after the first
(2015-02-07).

**Question for OE:** a 5-month-old with persistent complement deficiency who has
had one Hib dose — is the next dose due 4 weeks later on the routine infant
schedule, or should she wait until 12 months? We believe 4 weeks, and that
CDC's row is testing the 18-month patient its name describes rather than the
5-month-old its dates describe.

---

## 11. 🔴 `2016-UC-0153` — ADJUDICATED AGAINST cicada TWICE, on the corrected premise

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

## 11. (superseded framing) `2016-UC-0153` — ADJUDICATED AGAINST cicada, 2026-08-24

**OE ruled for CDC's row.** ACIP is explicit that interruption of the schedule
"does not require reinstitution of the entire series or the addition of extra
doses" (MMWR 71(37)) — the dose given at 4 months **counts**. An incompletely
vaccinated high-risk child aged 24–71 months is **caught up now**, on the
catch-up interval from her most recent dose; she does not restart at 24 months
and does not wait for it. Her remaining course is 2 more PCV doses ≥8 weeks
apart, then PPSV23 (or a single PCV20 in lieu) ≥8 weeks after the last PCV.

🔑 **The defect:** cicada treats the 2–5-year risk series as *unstarted*, because
her infant dose falls below that series' 2-year minimum age, and lets that
unstarted series set the vaccine group's dates — deferring to her second
birthday. The aggregation already knows this is a hazard: where best patient
series of mixed type are blended it computes the **dose number** from the union
of valid doses across all of them, precisely because "the risk series may not see
childhood doses", and then still takes the risk series for the **dates**. So the
history carries into the count and not into the schedule.

⚠️ **The premise OE was given was mine, and it was incomplete — reopen before
acting.** Section 11 below said her infant dose "does not count" in the risk
series. That is true of *satisfying a target dose* and false of the interval,
and the difference decides the case. Measured in the data and the trace:

- Her infant dose **is** evaluated in the risk series (Not Valid, too young) and
  is **not** discarded.
- That series' dose 1 carries an interval `fromPrevious: N`,
  `fromMostRecent: "133; 215; 216"` — PCV13, PCV15, PCV20 — with a minimum
  interval of 8 weeks. It resolves **to her infant dose**, giving
  2013-05-08 + 8 weeks = **2013-07-03, which is exactly CDC's date.** cicada
  anchors to the prior dose, as ACIP requires.
- The same dose 1 also carries `absMinAge`, `minAge` and `earliestRecAge` of
  **2 years**, with no grace period.
- FORECASTDTCAN-1 takes the **latest** of the minimum age date and the minimum
  interval dates. 2015-01-08 is later than 2013-07-03, so the age floor wins.

So cicada is not deferring her out of a catch-up: it is applying a two-year
minimum age that **CDC's own supporting data puts on that dose**, and CDC's row
reports the interval date while ignoring it. At the assessment date she is 3
years old, so both answers mean the same thing clinically — overdue, vaccinate
now — and they differ only in the earliest date reported.

Conforming to CDC's row would mean ignoring a stated absolute minimum age, which
FORECASTDTCAN-1 does not permit. **No engine change is being made on this
evidence.**

**Sharpened question for OE:** given that CDC's own 4.65-508 data sets an
absolute minimum age of 2 years on the first dose of the
"Pneumococcal risk 2-5 years Chronic Medical Conditions PCV-PCV-PPSV" series —
is that 2-year floor correct under current ACIP for a child with a cochlear
implant who already has a countable infant PCV dose, or should the catch-up dose
be available at 8 weeks after the prior dose regardless of age? If the floor is
correct, CDC's test row contradicts CDC's supporting data. If it is not, the
supporting data is the thing to report.

---

## 11. `2016-UC-0153` — a 3-year-old with a cochlear implant and one infant PCV dose

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
