// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoTetanus = AntigenSupportingData.fromJson(
{
    "targetDisease": "Tetanus",
    "vaccineGroup": "DTP",
    "series": [
        {
            "seriesName": "WHO Tetanus 6-dose series",
            "targetDisease": "Tetanus",
            "vaccineGroup": "DTP",
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
                            "absMinAge": "6 weeks",
                            "minAge": "6 weeks",
                            "earliestRecAge": "6 weeks"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "DTP-HepB-Hib (Pentavalent)",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "DTP",
                            "cvx": "01",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTaP",
                            "cvx": "20",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Td adult",
                            "cvx": "09",
                            "beginAge": "7 years"
                        },
                        {
                            "vaccineType": "Tdap",
                            "cvx": "115",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "TT",
                            "cvx": "35",
                            "beginAge": "6 weeks"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 2",
                    "age": [
                        {
                            "absMinAge": "10 weeks",
                            "minAge": "10 weeks",
                            "earliestRecAge": "10 weeks"
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
                            "vaccineType": "DTP-HepB-Hib (Pentavalent)",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "DTP",
                            "cvx": "01",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTaP",
                            "cvx": "20",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Td adult",
                            "cvx": "09",
                            "beginAge": "7 years"
                        },
                        {
                            "vaccineType": "Tdap",
                            "cvx": "115",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "TT",
                            "cvx": "35",
                            "beginAge": "6 weeks"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 3",
                    "age": [
                        {
                            "absMinAge": "14 weeks",
                            "minAge": "14 weeks",
                            "earliestRecAge": "14 weeks"
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
                            "vaccineType": "DTP-HepB-Hib (Pentavalent)",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "DTP",
                            "cvx": "01",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTaP",
                            "cvx": "20",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Tdap",
                            "cvx": "115",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "TT",
                            "cvx": "35",
                            "beginAge": "6 weeks"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 4",
                    "age": [
                        {
                            "absMinAge": "12 months",
                            "minAge": "12 months",
                            "earliestRecAge": "12 months",
                            "latestRecAge": "23 months"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "6 months",
                            "minInt": "6 months",
                            "earliestRecInt": "6 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "DTP",
                            "cvx": "01",
                            "beginAge": "12 months",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "DTP",
                            "cvx": "01",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTaP",
                            "cvx": "20",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Tdap",
                            "cvx": "115",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "TT",
                            "cvx": "35",
                            "beginAge": "6 weeks"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 5",
                    "age": [
                        {
                            "absMinAge": "4 years",
                            "minAge": "4 years",
                            "earliestRecAge": "4 years",
                            "latestRecAge": "7 years"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "6 months",
                            "minInt": "6 months",
                            "earliestRecInt": "3 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "4 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "DTP",
                            "cvx": "01",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "DTaP",
                            "cvx": "20",
                            "beginAge": "6 weeks"
                        },
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "4 years"
                        },
                        {
                            "vaccineType": "Td adult",
                            "cvx": "09",
                            "beginAge": "7 years"
                        },
                        {
                            "vaccineType": "Tdap",
                            "cvx": "115",
                            "beginAge": "4 years"
                        },
                        {
                            "vaccineType": "TT",
                            "cvx": "35",
                            "beginAge": "6 weeks"
                        }
                    ],
                    "recurringDose": "No"
                },
                {
                    "doseNumber": "Dose 6",
                    "age": [
                        {
                            "absMinAge": "9 years",
                            "minAge": "9 years",
                            "earliestRecAge": "9 years",
                            "latestRecAge": "15 years"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "6 months",
                            "minInt": "6 months",
                            "earliestRecInt": "5 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "7 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Td",
                            "cvx": "138",
                            "beginAge": "7 years"
                        },
                        {
                            "vaccineType": "Td adult",
                            "cvx": "09",
                            "beginAge": "7 years"
                        },
                        {
                            "vaccineType": "Tdap",
                            "cvx": "115",
                            "beginAge": "7 years"
                        },
                        {
                            "vaccineType": "TT",
                            "cvx": "35",
                            "beginAge": "6 weeks"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
