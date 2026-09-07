import '../cicada.dart';

/// The vaccine recommendation category of a Best Patient Series, per CDC's
/// "Vaccine Recommendation Category Determination" (CDSi supporting data
/// 4.65, 2026): Routine, High-Risk, or SCDM (shared clinical decision
/// making), with CDC's material for it.
class VaccineRecommendationCategoryResult {
  VaccineRecommendationCategoryResult({
    required this.category,
    required this.material,
    required this.row,
  });

  /// "Routine", "High-Risk" or "SCDM", as CDC writes it.
  final String category;

  /// The "Additional Material" URLs, split on CDC's semicolon.
  final List<String> material;

  /// The worksheet row that determined it.
  final VaccineRecommendationCategory row;
}

/// Determines the vaccine recommendation category for one Best Patient
/// Series, following CDC's document section by section:
///
/// * "Patient Not Recommended Further Vaccination": only a series whose
///   status is Not Complete has a category. Anything else returns null.
/// * "Supporting Data Structure": the candidate rows are those whose Best
///   Patient Series Name is this series. Each row's Patient Begin Age
///   (inclusive) and End Age (exclusive, "less than") are compared with the
///   patient's current age; Forecast Target Dose is a number, a semicolon
///   list, or "Any"; Included Indication is "n/a" (no check), "Any" (the
///   patient must have at least one of the series' indications, with the
///   Excluded Indications removed from that list), or a list (the patient
///   must have at least one of them). All criteria must be met.
/// * "No Rows Determined": null.
/// * "Two or More Rows Determined": High-Risk takes priority over SCDM,
///   Routine takes priority over SCDM. A series is never both High-Risk and
///   Routine; if the data ever says so, the first row wins.
///
/// [forecastTargetDoseNumber] is the dose number of the target dose being
/// forecast, as the antigen series numbers it (1 for Dose 1).
/// [patientObservationCodes] are the CDSi observation codes the patient
/// carries; [seriesIndications] are the series' Indication rows, which is
/// what "Any" ranges over.
VaccineRecommendationCategoryResult? determineVaccineRecommendationCategory({
  required AntigenSupportingData antigen,
  required String seriesName,
  required SeriesStatus status,
  required int forecastTargetDoseNumber,
  required VaxDate birthdate,
  required VaxDate assessmentDate,
  required Set<String> patientObservationCodes,
  required List<Indication> seriesIndications,
}) {
  if (status != SeriesStatus.notComplete) return null;
  final rows = (antigen.vaccineRecommendationCategory ?? const [])
      .where((r) => r.seriesName == seriesName)
      .toList();
  if (rows.isEmpty) return null;

  final seriesIndicationCodes = seriesIndications
      .map((i) => i.observationCode?.code)
      .whereType<String>()
      .toSet();
  final patientSeriesIndications =
      patientObservationCodes.intersection(seriesIndicationCodes);

  final matching = <VaccineRecommendationCategory>[];
  for (final row in rows) {
    // Patient Begin Age (on or after) and Patient End Age (less than).
    final begin = _na(row.patientBeginAge);
    if (begin != null && assessmentDate < birthdate.change(begin)) continue;
    final end = _na(row.patientEndAge);
    if (end != null && !(assessmentDate < birthdate.change(end))) continue;

    // Forecast Target Dose: a number, "2; 3; 4", or "Any".
    final dose = _na(row.forecastTargetDose);
    if (dose != null && dose.toLowerCase() != 'any') {
      final numbers = dose
          .split(';')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toSet();
      if (!numbers.contains(forecastTargetDoseNumber)) continue;
    }

    // Included / Excluded Indication.
    final included = _na(row.includedIndication);
    if (included != null) {
      final excluded = _codes(row.excludedIndication);
      if (included.toLowerCase() == 'any') {
        if (patientSeriesIndications.difference(excluded).isEmpty) continue;
      } else {
        final wanted = _codes(included);
        if (patientSeriesIndications.intersection(wanted).isEmpty) continue;
      }
    }
    matching.add(row);
  }
  if (matching.isEmpty) return null;

  VaccineRecommendationCategory chosen = matching.first;
  if (matching.length > 1) {
    // "High-Risk takes priority over SCDM" and "Routine takes priority over
    // SCDM": anything beats SCDM; otherwise the first row stands.
    chosen = matching.firstWhere(
      (r) => (r.category ?? '').toUpperCase() != 'SCDM',
      orElse: () => matching.first,
    );
  }
  return VaccineRecommendationCategoryResult(
    category: chosen.category ?? '',
    material: (_na(chosen.additionalMaterial) ?? '')
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(),
    row: chosen,
  );
}

String? _na(String? v) =>
    v == null || v.trim().isEmpty || v.trim().toLowerCase() == 'n/a'
        ? null
        : v.trim();

/// The observation codes in "Diabetes (014); HIV Infection (186)".
Set<String> _codes(String? list) {
  final s = _na(list);
  if (s == null || s.toLowerCase() == 'any') return const {};
  final out = <String>{};
  for (final part in s.split(';')) {
    final open = part.lastIndexOf('(');
    final close = part.lastIndexOf(')');
    if (open != -1 && close > open) {
      out.add(part.substring(open + 1, close).trim());
    } else if (part.trim().isNotEmpty) {
      out.add(part.trim());
    }
  }
  return out;
}
