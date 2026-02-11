# Allowed Interval Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Allowed Interval Reason**

## Extension: Allowed Interval Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-reason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:AllowedIntervalReason |

Captures the reason for the allowed interval between vaccine doses.

**Context of Use**

**Usage info**

**Usages:**

* Use this Extension: [Dose of a Vaccine](StructureDefinition-vax-dose.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/allowed-interval-reason)

### Formal Views of Extension Content

 [Description of Profiles, Differentials, Snapshots, and how the XML and JSON presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-allowed-interval-reason.csv), [Excel](StructureDefinition-allowed-interval-reason.xlsx), [Schematron](StructureDefinition-allowed-interval-reason.sch) 

#### Terminology Bindings

#### Constraints



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "allowed-interval-reason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-reason",
  "version" : "0.1.0",
  "name" : "AllowedIntervalReason",
  "title" : "Allowed Interval Reason",
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
  "description" : "Captures the reason for the allowed interval between vaccine doses.",
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
        "short" : "Allowed Interval Reason",
        "definition" : "Captures the reason for the allowed interval between vaccine doses."
      },
      {
        "id" : "Extension.extension",
        "path" : "Extension.extension",
        "max" : "0"
      },
      {
        "id" : "Extension.url",
        "path" : "Extension.url",
        "fixedUri" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-reason"
      },
      {
        "id" : "Extension.value[x]",
        "path" : "Extension.value[x]",
        "binding" : {
          "strength" : "required",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/interval-reason"
        }
      }
    ]
  }
}

```
