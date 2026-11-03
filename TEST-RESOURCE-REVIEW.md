# How cicada builds its test resources, against HL7's examples

Reviewed 2026-11-02. Sources read: FHIR R4 `examples-json.zip` (all 5 Immunization
examples, `immunization.profile.json`), ImmDS IG 1.0.0 (`OperationDefinition-ImmDSForecastOperation`,
`Parameters-parameters-in-example`, `Immunization-ImmDSImmunizationExample`), US Core 3.1.0 `Immunization-imm-1`.

ImmDS `$immds-forecast` inputs: `assessmentDate` (date, 1..1), `patient` (Patient, 1..1),
`immunization` (Immunization, 0..*). Nothing else.

## The CDC suites (generator `cicada_generator/lib/test_cases/test_case_generator.dart`, 1,401 cases)

| # | What we build | What HL7 shows | Count |
|---|---|---|---|
| 1 | Assessment date as a parameter whose *name* is the date, no value | `name: assessmentDate`, `valueDate` | 1,401 cases |
| 2 | Patient parameter named `Patient` | `patient` | 1,401 |
| 3 | Manufacturer (MVX) as a second coding in `vaccineCode` | `Immunization.manufacturer`, a Reference(Organization); no example puts MVX in `vaccineCode` | 2,363 of 2,957 doses |
| 4 | CVX coding's display is CDC's vaccine name (e.g. `RECOMBIVAX-ADULT`) | the CVX display | 2,957 doses |
| 5 | Every CDSi observation sent as a `Condition` coded with our own CodeSystem plus CDC's SNOMED codes, in a parameter `condition` | ImmDS has no input for clinical history; a chart holds allergies as AllergyIntolerance, labs as Observation, transplants as Procedure, therapy as MedicationStatement | 379 Conditions, 113 codes, 337 cases |
| 6 | `Patient.name.family` = the test case's title | — | 1,401 |
| 7 | Gender branch for `transgender`, not an AdministrativeGender code | `male`/`female`/`other`/`unknown` | 0 cases reach it |

## Hand-written tests and examples

`immds_response_test`, `dose_without_date_or_id_test`, `patient_without_birth_date_test`,
`forecast_mode_data_test`, `example/forecast-input.json`, `cicada_flutter` forecast service:
use `assessmentDate` / `patient` / `immunization`. None carry a manufacturer.
`xml_conversion_test.dart` uses `Patient` and `Immunization` as parameter names (#2).
`immds_response_test` sends one `condition` parameter (#5).

## Engine code that exists only because of the generator's shapes

- `patient_for_assessment.dart`: falls back to a parameter whose name parses as a date (#1).
- `codes_from_immunization.dart`: reads MVX only from `vaccineCode` (#3).

## Open before fixing

- #3: how an MVX code sits on the Organization (identifier system), from the HL7 V2-to-FHIR
  RXA-17 mapping. Not yet read.
- #5: which resource and which codes each of the 113 CDSi observations should arrive as. Some
  have no chart code at all (001 "Patient seeks protection").
