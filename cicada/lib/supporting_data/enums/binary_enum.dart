enum Binary {
  yes,

  no,

  na;

  static Binary? fromString(String? string) {
    switch (string) {
      case 'Yes':
        return Binary.yes;
      case 'No':
        return Binary.no;
      case '':
        return Binary.na;
      default:
        return null;
    }
  }

  static Binary? fromJson(Object? json) =>
      json is String? ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case Binary.yes:
        return 'Yes';
      case Binary.no:
        return 'No';
      case Binary.na:
        return '';
    }
  }

  String toJson() => toString();
}
