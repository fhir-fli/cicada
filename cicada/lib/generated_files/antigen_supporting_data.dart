import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/chikungunya.dart';
import 'package:cicada/generated_files/cholera.dart';
import 'package:cicada/generated_files/covid_19.dart';
import 'package:cicada/generated_files/dengue.dart';
import 'package:cicada/generated_files/diphtheria.dart';
import 'package:cicada/generated_files/ebola.dart';
import 'package:cicada/generated_files/hepa.dart';
import 'package:cicada/generated_files/hepb.dart';
import 'package:cicada/generated_files/hib.dart';
import 'package:cicada/generated_files/hpv.dart';
import 'package:cicada/generated_files/influenza.dart';
import 'package:cicada/generated_files/japanese_encephalitis.dart';
import 'package:cicada/generated_files/measles.dart';
import 'package:cicada/generated_files/meningococcal.dart';
import 'package:cicada/generated_files/meningococcal_b.dart';
import 'package:cicada/generated_files/mumps.dart';
import 'package:cicada/generated_files/orthopoxvirus.dart';
import 'package:cicada/generated_files/pertussis.dart';
import 'package:cicada/generated_files/pneumococcal.dart';
import 'package:cicada/generated_files/polio.dart';
import 'package:cicada/generated_files/rabies.dart';
import 'package:cicada/generated_files/rotavirus.dart';
import 'package:cicada/generated_files/rsv.dart';
import 'package:cicada/generated_files/rubella.dart';
import 'package:cicada/generated_files/tbe.dart';
import 'package:cicada/generated_files/tetanus.dart';
import 'package:cicada/generated_files/typhoid.dart';
import 'package:cicada/generated_files/varicella.dart';
import 'package:cicada/generated_files/yellow_fever.dart';
import 'package:cicada/generated_files/zoster.dart';

final List<AntigenSupportingData> antigenSupportingData = [
  typhoid,
  dengue,
  mumps,
  japaneseEncephalitis,
  pertussis,
  influenza,
  measles,
  hib,
  cholera,
  ebola,
  tetanus,
  chikungunya,
  pneumococcal,
  varicella,
  hepb,
  meningococcal,
  covid19,
  diphtheria,
  tbe,
  rubella,
  rabies,
  polio,
  zoster,
  hepa,
  yellowFever,
  rsv,
  hpv,
  meningococcalB,
  rotavirus,
  orthopoxvirus,
];

final Map<String, AntigenSupportingData> antigenSupportingDataMap = {
  'Typhoid': typhoid,
  'Dengue': dengue,
  'Mumps': mumps,
  'Japanese Encephalitis': japaneseEncephalitis,
  'Pertussis': pertussis,
  'Influenza': influenza,
  'Measles': measles,
  'Hib': hib,
  'Cholera': cholera,
  'Ebola': ebola,
  'Tetanus': tetanus,
  'Chikungunya': chikungunya,
  'Pneumococcal': pneumococcal,
  'Varicella': varicella,
  'HepB': hepb,
  'Meningococcal': meningococcal,
  'COVID-19': covid19,
  'Diphtheria': diphtheria,
  'TBE': tbe,
  'Rubella': rubella,
  'Rabies': rabies,
  'Polio': polio,
  'Zoster': zoster,
  'HepA': hepa,
  'Yellow Fever': yellowFever,
  'RSV': rsv,
  'HPV': hpv,
  'Meningococcal B': meningococcalB,
  'Rotavirus': rotavirus,
  'Orthopoxvirus': orthopoxvirus,
};
