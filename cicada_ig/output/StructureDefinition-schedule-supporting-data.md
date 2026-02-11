# Schedule Supporting Data - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Schedule Supporting Data**

## Resource Profile: Schedule Supporting Data 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/schedule-supporting-data | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:ScheduleSupportingData |

 
This resource consolidates various mapping and conflict information related to vaccine scheduling to support decision-making processes. 

**Usages:**

* This Resource is not used by any profiles in this Implementation Guide

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/cicada.ig|current/StructureDefinition/schedule-supporting-data)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots and how the different presentations work](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](StructureDefinition-schedule-supporting-data.csv), [Excel](StructureDefinition-schedule-supporting-data.xlsx), [Schematron](StructureDefinition-schedule-supporting-data.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "schedule-supporting-data",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/schedule-supporting-data",
  "version" : "0.1.0",
  "name" : "ScheduleSupportingData",
  "title" : "Schedule Supporting Data",
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
  "description" : "This resource consolidates various mapping and conflict information related to vaccine scheduling to support decision-making processes.",
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
  "type" : "schedule-supporting-data",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Element",
  "derivation" : "specialization",
  "differential" : {
    "element" : [
      {
        "id" : "schedule-supporting-data",
        "path" : "schedule-supporting-data",
        "short" : "Schedule Supporting Data",
        "definition" : "This resource consolidates various mapping and conflict information related to vaccine scheduling to support decision-making processes."
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict",
        "path" : "schedule-supporting-data.liveVirusConflict",
        "short" : "Potential conflicts between live virus vaccines based on previous and current vaccinations and the required time intervals to avoid interference.",
        "definition" : "Potential conflicts between live virus vaccines based on previous and current vaccinations and the required time intervals to avoid interference.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.previous",
        "path" : "schedule-supporting-data.liveVirusConflict.previous",
        "short" : "Details about the previous vaccination.",
        "definition" : "Details about the previous vaccination.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.previous.vaccineType",
        "path" : "schedule-supporting-data.liveVirusConflict.previous.vaccineType",
        "short" : "Type of the previous vaccine.",
        "definition" : "Type of the previous vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.previous.cvx",
        "path" : "schedule-supporting-data.liveVirusConflict.previous.cvx",
        "short" : "CVX code for the previous vaccine.",
        "definition" : "CVX code for the previous vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.current",
        "path" : "schedule-supporting-data.liveVirusConflict.current",
        "short" : "Details about the current vaccination.",
        "definition" : "Details about the current vaccination.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.current.vaccineType",
        "path" : "schedule-supporting-data.liveVirusConflict.current.vaccineType",
        "short" : "Type of the current vaccine.",
        "definition" : "Type of the current vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.current.cvx",
        "path" : "schedule-supporting-data.liveVirusConflict.current.cvx",
        "short" : "CVX code for the current vaccine.",
        "definition" : "CVX code for the current vaccine.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.conflictBeginInterval",
        "path" : "schedule-supporting-data.liveVirusConflict.conflictBeginInterval",
        "short" : "Time interval before which a conflict begins after the previous vaccination.",
        "definition" : "Time interval before which a conflict begins after the previous vaccination.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.minConflictEndInterval",
        "path" : "schedule-supporting-data.liveVirusConflict.minConflictEndInterval",
        "short" : "Minimum time interval after which the conflict might end.",
        "definition" : "Minimum time interval after which the conflict might end.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.liveVirusConflict.conflictEndInterval",
        "path" : "schedule-supporting-data.liveVirusConflict.conflictEndInterval",
        "short" : "Time interval after which the conflict ends.",
        "definition" : "Time interval after which the conflict ends.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccineGroupMap",
        "path" : "schedule-supporting-data.vaccineGroupMap",
        "short" : "Mapping of vaccine groups to their specific attributes.",
        "definition" : "Mapping of vaccine groups to their specific attributes.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccineGroupMap.name",
        "path" : "schedule-supporting-data.vaccineGroupMap.name",
        "short" : "Name of the vaccine group.",
        "definition" : "Name of the vaccine group.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccineGroupMap.administerFullVaccineGroup",
        "path" : "schedule-supporting-data.vaccineGroupMap.administerFullVaccineGroup",
        "short" : "Flag to indicate if the full vaccine group should be administered.",
        "definition" : "Flag to indicate if the full vaccine group should be administered.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "boolean"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccineGroupToAntigenMap",
        "path" : "schedule-supporting-data.vaccineGroupToAntigenMap",
        "short" : "Mapping of vaccine groups to their associated antigens.",
        "definition" : "Mapping of vaccine groups to their associated antigens.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccineGroupToAntigenMap.name",
        "path" : "schedule-supporting-data.vaccineGroupToAntigenMap.name",
        "short" : "The name of the vaccine group.",
        "definition" : "The name of the vaccine group.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccineGroupToAntigenMap.antigen",
        "path" : "schedule-supporting-data.vaccineGroupToAntigenMap.antigen",
        "short" : "List of antigens associated with the vaccine group.",
        "definition" : "List of antigens associated with the vaccine group.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.cvxToAntigenMap",
        "path" : "schedule-supporting-data.cvxToAntigenMap",
        "short" : "Maps CVX Codes to Antigens and Ages.",
        "definition" : "Maps CVX Codes to Antigens and Ages.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.cvxToAntigenMap.cvx",
        "path" : "schedule-supporting-data.cvxToAntigenMap.cvx",
        "short" : "CVX Code",
        "definition" : "CVX Code",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.cvxToAntigenMap.shortDescription",
        "path" : "schedule-supporting-data.cvxToAntigenMap.shortDescription",
        "short" : "Short Description of this CVX",
        "definition" : "Short Description of this CVX",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.cvxToAntigenMap.association",
        "path" : "schedule-supporting-data.cvxToAntigenMap.association",
        "short" : "A list of associated antigens and ages.",
        "definition" : "A list of associated antigens and ages.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.cvxToAntigenMap.association.antigen",
        "path" : "schedule-supporting-data.cvxToAntigenMap.association.antigen",
        "short" : "Name of the antigen",
        "definition" : "Name of the antigen",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.cvxToAntigenMap.association.associationBeginAge",
        "path" : "schedule-supporting-data.cvxToAntigenMap.association.associationBeginAge",
        "short" : "Starting age, if applicable, when this antigen is associated with this CVX code",
        "definition" : "Starting age, if applicable, when this antigen is associated with this CVX code",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.cvxToAntigenMap.association.associationEndAge",
        "path" : "schedule-supporting-data.cvxToAntigenMap.association.associationEndAge",
        "short" : "Ending age, if applicable, when this antigen is associated with this CVX code",
        "definition" : "Ending age, if applicable, when this antigen is associated with this CVX code",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap",
        "path" : "schedule-supporting-data.vaccinationObservationMap",
        "short" : "Describes the observation rules for vaccination based on specific patient conditions.",
        "definition" : "Describes the observation rules for vaccination based on specific patient conditions.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.observationCode",
        "path" : "schedule-supporting-data.vaccinationObservationMap.observationCode",
        "short" : "Unique code for the observation.",
        "definition" : "Unique code for the observation.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.observationTitle",
        "path" : "schedule-supporting-data.vaccinationObservationMap.observationTitle",
        "short" : "Title of the observation.",
        "definition" : "Title of the observation.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.indicationText",
        "path" : "schedule-supporting-data.vaccinationObservationMap.indicationText",
        "short" : "Text indicating why the vaccine should be administered.",
        "definition" : "Text indicating why the vaccine should be administered.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.contraindicationText",
        "path" : "schedule-supporting-data.vaccinationObservationMap.contraindicationText",
        "short" : "Text indicating why the vaccine should not be administered.",
        "definition" : "Text indicating why the vaccine should not be administered.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.clarifyingText",
        "path" : "schedule-supporting-data.vaccinationObservationMap.clarifyingText",
        "short" : "Additional clarifications for the vaccination rule.",
        "definition" : "Additional clarifications for the vaccination rule.",
        "min" : 0,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.codedValues",
        "path" : "schedule-supporting-data.vaccinationObservationMap.codedValues",
        "short" : "List of associated SNOMED or other coded values relevant to the observation.",
        "definition" : "List of associated SNOMED or other coded values relevant to the observation.",
        "min" : 0,
        "max" : "*",
        "type" : [
          {
            "code" : "BackboneElement"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.codedValues.code",
        "path" : "schedule-supporting-data.vaccinationObservationMap.codedValues.code",
        "short" : "Code identifying the condition or observation.",
        "definition" : "Code identifying the condition or observation.",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.codedValues.codeSystem",
        "path" : "schedule-supporting-data.vaccinationObservationMap.codedValues.codeSystem",
        "short" : "The system in which the code is valid (e.g., SNOMED, CDCPHINVS).",
        "definition" : "The system in which the code is valid (e.g., SNOMED, CDCPHINVS).",
        "min" : 1,
        "max" : "1",
        "type" : [
          {
            "code" : "string"
          }
        ]
      },
      {
        "id" : "schedule-supporting-data.vaccinationObservationMap.codedValues.text",
        "path" : "schedule-supporting-data.vaccinationObservationMap.codedValues.text",
        "short" : "Human-readable name or description of the code.",
        "definition" : "Human-readable name or description of the code.",
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
