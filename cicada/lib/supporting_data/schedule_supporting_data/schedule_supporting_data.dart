import '../../cicada.dart';

export 'cvx_to_antigen_map.dart';
export 'live_virus_conflicts.dart';
export 'vaccine_group_to_antigen_map.dart';
export 'vaccine_groups.dart';
export 'vax_observations.dart';

class ScheduleSupportingData {
  ScheduleSupportingData({
    this.liveVirusConflicts,
    this.vaccineGroups,
    this.vaccineGroupToAntigenMap,
    this.cvxToAntigenMap,
    this.observations,
  });

  final LiveVirusConflicts? liveVirusConflicts;
  final VaccineGroups? vaccineGroups;
  final VaccineGroupToAntigenMap? vaccineGroupToAntigenMap;
  final CvxToAntigenMap? cvxToAntigenMap;
  final VaxObservations? observations;

  factory ScheduleSupportingData.fromJson(Map<String, dynamic> json) {
    return ScheduleSupportingData(
      liveVirusConflicts: json['liveVirusConflicts'] == null
          ? null
          : LiveVirusConflicts.fromJson(
              json['liveVirusConflicts'] as Map<String, dynamic>),
      vaccineGroups: json['vaccineGroups'] == null
          ? null
          : VaccineGroups.fromJson(
              json['vaccineGroups'] as Map<String, dynamic>),
      vaccineGroupToAntigenMap: json['vaccineGroupToAntigenMap'] == null
          ? null
          : VaccineGroupToAntigenMap.fromJson(
              json['vaccineGroupToAntigenMap'] as Map<String, dynamic>),
      cvxToAntigenMap: json['cvxToAntigenMap'] == null
          ? null
          : CvxToAntigenMap.fromJson(
              json['cvxToAntigenMap'] as Map<String, dynamic>),
      observations: json['observations'] == null
          ? null
          : VaxObservations.fromJson(
              json['observations'] as Map<String, dynamic>),
    );
  }

  ScheduleSupportingData copyWith({
    LiveVirusConflicts? liveVirusConflicts,
    VaccineGroups? vaccineGroups,
    VaccineGroupToAntigenMap? vaccineGroupToAntigenMap,
    CvxToAntigenMap? cvxToAntigenMap,
    VaxObservations? observations,
  }) {
    return ScheduleSupportingData(
      liveVirusConflicts: liveVirusConflicts ?? this.liveVirusConflicts,
      vaccineGroups: vaccineGroups ?? this.vaccineGroups,
      vaccineGroupToAntigenMap:
          vaccineGroupToAntigenMap ?? this.vaccineGroupToAntigenMap,
      cvxToAntigenMap: cvxToAntigenMap ?? this.cvxToAntigenMap,
      observations: observations ?? this.observations,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (liveVirusConflicts != null)
        'liveVirusConflicts': liveVirusConflicts?.toJson(),
      if (vaccineGroups != null) 'vaccineGroups': vaccineGroups?.toJson(),
      if (vaccineGroupToAntigenMap != null)
        'vaccineGroupToAntigenMap': vaccineGroupToAntigenMap?.toJson(),
      if (cvxToAntigenMap != null) 'cvxToAntigenMap': cvxToAntigenMap?.toJson(),
      if (observations != null) 'observations': observations?.toJson(),
    };
  }
}
