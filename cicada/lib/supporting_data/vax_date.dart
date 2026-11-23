import 'package:fhir_r4/fhir_r4.dart';

/// A calendar date (CDSi dates have no time of day).
///
/// Held as a UTC DateTime so that reading its year, month and day, and
/// building one, never asks the system for a time-zone offset; as a local
/// DateTime those lookups were 68% of the engine's time after comparisons
/// stopped building DateTimes (VM profiler, 2026-11-23). The calendar
/// fields are the ones the caller gave, whatever its own zone.
class VaxDate extends DateTime {
  VaxDate(super.year, super.month, super.day) : super.utc();

  // JSON constructor with format validation and error handling
  VaxDate.fromJson(String date)
    : this.fromDateTime(
        DateTime.tryParse(date) ?? VaxDate.fromYYYYMMDD(date),
      );

  // Creating a VaxDate from a nullable string with default min or max dates
  VaxDate.fromNullableString(String? date, [bool useMax = false])
    : this.fromString(date ?? (useMax ? '2999-12-31' : '1900-01-01'), useMax);

  // Now and boundary dates constructors
  /// Today's date where the engine runs.
  VaxDate.now() : this.fromDateTime(DateTime.now());
  VaxDate.min() : super.utc(1900);
  VaxDate.max() : super.utc(2999, 12, 31);

  VaxDate.fromDateTime(DateTime dateTime)
    : super.utc(dateTime.year, dateTime.month, dateTime.day);

  VaxDate.fromNullableDateTime(DateTime? dateTime, bool useMax)
    : super.utc(
        dateTime?.year ?? (useMax ? 2999 : 1900),
        dateTime?.month ?? (useMax ? 12 : 1),
        dateTime?.day ?? (useMax ? 31 : 1),
      );

  // Constructors for creating VaxDate with maximum or minimum values based on
  // a string input
  VaxDate.fromString(String date, [bool useMax = false])
    : this._fromParsed(VaxDate._parse(date, useMax));

  VaxDate._fromParsed(VaxDate parsed)
    : super.utc(parsed.year, parsed.month, parsed.day);

  factory VaxDate._parse(String date, bool useMax) {
    final m = _plainDate.firstMatch(date);
    if (m != null) {
      return VaxDate(
        int.parse(m.group(1)!),
        int.parse(m.group(2)!),
        int.parse(m.group(3)!),
      );
    }
    final dt = DateTime.tryParse(date);
    if (dt != null) return VaxDate(dt.year, dt.month, dt.day);
    return VaxDate.fromYYYYMMDD(date, useMax);
  }

  factory VaxDate.fromYYYYMMDD(String date, [bool useMax = false]) {
    var parts = date.split('/');
    if (parts.length != 3) {
      parts = date.split('-');
    }
    if (parts.length == 3) {
      // Detect MM/DD/YYYY vs YYYY/MM/DD by first part length
      if (parts[0].length <= 2) {
        // MM/DD/YYYY format
        final month = int.tryParse(parts[0]) ?? (useMax ? 12 : 1);
        final day = int.tryParse(parts[1]) ?? (useMax ? 31 : 1);
        final year = int.tryParse(parts[2]) ?? (useMax ? 2999 : 1900);
        return VaxDate(year, month, day);
      } else {
        // YYYY/MM/DD format
        final year = int.tryParse(parts[0]) ?? (useMax ? 2999 : 1900);
        final month = int.tryParse(parts[1]) ?? (useMax ? 12 : 1);
        final day = int.tryParse(parts[2]) ?? (useMax ? 31 : 1);
        return VaxDate(year, month, day);
      }
    } else if (parts.length == 2) {
      final year = int.tryParse(parts[0]) ?? (useMax ? 2999 : 1900);
      final month = int.tryParse(parts[1]) ?? (useMax ? 12 : 1);
      return VaxDate(year, month, useMax ? 31 : 1);
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      final year = int.tryParse(parts[0]) ?? (useMax ? 2999 : 1900);
      return VaxDate(year, useMax ? 12 : 1, useMax ? 31 : 1);
    } else {
      return useMax ? VaxDate.max() : VaxDate.min();
    }
  }

  // A plain FHIR date, read without building a DateTime.
  static final _plainDate = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  // Overriding toString and toJson methods
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
  String toJson() => toString();

  // Conversion to DateTime and FHIR types
  DateTime toDateTime() => DateTime(year, month, day);

  /// The date as FHIR writes a date, `YYYY-MM-DD`, with no time and no zone,
  /// as the ImmDS IG's ImmunizationRecommendation example writes every
  /// dateCriterion value ("2020-05-28"). Written from a local DateTime it
  /// carried a time and the machine's offset (`2016-08-22T00:00:00+03:00`);
  /// read back, that names 2016-08-21T21:00Z, a day early. In every zone
  /// east of UTC a Condition's onset date came back one day early
  /// (2016-UC-0130 failed under TZ=Africa/Kampala, Europe/Berlin and
  /// Pacific/Kiritimati, 2026-11-23).
  String get _fhirDate =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
  FhirDateTime toFhirDateTime() => FhirDateTime.fromString(_fhirDate);
  FhirDate toFhirDate() => FhirDate.fromString(_fhirDate);

  // Comparison of calendar dates. A VaxDate is a date without a time, so
  // two compare by year, month and day; packed into one integer they compare
  // the same way. Building a local DateTime per comparison asked the system
  // for the time-zone offset each time: 81% of the engine's time on CDC's
  // healthy cases (VM profiler, 2026-11-23).
  int get _ymd => year * 10000 + month * 100 + day;
  bool operator <(VaxDate other) => _ymd < other._ymd;
  bool operator >(VaxDate other) => _ymd > other._ymd;
  bool operator <=(VaxDate other) => !(this > other);
  bool operator >=(VaxDate other) => !(this < other);
  bool isEqualTo(VaxDate other) => _ymd == other._ymd;

  /// Parse a CDSi date offset string into (years, months, days) components.
  static ({int years, int months, int days}) _parseOffset(String description) {
    var years = 0;
    var months = 0;
    var days = 0;
    var sign = 1;
    final parts = description.split(' ');

    for (var i = 0; i < parts.length; i++) {
      if (parts[i] == '-' || parts[i] == '+') {
        sign = (parts[i] == '-') ? -1 : 1;
        continue;
      }

      if (i < parts.length - 1 && int.tryParse(parts[i]) != null) {
        final value = int.parse(parts[i]) * sign;
        final unit = parts[i + 1].toLowerCase();

        if (unit.contains('year')) {
          years += value;
        } else if (unit.contains('month')) {
          months += value;
        } else if (unit.contains('day') || unit.contains('week')) {
          final multiplier = unit.contains('week') ? 7 : 1;
          days += value * multiplier;
        }

        i++;
      }
    }
    return (years: years, months: months, days: days);
  }

  /// Apply a date offset per CDSi CALCDT-5 and CALCDT-6:
  /// 1. Add years and months
  /// 2. If the resulting date doesn't exist, move to the first day of the
  ///    next month (CALCDT-5)
  /// 3. Add weeks/days (CALCDT-3)
  VaxDate _applyOffset(int years, int months, int days) {
    // Calendar arithmetic in UTC: the same year, month and day as local
    // time, without a time-zone lookup per step.
    // Step 1: add years and months (use day=1 to let Dart normalize month)
    final target = DateTime.utc(year + years, month + months);
    final daysInTargetMonth =
        DateTime.utc(
          target.year,
          target.month + 1,
          0,
        ).day;

    // Step 2: CALCDT-5 — if the original day exceeds the target month's
    // length, the date doesn't exist; move to first day of next month
    DateTime newDate;
    if (day > daysInTargetMonth) {
      newDate = DateTime.utc(target.year, target.month + 1);
    } else {
      newDate = DateTime.utc(target.year, target.month, day);
    }

    // Step 3: CALCDT-3 — add days
    if (days != 0) {
      newDate = DateTime.utc(newDate.year, newDate.month, newDate.day + days);
    }

    return VaxDate.fromDateTime(newDate);
  }

  // Method for modifying date with textual descriptions of changes
  VaxDate change(String description) {
    final o = _parseOffset(description);
    return _applyOffset(o.years, o.months, o.days);
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
    final o = _parseOffset(description);
    return _applyOffset(o.years, o.months, o.days);
  }
}

// Utility functions for finding the latest and earliest dates in a list
VaxDate latestOf(List<VaxDate> dates) => dates.reduce((a, b) => a > b ? a : b);
VaxDate earliestOf(List<VaxDate> dates) =>
    dates.reduce((a, b) => a < b ? a : b);
