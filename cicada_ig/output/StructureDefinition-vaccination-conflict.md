# Vaccination Conflict - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Vaccination Conflict**

## Extension: Vaccination Conflict 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vaccination-conflict | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:VaccinationConflict |

Indicates any conflicts with other vaccinations.

**Context of Use**

**Usage info**

**Usages:**

* Use this Extension: [Dose of a Vaccine](StructureDefinition-vax-dose.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/vaccination-conflict)

### Formal Views of Extension Content

 [Description of Profiles, Differentials, Snapshots, and how the XML and JSON presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-vaccination-conflict.csv), [Excel](StructureDefinition-vaccination-conflict.xlsx), [Schematron](StructureDefinition-vaccination-conflict.sch) 

#### Constraints



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "vaccination-conflict",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vaccination-conflict",
  "version" : "0.1.0",
  "name" : "VaccinationConflict",
  "title" : "Vaccination Conflict",
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
  "description" : "Indicates any conflicts with other vaccinations.",
  "fhirVersion" : "4.0.1",
  "mapping" : [
    {
      "identity" : "rim",
      "uri" : "http://hl7.org/v3",
      "name" : "RIM Mapping"
    }
  ],
  "kind" : "complex-type",
  "abstract" : false,
  "context" : [
    {
      "type" : "element",
      "expression" : "Element"
    }
  ],
  "type" : "Extension",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Extension",
  "derivation" : "constraint",
  "differential" : {
    "element" : [
      {
        "id" : "Extension",
        "path" : "Extension",
        "short" : "Vaccination Conflict",
        "definition" : "Indicates any conflicts with other vaccinations."
      },
      {
        "id" : "Extension.extension",
        "path" : "Extension.extension",
        "max" : "0"
      },
      {
        "id" : "Extension.url",
        "path" : "Extension.url",
        "fixedUri" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vaccination-conflict"
      },
      {
        "id" : "Extension.value[x]",
        "path" : "Extension.value[x]",
        "type" : [
          {
            "code" : "boolean"
          }
        ]
      }
    ]
  }
}

```
