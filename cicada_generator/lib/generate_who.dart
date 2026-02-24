/// WHO source data has been migrated to Excel files.
///
/// The Excel files in WHO/antigen/*.xlsx and WHO/schedule/*.xlsx are the
/// human-editable source of truth for WHO immunization definitions.
///
/// To regenerate Dart code from Excel:
///   dart cicada_generator/lib/main.dart --who
///
/// The one-time migration tool that created the Excel files from the original
/// hardcoded JSON definitions is: generate_who_excel.dart
void main() {
  print('WHO source data is now maintained in Excel files.');
  print('');
  print('Source files:');
  print('  cicada_generator/lib/WHO/antigen/*.xlsx  (22 antigen definitions)');
  print('  cicada_generator/lib/WHO/schedule/*.xlsx  (5 schedule data files)');
  print('');
  print('To regenerate Dart from Excel:');
  print('  dart cicada_generator/lib/main.dart --who');
}
