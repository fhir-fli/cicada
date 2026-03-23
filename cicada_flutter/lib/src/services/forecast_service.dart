import 'package:cicada/cicada.dart';
import 'package:cicada_flutter/src/models/entered_dose.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:fhir_r4/fhir_r4.dart';

/// Builds FHIR Parameters from user input and runs the cicada forecast engine.
class ForecastService {
  /// Run the forecast and return the raw [ForecastResult] for rich display.
  static ForecastResult runForecast({
    required PatientInfo patientInfo,
    required List<EnteredDose> doses,
  }) {
    final parameters = _buildParameters(patientInfo, doses);
    return evaluateForForecast(parameters);
  }

  /// Build a FHIR [Parameters] resource from user-entered data.
  static Parameters _buildParameters(
    PatientInfo info,
    List<EnteredDose> doses,
  ) {
    final params = <ParametersParameter>[
      ParametersParameter(
        name: 'assessmentDate'.toFhirString,
        valueDate: FhirDate.fromDateTime(info.effectiveAssessmentDate),
      ),
      ParametersParameter(
        name: 'patient'.toFhirString,
        resource: Patient(
          id: 'demo-patient'.toFhirString,
          birthDate: FhirDate.fromDateTime(info.birthDate),
          gender: info.sex == PatientSex.male
              ? AdministrativeGender.male
              : AdministrativeGender.female,
        ),
      ),
    ];

    // Immunization resources
    for (var i = 0; i < doses.length; i++) {
      final dose = doses[i];
      params.add(
        ParametersParameter(
          name: 'immunization'.toFhirString,
          resource: Immunization(
            id: 'dose-$i'.toFhirString,
            status: ImmunizationStatusCodes.completed,
            patient: Reference(
              reference: 'Patient/demo-patient'.toFhirString,
            ),
            vaccineCode: CodeableConcept(
              coding: [
                Coding(
                  system: 'http://hl7.org/fhir/sid/cvx'.toFhirUri,
                  code: dose.cvx.toFhirCode,
                ),
              ],
            ),
            occurrenceX: FhirDateTime.fromDateTime(dose.dateGiven),
          ),
        ),
      );
    }

    return Parameters(parameter: params);
  }
}
