# Processing Model - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Processing Model**

## Processing Model

### A quick overview of the basic logic because I think it helps make more sense of what is to come

* Most of the logic is at the level of the antigen, and most vaccines are broken down into their antigenic components and the logic is applied using them
* The basic gist of immunization logic runs like this:
* Create list of antigens that the patient should be immunized against
* Multiple options exist for immunity, some through infection (e.g. varicella), others through completing a vaccine series
* There are multiple series that are valid for inducing immunity, and may be appropriate given certain conditions, allergies, age, etc
* Each dose that has already been received is compared against the doses in every series, to see if they match required ages, intervals, etc
* When a vaccine that has previously been administered (historical vaccine) satisfies a dose in a series, that dose is considered satisfied, and the next recommended dose for each series is calculated
* After all historical vaccines are applied to each series, the series are scored according to factors such as how many valid doses they contain, how quickly they can be completed, or if they are the default series
* These scores are used to determine the preferred series for that particular antigen
* The series are then grouped together in Vaccine groups (MMR, DTaP, etc) to provide final recommendations for vaccines
* While not supplied in the official logic, these Vaccine groups should then be combined to actual Vaccines, with CVX/MVX codes and names, although this is somewhat more challenging as it usually has to do with which vaccines are available, rather than true preferences or recommendations

### Gathering Necessary Data

The engine accepts a FHIR R4 `Parameters` resource containing the patient's demographics, immunization history, and clinical data. From this, it extracts:

* **Patient demographics**: date of birth, gender
* **Immunization history**: past vaccine doses with dates, CVX codes, and any dose conditions
* **Observations**: conditions, allergies, procedures, medications, and other clinical data that may affect vaccine recommendations

Observations are mapped to CDSi observation codes via a crosswalk that supports multiple code systems (SNOMED CT, ICD-10-CM, CVX, CDCPHINVS, LOINC, RxNorm, and CPT). These observation codes drive risk series indications, contraindications, evidence of immunity, and conditional skip logic.

### Organize Immunization History

This is pretty self explanatory. After obtaining all of the immunizations a patient has received, break them down into their antigenic components using the CVX-to-antigen map in the supporting data. A single combination vaccine (like DTaP-IPV-HepB, CVX 146) maps to multiple antigens (Diphtheria, Tetanus, Pertussis, Polio, HepB), and the dose is evaluated independently in each antigen's series.

### Create Relevant Patient Series

This is a bit confusing at first. Later on in the logic it makes a bit more sense. At this stage there are just a couple of things to remember:

1. There are multiple ways to get appropriate immunity for an antigen
1. ANY of them are equally valid (for immunity purposes), and so we have to test each of them (as long as they are appropriate for the patient)
1. Standard Series: appropriate for anyone of the correct gender

* Correct gender, for the purposes of vaccine logic, patients are grouped into male, female, transgender or unknown. We use this value to determine if a series is appropriate for a patient.

#### Gender - Note that in this logic gender and sex are used synonymously for consistency in the logic. FOR THESE PURPOSES ONLY they refer to the same thing, and that is the genetic sex at birth. If you don't understand why there are differences in sex and gender (and gender identity), please consider reading any of the following articles by the AMA, Stanford, or Planned Parenthood

1. Risk Series: Series can be 'Standard', 'Evaluation Only', or 'Risk'. Each 'Risk' series has a list of indications that come from a list of 'Observations' (note, these are NOT the same as FHIR Observations). In some cases they are Conditions or Observations, but in some cases, they are Procedures, Immunizations, or just circumstances (like being a healthcare worker, or travel to endemic areas, etc.) that imparts a higher risk for certain diseases, and therefore the series will apply. If a Risk series cannot be definitely applied to a patient, then it is not used in the forecast (but a notification should be sent to the clinician alerting them to this fact).

Thus, a series is relevant if it is:

1. Appropriate for the patient's gender
1. **And**one of the following:
* A 'Standard' series
* A 'Risk' series whose indication observations match the patient's observations

### Evaluate and Forecast all Patient Series

1. For each antigen, we evaluate all of the relevant series.
1. For each series, we evaluate each required dose. The dose IN THE SERIES that we're trying to satisfy is called the target dose.
1. We compare, in chronological order, all of the injections the patient has received that could possibly satisfy the target dose.
1. If the patient has received no antigens for this series, we are finished with that series for now.
1. There are multiple requirements that have to be met to satisfy a target dose (was the vaccine given at the correct age, was the interval between the last dose and this dose appropriate, etc).
1. If all of those requirements are met, then that target dose is said to be satisfied.
1. If not, and the patient has received more injections, we repeat this process with each subsequent injection until the target dose has been satisfied or there are no more injections to evaluate.
1. If we have evaluated all of the patient's injections against the series, or the series has no more target doses (meaning we have successfully completed it), then we are done and can move onto the next series.
1. The one exception is for recurring series (such as Flu or Tetanus). For these, anytime a target dose is met, a new target dose, identical to the original is created, and then compared against the remaining vaccines. This continues until there are no more doses to evaluate.
1. After evaluation, any doses that were not assigned a status (neither valid, not valid, nor sub-standard) are marked as**extraneous**. These are doses that didn't match any target dose in the series.

### Select Patient Series

We're going to look through all of the series we just evaluated and find the one (or occasionally more than one) that is the best recommendation to get the patient fully immunized. This involves pre-filtering, identifying prioritized series, and scoring when no single series is clearly the best. See the [Select Patient Series](06_select-patient-series.md) page for details.

### Identify and Evaluate Vaccine Group

The above series are for individual antigens, not vaccines. There are vaccine groups that go together (notably MMR and DTaP/Tdap/Td) and generally you don't give one without the others. Because of this, we have to join the individual antigens together and evaluate them as a group. It's similar to the process for individual antigens, but we'll get to that towards the end.

