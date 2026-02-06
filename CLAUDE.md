# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cicada is a Dart immunization forecasting engine that implements the CDC's [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/iis/cdsi/) logic. It takes a FHIR R4 `Parameters` resource containing a patient's demographics, immunization history, and conditions, then evaluates past vaccine doses and forecasts future immunization needs.

## Structure

```
cicada/
├── cicada/                  # Main library package
│   ├── lib/
│   │   ├── forecast/        # Entry point: forecastFromParameters()
│   │   ├── models/          # VaxPatient → VaxAntigen → VaxGroup → VaxSeries → VaxDose
│   │   ├── providers/       # Riverpod providers (observations, patient parsing, outcomes)
│   │   ├── supporting_data/ # CDSi data model classes, enums, VaxDate
│   │   ├── generated_files/ # Generated Dart from CDSi XML/Excel specs (do not hand-edit)
│   │   └── utils/           # Helpers (antigen mapping, CVX lookups, condition parsing)
│   └── test/
├── cicada_generator/        # Code generator that produces generated_files/
│   └── lib/
│       ├── Version_4.61-508/ # CDSi source XML/Excel files
│       ├── generated_files/  # Intermediate JSON output
│       └── test_cases/       # Test case Excel/NDJSON files
├── cicada_ig/               # FHIR Implementation Guide (FSH/Docusaurus)
└── generate.sh              # Runs the generator
```

## Common Commands

```bash
# Install dependencies
cd cicada && dart pub get
cd cicada_generator && dart pub get

# Run tests (test reads healthyTestCases.ndjson and compares against CDSi expected results)
cd cicada && dart test
dart test cicada/test/cicada_test.dart

# Regenerate supporting data from CDSi XML sources
# Step 1: Convert XML to JSON
dart cicada_generator/lib/xml_to_json.dart

# Step 2: Generate Dart files from Excel/JSON (writes to cicada/lib/generated_files/)
dart cicada_generator/lib/main.dart

# Generate Riverpod code
cd cicada && dart run build_runner build

# Analyze and format
dart analyze cicada
dart format cicada
```

## Architecture

### Forecasting Pipeline

The core pipeline in `forecast/forecast.dart` runs these steps:

1. **Parse** — `PatientForAssessment` provider extracts a `VaxPatient` from FHIR `Parameters` (patient, immunizations, conditions, allergies)
2. **Map** — `antigenMap()` builds a `Map<String, VaxAntigen>` keyed by target disease, distributing past doses to matching antigens
3. **Evaluate** — Each `VaxAntigen` → `VaxGroup` → `VaxSeries` evaluates past doses against CDSi rules (age validity, intervals, live virus conflicts, allowable vaccine types)
4. **Forecast** — Each series determines forecast need (immunity, contraindications, series completeness), then generates recommended dates via conditional skip logic and interval calculations
5. **Select Best Series** — `VaxGroup` scores and prioritizes series (complete > in-process > zero-dose) to pick the best recommendation

### Model Hierarchy

- **VaxPatient**: Parsed patient with demographics, past doses, observations
- **VaxAntigen**: One per target disease (e.g., Measles). Contains groups and handles immunity/contraindication checks
- **VaxGroup**: Groups series by vaccine group (e.g., MMR). Implements series scoring and best-series selection
- **VaxSeries**: Tracks one CDSi series — evaluates doses against target doses, manages conditional skips, generates forecasts
- **VaxDose**: Individual administered dose with evaluation status (valid/not_valid/sub_standard/extraneous)

### Key Types

- **VaxDate**: Extends `DateTime` with CDSi date arithmetic. The `change("6 months 4 days")` method parses human-readable offsets. Min/max sentinels: `VaxDate.min()` (1900-01-01), `VaxDate.max()` (2999-12-31)
- **AntigenSupportingData / ScheduleSupportingData**: Deserialized CDSi specification data (series definitions, dose rules, intervals, contraindications, live virus conflicts)

### Generated Code

Files in `cicada/lib/generated_files/` are produced by the generator and should not be hand-edited. Each antigen (measles.dart, hepb.dart, etc.) contains an `AntigenSupportingData` instance. The `antigenSupportingDataMap` global provides disease-name-keyed lookup. `schedule_supporting_data.dart` contains the global `scheduleSupportingData` instance.

### State Management

Uses Riverpod (non-Flutter) with `ProviderContainer` for managing:
- `patientForAssessmentProvider` — parses FHIR Parameters into VaxPatient
- `observationsProvider` — shared observation state across evaluation
- `seriesGroupCompleteProvider` — tracks series group completion across antigens
- `operationOutcomesProvider` — collects errors

Note: Several places create ad-hoc `ProviderContainer()` instances (e.g., in VaxAntigen.immunity, VaxSeries.skipByCompletedSeries, VaxDose.getObservationDate) rather than sharing the container from the forecast entry point.

## Code Style

Uses `very_good_analysis`. The CDSi spec version currently implemented is **4.61-508**.

## Critical File Access Rules

**NEVER recursively list or read:**
- `cicada_generator/lib/Version_4.61-508/` — Large CDSi XML/Excel source files
- `cicada_generator/lib/generated_files/` — Large intermediate JSON files
- `cicada_generator/lib/test_cases/` — Test case data files

**Safe to read:**
- `cicada/lib/**/*.dart` — All source code
- `cicada/test/*_test.dart` — Test logic
- Config files: `pubspec.yaml`
