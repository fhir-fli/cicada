class SeasonalRecommendation {
  SeasonalRecommendation({
    this.startDate,
    this.endDate,
  });

  final String? startDate;
  final String? endDate;

  factory SeasonalRecommendation.fromJson(Map<String, dynamic> json) {
    return SeasonalRecommendation(
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );
  }

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
