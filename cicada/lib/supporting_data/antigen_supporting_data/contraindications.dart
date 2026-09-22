import 'package:cicada/supporting_data/antigen_supporting_data/vaccine_contraindications.dart';
import 'package:cicada/supporting_data/antigen_supporting_data/vaccine_group_contraindications.dart';

class Contraindications {
  Contraindications({
    this.vaccineGroup,
    this.vaccine,
  });

  factory Contraindications.fromJson(Map<String, dynamic> json) {
    return Contraindications(
      vaccineGroup:
          json['vaccineGroup'] == null
              ? null
              : VaccineGroupContraindications.fromJson(
                json['vaccineGroup'] as Map<String, dynamic>,
              ),
      vaccine:
          json['vaccine'] == null
              ? null
              : VaccineContraindications.fromJson(
                json['vaccine'] as Map<String, dynamic>,
              ),
    );
  }

  final VaccineGroupContraindications? vaccineGroup;
  final VaccineContraindications? vaccine;

  Map<String, dynamic> toJson() {
    return {
      if (vaccineGroup != null) 'vaccineGroup': vaccineGroup?.toJson(),
      if (vaccine != null) 'vaccine': vaccine?.toJson(),
    };
  }

  Contraindications copyWith({
    VaccineGroupContraindications? vaccineGroup,
    VaccineContraindications? vaccine,
  }) {
    return Contraindications(
      vaccineGroup: vaccineGroup ?? this.vaccineGroup,
      vaccine: vaccine ?? this.vaccine,
    );
  }
}
