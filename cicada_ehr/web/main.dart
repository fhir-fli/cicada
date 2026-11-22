/// The display-only forecast page for the EHR's chart tab.
///
/// Opened by the EHR's launch (`iss` and `launch` in the address) it sends
/// the tab to the sign-in; sent back (`state` in the address) it finishes
/// the sign-in, reads the open patient's chart, runs the engine and writes
/// the forecast out in full. There is nothing to click or type: a chart
/// tab is read, never driven (Grey, 2026-11-21). Nothing is stored.
///
/// This file holds only the sign-in. The chart read, engine and display are
/// forecast_page.dart, loaded on its own: the first page load (which only
/// sends the tab to the sign-in) skips them, and the second fetches them
/// while the EHR makes the token.
library;

import 'dart:js_interop';

import 'package:cicada_ehr/src/ehr_sign_in.dart';
import 'package:fhir_auth_core/fhir_auth_core.dart';
import 'package:web/web.dart' as web;

import 'dom.dart';
import 'forecast_page.dart' deferred as forecast_page;

Future<void> main() async {
  final window = currentBrowserWindow();
  final signIn = EhrSignIn(window: window);
  final timer = _Timer();
  try {
    switch (launchRequestOf(window.location)) {
      case LaunchRequest.none:
        message(
          'Cicada opens from a patient chart.',
          'This page has no patient: the EHR opens it with the chart.',
        );
      case LaunchRequest.begin:
        status('Signing in…');
        await signIn.begin(); // the tab leaves for the sign-in
      case LaunchRequest.finish:
        status('Signing in…');
        // Downloaded while the sign-in finishes. ignore() keeps a failed
        // download from being reported unhandled if the sign-in fails
        // first; the await below still receives its error.
        final pageCode = forecast_page.loadLibrary()..ignore();
        final session = await signIn.finish();
        timer.mark('sign-in');
        await pageCode;
        timer.mark('page code');
        await forecast_page.show(session, timer.mark);
        web.console.log('cicada timing: ${timer.report()}'.toJS);
    }
  } on Object catch (e) {
    web.console.log('cicada chart launch failed: $e'.toJS);
    message('Cicada could not show a forecast.', '$e');
  }
}

/// Milliseconds since navigation began (the Navigation Timing origin) at
/// each step, for the console.
class _Timer {
  final List<(String, double)> _marks = [];

  void mark(String step) => _marks.add((step, web.window.performance.now()));

  String report() => _marks.map((m) => '${m.$1} ${m.$2.round()} ms').join(', ');
}
