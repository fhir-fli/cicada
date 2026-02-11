# Immunization-Relevant Medications (RxNorm) - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Immunization-Relevant Medications (RxNorm)**

## ValueSet: Immunization-Relevant Medications (RxNorm) 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-medication-codes-rxnorm | *Version*:0.1.0 |
| Active as of 2026-02-11 | *Computable Name*:VaccineMedicationCodesRxnorm |

 
RxNorm codes for medications relevant to immunization decision support, including antivirals and aspirin. 

 **References** 

This value set is not used here; it may be used elsewhere (e.g. specifications and/or implementations that use this content)

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
  "id" : "vaccine-medication-codes-rxnorm",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-medication-codes-rxnorm",
  "version" : "0.1.0",
  "name" : "VaccineMedicationCodesRxnorm",
  "title" : "Immunization-Relevant Medications (RxNorm)",
  "status" : "active",
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
  "description" : "RxNorm codes for medications relevant to immunization decision support, including antivirals and aspirin.",
  "compose" : {
    "include" : [
      {
        "system" : "http://www.nlm.nih.gov/research/umls/rxnorm",
        "concept" : [
          {
            "code" : "281",
            "display" : "Acyclovir"
          },
          {
            "code" : "24811",
            "display" : "Famciclovir"
          },
          {
            "code" : "39786",
            "display" : "Valacyclovir"
          },
          {
            "code" : "1191",
            "display" : "Aspirin"
          }
        ]
      }
    ]
  }
}

```
