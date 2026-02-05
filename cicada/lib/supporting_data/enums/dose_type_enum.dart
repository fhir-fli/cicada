enum DoseType {
  total,

  valid,

  none;

  static DoseType? fromString(String? string) {
    switch (string) {
      case 'total':
      case 'Total':
        return DoseType.total;
      case 'valid':
      case 'Valid':
        return DoseType.valid;
      case '':
        return DoseType.none;
      default:
        return null;
    }
  }

  static DoseType? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case DoseType.total:
        return 'Total';
      case DoseType.valid:
        return 'Valid';
      case DoseType.none:
        return '';
    }
  }

  String toJson() => toString();
}
