# Cicada

An immunization forecasting engine in Dart that evaluates past vaccine doses and recommends future immunizations based on clinical decision support logic.

Cicada implements the CDC's [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/iis/cdsi/) specification (v4.61-508) and WHO Expanded Programme on Immunization (EPI) recommendations. It accepts FHIR R4 input and produces FHIR R4 output, making it interoperable with any FHIR-compliant system.

## Features

- Evaluates administered vaccine doses against series requirements (age, intervals, live virus conflicts, vaccine type)
- Forecasts future immunization needs with earliest, recommended, past-due, and latest dates
- Supports 30+ CDC antigens and 22 WHO antigens
- Handles clinical conditions, contraindications, immunity evidence, and risk-based series
- Multi-antigen vaccine group aggregation (DTaP/Tdap/Td, MMR, DTP, MR)
- FHIR R4 `Parameters` in, FHIR R4 `Parameters` out
- Built-in HTTP server for the `$immds-forecast` FHIR operation (JSON and XML)
- 99.6% accuracy against CDC test suite, 98.8% against NIST FITS

## Installation

```yaml
dependencies:
  cicada:
    git:
      url: https://github.com/fhir-fli/cicada.git
      path: cicada
```

```bash
cd cicada && dart pub get
```

## Quick Start

```dart
import 'package:cicada/cicada.dart';
import 'package:fhir_r4/fhir_r4.dart';

// Build a FHIR Parameters resource with patient data
final parameters = Parameters(parameter: [
  ParametersParameter(name: FhirString('assessmentDate'),
      resource: null, /* ... */),
  ParametersParameter(name: FhirString('patient'),
      resource: Patient(/* ... */)),
  ParametersParameter(name: FhirString('immunization'),
      resource: Immunization(/* ... */)),
]);

// Run the CDC forecast (default)
final result = forecastFromParameters(parameters);

// Run the WHO forecast
final whoResult = forecastFromParameters(parameters, mode: ForecastMode.who);
```

The input `Parameters` resource contains:
- A `Patient` resource (demographics: birth date, sex)
- `Immunization` resources (past vaccine doses with CVX codes and dates)
- `Condition` resources (clinical conditions affecting vaccine eligibility)
- `AllergyIntolerance` resources (allergies/contraindications)
- `Observation`, `Procedure`, `MedicationStatement` resources (additional clinical context)
- An assessment date parameter (the date to evaluate against)

The output `Parameters` resource contains:
- `ImmunizationEvaluation` resources (one per evaluated dose per antigen)
- `ImmunizationRecommendation` resources (one per vaccine group with forecast dates and status)

## ImmDS Server

Cicada includes an HTTP server that implements the FHIR `$immds-forecast` operation:

```bash
dart run bin/server.dart -p 8080
```

The server accepts `POST /$immds-forecast` with JSON or XML FHIR Parameters and returns the forecast result. It supports CORS headers for browser clients and has been tested against [NIST FITS](https://fits.nist.gov) (167/169 correct).

To expose the server for external testing (e.g., FITS):
```bash
ngrok http 8080
```

## CDC vs WHO Mode

Cicada supports two forecasting modes:

| Feature | CDC (CDSi) | WHO (EPI) |
|---------|-----------|-----------|
| Schedule | U.S. immunization schedule | WHO global recommendations |
| Antigens | 30+ (U.S. formulations) | 22 (global formulations) |
| Vaccines | DTaP, IPV, MMR, etc. | DTP, OPV+IPV, MR, pentavalent, etc. |
| Dose timing | 2/4/6 months | 6/10/14 weeks |
| Spec version | CDSi v4.61-508 | WHO position papers (2024) |

Switch modes at runtime:
```dart
// Programmatic
setForecastMode(ForecastMode.who);
final result = forecastFromParameters(parameters, mode: ForecastMode.who);

// Or use the lower-level API
final forecastResult = evaluateForForecast(parameters, mode: ForecastMode.who);
```

## Architecture

```
FHIR Parameters
       │
       ▼
   ┌───────────┐     ┌──────────────────┐
   │   Parse    │────▶│   VaxPatient     │
   └───────────┘     │  (demographics,  │
                     │   doses, obs)    │
                     └──────────────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │   Antigen Map    │  CVX → disease mapping
                     └──────────────────┘
                              │
                  ┌───────────┼───────────┐
                  ▼           ▼           ▼
            ┌──────────┐┌──────────┐┌──────────┐
            │VaxAntigen││VaxAntigen││VaxAntigen│  One per disease
            │ Measles  ││ Tetanus  ││  HepB    │
            └──────────┘└──────────┘└──────────┘
                  │           │           │
                  ▼           ▼           ▼
            ┌──────────┐┌──────────┐┌──────────┐
            │ VaxGroup ││ VaxGroup ││ VaxGroup │  Vaccine groups
            │   MMR    ││DTaP/Tdap ││   HepB   │
            └──────────┘└──────────┘└──────────┘
                  │           │           │
                  ▼           ▼           ▼
            ┌──────────┐┌──────────┐┌──────────┐
            │VaxSeries ││VaxSeries ││VaxSeries │  Series + scoring
            └──────────┘└──────────┘└──────────┘
                  │           │           │
                  ▼           ▼           ▼
            ┌──────────┐┌──────────┐┌──────────┐
            │ VaxDose  ││ VaxDose  ││ VaxDose  │  Dose evaluation
            └──────────┘└──────────┘└──────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │ Vaccine Group    │  Aggregate across
                     │ Forecasts        │  multi-antigen groups
                     └──────────────────┘
                              │
                              ▼
                     FHIR Parameters (output)
```

## Generator

The supporting data (antigen definitions, schedule rules) is generated from source specifications:

```bash
# Full CDC pipeline
./generate.sh

# Or step by step:
dart cicada_generator/lib/xml_to_json.dart    # CDSi XML → JSON
dart cicada_generator/lib/main.dart           # Excel/JSON → Dart

# WHO pipeline
dart cicada_generator/lib/generate_who.dart   # Create WHO JSON sources
dart cicada_generator/lib/main.dart --who     # JSON → Dart
```

Generated files are written to `cicada/lib/generated_files/` (CDC) and `cicada/lib/generated_files/who/` (WHO). Do not hand-edit these files.

## Testing

```bash
cd cicada

# CDC healthy test cases (1014 cases, v4.45 test data)
dart run test/cicada_test.dart

# CDC condition test cases (777 cases, v4.6 test data)
dart run test/condition_test.dart
```

Results:
- **Healthy**: 1010/1014 (99.6%) — 4 failures from CDSi version mismatch (v4.45 test data vs v4.61 engine)
- **Condition**: 747/777 (96.1%) — 30 failures from version mismatch (v4.6 test data vs v4.61 engine)
- **FITS**: 167/169 (98.8%) — 2 failures from FITS date rebasing (assessment date shifts)

All remaining failures have been individually verified as version mismatch or test infrastructure issues, not engine bugs.

## Implementation Guide

A FHIR Implementation Guide built with FSH is available in `cicada_ig/`. It defines profiles, code systems, value sets, and concept maps for the immunization forecasting domain.

View the published IG at: https://fhir-fli.github.io/fhir_fli_documentation/cicada_ig/index.html

## Credits

100% credit goes to the CDC and their [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/iis/cdsi/) team for the immunization logic specification, and to the WHO for their [Expanded Programme on Immunization](https://www.who.int/teams/immunization-vaccines-and-biologicals/essential-programme-on-immunization) position papers.

## Contact

[grey@fhirfli.dev](mailto:grey@fhirfli.dev)
