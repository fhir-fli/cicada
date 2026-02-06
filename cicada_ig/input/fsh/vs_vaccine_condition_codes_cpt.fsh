ValueSet: ImmunizationProceduresCpt
Id: immunization-procedures-cpt
Title: "Immunization-Relevant Procedures (CPT)"
Description: "CPT codes for procedures relevant to immunization decision support, including splenectomy and cochlear implant."
* ^status = #active

// 002 - Elective splenectomy
* include http://www.ama-assn.org/go/cpt#38100 "Splenectomy; total (separate procedure)"
* include http://www.ama-assn.org/go/cpt#38101 "Splenectomy; total, en bloc"
* include http://www.ama-assn.org/go/cpt#38102 "Splenectomy; total, en bloc with other organs"
* include http://www.ama-assn.org/go/cpt#38115 "Repair of ruptured spleen with splenorrhaphy"
* include http://www.ama-assn.org/go/cpt#38120 "Laparoscopy, surgical, splenectomy"

// 011 - Cochlear implant
* include http://www.ama-assn.org/go/cpt#69930 "Cochlear device implantation"
