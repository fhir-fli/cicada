import 'package:cicada_flutter/src/models/forecast_category.dart';
import 'package:cicada_flutter/src/theme/cicada_theme.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.category});

  final ForecastCategory category;

  @override
  Widget build(BuildContext context) {
    final (color, label) = _style;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, String) get _style => switch (category) {
    ForecastCategory.complete => (
      CicadaTheme.statusComplete,
      'Complete',
    ),
    ForecastCategory.immune => (CicadaTheme.statusImmune, 'Immune'),
    ForecastCategory.overdue => (CicadaTheme.statusOverdue, 'Overdue'),
    ForecastCategory.dueNow => (CicadaTheme.statusDue, 'Due Now'),
    ForecastCategory.dueSoon => (
      CicadaTheme.statusDue,
      'Due Soon',
    ),
    ForecastCategory.upcoming => (
      CicadaTheme.statusNotRecommended,
      'Upcoming',
    ),
    ForecastCategory.contraindicated => (
      CicadaTheme.statusContraindicated,
      'Contraindicated',
    ),
    ForecastCategory.agedOut => (CicadaTheme.statusAgedOut, 'Aged Out'),
    ForecastCategory.notRecommended => (
      CicadaTheme.statusNotRecommended,
      'Not Recommended',
    ),
  };
}
