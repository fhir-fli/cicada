Resource: ScheduleSupportingData
Id: schedule-supporting-data
Parent: Resource
Title: "Schedule Supporting Data"
Description: "This resource consolidates various mapping and conflict information related to vaccine scheduling to support decision-making processes."

* ^baseDefinition = "http://hl7.org/fhir/StructureDefinition/Element"

// Base element for the liveVirusConflict
* liveVirusConflict 0..1 BackboneElement "Potential conflicts between live virus vaccines based on previous and current vaccinations and the required time intervals to avoid interference."

// Elements within liveVirusConflict
* liveVirusConflict.previous 1..1 BackboneElement "Details about the previous vaccination."
* liveVirusConflict.previous.vaccineType 1..1 string "Type of the previous vaccine."
* liveVirusConflict.previous.cvx 1..1 string "CVX code for the previous vaccine."

* liveVirusConflict.current 1..1 BackboneElement "Details about the current vaccination."
* liveVirusConflict.current.vaccineType 1..1 string "Type of the current vaccine."
* liveVirusConflict.current.cvx 1..1 string "CVX code for the current vaccine."

* liveVirusConflict.conflictBeginInterval 1..1 string "Time interval before which a conflict begins after the previous vaccination."
* liveVirusConflict.minConflictEndInterval 1..1 string "Minimum time interval after which the conflict might end."
* liveVirusConflict.conflictEndInterval 1..1 string "Time interval after which the conflict ends."


* vaccineGroupMap 0..1 BackboneElement "Mapping of vaccine groups to their specific attributes."
* vaccineGroupMap.name 1..1 string "Name of the vaccine group."
* vaccineGroupMap.administerFullVaccineGroup 0..1 boolean "Flag to indicate if the full vaccine group should be administered."

* vaccineGroupToAntigenMap 0..1 BackboneElement "Mapping of vaccine groups to their associated antigens."
* vaccineGroupToAntigenMap.name 0..1 string "The name of the vaccine group."
* vaccineGroupToAntigenMap.antigen 0..* string "List of antigens associated with the vaccine group."

* cvxToAntigenMap 0..1 BackboneElement "Maps CVX Codes to Antigens and Ages."
* cvxToAntigenMap.cvx 0..1 string "CVX Code"
* cvxToAntigenMap.shortDescription 0..1 string "Short Description of this CVX"
* cvxToAntigenMap.association 0..* BackboneElement "A list of associated antigens and ages."
* cvxToAntigenMap.association.antigen 0..1 string "Name of the antigen"
* cvxToAntigenMap.association.associationBeginAge 0..1 string "Starting age, if applicable, when this antigen is associated with this CVX code"
* cvxToAntigenMap.association.associationEndAge 0..1 string "Ending age, if applicable, when this antigen is associated with this CVX code"

* vaccinationObservationMap 0..1 BackboneElement "Describes the observation rules for vaccination based on specific patient conditions."
* vaccinationObservationMap.observationCode 1..1 string "Unique code for the observation."
* vaccinationObservationMap.observationTitle 1..1 string "Title of the observation."
* vaccinationObservationMap.indicationText 0..1 string "Text indicating why the vaccine should be administered."
* vaccinationObservationMap.contraindicationText 0..1 string "Text indicating why the vaccine should not be administered."
* vaccinationObservationMap.clarifyingText 0..1 string "Additional clarifications for the vaccination rule."
* vaccinationObservationMap.codedValues 0..* BackboneElement "List of associated SNOMED or other coded values relevant to the observation."
* vaccinationObservationMap.codedValues.code 1..1 string "Code identifying the condition or observation."
* vaccinationObservationMap.codedValues.codeSystem 1..1 string "The system in which the code is valid (e.g., SNOMED, CDCPHINVS)."
* vaccinationObservationMap.codedValues.text 1..1 string "Human-readable name or description of the code."
