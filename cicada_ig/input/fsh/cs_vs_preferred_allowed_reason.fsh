CodeSystem: PreferredAllowedReasonCS
Id: PreferredAllowedReason
Title: "Reasons why certain doses are Preferred or Allowed doses"
Description: "Reasons why certain doses are Preferred or Allowed doses"
* ^experimental = false
* ^caseSensitive = true
* #notAPreferableOrAllowableVaccine "Not a preferable or allowable vaccine" "Not a preferable or allowable vaccine"
* #wrongTradeName "Wrong trade name" "Wrong trade name"
* #lessThanRecommendedVolume "Less than recommended volume" "Less than recommended volume"
* #administeredOutsideOfPreferredAgeRange "Administered outside of preferred age range" "Administered outside of preferred age range"
* #administeredBeforeAllowableAgeRange "Administered before allowable age range" "Allowable vaccine type given before its allowable begin age (Logic Specification v4.6 Table 6-29, third rule)"
* #administeredAfterAllowableAgeRange "Administered after allowable age range" "Allowable vaccine type given on or after its allowable end age (Logic Specification v4.6 Table 6-29, third rule)"
* #noPreferredTypes "No preferred types" "No preferred types"
* #noAllowedTypes "No allowed types" "No allowed types"

ValueSet: PreferredAllowedReasonVS
Id: preferred-allowed-reason
Title: "Reasons why certain doses are Preferred or Allowed doses"
Description: "Reasons why certain doses are Preferred or Allowed doses"
* ^experimental = false
* PreferredAllowedReason#notAPreferableOrAllowableVaccine "Not a preferable or allowable vaccine"
* PreferredAllowedReason#wrongTradeName "Wrong trade name"
* PreferredAllowedReason#lessThanRecommendedVolume "Less than recommended volume"
* PreferredAllowedReason#administeredOutsideOfPreferredAgeRange "Administered outside of preferred age range"
* PreferredAllowedReason#administeredBeforeAllowableAgeRange "Administered before allowable age range"
* PreferredAllowedReason#administeredAfterAllowableAgeRange "Administered after allowable age range"
* PreferredAllowedReason#noPreferredTypes "No preferred types"
* PreferredAllowedReason#noAllowedTypes "No allowed types"
