# SNOMED CT to CDSi Observation Code Map - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **SNOMED CT to CDSi Observation Code Map**

## ConceptMap: SNOMED CT to CDSi Observation Code Map 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ConceptMap/SnomedToCdsiObservation | *Version*:0.1.0 |
| Active as of 2026-02-11 | *Computable Name*: |

 
Maps SNOMED CT codes to CDSi observation codes used in immunization decision support. 



## Resource Content

```json
{
  "resourceType" : "ConceptMap",
  "id" : "SnomedToCdsiObservation",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ConceptMap/SnomedToCdsiObservation",
  "version" : "0.1.0",
  "title" : "SNOMED CT to CDSi Observation Code Map",
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
  "description" : "Maps SNOMED CT codes to CDSi observation codes used in immunization decision support.",
  "sourceUri" : "http://snomed.info/sct",
  "targetUri" : "https://www.cdc.gov/vaccines/programs/iis/cdsi",
  "group" : [
    {
      "source" : "http://snomed.info/sct",
      "target" : "https://www.cdc.gov/vaccines/programs/iis/cdsi",
      "element" : [
        {
          "code" : "370388006",
          "display" : "Patient immunocompromised",
          "target" : [
            {
              "code" : "003",
              "display" : "Immunocompromised",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "50711007",
          "display" : "Viral hepatitis type C",
          "target" : [
            {
              "code" : "005",
              "display" : "Hepatitis C virus infection",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "77386006",
          "display" : "Patient currently pregnant",
          "target" : [
            {
              "code" : "007",
              "display" : "Pregnant",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "31323000",
          "display" : "Severe combined immunodeficiency disease",
          "target" : [
            {
              "code" : "013",
              "display" : "Severe Combined Immunodeficiency [SCID]",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "73211009",
          "display" : "Diabetes mellitus",
          "target" : [
            {
              "code" : "014",
              "display" : "Diabetes",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "371111005",
          "display" : "Measles immune",
          "target" : [
            {
              "code" : "020",
              "display" : "Laboratory Evidence of Immunity for Measles",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "371112003",
          "display" : "Mumps immune",
          "target" : [
            {
              "code" : "021",
              "display" : "Laboratory Evidence of Immunity for Mumps",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "278968001",
          "display" : "Rubella immune",
          "target" : [
            {
              "code" : "022",
              "display" : "Laboratory Evidence of Immunity for Rubella",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "86406008",
          "display" : "Human immunodeficiency virus infection",
          "target" : [
            {
              "code" : "026",
              "display" : "HIV/AIDS - immunocompromised",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "195967001",
          "display" : "Asthma",
          "target" : [
            {
              "code" : "027",
              "display" : "Asthma",
              "equivalence" : "equivalent"
            }
          ]
        },
        {
          "code" : "56717001",
          "display" : "Tuberculosis",
          "target" : [
            {
              "code" : "031",
              "display" : "Tuberculosis",
              "equivalence" : "equivalent"
            }
          ]
        }
      ]
    }
  ]
}

```
