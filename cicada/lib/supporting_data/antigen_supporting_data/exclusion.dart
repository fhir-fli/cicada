class Exclusion {
  Exclusion({
    this.exclusionCode,
    this.exclusionTitle,
  });

  final String? exclusionCode;
  final String? exclusionTitle;

  factory Exclusion.fromJson(Map<String, dynamic> json) {
    return Exclusion(
      exclusionCode: json['exclusionCode'] as String?,
      exclusionTitle: json['exclusionTitle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (exclusionCode != null) 'exclusionCode': exclusionCode,
      if (exclusionTitle != null) 'exclusionTitle': exclusionTitle,
    };
  }
}
