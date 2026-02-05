enum TargetDisease {
  cholera,

  covid19,

  dengue,

  diphtheria,

  pertussis,

  tetanus,

  ebola,

  hepa,

  hepb,

  hib,

  hpv,

  influenza,

  japaneseEncephalitis,

  meningococcal,

  meningococcalB,

  measles,

  mumps,

  rubella,

  orthopoxvirus,

  pneumococcal,

  polio,

  rabies,

  rotavirus,

  rsv,

  tbe,

  typhoid,

  varicella,

  yellowFever,

  zoster;

  static TargetDisease? fromString(String string) {
    switch (string) {
      case 'Cholera':
        return TargetDisease.cholera;
      case 'COVID-19':
        return TargetDisease.covid19;
      case 'Dengue':
        return TargetDisease.dengue;
      case 'Diphtheria':
        return TargetDisease.diphtheria;
      case 'Pertussis':
        return TargetDisease.pertussis;
      case 'Tetanus':
        return TargetDisease.tetanus;
      case 'Ebola':
        return TargetDisease.ebola;
      case 'HepA':
        return TargetDisease.hepa;
      case 'HepB':
        return TargetDisease.hepb;
      case 'Hib':
        return TargetDisease.hib;
      case 'HPV':
        return TargetDisease.hpv;
      case 'Influenza':
        return TargetDisease.influenza;
      case 'Japanese Encephalitis':
        return TargetDisease.japaneseEncephalitis;
      case 'Meningococcal':
        return TargetDisease.meningococcal;
      case 'Meningococcal B':
        return TargetDisease.meningococcalB;
      case 'Measles':
        return TargetDisease.measles;
      case 'Mumps':
        return TargetDisease.mumps;
      case 'Rubella':
        return TargetDisease.rubella;
      case 'Orthopoxvirus':
        return TargetDisease.orthopoxvirus;
      case 'Pneumococcal':
        return TargetDisease.pneumococcal;
      case 'Polio':
        return TargetDisease.polio;
      case 'Rabies':
        return TargetDisease.rabies;
      case 'Rotavirus':
        return TargetDisease.rotavirus;
      case 'RSV':
        return TargetDisease.rsv;
      case 'TBE':
        return TargetDisease.tbe;
      case 'Typhoid':
        return TargetDisease.typhoid;
      case 'Varicella':
        return TargetDisease.varicella;
      case 'Yellow Fever':
        return TargetDisease.yellowFever;
      case 'Zoster':
        return TargetDisease.zoster;
      default:
        return null;
    }
  }

  static TargetDisease? fromJson(Object? json) {
    if (json is String) {
      return fromString(json);
    }
    return null;
  }

  @override
  String toString() {
    switch (this) {
      case TargetDisease.cholera:
        return 'Cholera';
      case TargetDisease.covid19:
        return 'COVID-19';
      case TargetDisease.dengue:
        return 'Dengue';
      case TargetDisease.diphtheria:
        return 'Diphtheria';
      case TargetDisease.pertussis:
        return 'Pertussis';
      case TargetDisease.tetanus:
        return 'Tetanus';
      case TargetDisease.ebola:
        return 'Ebola';
      case TargetDisease.hepa:
        return 'HepA';
      case TargetDisease.hepb:
        return 'HepB';
      case TargetDisease.hib:
        return 'Hib';
      case TargetDisease.hpv:
        return 'HPV';
      case TargetDisease.influenza:
        return 'Influenza';
      case TargetDisease.japaneseEncephalitis:
        return 'Japanese Encephalitis';
      case TargetDisease.meningococcal:
        return 'Meningococcal';
      case TargetDisease.meningococcalB:
        return 'Meningococcal B';
      case TargetDisease.measles:
        return 'Measles';
      case TargetDisease.mumps:
        return 'Mumps';
      case TargetDisease.rubella:
        return 'Rubella';
      case TargetDisease.orthopoxvirus:
        return 'Orthopoxvirus';
      case TargetDisease.pneumococcal:
        return 'Pneumococcal';
      case TargetDisease.polio:
        return 'Polio';
      case TargetDisease.rabies:
        return 'Rabies';
      case TargetDisease.rotavirus:
        return 'Rotavirus';
      case TargetDisease.rsv:
        return 'RSV';
      case TargetDisease.tbe:
        return 'TBE';
      case TargetDisease.typhoid:
        return 'Typhoid';
      case TargetDisease.varicella:
        return 'Varicella';
      case TargetDisease.yellowFever:
        return 'Yellow Fever';
      case TargetDisease.zoster:
        return 'Zoster';
    }
  }

  String toJson() => toString();
}
