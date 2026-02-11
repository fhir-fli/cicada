# Lab Evidence of Immunity (LOINC) - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Lab Evidence of Immunity (LOINC)**

## ValueSet: Lab Evidence of Immunity (LOINC) 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-lab-evidence-of-immunity-loinc | *Version*:0.1.0 |
| Active as of 2026-02-11 | *Computable Name*:VaccineLabEvidenceOfImmunityLoinc |

 
LOINC codes for laboratory tests that provide evidence of immunity, mapped to CDSi observation codes for immunization decision support. 

 **References** 

This value set is not used here; it may be used elsewhere (e.g. specifications and/or implementations that use this content)

### Logical Definition (CLD)

 

### Expansion

-------

 Explanation of the columns that may appear on this page: 

| | |
| :--- | :--- |
| Level | A few code lists that FHIR defines are hierarchical - each code is assigned a level. In this scheme, some codes are under other codes, and imply that the code they are under also applies |
| System | The source of the definition of the code (when the value set draws in codes defined elsewhere) |
| Code | The code (used as the code in the resource instance) |
| Display | The display (used in the*display*element of a[Coding](http://hl7.org/fhir/R4/datatypes.html#Coding)). If there is no display, implementers should not simply display the code, but map the concept into their application |
| Definition | An explanation of the meaning of the concept |
| Comments | Additional notes about how to use the code |



## Resource Content

```json
{
  "resourceType" : "ValueSet",
  "id" : "vaccine-lab-evidence-of-immunity-loinc",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/ValueSet/vaccine-lab-evidence-of-immunity-loinc",
  "version" : "0.1.0",
  "name" : "VaccineLabEvidenceOfImmunityLoinc",
  "title" : "Lab Evidence of Immunity (LOINC)",
  "status" : "active",
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
  "description" : "LOINC codes for laboratory tests that provide evidence of immunity, mapped to CDSi observation codes for immunization decision support.",
  "compose" : {
    "include" : [
      {
        "system" : "http://loinc.org",
        "concept" : [
          {
            "code" : "21500-4",
            "display" : "Measles virus IgG Ab [Units/volume] in Serum"
          },
          {
            "code" : "35275-7",
            "display" : "Measles virus IgG Ab [Presence] in Serum"
          },
          {
            "code" : "20479-2",
            "display" : "Measles virus Ab [Presence] in Serum"
          },
          {
            "code" : "6476-3",
            "display" : "Mumps virus IgG Ab [Units/volume] in Serum"
          },
          {
            "code" : "39012-0",
            "display" : "Mumps virus IgG Ab [Presence] in Serum"
          },
          {
            "code" : "22416-2",
            "display" : "Mumps virus Ab [Presence] in Serum"
          },
          {
            "code" : "8014-3",
            "display" : "Rubella virus IgG Ab [Units/volume] in Serum"
          },
          {
            "code" : "25514-1",
            "display" : "Rubella virus IgG Ab [Presence] in Serum"
          },
          {
            "code" : "20458-6",
            "display" : "Rubella virus Ab [Presence] in Serum"
          },
          {
            "code" : "19162-7",
            "display" : "Varicella zoster virus IgG Ab [Units/volume] in Serum"
          },
          {
            "code" : "17763-4",
            "display" : "Varicella zoster virus IgG Ab [Presence] in Serum"
          },
          {
            "code" : "5403-8",
            "display" : "Varicella zoster virus Ab [Presence] in Serum"
          },
          {
            "code" : "16935-9",
            "display" : "Hepatitis B virus surface Ab [Units/volume] in Serum"
          },
          {
            "code" : "22322-2",
            "display" : "Hepatitis B virus surface Ab [Presence] in Serum"
          },
          {
            "code" : "10900-9",
            "display" : "Hepatitis B virus surface Ab [Units/volume] in Serum by Immunoassay"
          },
          {
            "code" : "32018-4",
            "display" : "Hepatitis A virus Ab [Presence] in Serum"
          },
          {
            "code" : "40724-7",
            "display" : "Hepatitis A virus IgG Ab [Presence] in Serum"
          },
          {
            "code" : "13950-1",
            "display" : "Hepatitis A virus Ab [Units/volume] in Serum"
          }
        ]
      }
    ]
  }
}

```
