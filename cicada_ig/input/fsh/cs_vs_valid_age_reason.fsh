// Define CodeSystems for various aspects of VaxDose
CodeSystem: ValidAgeReasonCS
Id: ValidAgeReason
Title: "Valid Age Reason"
Description: "Value set for reasons why a patient's age is considered valid/invalid for a vaccine."
* #gracePeriod "Age: Grace Period" "Age: Grace Period"
* #tooYoung "Age: Too Young" "Age: Too Young"
* #tooOld "Age: Too Old" "Age: Too Old"

ValueSet: ValidAgeReasonVS
Id: valid-age-reason
Title: "Valid Age Reason"
Description: "Value set for reasons why a patient's age is considered valid/invalid for a vaccine."
* ValidAgeReason#gracePeriod "Age: Grace Period"
* ValidAgeReason#tooYoung "Age: Too Young"
* ValidAgeReason#tooOld "Age: Too Old"