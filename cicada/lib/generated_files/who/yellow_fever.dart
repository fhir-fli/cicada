// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoYellowFever = AntigenSupportingData.fromJson(
{
    "targetDisease": "Yellow Fever",
    "vaccineGroup": "Yellow Fever",
    "series": [
        {
            "seriesName": "WHO Yellow Fever 1-dose series",
            "targetDisease": "Yellow Fever",
            "vaccineGroup": "Yellow Fever",
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
                        "text": "Lives in or traveling to YF endemic area",
                        "code": "1012"
                    }
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
                            "vaccineType": "Yellow Fever",
                            "cvx": "37",
                            "beginAge": "9 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Yellow Fever",
                            "cvx": "37",
                            "beginAge": "6 months"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
