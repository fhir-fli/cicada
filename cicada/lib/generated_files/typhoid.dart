// ignore_for_file: prefer_single_quotes, always_specify_types

import '../cicada.dart';

final AntigenSupportingData typhoid = AntigenSupportingData.fromJson(
{
    "targetDisease": "Typhoid",
    "vaccineGroup": "Typhoid",
    "contraindications": {
        "vaccineGroup": {
            "contraindication": [
                {
                    "observationCode": "029",
                    "observationTitle": "Acute gastroenteritis",
                    "contraindicationText": "Do not vaccinate if the patient has acute gastroenteritis."
                },
                {
                    "observationCode": "030",
                    "observationTitle": "Acute febrile illness",
                    "contraindicationText": "Do not vaccinate if the patient has acute febrile illness."
                },
                {
                    "observationCode": "080",
                    "observationTitle": "Adverse reaction to vaccine component",
                    "contraindicationText": "Do not vaccinate if the patient has had an adverse reaction to a vaccine component."
                },
                {
                    "observationCode": "084",
                    "observationTitle": "Severe allergic reaction after previous dose of Typhoid",
                    "contraindicationText": "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Typhoid vaccine."
                }
            ]
        },
        "vaccine": {
            "contraindication": [
                {
                    "observationCode": "035",
                    "observationTitle": "Antimicrobial or antimalarial taken within 72 hours",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has taken antimicrobial or antimalarial medications  within the previous 72 hours.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "145",
                    "observationTitle": "B-lymphocyte [humoral] - Severe antibody deficiencies",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has severe B-lymphocyte (humoral) - antibody deficiencies (e.g., X-linked agammaglobulinemia and common variable immunodeficiency).",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "147",
                    "observationTitle": "T-lymphocyte [cell-mediated and humoral] - Complete defects",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has complete cell-mediated or humoral T-lymphocyte defects (e.g., severe combined immunodeficiency [SCID] disease, complete DiGeorge syndrome).",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "148",
                    "observationTitle": "T-lymphocyte [cell-mediated and humoral] - Partial defects",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has partial cell-mediated or humoral T-lymphocyte defects (e.g., most patients with DiGeorge syndrome, Wiskott-Aldrich syndrome, ataxia- telangiectasia).",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "149",
                    "observationTitle": "T-lymphocyte [cell-mediated and humoral] - interferon-gamma/Interleukin 12 axis deficiencies",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has T-lymphocyte [cell-mediated and humoral] - interferon-gamma/Interleukin 12 axis deficiencies.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "150",
                    "observationTitle": "T-lymphocyte [cell-mediated and humoral] - interferon-gamma or interferon-alpha",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has cell-mediated or humoral T-lymphocyte defects related to interferon-gamma or interferon-alpha",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "152",
                    "observationTitle": "Phagocytic function - Chronic granulomatous disease",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has phagocytic function - chronic granulomatous disease.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "153",
                    "observationTitle": "Phagocytic function - Leukocyte adhesion defect, and myeloperoxidase deficiency",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has a phagocytic function defect (e.g. leukocyte adhesion defect and myeloperoxidase deficiency).",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "154",
                    "observationTitle": "HIV/AIDS - severely immunocompromised",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has HIV/AIDS and is severely immunocompromised (See the CDC general recommendations for a definition of \"severely immunocompromised\").",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "156",
                    "observationTitle": "Generalized malignant neoplasm",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient has generalized malignant neoplasm.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "157",
                    "observationTitle": "Solid organ transplantation",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient received a solid organ transplant.",
                    "contraindicationGuidance": "Certain immunosuppressive medications are administered to prevent solid organ transplant rejection. Live vaccines should be withheld for 2 months following discontinuation of anti-rejection therapies in patients with a solid organ transplant.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "158",
                    "observationTitle": "Immunosuppressive therapy",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient is undergoing immunosuppressive therapy. Immunosuppressive medications include those given to prevent solid organ transplant rejection, human immune mediators like interleukins and colony-stimulating factors, immune modulators like levamisol and BCG bladder-tumor therapy, and medicines like tumor necrosis factor alpha inhibitors and anti-B cell antibodies.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                },
                {
                    "observationCode": "159",
                    "observationTitle": "Radiation therapy",
                    "contraindicationText": "Do not vaccinate with live attenuated typhoid virus (Ty21a) if the patient is undergoing radiation therapy.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25"
                        }
                    ]
                }
            ]
        }
    },
    "series": [
        {
            "seriesName": "Typhoid risk 1-dose series",
            "targetDisease": "Typhoid",
            "vaccineGroup": "Typhoid",
            "seriesAdminGuidance": [
                "This vaccine should be given at least 2 weeks before potential exposure."
            ],
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "Yes",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "minAgeToStart": "2 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Microbiology laboratorians who work frequently with S. typhi",
                        "code": "051"
                    },
                    "description": "Administer to persons who are microbiology laboratorians who work frequently with S. typhi.",
                    "beginAge": "18 years"
                },
                {
                    "observationCode": {
                        "text": "Intimate exposure to a documented S. typhi carrier",
                        "code": "072"
                    },
                    "description": "Administer to persons who have intimate exposure to a documented S. typhi carrier.",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "Travel to areas in which there is a recognized risk of exposure to S. typhi",
                        "code": "163"
                    },
                    "description": "Administer to persons who travel to areas in which there is a recognized risk of exposure to S. typhi.",
                    "beginAge": "2 years"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "2 years - 4 days",
                            "minAge": "2 years",
                            "earliestRecAge": "2 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Typhoid capsular polysaccharide",
                            "cvx": "101",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Typhoid capsular polysaccharide",
                            "cvx": "101",
                            "beginAge": "2 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "2 years - 4 days",
                            "minInt": "2 years",
                            "earliestRecInt": "2 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Typhoid capsular polysaccharide",
                            "cvx": "101",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Typhoid capsular polysaccharide",
                            "cvx": "101",
                            "beginAge": "2 years - 4 days"
                        }
                    ],
                    "recurringDose": "Yes"
                }
            ]
        },
        {
            "seriesName": "Typhoid risk 4-dose series",
            "targetDisease": "Typhoid",
            "vaccineGroup": "Typhoid",
            "seriesAdminGuidance": [
                "Primary vaccination with live-attenuated Ty21a vaccine consists of one enteric-coated capsule taken on alternate days (day 0, 2, 4, and 6), for a total of four capsules. The capsules must be kept refrigerated (not frozen). Each capsule should be taken with cool water no warmer than 98.6 F (37.0 C), approximately 1 hour before a meal. All doses should be completed at least 1 week before potential exposure."
            ],
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "Yes",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "minAgeToStart": "2 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Microbiology laboratorians who work frequently with S. typhi",
                        "code": "051"
                    },
                    "description": "Administer to persons who are microbiology laboratorians who work frequently with S. typhi.",
                    "beginAge": "18 years"
                },
                {
                    "observationCode": {
                        "text": "Intimate exposure to a documented S. typhi carrier",
                        "code": "072"
                    },
                    "description": "Administer to persons who have intimate exposure to a documented S. typhi carrier.",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "Travel to areas in which there is a recognized risk of exposure to S. typhi",
                        "code": "163"
                    },
                    "description": "Administer to persons who travel to areas in which there is a recognized risk of exposure to S. typhi.",
                    "beginAge": "2 years"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "6 years - 4 days",
                            "minAge": "6 years",
                            "earliestRecAge": "6 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25",
                            "beginAge": "6 years",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25",
                            "beginAge": "6 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "5 years - 4 days",
                            "minInt": "5 years",
                            "earliestRecInt": "5 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25",
                            "beginAge": "6 years",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Typhoid oral, live, attenuated",
                            "cvx": "25",
                            "beginAge": "6 years - 4 days"
                        }
                    ],
                    "recurringDose": "Yes"
                }
            ]
        }
    ]
});
