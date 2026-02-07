import 'package:collection/collection.dart';

import '../cicada.dart';

class VaxGroup {
  VaxGroup({
    required this.targetDisease,
    required this.vaccineGroup,
    required this.vaccineGroupName,
    required this.series,
    required this.assessmentDate,
    required this.dob,
  });

  void newSeries(Series newSeries) => series.add(
        VaxSeries(
          targetDisease: targetDisease,
          series: newSeries,
          assessmentDate: assessmentDate,
          dob: dob,
        ),
      );

  void newDose(VaxDose dose) {
    for (final VaxSeries singleSeries in series) {
      singleSeries.doses.add(dose.copyWith());
    }
  }

  void evaluate() {
    for (final VaxSeries singleSeries in series) {
      singleSeries.evaluate();
    }
  }

  List<VaxSeries> getRelevantSeries(List<VaxSeries> series) {
    final List<VaxSeries> relevantSeries = series
        .where((VaxSeries element) =>
            element.seriesStatus != SeriesStatus.contraindicated)
        .toList();
    return relevantSeries.isEmpty ? series.toList() : relevantSeries;
  }

  List<VaxSeries> getScorableSeries(List<VaxSeries> relevantSeries) {
    final Set<VaxSeries> scorableSeries = <VaxSeries>{};

    /// All the following are true for the relevant patient series:
    /// o The relevant patient series tracks an antigen series with a series
    ///   type of 'Risk.'
    /// o The series priority of the antigen series tracked by the relevant
    ///   patient series is the same as or greater than the series priority of
    ///   any relevant patient series that tracks an antigen series that
    ///   belongs to the same series group as the relevant patient series.
    /// o It is a candidate scorable patient series.
    final List<VaxSeries> riskSeries = relevantSeries
        .where(
            (VaxSeries element) => element.series.seriesType == SeriesType.risk)
        .toList();
    if (riskSeries.isNotEmpty) {
      riskSeries.sortByCompare(
          (VaxSeries element) => element.series.selectSeries?.seriesPriority,
          (SeriesPriority? a, SeriesPriority? b) =>
              (a?.index ?? 5).compareTo(b?.index ?? 5));
      riskSeries.retainWhere((VaxSeries element) =>
          element.series.selectSeries?.seriesPriority ==
          riskSeries.first.series.selectSeries?.seriesPriority);
      scorableSeries.addAll(riskSeries);
    }

    /// All the following are true for the relevant patient series:
    /// o The relevant patient series tracks an antigen series with a series
    ///   type of 'Standard.'
    final List<VaxSeries> standardSeries = relevantSeries
        .where((VaxSeries element) =>
            element.series.seriesType == SeriesType.standard)
        .toList();
    if (standardSeries.isNotEmpty) {
      /// o The relevant patient series includes a target dose evaluating at
      ///   least one vaccine dose administered with an evaluation status of
      ///   'Valid'.
      /// o The earliest vaccine dose administered with an evaluation status of
      ///   'Valid' associated with the relevant patient series has a date
      ///   administered before the maximum age to start date.
      /// o It is a candidate scorable patient series.
      final List<VaxSeries> validDosesSeries = standardSeries
          .where((VaxSeries element) => element.evaluatedDoses
              .any((VaxDose dose) => dose.evalStatus == EvalStatus.valid))
          .toList();
      if (validDosesSeries.isNotEmpty) {
        validDosesSeries.retainWhere((VaxSeries series) =>
            series.evaluatedDoses
                .firstWhere(
                    (VaxDose dose) => dose.evalStatus == EvalStatus.valid)
                .dateGiven <
            dob.changeNullable(
                series.series.selectSeries?.maxAgeToStart, true)!);
        scorableSeries.addAll(validDosesSeries);
      } else {
        /// o The number of valid doses is 0 for each relevant patient series
        ///   in the series group.
        /// o There is no default patient series for the series group.
        /// o It is a candidate scorable patient series.
        final List<VaxSeries> defaultSeries = standardSeries
            .where((VaxSeries element) =>
                element.series.selectSeries?.defaultSeries == Binary.yes)
            .toList();
        if (defaultSeries.isEmpty) {
          scorableSeries.addAll(standardSeries);
        }
      }
    }

    /// o The relevant patient series tracks an antigen series with a series
    ///   type of 'Evaluation Only'
    /// o The relevant patient series is a complete patient series.
    final Iterable<VaxSeries> competedEvaluationOnlySeries =
        relevantSeries.where((VaxSeries element) =>
            element.series.seriesType == SeriesType.evaluationOnly &&
            element.seriesStatus == SeriesStatus.complete);
    scorableSeries.addAll(competedEvaluationOnlySeries);
    return scorableSeries.toList();
  }

  VaxSeries? getPrioritizedSeries(
      List<VaxSeries> scorableSeries, List<VaxSeries> series) {
    if (scorableSeries.isEmpty) {
      final List<VaxSeries> defaultSeries = series
          .where((VaxSeries element) =>
              element.series.selectSeries?.defaultSeries == Binary.yes)
          .toList();
      if (defaultSeries.isNotEmpty) {
        return defaultSeries.first;
      }
    } else if (scorableSeries.length == 1) {
      return scorableSeries.first;
    } else {
      final List<VaxSeries> completeSeries = scorableSeries
          .where((VaxSeries element) =>
              element.seriesStatus == SeriesStatus.complete)
          .toList();
      if (completeSeries.length == 1) {
        return completeSeries.first;
      } else if (completeSeries.isEmpty) {
        final Iterable<VaxSeries> inProcessSeries = scorableSeries.where(
            (VaxSeries element) =>
                element.evaluatedTargetDose.values
                    .contains(TargetDoseStatus.satisfied) &&
                element.seriesStatus == SeriesStatus.notComplete);
        if (inProcessSeries.length == 1) {
          return inProcessSeries.first;
        } else if (inProcessSeries.isEmpty) {
          final List<VaxSeries> defaultSeries = scorableSeries
              .where((VaxSeries element) =>
                  element.series.selectSeries?.defaultSeries == Binary.yes)
              .toList();
          if (defaultSeries.isNotEmpty) {
            return defaultSeries.first;
          }
        }
      }
    }
    return null;
  }

  List<VaxSeries> scoreCompleteSeries(List<VaxSeries> completeSeries) {
    /// Find what is the maximum number of valid doses in a series
    /// While we're at it, count how many series have that many doses
    int maxNumberOfValidDoses = 0;
    int numberOfSeriesWithMaxValidDoses = 0;
    for (final VaxSeries series in completeSeries) {
      final int numberOfValidDosesForSeries = series.evaluatedDoses
          .where((VaxDose element) => element.evalStatus == EvalStatus.valid)
          .length;
      if (numberOfValidDosesForSeries > maxNumberOfValidDoses) {
        maxNumberOfValidDoses = numberOfValidDosesForSeries;
        numberOfSeriesWithMaxValidDoses = 1;
      } else if (numberOfValidDosesForSeries == maxNumberOfValidDoses) {
        numberOfSeriesWithMaxValidDoses++;
      }
    }

    for (final VaxSeries series in completeSeries) {
      final Iterable<VaxDose> validDoses = series.evaluatedDoses
          .where((VaxDose element) => element.evalStatus == EvalStatus.valid);

      /// If this series is a series with the maximum number of valid doses
      if (validDoses.length == maxNumberOfValidDoses) {
        /// If there is only one series that has that many valid doses
        /// it gets a score of 1
        if (numberOfSeriesWithMaxValidDoses == 1) {
          series.score = 1;
        }

        /// else - it means there is more than 1 series with that many valid
        /// doses, and the score is 0, which is the default score so we don't
        /// have to do anything
      } else {
        /// Otherwise, it means that the series has fewer than the most valid
        /// doses, and therefore gets a score of -1
        series.score = -1;
      }
    }
    return completeSeries;
  }

  List<VaxSeries> scoreInProcessSeries(List<VaxSeries> inProcessSeries) {
    /// Find what is the maximum number of valid doses in a series
    /// While we're at it, count how many series have that many doses
    int numberOfProductSeriesWithAllValidDoses = 0;
    int numberOfCompletableSeries = 0;
    int maxNumberOfValidDoses = 0;
    int numberOfSeriesWithMaxValidDoses = 0;
    int minNumDosesToCompleteASeries = 99;
    int numberOfSeriesClosestToCompletion = 0;
    VaxDate earliestFinishDate = VaxDate.max();
    int numberOfSeriesWithEarliestFinishDate = 0;

    for (final VaxSeries series in inProcessSeries) {
      final int numberOfValidDosesForSeries = series.evaluatedDoses
          .where((VaxDose element) => element.evalStatus == EvalStatus.valid)
          .length;

      /// A scorable patient series is a product patient series and has all
      /// valid doses.
      /// A patient series must be considered a product patient series if the
      /// product path flag is 'Y' for the select patient series.
      if (series.series.selectSeries?.productPath == Binary.yes &&
          numberOfValidDosesForSeries == series.evaluatedDoses.length) {
        numberOfProductSeriesWithAllValidDoses++;
      }

      /// The forecast finish date for a scorable patient series must be
      /// calculated as the earliest date of the patient series forecast made
      /// from the scorable patient series plus the latest minimum interval from
      /// the remaining target dose(s).
      VaxDate? forecastFinishDate = series.candidateEarliestDate;
      if (forecastFinishDate != null) {
        for (int i = series.targetDose;
            i < (series.series.seriesDose?.length ?? 0);
            i++) {
          forecastFinishDate = forecastFinishDate!.change(
              series.series.seriesDose?[i].allowableInterval?.minInt ??
                  '0 days');
        }

        /// A patient series must be considered completable if the forecast
        /// finish date is less than the maximum age date of the last target dose.
        final VaxDate maxAgeDateLastTargetDose = series.series.maxAgeDate(dob);

        if (forecastFinishDate! < maxAgeDateLastTargetDose) {
          numberOfCompletableSeries++;

          /// A scorable patient series can finish earliest.
          /// A patient series can finish earliest if the patient series is
          /// completable and the forecast finish date is on or before the
          /// forecast finish date in all other completable patient series.
          if (forecastFinishDate < earliestFinishDate) {
            earliestFinishDate = forecastFinishDate;
            numberOfSeriesWithEarliestFinishDate = 1;
          } else if (forecastFinishDate == earliestFinishDate) {
            numberOfSeriesWithEarliestFinishDate++;
          }
        }
      }

      /// A scorable patient series has the most valid doses.
      if (numberOfValidDosesForSeries > maxNumberOfValidDoses) {
        maxNumberOfValidDoses = numberOfValidDosesForSeries;
        numberOfSeriesWithMaxValidDoses = 1;
      } else if (numberOfValidDosesForSeries == maxNumberOfValidDoses) {
        numberOfSeriesWithMaxValidDoses++;
      }

      /// A scorable patient series is closest to completion.
      /// A patient series must be the considered the closest to completion if
      /// the number of not satisfied target doses is less than the number of
      /// not satisfied target doses in all other patient series.
      final int minDosesForSeriesToComplete =
          (series.series.seriesDose?.length ?? 99) - series.targetDose - 1;
      if (minDosesForSeriesToComplete < minNumDosesToCompleteASeries) {
        minNumDosesToCompleteASeries = minDosesForSeriesToComplete;
        numberOfSeriesClosestToCompletion = 1;
      } else if (minDosesForSeriesToComplete == minNumDosesToCompleteASeries) {
        numberOfSeriesClosestToCompletion++;
      }
    }

    for (final VaxSeries series in inProcessSeries) {
      final int numberOfValidDosesForSeries = series.evaluatedDoses
          .where((VaxDose element) => element.evalStatus == EvalStatus.valid)
          .length;

      /// A scorable patient series is a product patient series and has all valid doses.
      if (series.series.selectSeries?.productPath == Binary.yes &&
          numberOfValidDosesForSeries == series.evaluatedDoses.length) {
        if (numberOfProductSeriesWithAllValidDoses == 1) {
          series.score += 2;
        }
      } else {
        series.score -= 2;
      }

      VaxDate? forecastFinishDate = series.candidateEarliestDate;
      if (forecastFinishDate != null) {
        for (int i = series.targetDose;
            i < (series.series.seriesDose?.length ?? 0);
            i++) {
          forecastFinishDate = forecastFinishDate!.change(
              series.series.seriesDose?[i].allowableInterval?.minInt ??
                  '0 days');
        }
        final VaxDate maxAgeDateLastTargetDose = series.series.maxAgeDate(dob);

        /// A scorable patient series is completable.
        if (forecastFinishDate! < maxAgeDateLastTargetDose) {
          if (numberOfCompletableSeries == 1) {
            series.score += 3;
          }
        } else {
          series.score -= 3;
        }

        /// A scorable patient series has the most valid doses.
        if (numberOfValidDosesForSeries == maxNumberOfValidDoses) {
          if (numberOfSeriesWithMaxValidDoses == 1) {
            series.score += 2;
          }
        } else {
          series.score -= 2;
        }

        /// A scorable patient series is closest to completion.
        final int missingDoses =
            (series.series.seriesDose?.length ?? 99) - series.targetDose - 1;
        if (missingDoses == minNumDosesToCompleteASeries) {
          if (numberOfSeriesClosestToCompletion == 1) {
            series.score += 2;
          }
        } else {
          series.score -= 2;
        }

        /// A scorable patient series can finish earliest.
        if (forecastFinishDate == earliestFinishDate) {
          if (numberOfSeriesWithEarliestFinishDate == 1) {
            series.score += 1;
          }
        } else {
          series.score -= 1;
        }
      }
    }

    return inProcessSeries;
  }

  List<VaxSeries> scoreZeroValidDosesSeries(
      List<VaxSeries> zeroValidDosesSeries) {
    VaxDate earliestStartDate = VaxDate.max();
    int numberOfSeriesWithEarliestStartDate = 0;
    int numberOfCompletableSeries = 0;
    int numberOfProductSeries = 0;
    for (final VaxSeries series in zeroValidDosesSeries) {
      /// A scorable patient series can start earliest.
      /// A patient series must be considered start earliest if the start date
      /// is before the start date for all other patient series with a start date.
      if (series.series.seriesDose?.first.seasonalRecommendation?.startDate !=
          null) {
        final VaxDate startDate = VaxDate.fromJson(
            series.series.seriesDose!.first.seasonalRecommendation!.startDate!);
        if (startDate < earliestStartDate) {
          earliestStartDate = startDate;
          numberOfSeriesWithEarliestStartDate = 1;
        } else if (startDate == earliestStartDate) {
          numberOfSeriesWithEarliestStartDate++;
        }
      }

      /// A scorable patient series is completable.
      VaxDate? forecastFinishDate = series.candidateEarliestDate;
      if (forecastFinishDate != null) {
        for (int i = series.targetDose;
            i < (series.series.seriesDose?.length ?? 0);
            i++) {
          forecastFinishDate = forecastFinishDate!.change(
              series.series.seriesDose?[i].allowableInterval?.minInt ??
                  '0 days');
        }
        final VaxDate maxAgeDateLastTargetDose = series.series.maxAgeDate(dob);

        /// A scorable patient series is completable.
        /// A patient series must be considered completable if the forecast
        /// finish date is less than the maximum age date of the last target
        /// dose.
        if (forecastFinishDate! < maxAgeDateLastTargetDose) {
          numberOfCompletableSeries++;
        }
      }

      /// A patient series must be considered a product patient series if the
      /// product path flag is 'Y' for the select patient series.
      if (series.series.selectSeries?.productPath == Binary.yes) {
        numberOfProductSeries++;
      }
    }

    for (final VaxSeries series in zeroValidDosesSeries) {
      /// A scorable patient series can start earliest.
      /// A patient series must be considered start earliest if the start date
      /// is before the start date for all other patient series with a start date.
      if (series.series.seriesDose?.first.seasonalRecommendation?.startDate !=
          null) {
        final VaxDate startDate = VaxDate.fromJson(
            series.series.seriesDose!.first.seasonalRecommendation!.startDate!);
        if (startDate == earliestStartDate) {
          if (numberOfSeriesWithEarliestStartDate == 1) {
            series.score += 1;
          }
        } else {
          series.score -= 1;
        }
      } else {
        series.score -= 1;
      }

      /// A scorable patient series is completable.
      VaxDate? forecastFinishDate = series.candidateEarliestDate;
      if (forecastFinishDate != null) {
        for (int i = series.targetDose;
            i < (series.series.seriesDose?.length ?? 0);
            i++) {
          forecastFinishDate = forecastFinishDate!.change(
              series.series.seriesDose?[i].allowableInterval?.minInt ??
                  '0 days');
        }
        final VaxDate maxAgeDateLastTargetDose = series.series.maxAgeDate(dob);

        /// A scorable patient series is completable.
        /// A patient series must be considered completable if the forecast
        /// finish date is less than the maximum age date of the last target
        /// dose.
        if (forecastFinishDate! < maxAgeDateLastTargetDose) {
          if (numberOfCompletableSeries == 1) {
            series.score += 1;
          }
        } else {
          series.score -= 1;
        }
      }

      /// A patient series must be considered a product patient series if the
      /// product path flag is 'Y' for the select patient series.
      if (series.series.selectSeries?.productPath == Binary.yes) {
        if (numberOfProductSeries == 1) {
          series.score -= 1;
        }
      } else {
        series.score += 1;
      }
    }

    return zeroValidDosesSeries;
  }

  void forecast(
    bool evidenceOfImmunity,
    List<VaccineContraindication> vaccineContraindications,
  ) {
    this.evidenceOfImmunity = evidenceOfImmunity;
    for (final VaxSeries element in series) {
      element.forecast(vaccineContraindications, evidenceOfImmunity);
    }

    final List<VaxSeries> relevantSeries = getRelevantSeries(series);
    final List<VaxSeries> scorableSeries = getScorableSeries(relevantSeries);
    final VaxSeries? tempPrioritizedSeries =
        getPrioritizedSeries(scorableSeries, series);
    if (tempPrioritizedSeries != null) {
      prioritizedSeries.add(tempPrioritizedSeries);
    } else {
      classifyScorableSeries(scorableSeries);
      determineBestSeries();
    }
  }

  void classifyScorableSeries(List<VaxSeries> scorableSeries) {
    final List<VaxSeries> completeScorableSeries = scorableSeries
        .where((VaxSeries element) =>
            element.seriesStatus == SeriesStatus.complete)
        .toList();
    final List<VaxSeries> scoredSeries = <VaxSeries>[];
    if (completeScorableSeries.length == 1) {
      scoredSeries.add(completeScorableSeries.first);
    } else if (completeScorableSeries.length >= 2) {
      scoredSeries.addAll(scoreCompleteSeries(completeScorableSeries));
    } else {
      final List<VaxSeries> inProcessSeries = scorableSeries
          .where((VaxSeries element) =>
              element.evaluatedTargetDose.values
                  .contains(TargetDoseStatus.satisfied) &&
              element.seriesStatus == SeriesStatus.notComplete)
          .toList();
      if (inProcessSeries.length == 1) {
        scoredSeries.add(inProcessSeries.first);
      } else if (inProcessSeries.length >= 2) {
        scoredSeries.addAll(scoreInProcessSeries(inProcessSeries));
      } else {
        scoredSeries.addAll(scoreZeroValidDosesSeries(scorableSeries
            .where((VaxSeries element) => element.targetDose == 0)
            .toList()));
      }
    }

    if (scoredSeries.isNotEmpty) {
      prioritizedScoredSeries(scoredSeries);
    }
  }

  void prioritizedScoredSeries(List<VaxSeries> scoredSeries) {
    int highestScore = -99;
    for (final VaxSeries series in scoredSeries) {
      if (series.score > highestScore) {
        highestScore = series.score;
      }
    }
    scoredSeries
        .retainWhere((VaxSeries element) => element.score == highestScore);
    if (scoredSeries.length != 1) {
      int preference = 10;
      for (final VaxSeries series in scoredSeries) {
        if ((series.series.selectSeries?.seriesPriority?.index ?? 10) <
            preference) {
          preference = series.series.selectSeries!.seriesPriority!.index;
        }
      }
      scoredSeries.retainWhere((VaxSeries element) =>
          element.series.selectSeries!.seriesPriority!.index == preference);
      prioritizedSeries.addAll(scoredSeries);
    } else {
      prioritizedSeries.add(scoredSeries.first);
    }
  }

  void determineBestSeries() {
    if (prioritizedSeries.length == 1) {
      if (prioritizedSeries.first.seriesStatus == SeriesStatus.complete) {
        bestSeries = prioritizedSeries.first;
      } else if (prioritizedSeries.first.series.seriesType !=
          SeriesType.evaluationOnly) {
        if (prioritizedSeries.first.series.seriesType == SeriesType.risk) {
          bestSeries = prioritizedSeries.first;
        }
      }
    }
  }

  String targetDisease;
  String vaccineGroup;
  String vaccineGroupName;
  List<VaxSeries> series;
  VaxDate assessmentDate;
  VaxDate dob;
  bool evidenceOfImmunity = false;
  List<VaxSeries> prioritizedSeries = <VaxSeries>[];
  VaxSeries? bestSeries;
}
