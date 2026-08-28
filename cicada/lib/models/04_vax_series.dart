import 'package:collection/collection.dart';

import '../cicada.dart';

class VaxSeries {
  VaxSeries({
    required this.targetDisease,
    required this.series,
    required this.assessmentDate,
    required this.dob,
  });

  VaxDose? get lastCompleted {
    final int index = evaluatedDoses
        .lastIndexWhere((VaxDose element) => element.targetDoseSatisfied != -1);
    return index == -1 ? null : evaluatedDoses[index];
  }

  VaxDose? get currentDose =>
      doses.isEmpty ? null : doses[evaluatedDoses.length];

  /// Chapter 6 step 5a: a satisfied *recurring* target dose is followed by "a
  /// new target dose identical to the current target dose", so the collection
  /// does not advance past it; any other satisfied target dose moves on.
  void updateTargetDose(SeriesDose seriesDose) {
    if (seriesDose.recurringDose != Binary.yes) {
      targetDose++;
    }
  }

  void evaluate() {
    setUnsatisfiedDoses();
    if (doses.isNotEmpty) {
      indexDoses();
      evaluateSeriesDoses();
      markExtraneousDoses();
    }
    _recordSeriesGroupCompletion();
  }

  /// Publishes this series group's 'Complete' status at the end of evaluation.
  ///
  /// Table 6-7 asks whether the conditional skip's series group contains a
  /// relevant patient series with a patient series status of 'Complete'. A
  /// conditional skip whose `context` is `Both` is asked during evaluation as
  /// well as during forecasting, so that status has to exist by the time
  /// evaluation runs; it was previously written only in [determineForecastNeed],
  /// which runs after every antigen is evaluated, leaving the condition unable
  /// to be met during the evaluation pass at all.
  ///
  /// A patient series is 'Complete' when every target dose is satisfied, which
  /// is what is tested here.
  void _recordSeriesGroupCompletion() {
    final bool anyNotSatisfied = evaluatedTargetDose.values
        .any((TargetDoseStatus s) => s == TargetDoseStatus.notSatisfied);
    final bool anySatisfied = evaluatedTargetDose.values
        .any((TargetDoseStatus s) => s == TargetDoseStatus.satisfied);
    if (!anyNotSatisfied && anySatisfied) {
      seriesGroupCompletion[targetDisease]?[seriesGroupKey] = true;
      final VaxDate? completedOn = lastCompleted?.dateGiven;
      if (completedOn != null) {
        seriesGroupCompletionDate[targetDisease]?[seriesGroupKey] = completedOn;
      }
    }
  }

  /// Per Figure 4-6 / Step 6b: any dose that was never matched to a target
  /// dose should be marked extraneous.
  void markExtraneousDoses() {
    for (final VaxDose dose in doses) {
      if (dose.evalStatus == null) {
        dose.evalStatus = EvalStatus.extraneous;
        dose.evalReason = EvalReason.seriesAlreadyCompleted;
      }
    }
  }

  void setUnsatisfiedDoses() {
    for (int i = targetDose; i < (series.seriesDose?.length ?? 0); i++) {
      evaluatedTargetDose[i] = TargetDoseStatus.notSatisfied;
    }
  }

  void indexDoses() {
    for (int i = 0; i < doses.length; i++) {
      doses[i].index = i;
      doses[i].observations = observations;
    }
  }

  /// Chapter 6 steps 2-6: walk the target dose collection, evaluating the
  /// next unevaluated dose against each in turn. Step 5a keeps a satisfied
  /// recurring target dose in play, which is the inner loop.
  void evaluateSeriesDoses() {
    for (final SeriesDose seriesDose in series.seriesDose ?? <SeriesDose>[]) {
      if (evaluatedDoses.length == doses.length) {
        break;
      } else {
        evaluateNextDose(seriesDose);
        // For recurring doses (e.g., Influenza), keep matching additional
        // doses against the same target dose instead of moving on.
        if (seriesDose.recurringDose == Binary.yes) {
          int prev = -1;
          while (prev != evaluatedDoses.length &&
              evaluatedDoses.length < doses.length) {
            prev = evaluatedDoses.length;
            evaluateNextDose(seriesDose);
          }
        }
      }
    }
  }

  /// Chapter 6 step 2: take the next antigen administered record that has not
  /// yet been evaluated, in ascending date order.
  void evaluateNextDose(SeriesDose seriesDose) {
    for (int i = evaluatedDoses.length; i < doses.length; i++) {
      final VaxDose dose = doses[i];
      if (dose.evalStatus != null) {
        continue;
      } else {
        if (evaluateDose(seriesDose, dose)) {
          break;
        }
      }
    }
  }

  bool evaluateDose(SeriesDose seriesDose, VaxDose dose) {
    if (canSkipDose(seriesDose, dose)) {
      markDoseSkipped(seriesDose);
      return true;
    }

    if (evaluateDoseValidity(seriesDose, dose)) {
      markDoseValid(seriesDose, dose);
      return true;
    }

    return false;
  }

  /// Chapter 6 step 3: the conditional skip is evaluated against the current
  /// target dose, before the dose is evaluated against it. Recurring doses are
  /// not exempt — the recurring check is step 5, which happens *after*
  /// evaluation and only for a target dose that was satisfied, and step 5a
  /// makes the new target dose "identical to the current target dose",
  /// conditional skip included.
  ///
  /// An unconditional `recurringDose == yes -> false` used to sit here. It had
  /// no rule behind it and no case depended on it: removing it left the suite
  /// at 28 failures with an identical set.
  bool canSkipDose(SeriesDose seriesDose, VaxDose dose) {
    return canSkip(seriesDose, SkipContext.evaluation, dose.dateGiven);
  }

  void markDoseSkipped(SeriesDose seriesDose) {
    evaluatedTargetDose[targetDose] = TargetDoseStatus.skipped;
    updateTargetDose(seriesDose);
  }

  /// Records which component of step 6 decided this dose, for the trace.
  ///
  /// A dose that fails to count towards a series is the hardest thing to
  /// diagnose from the outside: the series simply reports one target dose
  /// fewer, and every later step inherits that. [verdict] names the component
  /// that decided it — age, interval, vaccine type — so the trace says which.
  void _traceDose(VaxDose dose, String verdict) => ForecastTrace.current?.log(
        '6 dose evaluation',
        '$targetDisease / ${series.seriesName}',
        'dose=${dose.doseId} given=${dose.dateGiven} '
            'targetDose=${targetDose + 1} $verdict',
      );

  bool evaluateDoseValidity(SeriesDose seriesDose, VaxDose dose) {
    final bool inadvertent = dose.isInadvertent(seriesDose);
    if (inadvertent) {
      _traceDose(dose, 'not counted: inadvertent');
      return false;
    }

    // Per Table 6-31: evaluate ALL remaining components, then combine.
    // 6.4 Evaluate Age
    final bool ageOk = dose.isValidByAge(seriesDose.age, targetDose);

    // 6.5/6.6 Evaluate Interval (preferable then allowable)
    final bool preferableOk = dose.evaluatePreferableInterval(
        seriesDose.preferableInterval, doses, targetDose);
    final bool allowableOk = preferableOk
        ? true
        : dose.evaluateAllowableInterval(
            seriesDose.allowableInterval, doses, targetDose);
    final bool intervalOk = preferableOk || allowableOk;

    if (!ageOk && !intervalOk) {
      // Both fail. Table 6-31 sets the status "with evaluation reasons",
      // plural, and defines no precedence between them, so none is imposed
      // here — the dose carries every reason that applies (VaxDose.evalReasons)
      // and evalReason reports one of them.
      _traceDose(dose, 'not counted: age and interval both fail');
      return false;
    }

    // Age-only failure
    if (!ageOk) {
      _traceDose(dose, 'not counted: age');
      return false;
    }

    // Interval-only failure
    if (!intervalOk) {
      dose.evalStatus ??= EvalStatus.not_valid;
      dose.evalReason ??= EvalReason.intervalTooShort;
      _traceDose(dose, 'not counted: interval');
      return false;
    }

    // 6.7 Evaluate Live Virus Conflict
    if (dose.isLiveVirusConflict(doses, allPatientDoses: allPatientDoses)) {
      _traceDose(dose, 'not counted: live virus conflict');
      return false;
    }

    // 6.8/6.9 Evaluate Vaccine Type (preferable then allowable)
    if (dose.isPreferredType(seriesDose.preferableVaccine, dob)) {
      _traceDose(dose, 'counted: preferable vaccine');
      return true;
    }
    final bool allowedType = dose.isAllowedType(seriesDose.allowableVaccine, dob);
    _traceDose(
        dose,
        allowedType
            ? 'counted: allowable vaccine'
            : 'not counted: vaccine type is neither preferable nor allowable');
    return allowedType;
  }

  /// Table 6-31: the target dose is satisfied and the evaluation status is
  /// 'Valid'. Step 4a then pushes on to the next target dose.
  void markDoseValid(SeriesDose seriesDose, VaxDose dose) {
    dose.evalStatus = EvalStatus.valid;
    dose.targetDoseSatisfied = targetDose;
    evaluatedDoses.add(dose);
    evaluatedTargetDose[targetDose] = TargetDoseStatus.satisfied;
    updateTargetDose(seriesDose);
  }

  void forecast(
    List<VaccineContraindication> vaccineContraindications,
    bool evidenceOfImmunity,
  ) {
    /// A series carrying a minimum age to start cannot be *started* by a
    /// patient younger than that age, and so must not recommend anything —
    /// but only while it is still unstarted.
    ///
    /// The engine honoured the maximum age to start but never its counterpart,
    /// which arrived with the CDSi 4.61 supporting data. Each series group is
    /// its own [VaxGroup], so "RSV 75 years+ 1-dose series" (minimum age to
    /// start 50 years) had no sibling to lose to and forecast unopposed: a
    /// five-day-old with cystic fibrosis was told to come back at her birth
    /// date plus 75 years. The same gate appears on pneumococcal, HPV, rabies,
    /// meningococcal B and cholera series.
    ///
    /// A patient who already holds a valid dose in the series has started it,
    /// whatever their age now, and the remaining doses must still be
    /// forecast. Gating those too dropped the dates of a series the engine
    /// had itself selected as the best patient series, so the group answered
    /// "Not Complete" with no dates at all: a first Heplisav-B at 18 years
    /// minus 4 days (`2018-0019`, the dose valid on the four-day grace
    /// period, series minimum age to start 18 years) and a PPSV23 at 47 in
    /// the "Pneumococcal 50+" series (`2024-0102`, minimum age to start 50
    /// years, next dose due at the 50th birthday).
    ///
    /// A series the patient cannot start is not a series they are on, so it
    /// must also stop representing them: leaving the status at the default
    /// "Not Complete" let step 8.14 pick the *unstartable* series as the best
    /// patient series and report its status for the whole vaccine group. An
    /// eight-month-old had aged out of the infant RSV series, but the "RSV 75
    /// years+" series in the other series group still read Not Complete, so
    /// the group answered Not Complete where CDSi says Aged Out
    /// (`2023-0034`). Not Recommended is dismissed by 8.14 the same way Aged
    /// Out is, which leaves the aged-out infant series to speak for the group.
    final String? minAgeToStart = series.selectSeries?.minAgeToStart;
    if (minAgeToStart != null &&
        evaluatedDoses.isEmpty &&
        assessmentDate < dob.change(minAgeToStart)) {
      shouldRecieveAnotherDose = false;
      seriesStatus = SeriesStatus.notRecommended;
      forecastReason = ForecastReason.patientHasNotReachedTheMinimumAgeToStart;
      return;
    }

    evaluateConditionalSkip(assessmentDate: assessmentDate);
    determineContraindications(
        vaccineContraindications: vaccineContraindications);
    determineForecastNeed(evidenceOfImmunity);
    ForecastTrace.current?.log(
      '7 forecast need',
      '$targetDisease / ${series.seriesName}',
      'type=${series.seriesType} status=$seriesStatus '
          'another=$shouldRecieveAnotherDose reason=$forecastReason',
    );
    if (shouldRecieveAnotherDose) {
      int currentTargetDose = -1;
      while (currentTargetDose != targetDose) {
        // When conditional skip advanced targetDose on a previous
        // iteration, recompute candidateEarliestDate for the new
        // target dose's age and interval requirements.
        if (currentTargetDose != -1) {
          _computeCandidateEarliestDate();
          if (!shouldRecieveAnotherDose) break;
        }
        generateForecast();
        currentTargetDose = targetDose;
        evaluateConditionalSkip(assessmentDate: candidateEarliestDate);
      }
      ForecastTrace.current?.log(
        '7 forecast dates',
        '$targetDisease / ${series.seriesName}',
        'targetDose=$targetDose earliest=$candidateEarliestDate '
            'recommended=$adjustedRecommendedDate '
            'pastDue=$adjustedPastDueDate',
      );
    }
  }

  void evaluateConditionalSkip({VaxDate? assessmentDate}) {
    assessmentDate ??= VaxDate.now();
    while (targetDose < (series.seriesDose?.length ?? 0)) {
      final SeriesDose seriesDose = series.seriesDose![targetDose];

      // Don't overwrite already satisfied doses — advance past them
      if (evaluatedTargetDose[targetDose] == TargetDoseStatus.satisfied) {
        // Chapter 6 step 5a: satisfying a recurring target dose inserts a new
        // target dose identical to it, so the collection does not advance —
        // that is the `break` below. The skip is still asked, because the new
        // target dose carries the same conditional skip, and it is what says
        // whether the patient is done for this period (e.g. a seasonal dose
        // already given).
        if (seriesDose.recurringDose == Binary.yes) {
          if (canSkip(seriesDose, SkipContext.forecast, assessmentDate)) {
            targetDose++;
            continue;
          } else {
            break;
          }
        }
        targetDose++;
        continue;
      }

      /// Normal skip check, except this time for forecast
      if (canSkip(seriesDose, SkipContext.forecast, assessmentDate)) {
        evaluatedTargetDose[targetDose] = TargetDoseStatus.skipped;
        targetDose++;
      } else {
        break;
      }
    }
  }

  /// Table 6-11: can the target dose be skipped? A conditional skip applies in
  /// the context it declares — evaluation, forecast, or both.
  bool canSkip(
          SeriesDose seriesDose, SkipContext skipContext, VaxDate evalDate) =>
      seriesDose.conditionalSkip?.any((ConditionalSkip conditionalSkip) =>
          (conditionalSkip.context == SkipContext.both ||
              conditionalSkip.context == skipContext) &&
          evaluateSkipCondition(conditionalSkip, skipContext, evalDate)) ??
      false;

  /// Table 6-11: how many sets were met, against the skip's set logic.
  bool evaluateSkipCondition(ConditionalSkip conditionalSkip,
      SkipContext skipContext, VaxDate evalDate) {
    final bool andLogic = conditionalSkip.setLogic?.toLowerCase() == 'and';
    final List<bool> results = conditionalSkip.set_
            ?.map((VaxSet set) => skipSet(set, skipContext, evalDate))
            .toList() ??
        <bool>[];
    return andLogic
        ? results.every((bool res) => res)
        : results.any((bool res) => res);
  }

  /// Table 6-10: is the conditional skip set met? How many conditions were
  /// met, against the set's condition logic.
  bool skipSet(VaxSet set_, SkipContext skipContext, VaxDate evalDate) {
    final bool andLogic = set_.conditionLogic?.toLowerCase() == 'and';
    final List<bool> conditionResults = set_.condition
            ?.map((VaxCondition condition) =>
                evaluateCondition(condition, evalDate, set_, skipContext))
            .toList() ??
        <bool>[];
    return andLogic
        ? conditionResults.every((bool res) => res)
        : conditionResults.any((bool res) => res);
  }

  /// Dispatch by conditional skip condition type: Table 6-6 age, Table 6-7
  /// completed series, Table 6-8 interval, Table 6-9 vaccine count.
  bool evaluateCondition(VaxCondition condition, VaxDate evalDate, VaxSet set_,
      SkipContext skipContext) {
    switch (condition.conditionType?.toLowerCase()) {
      case 'age':
        return skipByAge(condition, evalDate);
      case 'completed series':
        return skipByCompletedSeries(condition, evalDate);
      case 'interval':
        return skipByInterval(condition, evalDate);
      case 'vaccine count by age':
        return skipByCount(condition, dob, true, evalDate, skipContext);
      case 'vaccine count by date':
        return skipByCount(
            condition, evalDate, false, evalDate, skipContext);
      case 'vaccine count by date and age':
        return skipByCountDateAndAge(condition, evalDate, skipContext);
      default:
        return false;
    }
  }

  bool skipByAge(VaxCondition condition, VaxDate evalDate) {
    final VaxDate conditionalSkipBeginAgeDate =
        dob.changeNullable(condition.beginAge, false)!;

    final VaxDate conditionalSkipEndAgeDate =
        dob.changeNullable(condition.endAge, true)!;

    return evalDate >= conditionalSkipBeginAgeDate &&
        evalDate < conditionalSkipEndAgeDate;
  }

  /// ⚠️ DELIBERATE DEVIATION from the literal text of Table 6-7, kept because
  /// the literal reading is clinically wrong. Decided 2026-08-28. Reported to
  /// CDC; see CDSI-OE-QUERIES.md section 13.
  ///
  /// Table 6-7 asks only: "Does the Conditional Skip Series Group identify a
  /// Series Group with at least one relevant patient series with a patient
  /// series status of 'Complete'?" Present tense, no date. The Conditional Skip
  /// Reference Date of CONDSKIP-2 is consumed by Table 6-6 (Age) and Table 6-8
  /// (Interval) and by nothing else.
  ///
  /// We answer it as of [evalDate] anyway: when evaluating a dose given in the
  /// past, the question is what was true on the date that dose was given, not
  /// on the date the evaluation is being run. Table 6-7 omitting the reference
  /// date its sibling conditions carry is a drafting mistake.
  ///
  /// Only this reading satisfies both governing cases. A dialysis patient's
  /// four HepB doses must all count toward the risk series even though the
  /// standard group completed part way through them (`2024-UC-0019`) — ACIP
  /// keeps a separate 4-dose hemodialysis schedule as a distinct special
  /// situation (MMWR 72(6)). And a lab worker's single adult polio booster,
  /// given decades after he finished the childhood series, must not seed a
  /// fresh risk series as its dose 1 (`2016-UC-0133`). An end-state reading
  /// gets the second right and the first wrong.
  ///
  /// The end-state flag remains the fallback where no completion date is known,
  /// which is completion recorded during the forecast pass, where there is no
  /// satisfying dose to date it by.
  bool skipByCompletedSeries(VaxCondition condition, VaxDate evalDate) {
    final VaxDate? completedOn =
        seriesGroupCompletionDate[targetDisease]?[condition.seriesGroups];
    if (completedOn != null) {
      return evalDate >= completedOn;
    }
    return seriesGroupCompletion[targetDisease]?[condition.seriesGroups] ??
        false;
  }

  bool skipByInterval(VaxCondition condition, VaxDate evalDate) {
    if (targetDose == 0) {
      return false;
    } else {
      final VaxDate conditionalSkipIntervalDate =
          lastCompleted!.dateGiven.changeNullable(condition.interval, true)!;
      return evalDate >= conditionalSkipIntervalDate;
    }
  }

  bool skipByCountDateAndAge(
      VaxCondition condition, VaxDate referenceDate, SkipContext skipContext) {
    final VaxDate? startDate = condition.startDate == null
        ? dob.changeNullable(condition.beginAge, false)
        : VaxDate.fromString(condition.startDate!, true);
    final VaxDate? endDate = condition.endDate == null
        ? dob.changeNullable(condition.endAge, true)
        : VaxDate.fromString(condition.endDate!);
    final VaxDate? ageEndDate = dob.changeNullable(condition.endAge, true);
    final List<int> types = parseTypes(condition.vaccineTypes);
    final int totalCount = countVaccinesDateAndAge(
        types, startDate, endDate, ageEndDate, condition.doseType,
        referenceDate, skipContext);
    return evaluateCountLogic(
        totalCount, condition.doseCountLogic, condition.doseCount);
  }

  /// The doses a conditional skip counts, per CONDSKIP-1.
  ///
  /// CONDSKIP-1 counts *the patient's vaccine doses administered* — not the
  /// doses this series happens to have evaluated — where the vaccine type is
  /// one of the conditional skip vaccine types, the date administered falls
  /// inside the skip's age and date windows, and the evaluation status is
  /// 'Valid' when the dose type is 'Valid' or any status when it is 'Total'.
  ///
  /// This used to widen to all patient doses only while forecasting; while
  /// evaluating it saw just this series' own evaluated doses. So an asplenic
  /// child's two infant Hib doses could not satisfy "2 or more doses before 12
  /// months" (`2016-UC-0061`): they had failed the risk series' own 12-month
  /// minimum age, so the series had evaluated neither and counted 0.
  ///
  /// Two bounds keep it honest, and both are load-bearing — measured, each one
  /// alone is worse than doing nothing:
  ///
  /// - **The antigen.** Table 6-9: where a condition names no vaccine types,
  ///   "any vaccine valid for the antigen is permitted". `allPatientDoses` is
  ///   every dose the patient ever had, so without this a Hib or pneumococcal
  ///   skip counts their DTaP, HepB and polio doses too. An earlier attempt
  ///   without this filter broke 11 cases.
  /// - **The reference date**, which CONDSKIP-2 defines as the date
  ///   administered of the dose being evaluated, or the assessment date when
  ///   forecasting. Counting doses given after it means deciding whether to
  ///   skip a dose using doses that did not exist yet. Unbounded — antigen
  ///   filter and all — that broke 21 cases while fixing 1.
  ///
  /// Forecasting is unaffected: there the reference date is the assessment
  /// date, so every past dose still counts, as it did before.
  ///
  /// A 'Valid' count still comes from this series' evaluated doses: "valid"
  /// has no meaning except with respect to a patient series.
  List<VaxDose> conditionalSkipSource(List<int> types, DoseType? doseType,
      VaxDate referenceDate, SkipContext skipContext) {
    if (doseType != DoseType.total || allPatientDoses.isEmpty) {
      return evaluatedDoses;
    }
    final bool evaluating = skipContext == SkipContext.evaluation;
    return allPatientDoses
        .where((VaxDose dose) =>
            (evaluating
                ? dose.dateGiven < referenceDate
                : dose.dateGiven <= referenceDate) &&
            (types.isNotEmpty ||
                dose.antigens.any((String antigen) =>
                    antigen.toLowerCase() == targetDisease.toLowerCase())))
        .toList();
  }

  /// CONDSKIP-1 with both an age window and a date window (Table 6-9).
  int countVaccinesDateAndAge(List<int> types, VaxDate? startDate,
      VaxDate? endDate, VaxDate? ageEndDate, DoseType? doseType,
      VaxDate referenceDate, SkipContext skipContext) {
    final List<VaxDose> source =
        conditionalSkipSource(types, doseType, referenceDate, skipContext);
    return source
        .where((VaxDose dose) =>
            (types.isEmpty || types.contains(dose.cvxAsInt)) &&
            (startDate == null || dose.dateGiven >= startDate) &&
            (endDate == null || dose.dateGiven <= endDate) &&
            (ageEndDate == null || dose.dateGiven < ageEndDate) &&
            (doseType == DoseType.total ||
                (doseType == DoseType.valid &&
                    dose.evalStatus == EvalStatus.valid)))
        .length;
  }

  /// Table 6-9: vaccine count by age, or by date.
  bool skipByCount(VaxCondition condition, VaxDate refDate, bool byAge,
      VaxDate referenceDate, SkipContext skipContext) {
    final VaxDate? startDate = byAge
        ? dob.changeNullable(condition.beginAge, false)
        : condition.startDate == null
            ? null
            : VaxDate.fromString(condition.startDate!, true);
    final VaxDate? endDate = byAge
        ? dob.changeNullable(condition.endAge, true)
        : condition.endDate == null
            ? null
            : VaxDate.fromString(condition.endDate!);
    final List<int> types = parseTypes(condition.vaccineTypes);
    final int totalCount = countVaccines(types, startDate, endDate,
        condition.doseType, referenceDate, skipContext);
    return evaluateCountLogic(
        totalCount, condition.doseCountLogic, condition.doseCount);
  }

  List<int> parseTypes(String? vaccineTypes) {
    return vaccineTypes
            ?.split(';')
            .map((String e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toList() ??
        <int>[];
  }

  /// CONDSKIP-1: the count of conditional doses administered.
  int countVaccines(List<int> types, VaxDate? startDate, VaxDate? endDate,
      DoseType? doseType, VaxDate referenceDate, SkipContext skipContext) {
    final List<VaxDose> source =
        conditionalSkipSource(types, doseType, referenceDate, skipContext);
    return source
        .where((VaxDose dose) =>
            (types.isEmpty || types.contains(dose.cvxAsInt)) &&
            (startDate == null || dose.dateGiven >= startDate) &&
            (endDate == null || dose.dateGiven <= endDate) &&
            (doseType == DoseType.total ||
                (doseType == DoseType.valid &&
                    dose.evalStatus == EvalStatus.valid)))
        .length;
  }

  /// Table 6-9: the dose count logic — greater than, equal to, or less than
  /// the conditional skip dose count.
  bool evaluateCountLogic(
      int actualCount, String? logic, String? requiredCountStr) {
    final int requiredCount = int.tryParse(requiredCountStr ?? '0') ?? 0;
    switch (logic?.toLowerCase()) {
      case 'greater':
        return actualCount > requiredCount;
      case 'greater than':
        return actualCount > requiredCount;
      case 'less':
        return actualCount < requiredCount;
      case 'less than':
        return actualCount < requiredCount;
      case 'equal':
      case 'equal to':
        return actualCount == requiredCount;
      default:
        throw Exception('Invalid count logic');
    }
  }

  /// Filter ages by effectiveDate/cessationDate range.
  /// Returns only ages whose date range covers [date].
  List<VaxAge> _filterAges(List<VaxAge>? ages, VaxDate date) {
    if (ages == null || ages.isEmpty) return <VaxAge>[];
    final List<VaxAge> filtered = ages
        .where((VaxAge a) =>
            VaxDate.fromNullableString(a.effectiveDate) <= date &&
            date <= VaxDate.fromNullableString(a.cessationDate, true))
        .toList();
    // If only one age entry and no effectiveDate/cessationDate, it always
    // applies (common case: most antigens have a single age entry).
    if (filtered.isEmpty && ages.length == 1) return ages;
    return filtered;
  }

  /// Filter intervals by effectiveDate/cessationDate range.
  /// Returns only intervals whose date range covers [date].
  List<Interval> _filterIntervals(List<Interval>? intervals, VaxDate date) {
    if (intervals == null || intervals.isEmpty) return <Interval>[];
    final List<Interval> filtered = intervals
        .where((Interval i) =>
            VaxDate.fromNullableString(i.effectiveDate) <= date &&
            date <= VaxDate.fromNullableString(i.cessationDate, true))
        .toList();
    // If only one interval entry with no effectiveDate/cessationDate,
    // it always applies.
    if (filtered.isEmpty && intervals.length == 1) return intervals;
    return filtered;
  }

  /// Get the last dose with evalStatus Valid or Not Valid (not inadvertent).
  /// This is the correct reference dose per CALCDTINT-1.
  VaxDose? _getLastValidOrNotValidDose() {
    for (int i = doses.length - 1; i >= 0; i--) {
      final VaxDose d = doses[i];
      if (!d.inadvertent &&
          (d.evalStatus == EvalStatus.valid ||
              d.evalStatus == EvalStatus.not_valid)) {
        return d;
      }
    }
    return null;
  }

  /// Get reference dose date for a forecast interval.
  /// Mirrors VaxDose.getReferenceDate() but operates at series level for
  /// forecast context (includes not_valid doses per CALCDTINT-1).
  VaxDate? _getReferenceDateForForecast(Interval interval) {
    if (interval.fromPrevious == 'Y') {
      // Last dose with evalStatus Valid or Not Valid, not inadvertent
      return _getLastValidOrNotValidDose()?.dateGiven;
    } else if (interval.fromTargetDose != null) {
      return doses
          .firstWhereOrNull((VaxDose d) =>
              d.targetDoseSatisfied == interval.fromTargetDose! - 1)
          ?.dateGiven;
    } else if (interval.fromMostRecent != null) {
      final List<int> types = interval.mostRecent ?? <int>[];
      return doses
          .lastWhereOrNull((VaxDose d) =>
              types.contains(d.cvxAsInt) &&
              !d.inadvertent &&
              (d.evalStatus == EvalStatus.valid ||
                  d.evalStatus == EvalStatus.not_valid))
          ?.dateGiven;
    } else if (interval.fromRelevantObs != null) {
      // CALCDTINT-9: Use observation date of the most recent active patient
      // observation matching the fromRelevantObs code.
      return _getObservationDateForForecast(interval.fromRelevantObs);
    }
    return null;
  }

  /// Per CALCDTINT-9: Get the observation date from the most recent active
  /// patient observation matching the given observation code.
  VaxDate? _getObservationDateForForecast(ObservationCode? relevantObs) {
    if (relevantObs == null) return null;
    final int? obsIndex = observations.codesAsInt
        ?.indexWhere((int element) => element == relevantObs.codeAsInt);
    if (obsIndex == null || obsIndex == -1) return null;
    final VaxObservation obs = observations.observation![obsIndex];
    // Use period.start (the date the observation occurred), fallback to end
    if (obs.period?.start != null && obs.period!.start!.valueDateTime != null) {
      return VaxDate.fromDateTime(obs.period!.start!.valueDateTime!);
    }
    if (obs.period?.end != null && obs.period!.end!.valueDateTime != null) {
      return VaxDate.fromDateTime(obs.period!.end!.valueDateTime!);
    }
    return null;
  }

  /// Compute candidateEarliestDate for the current targetDose.
  /// Per CDSi Section 7.1: takes the latest of minimum age date, minimum
  /// interval dates, forecast conflict end dates, seasonal recommendation
  /// start date, inadvertent administration dates, and most recent dose date.
  /// Called by determineForecastNeed() and again in forecast() when
  /// conditional skip advances targetDose.
  void _computeCandidateEarliestDate() {
    if (targetDose >= (series.seriesDose?.length ?? 0)) return;
    final SeriesDose seriesDose = series.seriesDose![targetDose];

    // Filter ages by effectiveDate/cessationDate
    final List<VaxAge> filteredAges =
        _filterAges(seriesDose.age, assessmentDate);

    final VaxDate maximumAgeDate = filteredAges.firstOrNull?.maxAge == null
        ? VaxDate.max()
        : dob.change(filteredAges.first.maxAge!);

    if (assessmentDate >= maximumAgeDate) {
      shouldRecieveAnotherDose = false;
      seriesStatus = SeriesStatus.agedOut;
      forecastReason = ForecastReason.patientHasExceededTheMaximumAge;
      return;
    }

    /// The candidate earliest date must be the latest of the following dates:
    /// • Minimum age date
    candidateEarliestDate = filteredAges.firstOrNull?.minAge == null
        ? dob
        : dob.change(filteredAges.first.minAge!);

    // Filter intervals by effectiveDate/cessationDate
    final List<Interval> filteredIntervals =
        _filterIntervals(seriesDose.preferableInterval, assessmentDate);

    /// • Latest of all minimum interval dates
    /// Per CALCDTINT-1: reference dose includes Valid or Not Valid
    /// (not inadvertent). Each interval resolves its own reference
    /// via fromPrevious/fromTargetDose/fromMostRecent.
    for (final Interval interval in filteredIntervals) {
      final VaxDate? refDate = _getReferenceDateForForecast(interval);
      if (refDate != null && interval.minInt != null) {
        final VaxDate intervalDate = refDate.change(interval.minInt!);
        candidateEarliestDate = candidateEarliestDate! > intervalDate
            ? candidateEarliestDate
            : intervalDate;
      }
    }

    /// • Latest of all forecast conflict end dates
    /// Per CDSi Section 7.1: check ALL patient doses for cross-antigen
    /// live virus conflicts, not just doses in the current series.
    _applyLiveVirusConflictDates(seriesDose);

    /// • Seasonal recommendation start date
    final VaxDate seasonalRecommendationStartDate = VaxDate.fromNullableString(
        seriesDose.seasonalRecommendation?.startDate);
    candidateEarliestDate =
        candidateEarliestDate! > seasonalRecommendationStartDate
            ? candidateEarliestDate
            : seasonalRecommendationStartDate;

    /// • Latest of all dates administered of any inadvertent administration
    final VaxDate lastDateInadvertentAdministered = doses
            .lastWhereOrNull((VaxDose element) =>
                element.evalReason == EvalReason.inadvertentVaccine)
            ?.dateGiven ??
        VaxDate.min();
    candidateEarliestDate =
        candidateEarliestDate! > lastDateInadvertentAdministered
            ? candidateEarliestDate
            : lastDateInadvertentAdministered;

    /// • Date administered of the most recent vaccine dose
    ///   administered (Valid or Not Valid, not inadvertent)
    final VaxDate lastDateAdministered =
        _getLastValidOrNotValidDose()?.dateGiven ?? VaxDate.min();
    candidateEarliestDate = candidateEarliestDate! > lastDateAdministered
        ? candidateEarliestDate
        : lastDateAdministered;

    /// • Minimum age date (using filtered ages)
    final VaxDate minimumAgeDate =
        dob.changeNullable(filteredAges.firstOrNull?.minAge, false)!;
    candidateEarliestDate = candidateEarliestDate! > minimumAgeDate
        ? candidateEarliestDate
        : minimumAgeDate;

    /// If the candidateEarliestDate is after or the same as the
    /// maximum age date
    if (candidateEarliestDate! >= maximumAgeDate) {
      shouldRecieveAnotherDose = false;
      seriesStatus = SeriesStatus.agedOut;
      forecastReason =
          ForecastReason.patientIsUnableToFinishTheSeriesPriorToTheMaximumAge;
    } else {
      shouldRecieveAnotherDose = true;
      seriesStatus = SeriesStatus.notComplete;
    }
  }

  /// Apply live virus conflict dates from ALL patient doses to
  /// candidateEarliestDate. Per CDSi Section 7.1, the forecast conflict
  /// check considers all vaccine doses administered to the patient,
  /// not just doses in the current series.
  /// Note: allPatientDoses are the original dose objects (not evaluated
  /// copies), so we don't filter by evalStatus — any administered dose
  /// can cause a live virus conflict for forecast purposes.
  void _applyLiveVirusConflictDates(SeriesDose seriesDose) {
    final List<VaxDose> dosesToCheck =
        allPatientDoses.isNotEmpty ? allPatientDoses : doses;
    for (int i = dosesToCheck.length - 1; i >= 0; i--) {
      final VaxDose dose = dosesToCheck[i];
      final List<LiveVirusConflict>? liveVirusConflicts = activeScheduleData
          .liveVirusConflicts?.liveVirusConflict
          ?.where((LiveVirusConflict element) =>
              element.previous?.cvxAsInt == dose.cvxAsInt)
          .toList();
      if (liveVirusConflicts?.isNotEmpty ?? false) {
        for (final LiveVirusConflict conflict in liveVirusConflicts!) {
          final Vaccine? preferredConflict = seriesDose.preferableVaccine
              ?.firstWhereOrNull((Vaccine element) =>
                  element.cvxAsInt == conflict.current?.cvxAsInt);
          if (preferredConflict != null &&
              conflict.conflictEndInterval != null) {
            final VaxDate forecastConflictEndDate =
                dose.dateGiven.change(conflict.conflictEndInterval!);
            candidateEarliestDate =
                candidateEarliestDate! > forecastConflictEndDate
                    ? candidateEarliestDate
                    : forecastConflictEndDate;
          }
        }
      }
    }
  }

  /// Tables 7-5 and 7-6: does the antigen or vaccine contraindication apply to
  /// the patient? Table 7-7 then makes the patient series contraindicated.
  void determineContraindications({
    VaxDate? assessmentDate,
    required List<VaccineContraindication> vaccineContraindications,
  }) {
    if (targetDose != series.seriesDose?.length) {
      assessmentDate ??= VaxDate.now();
      // Work on copies so we don't mutate the original supporting data.
      final List<Vaccine> preferableVaccines =
          series.seriesDose?[targetDose].preferableVaccine?.toList() ??
              <Vaccine>[];
      final List<Vaccine> allowableVaccines =
          series.seriesDose?[targetDose].allowableVaccine?.toList() ??
              <Vaccine>[];

      /// Check each of the contraindications (we already ensured they apply
      /// to the patient in a previous step)
      final List<VaxObservation> currentObservations =
          observations.observation?.toList() ?? <VaxObservation>[];
      // TODO(Dokotela): if there's no date associated with an observation, do
      // we assume it's active and apply it? Currently, we do.
      /// We check and see which of the patient's observations are applicable for
      /// the given assessmentDate
      currentObservations.retainWhere((VaxObservation element) =>
          VaxDate.fromNullableDateTime(
                  element.period?.start?.valueDateTime, false) <=
              assessmentDate! &&
          assessmentDate <
              VaxDate.fromNullableDateTime(
                  element.period?.end?.valueDateTime, true));

      /// Get the list of the ints associated with the observations
      final List<int> obsInts = currentObservations
          .map((VaxObservation e) => e.codeAsInt ?? -1)
          .toList();
      obsInts.removeWhere((int element) => element == -1);

      /// We remove any contraindications that are not applicable, by ensuring that
      /// their code appears in the list of current observations of the patient
      final Iterable<VaccineContraindication> currentContraindications =
          vaccineContraindications.where((VaccineContraindication element) =>
              obsInts.contains(element.codeAsInt));
      final Set<Vaccine> contraindicatedVaccines = currentContraindications
          .expand((VaccineContraindication element) =>
              element.contraindicatedVaccine ?? <Vaccine>[])
          .toSet();

      for (final Vaccine vaccineContraindication in contraindicatedVaccines) {
        /// If the dates are appropriate to apply to a patient, we note that
        /// this dose is contraindicated, and stop checking
        if (dob.changeNullable(vaccineContraindication.beginAge, false)! <=
                assessmentDate &&
            assessmentDate <
                dob.changeNullable(vaccineContraindication.endAge, true)!) {
          preferableVaccines.removeWhere((Vaccine element) =>
              element.cvxAsInt == vaccineContraindication.cvxAsInt);
          allowableVaccines.removeWhere((Vaccine element) =>
              element.cvxAsInt == vaccineContraindication.cvxAsInt);
          // Series is only contraindicated when ALL usable vaccines
          // (preferable + allowable) are removed.
          if (preferableVaccines.isEmpty && allowableVaccines.isEmpty) {
            isContraindicated = true;
            break;
          }
        }
      }
    }
  }

  void determineForecastNeed(bool evidenceOfImmunity) {
    /// if there is evidence of immunity
    if (evidenceOfImmunity || seriesStatus == SeriesStatus.immune) {
      shouldRecieveAnotherDose = false;
      seriesStatus = SeriesStatus.immune;
      forecastReason = ForecastReason.patientHasEvidenceOfImmunity;
    } else

    /// If the series is contraindicated
    if (isContraindicated || seriesStatus == SeriesStatus.contraindicated) {
      shouldRecieveAnotherDose = false;
      seriesStatus = SeriesStatus.contraindicated;
      forecastReason = ForecastReason.patientHasAContraindication;
    } else {
      /// does the patient have at least one target dose status of 'Not Satisfied'
      final TargetDoseStatus? notSatisfied = evaluatedTargetDose.values
          .firstWhereOrNull((TargetDoseStatus element) =>
              element == TargetDoseStatus.notSatisfied);

      /// if no doses with a 'Not Satisfied' status were found
      if (notSatisfied == null) {
        /// check if there are any doses with a status of 'Satisfied'
        final TargetDoseStatus? satisfied = evaluatedTargetDose.values
            .firstWhereOrNull((TargetDoseStatus element) =>
                element == TargetDoseStatus.satisfied);

        /// If there are not, then this series is not recommended
        if (satisfied == null) {
          shouldRecieveAnotherDose = false;
          seriesStatus = SeriesStatus.notRecommended;
          forecastReason = ForecastReason
              .notRecommendedAtThisTimeDueToPastImmunizationHistory;
        }

        ///If there are, then this is considered a completed series
        /// — unless the current target dose is a recurring dose that was
        /// already satisfied. Chapter 6 step 5a: satisfying a recurring target
        /// dose inserts "a new target dose identical to the current target
        /// dose" after it, so the collection is not exhausted and the series
        /// is not complete; the next occurrence is still owed (e.g. the
        /// decennial Td booster, the yearly influenza dose).
        else {
          final SeriesDose? currentSeriesDose =
              targetDose < (series.seriesDose?.length ?? 0)
                  ? series.seriesDose![targetDose]
                  : null;
          if (currentSeriesDose?.recurringDose == Binary.yes &&
              evaluatedTargetDose[targetDose] == TargetDoseStatus.satisfied) {
            _computeCandidateEarliestDate();
          } else {
            shouldRecieveAnotherDose = false;
            seriesStatus = SeriesStatus.complete;
            forecastReason = ForecastReason.patientSeriesIsComplete;
            seriesGroupCompletion[targetDisease]?[seriesGroupKey] = true;
            final VaxDate? completedOn = lastCompleted?.dateGiven;
            if (completedOn != null) {
              seriesGroupCompletionDate[targetDisease]?[seriesGroupKey] =
                  completedOn;
            }
          }
        }
      }

      /// If the patient DOES have at least one does that is 'Not Satisfied'
      else {
        final SeriesDose? seriesDose = series.seriesDose?[targetDose];
        final VaxDate seasonalRecommendationEndDate =
            VaxDate.fromNullableString(
                seriesDose?.seasonalRecommendation?.endDate, true);

        /// If the assessment date is after seasonal recommendation end date
        if (assessmentDate > seasonalRecommendationEndDate) {
          shouldRecieveAnotherDose = false;
          seriesStatus = SeriesStatus.notRecommended;
          forecastReason = ForecastReason.pastSeasonalRecommendationEndDate;
        } else {
          _computeCandidateEarliestDate();
        }
      }
    }
  }

  void generateForecast() {
    final SeriesDose? seriesDose = series.seriesDose?[targetDose];
    if (seriesDose != null) {
      final VaxAge? age = seriesDose.age?.firstWhereOrNull((VaxAge element) =>
          VaxDate.fromNullableString(element.effectiveDate) <= assessmentDate &&
          assessmentDate <=
              VaxDate.fromNullableString(element.cessationDate, true));
      minimumAgeDate = dob.changeNullable(age?.minAge);
      earliestRecommendedAgeDate = dob.changeNullable(age?.earliestRecAge);
      latestRecommendedAgeDate = dob.changeNullable(age?.latestRecAge);
      maximumAgeDate = dob.changeNullable(age?.maxAge);

      // Only intervals in force at the assessment date.
      final List<Interval> filteredIntervals =
          _filterIntervals(seriesDose.preferableInterval, assessmentDate);

      // CALCDTINT-1: each interval resolves its own reference dose, and the
      // interval runs from that dose's date administered — never from dob.
      final List<VaxDate> earliestRecIntDates = <VaxDate>[];
      final List<VaxDate> latestRecIntDates = <VaxDate>[];
      for (final Interval interval in filteredIntervals) {
        final VaxDate? refDate = _getReferenceDateForForecast(interval);
        if (refDate != null) {
          final VaxDate? earliest =
              refDate.changeNullable(interval.earliestRecInt);
          if (earliest != null) earliestRecIntDates.add(earliest);
          final VaxDate? latest = refDate.changeNullable(interval.latestRecInt);
          if (latest != null) latestRecIntDates.add(latest);
        }
      }
      earliestRecIntDates.sort();
      latestRecIntDates.sort((VaxDate a, VaxDate b) => b.compareTo(a));
      // FORECASTDT-2: "the latest of all earliest recommended interval dates"
      // when there is no earliest recommended age date. FORECASTDT-3 takes the
      // latest of the latest recommended interval dates, minus one day.
      earliestRecommendedIntervalDate =
          earliestRecIntDates.isEmpty ? null : earliestRecIntDates.last;
      latestRecommendedIntervalDate =
          latestRecIntDates.isEmpty ? null : latestRecIntDates.first;
      // TODO(Dokotela): Latest Conflict End Interval Date
      seasonalRecommendationStartDate = VaxDate.fromNullableString(
          seriesDose.seasonalRecommendation?.startDate);
      final VaxDate? earliestDate = candidateEarliestDate;
      final VaxDate? unadjustedRecommendedDate = earliestRecommendedAgeDate ??
          earliestRecommendedIntervalDate ??
          earliestDate;
      final VaxDate? unadjustedPastDueDate =
          latestRecommendedAgeDate?.change('-1 day') ??
              latestRecommendedIntervalDate?.change('-1 day');
      latestDate = maximumAgeDate?.change('-1 day');
      adjustedRecommendedDate =
          earliestDate == null && unadjustedRecommendedDate == null
              ? null
              : earliestDate == null
                  ? unadjustedRecommendedDate
                  : unadjustedRecommendedDate == null
                      ? earliestDate
                      : earliestDate > unadjustedRecommendedDate
                          ? earliestDate
                          : unadjustedRecommendedDate;
      adjustedPastDueDate =
          earliestDate == null && unadjustedPastDueDate == null
              ? null
              : earliestDate == null
                  ? unadjustedPastDueDate
                  : unadjustedPastDueDate == null
                      ? earliestDate
                      : earliestDate > unadjustedPastDueDate
                          ? earliestDate
                          : unadjustedPastDueDate;
      // TODO(Dokotela)
      // • Administrative guidance pertaining to any indication for which there
      //   is an active patient observation for the patient.
      // • Administrative guidance pertaining to any contraindication for which
      //   there is an active patient observation for the patient.
      administrativeGuidance += series.seriesAdminGuidance?.join('\n') ?? '';

      /// A recommended series dose, must be a preferable vaccine
      final List<Vaccine>? preferableVaccines =
          seriesDose.preferableVaccine?.toList();
      preferableVaccines?.retainWhere((Vaccine element) {
        /// The forecast vaccine type of the dose is 'Y'
        if (element.forecastVaccineType != 'Y') {
          return false;
        }
        // TODO(Dokotela): - check contraindications

        /// The earliest date of the patient series forecast is on or after the
        /// preferable vaccine type begin age date and before the preferable
        /// vaccine type end age date of the series dose vaccine.
        else if (earliestDate != null &&
            earliestDate >= dob.changeNullable(element.beginAge, false)! &&
            earliestDate < dob.changeNullable(element.endAge, true)!) {
          return true;
        } else {
          /// The adjusted recommended date of the patient series forecast is on
          /// or after the preferable vaccine type begin age date and before the
          /// preferable vaccine type end age date of the series dose vaccine.
          return adjustedRecommendedDate != null &&
              adjustedRecommendedDate! >=
                  dob.changeNullable(element.beginAge, false)! &&
              adjustedRecommendedDate! <
                  dob.changeNullable(element.endAge, true)!;
        }
      });
    }
  }

  VaxDate? latestDate;
  String targetDisease;
  int targetDose = 0;
  Series series;
  List<VaxDose> doses = <VaxDose>[];
  List<VaxDose> allPatientDoses = <VaxDose>[];
  VaxObservations observations = VaxObservations();
  String seriesGroupKey = 'none';
  Map<String, Map<String, bool>> seriesGroupCompletion =
      <String, Map<String, bool>>{};
  Map<String, Map<String, VaxDate>> seriesGroupCompletionDate =
      <String, Map<String, VaxDate>>{};

  /// When each series group became complete — the date of the dose that
  /// satisfied its last target dose. A "Completed Series" conditional skip is
  /// a question about a moment in time, not about the end state: see
  /// [skipByCompletedSeries].
  List<VaxDose> evaluatedDoses = <VaxDose>[];
  Map<int, TargetDoseStatus> evaluatedTargetDose = <int, TargetDoseStatus>{};
  VaxDate assessmentDate;
  VaxDate dob;
  bool isContraindicated = false;
  SeriesStatus seriesStatus = SeriesStatus.notComplete;
  bool shouldRecieveAnotherDose = true;
  ForecastReason? forecastReason;
  VaxDate? candidateEarliestDate;
  String administrativeGuidance = '';
  VaxDate? earliestRecommendedAgeDate;
  VaxDate? minimumAgeDate;
  VaxDate? latestRecommendedAgeDate;
  VaxDate? maximumAgeDate;
  VaxDate? earliestRecommendedIntervalDate;
  VaxDate? latestRecommendedIntervalDate;
  VaxDate? seasonalRecommendationStartDate;
  VaxDate? adjustedPastDueDate;
  VaxDate? adjustedRecommendedDate;
  int score = 0;
}
