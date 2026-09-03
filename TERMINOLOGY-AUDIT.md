# Every code this IG mints, checked against SNOMED CT, LOINC and the published IGs

<!-- guard: allow ABSENCE-CLAIM — every negative below is a COMPLETE result set from
     bumblebee/tool/sct.py, which escalates 50→200→1000 and reports cannot-say rather
     than no when the server truncates, or a complete family enumeration by hierarchy;
     per-probe evidence in bumblebee/results/ig_code_gap_check.tsv and the family files -->

Audited 2026-09-03. `cicada_ig` defines **302 codes in 11 code systems**. This file
says what each one is, what already exists elsewhere, and what has to change here.

**Two decisions are open and both are yours** — the ImmDS change request in §5, and
whether the 13 submission candidates in `SNOMED-SUBMISSION-DOSSIER.md` are worth the
window that closes **13 October 2026**. Everything else below is a defect with the
fix named.

## Method, and what it cannot tell you

Two single-word probes per concept through `bumblebee/tool/sct.py`, which escalates
50 → 200 → 1000 and returns *cannot say* rather than *no* when the server truncates,
matching client-side against every designation. Where a whole family mattered it was
enumerated by hierarchy rather than searched, which is a stronger instrument: an
enumeration lets membership be checked per item.

Everything resolved against tx.fhir.org, which serves
`http://snomed.info/sct/900000000000207008/version/20250201` — **International,
2025-02-01** — and LOINC 2.82. The public SNOMED browser is unreachable from this
machine, so that one server is the only source for every edition claim here.

🔴 **One conclusion in this audit was wrong before CDC's own data corrected it.** An
early pass searched the `Vaccine allergy` family, found no varicella, HPV, measles,
yellow fever, zoster, JE, cholera or MenB concept, and concluded SNOMED lacked all of
them. It does not: CDC codes those observations to the **`Vaccine adverse reaction`**
family, which is a different subtree and holds every one. The false absence was
caught only because CDSi's own `<codedValues>` contradicted it. Searching one family
and concluding about the terminology is the same error this repo has now made ten
times.

## 1. 🔴 The CDSi observation code system is 27 concepts behind CDC

`cdsi-observation-codes` carries **251** concepts. CDSi 4.65-508, in
`cicada_generator/lib/Version_4.65-508/XML/ScheduleSupportingData.xml`, carries
**278**. Nothing in our IG is absent from CDC's file; **27 of CDC's are absent from
ours**: 253, 254, 256–269 (asthma severity, chronic cardiovascular disease, the five
diabetes-complication observations, islet transplantation, transplantation), 270–272
(chikungunya), 273–280 (immunoglobulin deficiency, complement inhibitor use, measles
outbreak, age ≥60, chikungunya laboratory exposure, birth mother received RSV vaccine
in pregnancy, hemoglobinopathy, chronic lung disease of prematurity).

**Fix:** regenerate the code system from the supporting data rather than maintaining
it by hand.

## 2. 🔴 The ConceptMap uses 11 of the 150 SNOMED mappings CDC publishes

CDSi's supporting data carries a `<codedValues>` block per observation:
**275 SNOMED codings across 150 of the 278 observations**, plus 171 CVX and 31
CDCPHINVS. `ConceptMap-SnomedToCdsiObservation` carries **11 elements**.
`ConceptMap-Icd10ToCdsiObservation` carries 17.

**139 SNOMED mappings CDC already publishes are unused**, including breastfeeding,
CSF leak, cochlear implant, chronic liver disease, chronic heart disease, chronic
lung disease and hepatitis A immunity. They are all in the file the generator
already reads.

**Fix:** generate both ConceptMaps from `<codedValues>` instead of hand-listing them.
Evidence: `bumblebee/results/cdsi_observation_codings.tsv`.

## 3. 🔴 Three different URLs name one concept space, and two are defined nowhere

| where | URL |
|---|---|
| the CodeSystem this IG publishes | `http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes` |
| `ConceptMap-SnomedToCdsiObservation` group target | `https://www.cdc.gov/vaccines/programs/iis/cdsi` |
| `cicada_generator/lib/generate_observation_map_entries.dart` | `http://fhirfli.dev/fhir/ig/cicada/CodeSystem/vaccine-observation-codes` |

The ConceptMap therefore does not map into this IG's own code system, and the
StructureMap the generator writes emits codings in a system no CodeSystem defines.

**Fix:** one URL, the one the CodeSystem publishes, in all three places.

## 4. 🔴 Nine SNOMED codes CDC cites are not in the International edition

All 244 distinct SNOMED codes in CDSi's supporting data were run through
`CodeSystem/$validate-code`. Nine do not resolve:

| code | CDC's text | CDSi observation |
|---|---|---|
| `2219088009` | Adverse reaction to meningococcal vaccine | 095 |
| `429301000124101` | Adverse reaction to rotavirus vaccine | 083 |
| `429311000124103` | Adverse reaction to human papillomavirus vaccine | 090 |
| `451111000124103` | Adverse reaction caused by meningococcal conjugate vaccine | 095 |
| `451281000124102` | Adverse reaction caused by meningococcal group B vaccine | 116 |
| `451291000124104` | Adverse reaction caused by zoster vaccine | 100, 172 |
| `451301000124103` | Adverse reaction caused by Japanese encephalitis virus vaccine | 082 |
| `451331000124106` | Adverse reaction caused by varicella virus live vaccine | 089 |
| `5281000124103` | Persistent Asthma | 253 |

**`2219088009` is a typo in CDC's file.** `219088009` |Adverse reaction to
meningococcal vaccine| is International and is what the text names. That one is
reportable to CDC — add it to `CDC-REPORT.md`.

The other eight are **US extension** content. An implementation outside the United
States cannot use them. Two have International equivalents in the newer component
form — `1303851004` for HPV and `1303852006` for varicella and zoster — and the rest
are in the dossier.

## 5. 🟠 Our own code systems mostly duplicate published ones

**`EvalReason` (15 codes) overlaps `hl7.fhir.us.immds` 1.0.0, which this IG already
depends on.** ImmDS publishes `StatusReason` with expired · tooyoung · tooold ·
inappropriate · toosoon · productconflict · quantity · recall · storage ·
notevaluated. `EvalReason` mints `expired`, `ageTooOld`, `ageTooYoung`,
`notPreferableOrAllowable`, `intervalTooShort`, `notRecommendedVolume`,
`partialDose`, `recall`, `adverseStorage` and `liveVirusConflict` for the same
meanings.

**And SNOMED has the product-quality half of it.** `1340072001` |Finding of vaccine
product| has ten children, a complete family: expired, expired after vial puncture,
expired after thawing, recalled by manufacturer, adverse storage, cold chain
breakdown, accidental breakage during handling, temperature drift during transport,
quality defect, out of stock.

| our code | SNOMED International |
|---|---|
| `expired` | `1290616008` \|Vaccine product expired\| |
| `recall` | `1290618009` \|Vaccine product recalled by manufacturer\| |
| `adverseStorage` | `1290620007` \|Vaccine product adverse storage\| |
| `coldChainBreak` | `1290621006` \|Vaccine product cold chain breakdown\| |

The remaining `EvalReason` codes — no date given, no CVX, age too young or old,
interval too short, partial dose, inadvertent vaccine, series already completed,
live virus conflict — are **outcomes of running the engine**, not findings about a
patient or a product. SNOMED's own guidance bars requests whose justification is
"gap in terminology", and a decision-support outcome is not a clinical finding.
**They belong in ImmDS, not SNOMED.**

`IntervalReason`, `ValidAgeReason`, `PreferredAllowedReason`, `data-integrity`,
`series-type` and `target-dose-status` are the same shape. None is a SNOMED
candidate. `EvalStatus#extraneous` is a deliberate, documented extension of the HL7
THO dose-status code system and should stay.

**`forecast-reason` is the one that was done right.** Every concept's definition
names the ImmDS code it maps to, or says *"No ImmDS concept."* The five that say so —
`evidence-of-immunity`, `contraindication`, `cannot-finish-before-maximum-age`,
`below-minimum-age-to-start`, `shared-clinical-decision-making` — are a **change
request to the ImmDS implementation guide**, which is the decision that needs you.

**`VaccineGender` (female, male, transgender, unknown)** mixes administrative gender
with gender identity in one list, which HL7's Gender Harmony work separates
deliberately. It is not a SNOMED gap; it is a modelling decision to revisit against
US Core and Gender Harmony before this IG goes anywhere.

## 6. 🔴 Four codes this IG cites do not exist, and nine more mean something else

232 distinct external codes were validated. Four do not resolve at all:

| system | code | our display |
|---|---|---|
| ICD-10-CM | `A18.9` | Tuberculosis of other organs — unknown in the 2026-04-01 release |
| LOINC | `5403-8` | Varicella zoster virus Ab [Presence] in Serum — unknown in 2.82 |
| LOINC | `6476-3` | Mumps virus IgG Ab [Units/volume] in Serum — unknown in 2.82 |
| RxNorm | `24811` | Famciclovir — unknown in the 03022026 release |

**Resolving is not the same as meaning what we say it means.** Re-running the check
with the `display` parameter, so the server has to agree with our label, found nine
more where the code is a different concept:

| system | code | our label | what it actually is |
|---|---|---|---|
| RxNorm | `39786` | Valacyclovir | **venlafaxine** |
| LOINC | `39012-0` | Mumps virus IgG Ab [Presence] in Serum | **Mycoplasma pneumoniae Ab [Presence] in Body fluid** |
| LOINC | `22416-2` | Mumps virus Ab [Presence] in Serum | **Mumps virus IgG Ab [Titer] in Cerebral spinal fluid** |
| LOINC | `21500-4` | Measles virus IgG Ab [Units/volume] in Serum | **Measles virus IgG Ab [Titer] in Cerebral spinal fluid by Immunofluorescence** |
| LOINC | `13950-1` | Hepatitis A virus Ab [Units/volume] in Serum | **Hepatitis A virus IgM Ab [Presence] in Serum or Plasma by Immunoassay** |
| LOINC | `20458-6` | Rubella virus Ab [Presence] in Serum | Rubella virus IgG Ab [**Interpretation**] in Serum |
| LOINC | `32018-4` | Hepatitis A virus Ab [Presence] in Serum | Hepatitis A virus **IgG** Ab [Presence] in Serum |
| CPT | `38101` | Splenectomy; total, en bloc | Splenectomy; **partial** (separate procedure) |
| CPT | `38115` | Repair of ruptured spleen with splenorrhaphy | Repair of ruptured spleen (splenorrhaphy) **with or without partial splenectomy** |

🔴 **`39786` is venlafaxine, an antidepressant, sitting in a value set of antivirals
that suppress the immune response to varicella vaccine.** 🔴 **Three of the six
lab-evidence-of-immunity codes are CSF or the wrong organism**, in a value set whose
entire job is deciding whether a patient is immune. A serum IgG result will not match
a CSF titre code, so the evidence is silently not found and the engine forecasts a
dose the patient does not need — or, for `39012-0`, matches a *Mycoplasma* antibody.

Nine ICD-10-CM rows differ only in wording (abbreviations, "Fatty (change of) liver")
and are fine.

**All of them are fixed**, and the codes were looked up rather than guessed:

- **RxNorm** through RxNav (`rxnav.nlm.nih.gov/REST/rxcui.json?name=`), taking the
  ingredient concept (TTY=IN) rather than the salt forms: valaciclovir is `73645`
  (display `valACYclovir`, RxNorm's tall-man casing), famciclovir `68099`. `39786`
  and the non-existent `24811` are gone.
- **The lab-evidence set was rebuilt**, not patched. Candidates came from complete
  LOINC 2.82 result sets per analyte, filtered to serum IgG — and total antibody for
  hepatitis A, which is what evidence of immunity means there — with CSF, IgM, titre
  and avidity codes excluded deliberately. **19 codes, all validated with their
  displays, 19 of 19 exact.** `13950-1` went because IgM is acute infection, not
  immunity. The section comments were also wrong: hepatitis A is CDSi observation
  018 and hepatitis B is 019; 024 and 025 are the provider-verified varicella and
  zoster histories, which are not laboratory tests.
- **CPT** displays taken from the server: `38101` is *partial* splenectomy, `38102`
  is the en-bloc add-on code, `38115` includes "with or without partial splenectomy",
  `69930` includes "with or without mastoidectomy".
- **ICD-10-CM** `A18.9` replaced with `A18.89` |Tuberculosis of other sites|, the
  codeable leaf under `A18.8` |Tuberculosis of other specified organs|, which is what
  the old display meant.

What is left is 18 cosmetic differences — ICD-10-CM abbreviations we wrote out
("SCID" for "Severe combined immunodeficiency [SCID]"), and the LOINC answer-list
displays, which carry a whole sentence of definition. Those are worth normalising
so the next sweep is quiet, but none changes what a code means.

Evidence: `bumblebee/results/ig_external_codes.tsv`, `ig_display_mismatches.tsv`.

🔑 **`$validate-code` without `display` only proves the code exists.** My own first
pass ran it that way and reported all 232 valid.

## 7. The 118 observations CDC does not code, adjudicated one at a time

Full table: `bumblebee/results/cdsi_uncoded_verdicts.tsv`.

| verdict | n | meaning |
|---|---|---|
| COMPOSITE | 70 | An eligibility rule — a role, a place, a destination, a duration — that SNOMED expresses by combining a finding with a value, not by pre-coordinating a concept. Not submissions. |
| MAP | 21 | SNOMED International already carries it and we should use it. |
| DECIDE | 14 | Something close exists; a clinician chooses whether it carries the meaning. |
| SUBMIT | 13 | No concept, and the family shows SNOMED carries this kind. |

**The 21 that map** include `105502003` |Dependence on renal dialysis| (032),
`371108009` |Varicella non-immune| (074), `303010008` |Hepatitis A gamma globulin
given| (126), `234645009` |Drug-induced immunodeficiency| (216), `1340018008` |TTS
following non-replicating adenovirus vector COVID-19 vaccination| (209),
`1290711000000105` |Exposure to monkeypox virus| (241) and `160734000` |Lives in
nursing home| (197).

**The 70 composites are a finding, not a failure.** Two thirds of what CDSi asks a
record for is not a diagnosis; it is *travelling to a JE-endemic area for a month or
more*, *a laboratory worker who handles specimens that might contain polioviruses*,
*a household contact under one year of age*. Any implementation of CDSi has to hold
these somewhere, and SNOMED is not where they go. That is worth saying out loud in
the IG's own narrative, because it is the part an implementer will otherwise
discover the hard way.

## 8. LOINC

No LOINC gap is demonstrated. The lab-evidence-of-immunity value set binds LOINC
codes for measles, mumps, rubella, varicella, hepatitis A and hepatitis B serology;
two of them are retired or wrong (§6) and the rest resolve. The forecast status value
set already uses LOINC answer list `LL940-8`.

## What to change here, in order

1. Regenerate `cdsi-observation-codes` from the 4.65-508 supporting data (§1).
2. Generate both ConceptMaps from `<codedValues>` (§2) — 139 mappings we already have.
3. Collapse the three CDSi URLs to one (§3).
4. Fix the four dead external codes **and the nine that mean something else** (§6).
   The venlafaxine-for-valacyclovir row and the three lab-evidence codes pointing at
   CSF titres or *Mycoplasma* are the ones that change what the engine decides.
5. Replace the `EvalReason` product-quality codes with the four SNOMED codes, and
   the rest with ImmDS `StatusReason` (§5).
6. File `2219088009` in `CDC-REPORT.md` (§4).
7. Draft requests: `SNOMED-SUBMISSION-DOSSIER.md` (§7 SUBMIT and §4 US extension).
