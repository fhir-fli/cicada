import 'dart:async';

import 'package:cicada_ehr/cicada_ehr.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:cicada_flutter/src/screens/forecast_dashboard_screen.dart';
import 'package:cicada_flutter/src/services/app_state.dart';
import 'package:cicada_flutter/src/services/forecast_service.dart';
import 'package:fhir_auth_core/fhir_auth_core.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// The app as the EHR opens it: sign in, read the open patient's chart, and
/// show the forecast. Nothing is stored.
class ChartLaunchScreen extends ConsumerStatefulWidget {
  const ChartLaunchScreen({
    required this.request,
    required this.window,
    super.key,
  });

  final LaunchRequest request;
  final BrowserWindow window;

  @override
  ConsumerState<ChartLaunchScreen> createState() => _ChartLaunchScreenState();
}

class _ChartLaunchScreenState extends ConsumerState<ChartLaunchScreen> {
  String _step = 'Signing in…';
  String? _failure;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    final signIn = EhrSignIn(window: widget.window);
    try {
      if (widget.request == LaunchRequest.begin) {
        await signIn.begin(); // the page leaves for the sign-in
        return;
      }
      final session = await signIn.finish();
      _show('Reading the chart…');
      final read = await ChartReader(
        client: session.client,
        fhirBase: session.fhirBase,
      ).read(patientId: session.patientId, assessmentDate: DateTime.now());
      for (final report in read.reports) {
        // Counts only, for whoever runs the app; never patient data.
        debugPrint('cicada chart read: $report');
      }
      final result = ForecastService.runForecastOnChart(read.parameters);
      debugPrint(
        'cicada engine: ${result.patient.pastDoses.length} dose(s) evaluated',
      );
      ref.read(patientInfoProvider.notifier).value = _patientInfo(
        read.patient,
      );
      ref.read(forecastResultProvider.notifier).value = result;
      if (mounted) setState(() => _ready = true);
    } on Object catch (e) {
      debugPrint('cicada chart launch failed: $e');
      if (mounted) setState(() => _failure = '$e');
    }
  }

  void _show(String step) {
    if (mounted) setState(() => _step = step);
  }

  /// The banner's demographics, when the chart gives a birth date and a
  /// male or female administrative gender; otherwise no banner.
  static PatientInfo? _patientInfo(Patient patient) {
    final birthDate = patient.birthDate?.valueDateTime;
    final sex = switch (patient.gender?.valueString) {
      'male' => PatientSex.male,
      'female' => PatientSex.female,
      _ => null,
    };
    if (birthDate == null || sex == null) return null;
    return PatientInfo(birthDate: birthDate, sex: sex);
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return const ForecastDashboardScreen(fromChart: true);
    final theme = Theme.of(context);
    final failure = _failure;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: failure == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(_step, style: theme.textTheme.titleMedium),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cicada could not show a forecast.',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SelectableText(failure, textAlign: TextAlign.center),
                  ],
                ),
        ),
      ),
    );
  }
}
