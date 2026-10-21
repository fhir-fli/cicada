#!/usr/bin/env python3
"""Build the one ConceptMap the engine and the IG use to turn chart codes into CDSi observations.

WHY. Until 2026-10-18 the engine matched chart codes against CDC's coded values
plus a hand-typed crosswalk, took the first observation that matched, and
asserted it. 21 of the crosswalk's 136 observations held another observation's
codes (asplenia under 018, hepatitis A immunity), and the first-match rule sent
HIV (B20) to 026 instead of 186. CDC's test cases send observation codes
directly, so none of this was exercised.

WHAT. One FHIR R4 ConceptMap, source code -> CDSi observation code, with every
row graded (R4 equivalence, read target to source; 'equivalent' and 'wider'
assert the observation, 'narrower' and 'relatedto' do not). Rows come from:
  * CDC's Coded Observations data (SNOMED, CVX, PHIN VS), graded 'equivalent'
    unless crosswalk/observation_map_policy.json says otherwise;
  * NLM's SNOMED CT to ICD-10-CM map, derived per observation
    (derive_icd10_observation_rows.py), with Grey's yes/no from
    CROSSWALK-REVIEW.tsv for the rows the derivation cannot grade;
  * the policy file's LOINC (positive result required, as dependsOn), RxNorm
    and CPT rows.
Observations in the policy's not_from_a_code list are never asserted from a
code: their rows are kept as 'relatedto'. A 'wider' row reached only through a
CDC code the policy lists as broad (broad_codes), or listed in review_rows, is
asserted only when CROSSWALK-REVIEW.tsv says yes.

Writes the ConceptMap JSON and a TSV of every decision, both flushed.

Usage: build_observation_concept_map.py <schedule.json> <META dir> <policy.json>
           <CROSSWALK-REVIEW.tsv> <out ConceptMap.json> <out decisions.tsv>
"""
import csv
import json
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import derive_icd10_observation_rows as derive_icd  # noqa: E402

CDSI_CS = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes'
CDSI_VS = 'http://fhirfli.dev/fhir/ig/cicada/ValueSet/cdsi-observation-codes-vs'
SYSTEMS = {
    'SNOMED': 'http://snomed.info/sct',
    'CVX': 'http://hl7.org/fhir/sid/cvx',
    'CDCPHINVS': 'urn:oid:2.16.840.1.114222.4.5.274',
    'ICD10CM': 'http://hl7.org/fhir/sid/icd-10-cm',
    'LOINC': 'http://loinc.org',
    'RXNORM': 'http://www.nlm.nih.gov/research/umls/rxnorm',
    'CPT': 'http://www.ama-assn.org/go/cpt',
}
INTERPRETATION = 'http://hl7.org/fhir/StructureDefinition/Observation#Observation.interpretation'
VALUE = 'http://hl7.org/fhir/StructureDefinition/Observation#Observation.value[x]'

# CVX's own displays (tool/fetch_cvx_displays.py, from tx.fhir.org). CDC's
# short product names ('OPV', 'PCV7') are not CVX displays; the IG publisher
# reported all 56 CVX rows as invalid displays on 2026-10-18.
CVX_DISPLAYS = Path(__file__).resolve().parent / 'cvx_displays.tsv'


def cvx_displays():
    out = {}
    with open(CVX_DISPLAYS, encoding='utf-8') as f:
        for line in f:
            if line.startswith('#') or line.startswith('code\t'):
                continue
            code, _, display = line.rstrip('\n').partition('\t')
            out[code] = display
    return out


def cdc_observations(schedule_path):
    """observation code -> (title, [(system, code, text)]) for CDC's own systems only."""
    data = json.load(open(schedule_path, encoding='utf-8'))
    out = {}
    for obs in data['observations']['observation']:
        coded = [(cv['codeSystem'], cv['code'], cv.get('text') or '')
                 for cv in (obs.get('codedValues') or {}).get('codedValue', [])
                 if cv.get('codeSystem') in ('SNOMED', 'CVX', 'CDCPHINVS') and cv.get('code')]
        out[obs['observationCode']] = (' '.join((obs.get('observationTitle') or '').split()), coded)
    return out


def review_decisions(path):
    """(observation, icd10cm) -> (answer, ICD-10-CM name, who decided), for decided rows."""
    out = {}
    with open(path, encoding='utf-8') as f:
        for row in csv.DictReader(f, delimiter='\t'):
            answer = (row.get('decision (yes/no)') or '').strip().lower()
            if answer in ('yes', 'no'):
                who = (row.get('decided by') or '').strip() or 'Grey'
                out[(row['observation'], row['icd10cm'])] = (answer, row['icd10cm name'], who)
    return out


def main(schedule_path, meta, policy_path, review_path, out_map, out_tsv):
    policy = json.load(open(policy_path, encoding='utf-8'))
    not_from = {k: v for k, v in policy['not_from_a_code'].items() if not k.startswith('_')}
    grades = {k: v for k, v in policy['code_grades'].items() if not k.startswith('_')}
    observations = cdc_observations(schedule_path)
    titles = {k: v[0] for k, v in observations.items()}
    decisions = review_decisions(review_path)
    cvx_names = cvx_displays()

    # (system key, code) -> {'display': str, 'targets': [target dicts]}
    elements = defaultdict(lambda: {'display': '', 'targets': []})
    log = open(out_tsv, 'w', encoding='utf-8', newline='')
    w = csv.writer(log, delimiter='\t')
    w.writerow(['system', 'code', 'display', 'observation', 'equivalence', 'source', 'reason'])

    def add(system, code, display, obs, equivalence, source, reason, depends_on=None):
        if obs in not_from and equivalence in ('equivalent', 'wider'):
            equivalence, reason = 'relatedto', f'not from a code: {not_from[obs]}'
        if system == 'CVX':
            display = cvx_names[code]
        el = elements[(system, code)]
        el['display'] = el['display'] or display
        target = {'code': obs, 'display': titles.get(obs, ''), 'equivalence': equivalence,
                  'comment': f'{source}. {reason}'.strip()}
        if depends_on:
            target['dependsOn'] = [depends_on]
        el['targets'].append(target)
        w.writerow([system, code, display, obs, equivalence, source,
                    reason + (f' [dependsOn {depends_on["value"]}]' if depends_on else '')])
        log.flush()

    # 1. CDC's own rows.
    for obs, (_, coded) in sorted(observations.items()):
        for system, code, text in coded:
            grade = grades.get(f'{system}|{code}|{obs}') or grades.get(f'{system}|{code}|*')
            equivalence, reason = (grade if grade else ('equivalent', ''))
            add(system, code, text, obs, equivalence, 'CDC Coded Observations 4.65-508', reason)

    # 2. ICD-10-CM, derived from NLM's map.
    counts = defaultdict(int)
    snomed_only = {k: (v[0], {c for s, c, _ in v[1] if s == 'SNOMED'}) for k, v in observations.items()}
    broad, review_rows = derive_icd.policy_review(policy)
    for row in derive_icd.derive(snomed_only, meta, broad, review_rows):
        obs, icd = row['observation'], row['icd10cm']
        if obs in not_from:
            counts['skipped: observation not from a code'] += 1
            continue
        evidence = f"NLM SNOMED CT to ICD-10-CM map (UMLS 2025AB): {row['sources_in_observation']} of {row['nlm_sources']} SNOMED concepts mapped here are this observation"
        if row['grade'] == 'wider' and row['review']:
            # Reached only through a broad CDC code (policy broad_codes) or
            # listed in review_rows: asserted only on a reviewed yes.
            answer, _, who = decisions.pop((obs, icd), ('', '', ''))
            if answer == 'yes':
                add('ICD10CM', icd, row['display'], obs, 'wider', evidence, f'reviewed: yes ({who})')
                counts['broad, reviewed yes'] += 1
            elif answer == 'no':
                counts['broad, reviewed no'] += 1
            else:
                add('ICD10CM', icd, row['display'], obs, 'narrower', evidence, 'awaiting review')
                counts['broad, awaiting review'] += 1
        elif row['grade'] == 'wider':
            add('ICD10CM', icd, row['display'], obs, 'wider', evidence, 'every one is')
            counts['wider'] += 1
        elif row['sources_in_observation'] * 2 >= row['nlm_sources']:
            answer, _, who = decisions.pop((obs, icd), ('', '', ''))
            if answer == 'yes':
                add('ICD10CM', icd, row['display'], obs, 'wider', evidence, f'reviewed: yes ({who})')
                counts['reviewed yes'] += 1
            elif answer == 'no':
                counts['reviewed no'] += 1
            else:
                add('ICD10CM', icd, row['display'], obs, 'narrower', evidence, 'awaiting review')
                counts['awaiting review'] += 1
        else:
            answer, _, who = decisions.pop((obs, icd), ('', '', ''))
            if answer == 'yes':
                add('ICD10CM', icd, row['display'], obs, 'wider', evidence, f'reviewed: yes ({who})')
                counts['reviewed yes'] += 1
            else:
                counts['dropped: under half the sources'] += 1

    # Reviewed rows the derivation never produced: the hand-typed 2026-02-06
    # file's rows that NLM's map does not confirm. Only a yes adds anything.
    for (obs, icd), (answer, display, who) in sorted(decisions.items()):
        if answer == 'yes':
            add('ICD10CM', icd, display, obs, 'wider', 'Hand-typed 2026-02-06 file',
                f'reviewed: yes ({who})')
            counts['reviewed yes (not derived)'] += 1
        else:
            counts['reviewed no'] += 1

    # 3. LOINC: positive result required.
    for obs, rows in policy['loinc'].items():
        if obs.startswith('_'):
            continue
        for code, display in rows:
            for result_system, result_code, result_display in policy['positive_results']:
                prop = INTERPRETATION if 'ObservationInterpretation' in result_system else VALUE
                add('LOINC', code, display, obs, 'equivalent', 'Cicada policy',
                    f'only with a positive result ({result_display})',
                    {'property': prop, 'system': result_system, 'value': result_code,
                     'display': result_display})

    # 4. RxNorm and CPT.
    for key in ('rxnorm', 'cpt'):
        for obs, rows in policy[key].items():
            if obs.startswith('_'):
                continue
            for row in rows:
                code, display = row[0], row[1]
                equivalence = row[2] if len(row) > 2 else 'equivalent'
                add(key.upper(), code, display, obs, equivalence, 'Cicada policy', '')
    log.close()

    # A target may repeat (code, observation, equivalence) only as an
    # alternative result condition (dependsOn). Anything else is a real
    # duplicate, and the IG's ignoreWarnings entry for the LOINC alternatives
    # must not be able to hide one.
    for (system, code), el in elements.items():
        seen = set()
        for target in el['targets']:
            key = (target['code'], target['equivalence'])
            if key in seen and 'dependsOn' not in target:
                raise SystemExit(f'duplicate target {system} {code} -> {key}')
            seen.add(key)

    groups = defaultdict(list)
    for (system, code), el in sorted(elements.items()):
        groups[system].append({'code': code, 'display': el['display'], 'target': el['targets']})
    concept_map = {
        'resourceType': 'ConceptMap',
        'id': 'cdsi-observations',
        'url': 'http://fhirfli.dev/fhir/ig/cicada/ConceptMap/cdsi-observations',
        'name': 'CdsiObservations',
        'title': 'Chart codes to CDSi observations',
        'status': 'draft',
        'experimental': False,
        'publisher': 'FHIR-FLI',
        'description': ('Every code system Cicada reads, mapped to CDSi observation codes. '
                        "'equivalent' and 'wider' rows assert the observation; 'narrower' and "
                        "'relatedto' rows link it for clinical judgement and are not asserted. "
                        'Built by cicada_generator/tool/build_observation_concept_map.py.'),
        'targetCanonical': CDSI_VS,
        'group': [{'source': SYSTEMS[s], 'target': CDSI_CS, 'element': els}
                  for s, els in groups.items()],
    }
    with open(out_map, 'w', encoding='utf-8') as f:
        json.dump(concept_map, f, indent=1, ensure_ascii=False)
        f.write('\n')
    total = sum(len(e['target']) for els in groups.values() for e in els)
    print(f'{total} targets on {sum(len(v) for v in groups.values())} source codes -> {out_map}', flush=True)
    for k, v in sorted(counts.items()):
        print(f'  ICD-10-CM {k}: {v}', flush=True)


if __name__ == '__main__':
    main(*sys.argv[1:7])
