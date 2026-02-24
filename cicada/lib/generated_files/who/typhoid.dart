// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoTyphoid = AntigenSupportingData.fromJson(
{
    "targetDisease": "Typhoid",
    "vaccineGroup": "Typhoid",
    "series": [
        {
            "seriesName": "WHO Typhoid conjugate 1-dose series",
            "targetDisease": "Typhoid",
            "vaccineGroup": "Typhoid",
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
                        "text": "Lives in typhoid endemic area",
                        "code": "1014"
                    }
                }
            ],
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "6 months",
                            "minAge": "6 months",
                            "earliestRecAge": "9 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Typhoid conjugate (TCV)",
                            "cvx": "190",
                            "beginAge": "6 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Typhoid conjugate (TCV)",
                            "cvx": "190",
                            "beginAge": "6 months"
                        },
                        {
                            "vaccineType": "Typhoid Vi polysaccharide",
                            "cvx": "101",
                            "beginAge": "2 years"
                        },
                        {
                            "vaccineType": "Typhoid oral (Ty21a)",
                            "cvx": "25",
                            "beginAge": "6 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
