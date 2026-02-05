class Vaccine {
  Vaccine({
    this.vaccineType,
    this.cvx,
    this.beginAge,
    this.endAge,
    this.tradeName,
    this.mvx,
    this.volume,
    this.forecastVaccineType,
  });

  final String? vaccineType;
  final String? cvx;
  final String? beginAge;
  final String? endAge;
  final String? tradeName;
  final String? mvx;
  final String? volume;
  final String? forecastVaccineType;

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      vaccineType: json['vaccineType'] as String?,
      cvx: json['cvx'] as String?,
      beginAge: json['beginAge'] as String?,
      endAge: json['endAge'] as String?,
      tradeName: json['tradeName'] as String?,
      mvx: json['mvx'] as String?,
      volume: json['volume'] as String?,
      forecastVaccineType: json['forecastVaccineType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (vaccineType != null) 'vaccineType': vaccineType,
      if (cvx != null) 'cvx': cvx,
      if (beginAge != null) 'beginAge': beginAge,
      if (endAge != null) 'endAge': endAge,
      if (tradeName != null) 'tradeName': tradeName,
      if (mvx != null) 'mvx': mvx,
      if (volume != null) 'volume': volume,
      if (forecastVaccineType != null)
        'forecastVaccineType': forecastVaccineType,
    };
  }

  // Example helper getter
  int? get cvxAsInt => cvx == null ? null : int.tryParse(cvx!);
}
