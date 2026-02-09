import '../cicada.dart';

List<Series> relevantSeries(
  VaxPatient patient,
  List<Series> oldSeries,
) {
  final List<Series> series = oldSeries.toList();
  series.retainWhere((Series element) =>
      element.requiredGender == null ||
      element.requiredGender!.isEmpty ||
      element.requiredGender!.contains(patient.gender));

  /// Keep each series where....
  series.retainWhere((Series series) {
    /// If it's a Standard or Evaluation Only Series
    if (series.seriesType == SeriesType.standard ||
        series.seriesType == SeriesType.evaluationOnly) {
      return true;
    }

    /// If it's a Risk group
    else if (series.seriesType == SeriesType.risk) {
      /// Get the list of indications for this series
      final List<String>? indicationList = series.indication
          ?.map((Indication e) => e.observationCode?.code ?? '')
          .toList();

      /// If the indicationList is null, it means there are no conditions to
      /// meet (this is probably an error in the rules), but either way,
      /// we don't include this series
      if (indicationList == null) {
        return false;
      } else {
        /// Because in the above mapping, we inserted a '' if there are any
        /// nulls, so we remove those
        indicationList.retainWhere((String e) => e != '');

        /// If that leaves an empty list, there are no indications (again,
        /// probably an error and we don't include this series)
        if (indicationList.isEmpty) {
          return false;
        }

        /// Otherwise, we look to see if there is an observation from the
        /// list of the patient's observations, that is also included as
        /// one of the indications for this series
        else {
          final int obsIndex = indicationList.indexWhere((String obsCode) {
            if (patient.observations.codeIndex(obsCode) == -1) {
              return false;
            }
            // Find the matching indication in this series (by obsCode)
            final ind = series.indication!.firstWhere(
              (i) => i.observationCode?.code == obsCode,
            );
            return patient.birthdate
                        .changeNullable(ind.beginAge, false)! <=
                    patient.assessmentDate &&
                patient.assessmentDate <
                    patient.birthdate
                        .changeNullable(ind.endAge, true)!;
          });
          return obsIndex != -1;
        }
      }
    } else {
      return false;
    }
  });

  return series;
}
