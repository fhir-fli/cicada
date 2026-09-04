import 'package:fhir_r4/fhir_r4.dart';

import '../cicada.dart';

/// The patient's recorded administrative sex, as CDSi's `requiredGender` reads
/// it.
///
/// R4 binds `Patient.gender` required to male | female | other | unknown, and
/// its own definition calls the element administrative. CDSi never says what
/// its Gender attribute means: its glossary reads "Patient Gender: the
/// patient's gender", and every sex-based rule in the supporting data inherits
/// the distinction from the ACIP recommendation behind it rather than defining
/// one. So this reads the record and does not infer.
///
/// Anything that is not male or female becomes [Gender.unknown], which is what
/// FHIR `other`, `unknown`, an absent element and any non-conformant string all
/// map to. That is deliberate and it is fail-open: CDC lists Unknown alongside
/// Female on every female-scoped series, so an unknown patient still receives
/// those forecasts.
///
/// There used to be a `Gender.transgender` branch here, reachable because
/// fhir_r4 does not enforce the required binding. It was harmful: no
/// `requiredGender` in CDSi 4.65-508 lists that value, and the gate is a
/// positive allow-list rather than a "not male" test, so such a patient matched
/// 2 of the 10 gender-gated series against 8 for `other`. They received no HPV
/// forecast at all. Transgender is not a gender value in CDSi; it is
/// observation 075, a risk indication for mpox vaccination, which the engine
/// matches like any other coded observation.
Gender genderFromPatient(Patient patient) {
  final String? g = patient.gender?.toString().toLowerCase();
  if (g == 'f' || g == 'female') return Gender.female;
  if (g == 'm' || g == 'male') return Gender.male;
  return Gender.unknown;
}
