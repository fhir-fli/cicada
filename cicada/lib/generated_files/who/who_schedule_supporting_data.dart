// ignore_for_file: prefer_single_quotes, always_specify_types

import '../../cicada.dart';

final whoScheduleSupportingData = ScheduleSupportingData.fromJson(
{
    "liveVirusConflicts": {
        "liveVirusConflict": [
            {
                "previous": {
                    "vaccineType": "OPV, bivalent",
                    "cvx": "178"
                },
                "current": {
                    "vaccineType": "OPV, bivalent",
                    "cvx": "178"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "OPV, bivalent",
                    "cvx": "178"
                },
                "current": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "current": {
                    "vaccineType": "OPV, bivalent",
                    "cvx": "178"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "current": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "current": {
                    "vaccineType": "MMR",
                    "cvx": "03"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "MMR",
                    "cvx": "03"
                },
                "current": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "MMR",
                    "cvx": "03"
                },
                "current": {
                    "vaccineType": "MMR",
                    "cvx": "03"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "Yellow Fever",
                    "cvx": "37"
                },
                "current": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "Measles/Rubella (MR)",
                    "cvx": "04"
                },
                "current": {
                    "vaccineType": "Yellow Fever",
                    "cvx": "37"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "Yellow Fever",
                    "cvx": "37"
                },
                "current": {
                    "vaccineType": "MMR",
                    "cvx": "03"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "MMR",
                    "cvx": "03"
                },
                "current": {
                    "vaccineType": "Yellow Fever",
                    "cvx": "37"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "Rotavirus, monovalent (RV1)",
                    "cvx": "116"
                },
                "current": {
                    "vaccineType": "OPV, bivalent",
                    "cvx": "178"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "OPV, bivalent",
                    "cvx": "178"
                },
                "current": {
                    "vaccineType": "Rotavirus, monovalent (RV1)",
                    "cvx": "116"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            },
            {
                "previous": {
                    "vaccineType": "BCG",
                    "cvx": "19"
                },
                "current": {
                    "vaccineType": "BCG",
                    "cvx": "19"
                },
                "conflictBeginInterval": "1 day",
                "minConflictEndInterval": "24 days",
                "conflictEndInterval": "28 days"
            }
        ]
    },
    "vaccineGroups": {
        "vaccineGroup": [
            {
                "name": "BCG",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "HepB",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "DTP",
                "administerFullVaccineGroup": "Yes"
            },
            {
                "name": "Hib",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Polio",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "MR",
                "administerFullVaccineGroup": "Yes"
            },
            {
                "name": "MMR",
                "administerFullVaccineGroup": "Yes"
            },
            {
                "name": "PCV",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Rotavirus",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "HPV",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "HepA",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Yellow Fever",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "JE",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Meningococcal",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Typhoid",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Cholera",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Rabies",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "Influenza",
                "administerFullVaccineGroup": "No"
            },
            {
                "name": "COVID-19",
                "administerFullVaccineGroup": "No"
            }
        ]
    },
    "vaccineGroupToAntigenMap": {
        "vaccineGroupMap": [
            {
                "name": "BCG",
                "antigen": [
                    "Tuberculosis"
                ]
            },
            {
                "name": "HepB",
                "antigen": [
                    "HepB"
                ]
            },
            {
                "name": "DTP",
                "antigen": [
                    "Diphtheria",
                    "Tetanus",
                    "Pertussis"
                ]
            },
            {
                "name": "Hib",
                "antigen": [
                    "Hib"
                ]
            },
            {
                "name": "Polio",
                "antigen": [
                    "Polio"
                ]
            },
            {
                "name": "MR",
                "antigen": [
                    "Measles",
                    "Rubella"
                ]
            },
            {
                "name": "MMR",
                "antigen": [
                    "Measles",
                    "Mumps",
                    "Rubella"
                ]
            },
            {
                "name": "PCV",
                "antigen": [
                    "Pneumococcal"
                ]
            },
            {
                "name": "Rotavirus",
                "antigen": [
                    "Rotavirus"
                ]
            },
            {
                "name": "HPV",
                "antigen": [
                    "HPV"
                ]
            },
            {
                "name": "HepA",
                "antigen": [
                    "HepA"
                ]
            },
            {
                "name": "Yellow Fever",
                "antigen": [
                    "Yellow Fever"
                ]
            },
            {
                "name": "JE",
                "antigen": [
                    "Japanese Encephalitis"
                ]
            },
            {
                "name": "Meningococcal",
                "antigen": [
                    "Meningococcal"
                ]
            },
            {
                "name": "Typhoid",
                "antigen": [
                    "Typhoid"
                ]
            },
            {
                "name": "Cholera",
                "antigen": [
                    "Cholera"
                ]
            },
            {
                "name": "Rabies",
                "antigen": [
                    "Rabies"
                ]
            },
            {
                "name": "Influenza",
                "antigen": [
                    "Influenza"
                ]
            },
            {
                "name": "COVID-19",
                "antigen": [
                    "COVID-19"
                ]
            }
        ]
    },
    "cvxToAntigenMap": {
        "cvxMap": [
            {
                "cvx": "19",
                "shortDescription": "BCG",
                "association": [
                    {
                        "antigen": "Tuberculosis"
                    }
                ]
            },
            {
                "cvx": "08",
                "shortDescription": "Hep B, adolescent or pediatric",
                "association": [
                    {
                        "antigen": "HepB"
                    }
                ]
            },
            {
                "cvx": "43",
                "shortDescription": "Hep B, adult",
                "association": [
                    {
                        "antigen": "HepB"
                    }
                ]
            },
            {
                "cvx": "45",
                "shortDescription": "Hep B, unspecified",
                "association": [
                    {
                        "antigen": "HepB"
                    }
                ]
            },
            {
                "cvx": "01",
                "shortDescription": "DTP",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    },
                    {
                        "antigen": "Pertussis"
                    }
                ]
            },
            {
                "cvx": "20",
                "shortDescription": "DTaP",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    },
                    {
                        "antigen": "Pertussis"
                    }
                ]
            },
            {
                "cvx": "198",
                "shortDescription": "DTP-HepB-Hib (Pentavalent)",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    },
                    {
                        "antigen": "Pertussis"
                    },
                    {
                        "antigen": "HepB"
                    },
                    {
                        "antigen": "Hib"
                    }
                ]
            },
            {
                "cvx": "51",
                "shortDescription": "Hep B-Hib",
                "association": [
                    {
                        "antigen": "HepB"
                    },
                    {
                        "antigen": "Hib"
                    }
                ]
            },
            {
                "cvx": "120",
                "shortDescription": "DTaP-IPV/Hib",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    },
                    {
                        "antigen": "Pertussis"
                    },
                    {
                        "antigen": "Polio"
                    },
                    {
                        "antigen": "Hib"
                    }
                ]
            },
            {
                "cvx": "130",
                "shortDescription": "DTaP-IPV",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    },
                    {
                        "antigen": "Pertussis"
                    },
                    {
                        "antigen": "Polio"
                    }
                ]
            },
            {
                "cvx": "09",
                "shortDescription": "Td adult",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    }
                ]
            },
            {
                "cvx": "138",
                "shortDescription": "Td, unspecified",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    }
                ]
            },
            {
                "cvx": "115",
                "shortDescription": "Tdap",
                "association": [
                    {
                        "antigen": "Diphtheria"
                    },
                    {
                        "antigen": "Tetanus"
                    },
                    {
                        "antigen": "Pertussis"
                    }
                ]
            },
            {
                "cvx": "35",
                "shortDescription": "TT",
                "association": [
                    {
                        "antigen": "Tetanus"
                    }
                ]
            },
            {
                "cvx": "17",
                "shortDescription": "Hib, unspecified",
                "association": [
                    {
                        "antigen": "Hib"
                    }
                ]
            },
            {
                "cvx": "47",
                "shortDescription": "Hib (HbOC)",
                "association": [
                    {
                        "antigen": "Hib"
                    }
                ]
            },
            {
                "cvx": "48",
                "shortDescription": "Hib (PRP-T)",
                "association": [
                    {
                        "antigen": "Hib"
                    }
                ]
            },
            {
                "cvx": "10",
                "shortDescription": "IPV",
                "association": [
                    {
                        "antigen": "Polio"
                    }
                ]
            },
            {
                "cvx": "02",
                "shortDescription": "OPV, trivalent",
                "association": [
                    {
                        "antigen": "Polio"
                    }
                ]
            },
            {
                "cvx": "178",
                "shortDescription": "OPV, bivalent",
                "association": [
                    {
                        "antigen": "Polio"
                    }
                ]
            },
            {
                "cvx": "89",
                "shortDescription": "Polio, unspecified",
                "association": [
                    {
                        "antigen": "Polio"
                    }
                ]
            },
            {
                "cvx": "03",
                "shortDescription": "MMR",
                "association": [
                    {
                        "antigen": "Measles"
                    },
                    {
                        "antigen": "Mumps"
                    },
                    {
                        "antigen": "Rubella"
                    }
                ]
            },
            {
                "cvx": "04",
                "shortDescription": "Measles/Rubella (MR)",
                "association": [
                    {
                        "antigen": "Measles"
                    },
                    {
                        "antigen": "Rubella"
                    }
                ]
            },
            {
                "cvx": "05",
                "shortDescription": "Measles",
                "association": [
                    {
                        "antigen": "Measles"
                    }
                ]
            },
            {
                "cvx": "06",
                "shortDescription": "Rubella",
                "association": [
                    {
                        "antigen": "Rubella"
                    }
                ]
            },
            {
                "cvx": "07",
                "shortDescription": "Mumps",
                "association": [
                    {
                        "antigen": "Mumps"
                    }
                ]
            },
            {
                "cvx": "94",
                "shortDescription": "MMRV",
                "association": [
                    {
                        "antigen": "Measles"
                    },
                    {
                        "antigen": "Mumps"
                    },
                    {
                        "antigen": "Rubella"
                    }
                ]
            },
            {
                "cvx": "133",
                "shortDescription": "PCV13",
                "association": [
                    {
                        "antigen": "Pneumococcal"
                    }
                ]
            },
            {
                "cvx": "152",
                "shortDescription": "PCV15",
                "association": [
                    {
                        "antigen": "Pneumococcal"
                    }
                ]
            },
            {
                "cvx": "215",
                "shortDescription": "PCV20",
                "association": [
                    {
                        "antigen": "Pneumococcal"
                    }
                ]
            },
            {
                "cvx": "116",
                "shortDescription": "Rotavirus, monovalent (RV1)",
                "association": [
                    {
                        "antigen": "Rotavirus"
                    }
                ]
            },
            {
                "cvx": "119",
                "shortDescription": "Rotavirus, pentavalent (RV5)",
                "association": [
                    {
                        "antigen": "Rotavirus"
                    }
                ]
            },
            {
                "cvx": "122",
                "shortDescription": "Rotavirus, unspecified",
                "association": [
                    {
                        "antigen": "Rotavirus"
                    }
                ]
            },
            {
                "cvx": "165",
                "shortDescription": "HPV, 9-valent",
                "association": [
                    {
                        "antigen": "HPV"
                    }
                ]
            },
            {
                "cvx": "62",
                "shortDescription": "HPV, quadrivalent",
                "association": [
                    {
                        "antigen": "HPV"
                    }
                ]
            },
            {
                "cvx": "118",
                "shortDescription": "HPV, bivalent",
                "association": [
                    {
                        "antigen": "HPV"
                    }
                ]
            },
            {
                "cvx": "83",
                "shortDescription": "HepA, pediatric/adolescent",
                "association": [
                    {
                        "antigen": "HepA"
                    }
                ]
            },
            {
                "cvx": "52",
                "shortDescription": "HepA, adult",
                "association": [
                    {
                        "antigen": "HepA"
                    }
                ]
            },
            {
                "cvx": "104",
                "shortDescription": "HepA-HepB (Twinrix)",
                "association": [
                    {
                        "antigen": "HepA"
                    },
                    {
                        "antigen": "HepB"
                    }
                ]
            },
            {
                "cvx": "37",
                "shortDescription": "Yellow Fever",
                "association": [
                    {
                        "antigen": "Yellow Fever"
                    }
                ]
            },
            {
                "cvx": "134",
                "shortDescription": "JE, inactivated (Ixiaro)",
                "association": [
                    {
                        "antigen": "Japanese Encephalitis"
                    }
                ]
            },
            {
                "cvx": "39",
                "shortDescription": "JE, unspecified",
                "association": [
                    {
                        "antigen": "Japanese Encephalitis"
                    }
                ]
            },
            {
                "cvx": "163",
                "shortDescription": "MenA conjugate (MenAfriVac)",
                "association": [
                    {
                        "antigen": "Meningococcal"
                    }
                ]
            },
            {
                "cvx": "108",
                "shortDescription": "Meningococcal ACWY",
                "association": [
                    {
                        "antigen": "Meningococcal"
                    }
                ]
            },
            {
                "cvx": "114",
                "shortDescription": "Meningococcal ACWY (Menactra)",
                "association": [
                    {
                        "antigen": "Meningococcal"
                    }
                ]
            },
            {
                "cvx": "136",
                "shortDescription": "Meningococcal ACWY (Menveo)",
                "association": [
                    {
                        "antigen": "Meningococcal"
                    }
                ]
            },
            {
                "cvx": "190",
                "shortDescription": "Typhoid conjugate (TCV)",
                "association": [
                    {
                        "antigen": "Typhoid"
                    }
                ]
            },
            {
                "cvx": "101",
                "shortDescription": "Typhoid Vi polysaccharide",
                "association": [
                    {
                        "antigen": "Typhoid"
                    }
                ]
            },
            {
                "cvx": "25",
                "shortDescription": "Typhoid oral (Ty21a)",
                "association": [
                    {
                        "antigen": "Typhoid"
                    }
                ]
            },
            {
                "cvx": "26",
                "shortDescription": "Cholera, oral (BivWC)",
                "association": [
                    {
                        "antigen": "Cholera"
                    }
                ]
            },
            {
                "cvx": "18",
                "shortDescription": "Rabies, IM",
                "association": [
                    {
                        "antigen": "Rabies"
                    }
                ]
            },
            {
                "cvx": "40",
                "shortDescription": "Rabies, ID",
                "association": [
                    {
                        "antigen": "Rabies"
                    }
                ]
            },
            {
                "cvx": "90",
                "shortDescription": "Rabies, unspecified",
                "association": [
                    {
                        "antigen": "Rabies"
                    }
                ]
            },
            {
                "cvx": "150",
                "shortDescription": "Influenza, injectable, quadrivalent",
                "association": [
                    {
                        "antigen": "Influenza"
                    }
                ]
            },
            {
                "cvx": "141",
                "shortDescription": "Influenza, injectable",
                "association": [
                    {
                        "antigen": "Influenza"
                    }
                ]
            },
            {
                "cvx": "149",
                "shortDescription": "Influenza, live intranasal",
                "association": [
                    {
                        "antigen": "Influenza"
                    }
                ]
            },
            {
                "cvx": "208",
                "shortDescription": "COVID-19, mRNA (Pfizer)",
                "association": [
                    {
                        "antigen": "COVID-19"
                    }
                ]
            },
            {
                "cvx": "207",
                "shortDescription": "COVID-19, mRNA (Moderna)",
                "association": [
                    {
                        "antigen": "COVID-19"
                    }
                ]
            },
            {
                "cvx": "212",
                "shortDescription": "COVID-19, viral vector (J&J)",
                "association": [
                    {
                        "antigen": "COVID-19"
                    }
                ]
            },
            {
                "cvx": "211",
                "shortDescription": "COVID-19, protein subunit (Novavax)",
                "association": [
                    {
                        "antigen": "COVID-19"
                    }
                ]
            }
        ]
    },
    "observations": {
        "observation": [
            {
                "observationCode": "1010",
                "observationTitle": "Lives in meningitis belt",
                "indicationText": "Patient lives in the African meningitis belt",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "161152002",
                            "codeSystem": "SNOMED",
                            "text": "Lives in meningitis belt"
                        }
                    ]
                }
            },
            {
                "observationCode": "1011",
                "observationTitle": "Lives in JE endemic area",
                "indicationText": "Patient lives in or is traveling to a Japanese Encephalitis endemic area",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "161152002",
                            "codeSystem": "SNOMED",
                            "text": "Lives in JE endemic area"
                        }
                    ]
                }
            },
            {
                "observationCode": "1012",
                "observationTitle": "Lives in or traveling to YF endemic area",
                "indicationText": "Patient lives in or is traveling to a Yellow Fever endemic area",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "161152002",
                            "codeSystem": "SNOMED",
                            "text": "Lives in or traveling to YF endemic area"
                        }
                    ]
                }
            },
            {
                "observationCode": "1013",
                "observationTitle": "Lives in cholera endemic/outbreak area",
                "indicationText": "Patient lives in or is traveling to a cholera endemic or outbreak area",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "161152002",
                            "codeSystem": "SNOMED",
                            "text": "Lives in cholera endemic/outbreak area"
                        }
                    ]
                }
            },
            {
                "observationCode": "1014",
                "observationTitle": "Lives in typhoid endemic area",
                "indicationText": "Patient lives in or is traveling to a typhoid endemic area",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "161152002",
                            "codeSystem": "SNOMED",
                            "text": "Lives in typhoid endemic area"
                        }
                    ]
                }
            },
            {
                "observationCode": "1015",
                "observationTitle": "High risk of rabies exposure",
                "indicationText": "Patient has high risk of rabies exposure (occupational, animal contact, travel)",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "170497006",
                            "codeSystem": "SNOMED",
                            "text": "High risk of rabies exposure"
                        }
                    ]
                }
            },
            {
                "observationCode": "1070",
                "observationTitle": "Serologic evidence of HepB immunity",
                "indicationText": "Serologic evidence of immunity (anti-HBs ≥10 mIU/mL)",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "365861007",
                            "codeSystem": "SNOMED",
                            "text": "Serologic evidence of HepB immunity"
                        }
                    ]
                }
            },
            {
                "observationCode": "1071",
                "observationTitle": "Laboratory evidence of Measles immunity",
                "indicationText": "Laboratory evidence of immunity for Measles",
                "codedValues": {
                    "codedValue": [
                        {
                            "code": "365861007",
                            "codeSystem": "SNOMED",
                            "text": "Laboratory evidence of Measles immunity"
                        }
                    ]
                }
            }
        ]
    }
});
