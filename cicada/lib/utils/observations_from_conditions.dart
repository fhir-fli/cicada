import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

List<VaxObservation> observationsFromConditions(
    List<Condition> conditions, VaxDate birthdate) {
  final List<VaxObservation> observations = <VaxObservation>[];
  // TODO(Dokotela): look at other systems besides Snomed
  for (final Condition condition in conditions) {
    final int? snomedIndex = condition.code?.coding?.indexWhere(
        (Coding element) =>
            element.system == FhirUri('http://snomed.info/sct'));
    final FhirCode? snomedCode = snomedIndex == null || snomedIndex == -1
        ? null
        : condition.code!.coding![snomedIndex].code;
    if (snomedCode != null) {
      final int? obsCodeIndex = scheduleSupportingData.observations?.observation
          ?.indexWhere((VaxObservation element) {
        final int? snomedCodeIndex = element.codedValues?.codedValue
            ?.indexWhere((CodedValue element) =>
                element.codeSystem == 'SNOMED' &&
                element.code == snomedCode.toString());
        return !(snomedCodeIndex == null || snomedCodeIndex == -1);
      });
      if (obsCodeIndex != null && obsCodeIndex != -1) {
        observations.add(scheduleSupportingData
            .observations!.observation![obsCodeIndex]
            .copyWith(period: periodOfCondition(condition, birthdate)));
      }
    }
  }
  return observations;
}
