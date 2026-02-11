# Interval Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Interval Reason**

## CodeSystem: Interval Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/CodeSystem/IntervalReason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:IntervalReasonCS |

 
This value set includes codes for the reason an interval is considered to be invalid. 

 This Code system is referenced in the content logical definition of the following value sets: 

* [IntervalReasonVS](ValueSet-interval-reason.md)



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "IntervalReason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/IntervalReason",
  "version" : "0.1.0",
  "name" : "IntervalReasonCS",
  "title" : "Interval Reason",
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
  "description" : "This value set includes codes for the reason an interval is considered to be invalid.",
  "content" : "complete",
  "count" : 3,
  "concept" : [
    {
      "code" : "tooLate",
      "display" : "Interval: too late",
      "definition" : "Interval: too late"
    },
    {
      "code" : "tooShort",
      "display" : "Interval: too short",
      "definition" : "Interval: too short"
    },
    {
      "code" : "gracePeriod",
      "display" : "Interval: grace period",
      "definition" : "Interval: grace period"
    }
  ]
}

```
