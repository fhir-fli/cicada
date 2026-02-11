# Interval Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Interval Reason**

## ValueSet: Interval Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ValueSet/interval-reason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:IntervalReasonVS |

 
This value set includes codes for the reason an interval is considered to be invalid. 

 **References** 

* [Allowed Interval Reason](StructureDefinition-allowed-interval-reason.md)
* [Preferred Interval Reason](StructureDefinition-preferred-interval-reason.md)

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
  "id" : "interval-reason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/interval-reason",
  "version" : "0.1.0",
  "name" : "IntervalReasonVS",
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
  "compose" : {
    "include" : [
      {
        "system" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/IntervalReason",
        "concept" : [
          {
            "code" : "tooLate",
            "display" : "Interval: too late"
          },
          {
            "code" : "tooShort",
            "display" : "Interval: too short"
          },
          {
            "code" : "gracePeriod",
            "display" : "Interval: grace period"
          }
        ]
      }
    ]
  }
}

```
