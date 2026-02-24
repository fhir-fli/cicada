// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoCovid19 = AntigenSupportingData.fromJson(
{
    "targetDisease": "COVID-19",
    "vaccineGroup": "COVID-19",
    "series": [
        {
            "seriesName": "WHO COVID-19 primary series",
            "targetDisease": "COVID-19",
            "vaccineGroup": "COVID-19",
            "seriesType": "Standard",
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
                            "absMinAge": "6 months",
                            "minAge": "6 months",
                            "earliestRecAge": "6 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "COVID-19, mRNA (Pfizer)",
                            "cvx": "208",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "6 months",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "COVID-19, mRNA (Pfizer)",
                            "cvx": "208",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "6 months"
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
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "6 months",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "COVID-19, mRNA (Pfizer)",
                            "cvx": "208",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "COVID-19, mRNA (Moderna)",
                            "cvx": "207",
                            "beginAge": "6 months"
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
