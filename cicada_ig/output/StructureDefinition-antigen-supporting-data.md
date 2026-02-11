# Antigen Supporting Data - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Antigen Supporting Data**

## Resource Profile: Antigen Supporting Data 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/antigen-supporting-data | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:AntigenSupportingData |

 
A resource to store supporting data for antigens including target disease, vaccine groups, immunity criteria, contraindications, and vaccination series. 

**Usages:**

* This Resource is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/antigen-supporting-data)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-antigen-supporting-data.csv), [Excel](StructureDefinition-antigen-supporting-data.xlsx), [Schematron](StructureDefinition-antigen-supporting-data.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "antigen-supporting-data",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/antigen-supporting-data",
  "version" : "0.1.0",
  "name" : "AntigenSupportingData",
  "title" : "Antigen Supporting Data",
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
  "description" : "A resource to store supporting data for antigens including target disease, vaccine groups, immunity criteria, contraindications, and vaccination series.",
  "fhirVersion" : "4.0.1",
  "mapping" : [
    {
      "identity" : "rim",
      "uri" : "http://hl7.org/v3",
      "name" : "RIM Mapping"
    }
  ],
  "kind" : "resource",
  "abstract" : false,
  "type" : "antigen-supporting-data",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Element",
  "derivation" : "specialization",
  "differential" : {
    "element" : [
      {
        "id" : "antigen-supporting-data",
        "path" : "antigen-supporting-data",
        "short" : "Antigen Supporting Data",
        "definition" : "A resource to store supporting data for antigens including target disease, vaccine groups, immunity criteria, contraindications, and vaccination series."
      },
      {
        "id" : "antigen-supporting-data.targetDisease",
        "path" : "antigen-supporting-data.targetDisease",
        "short" : "The disease that the vaccine targets.",
        "definition" : "The disease that the vaccine targets.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "CodeableConcept"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.vaccineGroup",
        "path" : "antigen-supporting-data.vaccineGroup",
        "short" : "The vaccine group associated with the target disease.",
        "definition" : "The vaccine group associated with the target disease.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "CodeableConcept"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity",
        "path" : "antigen-supporting-data.immunity",
        "short" : "Information about immunity from clinical history or birth data.",
        "definition" : "Information about immunity from clinical history or birth data.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.clinicalHistory",
        "path" : "antigen-supporting-data.immunity.clinicalHistory",
        "short" : "List of clinical guidelines that describe circumstances of immunity.",
        "definition" : "List of clinical guidelines that describe circumstances of immunity.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.clinicalHistory.guidelineCode",
        "path" : "antigen-supporting-data.immunity.clinicalHistory.guidelineCode",
        "short" : "Code of the guideline.",
        "definition" : "Code of the guideline.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.clinicalHistory.guidelineTitle",
        "path" : "antigen-supporting-data.immunity.clinicalHistory.guidelineTitle",
        "short" : "Title of the guideline.",
        "definition" : "Title of the guideline.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.dateOfBirth",
        "path" : "antigen-supporting-data.immunity.dateOfBirth",
        "short" : "Birth date related immunity information.",
        "definition" : "Birth date related immunity information.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.dateOfBirth.immunityBirthDate",
        "path" : "antigen-supporting-data.immunity.dateOfBirth.immunityBirthDate",
        "short" : "Date conferring automatic immunity.",
        "definition" : "Date conferring automatic immunity.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "date"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.dateOfBirth.birthCountry",
        "path" : "antigen-supporting-data.immunity.dateOfBirth.birthCountry",
        "short" : "Country of birth relevant to immunity.",
        "definition" : "Country of birth relevant to immunity.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.dateOfBirth.exclusion",
        "path" : "antigen-supporting-data.immunity.dateOfBirth.exclusion",
        "short" : "Exclusions based on certain criteria.",
        "definition" : "Exclusions based on certain criteria.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.dateOfBirth.exclusion.exclusionCode",
        "path" : "antigen-supporting-data.immunity.dateOfBirth.exclusion.exclusionCode",
        "short" : "Code for the exclusion criteria.",
        "definition" : "Code for the exclusion criteria.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.immunity.dateOfBirth.exclusion.exclusionTitle",
        "path" : "antigen-supporting-data.immunity.dateOfBirth.exclusion.exclusionTitle",
        "short" : "Title of the exclusion criteria.",
        "definition" : "Title of the exclusion criteria.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.contraindications",
        "path" : "antigen-supporting-data.contraindications",
        "short" : "Information about contraindications for the vaccine.",
        "definition" : "Information about contraindications for the vaccine.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.contraindications.vaccineGroup",
        "path" : "antigen-supporting-data.contraindications.vaccineGroup",
        "short" : "Contraindications specific to the vaccine group.",
        "definition" : "Contraindications specific to the vaccine group.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication",
        "path" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication",
        "short" : "List of contraindications.",
        "definition" : "List of contraindications.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication.observationCode",
        "path" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication.observationCode",
        "short" : "Code identifying the contraindication.",
        "definition" : "Code identifying the contraindication.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication.observationTitle",
        "path" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication.observationTitle",
        "short" : "Title of the contraindication.",
        "definition" : "Title of the contraindication.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication.contraindicationText",
        "path" : "antigen-supporting-data.contraindications.vaccineGroup.contraindication.contraindicationText",
        "short" : "Description of the contraindication.",
        "definition" : "Description of the contraindication.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series",
        "path" : "antigen-supporting-data.series",
        "short" : "Information about the vaccination series.",
        "definition" : "Information about the vaccination series.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesName",
        "path" : "antigen-supporting-data.series.seriesName",
        "short" : "Name of the vaccination series.",
        "definition" : "Name of the vaccination series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.targetDisease",
        "path" : "antigen-supporting-data.series.targetDisease",
        "short" : "Disease targeted by the series.",
        "definition" : "Disease targeted by the series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "CodeableConcept"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.vaccineGroup",
        "path" : "antigen-supporting-data.series.vaccineGroup",
        "short" : "Vaccine group for the series.",
        "definition" : "Vaccine group for the series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "CodeableConcept"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesType",
        "path" : "antigen-supporting-data.series.seriesType",
        "short" : "Type of series (standard, risk-based, etc.).",
        "definition" : "Type of series (standard, risk-based, etc.).",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries",
        "path" : "antigen-supporting-data.series.selectSeries",
        "short" : "Selection criteria for the series.",
        "definition" : "Selection criteria for the series.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries.defaultSeries",
        "path" : "antigen-supporting-data.series.selectSeries.defaultSeries",
        "short" : "If this is the default series.",
        "definition" : "If this is the default series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "boolean"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries.productPath",
        "path" : "antigen-supporting-data.series.selectSeries.productPath",
        "short" : "If the series has a specific product path.",
        "definition" : "If the series has a specific product path.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "boolean"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries.seriesGroupName",
        "path" : "antigen-supporting-data.series.selectSeries.seriesGroupName",
        "short" : "Name of the series group.",
        "definition" : "Name of the series group.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries.seriesGroup",
        "path" : "antigen-supporting-data.series.selectSeries.seriesGroup",
        "short" : "Group number of the series.",
        "definition" : "Group number of the series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries.seriesPriority",
        "path" : "antigen-supporting-data.series.selectSeries.seriesPriority",
        "short" : "Priority of the series.",
        "definition" : "Priority of the series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries.seriesPreference",
        "path" : "antigen-supporting-data.series.selectSeries.seriesPreference",
        "short" : "Preference number within the group.",
        "definition" : "Preference number within the group.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.selectSeries.maxAgeToStart",
        "path" : "antigen-supporting-data.series.selectSeries.maxAgeToStart",
        "short" : "Maximum age to start the series.",
        "definition" : "Maximum age to start the series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose",
        "path" : "antigen-supporting-data.series.seriesDose",
        "short" : "Doses within the series.",
        "definition" : "Doses within the series.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.doseNumber",
        "path" : "antigen-supporting-data.series.seriesDose.doseNumber",
        "short" : "Number of the dose in the series.",
        "definition" : "Number of the dose in the series.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.age",
        "path" : "antigen-supporting-data.series.seriesDose.age",
        "short" : "Age recommendations for the dose.",
        "definition" : "Age recommendations for the dose.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.age.absMinAge",
        "path" : "antigen-supporting-data.series.seriesDose.age.absMinAge",
        "short" : "Absolute minimum age for the dose.",
        "definition" : "Absolute minimum age for the dose.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.age.minAge",
        "path" : "antigen-supporting-data.series.seriesDose.age.minAge",
        "short" : "Minimum recommended age for the dose.",
        "definition" : "Minimum recommended age for the dose.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.age.earliestRecAge",
        "path" : "antigen-supporting-data.series.seriesDose.age.earliestRecAge",
        "short" : "Earliest recommended age for the dose.",
        "definition" : "Earliest recommended age for the dose.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.age.latestRecAge",
        "path" : "antigen-supporting-data.series.seriesDose.age.latestRecAge",
        "short" : "Latest recommended age for the dose.",
        "definition" : "Latest recommended age for the dose.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine",
        "short" : "Preferable vaccines for the dose.",
        "definition" : "Preferable vaccines for the dose.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.vaccineType",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.vaccineType",
        "short" : "Type of the vaccine.",
        "definition" : "Type of the vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.cvx",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.cvx",
        "short" : "CVX code for the vaccine.",
        "definition" : "CVX code for the vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.beginAge",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.beginAge",
        "short" : "Beginning age for the vaccine.",
        "definition" : "Beginning age for the vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.endAge",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.endAge",
        "short" : "Ending age for the vaccine.",
        "definition" : "Ending age for the vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.volume",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.volume",
        "short" : "Volume of the vaccine to be administered.",
        "definition" : "Volume of the vaccine to be administered.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "decimal"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.forecastVaccineType",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.forecastVaccineType",
        "short" : "Forecast type of the vaccine.",
        "definition" : "Forecast type of the vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.tradeName",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.tradeName",
        "short" : "Trade name of the vaccine.",
        "definition" : "Trade name of the vaccine.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.preferableVaccine.mvx",
        "path" : "antigen-supporting-data.series.seriesDose.preferableVaccine.mvx",
        "short" : "Manufacturer's vaccine code.",
        "definition" : "Manufacturer's vaccine code.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.allowableVaccine",
        "path" : "antigen-supporting-data.series.seriesDose.allowableVaccine",
        "short" : "Allowable vaccines if preferable vaccines are not available.",
        "definition" : "Allowable vaccines if preferable vaccines are not available.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.allowableVaccine.vaccineType",
        "path" : "antigen-supporting-data.series.seriesDose.allowableVaccine.vaccineType",
        "short" : "Type of allowable vaccine.",
        "definition" : "Type of allowable vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.allowableVaccine.cvx",
        "path" : "antigen-supporting-data.series.seriesDose.allowableVaccine.cvx",
        "short" : "CVX code for allowable vaccine.",
        "definition" : "CVX code for allowable vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.allowableVaccine.beginAge",
        "path" : "antigen-supporting-data.series.seriesDose.allowableVaccine.beginAge",
        "short" : "Beginning age for allowable vaccine.",
        "definition" : "Beginning age for allowable vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.allowableVaccine.endAge",
        "path" : "antigen-supporting-data.series.seriesDose.allowableVaccine.endAge",
        "short" : "Ending age for allowable vaccine.",
        "definition" : "Ending age for allowable vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.seasonalRecommendation",
        "path" : "antigen-supporting-data.series.seriesDose.seasonalRecommendation",
        "short" : "Seasonal recommendation for the vaccine dose.",
        "definition" : "Seasonal recommendation for the vaccine dose.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.seasonalRecommendation.startDate",
        "path" : "antigen-supporting-data.series.seriesDose.seasonalRecommendation.startDate",
        "short" : "Start date for the seasonal recommendation.",
        "definition" : "Start date for the seasonal recommendation.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "antigen-supporting-data.series.seriesDose.seasonalRecommendation.endDate",
        "path" : "antigen-supporting-data.series.seriesDose.seasonalRecommendation.endDate",
        "short" : "End date for the seasonal recommendation.",
        "definition" : "End date for the seasonal recommendation.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      }
    ]
  }
}

```
