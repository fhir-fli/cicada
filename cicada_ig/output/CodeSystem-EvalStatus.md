# Evaluation Status - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Evaluation Status**

## CodeSystem: Evaluation Status 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalStatus | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:EvalStatusCS |

 
The status of the result of an evaluation. 

 This Code system is referenced in the content logical definition of the following value sets: 

* [EvalStatusVS](ValueSet-eval-status.md)



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "EvalStatus",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalStatus",
  "version" : "0.1.0",
  "name" : "EvalStatusCS",
  "title" : "Evaluation Status",
  "status" : "draft",
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
  "description" : "The status of the result of an evaluation.",
  "content" : "complete",
  "count" : 4,
  "concept" : [
    {
      "code" : "valid",
      "display" : "Valid",
      "definition" : "Valid"
    },
    {
      "code" : "not_valid",
      "display" : "Not Valid",
      "definition" : "Not Valid"
    },
    {
      "code" : "extraneous",
      "display" : "Extraneous",
      "definition" : "Extraneous"
    },
    {
      "code" : "sub_standard",
      "display" : "Substandard",
      "definition" : "Substandard"
    }
  ]
}

```
