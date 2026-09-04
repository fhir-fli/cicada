import '../cicada.dart';

/// Table 5-5: which of an antigen's series are relevant patient series.
///
/// Standard and Evaluation Only series are always relevant; a Risk series is
/// relevant only when one of the indications that drives it applies to the
/// patient (Table 5-4).
List<Series> relevantSeries(
  VaxPatient patient,
  List<Series> oldSeries,
) {
  final List<Series> series = oldSeries.toList();
  series.retainWhere((Series element) =>
      element.requiredGender == null ||
      element.requiredGender!.isEmpty ||
      element.requiredGender!.contains(patient.gender) ||
      _pregnancyOutranksGender(element, patient));

  List<Indication> applicable(Series s, {required bool requireBeginAge}) =>
      applicableIndications(patient, s, requireBeginAge: requireBeginAge);

  bool keep(Series s, {required bool requireBeginAge}) {
    if (s.seriesType == SeriesType.standard ||
        s.seriesType == SeriesType.evaluationOnly) {
      return true;
    }
    if (s.seriesType == SeriesType.risk) {
      return applicable(s, requireBeginAge: requireBeginAge).isNotEmpty;
    }
    return false;
  }

  final List<Series> strict =
      series.where((Series s) => keep(s, requireBeginAge: true)).toList();
  if (strict.isNotEmpty) {
    return strict;
  }

  /// Nothing is relevant yet, and the only thing standing between the patient
  /// and a recommendation is their age: forecast the antigen anyway, from the
  /// series' own minimum age.
  ///
  /// Table 5-4 requires the indication begin age date to be on or before the
  /// assessment date, and while several series compete for a patient that
  /// bound is what picks between them — dropping it globally handed a
  /// three-year-old the "Pneumococcal risk 6-18 years" and "19+ years" series.
  /// But when it silences the antigen outright, CDC's own data says forecast:
  /// a child of 8 with laboratory-confirmed dengue living where dengue is
  /// endemic is told to come back on their ninth birthday (`2022-UC-0001` at 8
  /// years 11 months and `2022-UC-0005` at 8 years 7 months — two deliberate
  /// cases, both dated to the birthday), where the engine said nothing at all.
  final List<Series> relaxed =
      series.where((Series s) => keep(s, requireBeginAge: false)).toList();
  return relaxed;
}

/// Table 5-4: the indications of [s] that apply to [patient].
///
/// [requireBeginAge] false drops Table 5-4's lower age bound, keeping
/// everything else — see the note in [relevantSeries] for when that applies.
///
/// Shared so that a caller reporting *why* a risk series applied uses the same
/// test that made it apply, rather than a second copy of the rule.
List<Indication> applicableIndications(
  VaxPatient patient,
  Series s, {
  required bool requireBeginAge,
}) {
  final List<Indication> indications = s.indication ?? <Indication>[];
  return indications.where((Indication ind) {
    final String? code = ind.observationCode?.code;
    if (code == null || code.isEmpty) return false;
    if (patient.observations.codeIndex(code) == -1) return false;
    final bool beforeEnd = patient.assessmentDate <
        patient.birthdate.changeNullable(ind.endAge, true)!;
    if (!requireBeginAge) return beforeEnd;
    return patient.birthdate.changeNullable(ind.beginAge, false)! <=
            patient.assessmentDate &&
        beforeEnd;
  }).toList();
}

/// 🛑 DELIBERATE DEVIATION FROM CDSi. A recorded sex must not exclude a
/// pregnant patient from Tdap.
///
/// The pertussis risk 1-dose series carries BOTH `requiredGender`
/// Female-or-Unknown AND an indication on observation 007, Pregnant, whose own
/// text reads "Administer to women who are pregnant". The indication already
/// establishes the anatomy the recommendation is about, so the gender gate adds
/// nothing and can only exclude: a pregnant patient whose record says `male`
/// satisfies the indication and fails the gate.
///
/// ACIP recommends Tdap in every pregnancy. The clinically relevant fact is the
/// pregnancy, not the administrative sex on the record, and administrative sex
/// is what `Patient.gender` carries by its own R4 definition. A trans man, or
/// anyone whose recorded sex does not match their anatomy, is exactly the
/// patient this gate drops.
///
/// Scoped to pregnancy on purpose. Of the eleven gender-gated series in
/// 4.65-508, this is the only one whose indication is the qualifying state
/// itself; the ten HPV ones are gated on age or immunocompromise and exist as
/// duplicated male and non-male pairs with identical doses, ages and intervals,
/// so ignoring gender there would match both pairs and forecast twice.
///
/// Raised with CDC and put to OpenEvidence rather than decided here alone.
bool _pregnancyOutranksGender(Series series, VaxPatient patient) {
  const pregnantObservation = '007';
  final bool gated = series.indication?.any((Indication i) =>
          i.observationCode?.code == pregnantObservation) ??
      false;
  if (!gated) return false;
  return patient.observations.observation?.any(
          (VaxObservation o) => o.observationCode == pregnantObservation) ??
      false;
}
