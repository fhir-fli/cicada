// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoTuberculosis = AntigenSupportingData.fromJson(
{
    "targetDisease": "Tuberculosis",
    "vaccineGroup": "BCG",
    "series": [
        {
            "seriesName": "WHO Tuberculosis 1-dose series",
            "targetDisease": "Tuberculosis",
            "vaccineGroup": "BCG",
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
                            "absMinAge": "0 days",
                            "minAge": "0 days",
                            "earliestRecAge": "0 days"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "BCG",
                            "cvx": "19",
                            "beginAge": "0 days",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "BCG",
                            "cvx": "19",
                            "beginAge": "0 days"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
