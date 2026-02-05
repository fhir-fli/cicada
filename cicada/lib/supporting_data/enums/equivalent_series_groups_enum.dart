enum EquivalentSeriesGroups {
  group1,

  group2,

  group3,

  group4,

  group5,

  group6,

  group7,

  group8,

  group9,

  group10,

  none;

  static EquivalentSeriesGroups? fromString(String? string) {
    switch (string) {
      case '1':
        return EquivalentSeriesGroups.group1;
      case '2':
        return EquivalentSeriesGroups.group2;
      case '3':
        return EquivalentSeriesGroups.group3;
      case '4':
        return EquivalentSeriesGroups.group4;
      case '5':
        return EquivalentSeriesGroups.group5;
      case '6':
        return EquivalentSeriesGroups.group6;
      case '7':
        return EquivalentSeriesGroups.group7;
      case '8':
        return EquivalentSeriesGroups.group8;
      case '9':
        return EquivalentSeriesGroups.group9;
      case '10':
        return EquivalentSeriesGroups.group10;
      case '':
        return EquivalentSeriesGroups.none;
      default:
        return null;
    }
  }

  static EquivalentSeriesGroups? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case EquivalentSeriesGroups.group1:
        return '1';
      case EquivalentSeriesGroups.group2:
        return '2';
      case EquivalentSeriesGroups.group3:
        return '3';
      case EquivalentSeriesGroups.group4:
        return '4';
      case EquivalentSeriesGroups.group5:
        return '5';
      case EquivalentSeriesGroups.group6:
        return '6';
      case EquivalentSeriesGroups.group7:
        return '7';
      case EquivalentSeriesGroups.group8:
        return '8';
      case EquivalentSeriesGroups.group9:
        return '9';
      case EquivalentSeriesGroups.group10:
        return '10';
      case EquivalentSeriesGroups.none:
        return '';
    }
  }

  String toJson() => toString();
}
