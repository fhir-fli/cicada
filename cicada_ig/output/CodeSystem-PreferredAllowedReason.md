# Reasons why certain doses are Preferred or Allowed doses - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Reasons why certain doses are Preferred or Allowed doses**

## CodeSystem: Reasons why certain doses are Preferred or Allowed doses 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/CodeSystem/PreferredAllowedReason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:PreferredAllowedReasonCS |

 
Reasons why certain doses are Preferred or Allowed doses 

 This Code system is referenced in the content logical definition of the following value sets: 

* [PreferredAllowedReasonVS](ValueSet-preferred-allowed-reason.md)



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "PreferredAllowedReason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/PreferredAllowedReason",
  "version" : "0.1.0",
  "name" : "PreferredAllowedReasonCS",
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
  "content" : "complete",
  "count" : 6,
  "concept" : [
    {
      "code" : "notAPreferableOrAllowableVaccine",
      "display" : "Not a preferable or allowable vaccine",
      "definition" : "Not a preferable or allowable vaccine"
    },
    {
      "code" : "wrongTradeName",
      "display" : "Wrong trade name",
      "definition" : "Wrong trade name"
    },
    {
      "code" : "lessThanRecommendedVolume",
      "display" : "Less than recommended volume",
      "definition" : "Less than recommended volume"
    },
    {
      "code" : "administeredOutsideOfPreferredAgeRange",
      "display" : "Administered outside of preferred age range",
      "definition" : "Administered outside of preferred age range"
    },
    {
      "code" : "noPreferredTypes",
      "display" : "No preferred types",
      "definition" : "No preferred types"
    },
    {
      "code" : "noAllowedTypes",
      "display" : "No allowed types",
      "definition" : "No allowed types"
    }
  ]
}

```
