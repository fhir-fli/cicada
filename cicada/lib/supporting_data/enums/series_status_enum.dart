enum SeriesStatus {
  notComplete,

  immune,

  contraindicated,

  notRecommended,

  complete,

  agedOut;

  static SeriesStatus? fromString(String? string) {
    switch (string) {
      case 'Not Complete':
        return SeriesStatus.notComplete;
      case 'Immune':
        return SeriesStatus.immune;
      case 'Contraindicated':
        return SeriesStatus.contraindicated;
      case 'Not Recommended':
        return SeriesStatus.notRecommended;
      case 'Complete':
        return SeriesStatus.complete;
      case 'Aged Out':
        return SeriesStatus.agedOut;
      default:
        return null;
    }
  }

  static SeriesStatus? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case SeriesStatus.notComplete:
        return 'Not Complete';
      case SeriesStatus.immune:
        return 'Immune';
      case SeriesStatus.contraindicated:
        return 'Contraindicated';
      case SeriesStatus.notRecommended:
        return 'Not Recommended';
      case SeriesStatus.complete:
        return 'Complete';
      case SeriesStatus.agedOut:
        return 'Aged Out';
    }
  }

  String toJson() => toString();
}
