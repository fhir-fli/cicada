enum Gender {
  female,

  transgender,

  unknown,

  male;

  static Gender? fromString(String? string) {
    switch (string) {
      case 'Female':
        return Gender.female;
      case 'Transgender':
        return Gender.transgender;
      case 'Unknown':
        return Gender.unknown;
      case 'Male':
        return Gender.male;
      default:
        return null;
    }
  }

  static Gender? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case Gender.female:
        return 'Female';
      case Gender.transgender:
        return 'Transgender';
      case Gender.unknown:
        return 'Unknown';
      case Gender.male:
        return 'Male';
    }
  }

  String toJson() => toString();
}
