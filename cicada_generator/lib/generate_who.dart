import 'dart:io';

/// WHO source data has been migrated to Excel files.
///
/// The Excel files in WHO/antigen/*.xlsx and WHO/schedule/*.xlsx are the
/// human-editable source of truth for WHO immunization definitions.
///
/// To regenerate Dart code from Excel:
///   dart cicada_generator/lib/main.dart --who
///
/// The workbooks are in the CDC CDSi 4.65 layout. To rewrite them from the
/// model (after a change to the layout or the writers) and prove the round
/// trip: dart run lib/write_who_workbooks.dart [--schedule] --apply
void main() {
  stdout.write('''
WHO source data is now maintained in Excel files.

Source files:
  cicada_generator/lib/WHO/antigen/*.xlsx  (22 antigen definitions)
  cicada_generator/lib/WHO/schedule/*.xlsx  (5 schedule data files)

To regenerate Dart from Excel:
  dart cicada_generator/lib/main.dart --who
''');
}
