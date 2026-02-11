# Observation Profile for Immunization Decision Support - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Observation Profile for Immunization Decision Support**

## Resource Profile: Observation Profile for Immunization Decision Support 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/VaccineObservationFhir | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:VaccineObservationFhir |

 
Profile for Observation resources carrying lab evidence of immunity or other findings relevant to immunization decisions. Codes may be from SNOMED CT, ICD-10-CM, or LOINC. 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/VaccineObservationFhir)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-VaccineObservationFhir.csv), [Excel](StructureDefinition-VaccineObservationFhir.xlsx), [Schematron](StructureDefinition-VaccineObservationFhir.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "VaccineObservationFhir",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/VaccineObservationFhir",
  "version" : "0.1.0",
  "name" : "VaccineObservationFhir",
  "title" : "Observation Profile for Immunization Decision Support",
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
  "description" : "Profile for Observation resources carrying lab evidence of immunity or other findings relevant to immunization decisions. Codes may be from SNOMED CT, ICD-10-CM, or LOINC.",
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
  "type" : "Observation",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Observation",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "Observation",
        "path" : "Observation"
      },
      {
        "id" : "Observation.code",
        "path" : "Observation.code",
        "binding" : {
          "strength" : "extensible",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-condition-codes-snomed"
        }
      }
    ]
  }
}

```
