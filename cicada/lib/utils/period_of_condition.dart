import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

Period periodOfCondition(Condition condition, VaxDate birthdate) {
  VaxDate? startDate;
  VaxDate? endDate;

  /// Check to see if it's active, if it is, then we know we don't have to look
  /// for an end time
  final int? activeIndex = condition.clinicalStatus?.coding?.indexWhere((Coding
          element) =>
      element.system ==
          FhirUri('http://terminology.hl7.org/CodeSystem/condition-clinical') &&
      element.code.toString().toLowerCase() == 'active');

  /// If there's a valid onsetDateTime it's easy
  if (condition.onsetDateTime?.valueDateTime != null) {
    startDate = VaxDate.fromDateTime(condition.onsetDateTime!.valueDateTime!);
  }

  /// If it's an age, we have to look through the age Object
  else if (condition.onsetAge != null) {
    startDate = dateFromAge(birthdate, condition.onsetAge!);
  } else if (condition.onsetRange != null) {
    if (condition.onsetRange?.low != null) {
      startDate = dateFromQuantity(birthdate, condition.onsetRange!.low!);
    } else if (condition.onsetRange!.high != null) {
      startDate = dateFromQuantity(birthdate, condition.onsetRange!.high!);
    }
  } else if (condition.onsetString?.valueString != null) {
    final fhirDateTime =
        FhirDateTime.tryParse(condition.onsetString!.valueString);
    if (fhirDateTime?.valueDateTime != null) {
      startDate = VaxDate.fromDateTime(fhirDateTime!.valueDateTime!);
    }
  }

  if (activeIndex == null || activeIndex == -1) {
    /// If there's a valid abatementDateTime it's easy
    if (condition.abatementDateTime?.valueDateTime != null) {
      endDate =
          VaxDate.fromDateTime(condition.abatementDateTime!.valueDateTime!);
    }

    /// If it's an age, we have to look through the age Object
    else if (condition.abatementAge != null) {
      endDate = dateFromAge(birthdate, condition.abatementAge!);
    } else if (condition.abatementRange != null) {
      if (condition.abatementRange?.low != null) {
        endDate = dateFromQuantity(birthdate, condition.abatementRange!.low!);
      } else if (condition.abatementRange!.high != null) {
        endDate = dateFromQuantity(birthdate, condition.abatementRange!.high!);
      }
    } else if (condition.abatementString?.valueString != null) {
      if (FhirDateTime.tryParse(condition.abatementString!.valueString) !=
          null) {
        endDate = VaxDate.fromDateTime(
            FhirDateTime.tryParse(condition.abatementString)!.valueDateTime!);
      }
    }
  }

  return Period(
    start: startDate?.toFhirDateTime(),
    end: endDate?.toFhirDateTime(),
  );
}

VaxDate? dateFromAge(VaxDate birthdate, Age age) {
  /// Ensure it has a numerical value
  final double? value = age.value?.valueDouble;
  if (value != null) {
    /// Ensure the units are not null
    if (age.unit != null) {
      final String unit = age.unit!.toLowerCase();
      if (unit == 'year' || unit == 'years' || unit == 'a' || unit == 'y') {
        return birthdate.change('$value years');
      } else if (unit == 'month' || unit == 'months' || unit == 'm') {
        return birthdate.change('$value months');
      } else if (unit == 'day' || unit == 'days' || unit == 'd') {
        return birthdate.change('$value days');
      }
    }
  }
  return null;
}

VaxDate? dateFromQuantity(VaxDate birthdate, Quantity quantity) {
  /// Ensure it has a numerical value
  final double? value = quantity.value?.valueDouble;
  if (value != null) {
    /// Ensure the units are not null
    if (quantity.unit != null) {
      final String unit = quantity.unit!.toLowerCase();
      if (unit == 'year' || unit == 'years' || unit == 'a' || unit == 'y') {
        return birthdate.change('$value years');
      } else if (unit == 'month' || unit == 'months' || unit == 'm') {
        return birthdate.change('$value months');
      } else if (unit == 'day' || unit == 'days' || unit == 'd') {
        return birthdate.change('$value days');
      }
    }
  }
  return null;
}
