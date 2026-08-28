import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

class VaxDose {
  VaxDose({
    required this.doseId,
    this.volume,
    required this.dateGiven,
    required this.cvx,
    this.mvx,
    required this.antigens,
    required this.dob,
    this.targetDisease,
    this.evalStatus,
    this.evalReason,
  });

  factory VaxDose.fromImmunization(Immunization immunization, VaxDate dob) {
    final String? cvx = cvxFromImmunization(immunization);
    final VaxDate dateGiven = immunization.occurrenceDateTime?.valueDateTime !=
            null
        ? VaxDate.fromDateTime(immunization.occurrenceDateTime!.valueDateTime!)
        : VaxDate(2999, 01, 01);
    final bool expired = (immunization.expirationDate?.valueDateTime != null) &&
        immunization.expirationDate!.valueDateTime!
            .isBefore(immunization.occurrenceDateTime!.valueDateTime!);

    return VaxDose(
      doseId: immunization.id!.toString(),
      volume: parseVolume(immunization.doseQuantity),
      dateGiven: dateGiven,
      cvx: cvx ?? 'none',
      mvx: mvxFromImmunization(immunization),
      antigens: antigensFromCvx(cvx),
      evalStatus: immunizationEvalStatus(dateGiven, cvx, expired, immunization),
      evalReason: immunizationEvalReason(dateGiven, cvx, expired, immunization),
      dob: dob,
    );
  }

  factory VaxDose.fromJson(Map<String, dynamic> json) => VaxDose(
        doseId: json['doseId'] as String,
        volume: json['volume'] as double?,
        dateGiven: VaxDate.fromJson(json['dateGiven'] as String),
        cvx: json['cvx'] as String,
        mvx: json['mvx'] as String?,
        antigens: List<String>.from(json['antigens'] as Iterable<dynamic>),
        dob: VaxDate.fromJson(json['dob'] as String),
        targetDisease: json['targetDisease'] as String?,
      )
        ..targetDoseSatisfied = json['targetDoseSatisfied'] as int
        ..index = json['index'] as int?
        ..inadvertent = (json['inadvertent'] ?? false) as bool
        ..validAgeReason = ValidAgeReason.fromJson(json['validAgeReason'])
        ..preferredInterval = json['preferredInterval'] as bool?
        ..preferredIntervalReason =
            IntervalReason.fromJson(json['preferredIntervalReason'])
        ..allowedInterval = json['allowedInterval'] as bool?
        ..allowedIntervalReason =
            IntervalReason.fromJson(json['allowedIntervalReason'])
        ..conflict = json['conflict'] as bool?
        ..conflictReason = json['conflictReason'] as String?
        ..preferredVaccine = json['preferredVaccine'] as bool?
        ..preferredVaccineReason =
            PreferredAllowedReason.fromJson(json['preferredVaccineReason'])
        ..allowedVaccine = json['allowedVaccine'] as bool?
        ..allowedVaccineReason =
            PreferredAllowedReason.fromJson(json['allowedVaccineReason'])
        ..evalStatus = EvalStatus.fromJson(json['evalStatus'])
        ..evalReason = EvalReason.fromJson(json['evalReason'] as String?);

  final String doseId;
  final double? volume;
  final VaxDate dateGiven;
  final String cvx;
  final String? mvx;
  final List<String> antigens;
  final VaxDate dob;
  String? targetDisease;
  int? index;
  bool inadvertent = false;
  ValidAgeReason? validAgeReason;
  bool? preferredInterval;
  IntervalReason? preferredIntervalReason;
  bool? allowedInterval;
  IntervalReason? allowedIntervalReason;
  bool? conflict;
  String? conflictReason;
  bool? preferredVaccine;
  PreferredAllowedReason? preferredVaccineReason;
  bool? allowedVaccine;
  PreferredAllowedReason? allowedVaccineReason;
  EvalStatus? evalStatus;
  EvalReason? evalReason;
  int targetDoseSatisfied = -1;

  /// Every evaluation reason that applies to this dose, in the order the
  /// specification evaluates them.
  ///
  /// Table 6-31 sets the evaluation status "with evaluation **reasons**" —
  /// plural — and the specification never says which one to report when more
  /// than one applies. [evalReason] therefore cannot be right for every case:
  /// a MenACWY dose 2 given at 11 years, eight weeks less five days after
  /// dose 1, fails the 16-year minimum age *and* the minimum interval, and
  /// CDC's row reports the interval while the engine reports the age
  /// (`2013-0503`). Installing a precedence rule does not settle it — making
  /// interval outrank age fixed that case and broke `2013-0034`, where CDC
  /// reports the age for a dose that fails both by a wide margin.
  ///
  /// So the dose carries all of them. [evalReason] is unchanged, and remains
  /// the single reason reported to callers who want one; this is what a
  /// comparison against CDC's single column should be made against, because
  /// their column holds one of these, not the only one.
  ///
  /// Derived from the sub-step fields the evaluation has already filled in —
  /// it reports nothing the engine did not already work out.
  List<EvalReason> get evalReasons {
    final List<EvalReason> reasons = <EvalReason>[];
    void add(EvalReason? reason) {
      if (reason != null && !reasons.contains(reason)) reasons.add(reason);
    }

    // 6.3 inadvertent vaccine, 6.4 age, 6.5/6.6 intervals, 6.7 conflict,
    // 6.8/6.9 preferable and allowable vaccine — the order of Chapter 6.
    if (inadvertent) add(EvalReason.inadvertentVaccine);
    if (validAgeReason == ValidAgeReason.tooYoung) add(EvalReason.ageTooYoung);
    if (validAgeReason == ValidAgeReason.tooOld) add(EvalReason.ageTooOld);
    if (preferredIntervalReason == IntervalReason.tooShort ||
        allowedIntervalReason == IntervalReason.tooShort) {
      add(EvalReason.intervalTooShort);
    }
    if (conflict == true) add(EvalReason.liveVirusConflict);
    if (allowedVaccine == false) add(EvalReason.notPreferableOrAllowable);
    // Reasons with no sub-step field of their own (expired product, recall,
    // series already completed, and so on) live only in evalReason.
    add(evalReason);
    return reasons;
  }
  VaxObservations? observations;

  VaxDose copyWith({
    String? doseId,
    double? volume,
    VaxDate? dateGiven,
    String? cvx,
    String? mvx,
    List<String>? antigens,
    VaxDate? dob,
    String? targetDisease,
    int? index,
    bool? inadvertent,
    ValidAgeReason? validAgeReason,
    bool? preferredInterval,
    IntervalReason? preferredIntervalReason,
    bool? allowedInterval,
    IntervalReason? allowedIntervalReason,
    bool? conflict,
    String? conflictReason,
    bool? preferredVaccine,
    PreferredAllowedReason? preferredVaccineReason,
    bool? allowedVaccine,
    PreferredAllowedReason? allowedVaccineReason,
    EvalStatus? evalStatus,
    EvalReason? evalReason,
  }) =>
      VaxDose(
        doseId: doseId ?? this.doseId,
        volume: volume ?? this.volume,
        dateGiven: dateGiven ?? this.dateGiven,
        cvx: cvx ?? this.cvx,
        mvx: mvx ?? this.mvx,
        antigens: antigens ?? this.antigens,
        dob: dob ?? this.dob,
        targetDisease: targetDisease ?? this.targetDisease,
        evalStatus: evalStatus ?? this.evalStatus,
        evalReason: evalReason ?? this.evalReason,
      )..setOptionalProperties(
          index,
          inadvertent,
          validAgeReason,
          preferredInterval,
          preferredIntervalReason,
          allowedInterval,
          allowedIntervalReason,
          conflict,
          conflictReason,
          preferredVaccine,
          preferredVaccineReason,
          allowedVaccine,
          allowedVaccineReason);

  void setOptionalProperties(
    int? index,
    bool? inadvertent,
    ValidAgeReason? validAgeReason,
    bool? preferredInterval,
    IntervalReason? preferredIntervalReason,
    bool? allowedInterval,
    IntervalReason? allowedIntervalReason,
    bool? conflict,
    String? conflictReason,
    bool? preferredVaccine,
    PreferredAllowedReason? preferredVaccineReason,
    bool? allowedVaccine,
    PreferredAllowedReason? allowedVaccineReason,
  ) {
    // this.index = index ?? this.index;
    this.inadvertent = inadvertent ?? this.inadvertent;
    this.validAgeReason = validAgeReason ?? this.validAgeReason;
    this.preferredInterval = preferredInterval ?? this.preferredInterval;
    this.preferredIntervalReason =
        preferredIntervalReason ?? this.preferredIntervalReason;
    this.allowedInterval = allowedInterval ?? this.allowedInterval;
    this.allowedIntervalReason =
        allowedIntervalReason ?? this.allowedIntervalReason;
    this.conflict = conflict ?? this.conflict;
    this.conflictReason = conflictReason ?? this.conflictReason;
    this.preferredVaccine = preferredVaccine ?? this.preferredVaccine;
    this.preferredVaccineReason =
        preferredVaccineReason ?? this.preferredVaccineReason;
    this.allowedVaccine = allowedVaccine ?? this.allowedVaccine;
    this.allowedVaccineReason =
        allowedVaccineReason ?? this.allowedVaccineReason;
  }

  int get cvxAsInt => int.tryParse(cvx) ?? -1;

  static double? parseVolume(Quantity? doseQuantity) =>
      doseQuantity?.code?.toString().toLowerCase() == 'ml'
          ? doseQuantity?.value?.valueDouble
          : null;

  /// Section 6.1 / Table 6-3: does a condition on the dose administered prevent
  /// it being evaluated at all? A dose given after the lot expiration date, or
  /// carrying a condition such as a recall, cold chain break or subpotent
  /// administration, is sub-standard and the target dose must be repeated
  /// regardless of the other evaluation rules.
  static EvalStatus? immunizationEvalStatus(VaxDate dateGiven, String? cvx,
          bool expired, Immunization immunization) =>
      dateGiven.year == 2999
          ? EvalStatus.not_valid
          : cvx == null
              ? EvalStatus.not_valid
              : expired
                  ? EvalStatus.sub_standard
                  : immunization.isSubpotent?.valueBoolean ?? false
                      ? EvalStatus.sub_standard
                      : null;

  static EvalReason? immunizationEvalReason(VaxDate dateGiven, String? cvx,
          bool expired, Immunization immunization) =>
      dateGiven.year == 2999
          ? EvalReason.noDateGiven
          : cvx == null
              ? EvalReason.noCvx
              : expired
                  ? EvalReason.expired
                  : immunization.isSubpotent?.valueBoolean ?? false
                      ? subpotentReason(immunization)
                      : null;

  /// Section 6.3: was the vaccine dose administered an inadvertent vaccine for
  /// the target dose?
  bool isInadvertent(SeriesDose seriesDose) {
    if ((seriesDose.inadvertentVaccineIndex(cvxAsInt) ?? -1) != -1) {
      markAsInadvertent();
      return true;
    }
    return false;
  }

  void markAsInadvertent() {
    inadvertent = true;
    evalStatus = EvalStatus.not_valid;
    evalReason = EvalReason.inadvertentVaccine;
  }

  void setAgeReason(
    ValidAgeReason reason, [
    EvalStatus? status,
    EvalReason? newEvalReason,
  ]) {
    validAgeReason = reason;
    evalStatus = status ?? evalStatus;
    evalReason = newEvalReason ?? evalReason;
  }

  bool isValidByAge(
    List<VaxAge>? vaxAge,
    int targetDose,
  ) {
    if (vaxAge == null || vaxAge.isEmpty) {
      return true; // No age restrictions
    }

    final int ageIndex = determineAgeIndex(vaxAge);
    if (ageIndex == -1) {
      throw Exception(
          'More than 1 age restriction, but no appropriate effective or cessation dates found');
    }

    final VaxAge age = vaxAge[ageIndex];

    // Column 1: before absMinAge → Not Valid "Too young"
    if (!isDoseGivenAtValidAge(age)) {
      setAgeReason(ValidAgeReason.tooYoung, EvalStatus.not_valid,
          EvalReason.ageTooYoung);
      return false;
    }

    // Column 2: grace period zone → unconditionally Valid per Table 6-15
    if (isDoseWithinMinimumAge(age)) {
      setAgeReason(ValidAgeReason.gracePeriod);
      return true;
    }

    // Columns 3-4: check max age
    return isDoseGivenWithinMaximumAge(age);
  }

  int determineAgeIndex(List<VaxAge> vaxAge) {
    return vaxAge.length == 1
        ? 0
        : vaxAge.indexWhere((VaxAge element) =>
            VaxDate.fromNullableString(element.effectiveDate) <= dateGiven &&
            VaxDate.fromNullableString(element.cessationDate, true) >=
                dateGiven);
  }

  bool isDoseGivenAtValidAge(VaxAge age) {
    final VaxDate absoluteMinimumAgeDate = age.absMinAge == null
        ? VaxDate(1900, 01, 01)
        : dob.change(age.absMinAge!);
    return !(dateGiven < absoluteMinimumAgeDate);
  }

  /// Table 6-15 column 2: at or after the absolute minimum age but before the
  /// minimum age — the grace period.
  bool isDoseWithinMinimumAge(VaxAge age) {
    final VaxDate minimumAgeDate =
        age.minAge == null ? VaxDate(1900, 01, 01) : dob.change(age.minAge!);
    return dateGiven < minimumAgeDate;
  }

  /// Table 6-15 columns 3-4: before the maximum age date is a valid age; at or
  /// after it the dose is extraneous, 'Too old'.
  bool isDoseGivenWithinMaximumAge(VaxAge age) {
    final VaxDate maximumAgeDate =
        age.maxAge == null ? VaxDate(2999, 12, 31) : dob.change(age.maxAge!);
    if (dateGiven < maximumAgeDate) {
      setAgeReason(ValidAgeReason.gracePeriod);
      return true;
    }
    setAgeReason(
        ValidAgeReason.tooOld, EvalStatus.extraneous, EvalReason.ageTooOld);
    return false;
  }

  void updatePreferredInterval({required bool valid, IntervalReason? reason}) {
    preferredInterval = (preferredInterval ?? true) && valid;
    preferredIntervalReason = reason ?? preferredIntervalReason;
  }

  void updateAllowedInterval({required bool valid, IntervalReason? reason}) {
    allowedInterval = (allowedInterval ?? true) && valid;
    allowedIntervalReason = reason ?? allowedIntervalReason;
  }

  /// Per Section 6.5: Evaluate preferable intervals.
  /// If no preferable intervals defined → considered "valid" (return true).
  /// Per the spec: "if multiple intervals are specified, then all intervals
  /// must be satisfied in order for the dose to satisfy the interval
  /// requirements." (AND logic)
  /// Intervals with effectiveDate/cessationDate are filtered by the dose date
  /// first — only applicable intervals are evaluated.
  /// Table 6-18: below the absolute minimum interval date the dose does not
  /// satisfy the preferable interval; between the absolute minimum and the
  /// minimum interval date it does, on the grace period; at or after the
  /// minimum interval date it does outright.
  bool evaluatePreferableInterval(
      List<Interval>? intervals, List<VaxDose> doses, int targetDose) {
    if (intervals == null || intervals.isEmpty) {
      updatePreferredInterval(valid: true);
      return true;
    }

    for (final Interval interval in intervals) {
      // Filter by effectiveDate/cessationDate — only evaluate intervals
      // whose date range covers the dose administration date.
      final VaxDate effective =
          VaxDate.fromNullableString(interval.effectiveDate);
      final VaxDate cessation =
          VaxDate.fromNullableString(interval.cessationDate, true);
      if (!(effective <= dateGiven && dateGiven <= cessation)) {
        continue;
      }

      final VaxDate? referenceDate =
          getReferenceDate(interval, targetDose, doses);

      // If the reference date cannot be determined, the interval cannot be
      // evaluated — skip it (it doesn't apply). This covers:
      // - fromPrevious=Y but no qualifying previous dose (e.g. first dose)
      // - fromTargetDose where that target dose was never satisfied
      // - fromMostRecent with no matching doses
      if (referenceDate == null) {
        continue;
      }

      final VaxDate absoluteMinimum =
          referenceDate.changeNullable(interval.absMinInt, false)!;
      final VaxDate minimumDate =
          referenceDate.changeNullable(interval.minInt, false)!;

      if (dateGiven < absoluteMinimum) {
        updatePreferredInterval(valid: false, reason: IntervalReason.tooShort);
        return false;
      }

      if (dateGiven < minimumDate) {
        updatePreferredInterval(
            valid: true, reason: IntervalReason.gracePeriod);
      } else {
        updatePreferredInterval(valid: true);
      }
    }

    return true;
  }

  /// Per Section 6.6: Evaluate allowable interval.
  /// If no allowable interval defined → considered "not valid" (return false).
  /// Uses absMinInt only (no grace period concept).
  bool evaluateAllowableInterval(
      Interval? interval, List<VaxDose> doses, int targetDose) {
    if (interval == null) {
      updateAllowedInterval(valid: false);
      return false;
    }

    final VaxDate? referenceDate =
        getReferenceDate(interval, targetDose, doses);

    if (referenceDate == null) {
      updateAllowedInterval(valid: false);
      return false;
    }

    final VaxDate absoluteMinimum =
        referenceDate.changeNullable(interval.absMinInt, false)!;

    if (dateGiven < absoluteMinimum) {
      updateAllowedInterval(valid: false, reason: IntervalReason.tooShort);
      evalStatus = EvalStatus.not_valid;
      evalReason = EvalReason.intervalTooShort;
      return false;
    }

    updateAllowedInterval(valid: true);
    return true;
  }

  VaxDate? getReferenceDate(
      Interval interval, int targetDose, List<VaxDose> doses) {
    if (interval.fromPrevious == 'Y') {
      return getPreviousDoseDate(doses);
    } else if (interval.fromTargetDose != null) {
      return getTargetDoseDate(interval.fromTargetDose!, doses);
    } else if (interval.fromMostRecent != null) {
      return getMostRecentDoseDate(interval.mostRecent ?? <int>[], doses);
    } else if (interval.fromRelevantObs != null) {
      return getObservationDate(interval.fromRelevantObs);
    }
    return null;
  }

  /// Per CALCDTINT-1: Find the most immediate previous dose administered
  /// that has eval status Valid or Not Valid, and is not inadvertent.
  /// Scans backward from the current dose's index.
  VaxDate? getPreviousDoseDate(List<VaxDose> doses) {
    if (index == null || index == 0) return null;
    for (int i = index! - 1; i >= 0; i--) {
      final VaxDose prev = doses[i];
      if (!prev.inadvertent &&
          (prev.evalStatus == EvalStatus.valid ||
              prev.evalStatus == EvalStatus.not_valid)) {
        return prev.dateGiven;
      }
    }
    return null;
  }

  /// Per CALCDTINT-2: Find the date of the dose satisfying the specified
  /// target dose number.
  VaxDate? getTargetDoseDate(int targetDoseNumber, List<VaxDose> doses) {
    final VaxDate? referenceDate = doses
        .firstWhereOrNull(
            (VaxDose dose) => dose.targetDoseSatisfied == targetDoseNumber - 1)
        ?.dateGiven;
    return referenceDate;
  }

  /// Find the most recent dose of specified vaccine types, not inadvertent,
  /// given before the current dose (by index).
  VaxDate? getMostRecentDoseDate(List<int> vaccineTypes, List<VaxDose> doses) {
    if (index == null) return null;
    final VaxDose? dose = doses.lastWhereOrNull((VaxDose d) =>
        vaccineTypes.contains(d.cvxAsInt) &&
        !d.inadvertent &&
        d.index != null &&
        d.index! < index!);
    return dose?.dateGiven;
  }

  VaxDate? getObservationDate(ObservationCode? relevantObs) {
    if (relevantObs == null || observations == null) return null;
    final int? obsIndex = observations!.codesAsInt
        ?.indexWhere((int element) => element == relevantObs.codeAsInt);
    if (obsIndex == null || obsIndex == -1) {
      return null;
    }
    final VaxObservation obs = observations!.observation![obsIndex];
    // CALCDTINT-9: Use period.start (the date the observation occurred),
    // fallback to period.end
    if (obs.period?.start != null && obs.period!.start!.valueDateTime != null) {
      return VaxDate.fromDateTime(obs.period!.start!.valueDateTime!);
    }
    if (obs.period?.end != null && obs.period!.end!.valueDateTime != null) {
      return VaxDate.fromDateTime(obs.period!.end!.valueDateTime!);
    }
    return null;
  }

  bool isLiveVirusConflict(
    List<VaxDose> doses, {
    List<VaxDose> allPatientDoses = const <VaxDose>[],
  }) {
    /// Look to see if the current cvx type is one of the conflict types listed
    /// in the supporting data
    final List<LiveVirusConflict>? liveVirusConflicts = activeScheduleData
        .liveVirusConflicts?.liveVirusConflict
        ?.where((LiveVirusConflict element) =>
            element.current?.cvxAsInt == cvxAsInt)
        .toList();

    /// If it is not, then there can be no conflicts, and we return false
    if (liveVirusConflicts?.isEmpty ?? true) {
      conflict = false;
      return false;
    }

    /// Use allPatientDoses for cross-antigen conflict checking.
    /// Fall back to series-local doses if allPatientDoses is empty.
    final List<VaxDose> dosesToCheck =
        allPatientDoses.isNotEmpty ? allPatientDoses : doses;

    /// Per Figure 6-16: loop "For each previous vaccine dose administered"
    /// Check ALL previous doses by date (cross-antigen), not just series-local
    for (final VaxDose previousDose in dosesToCheck) {
      // Only check doses given before this one
      if (previousDose.dateGiven >= dateGiven) continue;
      // Skip self
      if (previousDose.doseId == doseId) continue;

      for (final LiveVirusConflict lvc in liveVirusConflicts!) {
        if (lvc.previous?.cvxAsInt != previousDose.cvxAsInt) continue;

        final VaxDate conflictBeginDate = previousDose.dateGiven
            .changeNullable(lvc.conflictBeginInterval, false)!;

        /// Per CALCDTCONFLICT-2: use minConflictEndInterval when previous
        /// is Valid or has no eval status; use conflictEndInterval otherwise
        final String? endInterval = (previousDose.evalStatus == null ||
                previousDose.evalStatus == EvalStatus.valid)
            ? lvc.minConflictEndInterval
            : lvc.conflictEndInterval;

        final VaxDate conflictEndDate =
            previousDose.dateGiven.changeNullable(endInterval, true)!;

        if (conflictBeginDate <= dateGiven && dateGiven < conflictEndDate) {
          conflict = true;
          conflictReason = 'Live Virus Conflict';
          evalStatus = EvalStatus.not_valid;
          evalReason = EvalReason.liveVirusConflict;
          return true;
        }
      }
    }

    conflict = false;
    return false;
  }

  bool isPreferredType(
    List<Vaccine>? vaccines,
    VaxDate birthdate,
  ) {
    if (vaccines == null || vaccines.isEmpty) {
      preferredVaccine = false;
      preferredVaccineReason = PreferredAllowedReason.noPreferredTypes;
      return false;
    }

    final List<Vaccine> preferredList = vaccines
        .where((Vaccine element) => element.cvxAsInt == int.tryParse(cvx))
        .toList();
    if (preferredList.isEmpty) {
      preferredVaccine = false;
      preferredVaccineReason =
          PreferredAllowedReason.notAPreferableOrAllowableVaccine;
      return false;
    }

    // Table 6-26 compares trade names, but only 24 of the 7,111 vaccine
    // entries in the supporting data name one — the influenza and HepB
    // product-path series. Everywhere else the trade name is not a constraint,
    // and comparing it against an absent value meant any dose that carried a
    // manufacturer failed to match: a Tdap given as SKB was not a preferable
    // vaccine for the pregnancy risk series, so the dose did not count and the
    // series never completed (`2016-UC-0131`). Real records carry MVX far more
    // often than these test cases do, so this was silently discarding valid
    // doses.
    final List<Vaccine> tradeNameMatches = preferredList
        .where((Vaccine element) =>
            element.mvx == null ||
            element.mvx!.toLowerCase() == mvx?.toLowerCase())
        .toList();
    if (tradeNameMatches.isEmpty) {
      preferredVaccine = false;
      preferredVaccineReason = PreferredAllowedReason.wrongTradeName;
      return false;
    }

    // One CVX can appear more than once with different age ranges, exactly as
    // in [isAllowedType] — take the first entry whose age range covers the
    // date administered rather than assuming there is only one candidate.
    for (final Vaccine preferredVax in tradeNameMatches) {
      final VaxDate preferableVaccineTypeBeginAgeDate =
          preferredVax.beginAge == null
              ? VaxDate.min()
              : birthdate.changeNullable(preferredVax.beginAge, false)!;
      final VaxDate preferableVaccineTypeEndAgeDate =
          preferredVax.endAge == null
              ? VaxDate.max()
              : birthdate.changeNullable(preferredVax.endAge, true)!;
      if (!(preferableVaccineTypeBeginAgeDate <= dateGiven &&
          dateGiven < preferableVaccineTypeEndAgeDate)) {
        continue;
      }

      final double? preferableVaccineVolume = preferredVax.volume == null
          ? null
          : double.tryParse(preferredVax.volume!);
      preferredVaccine = true;
      if (preferableVaccineVolume != null &&
          volume != null &&
          volume! < preferableVaccineVolume) {
        preferredVaccineReason =
            PreferredAllowedReason.lessThanRecommendedVolume;
      }
      return true;
    }

    preferredVaccine = false;
    preferredVaccineReason =
        PreferredAllowedReason.administeredOutsideOfPreferredAgeRange;
    return false;
  }

  /// Table 6-29: was the vaccine dose administered an allowable vaccine for
  /// the target dose? Vaccine type, then the allowable begin/end age range.
  bool isAllowedType(
    List<Vaccine>? vaccines,
    VaxDate birthdate,
  ) {
    if (vaccines == null || vaccines.isEmpty) {
      allowedVaccine = false;
      allowedVaccineReason = PreferredAllowedReason.noAllowedTypes;
      evalStatus = EvalStatus.not_valid;
      evalReason = EvalReason.notPreferableOrAllowable;
      return false;
    } else {
      final List<Vaccine> allowedList = vaccines.toList();
      allowedList.retainWhere(
          (Vaccine element) => element.cvxAsInt == int.tryParse(cvx));
      if (allowedList.isEmpty) {
        allowedVaccine = false;
        allowedVaccineReason =
            PreferredAllowedReason.notAPreferableOrAllowableVaccine;
        evalStatus = EvalStatus.not_valid;
        evalReason = EvalReason.notPreferableOrAllowable;
        return false;
      } else {
        // Check ALL matching entries — same CVX can appear multiple times
        // with different age ranges.
        for (final Vaccine allowedVax in allowedList) {
          final VaxDate allowableVaccineTypeBeginAgeDate =
              allowedVax.beginAge == null
                  ? VaxDate.min()
                  : birthdate.changeNullable(allowedVax.beginAge, false)!;
          final VaxDate allowableVaccineTypeEndAgeDate =
              allowedVax.endAge == null
                  ? VaxDate.max()
                  : birthdate.changeNullable(allowedVax.endAge, true)!;
          if (allowableVaccineTypeBeginAgeDate <= dateGiven &&
              dateGiven < allowableVaccineTypeEndAgeDate) {
            allowedVaccine = true;
            return true;
          }
        }
        allowedVaccine = false;
        allowedVaccineReason =
            PreferredAllowedReason.notAPreferableOrAllowableVaccine;
        evalStatus = EvalStatus.not_valid;
        evalReason = EvalReason.notPreferableOrAllowable;
        return false;
      }
    }
  }

  String get validity {
    String validity = 'Status: $evalStatus ';
    if (evalStatus == EvalStatus.valid) {
      return validity;
    }
    bool reason = false;

    if (evalReason != null) {
      validity += 'Reason: $evalReason, ';
      reason = true;
    }

    if (inadvertent) {
      validity += 'Inadvertent, ';
    }

    if (validAgeReason != null) {
      validity += '${reason ? "" : "Reason: "}$validAgeReason, ';
      reason = true;
    }

    if (preferredIntervalReason != null) {
      validity += '${reason ? "" : "Reason: "}$preferredIntervalReason, ';
      reason = true;
    }

    if (allowedIntervalReason != null) {
      validity += '${reason ? "" : "Reason: "}$allowedIntervalReason, ';
      reason = true;
    }

    if (conflictReason != null) {
      validity += '${reason ? "" : "Reason: "}$conflictReason, ';
      reason = true;
    }

    if (preferredVaccineReason != null) {
      validity += '${reason ? "" : "Reason: "}$preferredVaccineReason, ';
      reason = true;
    }

    if (allowedVaccineReason != null) {
      validity += '${reason ? "" : "Reason: "}$allowedVaccineReason, ';
      reason = true;
    }

    return reason ? validity.substring(0, validity.length - 2) : validity;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'doseId': doseId,
        if (volume != null) 'volume': volume,
        'dateGiven': dateGiven.toJson(),
        'cvx': cvx,
        if (mvx != null) 'mvx': mvx,
        'antigens': antigens,
        'dob': dob.toJson(),
        if (targetDisease != null) 'targetDisease': targetDisease,
        'targetDoseSatisfied': targetDoseSatisfied,
        if (index != null) 'index': index,
        'inadvertent': inadvertent,
        if (validAgeReason != null)
          'validAgeReason': validAgeReason?.toString(),
        if (preferredInterval != null) 'preferredInterval': preferredInterval,
        if (preferredIntervalReason != null)
          'preferredIntervalReason': preferredIntervalReason.toString(),
        if (allowedInterval != null) 'allowedInterval': allowedInterval,
        if (allowedIntervalReason != null)
          'allowedIntervalReason': allowedIntervalReason.toString(),
        if (conflict != null) 'conflict': conflict,
        if (conflictReason != null) 'conflictReason': conflictReason,
        if (preferredVaccine != null) 'preferredVaccine': preferredVaccine,
        if (preferredVaccineReason != null)
          'preferredVaccineReason': preferredVaccineReason.toString(),
        if (allowedVaccine != null) 'allowedVaccine': allowedVaccine,
        if (allowedVaccineReason != null)
          'allowedVaccineReason': allowedVaccineReason.toString(),
        if (evalStatus != null) 'evalStatus': evalStatus?.toString(),
        if (evalReason != null) 'evalReason': evalReason?.toString(),
      };
}
