# Medication Administration Profile with Vaccine Codes - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Medication Administration Profile with Vaccine Codes**

## Resource Profile: Medication Administration Profile with Vaccine Codes 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/MedicationAdministrationProfile | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:MedicationAdministrationProfile |

 
Profile for medication administrations with vaccine codes from CVX or MVX. 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/MedicationAdministrationProfile)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-MedicationAdministrationProfile.csv), [Excel](StructureDefinition-MedicationAdministrationProfile.xlsx), [Schematron](StructureDefinition-MedicationAdministrationProfile.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "MedicationAdministrationProfile",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/MedicationAdministrationProfile",
  "version" : "0.1.0",
  "name" : "MedicationAdministrationProfile",
  "title" : "Medication Administration Profile with Vaccine Codes",
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
  "description" : "Profile for medication administrations with vaccine codes from CVX or MVX.",
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
    },
    {
      "identity" : "w3c.prov",
      "uri" : "http://www.w3.org/ns/prov",
      "name" : "W3C PROV"
    }
  ],
  "kind" : "resource",
  "abstract" : false,
  "type" : "MedicationAdministration",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/MedicationAdministration",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "MedicationAdministration",
        "path" : "MedicationAdministration"
      },
      {
        "id" : "MedicationAdministration.medication[x]",
        "path" : "MedicationAdministration.medication[x]",
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
        "id" : "MedicationAdministration.medication[x]:medicationCodeableConcept",
        "path" : "MedicationAdministration.medication[x]",
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
