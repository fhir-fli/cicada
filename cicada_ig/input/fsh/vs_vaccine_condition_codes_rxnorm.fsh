ValueSet: VaccineMedicationCodesRxnorm
Id: vaccine-medication-codes-rxnorm
Title: "Immunization-Relevant Medications (RxNorm)"
Description: "RxNorm codes for medications relevant to immunization decision support, including antivirals and aspirin."
* ^status = #active

// 033 - Antiviral therapy
// 🔴 Corrected 2026-09-03. 39786 was labelled "Valacyclovir" and is venlafaxine, an
// antidepressant, in a value set of antivirals that suppress the response to
// varicella vaccine. 24811 labelled "Famciclovir" does not exist. Both codes were
// resolved through RxNav (rxnav.nlm.nih.gov/REST/rxcui.json?name=...), taking the
// ingredient-level concept (TTY=IN, not the PIN salt forms), then validated with
// their displays against tx.fhir.org.
* include http://www.nlm.nih.gov/research/umls/rxnorm#281 "acyclovir"
* include http://www.nlm.nih.gov/research/umls/rxnorm#68099 "famciclovir"
* include http://www.nlm.nih.gov/research/umls/rxnorm#73645 "valACYclovir"

// 034 - Long-term aspirin therapy
* include http://www.nlm.nih.gov/research/umls/rxnorm#1191 "Aspirin"
