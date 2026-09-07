/// One row of the "Vaccine Recommendation Category" worksheet, new in CDSi
/// supporting data 4.65 (CDC, "Vaccine Recommendation Category
/// Determination", 2026). Once the Best Patient Series is known (Logic
/// Specification 8.8), the row whose series, patient age, forecast target
/// dose and indications match names the category: Routine, High-Risk, or
/// SCDM (shared clinical decision making).
///
/// Values are carried exactly as CDC writes them. "n/a" means unbounded or
/// not applicable; [forecastTargetDose] is a dose number, a semicolon list,
/// or "Any"; [includedIndication] and [excludedIndication] are "n/a", "Any",
/// or a semicolon list of "text (code)" indications. The engine does not yet
/// apply these rows; nothing in the forecast reads them.
class VaccineRecommendationCategory {
  VaccineRecommendationCategory({
    this.worksheetName,
    this.seriesName,
    this.patientBeginAge,
    this.patientEndAge,
    this.forecastTargetDose,
    this.includedIndication,
    this.excludedIndication,
    this.category,
    this.additionalMaterial,
  });

  factory VaccineRecommendationCategory.fromJson(Map<String, dynamic> json) =>
      VaccineRecommendationCategory(
        worksheetName: json['worksheetName'] as String?,
        seriesName: json['seriesName'] as String?,
        patientBeginAge: json['patientBeginAge'] as String?,
        patientEndAge: json['patientEndAge'] as String?,
        forecastTargetDose: json['forecastTargetDose'] as String?,
        includedIndication: json['includedIndication'] as String?,
        excludedIndication: json['excludedIndication'] as String?,
        category: json['category'] as String?,
        additionalMaterial: json['additionalMaterial'] as String?,
      );

  /// "Excel Worksheet Name": the series worksheet this row is about.
  final String? worksheetName;

  /// "Best Patient Series Name": cell B1 of that worksheet.
  final String? seriesName;

  /// "Patient Begin Age": lower bound of the patient's current age.
  final String? patientBeginAge;

  /// "Patient End Age (less than)": upper bound of the patient's current age.
  final String? patientEndAge;

  /// "Forecast Target Dose": a dose number, "2; 3; 4", or "Any".
  final String? forecastTargetDose;

  /// "Included Indication": "n/a", "Any", or "text (code); text (code)".
  final String? includedIndication;

  /// "Excluded Indication": "n/a" or "text (code); text (code)".
  final String? excludedIndication;

  /// "Vaccine Recommendation Category": Routine, High-Risk, or SCDM.
  final String? category;

  /// "Additional Material": a URL.
  final String? additionalMaterial;

  Map<String, dynamic> toJson() => {
        if (worksheetName != null) 'worksheetName': worksheetName,
        if (seriesName != null) 'seriesName': seriesName,
        if (patientBeginAge != null) 'patientBeginAge': patientBeginAge,
        if (patientEndAge != null) 'patientEndAge': patientEndAge,
        if (forecastTargetDose != null)
          'forecastTargetDose': forecastTargetDose,
        if (includedIndication != null)
          'includedIndication': includedIndication,
        if (excludedIndication != null)
          'excludedIndication': excludedIndication,
        if (category != null) 'category': category,
        if (additionalMaterial != null)
          'additionalMaterial': additionalMaterial,
      };
}
