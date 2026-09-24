// ignore_for_file: lines_longer_than_80_chars
// The mismatch lines are the suite's own output, quoted whole so a failure
// can be searched for verbatim.

// The CDC test rows this project has ruled against, with the ruling.
//
// A ruled case still asserts every field: the engine must differ from CDC's
// row in exactly the recorded way (the suite's own mismatch lines). If it
// comes to match the row, the ruling is stale and the case fails until the
// entry is deleted; if it differs in any new way, that is a regression
// against the ruling. Nothing here is skipped.
//
// Every ruling names where it is written: CDSI-OE-ADJUDICATED.md (the
// OpenEvidence archive, by section), CDC-REPORT.md (the findings sent to
// CDC, by number) and CDSI-DISPUTED-CASES.md (the rows themselves). The
// mismatch lines were taken from the suite run of 2026-09-23 (1,379 passed,
// these 26), not typed.

/// One ruled case: where the ruling is written, and the exact lines the
/// suite must produce for it.
class Ruling {
  const Ruling({required this.citation, required this.mismatches});

  /// The document and section that records the decision.
  final String citation;

  /// The suite's mismatch lines, in the order the suite produces them.
  final List<String> mismatches;
}

/// CDC test id -> ruling.
const rulings = <String, Ruling>{
  '2016-UC-0032': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): no latest recommended '
        'interval exists on that MMR dose in 4.65-508 or 4.64; CDC-REPORT.md '
        '§5',
    mismatches: [
      '[MMR] pastDue: expected=2021/05/27 actual=2015/05/28',
    ],
  ),
  '2016-UC-0057': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §10 (2026-08-24): the high-risk Hib 2-dose '
        'rule applies only at 12–59 months (MMWR 63(RR-01)); a 5-month-old '
        'stays on the routine series; CDC-REPORT.md §5',
    mismatches: [
      '[Hib] earliest: expected=2015/08/10 actual=2015/02/07',
      '[Hib] recommended: expected=2015/08/10 actual=2015/02/07',
    ],
  ),
  '2016-UC-0060': Ruling(
    citation:
        'CDSI-DISPUTED-CASES.md 2016-UC-0060: the row contradicts itself '
        '(named "36 months of age", assessed 2013-07-08 at 2.5 months, both '
        'doses "before 12 months"); the engine follows the data. Classified '
        'do-not-conform 2026-08',
    mismatches: [
      '[Hib] earliest: expected=2013/09/02 actual=2013/08/05',
      '[Hib] recommended: expected=2013/09/02 actual=2013/08/05',
    ],
  ),
  '2016-UC-0079': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): history of sexual abuse is a '
        'routine-age trigger, not a risk series (MMWR 65(49)); the indication '
        'ends at 11 and she is 12 at assessment (Table 5-4); CDC-REPORT.md §5',
    mismatches: [
      'dose 2016-UC-0079_dose2: not found in any evaluated series (expected Valid, seriesType=risk)',
    ],
  ),
  '2016-UC-0087': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): no HPV risk series is '
        'indicated by observation 036 any more (MMWR 65(49), 68(32)); '
        'CDC-REPORT.md §5',
    mismatches: [
      'dose 2016-UC-0087_dose2: not found in any evaluated series (expected Valid, seriesType=risk)',
    ],
  ),
  '2016-UC-0088': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): no HPV risk series is '
        'indicated by observation 036 any more (MMWR 65(49), 68(32)); '
        'CDC-REPORT.md §5',
    mismatches: [
      'dose 2016-UC-0088_dose2: not found in any evaluated series (expected Valid, seriesType=risk)',
      'dose 2016-UC-0088_dose3: not found in any evaluated series (expected Valid, seriesType=risk)',
    ],
  ),
  '2016-UC-0110': Ruling(
    citation:
        "CDSI-OE-ADJUDICATED.md §8 (2026-08-24): the asplenic infant's 4th "
        'MenACWY dose anchors to 12 months of age, not dose 3 + 6 months '
        '(MMWR 69(9)); CDC-REPORT.md §5',
    mismatches: [
      '[Meningococcal] earliest: expected=2016/02/04 actual=2016/02/14',
    ],
  ),
  '2016-UC-0130': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §1 and §2 (2026-08-19): no ACIP basis for a '
        "Tdap dated before conception, and past-due is FORECASTDT-3's "
        'minus-one-day convention; CDC-REPORT.md §5',
    mismatches: [
      '[DTaP] earliest: expected=2016/02/27 actual=2017/02/27',
      '[DTaP] recommended: expected=2016/02/27 actual=2017/02/27',
      '[DTaP] pastDue: expected=2017/05/01 actual=2017/04/30',
    ],
  ),
  '2016-UC-0153': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §11 (re-ruled 2026-08-25): the 2-year floor '
        'on the 2–5 year risk series is a CDC supporting-data defect; the '
        'engine stays conformant to the data it ships, a documented '
        'non-conformance; CDC-REPORT.md §3',
    mismatches: [
      '[Pneumococcal] earliest: expected=2013/07/03 actual=2015/01/08',
      '[Pneumococcal] recommended: expected=2013/07/03 actual=2015/01/08',
    ],
  ),
  '2016-UC-0165': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §7 (2026-08-19): current ACIP anchors the '
        'next pneumococcal dose 5 years after the LAST pneumococcal dose '
        '(PCV13 2017-08-01), the PPSV23 anchoring is superseded (MMWR 72(3), '
        '74(1))',
    mismatches: [
      '[Pneumococcal] earliest: expected=2021/08/01 actual=2022/08/01',
      '[Pneumococcal] recommended: expected=2021/08/01 actual=2022/08/01',
    ],
  ),
  '2016-UC-0173': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §7 (2026-08-19): pneumococcal 5-year anchor '
        'is the last pneumococcal dose (MMWR 72(3), 74(1)); CDC-REPORT.md §5',
    mismatches: [
      '[Pneumococcal] earliest: expected=2021/08/21 actual=2022/08/21',
      '[Pneumococcal] recommended: expected=2021/08/21 actual=2022/08/21',
    ],
  ),
  '2016-UC-0178': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §7 (2026-08-19): pneumococcal 5-year anchor '
        'is the last pneumococcal dose (MMWR 72(3), 74(1)); CDC-REPORT.md §5',
    mismatches: [
      '[Pneumococcal] earliest: expected=2016/08/03 actual=2017/08/03',
      '[Pneumococcal] recommended: expected=2016/08/03 actual=2017/08/03',
    ],
  ),
  '2016-UC-0198': Ruling(
    citation:
        "CDSI-OE-ADJUDICATED.md §6 (2026-08-19) ruled CDC's row clinically "
        'right, but the rule that made it pass appeared in no CDSi '
        'specification and was removed (8a8475e9, see cicada-spec-audit); the '
        '"Meningococcal ACWY risk 2-23 month" series carries no maximum age '
        "to start, CDC-REPORT.md §2. Fails deliberately until CDC's data does",
    mismatches: [
      '[Meningococcal] earliest: expected=1979/07/13 actual=1977/07/13',
      '[Meningococcal] recommended: expected=1979/07/13 actual=1978/02/13',
    ],
  ),
  '2016-UC-0203': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): 116 is a contraindication '
        'code and indicates no MenB series; Contraindicated with no forecast '
        'is right; CDC-REPORT.md §5',
    mismatches: [
      'dose 2016-UC-0203_dose1: not found in any evaluated series (expected Valid, seriesType=risk)',
    ],
  ),
  '2017-UC-0015': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §5 (2026-08-19): ACIP extended CVD 103-HgR to '
        'ages 2–17 in February 2022 (MMWR 71(2)); the 18-year row predates '
        'it; CDC-REPORT.md §5',
    mismatches: [
      '[Cholera] earliest: expected=2000/02/17 actual=1984/02/17',
      '[Cholera] recommended: expected=2000/02/17 actual=1984/02/17',
    ],
  ),
  '2018-0022': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §12 (2026-08-25): "Age: Too Young" is the '
        'right reason (Heplisav-B is the correct product, 5 days short of 18) '
        "and HepB's data carries inadvertentVaccine empty on all 62 doses; "
        'CDC-REPORT.md §4',
    mismatches: [
      'dose 2018-0022_dose1: evalReason expected=Inadvertent Vaccine actual=Not a preferable or allowable vaccine,Age: Too Young',
    ],
  ),
  '2020-UC-0003': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): MenB at 16–23 is shared '
        'clinical decision-making, a Standard series, not risk (MMWR 69(9), '
        '73(49)); CDC-REPORT.md §5',
    mismatches: [
      'dose 2020-UC-0003_dose1: not found in any evaluated series (expected Valid, seriesType=risk)',
      'dose 2020-UC-0003_dose2: not found in any evaluated series (expected Not Valid, seriesType=risk)',
      '[Meningococcal B] doseNum: expected=2 actual=3',
    ],
  ),
  '2022-UC-0017': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): the dose carries minInt 1 '
        'year in the data, not 8 weeks; CDC-REPORT.md §5',
    mismatches: [
      '[Pneumococcal] earliest: expected=2022/03/21 actual=2023/01/24',
    ],
  ),
  '2022-UC-0030': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §3 (2026-08-19): observation 235 (HCP caring '
        'for orthopox patients) is defined in the data and named by no '
        'series, a CDSi data defect; CDC-REPORT.md §1',
    mismatches: [
      'dose 2022-UC-0030_dose1: not found in any evaluated series (expected Valid, seriesType=risk)',
      '[Orthopoxvirus] no forecast produced',
    ],
  ),
  '2022-UC-0031': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §3 (2026-08-19): observation 235 (HCP caring '
        'for orthopox patients) is defined in the data and named by no '
        'series, a CDSi data defect; CDC-REPORT.md §1',
    mismatches: [
      'dose 2022-UC-0031_dose1: not found in any evaluated series (expected Valid, seriesType=risk)',
      'dose 2022-UC-0031_dose2: not found in any evaluated series (expected Valid, seriesType=risk)',
      '[Orthopoxvirus] no forecast produced',
    ],
  ),
  '2023-UC-0047': Ruling(
    citation:
        'CDC-REPORT.md §5 (the shipped RSV data carries only the 2025-26 '
        'season; the row is a 2023-season row) and §6 (observation 017 is '
        'named only by the 50–74 years series)',
    mismatches: [
      '[RSV] status: expected=not complete actual=aged out',
      '[RSV] doseNum: expected=1 actual=',
      '[RSV] earliest: expected=2023/10/01 actual=',
      '[RSV] recommended: expected=2023/10/01 actual=',
    ],
  ),
  '2023-UC-0048': Ruling(
    citation:
        'CDC-REPORT.md §5: the shipped RSV data carries only the 2025-26 '
        'season; two years on, the infant passes the 20-month maximum age '
        'before the season opens',
    mismatches: [
      '[RSV] status: expected=not complete actual=aged out',
      '[RSV] doseNum: expected=1 actual=',
      '[RSV] earliest: expected=2023/11/03 actual=',
      '[RSV] recommended: expected=2023/11/03 actual=',
    ],
  ),
  '2023-UC-0050': Ruling(
    citation:
        'CDC-REPORT.md §5: the shipped RSV data carries only the 2025-26 '
        'season; two years on, the child passes the 20-month maximum age '
        'before the season opens',
    mismatches: [
      '[RSV] status: expected=not complete actual=aged out',
      '[RSV] doseNum: expected=2 actual=',
      '[RSV] earliest: expected=2023/12/12 actual=',
      '[RSV] recommended: expected=2023/12/12 actual=',
    ],
  ),
  '2023-UC-0051': Ruling(
    citation:
        'CDC-REPORT.md §5: the shipped RSV pregnancy series opens 2025-09-01; '
        'the row expects the 2023 season',
    mismatches: [
      '[RSV] earliest: expected=2023/10/11 actual=2025/09/01',
      '[RSV] recommended: expected=2023/10/11 actual=2025/09/01',
      '[RSV] pastDue: expected=2023/11/14 actual=2025/09/01',
    ],
  ),
  '2025-UC-0010': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §9 (2026-08-24): 172 is a contraindication '
        'code and indicates no Zoster risk series; CDC-REPORT.md §5',
    mismatches: [
      'dose 2025-UC-0010_dose1: not found in any evaluated series (expected Valid, seriesType=risk)',
    ],
  ),
  '2025-UC-0015': Ruling(
    citation:
        'CDSI-OE-ADJUDICATED.md §2 (2026-08-19): ACIP defines no overdue '
        "date; past-due is CDSi FORECASTDT-3's minus-one-day convention, "
        'which CDC applies elsewhere; CDC-REPORT.md §5',
    mismatches: [
      '[HPV] pastDue: expected=2025/06/30 actual=2025/06/29',
    ],
  ),
};
