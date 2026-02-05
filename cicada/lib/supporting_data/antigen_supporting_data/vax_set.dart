import '../../cicada.dart';

class VaxSet {
  VaxSet({
    this.setID,
    this.setDescription,
    this.effectiveDate,
    this.cessationDate,
    this.conditionLogic,
    this.condition,
  });

  final String? setID;
  final String? setDescription;
  final String? effectiveDate;
  final String? cessationDate;
  final String? conditionLogic;
  final List<VaxCondition>? condition;

  factory VaxSet.fromJson(Map<String, dynamic> json) {
    return VaxSet(
      setID: json['setID'] as String?,
      setDescription: json['setDescription'] as String?,
      effectiveDate: json['effectiveDate'] as String?,
      cessationDate: json['cessationDate'] as String?,
      conditionLogic: json['conditionLogic'] as String?,
      condition: (json['condition'] as List<dynamic>?)
          ?.map((e) => VaxCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (setID != null) 'setID': setID,
      if (setDescription != null) 'setDescription': setDescription,
      if (effectiveDate != null) 'effectiveDate': effectiveDate,
      if (cessationDate != null) 'cessationDate': cessationDate,
      if (conditionLogic != null) 'conditionLogic': conditionLogic,
      if (condition != null)
        'condition': condition?.map((e) => e.toJson()).toList(),
    };
  }

  VaxSet copyWith({
    String? setID,
    String? setDescription,
    String? effectiveDate,
    String? cessationDate,
    String? conditionLogic,
    List<VaxCondition>? condition,
  }) {
    return VaxSet(
      setID: setID ?? this.setID,
      setDescription: setDescription ?? this.setDescription,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      cessationDate: cessationDate ?? this.cessationDate,
      conditionLogic: conditionLogic ?? this.conditionLogic,
      condition: condition ?? this.condition,
    );
  }
}
