# Reasons why certain doses are Preferred or Allowed doses - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Reasons why certain doses are Preferred or Allowed doses**

## ValueSet: Reasons why certain doses are Preferred or Allowed doses 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ValueSet/preferred-allowed-reason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:PreferredAllowedReasonVS |

 
Reasons why certain doses are Preferred or Allowed doses 

 **References** 

* [Allowed Vaccine Reason](StructureDefinition-allowed-vaccine-reason.md)
* [Preferred Vaccine Reason](StructureDefinition-preferred-vaccine-reason.md)

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
  "id" : "preferred-allowed-reason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/preferred-allowed-reason",
  "version" : "0.1.0",
  "name" : "PreferredAllowedReasonVS",
  "title" : "Reasons why certain doses are Preferred or Allowed doses",
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
  "description" : "Reasons why certain doses are Preferred or Allowed doses",
  "compose" : {
    "include" : [
      {
        "system" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/PreferredAllowedReason",
        "concept" : [
          {
            "code" : "notAPreferableOrAllowableVaccine",
            "display" : "Not a preferable or allowable vaccine"
          },
          {
            "code" : "wrongTradeName",
            "display" : "Wrong trade name"
          },
          {
            "code" : "lessThanRecommendedVolume",
            "display" : "Less than recommended volume"
          },
          {
            "code" : "administeredOutsideOfPreferredAgeRange",
            "display" : "Administered outside of preferred age range"
          },
          {
            "code" : "noPreferredTypes",
            "display" : "No preferred types"
          },
          {
            "code" : "noAllowedTypes",
            "display" : "No allowed types"
          }
        ]
      }
    ]
  }
}

```
