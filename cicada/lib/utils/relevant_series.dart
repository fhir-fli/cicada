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
      element.requiredGender!.contains(patient.gender));

  /// The indications of [s] that apply to the patient. [requireBeginAge] false
  /// drops Table 5-4's lower age bound, keeping everything else.
  List<Indication> applicable(Series s, {required bool requireBeginAge}) {
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

  /// The latest indication begin age date the patient has reached for [s] —
  /// how specifically this series' indications describe a patient of this age.
  VaxDate ageSpecificity(Series s, {required bool requireBeginAge}) {
    VaxDate best = VaxDate.min();
    for (final Indication ind
        in applicable(s, requireBeginAge: requireBeginAge)) {
      final VaxDate begin =
          patient.birthdate.changeNullable(ind.beginAge, false) ??
              VaxDate.min();
      if (begin > best) best = begin;
    }
    return best;
  }

  /// Within a series group, the risk series whose indications are written for
  /// the patient's age win over ones written for a much younger patient.
  ///
  /// Two meningococcal risk series describe the same traveller: "ACWY risk
  /// 2-23 month" from 2 months of age and "ACWY risk 1-dose series" from 2
  /// years (and from 19 years for a microbiologist). They sit in one series
  /// group, and the infant series has the higher series priority, so
  /// SELECTSCORE-2 made it the only scorable one — for a 39-year-old
  /// microbiologist routinely exposed to *N. meningitidis*, cicada forecast a
  /// dose in his seventh month of life (`2016-UC-0198`). ACIP recommends one
  /// MenACWY dose, boosted every five years, and that is what CDC's row says.
  ///
  /// The supporting data has no way to say so: the infant series carries no
  /// maximum age to start and none of its doses carry a maximum age, so
  /// nothing ages an adult out of it — reported to CDC. Until it does, the
  /// indications themselves carry the answer, because they are age-banded:
  /// prefer the series whose applicable indication begins latest in life.
  /// Where a group's risk series are not age-banded this changes nothing,
  /// since they then share the same begin age.
  ///
  /// It applies **only to a patient with no doses for this antigen.** Once
  /// there is a history, the doses decide which series the patient is on and
  /// CDSi's scoring reads them; dropping a series because its indications
  /// start earlier in life then throws away the series their doses live in —
  /// `2023-UC-0020` lost two valid meningococcal doses and `2016-UC-0051` a
  /// HepB history that way.
  List<Series> preferMostAgeSpecific(List<Series> kept,
      {required bool requireBeginAge}) {
    final Map<String, VaxDate> bestByGroup = <String, VaxDate>{};
    final Map<String, Set<SeriesPriority?>> prioritiesByGroup =
        <String, Set<SeriesPriority?>>{};
    for (final Series s in kept) {
      if (s.seriesType != SeriesType.risk) continue;
      final String group = s.selectSeries?.seriesGroup ?? 'none';
      final VaxDate mine = ageSpecificity(s, requireBeginAge: requireBeginAge);
      final VaxDate? best = bestByGroup[group];
      if (best == null || mine > best) bestByGroup[group] = mine;
      prioritiesByGroup
          .putIfAbsent(group, () => <SeriesPriority?>{})
          .add(s.selectSeries?.seriesPriority);
    }
    return kept.where((Series s) {
      if (s.seriesType != SeriesType.risk) return true;
      final String group = s.selectSeries?.seriesGroup ?? 'none';

      /// Only where series priority is doing the choosing. Where a group's
      /// risk series share one priority, none is discarded and CDSi's own
      /// scoring settles it — a 32-year-old travelling to a Japanese
      /// encephalitis area is scored onto the series that can start earliest,
      /// which is CDC's answer (`2016-UC-0089`), and this must not overrule
      /// it.
      if ((prioritiesByGroup[group]?.length ?? 0) < 2) return true;

      final VaxDate best = bestByGroup[group] ?? VaxDate.min();
      return !(ageSpecificity(s, requireBeginAge: requireBeginAge) < best);
    }).toList();
  }

  final String? antigen =
      oldSeries.isEmpty ? null : oldSeries.first.targetDisease;
  final bool hasHistory = antigen != null &&
      patient.pastDoses.any((VaxDose d) => d.antigens.contains(antigen));

  final List<Series> strict =
      series.where((Series s) => keep(s, requireBeginAge: true)).toList();
  if (strict.isNotEmpty) {
    return hasHistory
        ? strict
        : preferMostAgeSpecific(strict, requireBeginAge: true);
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
  return hasHistory
      ? relaxed
      : preferMostAgeSpecific(relaxed, requireBeginAge: false);
}
