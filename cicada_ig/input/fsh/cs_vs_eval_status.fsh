CodeSystem: EvalStatusCS
Id: EvalStatus
Title: "Evaluation Status"
Description: "The status of the result of an evaluation."
* #valid "Valid" "Valid"
* #not_valid "Not Valid" "Not Valid"
* #extraneous "Extraneous" "Extraneous"
* #sub_standard "Substandard" "Substandard"

ValueSet: EvalStatusVS
Id: eval-status
Title: "Evaluation Status Value Set"
Description: "Value Set for the status of the result of an evaluation."
* EvalStatus#valid "Valid"
* EvalStatus#not_valid "Not Valid"
* EvalStatus#extraneous "Extraneous"
* EvalStatus#sub_standard "Substandard"
