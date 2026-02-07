import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';

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
    }
  }

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

  bool canSkipDose(SeriesDose seriesDose, VaxDose dose) {
    if (seriesDose.recurringDose == Binary.yes) return false;
    return canSkip(seriesDose, SkipContext.evaluation, dose.dateGiven);
  }

  void markDoseSkipped(SeriesDose seriesDose) {
    evaluatedTargetDose[targetDose] = TargetDoseStatus.skipped;
    updateTargetDose(seriesDose);
  }

  bool evaluateDoseValidity(SeriesDose seriesDose, VaxDose dose) {
    final bool inadvertent = dose.isInadvertent(seriesDose);
    if (inadvertent) {
      return false;
    } else if (!dose.isValidByAge(seriesDose.age, targetDose)) {
      return false;
    }

    // Per Figure 6-1: Evaluate Preferable Interval (6.5) first
    // Per Section 6.5: no preferable intervals → considered "valid"
    final bool preferableOk = dose.evaluatePreferableInterval(
        seriesDose.preferableInterval, doses, targetDose);

    // Per Figure 6-1: if preferable fails, try Allowable Interval (6.6)
    // Per Section 6.6: no allowable intervals → considered "not valid"
    final bool allowableOk = preferableOk
        ? true
        : dose.evaluateAllowableInterval(
            seriesDose.allowableInterval, doses, targetDose);

    // Per Table 6-31: satisfied if preferable OR allowable passed
    if (!preferableOk && !allowableOk) {
      // Ensure evalStatus is set when both interval checks fail
      dose.evalStatus ??= EvalStatus.not_valid;
      dose.evalReason ??= EvalReason.intervalTooShort;
      return false;
    }

    if (dose.isLiveVirusConflict(doses, allPatientDoses: allPatientDoses)) {
      return false;
    } else {
      return dose.isAllowedType(seriesDose.allowableVaccine, dob);
    }
  }

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
    evaluateConditionalSkip(assessmentDate: assessmentDate);
    determineContraindications(
        vaccineContraindications: vaccineContraindications);
    determineForecastNeed(evidenceOfImmunity);
    if (shouldRecieveAnotherDose) {
      int currentTargetDose = -1;
      while (currentTargetDose != targetDose) {
        generateForecast();
        currentTargetDose = targetDose;
        evaluateConditionalSkip(assessmentDate: candidateEarliestDate);
      }
    }
  }

  void evaluateConditionalSkip({VaxDate? assessmentDate}) {
    assessmentDate ??= VaxDate.now();
    _forecastMode = true;
    while (targetDose < (series.seriesDose?.length ?? 0)) {
      final SeriesDose seriesDose = series.seriesDose![targetDose];

      // Don't overwrite already satisfied doses — advance past them
      if (evaluatedTargetDose[targetDose] == TargetDoseStatus.satisfied) {
        // For recurring doses, check the conditional skip to determine
        // if the patient is done for this period (e.g., has a seasonal dose).
        // If the skip doesn't fire, the patient still needs another dose.
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
    _forecastMode = false;
  }

  bool canSkip(
          SeriesDose seriesDose, SkipContext skipContext, VaxDate evalDate) =>
      seriesDose.conditionalSkip?.any((ConditionalSkip conditionalSkip) =>
          (conditionalSkip.context == SkipContext.both ||
              conditionalSkip.context == skipContext) &&
          evaluateSkipCondition(conditionalSkip, skipContext, evalDate)) ??
      false;

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

  bool skipSet(VaxSet set_, SkipContext skipContext, VaxDate evalDate) {
    final bool andLogic = set_.conditionLogic?.toLowerCase() == 'and';
    final List<bool> conditionResults = set_.condition
            ?.map((VaxCondition condition) =>
                evaluateCondition(condition, evalDate, set_))
            .toList() ??
        <bool>[];
    return andLogic
        ? conditionResults.every((bool res) => res)
        : conditionResults.any((bool res) => res);
  }

  bool evaluateCondition(
      VaxCondition condition, VaxDate evalDate, VaxSet set_) {
    switch (condition.conditionType?.toLowerCase()) {
      case 'age':
        return skipByAge(condition, evalDate);
      case 'completed series':
        return skipByCompletedSeries(condition);
      case 'interval':
        return skipByInterval(condition, evalDate);
      case 'vaccine count by age':
        return skipByCount(condition, dob, true);
      case 'vaccine count by date':
        return skipByCount(condition, evalDate, false);
      case 'vaccine count by date and age':
        return skipByCountDateAndAge(condition);
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

  bool skipByCompletedSeries(VaxCondition condition) {
    final ProviderContainer container = ProviderContainer();

    return container.read(seriesGroupCompleteProvider)[targetDisease]
            ?[condition.seriesGroups] ??
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

  bool skipByCountDateAndAge(VaxCondition condition) {
    final VaxDate? startDate = condition.startDate == null
        ? dob.changeNullable(condition.beginAge, false)
        : VaxDate.fromString(condition.startDate!, true);
    final VaxDate? endDate = condition.endDate == null
        ? dob.changeNullable(condition.endAge, true)
        : VaxDate.fromString(condition.endDate!);
    final VaxDate? ageEndDate = dob.changeNullable(condition.endAge, true);
    final List<int> types = parseTypes(condition.vaccineTypes);
    final int totalCount =
        countVaccinesDateAndAge(types, startDate, endDate, ageEndDate, condition.doseType);
    return evaluateCountLogic(
        totalCount, condition.doseCountLogic, condition.doseCount);
  }

  int countVaccinesDateAndAge(List<int> types, VaxDate? startDate,
      VaxDate? endDate, VaxDate? ageEndDate, DoseType? doseType) {
    final List<VaxDose> source =
        doseType == DoseType.total && _forecastMode && allPatientDoses.isNotEmpty
            ? allPatientDoses
            : evaluatedDoses;
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

  bool skipByCount(VaxCondition condition, VaxDate refDate, bool byAge) {
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
    final int totalCount =
        countVaccines(types, startDate, endDate, condition.doseType);
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

  int countVaccines(List<int> types, VaxDate? startDate, VaxDate? endDate,
      DoseType? doseType) {
    // During forecast, use all patient doses for "Total" counts (CDSi counts
    // all administered doses, not just those evaluated in this series).
    // During evaluation, use evaluatedDoses to avoid counting future doses.
    final List<VaxDose> source =
        doseType == DoseType.total && _forecastMode && allPatientDoses.isNotEmpty
            ? allPatientDoses
            : evaluatedDoses;
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

  void determineContraindications({
    VaxDate? assessmentDate,
    required List<VaccineContraindication> vaccineContraindications,
  }) {
    if (targetDose != series.seriesDose?.length) {
      assessmentDate ??= VaxDate.now();
      final List<Vaccine> preferableVaccines =
          series.seriesDose?[targetDose].preferableVaccine ?? <Vaccine>[];

      /// Check each of the contraindications (we already ensured they apply
      /// to the patient in a previous step)
      final ProviderContainer container = ProviderContainer();
      final List<VaxObservation> currentObservations =
          container.read(observationsProvider).observation?.toList() ??
              <VaxObservation>[];
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
          if (preferableVaccines.isEmpty) {
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
        else {
          shouldRecieveAnotherDose = false;
          seriesStatus = SeriesStatus.complete;
          forecastReason = ForecastReason.patientSeriesIsComplete;
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
          final VaxDate maximumAgeDate =
              seriesDose?.age?.firstOrNull?.maxAge == null
                  ? VaxDate.max()
                  : dob.change(seriesDose!.age!.first.maxAge!);

          /// if the assessment date is after or the same as the maximum age date
          if (assessmentDate >= maximumAgeDate) {
            shouldRecieveAnotherDose = false;
            seriesStatus = SeriesStatus.agedOut;
            forecastReason = ForecastReason.patientHasExceededTheMaximumAge;
          } else {
            /// The candidate earliest date must the latest of the following dates
            candidateEarliestDate = seriesDose?.age?.firstOrNull?.minAge == null
                ? dob
                : dob.change(seriesDose!.age!.first.minAge!);

            /// • Latest of all minimum interval dates
            final List<Interval>? orderedIntervals =
                evaluatedDoses.isEmpty
                    ? null
                    : seriesDose?.preferableInterval?.sortedByCompare(
                        (Interval element) => element.minInt,
                        (String? a, String? b) => evaluatedDoses.last.dateGiven
                            .changeNullableOrElse(
                                a, evaluatedDoses.last.dateGiven)
                            .compareTo(evaluatedDoses.last.dateGiven
                                .changeNullableOrElse(
                                    b, evaluatedDoses.last.dateGiven)));
            final String? latestInterval = (orderedIntervals?.isEmpty ?? true)
                ? null
                : orderedIntervals!.first.minInt;
            if (latestInterval != null && evaluatedDoses.isNotEmpty) {
              final VaxDate latestIntervalDate =
                  evaluatedDoses.last.dateGiven.change(latestInterval);
              candidateEarliestDate =
                  candidateEarliestDate! > latestIntervalDate
                      ? candidateEarliestDate
                      : latestIntervalDate;

              /// • Latest of all forecast conflict end dates
              final VaxDose lastDoseAdministered = evaluatedDoses.last;

              /// Find if the last dose given has any conflicts
              final List<LiveVirusConflict>? liveVirusConflicts =
                  scheduleSupportingData.liveVirusConflicts?.liveVirusConflict
                      ?.where((LiveVirusConflict element) =>
                          element.previous?.cvxAsInt ==
                          lastDoseAdministered.cvxAsInt)
                      .toList();
              if (liveVirusConflicts?.isNotEmpty ?? false) {
                for (final LiveVirusConflict conflict in liveVirusConflicts!) {
                  /// Check if this seriesDose has a preferable vaccine that is
                  /// impacted by the conflict with the previous vaccine
                  final Vaccine? preferredConflict = seriesDose
                      ?.preferableVaccine
                      ?.firstWhereOrNull((Vaccine element) =>
                          element.cvxAsInt == conflict.current?.cvxAsInt);
                  if (preferredConflict != null &&
                      conflict.conflictEndInterval != null) {
                    final VaxDate forecastConflictEndDate = lastDoseAdministered
                        .dateGiven
                        .change(conflict.conflictEndInterval!);

                    candidateEarliestDate =
                        candidateEarliestDate! > forecastConflictEndDate
                            ? candidateEarliestDate
                            : forecastConflictEndDate;
                  }
                }
              }

              /// • Seasonal recommendation start date
              final VaxDate seasonalRecommendationStartDate =
                  VaxDate.fromNullableString(
                      seriesDose?.seasonalRecommendation?.startDate);
              candidateEarliestDate =
                  candidateEarliestDate! > seasonalRecommendationStartDate
                      ? candidateEarliestDate
                      : seasonalRecommendationStartDate;

              /// • Latest of all dates administered of any inadvertent
              ///   administration being evaluated against a target dose that is
              ///   part of a patient series that is the basis of the patient
              ///   series forecast
              // TODO(Dokotela): - unclear logic
              final VaxDate lastDateInadvertentAdministered = evaluatedDoses
                      .lastWhereOrNull((VaxDose element) =>
                          element.evalReason == EvalReason.inadvertentVaccine)
                      ?.dateGiven ??
                  VaxDate.min();

              candidateEarliestDate =
                  candidateEarliestDate! > lastDateInadvertentAdministered
                      ? candidateEarliestDate
                      : lastDateInadvertentAdministered;

              /// • Date administered of the most recent vaccine dose
              ///   administered being evaluated against a target dose that is
              ///   part of a patient series that is the basis of the patient
              ///   series forecast.
              // TODO(Dokotela): - unclear logic
              final VaxDate lastDateAdministered =
                  evaluatedDoses.last.dateGiven;
              candidateEarliestDate =
                  candidateEarliestDate! > lastDateAdministered
                      ? candidateEarliestDate
                      : lastDateAdministered;

              /// • Minimum age date
              final VaxDate minimumAgeDate = dob.changeNullable(
                  seriesDose?.age?.firstOrNull?.minAge, false)!;
              candidateEarliestDate = candidateEarliestDate! > minimumAgeDate
                  ? candidateEarliestDate
                  : minimumAgeDate;

              /// If the candidateEarliestDate is after or the same as the
              /// maximum age date
              if (candidateEarliestDate! >= maximumAgeDate) {
                shouldRecieveAnotherDose = false;
                seriesStatus = SeriesStatus.agedOut;
                forecastReason = ForecastReason
                    .patientIsUnableToFinishTheSeriesPriorToTheMaximumAge;
              } else {
                shouldRecieveAnotherDose = true;
                seriesStatus = SeriesStatus.notComplete;
              }
            } else {
              /// No interval data or no evaluated doses — use age-based check
              if (candidateEarliestDate! >= maximumAgeDate) {
                shouldRecieveAnotherDose = false;
                seriesStatus = SeriesStatus.agedOut;
                forecastReason = ForecastReason
                    .patientIsUnableToFinishTheSeriesPriorToTheMaximumAge;
              } else {
                shouldRecieveAnotherDose = true;
                seriesStatus = SeriesStatus.notComplete;
              }
            }
          }
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
      final List<VaxDate>? earliestRecommendedIntervalDates = seriesDose
          .preferableInterval
          ?.map((Interval e) => dob.changeNullable(e.earliestRecInt))
          .whereType<VaxDate>()
          .toList()
          .sortedByCompare((VaxDate element) => element,
              (VaxDate a, VaxDate b) => a.compareTo(b));
      earliestRecommendedIntervalDate =
          earliestRecommendedIntervalDates == null ||
                  earliestRecommendedIntervalDates.isEmpty
              ? null
              : earliestRecommendedIntervalDates.first;
      final List<VaxDate>? latestRecommendedIntervalDates = seriesDose
          .preferableInterval
          ?.map((Interval e) => dob.changeNullable(e.latestRecInt))
          .whereType<VaxDate>()
          .toList()
          .sortedByCompare((VaxDate element) => element,
              (VaxDate a, VaxDate b) => b.compareTo(a));
      latestRecommendedIntervalDate = latestRecommendedIntervalDates == null ||
              latestRecommendedIntervalDates.isEmpty
          ? null
          : latestRecommendedIntervalDates.first;
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
  bool _forecastMode = false;
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
