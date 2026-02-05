import '../../cicada.dart';

class SeriesDose {
  SeriesDose({
    this.doseNumber,
    this.age,
    this.preferableInterval,
    this.allowableInterval,
    this.preferableVaccine,
    this.allowableVaccine,
    this.inadvertentVaccine,
    this.conditionalSkip,
    this.recurringDose,
    this.seasonalRecommendation,
  });

  final DoseNumber? doseNumber;
  final List<VaxAge>? age;
  final List<Interval>? preferableInterval;
  final Interval? allowableInterval;
  final List<Vaccine>? preferableVaccine;
  final List<Vaccine>? allowableVaccine;
  final List<Vaccine>? inadvertentVaccine;
  final List<ConditionalSkip>? conditionalSkip;
  final Binary? recurringDose;
  final SeasonalRecommendation? seasonalRecommendation;

  factory SeriesDose.fromJson(Map<String, dynamic> json) {
    return SeriesDose(
      doseNumber: json['doseNumber'] == null
          ? null
          : DoseNumber.fromJson(json['doseNumber'] as String),
      age: json['age'] == null || (json['age'] as List).isEmpty
          ? null
          : (json['age'] as List<dynamic>?)
              ?.map((e) => VaxAge.fromJson(e as Map<String, dynamic>))
              .toList(),
      preferableInterval: (json['interval'] as List<dynamic>?)
          ?.map((e) => Interval.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowableInterval: json['allowableInterval'] == null
          ? null
          : Interval.fromJson(
              json['allowableInterval'] as Map<String, dynamic>),
      preferableVaccine: (json['preferableVaccine'] as List<dynamic>?)
          ?.map((e) => Vaccine.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowableVaccine: (json['allowableVaccine'] as List<dynamic>?)
          ?.map((e) => Vaccine.fromJson(e as Map<String, dynamic>))
          .toList(),
      inadvertentVaccine: (json['inadvertentVaccine'] as List<dynamic>?)
          ?.map((e) => Vaccine.fromJson(e as Map<String, dynamic>))
          .toList(),
      conditionalSkip: (json['conditionalSkip'] as List<dynamic>?)
          ?.map((e) => ConditionalSkip.fromJson(e as Map<String, dynamic>))
          .toList(),
      recurringDose: json['recurringDose'] == null
          ? null
          : Binary.fromJson(json['recurringDose'] as String),
      seasonalRecommendation: json['seasonalRecommendation'] == null
          ? null
          : SeasonalRecommendation.fromJson(
              json['seasonalRecommendation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (doseNumber != null) 'doseNumber': doseNumber?.toJson(),
      if (age != null) 'age': age?.map((e) => e.toJson()).toList(),
      if (preferableInterval != null)
        'interval': preferableInterval?.map((e) => e.toJson()).toList(),
      if (allowableInterval != null)
        'allowableInterval': allowableInterval?.toJson(),
      if (preferableVaccine != null)
        'preferableVaccine': preferableVaccine?.map((e) => e.toJson()).toList(),
      if (allowableVaccine != null)
        'allowableVaccine': allowableVaccine?.map((e) => e.toJson()).toList(),
      if (inadvertentVaccine != null)
        'inadvertentVaccine':
            inadvertentVaccine?.map((e) => e.toJson()).toList(),
      if (conditionalSkip != null)
        'conditionalSkip': conditionalSkip?.map((e) => e.toJson()).toList(),
      if (recurringDose != null) 'recurringDose': recurringDose?.toJson(),
      if (seasonalRecommendation != null)
        'seasonalRecommendation': seasonalRecommendation?.toJson(),
    };
  }

  SeriesDose copyWith({
    DoseNumber? doseNumber,
    List<VaxAge>? age,
    List<Interval>? preferableInterval,
    Interval? allowableInterval,
    List<Vaccine>? preferableVaccine,
    List<Vaccine>? allowableVaccine,
    List<Vaccine>? inadvertentVaccine,
    List<ConditionalSkip>? conditionalSkip,
    Binary? recurringDose,
    SeasonalRecommendation? seasonalRecommendation,
  }) {
    return SeriesDose(
      doseNumber: doseNumber ?? this.doseNumber,
      age: age ?? this.age,
      preferableInterval: preferableInterval ?? this.preferableInterval,
      allowableInterval: allowableInterval ?? this.allowableInterval,
      preferableVaccine: preferableVaccine ?? this.preferableVaccine,
      allowableVaccine: allowableVaccine ?? this.allowableVaccine,
      inadvertentVaccine: inadvertentVaccine ?? this.inadvertentVaccine,
      conditionalSkip: conditionalSkip ?? this.conditionalSkip,
      recurringDose: recurringDose ?? this.recurringDose,
      seasonalRecommendation:
          seasonalRecommendation ?? this.seasonalRecommendation,
    );
  }

  VaxDate maxAgeDate(VaxDate date) {
    final List<String>? maxAgeList =
        age?.map((VaxAge e) => e.maxAge).whereType<String>().toList();

    if (maxAgeList == null || maxAgeList.isEmpty) {
      return VaxDate.max();
    } else {
      for (final String maxAge in maxAgeList) {
        final VaxDate newDate = date.change(maxAge);
        if (newDate > date) {
          date = newDate;
        }
      }
      return date;
    }
  }

  int? inadvertentVaccineIndex(int cvx) {
    return inadvertentVaccine?.indexWhere((Vaccine element) {
      if (element.cvx == null) {
        return false;
      }
      final int? parsed = int.tryParse(element.cvx!);
      return parsed != null && parsed == cvx;
    });
  }
}
