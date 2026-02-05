# Cicada IG

## 100% Credit goes to the CDC and their [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/vaccines/programs/iis/cdsi.html)

All I've done is take all of their hard work, guidance and expertise and make it computable (well, perhaps it's already computable, I made a computer actually do it).

The CDC manual can be found [here](https://www.cdc.gov/vaccines/programs/iis/interop-proj/downloads/logic-spec-acip-rec-4.5.pdf)

First, a warning:
This is not completely FHIR compliant. As part of this was to help myself get more familiar with [FHIR Shorthand (commonly known as FSH)](https://build.fhir.org/ig/HL7/fhir-shorthand/), there are some "Resources" I've defined (e.g. [Antigen Supporting Data](StructureDefinition-antigen-supporting-data.html) and [Schedule Supporting Data](StructureDefinition-schedule-supporting-data.html)), that are certainly NOT FHIR. However, they are an accurate representation (at least in JSON) for the data used in the CDC's "CLINICAL DECISION SUPPORT FOR IMMUNIZATION (CDSI): LOGIC SPECIFICATION FOR ACIP RECOMMENDATIONS".

### [Preparation](01_preparation.html)
- This is some technical background in case anyone is interested on working on this themselves.

### [Immunization Decision Support Forecast Working Group](http://hl7.org/fhir/us/immds/)
- Because I can never find it
- Official HL7 working group

### [Logical Specification Concepts](02_logical-specification-concepts.html)
- There are a number of concepts that are involved in the evaluation and prediction of immunizations. Some of these terms make logical sense, but others do not. Here's a description of some of them. Again, this was all taken from the [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/vaccines/programs/iis/cdsi.html).

### [Processing Model](03_processing-model.html)
- Brief overview of the analysis and forecasting process prior to a detailed discussion

### [Evaluate Vaccine Dose Administered](04_evaluate-vaccine-dose-administered.html)
- Summarizes the steps to evaluate every vaccine within every series to which it applies

### [Forecast Dates and Reasons](05_forecast-dates-and-reasons.html)
- Made it through the evaluation process. Next up, creating the forecast.