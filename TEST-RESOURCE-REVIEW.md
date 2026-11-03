# How cicada builds its test resources, against HL7's examples

Reviewed 2026-11-02. Sources read: FHIR R4 `examples-json.zip` (all 5 Immunization
examples, `immunization.profile.json`), ImmDS IG 1.0.0 (`OperationDefinition-ImmDSForecastOperation`,
`Parameters-parameters-in-example`, `Immunization-ImmDSImmunizationExample`), US Core 3.1.0 `Immunization-imm-1`.

ImmDS `$immds-forecast` inputs (US 1.0.0 and international `hl7.fhir.uv.immds` 0.2.0 agree): `assessmentDate` (date, 1..1), `patient` (Patient, 1..1),
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

- #5: which resource and which codes each of the 113 CDSi observations should arrive as. Some
  have no chart code at all (001 "Patient seeks protection").

## Manufacturer: every source compared (2026-11-02)

Scan of 104 Immunization examples in 20 packages (re-run with international ImmDS, SMART Health Cards vaccination, Belgian vaccination: no new manufacturer forms)
(`cicada_generator/tool/ig_compare/`).

- **Where:** every source that carries a manufacturer puts it in `Immunization.manufacturer`
  (Reference(Organization)). R4 core: literal `Organization/hl7` (3 examples). UK Core, AU Base,
  AU Core, EU Base: `display` only, the company's name (4). No example, profile or mapping puts it
  in `vaccineCode`. UK Core marks it mustSupport; no profile binds or slices it.
- **How the code is written:** HL7 V2-to-FHIR (`ConceptMap-segment-rxa-to-immunization`): RXA-17
  -> `manufacturer(Organization)`; CWE -> Organization: CWE.1 -> `identifier.value`, CWE.3 ->
  `identifier.system`, CWE.2 -> `name`.
- **MVX system URIs** (`hl7.terminology.r4` 7.5.0, `NamingSystem-MVX`): `http://hl7.org/fhir/sid/mvx`
  (preferred), `urn:oid:2.16.840.1.113883.12.227` (preferred), `urn:oid:2.16.840.1.113883.6.60`,
  `http://terminology.hl7.org/CodeSystem/MVX`. cicada reads `http://terminology.hl7.org/NamingSystem/MVX`,
  which is none of them.
- **FITS** sends a contained Organization, `identifier.value` = MVX, no system.
- **NDC:** US Core 3.1.0 and 9.0.0 examples carry an NDC beside the CVX in `vaccineCode`. An NDC
  names one manufacturer's product.
- **WHO SMART immunizations 1.0.0:** one Immunization profile (vaccineCode bound to its own value
  set), no Immunization examples.

Forms the engine must read: contained Organization (identifier with any MVX URI or none; else
name), `manufacturer.identifier`, `manufacturer.display` (name), a literal reference to an
Organization supplied in the input, an NDC in `vaccineCode`, and the old MVX coding in `vaccineCode`.

## Every field, every resource (2026-11-02)

`path_census.py` counts every populated field of Parameters, Patient, Immunization, Condition,
AllergyIntolerance, Observation, Procedure, MedicationStatement and Organization in all the
guides' examples (5,000+ resources incl. ours) and in our 1,401 cases (`census.tsv`).
`compare_ours.py` lines each field we fill up against the guides (`ours_vs_guides.tsv`).

Fields we fill that **no guide example fills**:
- `Immunization.vaccineCode.coding` with system `http://hl7.org/fhir/sid/mvx` (2,363).
- `Condition.code.coding` with our CodeSystem `cdsi-observation-codes` (379).
- `Parameters.parameter.resource` = Condition (379); ImmDS defines no such input.
- `Condition.subject.type` (379): legal R4, but no example uses it.

Every other field we fill matches the guides at the path level. Value-level deviations
(parameter names, the date-as-name, CVX display, family name, gender branch) are #1, #2, #4, #6, #7.

Fields most guides fill that we never fill (`guides_not_ours.tsv`), relevant to what the engine reads:
- `Condition.verificationStatus` (11 guides) and `Condition.category` (9). The engine drops
  refuted and entered-in-error; our tests never send a verificationStatus, so that path is untested.
- `Immunization.manufacturer` (5), `Immunization.primarySource` (8), `vaccineCode.text` (7),
  `protocolApplied.doseNumberPositiveInt` and `.targetDisease` (6), `lotNumber` (9).
- Patient identifiers, names, address and telecom: carry nothing the forecast uses.
