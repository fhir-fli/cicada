import '../../cicada.dart';

class VaccineContraindications {
  VaccineContraindications({this.contraindication});

  final List<VaccineContraindication>? contraindication;

  factory VaccineContraindications.fromJson(Map<String, dynamic> json) {
    return VaccineContraindications(
      contraindication: (json['contraindication'] as List<dynamic>?)
          ?.map((e) =>
              VaccineContraindication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contraindication': contraindication?.map((e) => e.toJson()).toList(),
    };
  }

  VaccineContraindications copyWith({
    List<VaccineContraindication>? contraindication,
  }) {
    return VaccineContraindications(
      contraindication: contraindication ?? this.contraindication,
    );
  }

  List<int>? get codesAsInt {
    if (contraindication == null) {
      return null;
    } else {
      final List<int> codes = contraindication!
          .map((VaccineContraindication e) => e.codeAsInt ?? -1)
          .toList();
      codes.removeWhere((int element) => element == -1);
      return codes;
    }
  }
}

class VaccineContraindication {
  VaccineContraindication({
    this.observationCode,
    this.observationTitle,
    this.contraindicationText,
    this.contraindicationGuidance,
    this.contraindicatedVaccine,
  });

  final String? observationCode;
  final String? observationTitle;
  final String? contraindicationText;
  final String? contraindicationGuidance;
  final List<Vaccine>? contraindicatedVaccine;

  factory VaccineContraindication.fromJson(Map<String, dynamic> json) {
    return VaccineContraindication(
      observationCode: json['observationCode'] as String?,
      observationTitle: json['observationTitle'] as String?,
      contraindicationText: json['contraindicationText'] as String?,
      contraindicationGuidance: json['contraindicationGuidance'] as String?,
      contraindicatedVaccine: (json['contraindicatedVaccine'] as List<dynamic>?)
          ?.map((e) => Vaccine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (observationCode != null) 'observationCode': observationCode,
      if (observationTitle != null) 'observationTitle': observationTitle,
      if (contraindicationText != null)
        'contraindicationText': contraindicationText,
      if (contraindicationGuidance != null)
        'contraindicationGuidance': contraindicationGuidance,
      if (contraindicatedVaccine != null)
        'contraindicatedVaccine':
            contraindicatedVaccine?.map((e) => e.toJson()).toList(),
    };
  }

  VaccineContraindication copyWith({
    String? observationCode,
    String? observationTitle,
    String? contraindicationText,
    String? contraindicationGuidance,
    List<Vaccine>? contraindicatedVaccine,
  }) {
    return VaccineContraindication(
      observationCode: observationCode ?? this.observationCode,
      observationTitle: observationTitle ?? this.observationTitle,
      contraindicationText: contraindicationText ?? this.contraindicationText,
      contraindicationGuidance:
          contraindicationGuidance ?? this.contraindicationGuidance,
      contraindicatedVaccine:
          contraindicatedVaccine ?? this.contraindicatedVaccine,
    );
  }

  int? get codeAsInt =>
      observationCode == null ? null : int.tryParse(observationCode!);
}
