import 'package:flutter/foundation.dart';

/// A vaccine entry as it appears on a vaccine card — the labels people
/// actually see and recognize.
@immutable
class VaccineCardEntry {
  const VaccineCardEntry({
    required this.id,
    required this.label,
    required this.description,
    required this.defaultCvx,
    this.category = VaccineCategory.childhood,
    this.searchTerms = const [],
    this.comboComponents = const [],
  });

  /// Unique identifier for this entry.
  final String id;

  /// What appears on the vaccine card (e.g., "DTaP", "MMR").
  final String label;

  /// Plain-English description (e.g., "diphtheria, tetanus, pertussis").
  final String description;

  /// Default CVX code mapped for this entry.
  final String defaultCvx;

  /// Category for grouping in the picker.
  final VaccineCategory category;

  /// Additional search terms: brand names, disease names, abbreviations.
  final List<String> searchTerms;

  /// For combo vaccines: IDs of the component vaccine entries this covers.
  /// E.g., Pediarix covers ['dtap', 'hepb', 'ipv'].
  final List<String> comboComponents;

  bool get isCombo => comboComponents.isNotEmpty;

  /// Whether [query] matches this entry (case-insensitive).
  bool matches(String query) {
    final q = query.toLowerCase();
    if (label.toLowerCase().contains(q)) return true;
    if (description.toLowerCase().contains(q)) return true;
    return searchTerms.any((t) => t.toLowerCase().contains(q));
  }
}

enum VaccineCategory {
  childhood('Childhood'),
  adolescent('Adolescent'),
  adult('Adult'),
  travel('Travel & Other')
  ;

  const VaccineCategory(this.displayName);
  final String displayName;
}

/// All vaccine entries available in the picker, ordered by typical
/// schedule sequence.
const List<VaccineCardEntry> vaccineCardEntries = [
  // --- Childhood ---
  VaccineCardEntry(
    id: 'hepb',
    label: 'HepB',
    description: 'Hepatitis B',
    defaultCvx: '08',
    searchTerms: [
      'hepatitis b',
      'hep b',
      'engerix',
      'recombivax',
    ],
  ),
  VaccineCardEntry(
    id: 'rotavirus',
    label: 'Rotavirus',
    description: 'Rotavirus',
    defaultCvx: '122',
    searchTerms: ['rotateq', 'rotarix', 'rota'],
  ),
  VaccineCardEntry(
    id: 'dtap',
    label: 'DTaP',
    description: 'Diphtheria, tetanus, pertussis (childhood)',
    defaultCvx: '20',
    searchTerms: [
      'diphtheria',
      'tetanus',
      'pertussis',
      'whooping cough',
      'infanrix',
      'daptacel',
    ],
  ),
  VaccineCardEntry(
    id: 'hib',
    label: 'Hib',
    description: 'Haemophilus influenzae type b',
    defaultCvx: '17',
    searchTerms: ['haemophilus', 'actacel', 'pedvaxhib', 'hiberix'],
  ),
  VaccineCardEntry(
    id: 'ipv',
    label: 'IPV',
    description: 'Polio (inactivated)',
    defaultCvx: '10',
    searchTerms: ['polio', 'poliovirus', 'ipol'],
  ),
  VaccineCardEntry(
    id: 'pcv',
    label: 'PCV',
    description: 'Pneumococcal conjugate',
    defaultCvx: '152',
    searchTerms: [
      'pneumococcal',
      'prevnar',
      'pcv13',
      'pcv15',
      'pcv20',
      'vaxneuvance',
    ],
  ),
  VaccineCardEntry(
    id: 'mmr',
    label: 'MMR',
    description: 'Measles, mumps, rubella',
    defaultCvx: '03',
    searchTerms: ['measles', 'mumps', 'rubella', 'priorix', 'm-m-r ii'],
  ),
  VaccineCardEntry(
    id: 'varicella',
    label: 'Varicella',
    description: 'Chickenpox',
    defaultCvx: '21',
    searchTerms: ['chickenpox', 'chicken pox', 'varivax'],
  ),
  VaccineCardEntry(
    id: 'hepa',
    label: 'HepA',
    description: 'Hepatitis A',
    defaultCvx: '85',
    searchTerms: ['hepatitis a', 'hep a', 'havrix', 'vaqta'],
  ),

  // --- Adolescent ---
  VaccineCardEntry(
    id: 'tdap',
    label: 'Tdap',
    description: 'Tetanus, diphtheria, pertussis (booster)',
    defaultCvx: '115',
    category: VaccineCategory.adolescent,
    searchTerms: [
      'tetanus booster',
      'boostrix',
      'adacel',
      'tetanus',
      'diphtheria',
      'pertussis',
    ],
  ),
  VaccineCardEntry(
    id: 'hpv',
    label: 'HPV',
    description: 'Human papillomavirus',
    defaultCvx: '165',
    category: VaccineCategory.adolescent,
    searchTerms: ['gardasil', 'gardasil 9', 'papillomavirus', 'cervarix'],
  ),
  VaccineCardEntry(
    id: 'menacwy',
    label: 'MenACWY',
    description: 'Meningococcal ACWY',
    defaultCvx: '114',
    category: VaccineCategory.adolescent,
    searchTerms: [
      'meningococcal',
      'meningitis',
      'menactra',
      'menveo',
      'menquadfi',
    ],
  ),
  VaccineCardEntry(
    id: 'menb',
    label: 'MenB',
    description: 'Meningococcal B',
    defaultCvx: '164',
    category: VaccineCategory.adolescent,
    searchTerms: ['meningococcal b', 'bexsero', 'trumenba'],
  ),

  // --- Adult ---
  VaccineCardEntry(
    id: 'influenza',
    label: 'Influenza',
    description: 'Flu shot',
    defaultCvx: '158',
    category: VaccineCategory.adult,
    searchTerms: ['flu', 'flu shot', 'fluzone', 'flublok', 'fluarix'],
  ),
  VaccineCardEntry(
    id: 'covid19',
    label: 'COVID-19',
    description: 'COVID-19 vaccine',
    defaultCvx: '213',
    category: VaccineCategory.adult,
    searchTerms: [
      'covid',
      'coronavirus',
      'pfizer',
      'moderna',
      'novavax',
      'comirnaty',
      'spikevax',
    ],
  ),
  VaccineCardEntry(
    id: 'zoster',
    label: 'Zoster',
    description: 'Shingles (Shingrix)',
    defaultCvx: '187',
    category: VaccineCategory.adult,
    searchTerms: ['shingles', 'shingrix', 'zostavax', 'herpes zoster'],
  ),
  VaccineCardEntry(
    id: 'td',
    label: 'Td',
    description: 'Tetanus, diphtheria (adult)',
    defaultCvx: '09',
    category: VaccineCategory.adult,
    searchTerms: ['tetanus', 'diphtheria', 'tenivac', 'tetanus booster'],
  ),

  // --- Travel & Other ---
  VaccineCardEntry(
    id: 'yellowfever',
    label: 'Yellow Fever',
    description: 'Yellow fever',
    defaultCvx: '184',
    category: VaccineCategory.travel,
    searchTerms: ['yf-vax', 'stamaril'],
  ),
  VaccineCardEntry(
    id: 'rabies',
    label: 'Rabies',
    description: 'Rabies',
    defaultCvx: '90',
    category: VaccineCategory.travel,
    searchTerms: ['imovax', 'rabavert'],
  ),
  VaccineCardEntry(
    id: 'typhoid',
    label: 'Typhoid',
    description: 'Typhoid fever',
    defaultCvx: '91',
    category: VaccineCategory.travel,
    searchTerms: ['typhim', 'vivotif'],
  ),
  VaccineCardEntry(
    id: 'japanese_encephalitis',
    label: 'JE',
    description: 'Japanese encephalitis',
    defaultCvx: '129',
    category: VaccineCategory.travel,
    searchTerms: ['japanese encephalitis', 'ixiaro'],
  ),
  VaccineCardEntry(
    id: 'cholera',
    label: 'Cholera',
    description: 'Cholera',
    defaultCvx: '26',
    category: VaccineCategory.travel,
    searchTerms: ['vaxchora'],
  ),
];

/// Combo vaccines — selecting one auto-adds the component groups.
const List<VaccineCardEntry> comboVaccineEntries = [
  VaccineCardEntry(
    id: 'combo_pediarix',
    label: 'Pediarix',
    description: 'DTaP + HepB + IPV (combo)',
    defaultCvx: '110',
    searchTerms: ['pediarix'],
    comboComponents: ['dtap', 'hepb', 'ipv'],
  ),
  VaccineCardEntry(
    id: 'combo_pentacel',
    label: 'Pentacel',
    description: 'DTaP + IPV + Hib (combo)',
    defaultCvx: '120',
    searchTerms: ['pentacel'],
    comboComponents: ['dtap', 'ipv', 'hib'],
  ),
  VaccineCardEntry(
    id: 'combo_kinrix',
    label: 'Kinrix',
    description: 'DTaP + IPV (combo)',
    defaultCvx: '130',
    searchTerms: ['kinrix', 'quadracel'],
    comboComponents: ['dtap', 'ipv'],
  ),
  VaccineCardEntry(
    id: 'combo_proquad',
    label: 'ProQuad',
    description: 'MMR + Varicella (combo)',
    defaultCvx: '94',
    searchTerms: ['proquad', 'mmrv'],
    comboComponents: ['mmr', 'varicella'],
  ),
  VaccineCardEntry(
    id: 'combo_twinrix',
    label: 'Twinrix',
    description: 'HepA + HepB (combo)',
    defaultCvx: '104',
    searchTerms: ['twinrix'],
    comboComponents: ['hepa', 'hepb'],
  ),
  VaccineCardEntry(
    id: 'combo_vaxelis',
    label: 'Vaxelis',
    description: 'DTaP + IPV + Hib + HepB (combo)',
    defaultCvx: '146',
    searchTerms: ['vaxelis'],
    comboComponents: ['dtap', 'ipv', 'hib', 'hepb'],
  ),
];

/// Look up a vaccine card entry by ID.
VaccineCardEntry? vaccineById(String id) {
  for (final entry in vaccineCardEntries) {
    if (entry.id == id) return entry;
  }
  for (final entry in comboVaccineEntries) {
    if (entry.id == id) return entry;
  }
  return null;
}
