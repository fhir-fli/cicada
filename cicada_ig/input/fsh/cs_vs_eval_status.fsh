CodeSystem: EvalStatusCS
Id: EvalStatus
Title: "Cicada Evaluation Status"
Description: "Extension codes for dose evaluation status beyond the HL7 THO immunization-evaluation-dose-status CodeSystem. Only codes not covered by the standard are defined here."
* #extraneous "Extraneous" "The dose was administered after the series was already complete. Every administered dose must be reported, so extraneous doses are tracked but do not affect the forecast."

ValueSet: EvalStatusVS
Id: eval-status
Title: "Evaluation Status Value Set"
Description: "Combined value set for dose evaluation status, including HL7 THO standard codes (valid, notvalid) and the Cicada extension code (extraneous)."
* include codes from system http://terminology.hl7.org/CodeSystem/immunization-evaluation-dose-status
* include EvalStatus#extraneous "Extraneous"
