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
