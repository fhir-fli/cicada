import 'exclusion.dart';

class DateOfBirth {
  DateOfBirth({
    this.immunityBirthDate,
    this.birthCountry,
    this.exclusion,
  });

  final String? immunityBirthDate;
  final String? birthCountry;
  final List<Exclusion>? exclusion;

  factory DateOfBirth.fromJson(Map<String, dynamic> json) {
    return DateOfBirth(
      immunityBirthDate: json['immunityBirthDate'] as String?,
      birthCountry: json['birthCountry'] as String?,
      exclusion: (json['exclusion'] as List<dynamic>?)
          ?.map((e) => Exclusion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (immunityBirthDate != null) 'immunityBirthDate': immunityBirthDate,
      if (birthCountry != null) 'birthCountry': birthCountry,
      if (exclusion != null)
        'exclusion': exclusion?.map((e) => e.toJson()).toList(),
    };
  }

  DateOfBirth copyWith({
    String? immunityBirthDate,
    String? birthCountry,
    List<Exclusion>? exclusion,
  }) {
    return DateOfBirth(
      immunityBirthDate: immunityBirthDate ?? this.immunityBirthDate,
      birthCountry: birthCountry ?? this.birthCountry,
      exclusion: exclusion ?? this.exclusion,
    );
  }
}
