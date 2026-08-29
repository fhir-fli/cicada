# FITS never matches an ImmunizationEvaluation — question for NIST

**FITS 1.4.6, ConnectionType FHIRR4.** Forecasts validate correctly. Evaluations
have never matched, in any run, including runs from 2026-02-23 that predate all
recent work.

## What FITS reports

Every vaccination event, in every case that has doses:

```
Criterion                              Expected   Actual   Assessment
#85 - Hep A, unspecified formulation   VALID      (empty)  NO MATCH
```

The **Actual column is empty**. FITS is not disagreeing with our verdict; it has
nothing to compare. Aggregate: Evaluations correctness 100%, completion **0%**.

## What the Vaccine Matcher Log shows

Forecasts enumerate candidates from our response and match:

```
[RESOLVING MATCH FOR FORECAST] (Vaccine) CVX=85
    [CHECKING AGAINST] (Vaccine) CVX=03      [FAIL] CVX does not match
    ... 16 candidates, each printing its CVX ...
    [CHECKING AGAINST] (Vaccine) CVX=85      [PASS] CVX does match
    [FOUND 1 MATCHES]
```

Events do not:

```
[RESOLVING MATCH FOR] Vaccination Event  (Vaccine) CVX=85 at 08/29/2026
    [CHECKING AGAINST]    [FOUND 0 MATCHES]
    [DECISION] No match found
```

`[CHECKING AGAINST]` prints with **no vaccine after it**, where every forecast
candidate prints `(Vaccine) CVX=NN`. A candidate is built and its vaccine reads
as null.

## The question

**Which element of `ImmunizationEvaluation` does FITS read to obtain the CVX it
matches a vaccination event on?**

R4 `ImmunizationEvaluation` has no `vaccineCode`. Its full element list is
identifier, status, patient, date, authority, targetDisease, immunizationEvent,
doseStatus, doseStatusReason, description, series, doseNumber[x],
seriesDoses[x]. The only route to a vaccine code is dereferencing
`immunizationEvent` to the `Immunization`, and the ImmDS OperationDefinition
(`evaluation` 0..*, `recommendation` 1..1) defines no output parameter that
would carry Immunization resources.

## What we have already tested and ruled out

Each was the ONLY change in its run, verified on the wire, with the FITS log
compared before and after:

| # | change | result |
|---|---|---|
| 1 | `targetDisease` coding order, CVX first | created the `[CHECKING AGAINST]` line; vaccine still null |
| 2 | `targetDisease` coding order, SNOMED first | no `[CHECKING AGAINST]` line at all |
| 3 | `date` = assessment date rather than dose date | no change |
| 4 | `seriesDosesString` -> `seriesDosesPositiveInt` | no change |
| 5 | added `id` and `meta.profile` | no change |
| 6 | contained the `Immunization`, `immunizationEvent` as `#fragment` | no change |
| 7 | added `system` to the contained `vaccineCode` | no change |
| 8 | literal `Immunization/<id>` reference, no `contained` | no change |

Separately measured: `doseNumberPositiveInt` on
`ImmunizationRecommendation.recommendation` causes FITS to score **0% on every
criterion including Series Status and all dates**. `doseNumberString` scores
normally. Both are conformant R4 (`doseNumber[x] : positiveInt|string`), so a
responder that picks the integer form fails the whole suite silently.

## Our response

Parameter names match the ImmDS OperationDefinition. The evaluation carries
targetDisease, immunizationEvent, doseStatus valid/Valid, series,
doseNumberPositiveInt and seriesDosesPositiveInt, and 219 evaluations were
returned for 219 administered doses. Full XML available on request.
