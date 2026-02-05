import 'package:fhir_r4/fhir_r4.dart';

class VaxObservations {
  VaxObservations({this.observation});

  final List<VaxObservation>? observation;

  factory VaxObservations.fromJson(Map<String, dynamic> json) {
    return VaxObservations(
      observation: (json['observation'] as List<dynamic>?)
          ?.map((e) => VaxObservation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  VaxObservations copyWith({
    List<VaxObservation>? observation,
  }) {
    return VaxObservations(
      observation: observation ?? this.observation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (observation != null)
        'observation': observation?.map((e) => e.toJson()).toList(),
    };
  }

  List<int>? get codesAsInt {
    if (observation == null) {
      return null;
    } else {
      final List<int> codes =
          observation!.map((VaxObservation e) => e.codeAsInt ?? -1).toList();
      codes.removeWhere((int element) => element == -1);
      return codes;
    }
  }

  int codeIndex(String code) {
    final List<int>? codes = codesAsInt;
    if (codes == null) {
      return -1;
    } else {
      final int? codeInt = int.tryParse(code);
      if (codeInt == null) {
        return -1;
      } else {
        return codes.indexOf(codeInt);
      }
    }
  }
}

class VaxObservation {
  VaxObservation({
    this.observationCode,
    this.observationTitle,
    this.group,
    this.indicationText,
    this.contraindicationText,
    this.clarifyingText,
    this.codedValues,
    this.period,
  });

  final String? observationCode;
  final String? observationTitle;
  final String? group;
  final String? indicationText;
  final String? contraindicationText;
  final String? clarifyingText;
  final CodedValues? codedValues;
  final Period? period;

  factory VaxObservation.fromJson(Map<String, dynamic> json) {
    return VaxObservation(
      observationCode: json['observationCode'] as String?,
      observationTitle: json['observationTitle'] as String?,
      group: json['group'] as String?,
      indicationText: json['indicationText'] as String?,
      contraindicationText: json['contraindicationText'] as String?,
      clarifyingText: json['clarifyingText'] as String?,
      codedValues: json['codedValues'] == null
          ? null
          : CodedValues.fromJson(json['codedValues'] as Map<String, dynamic>),
      period: json['period'] == null
          ? null
          : Period.fromJson(json['period'] as Map<String, dynamic>),
    );
  }

  VaxObservation copyWith({
    String? observationCode,
    String? observationTitle,
    String? group,
    String? indicationText,
    String? contraindicationText,
    String? clarifyingText,
    CodedValues? codedValues,
    Period? period,
  }) {
    return VaxObservation(
      observationCode: observationCode ?? this.observationCode,
      observationTitle: observationTitle ?? this.observationTitle,
      group: group ?? this.group,
      indicationText: indicationText ?? this.indicationText,
      contraindicationText: contraindicationText ?? this.contraindicationText,
      clarifyingText: clarifyingText ?? this.clarifyingText,
      codedValues: codedValues ?? this.codedValues,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (observationCode != null) 'observationCode': observationCode,
      if (observationTitle != null) 'observationTitle': observationTitle,
      if (group != null) 'group': group,
      if (indicationText != null) 'indicationText': indicationText,
      if (contraindicationText != null)
        'contraindicationText': contraindicationText,
      if (clarifyingText != null) 'clarifyingText': clarifyingText,
      if (codedValues != null) 'codedValues': codedValues?.toJson(),
      if (period != null) 'period': period?.toJson(),
    };
  }

  int? get codeAsInt =>
      observationCode == null ? null : int.tryParse(observationCode!);
}

class CodedValues {
  CodedValues({this.codedValue});

  final List<CodedValue>? codedValue;

  factory CodedValues.fromJson(Map<String, dynamic> json) {
    return CodedValues(
      codedValue: (json['codedValue'] as List<dynamic>?)
          ?.map((e) => CodedValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (codedValue != null)
        'codedValue': codedValue?.map((e) => e.toJson()).toList(),
    };
  }
}

class CodedValue {
  CodedValue({
    this.code,
    this.codeSystem,
    this.text,
  });

  final String? code;
  final String? codeSystem;
  final String? text;

  factory CodedValue.fromJson(Map<String, dynamic> json) {
    return CodedValue(
      code: json['code'] as String?,
      codeSystem: json['codeSystem'] as String?,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (code != null) 'code': code,
      if (codeSystem != null) 'codeSystem': codeSystem,
      if (text != null) 'text': text,
    };
  }
}
