# Artifacts Summary - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Artifacts Summary**

## Artifacts Summary

This page provides a list of the FHIR artifacts defined as part of this implementation guide.

### Structures: Resource Profiles 

These define constraints on FHIR resources for systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [Allergy Intolerance Profile for Immunization Decision Support](StructureDefinition-ReactionProfile.md) | Profile for allergy intolerances relevant to immunization. The code (allergen/substance) may use SNOMED CT or ICD-10-CM. Reaction substances may use CVX, MVX, SNOMED CT, or RxNorm. |
| [Condition Profile with Vaccine Condition Codes](StructureDefinition-VaccineConditionFhir.md) | Profile for conditions where the code must be from the Vaccine Condition Codes value set. Accepts SNOMED CT and ICD-10-CM coded conditions. |
| [Dose of a Vaccine](StructureDefinition-vax-dose.md) | Detailed information about each vaccination dose. |
| [Immunization Procedures Profile](StructureDefinition-ProcedureProfile.md) | Profile for medical procedures related to immunization based on SNOMED CT or CPT codes. |
| [Medication Administration Profile with Vaccine Codes](StructureDefinition-MedicationAdministrationProfile.md) | Profile for medication administrations with vaccine codes from CVX or MVX. |
| [Medication Dispense Profile with Vaccine Codes](StructureDefinition-MedicationDispenseProfile.md) | Profile for medication dispenses with vaccine codes from CVX or MVX. |
| [Medication Request Profile with Vaccine Codes](StructureDefinition-MedicationRequestProfile.md) | Profile for medication requests with vaccine codes from CVX or MVX. |
| [Medication Statement Profile with Vaccine Codes](StructureDefinition-MedicationStatementProfile.md) | Profile for medication statements with vaccine codes from CVX or MVX. |
| [Observation Profile for Immunization Decision Support](StructureDefinition-VaccineObservationFhir.md) | Profile for Observation resources carrying lab evidence of immunity or other findings relevant to immunization decisions. Codes may be from SNOMED CT, ICD-10-CM, or LOINC. |
| [Vaccination Patient](StructureDefinition-vax-patient.md) | A profile that extends the base FHIR Patient resource to include detailed vaccination-related information. |
| [Vaccine](StructureDefinition-Vaccine.md) | Simple vaccine to easily obtain needed information for forecasting |

### Structures: Extension Definitions 

These define constraints on FHIR data types for systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [Allowed Interval Reason](StructureDefinition-allowed-interval-reason.md) | Captures the reason for the allowed interval between vaccine doses. |
| [Allowed Interval Status](StructureDefinition-allowed-interval-status.md) | Captures the status of the allowed interval for vaccination. |
| [Allowed Vaccine Reason](StructureDefinition-allowed-vaccine-reason.md) | Captures the reason why a particular vaccine is allowed. |
| [Allowed Vaccine Status](StructureDefinition-allowed-vaccine-status.md) | Indicates if the vaccine administered is allowed under certain conditions. |
| [AssessmentDate](StructureDefinition-assessment-date.md) | The date on which the vaccination assessment was made. |
| [Begin Age](StructureDefinition-begin-age.md) | The age at which the vaccine becomes applicable. |
| [End Age](StructureDefinition-end-age.md) | The age at which the vaccine is no longer applicable. |
| [Inadvertent Administration Status](StructureDefinition-inadvertent-administration-status.md) | Indicates if the vaccine was administered inadvertently. |
| [Preferred Interval Reason](StructureDefinition-preferred-interval-reason.md) | Captures the reason for the preferred interval between vaccine doses. |
| [Preferred Interval Status](StructureDefinition-preferred-interval-status.md) | Indicates if the vaccine was administered at the preferred interval. |
| [Preferred Vaccine Reason](StructureDefinition-preferred-vaccine-reason.md) | Captures the reason why a particular vaccine is preferred. |
| [Preferred Vaccine Status](StructureDefinition-preferred-vaccine-status.md) | Indicates if the vaccine administered is the preferred vaccine. |
| [Vaccination Conflict](StructureDefinition-vaccination-conflict.md) | Indicates any conflicts with other vaccinations. |
| [Vaccine Type](StructureDefinition-vaccine-type.md) | Type of the vaccine. |
| [Valid Age Reason](StructureDefinition-valid-age-reason.md) | Captures the reason why the vaccine was administered at a particular age. |
| [Valid Age Status](StructureDefinition-valid-age-status.md) | Indicates if the vaccine was administered at the correct age. |

### Terminology: Value Sets 

These define sets of codes used by systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [Evaluation Reason](ValueSet-eval-reason.md) | The reason for the evaluation. |
| [Evaluation Status Value Set](ValueSet-eval-status.md) | Value Set for the status of the result of an evaluation. |
| [Immunization-Relevant Medications (RxNorm)](ValueSet-vaccine-medication-codes-rxnorm.md) | RxNorm codes for medications relevant to immunization decision support, including antivirals and aspirin. |
| [Immunization-Relevant Procedures (CPT)](ValueSet-immunization-procedures-cpt.md) | CPT codes for procedures relevant to immunization decision support, including splenectomy and cochlear implant. |
| [Interval Reason](ValueSet-interval-reason.md) | This value set includes codes for the reason an interval is considered to be invalid. |
| [Lab Evidence of Immunity (LOINC)](ValueSet-vaccine-lab-evidence-of-immunity-loinc.md) | LOINC codes for laboratory tests that provide evidence of immunity, mapped to CDSi observation codes for immunization decision support. |
| [Medications](ValueSet-vaccine-medication-codes-snomed.md) | Value set for medications and substances based on SNOMED CT, including both active ingredients and marketed products. |
| [Procedures](ValueSet-procedures.md) | Comprehensive Value Set for medical procedures based on SNOMED CT codes. |
| [Reasons why certain doses are Preferred or Allowed doses](ValueSet-preferred-allowed-reason.md) | Reasons why certain doses are Preferred or Allowed doses |
| [Vaccine Condition Codes](ValueSet-vaccine-condition-codes-snomed.md) | Value set for conditions based on SNOMED CT, that may impact immunization. |
| [Vaccine Condition Codes (ICD-10-CM)](ValueSet-vaccine-condition-codes-icd10.md) | Value set for conditions based on ICD-10-CM that may impact immunization decisions, mapped to CDSi observation codes. |
| [Vaccine Gender](ValueSet-vaccine-gender.md) | Value set for gender categories relevant to vaccination data. |
| [VaccineCodesCvxMvx](ValueSet-VaccineCodesCvxMvx.md) |  |
| [Valid Age Reason](ValueSet-valid-age-reason.md) | Value set for reasons why a patient's age is considered valid/invalid for a vaccine. |

### Terminology: Code Systems 

These define new code systems used by systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [CDSI Observation Codes](CodeSystem-cdsi-observation-codes.md) | Observations and Conditions that are important to indications or contraindications in vaccine forecasting |
| [Evaluation Reason](CodeSystem-EvalReason.md) | The reason for the evaluation. |
| [Evaluation Status](CodeSystem-EvalStatus.md) | The status of the result of an evaluation. |
| [Interval Reason](CodeSystem-IntervalReason.md) | This value set includes codes for the reason an interval is considered to be invalid. |
| [Reasons why certain doses are Preferred or Allowed doses](CodeSystem-PreferredAllowedReason.md) | Reasons why certain doses are Preferred or Allowed doses |
| [Vaccine Gender](CodeSystem-VaccineGender.md) | Value set for gender categories relevant to vaccination data. |
| [Valid Age Reason](CodeSystem-ValidAgeReason.md) | Value set for reasons why a patient's age is considered valid/invalid for a vaccine. |

### Terminology: Structure Maps 

These define transformations to convert between data structures used by systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [MapVaccineCodes](StructureMap-MapVaccineCodes.md) | Define the usage of FHIR resource types with specific aliases |

### Terminology: Concept Maps 

These define transformations to convert between codes by systems conforming with this implementation guide.

| | |
| :--- | :--- |
| [ICD-10-CM to CDSi Observation Code Map](ConceptMap-Icd10ToCdsiObservation.md) | Maps ICD-10-CM diagnosis codes to CDSi observation codes used in immunization decision support. |
| [SNOMED CT to CDSi Observation Code Map](ConceptMap-SnomedToCdsiObservation.md) | Maps SNOMED CT codes to CDSi observation codes used in immunization decision support. |

### Other 

These are resources that are used within this implementation guide that do not fit into one of the other categories.

| | |
| :--- | :--- |
| [Antigen Supporting Data](StructureDefinition-antigen-supporting-data.md) | A resource to store supporting data for antigens including target disease, vaccine groups, immunity criteria, contraindications, and vaccination series. |
| [Schedule Supporting Data](StructureDefinition-schedule-supporting-data.md) | This resource consolidates various mapping and conflict information related to vaccine scheduling to support decision-making processes. |

