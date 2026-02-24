// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoMeasles = AntigenSupportingData.fromJson(
{
    "targetDisease": "Measles",
    "vaccineGroup": "MR",
    "immunity": {
        "clinicalHistory": [
            {
                "guidelineCode": "1071",
                "guidelineTitle": "Laboratory evidence of immunity for Measles"
            }
        ]
    },
    "series": [
        {
            "seriesName": "WHO Measles 2-dose series",
            "targetDisease": "Measles",
            "vaccineGroup": "MR",
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
                            "minAge": "9 months",
                            "earliestRecAge": "9 months",
                            "latestRecAge": "12 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Measles/Rubella (MR)",
                            "cvx": "04",
                            "beginAge": "9 months",
                            "forecastVaccineType": "Y"
                        },
                        {
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "9 months",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Measles/Rubella (MR)",
                            "cvx": "04",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "Measles",
                            "cvx": "05",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "MMRV",
                            "cvx": "94",
                            "beginAge": "12 months"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "age": [
                        {
                            "absMinAge": "15 months",
                            "minAge": "15 months",
                            "earliestRecAge": "15 months",
                            "latestRecAge": "18 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "4 weeks",
                            "minInt": "4 weeks",
                            "earliestRecInt": "6 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Measles/Rubella (MR)",
                            "cvx": "04",
                            "beginAge": "9 months",
                            "forecastVaccineType": "Y"
                        },
                        {
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "9 months",
                            "forecastVaccineType": "N"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Measles/Rubella (MR)",
                            "cvx": "04",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "Measles",
                            "cvx": "05",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "MMRV",
                            "cvx": "94",
                            "beginAge": "12 months"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
