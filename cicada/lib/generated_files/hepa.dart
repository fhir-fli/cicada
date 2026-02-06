// ignore_for_file: prefer_single_quotes, always_specify_types

import '../cicada.dart';

final AntigenSupportingData hepa = AntigenSupportingData.fromJson({
  "targetDisease": "HepA",
  "vaccineGroup": "HepA",
  "immunity": {
    "clinicalHistory": [
      {
        "guidelineCode": "018",
        "guidelineTitle":
            "Laboratory Evidence of Immunity or confirmation of Hepatitis A disease"
      }
    ]
  },
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
          "observationCode": "096",
          "observationTitle":
              "Severe allergic reaction after previous dose of Hepatitis A",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Hepatitis A vaccine."
        },
        {
          "observationCode": "107",
          "observationTitle": "Severe allergic reaction to neomycin",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction to neomycin."
        },
        {
          "observationCode": "112",
          "observationTitle": "Hypersensitivity to alum",
          "contraindicationText":
              "Do not vaccinate if the patient has a hypersensitivity to alum."
        }
      ]
    },
    "vaccine": {
      "contraindication": [
        {
          "observationCode": "097",
          "observationTitle":
              "Severe allergic reaction after previous dose of Hepatitis B",
          "contraindicationText":
              "Do not vaccinate if the patient has had a severe allergic reaction after a previous dose of Hepatitis B vaccine.",
          "contraindicatedVaccine": [
            {"vaccineType": "HepA-HepB", "cvx": "104"}
          ]
        },
        {
          "observationCode": "110",
          "observationTitle": "Hypersensitivity to yeast",
          "contraindicationText":
              "Do not vaccinate if the patient has a hypersensitivity to yeast.",
          "contraindicatedVaccine": [
            {"vaccineType": "HepA-HepB", "cvx": "104"}
          ]
        }
      ]
    }
  },
  "series": [
    {
      "seriesName": "HepA 2-dose series",
      "targetDisease": "HepA",
      "vaccineGroup": "HepA",
      "seriesType": "Standard",
      "equivalentSeriesGroups": "2",
      "selectSeries": {
        "defaultSeries": "Yes",
        "productPath": "No",
        "seriesGroupName": "Standard",
        "seriesGroup": "1",
        "seriesPriority": "A",
        "seriesPreference": "1",
        "maxAgeToStart": "19 years"
      },
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "12 months - 4 days",
              "minAge": "12 months",
              "earliestRecAge": "12 months",
              "latestRecAge": "24 months + 4 weeks",
              "maxAge": "19 years"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "19 years",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months",
              "endAge": "19 years",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 2",
          "age": [
            {
              "absMinAge": "18 months - 4 days",
              "minAge": "18 months",
              "earliestRecAge": "18 months"
            }
          ],
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "6 months - 4 days",
              "minInt": "6 months",
              "earliestRecInt": "6 months",
              "latestRecInt": "19 months + 4 weeks"
            }
          ],
          "allowableInterval": {
            "fromPrevious": "N",
            "fromTargetDose": "1",
            "absMinInt": "6 months - 4 days"
          },
          "preferableVaccine": [
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "19 years",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months",
              "endAge": "19 years",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            }
          ],
          "recurringDose": "No"
        }
      ]
    },
    {
      "seriesName": "HepA risk 2-dose series",
      "targetDisease": "HepA",
      "vaccineGroup": "HepA",
      "seriesType": "Risk",
      "equivalentSeriesGroups": "1",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "2",
        "seriesPriority": "A",
        "seriesPreference": "1",
        "minAgeToStart": "19 years"
      },
      "indication": [
        {
          "observationCode": {
            "text": "Patient seeks protection",
            "code": "001"
          },
          "description": "Administer to persons seeking protection.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Chronic liver disease", "code": "015"},
          "description":
              "Administer to persons who have chronic liver disease.",
          "beginAge": "19 years",
          "guidance":
              "includes, but is not limited to persons with hepatitis B virus (HBV) infection, hepatitis C virus (HCV) infection, cirrhosis, fatty liver disease, alcoholic liver disease, autoimmune hepatitis, or an alanine aminotransferase (ALT) or aspartate aminotransferase (AST) level persistently greater than twice the upper limit of normal"
        },
        {
          "observationCode": {
            "text": "Men who have sex with men",
            "code": "036"
          },
          "description": "Administer to men who have sex with men.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Illicit drug use", "code": "040"},
          "description": "Administer to persons who use illicit drugs.",
          "beginAge": "19 years",
          "guidance":
              "includes persons who use injections or non-injection drugs (i.e., all who use illegal drugs)"
        },
        {
          "observationCode": {
            "text":
                "Anticipate close personal contact with international adoptee",
            "code": "044"
          },
          "description":
              "Administer to persons who anticipate close personal contact with an international adoptee during the first 60 days.",
          "beginAge": "19 years",
          "guidance":
              "close personal contact includes but is not limited to household contact, caretaker, or regular babysitter. The first dose of the HepA vaccine series\r should be administered as soon as adoption is planned, ideally 2 or more weeks before the arrival of the adoptee"
        },
        {
          "observationCode": {
            "text": "Occupational exposure for Hepatitis A",
            "code": "059"
          },
          "description":
              "Administer to persons who have an occupational exposure for Hepatitis A",
          "beginAge": "19 years",
          "guidance":
              "Includes persons who work with HAV-infected nonhuman primates or with clinical or nonclinical material containing HAV in a research laboratory setting should be vaccinated. No other occupational groups (e.g., health care providers or food handlers) have been demonstrated to be at increased risk for HAV infection because of occupational exposure"
        },
        {
          "observationCode": {
            "text": "Persons at risk during an outbreak",
            "code": "070"
          },
          "description":
              "Administer to persons identified as at increased risk during a community outbreak attributable to a vaccine serogroup.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Homelessness", "code": "121"},
          "description":
              "Administer to persons who are experiencing homelessness.",
          "beginAge": "19 years",
          "guidance":
              "A homeless person is defined as 1) a person who lacks housing (regardless of whether the person is a member of a family), including a person whose primary residence during the night is a supervised public or private facility (e.g., shelter) that provides temporary living accommodations and a person who is a resident in transitional housing, 2) a person without permanent housing who might live on the streets; or stay in a shelter, mission, single-room occupancy facility, abandoned building, vehicle, or any other unstable or nonpermanent situation, or 3) who is doubled up, a term that refers to a situation where persons are unable to maintain their housing situation and are forced to stay with a series of friends or extended family members. In addition, previously homeless persons who are to be released from a prison or a hospital might be considered homeless if they do not have a stable housing situation to which they can return."
        },
        {
          "observationCode": {
            "text":
                "Travel to or working in countries that have high or intermediate endemicity of Hepatitis A",
            "code": "142"
          },
          "description":
              "Administer to persons traveling to or working in countries that have high or intermediate endemicity of Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - severely immunocompromised",
            "code": "154"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - not severely immunocompromised",
            "code": "155"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "Patient seeks Hepatitis A  protection",
            "code": "175"
          },
          "description":
              "Administer to persons seeking protection from Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text":
                "Persons in settings that provide services to adults with high proportion of those persons have risk factors for HAV infection",
            "code": "185"
          },
          "description":
              "Administer to persons in settings that provider services to adults with high proportion of those persons have risk factors HAV infection",
          "beginAge": "19 years",
          "guidance":
              "Settings in which a high proportion of persons have risk factors for HAV infection include health care settings that focus on persons who use injection or noninjection drugs, as well as group homes and nonresidential day care facilities for persons with developmental disabilities"
        },
        {
          "observationCode": {"text": "HIV Infection", "code": "186"},
          "description": "Administer to persons with HIV Infection",
          "beginAge": "19 years"
        }
      ],
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "12 months - 4 days",
              "minAge": "19 years",
              "earliestRecAge": "19 years"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "19 years",
              "volume": "1",
              "forecastVaccineType": "N"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months",
              "endAge": "19 years",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 2",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "6 months - 4 days",
              "minInt": "6 months",
              "earliestRecInt": "6 months"
            }
          ],
          "allowableInterval": {
            "fromPrevious": "N",
            "fromTargetDose": "1",
            "absMinInt": "6 months - 4 days"
          },
          "preferableVaccine": [
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "19 years",
              "volume": "1",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            }
          ],
          "recurringDose": "No"
        }
      ]
    },
    {
      "seriesName": "HepA risk Twinrix 3-dose series",
      "targetDisease": "HepA",
      "vaccineGroup": "HepA",
      "seriesType": "Risk",
      "equivalentSeriesGroups": "1",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "Yes",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "2",
        "seriesPriority": "A",
        "seriesPreference": "2",
        "minAgeToStart": "19 years"
      },
      "indication": [
        {
          "observationCode": {
            "text": "Patient seeks protection",
            "code": "001"
          },
          "description": "Administer to persons seeking protection.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Chronic liver disease", "code": "015"},
          "description":
              "Administer to persons who have chronic liver disease.",
          "beginAge": "19 years",
          "guidance":
              "includes, but is not limited to persons with hepatitis B virus (HBV) infection, hepatitis C virus (HCV) infection, cirrhosis, fatty liver disease, alcoholic liver disease, autoimmune hepatitis, or an alanine aminotransferase (ALT) or aspartate aminotransferase (AST) level persistently greater than twice the upper limit of normal"
        },
        {
          "observationCode": {
            "text": "Men who have sex with men",
            "code": "036"
          },
          "description": "Administer to men who have sex with men.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Illicit drug use", "code": "040"},
          "description": "Administer to persons who use illicit drugs.",
          "beginAge": "19 years",
          "guidance":
              "includes persons who use injections or non-injection drugs (i.e., all who use illegal drugs)"
        },
        {
          "observationCode": {
            "text":
                "Anticipate close personal contact with international adoptee",
            "code": "044"
          },
          "description":
              "Administer to persons who anticipate close personal contact with an international adoptee during the first 60 days.",
          "beginAge": "19 years",
          "guidance":
              "close personal contact includes but is not limited to household contact, caretaker, or regular babysitter. The first dose of the HepA vaccine series should be administered as soon as adoption is planned, ideally 2 or more weeks before the arrival of the adoptee"
        },
        {
          "observationCode": {
            "text": "Occupational exposure for Hepatitis A",
            "code": "059"
          },
          "description":
              "Administer to persons who have an occupational exposure for Hepatitis A",
          "beginAge": "19 years",
          "guidance":
              "Includes persons who work with HAV-infected nonhuman primates or with clinical or nonclinical material containing HAV in a research laboratory setting should be vaccinated. No other occupational groups (e.g., health care providers or food handlers) have been demonstrated to be at increased risk for HAV infection because of occupational exposure"
        },
        {
          "observationCode": {
            "text": "Persons at risk during an outbreak",
            "code": "070"
          },
          "description":
              "Administer to persons identified as at increased risk during a community outbreak attributable to a vaccine serogroup.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Homelessness", "code": "121"},
          "description":
              "Administer to persons who are experiencing homelessness.",
          "beginAge": "19 years",
          "guidance":
              "A homeless person is defined as 1) a person who lacks housing (regardless of whether the person is a member of a family), including a person whose primary residence during the night is a supervised public or private facility (e.g., shelter) that provides temporary living accommodations and a person who is a resident in transitional housing, 2) a person without permanent housing who might live on the streets; or stay in a shelter, mission, single-room occupancy facility, abandoned building, vehicle, or any other unstable or nonpermanent situation, or 3) who is doubled up, a term that refers to a situation where persons are unable to maintain their housing situation and are forced to stay with a series of friends or extended family members. In addition, previously homeless persons who are to be released from a prison or a hospital might be considered homeless if they do not have a stable housing situation to which they can return."
        },
        {
          "observationCode": {
            "text":
                "Travel to or working in countries that have high or intermediate endemicity of Hepatitis A",
            "code": "142"
          },
          "description":
              "Administer to persons traveling to or working in countries that have high or intermediate endemicity of Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - severely immunocompromised",
            "code": "154"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - not severely immunocompromised",
            "code": "155"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "Patient seeks Hepatitis A  protection",
            "code": "175"
          },
          "description":
              "Administer to persons seeking protection from Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text":
                "Persons in settings that provide services to adults with high proportion of those persons have risk factors for HAV infection",
            "code": "185"
          },
          "description":
              "Administer to persons in settings that provider services to adults with high proportion of those persons have risk factors HAV infection",
          "beginAge": "19 years",
          "guidance":
              "Settings in which a high proportion of persons have risk factors for HAV infection include health care settings that focus on persons who use injection or noninjection drugs, as well as group homes and nonresidential day care facilities for persons with developmental disabilities"
        },
        {
          "observationCode": {"text": "HIV Infection", "code": "186"},
          "description": "Administer to persons with HIV Infection",
          "beginAge": "19 years"
        }
      ],
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "18 years - 4 days",
              "minAge": "19 years",
              "earliestRecAge": "19 years"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 2",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "4 weeks - 4 days",
              "minInt": "4 weeks",
              "earliestRecInt": "4 weeks"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 3",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "5 months - 4 days",
              "minInt": "5 months",
              "earliestRecInt": "5 months"
            },
            {
              "fromPrevious": "N",
              "fromTargetDose": "1",
              "absMinInt": "6 months - 4 days",
              "minInt": "6 months",
              "earliestRecInt": "6 months"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        }
      ]
    },
    {
      "seriesName": "HepA risk Twinrix secondary 3-dose series",
      "targetDisease": "HepA",
      "vaccineGroup": "HepA",
      "seriesType": "Risk",
      "equivalentSeriesGroups": "1",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "2",
        "seriesPriority": "A",
        "seriesPreference": "3",
        "minAgeToStart": "19 years"
      },
      "indication": [
        {
          "observationCode": {
            "text": "Patient seeks protection",
            "code": "001"
          },
          "description": "Administer to persons seeking protection.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Chronic liver disease", "code": "015"},
          "description":
              "Administer to persons who have chronic liver disease.",
          "beginAge": "19 years",
          "guidance":
              "Includes, but is not limited to persons with hepatitis B virus (HBV) infection, hepatitis C virus (HCV) infection, cirrhosis, fatty liver disease, alcoholic liver disease, autoimmune hepatitis, or an alanine aminotransferase (ALT) or aspartate aminotransferase (AST) level persistently greater than twice the upper limit of normal"
        },
        {
          "observationCode": {
            "text": "Men who have sex with men",
            "code": "036"
          },
          "description": "Administer to men who have sex with men.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Illicit drug use", "code": "040"},
          "description": "Administer to persons who use illicit drugs.",
          "beginAge": "19 years",
          "guidance":
              "includes persons who use injections or non-injection drugs (i.e., all who use illegal drugs)"
        },
        {
          "observationCode": {
            "text":
                "Anticipate close personal contact with international adoptee",
            "code": "044"
          },
          "description":
              "Administer to persons who anticipate close personal contact with an international adoptee during the first 60 days.",
          "beginAge": "19 years",
          "guidance":
              "close personal contact includes but is not limited to household contact, caretaker, or regular babysitter. The first dose of the HepA vaccine series should be administered as soon as adoption is planned, ideally 2 or more weeks before the arrival of the adoptee"
        },
        {
          "observationCode": {
            "text": "Occupational exposure for Hepatitis A",
            "code": "059"
          },
          "description":
              "Administer to persons who have an occupational exposure for Hepatitis A",
          "beginAge": "19 years",
          "guidance":
              "Includes persons who work with HAV-infected nonhuman primates or with clinical or nonclinical material containing HAV in a research laboratory setting should be vaccinated. No other occupational groups (e.g., health care providers or food handlers) have been demonstrated to be at increased risk for HAV infection because of occupational exposure"
        },
        {
          "observationCode": {
            "text": "Persons at risk during an outbreak",
            "code": "070"
          },
          "description":
              "Administer to persons identified as at increased risk during a community outbreak attributable to a vaccine serogroup.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Homelessness", "code": "121"},
          "description":
              "Administer to persons who are experiencing homelessness.",
          "beginAge": "19 years",
          "guidance":
              "A homeless person is defined as 1) a person who lacks housing (regardless of whether the person is a member of a family), including a person whose primary residence during the night is a supervised public or private facility (e.g., shelter) that provides temporary living accommodations and a person who is a resident in transitional housing, 2) a person without permanent housing who might live on the streets; or stay in a shelter, mission, single-room occupancy facility, abandoned building, vehicle, or any other unstable or nonpermanent situation, or 3) who is doubled up, a term that refers to a situation where persons are unable to maintain their housing situation and are forced to stay with a series of friends or extended family members. In addition, previously homeless persons who are to be released from a prison or a hospital might be considered homeless if they do not have a stable housing situation to which they can return."
        },
        {
          "observationCode": {
            "text":
                "Travel to or working in countries that have high or intermediate endemicity of Hepatitis A",
            "code": "142"
          },
          "description":
              "Administer to persons traveling to or working in countries that have high or intermediate endemicity of Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - severely immunocompromised",
            "code": "154"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - not severely immunocompromised",
            "code": "155"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "Patient seeks Hepatitis A  protection",
            "code": "175"
          },
          "description":
              "Administer to persons seeking protection from Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text":
                "Persons in settings that provide services to adults with high proportion of those persons have risk factors for HAV infection",
            "code": "185"
          },
          "description":
              "Administer to persons in settings that provider services to adults with high proportion of those persons have risk factors HAV infection",
          "beginAge": "19 years",
          "guidance":
              "Settings in which a high proportion of persons have risk factors for HAV infection include health care settings that focus on persons who use injection or noninjection drugs, as well as group homes and nonresidential day care facilities for persons with developmental disabilities"
        },
        {
          "observationCode": {"text": "HIV Infection", "code": "186"},
          "description": "Administer to persons with HIV Infection",
          "beginAge": "19 years"
        }
      ],
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "12 months - 4 days",
              "minAge": "19 years",
              "earliestRecAge": "19 years"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 2",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "4 weeks - 4 days",
              "minInt": "4 weeks",
              "earliestRecInt": "4 weeks"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 3",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "5 months - 4 days",
              "minInt": "5 months",
              "earliestRecInt": "5 months"
            },
            {
              "fromPrevious": "N",
              "fromTargetDose": "1",
              "absMinInt": "6 months - 4 days",
              "minInt": "6 months",
              "earliestRecInt": "6 months"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        }
      ]
    },
    {
      "seriesName": "HepA risk Twinrix tertiary 3-dose series",
      "targetDisease": "HepA",
      "vaccineGroup": "HepA",
      "seriesType": "Evaluation Only",
      "equivalentSeriesGroups": "1",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "2",
        "seriesPriority": "A",
        "seriesPreference": "4",
        "minAgeToStart": "19 years"
      },
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "18 years - 4 days",
              "minAge": "19 years",
              "earliestRecAge": "19 years"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 2",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "4 weeks - 4 days",
              "minInt": "4 weeks",
              "earliestRecInt": "4 weeks"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 3",
          "interval": [
            {
              "fromPrevious": "Y",
              "absMinInt": "5 months - 4 days",
              "minInt": "5 months",
              "earliestRecInt": "5 months"
            },
            {
              "fromPrevious": "N",
              "fromTargetDose": "1",
              "absMinInt": "6 months - 4 days",
              "minInt": "6 months",
              "earliestRecInt": "6 months"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        }
      ]
    },
    {
      "seriesName": "HepA risk Twinrix 4 dose Series",
      "targetDisease": "HepA",
      "vaccineGroup": "HepA",
      "seriesType": "Risk",
      "equivalentSeriesGroups": "1",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "Yes",
        "seriesGroupName": "Increased Risk",
        "seriesGroup": "2",
        "seriesPriority": "A",
        "seriesPreference": "5",
        "minAgeToStart": "19 years"
      },
      "indication": [
        {
          "observationCode": {
            "text": "Patient seeks protection",
            "code": "001"
          },
          "description": "Administer to persons seeking protection.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Chronic liver disease", "code": "015"},
          "description":
              "Administer to persons who have chronic liver disease.",
          "beginAge": "19 years",
          "guidance":
              "includes, but is not limited to persons with hepatitis B virus (HBV) infection, hepatitis C virus (HCV) infection, cirrhosis, fatty liver disease, alcoholic liver disease, autoimmune hepatitis, or an alanine aminotransferase (ALT) or aspartate aminotransferase (AST) level persistently greater than twice the upper limit of normal"
        },
        {
          "observationCode": {
            "text": "Men who have sex with men",
            "code": "036"
          },
          "description": "Administer to men who have sex with men.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Illicit drug use", "code": "040"},
          "description": "Administer to persons who use illicit drugs.",
          "beginAge": "19 years",
          "guidance":
              "includes persons who use injections or non-injection drugs (i.e., all who use illegal drugs)"
        },
        {
          "observationCode": {
            "text":
                "Anticipate close personal contact with international adoptee",
            "code": "044"
          },
          "description":
              "Administer to persons who anticipate close personal contact with an international adoptee during the first 60 days.",
          "beginAge": "19 years",
          "guidance":
              "close personal contact includes but is not limited to \r household contact, caretaker, or regular babysitter. The first dose of the HepA vaccine series\r should be administered as soon as adoption is planned, ideally 2 or more weeks before the arrival of the adoptee"
        },
        {
          "observationCode": {
            "text": "Occupational exposure for Hepatitis A",
            "code": "059"
          },
          "description":
              "Administer to persons who have an occupational exposure for Hepatitis A",
          "beginAge": "19 years",
          "guidance":
              "Includes persons who work with HAV-infected nonhuman primates or with clinical or nonclinical material containing HAV in a research laboratory setting should be vaccinated. No other occupational groups (e.g., health care providers or food handlers) have been demonstrated to be at increased risk for HAV infection because of occupational exposure"
        },
        {
          "observationCode": {
            "text": "Persons at risk during an outbreak",
            "code": "070"
          },
          "description":
              "Administer to persons identified as at increased risk during a community outbreak attributable to a vaccine serogroup.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {"text": "Homelessness", "code": "121"},
          "description":
              "Administer to persons who are experiencing homelessness.",
          "beginAge": "19 years",
          "guidance":
              "A homeless person is defined as 1) a person who lacks housing (regardless of whether the person is a member of a family), including a person whose primary residence during the night is a supervised public or private facility (e.g., shelter) that provides temporary living accommodations and a person who is a resident in transitional housing, 2) a person without permanent housing who might live on the streets; or stay in a shelter, mission, single-room occupancy facility, abandoned building, vehicle, or any other unstable or nonpermanent situation, or 3) who is doubled up, a term that refers to a situation where persons are unable to maintain their housing situation and are forced to stay with a series of friends or extended family members. In addition, previously homeless persons who are to be released from a prison or a hospital might be considered homeless if they do not have a stable housing situation to which they can return."
        },
        {
          "observationCode": {
            "text":
                "Travel to or working in countries that have high or intermediate endemicity of Hepatitis A",
            "code": "142"
          },
          "description":
              "Administer to persons traveling to or working in countries that have high or intermediate endemicity of Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - severely immunocompromised",
            "code": "154"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "HIV/AIDS - not severely immunocompromised",
            "code": "155"
          },
          "description":
              "Administer to persons who have HIV/AIDS and are not severely immunocompromised [See the CDC general recommendations for a definition of \"severely immunocompromised\"].",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text": "Patient seeks Hepatitis A  protection",
            "code": "175"
          },
          "description":
              "Administer to persons seeking protection from Hepatitis A.",
          "beginAge": "19 years"
        },
        {
          "observationCode": {
            "text":
                "Persons in settings that provide services to adults with high proportion of those persons have risk factors for HAV infection",
            "code": "185"
          },
          "description":
              "Administer to persons in settings that provider services to adults with high proportion of those persons have risk factors HAV infection",
          "beginAge": "19 years",
          "guidance":
              "Settings in which a high proportion of persons have risk factors for HAV infection include health care settings that focus on persons who use injection or noninjection drugs, as well as group homes and nonresidential day care facilities for persons with developmental disabilities"
        },
        {
          "observationCode": {"text": "HIV Infection", "code": "186"},
          "description": "Administer to persons with HIV Infection",
          "beginAge": "19 years"
        }
      ],
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "18 years - 4 days",
              "minAge": "19 years",
              "earliestRecAge": "19 years"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
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
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
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
              "latestRecInt": "23 days"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        },
        {
          "doseNumber": "Dose 4",
          "interval": [
            {
              "fromPrevious": "N",
              "fromTargetDose": "1",
              "absMinInt": "12 months - 4 days",
              "minInt": "12 months",
              "earliestRecInt": "12 months"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years",
              "volume": "1",
              "forecastVaccineType": "Y"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "12 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "12 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "18 years - 4 days"
            }
          ],
          "recurringDose": "No"
        }
      ]
    },
    {
      "seriesName": "HepA risk 1-dose series",
      "targetDisease": "HepA",
      "vaccineGroup": "HepA",
      "seriesType": "Risk",
      "selectSeries": {
        "defaultSeries": "No",
        "productPath": "No",
        "seriesGroupName": "Increased Risk - Pediatric Travel",
        "seriesGroup": "3",
        "seriesPriority": "A",
        "seriesPreference": "1",
        "minAgeToStart": "6 months",
        "maxAgeToStart": "12 months"
      },
      "indication": [
        {
          "observationCode": {
            "text": "Travelling Internationally",
            "code": "048"
          },
          "description":
              "Administer to persons who will be travelling internationally.",
          "beginAge": "6 months",
          "endAge": "12 months"
        }
      ],
      "seriesDose": [
        {
          "doseNumber": "Dose 1",
          "age": [
            {
              "absMinAge": "6 months - 4 days",
              "minAge": "6 months",
              "earliestRecAge": "6 months",
              "latestRecAge": "12 months",
              "maxAge": "12 months"
            }
          ],
          "preferableVaccine": [
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "6 months",
              "endAge": "19 years",
              "volume": "0.5",
              "forecastVaccineType": "N"
            }
          ],
          "allowableVaccine": [
            {
              "vaccineType": "Hep A, pediatric, Unspecified",
              "cvx": "31",
              "beginAge": "6 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, adult",
              "cvx": "52",
              "beginAge": "6 months - 4 days"
            },
            {
              "vaccineType": "Hep A, ped/adol, 2 dose",
              "cvx": "83",
              "beginAge": "6 months - 4 days",
              "endAge": "19 years"
            },
            {
              "vaccineType": "Hep A, Unspecified",
              "cvx": "85",
              "beginAge": "6 months - 4 days"
            },
            {
              "vaccineType": "HepA-HepB",
              "cvx": "104",
              "beginAge": "6 months - 4 days"
            }
          ],
          "recurringDose": "No"
        }
      ]
    }
  ]
});
