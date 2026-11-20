import 'package:cicada_flutter/src/screens/chart_launch_screen.dart';
import 'package:cicada_flutter/src/screens/welcome_screen.dart';
import 'package:cicada_flutter/src/services/ehr_session.dart';
import 'package:cicada_flutter/src/theme/cicada_theme.dart';
import 'package:fhir_auth/fhir_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class CicadaApp extends StatelessWidget {
  const CicadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Cicada — Vaccine Forecast',
        theme: CicadaTheme.light,
        debugShowCheckedModeBanner: false,
        home: _home(),
      ),
    );
  }

  /// A web page opened by an EHR launch, or sent back by the sign-in, shows
  /// the patient's chart forecast; anything else is the manual-entry app.
  static Widget _home() {
    if (!kIsWeb) return const WelcomeScreen();
    final window = currentBrowserWindow();
    final request = launchRequestOf(window.location);
    if (request == LaunchRequest.none) return const WelcomeScreen();
    return ChartLaunchScreen(request: request, window: window);
  }
}
