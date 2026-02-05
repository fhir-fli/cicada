import 'package:cicada/cicada.dart';

class LiveVirusConflicts {
  LiveVirusConflicts({this.liveVirusConflict});

  final List<LiveVirusConflict>? liveVirusConflict;

  factory LiveVirusConflicts.fromJson(Map<String, dynamic> json) {
    return LiveVirusConflicts(
      liveVirusConflict: (json['liveVirusConflict'] as List<dynamic>?)
          ?.map((e) => LiveVirusConflict.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  LiveVirusConflicts copyWith({
    List<LiveVirusConflict>? liveVirusConflict,
  }) {
    return LiveVirusConflicts(
      liveVirusConflict: liveVirusConflict ?? this.liveVirusConflict,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (liveVirusConflict != null)
        'liveVirusConflict': liveVirusConflict?.map((e) => e.toJson()).toList(),
    };
  }
}

class LiveVirusConflict {
  LiveVirusConflict({
    this.previous,
    this.current,
    this.conflictBeginInterval,
    this.minConflictEndInterval,
    this.conflictEndInterval,
  });

  final Vaccine? previous;
  final Vaccine? current;
  final String? conflictBeginInterval;
  final String? minConflictEndInterval;
  final String? conflictEndInterval;

  factory LiveVirusConflict.fromJson(Map<String, dynamic> json) {
    return LiveVirusConflict(
      previous: json['previous'] == null
          ? null
          : Vaccine.fromJson(json['previous'] as Map<String, dynamic>),
      current: json['current'] == null
          ? null
          : Vaccine.fromJson(json['current'] as Map<String, dynamic>),
      conflictBeginInterval: json['conflictBeginInterval'] as String?,
      minConflictEndInterval: json['minConflictEndInterval'] as String?,
      conflictEndInterval: json['conflictEndInterval'] as String?,
    );
  }

  LiveVirusConflict copyWith({
    Vaccine? previous,
    Vaccine? current,
    String? conflictBeginInterval,
    String? minConflictEndInterval,
    String? conflictEndInterval,
  }) {
    return LiveVirusConflict(
      previous: previous ?? this.previous,
      current: current ?? this.current,
      conflictBeginInterval:
          conflictBeginInterval ?? this.conflictBeginInterval,
      minConflictEndInterval:
          minConflictEndInterval ?? this.minConflictEndInterval,
      conflictEndInterval: conflictEndInterval ?? this.conflictEndInterval,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (previous != null) 'previous': previous?.toJson(),
      if (current != null) 'current': current?.toJson(),
      if (conflictBeginInterval != null)
        'conflictBeginInterval': conflictBeginInterval,
      if (minConflictEndInterval != null)
        'minConflictEndInterval': minConflictEndInterval,
      if (conflictEndInterval != null)
        'conflictEndInterval': conflictEndInterval,
    };
  }
}
