import 'package:cicada/cicada.dart';
import 'package:cicada_ehr/cicada_ehr.dart';
import 'package:cicada_flutter/src/widgets/status_badge.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class VaccineGroupCard extends StatelessWidget {
  const VaccineGroupCard({
    super.key,
    required this.forecast,
    required this.assessmentDate,
    required this.category,
  });

  final VaccineGroupForecast forecast;
  final VaxDate assessmentDate;
  final ForecastCategory category;

  static final _dateFormat = DateFormat.yMMMd();

  /// The lines under the vaccine group name.
  ///
  /// A vaccine group holding a standard and a risk series group gets one
  /// forecast for each (CDSi Logic Specification v4.6, Table 9-2
  /// FORECASTVG-1; Chapter 9 intro: patients "may end up with more than 1
  /// vaccine group forecast for a given vaccine group"), so two cards can carry
  /// the same group name. A risk card says so, and names the chart entries
  /// that put the patient on that series (the forecast's
  /// supportingReferences), so the two can be told apart.
  Widget? _subtitle(ThemeData theme) {
    final lines = <String>[
      if (forecast.antigenNames.length > 1) forecast.antigenNames.join(', '),
      if (forecast.isRiskForecast) _riskLine(),
    ];
    if (lines.isEmpty) return null;
    return Text(
      lines.join('\n'),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  String _riskLine() {
    final label = forecast.seriesGroupName ?? 'Increased risk';
    final because = forecast.supportingReferences
        .map((r) => r.display)
        .whereType<String>()
        .toSet()
        .join(', ');
    return because.isEmpty ? label : '$label: $because';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ExpansionTile(
        leading: _vaccineIcon(theme),
        title: Text(
          forecast.vaccineGroupName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: _subtitle(theme),
        trailing: StatusBadge(category: category),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (forecast.status == SeriesStatus.notComplete) ...[
                  if (forecast.doseNumber != null)
                    _infoRow(
                      context,
                      'Next dose',
                      'Dose #${forecast.doseNumber}',
                    ),
                  if (_isValidDate(forecast.earliestDate))
                    _dateRow(
                      context,
                      'Earliest',
                      forecast.earliestDate!,
                    ),
                  if (_isValidDate(forecast.recommendedDate))
                    _dateRow(
                      context,
                      'Recommended',
                      forecast.recommendedDate!,
                      bold: true,
                    ),
                  if (_isValidDate(forecast.pastDueDate))
                    _dateRow(
                      context,
                      'Past due',
                      forecast.pastDueDate!,
                      isWarning: category == ForecastCategory.overdue,
                    ),
                  if (_isValidDate(forecast.latestDate))
                    _dateRow(
                      context,
                      'Latest',
                      forecast.latestDate!,
                    ),
                ],
                if (forecast.status == SeriesStatus.complete)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'All doses in this series have been completed.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                if (forecast.status == SeriesStatus.immune)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Evidence of immunity — no further doses needed.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vaccineIcon(ThemeData theme) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Icon(
        Icons.vaccines,
        size: 18,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _dateRow(
    BuildContext context,
    String label,
    DateTime date, {
    bool bold = false,
    bool isWarning = false,
  }) {
    final theme = Theme.of(context);
    final color = isWarning
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            _dateFormat.format(date),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(value, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  bool _isValidDate(VaxDate? date) =>
      date != null && date.year > 1900 && date.year < 2999;
}
