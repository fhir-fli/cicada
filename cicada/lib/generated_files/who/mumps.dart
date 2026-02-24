// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoMumps = AntigenSupportingData.fromJson(
{
    "targetDisease": "Mumps",
    "vaccineGroup": "MMR",
    "series": [
        {
            "seriesName": "WHO Mumps 2-dose series",
            "targetDisease": "Mumps",
            "vaccineGroup": "MMR",
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
                            "absMinAge": "12 months",
                            "minAge": "12 months",
                            "earliestRecAge": "12 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "12 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "12 months"
                        },
                        {
                            "vaccineType": "Mumps",
                            "cvx": "07",
                            "beginAge": "12 months"
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
                            "absMinAge": "13 months",
                            "minAge": "15 months",
                            "earliestRecAge": "15 months"
                        }
                    ],
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
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "12 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "MMR",
                            "cvx": "03",
                            "beginAge": "12 months"
                        },
                        {
                            "vaccineType": "Mumps",
                            "cvx": "07",
                            "beginAge": "12 months"
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
