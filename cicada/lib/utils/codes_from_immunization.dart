import 'package:fhir_r4/fhir_r4.dart';
import '../cicada.dart';

String? cvxFromImmunization(Immunization immunization) =>
    codeFromImmunization(immunization, FhirUri('http://hl7.org/fhir/sid/cvx'));

String? mvxFromImmunization(Immunization immunization) =>
    codeFromImmunization(
        immunization, FhirUri('http://hl7.org/fhir/sid/mvx')) ??
    codeFromImmunization(
        immunization, FhirUri('http://terminology.hl7.org/NamingSystem/MVX'));

String? codeFromImmunization(Immunization immunization, FhirUri url) {
  final int? index = immunization.vaccineCode.coding?.indexWhere(
      (Coding element) => element.system == url && element.code != null);
  if (index == null || index == -1) {
    return null;
  } else {
    return immunization.vaccineCode.coding![index].code!.toString();
  }
}

EvalReason? subpotentReason(Immunization immunization) {
  int? codingIndex;
  final int? subpotentIndex = immunization.subpotentReason
      ?.indexWhere((CodeableConcept codeableConcept) {
    codingIndex = codeableConcept.coding?.indexWhere((Coding coding) =>
        coding.system ==
            FhirUri(
                'http://terminology.hl7.org/CodeSystem/immunization-subpotent-reason') &&
        (coding.display != null || coding.code != null));
    return !(codingIndex == null || codingIndex == -1);
  });
  if (subpotentIndex == null ||
      subpotentIndex == -1 ||
      codingIndex == null ||
      codingIndex == -1) {
    return null;
  } else {
    if (immunization
            .subpotentReason![subpotentIndex].coding![codingIndex!].code !=
        null) {
      final EvalReason? evalReason = EvalReason.fromCode(immunization
          .subpotentReason![subpotentIndex]
          .coding![codingIndex!]
          .code
          ?.valueString);
      if (evalReason != null) {
        return evalReason;
      } else {
        return EvalReason.fromJson(immunization.subpotentReason![subpotentIndex]
            .coding![codingIndex!].display!.valueString);
      }
    } else {
      return null;
    }
  }
}
