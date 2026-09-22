enum EvalStatus {
  valid,

  notValid,

  extraneous,

  subStandard;

  static EvalStatus? fromString(String? string) {
    switch (string) {
      case 'Valid':
        return EvalStatus.valid;
      case 'Not Valid':
        return EvalStatus.notValid;
      case 'Extraneous':
        return EvalStatus.extraneous;
      case 'Substandard':
        return EvalStatus.subStandard;
      default:
        return null;
    }
  }

  static EvalStatus? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case EvalStatus.valid:
        return 'Valid';
      case EvalStatus.notValid:
        return 'Not Valid';
      case EvalStatus.extraneous:
        return 'Extraneous';
      case EvalStatus.subStandard:
        return 'Substandard';
    }
  }

  String toJson() => toString();
}
