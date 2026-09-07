ValueSet: ForecastStatusVS
Id: forecast-status
Title: "Forecast Status Value Set"
Description: "Combined value set for immunization forecast status, referencing published standard CodeSystems. Includes ImmDS IG ForecastStatus (CDSi-compatible), HL7 THO immunization-recommendation-status, and LOINC answer list LL940-8."
* ^experimental = false
* include codes from system http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus
* include codes from system http://terminology.hl7.org/CodeSystem/immunization-recommendation-status
* http://loinc.org#LA13421-5 "Complete - all required doses have been received to meet the requirements for a particular vaccine group."
* http://loinc.org#LA13422-3 "On schedule - person is not overdue for a given dose in the series. Includes a person too young to start the series."
* http://loinc.org#LA13423-1 "Overdue - person is late getting the next dose in the series."
* http://loinc.org#LA27183-5 "Immune"
* http://loinc.org#LA4216-3 "Contraindicated"
* http://loinc.org#LA4695-8 "Not Recommended"
* http://loinc.org#LA13424-9 "Too old - cannot complete the series because the latest age for receiving dose has passed."
