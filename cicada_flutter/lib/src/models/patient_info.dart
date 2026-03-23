import 'package:flutter/foundation.dart';

/// Demographics entered by the user.
@immutable
class PatientInfo {
  const PatientInfo({
    required this.birthDate,
    required this.sex,
    this.assessmentDate,
  });

  final DateTime birthDate;
  final PatientSex sex;
  final DateTime? assessmentDate;

  DateTime get effectiveAssessmentDate => assessmentDate ?? DateTime.now();

  PatientInfo copyWith({
    DateTime? birthDate,
    PatientSex? sex,
    DateTime? assessmentDate,
  }) => PatientInfo(
    birthDate: birthDate ?? this.birthDate,
    sex: sex ?? this.sex,
    assessmentDate: assessmentDate ?? this.assessmentDate,
  );
}

enum PatientSex {
  male('Male'),
  female('Female')
  ;

  const PatientSex(this.displayName);
  final String displayName;
}
