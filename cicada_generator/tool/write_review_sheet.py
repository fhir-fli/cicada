#!/usr/bin/env python3
"""Write CROSSWALK-REVIEW.tsv: the ICD-10-CM rows only a clinician can grade.

WHY. derive_icd10_observation_rows.py grades an (observation, ICD-10-CM code)
pair 'wider' when every SNOMED concept NLM maps to the code is evidence of the
observation. The rest need a person. Three kinds go on the sheet:
  * NLM partial rows: at least half of the SNOMED concepts NLM maps to the code
    are the observation;
  * NLM minority rows: some, but under half. Until 2026-10-18 these were
    dropped unreviewed, which lost codes whose meaning is the observation
    (I20.9 angina pectoris under 016 chronic heart disease, 6 of 14; Z90.81
    acquired absence of spleen under 160, 1 of 6);
  * rows the hand-typed 2026-02-06 crosswalk held that the derivation neither
    grades 'wider' nor puts on the sheet;
  * 'wider' rows reached only through a CDC code broader than the observation,
    or listed one by one, in observation_map_policy.json (broad_codes,
    review_rows; added 2026-10-21);
  * rows NLM's map never reaches, added by a ruling in
    observation_map_policy.json (added_icd10cm), written already decided
    'yes' with the ruling as 'decided by'.
Observations in observation_map_policy.json's not_from_a_code list get no NLM
rows; their hand-typed rows stay on the sheet, marked.

Until 2026-10-18 the sheet was written by a one-off script, so it could not be
rebuilt when the derivation changed. This writer carries every hand-entered
column over by (observation, ICD-10-CM code): Grey's decision, and Claude's
proposal with its reason. A row whose key no longer exists is reported, not
silently dropped. build_observation_concept_map.py reads only the decision
column.

Usage: write_review_sheet.py <schedule.json> <META dir> <policy.json> <CROSSWALK-REVIEW.tsv>
"""
import csv
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import derive_icd10_observation_rows as derive_icd  # noqa: E402
import umls_snomed  # noqa: E402

# The hand-typed crosswalk was deleted in 97e46867; its last version is read
# from git so the sheet stays reproducible.
OLD_CROSSWALK = '97e46867^:cicada_generator/lib/crosswalk/observation_crosswalk.json'

HEADER = ['decision (yes/no)', 'observation', 'observation title', 'icd10cm', 'icd10cm name',
          'SNOMED concepts NLM maps here', 'of which are this observation',
          'examples of the others', 'why it is here',
          'proposed (Claude)', 'unsure', 'why proposed', 'decided by']
CARRIED = ('decision (yes/no)', 'proposed (Claude)', 'unsure', 'why proposed', 'decided by')
PARTIAL = 'NLM map: most, not all, of the SNOMED concepts mapped to this code are this observation'
MINORITY = 'NLM map: under half of the SNOMED concepts mapped to this code are this observation'
HAND = 'hand-typed 2026-02-06 file; NLM map does not confirm it'
ADDED = 'added by a ruling (observation_map_policy.json added_icd10cm); NLM map does not reach it'
# write_oe_code_questions.py sends every row with this reason to OpenEvidence.
BROAD = 'NLM map: every SNOMED concept mapped here is this observation, but '


def main(schedule_path, meta, policy_path, sheet_path):
    policy = json.load(open(policy_path, encoding='utf-8'))
    not_from = {k for k in policy['not_from_a_code'] if not k.startswith('_')}
    observations = derive_icd.cdc_snomed(schedule_path)
    titles = {k: ' '.join((v[0] or '').split()) for k, v in observations.items()}

    previous = {}
    if Path(sheet_path).exists():
        for row in csv.DictReader(open(sheet_path, encoding='utf-8'), delimiter='\t'):
            previous[(row['observation'], row['icd10cm'])] = {k: row.get(k, '') or '' for k in CARRIED}

    broad, review_rows = derive_icd.policy_review(policy)
    rows, wider = {}, set()
    for d in derive_icd.derive(observations, meta, broad, review_rows):
        key = (d['observation'], d['icd10cm'])
        if d['grade'] == 'wider' and d['review'] and d['observation'] not in not_from:
            rows[key] = [d['observation'], titles.get(d['observation'], ''), d['icd10cm'], d['display'],
                         str(d['nlm_sources']), str(d['sources_in_observation']), d['example_outside'],
                         BROAD + d['review']]
        elif d['grade'] == 'wider':
            wider.add(key)
        elif d['observation'] not in not_from:
            why = PARTIAL if d['sources_in_observation'] * 2 >= d['nlm_sources'] else MINORITY
            rows[key] = [d['observation'], titles.get(d['observation'], ''), d['icd10cm'], d['display'],
                         str(d['nlm_sources']), str(d['sources_in_observation']), d['example_outside'], why]

    cm_codes = umls_snomed.icd10cm_codes(meta)
    old = json.loads(subprocess.run(['git', 'show', OLD_CROSSWALK], capture_output=True, text=True,
                                    check=True, cwd=Path(sheet_path).resolve().parent).stdout)
    for obs, systems in old.items():
        if obs.startswith('_'):
            continue
        for e in systems.get('ICD10CM', []):
            key = (obs, e['code'])
            if key in wider or key in rows:
                continue
            why = HAND + (' (observation is never taken from a code)' if obs in not_from else '')
            if e['code'] not in cm_codes:
                why += ' (not an ICD-10-CM code in this release)'
            rows[key] = [obs, titles.get(obs, ''), e['code'], e['text'], '', '', '', why]

    # Rows NLM's map never reaches, added by a ruling in the policy file. The
    # ruling is the decision, so these rows are written decided.
    added = {}
    for k, source in policy.get('added_icd10cm', {}).items():
        if k.startswith('_'):
            continue
        obs, icd = k.split('|')
        key = (obs, icd)
        if icd not in cm_codes:
            raise SystemExit(f'added_icd10cm {k}: not an ICD-10-CM code in this release')
        if key in wider or key in rows:
            raise SystemExit(f'added_icd10cm {k}: already derived; decide it on the sheet instead')
        rows[key] = [obs, titles.get(obs, ''), icd, cm_codes[icd], '', '', '', ADDED]
        added[key] = source

    with open(sheet_path, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f, delimiter='\t')
        w.writerow(HEADER)
        for key in sorted(rows):
            kept = previous.get(key, {})
            if key in added:
                kept = {'decision (yes/no)': 'yes', 'decided by': added[key]}
            w.writerow([kept.get('decision (yes/no)', '')] + rows[key] +
                       [kept.get(k, '') for k in CARRIED[1:]])
            f.flush()
    gone = sorted(k for k in previous if k not in rows)
    decided_gone = [k for k in gone if previous[k]['decision (yes/no)'].strip()]
    print(f'{len(rows)} rows -> {sheet_path}; {len(gone)} earlier rows no longer on the sheet '
          f'({len(decided_gone)} of them decided: {decided_gone})', flush=True)
    new = sorted(k for k in rows if k not in previous)
    print(f'{len(new)} rows new to the sheet', flush=True)


if __name__ == '__main__':
    main(*sys.argv[1:5])
