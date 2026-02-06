// ignore_for_file: prefer_single_quotes, always_specify_types

import '../cicada.dart';

final AntigenSupportingData hpv = AntigenSupportingData.fromJson(
{
    "targetDisease": "HPV",
    "vaccineGroup": "HPV",
    "contraindications": {
        "vaccineGroup": {
            "contraindication": [
                {
                    "observationCode": "007",
                    "observationTitle": "Pregnant",
                    "contraindicationText": "Do not vaccinate if the patient is pregnant."
                },
                {
                    "observationCode": "080",
                    "observationTitle": "Adverse reaction to vaccine component",
                    "contraindicationText": "Do not vaccinate if the patient has had an adverse reaction to a vaccine component."
                },
                {
                    "observationCode": "090",
                    "observationTitle": "Severe allergic reaction after previous dose of HPV",
                    "contraindicationText": "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of HPV vaccine."
                },
                {
                    "observationCode": "110",
                    "observationTitle": "Hypersensitivity to yeast",
                    "contraindicationText": "Do not vaccinate with 9vHPV if the patient has a hypersensitivity to yeast."
                }
            ]
        }
    },
    "series": [
        {
            "seriesName": "HPV 2-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesAdminGuidance": [
                "ACIP recommends routine HPV vaccination at age 11 or 12 years. Vaccination can be given starting at age 9 years.",
                "Shared clinical decision-making (SCDM) is recommended regarding Human papillomavirus (HPV) vaccination for persons 27-45 years of age. Shared clinical decision-making recommendations are intended to be flexible and should be informed by the characteristics, values, and preferences of the individual patient and the clinical discretion of the healthcare provider. More guidance can be found here: https://www.cdc.gov/vaccines/hcp/admin/downloads/ISD-job-aid-SCDM-HPV-shared-clinical-decision-making-HPV.pdf"
            ],
            "seriesType": "Standard",
            "equivalentSeriesGroups": "2",
            "requiredGender": [
                "Female",
                "Unknown"
            ],
            "selectSeries": {
                "defaultSeries": "Yes",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "maxAgeToStart": "15 years"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "11 years",
                            "latestRecAge": "13 years + 4 weeks",
                            "maxAge": "46 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
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
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Evaluation",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Target Dose is not required if current dose was administered at least 5 months - 4 days from the previous dose OR two total doses have already been administered",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months - 4 days"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                                    "setDescription": "Dose is not required once 5 months has passed since dose 1 or two total doses have already been administered.",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "HPV 3-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesAdminGuidance": [
                "ACIP recommends routine HPV vaccination at age 11 or 12 years. Vaccination can be given starting at age 9 years.",
                "Shared clinical decision-making (SCDM) is recommended regarding Human papillomavirus (HPV) vaccination for persons 27-45 years of age. Shared clinical decision-making recommendations are intended to be flexible and should be informed by the characteristics, values, and preferences of the individual patient and the clinical discretion of the healthcare provider. More guidance can be found here: https://www.cdc.gov/vaccines/hcp/admin/downloads/ISD-job-aid-SCDM-HPV-shared-clinical-decision-making-HPV.pdf"
            ],
            "seriesType": "Standard",
            "equivalentSeriesGroups": "2",
            "requiredGender": [
                "Female",
                "Unknown"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "2",
                "minAgeToStart": "15 years"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "11 years",
                            "latestRecAge": "13 years + 4 weeks",
                            "maxAge": "46 years",
                            "cessationDate": "2016-12-15"
                        },
                        {
                            "absMinAge": "15 years",
                            "minAge": "15 years",
                            "earliestRecAge": "15 years",
                            "latestRecAge": "15 years",
                            "maxAge": "46 years",
                            "effectiveDate": "2016-12-16"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "4 weeks - 4 days",
                            "minInt": "4 weeks",
                            "earliestRecInt": "4 weeks",
                            "latestRecInt": "4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
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
                            "latestRecInt": "16 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "interval": [
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "16 weeks - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "cessationDate": "2016-12-15"
                        },
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "effectiveDate": "2016-12-16"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "HPV male 2-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesAdminGuidance": [
                "ACIP recommends routine HPV vaccination at age 11 or 12 years. Vaccination can be given starting at age 9 years.",
                "Shared clinical decision-making (SCDM) is recommended regarding Human papillomavirus (HPV) vaccination for persons 27-45 years of age. Shared clinical decision-making recommendations are intended to be flexible and should be informed by the characteristics, values, and preferences of the individual patient and the clinical discretion of the healthcare provider. More guidance can be found here: https://www.cdc.gov/vaccines/hcp/admin/downloads/ISD-job-aid-SCDM-HPV-shared-clinical-decision-making-HPV.pdf"
            ],
            "seriesType": "Standard",
            "equivalentSeriesGroups": "2",
            "requiredGender": [
                "Male"
            ],
            "selectSeries": {
                "defaultSeries": "Yes",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "maxAgeToStart": "15 years"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "11 years",
                            "latestRecAge": "13 years + 4 weeks",
                            "maxAge": "46 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
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
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Evaluation",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Target Dose is not required if current dose was administered at least 5 months - 4 das from the previous dose OR two total doses have already been administered",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months - 4 days"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                                    "setDescription": "Dose is not required once 5 months has passed since dose 1 or two total doses have already been administered.",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "HPV male 3-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesAdminGuidance": [
                "ACIP recommends routine HPV vaccination at age 11 or 12 years. Vaccination can be given starting at age 9 years.",
                "Shared clinical decision-making (SCDM) is recommended regarding Human papillomavirus (HPV) vaccination for persons 27-45 years of age. Shared clinical decision-making recommendations are intended to be flexible and should be informed by the characteristics, values, and preferences of the individual patient and the clinical discretion of the healthcare provider. More guidance can be found here: https://www.cdc.gov/vaccines/hcp/admin/downloads/ISD-job-aid-SCDM-HPV-shared-clinical-decision-making-HPV.pdf"
            ],
            "seriesType": "Standard",
            "equivalentSeriesGroups": "2",
            "requiredGender": [
                "Male"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "2",
                "minAgeToStart": "15 years"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "11 years",
                            "latestRecAge": "13 years + 4 weeks",
                            "maxAge": "46 years",
                            "cessationDate": "2016-12-15"
                        },
                        {
                            "absMinAge": "15 years",
                            "minAge": "15 years",
                            "earliestRecAge": "15 years",
                            "latestRecAge": "15 years",
                            "maxAge": "46 years",
                            "effectiveDate": "2016-12-16"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "4 weeks - 4 days",
                            "minInt": "4 weeks",
                            "earliestRecInt": "4 weeks",
                            "latestRecInt": "4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
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
                            "latestRecInt": "16 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "interval": [
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "16 weeks - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "cessationDate": "2016-12-15"
                        },
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "effectiveDate": "2016-12-16"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "HPV risk 2-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesType": "Risk",
            "equivalentSeriesGroups": "1",
            "requiredGender": [
                "Female",
                "Unknown"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "minAgeToStart": "0 days",
                "maxAgeToStart": "11 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "History of sexual abuse or assault",
                        "code": "169"
                    },
                    "description": "Administer to persons who have a history of sexual abuse or assault.",
                    "beginAge": "0 days",
                    "endAge": "11 years"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "9 years",
                            "latestRecAge": "11 years",
                            "maxAge": "27 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
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
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Evaluation",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Target Dose is not required if current dose was administered at least 5 months - 4 das from the previous dose OR two total doses have already been administered",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months - 4 days"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                                    "setDescription": "Dose is not required once 5 months has passed since dose 1 or two total doses have already been administered.",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "HPV risk male 2-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesType": "Risk",
            "equivalentSeriesGroups": "1",
            "requiredGender": [
                "Male"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "minAgeToStart": "0 days",
                "maxAgeToStart": "11 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "History of sexual abuse or assault",
                        "code": "169"
                    },
                    "description": "Administer to persons who have a history of sexual abuse or assault.",
                    "beginAge": "0 days",
                    "endAge": "11 years"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "9 years",
                            "latestRecAge": "11 years",
                            "maxAge": "27 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
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
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "conditionalSkip": [
                        {
                            "context": "Evaluation",
                            "setLogic": "n/a",
                            "set": [
                                {
                                    "setID": "1",
                                    "setDescription": "Target Dose is not required if current dose was administered at least 5 months - 4 das from the previous dose OR two total doses have already been administered",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months - 4 days"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                                    "setDescription": "Dose is not required once 5 months has passed since dose 1 or two total doses have already been administered.",
                                    "conditionLogic": "OR",
                                    "condition": [
                                        {
                                            "conditionID": "1",
                                            "conditionType": "Interval",
                                            "interval": "5 months"
                                        },
                                        {
                                            "conditionID": "2",
                                            "conditionType": "Vaccine Count by Age",
                                            "beginAge": "9 years - 4 days",
                                            "doseCount": "1",
                                            "doseType": "Total",
                                            "doseCountLogic": "greater than",
                                            "vaccineTypes": "62;118;137;165"
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
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "13 months + 4 weeks"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "HPV risk 3-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesAdminGuidance": [
                "At the provider's discretion, the recommendation for a 3-dose schedule does not apply to children aged less than 15 years with asplenia, asthma, chronic granulomatous disease, chronic liver disease, chronic lung disease, chronic renal disease, CNS anatomic barrier defines (e.g., cochlear implant), complement deficiency, diabetes, heart disease, or sickle cell disease.",
                "Shared clinical decision-making (SCDM) is recommended regarding Human papillomavirus (HPV) vaccination for persons 27-45 years of age. Shared clinical decision-making recommendations are intended to be flexible and should be informed by the characteristics, values, and preferences of the individual patient and the clinical discretion of the healthcare provider. More guidance can be found here: https://www.cdc.gov/vaccines/hcp/admin/downloads/ISD-job-aid-SCDM-HPV-shared-clinical-decision-making-HPV.pdf"
            ],
            "seriesType": "Risk",
            "requiredGender": [
                "Female",
                "Unknown"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "minAgeToStart": "9 years",
                "maxAgeToStart": "46 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "B-lymphocyte [humoral] - Severe antibody deficiencies",
                        "code": "145"
                    },
                    "description": "Administer to persons who have severe B-lymphocyte (humoral) - antibody deficiencies (e.g., X-linked agammaglobulinemia and common variable immunodeficiency).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "B-lymphocyte [humoral] - Less severe antibody deficiencies",
                        "code": "146"
                    },
                    "description": "Administer to persons who have less severe B-lymphocyte (humoral) - antibody deficiencies (e.g., selective IgA deficiency and IgG subclass deficiency).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - Complete defects",
                        "code": "147"
                    },
                    "description": "Administer to persons who have complete cell-mediated or humoral T-lymphocyte defects (e.g., severe combined immunodeficiency [SCID] disease, complete DiGeorge syndrome).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - Partial defects",
                        "code": "148"
                    },
                    "description": "Administer to persons who have partial cell-mediated or humoral T-lymphocyte defects (e.g., most patients with DiGeorge syndrome, Wiskott-Aldrich syndrome, ataxia- telangiectasia).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - interferon-gamma/Interleukin 12 axis deficiencies",
                        "code": "149"
                    },
                    "description": "Administer to persons who have T-lymphocyte [cell-mediated and humoral] - interferon-gamma/Interleukin 12 axis deficiencies.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - interferon-gamma or interferon-alpha deficiencies",
                        "code": "150"
                    },
                    "description": "Administer to persons who have T-lymphocyte [cell-mediated and humoral] - interferon-gamma or interferon-alpha deficiencies.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Phagocytic function - Leukocyte adhesion defect, and myeloperoxidase deficiency",
                        "code": "153"
                    },
                    "description": "Administer to persons who have a phagocytic function defect (e.g. leukocyte adhesion defect and myeloperoxidase deficiency).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - severely immunocompromised",
                        "code": "154"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - not severely immunocompromised",
                        "code": "155"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Generalized malignant neoplasm",
                        "code": "156"
                    },
                    "description": "Administer to persons who have generalized malignant neoplasm.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Immunosuppressive therapy",
                        "code": "158"
                    },
                    "description": "Administer to persons who are undergoing immunosuppressive therapy. Immunosuppressive medications include those given to prevent solid organ transplant rejection, human immune mediators like interleukins and colony-stimulating factors, immune modulators like levamisol and BCG bladder-tumor therapy, and medicines like tumor necrosis factor alpha inhibitors and anti-B cell antibodies.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Radiation therapy",
                        "code": "159"
                    },
                    "description": "Administer to persons who are undergoing radiation therapy.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "HIV Infection",
                        "code": "186"
                    },
                    "description": "Administer to persons with HIV Infection",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Transplantation",
                        "code": "269"
                    },
                    "description": "Administer to persons who have received a transplant.",
                    "beginAge": "9 years"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "11 years",
                            "latestRecAge": "13 years + 4 weeks",
                            "maxAge": "46 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
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
                            "latestRecInt": "16 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "interval": [
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "16 weeks - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "cessationDate": "2016-12-15"
                        },
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "effectiveDate": "2016-12-16"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks",
                            "earliestRecInt": "4 months",
                            "latestRecInt": "5 months + 4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "HPV risk male 3-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesAdminGuidance": [
                "At the provider's discretion, the recommendation for a 3-dose schedule does not apply to children aged less than 15 years with asplenia, asthma, chronic granulomatous disease, chronic liver disease, chronic lung disease, chronic renal disease, CNS anatomic barrier defines (e.g., cochlear implant), complement deficiency, diabetes, heart disease, or sickle cell disease.",
                "Shared clinical decision-making (SCDM) is recommended regarding Human papillomavirus (HPV) vaccination for persons 27-45 years of age. Shared clinical decision-making recommendations are intended to be flexible and should be informed by the characteristics, values, and preferences of the individual patient and the clinical discretion of the healthcare provider. More guidance can be found here: https://www.cdc.gov/vaccines/hcp/admin/downloads/ISD-job-aid-SCDM-HPV-shared-clinical-decision-making-HPV.pdf"
            ],
            "seriesType": "Risk",
            "requiredGender": [
                "Male"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "2",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "minAgeToStart": "9 years",
                "maxAgeToStart": "46 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "B-lymphocyte [humoral] - Severe antibody deficiencies",
                        "code": "145"
                    },
                    "description": "Administer to persons who have severe B-lymphocyte (humoral) - antibody deficiencies (e.g., X-linked agammaglobulinemia and common variable immunodeficiency).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "B-lymphocyte [humoral] - Less severe antibody deficiencies",
                        "code": "146"
                    },
                    "description": "Administer to persons who have less severe B-lymphocyte (humoral) - antibody deficiencies (e.g., selective IgA deficiency and IgG subclass deficiency).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - Complete defects",
                        "code": "147"
                    },
                    "description": "Administer to persons who have complete cell-mediated or humoral T-lymphocyte defects (e.g., severe combined immunodeficiency [SCID] disease, complete DiGeorge syndrome).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - Partial defects",
                        "code": "148"
                    },
                    "description": "Administer to persons who have partial cell-mediated or humoral T-lymphocyte defects (e.g., most patients with DiGeorge syndrome, Wiskott-Aldrich syndrome, ataxia- telangiectasia).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - interferon-gamma/Interleukin 12 axis deficiencies",
                        "code": "149"
                    },
                    "description": "Administer to persons who have T-lymphocyte [cell-mediated and humoral] - interferon-gamma/Interleukin 12 axis deficiencies.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "T-lymphocyte [cell-mediated and humoral] - interferon-gamma or interferon-alpha deficiencies",
                        "code": "150"
                    },
                    "description": "Administer to persons who have T-lymphocyte [cell-mediated and humoral] - interferon-gamma or interferon-alpha deficiencies.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Phagocytic function - Leukocyte adhesion defect, and myeloperoxidase deficiency",
                        "code": "153"
                    },
                    "description": "Administer to persons who have a phagocytic function defect (e.g. leukocyte adhesion defect and myeloperoxidase deficiency).",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - severely immunocompromised",
                        "code": "154"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "HIV/AIDS - not severely immunocompromised",
                        "code": "155"
                    },
                    "description": "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Generalized malignant neoplasm",
                        "code": "156"
                    },
                    "description": "Administer to persons who have generalized malignant neoplasm.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Immunosuppressive therapy",
                        "code": "158"
                    },
                    "description": "Administer to persons who are undergoing immunosuppressive therapy. Immunosuppressive medications include those given to prevent solid organ transplant rejection, human immune mediators like interleukins and colony-stimulating factors, immune modulators like levamisol and BCG bladder-tumor therapy, and medicines like tumor necrosis factor alpha inhibitors and anti-B cell antibodies.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Radiation therapy",
                        "code": "159"
                    },
                    "description": "Administer to persons who are undergoing radiation therapy.",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "HIV Infection",
                        "code": "186"
                    },
                    "description": "Administer to persons with HIV Infection",
                    "beginAge": "9 years"
                },
                {
                    "observationCode": {
                        "text": "Transplantation",
                        "code": "269"
                    },
                    "description": "Administer to persons who have received a transplant.",
                    "beginAge": "9 years"
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years - 4 days",
                            "minAge": "9 years",
                            "earliestRecAge": "11 years",
                            "latestRecAge": "13 years + 4 weeks",
                            "maxAge": "46 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
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
                            "latestRecInt": "16 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "interval": [
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "16 weeks - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "cessationDate": "2016-12-15"
                        },
                        {
                            "fromPrevious": "N",
                            "fromTargetDose": "1",
                            "absMinInt": "5 months - 4 days",
                            "minInt": "5 months",
                            "earliestRecInt": "6 months",
                            "latestRecInt": "7 months + 4 weeks",
                            "effectiveDate": "2016-12-16"
                        },
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks - 4 days",
                            "minInt": "12 weeks",
                            "earliestRecInt": "4 months",
                            "latestRecInt": "5 months + 4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "endAge": "46 years",
                            "volume": "0.5",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "4vHPV",
                            "cvx": "62",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "HPV Unspecified",
                            "cvx": "137",
                            "beginAge": "9 years - 4 days"
                        },
                        {
                            "vaccineType": "9vHPV",
                            "cvx": "165",
                            "beginAge": "9 years - 4 days"
                        }
                    ],
                    "inadvertentVaccine": [
                        {
                            "vaccineType": "2vHPV",
                            "cvx": "118"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
