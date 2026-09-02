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

/// Names CVX on any coding the caller left without a system.
///
/// A caller may send `vaccineCode` as a bare `<code value="45"/>`; FITS does.
/// R4 gives [ImmunizationEvaluation] no `vaccineCode`, so a reader wanting the
/// vaccine has to follow `immunizationEvent` to the [Immunization], and an
/// unlabelled coding cannot be recognised there as CVX. We resolved this dose's
/// antigens from CVX, so we name the system we already relied on. Fills a blank
/// only; never rewrites a system the caller supplied.
Immunization _withCvxSystem(Immunization immunization) =>
    immunization.copyWith(
      vaccineCode: CodeableConcept(
        text: immunization.vaccineCode.text,
        coding: immunization.vaccineCode.coding
            ?.map((Coding c) => c.system == null
                ? c.copyWith(system: 'http://hl7.org/fhir/sid/cvx'.toFhirUri)
                : c)
            .toList(),
      ),
    );

/// Converts a [ForecastResult] into a FHIR [Parameters] resource conforming
/// to the ImmDS IG `$immds-forecast` operation output.
///
/// Output parameters:
///   - `evaluation` (0..*): [ImmunizationEvaluation] per dose per antigen
///   - `recommendation` (1..1): [ImmunizationRecommendation] with forecast
Parameters buildImmdsResponse(ForecastResult result) {
  final List<ParametersParameter> outParams = [];

  // Echo each administered Immunization back as a top-level parameter.
  //
  // R4 gives ImmunizationEvaluation no vaccineCode, so a reader wanting the
  // vaccine must follow immunizationEvent to the Immunization. In an operation
  // response there is no server to fetch it from, and the ImmDS
  // OperationDefinition declares no output parameter for it, so a literal
  // `Immunization/<id>` reference resolves to nothing. Returning the resources
  // alongside the evaluations gives a resolver something to find.
  //
  // The parameter name mirrors the input parameter (`immunization`), since the
  // operation defines no output name to use.
  for (final Immunization immunization in result.patient.immunizations) {
    if (immunization.id == null) continue;
    // A caller may send vaccineCode as a bare code with no system; FITS does.
    // R4 gives ImmunizationEvaluation no vaccineCode, so a reader wanting the
    // vaccine has to follow immunizationEvent to here, and an unlabelled coding
    // cannot be recognised as CVX. We resolved this dose's antigens from CVX,
    // so name the system we already relied on. Fills a blank only; never
    // rewrites a system the caller supplied.
    outParams.add(ParametersParameter(
      name: 'immunization'.toFhirString,
      resource: _withCvxSystem(immunization),
    ));
  }

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

      for (final dose in series.doses) {
        // Only include doses that were actually evaluated
        if (dose.evalStatus == null) continue;

        // One evaluation per (dose, target disease).
        //
        // This used to de-duplicate on (dose date, vaccine GROUP), on the
        // reasoning that a multi-antigen group like MMR would otherwise
        // produce "duplicate" evaluations for Measles, Mumps and Rubella.
        // They are not duplicates. R4 gives ImmunizationEvaluation a single
        // targetDisease, so an evaluation can speak for exactly one disease,
        // and covering three diseases takes three of them. Measured on one
        // MMR dose: the response carried the recommendation for all three
        // diseases and a single evaluation, for Mumps. A reader asking
        // whether that shot was valid got no answer about measles or rubella.
        // Keyed on the dose, not its date: two doses of the same vaccine on
        // the same day are two administered doses and each deserves its own
        // evaluation. Measured before this change: a request carrying two
        // same-day HepA doses got one evaluation back. (The forecast was
        // right either way — the engine counted one valid dose and asked for
        // dose 2 — so this was a reporting loss, not a counting error.)
        final key = '${dose.doseId}_${antigen.targetDisease}';
        if (seen.contains(key)) continue;
        seen.add(key);

        evaluations.add(ImmunizationEvaluation(
          // The ImmDS example carries an id and a profile claim; we carried
          // neither. A consumer that indexes resources by id had nothing to
          // index. The id is derived from the dose so it is stable per dose.
          // Unique per (dose, disease): one dose evaluated against several
          // antigens produces several evaluations, and they shared this id.
          id: 'eval-${dose.doseId}-${_idToken(antigen.targetDisease)}'
              .toFhirString,
          meta: FhirMeta(profile: <FhirCanonical>[
            'http://hl7.org/fhir/us/immds/StructureDefinition/immds-immunizationevaluation'
                .toFhirCanonical,
          ]),
          status: ImmunizationEvaluationStatusCodes.completed,
          patient: Reference(reference: patientRef),
          // R4: "The date the evaluation of the vaccine administration event
          // was performed" — the assessment date, not the date of the dose.
          // The ImmDS example agrees: date 2020-05-26 against an immunization
          // that occurred 2020-04-28.
          //
          // Measured against NIST FITS 1.4.6: FITS only builds an evaluation
          // candidate when this field equals the dose's administration date.
          // We ran it both ways. Under the dose date every event produced a
          // `[CHECKING AGAINST]` line; under the assessment date events with
          // doses before it produced none. But the candidate FITS then builds
          // carries no vaccine either way, so it matches nothing and the score
          // is 0% under both. The deviation buys nothing, so we send what the
          // specification and the published example say.
          date: result.patient.assessmentDate.toFhirDateTime(),
          targetDisease: _evalTargetDisease(antigen.targetDisease),
          // Literal reference, as all four R4 ImmunizationEvaluation examples
          // use (`Immunization/example`); none uses a fragment. The
          // Immunization it names travels back as its own top-level
          // `immunization` parameter, so the reference resolves within the
          // response.
          //
          // A contained Immunization reached by `#fragment` was tried against
          // NIST FITS 1.4.6 with the date filter satisfied, so the candidate
          // was genuinely built, and the candidate's vaccine was still null.
          // Neither route reaches FITS, so we send the example's form.
          immunizationEvent: Reference(
            reference: 'Immunization/${dose.doseId}'.toFhirString,
          ),
          doseStatus: _mapDoseStatus(dose.evalStatus!),
          // R4 types doseStatusReason 0..*, and CDSi Table 6-31 can set
          // several reasons on one dose. VaxDose.evalReasons is the full set
          // the evaluation worked out, and the suites assert against it; we
          // used to emit only the singular evalReason, so the caller saw one
          // of them. Send all of them, primary first.
          doseStatusReason: () {
            final List<EvalReason> reasons = <EvalReason>[
              if (dose.evalReason != null) dose.evalReason!,
              ...dose.evalReasons.where((EvalReason r) => r != dose.evalReason),
            ];
            return reasons.isEmpty
                ? null
                : reasons.map(_mapDoseStatusReason).toList();
          }(),
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
          extension_: <FhirExtension?>[
            _versionExt(),
            if (series.evaluatedTargetDose[dose.targetDoseSatisfied] != null)
              _targetDoseStatusExt(
                  series.evaluatedTargetDose[dose.targetDoseSatisfied]!),
            _evaluationDetailExt(dose),
          ].whereType<FhirExtension>().toList(),
        ));
      }
    }
  }

  return evaluations;
}

/// A target disease name as a FHIR id token: lower case, non-alphanumerics
/// collapsed to '-'. FHIR ids allow [A-Za-z0-9-.] only, and disease names
/// carry spaces ('Meningococcal B') and hyphens ('COVID-19').
String _idToken(String name) => name
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');

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
  // No CVX here. R4 defines this as the vaccine preventable DISEASE, and
  // both the R4 and ImmDS bindings are SNOMED disease concepts with no CVX
  // in them. A CVX was put here first to feed NIST FITS, which reads
  // `targetDisease.getCoding().get(0).getCode()` as a CVX number; measured,
  // it changed no FITS result, so a vaccine code in a disease element is all
  // it bought.
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

    // vaccineCode is 0..*, bound extensible to US Core CVX. The group code
    // says "some Hep A"; the engine also worked out which products actually
    // satisfy the next target dose (preferableVaccine with
    // forecastVaccineType = Y), and those were being discarded. Group code
    // first, then each specific product.
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
    for (int i = 0; i < vgf.forecastCvxCodes.length; i++) {
      final String cvx = vgf.forecastCvxCodes[i];
      if (groupCvx != null && cvx == groupCvx.$1) continue;
      final String? display = i < vgf.forecastVaccineDescriptions.length
          ? vgf.forecastVaccineDescriptions[i]
          : null;
      vaccineCodeList.add(CodeableConcept(coding: [
        Coding(
          system: 'http://hl7.org/fhir/sid/cvx'.toFhirUri,
          code: cvx.toFhirCode,
          display: display?.toFhirString,
        ),
      ]));
    }

    // contraindicatedVaccineCode is 0..*, same binding. The series removed
    // these products because a vaccine contraindication applied to this
    // patient; saying which ones is the difference between "contraindicated"
    // and a clinician knowing what not to give.
    final List<CodeableConcept> contraindicatedList = vgf.contraindicatedCvxCodes
        .map((String cvx) => CodeableConcept(coding: [
              Coding(
                system: 'http://hl7.org/fhir/sid/cvx'.toFhirUri,
                code: cvx.toFhirCode,
              ),
            ]))
        .toList();

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
      contraindicatedVaccineCode:
          contraindicatedList.isNotEmpty ? contraindicatedList : null,
      forecastStatus: _mapForecastStatus(vgf.status, isOverdue: isOverdue),
      // Why the engine forecast this. The reason was computed on the series
      // and thrown away, so a reader saw "Not Complete, due <date>" with no
      // statement of why, and "Immune" with no statement of what made the
      // patient immune.
      forecastReason: vgf.forecastReason == null
          ? null
          : [_mapForecastReason(vgf.forecastReason!)],
      dateCriterion: dateCriteria.isNotEmpty ? dateCriteria : null,
      // 🛑 doseNumberString, deliberately, do not "fix" this to positiveInt.
      //
      // R4 types this element `doseNumber[x] : positiveInt|string`, so BOTH
      // are conformant, and HL7's examples are explicitly "not a normative
      // part of the specification". Switching to doseNumberPositiveInt was
      // measured against NIST FITS as the ONLY change in a run: every
      // criterion went from scoring to 0%, including Series Status and the
      // dates, so FITS stops reading the recommendation entirely. Reverting it
      // alone restored the scores.
      doseNumberString: vgf.status == SeriesStatus.notComplete
          ? vgf.doseNumber?.toString().toFhirString
          : null,
      // description is 0..1 and unbound. The CDSi supporting data carries
      // administrative guidance per series, which the engine accumulated and
      // never sent. It is written for the person giving the vaccine, so it
      // leads; the antigen list follows it.
      description: () {
        final List<String> parts = <String>[
          if (vgf.administrativeGuidance != null &&
              vgf.administrativeGuidance!.isNotEmpty)
            vgf.administrativeGuidance!,
          if (vgf.antigenNames.length > 1)
            'Antigens: ${vgf.antigenNames.join(", ")}',
        ];
        return parts.isEmpty ? null : parts.join('\n').toFhirString;
      }(),
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
      extension_: <FhirExtension?>[
        _versionExt(),
        _dosesRemainingExt(vgf),
        // The series group this forecast is scoped to (FORECASTVG-1). `series`
        // 0..1 already names the series; core FHIR has nowhere for the group,
        // and it was computed and dropped.
        if (vgf.seriesGroupName != null)
          FhirExtension(
            url:
                'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/series-group-ext'
                    .toFhirString,
            valueString: vgf.seriesGroupName!.toFhirString,
          ),
        // Which antigens in this group actually need the dose. A multi-antigen
        // group forecasts as one recommendation, so without this the caller
        // cannot tell whether all of MMR is due or only the measles component.
        for (final String antigenName in vgf.antigensNeedingDose)
          FhirExtension(
            url:
                'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/antigen-needing-dose-ext'
                    .toFhirString,
            valueString: antigenName.toFhirString,
          ),
        for (final VaxSeries s in vgf.contributingSeries) _seriesDetailExt(s),
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
      ].whereType<FhirExtension>().toList(),
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


const _cicadaSd = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition';
const _cicadaCs = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem';

/// A date sub-extension, dropped when the date is absent or a sentinel.
FhirExtension? _dateExt(String url, VaxDate? date) =>
    date == null || _isSentinel(date)
        ? null
        : FhirExtension(
            url: url.toFhirString, valueDateTime: date.toFhirDateTime());

/// The CDSi target dose status this dose satisfied.
///
/// Chapter 6 evaluates each administered dose against a target dose and
/// records satisfied, not satisfied, or skipped. Only `doseNumber` derived
/// from it was leaving, so a skipped target dose and a satisfied one read the
/// same to a caller.
FhirExtension _targetDoseStatusExt(TargetDoseStatus status) {
  final String code = switch (status) {
    TargetDoseStatus.satisfied => 'satisfied',
    TargetDoseStatus.skipped => 'skipped',
    TargetDoseStatus.notSatisfied => 'not-satisfied',
  };
  return FhirExtension(
    url: '$_cicadaSd/target-dose-status-ext'.toFhirString,
    valueCodeableConcept: CodeableConcept(coding: <Coding>[
      Coding(
        system: '$_cicadaCs/target-dose-status'.toFhirUri,
        code: code.toFhirCode,
        display: status.toString().toFhirString,
      ),
    ]),
  );
}

/// The Chapter 6 sub-step outcomes behind a dose's evaluation.
///
/// `doseStatusReason` carries the coded reasons, of which there are fifteen.
/// The engine knows more than that: which of age, interval, conflict or
/// vaccine choice passed, and for the ones that failed, which rule failed.
/// Returns null when the evaluation recorded nothing beyond the status.
FhirExtension? _evaluationDetailExt(VaxDose dose) {
  FhirExtension boolExt(String url, bool value) => FhirExtension(
      url: url.toFhirString, valueBoolean: value.toFhirBoolean);
  FhirExtension codeExt(String url, String value) => FhirExtension(
      url: url.toFhirString, valueString: value.toFhirString);

  final List<FhirExtension> parts = <FhirExtension>[
    if (dose.inadvertent) boolExt('inadvertent', true),
    if (dose.validAgeReason != null)
      codeExt('validAgeReason', dose.validAgeReason!.toString()),
    if (dose.preferredInterval != null)
      boolExt('preferredInterval', dose.preferredInterval!),
    if (dose.preferredIntervalReason != null)
      codeExt('preferredIntervalReason', dose.preferredIntervalReason!.toString()),
    if (dose.allowedInterval != null)
      boolExt('allowedInterval', dose.allowedInterval!),
    if (dose.allowedIntervalReason != null)
      codeExt('allowedIntervalReason', dose.allowedIntervalReason!.toString()),
    if (dose.conflict != null) boolExt('conflict', dose.conflict!),
    if (dose.conflictReason != null)
      codeExt('conflictReason', dose.conflictReason!),
    if (dose.preferredVaccine != null)
      boolExt('preferredVaccine', dose.preferredVaccine!),
    if (dose.preferredVaccineReason != null)
      codeExt('preferredVaccineReason', dose.preferredVaccineReason!.toString()),
    if (dose.allowedVaccine != null)
      boolExt('allowedVaccine', dose.allowedVaccine!),
    if (dose.allowedVaccineReason != null)
      codeExt('allowedVaccineReason', dose.allowedVaccineReason!.toString()),
  ];

  return parts.isEmpty
      ? null
      : FhirExtension(
          url: '$_cicadaSd/evaluation-detail-ext'.toFhirString,
          extension_: parts,
        );
}

/// One contributing series: its own status, its own four dates, and the
/// component dates that produced them.
///
/// A vaccine group forecast reports the aggregate. Everything here was worked
/// out per series and then merged away, so "due 2027-03-01" arrived with no
/// way to see whether age or interval drove it, and a group covered by several
/// series reported one answer for all of them.
FhirExtension _seriesDetailExt(VaxSeries series) {
  final List<FhirExtension?> parts = <FhirExtension?>[
    if (series.series.seriesName != null)
      FhirExtension(
        url: 'seriesName'.toFhirString,
        valueString: series.series.seriesName!.toFhirString,
      ),
    if (series.series.selectSeries?.seriesGroupName != null)
      FhirExtension(
        url: 'seriesGroupName'.toFhirString,
        valueString: series.series.selectSeries!.seriesGroupName!.toFhirString,
      ),
    FhirExtension(
      url: 'seriesType'.toFhirString,
      valueString:
          (series.series.seriesType == SeriesType.risk ? 'risk' : 'standard')
              .toFhirString,
    ),
    FhirExtension(
      url: 'status'.toFhirString,
      valueCodeableConcept: _mapForecastStatus(series.seriesStatus),
    ),
    if (series.targetDose > 0)
      FhirExtension(
        url: 'targetDoseNumber'.toFhirString,
        valuePositiveInt: series.targetDose.toFhirPositiveInt,
      ),
    _dateExt('earliestDate', series.candidateEarliestDate),
    _dateExt('recommendedDate', series.adjustedRecommendedDate),
    _dateExt('pastDueDate', series.adjustedPastDueDate),
    _dateExt('latestDate', series.latestDate),
    _dateExt('minimumAgeDate', series.minimumAgeDate),
    _dateExt('maximumAgeDate', series.maximumAgeDate),
    _dateExt('earliestRecommendedAgeDate', series.earliestRecommendedAgeDate),
    _dateExt('latestRecommendedAgeDate', series.latestRecommendedAgeDate),
    _dateExt('earliestRecommendedIntervalDate',
        series.earliestRecommendedIntervalDate),
    _dateExt('latestRecommendedIntervalDate',
        series.latestRecommendedIntervalDate),
    _dateExt('seasonalRecommendationStartDate',
        series.seasonalRecommendationStartDate),
  ];

  return FhirExtension(
    url: '$_cicadaSd/series-detail-ext'.toFhirString,
    extension_: parts.whereType<FhirExtension>().toList(),
  );
}

/// Stamps the engine and the supporting-data release onto a response resource.
///
/// A forecast is a function of both, and a stored response that names neither
/// cannot be traced back to what produced it. ICE does the same with
/// `dataSourceType`. Parameters is not a DomainResource and carries no
/// extension, so the stamp goes on each evaluation and on the recommendation.
FhirExtension _versionExt() => FhirExtension(
      url: '$_cicadaSd/engine-version-ext'.toFhirString,
      extension_: <FhirExtension>[
        FhirExtension(
          url: 'engine'.toFhirString,
          valueString: 'cicada/$cicadaEngineVersion'.toFhirString,
        ),
        FhirExtension(
          url: 'supportingData'.toFhirString,
          valueString: 'CDSi $cdsiSupportingDataVersion'.toFhirString,
        ),
      ],
    );

/// Doses left in the series after the one being forecast.
///
/// ICE returns a number of doses remaining, and "Recurring" when the series
/// ends in a recurring dose, which no count can express. seriesDoses and
/// doseNumber let a reader subtract, but they cannot tell them it never ends.
FhirExtension? _dosesRemainingExt(VaccineGroupForecast vgf) {
  if (vgf.contributingSeries.isEmpty) return null;
  final VaxSeries series = vgf.contributingSeries.first;
  final List<SeriesDose> doses =
      series.series.seriesDose ?? const <SeriesDose>[];
  if (doses.isEmpty) return null;

  // `Binary` is ambiguous here: fhir_r4 exports a Binary resource too.
  final bool recurring = doses.last.recurringDose?.toString() == 'Yes';
  if (recurring) {
    return FhirExtension(
      url: '$_cicadaSd/doses-remaining-ext'.toFhirString,
      valueString: 'Recurring'.toFhirString,
    );
  }
  final int? next = vgf.doseNumber;
  if (next == null) return null;
  final int remaining = doses.length - next + 1;
  if (remaining < 0) return null;
  return FhirExtension(
    url: '$_cicadaSd/doses-remaining-ext'.toFhirString,
    valueString: remaining.toString().toFhirString,
  );
}

/// Maps [ForecastReason] to a `recommendation.forecastReason` CodeableConcept.
///
/// Two coding layers, because the ImmDS value set does not cover the engine:
/// 1. `http://hl7.org/fhir/us/immds/CodeSystem/ForecastReason` when one of its
///    five concepts says the same thing. Read first by consumers that know the
///    IG.
/// 2. The cicada CodeSystem always, carrying the precise CDSi reason. The
///    ImmDS binding on this element is **example** strength, so a code from
///    outside the value set is conformant, and four of our eight reasons —
///    evidence of immunity, contraindication, unable to finish before the
///    maximum age, below the minimum age to start — have no ImmDS concept.
///    Dropping them to fit the value set would be losing the answer to keep
///    the vocabulary tidy.
CodeableConcept _mapForecastReason(ForecastReason reason) {
  const immdsSystem = 'http://hl7.org/fhir/us/immds/CodeSystem/ForecastReason';
  const cicadaSystem =
      'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/forecast-reason';

  final (String code, String? immdsCode, String? immdsDisplay) =
      switch (reason) {
    ForecastReason.patientSeriesIsComplete => (
        'series-complete',
        'complete',
        'Complete'
      ),
    ForecastReason.notRecommendedAtThisTimeDueToPastImmunizationHistory => (
        'not-recommended-history',
        'notRecommended',
        'Not Recommended'
      ),
    ForecastReason.patientHasExceededTheMaximumAge => (
        'exceeded-maximum-age',
        'maximumAge',
        'Maximum Age Exceeded'
      ),
    ForecastReason.pastSeasonalRecommendationEndDate => (
        'past-seasonal-end',
        'seasonalPast',
        'Seasonal End Date Passed'
      ),
    ForecastReason.patientHasEvidenceOfImmunity => (
        'evidence-of-immunity',
        null,
        null
      ),
    ForecastReason.patientHasAContraindication => (
        'contraindication',
        null,
        null
      ),
    ForecastReason.patientIsUnableToFinishTheSeriesPriorToTheMaximumAge => (
        'cannot-finish-before-maximum-age',
        null,
        null
      ),
    ForecastReason.patientHasNotReachedTheMinimumAgeToStart => (
        'below-minimum-age-to-start',
        null,
        null
      ),
    ForecastReason.completeForTheSeason => (
        'complete-for-the-season',
        'seasonalComplete',
        'Complete for the Season'
      ),
  };

  return CodeableConcept(
    coding: <Coding>[
      if (immdsCode != null)
        Coding(
          system: immdsSystem.toFhirUri,
          code: immdsCode.toFhirCode,
          display: immdsDisplay?.toFhirString,
        ),
      Coding(
        system: cicadaSystem.toFhirUri,
        code: code.toFhirCode,
        display: reason.toString().toFhirString,
      ),
    ],
    text: reason.toString().toFhirString,
  );
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
