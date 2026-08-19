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

  /// Whether any indication of [s] applies. [requireBeginAge] false drops
  /// Table 5-4's lower age bound, keeping everything else.
  bool indicated(Series s, {required bool requireBeginAge}) {
    final List<String>? indicationList = s.indication
        ?.map((Indication e) => e.observationCode?.code ?? '')
        .toList();

    /// A risk series with no indications cannot be driven by anything (this
    /// is probably an error in the rules), so it is never relevant.
    if (indicationList == null) {
      return false;
    }

    /// The mapping above inserted '' for nulls; drop those.
    indicationList.retainWhere((String e) => e != '');
    if (indicationList.isEmpty) {
      return false;
    }

    return indicationList.indexWhere((String obsCode) {
          if (patient.observations.codeIndex(obsCode) == -1) {
            return false;
          }
          final Indication ind = s.indication!.firstWhere(
            (Indication i) => i.observationCode?.code == obsCode,
          );
          final bool beforeEnd = patient.assessmentDate <
              patient.birthdate.changeNullable(ind.endAge, true)!;
          if (!requireBeginAge) {
            return beforeEnd;
          }
          return patient.birthdate.changeNullable(ind.beginAge, false)! <=
                  patient.assessmentDate &&
              beforeEnd;
        }) !=
        -1;
  }

  bool keep(Series s, {required bool requireBeginAge}) {
    if (s.seriesType == SeriesType.standard ||
        s.seriesType == SeriesType.evaluationOnly) {
      return true;
    }
    if (s.seriesType == SeriesType.risk) {
      return indicated(s, requireBeginAge: requireBeginAge);
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
  return series.where((Series s) => keep(s, requireBeginAge: false)).toList();
}
