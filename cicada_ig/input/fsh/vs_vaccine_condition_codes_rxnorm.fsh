ValueSet: VaccineMedicationCodesRxnorm
Id: vaccine-medication-codes-rxnorm
Title: "Immunization-Relevant Medications (RxNorm)"
Description: "RxNorm codes for medications relevant to immunization decision support, including antivirals and aspirin."
* ^status = #active

// 033 - Antiviral therapy
* include http://www.nlm.nih.gov/research/umls/rxnorm#281 "Acyclovir"
* include http://www.nlm.nih.gov/research/umls/rxnorm#24811 "Famciclovir"
* include http://www.nlm.nih.gov/research/umls/rxnorm#39786 "Valacyclovir"

// 034 - Long-term aspirin therapy
* include http://www.nlm.nih.gov/research/umls/rxnorm#1191 "Aspirin"
