Instance: SnomedToCdsiObservation
InstanceOf: ConceptMap
Usage: #definition
Title: "SNOMED CT to CDSi Observation Code Map"
Description: "Maps SNOMED CT codes to CDSi observation codes used in immunization decision support."
* status = #active
* sourceUri = "http://snomed.info/sct"
* targetUri = "https://www.cdc.gov/vaccines/programs/iis/cdsi"

* group[+].source = "http://snomed.info/sct"
* group[=].target = "https://www.cdc.gov/vaccines/programs/iis/cdsi"

// 003 - Immunocompromised
* group[=].element[+].code = #370388006
* group[=].element[=].display = "Patient immunocompromised"
* group[=].element[=].target[+].code = #003
* group[=].element[=].target[=].display = "Immunocompromised"
* group[=].element[=].target[=].equivalence = #equivalent

// 005 - Hepatitis C
* group[=].element[+].code = #50711007
* group[=].element[=].display = "Viral hepatitis type C"
* group[=].element[=].target[+].code = #005
* group[=].element[=].target[=].display = "Hepatitis C virus infection"
* group[=].element[=].target[=].equivalence = #equivalent

// 007 - Pregnant
* group[=].element[+].code = #77386006
* group[=].element[=].display = "Patient currently pregnant"
* group[=].element[=].target[+].code = #007
* group[=].element[=].target[=].display = "Pregnant"
* group[=].element[=].target[=].equivalence = #equivalent

// 013 - SCID
* group[=].element[+].code = #31323000
* group[=].element[=].display = "Severe combined immunodeficiency disease"
* group[=].element[=].target[+].code = #013
* group[=].element[=].target[=].display = "Severe Combined Immunodeficiency [SCID]"
* group[=].element[=].target[=].equivalence = #equivalent

// 014 - Diabetes
* group[=].element[+].code = #73211009
* group[=].element[=].display = "Diabetes mellitus"
* group[=].element[=].target[+].code = #014
* group[=].element[=].target[=].display = "Diabetes"
* group[=].element[=].target[=].equivalence = #equivalent

// 020 - Lab Evidence Measles
* group[=].element[+].code = #371111005
* group[=].element[=].display = "Measles immune"
* group[=].element[=].target[+].code = #020
* group[=].element[=].target[=].display = "Laboratory Evidence of Immunity for Measles"
* group[=].element[=].target[=].equivalence = #equivalent

// 021 - Lab Evidence Mumps
* group[=].element[+].code = #371112003
* group[=].element[=].display = "Mumps immune"
* group[=].element[=].target[+].code = #021
* group[=].element[=].target[=].display = "Laboratory Evidence of Immunity for Mumps"
* group[=].element[=].target[=].equivalence = #equivalent

// 022 - Lab Evidence Rubella
* group[=].element[+].code = #278968001
* group[=].element[=].display = "Rubella immune"
* group[=].element[=].target[+].code = #022
* group[=].element[=].target[=].display = "Laboratory Evidence of Immunity for Rubella"
* group[=].element[=].target[=].equivalence = #equivalent

// 026 - HIV/AIDS
* group[=].element[+].code = #86406008
* group[=].element[=].display = "Human immunodeficiency virus infection"
* group[=].element[=].target[+].code = #026
* group[=].element[=].target[=].display = "HIV/AIDS - immunocompromised"
* group[=].element[=].target[=].equivalence = #equivalent

// 027 - Asthma
* group[=].element[+].code = #195967001
* group[=].element[=].display = "Asthma"
* group[=].element[=].target[+].code = #027
* group[=].element[=].target[=].display = "Asthma"
* group[=].element[=].target[=].equivalence = #equivalent

// 031 - Tuberculosis
* group[=].element[+].code = #56717001
* group[=].element[=].display = "Tuberculosis"
* group[=].element[=].target[+].code = #031
* group[=].element[=].target[=].display = "Tuberculosis"
* group[=].element[=].target[=].equivalence = #equivalent
