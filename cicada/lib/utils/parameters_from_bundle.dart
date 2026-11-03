import 'package:fhir_r4/fhir_r4.dart';

/// A Bundle of the patient's records as forecast input, the shape of the
/// Swiss vaccination guide's recommendation request (ch.fhir.ig.ch-vacd 6.0.0,
/// `ch-vacd-recommendation-request-message`: Patient, Immunization,
/// Condition, AllergyIntolerance, Observation, Organization entries). Each
/// entry becomes a parameter named for its resource type. That message
/// carries no assessment date, so none is set and the engine uses today.
Parameters parametersFromBundle(Bundle bundle) => Parameters(
  parameter: [
    for (final entry in bundle.entry ?? const <BundleEntry>[])
      if (entry.resource != null)
        ParametersParameter(
          name:
              _lowerFirst(entry.resource!.resourceType.toString()).toFhirString,
          resource: entry.resource,
        ),
  ],
);

String _lowerFirst(String s) =>
    s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);
