import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';
import 'forecast.dart';

/// Converts a [ForecastResult] into a FHIR [Parameters] resource conforming
/// to the ImmDS IG `$immds-forecast` operation output.
///
/// Output parameters:
///   - `evaluation` (0..*): [ImmunizationEvaluation] per dose per antigen
///   - `recommendation` (1..1): [ImmunizationRecommendation] with forecast
Parameters buildImmdsResponse(ForecastResult result) {
  final List<ParametersParameter> outParams = [];

  // Build ImmunizationEvaluation resources (one per evaluated dose per series)
  final evaluations = _buildEvaluations(result);
  for (final eval in evaluations) {
    outParams.add(ParametersParameter(
      name: 'evaluation'.toFhirString,
      resource: eval,
    ));
  }

  // Build ImmunizationRecommendation resource (one per patient)
  final recommendation = _buildRecommendation(result);
  outParams.add(ParametersParameter(
    name: 'recommendation'.toFhirString,
    resource: recommendation,
  ));

  return Parameters(parameter: outParams);
}

/// Builds [ImmunizationEvaluation] resources from all evaluated doses across
/// all antigens and series.
List<ImmunizationEvaluation> _buildEvaluations(ForecastResult result) {
  final List<ImmunizationEvaluation> evaluations = [];
  final patientRef =
      'Patient/${result.patient.patient.id ?? 'unknown'}'.toFhirString;

  for (final antigen in result.agMap.values) {
    for (final group in antigen.groups.values) {
      // Use the best/prioritized series for evaluations
      final series = group.prioritizedSeries.isNotEmpty
          ? group.prioritizedSeries.first
          : (group.series.isNotEmpty ? group.series.first : null);
      if (series == null) continue;

      for (final dose in series.doses) {
        // Only include doses that were actually evaluated
        if (dose.evalStatus == null) continue;

        evaluations.add(ImmunizationEvaluation(
          status: ImmunizationEvaluationStatusCodes.completed,
          patient: Reference(reference: patientRef),
          date: result.patient.assessmentDate.toFhirDateTime(),
          targetDisease: CodeableConcept(
            text: antigen.targetDisease.toFhirString,
          ),
          immunizationEvent: Reference(
            reference: 'Immunization/${dose.doseId}'.toFhirString,
          ),
          doseStatus: _mapDoseStatus(dose.evalStatus!),
          doseStatusReason: dose.evalReason != null
              ? [_mapDoseStatusReason(dose.evalReason!)]
              : null,
          series: series.series.seriesName?.toFhirString,
          doseNumberString:
              '${dose.targetDoseSatisfied + 1}'.toFhirString,
          seriesDosesString:
              '${series.series.seriesDose?.length ?? 0}'.toFhirString,
        ));
      }
    }
  }

  return evaluations;
}

/// Builds the [ImmunizationRecommendation] resource from vaccine group
/// forecasts.
ImmunizationRecommendation _buildRecommendation(ForecastResult result) {
  final patientRef =
      'Patient/${result.patient.patient.id ?? 'unknown'}'.toFhirString;
  final List<ImmunizationRecommendationRecommendation> recommendations = [];

  for (final vgf in result.vaccineGroupForecasts.values) {
    final List<ImmunizationRecommendationDateCriterion> dateCriteria = [];

    // Earliest date (LOINC 30981-5)
    if (vgf.earliestDate != null && !_isSentinel(vgf.earliestDate!)) {
      dateCriteria.add(ImmunizationRecommendationDateCriterion(
        code: CodeableConcept(coding: [
          Coding(
            system: 'http://loinc.org'.toFhirUri,
            code: '30981-5'.toFhirCode,
            display: 'Earliest date to give'.toFhirString,
          ),
        ]),
        value: vgf.earliestDate!.toFhirDateTime(),
      ));
    }

    // Recommended date (LOINC 30980-7)
    if (vgf.recommendedDate != null && !_isSentinel(vgf.recommendedDate!)) {
      dateCriteria.add(ImmunizationRecommendationDateCriterion(
        code: CodeableConcept(coding: [
          Coding(
            system: 'http://loinc.org'.toFhirUri,
            code: '30980-7'.toFhirCode,
            display: 'Date vaccine due'.toFhirString,
          ),
        ]),
        value: vgf.recommendedDate!.toFhirDateTime(),
      ));
    }

    // Past due date (LOINC 59778-1)
    if (vgf.pastDueDate != null && !_isSentinel(vgf.pastDueDate!)) {
      dateCriteria.add(ImmunizationRecommendationDateCriterion(
        code: CodeableConcept(coding: [
          Coding(
            system: 'http://loinc.org'.toFhirUri,
            code: '59778-1'.toFhirCode,
            display: 'Date when overdue for immunization'.toFhirString,
          ),
        ]),
        value: vgf.pastDueDate!.toFhirDateTime(),
      ));
    }

    // Latest date (LOINC 59777-3)
    if (vgf.latestDate != null && !_isSentinel(vgf.latestDate!)) {
      dateCriteria.add(ImmunizationRecommendationDateCriterion(
        code: CodeableConcept(coding: [
          Coding(
            system: 'http://loinc.org'.toFhirUri,
            code: '59777-3'.toFhirCode,
            display: 'Latest date to give immunization'.toFhirString,
          ),
        ]),
        value: vgf.latestDate!.toFhirDateTime(),
      ));
    }

    recommendations.add(ImmunizationRecommendationRecommendation(
      targetDisease: CodeableConcept(
        text: vgf.vaccineGroupName.toFhirString,
      ),
      forecastStatus: _mapForecastStatus(vgf.status),
      dateCriterion: dateCriteria.isNotEmpty ? dateCriteria : null,
      description: vgf.antigenNames.length > 1
          ? 'Antigens: ${vgf.antigenNames.join(", ")}'.toFhirString
          : null,
    ));
  }

  return ImmunizationRecommendation(
    patient: Reference(reference: patientRef),
    date: result.patient.assessmentDate.toFhirDateTime(),
    recommendation: recommendations,
  );
}

/// Maps [EvalStatus] to the FHIR dose status CodeableConcept.
///
/// Uses the HL7 terminology CodeSystem:
/// `http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status`
CodeableConcept _mapDoseStatus(EvalStatus status) {
  const system =
      'http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status';
  switch (status) {
    case EvalStatus.valid:
      return CodeableConcept(coding: [
        Coding(
          system: system.toFhirUri,
          code: 'valid'.toFhirCode,
          display: 'Valid'.toFhirString,
        ),
      ]);
    case EvalStatus.not_valid:
    case EvalStatus.extraneous:
    case EvalStatus.sub_standard:
      return CodeableConcept(coding: [
        Coding(
          system: system.toFhirUri,
          code: 'notvalid'.toFhirCode,
          display: 'Not Valid'.toFhirString,
        ),
      ]);
  }
}

/// Maps [EvalReason] to a FHIR dose status reason CodeableConcept.
///
/// Uses the ImmDS CodeSystem:
/// `http://hl7.org/fhir/us/immds/CodeSystem/StatusReason`
CodeableConcept _mapDoseStatusReason(EvalReason reason) {
  const system = 'http://hl7.org/fhir/us/immds/CodeSystem/StatusReason';
  final (String code, String display) = switch (reason) {
    EvalReason.expired => ('expired', 'Expired Product'),
    EvalReason.ageTooOld => ('toold', 'Too Old'),
    EvalReason.ageTooYoung => ('tooyoung', 'Too Young'),
    EvalReason.inadvertentVaccine => ('inappropriate', 'Inappropriate Vaccine'),
    EvalReason.notPreferableOrAllowable => (
        'inappropriate',
        'Not a Preferable or Allowable Vaccine'
      ),
    EvalReason.notRecommendedVolume => ('quantity', 'Quantity'),
    EvalReason.partialDose => ('quantity', 'Partial Dose'),
    EvalReason.coldChainBreak => ('storage', 'Cold Chain Break'),
    EvalReason.recall => ('recall', 'Manufacturer Recall'),
    EvalReason.adverseStorage => ('storage', 'Adverse Storage'),
    EvalReason.intervalTooShort => ('toosoon', 'Too Soon'),
    EvalReason.liveVirusConflict => ('productconflict', 'Product Conflict'),
    EvalReason.seriesAlreadyCompleted => (
        'notevaluated',
        'Series Already Completed'
      ),
    EvalReason.noDateGiven => ('notevaluated', 'No Date Given'),
    EvalReason.noCvx => ('notevaluated', 'No CVX Code'),
  };

  return CodeableConcept(coding: [
    Coding(
      system: system.toFhirUri,
      code: code.toFhirCode,
      display: display.toFhirString,
    ),
  ]);
}

/// Maps [SeriesStatus] to the ImmDS forecast status CodeableConcept.
///
/// Uses the ImmDS CodeSystem:
/// `http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus`
CodeableConcept _mapForecastStatus(SeriesStatus status) {
  const system = 'http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus';
  final (String code, String display) = switch (status) {
    SeriesStatus.complete => ('complete', 'Complete'),
    SeriesStatus.notComplete => ('notComplete', 'Not Complete'),
    SeriesStatus.immune => ('immune', 'Immune'),
    SeriesStatus.contraindicated => ('contraindicated', 'Contraindicated'),
    SeriesStatus.notRecommended => ('notRecommended', 'Not Recommended'),
    SeriesStatus.agedOut => ('agedOut', 'Aged Out'),
  };

  return CodeableConcept(coding: [
    Coding(
      system: system.toFhirUri,
      code: code.toFhirCode,
      display: display.toFhirString,
    ),
  ]);
}

/// Returns true if the date is a VaxDate sentinel (min or max boundary).
bool _isSentinel(VaxDate date) =>
    date.year <= 1900 || date.year >= 2999;
