# CLAUDE.md

> **Universal rules are in `~/.claude/CLAUDE.md`** — it loads in every session, in
> every directory, so they are not repeated here. Full records: `~/.claude/rules/`.
> This file holds project facts only.

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
│       ├── Version_4.65-508/ # CDSi source XML/Excel files
│       ├── WHO/              # WHO source data (Excel = source of truth)
│       │   ├── antigen/      # WHO antigen definitions (22 .xlsx files)
│       │   └── schedule/     # WHO schedule supporting data (5 .xlsx files)
│       ├── generated_files/  # Intermediate JSON output (CDC and WHO)
│       ├── test_cases/       # Test case Excel/NDJSON files
│       └── generate_who_excel.dart # One-time migration: JSON → Excel
├── cicada_ig/               # FHIR Implementation Guide (FSH/Docusaurus)
└── generate.sh              # Runs the generator
```

## Common Commands

```bash
# Install dependencies
cd cicada && dart pub get
cd cicada_generator && dart pub get

# Run tests
cd cicada && dart test                             # the whole suite — run this, not files by name
cd cicada && dart run test/healthy_test.dart       # 1064 healthy CDC test cases
cd cicada && dart run test/condition_test.dart     # 337 condition CDC test cases

# Run ImmDS server
dart run cicada/bin/server.dart -p 8080

# Regenerate CDC supporting data from CDSi XML sources
dart cicada_generator/lib/xml_to_json.dart         # Step 1: XML → JSON
dart cicada_generator/lib/main.dart                # Step 2: Excel/JSON → Dart

# Regenerate WHO supporting data from Excel sources
dart cicada_generator/lib/main.dart --who           # Excel → JSON → Dart

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

- **`ForecastMode.cdc`** (default) — Uses CDSi v4.65-508 antigen definitions and U.S. schedule
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

🔑 **The Excel is the source of truth, not the XML.** `main.dart` builds from
`Version_4.65-508/Excel/` and falls back to XML-derived JSON only when a sheet
fails to parse. Cite the spreadsheets when making a claim about CDC's data.
(Verified 2026-08-27: for indication observation codes the two agree exactly
across all 30 antigens — but the XML is still the fallback, not the source.)

- **CDC**: Each antigen (measles.dart, hepb.dart, etc.) contains an `AntigenSupportingData` instance. `antigenSupportingDataMap` provides disease-name-keyed lookup. `schedule_supporting_data.dart` contains `scheduleSupportingData`.
- **WHO**: `generated_files/who/` mirrors the same structure with `who` prefix: `whoAntigenSupportingDataMap`, `whoScheduleSupportingData`. The barrel file is `who_generated_supporting_data.dart`.

### ImmDS Server

`bin/server.dart` runs a Shelf HTTP server implementing the ImmDS forecast operations:
- Accepts `POST /$immds-forecast` (CDC) and `POST /$immds-forecast-who` (WHO) with JSON or XML FHIR Parameters
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

Uses `very_good_analysis`. The CDSi supporting data currently implemented is **4.65-508** (Aug 2026). The logic specification is v4.6 (Dec 2024) — CDC versions them separately.

## Vaccine group forecasts come in a list

`ForecastResult.vaccineGroupForecasts` is
`Map<String, List<VaccineGroupForecast>>`. A vaccine group holding both a
standard and a risk series group gets **one forecast for each**: FORECASTVG-1
scopes a forecast to a series group, and the Chapter 9 intro says such a patient
"may end up with more than 1 vaccine group forecast". `$immds-forecast` emits a
recommendation per forecast. Each carries `isRiskForecast`, `seriesGroupName`
and `antigensNeedingDose` so a consumer can tell them apart.

🛑 **The engine does not choose between them.** CDC's workbook records one row
per case and never says which series group it means, so the test harness picks
one via `collapseForComparison` in `cicada/test/cdc_row_collapse.dart`. That
rule is an artefact of CDC's file format and **must not move into `lib/`**. It
is duplicated into `cicada_generator/lib/cdc_row_collapse.dart` because the two
packages cannot depend on each other (excel pins archive 3.x, fhir_r4_bulk needs
4.x); `cdc_row_collapse_sync_test.dart` fails if the copies drift.

## Check every package, not the one you have open

```bash
./tool_check_all.sh    # cicada + cicada_generator + cicada_flutter
```

🛑 `dart analyze` in one package cannot see the others. `64bd94f5` changed a
type on `ForecastResult`; cicada and cicada_generator were checked, and
**cicada_flutter did not compile for four commits** — 8 analyzer errors, and
`flutter test` could not run. It surfaced only during an unrelated dependency
bump. Run the script before claiming a change is clean.

## Test Results

Both suites compare against CDC's expected results and both must be run before
and after any engine change — from `cicada/`, with absolute paths:

```bash
dart test                            # 26 failures, all classified — run THIS
dart run test/healthy_test.dart      # 1063 / 1064
dart run test/condition_test.dart    #  312 /  337
```

🛑 **Run `dart test`, not files by name.** Running only healthy and condition by
name hid four failures in `forecast_test.dart` — a stale weaker duplicate of
`healthy_test.dart` — for an entire session.

🔴 **The condition denominator is 337, not 777.** The workbook carries 439 empty
rows after its last real case; those loaded as test cases, matched no
expectation, asserted nothing and were counted as passes. Fixed in the generator
2026-08-25; both suites now fail if any case has no id or no expectations.

- **Healthy (v4.46 cases, 4.65-508 data — versions match, so this is the gate).**
  Its 1 failure is `2018-0022`, a dose-**evaluation reason label**, not a forecast.
🔴 **One of the 26 fails deliberately** — `2016-UC-0198`. Rules that had made them pass existed in **no CDSi
specification** and were removed. **Do not "fix" them.** Before any engine
change run `python3 tool_check_spec_citations.py` from `cicada/`: every
decision-bearing function must name the rule it implements, and it exits
non-zero if one does not.

- **Condition (v4.6 cases, Sept 2025).** Version-mismatched by construction:
  several failures are cases written against supporting data CDC has since
  changed. Movement in this suite is the signal, not its absolute number.
- ⚠️ `test/cicada_test.dart` asserted **nothing** — zero `expect()` calls — and
  `test/forecast_test.dart` was a weaker duplicate of `healthy_test.dart`. Both
  deleted 2026-08-25. The "1010/1014 (99.6%)" that used to sit here came from
  the first of them — do not quote it.
- **FITS (external)**: 167/169 (98.8%) — 2 failures from FITS date rebasing.

⚠️ **"Verified as version mismatch" was too strong, and it cost us.** That line
went unquestioned for months and hid a real engine bug: `selectSeries
.minAgeToStart` was parsed and never read, so "RSV 75 years+ 1-dose series"
applied to infants and forecast them at **birth date plus 75 years** — a
5-day-old with cystic fibrosis included. Fixed 2026-08-18.

**Adjudicate the remaining failures per case, not as a block.** Cases whose
supporting data has genuinely moved under them (observation codes retired, an
RSV season rolled forward, a licensed minimum age lowered) are written up with
CDC's own row and the clinical question in `CDSI-OE-QUERIES.md`; anything we
conclude CDC got *wrong* goes in there too, for outside adjudication, rather
than being silently conformed to or silently ignored.

## Critical File Access Rules

**NEVER recursively list or read:**
- `cicada_generator/lib/Version_4.65-508/` — Large CDSi XML/Excel source files
- `cicada_generator/lib/WHO/` — WHO source data files
- `cicada_generator/lib/generated_files/` — Large intermediate JSON files
- `cicada_generator/lib/test_cases/` — Test case data files

**Safe to read:**
- `cicada/lib/**/*.dart` — All source code
- `cicada/test/*_test.dart` — Test logic
- Config files: `pubspec.yaml`
