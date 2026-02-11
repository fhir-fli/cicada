# Begin Age - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Begin Age**

## Extension: Begin Age 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/begin-age | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:BeginAge |

The age at which the vaccine becomes applicable.

**Context of Use**

**Usage info**

**Usages:**

* Use this Extension: [Vaccine](StructureDefinition-Vaccine.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/begin-age)

### Formal Views of Extension Content

 [Description of Profiles, Differentials, Snapshots, and how the XML and JSON presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-begin-age.csv), [Excel](StructureDefinition-begin-age.xlsx), [Schematron](StructureDefinition-begin-age.sch) 

#### Constraints



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "begin-age",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/begin-age",
  "version" : "0.1.0",
  "name" : "BeginAge",
  "title" : "Begin Age",
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
  "description" : "The age at which the vaccine becomes applicable.",
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
        "short" : "Begin Age",
        "definition" : "The age at which the vaccine becomes applicable."
      },
      {
        "id" : "Extension.extension",
        "path" : "Extension.extension",
        "max" : "0"
      },
      {
        "id" : "Extension.url",
        "path" : "Extension.url",
        "fixedUri" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/begin-age"
      },
      {
        "id" : "Extension.value[x]",
        "path" : "Extension.value[x]",
        "type" : [
          {
            "code" : "Age"
          }
        ]
      }
    ]
  }
}

```
