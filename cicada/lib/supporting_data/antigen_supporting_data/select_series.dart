import '../../cicada.dart';

class SelectSeries {
  SelectSeries({
    this.defaultSeries,
    this.productPath,
    this.seriesGroupName,
    this.seriesGroup,
    this.seriesPriority,
    this.seriesPreference,
    this.minAgeToStart,
    this.maxAgeToStart,
  });

  final Binary? defaultSeries;
  final Binary? productPath;
  final String? seriesGroupName;
  final String? seriesGroup;
  final SeriesPriority? seriesPriority;
  final SeriesPreference? seriesPreference;
  final String? minAgeToStart;
  final String? maxAgeToStart;

  factory SelectSeries.fromJson(Map<String, dynamic> json) {
    return SelectSeries(
      defaultSeries: json['defaultSeries'] == null
          ? null
          : Binary.fromJson(json['defaultSeries'] as String),
      productPath: json['productPath'] == null
          ? null
          : Binary.fromJson(json['productPath'] as String),
      seriesGroupName: json['seriesGroupName'] as String?,
      seriesGroup: json['seriesGroup'] as String?,
      seriesPriority: json['seriesPriority'] == null
          ? null
          : SeriesPriority.fromJson(json['seriesPriority'] as String),
      seriesPreference: json['seriesPreference'] == null
          ? null
          : SeriesPreference.fromJson(json['seriesPreference'] as String),
      minAgeToStart: json['minAgeToStart'] as String?,
      maxAgeToStart: json['maxAgeToStart'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (defaultSeries != null) 'defaultSeries': defaultSeries?.toJson(),
      if (productPath != null) 'productPath': productPath?.toJson(),
      if (seriesGroupName != null) 'seriesGroupName': seriesGroupName,
      if (seriesGroup != null) 'seriesGroup': seriesGroup,
      if (seriesPriority != null) 'seriesPriority': seriesPriority?.toJson(),
      if (seriesPreference != null)
        'seriesPreference': seriesPreference?.toJson(),
      if (minAgeToStart != null) 'minAgeToStart': minAgeToStart,
      if (maxAgeToStart != null) 'maxAgeToStart': maxAgeToStart,
    };
  }
}
