import 'package:cicada/cicada.dart';

/// UI-level categorization that splits the engine's "Not Complete" into
/// finer buckets based on forecast dates vs assessment date.
enum ForecastCategory {
  /// Past due date has passed — action needed.
  overdue,

  /// Recommended date is on or before the assessment date.
  dueNow,

  /// Recommended date is in the future but within 30 days.
  dueSoon,

  /// Recommended date is more than 30 days out.
  upcoming,

  /// Series is complete.
  complete,

  /// Evidence of immunity.
  immune,

  /// Contraindicated for this patient.
  contraindicated,

  /// Patient has aged out of this series.
  agedOut,

  /// Not recommended for this patient.
  notRecommended
  ;

  String get displayLabel => switch (this) {
    overdue => 'Overdue',
    dueNow => 'Due Now',
    dueSoon => 'Due Soon',
    upcoming => 'Upcoming',
    complete => 'Complete',
    immune => 'Immune',
    contraindicated => 'Contraindicated',
    agedOut => 'Aged Out',
    notRecommended => 'Not Recommended',
  };

  /// Whether this category represents a vaccine the patient should act on.
  bool get isActionable => this == overdue || this == dueNow || this == dueSoon;
}

/// Categorize a [VaccineGroupForecast] relative to the [assessmentDate].
ForecastCategory categorize(
  VaccineGroupForecast forecast,
  VaxDate assessmentDate,
) {
  switch (forecast.status) {
    case SeriesStatus.complete:
      return ForecastCategory.complete;
    case SeriesStatus.immune:
      return ForecastCategory.immune;
    case SeriesStatus.contraindicated:
      return ForecastCategory.contraindicated;
    case SeriesStatus.agedOut:
      return ForecastCategory.agedOut;
    case SeriesStatus.notRecommended:
      return ForecastCategory.notRecommended;
    case SeriesStatus.notComplete:
      // Check past due first
      final pastDue = forecast.pastDueDate;
      if (_isValid(pastDue) && assessmentDate.isAfter(pastDue!)) {
        return ForecastCategory.overdue;
      }

      // Check recommended date
      final rec = forecast.recommendedDate;
      if (!_isValid(rec)) return ForecastCategory.upcoming;

      if (!rec!.isAfter(assessmentDate)) {
        return ForecastCategory.dueNow;
      }

      // Due within 30 days?
      final thirtyDaysOut = assessmentDate.add(const Duration(days: 30));
      if (!rec.isAfter(thirtyDaysOut)) {
        return ForecastCategory.dueSoon;
      }

      return ForecastCategory.upcoming;
  }
}

bool _isValid(VaxDate? date) =>
    date != null && date.year > 1900 && date.year < 2999;
