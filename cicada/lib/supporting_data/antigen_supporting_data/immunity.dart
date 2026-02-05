import 'clinical_history.dart';
import 'date_of_birth.dart';

class Immunity {
  Immunity({
    this.clinicalHistory,
    this.dateOfBirth,
  });

  final List<ClinicalHistory>? clinicalHistory;
  final DateOfBirth? dateOfBirth;

  factory Immunity.fromJson(Map<String, dynamic> json) {
    return Immunity(
      clinicalHistory: (json['clinicalHistory'] as List<dynamic>?)
          ?.map((e) => ClinicalHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateOfBirth.fromJson(json['dateOfBirth'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (clinicalHistory != null)
        'clinicalHistory': clinicalHistory?.map((e) => e.toJson()).toList(),
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth?.toJson(),
    };
  }

  Immunity copyWith({
    List<ClinicalHistory>? clinicalHistory,
    DateOfBirth? dateOfBirth,
  }) {
    return Immunity(
      clinicalHistory: clinicalHistory ?? this.clinicalHistory,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  bool isEmpty() =>
      (clinicalHistory == null || clinicalHistory!.isEmpty) &&
      dateOfBirth == null;
}
