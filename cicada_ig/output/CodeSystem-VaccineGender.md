# Vaccine Gender - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Vaccine Gender**

## CodeSystem: Vaccine Gender 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/CodeSystem/VaccineGender | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:VaccineGenderCS |

 
Value set for gender categories relevant to vaccination data. 

 This Code system is referenced in the content logical definition of the following value sets: 

* [VaccineGenderVS](ValueSet-vaccine-gender.md)



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "VaccineGender",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/VaccineGender",
  "version" : "0.1.0",
  "name" : "VaccineGenderCS",
  "title" : "Vaccine Gender",
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
  "description" : "Value set for gender categories relevant to vaccination data.",
  "content" : "complete",
  "count" : 4,
  "concept" : [
    {
      "code" : "female",
      "display" : "Female",
      "definition" : "Female"
    },
    {
      "code" : "transgender",
      "display" : "Transgender",
      "definition" : "Transgender"
    },
    {
      "code" : "unknown",
      "display" : "Unknown",
      "definition" : "Unknown"
    },
    {
      "code" : "male",
      "display" : "Male",
      "definition" : "Male"
    }
  ]
}

```
