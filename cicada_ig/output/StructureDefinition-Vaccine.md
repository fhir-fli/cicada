# Vaccine - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Vaccine**

## Resource Profile: Vaccine 

| | |
| :--- | :--- |
| *Official URL*:http://example.org/fhir/StructureDefinition/Vaccine | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:Vaccine |

 
Simple vaccine to easily obtain needed information for forecasting 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/Vaccine)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-Vaccine.csv), [Excel](StructureDefinition-Vaccine.xlsx), [Schematron](StructureDefinition-Vaccine.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "Vaccine",
  "url" : "http://example.org/fhir/StructureDefinition/Vaccine",
  "version" : "0.1.0",
  "name" : "Vaccine",
  "title" : "Vaccine",
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
  "description" : "Simple vaccine to easily obtain needed information for forecasting",
  "fhirVersion" : "4.0.1",
  "mapping" : [
    {
      "identity" : "script10.6",
      "uri" : "http://ncpdp.org/SCRIPT10_6",
      "name" : "Mapping to NCPDP SCRIPT 10.6"
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
  "type" : "Medication",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Medication",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "Medication",
        "path" : "Medication"
      },
      {
        "id" : "Medication.extension",
        "path" : "Medication.extension",
        "slicing" : {
          "discriminator" : [
            {
              "type" : "value",
              "path" : "url"
            }
          ],
          "ordered" : false,
          "rules" : "open"
        }
      },
      {
        "id" : "Medication.extension:beginAge",
        "path" : "Medication.extension",
        "sliceName" : "beginAge",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/begin-age"
            ]
          }
        ]
      },
      {
        "id" : "Medication.extension:endAge",
        "path" : "Medication.extension",
        "sliceName" : "endAge",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/end-age"
            ]
          }
        ]
      },
      {
        "id" : "Medication.extension:vaccineType",
        "path" : "Medication.extension",
        "sliceName" : "vaccineType",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vaccine-type"
            ]
          }
        ]
      },
      {
        "id" : "Medication.identifier",
        "path" : "Medication.identifier",
        "slicing" : {
          "discriminator" : [
            {
              "type" : "pattern",
              "path" : "type"
            }
          ],
          "rules" : "open"
        }
      },
      {
        "id" : "Medication.identifier:tradeName",
        "path" : "Medication.identifier",
        "sliceName" : "tradeName",
        "min" : 0,
        "max" : "1"
      },
      {
        "id" : "Medication.identifier:tradeName.type",
        "path" : "Medication.identifier.type",
        "min" : 1,
        "patternCodeableConcept" : {
          "coding" : [
            {
              "code" : "official"
            }
          ]
        }
      }
    ]
  }
}

```
