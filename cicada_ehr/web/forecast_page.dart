/// Everything after the sign-in: read the open patient's chart, run the
/// engine and write the forecast out. Loaded on its own
/// (`deferred as` in main.dart), so the page that only starts the sign-in
/// never downloads the engine or the FHIR model.
library;

import 'dart:js_interop';

import 'package:cicada/cicada.dart';
import 'package:cicada_ehr/cicada_ehr.dart';
import 'package:web/web.dart' as web;

import 'dom.dart';

/// Reads [session]'s patient, runs the engine and shows the forecast,
/// calling [mark] after each step for the console timing.
Future<void> show(EhrSession session, void Function(String step) mark) async {
  status('Reading the chart…');
  final read = await ChartReader(
    client: session.client,
    fhirBase: session.fhirBase,
  ).read(patientId: session.patientId, assessmentDate: DateTime.now());
  mark('chart read');
  for (final report in read.reports) {
    // Counts only, for whoever runs the page; never patient data.
    web.console.log('cicada chart read: $report'.toJS);
  }
  final result = evaluateForForecast(read.parameters);
  mark('engine');
  _render(ForecastView.of(result, read.patient));
  mark('render');
  web.console.log(
    'cicada engine: ${result.patient.pastDoses.length} dose(s) evaluated'.toJS,
  );
}

void _render(ForecastView view) {
  final page = root..textContent = '';

  final banner = el('header', className: 'banner');
  for (final line in view.banner) {
    banner.append(el('span', text: line));
  }
  page.append(banner);

  final summary = el('p', className: 'summary');
  for (final count in view.summary) {
    summary.append(el('span', text: count));
  }
  page
    ..append(summary)
    ..append(el('p', text: ForecastView.basis, className: 'basis'));

  for (final section in view.sections) {
    page.append(el('h2', text: section.title));
    for (final card in section.cards) {
      page.append(_card(card));
    }
  }

  if (view.doseEvaluations.isNotEmpty) {
    page.append(el('h2', text: 'Dose evaluations'));
    for (final group in view.doseEvaluations) {
      page.append(_doses(group));
    }
  }
}

web.HTMLElement _card(ForecastCard card) {
  final e = el('section', className: 'card ${card.category.name}');
  final head = el('div', className: 'card-head')
    ..append(el('h3', text: card.title))
    ..append(
      el(
        'span',
        text: card.category.displayLabel,
        className: 'badge ${card.category.name}',
      ),
    );
  e.append(head);
  for (final line in card.subtitles) {
    e.append(el('p', text: line, className: 'subtitle'));
  }
  if (card.rows.isNotEmpty) {
    final rows = el('dl');
    for (final row in card.rows) {
      rows
        ..append(el('dt', text: row.label))
        ..append(el('dd', text: row.value));
    }
    e.append(rows);
  }
  for (final note in card.notes) {
    e.append(el('p', text: note, className: 'note'));
  }
  return e;
}

web.HTMLElement _doses(DoseEvaluationGroup group) {
  final e = el('section', className: 'card')
    ..append(el('h3', text: group.title));
  final table = el('table');
  final head = el('tr');
  for (final h in const ['Date given', 'CVX', 'Status', 'Reason']) {
    head.append(el('th', text: h));
  }
  table.append(head);
  for (final row in group.rows) {
    table.append(
      el('tr')
        ..append(el('td', text: row.date))
        ..append(el('td', text: row.cvx))
        ..append(el('td', text: row.status))
        ..append(el('td', text: row.reason ?? '')),
    );
  }
  return e..append(table);
}
