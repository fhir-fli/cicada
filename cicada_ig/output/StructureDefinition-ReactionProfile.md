# Allergy Intolerance Profile for Immunization Decision Support - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Allergy Intolerance Profile for Immunization Decision Support**

## Resource Profile: Allergy Intolerance Profile for Immunization Decision Support 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/ReactionProfile | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:ReactionProfile |

 
Profile for allergy intolerances relevant to immunization. The code (allergen/substance) may use SNOMED CT or ICD-10-CM. Reaction substances may use CVX, MVX, SNOMED CT, or RxNorm. 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/ReactionProfile)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-ReactionProfile.csv), [Excel](StructureDefinition-ReactionProfile.xlsx), [Schematron](StructureDefinition-ReactionProfile.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "ReactionProfile",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/ReactionProfile",
  "version" : "0.1.0",
  "name" : "ReactionProfile",
  "title" : "Allergy Intolerance Profile for Immunization Decision Support",
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
  "description" : "Profile for allergy intolerances relevant to immunization. The code (allergen/substance) may use SNOMED CT or ICD-10-CM. Reaction substances may use CVX, MVX, SNOMED CT, or RxNorm.",
  "fhirVersion" : "4.0.1",
  "mapping" : [
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
  "type" : "AllergyIntolerance",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/AllergyIntolerance",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "AllergyIntolerance",
        "path" : "AllergyIntolerance"
      },
      {
        "id" : "AllergyIntolerance.code",
        "path" : "AllergyIntolerance.code",
        "binding" : {
          "strength" : "extensible",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-condition-codes-snomed"
        }
      },
      {
        "id" : "AllergyIntolerance.reaction.substance",
        "path" : "AllergyIntolerance.reaction.substance",
        "binding" : {
          "strength" : "extensible",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/VaccineCodesCvxMvx"
        }
      }
    ]
  }
}

```
