// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoCovid19 = AntigenSupportingData.fromJson(
{
    "targetDisease": "COVID-19",
    "vaccineGroup": "COVID-19",
    "series": [
        {
            "seriesName": "WHO COVID-19 high-priority 2-dose series",
            "targetDisease": "COVID-19",
            "vaccineGroup": "COVID-19",
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "High Priority",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "1"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Healthcare worker",
                        "code": "1020"
                    },
                    "description": "Patient is a healthcare worker with occupational exposure risk",
                    "guidance": ""
                },
                {
                    "observationCode": {
                        "text": "Older adult 60+ years",
                        "code": "1021"
                    },
                    "description": "Patient is an older adult (60 years or older)",
                    "beginAge": "60 years",
                    "guidance": ""
                },
                {
                    "observationCode": {
                        "text": "Immunocompromised individual",
                        "code": "1022"
                    },
                    "description": "Patient is immunocompromised",
                    "guidance": ""
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "12 years",
                            "minAge": "18 years",
                            "earliestRecAge": "18 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "COVID-19, mRNA (Pfizer)",
                            "cvx": "208",
                            "beginAge": "12 years",
                            "forecastVaccineType": "Y"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "12 years",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "COVID-19, mRNA (Pfizer)",
                            "cvx": "208",
                            "beginAge": "12 years"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "12 years"
                        },
                        {
                            "vaccineType": "COVID-19, viral vector (J&J)",
                            "cvx": "212",
                            "beginAge": "18 years"
                        },
                        {
                            "vaccineType": "COVID-19, protein subunit (Novavax)",
                            "cvx": "211",
                            "beginAge": "12 years"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "3 weeks",
                            "minInt": "4 weeks",
                            "earliestRecInt": "4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "COVID-19, mRNA (Pfizer)",
                            "cvx": "208",
                            "beginAge": "12 years",
                            "forecastVaccineType": "Y"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "12 years",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "COVID-19, mRNA (Pfizer)",
                            "cvx": "208",
                            "beginAge": "12 years"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "12 years"
                        },
                        {
                            "vaccineType": "COVID-19, protein subunit (Novavax)",
                            "cvx": "211",
                            "beginAge": "12 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
