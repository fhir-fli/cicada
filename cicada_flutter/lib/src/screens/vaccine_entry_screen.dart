import 'dart:async';

import 'package:cicada_flutter/src/models/entered_dose.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:cicada_flutter/src/models/vaccine_data.dart';
import 'package:cicada_flutter/src/screens/forecast_dashboard_screen.dart';
import 'package:cicada_flutter/src/services/app_state.dart';
import 'package:cicada_flutter/src/services/forecast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class VaccineEntryScreen extends ConsumerStatefulWidget {
  const VaccineEntryScreen({super.key});

  @override
  ConsumerState<VaccineEntryScreen> createState() => _VaccineEntryScreenState();
}

class _VaccineEntryScreenState extends ConsumerState<VaccineEntryScreen> {
  final _dateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doses = ref.watch(enteredDosesProvider);
    final patientInfo = ref.watch(patientInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccine History'),
        actions: [
          FilledButton.icon(
            onPressed: () => _runForecast(patientInfo, doses),
            icon: const Icon(Icons.assessment),
            label: const Text('Get Forecast'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVaccineSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Vaccine'),
      ),
      body: SafeArea(
        child: doses.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.vaccines_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(
                          100,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No vaccines entered yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap "Add Vaccine" to enter your vaccine history, '
                        'or tap "Get Forecast" to see what\'s recommended '
                        'with no prior doses.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                itemCount: doses.length,
                itemBuilder: (context, index) {
                  final dose = doses[index];
                  return Dismissible(
                    key: ValueKey(
                      '$index-${dose.vaccineId}-${dose.dateGiven}',
                    ),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      color: theme.colorScheme.error,
                      child: Icon(
                        Icons.delete,
                        color: theme.colorScheme.onError,
                      ),
                    ),
                    onDismissed: (_) {
                      ref.read(enteredDosesProvider.notifier).removeAt(index);
                    },
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          child: Text(
                            dose.vaccineLabel.substring(
                              0,
                              dose.vaccineLabel.length > 3
                                  ? 3
                                  : dose.vaccineLabel.length,
                            ),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                        title: Text(dose.vaccineLabel),
                        subtitle: Text(_dateFormat.format(dose.dateGiven)),
                        trailing: dose.isComboGenerated
                            ? Tooltip(
                                message: 'Added from combo vaccine',
                                child: Icon(
                                  Icons.link,
                                  size: 16,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _runForecast(PatientInfo? patientInfo, List<EnteredDose> doses) {
    if (patientInfo == null) return;

    try {
      final result = ForecastService.runForecast(
        patientInfo: patientInfo,
        doses: doses,
      );
      ref.read(forecastResultProvider.notifier).value = result;
      unawaited(
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ForecastDashboardScreen(),
          ),
        ),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Forecast error: $e')),
      );
    }
  }

  void _showAddVaccineSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => _VaccinePickerSheet(
            scrollController: scrollController,
            onSelected: _addVaccine,
          ),
        ),
      ),
    );
  }

  void _addVaccine(VaccineCardEntry entry, DateTime date) {
    if (entry.isCombo) {
      // Add the combo vaccine itself
      ref
          .read(enteredDosesProvider.notifier)
          .add(
            EnteredDose(
              vaccineId: entry.id,
              vaccineLabel: entry.label,
              cvx: entry.defaultCvx,
              dateGiven: date,
            ),
          );
    } else {
      ref
          .read(enteredDosesProvider.notifier)
          .add(
            EnteredDose(
              vaccineId: entry.id,
              vaccineLabel: entry.label,
              cvx: entry.defaultCvx,
              dateGiven: date,
            ),
          );
    }
  }
}

class _VaccinePickerSheet extends StatefulWidget {
  const _VaccinePickerSheet({
    required this.scrollController,
    required this.onSelected,
  });

  final ScrollController scrollController;
  final void Function(VaccineCardEntry entry, DateTime date) onSelected;

  @override
  State<_VaccinePickerSheet> createState() => _VaccinePickerSheetState();
}

class _VaccinePickerSheetState extends State<_VaccinePickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _showCombos = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VaccineCardEntry> get _filteredEntries {
    final entries = _showCombos ? comboVaccineEntries : vaccineCardEntries;
    if (_query.isEmpty) return entries;
    return entries.where((e) => e.matches(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredEntries;

    // Group by category when not searching and not showing combos.
    final grouped = <VaccineCategory, List<VaccineCardEntry>>{};
    if (_query.isEmpty && !_showCombos) {
      for (final entry in filtered) {
        grouped.putIfAbsent(entry.category, () => []).add(entry);
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _showCombos ? 'Combo Vaccines' : 'Add Vaccine',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _showCombos = !_showCombos),
                child: Text(
                  _showCombos ? 'Individual' : 'Combo Vaccines',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name, disease, or brand...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: _query.isEmpty && !_showCombos
              ? ListView(
                  controller: widget.scrollController,
                  children: [
                    for (final category in VaccineCategory.values)
                      if (grouped.containsKey(category)) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Text(
                            category.displayName,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        ...grouped[category]!.map(
                          (e) => _VaccinePickerTile(
                            entry: e,
                            onSelected: widget.onSelected,
                          ),
                        ),
                      ],
                  ],
                )
              : ListView.builder(
                  controller: widget.scrollController,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _VaccinePickerTile(
                    entry: filtered[index],
                    onSelected: widget.onSelected,
                  ),
                ),
        ),
      ],
    );
  }
}

class _VaccinePickerTile extends StatelessWidget {
  const _VaccinePickerTile({
    required this.entry,
    required this.onSelected,
  });

  final VaccineCardEntry entry;
  final void Function(VaccineCardEntry, DateTime) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: entry.isCombo
          ? Icon(Icons.merge_type, color: theme.colorScheme.tertiary)
          : null,
      title: Text(entry.label),
      subtitle: Text(
        entry.isCombo ? entry.description : entry.description,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.add_circle_outline),
      onTap: () => _pickDateAndAdd(context),
    );
  }

  Future<void> _pickDateAndAdd(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      initialDate: now,
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'When was this vaccine given?',
    );
    if (picked != null && context.mounted) {
      onSelected(entry, picked);
      Navigator.of(context).pop();
    }
  }
}
