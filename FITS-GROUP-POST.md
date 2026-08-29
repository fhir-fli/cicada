Subject: What does FITS require in an ImmunizationEvaluation?

I'm testing an engine against FITS and can't find a detailed spec for what the
FHIR R4 connector expects in a response.

Forecasts validate correctly. Evaluations never match — always NO MATCH with an
empty Actual column, so Evaluations completion is 0% while correctness reads
100%.

The Vaccine Matcher Log shows forecasts enumerating candidates from our
response, each printing its code:

    [RESOLVING MATCH FOR FORECAST] (Vaccine) CVX=85
        [CHECKING AGAINST] (Vaccine) CVX=03    [FAIL] CVX does not match
        ... 16 candidates ...
        [CHECKING AGAINST] (Vaccine) CVX=85    [PASS] CVX does match
        [FOUND 1 MATCHES]

For events the candidate line prints with no vaccine at all:

    [RESOLVING MATCH FOR] Vaccination Event (Vaccine) CVX=85 at 08/29/2026
        [CHECKING AGAINST]    [FOUND 0 MATCHES]
        [DECISION] No match found

Which element does it read to get that CVX? R4 ImmunizationEvaluation has no
vaccineCode, so I assume it dereferences immunizationEvent — but the operation
declares no output parameter that returns Immunization resources.

We return one evaluation per dose, immunizationEvent and patient referencing the
ids FITS sent, doseStatus valid/Valid, series, doseNumberPositiveInt,
seriesDosesPositiveInt.

Two things I can now show, each measured as a single change:

ImmunizationEvaluation.date controls whether a candidate is built at all. With
the dose's administration date in it, every event prints a [CHECKING AGAINST]
line. With the assessment date in it, events whose doses fall before that date
print no candidate line at all. R4 defines the element as the date the
evaluation was performed, and the ImmDS example uses the assessment date
(2020-05-26) against an immunization given 2020-04-28, so the conformant value
is the one that suppresses the candidate.

With the dose date in place, so the candidate does get built, the candidate's
vaccine is still null. Both ways of conveying it fail: the Immunization
contained on the evaluation with a #fragment reference, and the Immunization
returned as its own top-level parameter with a literal Immunization/<id>
reference, in both cases with an explicit
http://hl7.org/fhir/sid/cvx system on the coding.

Also tried, no effect: targetDisease coding order both ways;
seriesDosesString vs seriesDosesPositiveInt; adding id and meta.profile.

Separately: on ImmunizationRecommendation.recommendation, doseNumberPositiveInt
makes FITS score 0% on every criterion including Series Status and all dates,
not just Dose Number. doseNumberString scores normally. R4 types this
positiveInt|string, so both are conformant and the integer form fails the whole
suite silently. Is that expected?

Happy to supply full request and response XML.
