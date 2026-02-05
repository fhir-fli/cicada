enum ValidAgeReason {
  gracePeriod,

  tooYoung,

  tooOld;

  static ValidAgeReason? fromString(String? string) {
    switch (string?.toString().toLowerCase()) {
      case 'age: grace period':
        return ValidAgeReason.gracePeriod;
      case 'age: too young':
        return ValidAgeReason.tooYoung;
      case 'age: too old':
        return ValidAgeReason.tooOld;
      default:
        return null;
    }
  }

  static ValidAgeReason? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case ValidAgeReason.gracePeriod:
        return 'Age: Grace Period';
      case ValidAgeReason.tooYoung:
        return 'Age: Too Young';
      case ValidAgeReason.tooOld:
        return 'Age: Too Old';
    }
  }

  String toJson() => toString();
}
