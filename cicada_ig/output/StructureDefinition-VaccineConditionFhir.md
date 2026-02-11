# Condition Profile with Vaccine Condition Codes - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Condition Profile with Vaccine Condition Codes**

## Resource Profile: Condition Profile with Vaccine Condition Codes 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/VaccineConditionFhir | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:VaccineConditionFhir |

 
Profile for conditions where the code must be from the Vaccine Condition Codes value set. Accepts SNOMED CT and ICD-10-CM coded conditions. 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/VaccineConditionFhir)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-VaccineConditionFhir.csv), [Excel](StructureDefinition-VaccineConditionFhir.xlsx), [Schematron](StructureDefinition-VaccineConditionFhir.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "VaccineConditionFhir",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/VaccineConditionFhir",
  "version" : "0.1.0",
  "name" : "VaccineConditionFhir",
  "title" : "Condition Profile with Vaccine Condition Codes",
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
  "description" : "Profile for conditions where the code must be from the Vaccine Condition Codes value set. Accepts SNOMED CT and ICD-10-CM coded conditions.",
  "fhirVersion" : "4.0.1",
  "mapping" : [
    {
      "identity" : "workflow",
      "uri" : "http://hl7.org/fhir/workflow",
      "name" : "Workflow Pattern"
    },
    {
      "identity" : "sct-concept",
      "uri" : "http://snomed.info/conceptdomain",
      "name" : "SNOMED CT Concept Domain Binding"
    },
    {
      "identity" : "v2",
      "uri" : "http://hl7.org/v2",
      "name" : "HL7 v2 Mapping"
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
      "identity" : "sct-attr",
      "uri" : "http://snomed.org/attributebinding",
      "name" : "SNOMED CT Attribute Binding"
    }
  ],
  "kind" : "resource",
  "abstract" : false,
  "type" : "Condition",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Condition",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "Condition",
        "path" : "Condition"
      },
      {
        "id" : "Condition.code",
        "path" : "Condition.code",
        "binding" : {
          "strength" : "extensible",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-condition-codes-snomed"
        }
      }
    ]
  }
}

```
