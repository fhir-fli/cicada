import 'package:fhir_r4/fhir_r4.dart';

bool isSubstandard(Immunization immunization) {
  /// We require that an occurrenceDateTime be available, otherwise for now
  /// we're going to consider it substandard
  // TODO(Dokotela): - should this actually be considered substandard?
  if (immunization.occurrenceDateTime?.valueDateTime != null) {
    /// If the immunization is subpotent, regardless of the reason, we are
    /// not going to include it in evaluations
    if (immunization.isSubpotent?.valueBoolean ?? false) {
      return true;
    }

    /// Otherwise, if it has an expiration date
    else if (immunization.expirationDate != null) {
      /// we check if it was expired when it was given, that means, is the
      /// expiration date BEFORE the date it was given (if it is the same
      /// date, we are still going to consider this valid)
      if (immunization.expirationDate != null
          // &&
          //     immunization.expirationDate! < immunization.occurrenceDateTime!
          ) {
        return true;
      } else {
        return false;
      }
    } else {
      /// If there is no expiration date, we assume it's valid and we include
      /// it in the list for evaluation
      return false;
    }
  }
  return true;
}
