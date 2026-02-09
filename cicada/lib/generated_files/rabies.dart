// ignore_for_file: prefer_single_quotes, always_specify_types

import '../cicada.dart';

final AntigenSupportingData rabies = AntigenSupportingData.fromJson({
  "targetDisease": "Rabies",
  "vaccineGroup": "Rabies",
  "contraindications": {
    "vaccineGroup": {
      "contraindication": [
        {
          "observationCode": "080",
          "observationTitle": "Adverse reaction to vaccine component",
          "contraindicationText":
              "Do not vaccinate if the patient has had an adverse reaction to a vaccine component."
        },
        {
          "observationCode": "113",
          "observationTitle":
              "Severe allergic reaction after previous dose of Rabies",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Rabies vaccine."
        }
      ]
    }
  },
  "series": [
    {
      "seriesName": "Rabies risk continuous exposure series",
      "targetDisease": "Rabies",
      "vaccineGroup": "Rabies",
      "seriesAdminGuidance": [
        "The 6 month booster should only be given after a rabies antibody titer. The booster should be administered if the titer falls below 0.5 IU/mL."
      ],
      "seriesType": "Risk",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "1",
        "seriesPriority": "A",
        "seriesPreference": "1",
        "minAgeToStart": "0 days"
      },
      "indication": [
        {
          "observationCode": {"text": "Rabies researchers", "code": "053"},
          "description": "Administer to rabies researchers",
          "beginAge": "0 days"
        },
        {
          "observationCode": {
            "text": "Persons working in rabies vaccine production facilities",
            "code": "217"
          },
          "description":
              "Administer to persons working in rabies vaccine production facilities",
          "beginAge": "0 days"
        },
        {
          "observationCode": {
            "text":
                "Persons performing testing for rabies in diagnostic laboratories",
            "code": "218"
          },
          "description":
              "Administer to persons performing testing for rabies in diagnostic laboratories",
          "beginAge": "0 days"
        }
      ],
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
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
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
              "minInt": "7 days",
              "earliestRecInt": "7 days"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 3",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "14 days",
              "minInt": "14 days",
              "earliestRecInt": "14 days",
              "latestRecInt": "21 days"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "conditionalSkip": [
            {
              "context": "Evaluation",
              "setLogic": "n/a",
              "set": [
                {
                  "setID": "1",
                  "setDescription":
                      "Target dose can be skipped if 1 or more previous doses have been administered on or after May 6, 2022",
                  "effectiveDate": "2022-05-06",
                  "condition": [
                    {
                      "conditionID": "1",
                      "conditionType": "Vaccine Count By Date",
                      "startDate": "2022-05-06",
                      "doseCount": "0",
                      "doseType": "Valid",
                      "doseCountLogic": "greater than",
                      "vaccineTypes": "18; 90; 175; 176"
                    }
                  ]
                }
              ]
            },
            {
              "context": "Forecast",
              "setLogic": "n/a",
              "set": [
                {
                  "setID": "2",
                  "setDescription":
                      "Target Dose can be skipped on or after May 6, 2022",
                  "effectiveDate": "2022-05-06",
                  "condition": [
                    {
                      "conditionID": "1",
                      "conditionType": "Vaccine Count By Age",
                      "beginAge": "0 days",
                      "doseCount": "0",
                      "doseType": "Valid",
                      "doseCountLogic": "greater than",
                      "vaccineTypes": "18; 90; 175; 176"
                    }
                  ]
                }
              ]
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 4",
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
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "recurringDose": "Yes"
        }
      ]
    },
    {
      "seriesName": "Rabies risk frequent exposure series",
      "targetDisease": "Rabies",
      "vaccineGroup": "Rabies",
      "seriesAdminGuidance": [
        "The 2 year booster should only be given after a rabies antibody titer. The booster should be administered if the titer falls below 0.5 IU/mL."
      ],
      "seriesType": "Risk",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "1",
        "seriesPriority": "B",
        "seriesPreference": "1",
        "minAgeToStart": "0 days"
      },
      "indication": [
        {
          "observationCode": {
            "text": "Persons who frequently handle bats",
            "code": "219"
          },
          "description": "Administer to persons who frequently handle bats.",
          "beginAge": "0 days"
        },
        {
          "observationCode": {
            "text": "Persons who frequently have contact with bats",
            "code": "220"
          },
          "description":
              "Administer to persons who frequently have contact with bats.",
          "beginAge": "0 days"
        },
        {
          "observationCode": {
            "text":
                "Persons who frequently enter high-density bat environments",
            "code": "221"
          },
          "description":
              "Administer to persons who frequently enter high-density bat environments.",
          "beginAge": "0 days"
        },
        {
          "observationCode": {
            "text": "Persons who frequently perform animal necropsies",
            "code": "222"
          },
          "description":
              "Administer to persons who frequently perform animal necropsies.",
          "beginAge": "0 days",
          "guidance":
              "For example, biologists who frequently enter bat roosts or who collect suspected rabies samples."
        }
      ],
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
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
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
              "minInt": "7 days",
              "earliestRecInt": "7 days"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 3",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "14 days",
              "minInt": "14 days",
              "earliestRecInt": "14 days",
              "latestRecInt": "21 days"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "conditionalSkip": [
            {
              "context": "Evaluation",
              "setLogic": "n/a",
              "set": [
                {
                  "setID": "1",
                  "setDescription":
                      "Target dose can be skipped if 1 or more previous doses have been administered on or after May 6, 2022",
                  "effectiveDate": "2022-05-06",
                  "condition": [
                    {
                      "conditionID": "1",
                      "conditionType": "Vaccine Count By Date",
                      "startDate": "2022-05-06",
                      "doseCount": "0",
                      "doseType": "Valid",
                      "doseCountLogic": "greater than",
                      "vaccineTypes": "18; 90; 175; 176"
                    }
                  ]
                }
              ]
            },
            {
              "context": "Forecast",
              "setLogic": "n/a",
              "set": [
                {
                  "setID": "2",
                  "setDescription":
                      "Target Dose can be skipped on or after May 6, 2022",
                  "effectiveDate": "2022-05-06",
                  "condition": [
                    {
                      "conditionID": "1",
                      "conditionType": "Vaccine Count By Age",
                      "beginAge": "0 days",
                      "doseCount": "0",
                      "doseType": "Valid",
                      "doseCountLogic": "greater than",
                      "vaccineTypes": "18; 90; 175; 176"
                    }
                  ]
                }
              ]
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 4",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "2 years",
              "minInt": "2 years",
              "earliestRecInt": "2 years"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "recurringDose": "Yes"
        }
      ]
    },
    {
      "seriesName": "Rabies risk infrequent exposure series",
      "targetDisease": "Rabies",
      "vaccineGroup": "Rabies",
      "seriesAdminGuidance": [
        "For persons who risk for rabies exposure is greater than 3 years, two options are available within the 3 years after primary series.\r 1) a one-time a titer check at 1-3 years after the primary series. A single booster should be administered if the titer is below 0.5 IU/mL.\r 2) preemptively receive a one-time booster on or after day 21 to year 3 after completion of the 2-dose primary series.",
        "For persons who risk for rabies exposure is greater than 3 years, but who have not had a titer or booster within three years can be realigned with ACIP recommendations through a one-time titer and booster if titer is below 0.5 IU/mL. Once boosted, titers should be checked no sooner than 1 week (preferable 2-4 weeks) later to ensure a titer of at least 0.5 UI/mL.",
        "For persons who risk for rabies exposure is less than 3 years (e.g., short-term volunteer providing hands-on animal care or infrequent traveler with no high-risk travel past 3 years), no boosting is recommended."
      ],
      "seriesType": "Risk",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "1",
        "seriesPriority": "C",
        "seriesPreference": "1",
        "minAgeToStart": "0 days"
      },
      "indication": [
        {
          "observationCode": {
            "text":
                "Persons whose activities bring them into frequent contact with rabies virus or potentially rabid animals",
            "code": "062"
          },
          "description":
              "Administer to persons whose activities bring them into frequent contact with rabies virus or potentially rabid animals.",
          "beginAge": "0 days",
          "guidance":
              "Occupational or recreational activities that typically involve contact with animals include 1) veterinarians, technicians, animal control officers, and their students or trainees; 2) persons who handle wildlife reservoir species (e.g., wildlife biologists, rehabilitators, and trappers); and 3) spelunkers"
        },
        {
          "observationCode": {
            "text":
                "International travel with possible contact with animals in areas where rabies is enzootic and immediate access to appropriate medical care might be limited",
            "code": "144"
          },
          "description":
              "Administer to persons with plans for international travel with possible contact with animals in areas where rabies is enzootic and immediate access to appropriate medical care might be limited.",
          "beginAge": "0 days",
          "guidance":
              "PrEP considerations include whether the travelers 1) will be performing occupational or recreational activities that increase risk for exposure to potentially rabid animals (particularly dogs) and 2) might have difficulty getting prompt access to safe PEP (e.g., rural part of a country or far from closest PEP clinic)"
        }
      ],
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
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
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
              "minInt": "7 days",
              "earliestRecInt": "7 days"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 3",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "14 days",
              "minInt": "14 days",
              "earliestRecInt": "14 days",
              "latestRecInt": "21 days"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "conditionalSkip": [
            {
              "context": "Evaluation",
              "setLogic": "n/a",
              "set": [
                {
                  "setID": "1",
                  "setDescription":
                      "Target dose can be skipped if 1 or more previous doses have been administered on or after May 6, 2022",
                  "effectiveDate": "2022-05-06",
                  "condition": [
                    {
                      "conditionID": "1",
                      "conditionType": "Vaccine Count By Date",
                      "startDate": "2022-05-06",
                      "doseCount": "0",
                      "doseType": "Valid",
                      "doseCountLogic": "greater than",
                      "vaccineTypes": "18; 90; 175; 176"
                    }
                  ]
                }
              ]
            },
            {
              "context": "Forecast",
              "setLogic": "n/a",
              "set": [
                {
                  "setID": "2",
                  "setDescription":
                      "Target Dose can be skipped on or after May 6, 2022",
                  "effectiveDate": "2022-05-06",
                  "condition": [
                    {
                      "conditionID": "1",
                      "conditionType": "Vaccine Count By Age",
                      "beginAge": "0 days",
                      "doseCount": "0",
                      "doseType": "Valid",
                      "doseCountLogic": "greater than",
                      "vaccineTypes": "18; 90; 175; 176"
                    }
                  ]
                }
              ]
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 4",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "21 days",
              "minInt": "21 days",
              "earliestRecInt": "21 days",
              "latestRecInt": "3 years"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Rabies, intramuscular injection",
              "cvx": "18",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies, unspecified formulation",
              "cvx": "90",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM Diploid cell culture",
              "cvx": "175",
              "beginAge": "0 days"
            },
            {
              "vaccineType": "Rabies - IM fibroblast culture",
              "cvx": "176",
              "beginAge": "0 days"
            }
          ],
          "recurringDose": "No"
        }
      ]
    }
  ]
});
