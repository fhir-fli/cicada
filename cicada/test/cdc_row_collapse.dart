// Canonical copy. `cicada_generator/lib/cdc_row_collapse.dart` must hold the
// same `collapseForComparison`; `cdc_row_collapse_sync_test.dart` fails if the
// two drift apart. They are duplicated rather than shared because a relative
// import cannot cross a package boundary and the two packages cannot depend on
// each other (excel pins archive 3.x, fhir_r4_bulk needs 4.x).

import 'package:cicada/cicada.dart';

/// Collapse a vaccine group's forecasts to the one CDC's workbook records.
///
/// ⚠️ TEST HARNESS ONLY. This is not engine logic and must not move into
/// `lib/`. FORECASTVG-1 scopes a forecast to a *series group*, and the CDSi
/// Chapter 9 intro says a patient with non-equivalent series groups "may end
/// up with more than 1 vaccine group forecast", so the engine emits one per
/// series type. CDC's workbook records **one row per case** and never says
/// which series group that row is about, so comparing against it means
/// picking one. That choice is an artefact of their file format, not a rule
/// in the specification, which is why it lives in the test harness.
///
/// The rule, read off what CDC's rows actually record: for a single-antigen
/// vaccine group the row is the risk forecast. For a multi-antigen group it is
/// the risk forecast too, unless the standard pathway still owes a dose for one
/// of the antigens that carry the risk series. That keeps an MMR traveller's
/// complete risk series from silencing a standard series still owing dose 2,
/// and keeps a pregnant patient's settled pertussis from being dragged to Not
/// Complete by tetanus and diphtheria boosters that recur for life.
VaccineGroupForecast? collapseForComparison(List<VaccineGroupForecast>? all) {
  if (all == null || all.isEmpty) return null;
  if (all.length == 1) return all.first;
  final VaccineGroupForecast? risk =
      all.where((VaccineGroupForecast f) => f.isRiskForecast).firstOrNull;
  final VaccineGroupForecast? standard =
      all.where((VaccineGroupForecast f) => !f.isRiskForecast).firstOrNull;
  if (risk == null) return standard;
  if (standard == null) return risk;

  // A single-antigen vaccine group: CDC's row is the risk one.
  final Set<String> groupAntigens = <String>{
    ...risk.antigenNames,
    ...standard.antigenNames,
  };
  if (groupAntigens.length == 1) return risk;

  // A multi-antigen group: the risk row, unless the standard pathway still
  // owes a dose for one of the antigens that carry the risk series.
  if (risk.antigensNeedingDose.isNotEmpty) return risk;
  final bool standardOwesARiskAntigen = risk.antigenNames
      .any((String a) => standard.antigensNeedingDose.contains(a));
  return standardOwesARiskAntigen ? standard : risk;
}
