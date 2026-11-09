// Prints the CDSi observations the engine assigns to single real-world codes.
//
// Written 2026-10-18 when the crosswalk (cicada_generator/lib/crosswalk/
// observation_crosswalk.json) turned out to file 21 code sets under the wrong
// observation number: asplenia came out as 018 "Laboratory Evidence of
// Immunity or confirmation of Hepatitis A disease". CDC's test cases send the
// CDSi observation code directly, so none of them reach the crosswalk.
// test/crosswalk_keying_test.dart asserts these; this prints them.
//
//   cd cicada/cicada && dart run tool/probe_crosswalk_keying.dart
import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';

void main() {
  const cases = [
    ('http://hl7.org/fhir/sid/icd-10-cm', 'D73.0', 'Hyposplenism'),
    (
      'http://hl7.org/fhir/sid/icd-10-cm',
      'Z90.81',
      'Acquired absence of spleen',
    ),
    ('http://hl7.org/fhir/sid/icd-10-cm', 'N18.4', 'CKD stage 4'),
    ('http://hl7.org/fhir/sid/icd-10-cm', 'B20', 'HIV disease'),
    (
      'http://hl7.org/fhir/sid/icd-10-cm',
      'T50.B95A',
      'Adverse effect of viral vaccine',
    ),
    ('http://hl7.org/fhir/sid/icd-10-cm', 'J45.50', 'Severe persistent asthma'),
    ('http://loinc.org', '16935-9', 'HBsAb units'),
    ('http://loinc.org', '32018-4', 'HepA IgG presence'),
    ('http://loinc.org', '7962-4', 'Measles IgG units'),
    ('http://www.nlm.nih.gov/research/umls/rxnorm', '281', 'Acyclovir'),
  ];
  for (final (system, code, label) in cases) {
    final found = observationsFromCodeableConcept(
      CodeableConcept(
        coding: [Coding(system: FhirUri(system), code: FhirCode(code))],
      ),
    );
    final names =
        found.isEmpty
            ? 'none'
            : found
                .map((o) => '${o.observationCode} ${o.observationTitle}')
                .join(' | ');
    stdout.writeln('$label ($code) -> $names');
  }
}
