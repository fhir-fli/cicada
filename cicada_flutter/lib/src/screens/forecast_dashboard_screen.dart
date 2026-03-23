import 'package:cicada/cicada.dart';
import 'package:cicada_flutter/src/models/forecast_category.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:cicada_flutter/src/services/app_state.dart';
import 'package:cicada_flutter/src/widgets/vaccine_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ForecastDashboardScreen extends ConsumerWidget {
  const ForecastDashboardScreen({super.key});

  static final _dateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final result = ref.watch(forecastResultProvider);
    final patientInfo = ref.watch(patientInfoProvider);

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Forecast')),
        body: const Center(child: Text('No forecast results available.')),
      );
    }

    final assessmentDate = result.patient.assessmentDate;

    // Categorize each forecast.
    final categorized =
        <(VaccineGroupForecast, ForecastCategory)>[
          for (final f in result.vaccineGroupForecasts.values)
            (f, categorize(f, assessmentDate)),
        ]..sort(
          (a, b) => _categoryPriority(a.$2).compareTo(_categoryPriority(b.$2)),
        );

    // Counts for the summary strip.
    final actionableCount = categorized.where((e) => e.$2.isActionable).length;
    final upcomingCount = categorized
        .where((e) => e.$2 == ForecastCategory.upcoming)
        .length;
    final completeCount = categorized
        .where(
          (e) =>
              e.$2 == ForecastCategory.complete ||
              e.$2 == ForecastCategory.immune,
        )
        .length;

    // Group for section headers.
    final actionable = categorized.where((e) => e.$2.isActionable).toList();
    final upcoming = categorized
        .where((e) => e.$2 == ForecastCategory.upcoming)
        .toList();
    final done = categorized
        .where(
          (e) =>
              e.$2 == ForecastCategory.complete ||
              e.$2 == ForecastCategory.immune,
        )
        .toList();
    final other = categorized
        .where(
          (e) =>
              e.$2 == ForecastCategory.agedOut ||
              e.$2 == ForecastCategory.contraindicated ||
              e.$2 == ForecastCategory.notRecommended,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit vaccines',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Patient banner
            if (patientInfo != null) _patientBanner(context, patientInfo),
            const SizedBox(height: 12),

            // Summary strip
            _summaryStrip(
              context,
              actionableCount,
              upcomingCount,
              completeCount,
            ),
            const SizedBox(height: 16),

            // Disclaimer
            _disclaimer(theme),
            const SizedBox(height: 12),

            // Action needed section
            if (actionable.isNotEmpty) ...[
              _sectionHeader(
                context,
                'Action Needed',
                Icons.warning_amber_rounded,
                theme.colorScheme.error,
              ),
              ...actionable.map((e) => _buildCard(e, assessmentDate)),
              const SizedBox(height: 16),
            ],

            // Upcoming section
            if (upcoming.isNotEmpty) ...[
              _sectionHeader(
                context,
                'Upcoming',
                Icons.schedule,
                theme.colorScheme.onSurfaceVariant,
              ),
              ...upcoming.map((e) => _buildCard(e, assessmentDate)),
              const SizedBox(height: 16),
            ],

            // Complete section
            if (done.isNotEmpty) ...[
              _sectionHeader(
                context,
                'Complete',
                Icons.check_circle_outline,
                theme.colorScheme.primary,
              ),
              ...done.map((e) => _buildCard(e, assessmentDate)),
              const SizedBox(height: 16),
            ],

            // Other section
            if (other.isNotEmpty) ...[
              _sectionHeader(
                context,
                'Other',
                Icons.info_outline,
                theme.colorScheme.onSurfaceVariant,
              ),
              ...other.map((e) => _buildCard(e, assessmentDate)),
              const SizedBox(height: 16),
            ],

            // Evaluated doses section
            if (result.agMap.isNotEmpty) ...[
              _sectionHeader(
                context,
                'Dose Evaluations',
                Icons.fact_check_outlined,
                theme.colorScheme.onSurfaceVariant,
              ),
              ..._buildDoseEvaluations(context, result),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    (VaccineGroupForecast, ForecastCategory) entry,
    VaxDate assessmentDate,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: VaccineGroupCard(
        forecast: entry.$1,
        assessmentDate: assessmentDate,
        category: entry.$2,
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer(ThemeData theme) {
    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Based on the information you entered. '
                'Discuss with your healthcare provider.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _patientBanner(BuildContext context, PatientInfo info) {
    final theme = Theme.of(context);
    final age = _formatAge(info.birthDate);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.person,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age: $age',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '${info.sex.displayName} '
                    '— DOB: ${_dateFormat.format(info.birthDate)} '
                    '— Assessment: '
                    '${_dateFormat.format(info.effectiveAssessmentDate)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryStrip(
    BuildContext context,
    int actionableCount,
    int upcomingCount,
    int completeCount,
  ) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (actionableCount > 0)
          _summaryChip(
            context,
            '$actionableCount due now',
            theme.colorScheme.error,
          ),
        _summaryChip(
          context,
          '$upcomingCount upcoming',
          theme.colorScheme.onSurfaceVariant,
        ),
        _summaryChip(
          context,
          '$completeCount complete',
          theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _summaryChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildDoseEvaluations(
    BuildContext context,
    ForecastResult result,
  ) {
    final theme = Theme.of(context);
    final widgets = <Widget>[];

    for (final antigen in result.agMap.values) {
      for (final group in antigen.groups.values) {
        final series = group.prioritizedSeries.isNotEmpty
            ? group.prioritizedSeries.first
            : (group.series.isNotEmpty ? group.series.first : null);
        if (series == null) continue;

        final evaluatedDoses = series.doses
            .where((d) => d.evalStatus != null)
            .toList();
        if (evaluatedDoses.isEmpty) continue;

        widgets.add(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${group.vaccineGroupName}'
                    ' — ${antigen.targetDisease}',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...evaluatedDoses.map(
                    (dose) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            dose.evalStatus == EvalStatus.valid
                                ? Icons.check_circle
                                : dose.evalStatus == EvalStatus.extraneous
                                ? Icons.remove_circle_outline
                                : Icons.cancel,
                            size: 16,
                            color: dose.evalStatus == EvalStatus.valid
                                ? Colors.green
                                : dose.evalStatus == EvalStatus.extraneous
                                ? Colors.grey
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _dateFormat.format(dose.dateGiven),
                            style: theme.textTheme.bodySmall,
                          ),
                          if (dose.evalReason != null) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                dose.evalReason.toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  int _categoryPriority(ForecastCategory cat) => switch (cat) {
    ForecastCategory.overdue => 0,
    ForecastCategory.dueNow => 1,
    ForecastCategory.dueSoon => 2,
    ForecastCategory.upcoming => 3,
    ForecastCategory.complete => 4,
    ForecastCategory.immune => 5,
    ForecastCategory.contraindicated => 6,
    ForecastCategory.agedOut => 7,
    ForecastCategory.notRecommended => 8,
  };

  String _formatAge(DateTime birthDate) {
    final now = DateTime.now();
    final years = now.year - birthDate.year;
    final months = now.month - birthDate.month;
    final adjustedMonths = months < 0 ? months + 12 : months;
    final adjustedYears = months < 0 ? years - 1 : years;

    if (adjustedYears == 0) {
      return '$adjustedMonths month${adjustedMonths == 1 ? '' : 's'}';
    }
    if (adjustedYears < 3) {
      return '$adjustedYears year${adjustedYears == 1 ? '' : 's'}, '
          '$adjustedMonths month${adjustedMonths == 1 ? '' : 's'}';
    }
    return '$adjustedYears years';
  }
}
