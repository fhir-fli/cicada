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

## What is established

**1. `ImmunizationEvaluation.date` gates candidate construction.**

Holding everything else fixed:

| `date` carries | result |
|---|---|
| the dose's administration date | every vaccination event prints a `[CHECKING AGAINST]` line |
| the assessment date | events whose doses fall before it print no candidate line at all |

R4 defines the element as the date the evaluation was performed, and the ImmDS
example uses the assessment date (2020-05-26) against an immunization given
2020-04-28. **The conformant value is the one that suppresses the candidate.**

**2. With the candidate built, its vaccine is still null — by both routes.**

Run with the dose date in place, so `[CHECKING AGAINST]` lines do appear:

| conveyance | result |
|---|---|
| `Immunization` contained, `immunizationEvent` = `#<id>` | `[FOUND 0 MATCHES]`, no vaccine printed |
| `Immunization` as a top-level `immunization` parameter, `immunizationEvent` = `Immunization/<id>` | `[FOUND 0 MATCHES]`, no vaccine printed |

Both carried an explicit `http://hl7.org/fhir/sid/cvx` system on the coding.
That is every route R4 offers, and neither reaches FITS.

## Tested, no effect

`seriesDosesString` vs `seriesDosesPositiveInt` · adding `id` and
`meta.profile`.

## Confounded, do not cite

Earlier runs varied `targetDisease` coding order (CVX first vs SNOMED first)
and read the presence of the `[CHECKING AGAINST]` line as the outcome. Those
runs carried the assessment date, which we now know governs that line on its
own, so the coding-order result cannot be attributed. The same applies to the
first containment test: it ran under the assessment date, so its negative was
unknown rather than no. It has since been re-run properly and is row 2 above.

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
