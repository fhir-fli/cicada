import '../../cicada.dart';

class VaccineGroups {
  VaccineGroups({this.vaccineGroup});

  final List<VaccineGroup>? vaccineGroup;

  factory VaccineGroups.fromJson(Map<String, dynamic> json) {
    return VaccineGroups(
      vaccineGroup: (json['vaccineGroup'] as List<dynamic>?)
          ?.map((e) => VaccineGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  VaccineGroups copyWith({
    List<VaccineGroup>? vaccineGroup,
  }) {
    return VaccineGroups(
      vaccineGroup: vaccineGroup ?? this.vaccineGroup,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (vaccineGroup != null)
        'vaccineGroup': vaccineGroup?.map((e) => e.toJson()).toList(),
    };
  }
}

class VaccineGroup {
  VaccineGroup({
    this.name,
    this.administerFullVaccineGroup,
  });

  final String? name;
  final Binary? administerFullVaccineGroup;

  factory VaccineGroup.fromJson(Map<String, dynamic> json) {
    return VaccineGroup(
      name: json['name'] as String?,
      administerFullVaccineGroup: json['administerFullVaccineGroup'] == null
          ? null
          : Binary.fromJson(json['administerFullVaccineGroup'] as String),
    );
  }

  VaccineGroup copyWith({
    String? name,
    Binary? administerFullVaccineGroup,
  }) {
    return VaccineGroup(
      name: name ?? this.name,
      administerFullVaccineGroup:
          administerFullVaccineGroup ?? this.administerFullVaccineGroup,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (administerFullVaccineGroup != null)
        'administerFullVaccineGroup': administerFullVaccineGroup?.toJson(),
    };
  }
}
