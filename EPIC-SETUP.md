# Cicada in Epic: setup sheet for the health system's IT team

Cicada shows a patient's immunization forecast (CDC CDSi logic) inside the
Epic chart. It reads the open patient's chart over FHIR, works out what is
due, and shows it. It writes nothing to Epic and stores nothing: no database,
no server-side code, no logs of patient data.

Epic's developer guide ("Implementing a SMART on FHIR EHR or Standalone
Launch", fhir.epic.com Documentation, read 2026-11-20) lists what the
health system needs from an app maker. This sheet answers each item.
"Open" means not decided yet.

## What the app needs from Epic

| Item | Value |
|---|---|
| Launch type | SMART on FHIR EHR launch, embedded in Hyperspace in the patient chart |
| Epic build | Web FDI record with an `MR_CLINKB_*` launch activity (Epic troubleshooting guide, "Hyperspace/MyChart Embedding Errors"), plus a launch point in the chart |
| Client type | Public client: no client secret, no refresh token, PKCE S256 |
| Non-production client ID | Open: a new app record will be made for the health system |
| Production client ID | Open |
| Launch URL | Open: depends on hosting (below). The page is the site root, `/` |
| Redirect URI | `<launch URL origin>/callback.html` |
| Context tokens | None beyond Epic's standard `iss` and `launch`. Cicada needs the patient in context, so it must launch from a patient chart |
| Scopes requested | `openid fhirUser launch` |

## FHIR reads (all read-only, for the patient in context)

| Request | Why |
|---|---|
| `Patient/{id}` | birth date, sex |
| `Immunization?patient=` | doses given |
| `Condition?patient=` | indications and contraindications |
| `AllergyIntolerance?patient=` | contraindications |
| `Observation?patient=&category=laboratory` | immunity tests |
| `Observation?patient=&category=social-history` | pregnancy, smoking, occupation |
| `Procedure?patient=` | e.g. splenectomy |

Every page of each search is followed. Medications and orders are not read.

## What the browser must allow

| Item | Value |
|---|---|
| Cicada's own domain | Open: depends on hosting |
| `www.gstatic.com` | Today the page loads its drawing engine (CanvasKit, ~1.6 MB) from here. To be removed: the engine will be served from cicada's own domain |
| `fonts.gstatic.com` | Today the page loads a font (~64 KB) from here. To be removed the same way |
| The health system's Interconnect FHIR address | Sign-in and data requests |
| JavaScript and WebAssembly | Required (Flutter web app) |
| Session storage | Required: holds the sign-in for one chart tab while it is open |
| Cookies | Not used |

The domain counts come from loading the page in a fresh browser and
recording every request (2026-11-20).

## Load time

Epic asks embedded apps to be ready in 1.5 seconds or less on average. Measured
2026-11-20, fresh browser, page served gzip-compressed, five loads each, time
to the first drawn screen:

| Network | Time |
|---|---|
| Same machine | 1.1-1.6 s |
| 50 Mbit/s, 20 ms | 1.4-3.3 s |
| 10 Mbit/s, 60 ms | 3.6-3.9 s |

A full launch from Epic's sandbox took about 6.4 s from launch to forecast
(2026-11-20): the page loads twice (before and after sign-in), then makes the
seven reads above one after another. Work to shorten this is planned.

## Changes cicada needs before a health system can use it

- Add the health system's FHIR address to `allowedIssuers`
  (`cicada_flutter/lib/src/services/ehr_session.dart`); today only Epic's
  sandbox is allowed.
- Choose hosting and set the launch URL.
- Serve the drawing engine and font from cicada's own domain.
