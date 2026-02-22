enum EvalReason {
  noDateGiven,

  noCvx,

  expired,

  ageTooOld,

  ageTooYoung,

  inadvertentVaccine,

  notPreferableOrAllowable,

  notRecommendedVolume,

  partialDose,

  coldChainBreak,

  recall,

  adverseStorage,

  intervalTooShort,

  seriesAlreadyCompleted,

  liveVirusConflict;

  static EvalReason? fromString(String? string) {
    switch (string) {
      case 'No Date Given':
        return EvalReason.noDateGiven;
      case 'No Cvx':
        return EvalReason.noCvx;
      case 'Expired Product':
        return EvalReason.expired;
      case 'Age: Too Old':
        return EvalReason.ageTooOld;
      case 'Age: Too Young':
        return EvalReason.ageTooYoung;
      case 'Inadvertent Vaccine':
        return EvalReason.inadvertentVaccine;
      case 'Not a preferable or allowable vaccine':
        return EvalReason.notPreferableOrAllowable;
      case 'Volume administered is less than recommended volume':
        return EvalReason.notRecommendedVolume;
      case 'Partial Dose':
        return EvalReason.partialDose;
      case 'Cold Chain Break':
        return EvalReason.coldChainBreak;
      case 'Manufacturer Recall':
        return EvalReason.recall;
      case 'Adverse Storage':
        return EvalReason.adverseStorage;
      case 'Interval: too short':
      case 'Interval: too Soon':
        return EvalReason.intervalTooShort;
      case 'Series Already Completed':
      case 'Series Already Complete':
        return EvalReason.seriesAlreadyCompleted;
      case 'Live Virus Conflict':
        return EvalReason.liveVirusConflict;
      default:
        return null;
    }
  }

  static EvalReason? fromJson(String? json) => fromString(json);

  static EvalReason? fromCode(String? code) {
    switch (code) {
      case 'partialdose':
        return EvalReason.partialDose;
      case 'coldchainbreak':
        return EvalReason.coldChainBreak;
      case 'recall':
        return EvalReason.recall;
      case 'adversestorage':
        return EvalReason.adverseStorage;
      case 'expired':
        return EvalReason.expired;
      default:
        return null;
    }
  }

  @override
  String toString() {
    switch (this) {
      case EvalReason.noDateGiven:
        return 'No Date Given';
      case EvalReason.noCvx:
        return 'No Cvx';
      case EvalReason.expired:
        return 'Expired Product';
      case EvalReason.ageTooOld:
        return 'Age: Too Old';
      case EvalReason.ageTooYoung:
        return 'Age: Too Young';
      case EvalReason.inadvertentVaccine:
        return 'Inadvertent Vaccine';
      case EvalReason.notPreferableOrAllowable:
        return 'Not a preferable or allowable vaccine';
      case EvalReason.notRecommendedVolume:
        return 'Volume administered is less than recommended volume';
      case EvalReason.partialDose:
        return 'Partial Dose';
      case EvalReason.coldChainBreak:
        return 'Cold Chain Break';
      case EvalReason.recall:
        return 'Manufacturer Recall';
      case EvalReason.adverseStorage:
        return 'Adverse Storage';
      case EvalReason.intervalTooShort:
        return 'Interval: too short';
      case EvalReason.seriesAlreadyCompleted:
        return 'Series Already Completed';
      case EvalReason.liveVirusConflict:
        return 'Live Virus Conflict';
    }
  }

  String toJson() => toString();
}
