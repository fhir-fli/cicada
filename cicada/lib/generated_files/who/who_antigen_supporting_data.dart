import 'package:cicada/cicada.dart';
import 'package:cicada/generated_files/who/cholera.dart';
import 'package:cicada/generated_files/who/covid_19.dart';
import 'package:cicada/generated_files/who/diphtheria.dart';
import 'package:cicada/generated_files/who/hepa.dart';
import 'package:cicada/generated_files/who/hepb.dart';
import 'package:cicada/generated_files/who/hib.dart';
import 'package:cicada/generated_files/who/hpv.dart';
import 'package:cicada/generated_files/who/influenza.dart';
import 'package:cicada/generated_files/who/japanese_encephalitis.dart';
import 'package:cicada/generated_files/who/measles.dart';
import 'package:cicada/generated_files/who/meningococcal.dart';
import 'package:cicada/generated_files/who/mumps.dart';
import 'package:cicada/generated_files/who/pertussis.dart';
import 'package:cicada/generated_files/who/pneumococcal.dart';
import 'package:cicada/generated_files/who/polio.dart';
import 'package:cicada/generated_files/who/rabies.dart';
import 'package:cicada/generated_files/who/rotavirus.dart';
import 'package:cicada/generated_files/who/rubella.dart';
import 'package:cicada/generated_files/who/tetanus.dart';
import 'package:cicada/generated_files/who/tuberculosis.dart';
import 'package:cicada/generated_files/who/typhoid.dart';
import 'package:cicada/generated_files/who/yellow_fever.dart';

final List<AntigenSupportingData> whoAntigenSupportingData = [
  whoRabies,
  whoJapaneseEncephalitis,
  whoRubella,
  whoInfluenza,
  whoHib,
  whoHpv,
  whoPertussis,
  whoTetanus,
  whoMeningococcal,
  whoPneumococcal,
  whoRotavirus,
  whoCholera,
  whoDiphtheria,
  whoMumps,
  whoTyphoid,
  whoHepa,
  whoPolio,
  whoMeasles,
  whoCovid19,
  whoYellowFever,
  whoHepb,
  whoTuberculosis,
];

final Map<String, AntigenSupportingData> whoAntigenSupportingDataMap = {
  'Rabies': whoRabies,
  'Japanese Encephalitis': whoJapaneseEncephalitis,
  'Rubella': whoRubella,
  'Influenza': whoInfluenza,
  'Hib': whoHib,
  'HPV': whoHpv,
  'Pertussis': whoPertussis,
  'Tetanus': whoTetanus,
  'Meningococcal': whoMeningococcal,
  'Pneumococcal': whoPneumococcal,
  'Rotavirus': whoRotavirus,
  'Cholera': whoCholera,
  'Diphtheria': whoDiphtheria,
  'Mumps': whoMumps,
  'Typhoid': whoTyphoid,
  'HepA': whoHepa,
  'Polio': whoPolio,
  'Measles': whoMeasles,
  'COVID-19': whoCovid19,
  'Yellow Fever': whoYellowFever,
  'HepB': whoHepb,
  'Tuberculosis': whoTuberculosis,
};
