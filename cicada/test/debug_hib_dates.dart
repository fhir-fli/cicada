import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:cicada/forecast/forecast.dart';

void main() {
  final lines = File('conditionTestCases.ndjson').readAsLinesSync();
  final targets = {
    '2016-UC-0057',
    '2016-UC-0060',
    '2016-UC-0068',
    '2016-UC-0072',
  };

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;
    final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
    final paramList = decoded['parameter'] as List<dynamic>?;
    if (paramList == null) continue;

    // Add "status": "completed" to Immunizations missing it
    for (final p in paramList) {
      final param = p as Map<String, dynamic>;
      if (param.containsKey('resource')) {
        final resource = param['resource'] as Map<String, dynamic>;
        if (resource['resourceType'] == 'Immunization' &&
            !resource.containsKey('status')) {
          resource['status'] = 'completed';
        }
      }
    }

    final parameters = Parameters.fromJson(decoded);
    final Patient? patient = parameters.parameter
        ?.firstWhereOrNull(
            (ParametersParameter e) => e.resource is Patient)
        ?.resource as Patient?;
    final id = patient?.id?.toString() ?? '';
    if (!targets.contains(id)) continue;

    print('============================================================');
    print('Patient: $id');
    print('============================================================');

    final result = evaluateForForecast(parameters);

    // 1. DOB and observations
    print('\n1. DOB and Observations');
    print('   DOB: ${result.patient.birthdate}');
    print('   Assessment Date: ${result.patient.assessmentDate}');
    print('   Observations (${result.patient.observations.observation?.length ?? 0}):');
    for (final obs in result.patient.observations.observation ?? []) {
      print('     Code=${obs.observationCode}: ${obs.observationTitle}');
      if (obs.period != null) {
        print('       Period: ${obs.period?.start} - ${obs.period?.end}');
      }
    }

    // 2. All administered doses
    print('\n2. Administered Doses (${result.patient.pastDoses.length}):');
    for (final dose in result.patient.pastDoses) {
      print('   ${dose.dateGiven}: CVX=${dose.cvx} MVX=${dose.mvx}'
          ' antigens=${dose.antigens}');
    }

    // 3. Hib antigen detail
    print('\n3. Hib Antigen Detail:');
    for (final antigenEntry in result.agMap.entries) {
      final antigen = antigenEntry.value;
      if (antigen.vaccineGroupName != 'Hib') continue;

      print('   Target Disease: ${antigen.targetDisease}');
      print('   Vaccine Group Name: ${antigen.vaccineGroupName}');
      print('   Contraindication: ${antigen.contraindication}');
      print('   Evidence of Immunity: ${antigen.evidenceOfImmunity}');

      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        print('\n   Group key="${groupEntry.key}":');
        print('     Series count: ${group.series.length}');
        print('     Prioritized series count: ${group.prioritizedSeries.length}');
        if (group.bestSeries != null) {
          print('     Best series: ${group.bestSeries!.series.seriesName}'
              ' [${group.bestSeries!.series.seriesType}]');
        } else {
          print('     Best series: NONE');
        }

        for (final s in group.series) {
          print('\n     --- Series: ${s.series.seriesName} ---');
          print('       Type: ${s.series.seriesType}');
          print('       Equiv: ${s.series.equivalentSeriesGroups}');
          print('       Status: ${s.seriesStatus}');
          print('       shouldReceiveAnotherDose: ${s.shouldRecieveAnotherDose}');
          print('       forecastReason: ${s.forecastReason}');
          print('       isContraindicated: ${s.isContraindicated}');
          print('       targetDose: ${s.targetDose}/${s.series.seriesDose?.length ?? 0}');
          print('       score: ${s.score}');
          print('       Evaluated doses (${s.evaluatedDoses.length}):');
          for (final d in s.evaluatedDoses) {
            print('         [td=${d.targetDoseSatisfied}] ${d.dateGiven}'
                ' CVX=${d.cvx} status=${d.evalStatus} reason=${d.evalReason}');
          }
          print('       All doses in series (${s.doses.length}):');
          for (final d in s.doses) {
            print('         ${d.dateGiven} CVX=${d.cvx}'
                ' status=${d.evalStatus} reason=${d.evalReason}'
                ' inadvertent=${d.inadvertent}');
          }
          print('       evaluatedTargetDose: ${s.evaluatedTargetDose}');

          // Forecast dates
          print('       candidateEarliestDate: ${s.candidateEarliestDate}');
          print('       adjustedRecommendedDate: ${s.adjustedRecommendedDate}');
          print('       adjustedPastDueDate: ${s.adjustedPastDueDate}');
          print('       latestDate: ${s.latestDate}');
          print('       earliestRecAgeDate: ${s.earliestRecommendedAgeDate}');
          print('       latestRecAgeDate: ${s.latestRecommendedAgeDate}');
          print('       earliestRecIntDate: ${s.earliestRecommendedIntervalDate}');
          print('       latestRecIntDate: ${s.latestRecommendedIntervalDate}');
          print('       minimumAgeDate: ${s.minimumAgeDate}');
          print('       maximumAgeDate: ${s.maximumAgeDate}');

          // Indication info for risk series
          if (s.series.seriesType == SeriesType.risk) {
            print('       Indications:');
            for (final ind in s.series.indication ?? []) {
              print('         obsCode=${ind.observationCode?.text}'
                  ' desc=${ind.description}');
            }
          }
        }
      }
    }

    // 4. VG forecast for Hib
    print('\n4. Vaccine Group Forecast (Hib):');
    final hibVG = result.vaccineGroupForecasts['Hib'];
    if (hibVG != null) {
      print('   Status: ${hibVG.status}');
      print('   Earliest: ${hibVG.earliestDate}');
      print('   Recommended: ${hibVG.recommendedDate}');
      print('   Past Due: ${hibVG.pastDueDate}');
      print('   Latest: ${hibVG.latestDate}');
      print('   Antigen Names: ${hibVG.antigenNames}');
    } else {
      print('   NOT FOUND in vaccineGroupForecasts');
      print('   Available VG keys: ${result.vaccineGroupForecasts.keys.toList()}');
    }

    // 5. Best/prioritized risk series candidateEarliestDate calculation details
    print('\n5. CandidateEarliestDate Calculation Details for Best Series:');
    for (final antigenEntry in result.agMap.entries) {
      final antigen = antigenEntry.value;
      if (antigen.vaccineGroupName != 'Hib') continue;

      for (final groupEntry in antigen.groups.entries) {
        final group = groupEntry.value;
        // Show prioritized series details
        for (final ps in group.prioritizedSeries) {
          print('\n   Prioritized series: ${ps.series.seriesName}'
              ' [${ps.series.seriesType}]');
          print('   targetDose index: ${ps.targetDose}');
          print('   candidateEarliestDate: ${ps.candidateEarliestDate}');

          // Show what _computeCandidateEarliestDate would compute
          final int td = ps.targetDose;
          if (td < (ps.series.seriesDose?.length ?? 0)) {
            final seriesDose = ps.series.seriesDose![td];
            print('   SeriesDose #$td details:');
            print('     doseNumber: ${seriesDose.doseNumber}');
            print('     recurringDose: ${seriesDose.recurringDose}');

            // Age info
            print('     Ages (${seriesDose.age?.length ?? 0}):');
            for (final age in seriesDose.age ?? []) {
              print('       minAge=${age.minAge} earliestRecAge=${age.earliestRecAge}'
                  ' latestRecAge=${age.latestRecAge} maxAge=${age.maxAge}'
                  ' effective=${age.effectiveDate} cessation=${age.cessationDate}');
              final minAgeDate = result.patient.birthdate.changeNullable(age.minAge);
              final earliestRecAgeDate = result.patient.birthdate.changeNullable(age.earliestRecAge);
              final latestRecAgeDate = result.patient.birthdate.changeNullable(age.latestRecAge);
              final maxAgeDate = result.patient.birthdate.changeNullable(age.maxAge);
              print('       -> minAgeDate=$minAgeDate'
                  ' earliestRecAgeDate=$earliestRecAgeDate'
                  ' latestRecAgeDate=$latestRecAgeDate'
                  ' maxAgeDate=$maxAgeDate');
            }

            // Interval info
            print('     Preferable Intervals (${seriesDose.preferableInterval?.length ?? 0}):');
            for (final interval in seriesDose.preferableInterval ?? []) {
              print('       fromPrevious=${interval.fromPrevious}'
                  ' fromTargetDose=${interval.fromTargetDose}'
                  ' fromMostRecent=${interval.fromMostRecent}'
                  ' minInt=${interval.minInt}'
                  ' earliestRecInt=${interval.earliestRecInt}'
                  ' latestRecInt=${interval.latestRecInt}'
                  ' priority=${interval.intervalPriority}'
                  ' effective=${interval.effectiveDate}'
                  ' cessation=${interval.cessationDate}');

              // Compute reference dose date
              VaxDate? refDate;
              String refSource = 'none';
              if (interval.fromPrevious == 'Y') {
                // Last dose with evalStatus Valid or Not Valid, not inadvertent
                for (int i = ps.doses.length - 1; i >= 0; i--) {
                  final d = ps.doses[i];
                  if (!d.inadvertent &&
                      (d.evalStatus == EvalStatus.valid ||
                          d.evalStatus == EvalStatus.not_valid)) {
                    refDate = d.dateGiven;
                    refSource = 'fromPrevious (dose ${d.dateGiven} CVX=${d.cvx})';
                    break;
                  }
                }
              } else if (interval.fromTargetDose != null) {
                final targetDoseNum = interval.fromTargetDose! - 1;
                final d = ps.doses.firstWhereOrNull(
                    (VaxDose d) => d.targetDoseSatisfied == targetDoseNum);
                if (d != null) {
                  refDate = d.dateGiven;
                  refSource = 'fromTargetDose #${interval.fromTargetDose}'
                      ' (dose ${d.dateGiven} CVX=${d.cvx})';
                }
              }
              print('       -> refDate=$refDate ($refSource)');
              if (refDate != null && interval.minInt != null) {
                final minIntDate = refDate.change(interval.minInt!);
                print('       -> minIntDate=$minIntDate (refDate + ${interval.minInt})');
              }
              if (refDate != null && interval.earliestRecInt != null) {
                final earliestRecIntDate = refDate.change(interval.earliestRecInt!);
                print('       -> earliestRecIntDate=$earliestRecIntDate (refDate + ${interval.earliestRecInt})');
              }
              if (refDate != null && interval.latestRecInt != null) {
                final latestRecIntDate = refDate.change(interval.latestRecInt!);
                print('       -> latestRecIntDate=$latestRecIntDate (refDate + ${interval.latestRecInt})');
              }
            }

            print('     Allowable Interval:');
            if (seriesDose.allowableInterval != null) {
              final ai = seriesDose.allowableInterval!;
              print('       minInt=${ai.minInt}');
            } else {
              print('       (none)');
            }

            // Conditional skip info
            print('     Conditional Skips (${seriesDose.conditionalSkip?.length ?? 0}):');
            for (final cs in seriesDose.conditionalSkip ?? []) {
              print('       context=${cs.context} setLogic=${cs.setLogic}');
              for (final set in cs.set_ ?? []) {
                print('         conditionLogic=${set.conditionLogic}');
                for (final cond in set.condition ?? []) {
                  print('           type=${cond.conditionType}'
                      ' beginAge=${cond.beginAge}'
                      ' endAge=${cond.endAge}'
                      ' interval=${cond.interval}'
                      ' doseCount=${cond.doseCount}'
                      ' doseType=${cond.doseType}'
                      ' doseCountLogic=${cond.doseCountLogic}'
                      ' vaccineTypes=${cond.vaccineTypes}'
                      ' seriesGroups=${cond.seriesGroups}');
                }
              }
            }

            // Last valid-or-not-valid dose
            VaxDose? lastVNV;
            for (int i = ps.doses.length - 1; i >= 0; i--) {
              final d = ps.doses[i];
              if (!d.inadvertent &&
                  (d.evalStatus == EvalStatus.valid ||
                      d.evalStatus == EvalStatus.not_valid)) {
                lastVNV = d;
                break;
              }
            }
            print('     Last valid/not_valid dose: ${lastVNV?.dateGiven} CVX=${lastVNV?.cvx}');

            // Last inadvertent dose
            final lastInadvertent = ps.doses.lastWhereOrNull(
                (VaxDose d) => d.evalReason == EvalReason.inadvertentVaccine);
            print('     Last inadvertent dose: ${lastInadvertent?.dateGiven}');

            // AllPatientDoses info
            print('     allPatientDoses count: ${ps.allPatientDoses.length}');
          } else {
            print('   targetDose ($td) is past end of seriesDose list'
                ' (${ps.series.seriesDose?.length ?? 0})');
          }
        }
      }
    }

    print('\n');
  }
}
