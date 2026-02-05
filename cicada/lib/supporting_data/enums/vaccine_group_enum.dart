enum VaccineGroup {
  cholera,

  covid19,

  dengue,

  dtapTdapTd,

  ebola,

  hepa,

  hepb,

  hib,

  hpv,

  influenza,

  japaneseEncephalitis,

  meningococcal,

  meningococcalB,

  mmr,

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

  static VaccineGroup? fromString(String string) {
    switch (string) {
      case 'Cholera':
        return VaccineGroup.cholera;
      case 'COVID-19':
        return VaccineGroup.covid19;
      case 'Dengue':
        return VaccineGroup.dengue;
      case 'DTaP/Tdap/Td':
        return VaccineGroup.dtapTdapTd;
      case 'Ebola':
        return VaccineGroup.ebola;
      case 'HepA':
        return VaccineGroup.hepa;
      case 'HepB':
        return VaccineGroup.hepb;
      case 'Hib':
        return VaccineGroup.hib;
      case 'HPV':
        return VaccineGroup.hpv;
      case 'Influenza':
        return VaccineGroup.influenza;
      case 'Japanese Encephalitis':
        return VaccineGroup.japaneseEncephalitis;
      case 'Meningococcal':
        return VaccineGroup.meningococcal;
      case 'Meningococcal B':
        return VaccineGroup.meningococcalB;
      case 'MMR':
        return VaccineGroup.mmr;
      case 'Orthopoxvirus':
        return VaccineGroup.orthopoxvirus;
      case 'Pneumococcal':
        return VaccineGroup.pneumococcal;
      case 'Polio':
        return VaccineGroup.polio;
      case 'Rabies':
        return VaccineGroup.rabies;
      case 'Rotavirus':
        return VaccineGroup.rotavirus;
      case 'RSV':
        return VaccineGroup.rsv;
      case 'TBE':
        return VaccineGroup.tbe;
      case 'Typhoid':
        return VaccineGroup.typhoid;
      case 'Varicella':
        return VaccineGroup.varicella;
      case 'Yellow Fever':
        return VaccineGroup.yellowFever;
      case 'Zoster':
        return VaccineGroup.zoster;
      default:
        return null;
    }
  }

  static VaccineGroup? fromJson(Object? json) {
    if (json is String) {
      return fromString(json);
    }
    return null;
  }

  @override
  String toString() {
    switch (this) {
      case VaccineGroup.cholera:
        return 'Cholera';
      case VaccineGroup.covid19:
        return 'COVID-19';
      case VaccineGroup.dengue:
        return 'Dengue';
      case VaccineGroup.dtapTdapTd:
        return 'DTaP/Tdap/Td';
      case VaccineGroup.ebola:
        return 'Ebola';
      case VaccineGroup.hepa:
        return 'HepA';
      case VaccineGroup.hepb:
        return 'HepB';
      case VaccineGroup.hib:
        return 'Hib';
      case VaccineGroup.hpv:
        return 'HPV';
      case VaccineGroup.influenza:
        return 'Influenza';
      case VaccineGroup.japaneseEncephalitis:
        return 'Japanese Encephalitis';
      case VaccineGroup.meningococcal:
        return 'Meningococcal';
      case VaccineGroup.meningococcalB:
        return 'Meningococcal B';
      case VaccineGroup.mmr:
        return 'MMR';
      case VaccineGroup.orthopoxvirus:
        return 'Orthopoxvirus';
      case VaccineGroup.pneumococcal:
        return 'Pneumococcal';
      case VaccineGroup.polio:
        return 'Polio';
      case VaccineGroup.rabies:
        return 'Rabies';
      case VaccineGroup.rotavirus:
        return 'Rotavirus';
      case VaccineGroup.rsv:
        return 'RSV';
      case VaccineGroup.tbe:
        return 'TBE';
      case VaccineGroup.typhoid:
        return 'Typhoid';
      case VaccineGroup.varicella:
        return 'Varicella';
      case VaccineGroup.yellowFever:
        return 'Yellow Fever';
      case VaccineGroup.zoster:
        return 'Zoster';
    }
  }

  String toJson() => toString();
}
