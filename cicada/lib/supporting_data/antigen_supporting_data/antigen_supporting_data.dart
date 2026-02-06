import '../../cicada.dart';

export 'clinical_history.dart';
export 'conditional_skip.dart';
export 'contraindications.dart';
export 'date_of_birth.dart';
export 'exclusion.dart';
export 'immunity.dart';
export 'indication.dart';
export 'interval.dart';
export 'observation_code.dart';
export 'seasonal_recommendation.dart';
export 'select_series.dart';
export 'series.dart';
export 'series_dose.dart';
export 'vaccine.dart';
export 'vaccine_contraindications.dart';
export 'vaccine_group_contraindications.dart';
export 'vax_age.dart';
export 'vax_condition.dart';
export 'vax_set.dart';

class AntigenSupportingData {
  AntigenSupportingData({
    this.targetDisease,
    this.vaccineGroup,
    this.immunity,
    this.contraindications,
    this.series,
  });

  final String? targetDisease;
  final String? vaccineGroup;
  final Immunity? immunity;
  final Contraindications? contraindications;
  final List<Series>? series;

  factory AntigenSupportingData.fromJson(Map<String, dynamic> oldJson) {
    final json = oldJson['antigenSupportingData'] ?? oldJson;
    return AntigenSupportingData(
      targetDisease: json['targetDisease'] as String?,
      vaccineGroup: json['vaccineGroup'] as String?,
      immunity: json['immunity'] == null
          ? null
          : Immunity.fromJson(json['immunity'] as Map<String, dynamic>),
      contraindications: json['contraindications'] == null
          ? null
          : Contraindications.fromJson(
              json['contraindications'] as Map<String, dynamic>),
      series: (json['series'] as List<dynamic>?)
          ?.map((e) => Series.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (targetDisease != null) 'targetDisease': targetDisease,
      if (vaccineGroup != null) 'vaccineGroup': vaccineGroup,
      if (immunity != null) 'immunity': immunity?.toJson(),
      if (contraindications != null)
        'contraindications': contraindications?.toJson(),
      if (series != null) 'series': series?.map((e) => e.toJson()).toList(),
    };
  }

  AntigenSupportingData copyWith({
    String? targetDisease,
    String? vaccineGroup,
    Immunity? immunity,
    Contraindications? contraindications,
    List<Series>? series,
  }) {
    return AntigenSupportingData(
      targetDisease: targetDisease ?? this.targetDisease,
      vaccineGroup: vaccineGroup ?? this.vaccineGroup,
      immunity: immunity ?? this.immunity,
      contraindications: contraindications ?? this.contraindications,
      series: series ?? this.series,
    );
  }
}
