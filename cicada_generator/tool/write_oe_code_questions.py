#!/usr/bin/env python3
"""Write the unsure rows of CROSSWALK-REVIEW.tsv as OpenEvidence questions.

Rows reached only through a broad CDC code go to OpenEvidence whether or not
Claude was sure, until OpenEvidence has answered them (Grey, 2026-10-21: "You
should review them AND open evidence should review them").

Grey pastes each section into OpenEvidence as it stands (2026-10-18: "put them
all in a single file and I'll ask open evidence"), so nothing in a section
may point into this repository. One section per CDSi observation, split so
none holds more than MAX_CODES lines; the 7th-character variants of one code
(A, D, S ...) that share a proposal are folded into one line. The first line
gives the open count. Rebuild after every change to the sheet; delete a
section once its answers are copied into the decision column.

Usage: write_oe_code_questions.py <CROSSWALK-REVIEW.tsv> <out.md> <extra-questions.md>
The extra-questions file holds hand-written sections (policy questions) that
are appended as they are.
"""
import csv
import re
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from write_review_sheet import BROAD  # noqa: E402

MAX_CODES = 40


def fold(rows):
    """[(code, name, proposal, label, reason)] with 7th-character variants folded."""
    groups = defaultdict(list)
    order = []
    for r in rows:
        code = r['icd10cm']
        # Only a letter in the 8th place is a 7th-character extension (E11.3599 is not).
        stem = code[:-1] if len(code) == 8 and code[-1].isalpha() else code
        label = 'doubt' if r['unsure'].strip() == 'unsure' else 'reason'
        key = (stem, r['proposed (Claude)'], label, r['why proposed'])
        if key not in groups:
            order.append(key)
        groups[key].append(r)
    out = []
    for key in order:
        rs = groups[key]
        if len(rs) == 1:
            out.append((rs[0]['icd10cm'], rs[0]['icd10cm name'], key[1], key[2], key[3]))
        else:
            sevenths = '/'.join(r['icd10cm'][-1] for r in rs)
            name = rs[0]['icd10cm name'].rsplit(',', 1)[0]
            out.append((f'{key[0]}{sevenths}', name, key[1], key[2], key[3]))
    return out


def self_contained(reason, titles):
    """Name CDSi observations by title: OpenEvidence cannot resolve a bare '206'."""
    reason = re.sub(r'CDC has (\d{3}) for that',
                    lambda m: f'CDSi has a separate condition "{titles.get(m.group(1), m.group(1))}"', reason)
    reason = re.sub(r"CDC's code for (\d{3})",
                    lambda m: f'CDC\'s SNOMED code for "{titles.get(m.group(1), m.group(1))}"', reason)
    reason = re.sub(r'(?:is (?:also )?its own observation|has its own observation) \((\d{3})\)',
                    lambda m: f'has its own CDSi condition "{titles.get(m.group(1), m.group(1))}"', reason)
    reason = re.sub(r'\((\d{3})\)', lambda m: f'("{titles.get(m.group(1), m.group(1))}")', reason)
    reason = reason.replace('is its own observation', 'has its own CDSi condition')
    reason = reason.replace('is also its own observation', 'also has its own CDSi condition')
    reason = reason.replace('under 039', 'under this condition')
    # A count ("213 of the 230") is not an observation number.
    if re.search(r'(?<!of the )(?<!\.)\b\d{3}\b(?! of)', reason):
        raise SystemExit(f'reason still names an observation number: {reason}')
    return reason


def main(sheet, out_path, extra_path):
    every = list(csv.DictReader(open(sheet, encoding='utf-8'), delimiter='\t'))
    all_titles = {r['observation']: r['observation title'] for r in every}
    rows = [r for r in every
            if (r['unsure'].strip() == 'unsure' and not r['decision (yes/no)'].strip())
            or (r['why it is here'].startswith(BROAD)
                and not r['decided by'].startswith('OpenEvidence'))]
    for r in rows:
        r['why proposed'] = self_contained(r['why proposed'], all_titles)
    by_obs = defaultdict(list)
    titles = {}
    for r in rows:
        by_obs[r['observation']].append(r)
        titles[r['observation']] = r['observation title']
    sections = []
    for obs in sorted(by_obs):
        lines = fold(by_obs[obs])
        parts = [lines[i:i + MAX_CODES] for i in range(0, len(lines), MAX_CODES)]
        for n, part in enumerate(parts, 1):
            sections.append((obs, n, len(parts), part))
    extra = open(extra_path, encoding='utf-8').read().strip()
    n_extra = extra.count('\n## ') + (1 if extra.startswith('## ') else 0)
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(f'# {len(sections) + n_extra} QUESTIONS OPEN ({len(rows)} ICD-10-CM codes in '
                f'{len(sections)} sections, plus {n_extra} policy questions)\n\n')
        f.write('Each section below is pasted into OpenEvidence as it stands. Delete a section once '
                'its answers are applied.\n\n')
        for obs, n, total, part in sections:
            part_label = f' (part {n} of {total})' if total > 1 else ''
            f.write(f'## {titles[obs]}{part_label}\n\n')
            f.write(f'CDC\'s immunization decision-support logic (CDSi) has a patient condition '
                    f'"{titles[obs]}" (CDSi observation {obs}) that changes vaccine recommendations. '
                    'A clinic system has only the ICD-10-CM code on the problem list. For each code '
                    'below, does a patient carrying that code meet this condition for the purpose of '
                    'the ACIP recommendations that use it? Answer yes or no for every code, with the '
                    'reason and a source. The tentative answer and its reason (or the doubt) are given '
                    'after each code.\n\n')
            for code, name, proposal, label, reason in part:
                f.write(f'- {code} {name}: tentative {proposal}; {label}: {reason}\n')
            f.write('\n')
            f.flush()
        f.write(extra + '\n')
    print(f'{len(sections)} sections, {len(rows)} codes, {n_extra} extra -> {out_path}', flush=True)


if __name__ == '__main__':
    main(*sys.argv[1:4])
