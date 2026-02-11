# Dose of a Vaccine - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Dose of a Vaccine**

## Resource Profile: Dose of a Vaccine 

| | |
| :--- | :--- |
| *Official URL*:http://example.org/fhir/StructureDefinition/vax-dose | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:VaxDose |

 
Detailed information about each vaccination dose. 

**Usages:**

* This Profile is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/vax-dose)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-vax-dose.csv), [Excel](StructureDefinition-vax-dose.xlsx), [Schematron](StructureDefinition-vax-dose.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "vax-dose",
  "url" : "http://example.org/fhir/StructureDefinition/vax-dose",
  "version" : "0.1.0",
  "name" : "VaxDose",
  "title" : "Dose of a Vaccine",
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
  "description" : "Detailed information about each vaccination dose.",
  "fhirVersion" : "4.0.1",
  "mapping" : [
    {
      "identity" : "workflow",
      "uri" : "http://hl7.org/fhir/workflow",
      "name" : "Workflow Pattern"
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
      "identity" : "cda",
      "uri" : "http://hl7.org/v3/cda",
      "name" : "CDA (R2)"
    }
  ],
  "kind" : "resource",
  "abstract" : false,
  "type" : "Immunization",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Immunization",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "Immunization",
        "path" : "Immunization"
      },
      {
        "id" : "Immunization.extension",
        "path" : "Immunization.extension",
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
        "id" : "Immunization.extension:assessmentDate",
        "path" : "Immunization.extension",
        "sliceName" : "assessmentDate",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/assessment-date"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:inadvertentAdministration",
        "path" : "Immunization.extension",
        "sliceName" : "inadvertentAdministration",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/inadvertent-administration-status"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:validAgeStatus",
        "path" : "Immunization.extension",
        "sliceName" : "validAgeStatus",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/valid-age-status"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:validAgeReason",
        "path" : "Immunization.extension",
        "sliceName" : "validAgeReason",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/valid-age-reason"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:preferredIntervalStatus",
        "path" : "Immunization.extension",
        "sliceName" : "preferredIntervalStatus",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-interval-status"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:preferredIntervalReason",
        "path" : "Immunization.extension",
        "sliceName" : "preferredIntervalReason",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-interval-reason"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:allowedIntervalStatus",
        "path" : "Immunization.extension",
        "sliceName" : "allowedIntervalStatus",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-status"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:allowedIntervalReason",
        "path" : "Immunization.extension",
        "sliceName" : "allowedIntervalReason",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-reason"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:vaccinationConflict",
        "path" : "Immunization.extension",
        "sliceName" : "vaccinationConflict",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vaccination-conflict"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:preferredVaccineStatus",
        "path" : "Immunization.extension",
        "sliceName" : "preferredVaccineStatus",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-status"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:preferredVaccineReason",
        "path" : "Immunization.extension",
        "sliceName" : "preferredVaccineReason",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-reason"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:allowedVaccineStatus",
        "path" : "Immunization.extension",
        "sliceName" : "allowedVaccineStatus",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-status"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.extension:allowedVaccineReason",
        "path" : "Immunization.extension",
        "sliceName" : "allowedVaccineReason",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "Extension",
            "profile" : [
              "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-reason"
            ]
          }
        ]
      },
      {
        "id" : "Immunization.status",
        "path" : "Immunization.status",
        "binding" : {
          "strength" : "required",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/eval-status"
        }
      },
      {
        "id" : "Immunization.statusReason",
        "path" : "Immunization.statusReason",
        "binding" : {
          "strength" : "extensible",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/eval-reason"
        }
      },
      {
        "id" : "Immunization.vaccineCode",
        "path" : "Immunization.vaccineCode",
        "binding" : {
          "strength" : "required",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/VaccineCodesCvxMvx"
        }
      },
      {
        "id" : "Immunization.occurrence[x]",
        "path" : "Immunization.occurrence[x]",
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
        "id" : "Immunization.occurrence[x]:occurrenceDateTime",
        "path" : "Immunization.occurrence[x]",
        "sliceName" : "occurrenceDateTime",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "dateTime"
          }
        ]
      },
      {
        "id" : "Immunization.subpotentReason",
        "path" : "Immunization.subpotentReason",
        "binding" : {
          "strength" : "required",
          "valueSet" : "http://hl7.org/fhir/ValueSet/immunization-subpotent-reason"
        }
      },
      {
        "id" : "Immunization.protocolApplied",
        "path" : "Immunization.protocolApplied",
        "slicing" : {
          "discriminator" : [
            {
              "type" : "pattern",
              "path" : "doseNumberPositiveInt"
            }
          ],
          "rules" : "open"
        }
      }
    ]
  }
}

```
