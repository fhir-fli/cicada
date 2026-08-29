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

Tried as single changes, none of which matched: targetDisease coding order both
ways (CVX first at least produces the [CHECKING AGAINST] line, SNOMED first
produces none); date as assessment date rather than dose date;
seriesDosesString vs seriesDosesPositiveInt; adding id and meta.profile;
containing the Immunization with a #fragment reference; adding the CVX system to
that contained vaccineCode; a literal Immunization/<id> reference with no
contained resource.

Separately: on ImmunizationRecommendation.recommendation, doseNumberPositiveInt
makes FITS score 0% on every criterion including Series Status and all dates,
not just Dose Number. doseNumberString scores normally. R4 types this
positiveInt|string, so both are conformant and the integer form fails the whole
suite silently. Is that expected?

Happy to supply full request and response XML.
