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
| Cicada's own domain | Open: depends on hosting. The page is three static files: `index.html`, `callback.html` (the same page) and `main.dart.js` |
| The health system's Interconnect FHIR address | Sign-in and data requests |
| JavaScript | Required. No WebAssembly, no fonts or code from other domains |
| Session storage | Required: holds the sign-in for one chart tab while it is open |
| Cookies | Not used |

The page loaded nothing from any other domain in 15 timed fresh-browser loads
(2026-11-21): every request went to the page's own host.

## The page

The chart tab is a plain web page compiled from Dart (`cicada_ehr`), not the
Flutter app. It has nothing to click or type: it signs in, reads the chart,
runs the engine and writes the forecast out. Its JavaScript is 5.4 MB, 0.90 MB
gzip-compressed. Build it with `cicada_ehr/tool/build_web.sh <client id>`.

## Load time

Epic asks embedded apps to be ready in 1.5 seconds or less on average.
Measured 2026-11-21, fresh browser, page served gzip-compressed, five loads
each, time from navigation to the page's first write:

| Network | Time |
|---|---|
| Same machine | 0.71-0.82 s |
| 50 Mbit/s, 20 ms | 0.65-0.79 s |
| 10 Mbit/s, 60 ms | 1.39-1.59 s |

The Flutter page measured 1.1-1.6, 1.4-3.3 and 3.6-3.9 s the same way
(2026-11-20).

One sign-in against Epic's sandbox (standalone, 2026-11-21): after Epic sent
the browser back, the forecast was on screen 3.2 s after that page began
loading. 1.6 s to finish the sign-in (page load and token exchange), 1.3 s to
read the chart (seven requests, one after another), 0.26 s for the engine.
The page loads twice in a launch, once before the sign-in and once after.
A launch from Epic's own launcher has not been timed for this page yet.

## Changes cicada needs before a health system can use it

- Add the health system's FHIR address to `allowedIssuers`
  (`cicada_ehr/lib/src/ehr_sign_in.dart`); today only Epic's sandbox is
  allowed.
- Choose hosting and set the launch URL.
