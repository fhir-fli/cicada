// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoJapaneseEncephalitis = AntigenSupportingData.fromJson(
{
    "targetDisease": "Japanese Encephalitis",
    "vaccineGroup": "JE",
    "series": [
        {
            "seriesName": "WHO JE 2-dose series (live attenuated)",
            "targetDisease": "Japanese Encephalitis",
            "vaccineGroup": "JE",
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "1"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Lives in or traveling to JE endemic area",
                        "code": "1011"
                    },
                    "description": "",
                    "beginAge": "",
                    "endAge": "",
                    "guidance": ""
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "6 months",
                            "minAge": "8 months",
                            "earliestRecAge": "8 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "JE, unspecified",
                            "cvx": "39",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "JE, unspecified",
                            "cvx": "39",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "JE, inactivated (Ixiaro)",
                            "cvx": "134",
                            "beginAge": "6 months"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "age": [
                        {
                            "absMinAge": "18 months",
                            "minAge": "2 years",
                            "earliestRecAge": "2 years"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "4 months",
                            "minInt": "12 months",
                            "earliestRecInt": "16 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "JE, unspecified",
                            "cvx": "39",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "JE, unspecified",
                            "cvx": "39",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "JE, inactivated (Ixiaro)",
                            "cvx": "134",
                            "beginAge": "6 months"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "WHO JE 2-dose series (inactivated)",
            "targetDisease": "Japanese Encephalitis",
            "vaccineGroup": "JE",
            "seriesType": "Risk",
            "selectSeries": {
                "defaultSeries": "No",
                "productPath": "No",
                "seriesGroupName": "Increased Risk",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "2"
            },
            "indication": [
                {
                    "observationCode": {
                        "text": "Lives in or traveling to JE endemic area",
                        "code": "1011"
                    },
                    "description": "",
                    "beginAge": "",
                    "endAge": "",
                    "guidance": ""
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "6 months",
                            "minAge": "9 months",
                            "earliestRecAge": "9 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "JE, inactivated (Ixiaro)",
                            "cvx": "134",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "JE, inactivated (Ixiaro)",
                            "cvx": "134",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "JE, unspecified",
                            "cvx": "39",
                            "beginAge": "6 months"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "7 days",
                            "minInt": "28 days",
                            "earliestRecInt": "28 days"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "JE, inactivated (Ixiaro)",
                            "cvx": "134",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "JE, inactivated (Ixiaro)",
                            "cvx": "134",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "JE, unspecified",
                            "cvx": "39",
                            "beginAge": "6 months"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
