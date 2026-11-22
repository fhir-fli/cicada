import 'package:cicada/cicada.dart';
import 'package:cicada_ehr/src/forecast_category.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:intl/intl.dart';

/// One labelled value on a card, such as `Recommended` and its date.
typedef ForecastRow = ({String label, String value});

/// Everything the display page shows for one vaccine group forecast. Nothing
/// is folded away: a chart tab is read, never clicked.
class ForecastCard {
  const ForecastCard({
    required this.title,
    required this.subtitles,
    required this.category,
    required this.rows,
    required this.notes,
  });

  /// The vaccine group, e.g. `MMR`.
  final String title;

  /// The antigens when there are several, and for a risk forecast the series
  /// group and the chart entries that put the patient on it.
  final List<String> subtitles;

  final ForecastCategory category;

  /// Next dose and the four forecast dates, those the engine set.
  final List<ForecastRow> rows;

  /// The engine's forecast reason, when it gives one.
  final List<String> notes;
}

/// A heading and its cards.
class ForecastSection {
  const ForecastSection({required this.title, required this.cards});

  final String title;
  final List<ForecastCard> cards;
}

/// One evaluated dose.
class DoseEvaluationRow {
  const DoseEvaluationRow({
    required this.date,
    required this.cvx,
    required this.status,
    required this.reason,
  });

  final String date;
  final String cvx;
  final String status;
  final String? reason;
}

/// The evaluated doses of one antigen's best series.
class DoseEvaluationGroup {
  const DoseEvaluationGroup({required this.title, required this.rows});

  /// `<vaccine group> — <target disease>`.
  final String title;
  final List<DoseEvaluationRow> rows;
}

/// The whole display, built from the engine's result and the chart's
/// Patient. Holds text only; the page and the tests both read it.
class ForecastView {
  const ForecastView({
    required this.banner,
    required this.summary,
    required this.sections,
    required this.doseEvaluations,
  });

  /// Build the view of [result] for [patient], as of the engine's
  /// assessment date.
  factory ForecastView.of(ForecastResult result, Patient patient) {
    final assessmentDate = result.patient.assessmentDate;
    final categorized = <(VaccineGroupForecast, ForecastCategory)>[
      // A vaccine group can carry a standard forecast and a risk one (CDSi
      // Logic Specification v4.6 Table 9-2 FORECASTVG-1); each gets a card.
      for (final f in result.vaccineGroupForecasts.values.expand((l) => l))
        (f, categorize(f, assessmentDate)),
    ]..sort((a, b) => a.$2.index.compareTo(b.$2.index));

    List<ForecastCard> cardsIn(Set<ForecastCategory> categories) => [
      for (final (f, c) in categorized)
        if (categories.contains(c)) _card(f, c),
    ];

    final actionable = cardsIn({
      ForecastCategory.overdue,
      ForecastCategory.dueNow,
      ForecastCategory.dueSoon,
    });
    final upcoming = cardsIn({ForecastCategory.upcoming});
    final done = cardsIn({ForecastCategory.complete, ForecastCategory.immune});
    final other = cardsIn({
      ForecastCategory.contraindicated,
      ForecastCategory.agedOut,
      ForecastCategory.notRecommended,
    });

    return ForecastView(
      banner: _banner(patient, assessmentDate),
      summary: [
        if (actionable.isNotEmpty) '${actionable.length} due now',
        '${upcoming.length} upcoming',
        '${done.length} complete',
      ],
      sections: [
        if (actionable.isNotEmpty)
          ForecastSection(title: 'Action needed', cards: actionable),
        if (upcoming.isNotEmpty)
          ForecastSection(title: 'Upcoming', cards: upcoming),
        if (done.isNotEmpty) ForecastSection(title: 'Complete', cards: done),
        if (other.isNotEmpty) ForecastSection(title: 'Other', cards: other),
      ],
      doseEvaluations: _doseEvaluations(result),
    );
  }

  /// Age, sex, date of birth and assessment date, those the chart gives.
  final List<String> banner;

  /// The counts, e.g. `4 due now`.
  final List<String> summary;

  final List<ForecastSection> sections;
  final List<DoseEvaluationGroup> doseEvaluations;

  /// What the forecast was read from, shown under the banner.
  static const String basis =
      'Based on the immunizations, conditions, allergies, laboratory '
      'results, social history and procedures in this chart. Medications '
      'are not read.';

  static final DateFormat _date = DateFormat.yMMMd();

  static String formatDate(DateTime date) => _date.format(date);

  static List<String> _banner(Patient patient, VaxDate assessmentDate) {
    final birthDate = patient.birthDate?.valueDateTime;
    final sex = switch (patient.gender?.valueString) {
      'male' => 'Male',
      'female' => 'Female',
      'other' => 'Other',
      'unknown' => 'Unknown',
      _ => null,
    };
    return [
      if (birthDate != null) 'Age ${formatAge(birthDate, assessmentDate)}',
      ?sex,
      if (birthDate != null) 'DOB ${formatDate(birthDate)}',
      'Assessment ${formatDate(assessmentDate)}',
    ];
  }

  /// Whole months under 3 years, whole years from 3.
  static String formatAge(DateTime birthDate, DateTime on) {
    var months = (on.year - birthDate.year) * 12 + on.month - birthDate.month;
    if (on.day < birthDate.day) months -= 1;
    final years = months ~/ 12;
    final rest = months % 12;
    String plural(int n, String unit) => '$n $unit${n == 1 ? '' : 's'}';
    if (years == 0) return plural(rest, 'month');
    if (years < 3) return '${plural(years, 'year')}, ${plural(rest, 'month')}';
    return plural(years, 'year');
  }

  static ForecastCard _card(VaccineGroupForecast f, ForecastCategory c) {
    final subtitles = <String>[
      if (f.antigenNames.length > 1) f.antigenNames.join(', '),
      if (f.isRiskForecast) _riskLine(f),
    ];
    final rows = <ForecastRow>[
      if (f.status == SeriesStatus.notComplete) ...[
        if (f.doseNumber != null)
          (label: 'Next dose', value: 'Dose ${f.doseNumber}'),
        if (_isSet(f.earliestDate))
          (label: 'Earliest', value: formatDate(f.earliestDate!)),
        if (_isSet(f.recommendedDate))
          (label: 'Recommended', value: formatDate(f.recommendedDate!)),
        if (_isSet(f.pastDueDate))
          (label: 'Past due', value: formatDate(f.pastDueDate!)),
        if (_isSet(f.latestDate))
          (label: 'Latest', value: formatDate(f.latestDate!)),
        if (f.forecastVaccineDescriptions.isNotEmpty)
          (
            label: 'Vaccines',
            value: _vaccines(
              f.forecastVaccineDescriptions,
              f.forecastCvxCodes,
            ),
          ),
      ],
      if (f.contraindicatedCvxCodes.isNotEmpty)
        (
          label: 'Contraindicated',
          value: f.contraindicatedCvxCodes.map((c) => 'CVX $c').join(', '),
        ),
    ];
    // The engine's reason for a series with nothing left to give, in its
    // own words. CDSi's series-level administrative guidance is not shown:
    // it is written for every patient on the series (an HIV note on every
    // varicella card, an age-60 note on a child's HepB), not for this one.
    final notes = <String>[
      if (f.forecastReason != null) '${f.forecastReason}.',
    ];
    return ForecastCard(
      title: f.vaccineGroupName,
      subtitles: subtitles,
      category: c,
      rows: rows,
      notes: notes,
    );
  }

  /// The series group and the chart entries that made the risk series apply
  /// (the forecast's supportingReferences, CDSi Table 5-4), so a risk card
  /// can be told from the standard one of the same vaccine group.
  static String _riskLine(VaccineGroupForecast f) {
    final label = f.seriesGroupName ?? 'Increased risk';
    final because = f.supportingReferences
        .map((r) => r.display)
        .whereType<String>()
        .toSet()
        .join(', ');
    return because.isEmpty ? label : '$label: $because';
  }

  static String _vaccines(List<String> descriptions, List<String> cvx) => [
    for (var i = 0; i < descriptions.length; i++)
      if (i < cvx.length)
        '${descriptions[i]} (CVX ${cvx[i]})'
      else
        descriptions[i],
  ].join('; ');

  static List<DoseEvaluationGroup> _doseEvaluations(ForecastResult result) {
    final groups = <DoseEvaluationGroup>[];
    for (final antigen in result.agMap.values) {
      for (final group in antigen.groups.values) {
        final series = group.prioritizedSeries.isNotEmpty
            ? group.prioritizedSeries.first
            : (group.series.isNotEmpty ? group.series.first : null);
        if (series == null) continue;
        final rows = [
          for (final dose in series.doses)
            if (dose.evalStatus != null)
              DoseEvaluationRow(
                date: formatDate(dose.dateGiven),
                cvx: dose.cvx,
                status: dose.evalStatus.toString(),
                reason: dose.evalReason?.toString(),
              ),
        ];
        if (rows.isEmpty) continue;
        groups.add(
          DoseEvaluationGroup(
            title: '${group.vaccineGroupName} — ${antigen.targetDisease}',
            rows: rows,
          ),
        );
      }
    }
    return groups;
  }

  /// The engine marks an unset date with its sentinels, 1900-01-01 and
  /// 2999-12-31 (`VaxDate.min()` / `VaxDate.max()`).
  static bool _isSet(VaxDate? date) =>
      date != null && date.year > 1900 && date.year < 2999;
}
