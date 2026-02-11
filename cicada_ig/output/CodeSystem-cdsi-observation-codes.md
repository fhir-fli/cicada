# CDSI Observation Codes - The Cicada Vaccine Forecasting Engine and Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **CDSI Observation Codes**

## CodeSystem: CDSI Observation Codes 

| | |
| :--- | :--- |
| *Official URL*:http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes | *Version*:0.1.0 |
| Draft as of 2026-02-11 | *Computable Name*:CdsiObservationCodes |

 
Observations and Conditions that are important to indications or contraindications in vaccine forecasting 

 This Code system is referenced in the content logical definition of the following value sets: 

* This CodeSystem is not used here; it may be used elsewhere (e.g. specifications and/or implementations that use this content)



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "cdsi-observation-codes",
  "url" : "http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes",
  "version" : "0.1.0",
  "name" : "CdsiObservationCodes",
  "title" : "CDSI Observation Codes",
  "status" : "draft",
  "date" : "2026-02-11T14:37:07-05:00",
  "publisher" : "FHIR-FLI",
  "contact" : [
    {
      "name" : "FHIR-FLI",
      "telecom" : [
        {
          "system" : "url",
          "value" : "http://fhirfli.dev"
        }
      ]
    }
  ],
  "description" : "Observations and Conditions that are important to indications or contraindications in vaccine forecasting",
  "content" : "complete",
  "count" : 251,
  "concept" : [
    {
      "code" : "001",
      "display" : "001",
      "definition" : "Patient seeks protection"
    },
    {
      "code" : "002",
      "display" : "002",
      "definition" : "Undergoing elective splenectomy"
    },
    {
      "code" : "003",
      "display" : "003",
      "definition" : "Immunocompromised"
    },
    {
      "code" : "004",
      "display" : "004",
      "definition" : "Recipient of a hematopoietic stem cell transplant"
    },
    {
      "code" : "005",
      "display" : "005",
      "definition" : "Hepatitis C virus infection"
    },
    {
      "code" : "006",
      "display" : "006",
      "definition" : "Receives clotting factor concentrates"
    },
    {
      "code" : "007",
      "display" : "007",
      "definition" : "Pregnant"
    },
    {
      "code" : "008",
      "display" : "008",
      "definition" : "Travel to an area of active cholera transmission"
    },
    {
      "code" : "009",
      "display" : "009",
      "definition" : "Breastfeeding"
    },
    {
      "code" : "010",
      "display" : "010",
      "definition" : "Cerebrospinal fluid leaks"
    },
    {
      "code" : "011",
      "display" : "011",
      "definition" : "Cochlear implants"
    },
    {
      "code" : "012",
      "display" : "012",
      "definition" : "Family history of altered immunocompetence"
    },
    {
      "code" : "013",
      "display" : "013",
      "definition" : "Severe Combined Immunodeficiency [SCID]"
    },
    {
      "code" : "014",
      "display" : "014",
      "definition" : "Diabetes"
    },
    {
      "code" : "015",
      "display" : "015",
      "definition" : "Chronic liver disease"
    },
    {
      "code" : "016",
      "display" : "016",
      "definition" : "Chronic heart disease"
    },
    {
      "code" : "017",
      "display" : "017",
      "definition" : "Chronic lung disease"
    },
    {
      "code" : "018",
      "display" : "018",
      "definition" : "Laboratory Evidence of Immunity or confirmation of Hepatitis A disease"
    },
    {
      "code" : "019",
      "display" : "019",
      "definition" : "Laboratory Evidence of Immunity or confirmation of Hepatitis B disease"
    },
    {
      "code" : "020",
      "display" : "020",
      "definition" : "Laboratory Evidence of Immunity for Measles"
    },
    {
      "code" : "021",
      "display" : "021",
      "definition" : "Laboratory Evidence of Immunity for Mumps"
    },
    {
      "code" : "022",
      "display" : "022",
      "definition" : "Laboratory Evidence of Immunity for Rubella"
    },
    {
      "code" : "023",
      "display" : "023",
      "definition" : "Laboratory Evidence of Immunity or confirmation of Varicella disease"
    },
    {
      "code" : "024",
      "display" : "024",
      "definition" : "Healthcare provider verified history of or diagnosis of Varicella"
    },
    {
      "code" : "025",
      "display" : "025",
      "definition" : "Healthcare provider verified history or diagnosis of Herpes Zoster"
    },
    {
      "code" : "026",
      "display" : "026",
      "definition" : "Persons with perinatal HIV infection who do not have evidence of severe immunosuppression and who were vaccinated with MMR before establishment of antiviral therapy [ART]"
    },
    {
      "code" : "027",
      "display" : "027",
      "definition" : "Asthma"
    },
    {
      "code" : "028",
      "display" : "028",
      "definition" : "Intussusception"
    },
    {
      "code" : "029",
      "display" : "029",
      "definition" : "Acute gastroenteritis"
    },
    {
      "code" : "030",
      "display" : "030",
      "definition" : "Acute febrile illness"
    },
    {
      "code" : "031",
      "display" : "031",
      "definition" : "Tuberculosis"
    },
    {
      "code" : "032",
      "display" : "032",
      "definition" : "Dialysis patient"
    },
    {
      "code" : "033",
      "display" : "033",
      "definition" : "Taken influenza antiviral medications within the previous 48 hours"
    },
    {
      "code" : "034",
      "display" : "034",
      "definition" : "Receiving long-term aspirin therapy"
    },
    {
      "code" : "035",
      "display" : "035",
      "definition" : "Antimicrobial or antimalarial taken within 72 hours"
    },
    {
      "code" : "036",
      "display" : "036",
      "definition" : "Men who have sex with men"
    },
    {
      "code" : "037",
      "display" : "037",
      "definition" : "Not in a long-term, mutually monogamous relationship"
    },
    {
      "code" : "038",
      "display" : "038",
      "definition" : "Sex partner of Hepatitis B surface antigen-positive persons"
    },
    {
      "code" : "039",
      "display" : "039",
      "definition" : "Receives treatment for STD"
    },
    {
      "code" : "040",
      "display" : "040",
      "definition" : "Illicit drug use"
    },
    {
      "code" : "041",
      "display" : "041",
      "definition" : "Illicit injection drug use"
    },
    {
      "code" : "042",
      "display" : "042",
      "definition" : "Smoke cigarettes"
    },
    {
      "code" : "043",
      "display" : "043",
      "definition" : "Alcoholism"
    },
    {
      "code" : "044",
      "display" : "044",
      "definition" : "Anticipate close personal contact with international adoptee"
    },
    {
      "code" : "045",
      "display" : "045",
      "definition" : "Travel to country with a Yellow Fever vaccination entry requirement"
    },
    {
      "code" : "046",
      "display" : "046",
      "definition" : "College students living in residence halls"
    },
    {
      "code" : "047",
      "display" : "047",
      "definition" : "Resident of area at risk for exposure to the disease"
    },
    {
      "code" : "048",
      "display" : "048",
      "definition" : "Travelling Internationally"
    },
    {
      "code" : "049",
      "display" : "049",
      "definition" : "Working with Hepatitis A virus in research setting"
    },
    {
      "code" : "050",
      "display" : "050",
      "definition" : "Microbiologists routinely exposed to Neisseria meningitidis"
    },
    {
      "code" : "051",
      "display" : "051",
      "definition" : "Microbiology laboratorians who work frequently with S. typhi"
    },
    {
      "code" : "052",
      "display" : "052",
      "definition" : "Laboratory personnel who might be exposed to YFV"
    },
    {
      "code" : "053",
      "display" : "053",
      "definition" : "Rabies researchers"
    },
    {
      "code" : "054",
      "display" : "054",
      "definition" : "Laboratory workers who handle specimens that might contain polioviruses"
    },
    {
      "code" : "055",
      "display" : "055",
      "definition" : "Health care personnel"
    },
    {
      "code" : "056",
      "display" : "056",
      "definition" : "Health-care workers who have close contact with patients who might be excreting wild polioviruses"
    },
    {
      "code" : "057",
      "display" : "057",
      "definition" : "Public safety worker exposed to blood or infection body fluids"
    },
    {
      "code" : "058",
      "display" : "058",
      "definition" : "Staff of institution for persons with developmental disabilities"
    },
    {
      "code" : "059",
      "display" : "059",
      "definition" : "Occupational exposure for Hepatitis A"
    },
    {
      "code" : "060",
      "display" : "060",
      "definition" : "Veterinarians and their staff"
    },
    {
      "code" : "061",
      "display" : "061",
      "definition" : "Animal handlers"
    },
    {
      "code" : "062",
      "display" : "062",
      "definition" : "Persons whose activities bring them into frequent contact with rabies virus or potentially rabid animals"
    },
    {
      "code" : "063",
      "display" : "063",
      "definition" : "Post secondary student"
    },
    {
      "code" : "064",
      "display" : "064",
      "definition" : "Military recruits"
    },
    {
      "code" : "065",
      "display" : "065",
      "definition" : "Client of institution for persons with developmental disabilities"
    },
    {
      "code" : "066",
      "display" : "066",
      "definition" : "Chronic renal failure"
    },
    {
      "code" : "068",
      "display" : "068",
      "definition" : "In drug abuse treatment and prevention facility"
    },
    {
      "code" : "069",
      "display" : "069",
      "definition" : "In correctional facility"
    },
    {
      "code" : "070",
      "display" : "070",
      "definition" : "Persons at risk during an outbreak"
    },
    {
      "code" : "071",
      "display" : "071",
      "definition" : "Household contact with hepatitis B surface antigen-positive persons"
    },
    {
      "code" : "072",
      "display" : "072",
      "definition" : "Intimate exposure to a documented S. typhi carrier"
    },
    {
      "code" : "073",
      "display" : "073",
      "definition" : "Household and close contacts of immunocompromised persons"
    },
    {
      "code" : "074",
      "display" : "074",
      "definition" : "Negative serological screening for varicella"
    },
    {
      "code" : "075",
      "display" : "075",
      "definition" : "Transgender person"
    },
    {
      "code" : "076",
      "display" : "076",
      "definition" : "Progressive neurologic disorder"
    },
    {
      "code" : "077",
      "display" : "077",
      "definition" : "Received inactivated or unknown measles vaccine between 1963-1967"
    },
    {
      "code" : "078",
      "display" : "078",
      "definition" : "Received killed or unknown Mumps vaccine before 1979"
    },
    {
      "code" : "079",
      "display" : "079",
      "definition" : "Encephalopathy not attributable to another identifiable cause within 7 days of administration of a previous dose of Tdap, DTP, or DTaP vaccine"
    },
    {
      "code" : "080",
      "display" : "080",
      "definition" : "Adverse reaction to vaccine component"
    },
    {
      "code" : "081",
      "display" : "081",
      "definition" : "Severe allergic reaction after previous dose of Polio"
    },
    {
      "code" : "082",
      "display" : "082",
      "definition" : "Severe allergic reaction after previous dose of Japanese Encephalitis"
    },
    {
      "code" : "083",
      "display" : "083",
      "definition" : "Severe allergic reaction after previous dose of Rotavirus"
    },
    {
      "code" : "084",
      "display" : "084",
      "definition" : "Severe allergic reaction after previous dose of Typhoid"
    },
    {
      "code" : "085",
      "display" : "085",
      "definition" : "Severe allergic reaction after previous dose of Influenza"
    },
    {
      "code" : "086",
      "display" : "086",
      "definition" : "Severe allergic reaction after previous dose of Pertussis"
    },
    {
      "code" : "087",
      "display" : "087",
      "definition" : "Severe allergic reaction after previous dose of Diphtheria"
    },
    {
      "code" : "088",
      "display" : "088",
      "definition" : "Severe allergic reaction after previous dose of Tetanus"
    },
    {
      "code" : "089",
      "display" : "089",
      "definition" : "Severe allergic reaction after previous dose of Varicella"
    },
    {
      "code" : "090",
      "display" : "090",
      "definition" : "Severe allergic reaction after previous dose of HPV"
    },
    {
      "code" : "091",
      "display" : "091",
      "definition" : "Severe allergic reaction after previous dose of Measles"
    },
    {
      "code" : "092",
      "display" : "092",
      "definition" : "Severe allergic reaction after previous dose of Mumps"
    },
    {
      "code" : "093",
      "display" : "093",
      "definition" : "Severe allergic reaction after previous dose of Rubella"
    },
    {
      "code" : "094",
      "display" : "094",
      "definition" : "Severe allergic reaction after previous dose of Pneumococcal"
    },
    {
      "code" : "095",
      "display" : "095",
      "definition" : "Severe allergic reaction after previous dose of Meningococcal"
    },
    {
      "code" : "096",
      "display" : "096",
      "definition" : "Severe allergic reaction after previous dose of Hepatitis A"
    },
    {
      "code" : "097",
      "display" : "097",
      "definition" : "Severe allergic reaction after previous dose of Hepatitis B"
    },
    {
      "code" : "098",
      "display" : "098",
      "definition" : "Severe allergic reaction after previous dose of Hib"
    },
    {
      "code" : "099",
      "display" : "099",
      "definition" : "Severe allergic reaction after previous dose of Yellow Fever"
    },
    {
      "code" : "100",
      "display" : "100",
      "definition" : "Severe allergic reaction after previous dose of live zoster"
    },
    {
      "code" : "101",
      "display" : "101",
      "definition" : "Allergic reaction to egg protein"
    },
    {
      "code" : "102",
      "display" : "102",
      "definition" : "Severe allergic reaction to gelatin"
    },
    {
      "code" : "103",
      "display" : "103",
      "definition" : "Severe allergic reaction to arginine"
    },
    {
      "code" : "104",
      "display" : "104",
      "definition" : "Allergic reaction to latex"
    },
    {
      "code" : "105",
      "display" : "105",
      "definition" : "Severe allergic reaction to chicken protein"
    },
    {
      "code" : "106",
      "display" : "106",
      "definition" : "Severe allergic reaction to gentamicin"
    },
    {
      "code" : "107",
      "display" : "107",
      "definition" : "Severe allergic reaction to neomycin"
    },
    {
      "code" : "108",
      "display" : "108",
      "definition" : "Severe allergic reaction to streptomycin"
    },
    {
      "code" : "109",
      "display" : "109",
      "definition" : "Severe allergic reaction to polymyxin B"
    },
    {
      "code" : "110",
      "display" : "110",
      "definition" : "Hypersensitivity to yeast"
    },
    {
      "code" : "111",
      "display" : "111",
      "definition" : "Hypersensitivity to the preservative 2-phenoxyethanol"
    },
    {
      "code" : "112",
      "display" : "112",
      "definition" : "Hypersensitivity to alum"
    },
    {
      "code" : "113",
      "display" : "113",
      "definition" : "Severe allergic reaction after previous dose of Rabies"
    },
    {
      "code" : "114",
      "display" : "114",
      "definition" : "End stage renal disease"
    },
    {
      "code" : "115",
      "display" : "115",
      "definition" : "Severe allergic reaction to protamine sulfate"
    },
    {
      "code" : "116",
      "display" : "116",
      "definition" : "Severe allergic reaction after previous dose of Meningococcal B"
    },
    {
      "code" : "117",
      "display" : "117",
      "definition" : "Severe allergic reaction to diphtheria toxoid"
    },
    {
      "code" : "118",
      "display" : "118",
      "definition" : "Severe allergic reaction to tetanus toxoid"
    },
    {
      "code" : "119",
      "display" : "119",
      "definition" : "Severe allergic reaction after previous dose of cholera"
    },
    {
      "code" : "120",
      "display" : "120",
      "definition" : "Begin Date of antiviral therapy [ART]"
    },
    {
      "code" : "121",
      "display" : "121",
      "definition" : "Homelessness"
    },
    {
      "code" : "122",
      "display" : "122",
      "definition" : "Severe allergic reaction after previous dose of COVID-19"
    },
    {
      "code" : "123",
      "display" : "123",
      "definition" : "Severe allergic reaction after previous dose of Ebola"
    },
    {
      "code" : "124",
      "display" : "124",
      "definition" : "Severe allergic reaction to rice protein "
    },
    {
      "code" : "125",
      "display" : "125",
      "definition" : "Tetanus IG administration"
    },
    {
      "code" : "126",
      "display" : "126",
      "definition" : "Hep A IG administration"
    },
    {
      "code" : "127",
      "display" : "127",
      "definition" : "Hep B IG administration"
    },
    {
      "code" : "128",
      "display" : "128",
      "definition" : "Rabies IG administration"
    },
    {
      "code" : "129",
      "display" : "129",
      "definition" : "Varicella IG administration"
    },
    {
      "code" : "130",
      "display" : "130",
      "definition" : "Measles prophylaxis IG administration - Standard"
    },
    {
      "code" : "131",
      "display" : "131",
      "definition" : "Measles prophylaxis IG administration - Immunocompromised Contact"
    },
    {
      "code" : "132",
      "display" : "132",
      "definition" : "RBC [adenine-saline added] blood transfusion"
    },
    {
      "code" : "133",
      "display" : "133",
      "definition" : "Packed RBC blood transfusion"
    },
    {
      "code" : "134",
      "display" : "134",
      "definition" : "Whole blood transfusion"
    },
    {
      "code" : "135",
      "display" : "135",
      "definition" : "Plasma/platelet products blood transfusion"
    },
    {
      "code" : "136",
      "display" : "136",
      "definition" : "Cytomegalovirus IGIV"
    },
    {
      "code" : "137",
      "display" : "137",
      "definition" : "IGIV - Replacement therapy for immune deficiencies"
    },
    {
      "code" : "138",
      "display" : "138",
      "definition" : "IGIV - Immune thrombocytopenic purpura treatment"
    },
    {
      "code" : "139",
      "display" : "139",
      "definition" : "IGIV - Postexposure varicella prophylaxis"
    },
    {
      "code" : "140",
      "display" : "140",
      "definition" : "IGIV - Immune thrombocytopenic purpura treatment"
    },
    {
      "code" : "141",
      "display" : "141",
      "definition" : "IGIV - Kawasaki disease"
    },
    {
      "code" : "142",
      "display" : "142",
      "definition" : "Travel to or working in countries that have high or intermediate endemicity of Hepatitis A"
    },
    {
      "code" : "143",
      "display" : "143",
      "definition" : "Travel to areas or countries where polio is epidemic or endemic"
    },
    {
      "code" : "144",
      "display" : "144",
      "definition" : "International travel with possible contact with animals in areas where rabies is enzootic and immediate access to appropriate medical care might be limited"
    },
    {
      "code" : "145",
      "display" : "145",
      "definition" : "B-lymphocyte [humoral] - Severe antibody deficiencies"
    },
    {
      "code" : "146",
      "display" : "146",
      "definition" : "B-lymphocyte [humoral] - Less severe antibody deficiencies"
    },
    {
      "code" : "147",
      "display" : "147",
      "definition" : "T-lymphocyte [cell-mediated and humoral] - Complete defects"
    },
    {
      "code" : "148",
      "display" : "148",
      "definition" : "T-lymphocyte [cell-mediated and humoral] - Partial defects"
    },
    {
      "code" : "149",
      "display" : "149",
      "definition" : "T-lymphocyte [cell-mediated and humoral] - interferon-gamma/Interleukin 12 axis deficiencies"
    },
    {
      "code" : "150",
      "display" : "150",
      "definition" : "T-lymphocyte [cell-mediated and humoral] - interferon-gamma or interferon-alpha"
    },
    {
      "code" : "151",
      "display" : "151",
      "definition" : "Persistent complement, properdin, or factor B deficiency"
    },
    {
      "code" : "152",
      "display" : "152",
      "definition" : "Phagocytic function - Chronic granulomatous disease"
    },
    {
      "code" : "153",
      "display" : "153",
      "definition" : "Phagocytic function - Leukocyte adhesion defect, and myeloperoxidase deficiency"
    },
    {
      "code" : "154",
      "display" : "154",
      "definition" : "HIV/AIDS - severely immunocompromised"
    },
    {
      "code" : "155",
      "display" : "155",
      "definition" : "HIV/AIDS - not severely immunocompromised"
    },
    {
      "code" : "156",
      "display" : "156",
      "definition" : "Generalized malignant neoplasm"
    },
    {
      "code" : "157",
      "display" : "157",
      "definition" : "Transplantation"
    },
    {
      "code" : "158",
      "display" : "158",
      "definition" : "Immunosuppressive therapy"
    },
    {
      "code" : "159",
      "display" : "159",
      "definition" : "Radiation therapy"
    },
    {
      "code" : "160",
      "display" : "160",
      "definition" : "Anatomical or functional asplenia"
    },
    {
      "code" : "161",
      "display" : "161",
      "definition" : "Chronic kidney disease"
    },
    {
      "code" : "162",
      "display" : "162",
      "definition" : "Travel to areas at risk for Yellow Fever transmission"
    },
    {
      "code" : "163",
      "display" : "163",
      "definition" : "Travel to areas in which there is a recognized risk of exposure to S. typhi"
    },
    {
      "code" : "164",
      "display" : "164",
      "definition" : "Travel to or are residents of countries in which meningococcal disease is hyperendemic or epidemic"
    },
    {
      "code" : "165",
      "display" : "165",
      "definition" : "Longer-term (e.g., 1 month or more) travel to a JE-endemic area"
    },
    {
      "code" : "166",
      "display" : "166",
      "definition" : "Travel to countries with high or intermediate prevalence of chronic HBV infection"
    },
    {
      "code" : "167",
      "display" : "167",
      "definition" : "Nephrotic Syndrome"
    },
    {
      "code" : "168",
      "display" : "168",
      "definition" : "Chemotherapy"
    },
    {
      "code" : "169",
      "display" : "169",
      "definition" : "History of sexual abuse or assault"
    },
    {
      "code" : "170",
      "display" : "170",
      "definition" : "Onset of pregnancy"
    },
    {
      "code" : "171",
      "display" : "171",
      "definition" : "Date of hematopoietic stem cell transplant"
    },
    {
      "code" : "172",
      "display" : "172",
      "definition" : "Severe allergic reaction after previous dose of recombinant zoster"
    },
    {
      "code" : "173",
      "display" : "173",
      "definition" : "Moving to JE-endemic country to take up residence"
    },
    {
      "code" : "174",
      "display" : "174",
      "definition" : "Frequent travel to JE-endemic areas"
    },
    {
      "code" : "175",
      "display" : "175",
      "definition" : "Patient seeks Hepatitis A protection"
    },
    {
      "code" : "176",
      "display" : "176",
      "definition" : "Patient seeks Hepatitis B protection"
    },
    {
      "code" : "177",
      "display" : "177",
      "definition" : "Patient seeks Meningococcal B protection"
    },
    {
      "code" : "178",
      "display" : "178",
      "definition" : "Leukemia"
    },
    {
      "code" : "179",
      "display" : "179",
      "definition" : "Lymphoma"
    },
    {
      "code" : "180",
      "display" : "180",
      "definition" : "Hodgkin's disease"
    },
    {
      "code" : "181",
      "display" : "181",
      "definition" : "Multiple myeloma"
    },
    {
      "code" : "182",
      "display" : "182",
      "definition" : "Ebola virus outbreak response"
    },
    {
      "code" : "183",
      "display" : "183",
      "definition" : "Health care personnel at federally designated Ebola treatment center in U.S."
    },
    {
      "code" : "184",
      "display" : "184",
      "definition" : "Laboratorians or other staff at biosafety level 4 facilities in U.S."
    },
    {
      "code" : "185",
      "display" : "185",
      "definition" : "Persons in settings that provide services to adults with high proportion of those persons have risk factors for HAV infection"
    },
    {
      "code" : "186",
      "display" : "186",
      "definition" : "HIV Infection"
    },
    {
      "code" : "187",
      "display" : "187",
      "definition" : "Allergic reaction to polysorbate 80"
    },
    {
      "code" : "188",
      "display" : "188",
      "definition" : "Known allergy to Polyethylene glycol [PEG]"
    },
    {
      "code" : "189",
      "display" : "189",
      "definition" : "Active treatment for solid tumors"
    },
    {
      "code" : "190",
      "display" : "190",
      "definition" : "Active treatment for hematologic malignancies"
    },
    {
      "code" : "191",
      "display" : "191",
      "definition" : "Receipt of CAR-T-cell therapy"
    },
    {
      "code" : "192",
      "display" : "192",
      "definition" : "Severe allergic reaction after previous dose of any egg-based IIV or LAIV influenza vaccine"
    },
    {
      "code" : "193",
      "display" : "193",
      "definition" : "Severe allergic reaction after previous dose of any ccIIV influenza vaccine"
    },
    {
      "code" : "194",
      "display" : "194",
      "definition" : "Severe allergic reaction after previous dose of any RIV influenza vaccine"
    },
    {
      "code" : "195",
      "display" : "195",
      "definition" : "Occupations at increased risk for COVID-19 exposure and transmission"
    },
    {
      "code" : "196",
      "display" : "196",
      "definition" : "Residing in an institutional setting at increased risk for COVID-19 exposure and transmission"
    },
    {
      "code" : "197",
      "display" : "197",
      "definition" : "Resident of a long term care facility"
    },
    {
      "code" : "198",
      "display" : "198",
      "definition" : "Cancer"
    },
    {
      "code" : "199",
      "display" : "199",
      "definition" : "Interstitial lung disease"
    },
    {
      "code" : "200",
      "display" : "200",
      "definition" : "Cystic fibrosis"
    },
    {
      "code" : "201",
      "display" : "201",
      "definition" : "Pulmonary hypertension"
    },
    {
      "code" : "202",
      "display" : "202",
      "definition" : "Dementia"
    },
    {
      "code" : "203",
      "display" : "203",
      "definition" : "Down syndrome"
    },
    {
      "code" : "204",
      "display" : "204",
      "definition" : "Obesity"
    },
    {
      "code" : "205",
      "display" : "205",
      "definition" : "Thalassemia"
    },
    {
      "code" : "206",
      "display" : "206",
      "definition" : "Cerebrovascular disease"
    },
    {
      "code" : "207",
      "display" : "207",
      "definition" : "Substance use disorder"
    },
    {
      "code" : "208",
      "display" : "208",
      "definition" : "Mental Health conditions"
    },
    {
      "code" : "209",
      "display" : "209",
      "definition" : "History of thrombosis with thrombocytopenia following the Janssen COVID-19 Vaccine or any other adenovirus-vectored COVID-19 vaccines"
    },
    {
      "code" : "210",
      "display" : "210",
      "definition" : "Severe allergic reaction after previous dose of Dengue vaccine"
    },
    {
      "code" : "211",
      "display" : "211",
      "definition" : "Evidence of previous dengue infection and living in areas where dengue is endemic"
    },
    {
      "code" : "212",
      "display" : "212",
      "definition" : "Health care personnel involved in the care and transport of patients with suspected or confirmed Ebola virus disease at Special Pathogen Treatment Centers"
    },
    {
      "code" : "213",
      "display" : "213",
      "definition" : "Laboratorians and support staff members at Laboratory Response Network (LRN) facilities that handle specimens that might contain replication-competent Ebola virus in the United States"
    },
    {
      "code" : "214",
      "display" : "214",
      "definition" : "Chronic obstructive pulmonary disease"
    },
    {
      "code" : "215",
      "display" : "215",
      "definition" : "Emphysema"
    },
    {
      "code" : "216",
      "display" : "216",
      "definition" : "Iatrogenic Immunosuppression"
    },
    {
      "code" : "217",
      "display" : "217",
      "definition" : "Persons working in rabies vaccine production facilities"
    },
    {
      "code" : "218",
      "display" : "218",
      "definition" : "Persons performing testing for rabies in diagnostic laboratories"
    },
    {
      "code" : "219",
      "display" : "219",
      "definition" : "Persons who frequently handle bats"
    },
    {
      "code" : "220",
      "display" : "220",
      "definition" : "Persons who frequently have contact with bats"
    },
    {
      "code" : "221",
      "display" : "221",
      "definition" : "Persons who frequently enter high-density bat environments"
    },
    {
      "code" : "222",
      "display" : "222",
      "definition" : "Persons who frequently perform animal necropsies"
    },
    {
      "code" : "223",
      "display" : "223",
      "definition" : "Severe allergic reaction after previous dose of orthopoxvirus vaccine"
    },
    {
      "code" : "224",
      "display" : "224",
      "definition" : "History or presence of atopic dermatitis"
    },
    {
      "code" : "225",
      "display" : "225",
      "definition" : "Household contact with history or presence of atopic dermatitis"
    },
    {
      "code" : "226",
      "display" : "226",
      "definition" : "Active exfoliative skin conditions"
    },
    {
      "code" : "227",
      "display" : "227",
      "definition" : "Household contact with active exfoliative skin conditions"
    },
    {
      "code" : "228",
      "display" : "228",
      "definition" : "Household contact is pregnant"
    },
    {
      "code" : "229",
      "display" : "229",
      "definition" : "Age is less than 1 year"
    },
    {
      "code" : "230",
      "display" : "230",
      "definition" : "Household contact who is less than 1 year of age"
    },
    {
      "code" : "231",
      "display" : "231",
      "definition" : "3 or more known major cardiac risk factors"
    },
    {
      "code" : "232",
      "display" : "232",
      "definition" : "Research laboratory personnel working with more virulent orthopoxviruses (e.g., Variola virus or mpox virus)"
    },
    {
      "code" : "233",
      "display" : "233",
      "definition" : "Clinical laboratory personnel performing diagnostic testing for more virulent orthopoxviruses (e.g., Variola virus or mpox virus)"
    },
    {
      "code" : "234",
      "display" : "234",
      "definition" : "Designated response team members working with more virulent orthopoxviruses (e.g., Variola virus or mpox virus)"
    },
    {
      "code" : "235",
      "display" : "235",
      "definition" : "Healthcare personnel who care for patients infected with more virulent orthopoxviruses (e.g., Variola virus or mpox virus)"
    },
    {
      "code" : "236",
      "display" : "236",
      "definition" : "Research laboratory personnel working with less virulent orthopoxviruses (e.g., Vaccinia virus or Cowpox virus)"
    },
    {
      "code" : "237",
      "display" : "237",
      "definition" : "Clinical laboratory personnel performing diagnostic testing for less virulent orthopoxviruses (e.g., Vaccinia virus or Cowpox virus)"
    },
    {
      "code" : "238",
      "display" : "238",
      "definition" : "Designated response team members working with less virulent orthopoxviruses (e.g., Vaccinia virus or Cowpox virus)"
    },
    {
      "code" : "239",
      "display" : "239",
      "definition" : "Healthcare personnel who administer ACAM2000"
    },
    {
      "code" : "240",
      "display" : "240",
      "definition" : "Healthcare personnel who care for patients infected with less virulent orthopoxviruses (e.g., Vaccinia virus or Cowpox virus)"
    },
    {
      "code" : "241",
      "display" : "241",
      "definition" : "Known exposure to mpox"
    },
    {
      "code" : "242",
      "display" : "242",
      "definition" : "Presumed exposure to mpox"
    },
    {
      "code" : "243",
      "display" : "243",
      "definition" : "Lack of laboratory confirmation of a previous Dengue infection"
    },
    {
      "code" : "244",
      "display" : "244",
      "definition" : "Severe allergic reaction after previous dose of RSV vaccine"
    },
    {
      "code" : "245",
      "display" : "245",
      "definition" : "American Indian or Alaskan Native"
    },
    {
      "code" : "246",
      "display" : "246",
      "definition" : "Severe immunocompromise"
    },
    {
      "code" : "247",
      "display" : "247",
      "definition" : "Gay, bisexual, and other men who have sex with men, transgender or nonbinary peope who in the past 6 months have had one of the following:  1) A new diagnosis of ≥ 1 sexually transmitted disease 2)  More than one sex partner 3)  Sex at a commercial sex venue 4)   Sex in association with a large public event in a geographic area where mpox transmission is occurring"
    },
    {
      "code" : "248",
      "display" : "248",
      "definition" : "Sexual partners of gay, bisexual, and other men who have sex with men, transgender or nonbinary peope who in the past 6 months have had one of the following:  1) A new diagnosis of ≥ 1 sexually transmitted disease 2)  More than one sex partner 3)  Sex at a commercial sex venue 4)   Sex in association with a large public event in a geographic area where mpox transmission is occurring"
    },
    {
      "code" : "249",
      "display" : "249",
      "definition" : "Moving or traveling to an area where TBE is endemic and will have extensive exposure to ticks because of their planned outdoor activities and itinerary"
    },
    {
      "code" : "250",
      "display" : "250",
      "definition" : "Moving or traveling to an area where TBE is endemic who might engage in outdoor activities in areas where ticks are likely to be found"
    },
    {
      "code" : "251",
      "display" : "251",
      "definition" : "Laboratory workers with a potential for exposure to TBE virus"
    },
    {
      "code" : "252",
      "display" : "252",
      "definition" : "Severe allergic reaction after previous dose of Tick-borne Encephalitis vaccine"
    }
  ]
}

```
