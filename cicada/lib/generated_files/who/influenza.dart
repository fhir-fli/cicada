// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoInfluenza = AntigenSupportingData.fromJson(
{
    "targetDisease": "Influenza",
    "vaccineGroup": "Influenza",
    "series": [
        {
            "seriesName": "WHO Influenza annual series",
            "targetDisease": "Influenza",
            "vaccineGroup": "Influenza",
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
                            "vaccineType": "Influenza, injectable, quadrivalent",
                            "cvx": "150",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Influenza, injectable, quadrivalent",
                            "cvx": "150",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "Influenza, injectable",
                            "cvx": "141",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "Influenza, live intranasal",
                            "cvx": "149",
                            "beginAge": "2 years"
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
                            "earliestRecInt": "4 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Influenza, injectable, quadrivalent",
                            "cvx": "150",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Influenza, injectable, quadrivalent",
                            "cvx": "150",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "Influenza, injectable",
                            "cvx": "141",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "Influenza, live intranasal",
                            "cvx": "149",
                            "beginAge": "2 years"
                        }
                    ],
                    "recurringDose": "Yes"
                }
            ]
        }
    ]
});
