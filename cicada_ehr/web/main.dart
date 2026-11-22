/// The display-only forecast page for the EHR's chart tab.
///
/// Opened by the EHR's launch (`iss` and `launch` in the address) it sends
/// the tab to the sign-in; sent back (`state` in the address) it finishes
/// the sign-in, reads the open patient's chart, runs the engine and writes
/// the forecast out in full. There is nothing to click or type: a chart
/// tab is read, never driven (Grey, 2026-11-21). Nothing is stored.
library;

import 'dart:async';
import 'dart:js_interop';

import 'package:cicada/cicada.dart';
import 'package:cicada_ehr/cicada_ehr.dart';
import 'package:fhir_auth_core/fhir_auth_core.dart';
import 'package:web/web.dart' as web;

Future<void> main() async {
  final window = currentBrowserWindow();
  final signIn = EhrSignIn(window: window);
  final timer = _Timer();
  try {
    switch (launchRequestOf(window.location)) {
      case LaunchRequest.none:
        _message(
          'Cicada opens from a patient chart.',
          'This page has no patient: the EHR opens it with the chart.',
        );
      case LaunchRequest.begin:
        _status('Signing in…');
        await signIn.begin(); // the tab leaves for the sign-in
      case LaunchRequest.finish:
        _status('Signing in…');
        final session = await signIn.finish();
        timer.mark('sign-in');
        _status('Reading the chart…');
        final read = await ChartReader(
          client: session.client,
          fhirBase: session.fhirBase,
        ).read(patientId: session.patientId, assessmentDate: DateTime.now());
        timer.mark('chart read');
        for (final report in read.reports) {
          // Counts only, for whoever runs the page; never patient data.
          web.console.log('cicada chart read: $report'.toJS);
        }
        final result = evaluateForForecast(read.parameters);
        timer.mark('engine');
        _render(ForecastView.of(result, read.patient));
        timer.mark('render');
        web.console.log(
          'cicada engine: ${result.patient.pastDoses.length} dose(s) '
                  'evaluated; ${timer.report()}'
              .toJS,
        );
    }
  } on Object catch (e) {
    web.console.log('cicada chart launch failed: $e'.toJS);
    _message('Cicada could not show a forecast.', '$e');
  }
}

/// Milliseconds since navigation began (the Navigation Timing origin) at
/// each step, for the console.
class _Timer {
  final List<(String, double)> _marks = [];

  void mark(String step) => _marks.add((step, web.window.performance.now()));

  String report() => _marks.map((m) => '${m.$1} ${m.$2.round()} ms').join(', ');
}

web.HTMLElement get _root =>
    web.document.getElementById('cicada')! as web.HTMLElement;

/// An element with [text] as its text, never as markup: everything shown
/// comes from the chart or the engine.
web.HTMLElement _el(String tag, {String? text, String? className}) {
  final e = web.document.createElement(tag) as web.HTMLElement;
  if (text != null) e.textContent = text;
  if (className != null) e.className = className;
  return e;
}

void _status(String text) {
  _root
    ..textContent = ''
    ..append(_el('p', text: text, className: 'status'));
}

void _message(String title, String detail) {
  _root
    ..textContent = ''
    ..append(_el('h1', text: title))
    ..append(_el('p', text: detail, className: 'detail'));
}

void _render(ForecastView view) {
  final page = _root..textContent = '';

  final banner = _el('header', className: 'banner');
  for (final line in view.banner) {
    banner.append(_el('span', text: line));
  }
  page.append(banner);

  final summary = _el('p', className: 'summary');
  for (final count in view.summary) {
    summary.append(_el('span', text: count));
  }
  page
    ..append(summary)
    ..append(_el('p', text: ForecastView.basis, className: 'basis'));

  for (final section in view.sections) {
    page.append(_el('h2', text: section.title));
    for (final card in section.cards) {
      page.append(_card(card));
    }
  }

  if (view.doseEvaluations.isNotEmpty) {
    page.append(_el('h2', text: 'Dose evaluations'));
    for (final group in view.doseEvaluations) {
      page.append(_doses(group));
    }
  }
}

web.HTMLElement _card(ForecastCard card) {
  final e = _el('section', className: 'card ${card.category.name}');
  final head = _el('div', className: 'card-head')
    ..append(_el('h3', text: card.title))
    ..append(
      _el(
        'span',
        text: card.category.displayLabel,
        className: 'badge ${card.category.name}',
      ),
    );
  e.append(head);
  for (final line in card.subtitles) {
    e.append(_el('p', text: line, className: 'subtitle'));
  }
  if (card.rows.isNotEmpty) {
    final rows = _el('dl');
    for (final row in card.rows) {
      rows
        ..append(_el('dt', text: row.label))
        ..append(_el('dd', text: row.value));
    }
    e.append(rows);
  }
  for (final note in card.notes) {
    e.append(_el('p', text: note, className: 'note'));
  }
  return e;
}

web.HTMLElement _doses(DoseEvaluationGroup group) {
  final e = _el('section', className: 'card')
    ..append(_el('h3', text: group.title));
  final table = _el('table');
  final head = _el('tr');
  for (final h in const ['Date given', 'CVX', 'Status', 'Reason']) {
    head.append(_el('th', text: h));
  }
  table.append(head);
  for (final row in group.rows) {
    table.append(
      _el('tr')
        ..append(_el('td', text: row.date))
        ..append(_el('td', text: row.cvx))
        ..append(_el('td', text: row.status))
        ..append(_el('td', text: row.reason ?? '')),
    );
  }
  return e..append(table);
}
