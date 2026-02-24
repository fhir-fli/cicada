// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoHpv = AntigenSupportingData.fromJson(
{
    "targetDisease": "HPV",
    "vaccineGroup": "HPV",
    "series": [
        {
            "seriesName": "WHO HPV 1-dose series",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesType": "Standard",
            "requiredGender": [
                "Female"
            ],
            "selectSeries": {
                "defaultSeries": "Yes",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "minAgeToStart": "9 years",
                "maxAgeToStart": "20 years"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years",
                            "minAge": "9 years",
                            "earliestRecAge": "9 years",
                            "latestRecAge": "14 years",
                            "maxAge": "20 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, quadrivalent",
                            "cvx": "62",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, bivalent",
                            "cvx": "118",
                            "beginAge": "9 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "WHO HPV 2-dose series (>=21y)",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesType": "Standard",
            "equivalentSeriesGroups": "1",
            "requiredGender": [
                "Female"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "2",
                "seriesPriority": "A",
                "seriesPreference": "2",
                "minAgeToStart": "21 years"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years",
                            "minAge": "21 years",
                            "earliestRecAge": "21 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, quadrivalent",
                            "cvx": "62",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, bivalent",
                            "cvx": "118",
                            "beginAge": "9 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "5 months",
                            "minInt": "6 months",
                            "earliestRecInt": "6 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, quadrivalent",
                            "cvx": "62",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, bivalent",
                            "cvx": "118",
                            "beginAge": "9 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "WHO HPV 3-dose series (immunocompromised)",
            "targetDisease": "HPV",
            "vaccineGroup": "HPV",
            "seriesType": "Risk",
            "requiredGender": [
                "Female"
            ],
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Immunocompromised",
                "seriesGroup": "3",
                "seriesPriority": "A",
                "seriesPreference": "1",
                "minAgeToStart": "9 years"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Immunocompromised individual",
                        "code": "1022"
                    },
                    "description": "Patient is immunocompromised — requires 3-dose HPV series",
                    "guidance": ""
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "9 years",
                            "minAge": "9 years",
                            "earliestRecAge": "9 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, quadrivalent",
                            "cvx": "62",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, bivalent",
                            "cvx": "118",
                            "beginAge": "9 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "4 weeks",
                            "minInt": "4 weeks",
                            "earliestRecInt": "2 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, quadrivalent",
                            "cvx": "62",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, bivalent",
                            "cvx": "118",
                            "beginAge": "9 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "12 weeks",
                            "minInt": "4 months",
                            "earliestRecInt": "4 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "HPV, 9-valent",
                            "cvx": "165",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, quadrivalent",
                            "cvx": "62",
                            "beginAge": "9 years"
                        },
                        {
                            "vaccineType": "HPV, bivalent",
                            "cvx": "118",
                            "beginAge": "9 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
