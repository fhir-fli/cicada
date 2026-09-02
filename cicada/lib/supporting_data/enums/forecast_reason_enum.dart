enum ForecastReason {
  patientHasEvidenceOfImmunity,

  patientHasAContraindication,

  notRecommendedAtThisTimeDueToPastImmunizationHistory,

  patientSeriesIsComplete,

  pastSeasonalRecommendationEndDate,

  patientHasExceededTheMaximumAge,

  patientIsUnableToFinishTheSeriesPriorToTheMaximumAge,

  /// The series carries a minimum age to start and the patient has not
  /// reached it, so this series cannot be begun yet.
  patientHasNotReachedTheMinimumAgeToStart,

  /// The patient has had every dose this season asks for, and the next one
  /// falls in a later season.
  ///
  /// 🛑 DELIBERATE DEVIATION FROM CDSi. The logic spec has no such reason: its
  /// only seasonal reason is 'Past seasonal recommendation end date'. The
  /// series is genuinely Not Complete, because a further dose is owed, so the
  /// status is unchanged and this reason says which kind of Not Complete it
  /// is.
  ///
  /// Added because "Not Complete, due <next season>" and "Not Complete, due
  /// now" are the same output to an alert or a quality measure, so a patient
  /// who has had this year's influenza dose reads as a gap for the rest of the
  /// season. ACIP defines influenza and RSV recommendations by season
  /// (MMWR Recomm Rep 2022;71(1):1-28; MMWR 2025;74(32):500-507), and
  /// OpenEvidence adjudicated this as the one addition with clear clinical
  /// payoff, 2026-09-01.
  ///
  /// It is emitted as the ImmDS code `seasonalComplete`, "The patient is
  /// complete for the season", so consumers get a standard code rather than
  /// one of ours.
  completeForTheSeason,

  /// ACIP recommends this series by shared clinical decision-making rather
  /// than routinely.
  ///
  /// Read from CDC's own marking: the series NAME carries "shared clinical
  /// decision making". Six series are named that way — four MenB and two
  /// COVID-19 — and for those the whole series is SCDM.
  ///
  /// 🛑 NOT set from the guidance prose. Seventeen further series mention SCDM
  /// in `seriesAdminGuidance` while being routine for most of their range: HPV
  /// says SCDM applies at 27-45 years, and pneumococcal scopes it by age and
  /// condition too. Coding those as SCDM outright would be wrong for the
  /// patients they are routine for, and the engine has no scoped SCDM
  /// attribute to read. That prose already reaches the caller in
  /// `recommendation.description`.
  ///
  /// Emitted with a cicada code: neither CDSi nor the ImmDS ForecastReason
  /// code system has a concept for it. ICE calls it
  /// CLINICAL_PATIENT_DISCRETION.
  sharedClinicalDecisionMaking;

  static ForecastReason? fromString(String? string) {
    switch (string) {
      case 'Patient has evidence of immunity':
        return ForecastReason.patientHasEvidenceOfImmunity;
      case 'Patient has a contraindication':
        return ForecastReason.patientHasAContraindication;
      case 'Not recommended at this time due to past immunization history':
        return ForecastReason
            .notRecommendedAtThisTimeDueToPastImmunizationHistory;
      case 'Patient series is complete':
        return ForecastReason.patientSeriesIsComplete;
      case 'Past seasonal recommendation end date':
        return ForecastReason.pastSeasonalRecommendationEndDate;
      case 'Patient has exceeded the maximum age':
        return ForecastReason.patientHasExceededTheMaximumAge;
      case 'Patient is unable to finish the series prior to the maximum age':
        return ForecastReason
            .patientIsUnableToFinishTheSeriesPriorToTheMaximumAge;
      case 'Patient has not reached the minimum age to start':
        return ForecastReason.patientHasNotReachedTheMinimumAgeToStart;
      case 'Patient is complete for the season':
        return ForecastReason.completeForTheSeason;
      case 'Recommended by shared clinical decision-making':
        return ForecastReason.sharedClinicalDecisionMaking;
      default:
        return null;
    }
  }

  static ForecastReason? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case patientHasEvidenceOfImmunity:
        return 'Patient has evidence of immunity';
      case patientHasAContraindication:
        return 'Patient has a contraindication';
      case notRecommendedAtThisTimeDueToPastImmunizationHistory:
        return 'Not recommended at this time due to past immunization history';
      case patientSeriesIsComplete:
        return 'Patient series is complete';
      case pastSeasonalRecommendationEndDate:
        return 'Past seasonal recommendation end date';
      case patientHasExceededTheMaximumAge:
        return 'Patient has exceeded the maximum age';
      case patientIsUnableToFinishTheSeriesPriorToTheMaximumAge:
        return 'Patient is unable to finish the series prior to the maximum age';
      case patientHasNotReachedTheMinimumAgeToStart:
        return 'Patient has not reached the minimum age to start';
      case completeForTheSeason:
        return 'Patient is complete for the season';
      case sharedClinicalDecisionMaking:
        return 'Recommended by shared clinical decision-making';
    }
  }

  String toJson() => toString();
}
