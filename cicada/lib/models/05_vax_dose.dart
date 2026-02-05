import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:riverpod/riverpod.dart';

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
    VaxDose? previousDose,
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
    if (!isDoseGivenAtValidAge(age)) {
      setAgeReason(ValidAgeReason.tooYoung, EvalStatus.not_valid);
      return false;
    }

    if (isDoseWithinMinimumAge(age) &&
        isFirstOrPreviousInvalid(targetDose, previousDose)) {
      return true;
    }

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

  bool isFirstOrPreviousInvalid(int targetDose, VaxDose? previousDose) {
    if (targetDose == 0 || previousDose == null) {
      setAgeReason(ValidAgeReason.gracePeriod);
      return true;
    }
    if (previousDose.evalStatus == EvalStatus.not_valid &&
        (previousDose.validAgeReason == ValidAgeReason.tooYoung ||
            previousDose.validAgeReason == ValidAgeReason.tooOld ||
            previousDose.allowedIntervalReason != null) &&
        previousDose.dateGiven.change('1 year') > dateGiven) {
      setAgeReason(ValidAgeReason.tooYoung, EvalStatus.not_valid,
          EvalReason.ageTooYoung);
      return false;
    }
    setAgeReason(ValidAgeReason.gracePeriod);
    return true;
  }

  bool isDoseGivenWithinMaximumAge(VaxAge age) {
    final VaxDate maximumAgeDate =
        age.maxAge == null ? VaxDate(2999, 12, 31) : dob.change(age.maxAge!);
    if (dateGiven < maximumAgeDate) {
      setAgeReason(ValidAgeReason.gracePeriod);
      return true;
    }
    setAgeReason(ValidAgeReason.tooOld, EvalStatus.extraneous);
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

  bool isAllowedInterval(
      List<Interval>? intervals, List<VaxDose> doses, int targetDose) {
    // Update interval status based on whether intervals are defined or not
    if (intervals == null || intervals.isEmpty) {
      updatePreferredInterval(valid: true);
      updateAllowedInterval(valid: true);
      return true;
    }

    for (final Interval interval in intervals) {
      final VaxDate? referenceDate =
          getReferenceDate(interval, targetDose, doses);

      // If no reference date could be determined, the interval is invalid
      if (referenceDate == null) {
        updatePreferredInterval(valid: false);
        return false;
      }

      // Evaluate the calculated dates against the interval requirements
      if (!evaluateIntervalDates(referenceDate, interval)) {
        return false;
      }
    }

    updatePreferredInterval(valid: true);
    updateAllowedInterval(valid: true);
    return true;
  }

  VaxDate? getReferenceDate(
      Interval interval, int targetDose, List<VaxDose> doses) {
    /// Determine the reference date from various possible sources
    if (interval.fromPrevious == 'Y') {
      return getPreviousDoseDate(targetDose, doses);
    } else if (interval.fromTargetDose != null) {
      return getTargetDoseDate(interval.fromTargetDose!, doses);
    } else if (interval.fromMostRecent != null) {
      return getMostRecentDoseDate(interval.mostRecent ?? <int>[], doses);
    } else if (interval.fromRelevantObs != null) {
      return getObservationDate(interval.fromRelevantObs);
    }
    return null;
  }

  /// If, we are supposed to get it from the most recent, AND the previous
  /// dose given was "Valid" or "Not Valid" (NOT "Substandard") AND the
  /// previous dose was not inadvertent, then we use the previous dose's
  /// dateGiven as the reference date.
  VaxDate? getPreviousDoseDate(int targetDose, List<VaxDose> doses) {
    // Get the date of the immediate previous dose if valid and not inadvertent
    if (targetDose > 0 &&
        doses[targetDose - 1].evalStatus != EvalStatus.sub_standard &&
        !doses[targetDose - 1].inadvertent) {
      return doses[targetDose - 1].dateGiven;
    }
    updatePreferredInterval(valid: false);
    return null;
  }

  /// If the from previous is not no (should be N but just in case we
  /// check for anything containing an N), and the fromTargetDose is
  /// not null and it's less than the current targetDose (which shouldn't
  /// be possible, but just covering edge cases)
  VaxDate? getTargetDoseDate(int targetDoseNumber, List<VaxDose> doses) {
    // Find the date of a specific target dose in the series
    final VaxDate? referenceDate = doses
        .firstWhereOrNull(
            (VaxDose dose) => dose.targetDoseSatisfied == targetDoseNumber - 1)
        ?.dateGiven;
    if (referenceDate == null) {
      updatePreferredInterval(valid: false);
    }
    return referenceDate;
  }

  /// If it's not from the immediate previous dose, and fromMostRecent
  /// does not equal null ("n/a" on the spreadsheets) and it's not an
  /// inadvertent vaccine
  VaxDate? getMostRecentDoseDate(List<int> vaccineTypes, List<VaxDose> doses) {
    // Get the date of the most recent dose of a specified vaccine type, if not inadvertent
    final VaxDose? dose = doses.lastWhereOrNull((VaxDose dose) =>
        vaccineTypes.contains(dose.cvxAsInt) && !dose.inadvertent);
    return dose?.dateGiven;
  }

  VaxDate? getObservationDate(ObservationCode? relevantObs) {
    /// For this one we have to review the list of conditions, which we
    /// stored in a Provider
    final ProviderContainer container = ProviderContainer();
    // Get the date of the most recent relevant observation
    final VaxObservations observations = container.read(observationsProvider);
    final int? index = observations.codesAsInt
        ?.indexWhere((int element) => element == relevantObs?.codeAsInt);
    if (index == null || index == -1) {
      updatePreferredInterval(valid: false);
      return null;
    } else {
      /// Otherwise, the reference date is the most recent active date of
      /// the appropriate observation
      final VaxObservation obs = observations.observation![index];
      return obs.period?.end == null || obs.period!.end!.valueDateTime == null
          ? VaxDate.now()
          : VaxDate.fromDateTime(obs.period!.end!.valueDateTime!);
    }
  }

  bool evaluateIntervalDates(VaxDate referenceDate, Interval interval) {
    // Calculate absolute minimum and minimum interval dates
    final VaxDate absoluteMinimum =
        referenceDate.changeNullable(interval.absMinInt, false)!;
    final VaxDate minimumDate =
        referenceDate.changeNullable(interval.minInt, false)!;

    // Check if the given dose is administered before the absolute minimum date
    if (VaxDate.now() < absoluteMinimum) {
      updatePreferredInterval(valid: false, reason: IntervalReason.tooShort);
      updateAllowedInterval(valid: false, reason: IntervalReason.tooShort);
      evalStatus = EvalStatus.not_valid;
      evalReason = EvalReason.intervalTooShort;
      return false;
    }
    // Check if it is within the grace period
    if (VaxDate.now() < minimumDate) {
      updatePreferredInterval(valid: true, reason: IntervalReason.gracePeriod);
    }
    return true;
  }

  bool isLiveVirusConflict(
    List<VaxDose> doses,
  ) {
    /// If there are no previous doses to look at, there can be no conflicts
    if (doses.isEmpty || index == 0) {
      conflict = false;
      return false;
    }

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
    } else {
      /// We evaluate the previous dose, and we look to see if one of the
      /// live virus conflicts for the current dose has a previous type that
      /// matches the type of the previous dose that was actually given
      final VaxDose previousDose = doses[index! - 1];
      final int previousIndex = liveVirusConflicts!.indexWhere(
          (LiveVirusConflict element) =>
              element.previous?.cvxAsInt == previousDose.cvxAsInt);

      /// If not, no conflict, we return false
      if (previousIndex == -1) {
        conflict = false;
        return false;
      } else {
        final VaxDate conflictBeginIntervalDate = previousDose.dateGiven
            .changeNullable(
                liveVirusConflicts[previousIndex].conflictBeginInterval,
                false)!;
        final VaxDate conflictEndIntervalDate = previousDose.dateGiven
            .changeNullable(
                liveVirusConflicts[previousIndex].conflictEndInterval, true)!;
        if (conflictBeginIntervalDate <= dateGiven &&
            dateGiven < conflictEndIntervalDate) {
          conflict = true;
          conflictReason = 'Live Virus Conflict';
          evalStatus = EvalStatus.not_valid;
          evalReason = EvalReason.liveVirusConflict;
          return true;
        } else {
          conflict = false;
          return false;
        }
      }
    }
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
        final Vaccine allowedVax = allowedList.first;
        final VaxDate allowableVaccineTypeBeginAgeDate =
            allowedVax.beginAge == null
                ? VaxDate.min()
                : birthdate.changeNullable(allowedVax.beginAge, false)!;
        final VaxDate allowableVaccineTypeEndAgeDate = allowedVax.endAge == null
            ? VaxDate.max()
            : birthdate.changeNullable(allowedVax.endAge, true)!;
        if (allowableVaccineTypeBeginAgeDate <= dateGiven &&
            dateGiven < allowableVaccineTypeEndAgeDate) {
          allowedVaccine = true;
          return true;
        } else {
          allowedVaccine = false;
          allowedVaccineReason =
              PreferredAllowedReason.notAPreferableOrAllowableVaccine;
          evalStatus = EvalStatus.not_valid;
          evalReason = EvalReason.notPreferableOrAllowable;
          return false;
        }
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
