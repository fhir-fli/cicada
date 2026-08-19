/// A switchable record of what the engine decided, step by step.
///
/// CDSi is a long pipeline — evaluate doses, decide forecast need, score and
/// select series, aggregate to the vaccine group — and when the final answer
/// is wrong the interesting question is always *which step first diverged*.
/// Without this, answering that meant adding print statements, re-running,
/// deleting them, and doing it again for the next case.
///
/// Off by default and free when off: every call site is
/// `ForecastTrace.current?.log(...)`, so a null check is the entire cost.
///
/// ```dart
/// final trace = ForecastTrace.begin();
/// final result = forecastFromParameters(parameters);
/// ForecastTrace.end();
/// print(trace.render());
/// ```
library;

/// One recorded decision.
class TraceEntry {
  TraceEntry({
    required this.step,
    required this.subject,
    required this.detail,
  });

  /// The CDSi step this belongs to, e.g. `'8.14 best patient series'`.
  final String step;

  /// What it is about — an antigen, a series, a vaccine group, a dose.
  final String subject;

  /// What was decided, and the values it turned on.
  final String detail;

  @override
  String toString() => '$subject — $detail';
}

/// Collects [TraceEntry]s while the engine runs.
class ForecastTrace {
  ForecastTrace._();

  /// The trace currently collecting, or null when tracing is off.
  static ForecastTrace? current;

  final List<TraceEntry> entries = <TraceEntry>[];

  /// Starts a new trace and installs it as [current].
  static ForecastTrace begin() => current = ForecastTrace._();

  /// Stops tracing. Anything already collected stays readable.
  static void end() => current = null;

  void log(String step, String subject, String detail) =>
      entries.add(TraceEntry(step: step, subject: subject, detail: detail));

  /// Entries for one step, in the order they were recorded.
  List<TraceEntry> forStep(String step) =>
      entries.where((TraceEntry e) => e.step == step).toList();

  /// The steps seen, in first-seen order — the pipeline as it actually ran.
  List<String> get steps {
    final List<String> seen = <String>[];
    for (final TraceEntry e in entries) {
      if (!seen.contains(e.step)) seen.add(e.step);
    }
    return seen;
  }

  /// Human-readable, grouped by step. [subjectFilter] narrows to subjects
  /// containing that text, case-insensitively — usually an antigen or group.
  String render({String? subjectFilter}) {
    final StringBuffer out = StringBuffer();
    for (final String step in steps) {
      final List<TraceEntry> rows = forStep(step).where((TraceEntry e) {
        if (subjectFilter == null) return true;
        return e.subject.toLowerCase().contains(subjectFilter.toLowerCase());
      }).toList();
      if (rows.isEmpty) continue;
      out.writeln('──────────── $step');
      for (final TraceEntry e in rows) {
        out.writeln('  $e');
      }
      out.writeln();
    }
    return out.toString();
  }
}
