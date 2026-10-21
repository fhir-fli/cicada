#!/usr/bin/env python3
"""For every CDSi observation and every CDC SNOMED code listed for it: how many
'wider' ICD-10-CM rows depend on that code alone (some SNOMED concept NLM maps to
the ICD-10-CM code is reached through no other listed code).

WHY. A CDC code broader than its observation makes every ICD-10-CM code under
it count with no review. Run 2026-10-21: 400047006 Peripheral vascular disease
alone put 1,138 codes under 254 chronic cardiovascular disease. A large count is
not by itself a defect (73211009 Diabetes mellitus carries all 144 diabetes
rows); each code with any such row is compared with its observation title, and
the broader ones go in observation_map_policy.json broad_codes. Rerun when CDC's
supporting data changes.

Writes <out dir>/census.tsv (one row per observation, CDC code) and
<out dir>/rows.tsv (one row per 'wider' ICD-10-CM row), both flushed.

Usage: broad_code_census.py <schedule.json> <META dir> <out dir>
"""
import csv
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import derive_icd10_observation_rows as d  # noqa: E402
import umls_snomed as u  # noqa: E402

schedule, meta, out_dir = sys.argv[1:4]
Path(out_dir).mkdir(parents=True, exist_ok=True)
obs = d.cdc_snomed(schedule)
aui, names = u.snomed_atoms(meta); g = u.load_graph(meta, aui); inv = u.inverted(g)
src = u.nlm_icd10cm_sources(meta); icdn = u.icd10cm_names(meta)
cf = open(f'{out_dir}/census.tsv', 'w', newline=''); cw = csv.writer(cf, delimiter='\t')
cw.writerow(['observation', 'title', 'root', 'root name', 'closure size', 'wider rows', 'rows needing only this root'])
rf = open(f'{out_dir}/rows.tsv', 'w', newline=''); rw = csv.writer(rf, delimiter='\t')
rw.writerow(['observation', 'icd10cm', 'name', 'roots it needs'])
for o, (title, roots) in sorted(obs.items()):
    if not roots:
        continue
    per = {r: u.evidence_closure([r], inv) for r in sorted(roots)}
    cover = defaultdict(set)
    for r, cl in per.items():
        for c in cl:
            cover[c].add(r)
    wider = {icd: fx for icd, fx in src.items() if fx and all(c in cover for c in fx)}
    needs = defaultdict(list)
    for icd, fx in sorted(wider.items()):
        need = sorted({next(iter(cover[c])) for c in fx if len(cover[c]) == 1})
        for r in need:
            needs[r].append(icd)
        rw.writerow([o, icd, icdn.get(icd, ''), ' '.join(f'{r}' for r in need)])
    rf.flush()
    for r in sorted(per, key=lambda r: -len(needs[r])):
        cw.writerow([o, ' '.join(title.split()), r, names.get(r, '?'), len(per[r]), len(wider), len(needs[r])])
    cf.flush()
    print(o, len(roots), 'roots', len(wider), 'wider', flush=True)
