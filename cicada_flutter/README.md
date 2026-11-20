# cicada_flutter

The Cicada immunization forecast as an app. It runs two ways.

## Manual entry

Open the app with no SMART parameters. Enter a birth date, sex and doses, or
pick a sample patient, and the dashboard shows the forecast.

## Inside the EHR (SMART on FHIR, web)

The EHR opens the app in the patient chart with `?iss=...&launch=...`. The
app signs in without leaving its own window (`fhir_auth`'s
`beginRedirectLogin` / `completeRedirectLogin`), reads the open patient's
chart, runs the engine, and shows the dashboard. It stores nothing.

What it reads, for the patient in context:

| Search | Why |
|---|---|
| `Patient/{id}` | birth date, sex |
| `Immunization?patient=` | doses |
| `Condition?patient=` | indications, contraindications |
| `AllergyIntolerance?patient=` | contraindications |
| `Observation?patient=&category=laboratory` | immunity tests |
| `Observation?patient=&category=social-history` | pregnancy, smoking, occupation |
| `Procedure?patient=` | e.g. splenectomy |

Every page of each search is followed. Medications and orders are not read:
the Epic app record grants no MedicationRequest, MedicationStatement,
MedicationAdministration or ServiceRequest access. Epic refuses an
Observation search with neither code nor category, so Observation is read by
category.

Only the servers in `allowedIssuers` (`lib/src/services/ehr_session.dart`)
are signed in to; today that is Epic's public sandbox.

Build and serve:

```bash
flutter build web --dart-define=CICADA_CLIENT_ID=<non-production client ID>
cd build/web && python3 -m http.server 8080 --bind 127.0.0.1
```

The redirect URI registered with Epic is
`http://localhost:8080/callback.html`. Launch from Epic's LaunchPad
(fhir.epic.com, Documentation, SMART on FHIR (OAuth 2.0), Try it) with the
launch URL `http://localhost:8080/`, or start a standalone sign-in at
`http://localhost:8080/?iss=https%3A%2F%2Ffhir.epic.com%2Finterconnect-fhir-oauth%2Fapi%2FFHIR%2FR4`.
Each search's count goes to the browser console (`cicada chart read:`),
never patient data.
