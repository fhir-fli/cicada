CodeSystem: IntervalReasonCS
Id: IntervalReason
Title: "Interval Reason"
Description: "This value set includes codes for the reason an interval is considered to be invalid."
* #tooLate "Interval: too late" "Interval: too late"
* #tooShort "Interval: too short" "Interval: too short"
* #gracePeriod "Interval: grace period" "Interval: grace period"

ValueSet: IntervalReasonVS
Id: interval-reason
Title: "Interval Reason"
Description: "This value set includes codes for the reason an interval is considered to be invalid."
* IntervalReason#tooLate "Interval: too late"
* IntervalReason#tooShort "Interval: too short"
* IntervalReason#gracePeriod "Interval: grace period"
