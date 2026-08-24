# CDSi test cases where cicada disagrees with the CDC data

cicada implements the CDSi logic specification v4.6 against supporting data 4.65-508 (August 2026). Each case below is printed as CDC published it — every populated column of their row — followed by what cicada answers. The question is which answer is clinically correct.

**Version note.** The healthy cases are v4.46 (August 2026) and match the supporting data. The underlying-conditions cases are v4.6 (September 2025) and predate it, so some of those disagreements may be the two documents describing different seasons or thresholds rather than an error by either side — the RSV ones especially: the shipped data carries only the 2025-26 season (infant series opens 2025-10-01, maternal 2025-09-01) while those cases were written against 2023-24.


## Healthy childhood and adult cases (v4.46 — versions match, so these are the sharpest)

Source: `cdsi-healthy-childhood-and-adult-test-cases-v4.46.xlsx`, sheet "FITS Exported TestCases".

### 2018-0022

CDC row, every populated column:

```
CDC_Test_ID              2018-0022
Test_Case_Name           Hep B: Patient is 18 years - 5 days with first dose of Hep B (Hepislav) vaccine
DOB                      2008-08-10
gender                   F
Series_Status            Not complete
Date_Administered_1      2026-08-05
Vaccine_Name_1           HEPLISAV-B
CVX_1                    189
MVX_1                    DVX
Evaluation_Status_1      Not Valid
Evaluation_Reason_1      Inadvertent Vaccine
Forecast_#               1
Earliest_Date            2026-08-05
Recommended_Date         2026-08-05
Past_Due_Date            2026-08-05
Vaccine_Group            HepB
Assessment_Date          2026-08-05
Evaluation_Test_Type     Interval: Below Absolute Minimum
Date_Added               2018-04-13
Date_Updated             2021-06-28
Forecast_Test_Type       Recommended based on age
Reason_For_Change        v4.1: Updated forecast dates to reflect a 0 day interval for administration of any age appropriate HepB vaccine. 
v4.0: Updated dose #1 to reflect an invalid dose reason of 'Vaccine product was not a preferable or allowable vaccine for this series'.
v3.5: Updated dose #1 to reflect an invalid dose reason of Vaccine Dose Administered was administered at too young of an age.
Changed_In_Version       4.1
General_Description      This test cases describes when a patient is administered a dose of the Hep B (Heplisav) vaccine at 18 years - 5 days that the dose is not valid.
```

**cicada answers:** status `Not Complete`, forecast #`1`, earliest `2026/08/05`, recommended `2026/08/05`, past due `2026/08/05`.


## Underlying-conditions cases (v4.6 — predate the supporting data)

Source: `CDSi-underlying-conditions-test-cases-v4.6.xlsx`, sheet "Underlying Condition Test Cases".

### 2016-UC-0032

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0032
Test_Case_Name           MMR: Patient is a healthcare worker, born before 1957, has received one dose of the MMR vaccine.
DOB                      1955-08-12
Gender                   F
Observation_Code_1       055
Observation_Text_1       Health care personnel
Series_Status            Not Complete
Date_Administered_1      2015-04-30
Vaccine_Name_1           MMR
CVX_1                    03
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            standard
Forecast_#               2
Earliest_Date            2015-05-28
Recommended_Date         2015-05-28
Past_Due_Date            2021-05-27
Vaccine_Group            MMR
Assessment_Date          2015-04-30
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2015-06-23
Date_updated             2019-12-05
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        V4.1 added past due date
v 4.0 Updated to reflect that if a patient is a healthcare worker and has received one dose of the MMR vaccine that a second dose should be administered 4 weeks later. Added description.
Changed_In_Version       4.1
```

**cicada answers:** status `Not Complete`, forecast #`2`, earliest `2015/05/28`, recommended `2015/05/28`, past due `2015/05/28`.

### 2016-UC-0057

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0057
Test_Case_Name           Patient is 18 months of age, has Persistent complement, properdin, or factor B deficiency and has received only one dose of the Hib vaccine before 12 months of age.
DOB                      2014-08-10
Gender                   F
Observation_Code_1       151
Observation_Text_1       Persistent complement, properdin, or factor B deficiency
Series_Status            Not Complete
Date_Administered_1      2015-01-10
Vaccine_Name_1           PRP-OMP
CVX_1                    49
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            standard
Forecast_#               2
Earliest_Date            2015-08-10
Recommended_Date         2015-08-10
Vaccine_Group            Hib
Assessment_Date          2015-01-10
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-08-25
Date_updated             2019-07-29
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        Added description, updated assessment date
Changed_In_Version       4.0
```

**cicada answers:** status `Not Complete`, forecast #`2`, earliest `2015/02/07`, recommended `2015/02/07`, past due `2015/02/07`.

### 2016-UC-0060

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0060
Test_Case_Name           Patient is 36 months of age, and has anatomical or functional asplenia  and has received two  dose of the Standard Hib vaccine before 12 months of age.
DOB                      2013-04-22
Gender                   M
Observation_Code_1       004
Observation_Text_1       Recipient of a hematopoietic stem cell transplant
Series_Status            Not Complete
Date_Administered_1      2013-06-10
Vaccine_Name_1           PRP-T
CVX_1                    48
MVX_1                    PMC
Evaluation_Status_1      Valid
Series_Type_1            standard
Date_Administered_2      2013-07-08
Vaccine_Name_2           PRP-T
CVX_2                    48
MVX_2                    PMC
Evaluation_Status_2      Valid
Series_Type_2            standard
Forecast_#               3
Earliest_Date            2013-09-02
Recommended_Date         2013-09-02
Vaccine_Group            Hib
Assessment_Date          2013-07-08
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-08-11
Date_updated             2019-04-25
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        v4.0 Updated to display accurate forecasting date based on ACIP recommendations
Changed_In_Version       4.0
```

**cicada answers:** status `Not Complete`, forecast #`3`, earliest `2013/08/05`, recommended `2013/08/05`, past due `2013/08/05`.

### 2016-UC-0079

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0079
Test_Case_Name           Patient is 11 years of age, female, has a history of sexual abuse/assault, and has received two doses  of the HPV risk female 2 dose series
DOB                      2005-03-03
Gender                   F
Observation_Code_1       169
Observation_Text_1       History of sexual abuse or assault
Series_Status            Complete
Date_Administered_1      2016-12-19
Vaccine_Name_1           9vHPV
CVX_1                    165
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            standard
Date_Administered_2      2017-06-01
Vaccine_Name_2           9vHPV
CVX_2                    165
MVX_2                    MSD
Evaluation_Status_2      Valid
Series_Type_2            risk
Forecast_#               -
Vaccine_Group            HPV
Assessment_Date          2017-06-01
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-08-16
Date_updated             2019-01-09
Forecast_Test_Type       Not Recommended: Series Complete
Reason_For_Change        New HPV 2 dose recommendation, added description
Changed_In_Version       4.0
```

**cicada answers:** status `Complete`, forecast #`null`, earliest `null`, recommended `null`, past due `null`.

### 2016-UC-0087

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0087
Test_Case_Name           Patient is an adult male, MSM, and has received the second dose of the HPV risk adult male 3 dose series.
DOB                      1988-01-23
Gender                   M
Observation_Code_1       036
Observation_Text_1       Men who have sex with men
Series_Status            Not Complete
Date_Administered_1      2014-04-03
Vaccine_Name_1           4vHPV
CVX_1                    62
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            standard
Date_Administered_2      2014-05-01
Vaccine_Name_2           4vHPV
CVX_2                    62
MVX_2                    MSD
Evaluation_Status_2      Valid
Series_Type_2            risk
Forecast_#               3
Earliest_Date            2014-09-03
Recommended_Date         2014-10-03
Past_Due_Date            2014-11-30
Vaccine_Group            HPV
Assessment_Date          2014-05-01
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-08-18
Date_updated             2019-01-09
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        Updated Earliest, Recommended, and past due date based on HPV Recommendations, added description
Changed_In_Version       4.0
```

**cicada answers:** status `Not Complete`, forecast #`3`, earliest `2014/09/03`, recommended `2014/10/03`, past due `2014/11/30`.

### 2016-UC-0088

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0088
Test_Case_Name           Patient is an adult male, MSM, and has received all three doses of the HPV risk adult male 3-dose series.
DOB                      1990-03-01
Gender                   M
Observation_Code_1       036
Observation_Text_1       Men who have sex with men
Series_Status            Complete
Date_Administered_1      2015-03-28
Vaccine_Name_1           4vHPV
CVX_1                    62
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            standard
Date_Administered_2      2015-04-25
Vaccine_Name_2           4vHPV
CVX_2                    62
MVX_2                    MSD
Evaluation_Status_2      Valid
Series_Type_2            risk
Date_Administered_3      2015-09-14
Vaccine_Name_3           4vHPV
CVX_3                    62
MVX_3                    MSD
Evaluation_Status_3      Valid
Series_Type_3            risk
Forecast_#               -
Vaccine_Group            HPV
Assessment_Date          2015-09-14
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-08-18
Date_updated             2019-01-09
Forecast_Test_Type       Not Recommended: Series Complete
Reason_For_Change        Added description
Changed_In_Version       4.0
```

**cicada answers:** status `Complete`, forecast #`null`, earliest `null`, recommended `null`, past due `null`.

### 2016-UC-0110

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0110
Test_Case_Name           Patient is an  infant with anatomical or functional asplenia and has receive the third  dose of the Meningococcal ACWY vaccine.
DOB                      2015-02-14
Gender                   M
Observation_Code_1       160
Observation_Text_1       Anatomical or functional asplenia
Series_Status            Not Complete
Date_Administered_1      2015-04-14
Vaccine_Name_1           Meningococcal, MCV4O
CVX_1                    136
MVX_1                    NOV
Evaluation_Status_1      Valid
Series_Type_1            risk
Date_Administered_2      2015-06-09
Vaccine_Name_2           Meningococcal, MCV4O
CVX_2                    136
MVX_2                    NOV
Evaluation_Status_2      Valid
Series_Type_2            risk
Date_Administered_3      2015-08-04
Vaccine_Name_3           Meningococcal, MCV4O
CVX_3                    136
MVX_3                    NOV
Evaluation_Status_3      Valid
Series_Type_3            risk
Forecast_#               4
Earliest_Date            2016-02-04
Recommended_Date         2016-02-14
Administrative_Guidance  If MenACWY-D is used, it should be administered at least 4 weeks after completion of all PCV doses.
Vaccine_Group            Meningococcal
Assessment_Date          2015-08-04
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-09-08
Date_updated             2021-06-11
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        Updated the Recommended Date
Changed_In_Version       4.2
```

**cicada answers:** status `Not Complete`, forecast #`4`, earliest `2016/02/14`, recommended `2016/02/14`, past due `2016/02/14`.

### 2016-UC-0130

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0130
Test_Case_Name           Patient is pregnant, and at 27 weeks of gestation, and has not received the Pertussis vaccine (Tdap)
DOB                      1988-06-23
Gender                   F
Observation_Code_1       007
Observation_Text_1       Pregnant
Observation_Code_2       170
Observation_Text_2       Onset of pregnancy
Observation_Date_2       2016-08-22
Series_Status            Not Complete
Forecast_#               1
Earliest_Date            2016-02-27
Recommended_Date         2016-02-27
Past_Due_Date            2017-05-01
Administrative_Guidance  Administer during each pregnancy (preferably during 27 to 36 weeks’ gestation) regardless of interval since prior Td or Tdap vaccination.
Vaccine_Group            DTaP
Assessment_Date          2016-08-22
Evaluation_Test_Type     No Doses Administered
Date_added               2016-08-23
Date_updated             2024-04-24
Forecast_Test_Type       Recommended based on Condition
Reason_For_Change        v4.5: Added a forecast earliest date.
v4.0: added description
Changed_In_Version       4.5
```

**cicada answers:** status `Not Complete`, forecast #`1`, earliest `2017/02/27`, recommended `2017/02/27`, past due `2017/04/30`.

### 2016-UC-0153

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0153
Test_Case_Name           Child is 3 years old with cochlear implants,  and has an incomplete schedule (only received 1 dose at 4 months) of the PCV series.
DOB                      2013-01-08
Gender                   M
Observation_Code_1       011
Observation_Text_1       Cochlear implants
Series_Status            Not Complete
Date_Administered_1      2013-05-08
Vaccine_Name_1           PCV13
CVX_1                    133
MVX_1                    PFR
Evaluation_Status_1      Valid
Series_Type_1            standard
Forecast_#               2
Earliest_Date            2013-07-03
Recommended_Date         2013-07-03
Administrative_Guidance  When cochlear implant placement is being planned, PCV13 and/or PPSV23 vaccination should be completed at least 2 weeks before surgery or initiation of therapy.
Vaccine_Group            Pneumococcal
Assessment_Date          2016-02-12
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-08-30
Date_updated             2019-01-17
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        Updated to reflect the correct forecasting date, added description.
Changed_In_Version       4.0
```

**cicada answers:** status `Not Complete`, forecast #`2`, earliest `2015/01/08`, recommended `2015/01/08`, past due `2015/01/08`.

### 2016-UC-0165

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0165
Test_Case_Name           Patient is an adult, has cochlear implants, has received PCV13 one year after the PPSV23 vaccine dose.
DOB                      1977-05-01
Gender                   M
Observation_Code_1       011
Observation_Text_1       Cochlear implants
Series_Status            Not Complete
Date_Administered_1      2016-08-01
Vaccine_Name_1           PPSV23
CVX_1                    33
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            risk
Date_Administered_2      2017-08-01
Vaccine_Name_2           PCV13
CVX_2                    133
MVX_2                    PFR
Evaluation_Status_2      Valid
Series_Type_2            risk
Forecast_#               3
Earliest_Date            2021-08-01
Recommended_Date         2021-08-01
Administrative_Guidance  When cochlear implant placement is being planned, PCV13 and/or PPSV23 vaccination should be completed at least 2 weeks before surgery or initiation of therapy.
Vaccine_Group            Pneumococcal
Assessment_Date          2017-08-01
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-09-02
Date_updated             2024-04-24
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        v4.5: Updated test case to forecast another dose.
Updated forecast vaccine type, added description
Changed_In_Version       4.5
```

**cicada answers:** status `Not Complete`, forecast #`3`, earliest `2022/08/01`, recommended `2022/08/01`, past due `2022/08/01`.

### 2016-UC-0173

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0173
Test_Case_Name           Patient is 22 years of age with General malignant neoplasm and has received a dose of PPSV23 and a dose PCV13 at a year later.
DOB                      1994-06-13
Gender                   M
Observation_Code_1       156
Observation_Text_1       Generalized malignant neoplasm
Series_Status            Not Complete
Date_Administered_1      2016-08-21
Vaccine_Name_1           PPSV23
CVX_1                    33
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            risk
Date_Administered_2      2017-08-21
Vaccine_Name_2           PCV13
CVX_2                    133
MVX_2                    PFR
Evaluation_Status_2      Valid
Series_Type_2            risk
Forecast_#               3
Earliest_Date            2021-08-21
Recommended_Date         2021-08-21
Vaccine_Group            Pneumococcal
Assessment_Date          2017-08-21
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-09-02
Date_updated             2019-12-02
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        Updated earliest and recommended forecast date to 5 years after most previous dose of PPSV23, added description
Changed_In_Version       4.1
```

**cicada answers:** status `Not Complete`, forecast #`3`, earliest `2022/08/21`, recommended `2022/08/21`, past due `2022/08/21`.

### 2016-UC-0178

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0178
Test_Case_Name           Patient is 26 years of age with nephrotic syndrome, and has received two doses of the PPSV vaccine and a dose of the PCV13 vaccine
DOB                      1986-07-02
Gender                   M
Observation_Code_1       167
Observation_Text_1       Nephrotic Syndrome
Series_Status            Not Complete
Date_Administered_1      2006-08-03
Vaccine_Name_1           PPSV23
CVX_1                    33
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            risk
Date_Administered_2      2011-08-03
Vaccine_Name_2           PPSV23
CVX_2                    33
MVX_2                    MSD
Evaluation_Status_2      Valid
Series_Type_2            risk
Date_Administered_3      2012-08-03
Vaccine_Name_3           PCV13
CVX_3                    133
MVX_3                    PFR
Evaluation_Status_3      Valid
Series_Type_3            Risk
Forecast_#               4
Earliest_Date            2016-08-03
Recommended_Date         2016-08-03
Vaccine_Group            Pneumococcal
Assessment_Date          2012-08-03
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-09-06
Date_updated             2024-01-09
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        v4.5:  Updated the test case status to "Not Complete and forecast another dose and added description
Changed_In_Version       4.5
```

**cicada answers:** status `Not Complete`, forecast #`4`, earliest `2017/08/03`, recommended `2017/08/03`, past due `2017/08/03`.

### 2016-UC-0203

CDC row, every populated column:

```
CDC_Test_ID              2016-UC-0203
Test_Case_Name           Patient has had a severe allergic reaction after previous dose of Meningococcal B vaccine.
DOB                      1995-01-13
Gender                   M
Observation_Code_1       116
Observation_Text_1       Severe allergic reaction after previous dose of Meningococcal B
Series_Status            Contraindicated
Date_Administered_1      2016-06-28
Vaccine_Name_1           Meningococcal B, OMV
CVX_1                    163
MVX_1                    NOV
Evaluation_Status_1      Valid
Series_Type_1            risk
Forecast_#               -
Vaccine_Group            Meningococcal B
Assessment_Date          2016-06-28
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2016-09-19
Date_updated             2024-06-24
Forecast_Test_Type       Not recommended: contraindicated
Reason_For_Change        v4.6 Removed the observation code of 001 - patient seeks protection since this now falls under SCDM in the standard series.  Updated the General desription to remove the patient is seek protection text.
v.4.0  Updated to reflect an additional contraindication/observation. Added description
Changed_In_Version       4.6
```

**cicada answers:** status `Contraindicated`, forecast #`2`, earliest `null`, recommended `null`, past due `null`.

### 2017-UC-0015

CDC row, every populated column:

```
CDC_Test_ID              2017-UC-0015
Test_Case_Name           Patient is 35 years of age and is traveling to a country that has active cholera transmission.
DOB                      1982-02-17
Gender                   M
Observation_Code_1       008
Observation_Text_1       Travel to an area of active cholera transmission
Series_Status            Not Complete
Forecast_#               1
Earliest_Date            2000-02-17
Recommended_Date         2000-02-17
Vaccine_Group            Cholera
Assessment_Date          2017-07-18
Evaluation_Test_Type     No Doses Administered
Date_added               2017-07-18
Date_updated             2019-03-26
Forecast_Test_Type       Recommended based on Condition
Reason_For_Change        Added description
Changed_In_Version       4.0
```

**cicada answers:** status `Not Complete`, forecast #`1`, earliest `1984/02/17`, recommended `1984/02/17`, past due `1984/02/17`.

### 2020-UC-0003

CDC row, every populated column:

```
CDC_Test_ID              2020-UC-0003
Test_Case_Name           Patient is an adult seeking protection from MenB and has received dose #2 of the Risk 2 dose MenB-FH-bp at an interval of 4 months.
DOB                      2000-06-01
Gender                   M
Observation_Code_1       177
Observation_Text_1       Patient seeks Meningococcal B protection
Series_Status            Not Complete
Date_Administered_1      2018-06-01
Vaccine_Name_1           Meningococcal B, recombinant
CVX_1                    162
MVX_1                    PFR
Evaluation_Status_1      Valid
Series_Type_1            risk
Date_Administered_2      2018-10-01
Vaccine_Name_2           meningococcal B, recombinant
CVX_2                    162
MVX_2                    PFR
Evaluation_Status_2      Not Valid
Series_Type_2            Risk
Evaluation_Reason_2      Interval too soon
Forecast_#               2
Earliest_Date            2019-02-01
Recommended_Date         2019-02-01
Vaccine_Group            Meningococcal B
Assessment_Date          2018-10-01
Evaluation_Test_Type     Interval: Below Absolute Minimum
Date_added               2024-04-22
Date_updated             2024-04-22
Forecast_Test_Type       Recommended based on interval
Changed_In_Version       4.5
```

**cicada answers:** status `Not Complete`, forecast #`3`, earliest `2019/02/01`, recommended `2019/02/01`, past due `2019/02/01`.

### 2022-UC-0017

CDC row, every populated column:

```
CDC_Test_ID              2022-UC-0017
Test_Case_Name           Patient is an adult with diabetes and has received a PCV15 vaccine.
DOB                      1989-10-17
Gender                   F
Observation_Code_1       014
Observation_Text_1       Diabetes
Series_Status            Not Complete
Date_Administered_1      2022-01-24
Vaccine_Name_1           PCV15
CVX_1                    215
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            risk
Forecast_#               2
Earliest_Date            2022-03-21
Recommended_Date         2023-01-24
Vaccine_Group            Pneumococcal
Assessment_Date          2022-01-24
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2022-03-22
Date_updated             2022-03-22
Forecast_Test_Type       Recommended based on interval
Changed_In_Version       4.4
```

**cicada answers:** status `Not Complete`, forecast #`2`, earliest `2023/01/24`, recommended `2023/01/24`, past due `2023/01/24`.

### 2022-UC-0030

CDC row, every populated column:

```
CDC_Test_ID              2022-UC-0030
Test_Case_Name           Patient is a healthcare personnel worker who cares for patients infected with a more virulent orthopoxvirus and has been administered a dose of the Orthopoxirus (Jynneos) vaccine.
DOB                      1969-10-19
Gender                   M
Observation_Code_1       235
Observation_Text_1       Healthcare personnel who care for patients infected with more virulent orthopoxviruses (e.g., Variola virus or mpox virus)
Series_Status            Not Complete
Date_Administered_1      2022-06-03
Vaccine_Name_1           Vaccinia, smallpox Mpox vaccine live, PF, SQ or ID injection
CVX_1                    206
MVX_1                    BN
Evaluation_Status_1      Valid
Series_Type_1            risk
Forecast_#               2
Earliest_Date            2022-07-01
Recommended_Date         2022-07-01
Administrative_Guidance  Persons who previously received ACAM2000 should decide before their next booster dose whether to receive ACAM2000 or JYNNEOS.  Persons who tranition to receiving JYNNEO boosters are expected to continue receiving JYNNEOS boosters and to not revert to ACAM2000; in addition, the frequency of booster doses should correspond to the vaccine used for boosters. For example, persons who previously received ACAM2000 every 3 years because of work with more virulent orthopoxviruses might decide to change to JYNNEOS when their next booster is due; in these cases, subsequent JYNNEOS booster doses should be administered every 2 years.
Vaccine_Group            Orthopoxvirus
Assessment_Date          2022-06-03
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2022-06-08
Date_updated             2022-11-01
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        v4.5: Renamed vaccine group from Vaccinia to Orthopoxvirus
Changed_In_Version       4.5
```

**cicada produces no forecast for Orthopoxvirus.**

### 2022-UC-0031

CDC row, every populated column:

```
CDC_Test_ID              2022-UC-0031
Test_Case_Name           Patient is a healthcare personnel worker who cares for patients infected with a more virulent orthopoxvirus and has been administered the second dose of the Orthopoxirus (Jynneos) vaccine.
DOB                      1969-10-19
Gender                   M
Observation_Code_1       235
Observation_Text_1       Healthcare personnel who care for patients infected with more virulent orthopoxviruses (e.g., Variola virus or mpox virus)
Series_Status            Not Complete
Date_Administered_1      2022-06-03
Vaccine_Name_1           Vaccinia, smallpox Mpox vaccine live, PF, SQ or ID injection
CVX_1                    206
MVX_1                    BN
Evaluation_Status_1      Valid
Series_Type_1            risk
Date_Administered_2      2022-07-01
Vaccine_Name_2           vaccinia - smallpox mpox vaccine live, PF
CVX_2                    206
MVX_2                    BN
Evaluation_Status_2      Valid
Series_Type_2            risk
Forecast_#               3
Earliest_Date            2024-07-01
Recommended_Date         2024-07-01
Past_Due_Date            2025-06-30
Administrative_Guidance  Persons who previously received ACAM2000 should decide before their next booster dose whether to receive ACAM2000 or JYNNEOS.  Persons who tranition to receiving JYNNEO boosters are expected to continue receiving JYNNEOS boosters and to not revert to ACAM2000; in addition, the frequency of booster doses should correspond to the vaccine used for boosters. For example, persons who previously received ACAM2000 every 3 years because of work with more virulent orthopoxviruses might decide to change to JYNNEOS when their next booster is due; in these cases, subsequent JYNNEOS booster doses should be administered every 2 years.
Vaccine_Group            Orthopoxvirus
Assessment_Date          2022-07-01
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2022-06-08
Date_updated             2022-11-07
Forecast_Test_Type       Recommended based on interval
Reason_For_Change        v4.5: Renamed vaccine group from Vaccinia to Orthopoxvirus
Changed_In_Version       4.5
```

**cicada produces no forecast for Orthopoxvirus.**

### 2023-UC-0047

CDC row, every populated column:

```
CDC_Test_ID              2023-UC-0047
Test_Case_Name           Patient is a baby that is 8 months of age and has chronic lung disease and hasn't received a dose of the RSV Vaccine
DOB                      2022-12-21
Gender                   F
Observation_Code_1       017
Observation_Text_1       Chronic lung disease
Series_Status            Not Complete
Forecast_#               1
Earliest_Date            2023-10-01
Recommended_Date         2023-10-01
Vaccine_Group            RSV
Assessment_Date          2023-10-12
Evaluation_Test_Type     No Doses Administered
Date_added               2024-01-09
Date_updated             2024-01-17
Forecast_Test_Type       Recommended based on Condition
Changed_In_Version       4.5
```

**cicada answers:** status `Aged Out`, forecast #`null`, earliest `null`, recommended `null`, past due `null`.

### 2023-UC-0048

CDC row, every populated column:

```
CDC_Test_ID              2023-UC-0048
Test_Case_Name           Patient is a newborn baby that was born five days ago with cystic fibrosis and hasn't received any doses of the RSV vaccine
DOB                      2023-11-03
Gender                   M
Observation_Code_1       200
Observation_Text_1       Cystic fibrosis
Series_Status            Not Complete
Forecast_#               1
Earliest_Date            2023-11-03
Recommended_Date         2023-11-03
Vaccine_Group            RSV
Assessment_Date          2023-11-08
Evaluation_Test_Type     No Doses Administered
Date_added               2024-01-09
Date_updated             2024-03-11
Forecast_Test_Type       Recommended based on Condition
Changed_In_Version       4.5
```

**cicada answers:** status `Aged Out`, forecast #`null`, earliest `null`, recommended `null`, past due `null`.

### 2023-UC-0050

CDC row, every populated column:

```
CDC_Test_ID              2023-UC-0050
Test_Case_Name           Patient is a baby that is 18 months of age that is American Indian or Alaskan native and has received a dose of the RSV vaccine.
DOB                      2022-05-14
Gender                   F
Observation_Code_1       245
Observation_Text_1       American Indian or Alaskan Native
Series_Status            Not Complete
Date_Administered_1      2023-12-12
Vaccine_Name_1           RSV, mAb, nirsevimab-alip, 1.0 mL
CVX_1                    307
MVX_1                    PMC
Evaluation_Status_1      Valid
Series_Type_1            risk
Forecast_#               2
Earliest_Date            2023-12-12
Recommended_Date         2023-12-12
Administrative_Guidance  ACIP recommends 1 dose of nirsevimab (200 mg, administered as two 100 mg injections given at the same time at different injection sites) for infants and children aged 8-19 months who are at increased risk for severe RSV disease and entering their second RSV season.
Vaccine_Group            RSV
Assessment_Date          2023-12-12
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2024-01-10
Date_updated             2024-11-12
Forecast_Test_Type       Recommended based on interval
Changed_In_Version       4.5
```

**cicada answers:** status `Aged Out`, forecast #`null`, earliest `null`, recommended `null`, past due `null`.

### 2023-UC-0051

CDC row, every populated column:

```
CDC_Test_ID              2023-UC-0051
Test_Case_Name           Patient is an adult that is pregnant and is at, at least 32 weeks gestation, and has not been administered a dose of the RSV vaccine.
DOB                      1990-08-10
Gender                   F
Observation_Code_1       007
Observation_Text_1       Pregnant
Observation_Date_1       2023-03-01
Observation_Code_2       170
Observation_Text_2       Onset of pregnancy
Observation_Date_2       2023-03-01
Series_Status            Not Complete
Forecast_#               1
Earliest_Date            2023-10-11
Recommended_Date         2023-10-11
Past_Due_Date            2023-11-14
Administrative_Guidance  Pregnant persons should receive 1 dose of RSVpreF (Pfizer, Abrysvo) vaccine during each pregnancy, during 32 through 36 weeks gestation starting 1-2 months prior to the anticipated beginning of the RSV season and ending 1-2 months prior to the anticipated end of the season.
Vaccine_Group            RSV
Assessment_Date          2023-03-01
Evaluation_Test_Type     No Doses Administered
Date_added               2024-01-10
Date_updated             2024-11-12
Forecast_Test_Type       Recommended based on Condition
Changed_In_Version       4.5
```

**cicada answers:** status `Not Complete`, forecast #`1`, earliest `2025/09/01`, recommended `2025/09/01`, past due `2025/09/01`.

### 2025-UC-0010

CDC row, every populated column:

```
CDC_Test_ID              2025-UC-0010
Test_Case_Name           Patient is 58 years of age and has had a severe allergic reaction after a previous adminstered dose of recombinant zoster.
DOB                      1966-07-29
Gender                   F
Observation_Code_1       172
Observation_Text_1       Severe allergic reaction after previous dose of recombinant zoster
Series_Status            Contraindicated
Date_Administered_1      2025-04-01
Vaccine_Name_1           Zoster Recombinant
CVX_1                    187
MVX_1                    SKB
Evaluation_Status_1      Valid
Series_Type_1            risk
Forecast_#               -
Vaccine_Group            Zoster
Assessment_Date          2025-04-01
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2025-06-07
Date_updated             2025-06-07
Forecast_Test_Type       Not recommended: contraindicated
Changed_In_Version       4.6
```

**cicada answers:** status `Contraindicated`, forecast #`2`, earliest `null`, recommended `null`, past due `null`.

### 2025-UC-0015

CDC row, every populated column:

```
CDC_Test_ID              2025-UC-0015
Test_Case_Name           Patient is female, 38 years of age, and is undergoing radiation therapy and has been administered the second dose of the HPV vaccine.
DOB                      1986-08-03
Gender                   F
Observation_Code_1       159
Observation_Text_1       Radiation therapy
Series_Status            Not Complete
Date_Administered_1      2024-11-02
Vaccine_Name_1           9vHPV
CVX_1                    165
MVX_1                    MSD
Evaluation_Status_1      Valid
Series_Type_1            risk
Date_Administered_2      2024-11-30
Vaccine_Name_2           9vHPV
CVX_2                    165
MVX_2                    MSD
Evaluation_Status_2      Valid
Series_Type_2            risk
Forecast_#               3
Earliest_Date            2025-04-02
Recommended_Date         2025-05-02
Past_Due_Date            2025-06-30
Administrative_Guidance  Shared clinical decision making (SCDM) is recommended regarding Human papillomavirus (HPV) vaccination for persons 27-45 years of age.  Shared clinical decision-making recommendations are intended to be flexible and should be informed by the characteristics, values, and preferences of the individual patient and the clinical discretion of the healthcare provider.  More guidance can be found here: https://www.cdc.gov/vaccines/hcp/admin/downloads/ISD-job-aid-SCDM-HPV-shared-clinical-decisiion-making-HPV.pdf
Vaccine_Group            HPV
Assessment_Date          2024-11-30
Evaluation_Test_Type     All Valid: Forecast Test
Date_added               2025-06-17
Date_updated             2025-06-17
Forecast_Test_Type       Recommended based on interval
Changed_In_Version       4.6
```

**cicada answers:** status `Not Complete`, forecast #`3`, earliest `2025/04/02`, recommended `2025/05/02`, past due `2025/06/29`.

