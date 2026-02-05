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
          snomedEntries +=
              '''
      src.code as codeValue where codeValue = '${codedValue.code}' -> 
          newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',
          newCoding.code = '${observation.observationCode}',
          newCoding.display = "${codedValue.text}" "SetSNOMEDCode${codedValue.code}";\n\n''';
        } else if (codedValue.codeSystem == 'CVX') {
          cvxEntries +=
              '''
      src.code as codeValue where codeValue = '${codedValue.code}' -> 
          newCoding.system = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes',
          newCoding.code = '${observation.observationCode}',
          newCoding.display = "${codedValue.text}" "SetCVXCode${codedValue.code}";\n\n''';
        } else if (codedValue.codeSystem == 'CDCPHINVS') {
          phinvadsEntries +=
              '''
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
map "http://fhirfli.dev/fhir/ig/cicada/StructureMap/map-vaccine-codes" = "MapVaccineCodes"

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
  src -> tgt.status = "active" "SetConditionStatus";
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
  src -> tgt.status = "active" "SetProcedureStatus";
  src.code as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyProcedureMappings";
  src -> tgt.onsetDateTime = src.performedDateTime "SetProcedureOnsetDateTime";
  src -> tgt.onsetAge = src.performedAge "SetProcedureOnsetAge";
  src -> tgt.onsetPeriod = src.performedPeriod "SetProcedureOnsetPeriod";
  src -> tgt.onsetRange = src.performedRange "SetProcedureOnsetRange";
  src -> tgt.onsetString = src.performedString "SetProcedureOnsetString";
}

group MapFromImmunization(source src : sourceImmunization, target tgt : targetCondition) {
  src -> tgt.status = "active" "SetImmunizationStatus";
  src.vaccineCode as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyImmunizationMappings";
  src -> tgt.onsetDateTime = src.occurrenceDateTime "SetImmunizationOnsetDateTime";
  src -> tgt.onsetString = src.occurrenceString "SetImmunizationOnsetString";
}

group MapFromMedication(source src : sourceMedication, target tgt : targetCondition) {
  src -> tgt.status = "active" "SetMedicationStatus";
  src.code as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedicationMappings";
}

// TODO(Dokotela): what about medicationReference?
group MapFromMedicationStatement(source src : sourceMedicationStatement, target tgt : targetCondition) {
  src -> tgt.status = "active" "SetMedStatementStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedStatementMappings";
}

group MapFromMedicationRequest(source src : sourceMedicationRequest, target tgt : targetCondition) {
  src -> tgt.status = "active" "SetMedRequestStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedRequestMappings";
  src -> tgt.onsetDateTime = src.authoredOn "SetMedRequestOnsetDateTime";
}

group MapFromMedicationAdministration(source src : sourceMedicationAdministration, target tgt : targetCondition) {
  src -> tgt.status = "active" "SetMedAdminStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedAdminMappings";
  src -> tgt.onsetDateTime = src.effectiveDateTime "SetMedAdminOnsetDateTime";
  src -> tgt.onsetPeriod = src.effectivePeriod "SetMedAdminOnsetPeriod";
}

group MapFromMedicationDispense(source src : sourceMedicationDispense, target tgt : targetCondition) {
  src -> tgt.status = "active" "SetMedDispenseStatus";
  src.medicationCodeableConcept as code -> code.coding as coding then ApplyCommonMappings(coding, tgt) "ApplyMedDispenseMappings";
  src -> tgt.onsetDateTime = src.whenHandedOver "SetMedDispenseOnsetDateTime";
}

group ApplyCommonMappings(source src : Coding, target tgt : targetCondition) {
''';

const fileEnd = '}';
