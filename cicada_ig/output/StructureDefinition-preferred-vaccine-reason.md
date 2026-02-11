# Preferred Vaccine Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Preferred Vaccine Reason**

## Extension: Preferred Vaccine Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-reason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:PreferredVaccineReason |

Captures the reason why a particular vaccine is preferred.

**Context of Use**

**Usage info**

**Usages:**

* Use this Extension: [Dose of a Vaccine](StructureDefinition-vax-dose.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/preferred-vaccine-reason)

### Formal Views of Extension Content

 [Description of Profiles, Differentials, Snapshots, and how the XML and JSON presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-preferred-vaccine-reason.csv), [Excel](StructureDefinition-preferred-vaccine-reason.xlsx), [Schematron](StructureDefinition-preferred-vaccine-reason.sch) 

#### Terminology Bindings

#### Constraints



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "preferred-vaccine-reason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-reason",
  "version" : "0.1.0",
  "name" : "PreferredVaccineReason",
  "title" : "Preferred Vaccine Reason",
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
  "description" : "Captures the reason why a particular vaccine is preferred.",
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
        "short" : "Preferred Vaccine Reason",
        "definition" : "Captures the reason why a particular vaccine is preferred."
      },
      {
        "id" : "Extension.extension",
        "path" : "Extension.extension",
        "max" : "0"
      },
      {
        "id" : "Extension.url",
        "path" : "Extension.url",
        "fixedUri" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-reason"
      },
      {
        "id" : "Extension.value[x]",
        "path" : "Extension.value[x]",
        "binding" : {
          "strength" : "required",
          "valueSet" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/preferred-allowed-reason"
        }
      }
    ]
  }
}

```
