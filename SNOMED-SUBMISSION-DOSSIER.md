# Proposed SNOMED CT submissions from cicada

<!-- guard: allow ABSENCE-CLAIM — this file is a register of verified absences; each
     rests on a COMPLETE family enumeration by hierarchy or a complete filtered result
     set from bumblebee/tool/sct.py, and step 2 requires re-running the check
     immediately before anything is sent -->

**THIRTEEN ITEMS OPEN. NOTHING HAS BEEN SUBMITTED.**

Companion to `TERMINOLOGY-AUDIT.md`, which says how the list was arrived at, and to
bumblebee's `docs/review/SNOMED-SUBMISSION-DOSSIER.md`, which uses the same format
and the same window: requests for the **January 2027 International release close
13 October 2026**, through NLM's US content request system with a free UMLS
Terminology Services account.

Structured to the SNOMED CT Content Request Service's requirements, from *Customer
Guidance for Requesting Changes to SNOMED CT* v15.0: **Summary · Topic · Proposed
Use Case · Reference** on every request, plus the **semantic tag** and a parent that
agrees with it. References must be internationally relevant, recent and
authoritative. **Generic justification is rejected** — "gap in terminology" and
"self-evident" are named as inadequate — so each use case below says what the concept
is for, in a system, for a patient.

## The state of the two preparation steps

1. **Duplicate check — DONE 2026-09-03, and it must be run again immediately before
   sending.** Every entry rests on either a complete hierarchy enumeration or a
   complete filtered result set through `bumblebee/tool/sct.py`, which escalates
   50 → 200 → 1000 and answers *cannot say* rather than *no* when the server
   truncates. Server: tx.fhir.org, SNOMED CT International 2025-02-01. Raw evidence
   in `bumblebee/results/`.
   🔴 **An earlier pass of this same check was wrong**: it searched the `Vaccine
   allergy` subtree, found no varicella, HPV, measles, yellow fever, zoster, JE,
   cholera or MenB concept, and concluded they were absent. They are all in the
   **`Vaccine adverse reaction`** subtree instead. Caught by CDSi's own coded values.
   That is why every entry below names the family it enumerated.
2. **Reference verification — PARTIAL.** Three references have been retrieved and
   read: Gold 2023, Caballero 2021, and the two WHO position papers named below.
   **The per-vaccine WHO position papers for Japanese encephalitis, meningococcal
   disease, influenza, tick-borne encephalitis and rotavirus exist** — they are on
   WHO's own position-paper index — **but their Weekly Epidemiological Record
   citations have not been retrieved yet and are marked ⏳.** WHO has **no** position
   paper for Ebola or chikungunya vaccines; those entries need a different
   international source and are marked 🛑.

---

# A. Adverse reaction to a vaccine that SNOMED does not name

**The family.** `293104008` |Vaccine adverse reaction| has **47 descendants, a
complete enumeration**, and SNOMED is actively extending it: seven COVID-19 concepts
were added by platform, and the component form —
`1303850003` |Adverse reaction to component of vaccine product containing Tick-borne
encephalitis virus antigen| and its HPV and varicella-zoster siblings — is the
current pattern. The vaccines below have no concept in that family, and none in
`863903001` |Vaccine allergy| either, which holds 21 concepts, also complete.

**The shared use case.** CDC's Clinical Decision Support for Immunization (CDSi)
supporting data, v4.65-508, makes "severe allergic reaction after a previous dose of
X" a **contraindication** that stops the engine recommending the next dose. With no
code, a record cannot say which vaccine the reaction was to, and every forecasting
engine either invents a local code — as this one did — or loses the distinction.

**The shared references, verified:**
- Gold MS, Amarasinghe A, Greenhawt M, Kelso JM, Kochhar S, Yu-Hor Thong B, Top KA,
  Turner PJ, Worm M, Law B. *Anaphylaxis: Revision of the Brighton collaboration case
  definition.* **Vaccine 2023;41(15):2605–14**, doi:10.1016/j.vaccine.2022.11.027,
  PMID 36435707. The international case definition these concepts record.

## A1. Adverse reaction to Ebola vaccine

- **Summary:** Adverse reaction to Ebola vaccine
- **Topic:** Immunization / vaccine safety
- **Semantic tag:** disorder
- **Proposed parent:** `408672009` |Adverse reaction to viral vaccine|
- **Use case:** CDSi observation 123 is a contraindication to further Ebola
  vaccination. rVSVΔG-ZEBOV-GP is deployed in outbreak ring vaccination, where the
  people vaccinated are contacts of cases and the record has to travel between
  response teams. Nothing in SNOMED can say the reaction was to the Ebola vaccine.
- **Absence:** `Ebolavirus` returns 15 concepts, complete, holding only vaccine
  products; the 47-concept family enumeration holds no Ebola concept.
- 🛑 **Reference: WHO has no Ebola vaccine position paper.** Use SAGE's 2021
  recommendation and the ERVEBO prequalification record instead — **both still to be
  retrieved and cited properly.**

## A2. Adverse reaction to dengue vaccine

- **Summary:** Adverse reaction to dengue vaccine
- **Topic:** Immunization / vaccine safety
- **Semantic tag:** disorder
- **Proposed parent:** `408672009` |Adverse reaction to viral vaccine|
- **Use case:** CDSi observation 210. Dengue vaccination is a two-product problem —
  CYD-TDV requires proof of prior infection, TAK-003 does not — so a record that
  cannot say a patient reacted to a dengue vaccine cannot be safely reused when the
  other product is offered.
- **Absence:** `dengue` returns 54 concepts, complete, with no reaction or allergy
  concept among them.
- ✅ **Reference:** WHO. *Dengue vaccines: WHO position paper – May 2024.* Weekly
  Epidemiological Record 2024;99(18):203–24.

## A3. Adverse reaction to respiratory syncytial virus vaccine

- **Summary:** Adverse reaction to respiratory syncytial virus vaccine
- **Topic:** Immunization / vaccine safety
- **Semantic tag:** disorder
- **Proposed parent:** `408672009` |Adverse reaction to viral vaccine|
- **Use case:** CDSi observation 244. RSVpreF is given in the third trimester to
  protect the infant, so the reaction is recorded in the mother's record and acted on
  in the infant's.
- **Absence:** `syncytial` returns 70 concepts, complete, holding
  `1303503001` |Administration of respiratory syncytial virus vaccine|,
  `51311000087100` |Respiratory syncytial virus only vaccine product|,
  `71191000119100` |Respiratory syncytial virus vaccination given| and
  `554366121000119108` |Human respiratory syncytial virus vaccination declined| —
  the whole workflow except the reaction.
- ✅ **Reference:** WHO. *WHO position paper on immunization to protect infants
  against respiratory syncytial virus disease – May 2025.* Weekly Epidemiological
  Record 2025;100(22):193–218.

## A4. Adverse reaction to Japanese encephalitis vaccine

- **Summary:** Adverse reaction to Japanese encephalitis vaccine
- **Topic:** Immunization / vaccine safety
- **Semantic tag:** disorder
- **Proposed parent:** `408672009` |Adverse reaction to viral vaccine|
- **Use case:** CDSi observation 082. **A concept exists in the US extension —
  `451301000124103` — and is unusable outside the United States.** JE vaccination is
  a routine childhood immunization across endemic Asia, which is where the concept is
  most needed.
- **Absence:** `Japanese` returns 77 concepts, complete, with nothing in the
  International edition.
- ⏳ **Reference:** WHO's Japanese encephalitis position paper — citation to retrieve.
- **Note for the request:** frame it as promoting existing US extension content, and
  name `451301000124103` so the Content Team can see the term already exists.

## A5. Adverse reaction to meningococcal group B vaccine

- **Summary:** Adverse reaction to meningococcal group B vaccine
- **Topic:** Immunization / vaccine safety
- **Semantic tag:** disorder
- **Proposed parent:** `219088009` |Adverse reaction to meningococcal vaccine|
- **Use case:** CDSi observation 116. MenB vaccines are a different product class
  from the conjugate vaccines and are scheduled separately; `219088009` cannot
  distinguish them, so a MenB reaction reads as a reaction to any meningococcal
  vaccine and blocks the wrong series.
- **Absence:** `meningococcal` returns 33 concepts, complete; the only International
  reaction concept is the undifferentiated `219088009`. The US extension has
  `451281000124102` (group B) and `451111000124103` (conjugate).
- ⏳ **Reference:** WHO's meningococcal vaccines position paper — citation to retrieve.

## A6. Adverse reaction to chikungunya vaccine

- **Summary:** Adverse reaction to chikungunya vaccine
- **Topic:** Immunization / vaccine safety
- **Semantic tag:** disorder
- **Proposed parent:** `408672009` |Adverse reaction to viral vaccine|
- **Use case:** CDSi observation 270, added in 4.65-508. Two chikungunya vaccines are
  now licensed and the live-attenuated one carries age and immunocompromise
  restrictions, so a prior reaction is a contraindication an engine must see.
- **Absence:** `chikungunya` returns 12 concepts, complete, holding three vaccine
  products and no reaction concept.
- 🛑 **Reference: WHO has no chikungunya vaccine position paper.** Needs a different
  international source — **to find.**

## A7–A9. Adverse reaction to influenza vaccine, by platform

Three requests, same shape: **egg-based inactivated or live attenuated (IIV/LAIV)**,
**cell-culture inactivated (ccIIV)**, **recombinant (RIV)** — CDSi observations 192,
193 and 194.

- **Topic:** Immunization / vaccine safety
- **Semantic tag:** disorder
- **Proposed parent:** `420113004` |Adverse reaction to influenza virus vaccine|
- **Use case:** the platform *is* the clinical distinction. A person who reacted to
  an egg-based influenza vaccine may be given a cell-culture or recombinant product;
  `420113004` cannot express that, so recording it there removes the only option the
  patient has. SNOMED has already accepted this argument for COVID-19, where the
  family carries mRNA, viral-vector, recombinant-spike, antigen, VLP and
  inactivated-whole variants as separate concepts.
- **Absence:** the 47-concept family enumeration holds one influenza concept.
- ⏳ **Reference:** WHO's influenza vaccines position paper — citation to retrieve.

---

# B. Allergy to a vaccine excipient that SNOMED does not name

**The family.** SNOMED pre-coordinates allergy to vaccine excipients wherever the
excipient matters: `294847001` gelatin, `860956003` yeast, `213020009` egg protein,
`1003755004` latex, `294278007` protamine, `870608005` thimerosal, `294426006`
formaldehyde, `402306009` aluminium, and — added recently, and exactly the precedent
these requests need — `1163445008` |Hypersensitivity to polysorbate-80| and
`1163444007` |Hypersensitivity to polyethylene glycol|.

**The shared reference, verified:**
- Caballero ML, Krantz MS, Quirce S, Phillips EJ, Stone CA Jr. *Hidden Dangers:
  Recognizing Excipients as Potential Causes of Drug and Vaccine Hypersensitivity
  Reactions.* **J Allergy Clin Immunol Pract 2021;9(8):2968–82**,
  doi:10.1016/j.jaip.2021.03.002.

## B1. Hypersensitivity to 2-phenoxyethanol

- **Semantic tag:** disorder · **Proposed parent:** `419199007` |Allergy to substance|
- **Use case:** CDSi observation 111 is a contraindication. 2-phenoxyethanol is the
  preservative in IPV and several combination vaccines used in every national
  schedule, so the alternative product is a different manufacturer's, not a different
  antigen.
- **Absence:** the substance `84103009` |Phenoxyethanol| exists;
  `phenoxyethanol` returns 3 concepts, complete, and none is an allergy.

## B2. Allergy to arginine

- **Semantic tag:** disorder · **Proposed parent:** `419199007` |Allergy to substance|
- **Use case:** CDSi observation 103. Arginine is a stabiliser in vaccine
  formulations; the substance is already coded, the allergy is not.
- **Absence:** `arginine` returns 106 concepts, complete, holding the substance
  `52625008` and no allergy concept.

## B3. Allergy to rice protein

- **Semantic tag:** disorder · **Proposed parent:** `419199007` |Allergy to substance|
- **Use case:** CDSi observation 124. Rice-derived protein appears in vaccine
  formulations; SNOMED codes the food `67324005` |Rice| and the allergen extract
  `411739002` but not the allergy.
- **Absence:** `rice` returns 551 concepts, complete, with no allergy-to-rice concept.

## B4. Allergy to chicken protein

- **Semantic tag:** disorder · **Proposed parent:** `419199007` |Allergy to substance|
- **Use case:** CDSi observation 105. This is the chicken-embryo protein in vaccines
  grown in chick cells, not chicken as food, and the distinction changes which
  vaccines are safe.
- **Absence:** `chicken` returns 68 concepts, complete. `703932008` |Allergy to
  chicken meat| is food allergy, and `411576001` |Chicken serum proteins diagnostic
  allergen extract| is a test reagent.
- ⚠️ **A reviewer will raise `703932008`.** The request has to argue the distinction
  explicitly or it reads as a duplicate.

## B5. Allergy to diphtheria toxoid · B6. Allergy to tetanus toxoid

- **Semantic tag:** disorder · **Proposed parent:** `419199007` |Allergy to substance|
- **Use case:** CDSi observations 117 and 118. The toxoid is the antigen shared
  across DTaP, Tdap, Td and several combination products, so an allergy to it rules
  out a different set of vaccines than an allergy to any one of them.
- **Absence:** `toxoid` returns 46 concepts, complete, and none is an allergy.
  `219085007` and `219084006` are reactions to the *vaccines*, which is a different
  statement.

---

# C. One indication concept

## C1. Receiving clotting factor concentrate

- **Summary:** Receiving clotting factor concentrate
- **Topic:** Haematology / immunization
- **Semantic tag:** finding
- **Use case:** CDSi observation 006 is an **indication**: people who receive
  clotting factor concentrates are recommended hepatitis A and hepatitis B
  vaccination because of the transmission risk from plasma-derived product. The
  criterion is the product received, not the diagnosis, so the haemophilia concepts
  do not carry it.
- **Absence:** `coagulation` returns 495 and `concentrate` 62, both complete, with no
  factor-concentrate therapy concept in either; `hemophilia` and `haemophilia` return
  43 and 42, complete, holding the deficiency diseases only.
- ⏳ **Reference:** to retrieve — a WFH or national haemophilia guideline naming
  vaccination of concentrate recipients.

---

## Before anything is sent

1. **Re-run the duplicate check.** `bumblebee/tool/ig_code_gap_check.py` and the
   family enumerations. The International edition moves twice a year.
2. **Retrieve the ⏳ and 🛑 references.** Five position papers to cite properly, and
   two vaccines that have no WHO position paper at all and need another
   internationally relevant source.
3. **Decide A7–A9.** Three influenza platform requests are the weakest of the set —
   a reviewer may say the platform belongs on the vaccine product, not the reaction.
   The COVID-19 precedent says otherwise, but that is an argument, not a fact.
4. **Decide C1**, which is an indication rather than a reaction and sits alone.
