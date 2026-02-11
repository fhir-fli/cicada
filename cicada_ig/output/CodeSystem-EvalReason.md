# Evaluation Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Evaluation Reason**

## CodeSystem: Evaluation Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalReason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:EvalReasonCS |

 
The reason for the evaluation. 

 This Code system is referenced in the content logical definition of the following value sets: 

* [EvalReasonVS](ValueSet-eval-reason.md)



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "EvalReason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalReason",
  "version" : "0.1.0",
  "name" : "EvalReasonCS",
  "title" : "Evaluation Reason",
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
  "description" : "The reason for the evaluation.",
  "content" : "complete",
  "count" : 15,
  "concept" : [
    {
      "code" : "noDateGiven",
      "display" : "No Date Given",
      "definition" : "No Date Given"
    },
    {
      "code" : "noCvx",
      "display" : "No Cvx",
      "definition" : "No Cvx"
    },
    {
      "code" : "expired",
      "display" : "Expired Product",
      "definition" : "Expired Product"
    },
    {
      "code" : "ageTooOld",
      "display" : "Age: Too Old",
      "definition" : "Age: Too Old"
    },
    {
      "code" : "ageTooYoung",
      "display" : "Age: Too Young",
      "definition" : "Age: Too Young"
    },
    {
      "code" : "inadvertentVaccine",
      "display" : "Inadvertent Vaccine",
      "definition" : "Inadvertent Vaccine"
    },
    {
      "code" : "notPreferableOrAllowable",
      "display" : "Not a preferable or allowable vaccine",
      "definition" : "Not a preferable or allowable vaccine"
    },
    {
      "code" : "notRecommendedVolume",
      "display" : "Volume administered is less than recommended volume",
      "definition" : "Volume administered is less than recommended volume"
    },
    {
      "code" : "partialDose",
      "display" : "Partial Dose",
      "definition" : "Partial Dose"
    },
    {
      "code" : "coldChainBreak",
      "display" : "Cold Chain Break",
      "definition" : "Cold Chain Break"
    },
    {
      "code" : "recall",
      "display" : "Manufacturer Recall",
      "definition" : "Manufacturer Recall"
    },
    {
      "code" : "adverseStorage",
      "display" : "Adverse Storage",
      "definition" : "Adverse Storage"
    },
    {
      "code" : "intervalTooShort",
      "display" : "Interval: too short",
      "definition" : "Interval: too short"
    },
    {
      "code" : "seriesAlreadyCompleted",
      "display" : "Series Already Completed",
      "definition" : "Series Already Completed"
    },
    {
      "code" : "liveVirusConflict",
      "display" : "Live Virus Conflict",
      "definition" : "Live Virus Conflict"
    }
  ]
}

```
