enum IntervalReason {
  tooLate,

  tooShort,

  gracePeriod;

  static IntervalReason? fromString(String? string) {
    switch (string?.toLowerCase()) {
      case 'interval: too late':
        return IntervalReason.tooLate;
      case 'interval: too short':
        return IntervalReason.tooShort;
      case 'interval: grace period':
        return IntervalReason.gracePeriod;
      default:
        return null;
    }
  }

  static IntervalReason? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case IntervalReason.tooLate:
        return 'Interval: too late';
      case IntervalReason.tooShort:
        return 'Interval: too short';
      case IntervalReason.gracePeriod:
        return 'Interval: grace period';
    }
  }

  String toJson() => toString();
}
