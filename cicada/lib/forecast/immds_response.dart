import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

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
        final key =
            '${dose.dateGiven}_${groupCvx?.$1 ?? group.vaccineGroupName}';
        if (seen.contains(key)) continue;
        seen.add(key);

        // The Immunization the caller sent for this dose, if we still have it.
        final Immunization? containedImmunization =
            result.patient.immunizations.firstWhereOrNull(
                (Immunization i) => i.id?.toString() == dose.doseId);

        evaluations.add(ImmunizationEvaluation(
          // The ImmDS example carries an id and a profile claim; we carried
          // neither. A consumer that indexes resources by id had nothing to
          // index. The id is derived from the dose so it is stable per dose.
          id: 'eval-${dose.doseId}'.toFhirString,
          meta: FhirMeta(profile: <FhirCanonical>[
            'http://hl7.org/fhir/us/immds/StructureDefinition/immds-immunizationevaluation'
                .toFhirCanonical,
          ]),
          status: ImmunizationEvaluationStatusCodes.completed,
          patient: Reference(reference: patientRef),
          // R4: "The date the evaluation of the vaccine administration event
          // was performed" — the assessment date, not the date of the dose.
          // The ImmDS example agrees: date 2020-05-26 against an immunization
          // that occurred 2020-04-28. We were sending the dose date.
          date: result.patient.assessmentDate.toFhirDateTime(),
          targetDisease: _evalTargetDisease(antigen.targetDisease),
          // The Immunization travels WITH the evaluation, as a contained
          // resource, and immunizationEvent points at it by fragment.
          //
          // R4 ImmunizationEvaluation has no vaccineCode element, so the only
          // way to learn which vaccine a dose was is to dereference
          // immunizationEvent. FITS names the expected evaluation by CVX
          // ("CVX 85, Hep A, unspecified formulation, Valid"), so it has to be
          // doing exactly that. A literal `Immunization/<id>` reference is not
          // resolvable inside an operation response that carries no
          // Immunization resources, and the ImmDS OperationDefinition defines
          // no output parameter for them. Containment is what FHIR provides
          // for a reference that has no independent existence for the reader.
          contained: containedImmunization == null
              ? null
              : <Resource>[containedImmunization],
          immunizationEvent: Reference(
            reference: (containedImmunization != null
                    ? '#${dose.doseId}'
                    : 'Immunization/${dose.doseId}')
                .toFhirString,
          ),
          doseStatus: _mapDoseStatus(dose.evalStatus!),
          doseStatusReason: dose.evalReason != null
              ? [_mapDoseStatusReason(dose.evalReason!)]
              : null,
          series: series.series.seriesName?.toFhirString,
          doseNumberPositiveInt: dose.targetDoseSatisfied >= 0
              ? (dose.targetDoseSatisfied + 1).toFhirPositiveInt
              : null,
          // seriesDoses[x] is a count. The ImmDS example uses
          // seriesDosesPositiveInt; we were sending seriesDosesString, a
          // different choice element, so a reader looking for the integer
          // found nothing. positiveInt cannot be 0, so omit when there are
          // no doses defined.
          seriesDosesPositiveInt: (series.series.seriesDose?.length ?? 0) > 0
              ? series.series.seriesDose!.length.toFhirPositiveInt
              : null,
        ));
      }
    }
  }

  return evaluations;
}

/// Returns a [CodeableConcept] for evaluation targetDisease.
///
/// SNOMED disease codes only.
///
/// R4 defines targetDisease as "the vaccine preventable **disease** the dose is
/// being evaluated against". Its example binding is
/// ValueSet/immunization-evaluation-target-disease, and the ImmDS binding is 43
/// SNOMED disease concepts. Neither contains a CVX code, because a CVX names a
/// vaccine, not a disease.
///
/// This used to emit the vaccine GROUP CVX here, first. That was wrong twice
/// over: it put a vaccine code in a disease element, and the group code is not
/// the product administered. A child given TriHibit (CVX 50) had an evaluation
/// reading CVX 107 "DTaP, unspecified formulation" and CVX 17 "Hib,
/// unspecified", so no reader could tell what was actually given. The product
/// CVX now travels on the contained Immunization, which is the only element
/// R4 gives it, so there is nothing left for a CVX to do here.
CodeableConcept _evalTargetDisease(String targetDisease) {
  final List<Coding> codings = [];
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

  // A vaccine group can carry more than one forecast: FORECASTVG-1 scopes a
  // forecast to a series group, and a group may hold both a standard and a risk
  // series group. Each becomes its own recommendation.
  for (final vgf in result.vaccineGroupForecasts.values
      .expand((List<VaccineGroupForecast> l) => l)) {
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
      // doseNumber[x] is a count, and every HL7 example uses
      // doseNumberPositiveInt. We were stringifying an int into
      // doseNumberString — a different choice element, so a reader looking for
      // the integer found nothing. Same defect as seriesDosesString.
      doseNumberPositiveInt: vgf.status == SeriesStatus.notComplete &&
              (vgf.doseNumber ?? 0) > 0
          ? vgf.doseNumber!.toFhirPositiveInt
          : null,
      description: vgf.antigenNames.length > 1
          ? 'Antigens: ${vgf.antigenNames.join(", ")}'.toFhirString
          : null,
      // The series group this forecast is scoped to (CDSi FORECASTVG-1).
      // Core element: "One possible path to achieve presumed immunity against
      // a disease - within the context of an authority."
      // Only when there genuinely is one series. A multi-antigen group blends
      // several, and `series` is 0..1 and means a path to immunity, not a
      // category — the series GROUP name does not belong here. The coded
      // standard/risk distinction is carried by the extension below instead.
      series: vgf.seriesName?.toFhirString,
      // The patient information that made this series apply: the Condition or
      // Observation carrying the risk indication (CDSi Table 5-4). "Patient
      // Information that supports the status and recommendation."
      supportingPatientInformation: vgf.supportingReferences.isEmpty
          ? null
          : vgf.supportingReferences
              .map((SupportingResource r) => Reference(
                    reference: r.reference?.toFhirString,
                    display: r.display?.toFhirString,
                  ))
              .toList(),
      // Which pathway this recommendation describes. A vaccine group can yield
      // both a standard and a risk recommendation for the same target disease,
      // and nothing in core FHIR or the US ImmDS IG distinguishes them.
      extension_: [
        FhirExtension(
          url:
              'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/series-type-ext'
                  .toFhirString,
          valueCodeableConcept: CodeableConcept(coding: [
            Coding(
              system: 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/series-type'
                  .toFhirUri,
              code: (vgf.isRiskForecast ? 'risk' : 'standard').toFhirCode,
              display: (vgf.isRiskForecast ? 'Risk' : 'Standard').toFhirString,
            ),
          ]),
        ),
      ],
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
/// 1. HL7 THO: `http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status`
///    Codes: valid, notvalid
/// 2. Cicada IG (extraneous only): `http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalStatus`
///    Code: extraneous — no standard exists for this status
///
/// Sub-standard maps to `notvalid` (FHIR's `isSubpotent` on the input
/// Immunization covers the potency distinction).
CodeableConcept _mapDoseStatus(EvalStatus status) {
  const hl7System =
      'http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status';
  const cicadaSystem =
      'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/EvalStatus';

  final String hl7Code = status == EvalStatus.valid ? 'valid' : 'notvalid';
  final String hl7Display = status == EvalStatus.valid ? 'Valid' : 'Not Valid';

  final List<Coding> codings = [
    Coding(
      system: hl7System.toFhirUri,
      code: hl7Code.toFhirCode,
      display: hl7Display.toFhirString,
    ),
  ];

  // Add Cicada-specific code for extraneous (no standard equivalent)
  if (status == EvalStatus.extraneous) {
    codings.add(Coding(
      system: cicadaSystem.toFhirUri,
      code: 'extraneous'.toFhirCode,
      display: 'Extraneous'.toFhirString,
    ));
  }

  return CodeableConcept(coding: codings);
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
  const cdsiSystem = 'http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus';
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
      codings.add(Coding(
          system: hl7System.toFhirUri,
          code: 'complete'.toFhirCode,
          display: 'Complete'.toFhirString));
    case SeriesStatus.immune:
      codings.add(Coding(
          system: hl7System.toFhirUri,
          code: 'immune'.toFhirCode,
          display: 'Immune'.toFhirString));
    case SeriesStatus.contraindicated:
      codings.add(Coding(
          system: hl7System.toFhirUri,
          code: 'contraindicated'.toFhirCode,
          display: 'Contraindicated'.toFhirString));
    case SeriesStatus.notComplete:
      codings.add(Coding(
        system: hl7System.toFhirUri,
        code: isOverdue ? 'overdue'.toFhirCode : 'due'.toFhirCode,
        display: isOverdue ? 'Overdue'.toFhirString : 'Due'.toFhirString,
      ));
    case SeriesStatus.agedOut:
      codings.add(Coding(
          system: hl7System.toFhirUri,
          code: 'agedout'.toFhirCode,
          display: 'Aged Out'.toFhirString));
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
bool _isSentinel(VaxDate date) => date.year <= 1900 || date.year >= 2999;
