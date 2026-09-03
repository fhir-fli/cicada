ValueSet: ImmunizationProceduresCpt
Id: immunization-procedures-cpt
Title: "Immunization-Relevant Procedures (CPT)"
Description: "CPT codes for procedures relevant to immunization decision support, including splenectomy and cochlear implant."
* ^status = #active

// 002 - Elective splenectomy
// Displays corrected 2026-09-03 to what the code actually says: 38101 is PARTIAL
// splenectomy, not "total, en bloc", and 38102 is an add-on code for en bloc
// removal in conjunction with another procedure. Every display below was validated
// against tx.fhir.org.
* include http://www.ama-assn.org/go/cpt#38100 "Splenectomy; total (separate procedure)"
* include http://www.ama-assn.org/go/cpt#38101 "Splenectomy; partial (separate procedure)"
* include http://www.ama-assn.org/go/cpt#38102 "Splenectomy; total, en bloc for extensive disease, in conjunction with other procedure (List in addition to code for primary procedure)"
* include http://www.ama-assn.org/go/cpt#38115 "Repair of ruptured spleen (splenorrhaphy) with or without partial splenectomy"
* include http://www.ama-assn.org/go/cpt#38120 "Laparoscopy, surgical, splenectomy"

// 011 - Cochlear implant
* include http://www.ama-assn.org/go/cpt#69930 "Cochlear device implantation, with or without mastoidectomy"
