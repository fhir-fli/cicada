class VaccineGroupToAntigenMap {
  VaccineGroupToAntigenMap({this.vaccineGroupMap});

  factory VaccineGroupToAntigenMap.fromJson(Map<String, dynamic> json) {
    return VaccineGroupToAntigenMap(
      vaccineGroupMap:
          (json['vaccineGroupMap'] as List<dynamic>?)
              ?.map((e) => VaccineGroupMap.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  final List<VaccineGroupMap>? vaccineGroupMap;

  VaccineGroupToAntigenMap copyWith({
    List<VaccineGroupMap>? vaccineGroupMap,
  }) {
    return VaccineGroupToAntigenMap(
      vaccineGroupMap: vaccineGroupMap ?? this.vaccineGroupMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (vaccineGroupMap != null)
        'vaccineGroupMap': vaccineGroupMap?.map((e) => e.toJson()).toList(),
    };
  }
}

class VaccineGroupMap {
  VaccineGroupMap({this.name, this.antigen});

  factory VaccineGroupMap.fromJson(Map<String, dynamic> json) {
    return VaccineGroupMap(
      name: json['name'] as String?,
      antigen:
          (json['antigen'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  final String? name;
  final List<String>? antigen;

  VaccineGroupMap copyWith({
    String? name,
    List<String>? antigen,
  }) {
    return VaccineGroupMap(
      name: name ?? this.name,
      antigen: antigen ?? this.antigen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (antigen != null) 'antigen': antigen,
    };
  }
}
