class ClinicalHistory {
  ClinicalHistory({
    this.guidelineCode,
    this.guidelineTitle,
  });

  String? guidelineCode;
  String? guidelineTitle;

  factory ClinicalHistory.fromJson(Map<String, dynamic> json) {
    return ClinicalHistory(
      guidelineCode: json['guidelineCode'] as String?,
      guidelineTitle: json['guidelineTitle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (guidelineCode != null) 'guidelineCode': guidelineCode,
      if (guidelineTitle != null) 'guidelineTitle': guidelineTitle,
    };
  }
}
