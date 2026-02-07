import 'package:fhir_r4/fhir_r4.dart';

class VaxDate extends DateTime {
  VaxDate(super.year, super.month, super.day);

  // Now and boundary dates constructors
  VaxDate.now() : super.now();
  VaxDate.min() : super(1900, 1, 1);
  VaxDate.max() : super(2999, 12, 31);

  VaxDate.fromDateTime(DateTime dateTime)
      : super(dateTime.year, dateTime.month, dateTime.day);

  VaxDate.fromNullableDateTime(DateTime? dateTime, bool useMax)
      : super(
            dateTime?.year ?? (useMax ? 2999 : 1900),
            dateTime?.month ?? (useMax ? 12 : 1),
            dateTime?.day ?? (useMax ? 31 : 1));

  // Constructors for creating VaxDate with maximum or minimum values based on a string input
  VaxDate.fromString(String date, [bool useMax = false])
      : this._fromParsed(_parseDate(date, useMax));

  VaxDate._fromParsed(VaxDate parsed) : super(parsed.year, parsed.month, parsed.day);

  static VaxDate _parseDate(String date, bool useMax) {
    final dt = DateTime.tryParse(date);
    if (dt != null) return VaxDate(dt.year, dt.month, dt.day);
    return fromYYYYMMDD(date, useMax);
  }

  // JSON constructor with format validation and error handling
  VaxDate.fromJson(String date)
      : this.fromDateTime(DateTime.tryParse(date) ?? fromYYYYMMDD(date));

  // Creating a VaxDate from a nullable string with default min or max dates
  VaxDate.fromNullableString(String? date, [bool useMax = false])
      : this.fromString(date ?? (useMax ? '2999-12-31' : '1900-01-01'), useMax);

  static VaxDate fromYYYYMMDD(String date, [bool useMax = false]) {
    List<String> parts = date.split('/');
    if (parts.length != 3) {
      parts = date.split('-');
    }
    if (parts.length == 3) {
      // Detect MM/DD/YYYY vs YYYY/MM/DD by first part length
      if (parts[0].length <= 2) {
        // MM/DD/YYYY format
        final int month = int.tryParse(parts[0]) ?? (useMax ? 12 : 1);
        final int day = int.tryParse(parts[1]) ?? (useMax ? 31 : 1);
        final int year = int.tryParse(parts[2]) ?? (useMax ? 2999 : 1900);
        return VaxDate(year, month, day);
      } else {
        // YYYY/MM/DD format
        final int year = int.tryParse(parts[0]) ?? (useMax ? 2999 : 1900);
        final int month = int.tryParse(parts[1]) ?? (useMax ? 12 : 1);
        final int day = int.tryParse(parts[2]) ?? (useMax ? 31 : 1);
        return VaxDate(year, month, day);
      }
    } else if (parts.length == 2) {
      final int year = int.tryParse(parts[0]) ?? (useMax ? 2999 : 1900);
      final int month = int.tryParse(parts[1]) ?? (useMax ? 12 : 1);
      return VaxDate(year, month, useMax ? 31 : 1);
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      final int year = int.tryParse(parts[0]) ?? (useMax ? 2999 : 1900);
      return VaxDate(year, useMax ? 12 : 1, useMax ? 31 : 1);
    } else {
      return useMax ? VaxDate.max() : VaxDate.min();
    }
  }

  // Overriding toString and toJson methods
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
  String toJson() => toString();

  // Conversion to DateTime and FHIR types
  DateTime toDateTime() => DateTime(year, month, day);
  FhirDateTime toFhirDateTime() => FhirDateTime.fromDateTime(toDateTime());
  FhirDate toFhirDate() => FhirDate.fromDateTime(toDateTime());

  // Operators for comparison
  bool operator <(VaxDate other) => toDateTime().isBefore(other.toDateTime());
  bool operator >(VaxDate other) => toDateTime().isAfter(other.toDateTime());
  bool operator <=(VaxDate other) => !(this > other);
  bool operator >=(VaxDate other) => !(this < other);
  bool isEqualTo(VaxDate other) =>
      toDateTime().isAtSameMomentAs(other.toDateTime());

  // Method for modifying date with textual descriptions of changes
  VaxDate change(String description) {
    int years = 0, months = 0, days = 0;
    int sign = 1; // Positive by default
    final List<String> parts = description.split(' ');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i] == '-' || parts[i] == '+') {
        sign = (parts[i] == '-') ? -1 : 1;
        continue; // Adjust sign and skip to next part
      }

      if (i < parts.length - 1 && int.tryParse(parts[i]) != null) {
        final int value = int.parse(parts[i]) * sign;
        final String unit = parts[i + 1].toLowerCase();

        if (unit.contains('year')) {
          years += value;
        } else if (unit.contains('month')) {
          months += value;
        } else if (unit.contains('day') || unit.contains('week')) {
          final int multiplier = unit.contains('week') ? 7 : 1;
          days += value * multiplier;
        }

        i++; // Move past the unit
      }
    }

    // Apply the changes in the specified order: years, months, then days
    DateTime newDate = DateTime(year + years, month + months, day);
    // Correct for day overflow (e.g., September 31 -> October 1)
    newDate = DateTime(
        newDate.year,
        newDate.month + (newDate.day < day ? 1 : 0),
        newDate.day < day ? 1 : newDate.day + days);

    return VaxDate.fromDateTime(newDate);
  }

  VaxDate changeNullableOrElse(String? description, VaxDate orElse) {
    if (description == null) {
      return orElse;
    } else {
      return change(description);
    }
  }

  VaxDate? changeNullable(String? description, [bool? useMax]) {
    if (description == null) {
      return useMax ?? false
          ? VaxDate.max()
          : (useMax == false ? VaxDate.min() : null);
    }

    int years = 0, months = 0, days = 0;
    int sign = 1; // Positive by default
    final List<String> parts = description.split(' ');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i] == '-' || parts[i] == '+') {
        sign = (parts[i] == '-') ? -1 : 1;
        continue; // Adjust sign and skip to next part
      }

      if (i < parts.length - 1 && int.tryParse(parts[i]) != null) {
        final int value = int.parse(parts[i]) * sign;
        final String unit = parts[i + 1].toLowerCase();

        if (unit.contains('year')) {
          years += value;
        } else if (unit.contains('month')) {
          months += value;
        } else if (unit.contains('day') || unit.contains('week')) {
          final int multiplier = unit.contains('week') ? 7 : 1;
          days += value * multiplier;
        }

        i++; // Move past the unit
      }
    }

    // Apply the changes in the specified order: years, months, then days
    DateTime newDate = DateTime(year + years, month + months, day);
    // Correct for day overflow (e.g., September 31 -> October 1)
    newDate = DateTime(
        newDate.year,
        newDate.month + (newDate.day < day ? 1 : 0),
        newDate.day < day ? 1 : newDate.day + days);

    return VaxDate.fromDateTime(newDate);
  }
}

// Utility functions for finding the latest and earliest dates in a list
VaxDate latestOf(List<VaxDate> dates) =>
    dates.reduce((VaxDate a, VaxDate b) => a > b ? a : b);
VaxDate earliestOf(List<VaxDate> dates) =>
    dates.reduce((VaxDate a, VaxDate b) => a < b ? a : b);
