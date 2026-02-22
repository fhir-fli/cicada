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
      setAgeReason(
          ValidAgeReason.tooYoung, EvalStatus.not_valid, EvalReason.ageTooYoung);
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

  bool isDoseWithinMinimumAge(VaxAge age) {
    final VaxDate minimumAgeDate =
        age.minAge == null ? VaxDate(1900, 01, 01) : dob.change(age.minAge!);
    return dateGiven < minimumAgeDate;
  }

  bool isDoseGivenWithinMaximumAge(VaxAge age) {
    final VaxDate maximumAgeDate =
        age.maxAge == null ? VaxDate(2999, 12, 31) : dob.change(age.maxAge!);
    if (dateGiven < maximumAgeDate) {
      setAgeReason(ValidAgeReason.gracePeriod);
      return true;
    }
    setAgeReason(ValidAgeReason.tooOld, EvalStatus.extraneous, EvalReason.ageTooOld);
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
        updatePreferredInterval(valid: true, reason: IntervalReason.gracePeriod);
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
    if (obs.period?.start != null &&
        obs.period!.start!.valueDateTime != null) {
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
    final List<LiveVirusConflict>? liveVirusConflicts = scheduleSupportingData
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
        final String? endInterval =
            (previousDose.evalStatus == null ||
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
    } else {
      final List<Vaccine> preferredList = vaccines.toList();
      preferredList.retainWhere(
          (Vaccine element) => element.cvxAsInt == int.tryParse(cvx));
      if (preferredList.isEmpty) {
        preferredVaccine = false;
        preferredVaccineReason =
            PreferredAllowedReason.notAPreferableOrAllowableVaccine;
        return false;
      } else {
        preferredList.retainWhere((Vaccine element) =>
            element.mvx?.toLowerCase() == mvx?.toLowerCase());
        if (preferredList.isEmpty) {
          preferredVaccine = false;
          preferredVaccineReason = PreferredAllowedReason.wrongTradeName;
          return false;
        } else if (preferredList.length != 1) {
          throw Exception('Something wrong with the preferred list');
        } else {
          final Vaccine preferredVax = preferredList.first;
          final VaxDate preferableVaccineTypeBeginAgeDate =
              preferredVax.beginAge == null
                  ? VaxDate.min()
                  : birthdate.changeNullable(preferredVax.beginAge, false)!;
          final VaxDate preferableVaccineTypeEndAgeDate =
              preferredVax.endAge == null
                  ? VaxDate.max()
                  : birthdate.changeNullable(preferredVax.endAge, true)!;
          final double? preferableVaccineVolume = preferredVax.volume == null
              ? null
              : double.tryParse(preferredVax.volume!);
          if (preferableVaccineTypeBeginAgeDate <= dateGiven &&
              dateGiven < preferableVaccineTypeEndAgeDate) {
            if (preferableVaccineVolume == null || volume == null) {
              preferredVaccine = true;
              return true;
            } else if (volume! >= preferableVaccineVolume) {
              preferredVaccine = true;
              return true;
            } else {
              preferredVaccine = true;
              preferredVaccineReason =
                  PreferredAllowedReason.lessThanRecommendedVolume;
              return true;
            }
          } else {
            preferredVaccine = false;
            preferredVaccineReason =
                PreferredAllowedReason.administeredOutsideOfPreferredAgeRange;
            return false;
          }
        }
      }
    }
  }

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
