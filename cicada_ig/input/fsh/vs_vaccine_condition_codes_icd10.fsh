ValueSet: VaccineConditionCodesIcd10
Id: vaccine-condition-codes-icd10
Title: "Vaccine Condition Codes (ICD-10-CM)"
Description: "Value set for conditions based on ICD-10-CM that may impact immunization decisions, mapped to CDSi observation codes."
* ^status = #active

// 003 - Immunocompromised
* include http://hl7.org/fhir/sid/icd-10-cm#D84.9 "Immunodeficiency, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#D83.9 "Common variable immunodeficiency, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#D80.9 "Immunodeficiency with predominantly antibody defects, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#D89.9 "Disorder involving immune mechanism, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#D84.8 "Other specified immunodeficiency disorders"

// 004 - Hematopoietic stem cell transplant recipient
* include http://hl7.org/fhir/sid/icd-10-cm#Z94.84 "Bone marrow transplant status"
* include http://hl7.org/fhir/sid/icd-10-cm#T86.00 "Unspecified complication of bone marrow transplant"
* include http://hl7.org/fhir/sid/icd-10-cm#T86.09 "Other complications of bone marrow transplant"

// 005 - Hepatitis C virus infection
* include http://hl7.org/fhir/sid/icd-10-cm#B18.2 "Chronic viral hepatitis C"
* include http://hl7.org/fhir/sid/icd-10-cm#B17.10 "Acute hepatitis C without hepatic coma"
* include http://hl7.org/fhir/sid/icd-10-cm#B17.11 "Acute hepatitis C with hepatic coma"
* include http://hl7.org/fhir/sid/icd-10-cm#B19.20 "Unspecified viral hepatitis C without hepatic coma"

// 007 - Pregnant
* include http://hl7.org/fhir/sid/icd-10-cm#Z33.1 "Pregnant state, incidental"
* include http://hl7.org/fhir/sid/icd-10-cm#O09.90 "Supervision of high risk pregnancy, unspecified trimester"
* include http://hl7.org/fhir/sid/icd-10-cm#Z34.00 "Encounter for supervision of normal first pregnancy, unspecified trimester"
* include http://hl7.org/fhir/sid/icd-10-cm#Z34.80 "Encounter for supervision of other normal pregnancy, unspecified trimester"

// 009 - Breastfeeding
* include http://hl7.org/fhir/sid/icd-10-cm#Z39.1 "Encounter for care and examination of lactating mother"

// 010 - Cerebrospinal fluid leaks
* include http://hl7.org/fhir/sid/icd-10-cm#G96.00 "Cerebrospinal fluid leak, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#G96.01 "Cranial cerebrospinal fluid leak, spontaneous"
* include http://hl7.org/fhir/sid/icd-10-cm#G96.02 "Spinal cerebrospinal fluid leak, spontaneous"
* include http://hl7.org/fhir/sid/icd-10-cm#G96.08 "Other cranial cerebrospinal fluid leak"
* include http://hl7.org/fhir/sid/icd-10-cm#G96.09 "Other spinal cerebrospinal fluid leak"

// 011 - Cochlear implants
* include http://hl7.org/fhir/sid/icd-10-cm#Z96.21 "Cochlear implant status"

// 013 - Severe Combined Immunodeficiency
* include http://hl7.org/fhir/sid/icd-10-cm#D81.9 "Combined immunodeficiency, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#D81.0 "SCID with reticular dysgenesis"
* include http://hl7.org/fhir/sid/icd-10-cm#D81.1 "SCID with low T- and B-cell numbers"
* include http://hl7.org/fhir/sid/icd-10-cm#D81.2 "SCID with low or normal B-cell numbers"
* include http://hl7.org/fhir/sid/icd-10-cm#D81.3 "Adenosine deaminase deficiency"
* include http://hl7.org/fhir/sid/icd-10-cm#D81.5 "Purine nucleoside phosphorylase deficiency"
* include http://hl7.org/fhir/sid/icd-10-cm#D81.6 "Major histocompatibility complex class I deficiency"
* include http://hl7.org/fhir/sid/icd-10-cm#D81.7 "Major histocompatibility complex class II deficiency"

// 014 - Diabetes
* include http://hl7.org/fhir/sid/icd-10-cm#E10.9 "Type 1 diabetes mellitus without complications"
* include http://hl7.org/fhir/sid/icd-10-cm#E10.65 "Type 1 diabetes mellitus with hyperglycemia"
* include http://hl7.org/fhir/sid/icd-10-cm#E11.9 "Type 2 diabetes mellitus without complications"
* include http://hl7.org/fhir/sid/icd-10-cm#E11.65 "Type 2 diabetes mellitus with hyperglycemia"
* include http://hl7.org/fhir/sid/icd-10-cm#E13.9 "Other specified diabetes mellitus without complications"
* include http://hl7.org/fhir/sid/icd-10-cm#E08.9 "Diabetes mellitus due to underlying condition without complications"
* include http://hl7.org/fhir/sid/icd-10-cm#E09.9 "Drug or chemical induced diabetes mellitus without complications"

// 015 - Chronic liver disease
* include http://hl7.org/fhir/sid/icd-10-cm#K70.30 "Alcoholic cirrhosis of liver without ascites"
* include http://hl7.org/fhir/sid/icd-10-cm#K70.31 "Alcoholic cirrhosis of liver with ascites"
* include http://hl7.org/fhir/sid/icd-10-cm#K73.9 "Chronic hepatitis, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#K74.0 "Hepatic fibrosis"
* include http://hl7.org/fhir/sid/icd-10-cm#K74.60 "Unspecified cirrhosis of liver"
* include http://hl7.org/fhir/sid/icd-10-cm#K74.69 "Other cirrhosis of liver"
* include http://hl7.org/fhir/sid/icd-10-cm#K76.0 "Fatty liver, not elsewhere classified"
* include http://hl7.org/fhir/sid/icd-10-cm#K76.9 "Liver disease, unspecified"

// 016 - Chronic heart disease
* include http://hl7.org/fhir/sid/icd-10-cm#I25.10 "Atherosclerotic heart disease of native coronary artery without angina pectoris"
* include http://hl7.org/fhir/sid/icd-10-cm#I25.9 "Chronic ischemic heart disease, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#I50.9 "Heart failure, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#I50.20 "Unspecified systolic (congestive) heart failure"
* include http://hl7.org/fhir/sid/icd-10-cm#I50.30 "Unspecified diastolic (congestive) heart failure"
* include http://hl7.org/fhir/sid/icd-10-cm#I42.9 "Cardiomyopathy, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#I42.0 "Dilated cardiomyopathy"
* include http://hl7.org/fhir/sid/icd-10-cm#Q24.9 "Congenital malformation of heart, unspecified"

// 017 - Chronic lung disease
* include http://hl7.org/fhir/sid/icd-10-cm#J44.9 "Chronic obstructive pulmonary disease, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#J44.1 "Chronic obstructive pulmonary disease with acute exacerbation"
* include http://hl7.org/fhir/sid/icd-10-cm#J43.9 "Emphysema, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#J84.9 "Interstitial pulmonary disease, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#J84.10 "Pulmonary fibrosis, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#J47.9 "Bronchiectasis, uncomplicated"
* include http://hl7.org/fhir/sid/icd-10-cm#P27.1 "Bronchopulmonary dysplasia originating in the perinatal period"

// 018 - Asplenia
* include http://hl7.org/fhir/sid/icd-10-cm#D73.0 "Hyposplenism"
* include http://hl7.org/fhir/sid/icd-10-cm#Q89.01 "Asplenia (congenital)"
* include http://hl7.org/fhir/sid/icd-10-cm#D73.89 "Other diseases of spleen"
* include http://hl7.org/fhir/sid/icd-10-cm#Z90.81 "Acquired absence of spleen"

// 019 - Chronic renal failure
* include http://hl7.org/fhir/sid/icd-10-cm#N18.1 "Chronic kidney disease, stage 1"
* include http://hl7.org/fhir/sid/icd-10-cm#N18.2 "Chronic kidney disease, stage 2"
* include http://hl7.org/fhir/sid/icd-10-cm#N18.30 "Chronic kidney disease, stage 3 unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#N18.4 "Chronic kidney disease, stage 4"
* include http://hl7.org/fhir/sid/icd-10-cm#N18.5 "Chronic kidney disease, stage 5"
* include http://hl7.org/fhir/sid/icd-10-cm#N18.6 "End stage renal disease"
* include http://hl7.org/fhir/sid/icd-10-cm#N18.9 "Chronic kidney disease, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#Z99.2 "Dependence on renal dialysis"

// 026 - HIV/AIDS
* include http://hl7.org/fhir/sid/icd-10-cm#B20 "Human immunodeficiency virus [HIV] disease"
* include http://hl7.org/fhir/sid/icd-10-cm#Z21 "Asymptomatic human immunodeficiency virus [HIV] infection status"

// 027 - Asthma
* include http://hl7.org/fhir/sid/icd-10-cm#J45.20 "Mild intermittent asthma, uncomplicated"
* include http://hl7.org/fhir/sid/icd-10-cm#J45.30 "Mild persistent asthma, uncomplicated"
* include http://hl7.org/fhir/sid/icd-10-cm#J45.40 "Moderate persistent asthma, uncomplicated"
* include http://hl7.org/fhir/sid/icd-10-cm#J45.50 "Severe persistent asthma, uncomplicated"
* include http://hl7.org/fhir/sid/icd-10-cm#J45.909 "Unspecified asthma, uncomplicated"
* include http://hl7.org/fhir/sid/icd-10-cm#J45.998 "Other asthma"

// 028 - Intussusception
* include http://hl7.org/fhir/sid/icd-10-cm#K56.1 "Intussusception"

// 029 - Acute gastroenteritis
* include http://hl7.org/fhir/sid/icd-10-cm#K52.9 "Noninfective gastroenteritis and colitis, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#A09 "Infectious gastroenteritis and colitis, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#A08.0 "Rotaviral enteritis"
* include http://hl7.org/fhir/sid/icd-10-cm#A08.39 "Other viral enteritis"

// 031 - Tuberculosis
* include http://hl7.org/fhir/sid/icd-10-cm#A15.0 "Tuberculosis of lung"
* include http://hl7.org/fhir/sid/icd-10-cm#A15.9 "Respiratory tuberculosis unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#A18.9 "Tuberculosis of other organs"
* include http://hl7.org/fhir/sid/icd-10-cm#A19.9 "Miliary tuberculosis, unspecified"
* include http://hl7.org/fhir/sid/icd-10-cm#R76.11 "Nonspecific reaction to tuberculin skin test without active tuberculosis"
* include http://hl7.org/fhir/sid/icd-10-cm#Z86.11 "Personal history of tuberculosis"

// 034 - Long-term aspirin therapy
* include http://hl7.org/fhir/sid/icd-10-cm#Z79.82 "Long term (current) use of aspirin"

// 039 - STD treatment
* include http://hl7.org/fhir/sid/icd-10-cm#Z11.3 "Encounter for screening for infections with a predominantly sexual mode of transmission"
* include http://hl7.org/fhir/sid/icd-10-cm#Z11.4 "Encounter for screening for human immunodeficiency virus [HIV]"
* include http://hl7.org/fhir/sid/icd-10-cm#Z20.2 "Contact with and exposure to infections with a predominantly sexual mode of transmission"
