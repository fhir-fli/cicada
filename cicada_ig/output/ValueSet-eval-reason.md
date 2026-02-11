# Evaluation Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Evaluation Reason**

## ValueSet: Evaluation Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ValueSet/eval-reason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:EvalReasonVS |

 
The reason for the evaluation. 

 **References** 

* [Dose of a Vaccine](StructureDefinition-vax-dose.md)

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
  "id" : "eval-reason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/eval-reason",
  "version" : "0.1.0",
  "name" : "EvalReasonVS",
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
  "compose" : {
    "include" : [
      {
        "system" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalReason",
        "concept" : [
          {
            "code" : "noDateGiven",
            "display" : "No Date Given"
          },
          {
            "code" : "noCvx",
            "display" : "No Cvx"
          },
          {
            "code" : "expired",
            "display" : "Expired Product"
          },
          {
            "code" : "ageTooOld",
            "display" : "Age: Too Old"
          },
          {
            "code" : "ageTooYoung",
            "display" : "Age: Too Young"
          },
          {
            "code" : "inadvertentVaccine",
            "display" : "Inadvertent Vaccine"
          },
          {
            "code" : "notPreferableOrAllowable",
            "display" : "Not a preferable or allowable vaccine"
          },
          {
            "code" : "notRecommendedVolume",
            "display" : "Volume administered is less than recommended volume"
          },
          {
            "code" : "partialDose",
            "display" : "Partial Dose"
          },
          {
            "code" : "coldChainBreak",
            "display" : "Cold Chain Break"
          },
          {
            "code" : "recall",
            "display" : "Manufacturer Recall"
          },
          {
            "code" : "adverseStorage",
            "display" : "Adverse Storage"
          },
          {
            "code" : "intervalTooShort",
            "display" : "Interval: too short"
          },
          {
            "code" : "seriesAlreadyCompleted",
            "display" : "Series Already Completed"
          },
          {
            "code" : "liveVirusConflict",
            "display" : "Live Virus Conflict"
          }
        ]
      }
    ]
  }
}

```
