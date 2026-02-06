// ignore_for_file: prefer_single_quotes, always_specify_types

import '../cicada.dart';

final AntigenSupportingData meningococcal = AntigenSupportingData.fromJson(
{
    "targetDisease": "Meningococcal",
    "vaccineGroup": "Meningococcal",
    "contraindications": {
        "vaccineGroup": {
            "contraindication": [
                {
                    "observationCode": "095",
                    "observationTitle": "Severe allergic reaction after previous dose of Meningococcal",
                    "contraindicationText": "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Meningococcal vaccine."
                },
                {
                    "observationCode": "080",
                    "observationTitle": "Adverse reaction to vaccine component",
                    "contraindicationText": "Do not vaccinate if the patient has had an adverse reaction to a vaccine component."
                }
            ]
        },
        "vaccine": {
            "contraindication": [
                {
                    "observationCode": "117",
                    "observationTitle": "Severe allergic reaction to diphtheria toxoid",
                    "contraindicationText": "Do not vaccinate if the patient has had a severe allergic reaction to diphtheria toxoid.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328"
                        }
                    ]
                },
                {
                    "observationCode": "118",
                    "observationTitle": "Severe allergic reaction to tetanus toxoid",
                    "contraindicationText": "Do not vaccinate if the patient has had a severe allergic reaction to tetanus toxoid.",
                    "contraindicatedVaccine": [
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316"
                        }
                    ]
                }
            ]
        }
    },
    "series": [
        {
            "seriesName": "Meningococcal ACWY 2-dose series",
            "targetDisease": "Meningococcal",
            "vaccineGroup": "Meningococcal",
            "seriesAdminGuidance": [
                "Penbraya (MenACWY/MenB - Pfizer) or Penmenvy (MenACWY/MenB - GSK) may be used when both MenACWY and MenB are indicated at the same visit.",
                "Persons aged 19-21 years who have not received a dose after their 16th birthday can receive a single MenACWY dose as part of catch-up vaccination."
            ],
            "seriesType": "Standard",
            "equivalentSeriesGroups": "2",
            "selectSeries": {
                "defaultSeries": "Yes",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "1"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "10 years",
                            "minAge": "11 years",
                            "earliestRecAge": "11 years",
                            "latestRecAge": "13 years + 4 weeks",
                            "maxAge": "19 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "MCV4, unspecified",
                            "cvx": "147",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Evaluation",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Target Dose is not needed if the current dose was administered on or after 16 years - 4 days of age",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "16 years - 4 days"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "context": "Forecast",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "2",
                                    "setDescription": "Target Dose is not required for those who are 16 years of age or older",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "16 years"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "age": [
                        {
                            "absMinAge": "16 years - 4 days",
                            "minAge": "16 years",
                            "earliestRecAge": "16 years",
                            "latestRecAge": "17 years + 4 weeks",
                            "maxAge": "22 years"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "N",
                            "fromMostRecent": "316; 328",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "6 months",
                            "earliestRecInt": "6 months"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "8 weeks",
                            "earliestRecInt": "4 years",
                            "latestRecInt": "6 years + 4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "MCV4, unspecified",
                            "cvx": "147",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "Meningococcal ACWY risk 2-23 month",
            "targetDisease": "Meningococcal",
            "vaccineGroup": "Meningococcal",
            "seriesAdminGuidance": [
                "Penbraya (MenACWY/MenB - Pfizer) or Penmenvy (MenACWY/MenB - GSK) may be used when both MenACWY and MenB are indicated at the same visit."
            ],
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "A"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Persons at risk during an outbreak",
                        "code": "070"
                    },
                    "description": "Administer to persons identified as at increased risk during a community outbreak attributable to a vaccine serogroup",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "Persistent complement, properdin, or factor B deficiency",
                        "code": "151"
                    },
                    "description": "Administer to persons who have persistent complement deficiencies",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - severely immunocompromised",
                        "code": "154"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - not severely immunocompromised",
                        "code": "155"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "Anatomical or functional asplenia",
                        "code": "160"
                    },
                    "description": "Administer to persons with anatomic or functional asplenia, including sickle cell disease.",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "Travel to or are residents of countries in which meningococcal disease is hyperendemic or epidemic",
                        "code": "164"
                    },
                    "description": "Administer to persons who travel to or are residents of countries in which meningococcal disease is hyperendemic or epidemic",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "HIV Infection",
                        "code": "186"
                    },
                    "description": "Administer to persons with HIV Infection",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "Sickle cell disease",
                        "code": "259"
                    },
                    "description": "Administer to persons with sickle cell disease",
                    "beginAge": "2 months"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "2 months - 4 days",
                            "minAge": "2 months",
                            "earliestRecAge": "2 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if patient is currently 7 months of age or older AND no doses were administered prior to age 7 months",
                                    "conditionLogic": "AND",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "7 months"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count By Age",
                                            "beginAge": "2 months",
                                            "endAge": "7 months",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "equal to"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "age": [
                        {
                            "earliestRecAge": "4 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "8 weeks",
                            "earliestRecInt": "8 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if patient is currently 7 months of age or older",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "7 months"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "age": [
                        {
                            "earliestRecAge": "6 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "8 weeks",
                            "earliestRecInt": "8 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if patient is currently 7 months of age or older",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "7 months"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 4",
                    "age": [
                        {
                            "earliestRecAge": "7 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "8 weeks",
                            "earliestRecInt": "8 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if more than 2 doses have been administered between 2 and 7 months OR at least 1 dose on or after 7 months",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Vaccine Count By Age",
                                            "beginAge": "2 months",
                                            "endAge": "7 months",
                                            "doseCount": "2",
                                            "doseType": "Valid",
                                            "doseCountLogic": "greater than"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count By Age",
                                            "beginAge": "7 months",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "greater than"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 5",
                    "age": [
                        {
                            "absMinAge": "12 months - 4 days",
                            "minAge": "12 months",
                            "earliestRecAge": "12 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks",
                            "earliestRecInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 6",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "3 years - 4 days",
                            "minInt": "3 years",
                            "earliestRecInt": "3 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if the patient has received 1 or more doses after the age of 7 years",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "7 years",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "greater than"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 7",
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
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "Yes"
                }
            ]
        },
        {
            "seriesName": "Meningococcal ACWY risk Hib-MenCY-TT 4-dose series",
            "targetDisease": "Meningococcal",
            "vaccineGroup": "Meningococcal",
            "seriesAdminGuidance": [
                "Penbraya (MenACWY/MenB - Pfizer) or Penmenvy (MenACWY/MenB - GSK) may be used when both MenACWY and MenB are indicated at the same visit."
            ],
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "Yes",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "A",
                "minAgeToStart": "2 months",
                "maxAgeToStart": "16 months"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Persons at risk during an outbreak",
                        "code": "070"
                    },
                    "description": "Administer to persons identified as at increased risk during a community outbreak attributable to a vaccine serogroup",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "Persistent complement, properdin, or factor B deficiency",
                        "code": "151"
                    },
                    "description": "Administer to persons who have persistent complement deficiencies",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "Anatomical or functional asplenia",
                        "code": "160"
                    },
                    "description": "Administer to persons with anatomic or functional asplenia, including sickle cell disease.",
                    "beginAge": "2 months"
                },
                {
                    "observationCode": {
                        "text": "Sickle cell disease",
                        "code": "259"
                    },
                    "description": "Administer to persons with sickle cell disease",
                    "beginAge": "2 months"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "6 weeks",
                            "minAge": "2 months",
                            "earliestRecAge": "2 months",
                            "maxAge": "19 months"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal C/Y-HIB PRP",
                            "cvx": "148",
                            "beginAge": "6 weeks",
                            "endAge": "19 months"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "age": [
                        {
                            "maxAge": "19 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "8 weeks",
                            "earliestRecInt": "8 weeks"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal C/Y-HIB PRP",
                            "cvx": "148",
                            "beginAge": "6 weeks",
                            "endAge": "19 months"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required for those 19 months or older",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "19 months"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "age": [
                        {
                            "maxAge": "19 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "8 weeks",
                            "earliestRecInt": "8 weeks"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal C/Y-HIB PRP",
                            "cvx": "148",
                            "beginAge": "6 weeks",
                            "endAge": "19 months"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "OR",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if the patient has received 0 doses before the age of 12 months",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "6 weeks",
                                            "endAge": "12 months",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "equal to"
                                        }
                                    ]
                                },
                                {
                                    "setID": "2",
                                    "setDescription": "Dose is not required for those 19 months or older",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "19 months"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 4",
                    "age": [
                        {
                            "maxAge": "19 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "6 months - 4 days",
                            "minInt": "6 months",
                            "earliestRecInt": "6 months"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal C/Y-HIB PRP",
                            "cvx": "148",
                            "beginAge": "6 weeks",
                            "endAge": "19 months"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "OR",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if the patient has received 0 doses before the age of 12 months",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "6 weeks",
                                            "endAge": "12 months",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "equal to"
                                        }
                                    ]
                                },
                                {
                                    "setID": "2",
                                    "setDescription": "Dose is not required for those 19 months or older",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Age",
                                            "beginAge": "19 months"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 5",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "3 years - 4 days",
                            "minInt": "3 years",
                            "earliestRecInt": "3 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if the patient has received 1 or more doses after the age of 7 years",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "7 years",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "greater than"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 6",
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
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "Yes"
                }
            ]
        },
        {
            "seriesName": "Meningococcal ACWY risk 2-dose series",
            "targetDisease": "Meningococcal",
            "vaccineGroup": "Meningococcal",
            "seriesAdminGuidance": [
                "Penbraya (MenACWY/MenB - Pfizer) or Penmenvy (MenACWY/MenB - GSK) may be used when both MenACWY and MenB are indicated at the same visit."
            ],
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "A"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Persistent complement, properdin, or factor B deficiency",
                        "code": "151"
                    },
                    "description": "Administer to persons who have persistent complement deficiencies",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - severely immunocompromised",
                        "code": "154"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - not severely immunocompromised",
                        "code": "155"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "Anatomical or functional asplenia",
                        "code": "160"
                    },
                    "description": "Administer to persons with anatomic or functional asplenia, including sickle cell disease.",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "HIV Infection",
                        "code": "186"
                    },
                    "description": "Administer to persons with HIV Infection",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "Sickle cell disease",
                        "code": "259"
                    },
                    "description": "Administer to persons with sickle cell disease",
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
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "N",
                            "fromMostRecent": "316; 328",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "6 months",
                            "earliestRecInt": "6 months"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks - 4 days",
                            "minInt": "8 weeks",
                            "earliestRecInt": "8 weeks",
                            "latestRecInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "3 years - 4 days",
                            "minInt": "3 years",
                            "earliestRecInt": "3 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if the patient has received 1 or more doses after the age of 7 years",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "7 years",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "greater than"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 4",
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
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "Yes"
                }
            ]
        },
        {
            "seriesName": "Meningococcal ACWY risk 1-dose series",
            "targetDisease": "Meningococcal",
            "vaccineGroup": "Meningococcal",
            "seriesAdminGuidance": [
                "Persons with HIV infection who are recommended routinely to receive vaccine should receive a 2-dose primary series, administered 8-12 weeks apart, because evidence suggests that persons with HIV do not respond optimally to a single dose.",
                "Penbraya (MenACWY/MenB - Pfizer) or Penmenvy (MenACWY/MenB - GSK) may be used when both MenACWY and MenB are indicated at the same visit."
            ],
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "B",
                "minAgeToStart": "2 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "College students living in residence halls",
                        "code": "046"
                    },
                    "description": "Administer to college students living in residence halls.",
                    "beginAge": "19 years"
                },
                {
                    "observationCode": {
                        "text": "Microbiologists routinely exposed to Neisseria meningitidis",
                        "code": "050"
                    },
                    "description": "Administer to microbiologists routinely exposed to Neisseria meningitidis",
                    "beginAge": "19 years"
                },
                {
                    "observationCode": {
                        "text": "Military recruits",
                        "code": "064"
                    },
                    "description": "Administer to military recruits.",
                    "beginAge": "19 years"
                },
                {
                    "observationCode": {
                        "text": "Persons at risk during an outbreak",
                        "code": "070"
                    },
                    "description": "Administer to persons identified as at increased risk during a community outbreak attributable to a vaccine serogroup.",
                    "beginAge": "2 years"
                },
                {
                    "observationCode": {
                        "text": "Travel to or are residents of countries in which meningococcal disease is hyperendemic or epidemic",
                        "code": "164"
                    },
                    "description": "Administer to persons who travel to or are residents of countries in which meningococcal disease is hyperendemic or epidemic.",
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
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MPSV4",
                            "cvx": "32",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "3 years - 4 days",
                            "minInt": "3 years",
                            "earliestRecInt": "3 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "endAge": "56 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Both",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Dose is not required if the patient has received 1 or more doses after the age of 7 years",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "7 years",
                                            "doseCount": "0",
                                            "doseType": "Valid",
                                            "doseCountLogic": "greater than"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
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
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years",
                            "endAge": "26 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Meningococcal ACWY, unspecified",
                            "cvx": "108",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4P",
                            "cvx": "114",
                            "beginAge": "9 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal, MCV4O",
                            "cvx": "136",
                            "beginAge": "2 months - 4 days"
                        },
                        {
                            "vaccineType": "Meningococcal Polysaccharide A, C, Y, W-135 TT Conjugate",
                            "cvx": "203",
                            "beginAge": "2 years - 4 days"
                        },
                        {
                            "vaccineType": "meningococcal polysaccharide (MenACWY-TT conjugate), (MenB), PF",
                            "cvx": "316",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        },
                        {
                            "vaccineType": "Meningococcal oligosaccharide (MenACWY), (MenB), PF",
                            "cvx": "328",
                            "beginAge": "10 years - 4 days",
                            "endAge": "26 years"
                        }
                    ],
                    "recurringDose": "Yes"
                }
            ]
        }
    ]
});
