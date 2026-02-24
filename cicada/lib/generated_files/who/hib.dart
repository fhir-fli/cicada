// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final AntigenSupportingData whoHib = AntigenSupportingData.fromJson(
{
    "targetDisease": "Hib",
    "vaccineGroup": "Hib",
    "series": [
        {
            "seriesName": "WHO Hib 3-dose series",
            "targetDisease": "Hib",
            "vaccineGroup": "Hib",
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
                            "earliestRecAge": "6 weeks",
                            "maxAge": "5 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "DTP-HepB-Hib (Pentavalent)",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hib, unspecified",
                            "cvx": "17",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hep B-Hib",
                            "cvx": "51",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
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
                            "earliestRecAge": "10 weeks",
                            "maxAge": "5 years"
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
                            "endAge": "5 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hib, unspecified",
                            "cvx": "17",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hep B-Hib",
                            "cvx": "51",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
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
                            "earliestRecAge": "14 weeks",
                            "maxAge": "5 years"
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
                            "endAge": "5 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hib, unspecified",
                            "cvx": "17",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hep B-Hib",
                            "cvx": "51",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        },
        {
            "seriesName": "WHO Hib 4-dose series (3p+1)",
            "targetDisease": "Hib",
            "vaccineGroup": "Hib",
            "seriesType": "Standard",
            "selectSeries": {
                "defaultSeries": "Yes",
                "productPath": "No",
                "seriesGroupName": "Standard",
                "seriesGroup": "1",
                "seriesPriority": "A",
                "seriesPreference": "2"
            },
            "seriesDose": [
                {
                    "doseNumber": "Dose 1",
                    "age": [
                        {
                            "absMinAge": "6 weeks",
                            "minAge": "6 weeks",
                            "earliestRecAge": "6 weeks",
                            "maxAge": "5 years"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "DTP-HepB-Hib (Pentavalent)",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hib, unspecified",
                            "cvx": "17",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hep B-Hib",
                            "cvx": "51",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
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
                            "earliestRecAge": "10 weeks",
                            "maxAge": "5 years"
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
                            "endAge": "5 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hib, unspecified",
                            "cvx": "17",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hep B-Hib",
                            "cvx": "51",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
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
                            "earliestRecAge": "14 weeks",
                            "maxAge": "5 years"
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
                            "endAge": "5 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hib, unspecified",
                            "cvx": "17",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hep B-Hib",
                            "cvx": "51",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
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
                            "latestRecAge": "15 months",
                            "maxAge": "5 years"
                        }
                    ],
                    "interval": [
                        {
                            "fromPrevious": "Y",
                            "absMinInt": "8 weeks",
                            "minInt": "8 weeks",
                            "earliestRecInt": "8 months"
                        }
                    ],
                    "preferableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years",
                            "forecastVaccineType": "Y"
                        }
                    ],
                    "allowableVaccine": [
                        {
                            "vaccineType": "Hib (PRP-T)",
                            "cvx": "48",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hib, unspecified",
                            "cvx": "17",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "DTP-HepB-Hib",
                            "cvx": "198",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        },
                        {
                            "vaccineType": "Hep B-Hib",
                            "cvx": "51",
                            "beginAge": "6 weeks",
                            "endAge": "5 years"
                        }
                    ],
                    "recurringDose": "No"
                }
            ]
        }
    ]
});
