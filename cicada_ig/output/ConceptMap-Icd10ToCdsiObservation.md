# ICD-10-CM to CDSi Observation Code Map - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **ICD-10-CM to CDSi Observation Code Map**

## ConceptMap: ICD-10-CM to CDSi Observation Code Map 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ConceptMap/Icd10ToCdsiObservation | *Version*:0.1.0 |
| Active as of 2026-02-11 | *Computable Name*: |

 
Maps ICD-10-CM diagnosis codes to CDSi observation codes used in immunization decision support. 



## Resource Content

```json
{
  "resourceType" : "ConceptMap",
  "id" : "Icd10ToCdsiObservation",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ConceptMap/Icd10ToCdsiObservation",
  "version" : "0.1.0",
  "title" : "ICD-10-CM to CDSi Observation Code Map",
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
  "description" : "Maps ICD-10-CM diagnosis codes to CDSi observation codes used in immunization decision support.",
  "sourceUri" : "http://hl7.org/fhir/sid/icd-10-cm",
  "targetUri" : "https://www.cdc.gov/vaccines/programs/iis/cdsi",
  "group" : [
    {
      "source" : "http://hl7.org/fhir/sid/icd-10-cm",
      "target" : "https://www.cdc.gov/vaccines/programs/iis/cdsi",
      "element" : [
        {
          "code" : "D84.9",
          "display" : "Immunodeficiency, unspecified",
          "target" : [
            {
              "code" : "003",
              "display" : "Immunocompromised",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "B18.2",
          "display" : "Chronic viral hepatitis C",
          "target" : [
            {
              "code" : "005",
              "display" : "Hepatitis C virus infection",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "Z33.1",
          "display" : "Pregnant state, incidental",
          "target" : [
            {
              "code" : "007",
              "display" : "Pregnant",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "D81.9",
          "display" : "Combined immunodeficiency, unspecified",
          "target" : [
            {
              "code" : "013",
              "display" : "Severe Combined Immunodeficiency [SCID]",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "E11.9",
          "display" : "Type 2 diabetes mellitus without complications",
          "target" : [
            {
              "code" : "014",
              "display" : "Diabetes",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "K74.60",
          "display" : "Unspecified cirrhosis of liver",
          "target" : [
            {
              "code" : "015",
              "display" : "Chronic liver disease",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "I50.9",
          "display" : "Heart failure, unspecified",
          "target" : [
            {
              "code" : "016",
              "display" : "Chronic heart disease",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "J44.9",
          "display" : "Chronic obstructive pulmonary disease, unspecified",
          "target" : [
            {
              "code" : "017",
              "display" : "Chronic lung disease",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "D73.0",
          "display" : "Hyposplenism",
          "target" : [
            {
              "code" : "018",
              "display" : "Asplenia",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "Z90.81",
          "display" : "Acquired absence of spleen",
          "target" : [
            {
              "code" : "018",
              "display" : "Asplenia",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "N18.6",
          "display" : "End stage renal disease",
          "target" : [
            {
              "code" : "019",
              "display" : "Chronic renal failure",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "B20",
          "display" : "Human immunodeficiency virus [HIV] disease",
          "target" : [
            {
              "code" : "026",
              "display" : "HIV/AIDS - immunocompromised",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "Z21",
          "display" : "Asymptomatic human immunodeficiency virus [HIV] infection status",
          "target" : [
            {
              "code" : "026",
              "display" : "HIV/AIDS - immunocompromised",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "J45.909",
          "display" : "Unspecified asthma, uncomplicated",
          "target" : [
            {
              "code" : "027",
              "display" : "Asthma",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "K56.1",
          "display" : "Intussusception",
          "target" : [
            {
              "code" : "028",
              "display" : "Intussusception",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "A15.0",
          "display" : "Tuberculosis of lung",
          "target" : [
            {
              "code" : "031",
              "display" : "Tuberculosis",
              "equivalence" : "wider"
            }
          ]
        },
        {
          "code" : "Z79.82",
          "display" : "Long term (current) use of aspirin",
          "target" : [
            {
              "code" : "034",
              "display" : "Receiving long-term aspirin therapy",
              "equivalence" : "equivalent"
            }
          ]
        }
      ]
    }
  ]
}

```
