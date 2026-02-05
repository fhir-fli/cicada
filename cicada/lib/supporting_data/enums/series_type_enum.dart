enum SeriesType {
  standard,

  risk,

  evaluationOnly;

  static SeriesType? fromString(String? seriesType) {
    switch (seriesType) {
      case 'Standard':
        return SeriesType.standard;
      case 'Risk':
        return SeriesType.risk;
      case 'Evaluation Only':
        return SeriesType.evaluationOnly;
      default:
        return null;
    }
  }

  static SeriesType? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case SeriesType.standard:
        return 'Standard';
      case SeriesType.risk:
        return 'Risk';
      case SeriesType.evaluationOnly:
        return 'Evaluation Only';
    }
  }

  String toJson() => toString();
}
