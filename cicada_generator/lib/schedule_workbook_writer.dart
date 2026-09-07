// Writes a [ScheduleSupportingData] as the five workbooks CDC publishes for
// CDSi 4.65 schedule supporting data, in CDC's layout: the same sheet names,
// the same column headings, "n/a" for an empty cell, a Change History sheet
// in every workbook, and an Overview sheet in Coded Observations.
// ScheduleSheetParser reads the result (it dispatches on the file name and
// reads rows by position, so the file names below must keep their words).
import 'package:cicada/cicada.dart';
import 'package:excel/excel.dart';

class ScheduleWorkbookWriter {
  ScheduleWorkbookWriter({this.overview = const []});

  /// Overview lines for the Coded Observations workbook.
  final List<String> overview;

  /// The five workbooks, keyed by the CDC file-name stem ("Coded
  /// Observations", "CVX to Antigen Map", "Live Virus Conflicts", "Vaccine
  /// Group", "Vaccine Group to Antigen Map").
  Map<String, Excel> write(ScheduleSupportingData data) => {
        'Coded Observations': _codedObservations(data.observations),
        'CVX to Antigen Map': _cvxToAntigenMap(data.cvxToAntigenMap),
        'Live Virus Conflicts': _liveVirusConflicts(data.liveVirusConflicts),
        'Vaccine Group': _vaccineGroups(data.vaccineGroups),
        'Vaccine Group to Antigen Map':
            _vaccineGroupToAntigenMap(data.vaccineGroupToAntigenMap),
      };

  Excel _codedObservations(VaxObservations? obs) {
    final excel = Excel.createExcel();
    final sheet = excel['Conditions'];
    _add(sheet, [
      'Observation Code', 'Observation Title', 'Indication Text Description',
      'Contraindication Text Description', 'Clarifying Text', 'SNOMED (Code)',
      'CVX (Code)', 'PHIN VS (Code)',
    ]);
    for (final o in obs?.observation ?? const <VaxObservation>[]) {
      final values = o.codedValues?.codedValue ?? const <CodedValue>[];
      String bySystem(String system) {
        final v = values.where((c) => c.codeSystem == system).toList();
        return v.isEmpty
            ? 'n/a'
            : v.map((c) => _codeText(c.text, c.code)).join('; ');
      }
      _add(sheet, [
        _na(o.observationCode), _na(o.observationTitle), _na(o.indicationText),
        _na(o.contraindicationText), _na(o.clarifyingText), bySystem('SNOMED'),
        bySystem('CVX'), bySystem('CDCPHINVS'),
      ]);
    }
    _changeHistory(excel);
    final ov = excel['Overview'];
    final lines = overview.isEmpty
        ? [
            'The Observation Code is the identifier the antigen workbooks use '
                'for an indication or contraindication. The coded values are the '
                'SNOMED, CVX and PHIN VS codes a patient record may carry for it.',
          ]
        : overview;
    var first = true;
    for (final l in lines) {
      _add(ov, [first ? 'Overview' : '', l]);
      _add(ov, const []);
      first = false;
    }
    excel.delete('Sheet1');
    return excel;
  }

  Excel _cvxToAntigenMap(CvxToAntigenMap? map) {
    final excel = Excel.createExcel();
    final sheet = excel['CVX to Antigen Map'];
    _add(sheet, [
      'CVX Code', 'Short Description', 'Antigen', 'Association Begin Age',
      'Association End Age',
    ]);
    for (final m in map?.cvxMap ?? const <CvxMap>[]) {
      for (final a in m.association ?? const <Association>[]) {
        _add(sheet, [
          _na(m.cvx), _na(m.shortDescription), _na(a.antigen),
          _na(a.associationBeginAge), _na(a.associationEndAge),
        ]);
      }
    }
    _changeHistory(excel);
    excel.delete('Sheet1');
    return excel;
  }

  Excel _liveVirusConflicts(LiveVirusConflicts? conflicts) {
    final excel = Excel.createExcel();
    final sheet = excel['Live Virus Conflicts'];
    _add(sheet, [
      'Previous Vaccine Type (CVX)', 'Current Vaccine Type (CVX)',
      'Conflict Begin Interval', 'Minimum Conflict End Interval',
      'Conflict End Interval',
    ]);
    for (final c in conflicts?.liveVirusConflict ?? const <LiveVirusConflict>[]) {
      _add(sheet, [
        _codeText(c.previous?.vaccineType, c.previous?.cvx),
        _codeText(c.current?.vaccineType, c.current?.cvx),
        _na(c.conflictBeginInterval), _na(c.minConflictEndInterval),
        _na(c.conflictEndInterval),
      ]);
    }
    _changeHistory(excel);
    excel.delete('Sheet1');
    return excel;
  }

  Excel _vaccineGroups(VaccineGroups? groups) {
    final excel = Excel.createExcel();
    final sheet = excel['Vaccine Groups'];
    _add(sheet, ['Vaccine Group', 'Administer Full Vaccine Group']);
    for (final g in groups?.vaccineGroup ?? const <VaccineGroup>[]) {
      _add(sheet, [_na(g.name), _na(g.administerFullVaccineGroup?.toString())]);
    }
    _changeHistory(excel);
    excel.delete('Sheet1');
    return excel;
  }

  Excel _vaccineGroupToAntigenMap(VaccineGroupToAntigenMap? map) {
    final excel = Excel.createExcel();
    final sheet = excel['Vaccine Group to Antigen Map'];
    _add(sheet, ['Vaccine Group', 'Antigen']);
    for (final g in map?.vaccineGroupMap ?? const <VaccineGroupMap>[]) {
      for (final a in g.antigen ?? const <String>[]) {
        _add(sheet, [_na(g.name), _na(a)]);
      }
    }
    _changeHistory(excel);
    excel.delete('Sheet1');
    return excel;
  }

  static void _changeHistory(Excel excel) {
    final sheet = excel['Change History'];
    _add(sheet, ['Version', 'n/a', 'Publication Date: n/a']);
    _add(sheet, [
      'Change', 'Change #', 'Area', 'Previous Values', 'Change',
      'Reason for Change',
    ]);
  }

  static void _add(Sheet sheet, List<String> cells) {
    sheet.appendRow(cells.map<CellValue?>(TextCellValue.new).toList());
  }

  static String _na(String? v) => v == null || v.isEmpty ? 'n/a' : v;

  static String _codeText(String? text, String? code) {
    if ((code == null || code.isEmpty) && (text == null || text.isEmpty)) {
      return 'n/a';
    }
    if (code == null || code.isEmpty) return text!;
    return '${text ?? ''} ($code)'.trim();
  }
}
