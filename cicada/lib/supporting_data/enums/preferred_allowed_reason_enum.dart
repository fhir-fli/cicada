enum PreferredAllowedReason {
  notAPreferableOrAllowableVaccine,

  wrongTradeName,

  lessThanRecommendedVolume,

  administeredOutsideOfPreferredAgeRange,

  /// Table 6-29, third rule: the vaccine type is an allowable vaccine for
  /// the target dose, but the date administered is before the allowable
  /// vaccine type begin age date.
  administeredBeforeAllowableAgeRange,

  /// Table 6-29, third rule: the vaccine type is an allowable vaccine for
  /// the target dose, but the date administered is on or after the
  /// allowable vaccine type end age date.
  administeredAfterAllowableAgeRange,

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
      case 'administered before allowable age range':
        return PreferredAllowedReason.administeredBeforeAllowableAgeRange;
      case 'administered after allowable age range':
        return PreferredAllowedReason.administeredAfterAllowableAgeRange;
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
      case PreferredAllowedReason.administeredBeforeAllowableAgeRange:
        return 'Administered before allowable age range';
      case PreferredAllowedReason.administeredAfterAllowableAgeRange:
        return 'Administered after allowable age range';
      case PreferredAllowedReason.noPreferredTypes:
        return 'No preferred types';
      case PreferredAllowedReason.noAllowedTypes:
        return 'No allowed types';
    }
  }

  String toJson() => toString();
}
