# CDSi cases where cicada says the CDC test row is wrong — for OpenEvidence

Companion to `CDSI-DISPUTED-CASES.md`. That file lists every case where cicada
and the CDC data differ. This one holds only the cases where, after checking
the workbook and the logic specification, **we concluded the CDC row itself is
defective** — the claims that most need an outside adjudicator, because the
CDC test suite is otherwise the reference.

Each entry gives CDC's published row, cicada's answer, our reasoning, and the
question to put to OE.

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
