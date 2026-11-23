import 'dart:io';

import 'package:cicada/cicada.dart';
import 'package:test/test.dart';

/// Dates are calendar dates: the same year, month and day whatever time
/// zone the engine runs in.
///
/// Until 2026-11-23 a date written out by the engine carried a time and the
/// machine's offset (`2016-08-22T00:00:00.000+03:00`). A Condition's onset
/// is written into a Period that way and read back later; read back, that
/// value names 2016-08-21T21:00Z, so east of UTC every onset date came back
/// a day early. CDC case 2016-UC-0130 failed under Africa/Kampala,
/// Europe/Berlin and Pacific/Kiritimati and passed in the Americas, where
/// the shift lands later on the same day.
void main() {
  test('a date is written as FHIR writes a date, with no time or zone', () {
    // The ImmDS IG's ImmunizationRecommendation example writes every
    // dateCriterion value this way ("2020-05-28").
    expect(VaxDate(2016, 8, 22).toFhirDateTime().toString(), '2016-08-22');
    expect(VaxDate(2016, 8, 22).toFhirDate().toString(), '2016-08-22');
  });

  test('a date written out and read back is the same date', () {
    final date = VaxDate(2016, 8, 22);
    final back = VaxDate.fromDateTime(date.toFhirDateTime().valueDateTime!);
    expect(back.isEqualTo(date), isTrue, reason: '$back');
  });

  test('dates compare by calendar day', () {
    expect(VaxDate(2016, 8, 22) < VaxDate(2016, 8, 23), isTrue);
    expect(VaxDate(2016, 12, 31) < VaxDate(2017, 1, 1), isTrue);
    expect(VaxDate(2016, 8, 22) > VaxDate(2016, 8, 22), isFalse);
    expect(VaxDate(2016, 8, 22).isEqualTo(VaxDate(2016, 8, 22)), isTrue);
  });

  test('CALCDT-5: a date that does not exist moves to the next month', () {
    expect(VaxDate(2016, 1, 31).change('1 month').toString(), '2016/03/01');
    expect(
      VaxDate(2016, 1, 31).change('1 month + 4 days').toString(),
      '2016/03/05',
    );
  });

  // The time zone is fixed when the process starts, so the zones are run in
  // child processes. Kiritimati is UTC+14 and Pago Pago UTC-11, the two
  // extremes.
  for (final zone in [
    'Africa/Kampala',
    'Pacific/Kiritimati',
    'Pacific/Pago_Pago',
  ]) {
    test('the round trip holds in $zone', () async {
      final r = await Process.run(
        Platform.resolvedExecutable,
        ['test', 'test/vax_date_test.dart', '--name', 'is the same date'],
        environment: {'TZ': zone, 'CICADA_TZ_CHILD': '1'},
      );
      expect(r.exitCode, 0, reason: '${r.stdout}\n${r.stderr}');
    }, skip: Platform.environment['CICADA_TZ_CHILD'] == '1');
  }
}
