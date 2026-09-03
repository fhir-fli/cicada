// 🔴 Rebuilt 2026-09-03. Fourteen of the eighteen codes this value set carried did
// not mean what their display said, and six of those were a different test:
//
//   21500-4  labelled "Measles IgG [Units/volume] in Serum"  is a CSF titre by immunofluorescence
//   22416-2  labelled "Mumps Ab [Presence] in Serum"         is a CSF titre
//   39012-0  labelled "Mumps IgG [Presence] in Serum"        is Mycoplasma pneumoniae Ab in Body fluid
//   13950-1  labelled "HAV Ab [Units/volume] in Serum"       is HAV IgM — acute infection, not immunity
//   6476-3   labelled "Mumps IgG [Units/volume] in Serum"    does not exist (6476-6 does)
//   5403-8   labelled "VZV Ab [Presence] in Serum"           does not exist (5403-1 does)
//
// A serum IgG result never matches a CSF titre code, so evidence of immunity was
// silently not found and the engine forecast a dose the patient did not need. The
// rest were paraphrased displays — "[Presence] in Serum" for a code that is
// "[Presence] in Serum by Immunoassay" — which is how the wrong ones hid.
//
// Every code below was validated WITH ITS DISPLAY against tx.fhir.org, LOINC 2.82.
// Candidates were enumerated from complete LOINC result sets, not guessed:
// bumblebee/results/cicada_immunity_loinc_candidates*.txt.
//
// The comment numbers are CDSi's, and they were wrong before too: hepatitis A is
// observation 018 and hepatitis B is 019. 024 and 025 are the healthcare-provider
// verified varicella and zoster histories, which are not laboratory tests at all.
ValueSet: VaccineLabEvidenceOfImmunityLoinc
Id: vaccine-lab-evidence-of-immunity-loinc
Title: "Lab Evidence of Immunity (LOINC)"
Description: "LOINC codes for laboratory tests that provide evidence of immunity, mapped to CDSi observation codes for immunization decision support. Serum IgG in every case, plus total antibody for hepatitis A, which is what evidence of immunity means for these antigens; IgM, cerebrospinal fluid and avidity codes are deliberately excluded."
* ^status = #active

// 018 - Laboratory Evidence of Immunity or confirmation of Hepatitis A disease
* include http://loinc.org#32018-4 "Hepatitis A virus IgG Ab [Presence] in Serum"
* include http://loinc.org#40724-7 "Hepatitis A virus IgG Ab [Presence] in Serum by Immunoassay"
* include http://loinc.org#22313-1 "Hepatitis A virus IgG Ab [Units/volume] in Serum"
* include http://loinc.org#20575-7 "Hepatitis A virus Ab [Presence] in Serum"

// 019 - Laboratory Evidence of Immunity or confirmation of Hepatitis B disease
* include http://loinc.org#16935-9 "Hepatitis B virus surface Ab [Units/volume] in Serum"
* include http://loinc.org#22322-2 "Hepatitis B virus surface Ab [Presence] in Serum"
* include http://loinc.org#10900-9 "Hepatitis B virus surface Ab [Presence] in Serum by Immunoassay"

// 020 - Laboratory Evidence of Immunity for Measles
* include http://loinc.org#7962-4 "Measles virus IgG Ab [Units/volume] in Serum"
* include http://loinc.org#20479-2 "Measles virus IgG Ab [Presence] in Serum"
* include http://loinc.org#35275-7 "Measles virus IgG Ab [Presence] in Serum by Immunoassay"

// 021 - Laboratory Evidence of Immunity for Mumps
* include http://loinc.org#7966-5 "Mumps virus IgG Ab [Units/volume] in Serum"
* include http://loinc.org#22415-4 "Mumps virus IgG Ab [Presence] in Serum"
* include http://loinc.org#6476-6 "Mumps virus IgG Ab [Presence] in Serum by Immunoassay"

// 022 - Laboratory Evidence of Immunity for Rubella
* include http://loinc.org#8014-3 "Rubella virus IgG Ab [Units/volume] in Serum"
* include http://loinc.org#25514-1 "Rubella virus IgG Ab [Presence] in Serum"
* include http://loinc.org#40667-8 "Rubella virus IgG Ab [Presence] in Serum or Plasma by Immunoassay"

// 023 - Laboratory Evidence of Immunity or confirmation of Varicella disease
* include http://loinc.org#8047-3 "Varicella zoster virus IgG Ab [Units/volume] in Serum"
* include http://loinc.org#19162-7 "Varicella zoster virus IgG Ab [Presence] in Serum"
* include http://loinc.org#15410-4 "Varicella zoster virus IgG Ab [Presence] in Serum by Immunoassay"
