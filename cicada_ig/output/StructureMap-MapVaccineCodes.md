# MapVaccineCodes - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **MapVaccineCodes**

## StructureMap: MapVaccineCodes 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/StructureMap/map-vaccine-codes | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:MapVaccineCodes |

 
Define the usage of FHIR resource types with specific aliases 

```
/// url = "http://fhirfli.dev/fhir/ig/cicada/StructureMap/map-vaccine-codes"
/// name = "MapVaccineCodes"
/// title = "null"
/// status = "draft"

// Define the usage of FHIR resource types with specific aliases

uses "http://hl7.org/fhir/StructureDefinition/Observation" alias sourceObservation as source
uses "http://hl7.org/fhir/StructureDefinition/Condition" alias sourceCondition as source
uses "http://hl7.org/fhir/StructureDefinition/Procedure" alias sourceProcedure as source
uses "http://hl7.org/fhir/StructureDefinition/Immunization" alias sourceImmunization as source
uses "http://hl7.org/fhir/StructureDefinition/Medication" alias sourceMedication as source
uses "http://hl7.org/fhir/StructureDefinition/MedicationStatement" alias sourceMedicationStatement as source
uses "http://hl7.org/fhir/StructureDefinition/MedicationRequest" alias sourceMedicationRequest as source
uses "http://hl7.org/fhir/StructureDefinition/MedicationAdministration" alias sourceMedicationAdministration as source
uses "http://hl7.org/fhir/StructureDefinition/MedicationDispense" alias sourceMedicationDispense as source
uses "http://hl7.org/fhir/StructureDefinition/Condition" alias targetCondition as target

group MapToVaccineConditionObservation(source src : any, target tgt : targetCondition) {
  src as sourceObservation where (src is Observation) -> tgt then MapFromObservation(src, tgt) "SourceObservationToTarget";
  src as sourceCondition where (src is Condition) -> tgt then MapFromCondition(src, tgt) "SourceConditionToTarget";
  src as sourceProcedure where (src is Procedure) -> tgt then MapFromProcedure(src, tgt) "SourceProcedureToTarget";
  src as sourceImmunization where (src is Immunization) -> tgt then MapFromImmunization(src, tgt) "SourceImmunizationToTarget";
  src as sourceMedication where (src is Medication) -> tgt then MapFromMedication(src, tgt) "SourceMedicationToTarget";
  src as sourceMedicationStatement where (src is MedicationStatement) -> tgt then MapFromMedicationStatement(src, tgt) "SourceMedStatementToTarget";
  src as sourceMedicationRequest where (src is MedicationRequest) -> tgt then MapFromMedicationRequest(src, tgt) "SourceMedRequestToTarget";
  src as sourceMedicationAdministration where (src is MedicationAdministration) -> tgt then MapFromMedicationAdministration(src, tgt) "SourceMedAdminToTarget";
  src as sourceMedicationDispense where (src is MedicationDispense) -> tgt then MapFromMedicationDispense(src, tgt) "SourceMedDispenseToTarget";
}

group MapFromObservation(source src : sourceObservation, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetObservationStatus";
  src.code as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyObsMappings";
  src -> tgt.onsetDateTime = src.effectiveDateTime "SetObsOnsetDateTime";
  src -> tgt.onsetPeriod = src.effectivePeriod "SetObsOnsetPeriod";
  src -> tgt.onsetDateTime = src.effectiveInstant "SetObsOnsetInstant";
}

group MapFromCondition(source src : sourceCondition, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetConditionStatus";
  src.code as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyCondMappings";
  src -> tgt.onsetDateTime = src.onsetDateTime "SetCondOnsetDateTime";
  src -> tgt.onsetAge = src.onsetAge "SetCondOnsetAge";
  src -> tgt.onsetPeriod = src.onsetPeriod "SetCondOnsetPeriod";
  src -> tgt.onsetRange = src.onsetRange "SetCondOnsetRange";
  src -> tgt.onsetString = src.onsetString "SetCondOnsetString";
  src -> tgt.abatementDateTime = src.abatementDateTime "SetCondAbatementDateTime";
  src -> tgt.abatementAge = src.abatementAge "SetCondAbatementAge";
  src -> tgt.abatementPeriod = src.abatementPeriod "SetCondAbatementPeriod";
  src -> tgt.abatementRange = src.abatementRange "SetCondAbatementRange";
  src -> tgt.abatementString = src.abatementString "SetCondAbatementString";
}

group MapFromProcedure(source src : sourceProcedure, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetProcedureStatus";
  src.code as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyProcedureMappings";
  src -> tgt.onsetDateTime = src.performedDateTime "SetProcedureOnsetDateTime";
  src -> tgt.onsetAge = src.performedAge "SetProcedureOnsetAge";
  src -> tgt.onsetPeriod = src.performedPeriod "SetProcedureOnsetPeriod";
  src -> tgt.onsetRange = src.performedRange "SetProcedureOnsetRange";
  src -> tgt.onsetString = src.performedString "SetProcedureOnsetString";
}

group MapFromImmunization(source src : sourceImmunization, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetImmunizationStatus";
  src.vaccineCode as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyImmunizationMappings";
  src -> tgt.onsetDateTime = src.occurrenceDateTime "SetImmunizationOnsetDateTime";
  src -> tgt.onsetString = src.occurrenceString "SetImmunizationOnsetString";
}

group MapFromMedication(source src : sourceMedication, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetMedicationStatus";
  src.code as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedicationMappings";
}

// TODO(Dokotela): what about medicationReference?
group MapFromMedicationStatement(source src : sourceMedicationStatement, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetMedStatementStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedStatementMappings";
}

group MapFromMedicationRequest(source src : sourceMedicationRequest, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetMedRequestStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedRequestMappings";
  src -> tgt.onsetDateTime = src.authoredOn "SetMedRequestOnsetDateTime";
}

group MapFromMedicationAdministration(source src : sourceMedicationAdministration, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetMedAdminStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedAdminMappings";
  src -> tgt.onsetDateTime = src.effectiveDateTime "SetMedAdminOnsetDateTime";
  src -> tgt.onsetPeriod = src.effectivePeriod "SetMedAdminOnsetPeriod";
}

group MapFromMedicationDispense(source src : sourceMedicationDispense, target tgt : targetCondition) {
  src -> tgt.status = 'active' "SetMedDispenseStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedDispenseMappings";
  src -> tgt.onsetDateTime = src.whenHandedOver "SetMedDispenseOnsetDateTime";
}

group ApplyCommonMappings(source src : Coding, target tgt : targetCondition) {
  src.system as systemValue where systemValue = 'http://snomed.info/sct' -> tgt.code = create('CodeableConcept') as newCC then {
    src -> newCC.coding = create('Coding') as newCoding then {
      src.code as codeValue where codeValue = '370388006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '003',  newCoding.display = 'Patient Immunocompromised' "SetSNOMEDCode370388006";
      src.code as codeValue where codeValue = '234336002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '004',  newCoding.display = 'Hemopoietic stem cell transplant [procedure]' "SetSNOMEDCode234336002";
      src.code as codeValue where codeValue = '50711007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '005',  newCoding.display = 'Viral hepatitis type C [disorder]' "SetSNOMEDCode50711007";
      src.code as codeValue where codeValue = '77386006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '007',  newCoding.display = 'Patient currently pregnant [finding]' "SetSNOMEDCode77386006";
      src.code as codeValue where codeValue = '102874004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '007',  newCoding.display = 'Possible pregnancy [finding]' "SetSNOMEDCode102874004";
      src.code as codeValue where codeValue = '255409004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '007',  newCoding.display = 'Pregnant woman [person]' "SetSNOMEDCode255409004";
      src.code as codeValue where codeValue = '413712001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '009',  newCoding.display = 'Breastfeeding [mother] [observable entity]' "SetSNOMEDCode413712001";
      src.code as codeValue where codeValue = '230744007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '010',  newCoding.display = 'Cerebrospinal fluid leak [disorder]' "SetSNOMEDCode230744007";
      src.code as codeValue where codeValue = '449840001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '011',  newCoding.display = 'Cochlear prosthesis in situ [finding]' "SetSNOMEDCode449840001";
      src.code as codeValue where codeValue = '43252007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '011',  newCoding.display = 'Cochlear prosthesis, device [physical object]' "SetSNOMEDCode43252007";
      src.code as codeValue where codeValue = '359612003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '011',  newCoding.display = 'Implantation of cochlear prosthetic device [procedure]' "SetSNOMEDCode359612003";
      src.code as codeValue where codeValue = '31323000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '013',  newCoding.display = 'Severe combined immunodeficiency disease [disorder]' "SetSNOMEDCode31323000";
      src.code as codeValue where codeValue = '73211009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '014',  newCoding.display = 'Diabetes mellitus [disorder]' "SetSNOMEDCode73211009";
      src.code as codeValue where codeValue = '328383001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '015',  newCoding.display = 'Chronic liver disease [disorder]' "SetSNOMEDCode328383001";
      src.code as codeValue where codeValue = '19943007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '015',  newCoding.display = 'Cirrhosis of liver [disorder]' "SetSNOMEDCode19943007";
      src.code as codeValue where codeValue = '128238001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '016',  newCoding.display = 'Chronic heart disease [disorder]' "SetSNOMEDCode128238001";
      src.code as codeValue where codeValue = '42343007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '016',  newCoding.display = 'Congestive heart failure [disorder]' "SetSNOMEDCode42343007";
      src.code as codeValue where codeValue = '57809008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '016',  newCoding.display = 'Myocardial disease [disorder]' "SetSNOMEDCode57809008";
      src.code as codeValue where codeValue = '12770006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '016',  newCoding.display = 'Cyanotic congenital heart disease [disorder]' "SetSNOMEDCode12770006";
      src.code as codeValue where codeValue = '413839001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '017',  newCoding.display = 'Chronic lung disease [disorder]' "SetSNOMEDCode413839001";
      src.code as codeValue where codeValue = '13645005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '017',  newCoding.display = 'Chronic obstructive lung disease [disorder]' "SetSNOMEDCode13645005";
      src.code as codeValue where codeValue = '87433001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '017',  newCoding.display = 'Pulmonary emphysema [disorder]' "SetSNOMEDCode87433001";
      src.code as codeValue where codeValue = '278971009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '018',  newCoding.display = 'Hepatitis A Immune [Finding]' "SetSNOMEDCode278971009";
      src.code as codeValue where codeValue = '271511000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '019',  newCoding.display = 'Hepatitis B Immune [Finding]' "SetSNOMEDCode271511000";
      src.code as codeValue where codeValue = '371111005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '020',  newCoding.display = 'Measles Immune [finding]' "SetSNOMEDCode371111005";
      src.code as codeValue where codeValue = '371112003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '021',  newCoding.display = 'Mumps Immune [finding]' "SetSNOMEDCode371112003";
      src.code as codeValue where codeValue = '278968001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '022',  newCoding.display = 'Rubella Immune [finding]' "SetSNOMEDCode278968001";
      src.code as codeValue where codeValue = '371113008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '023',  newCoding.display = 'Varicella Immune' "SetSNOMEDCode371113008";
      src.code as codeValue where codeValue = '38907003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '024',  newCoding.display = 'Varicella [Disorder]' "SetSNOMEDCode38907003";
      src.code as codeValue where codeValue = '4740000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '025',  newCoding.display = 'Herpes Zoster [Disorder]' "SetSNOMEDCode4740000";
      src.code as codeValue where codeValue = '86406008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '026',  newCoding.display = 'Human immunodeficiency virus infection [disorder]' "SetSNOMEDCode86406008";
      src.code as codeValue where codeValue = '427314002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '026',  newCoding.display = 'Antiviral therapy [procedure]' "SetSNOMEDCode427314002";
      src.code as codeValue where codeValue = '390798007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '027',  newCoding.display = 'Asthma finding [finding]' "SetSNOMEDCode390798007";
      src.code as codeValue where codeValue = '195967001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '027',  newCoding.display = 'Asthma [disorder]' "SetSNOMEDCode195967001";
      src.code as codeValue where codeValue = '35327006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '028',  newCoding.display = 'Intussusception [morphologic abnormality]' "SetSNOMEDCode35327006";
      src.code as codeValue where codeValue = '49723003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '028',  newCoding.display = 'Intussusception of intestine [disorder]' "SetSNOMEDCode49723003";
      src.code as codeValue where codeValue = '69776003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '029',  newCoding.display = 'Acute gastroenteritis [disorder]' "SetSNOMEDCode69776003";
      src.code as codeValue where codeValue = '56717001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '031',  newCoding.display = 'Tuberculosis [disorder]' "SetSNOMEDCode56717001";
      src.code as codeValue where codeValue = '372763006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Amantadine [substance]' "SetSNOMEDCode372763006";
      src.code as codeValue where codeValue = '51361008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Amantadine [product]' "SetSNOMEDCode51361008";
      src.code as codeValue where codeValue = '372532009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Rimantadine [substance]' "SetSNOMEDCode372532009";
      src.code as codeValue where codeValue = '108712009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Rimantadine [product]' "SetSNOMEDCode108712009";
      src.code as codeValue where codeValue = '387010007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Zanamivir [substance]' "SetSNOMEDCode387010007";
      src.code as codeValue where codeValue = '116100000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Zanamivir [product]' "SetSNOMEDCode116100000";
      src.code as codeValue where codeValue = '412261005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Oseltamivir [substance]' "SetSNOMEDCode412261005";
      src.code as codeValue where codeValue = '386142008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '033',  newCoding.display = 'Oseltamivir [product]' "SetSNOMEDCode386142008";
      src.code as codeValue where codeValue = '405742008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '034',  newCoding.display = 'Aspirin therapy finding [finding]' "SetSNOMEDCode405742008";
      src.code as codeValue where codeValue = '76102007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '036',  newCoding.display = 'Male homosexual [finding]' "SetSNOMEDCode76102007";
      src.code as codeValue where codeValue = '225531006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '036',  newCoding.display = 'Homosexual behavior [finding]' "SetSNOMEDCode225531006";
      src.code as codeValue where codeValue = '225516002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '037',  newCoding.display = 'Multiple sexual contacts [finding]' "SetSNOMEDCode225516002";
      src.code as codeValue where codeValue = '228460004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '037',  newCoding.display = 'Multiple current sexual partners [finding]' "SetSNOMEDCode228460004";
      src.code as codeValue where codeValue = '228466005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '037',  newCoding.display = 'Commitment to sexual relationship [observable entity]' "SetSNOMEDCode228466005";
      src.code as codeValue where codeValue = '225517006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '038',  newCoding.display = 'Sexual partners [observable entity]' "SetSNOMEDCode225517006";
      src.code as codeValue where codeValue = '11723008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '038',  newCoding.display = 'Contact with [contextual qualifier] [qualifier value]' "SetSNOMEDCode11723008";
      src.code as codeValue where codeValue = '165806002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '038',  newCoding.display = 'Hepatitis B surface antigen positive [finding]' "SetSNOMEDCode165806002";
      src.code as codeValue where codeValue = '305489005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '039',  newCoding.display = 'Under care of genitourinary medicine physician [finding]' "SetSNOMEDCode305489005";
      src.code as codeValue where codeValue = '305679000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '039',  newCoding.display = 'Seen by genitourinary medicine physician [finding]' "SetSNOMEDCode305679000";
      src.code as codeValue where codeValue = '8098009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '039',  newCoding.display = 'Sexually transmitted infectious disease [disorder]' "SetSNOMEDCode8098009";
      src.code as codeValue where codeValue = '307052004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '040',  newCoding.display = 'Illicit drug use [finding]' "SetSNOMEDCode307052004";
      src.code as codeValue where codeValue = '228366006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '040',  newCoding.display = 'Finding relating to drug misuse behavior [finding]' "SetSNOMEDCode228366006";
      src.code as codeValue where codeValue = '226034001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '041',  newCoding.display = 'Injecting drug user [finding]' "SetSNOMEDCode226034001";
      src.code as codeValue where codeValue = '228388006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '041',  newCoding.display = 'Intravenous drug user  [finding]' "SetSNOMEDCode228388006";
      src.code as codeValue where codeValue = '145101000119102' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '041',  newCoding.display = 'Intravenous cocaine abuse [disorder]' "SetSNOMEDCode145101000119102";
      src.code as codeValue where codeValue = '403746009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '041',  newCoding.display = 'Skin lesion due to intravenous drug abuse [disorder]' "SetSNOMEDCode403746009";
      src.code as codeValue where codeValue = '860699005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '041',  newCoding.display = 'Deep vein thrombosis of lower extremity due to intravenous drug use [disorder]' "SetSNOMEDCode860699005";
      src.code as codeValue where codeValue = '77176002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '042',  newCoding.display = 'Smoker [finding]' "SetSNOMEDCode77176002";
      src.code as codeValue where codeValue = '228281002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '043',  newCoding.display = 'Problem drinker [finding]' "SetSNOMEDCode228281002";
      src.code as codeValue where codeValue = '7200002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '043',  newCoding.display = 'Alcoholism [disorder]' "SetSNOMEDCode7200002";
      src.code as codeValue where codeValue = '159138004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '050',  newCoding.display = 'Microbiologist [occupation]' "SetSNOMEDCode159138004";
      src.code as codeValue where codeValue = '14698002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '050',  newCoding.display = 'Medical microbiologist [occupation]' "SetSNOMEDCode14698002";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '050',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '17872004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '050',  newCoding.display = 'Neisseria meningitidis [organism]' "SetSNOMEDCode17872004";
      src.code as codeValue where codeValue = '159138004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '051',  newCoding.display = 'Microbiologist [occupation]' "SetSNOMEDCode159138004";
      src.code as codeValue where codeValue = '14698002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '051',  newCoding.display = 'Medical microbiologist [occupation]' "SetSNOMEDCode14698002";
      src.code as codeValue where codeValue = '159282002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '051',  newCoding.display = 'Laboratory technician [occupation]' "SetSNOMEDCode159282002";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '051',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '5595000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '051',  newCoding.display = 'Salmonella Typhi [organism]' "SetSNOMEDCode5595000";
      src.code as codeValue where codeValue = '159282002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '052',  newCoding.display = 'Laboratory technician [occupation]' "SetSNOMEDCode159282002";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '052',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '26630006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '052',  newCoding.display = 'Yellow fever virus [organism]' "SetSNOMEDCode26630006";
      src.code as codeValue where codeValue = '159282002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '053',  newCoding.display = 'Laboratory technician [occupation]' "SetSNOMEDCode159282002";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '053',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '59881000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '053',  newCoding.display = 'Rabies virus [organism]' "SetSNOMEDCode59881000";
      src.code as codeValue where codeValue = '159282002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '054',  newCoding.display = 'Laboratory technician [occupation]' "SetSNOMEDCode159282002";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '054',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '44172002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '054',  newCoding.display = 'Human poliovirus [organism]' "SetSNOMEDCode44172002";
      src.code as codeValue where codeValue = '223366009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '055',  newCoding.display = 'Healthcare professional [occupation]' "SetSNOMEDCode223366009";
      src.code as codeValue where codeValue = '223366009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '056',  newCoding.display = 'Healthcare professional [occupation]' "SetSNOMEDCode223366009";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '056',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '44172002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '056',  newCoding.display = 'Human poliovirus [organism]' "SetSNOMEDCode44172002";
      src.code as codeValue where codeValue = '26369006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Public health nurse [occupation]' "SetSNOMEDCode26369006";
      src.code as codeValue where codeValue = '68867008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Public health dentist [occupation]' "SetSNOMEDCode68867008";
      src.code as codeValue where codeValue = '307969004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Public health officer [occupation]' "SetSNOMEDCode307969004";
      src.code as codeValue where codeValue = '56466003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Public health physician [occupation]' "SetSNOMEDCode56466003";
      src.code as codeValue where codeValue = '56079002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Public health veterinarian [occupation]' "SetSNOMEDCode56079002";
      src.code as codeValue where codeValue = '60008001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Public health nutritionist [occupation]' "SetSNOMEDCode60008001";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '87612001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Blood [substance]' "SetSNOMEDCode87612001";
      src.code as codeValue where codeValue = '32457005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '057',  newCoding.display = 'Body fluid [substance]' "SetSNOMEDCode32457005";
      src.code as codeValue where codeValue = '223366009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Healthcare professional [occupation]' "SetSNOMEDCode223366009";
      src.code as codeValue where codeValue = '158942005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Residential child care worker [occupation]' "SetSNOMEDCode158942005";
      src.code as codeValue where codeValue = '158939004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Child care officer [occupation]' "SetSNOMEDCode158939004";
      src.code as codeValue where codeValue = '73851001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Plumber [general] [occupation]' "SetSNOMEDCode73851001";
      src.code as codeValue where codeValue = '160157004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Sewerman [occupation]' "SetSNOMEDCode160157004";
      src.code as codeValue where codeValue = '266006009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Food/drink processor [occupation]' "SetSNOMEDCode266006009";
      src.code as codeValue where codeValue = '274272004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Catering services occupation [occupation]' "SetSNOMEDCode274272004";
      src.code as codeValue where codeValue = '160133004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '059',  newCoding.display = 'Packer - food/garden produce [occupation]' "SetSNOMEDCode160133004";
      src.code as codeValue where codeValue = '265940000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '060',  newCoding.display = 'Animal health occupation [occupation]' "SetSNOMEDCode265940000";
      src.code as codeValue where codeValue = '159091009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '061',  newCoding.display = 'Trainer - performing animals [occupation]' "SetSNOMEDCode159091009";
      src.code as codeValue where codeValue = '24932003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '062',  newCoding.display = 'Exposure to [contextual qualifier] [qualifier value]' "SetSNOMEDCode24932003";
      src.code as codeValue where codeValue = '59881000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '062',  newCoding.display = 'Rabies virus [organism]' "SetSNOMEDCode59881000";
      src.code as codeValue where codeValue = '65853000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '063',  newCoding.display = 'Student [occupation]' "SetSNOMEDCode65853000";
      src.code as codeValue where codeValue = '257561002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '063',  newCoding.display = 'Further education establishment [environment]' "SetSNOMEDCode257561002";
      src.code as codeValue where codeValue = '90688005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '066',  newCoding.display = 'Chronic renal failure syndrome [disorder]' "SetSNOMEDCode90688005";
      src.code as codeValue where codeValue = '20078004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '068',  newCoding.display = 'Substance abuse treatment center [environment]' "SetSNOMEDCode20078004";
      src.code as codeValue where codeValue = '257656006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '069',  newCoding.display = 'Penal institution [environment]' "SetSNOMEDCode257656006";
      src.code as codeValue where codeValue = '410519009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '070',  newCoding.display = 'At risk context [qualifier value]' "SetSNOMEDCode410519009";
      src.code as codeValue where codeValue = '443684005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '070',  newCoding.display = 'Disease outbreak [event]' "SetSNOMEDCode443684005";
      src.code as codeValue where codeValue = '11723008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '071',  newCoding.display = 'Contact with [contextual qualifier] [qualifier value]' "SetSNOMEDCode11723008";
      src.code as codeValue where codeValue = '165806002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '071',  newCoding.display = 'Hepatitis B surface antigen positive [finding]' "SetSNOMEDCode165806002";
      src.code as codeValue where codeValue = '170484009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '072',  newCoding.display = 'Typhoid carrier [finding]' "SetSNOMEDCode170484009";
      src.code as codeValue where codeValue = '12271241000119109' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '075',  newCoding.display = 'Transgender identify [finding]' "SetSNOMEDCode12271241000119109";
      src.code as codeValue where codeValue = '84757009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '076',  newCoding.display = 'Epilepsy [disorder]' "SetSNOMEDCode84757009";
      src.code as codeValue where codeValue = '192711008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '079',  newCoding.display = 'Post diphtheria vaccination encephalitis [disorder]' "SetSNOMEDCode192711008";
      src.code as codeValue where codeValue = '192710009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '079',  newCoding.display = 'Post tetanus vaccination encephalitis [disorder]' "SetSNOMEDCode192710009";
      src.code as codeValue where codeValue = '192712001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '079',  newCoding.display = 'Post pertussis vaccination encephalitis [disorder]' "SetSNOMEDCode192712001";
      src.code as codeValue where codeValue = '293104008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '080',  newCoding.display = 'Vaccines adverse reaction [disorder]' "SetSNOMEDCode293104008";
      src.code as codeValue where codeValue = '293117006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'Poliomyelitis vaccine adverse reaction [disorder]' "SetSNOMEDCode293117006";
      src.code as codeValue where codeValue = '451301000124103' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '082',  newCoding.display = 'Adverse reaction caused by Japanese encephalitis virus vaccine [disorder]' "SetSNOMEDCode451301000124103";
      src.code as codeValue where codeValue = '429301000124101' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '083',  newCoding.display = 'Adverse reaction to rotavirus vaccine [disorder]' "SetSNOMEDCode429301000124101";
      src.code as codeValue where codeValue = '293122006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '084',  newCoding.display = 'Typhoid vaccine adverse reaction [disorder]' "SetSNOMEDCode293122006";
      src.code as codeValue where codeValue = '420113004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza virus vaccine adverse reaction [disorder]' "SetSNOMEDCode420113004";
      src.code as codeValue where codeValue = '293115003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'Pertussis vaccine adverse reaction [disorder]' "SetSNOMEDCode293115003";
      src.code as codeValue where codeValue = '219085007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'Adverse reaction to diphtheria vaccine [disorder]' "SetSNOMEDCode219085007";
      src.code as codeValue where codeValue = '219084006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'Adverse reaction to tetanus vaccine [disorder]' "SetSNOMEDCode219084006";
      src.code as codeValue where codeValue = '451331000124106' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '089',  newCoding.display = 'Adverse reaction caused by varicella virus live vaccine [disorder]' "SetSNOMEDCode451331000124106";
      src.code as codeValue where codeValue = '429311000124103' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '090',  newCoding.display = 'Adverse reaction to human papillomavirus vaccine [disorder]' "SetSNOMEDCode429311000124103";
      src.code as codeValue where codeValue = '219096004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '091',  newCoding.display = 'Adverse reaction to measles vaccine [disorder]' "SetSNOMEDCode219096004";
      src.code as codeValue where codeValue = '293114004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '092',  newCoding.display = 'Mumps vaccine adverse reaction [disorder]' "SetSNOMEDCode293114004";
      src.code as codeValue where codeValue = '293119009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '093',  newCoding.display = 'Rubella vaccine adverse reaction [disorder]' "SetSNOMEDCode293119009";
      src.code as codeValue where codeValue = '293116002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '094',  newCoding.display = 'Pneumococcal vaccine adverse reaction [disorder]' "SetSNOMEDCode293116002";
      src.code as codeValue where codeValue = '2219088009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Adverse reaction to meningococcal vaccine [disorder]' "SetSNOMEDCode2219088009";
      src.code as codeValue where codeValue = '451111000124103' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Adverse reaction caused by meningococcal conjugate vaccine [disorder]' "SetSNOMEDCode451111000124103";
      src.code as codeValue where codeValue = '293126009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '096',  newCoding.display = 'Hepatitis A vaccine adverse reaction [disorder]' "SetSNOMEDCode293126009";
      src.code as codeValue where codeValue = '293110008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Hepatitis B vaccine adverse reaction [disorder]' "SetSNOMEDCode293110008";
      src.code as codeValue where codeValue = '293127000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'Haemophilus influenzae Type B vaccine adverse reaction [disorder]' "SetSNOMEDCode293127000";
      src.code as codeValue where codeValue = '219095000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '099',  newCoding.display = 'Adverse reaction to yellow fever vaccine [disorder]' "SetSNOMEDCode219095000";
      src.code as codeValue where codeValue = '451291000124104' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '100',  newCoding.display = 'Adverse reaction caused by zoster vaccine [disorder]' "SetSNOMEDCode451291000124104";
      src.code as codeValue where codeValue = '213020009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '101',  newCoding.display = 'Egg protein allergy [disorder]' "SetSNOMEDCode213020009";
      src.code as codeValue where codeValue = '91930004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '101',  newCoding.display = 'Allergy to eggs [disorder]' "SetSNOMEDCode91930004";
      src.code as codeValue where codeValue = '293309006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '102',  newCoding.display = 'Gelatin adverse reaction [disorder]' "SetSNOMEDCode293309006";
      src.code as codeValue where codeValue = '294847001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '102',  newCoding.display = 'Gelatin allergy [disorder]' "SetSNOMEDCode294847001";
      src.code as codeValue where codeValue = '300916003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '104',  newCoding.display = 'Latex allergy [disorder]' "SetSNOMEDCode300916003";
      src.code as codeValue where codeValue = '441593005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '104',  newCoding.display = 'Anaphylaxis due to latex [disorder]' "SetSNOMEDCode441593005";
      src.code as codeValue where codeValue = '419522004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '106',  newCoding.display = 'Gentamycin sensitivity [disorder]' "SetSNOMEDCode419522004";
      src.code as codeValue where codeValue = '420094007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '106',  newCoding.display = 'Gentamicin adverse reaction [disorder]' "SetSNOMEDCode420094007";
      src.code as codeValue where codeValue = '294469003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '106',  newCoding.display = 'Gentamicin allergy [disorder]' "SetSNOMEDCode294469003";
      src.code as codeValue where codeValue = '294468006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '107',  newCoding.display = 'Neomycin allergy [disorder]' "SetSNOMEDCode294468006";
      src.code as codeValue where codeValue = '292927007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '107',  newCoding.display = 'Neomycin adverse reaction [disorder]' "SetSNOMEDCode292927007";
      src.code as codeValue where codeValue = '294466005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '108',  newCoding.display = 'Streptomycin allergy [disorder]' "SetSNOMEDCode294466005";
      src.code as codeValue where codeValue = '292925004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '108',  newCoding.display = 'Streptomycin adverse reaction [disorder]' "SetSNOMEDCode292925004";
      src.code as codeValue where codeValue = '294530006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '109',  newCoding.display = 'Polymyxin B allergy [disorder]' "SetSNOMEDCode294530006";
      src.code as codeValue where codeValue = '292992006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '109',  newCoding.display = 'Polymyxin B adverse reaction [disorder]' "SetSNOMEDCode292992006";
      src.code as codeValue where codeValue = '703936006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '110',  newCoding.display = 'Allergy to yeast [disorder]' "SetSNOMEDCode703936006";
      src.code as codeValue where codeValue = '293118001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '113',  newCoding.display = 'Rabies vaccine adverse reaction [disorder]' "SetSNOMEDCode293118001";
      src.code as codeValue where codeValue = '46177005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '114',  newCoding.display = 'End stage renal disease [disorder]' "SetSNOMEDCode46177005";
      src.code as codeValue where codeValue = '64520006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '115',  newCoding.display = 'Protamine sulfate [substance]' "SetSNOMEDCode64520006";
      src.code as codeValue where codeValue = '294278007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '115',  newCoding.display = 'Protamine allergy [disorder]' "SetSNOMEDCode294278007";
      src.code as codeValue where codeValue = '451281000124102' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '116',  newCoding.display = 'Adverse reaction caused by meningococcal group B vaccine [disorder]' "SetSNOMEDCode451281000124102";
      src.code as codeValue where codeValue = '219082005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '119',  newCoding.display = 'Adverse reaction caused by cholera vaccine [disorder]' "SetSNOMEDCode219082005";
      src.code as codeValue where codeValue = '32911000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '121',  newCoding.display = 'Homeless [finding]' "SetSNOMEDCode32911000";
      src.code as codeValue where codeValue = '116859006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '132',  newCoding.display = 'Transfusion of blood product [procedure]' "SetSNOMEDCode116859006";
      src.code as codeValue where codeValue = '116859006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '133',  newCoding.display = 'Transfusion of blood product [procedure]' "SetSNOMEDCode116859006";
      src.code as codeValue where codeValue = '116859006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '134',  newCoding.display = 'Transfusion of blood product [procedure]' "SetSNOMEDCode116859006";
      src.code as codeValue where codeValue = '13569004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '135',  newCoding.display = 'Transfusion of plasma [procedure]' "SetSNOMEDCode13569004";
      src.code as codeValue where codeValue = '12719002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '135',  newCoding.display = 'Platelet transfusion [procedure]' "SetSNOMEDCode12719002";
      src.code as codeValue where codeValue = '65880007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '145',  newCoding.display = 'X-linked agammaglobulinemia [disorder]' "SetSNOMEDCode65880007";
      src.code as codeValue where codeValue = '23238000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '145',  newCoding.display = 'Common variable agammaglobulinemia [disorder]' "SetSNOMEDCode23238000";
      src.code as codeValue where codeValue = '190979003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '146',  newCoding.display = 'Selective immunoglobulin A deficiency [disorder]' "SetSNOMEDCode190979003";
      src.code as codeValue where codeValue = '123785006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '146',  newCoding.display = 'Immunoglobulin G subclass deficiency [finding]' "SetSNOMEDCode123785006";
      src.code as codeValue where codeValue = '31323000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '147',  newCoding.display = 'Severe combined immunodeficiency disease [disorder]' "SetSNOMEDCode31323000";
      src.code as codeValue where codeValue = '77128003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '147',  newCoding.display = 'DiGeorge sequence [disorder]' "SetSNOMEDCode77128003";
      src.code as codeValue where codeValue = '77128003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '148',  newCoding.display = 'DiGeorge sequence [disorder]' "SetSNOMEDCode77128003";
      src.code as codeValue where codeValue = '36070007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '148',  newCoding.display = 'Wiskott-Aldrich syndrome [disorder]' "SetSNOMEDCode36070007";
      src.code as codeValue where codeValue = '68504005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '148',  newCoding.display = 'Ataxia-telangiectasia syndrome [disorder]' "SetSNOMEDCode68504005";
      src.code as codeValue where codeValue = '24743004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '150',  newCoding.display = 'Complement deficiency disease [disorder]' "SetSNOMEDCode24743004";
      src.code as codeValue where codeValue = '24743004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '151',  newCoding.display = 'Complement deficiency disease [disorder]' "SetSNOMEDCode24743004";
      src.code as codeValue where codeValue = '81166004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '151',  newCoding.display = 'Properdin deficiency disease [disorder]' "SetSNOMEDCode81166004";
      src.code as codeValue where codeValue = '234605000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '151',  newCoding.display = 'Factor B deficiency [disorder]' "SetSNOMEDCode234605000";
      src.code as codeValue where codeValue = '387759001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '152',  newCoding.display = 'Chronic granulomatous disease [disorder]' "SetSNOMEDCode387759001";
      src.code as codeValue where codeValue = '77358003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '153',  newCoding.display = 'Congenital leukocyte adherence deficiency [disorder]' "SetSNOMEDCode77358003";
      src.code as codeValue where codeValue = '234433009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '153',  newCoding.display = 'Myeloperoxidase deficiency [disorder]' "SetSNOMEDCode234433009";
      src.code as codeValue where codeValue = '62479008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '154',  newCoding.display = 'Acquired immune deficiency syndrome [disorder]' "SetSNOMEDCode62479008";
      src.code as codeValue where codeValue = '62479008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '155',  newCoding.display = 'Acquired immune deficiency syndrome [disorder]' "SetSNOMEDCode62479008";
      src.code as codeValue where codeValue = '77465005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '157',  newCoding.display = 'Transplantation [procedure]' "SetSNOMEDCode77465005";
      src.code as codeValue where codeValue = '313039003' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '157',  newCoding.display = 'Solid organ transplant [procedure]' "SetSNOMEDCode313039003";
      src.code as codeValue where codeValue = '86553008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '158',  newCoding.display = 'Immunosuppressive therapy [procedure]' "SetSNOMEDCode86553008";
      src.code as codeValue where codeValue = '53438000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '159',  newCoding.display = 'Radiation therapy procedure or service [procedure]' "SetSNOMEDCode53438000";
      src.code as codeValue where codeValue = '707147002' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '160',  newCoding.display = 'Asplenia [disorder]' "SetSNOMEDCode707147002";
      src.code as codeValue where codeValue = '709044004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '161',  newCoding.display = 'Chronic kidney disease [disorder]' "SetSNOMEDCode709044004";
      src.code as codeValue where codeValue = '52254009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '167',  newCoding.display = 'Nephrotic syndrome [disorder]' "SetSNOMEDCode52254009";
      src.code as codeValue where codeValue = '367336001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '168',  newCoding.display = 'Chemotherapy [procedure]' "SetSNOMEDCode367336001";
      src.code as codeValue where codeValue = '213017001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '169',  newCoding.display = 'Sexual abuse [event]' "SetSNOMEDCode213017001";
      src.code as codeValue where codeValue = '422608009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '169',  newCoding.display = 'Sexual assault [finding' "SetSNOMEDCode422608009";
      src.code as codeValue where codeValue = '248110007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '169',  newCoding.display = 'Sexual assault [event]' "SetSNOMEDCode248110007";
      src.code as codeValue where codeValue = '248986005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '170',  newCoding.display = 'Estimated date of conception [observable entity]' "SetSNOMEDCode248986005";
      src.code as codeValue where codeValue = '451291000124104' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '172',  newCoding.display = 'Adverse reaction caused by zoster vaccine [disorder]' "SetSNOMEDCode451291000124104";
      src.code as codeValue where codeValue = '93143009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '178',  newCoding.display = 'Leukemia, disease [disorder]' "SetSNOMEDCode93143009";
      src.code as codeValue where codeValue = '399600009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '179',  newCoding.display = 'Lymphoma [finding]' "SetSNOMEDCode399600009";
      src.code as codeValue where codeValue = '118599009' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '180',  newCoding.display = 'Hodgkin's disease [disorder]' "SetSNOMEDCode118599009";
      src.code as codeValue where codeValue = '109989006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '181',  newCoding.display = 'Multiple myeloma [disorder]' "SetSNOMEDCode109989006";
      src.code as codeValue where codeValue = '86406008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '186',  newCoding.display = 'Human immunodeficiency virus infection [disorder]' "SetSNOMEDCode86406008";
      src.code as codeValue where codeValue = '1156961008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '191',  newCoding.display = 'Chimeric antigen receptor T-cell immunotherapy [procedure]' "SetSNOMEDCode1156961008";
      src.code as codeValue where codeValue = '363346000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '198',  newCoding.display = 'Malignant neoplastic disease [disorder]' "SetSNOMEDCode363346000";
      src.code as codeValue where codeValue = '233703007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '199',  newCoding.display = 'Interstitial lung disease [disorder]' "SetSNOMEDCode233703007";
      src.code as codeValue where codeValue = '190905008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '200',  newCoding.display = 'cystic fibrosis [disorder]' "SetSNOMEDCode190905008";
      src.code as codeValue where codeValue = '70995007' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '201',  newCoding.display = 'Pulmonary hypertension [disorder]' "SetSNOMEDCode70995007";
      src.code as codeValue where codeValue = '52448006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '202',  newCoding.display = 'Dimensia [disorder]' "SetSNOMEDCode52448006";
      src.code as codeValue where codeValue = '41040004' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '203',  newCoding.display = 'Complete trisomy 21 syndrome [disorder]' "SetSNOMEDCode41040004";
      src.code as codeValue where codeValue = '40108008' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '205',  newCoding.display = 'Thalassemia [disorder]' "SetSNOMEDCode40108008";
      src.code as codeValue where codeValue = '62914000' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '206',  newCoding.display = 'Cerebrovascular disease [disorder]' "SetSNOMEDCode62914000";
      src.code as codeValue where codeValue = '13645005' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '214',  newCoding.display = 'Chronic obstructive lung disease [disorder]' "SetSNOMEDCode13645005";
      src.code as codeValue where codeValue = '87433001' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '215',  newCoding.display = 'Pulmonary emphysema [disorder]' "SetSNOMEDCode87433001";
      src.code as codeValue where codeValue = '413490006' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '245',  newCoding.display = 'American Indian or Alaska Native [racial group]' "SetSNOMEDCode413490006";
    } "HandleIndividualSNOMEDCoding";
  } "ApplySNOMEDMappings";
  src.system as systemValue where systemValue = 'http://hl7.org/fhir/sid/cvx' -> tgt.code = create('CodeableConcept') as newCC then {
    src -> newCC.coding = create('Coding') as newCoding then {
      src.code as codeValue where codeValue = '02' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'OPV' "SetCVXCode02";
      src.code as codeValue where codeValue = '10' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'IPV' "SetCVXCode10";
      src.code as codeValue where codeValue = '89' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'Polio, unspecified formulation' "SetCVXCode89";
      src.code as codeValue where codeValue = '110' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'DTaP-HepB-IPV' "SetCVXCode110";
      src.code as codeValue where codeValue = '120' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'DTaP-Hib-IPV' "SetCVXCode120";
      src.code as codeValue where codeValue = '130' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'DTaP-IPV' "SetCVXCode130";
      src.code as codeValue where codeValue = '132' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'DTaP-IPV-Hib-HepB, Historical' "SetCVXCode132";
      src.code as codeValue where codeValue = '146' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'DTaP-IPV-Hib-HepB' "SetCVXCode146";
      src.code as codeValue where codeValue = '39' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '082',  newCoding.display = 'Japanese Encephalitis, MB' "SetCVXCode39";
      src.code as codeValue where codeValue = '134' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '082',  newCoding.display = 'Japanese Encephalitis, VC' "SetCVXCode134";
      src.code as codeValue where codeValue = '129' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '082',  newCoding.display = 'Japanese Encephalitis, unspecified' "SetCVXCode129";
      src.code as codeValue where codeValue = '116' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '083',  newCoding.display = 'Rotavirus, pentavalent' "SetCVXCode116";
      src.code as codeValue where codeValue = '122' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '083',  newCoding.display = 'Rotavirus, unspecified formulation' "SetCVXCode122";
      src.code as codeValue where codeValue = '74' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '083',  newCoding.display = 'Rotavirus, tetravalent' "SetCVXCode74";
      src.code as codeValue where codeValue = '119' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '083',  newCoding.display = 'Rotavirus, monovalent' "SetCVXCode119";
      src.code as codeValue where codeValue = '101' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '084',  newCoding.display = 'Typhoid capsular polysaccharide' "SetCVXCode101";
      src.code as codeValue where codeValue = '25' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '084',  newCoding.display = 'Typhoid oral, live, attenuated' "SetCVXCode25";
      src.code as codeValue where codeValue = '41' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '084',  newCoding.display = 'Typhoid, parenteral' "SetCVXCode41";
      src.code as codeValue where codeValue = '53' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '084',  newCoding.display = 'Typhoid, parenteral, AKD [U.S. military]' "SetCVXCode53";
      src.code as codeValue where codeValue = '91' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '084',  newCoding.display = 'Typhoid, unspecified formulation' "SetCVXCode91";
      src.code as codeValue where codeValue = '15' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, split incl. purified surface antigen' "SetCVXCode15";
      src.code as codeValue where codeValue = '16' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, whole' "SetCVXCode16";
      src.code as codeValue where codeValue = '88' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, Unspecified' "SetCVXCode88";
      src.code as codeValue where codeValue = '111' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, live, intranasal' "SetCVXCode111";
      src.code as codeValue where codeValue = '135' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, high dose seasonal' "SetCVXCode135";
      src.code as codeValue where codeValue = '140' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, injectable preservative free' "SetCVXCode140";
      src.code as codeValue where codeValue = '141' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, injectable' "SetCVXCode141";
      src.code as codeValue where codeValue = '144' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, intradermal, preservative free' "SetCVXCode144";
      src.code as codeValue where codeValue = '149' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'influenza, live, intranasal, quadrivalent' "SetCVXCode149";
      src.code as codeValue where codeValue = '150' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'influenza, injectable, quadrivalent, preservative free' "SetCVXCode150";
      src.code as codeValue where codeValue = '151' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'influenza nasal, unspecified formulation' "SetCVXCode151";
      src.code as codeValue where codeValue = '153' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, injectable, MDCK, preservative free' "SetCVXCode153";
      src.code as codeValue where codeValue = '155' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'influenza, recombinant, injectable, preservative free' "SetCVXCode155";
      src.code as codeValue where codeValue = '158' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, injectable, quadrivalent' "SetCVXCode158";
      src.code as codeValue where codeValue = '161' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, injectable, quadrivalent, preservative free, peds' "SetCVXCode161";
      src.code as codeValue where codeValue = '166' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Influenza, intradermal, quadrivalent, preservative free' "SetCVXCode166";
      src.code as codeValue where codeValue = '01' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTP' "SetCVXCode01";
      src.code as codeValue where codeValue = '20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP' "SetCVXCode20";
      src.code as codeValue where codeValue = '22' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTP-Hib' "SetCVXCode22";
      src.code as codeValue where codeValue = '50' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP-Hib' "SetCVXCode50";
      src.code as codeValue where codeValue = '102' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTP-Hib-HepB' "SetCVXCode102";
      src.code as codeValue where codeValue = '106' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP, 5 pertussis antigens' "SetCVXCode106";
      src.code as codeValue where codeValue = '107' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP, Unspecified Formulation' "SetCVXCode107";
      src.code as codeValue where codeValue = '110' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP-HepB-IPV' "SetCVXCode110";
      src.code as codeValue where codeValue = '115' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'Tdap' "SetCVXCode115";
      src.code as codeValue where codeValue = '120' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP-Hib-IPV' "SetCVXCode120";
      src.code as codeValue where codeValue = '130' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP-IPV' "SetCVXCode130";
      src.code as codeValue where codeValue = '132' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP-IPV-Hib-HepB,historical' "SetCVXCode132";
      src.code as codeValue where codeValue = '146' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'DTaP-IPV-Hib-HepB' "SetCVXCode146";
      src.code as codeValue where codeValue = '01' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTP' "SetCVXCode01";
      src.code as codeValue where codeValue = '09' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'Td - Adult Adsorbed' "SetCVXCode09";
      src.code as codeValue where codeValue = '20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP' "SetCVXCode20";
      src.code as codeValue where codeValue = '22' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTP-Hib' "SetCVXCode22";
      src.code as codeValue where codeValue = '28' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DT - Pediatric' "SetCVXCode28";
      src.code as codeValue where codeValue = '50' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP-Hib' "SetCVXCode50";
      src.code as codeValue where codeValue = '102' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTP-Hib-HepB' "SetCVXCode102";
      src.code as codeValue where codeValue = '106' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP, 5 pertussis antigens' "SetCVXCode106";
      src.code as codeValue where codeValue = '107' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP, Unspecified Formulation' "SetCVXCode107";
      src.code as codeValue where codeValue = '110' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP-HepB-IPV' "SetCVXCode110";
      src.code as codeValue where codeValue = '113' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'Td p-free' "SetCVXCode113";
      src.code as codeValue where codeValue = '115' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'Tdap' "SetCVXCode115";
      src.code as codeValue where codeValue = '120' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP-Hib-IPV' "SetCVXCode120";
      src.code as codeValue where codeValue = '130' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP-IPV' "SetCVXCode130";
      src.code as codeValue where codeValue = '132' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP-IPV-Hib-HepB,historical' "SetCVXCode132";
      src.code as codeValue where codeValue = '138' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'Td - Adult' "SetCVXCode138";
      src.code as codeValue where codeValue = '139' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'Td - Adult Unspecified Formulation' "SetCVXCode139";
      src.code as codeValue where codeValue = '146' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'DTaP-IPV-Hib-HepB' "SetCVXCode146";
      src.code as codeValue where codeValue = '01' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTP' "SetCVXCode01";
      src.code as codeValue where codeValue = '09' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'Td - Adult Adsorbed' "SetCVXCode09";
      src.code as codeValue where codeValue = '20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP' "SetCVXCode20";
      src.code as codeValue where codeValue = '22' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTP-Hib' "SetCVXCode22";
      src.code as codeValue where codeValue = '28' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DT - Pediatric' "SetCVXCode28";
      src.code as codeValue where codeValue = '35' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'TT' "SetCVXCode35";
      src.code as codeValue where codeValue = '50' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP-Hib' "SetCVXCode50";
      src.code as codeValue where codeValue = '102' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTP-Hib-HepB' "SetCVXCode102";
      src.code as codeValue where codeValue = '106' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP, 5 pertussis antigens' "SetCVXCode106";
      src.code as codeValue where codeValue = '107' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP, Unspecified Formulation' "SetCVXCode107";
      src.code as codeValue where codeValue = '110' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP-HepB-IPV' "SetCVXCode110";
      src.code as codeValue where codeValue = '113' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'Td p-free' "SetCVXCode113";
      src.code as codeValue where codeValue = '115' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'Tdap' "SetCVXCode115";
      src.code as codeValue where codeValue = '120' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP-Hib-IPV' "SetCVXCode120";
      src.code as codeValue where codeValue = '130' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP-IPV' "SetCVXCode130";
      src.code as codeValue where codeValue = '132' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP-IPV-Hib-HepB,historical' "SetCVXCode132";
      src.code as codeValue where codeValue = '138' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'Td - Adult' "SetCVXCode138";
      src.code as codeValue where codeValue = '139' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'Td - Adult Unspecified Formulation' "SetCVXCode139";
      src.code as codeValue where codeValue = '146' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'DTaP-IPV-Hib-HepB' "SetCVXCode146";
      src.code as codeValue where codeValue = '21' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '089',  newCoding.display = 'Varicella' "SetCVXCode21";
      src.code as codeValue where codeValue = '94' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '089',  newCoding.display = 'MMRV' "SetCVXCode94";
      src.code as codeValue where codeValue = '121' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '089',  newCoding.display = 'Zoster' "SetCVXCode121";
      src.code as codeValue where codeValue = '62' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '090',  newCoding.display = '4vHPV' "SetCVXCode62";
      src.code as codeValue where codeValue = '118' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '090',  newCoding.display = '2vHPV' "SetCVXCode118";
      src.code as codeValue where codeValue = '137' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '090',  newCoding.display = 'HPV Unspecified' "SetCVXCode137";
      src.code as codeValue where codeValue = '165' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '090',  newCoding.display = '9vHPV' "SetCVXCode165";
      src.code as codeValue where codeValue = '03' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '091',  newCoding.display = 'MMR' "SetCVXCode03";
      src.code as codeValue where codeValue = '04' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '091',  newCoding.display = 'Measles/Rubella' "SetCVXCode04";
      src.code as codeValue where codeValue = '05' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '091',  newCoding.display = 'Measles' "SetCVXCode05";
      src.code as codeValue where codeValue = '94' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '091',  newCoding.display = 'MMRV' "SetCVXCode94";
      src.code as codeValue where codeValue = '03' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '092',  newCoding.display = 'MMR' "SetCVXCode03";
      src.code as codeValue where codeValue = '07' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '092',  newCoding.display = 'Mumps' "SetCVXCode07";
      src.code as codeValue where codeValue = '38' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '092',  newCoding.display = 'Rubella/Mumps' "SetCVXCode38";
      src.code as codeValue where codeValue = '94' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '092',  newCoding.display = 'MMRV' "SetCVXCode94";
      src.code as codeValue where codeValue = '03' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '093',  newCoding.display = 'MMR' "SetCVXCode03";
      src.code as codeValue where codeValue = '04' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '093',  newCoding.display = 'Measles/Rubella' "SetCVXCode04";
      src.code as codeValue where codeValue = '06' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '093',  newCoding.display = 'Rubella' "SetCVXCode06";
      src.code as codeValue where codeValue = '38' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '093',  newCoding.display = 'Rubella/Mumps' "SetCVXCode38";
      src.code as codeValue where codeValue = '94' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '093',  newCoding.display = 'MMRV' "SetCVXCode94";
      src.code as codeValue where codeValue = '133' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '094',  newCoding.display = 'PCV13' "SetCVXCode133";
      src.code as codeValue where codeValue = '100' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '094',  newCoding.display = 'PCV7' "SetCVXCode100";
      src.code as codeValue where codeValue = '33' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '094',  newCoding.display = 'PPSV23' "SetCVXCode33";
      src.code as codeValue where codeValue = '109' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '094',  newCoding.display = 'Pneumococcal, unspecified formulation' "SetCVXCode109";
      src.code as codeValue where codeValue = '152' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '094',  newCoding.display = 'Pneumococcal Conjugate, unspecified formulation' "SetCVXCode152";
      src.code as codeValue where codeValue = '32' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Meningococcal, MPSV4' "SetCVXCode32";
      src.code as codeValue where codeValue = '108' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Meningococcal ACWY, unspecified' "SetCVXCode108";
      src.code as codeValue where codeValue = '114' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Meningococcal, MCV4P' "SetCVXCode114";
      src.code as codeValue where codeValue = '136' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Meningococcal, MCV4O' "SetCVXCode136";
      src.code as codeValue where codeValue = '147' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'MCV4, unspecified' "SetCVXCode147";
      src.code as codeValue where codeValue = '148' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Meningococcal C/Y-HIB PRP' "SetCVXCode148";
      src.code as codeValue where codeValue = '167' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Meningococcal, unknown serogroups' "SetCVXCode167";
      src.code as codeValue where codeValue = '52' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '096',  newCoding.display = 'Hep A, adult' "SetCVXCode52";
      src.code as codeValue where codeValue = '83' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '096',  newCoding.display = 'Hep A, ped/adol, 2 dose' "SetCVXCode83";
      src.code as codeValue where codeValue = '84' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '096',  newCoding.display = 'Hep A, ped/adol, 3 dose' "SetCVXCode84";
      src.code as codeValue where codeValue = '85' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '096',  newCoding.display = 'Hep A, Unspecified' "SetCVXCode85";
      src.code as codeValue where codeValue = '104' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '096',  newCoding.display = 'HepA-HepB' "SetCVXCode104";
      src.code as codeValue where codeValue = '08' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Hep B, Adol/peds' "SetCVXCode08";
      src.code as codeValue where codeValue = '42' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Hep B, Adol/high risk infant' "SetCVXCode42";
      src.code as codeValue where codeValue = '43' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Hep B, Adult' "SetCVXCode43";
      src.code as codeValue where codeValue = '44' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Hep B, Dialysis' "SetCVXCode44";
      src.code as codeValue where codeValue = '45' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Hep B, Unspecified Formulation' "SetCVXCode45";
      src.code as codeValue where codeValue = '51' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Hib-HepB' "SetCVXCode51";
      src.code as codeValue where codeValue = '102' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'DTaP-Hib-HepB' "SetCVXCode102";
      src.code as codeValue where codeValue = '104' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'HepA-HepB' "SetCVXCode104";
      src.code as codeValue where codeValue = '110' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'DTaP-HepB-IPV' "SetCVXCode110";
      src.code as codeValue where codeValue = '132' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'DTaP-IPV-Hib-HepB, historical' "SetCVXCode132";
      src.code as codeValue where codeValue = '146' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'DTaP-IPV-Hib-HepB' "SetCVXCode146";
      src.code as codeValue where codeValue = '17' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'Hib unspecified formulation' "SetCVXCode17";
      src.code as codeValue where codeValue = '22' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'DTP-Hib' "SetCVXCode22";
      src.code as codeValue where codeValue = '46' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'PRP-D' "SetCVXCode46";
      src.code as codeValue where codeValue = '47' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'HbOC' "SetCVXCode47";
      src.code as codeValue where codeValue = '48' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'PRP-T' "SetCVXCode48";
      src.code as codeValue where codeValue = '49' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'PRP-OMP' "SetCVXCode49";
      src.code as codeValue where codeValue = '50' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'DTaP/Hib' "SetCVXCode50";
      src.code as codeValue where codeValue = '51' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'Hib-HepB' "SetCVXCode51";
      src.code as codeValue where codeValue = '102' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'DTP-Hib-HepB' "SetCVXCode102";
      src.code as codeValue where codeValue = '120' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'DTaP-IPV/Hib' "SetCVXCode120";
      src.code as codeValue where codeValue = '132' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'DTaP-IPV-Hib-HepB,historical' "SetCVXCode132";
      src.code as codeValue where codeValue = '146' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'DTaP-IPV-Hib-HepB' "SetCVXCode146";
      src.code as codeValue where codeValue = '148' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'Hib-MenCY-TT' "SetCVXCode148";
      src.code as codeValue where codeValue = '25' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '099',  newCoding.display = 'Yellow Fever' "SetCVXCode25";
      src.code as codeValue where codeValue = '121' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '100',  newCoding.display = 'Zoster live' "SetCVXCode121";
      src.code as codeValue where codeValue = '18' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '113',  newCoding.display = 'Rabies, intramuscular injection' "SetCVXCode18";
      src.code as codeValue where codeValue = '40' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '113',  newCoding.display = 'Rabies, intradermal injection' "SetCVXCode40";
      src.code as codeValue where codeValue = '90' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '113',  newCoding.display = 'Rabies, unspecified formulation' "SetCVXCode90";
      src.code as codeValue where codeValue = '162' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '116',  newCoding.display = 'Meningococcal B, recombinant' "SetCVXCode162";
      src.code as codeValue where codeValue = '163' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '116',  newCoding.display = 'Meningococcal B, OMV' "SetCVXCode163";
      src.code as codeValue where codeValue = '164' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '116',  newCoding.display = 'Meningococcal B, unspecified' "SetCVXCode164";
      src.code as codeValue where codeValue = '26' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '119',  newCoding.display = 'cholera, unspecified formulation' "SetCVXCode26";
      src.code as codeValue where codeValue = '172' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '119',  newCoding.display = 'cholera, WC-rBS' "SetCVXCode172";
      src.code as codeValue where codeValue = '173' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '119',  newCoding.display = 'cholera, BivWC' "SetCVXCode173";
      src.code as codeValue where codeValue = '174' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '119',  newCoding.display = 'cholera, live attenuated' "SetCVXCode174";
      src.code as codeValue where codeValue = '208' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '122',  newCoding.display = 'COVID-19, mRNA, LNP-S, PF, 30 mcg/0.3 mL dose' "SetCVXCode208";
      src.code as codeValue where codeValue = '13' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '125',  newCoding.display = 'Tetanus immune globulin' "SetCVXCode13";
      src.code as codeValue where codeValue = '154' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '126',  newCoding.display = 'Hepatitis A immune globulin' "SetCVXCode154";
      src.code as codeValue where codeValue = '30' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '127',  newCoding.display = 'Hepatitis B immune globulin' "SetCVXCode30";
      src.code as codeValue where codeValue = '34' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '128',  newCoding.display = 'Rabies immune globulin' "SetCVXCode34";
      src.code as codeValue where codeValue = '36' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '129',  newCoding.display = 'Varicella zoster immune globulin' "SetCVXCode36";
      src.code as codeValue where codeValue = '187' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '172',  newCoding.display = 'Zoster subunit' "SetCVXCode187";
      src.code as codeValue where codeValue = 'non-US' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '252',  newCoding.display = 'Tick-borne encephalitis vaccine' "SetCVXCodenonUS";
      src.code as codeValue where codeValue = '222' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '252',  newCoding.display = 'Tick-borne encephalitis, unspecified' "SetCVXCode222";
      src.code as codeValue where codeValue = '223' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '252',  newCoding.display = 'Tick-borne encephalitis, inactivated, PF, 0.25mL' "SetCVXCode223";
      src.code as codeValue where codeValue = '224' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '252',  newCoding.display = 'Tick-borne encephalitis, inactivated, PF, 0.5mL' "SetCVXCode224";
    } "HandleIndividualCVXCoding";
  } "ApplyCVXMappings";
  src.system as systemValue where systemValue = 'http://phinvads.cdc.gov' -> tgt.code = create('CodeableConcept') as newCC then {
    src -> newCC.coding = create('Coding') as newCoding then {
      src.code as codeValue where codeValue = 'VXC27' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '003',  newCoding.display = 'Immunodeficiency due to any cause' "SetCDCPHINVSCodeVXC27";
      src.code as codeValue where codeValue = 'VXC21' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '028',  newCoding.display = 'Previous history of intussusception' "SetCDCPHINVSCodeVXC21";
      src.code as codeValue where codeValue = 'VXC22' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '079',  newCoding.display = 'Encephalopathy within 7 days of previous dose of DTP or DTaP' "SetCDCPHINVSCodeVXC22";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '080',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '081',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '082',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '083',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '084',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '085',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '086',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '087',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '088',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '089',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '090',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '091',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '092',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '093',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '094',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '095',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '096',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '097',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '098',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '099',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '100',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC18' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '110',  newCoding.display = 'Allergy to baker's yeast [anaphylactic]' "SetCDCPHINVSCodeVXC18";
      src.code as codeValue where codeValue = 'VXC17' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '111',  newCoding.display = 'Allergy [anaphylactic] to 2-phenoxyethanol' "SetCDCPHINVSCodeVXC17";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '113',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '116',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '119',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '122',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '172',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
      src.code as codeValue where codeValue = 'VXC20' ->  newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',  newCoding.code = '252',  newCoding.display = 'Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]' "SetCDCPHINVSCodeVXC20";
    } "HandleIndividualCDCPHINVSCoding";
  } "ApplyCDCPHINVSMappings";
}


```



## Resource Content

```json
{
  "resourceType" : "StructureMap",
  "id" : "MapVaccineCodes",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/StructureMap/map-vaccine-codes",
  "version" : "0.1.0",
  "name" : "MapVaccineCodes",
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
  "description" : "Define the usage of FHIR resource types with specific aliases",
  "structure" : [
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/Observation",
      "mode" : "source",
      "alias" : "sourceObservation"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/Condition",
      "mode" : "source",
      "alias" : "sourceCondition"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/Procedure",
      "mode" : "source",
      "alias" : "sourceProcedure"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/Immunization",
      "mode" : "source",
      "alias" : "sourceImmunization"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/Medication",
      "mode" : "source",
      "alias" : "sourceMedication"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/MedicationStatement",
      "mode" : "source",
      "alias" : "sourceMedicationStatement"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/MedicationRequest",
      "mode" : "source",
      "alias" : "sourceMedicationRequest"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/MedicationAdministration",
      "mode" : "source",
      "alias" : "sourceMedicationAdministration"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/MedicationDispense",
      "mode" : "source",
      "alias" : "sourceMedicationDispense"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/Condition",
      "mode" : "target",
      "alias" : "targetCondition"
    }
  ],
  "group" : [
    {
      "name" : "MapToVaccineConditionObservation",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "any",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SourceObservationToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceObservation",
              "condition" : "(src is Observation)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromObservation",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceConditionToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceCondition",
              "condition" : "(src is Condition)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromCondition",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceProcedureToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceProcedure",
              "condition" : "(src is Procedure)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromProcedure",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceImmunizationToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceImmunization",
              "condition" : "(src is Immunization)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromImmunization",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceMedicationToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceMedication",
              "condition" : "(src is Medication)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromMedication",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceMedStatementToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceMedicationStatement",
              "condition" : "(src is MedicationStatement)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromMedicationStatement",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceMedRequestToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceMedicationRequest",
              "condition" : "(src is MedicationRequest)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromMedicationRequest",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceMedAdminToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceMedicationAdministration",
              "condition" : "(src is MedicationAdministration)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromMedicationAdministration",
              "variable" : ["src", "tgt"]
            }
          ]
        },
        {
          "name" : "SourceMedDispenseToTarget",
          "source" : [
            {
              "context" : "src",
              "variable" : "sourceMedicationDispense",
              "condition" : "(src is MedicationDispense)"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable"
            }
          ],
          "dependent" : [
            {
              "name" : "MapFromMedicationDispense",
              "variable" : ["src", "tgt"]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromObservation",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceObservation",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetObservationStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyObsMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "code",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        },
        {
          "name" : "SetObsOnsetDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.effectiveDateTime"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetObsOnsetPeriod",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetPeriod",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.effectivePeriod"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetObsOnsetInstant",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.effectiveInstant"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromCondition",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceCondition",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetConditionStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyCondMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "code",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        },
        {
          "name" : "SetCondOnsetDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.onsetDateTime"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondOnsetAge",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetAge",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.onsetAge"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondOnsetPeriod",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetPeriod",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.onsetPeriod"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondOnsetRange",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetRange",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.onsetRange"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondOnsetString",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetString",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.onsetString"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondAbatementDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "abatementDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.abatementDateTime"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondAbatementAge",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "abatementAge",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.abatementAge"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondAbatementPeriod",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "abatementPeriod",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.abatementPeriod"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondAbatementRange",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "abatementRange",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.abatementRange"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetCondAbatementString",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "abatementString",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.abatementString"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromProcedure",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceProcedure",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetProcedureStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyProcedureMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "code",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        },
        {
          "name" : "SetProcedureOnsetDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.performedDateTime"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetProcedureOnsetAge",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetAge",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.performedAge"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetProcedureOnsetPeriod",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetPeriod",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.performedPeriod"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetProcedureOnsetRange",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetRange",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.performedRange"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetProcedureOnsetString",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetString",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.performedString"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromImmunization",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceImmunization",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetImmunizationStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyImmunizationMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "vaccineCode",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        },
        {
          "name" : "SetImmunizationOnsetDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.occurrenceDateTime"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetImmunizationOnsetString",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetString",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.occurrenceString"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromMedication",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceMedication",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetMedicationStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyMedicationMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "code",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromMedicationStatement",
      "typeMode" : "none",
      "documentation" : "TODO(Dokotela): what about medicationReference?",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceMedicationStatement",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetMedStatementStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyMedStatementMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "medicationCodeableConcept",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromMedicationRequest",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceMedicationRequest",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetMedRequestStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyMedRequestMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "medicationCodeableConcept",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        },
        {
          "name" : "SetMedRequestOnsetDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.authoredOn"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromMedicationAdministration",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceMedicationAdministration",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetMedAdminStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyMedAdminMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "medicationCodeableConcept",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        },
        {
          "name" : "SetMedAdminOnsetDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.effectiveDateTime"
                }
              ]
            }
          ]
        },
        {
          "name" : "SetMedAdminOnsetPeriod",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetPeriod",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.effectivePeriod"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name" : "MapFromMedicationDispense",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "sourceMedicationDispense",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "SetMedDispenseStatus",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "status",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueString" : "active"
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyMedDispenseMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "medicationCodeableConcept",
              "variable" : "code"
            }
          ],
          "target" : [
            {
              "context" : "code",
              "contextType" : "variable",
              "element" : "coding",
              "variable" : "coding"
            }
          ],
          "dependent" : [
            {
              "name" : "ApplyCommonMappings",
              "variable" : ["coding", "tgt"]
            }
          ]
        },
        {
          "name" : "SetMedDispenseOnsetDateTime",
          "source" : [
            {
              "context" : "src"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "onsetDateTime",
              "transform" : "copy",
              "parameter" : [
                {
                  "valueId" : "src.whenHandedOver"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name" : "ApplyCommonMappings",
      "typeMode" : "none",
      "input" : [
        {
          "name" : "src",
          "type" : "Coding",
          "mode" : "source"
        },
        {
          "name" : "tgt",
          "type" : "targetCondition",
          "mode" : "target"
        }
      ],
      "rule" : [
        {
          "name" : "ApplySNOMEDMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "system",
              "variable" : "systemValue",
              "condition" : "systemValue = 'http://snomed.info/sct'"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "code",
              "variable" : "newCC",
              "transform" : "create",
              "parameter" : [
                {
                  "valueString" : "CodeableConcept"
                }
              ]
            }
          ],
          "rule" : [
            {
              "name" : "HandleIndividualSNOMEDCoding",
              "source" : [
                {
                  "context" : "src"
                }
              ],
              "target" : [
                {
                  "context" : "newCC",
                  "contextType" : "variable",
                  "element" : "coding",
                  "variable" : "newCoding",
                  "transform" : "create",
                  "parameter" : [
                    {
                      "valueString" : "Coding"
                    }
                  ]
                }
              ],
              "rule" : [
                {
                  "name" : "SetSNOMEDCode370388006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '370388006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "003"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Patient Immunocompromised"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode234336002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '234336002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "004"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hemopoietic stem cell transplant [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode50711007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '50711007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "005"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Viral hepatitis type C [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode77386006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '77386006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "007"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Patient currently pregnant [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode102874004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '102874004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "007"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Possible pregnancy [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode255409004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '255409004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "007"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pregnant woman [person]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode413712001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '413712001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "009"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Breastfeeding [mother] [observable entity]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode230744007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '230744007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "010"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Cerebrospinal fluid leak [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode449840001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '449840001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "011"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Cochlear prosthesis in situ [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode43252007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '43252007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "011"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Cochlear prosthesis, device [physical object]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode359612003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '359612003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "011"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Implantation of cochlear prosthetic device [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode31323000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '31323000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "013"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Severe combined immunodeficiency disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode73211009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '73211009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "014"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Diabetes mellitus [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode328383001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '328383001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "015"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic liver disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode19943007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '19943007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "015"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Cirrhosis of liver [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode128238001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '128238001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "016"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic heart disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode42343007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '42343007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "016"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Congestive heart failure [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode57809008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '57809008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "016"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Myocardial disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode12770006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '12770006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "016"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Cyanotic congenital heart disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode413839001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '413839001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "017"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic lung disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode13645005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '13645005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "017"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic obstructive lung disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode87433001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '87433001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "017"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pulmonary emphysema [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode278971009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '278971009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "018"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis A Immune [Finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode271511000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '271511000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "019"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis B Immune [Finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode371111005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '371111005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "020"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Measles Immune [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode371112003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '371112003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "021"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Mumps Immune [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode278968001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '278968001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "022"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rubella Immune [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode371113008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '371113008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "023"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Varicella Immune"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode38907003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '38907003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "024"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Varicella [Disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode4740000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '4740000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "025"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Herpes Zoster [Disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode86406008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '86406008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "026"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Human immunodeficiency virus infection [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode427314002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '427314002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "026"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Antiviral therapy [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode390798007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '390798007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "027"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Asthma finding [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode195967001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '195967001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "027"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Asthma [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode35327006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '35327006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "028"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Intussusception [morphologic abnormality]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode49723003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '49723003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "028"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Intussusception of intestine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode69776003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '69776003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "029"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Acute gastroenteritis [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode56717001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '56717001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "031"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tuberculosis [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode372763006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '372763006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Amantadine [substance]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode51361008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '51361008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Amantadine [product]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode372532009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '372532009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rimantadine [substance]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode108712009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '108712009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rimantadine [product]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode387010007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '387010007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Zanamivir [substance]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode116100000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '116100000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Zanamivir [product]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode412261005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '412261005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Oseltamivir [substance]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode386142008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '386142008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "033"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Oseltamivir [product]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode405742008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '405742008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "034"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Aspirin therapy finding [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode76102007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '76102007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "036"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Male homosexual [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode225531006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '225531006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "036"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Homosexual behavior [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode225516002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '225516002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "037"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Multiple sexual contacts [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode228460004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '228460004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "037"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Multiple current sexual partners [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode228466005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '228466005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "037"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Commitment to sexual relationship [observable entity]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode225517006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '225517006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "038"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Sexual partners [observable entity]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode11723008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '11723008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "038"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Contact with [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode165806002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '165806002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "038"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis B surface antigen positive [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode305489005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '305489005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "039"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Under care of genitourinary medicine physician [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode305679000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '305679000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "039"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Seen by genitourinary medicine physician [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode8098009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '8098009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "039"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Sexually transmitted infectious disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode307052004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '307052004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "040"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Illicit drug use [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode228366006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '228366006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "040"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Finding relating to drug misuse behavior [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode226034001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '226034001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "041"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Injecting drug user [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode228388006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '228388006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "041"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Intravenous drug user  [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode145101000119102",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '145101000119102'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "041"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Intravenous cocaine abuse [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode403746009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '403746009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "041"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Skin lesion due to intravenous drug abuse [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode860699005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '860699005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "041"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Deep vein thrombosis of lower extremity due to intravenous drug use [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode77176002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '77176002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "042"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Smoker [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode228281002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '228281002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "043"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Problem drinker [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode7200002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '7200002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "043"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Alcoholism [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode159138004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '159138004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "050"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Microbiologist [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode14698002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '14698002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "050"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Medical microbiologist [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "050"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode17872004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '17872004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "050"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Neisseria meningitidis [organism]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode159138004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '159138004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "051"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Microbiologist [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode14698002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '14698002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "051"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Medical microbiologist [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode159282002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '159282002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "051"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Laboratory technician [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "051"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode5595000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '5595000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "051"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Salmonella Typhi [organism]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode159282002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '159282002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "052"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Laboratory technician [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "052"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode26630006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '26630006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "052"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Yellow fever virus [organism]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode159282002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '159282002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "053"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Laboratory technician [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "053"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode59881000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '59881000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "053"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rabies virus [organism]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode159282002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '159282002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "054"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Laboratory technician [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "054"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode44172002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '44172002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "054"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Human poliovirus [organism]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode223366009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '223366009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "055"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Healthcare professional [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode223366009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '223366009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "056"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Healthcare professional [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "056"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode44172002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '44172002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "056"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Human poliovirus [organism]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode26369006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '26369006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Public health nurse [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode68867008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '68867008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Public health dentist [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode307969004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '307969004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Public health officer [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode56466003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '56466003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Public health physician [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode56079002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '56079002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Public health veterinarian [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode60008001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '60008001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Public health nutritionist [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode87612001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '87612001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Blood [substance]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode32457005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '32457005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "057"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Body fluid [substance]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode223366009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '223366009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Healthcare professional [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode158942005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '158942005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Residential child care worker [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode158939004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '158939004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Child care officer [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode73851001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '73851001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Plumber [general] [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode160157004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '160157004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Sewerman [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode266006009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '266006009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Food/drink processor [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode274272004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '274272004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Catering services occupation [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode160133004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '160133004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "059"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Packer - food/garden produce [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode265940000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '265940000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "060"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Animal health occupation [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode159091009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '159091009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "061"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Trainer - performing animals [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24932003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24932003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "062"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Exposure to [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode59881000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '59881000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "062"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rabies virus [organism]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode65853000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '65853000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "063"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Student [occupation]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode257561002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '257561002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "063"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Further education establishment [environment]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode90688005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '90688005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "066"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic renal failure syndrome [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode20078004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '20078004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "068"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Substance abuse treatment center [environment]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode257656006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '257656006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "069"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Penal institution [environment]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode410519009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '410519009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "070"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "At risk context [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode443684005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '443684005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "070"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Disease outbreak [event]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode11723008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '11723008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "071"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Contact with [contextual qualifier] [qualifier value]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode165806002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '165806002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "071"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis B surface antigen positive [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode170484009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '170484009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "072"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Typhoid carrier [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode12271241000119109",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '12271241000119109'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "075"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Transgender identify [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode84757009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '84757009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "076"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Epilepsy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode192711008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '192711008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "079"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Post diphtheria vaccination encephalitis [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode192710009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '192710009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "079"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Post tetanus vaccination encephalitis [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode192712001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '192712001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "079"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Post pertussis vaccination encephalitis [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293104008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293104008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "080"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Vaccines adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293117006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293117006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Poliomyelitis vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode451301000124103",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '451301000124103'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "082"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction caused by Japanese encephalitis virus vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode429301000124101",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '429301000124101'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "083"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction to rotavirus vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293122006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293122006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "084"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Typhoid vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode420113004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '420113004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza virus vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293115003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293115003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pertussis vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode219085007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '219085007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction to diphtheria vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode219084006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '219084006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction to tetanus vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode451331000124106",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '451331000124106'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "089"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction caused by varicella virus live vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode429311000124103",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '429311000124103'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "090"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction to human papillomavirus vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode219096004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '219096004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "091"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction to measles vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293114004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293114004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "092"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Mumps vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293119009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293119009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "093"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rubella vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293116002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293116002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "094"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pneumococcal vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode2219088009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '2219088009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction to meningococcal vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode451111000124103",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '451111000124103'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction caused by meningococcal conjugate vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293126009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293126009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "096"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis A vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293110008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293110008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis B vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293127000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293127000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Haemophilus influenzae Type B vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode219095000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '219095000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "099"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction to yellow fever vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode451291000124104",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '451291000124104'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "100"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction caused by zoster vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode213020009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '213020009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "101"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Egg protein allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode91930004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '91930004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "101"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to eggs [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293309006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293309006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "102"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Gelatin adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode294847001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '294847001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "102"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Gelatin allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode300916003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '300916003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "104"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Latex allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode441593005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '441593005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "104"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Anaphylaxis due to latex [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode419522004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '419522004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "106"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Gentamycin sensitivity [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode420094007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '420094007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "106"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Gentamicin adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode294469003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '294469003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "106"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Gentamicin allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode294468006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '294468006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "107"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Neomycin allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode292927007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '292927007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "107"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Neomycin adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode294466005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '294466005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "108"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Streptomycin allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode292925004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '292925004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "108"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Streptomycin adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode294530006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '294530006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "109"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Polymyxin B allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode292992006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '292992006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "109"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Polymyxin B adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode703936006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '703936006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "110"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to yeast [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode293118001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '293118001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "113"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rabies vaccine adverse reaction [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode46177005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '46177005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "114"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "End stage renal disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode64520006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '64520006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "115"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Protamine sulfate [substance]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode294278007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '294278007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "115"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Protamine allergy [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode451281000124102",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '451281000124102'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "116"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction caused by meningococcal group B vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode219082005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '219082005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "119"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction caused by cholera vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode32911000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '32911000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "121"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Homeless [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode116859006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '116859006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "132"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Transfusion of blood product [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode116859006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '116859006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "133"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Transfusion of blood product [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode116859006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '116859006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "134"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Transfusion of blood product [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode13569004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '13569004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "135"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Transfusion of plasma [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode12719002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '12719002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "135"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Platelet transfusion [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode65880007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '65880007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "145"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "X-linked agammaglobulinemia [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode23238000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '23238000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "145"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Common variable agammaglobulinemia [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode190979003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '190979003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "146"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Selective immunoglobulin A deficiency [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode123785006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '123785006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "146"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Immunoglobulin G subclass deficiency [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode31323000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '31323000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "147"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Severe combined immunodeficiency disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode77128003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '77128003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "147"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DiGeorge sequence [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode77128003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '77128003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "148"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DiGeorge sequence [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode36070007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '36070007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "148"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Wiskott-Aldrich syndrome [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode68504005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '68504005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "148"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Ataxia-telangiectasia syndrome [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24743004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24743004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "150"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Complement deficiency disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode24743004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '24743004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "151"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Complement deficiency disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode81166004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '81166004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "151"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Properdin deficiency disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode234605000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '234605000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "151"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Factor B deficiency [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode387759001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '387759001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "152"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic granulomatous disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode77358003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '77358003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "153"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Congenital leukocyte adherence deficiency [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode234433009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '234433009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "153"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Myeloperoxidase deficiency [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode62479008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '62479008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "154"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Acquired immune deficiency syndrome [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode62479008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '62479008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "155"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Acquired immune deficiency syndrome [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode77465005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '77465005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "157"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Transplantation [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode313039003",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '313039003'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "157"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Solid organ transplant [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode86553008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '86553008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "158"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Immunosuppressive therapy [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode53438000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '53438000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "159"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Radiation therapy procedure or service [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode707147002",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '707147002'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "160"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Asplenia [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode709044004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '709044004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "161"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic kidney disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode52254009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '52254009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "167"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Nephrotic syndrome [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode367336001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '367336001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "168"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chemotherapy [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode213017001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '213017001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "169"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Sexual abuse [event]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode422608009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '422608009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "169"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Sexual assault [finding"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode248110007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '248110007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "169"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Sexual assault [event]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode248986005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '248986005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "170"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Estimated date of conception [observable entity]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode451291000124104",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '451291000124104'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "172"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Adverse reaction caused by zoster vaccine [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode93143009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '93143009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "178"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Leukemia, disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode399600009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '399600009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "179"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Lymphoma [finding]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode118599009",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '118599009'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "180"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hodgkin's disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode109989006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '109989006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "181"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Multiple myeloma [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode86406008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '86406008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "186"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Human immunodeficiency virus infection [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode1156961008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '1156961008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "191"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chimeric antigen receptor T-cell immunotherapy [procedure]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode363346000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '363346000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "198"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Malignant neoplastic disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode233703007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '233703007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "199"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Interstitial lung disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode190905008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '190905008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "200"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "cystic fibrosis [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode70995007",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '70995007'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "201"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pulmonary hypertension [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode52448006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '52448006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "202"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Dimensia [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode41040004",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '41040004'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "203"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Complete trisomy 21 syndrome [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode40108008",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '40108008'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "205"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Thalassemia [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode62914000",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '62914000'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "206"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Cerebrovascular disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode13645005",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '13645005'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "214"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Chronic obstructive lung disease [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode87433001",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '87433001'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "215"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pulmonary emphysema [disorder]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetSNOMEDCode413490006",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '413490006'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "245"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "American Indian or Alaska Native [racial group]"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyCVXMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "system",
              "variable" : "systemValue",
              "condition" : "systemValue = 'http://hl7.org/fhir/sid/cvx'"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "code",
              "variable" : "newCC",
              "transform" : "create",
              "parameter" : [
                {
                  "valueString" : "CodeableConcept"
                }
              ]
            }
          ],
          "rule" : [
            {
              "name" : "HandleIndividualCVXCoding",
              "source" : [
                {
                  "context" : "src"
                }
              ],
              "target" : [
                {
                  "context" : "newCC",
                  "contextType" : "variable",
                  "element" : "coding",
                  "variable" : "newCoding",
                  "transform" : "create",
                  "parameter" : [
                    {
                      "valueString" : "Coding"
                    }
                  ]
                }
              ],
              "rule" : [
                {
                  "name" : "SetCVXCode02",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '02'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "OPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode10",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '10'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode89",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '89'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Polio, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode110",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '110'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-HepB-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode120",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '120'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode130",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '130'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode132",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '132'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB, Historical"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode146",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '146'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode39",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '39'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "082"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Japanese Encephalitis, MB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode134",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '134'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "082"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Japanese Encephalitis, VC"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode129",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '129'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "082"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Japanese Encephalitis, unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode116",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '116'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "083"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rotavirus, pentavalent"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode122",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '122'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "083"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rotavirus, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode74",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '74'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "083"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rotavirus, tetravalent"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode119",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '119'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "083"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rotavirus, monovalent"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode101",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '101'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "084"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Typhoid capsular polysaccharide"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode25",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '25'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "084"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Typhoid oral, live, attenuated"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode41",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '41'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "084"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Typhoid, parenteral"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode53",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '53'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "084"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Typhoid, parenteral, AKD [U.S. military]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode91",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '91'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "084"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Typhoid, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode15",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '15'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, split incl. purified surface antigen"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode16",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '16'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, whole"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode88",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '88'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, Unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode111",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '111'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, live, intranasal"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode135",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '135'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, high dose seasonal"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode140",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '140'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, injectable preservative free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode141",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '141'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, injectable"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode144",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '144'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, intradermal, preservative free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode149",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '149'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "influenza, live, intranasal, quadrivalent"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode150",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '150'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "influenza, injectable, quadrivalent, preservative free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode151",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '151'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "influenza nasal, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode153",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '153'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, injectable, MDCK, preservative free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode155",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '155'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "influenza, recombinant, injectable, preservative free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode158",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '158'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, injectable, quadrivalent"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode161",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '161'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, injectable, quadrivalent, preservative free, peds"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode166",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '166'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Influenza, intradermal, quadrivalent, preservative free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode01",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '01'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode22",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '22'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode50",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '50'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode102",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '102'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode106",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '106'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP, 5 pertussis antigens"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode107",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '107'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP, Unspecified Formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode110",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '110'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-HepB-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode115",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '115'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tdap"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode120",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '120'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode130",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '130'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode132",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '132'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB,historical"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode146",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '146'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode01",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '01'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode09",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '09'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td - Adult Adsorbed"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode22",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '22'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode28",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '28'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DT - Pediatric"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode50",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '50'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode102",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '102'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode106",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '106'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP, 5 pertussis antigens"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode107",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '107'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP, Unspecified Formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode110",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '110'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-HepB-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode113",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '113'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td p-free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode115",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '115'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tdap"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode120",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '120'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode130",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '130'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode132",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '132'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB,historical"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode138",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '138'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td - Adult"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode139",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '139'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td - Adult Unspecified Formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode146",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '146'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode01",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '01'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode09",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '09'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td - Adult Adsorbed"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode22",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '22'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode28",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '28'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DT - Pediatric"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode35",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '35'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "TT"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode50",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '50'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode102",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '102'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode106",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '106'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP, 5 pertussis antigens"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode107",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '107'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP, Unspecified Formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode110",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '110'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-HepB-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode113",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '113'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td p-free"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode115",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '115'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tdap"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode120",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '120'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode130",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '130'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode132",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '132'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB,historical"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode138",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '138'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td - Adult"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode139",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '139'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Td - Adult Unspecified Formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode146",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '146'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode21",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '21'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "089"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Varicella"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode94",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '94'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "089"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MMRV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode121",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '121'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "089"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Zoster"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode62",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '62'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "090"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "4vHPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode118",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '118'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "090"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "2vHPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode137",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '137'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "090"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "HPV Unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode165",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '165'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "090"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "9vHPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode03",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '03'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "091"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MMR"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode04",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '04'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "091"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Measles/Rubella"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode05",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '05'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "091"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Measles"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode94",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '94'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "091"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MMRV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode03",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '03'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "092"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MMR"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode07",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '07'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "092"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Mumps"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode38",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '38'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "092"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rubella/Mumps"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode94",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '94'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "092"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MMRV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode03",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '03'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "093"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MMR"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode04",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '04'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "093"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Measles/Rubella"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode06",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '06'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "093"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rubella"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode38",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '38'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "093"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rubella/Mumps"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode94",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '94'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "093"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MMRV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode133",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '133'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "094"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "PCV13"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode100",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '100'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "094"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "PCV7"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode33",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '33'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "094"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "PPSV23"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode109",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '109'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "094"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pneumococcal, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode152",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '152'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "094"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Pneumococcal Conjugate, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode32",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '32'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal, MPSV4"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode108",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '108'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal ACWY, unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode114",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '114'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal, MCV4P"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode136",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '136'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal, MCV4O"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode147",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '147'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "MCV4, unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode148",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '148'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal C/Y-HIB PRP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode167",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '167'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal, unknown serogroups"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode52",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '52'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "096"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep A, adult"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode83",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '83'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "096"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep A, ped/adol, 2 dose"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode84",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '84'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "096"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep A, ped/adol, 3 dose"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode85",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '85'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "096"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep A, Unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode104",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '104'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "096"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "HepA-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode08",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '08'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep B, Adol/peds"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode42",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '42'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep B, Adol/high risk infant"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode43",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '43'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep B, Adult"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode44",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '44'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep B, Dialysis"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode45",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '45'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hep B, Unspecified Formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode51",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '51'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode102",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '102'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode104",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '104'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "HepA-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode110",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '110'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-HepB-IPV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode132",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '132'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB, historical"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode146",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '146'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode17",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '17'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hib unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode22",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '22'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode46",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '46'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "PRP-D"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode47",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '47'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "HbOC"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode48",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '48'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "PRP-T"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode49",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '49'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "PRP-OMP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode50",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '50'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP/Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode51",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '51'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode102",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '102'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTP-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode120",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '120'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV/Hib"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode132",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '132'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB,historical"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode146",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '146'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "DTaP-IPV-Hib-HepB"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode148",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '148'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hib-MenCY-TT"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode25",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '25'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "099"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Yellow Fever"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode121",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '121'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "100"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Zoster live"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode18",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '18'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "113"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rabies, intramuscular injection"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode40",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '40'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "113"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rabies, intradermal injection"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode90",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '90'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "113"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rabies, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode162",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '162'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "116"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal B, recombinant"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode163",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '163'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "116"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal B, OMV"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode164",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '164'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "116"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Meningococcal B, unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode26",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '26'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "119"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "cholera, unspecified formulation"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode172",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '172'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "119"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "cholera, WC-rBS"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode173",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '173'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "119"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "cholera, BivWC"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode174",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '174'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "119"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "cholera, live attenuated"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode208",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '208'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "122"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "COVID-19, mRNA, LNP-S, PF, 30 mcg/0.3 mL dose"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode13",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '13'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "125"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tetanus immune globulin"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode154",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '154'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "126"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis A immune globulin"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode30",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '30'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "127"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Hepatitis B immune globulin"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode34",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '34'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "128"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Rabies immune globulin"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode36",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '36'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "129"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Varicella zoster immune globulin"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode187",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '187'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "172"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Zoster subunit"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCodenonUS",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'non-US'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "252"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tick-borne encephalitis vaccine"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode222",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '222'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "252"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tick-borne encephalitis, unspecified"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode223",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '223'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "252"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tick-borne encephalitis, inactivated, PF, 0.25mL"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCVXCode224",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = '224'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "252"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Tick-borne encephalitis, inactivated, PF, 0.5mL"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          "name" : "ApplyCDCPHINVSMappings",
          "source" : [
            {
              "context" : "src",
              "element" : "system",
              "variable" : "systemValue",
              "condition" : "systemValue = 'http://phinvads.cdc.gov'"
            }
          ],
          "target" : [
            {
              "context" : "tgt",
              "contextType" : "variable",
              "element" : "code",
              "variable" : "newCC",
              "transform" : "create",
              "parameter" : [
                {
                  "valueString" : "CodeableConcept"
                }
              ]
            }
          ],
          "rule" : [
            {
              "name" : "HandleIndividualCDCPHINVSCoding",
              "source" : [
                {
                  "context" : "src"
                }
              ],
              "target" : [
                {
                  "context" : "newCC",
                  "contextType" : "variable",
                  "element" : "coding",
                  "variable" : "newCoding",
                  "transform" : "create",
                  "parameter" : [
                    {
                      "valueString" : "Coding"
                    }
                  ]
                }
              ],
              "rule" : [
                {
                  "name" : "SetCDCPHINVSCodeVXC27",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC27'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "003"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Immunodeficiency due to any cause"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC21",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC21'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "028"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Previous history of intussusception"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC22",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC22'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "079"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Encephalopathy within 7 days of previous dose of DTP or DTaP"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "080"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "081"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "082"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "083"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "084"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "085"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "086"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "087"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "088"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "089"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "090"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "091"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "092"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "093"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "094"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "095"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "096"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "097"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "098"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "099"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "100"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC18",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC18'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "110"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to baker's yeast [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC17",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC17'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "111"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy [anaphylactic] to 2-phenoxyethanol"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "113"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "116"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "119"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "122"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "172"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                },
                {
                  "name" : "SetCDCPHINVSCodeVXC20",
                  "source" : [
                    {
                      "context" : "src",
                      "element" : "code",
                      "variable" : "codeValue",
                      "condition" : "codeValue = 'VXC20'"
                    }
                  ],
                  "target" : [
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "system",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "code",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "252"
                        }
                      ]
                    },
                    {
                      "context" : "newCoding",
                      "contextType" : "variable",
                      "element" : "display",
                      "transform" : "copy",
                      "parameter" : [
                        {
                          "valueString" : "Allergy to previous dose of this vaccine or to any of its unlisted vaccine components [anaphylactic]"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}

```
