# Medication Statement Profile with Vaccine Codes - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Medication Statement Profile with Vaccine Codes**

## Resource Profile: Medication Statement Profile with Vaccine Codes 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/MedicationStatementProfile | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:MedicationStatementProfile |

 
Profile for medication statements with vaccine codes from CVX or MVX. 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/MedicationStatementProfile)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-MedicationStatementProfile.csv), [Excel](StructureDefinition-MedicationStatementProfile.xlsx), [Schematron](StructureDefinition-MedicationStatementProfile.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "MedicationStatementProfile",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/MedicationStatementProfile",
  "version" : "0.1.0",
  "name" : "MedicationStatementProfile",
  "title" : "Medication Statement Profile with Vaccine Codes",
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
  "description" : "Profile for medication statements with vaccine codes from CVX or MVX.",
  "fhirVersion" : "4.0.1",
  "mapping" : [
    {
      "identity" : "workflow",
      "uri" : "http://hl7.org/fhir/workflow",
      "name" : "Workflow Pattern"
    },
    {
      "identity" : "rim",
      "uri" : "http://hl7.org/v3",
      "name" : "RIM Mapping"
    },
    {
      "identity" : "w5",
      "uri" : "http://hl7.org/fhir/fivews",
      "name" : "FiveWs Pattern Mapping"
    },
    {
      "identity" : "v2",
      "uri" : "http://hl7.org/v2",
      "name" : "HL7 v2 Mapping"
    }
  ],
  "kind" : "resource",
  "abstract" : false,
  "type" : "MedicationStatement",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/MedicationStatement",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "MedicationStatement",
        "path" : "MedicationStatement"
      },
      {
        "id" : "MedicationStatement.medication[x]",
        "path" : "MedicationStatement.medication[x]",
        "slicing" : {
          "discriminator" : [
            {
              "type" : "type",
              "path" : "$this"
            }
          ],
          "ordered" : false,
          "rules" : "open"
        }
      },
      {
        "id" : "MedicationStatement.medication[x]:medicationCodeableConcept",
        "path" : "MedicationStatement.medication[x]",
        "sliceName" : "medicationCodeableConcept",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "CodeableConcept"
          }
        ],
        "binding" : {
          "strength" : "required",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/VaccineCodesCvxMvx"
        }
      }
    ]
  }
}

```
