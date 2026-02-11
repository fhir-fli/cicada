# Valid Age Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Valid Age Reason**

## CodeSystem: Valid Age Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/CodeSystem/ValidAgeReason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:ValidAgeReasonCS |

 
Value set for reasons why a patient's age is considered valid/invalid for a vaccine. 

 This Code system is referenced in the content logical definition of the following value sets: 

* [ValidAgeReasonVS](ValueSet-valid-age-reason.md)



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "ValidAgeReason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/ValidAgeReason",
  "version" : "0.1.0",
  "name" : "ValidAgeReasonCS",
  "title" : "Valid Age Reason",
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
  "description" : "Value set for reasons why a patient's age is considered valid/invalid for a vaccine.",
  "content" : "complete",
  "count" : 3,
  "concept" : [
    {
      "code" : "gracePeriod",
      "display" : "Age: Grace Period",
      "definition" : "Age: Grace Period"
    },
    {
      "code" : "tooYoung",
      "display" : "Age: Too Young",
      "definition" : "Age: Too Young"
    },
    {
      "code" : "tooOld",
      "display" : "Age: Too Old",
      "definition" : "Age: Too Old"
    }
  ]
}

```
