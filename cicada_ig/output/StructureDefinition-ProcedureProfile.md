# Immunization Procedures Profile - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Immunization Procedures Profile**

## Resource Profile: Immunization Procedures Profile 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/ProcedureProfile | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:ProcedureProfile |

 
Profile for medical procedures related to immunization based on SNOMED CT or CPT codes. 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/ProcedureProfile)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-ProcedureProfile.csv), [Excel](StructureDefinition-ProcedureProfile.xlsx), [Schematron](StructureDefinition-ProcedureProfile.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "ProcedureProfile",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/ProcedureProfile",
  "version" : "0.1.0",
  "name" : "ProcedureProfile",
  "title" : "Immunization Procedures Profile",
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
  "description" : "Profile for medical procedures related to immunization based on SNOMED CT or CPT codes.",
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
  "type" : "Procedure",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Procedure",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "Procedure",
        "path" : "Procedure"
      },
      {
        "id" : "Procedure.code",
        "path" : "Procedure.code",
        "binding" : {
          "strength" : "extensible",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/procedures"
        }
      }
    ]
  }
}

```
