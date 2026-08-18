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
  patientHasNotReachedTheMinimumAgeToStart;

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
    }
  }

  String toJson() => toString();
}
