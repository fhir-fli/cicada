# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cicada is a Dart immunization forecasting engine that implements the CDC's [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/iis/cdsi/) logic and WHO Expanded Programme on Immunization (EPI) recommendations. It takes a FHIR R4 `Parameters` resource containing a patient's demographics, immunization history, and conditions, then evaluates past vaccine doses and forecasts future immunization needs.

## Structure

```
cicada/
├── cicada/                  # Main library package
│   ├── bin/
│   │   └── server.dart      # ImmDS HTTP server (Shelf, JSON+XML, CORS)
│   ├── lib/
│   │   ├── forecast/        # Entry point: forecastFromParameters(), ForecastMode, ImmDS response
│   │   ├── models/          # VaxPatient → VaxAntigen → VaxGroup → VaxSeries → VaxDose
│   │   ├── providers/       # Riverpod providers (observations, patient parsing, outcomes)
│   │   ├── supporting_data/ # CDSi data model classes, enums, VaxDate
│   │   ├── generated_files/ # Generated Dart from CDSi XML/Excel specs (do not hand-edit)
│   │   │   └── who/         # Generated WHO antigen + schedule data (do not hand-edit)
│   │   └── utils/           # Helpers (antigen mapping, CVX lookups, condition parsing, XML conversion)
│   └── test/
├── cicada_generator/        # Code generator that produces generated_files/
│   └── lib/
│       ├── Version_4.61-508/ # CDSi source XML/Excel files
│       ├── WHO/              # WHO source data
│       │   ├── antigen/      # WHO antigen definitions (.xlsx and .json)
│       │   └── schedule/     # WHO schedule supporting data (.json)
│       ├── generated_files/  # Intermediate JSON output (CDC and WHO)
│       ├── test_cases/       # Test case Excel/NDJSON files
│       └── generate_who.dart # Generates WHO JSON source files from definitions
├── cicada_ig/               # FHIR Implementation Guide (FSH/Docusaurus)
└── generate.sh              # Runs the generator
```

## Common Commands

```bash
# Install dependencies
cd cicada && dart pub get
cd cicada_generator && dart pub get

# Run tests
cd cicada && dart run test/cicada_test.dart       # 1014 healthy CDC test cases
cd cicada && dart run test/condition_test.dart     # 777 condition CDC test cases

# Run ImmDS server
dart run cicada/bin/server.dart -p 8080

# Regenerate CDC supporting data from CDSi XML sources
dart cicada_generator/lib/xml_to_json.dart         # Step 1: XML → JSON
dart cicada_generator/lib/main.dart                # Step 2: Excel/JSON → Dart

# Regenerate WHO supporting data
dart cicada_generator/lib/generate_who.dart        # Step 1: Create WHO JSON sources
dart cicada_generator/lib/main.dart --who           # Step 2: JSON → Dart

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

### ForecastMode (CDC vs WHO)

The engine supports two modes via `ForecastMode` enum in `forecast/forecast_mode.dart`:

- **`ForecastMode.cdc`** (default) — Uses CDSi v4.61-508 antigen definitions and U.S. schedule
- **`ForecastMode.who`** — Uses WHO EPI antigen definitions (22 antigens) and global schedule

Runtime switching uses `activeAntigenMap` and `activeScheduleData` getters that dispatch to the correct dataset. Multi-antigen groups (e.g., DTP, MMR) are derived dynamically from the vaccine-group-to-antigen map.

**WHO antigens (22):** BCG, HepB, Diphtheria, Tetanus, Pertussis, Hib, Polio, Measles, Rubella, PCV, Rotavirus, HPV, HepA, Yellow Fever, Japanese Encephalitis, Meningococcal, Typhoid, Cholera, Rabies, Mumps, Influenza, COVID-19

### Model Hierarchy

- **VaxPatient**: Parsed patient with demographics, past doses, observations
- **VaxAntigen**: One per target disease (e.g., Measles). Contains groups and handles immunity/contraindication checks
- **VaxGroup**: Groups series by vaccine group (e.g., MMR). Implements series scoring and best-series selection
- **VaxSeries**: Tracks one CDSi series — evaluates doses against target doses, manages conditional skips, generates forecasts
- **VaxDose**: Individual administered dose with evaluation status (valid/not_valid/sub_standard/extraneous)

### Key Types

- **VaxDate**: Extends `DateTime` with CDSi date arithmetic. The `change("6 months 4 days")` method parses human-readable offsets. Min/max sentinels: `VaxDate.min()` (1900-01-01), `VaxDate.max()` (2999-12-31)
- **AntigenSupportingData / ScheduleSupportingData**: Deserialized specification data (series definitions, dose rules, intervals, contraindications, live virus conflicts). Used by both CDC and WHO modes.

### Generated Code

Files in `cicada/lib/generated_files/` are produced by the generator and should not be hand-edited.

- **CDC**: Each antigen (measles.dart, hepb.dart, etc.) contains an `AntigenSupportingData` instance. `antigenSupportingDataMap` provides disease-name-keyed lookup. `schedule_supporting_data.dart` contains `scheduleSupportingData`.
- **WHO**: `generated_files/who/` mirrors the same structure with `who` prefix: `whoAntigenSupportingDataMap`, `whoScheduleSupportingData`. The barrel file is `who_generated_supporting_data.dart`.

### ImmDS Server

`bin/server.dart` runs a Shelf HTTP server implementing the `$immds-forecast` operation:
- Accepts `POST /$immds-forecast` with JSON or XML FHIR Parameters
- Returns FHIR Parameters with evaluations and recommendations
- Supports CORS for browser-based clients
- Tested against NIST FITS (Forecasting and Immunization Testing Standard): 167/169 correct

### State Management

Uses Riverpod (non-Flutter) with `ProviderContainer` for managing:
- `patientForAssessmentProvider` — parses FHIR Parameters into VaxPatient
- `observationsProvider` — shared observation state across evaluation
- `seriesGroupCompleteProvider` — tracks series group completion across antigens
- `operationOutcomesProvider` — collects errors

## Code Style

Uses `very_good_analysis`. The CDSi spec version currently implemented is **4.61-508**.

## Test Results

- **CDC Healthy**: 1010/1014 (99.6%) — 4 failures verified as version mismatch issues
- **CDC Condition**: 747/777 (96.1%) — 30 failures verified as version mismatch issues
- **FITS (external)**: 167/169 (98.8%) — 2 failures from FITS date rebasing

## Critical File Access Rules

**NEVER recursively list or read:**
- `cicada_generator/lib/Version_4.61-508/` — Large CDSi XML/Excel source files
- `cicada_generator/lib/WHO/` — WHO source data files
- `cicada_generator/lib/generated_files/` — Large intermediate JSON files
- `cicada_generator/lib/test_cases/` — Test case data files

**Safe to read:**
- `cicada/lib/**/*.dart` — All source code
- `cicada/test/*_test.dart` — Test logic
- Config files: `pubspec.yaml`
