Instance: Icd10ToCdsiObservation
InstanceOf: ConceptMap
Usage: #definition
Title: "ICD-10-CM to CDSi Observation Code Map"
Description: "Maps ICD-10-CM diagnosis codes to CDSi observation codes used in immunization decision support."
* status = #active
* sourceUri = "http://hl7.org/fhir/sid/icd-10-cm"
* targetUri = "https://www.cdc.gov/vaccines/programs/iis/cdsi"

* group[+].source = "http://hl7.org/fhir/sid/icd-10-cm"
* group[=].target = "https://www.cdc.gov/vaccines/programs/iis/cdsi"

// 003 - Immunocompromised
* group[=].element[+].code = #D84.9
* group[=].element[=].display = "Immunodeficiency, unspecified"
* group[=].element[=].target[+].code = #003
* group[=].element[=].target[=].display = "Immunocompromised"
* group[=].element[=].target[=].equivalence = #wider

// 005 - Hepatitis C
* group[=].element[+].code = #B18.2
* group[=].element[=].display = "Chronic viral hepatitis C"
* group[=].element[=].target[+].code = #005
* group[=].element[=].target[=].display = "Hepatitis C virus infection"
* group[=].element[=].target[=].equivalence = #equivalent

// 007 - Pregnant
* group[=].element[+].code = #Z33.1
* group[=].element[=].display = "Pregnant state, incidental"
* group[=].element[=].target[+].code = #007
* group[=].element[=].target[=].display = "Pregnant"
* group[=].element[=].target[=].equivalence = #equivalent

// 013 - SCID
* group[=].element[+].code = #D81.9
* group[=].element[=].display = "Combined immunodeficiency, unspecified"
* group[=].element[=].target[+].code = #013
* group[=].element[=].target[=].display = "Severe Combined Immunodeficiency [SCID]"
* group[=].element[=].target[=].equivalence = #wider

// 014 - Diabetes
* group[=].element[+].code = #E11.9
* group[=].element[=].display = "Type 2 diabetes mellitus without complications"
* group[=].element[=].target[+].code = #014
* group[=].element[=].target[=].display = "Diabetes"
* group[=].element[=].target[=].equivalence = #wider

// 015 - Chronic liver disease
* group[=].element[+].code = #K74.60
* group[=].element[=].display = "Unspecified cirrhosis of liver"
* group[=].element[=].target[+].code = #015
* group[=].element[=].target[=].display = "Chronic liver disease"
* group[=].element[=].target[=].equivalence = #wider

// 016 - Chronic heart disease
* group[=].element[+].code = #I50.9
* group[=].element[=].display = "Heart failure, unspecified"
* group[=].element[=].target[+].code = #016
* group[=].element[=].target[=].display = "Chronic heart disease"
* group[=].element[=].target[=].equivalence = #wider

// 017 - Chronic lung disease
* group[=].element[+].code = #J44.9
* group[=].element[=].display = "Chronic obstructive pulmonary disease, unspecified"
* group[=].element[=].target[+].code = #017
* group[=].element[=].target[=].display = "Chronic lung disease"
* group[=].element[=].target[=].equivalence = #wider

// 018 - Asplenia
* group[=].element[+].code = #D73.0
* group[=].element[=].display = "Hyposplenism"
* group[=].element[=].target[+].code = #018
* group[=].element[=].target[=].display = "Asplenia"
* group[=].element[=].target[=].equivalence = #equivalent

* group[=].element[+].code = #Z90.81
* group[=].element[=].display = "Acquired absence of spleen"
* group[=].element[=].target[+].code = #018
* group[=].element[=].target[=].display = "Asplenia"
* group[=].element[=].target[=].equivalence = #equivalent

// 019 - Chronic renal failure
* group[=].element[+].code = #N18.6
* group[=].element[=].display = "End stage renal disease"
* group[=].element[=].target[+].code = #019
* group[=].element[=].target[=].display = "Chronic renal failure"
* group[=].element[=].target[=].equivalence = #wider

// 026 - HIV/AIDS
* group[=].element[+].code = #B20
* group[=].element[=].display = "Human immunodeficiency virus [HIV] disease"
* group[=].element[=].target[+].code = #026
* group[=].element[=].target[=].display = "HIV/AIDS - immunocompromised"
* group[=].element[=].target[=].equivalence = #equivalent

* group[=].element[+].code = #Z21
* group[=].element[=].display = "Asymptomatic human immunodeficiency virus [HIV] infection status"
* group[=].element[=].target[+].code = #026
* group[=].element[=].target[=].display = "HIV/AIDS - immunocompromised"
* group[=].element[=].target[=].equivalence = #wider

// 027 - Asthma
* group[=].element[+].code = #J45.909
* group[=].element[=].display = "Unspecified asthma, uncomplicated"
* group[=].element[=].target[+].code = #027
* group[=].element[=].target[=].display = "Asthma"
* group[=].element[=].target[=].equivalence = #wider

// 028 - Intussusception
* group[=].element[+].code = #K56.1
* group[=].element[=].display = "Intussusception"
* group[=].element[=].target[+].code = #028
* group[=].element[=].target[=].display = "Intussusception"
* group[=].element[=].target[=].equivalence = #equivalent

// 031 - Tuberculosis
* group[=].element[+].code = #A15.0
* group[=].element[=].display = "Tuberculosis of lung"
* group[=].element[=].target[+].code = #031
* group[=].element[=].target[=].display = "Tuberculosis"
* group[=].element[=].target[=].equivalence = #wider

// 034 - Long-term aspirin
* group[=].element[+].code = #Z79.82
* group[=].element[=].display = "Long term (current) use of aspirin"
* group[=].element[=].target[+].code = #034
* group[=].element[=].target[=].display = "Receiving long-term aspirin therapy"
* group[=].element[=].target[=].equivalence = #equivalent
