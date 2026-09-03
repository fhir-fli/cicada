import 'dart:io';

import 'package:cicada/cicada.dart';

Future<void> main() async {
  final VaxObservations? observations = scheduleSupportingData.observations;
  String snomedEntries = '';
  String cvxEntries = '';
  String phinvadsEntries = '';
  for (final observation in observations?.observation ?? <VaxObservation>[]) {
    if (observation.codedValues != null) {
      for (final CodedValue codedValue
          in observation.codedValues?.codedValue ?? <CodedValue>[]) {
        if (codedValue.codeSystem == 'SNOMED') {
          snomedEntries += '''
      src.code as codeValue where codeValue = '${codedValue.code}' -> 
          newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',
          newCoding.code = '${observation.observationCode}',
          newCoding.display = "${codedValue.text}" "SetSNOMEDCode${codedValue.code}";\n\n''';
        } else if (codedValue.codeSystem == 'CVX') {
          cvxEntries += '''
      src.code as codeValue where codeValue = '${codedValue.code}' -> 
          newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',
          newCoding.code = '${observation.observationCode}',
          newCoding.display = "${codedValue.text}" "SetCVXCode${codedValue.code}";\n\n''';
        } else if (codedValue.codeSystem == 'CDCPHINVS') {
          phinvadsEntries += '''
      src.code as codeValue where codeValue = '${codedValue.code}' -> 
          newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',
          newCoding.code = '${observation.observationCode}',
          newCoding.display = "${codedValue.text}" "SetCDCPHINVSCode${codedValue.code}";\n\n''';
        }
      }
    }
  }
  entries += '''
  src.system as systemValue where systemValue = 'http://snomed.info/sct' -> tgt.code = create('CodeableConcept') as newCC then {
    src -> newCC.coding = create('Coding') as newCoding then {''';
  entries += snomedEntries;
  entries += '''
    } "HandleIndividualSNOMEDCoding";
  } "ApplySNOMEDMappings";\n\n''';
  entries += '''
  src.system as systemValue where systemValue = 'http://hl7.org/fhir/sid/cvx' -> tgt.code = create('CodeableConcept') as newCC then {
    src -> newCC.coding = create('Coding') as newCoding then {''';
  entries += cvxEntries;
  entries += '''
    } "HandleIndividualCVXCoding";
  } "ApplyCVXMappings";\n\n''';
  entries += '''
  src.system as systemValue where systemValue = 'http://phinvads.cdc.gov' -> tgt.code = create('CodeableConcept') as newCC then {
    src -> newCC.coding = create('Coding') as newCoding then {''';
  entries += phinvadsEntries;
  entries += '''
    } "HandleIndividualCDCPHINVSCoding";
  } "ApplyCDCPHINVSMappings";\n''';
  entries += fileEnd;
  await File(
    'lib/generated_files/vaccine_observation_codes_map.map',
  ).writeAsString(entries);
}

String entries = '''
map "http://fhirfli.dev/fhir/ig/cicada/StructureMap/MapVaccineCodes" = "MapVaccineCodes"

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

group MapToVaccineConditionObservation(source src, target tgt : targetCondition) {
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
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetObservationStatus";
  src.code as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyObsMappingsCoding";
  } "ApplyObsMappings";
  src -> tgt.onset = src.effectiveDateTime "SetObsOnsetDateTime";
  src -> tgt.onset = src.effectivePeriod "SetObsOnsetPeriod";
  src -> tgt.onset = src.effectiveInstant "SetObsOnsetInstant";
}

group MapFromCondition(source src : sourceCondition, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetConditionStatus";
  src.code as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyCondMappingsCoding";
  } "ApplyCondMappings";
  src -> tgt.onset = src.onsetDateTime "SetCondOnsetDateTime";
  src -> tgt.onset = src.onsetAge "SetCondOnsetAge";
  src -> tgt.onset = src.onsetPeriod "SetCondOnsetPeriod";
  src -> tgt.onset = src.onsetRange "SetCondOnsetRange";
  src -> tgt.onset = src.onsetString "SetCondOnsetString";
  src -> tgt.abatement = src.abatementDateTime "SetCondAbatementDateTime";
  src -> tgt.abatement = src.abatementAge "SetCondAbatementAge";
  src -> tgt.abatement = src.abatementPeriod "SetCondAbatementPeriod";
  src -> tgt.abatement = src.abatementRange "SetCondAbatementRange";
  src -> tgt.abatement = src.abatementString "SetCondAbatementString";
}

group MapFromProcedure(source src : sourceProcedure, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetProcedureStatus";
  src.code as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyProcedureMappingsCoding";
  } "ApplyProcedureMappings";
  src -> tgt.onset = src.performedDateTime "SetProcedureOnsetDateTime";
  src -> tgt.onset = src.performedAge "SetProcedureOnsetAge";
  src -> tgt.onset = src.performedPeriod "SetProcedureOnsetPeriod";
  src -> tgt.onset = src.performedRange "SetProcedureOnsetRange";
  src -> tgt.onset = src.performedString "SetProcedureOnsetString";
}

group MapFromImmunization(source src : sourceImmunization, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetImmunizationStatus";
  src.vaccineCode as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyImmunizationMappingsCoding";
  } "ApplyImmunizationMappings";
  src -> tgt.onset = src.occurrenceDateTime "SetImmunizationOnsetDateTime";
  src -> tgt.onset = src.occurrenceString "SetImmunizationOnsetString";
}

group MapFromMedication(source src : sourceMedication, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetMedicationStatus";
  src.code as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyMedicationMappingsCoding";
  } "ApplyMedicationMappings";
}

// TODO(Dokotela): what about medicationReference?
group MapFromMedicationStatement(source src : sourceMedicationStatement, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetMedStatementStatus";
  src.medication as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyMedStatementMappingsCoding";
  } "ApplyMedStatementMappings";
}

group MapFromMedicationRequest(source src : sourceMedicationRequest, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetMedRequestStatus";
  src.medication as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyMedRequestMappingsCoding";
  } "ApplyMedRequestMappings";
  src -> tgt.onset = src.authoredOn "SetMedRequestOnsetDateTime";
}

group MapFromMedicationAdministration(source src : sourceMedicationAdministration, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetMedAdminStatus";
  src.medication as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyMedAdminMappingsCoding";
  } "ApplyMedAdminMappings";
  src -> tgt.onset = src.effectiveDateTime "SetMedAdminOnsetDateTime";
  src -> tgt.onset = src.effectivePeriod "SetMedAdminOnsetPeriod";
}

group MapFromMedicationDispense(source src : sourceMedicationDispense, target tgt : targetCondition) {
  src -> tgt.clinicalStatus = cc('http://terminology.hl7.org/CodeSystem/condition-clinical', 'active') "SetMedDispenseStatus";
  src.medication as code then {
    code.coding as coding -> tgt then ApplyCommonMappings(coding, tgt) "ApplyMedDispenseMappingsCoding";
  } "ApplyMedDispenseMappings";
  src -> tgt.onset = src.whenHandedOver "SetMedDispenseOnsetDateTime";
}

group ApplyCommonMappings(source src, target tgt : targetCondition) {
''';

const fileEnd = '}';
