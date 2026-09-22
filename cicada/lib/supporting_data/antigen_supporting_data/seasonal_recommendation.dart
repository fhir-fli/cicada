class SeasonalRecommendation {
  SeasonalRecommendation({
    this.startDate,
    this.endDate,
  });

  factory SeasonalRecommendation.fromJson(Map<String, dynamic> json) {
    return SeasonalRecommendation(
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );
  }

  final String? startDate;
  final String? endDate;

  Map<String, dynamic> toJson() {
    return {
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
  }

  bool isEmpty() =>
      (startDate == null || startDate!.isEmpty) &&
      (endDate == null || endDate!.isEmpty);
}
