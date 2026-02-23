import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';
import 'forecast.dart';

/// CDC official vaccine group CVX codes.
///
/// Source: https://www2a.cdc.gov/vaccines/iis/iisstandards/vaccines.asp?rpt=vg
/// These are the "CVX for Vaccine Group" codes used in HL7 messages to identify
/// the vaccine group a forecast recommendation applies to.
const _vaccineGroupCvx = <String, (String cvx, String display)>{
  'Cholera': ('26', 'cholera, unspecified formulation'),
  'COVID-19': ('213', 'SARS-COV-2 (COVID-19) vaccine, unspecified'),
  'Dengue': ('330', 'Dengue Fever, unspecified'),
  'DTaP/Tdap/Td': ('107', 'DTaP, unspecified formulation'),
  'Ebola': ('214', 'Ebola, unspecified'),
  'HepA': ('85', 'Hep A, unspecified formulation'),
  'HepB': ('45', 'Hep B, unspecified formulation'),
  'Hib': ('17', 'Hib, unspecified formulation'),
  'HPV': ('137', 'HPV, unspecified formulation'),
  'Influenza': ('88', 'influenza, unspecified formulation'),
  'Japanese Encephalitis': ('129', 'Japanese Encephalitis, unspecified'),
  'Meningococcal': ('108', 'meningococcal, unspecified formulation'),
  'Meningococcal B': ('164', 'meningococcal B, unspecified'),
  'MMR': ('03', 'MMR'),
  'Orthopoxvirus': ('325', 'vaccinia (smallpox, mpox), unspecified'),
  'Pneumococcal': ('152', 'Pneumococcal Conjugate, unspecified formulation'),
  'Polio': ('89', 'polio, unspecified formulation'),
  'Rabies': ('90', 'rabies, unspecified formulation'),
  'Rotavirus': ('122', 'rotavirus, unspecified formulation'),
  'RSV': ('304', 'RSV, unspecified'),
  'TBE': ('222', 'tick-borne encephalitis, unspecified'),
  'Typhoid': ('91', 'typhoid, unspecified formulation'),
  'Varicella': ('21', 'varicella'),
  'Yellow Fever': ('184', 'yellow fever, unspecified formulation'),
  'Zoster': ('188', 'zoster, unspecified formulation'),
};

/// SNOMED CT codes for CDSi target diseases.
const _diseaseSnomedCodes = <String, String>{
  'Cholera': '63650001',
  'COVID-19': '840539006',
  'Dengue': '38362002',
  'Diphtheria': '397430003',
  'Pertussis': '27836007',
  'Tetanus': '76902006',
  'Ebola': '37109004',
  'HepA': '40468003',
  'HepB': '66071002',
  'Hib': '709410003',
  'HPV': '240532009',
  'Influenza': '6142004',
  'Japanese Encephalitis': '52947006',
  'Meningococcal': '23511006',
  'Meningococcal B': '860805006',
  'Measles': '14189004',
  'Mumps': '36989005',
  'Rubella': '36653000',
  'Orthopoxvirus': '359814004',
  'Pneumococcal': '16814004',
  'Polio': '398102009',
  'Rabies': '14168008',
  'Rotavirus': '18624000',
  'RSV': '55735004',
  'TBE': '712986001',
  'Typhoid': '4834000',
  'Varicella': '38907003',
  'Yellow Fever': '16541001',
  'Zoster': '4740000',
};

/// Returns a [CodeableConcept] with SNOMED CT coding and text display for a
/// target disease name.
CodeableConcept _diseaseCodeableConcept(String targetDisease) {
  final snomedCode = _diseaseSnomedCodes[targetDisease];
  if (snomedCode != null) {
    return CodeableConcept(
      coding: [
        Coding(
          system: 'http://snomed.info/sct'.toFhirUri,
          code: snomedCode.toFhirCode,
          display: targetDisease.toFhirString,
        ),
      ],
      text: targetDisease.toFhirString,
    );
  }
  return CodeableConcept(text: targetDisease.toFhirString);
}

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
///
/// De-duplicates by (dateGiven, vaccineGroupCvx) to produce one evaluation per
/// administered dose per vaccine group (multi-antigen groups like MMR would
/// otherwise produce duplicate evaluations for Measles, Mumps, Rubella).
List<ImmunizationEvaluation> _buildEvaluations(ForecastResult result) {
  final List<ImmunizationEvaluation> evaluations = [];
  final patientRef =
      'Patient/${result.patient.patient.id ?? 'unknown'}'.toFhirString;
  final seen = <String>{};

  for (final antigen in result.agMap.values) {
    for (final group in antigen.groups.values) {
      // Use the best/prioritized series for evaluations
      final series = group.prioritizedSeries.isNotEmpty
          ? group.prioritizedSeries.first
          : (group.series.isNotEmpty ? group.series.first : null);
      if (series == null) continue;

      final groupCvx = _vaccineGroupCvx[group.vaccineGroupName];

      for (final dose in series.doses) {
        // Only include doses that were actually evaluated
        if (dose.evalStatus == null) continue;

        // De-duplicate: one evaluation per (dose date, vaccine group)
        final key = '${dose.dateGiven}_${groupCvx?.$1 ?? group.vaccineGroupName}';
        if (seen.contains(key)) continue;
        seen.add(key);

        evaluations.add(ImmunizationEvaluation(
          status: ImmunizationEvaluationStatusCodes.completed,
          patient: Reference(reference: patientRef),
          date: dose.dateGiven.toFhirDateTime(),
          targetDisease: _evalTargetDisease(
              antigen.targetDisease, groupCvx),
          immunizationEvent: Reference(
            reference: 'Immunization/${dose.doseId}'.toFhirString,
          ),
          doseStatus: _mapDoseStatus(dose.evalStatus!),
          doseStatusReason: dose.evalReason != null
              ? [_mapDoseStatusReason(dose.evalReason!)]
              : null,
          series: series.series.seriesName?.toFhirString,
          doseNumberPositiveInt: dose.targetDoseSatisfied >= 0
              ? (dose.targetDoseSatisfied + 1).toFhirPositiveInt
              : null,
          seriesDosesString:
              '${series.series.seriesDose?.length ?? 0}'.toFhirString,
        ));
      }
    }
  }

  return evaluations;
}

/// Returns a [CodeableConcept] for evaluation targetDisease.
///
/// FITS reads `targetDisease.getCoding().get(0).getCode()` as a CVX code,
/// so the vaccine group CVX is placed first. SNOMED disease coding follows
/// for spec-correctness.
CodeableConcept _evalTargetDisease(
    String targetDisease, (String cvx, String display)? groupCvx) {
  final List<Coding> codings = [];
  if (groupCvx != null) {
    codings.add(Coding(
      system: 'http://hl7.org/fhir/sid/cvx'.toFhirUri,
      code: groupCvx.$1.toFhirCode,
      display: groupCvx.$2.toFhirString,
    ));
  }
  final snomedCode = _diseaseSnomedCodes[targetDisease];
  if (snomedCode != null) {
    codings.add(Coding(
      system: 'http://snomed.info/sct'.toFhirUri,
      code: snomedCode.toFhirCode,
      display: targetDisease.toFhirString,
    ));
  }
  return CodeableConcept(
    coding: codings.isNotEmpty ? codings : null,
    text: targetDisease.toFhirString,
  );
}

/// Builds the [ImmunizationRecommendation] resource from vaccine group
/// forecasts.
ImmunizationRecommendation _buildRecommendation(ForecastResult result) {
  final patientRef =
      'Patient/${result.patient.patient.id ?? 'unknown'}'.toFhirString;
  final assessmentDate = result.patient.assessmentDate;
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

    // Build targetDisease with SNOMED coding for each antigen in the group
    final List<Coding> diseaseCodings = [];
    for (final antigenName in vgf.antigenNames) {
      final snomedCode = _diseaseSnomedCodes[antigenName];
      if (snomedCode != null) {
        diseaseCodings.add(Coding(
          system: 'http://snomed.info/sct'.toFhirUri,
          code: snomedCode.toFhirCode,
          display: antigenName.toFhirString,
        ));
      }
    }

    // vaccineCode: single group-level CVX per CDC vaccine group mapping
    final List<CodeableConcept> vaccineCodeList = [];
    final groupCvx = _vaccineGroupCvx[vgf.vaccineGroupName];
    if (groupCvx != null) {
      vaccineCodeList.add(CodeableConcept(coding: [
        Coding(
          system: 'http://hl7.org/fhir/sid/cvx'.toFhirUri,
          code: groupCvx.$1.toFhirCode,
          display: groupCvx.$2.toFhirString,
        ),
      ]));
    }

    // Determine due vs overdue for Not Complete status
    final isOverdue = vgf.status == SeriesStatus.notComplete &&
        vgf.pastDueDate != null &&
        !_isSentinel(vgf.pastDueDate!) &&
        assessmentDate.isAfter(vgf.pastDueDate!);

    recommendations.add(ImmunizationRecommendationRecommendation(
      targetDisease: CodeableConcept(
        coding: diseaseCodings.isNotEmpty ? diseaseCodings : null,
        text: vgf.vaccineGroupName.toFhirString,
      ),
      vaccineCode: vaccineCodeList.isNotEmpty ? vaccineCodeList : null,
      forecastStatus: _mapForecastStatus(vgf.status, isOverdue: isOverdue),
      dateCriterion: dateCriteria.isNotEmpty ? dateCriteria : null,
      doseNumberString: vgf.status == SeriesStatus.notComplete
          ? vgf.doseNumber?.toString().toFhirString
          : null,
      description: vgf.antigenNames.length > 1
          ? 'Antigens: ${vgf.antigenNames.join(", ")}'.toFhirString
          : null,
    ));
  }

  return ImmunizationRecommendation(
    patient: Reference(reference: patientRef),
    date: assessmentDate.toFhirDateTime(),
    recommendation: recommendations,
  );
}

/// Maps [EvalStatus] to the FHIR dose status CodeableConcept.
///
/// Uses two coding layers:
/// 1. CDSi-compatible display text (read first by FITS/testing tools)
/// 2. HL7 standard: `http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status`
///    Codes: valid, notvalid
CodeableConcept _mapDoseStatus(EvalStatus status) {
  const cdsiSystem =
      'http://hl7.org/fhir/us/immds/CodeSystem/EvaluationStatus';
  const hl7System =
      'http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status';

  final String cdsiCode = switch (status) {
    EvalStatus.valid => 'Valid',
    EvalStatus.not_valid => 'Not Valid',
    EvalStatus.extraneous => 'Extraneous',
    EvalStatus.sub_standard => 'Sub standard',
  };
  final String hl7Code = status == EvalStatus.valid ? 'valid' : 'notvalid';
  final String hl7Display = status == EvalStatus.valid ? 'Valid' : 'Not Valid';

  return CodeableConcept(coding: [
    Coding(
      system: cdsiSystem.toFhirUri,
      code: cdsiCode.toFhirCode,
      display: cdsiCode.toFhirString,
    ),
    Coding(
      system: hl7System.toFhirUri,
      code: hl7Code.toFhirCode,
      display: hl7Display.toFhirString,
    ),
  ]);
}

/// Maps [EvalReason] to a FHIR dose status reason CodeableConcept.
///
/// Uses the ImmDS CodeSystem:
/// `http://hl7.org/fhir/us/immds/CodeSystem/StatusReason`
CodeableConcept _mapDoseStatusReason(EvalReason reason) {
  const system = 'http://hl7.org/fhir/us/immds/CodeSystem/StatusReason';
  final (String code, String display) = switch (reason) {
    EvalReason.expired => ('expired', 'Expired Product'),
    EvalReason.ageTooOld => ('tooold', 'Too Old'),
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

/// Maps [SeriesStatus] to a forecast status [CodeableConcept].
///
/// Uses three coding layers:
/// 1. CDSi status text via ImmDS IG CodeSystem — read first by testing tools
///    (FITS parses `getCoding().get(0).getCode()` case-insensitively)
/// 2. HL7 standard: `http://terminology.hl7.org/CodeSystem/immunization-recommendation-status`
///    Codes: due, overdue, immune, contraindicated, complete, agedout
/// 3. LOINC answer list LL940-8 for LOINC 59783-1 "Status in immunization series"
///
/// For [SeriesStatus.notComplete], pass [isOverdue] = true when the assessment
/// date is past the past due date to distinguish `due` from `overdue`.
CodeableConcept _mapForecastStatus(SeriesStatus status,
    {bool isOverdue = false}) {
  const cdsiSystem =
      'http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus';
  const hl7System =
      'http://terminology.hl7.org/CodeSystem/immunization-recommendation-status';
  const loincSystem = 'http://loinc.org';

  final List<Coding> codings = [];

  // Primary: CDSi-compatible status text (parsed by FITS/testing tools)
  final String cdsiCode = switch (status) {
    SeriesStatus.complete => 'Complete',
    SeriesStatus.notComplete => 'Not Complete',
    SeriesStatus.immune => 'Immune',
    SeriesStatus.contraindicated => 'Contraindicated',
    SeriesStatus.agedOut => 'Aged Out',
    SeriesStatus.notRecommended => 'Not Recommended',
  };
  codings.add(Coding(
    system: cdsiSystem.toFhirUri,
    code: cdsiCode.toFhirCode,
    display: cdsiCode.toFhirString,
  ));

  // Secondary: HL7 standard code (where a standard code exists)
  switch (status) {
    case SeriesStatus.complete:
      codings.add(Coding(system: hl7System.toFhirUri,
          code: 'complete'.toFhirCode, display: 'Complete'.toFhirString));
    case SeriesStatus.immune:
      codings.add(Coding(system: hl7System.toFhirUri,
          code: 'immune'.toFhirCode, display: 'Immune'.toFhirString));
    case SeriesStatus.contraindicated:
      codings.add(Coding(system: hl7System.toFhirUri,
          code: 'contraindicated'.toFhirCode,
          display: 'Contraindicated'.toFhirString));
    case SeriesStatus.notComplete:
      codings.add(Coding(
        system: hl7System.toFhirUri,
        code: isOverdue ? 'overdue'.toFhirCode : 'due'.toFhirCode,
        display: isOverdue ? 'Overdue'.toFhirString : 'Due'.toFhirString,
      ));
    case SeriesStatus.agedOut:
      codings.add(Coding(system: hl7System.toFhirUri,
          code: 'agedout'.toFhirCode, display: 'Aged Out'.toFhirString));
    case SeriesStatus.notRecommended:
      break; // No HL7 standard code exists
  }

  // Tertiary: LOINC answer list LL940-8 (LOINC 59783-1)
  final (String laCode, String laDisplay) = switch (status) {
    SeriesStatus.complete => ('LA13421-5', 'Complete'),
    SeriesStatus.notComplete =>
      isOverdue ? ('LA13423-1', 'Overdue') : ('LA13422-3', 'On schedule'),
    SeriesStatus.immune => ('LA27183-5', 'Immune'),
    SeriesStatus.contraindicated => ('LA4216-3', 'Contraindicated'),
    SeriesStatus.notRecommended => ('LA4695-8', 'Not Recommended'),
    SeriesStatus.agedOut => ('LA13424-9', 'Too old'),
  };
  codings.add(Coding(
    system: loincSystem.toFhirUri,
    code: laCode.toFhirCode,
    display: laDisplay.toFhirString,
  ));

  return CodeableConcept(coding: codings);
}

/// Returns true if the date is a VaxDate sentinel (min or max boundary).
bool _isSentinel(VaxDate date) =>
    date.year <= 1900 || date.year >= 2999;
