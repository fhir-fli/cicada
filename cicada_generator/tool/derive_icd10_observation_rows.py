#!/usr/bin/env python3
"""Derive ICD-10-CM -> CDSi observation rows from NLM's SNOMED CT to ICD-10-CM map.

WHY. The ICD-10-CM rows in crosswalk/observation_crosswalk.json were typed by
hand on 2026-02-06 and 21 of its 136 observations held codes for a different
observation: asplenia sat under 018, laboratory evidence of hepatitis A
immunity (audit 2026-10-18, AUDIT-2026-10-18-crosswalk-vs-cdc-titles.tsv).
CDC publishes SNOMED for its observations, and NLM publishes where each SNOMED
concept classifies in ICD-10-CM, so the ICD-10-CM side can be derived.

RULE. For observation O, let S(O) be every SNOMED concept that is evidence of
one of CDC's SNOMED codes for O: a subtype, or a disorder due to one (one
step) and that disorder's subtypes (umls_snomed.evidence_closure). For an ICD-10-CM code X, let F(X) be every
SNOMED concept NLM maps to X unconditionally (map rule TRUE or OTHERWISE TRUE,
category 447637006 "properly classified"). Then
  * F(X) inside S(O)        -> 'wider': every concept that lands on X is an O,
                               so the CDSi observation is wider than X.
  * F(X) partly inside S(O) -> 'narrower': X also holds concepts that are not
                               O. A record coded X may or may not be an O. Not
                               asserted; clinical judgement.
ConceptMap.group.element.target.equivalence is read from target to source
(R4B StructureDefinition-ConceptMap), which is why 'wider' is the assertable
grade here.

Inputs: the generated CDC schedule JSON and a UMLS META directory. Everything
SNOMED and ICD-10-CM comes from that one release.
Writes one TSV row per (observation, ICD-10-CM code), flushed as it goes.

Usage: derive_icd10_observation_rows.py <schedule.json> <META dir> <out.tsv>
"""
import csv
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import umls_snomed  # noqa: E402


def cdc_snomed(schedule_path):
    data = json.load(open(schedule_path, encoding='utf-8'))
    out = {}
    for obs in data['observations']['observation']:
        codes = {cv['code'] for cv in (obs.get('codedValues') or {}).get('codedValue', [])
                 if cv.get('codeSystem') == 'SNOMED' and cv.get('code')}
        out[obs['observationCode']] = (obs.get('observationTitle', ''), codes)
    return out


def derive(observations, meta, broad=None, review_rows=None):
    """Yield one dict per (observation, ICD-10-CM code) pair that shares a SNOMED source.

    `observations` maps observation code -> (title, set of CDC SNOMED codes).

    `broad` maps observation code -> {CDC SNOMED code: reason} for CDC codes
    broader than the observation (observation_map_policy.json broad_codes). A
    'wider' row whose SNOMED sources are not all reached without those codes
    keeps its grade but carries a 'review' reason, and is decided on the
    review sheet like a partial row. Measured 2026-10-21
    (tool/broad_code_census.py): 400047006 Peripheral vascular disease alone
    put 1,138 ICD-10-CM codes, 586 of them vessel injuries, under 254 chronic
    cardiovascular disease. `review_rows` maps 'observation|icd10cm' -> reason
    for single 'wider' rows sent to review for another cause.
    """
    broad = broad or {}
    review_rows = review_rows or {}
    aui_code, names = umls_snomed.snomed_atoms(meta)
    graph = umls_snomed.load_graph(meta, aui_code)
    umls_snomed.check_direction(graph, names)
    inv = umls_snomed.inverted(graph)
    sources = umls_snomed.nlm_icd10cm_sources(meta)
    icd_names = umls_snomed.icd10cm_names(meta)
    print(f'{len(sources)} ICD-10-CM codes reached by NLM map', flush=True)
    for obs_code, codes in broad.items():
        not_cdc = set(codes) - observations.get(obs_code, ('', set()))[1]
        if not_cdc:
            raise SystemExit(f'broad codes {sorted(not_cdc)} are not CDC codes for {obs_code}')
    for key in review_rows:
        obs_code, icd = key.split('|')
        if icd not in sources or obs_code not in observations:
            raise SystemExit(f'review row {key} names no derived pair')
    for obs_code, (title, listed) in sorted(observations.items()):
        if not listed:
            continue
        s_o = umls_snomed.evidence_closure(listed, inv)
        wide = broad.get(obs_code, {})
        s_strict = umls_snomed.evidence_closure(listed - set(wide), inv) if wide else s_o
        per_wide = {r: umls_snomed.evidence_closure([r], inv) for r in sorted(wide)}
        for icd in sorted(sources):
            f_x = sources[icd]
            inside = f_x & s_o
            if not inside:
                continue
            grade = 'wider' if inside == f_x else 'narrower'
            review = ''
            if grade == 'wider' and not f_x <= s_strict:
                used = [r for r, cl in per_wide.items() if (f_x - s_strict) & cl]
                review = ('reached only through ' + '; '.join(
                    f'{r} {names.get(r, "?")}: {wide[r]}' for r in used))
            elif grade == 'wider' and f'{obs_code}|{icd}' in review_rows:
                review = review_rows[f'{obs_code}|{icd}']
            yield {
                'observation': obs_code, 'title': title, 'icd10cm': icd,
                'display': icd_names.get(icd, ''),
                'grade': grade,
                'nlm_sources': len(f_x), 'sources_in_observation': len(inside),
                'example_outside': '; '.join(
                    f'{c} {names.get(c, "?")}' for c in sorted(f_x - s_o)[:3]),
                'review': review,
            }


def policy_review(policy):
    """The broad_codes and review_rows sections of observation_map_policy.json."""
    broad = {k: {c: r for c, r in v.items() if not c.startswith('_')}
             for k, v in policy.get('broad_codes', {}).items() if not k.startswith('_')}
    rows = {k: v for k, v in policy.get('review_rows', {}).items() if not k.startswith('_')}
    return broad, rows


COLUMNS = ['observation', 'title', 'icd10cm', 'display', 'grade', 'nlm_sources',
           'sources_in_observation', 'example_outside', 'review']


def main(schedule_path, meta, out_path):
    rows = 0
    with open(out_path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLUMNS, delimiter='\t')
        w.writeheader()
        for row in derive(cdc_snomed(schedule_path), meta):
            w.writerow(row)
            f.flush()
            rows += 1
    print(f'{rows} rows -> {out_path}', flush=True)


if __name__ == '__main__':
    main(*sys.argv[1:4])
