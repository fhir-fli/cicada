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

  final String? vaccineType;
  final String? cvx;
  final String? beginAge;
  final String? endAge;
  final String? tradeName;
  final String? mvx;
  final String? volume;
  final String? forecastVaccineType;

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

  /// The CVX code as a number, parsed once: the live-virus conflict check
  /// compares it for every past dose in every series, and parsing it each
  /// time was 24% of engine time for a fully vaccinated child (VM profiler,
  /// 2026-11-23).
  late final int? cvxAsInt = cvx == null ? null : int.tryParse(cvx!);
}
