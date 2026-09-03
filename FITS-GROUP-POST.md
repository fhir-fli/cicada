<!-- PASTE EVERYTHING BELOW THE LINE INTO THE FITS GOOGLE GROUP THREAD.
     Nothing else is open on FITS. -->

---

Thank you both.

Clement, glad the R4 Connector bug is identified. Sending this now rather than
after deployment, since you mention identifying at least part of the bug — if
any of it is useful to check the branch against before it merges, it is here.
We will re-run the AART cases once the fix is live and report back, and the
endpoint can stay up as a test target in the meantime.

Here is what we return, for AART-HepA-2: female, DOB 2025-08-29, one Hep A dose
CVX 85 given 2026-08-29, assessment date 2026-08-29. Same server build FITS was
pointed at, with the case replayed locally.

What we receive. This is our reconstruction of the case parameters rather than a
capture of your request; the vaccine code arrives with no system on it.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Parameters xmlns="http://hl7.org/fhir">
  <parameter>
    <name value="assessmentDate"/>
    <valueDate value="2026-08-29"/>
  </parameter>
  <parameter>
    <name value="patient"/>
    <resource>
      <Patient>
        <id value="1"/>
        <gender value="female"/>
        <birthDate value="2025-08-29"/>
      </Patient>
    </resource>
  </parameter>
  <parameter>
    <name value="immunization"/>
    <resource>
      <Immunization>
        <id value="1"/>
        <status value="completed"/>
        <vaccineCode>
          <coding>
            <code value="85"/>
          </coding>
        </vaccineCode>
        <patient>
          <reference value="Patient/1"/>
        </patient>
        <occurrenceDateTime value="2026-08-29"/>
      </Immunization>
    </resource>
  </parameter>
</Parameters>
```

What we return, verbatim. The evaluation parameter:

```xml
  <parameter>
    <name value="evaluation"/>
    <resource>
      <ImmunizationEvaluation xmlns="http://hl7.org/fhir">
        <id value="eval-1"/>
        <meta>
          <profile value="http://hl7.org/fhir/us/immds/StructureDefinition/immds-immunizationevaluation"/>
        </meta>
        <status value="completed"/>
        <patient>
          <reference value="Patient/1"/>
        </patient>
        <date value="2026-08-29T00:00:00.000-04:00"/>
        <targetDisease>
          <coding>
            <system value="http://snomed.info/sct"/>
            <code value="40468003"/>
            <display value="HepA"/>
          </coding>
          <text value="HepA"/>
        </targetDisease>
        <immunizationEvent>
          <reference value="Immunization/1"/>
        </immunizationEvent>
        <doseStatus>
          <coding>
            <system value="http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status"/>
            <code value="valid"/>
            <display value="Valid"/>
          </coding>
        </doseStatus>
        <series value="HepA 2-dose series"/>
        <doseNumberPositiveInt value="1"/>
        <seriesDosesPositiveInt value="2"/>
      </ImmunizationEvaluation>
    </resource>
  </parameter>
```

...and the matching entry inside the recommendation parameter:

```xml
        <recommendation>
          <extension>
            <url value="http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/series-type-ext"/>
            <valueCodeableConcept>
              <coding>
                <system value="http://fhirfli.dev/fhir/ig/cicada/CodeSystem/series-type"/>
                <code value="standard"/>
                <display value="Standard"/>
              </coding>
            </valueCodeableConcept>
          </extension>
          <vaccineCode>
            <coding>
              <system value="http://hl7.org/fhir/sid/cvx"/>
              <code value="85"/>
              <display value="Hep A, unspecified formulation"/>
            </coding>
          </vaccineCode>
          <targetDisease>
            <coding>
              <system value="http://snomed.info/sct"/>
              <code value="40468003"/>
              <display value="HepA"/>
            </coding>
            <text value="HepA"/>
          </targetDisease>
          <forecastStatus>
            <coding>
              <system value="http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus"/>
              <code value="Not Complete"/>
              <display value="Not Complete"/>
            </coding>
            <coding>
              <system value="http://terminology.hl7.org/CodeSystem/immunization-recommendation-status"/>
              <code value="due"/>
              <display value="Due"/>
            </coding>
            <coding>
              <system value="http://loinc.org"/>
              <code value="LA13422-3"/>
              <display value="On schedule"/>
            </coding>
          </forecastStatus>
          <dateCriterion>
            <code>
              <coding>
                <system value="http://loinc.org"/>
                <code value="30981-5"/>
                <display value="Earliest date to give"/>
              </coding>
            </code>
            <value value="2027-03-01T00:00:00.000-05:00"/>
          </dateCriterion>
          <dateCriterion>
            <code>
              <coding>
                <system value="http://loinc.org"/>
                <code value="30980-7"/>
                <display value="Date vaccine due"/>
              </coding>
            </code>
            <value value="2027-03-01T00:00:00.000-05:00"/>
          </dateCriterion>
          <dateCriterion>
            <code>
              <coding>
                <system value="http://loinc.org"/>
                <code value="59778-1"/>
                <display value="Date when overdue for immunization"/>
              </coding>
            </code>
            <value value="2028-04-25T00:00:00.000-04:00"/>
          </dateCriterion>
          <series value="HepA 2-dose series"/>
          <doseNumberString value="2"/>
        </recommendation>
```

The full response is 46 KB: one `immunization` and one `evaluation` parameter
per dose, plus one `recommendation` with 16 entries. Say if you want it, or any
other case.

Two things that look separate from the evaluation matching, so may survive the
fix. FITS only builds an evaluation candidate when `ImmunizationEvaluation.date`
holds the dose's administration date, but R4 and your own example put the
assessment date there, so the conformant value is the one that suppresses it.
And on `ImmunizationRecommendation.recommendation`, `doseNumberPositiveInt`
scores 0% on every criterion while `doseNumberString` scores normally, though R4
types the element `positiveInt|string` and allows both.
