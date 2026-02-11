# Preparation - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Preparation**

## Preparation

### This is only if you're interested in the actual code behind this process

* The full [Github Repo is here](https://github.com/Dokotela/cicada)
* The CDSi [Supporting Data](https://www.cdc.gov/iis/cdsi/) is published by the CDC as XML and Excel files. The generator converts these into JSON and Dart classes that the engine uses at runtime.

### Build Pipeline

The generator pipeline has four steps, all orchestrated by `generate.sh` in the project root:

1. **XML to JSON** (`cicada_generator/lib/xml_to_json.dart`): Converts the CDSi XML files (one per antigen) into JSON. The script auto-detects the `Version_*` directory.
1. **Main Generator** (`cicada_generator/lib/main.dart`): Reads the Excel schedule supporting data and the per-antigen JSON files, then generates Dart source files in `cicada/lib/generated_files/`. This step also merges a supplementary observation crosswalk (`cicada_generator/lib/crosswalk/observation_crosswalk.json`) that maps ICD-10-CM, LOINC, RxNorm, and CPT codes to CDSi observation codes. The CDC's native supporting data only includes SNOMED, CVX, and CDCPHINVS codes for observations.
1. **Test Case Generator** (`cicada_generator/lib/test_cases/test_case_generator.dart`): Reads the CDC-provided test case Excel files, generates expected results as a Dart map (`test_doses.dart`), and copies the NDJSON test data to the test directory.
1. **Format** (`dart format cicada`): Formats all generated Dart files.

### Running the Generator

```
cd cicada && ./generate.sh

```

This will regenerate all supporting data files from the current CDSi source files. The generated files should not be hand-edited since they will be overwritten on the next run.

### Running the Tests

```
cd cicada && dart test

```

The test suite reads `healthyTestCases.ndjson` (currently 1013 test cases from CDSi v4.45 test data), runs each through the forecasting engine, and compares the dose evaluation results against the CDC's expected outcomes.

### Architecture Notes

* All CDSi supporting data is generated code in `cicada/lib/generated_files/`. Each antigen has its own file (e.g., `measles.dart`, `hepb.dart`) containing an `AntigenSupportingData` instance. The `antigenSupportingDataMap` global provides disease-name-keyed lookup. `schedule_supporting_data.dart` contains global data including live virus conflicts, vaccine groups, CVX-to-antigen mappings, and observations.
* The engine accepts a FHIR R4 `Parameters` resource containing the patient's demographics, immunization history, conditions, allergies, observations, procedures, and medications. It returns an `ImmunizationRecommendation` resource.
* Observations (conditions, allergies, etc.) are matched against CDSi observation codes via a crosswalk that supports 7 code systems: SNOMED CT, CVX, CDCPHINVS, ICD-10-CM, LOINC, RxNorm, and CPT.

