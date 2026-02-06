// ignore_for_file: prefer_single_quotes, always_specify_types

import '../cicada.dart';

final AntigenSupportingData varicella = AntigenSupportingData.fromJson({
  "targetDisease": "Varicella",
  "vaccineGroup": "Varicella",
  "immunity": {
    "clinicalHistory": [
      {
        "guidelineCode": "023",
        "guidelineTitle":
            "Laboratory Evidence of Immunity or confirmation of Varicella disease"
      },
      {
        "guidelineCode": "024",
        "guidelineTitle":
            "Healthcare provider verified history of or diagnosis of Varicella"
      },
      {
        "guidelineCode": "025",
        "guidelineTitle":
            "Healthcare provider verified history or diagnosis of Herpes Zoster"
      }
    ],
    "dateOfBirth": {
      "immunityBirthDate": "01/01/1980",
      "birthCountry": "U.S.",
      "exclusion": [
        {"exclusionCode": "055", "exclusionTitle": "Health care personnel"},
        {"exclusionCode": "007", "exclusionTitle": "Pregnant"},
        {"exclusionCode": "003", "exclusionTitle": "Immunocompromised"}
      ]
    }
  },
  "contraindications": {
    "vaccineGroup": {
      "contraindication": [
        {
          "observationCode": "007",
          "observationTitle": "Pregnant",
          "contraindicationText": "Do not vaccinate if the patient is pregnant."
        },
        {
          "observationCode": "012",
          "observationTitle": "Family history of altered immunocompetence",
          "contraindicationText":
              "Do not vaccinate if the patient has a family history of altered immunocompetence"
        },
        {
          "observationCode": "031",
          "observationTitle": "Tuberculosis",
          "contraindicationText":
              "Do not vaccinate if the patient has active untreated tuberculosis."
        },
        {
          "observationCode": "080",
          "observationTitle": "Adverse reaction to vaccine component",
          "contraindicationText":
              "Do not vaccinate if the patient has had an adverse reaction to a vaccine component."
        },
        {
          "observationCode": "089",
          "observationTitle":
              "Severe allergic reaction after previous dose of Varicella",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Varicella vaccine."
        },
        {
          "observationCode": "102",
          "observationTitle": "Severe allergic reaction to gelatin",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction to gelatin."
        },
        {
          "observationCode": "107",
          "observationTitle": "Severe allergic reaction to neomycin",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction to neomycin."
        },
        {
          "observationCode": "125",
          "observationTitle": "Tetanus IG administration",
          "contraindicationText":
              "Do not vaccinate if the patient has had Tetanus IG administered in the previous 3 months."
        },
        {
          "observationCode": "126",
          "observationTitle": "Hep A IG administration",
          "contraindicationText":
              "Do not vaccinate if the patient has had Hepatitis A IG administered in the previous 6 months."
        },
        {
          "observationCode": "127",
          "observationTitle": "Hep B IG administration",
          "contraindicationText":
              "Do not vaccinate if the patient has had Hepatitis B IG administered in the previous 3 months."
        },
        {
          "observationCode": "128",
          "observationTitle": "Rabies IG administration",
          "contraindicationText":
              "Do not vaccinate if the patient has had Rabies IG administered in the previous 4 months."
        },
        {
          "observationCode": "129",
          "observationTitle": "Varicella IG administration",
          "contraindicationText":
              "Do not vaccinate if the patient has had Varicella IG administered in the previous 5 months."
        },
        {
          "observationCode": "130",
          "observationTitle":
              "Measles prophylaxis IG administration - Standard",
          "contraindicationText":
              "Do not vaccinate if the patient has had Measles IG at a standard dose (0.25 mL/kg) administered in the previous 5 months."
        },
        {
          "observationCode": "131",
          "observationTitle":
              "Measles prophylaxis IG administration - Immunocompromised Contact",
          "contraindicationText":
              "Do not vaccinate if the patient has had Measles IG at an immunocompromised dose (0.5 mL/kg) administered in the previous 6 months."
        },
        {
          "observationCode": "132",
          "observationTitle": "RBC [adenine-saline added] blood transfusion",
          "contraindicationText":
              "Do not vaccinate if the patient has received a blood transfusion of adenine-saline added RBCs in the previous 3 months."
        },
        {
          "observationCode": "133",
          "observationTitle": "Packed RBC blood transfusion",
          "contraindicationText":
              "Do not vaccinate if the patient has received a blood transfusion of packed RBCs in the previous 6 months."
        },
        {
          "observationCode": "134",
          "observationTitle": "Whole blood transfusion",
          "contraindicationText":
              "Do not vaccinate if the patient has received a whole blood transfusion in the previous 6 months."
        },
        {
          "observationCode": "135",
          "observationTitle": "Plasma/platelet products blood transfusion",
          "contraindicationText":
              "Do not vaccinate if the patient has received a blood transfusion of plasma or platelet product in the previous 7 months."
        },
        {
          "observationCode": "136",
          "observationTitle": "Cytomegalovirus IGIV",
          "contraindicationText":
              "Do not vaccinate if the patient has received Cytomegalovirus IGIV in the previous 6 months."
        },
        {
          "observationCode": "137",
          "observationTitle":
              "IGIV - Replacement therapy for immune deficiencies",
          "contraindicationText":
              "Do not vaccinate if the patient has received IGIV (Replacement therapy for immune deficiencies) in the previous 8 months."
        },
        {
          "observationCode": "138",
          "observationTitle":
              "IGIV - Immune thrombocytopenic purpura treatment",
          "contraindicationText":
              "Do not vaccinate if the patient has received IGIV (Immune thrombocytopenic purpura treatment (400 mg/kg IV)) in the previous 8 months."
        },
        {
          "observationCode": "139",
          "observationTitle": "IGIV - Postexposure varicella prophylaxis",
          "contraindicationText":
              "Do not vaccinate if the patient has received IGIV (Postexposure varicella prophylaxis) in the previous 8 months."
        },
        {
          "observationCode": "140",
          "observationTitle":
              "IGIV - Immune thrombocytopenic purpura treatment",
          "contraindicationText":
              "Do not vaccinate if the patient has received IGIV (Immune thrombocytopenic purpura treatment (1000 mg/kg IV)) in the previous 10 months."
        },
        {
          "observationCode": "141",
          "observationTitle": "IGIV - Kawasaki disease",
          "contraindicationText":
              "Do not vaccinate if the patient has received IGIV (Kawasaki disease) in the previous 11 months."
        },
        {
          "observationCode": "147",
          "observationTitle":
              "T-lymphocyte [cell-mediated and humoral] - Complete defects",
          "contraindicationText":
              "Do not vaccinate if the patient has complete cell-mediated or humoral T-lymphocyte defects (e.g., severe combined immunodeficiency [SCID] disease, complete DiGeorge syndrome)."
        },
        {
          "observationCode": "148",
          "observationTitle":
              "T-lymphocyte [cell-mediated and humoral] - Partial defects",
          "contraindicationText":
              "Do not vaccinate if the patient has partial cell-mediated or humoral T-lymphocyte defects (e.g., most patients with DiGeorge syndrome, Wiskott-Aldrich syndrome, ataxia- telangiectasia)."
        },
        {
          "observationCode": "150",
          "observationTitle":
              "T-lymphocyte [cell-mediated and humoral] - interferon-gamma or interferon-alpha",
          "contraindicationText":
              "Do not vaccinate if the patient has cell-mediated or humoral T-lymphocyte defects related to interferon-gamma or interferon-alpha."
        },
        {
          "observationCode": "153",
          "observationTitle":
              "Phagocytic function - Leukocyte adhesion defect, and myeloperoxidase deficiency",
          "contraindicationText":
              "Do not vaccinate if the patient has a phagocytic function defect (e.g. leukocyte adhesion defect and myeloperoxidase deficiency)."
        },
        {
          "observationCode": "154",
          "observationTitle": "HIV/AIDS - severely immunocompromised",
          "contraindicationText":
              "Do not vaccinate if the patient has HIV/AIDS and is severely immunocompromised (See the CDC general recommendations for a definition of \"severely immunocompromised\")."
        },
        {
          "observationCode": "156",
          "observationTitle": "Generalized malignant neoplasm",
          "contraindicationText":
              "Do not vaccinate if the patient has generalized malignant neoplasm."
        },
        {
          "observationCode": "157",
          "observationTitle": "Solid organ transplantation",
          "contraindicationText":
              "Do not vaccinate if the patient received a solid organ transplant.",
          "contraindicationGuidance":
              "Certain immunosuppressive medications are administered to prevent solid organ transplant rejection. Live vaccines should be withheld for 2 months following discontinuation of anti-rejection therapies in patients with a solid organ transplant."
        },
        {
          "observationCode": "158",
          "observationTitle": "Immunosuppressive therapy",
          "contraindicationText":
              "Do not vaccinate if the patient is undergoing immunosuppressive therapy. Immunosuppressive medications include those given to prevent solid organ transplant rejection, human immune mediators like interleukins and colony-stimulating factors, immune modulators like levamisol and BCG bladder-tumor therapy, and medicines like tumor necrosis factor alpha inhibitors and anti-B cell antibodies."
        },
        {
          "observationCode": "159",
          "observationTitle": "Radiation therapy",
          "contraindicationText":
              "Do not vaccinate if the patient is undergoing radiation therapy."
        },
        {
          "observationCode": "168",
          "observationTitle": "Chemotherapy",
          "contraindicationText":
              "Do not vaccinate if the patient is undergoing chemotherapy, including 14 days before the start of therapy and 3 months after the completion of therapy."
        },
        {
          "observationCode": "246",
          "observationTitle": "Severe immunocompromise",
          "contraindicationText":
              "Do not vaccinate persons with severe immunocompromise."
        }
      ]
    },
    "vaccine": {
      "contraindication": [
        {
          "observationCode": "091",
          "observationTitle":
              "Severe allergic reaction after previous dose of Measles",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Measles vaccine.",
          "contraindicatedVaccine": [
            {"vaccineType": "MMRV", "cvx": "94"}
          ]
        },
        {
          "observationCode": "092",
          "observationTitle":
              "Severe allergic reaction after previous dose of Mumps",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Mumps vaccine.",
          "contraindicatedVaccine": [
            {"vaccineType": "MMRV", "cvx": "94"}
          ]
        },
        {
          "observationCode": "093",
          "observationTitle":
              "Severe allergic reaction after previous dose of Rubella",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Rubella vaccine.",
          "contraindicatedVaccine": [
            {"vaccineType": "MMRV", "cvx": "94"}
          ]
        },
        {
          "observationCode": "155",
          "observationTitle": "HIV/AIDS - not severely immunocompromised",
          "contraindicationText":
              "Do not vaccinate if the patient has HIV/AIDS but are not severely immunocompromised (See the CDC general recommendations for a definition of \"severely immunocompromised\").",
          "contraindicatedVaccine": [
            {"vaccineType": "MMRV", "cvx": "94"}
          ]
        },
        {
          "observationCode": "186",
          "observationTitle": "HIV Infection",
          "contraindicationText":
              "Do not vaccinate with MMRV if the patient has an HIV infection of any severity.",
          "contraindicatedVaccine": [
            {"vaccineType": "MMRV", "cvx": "94"}
          ]
        }
      ]
    }
  },
  "series": [
    {
      "seriesName": "Varicella childhood 2-dose series",
      "targetDisease": "Varicella",
      "vaccineGroup": "Varicella",
      "seriesAdminGuidance": [
        "HIV-infected people eligible for vaccination should get 2 doses of single-antigen varicella vaccine separated by 3 months. HIV-infected people should not get the combination MMRV vaccine."
      ],
      "seriesType": "Standard",
      "selectSeries": {
        "defaultSeries": "Yes",
        "productPath": "No",
        "seriesGroupName": "Standard",
        "seriesGroup": "1",
        "seriesPriority": "A",
        "seriesPreference": "1",
        "maxAgeToStart": "13 years"
      },
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "12 months - 4 days",
              "minAge": "12 months",
              "earliestRecAge": "12 months",
              "latestRecAge": "16 months + 4 weeks"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months",
              "volume": "0.5",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "MMRV",
              "cvx": "94",
              "beginAge": "4 years",
              "endAge": "13 years",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "MMRV",
              "cvx": "94",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Zoster Live",
              "cvx": "121",
              "beginAge": "12 months - 4 days",
              "endAge": "50 years"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 2",
          "age": [
            {
              "absMinAge": "13 months",
              "minAge": "15 months",
              "earliestRecAge": "4 years",
              "latestRecAge": "7 years + 4 weeks"
            }
          ],
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "12 weeks - 4 days",
              "minInt": "12 weeks",
              "earliestRecInt": "3 years",
              "latestRecInt": "6 years + 4 weeks"
            }
          ],
          "allowableInterval": {"fromPrevious": "Y", "absMinInt": "4 weeks"},
          "preferableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months",
              "volume": "0.5",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "MMRV",
              "cvx": "94",
              "beginAge": "4 years",
              "endAge": "13 years",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "MMRV",
              "cvx": "94",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Zoster Live",
              "cvx": "121",
              "beginAge": "12 months - 4 days",
              "endAge": "50 years"
            }
          ],
          "recurringDose": "No"
        }
      ]
    },
    {
      "seriesName": "Varicella 13+ 2-dose series",
      "targetDisease": "Varicella",
      "vaccineGroup": "Varicella",
      "seriesAdminGuidance": [
        "Vaccination should be emphasized for those who have close contact with persons at high risk for severe disease or are at high risk for exposure or transmission. Pregnant women should be assessed for evidence of varicella immunity. Women who do not have evidence of immunity should receive the first dose of varicella vaccine upon completion or termination of pregnancy and before discharge from the health care facility.",
        "HIV-infected people eligible for vaccination should get 2 doses of single-antigen varicella vaccine separated by 3 months. HIV-infected people should not get the combination MMRV vaccine."
      ],
      "seriesType": "Standard",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Standard",
        "seriesGroup": "1",
        "seriesPriority": "A",
        "seriesPreference": "2"
      },
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "13 years",
              "minAge": "13 years",
              "earliestRecAge": "13 years",
              "latestRecAge": "13 years"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "MMRV",
              "cvx": "94",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Zoster Live",
              "cvx": "121",
              "beginAge": "12 months - 4 days",
              "endAge": "50 years"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 2",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "4 weeks - 4 days",
              "minInt": "4 weeks",
              "earliestRecInt": "4 weeks",
              "latestRecInt": "8 weeks"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Varicella",
              "cvx": "21",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "MMRV",
              "cvx": "94",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Zoster Live",
              "cvx": "121",
              "beginAge": "12 months - 4 days",
              "endAge": "50 years"
            }
          ],
          "recurringDose": "No"
        }
      ]
    }
  ]
});
