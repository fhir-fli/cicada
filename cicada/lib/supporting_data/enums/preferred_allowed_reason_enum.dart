enum PreferredAllowedReason {
  notAPreferableOrAllowableVaccine,

  wrongTradeName,

  lessThanRecommendedVolume,

  administeredOutsideOfPreferredAgeRange,

  noPreferredTypes,

  noAllowedTypes;

  static PreferredAllowedReason? fromString(String? string) {
    switch (string?.toString().toLowerCase()) {
      case 'not a preferable or allowable vaccine':
        return PreferredAllowedReason.notAPreferableOrAllowableVaccine;
      case 'wrong trade name':
        return PreferredAllowedReason.wrongTradeName;
      case 'less than recommended volume':
        return PreferredAllowedReason.lessThanRecommendedVolume;
      case 'administered outside of preferred age range':
        return PreferredAllowedReason.administeredOutsideOfPreferredAgeRange;
      case 'no preferred types':
        return PreferredAllowedReason.noPreferredTypes;
      case 'no allowed types':
        return PreferredAllowedReason.noAllowedTypes;
      default:
        return null;
    }
  }

  static PreferredAllowedReason? fromJson(Object? json) {
    return json is String ? fromString(json) : null;
  }

  @override
  String toString() {
    switch (this) {
      case PreferredAllowedReason.notAPreferableOrAllowableVaccine:
        return 'Not a preferable or allowable vaccine';
      case PreferredAllowedReason.wrongTradeName:
        return 'Wrong trade name';
      case PreferredAllowedReason.lessThanRecommendedVolume:
        return 'Less than recommended volume';
      case PreferredAllowedReason.administeredOutsideOfPreferredAgeRange:
        return 'Administered outside of preferred age range';
      case PreferredAllowedReason.noPreferredTypes:
        return 'No preferred types';
      case PreferredAllowedReason.noAllowedTypes:
        return 'No allowed types';
    }
  }

  String toJson() => toString();
}
