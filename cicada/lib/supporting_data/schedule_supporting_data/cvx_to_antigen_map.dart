class CvxToAntigenMap {
  CvxToAntigenMap({this.cvxMap});

  final List<CvxMap>? cvxMap;

  factory CvxToAntigenMap.fromJson(Map<String, dynamic> json) {
    return CvxToAntigenMap(
      cvxMap: (json['cvxMap'] as List<dynamic>?)
          ?.map((e) => CvxMap.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CvxToAntigenMap copyWith({
    List<CvxMap>? cvxMap,
  }) {
    return CvxToAntigenMap(
      cvxMap: cvxMap ?? this.cvxMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (cvxMap != null) 'cvxMap': cvxMap?.map((e) => e.toJson()).toList(),
    };
  }
}

class CvxMap {
  CvxMap({
    this.cvx,
    this.shortDescription,
    this.association,
  });

  final String? cvx;
  final String? shortDescription;
  final List<Association>? association;

  factory CvxMap.fromJson(Map<String, dynamic> json) {
    return CvxMap(
      cvx: json['cvx'] as String?,
      shortDescription: json['shortDescription'] as String?,
      association: (json['association'] as List<dynamic>?)
          ?.map((e) => Association.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CvxMap copyWith({
    String? cvx,
    String? shortDescription,
    List<Association>? association,
  }) {
    return CvxMap(
      cvx: cvx ?? this.cvx,
      shortDescription: shortDescription ?? this.shortDescription,
      association: association ?? this.association,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (cvx != null) 'cvx': cvx,
      if (shortDescription != null) 'shortDescription': shortDescription,
      if (association != null)
        'association': association?.map((e) => e.toJson()).toList(),
    };
  }
}

class Association {
  Association({
    this.antigen,
    this.associationBeginAge,
    this.associationEndAge,
  });

  final String? antigen;
  final String? associationBeginAge;
  final String? associationEndAge;

  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      antigen: json['antigen'],
      associationBeginAge: json['associationBeginAge'] as String?,
      associationEndAge: json['associationEndAge'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (antigen != null) 'antigen': antigen,
      if (associationBeginAge != null)
        'associationBeginAge': associationBeginAge,
      if (associationEndAge != null) 'associationEndAge': associationEndAge,
    };
  }
}
