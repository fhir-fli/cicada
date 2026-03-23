import 'dart:async';

import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:cicada_flutter/src/screens/vaccine_entry_screen.dart';
import 'package:cicada_flutter/src/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PatientSetupScreen extends ConsumerStatefulWidget {
  const PatientSetupScreen({super.key});

  @override
  ConsumerState<PatientSetupScreen> createState() => _PatientSetupScreenState();
}

class _PatientSetupScreenState extends ConsumerState<PatientSetupScreen> {
  DateTime? _birthDate;
  PatientSex _sex = PatientSex.male;
  final _dateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Info')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter basic demographics to get started.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),

                  // Date of birth
                  Text(
                    'Date of Birth',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickBirthDate,
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        hintText: 'Select date of birth',
                      ),
                      child: _birthDate != null
                          ? Text(_dateFormat.format(_birthDate!))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sex
                  Text(
                    'Sex',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<PatientSex>(
                    segments: PatientSex.values
                        .map(
                          (s) => ButtonSegment(
                            value: s,
                            label: Text(s.displayName),
                          ),
                        )
                        .toList(),
                    selected: {_sex},
                    onSelectionChanged: (set) {
                      setState(() => _sex = set.first);
                    },
                  ),
                  const SizedBox(height: 48),

                  FilledButton.icon(
                    onPressed: _birthDate != null ? _proceed : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      initialDate: _birthDate ?? DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Select date of birth',
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _proceed() {
    final info = PatientInfo(birthDate: _birthDate!, sex: _sex);
    ref.read(patientInfoProvider.notifier).value = info;
    ref.read(enteredDosesProvider.notifier).clear();
    ref.read(forecastResultProvider.notifier).clear();
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const VaccineEntryScreen(),
        ),
      ),
    );
  }
}
