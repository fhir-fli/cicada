# Evaluation Status Value Set - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Evaluation Status Value Set**

## ValueSet: Evaluation Status Value Set 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ValueSet/eval-status | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:EvalStatusVS |

 
Value Set for the status of the result of an evaluation. 

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
  "id" : "eval-status",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/eval-status",
  "version" : "0.1.0",
  "name" : "EvalStatusVS",
  "title" : "Evaluation Status Value Set",
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
  "description" : "Value Set for the status of the result of an evaluation.",
  "compose" : {
    "include" : [
      {
        "system" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalStatus",
        "concept" : [
          {
            "code" : "valid",
            "display" : "Valid"
          },
          {
            "code" : "not_valid",
            "display" : "Not Valid"
          },
          {
            "code" : "extraneous",
            "display" : "Extraneous"
          },
          {
            "code" : "sub_standard",
            "display" : "Substandard"
          }
        ]
      }
    ]
  }
}

```
