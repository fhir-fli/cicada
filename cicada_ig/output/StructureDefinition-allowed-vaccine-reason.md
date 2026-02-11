# Allowed Vaccine Reason - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Allowed Vaccine Reason**

## Extension: Allowed Vaccine Reason 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-reason | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:AllowedVaccineReason |

Captures the reason why a particular vaccine is allowed.

**Context of Use**

**Usage info**

**Usages:**

* Use this Extension: [Dose of a Vaccine](StructureDefinition-vax-dose.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/allowed-vaccine-reason)

### Formal Views of Extension Content

 [Description of Profiles, Differentials, Snapshots, and how the XML and JSON presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-allowed-vaccine-reason.csv), [Excel](StructureDefinition-allowed-vaccine-reason.xlsx), [Schematron](StructureDefinition-allowed-vaccine-reason.sch) 

#### Terminology Bindings

#### Constraints



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "allowed-vaccine-reason",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-reason",
  "version" : "0.1.0",
  "name" : "AllowedVaccineReason",
  "title" : "Allowed Vaccine Reason",
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
  "description" : "Captures the reason why a particular vaccine is allowed.",
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
        "short" : "Allowed Vaccine Reason",
        "definition" : "Captures the reason why a particular vaccine is allowed."
      },
      {
        "id" : "Extension.extension",
        "path" : "Extension.extension",
        "max" : "0"
      },
      {
        "id" : "Extension.url",
        "path" : "Extension.url",
        "fixedUri" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-reason"
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
