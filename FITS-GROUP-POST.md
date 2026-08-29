Subject: FHIR R4 connector — which element does FITS read to match an ImmunizationEvaluation?

Using FITS 1.4.6 with a FHIR R4 endpoint (cicada, an open-source CDSi
engine). Forecasts validate correctly across
the suite. Evaluations never match: every vaccination event returns NO MATCH
with an empty Actual column, so Evaluations completion is 0% while correctness
reads 100%.

The Vaccine Matcher Log shows why. For forecasts it enumerates candidates from
our response and each prints its code:

    [RESOLVING MATCH FOR FORECAST] (Vaccine) CVX=85
        [CHECKING AGAINST] (Vaccine) CVX=03    [FAIL] CVX does not match
        ... 16 candidates ...
        [CHECKING AGAINST] (Vaccine) CVX=85    [PASS] CVX does match
        [FOUND 1 MATCHES]

For events, the candidate line prints with no vaccine at all:

    [RESOLVING MATCH FOR] Vaccination Event (Vaccine) CVX=85 at 08/29/2026
        [CHECKING AGAINST]    [FOUND 0 MATCHES]
        [DECISION] No match found

My question: which element of ImmunizationEvaluation does the R4 connector read
to obtain the CVX it matches on?

R4 ImmunizationEvaluation has no vaccineCode element — the full list is
identifier, status, patient, date, authority, targetDisease, immunizationEvent,
doseStatus, doseStatusReason, description, series, doseNumber[x],
seriesDoses[x]. The only path to a vaccine code is dereferencing
immunizationEvent to the Immunization, and the ImmDS OperationDefinition
(evaluation 0..*, recommendation 1..1) has no output parameter that would carry
Immunization resources back.

We return one evaluation per administered dose (219 for 219), with
immunizationEvent and patient referencing the exact resource ids FITS sent,
doseStatus valid/Valid, series, doseNumberPositiveInt and seriesDosesPositiveInt.

Tried as single changes, each verified on the wire, none of which produced a
match:

  targetDisease coding order both ways (CVX first at least produces the
  [CHECKING AGAINST] line; SNOMED first produces none); date as assessment date
  rather than dose date; seriesDosesString vs seriesDosesPositiveInt; adding id
  and meta.profile; containing the Immunization with a #fragment reference;
  adding the CVX system to that contained vaccineCode; and a literal
  Immunization/<id> reference with no contained resource.

Separate finding that may affect other implementers. On
ImmunizationRecommendation.recommendation, sending doseNumberPositiveInt causes
FITS to score 0% on every criterion, including Series Status and all date
criteria — not just Dose Number. Sending doseNumberString scores normally.
R4 types this doseNumber[x] : positiveInt|string, so both are conformant, and
the integer form fails the whole suite with no error surfaced. Is that expected?

Happy to supply the full request and response XML for any case.
