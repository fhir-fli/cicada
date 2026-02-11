# Vaccine Condition Codes (ICD-10-CM) - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Vaccine Condition Codes (ICD-10-CM)**

## ValueSet: Vaccine Condition Codes (ICD-10-CM) 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-condition-codes-icd10 | *Version*:0.1.0 |
| Active as of 2026-02-11 | *Computable Name*:VaccineConditionCodesIcd10 |

 
Value set for conditions based on ICD-10-CM that may impact immunization decisions, mapped to CDSi observation codes. 

 **References** 

This value set is not used here; it may be used elsewhere (e.g. specifications and/or implementations that use this content)

### Logical Definition (CLD)

 

### Expansion

-------

 Explanation of the columns that may appear on this page: 

| | |
| :--- | :--- |
| Level | A few code lists that FHIR defines are hierarchical - each code is assigned a level. In this scheme, some codes are under other codes, and imply that the code they are under also applies |
| System | The source of the definition of the code (when the value set draws in codes defined elsewhere) |
| Code | The code (used as the code in the resource instance) |
| Display | The display (used in the*display*element of a[Coding](http://hl7.org/fhir/R4/datatypes.html#Coding)). If there is no display, implementers should not simply display the code, but map the concept into their application |
| Definition | An explanation of the meaning of the concept |
| Comments | Additional notes about how to use the code |



## Resource Content

```json
{
  "resourceType" : "ValueSet",
  "id" : "vaccine-condition-codes-icd10",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-condition-codes-icd10",
  "version" : "0.1.0",
  "name" : "VaccineConditionCodesIcd10",
  "title" : "Vaccine Condition Codes (ICD-10-CM)",
  "status" : "active",
  "date" : "2026-02-11T14:37:07-05:00",
  "publisher" : "FHIR-FLI",
  "contact" : [
    {
      "name" : "FHIR-FLI",
      "telecom" : [
        {
          "system" : "url",
          "value" : "http://fhirfli.dev"
        }
      ]
    }
  ],
  "description" : "Value set for conditions based on ICD-10-CM that may impact immunization decisions, mapped to CDSi observation codes.",
  "compose" : {
    "include" : [
      {
        "system" : "http://hl7.org/fhir/sid/icd-10-cm",
        "concept" : [
          {
            "code" : "D84.9",
            "display" : "Immunodeficiency, unspecified"
          },
          {
            "code" : "D83.9",
            "display" : "Common variable immunodeficiency, unspecified"
          },
          {
            "code" : "D80.9",
            "display" : "Immunodeficiency with predominantly antibody defects, unspecified"
          },
          {
            "code" : "D89.9",
            "display" : "Disorder involving immune mechanism, unspecified"
          },
          {
            "code" : "D84.8",
            "display" : "Other specified immunodeficiency disorders"
          },
          {
            "code" : "Z94.84",
            "display" : "Bone marrow transplant status"
          },
          {
            "code" : "T86.00",
            "display" : "Unspecified complication of bone marrow transplant"
          },
          {
            "code" : "T86.09",
            "display" : "Other complications of bone marrow transplant"
          },
          {
            "code" : "B18.2",
            "display" : "Chronic viral hepatitis C"
          },
          {
            "code" : "B17.10",
            "display" : "Acute hepatitis C without hepatic coma"
          },
          {
            "code" : "B17.11",
            "display" : "Acute hepatitis C with hepatic coma"
          },
          {
            "code" : "B19.20",
            "display" : "Unspecified viral hepatitis C without hepatic coma"
          },
          {
            "code" : "Z33.1",
            "display" : "Pregnant state, incidental"
          },
          {
            "code" : "O09.90",
            "display" : "Supervision of high risk pregnancy, unspecified trimester"
          },
          {
            "code" : "Z34.00",
            "display" : "Encounter for supervision of normal first pregnancy, unspecified trimester"
          },
          {
            "code" : "Z34.80",
            "display" : "Encounter for supervision of other normal pregnancy, unspecified trimester"
          },
          {
            "code" : "Z39.1",
            "display" : "Encounter for care and examination of lactating mother"
          },
          {
            "code" : "G96.00",
            "display" : "Cerebrospinal fluid leak, unspecified"
          },
          {
            "code" : "G96.01",
            "display" : "Cranial cerebrospinal fluid leak, spontaneous"
          },
          {
            "code" : "G96.02",
            "display" : "Spinal cerebrospinal fluid leak, spontaneous"
          },
          {
            "code" : "G96.08",
            "display" : "Other cranial cerebrospinal fluid leak"
          },
          {
            "code" : "G96.09",
            "display" : "Other spinal cerebrospinal fluid leak"
          },
          {
            "code" : "Z96.21",
            "display" : "Cochlear implant status"
          },
          {
            "code" : "D81.9",
            "display" : "Combined immunodeficiency, unspecified"
          },
          {
            "code" : "D81.0",
            "display" : "SCID with reticular dysgenesis"
          },
          {
            "code" : "D81.1",
            "display" : "SCID with low T- and B-cell numbers"
          },
          {
            "code" : "D81.2",
            "display" : "SCID with low or normal B-cell numbers"
          },
          {
            "code" : "D81.3",
            "display" : "Adenosine deaminase deficiency"
          },
          {
            "code" : "D81.5",
            "display" : "Purine nucleoside phosphorylase deficiency"
          },
          {
            "code" : "D81.6",
            "display" : "Major histocompatibility complex class I deficiency"
          },
          {
            "code" : "D81.7",
            "display" : "Major histocompatibility complex class II deficiency"
          },
          {
            "code" : "E10.9",
            "display" : "Type 1 diabetes mellitus without complications"
          },
          {
            "code" : "E10.65",
            "display" : "Type 1 diabetes mellitus with hyperglycemia"
          },
          {
            "code" : "E11.9",
            "display" : "Type 2 diabetes mellitus without complications"
          },
          {
            "code" : "E11.65",
            "display" : "Type 2 diabetes mellitus with hyperglycemia"
          },
          {
            "code" : "E13.9",
            "display" : "Other specified diabetes mellitus without complications"
          },
          {
            "code" : "E08.9",
            "display" : "Diabetes mellitus due to underlying condition without complications"
          },
          {
            "code" : "E09.9",
            "display" : "Drug or chemical induced diabetes mellitus without complications"
          },
          {
            "code" : "K70.30",
            "display" : "Alcoholic cirrhosis of liver without ascites"
          },
          {
            "code" : "K70.31",
            "display" : "Alcoholic cirrhosis of liver with ascites"
          },
          {
            "code" : "K73.9",
            "display" : "Chronic hepatitis, unspecified"
          },
          {
            "code" : "K74.0",
            "display" : "Hepatic fibrosis"
          },
          {
            "code" : "K74.60",
            "display" : "Unspecified cirrhosis of liver"
          },
          {
            "code" : "K74.69",
            "display" : "Other cirrhosis of liver"
          },
          {
            "code" : "K76.0",
            "display" : "Fatty liver, not elsewhere classified"
          },
          {
            "code" : "K76.9",
            "display" : "Liver disease, unspecified"
          },
          {
            "code" : "I25.10",
            "display" : "Atherosclerotic heart disease of native coronary artery without angina pectoris"
          },
          {
            "code" : "I25.9",
            "display" : "Chronic ischemic heart disease, unspecified"
          },
          {
            "code" : "I50.9",
            "display" : "Heart failure, unspecified"
          },
          {
            "code" : "I50.20",
            "display" : "Unspecified systolic (congestive) heart failure"
          },
          {
            "code" : "I50.30",
            "display" : "Unspecified diastolic (congestive) heart failure"
          },
          {
            "code" : "I42.9",
            "display" : "Cardiomyopathy, unspecified"
          },
          {
            "code" : "I42.0",
            "display" : "Dilated cardiomyopathy"
          },
          {
            "code" : "Q24.9",
            "display" : "Congenital malformation of heart, unspecified"
          },
          {
            "code" : "J44.9",
            "display" : "Chronic obstructive pulmonary disease, unspecified"
          },
          {
            "code" : "J44.1",
            "display" : "Chronic obstructive pulmonary disease with acute exacerbation"
          },
          {
            "code" : "J43.9",
            "display" : "Emphysema, unspecified"
          },
          {
            "code" : "J84.9",
            "display" : "Interstitial pulmonary disease, unspecified"
          },
          {
            "code" : "J84.10",
            "display" : "Pulmonary fibrosis, unspecified"
          },
          {
            "code" : "J47.9",
            "display" : "Bronchiectasis, uncomplicated"
          },
          {
            "code" : "P27.1",
            "display" : "Bronchopulmonary dysplasia originating in the perinatal period"
          },
          {
            "code" : "D73.0",
            "display" : "Hyposplenism"
          },
          {
            "code" : "Q89.01",
            "display" : "Asplenia (congenital)"
          },
          {
            "code" : "D73.89",
            "display" : "Other diseases of spleen"
          },
          {
            "code" : "Z90.81",
            "display" : "Acquired absence of spleen"
          },
          {
            "code" : "N18.1",
            "display" : "Chronic kidney disease, stage 1"
          },
          {
            "code" : "N18.2",
            "display" : "Chronic kidney disease, stage 2"
          },
          {
            "code" : "N18.30",
            "display" : "Chronic kidney disease, stage 3 unspecified"
          },
          {
            "code" : "N18.4",
            "display" : "Chronic kidney disease, stage 4"
          },
          {
            "code" : "N18.5",
            "display" : "Chronic kidney disease, stage 5"
          },
          {
            "code" : "N18.6",
            "display" : "End stage renal disease"
          },
          {
            "code" : "N18.9",
            "display" : "Chronic kidney disease, unspecified"
          },
          {
            "code" : "Z99.2",
            "display" : "Dependence on renal dialysis"
          },
          {
            "code" : "B20",
            "display" : "Human immunodeficiency virus [HIV] disease"
          },
          {
            "code" : "Z21",
            "display" : "Asymptomatic human immunodeficiency virus [HIV] infection status"
          },
          {
            "code" : "J45.20",
            "display" : "Mild intermittent asthma, uncomplicated"
          },
          {
            "code" : "J45.30",
            "display" : "Mild persistent asthma, uncomplicated"
          },
          {
            "code" : "J45.40",
            "display" : "Moderate persistent asthma, uncomplicated"
          },
          {
            "code" : "J45.50",
            "display" : "Severe persistent asthma, uncomplicated"
          },
          {
            "code" : "J45.909",
            "display" : "Unspecified asthma, uncomplicated"
          },
          {
            "code" : "J45.998",
            "display" : "Other asthma"
          },
          {
            "code" : "K56.1",
            "display" : "Intussusception"
          },
          {
            "code" : "K52.9",
            "display" : "Noninfective gastroenteritis and colitis, unspecified"
          },
          {
            "code" : "A09",
            "display" : "Infectious gastroenteritis and colitis, unspecified"
          },
          {
            "code" : "A08.0",
            "display" : "Rotaviral enteritis"
          },
          {
            "code" : "A08.39",
            "display" : "Other viral enteritis"
          },
          {
            "code" : "A15.0",
            "display" : "Tuberculosis of lung"
          },
          {
            "code" : "A15.9",
            "display" : "Respiratory tuberculosis unspecified"
          },
          {
            "code" : "A18.9",
            "display" : "Tuberculosis of other organs"
          },
          {
            "code" : "A19.9",
            "display" : "Miliary tuberculosis, unspecified"
          },
          {
            "code" : "R76.11",
            "display" : "Nonspecific reaction to tuberculin skin test without active tuberculosis"
          },
          {
            "code" : "Z86.11",
            "display" : "Personal history of tuberculosis"
          },
          {
            "code" : "Z79.82",
            "display" : "Long term (current) use of aspirin"
          },
          {
            "code" : "Z11.3",
            "display" : "Encounter for screening for infections with a predominantly sexual mode of transmission"
          },
          {
            "code" : "Z11.4",
            "display" : "Encounter for screening for human immunodeficiency virus [HIV]"
          },
          {
            "code" : "Z20.2",
            "display" : "Contact with and exposure to infections with a predominantly sexual mode of transmission"
          }
        ]
      }
    ]
  }
}

```
