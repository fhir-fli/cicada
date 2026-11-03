"""Build the map the test generator uses to turn each CDSi observation into the FHIR resource a
chart would hold (see TEST-RESOURCE-REVIEW.md). One entry per observation, written as it goes.

Usage: python3 -I build_observation_resource_map.py <schedule_supporting_data.json> <assigned.tsv> <out.json>

Per entry: resource (Condition, AllergyIntolerance, Procedure, MedicationStatement, Immunization,
Observation), observationCategory and code/value for Observations, the codings to send, and
whether the CDSi code is added because CDC lists no code that names this observation alone.
"""
import csv, json, sys
from collections import defaultdict

FHIR = {'SNOMED': 'http://snomed.info/sct', 'ICD10CM': 'http://hl7.org/fhir/sid/icd-10-cm',
        'LOINC': 'http://loinc.org', 'RXNORM': 'http://www.nlm.nih.gov/research/umls/rxnorm',
        'CPT': 'http://www.ama-assn.org/go/cpt', 'CVX': 'http://hl7.org/fhir/sid/cvx'}
CDSI = 'http://fhirfli.dev/fhir/ig/cicada/CodeSystem/cdsi-observation-codes'
PREFER = {'Condition': ['SNOMED', 'ICD10CM'], 'AllergyIntolerance': ['SNOMED', 'CVX', 'ICD10CM'],
          'Procedure': ['SNOMED', 'CPT', 'ICD10CM'], 'MedicationStatement': ['RXNORM', 'SNOMED'],
          'Immunization': ['CVX'], 'occupation': ['SNOMED'], 'smoking': ['SNOMED'], 'laboratory': ['LOINC']}
POSITIVE = {'system': FHIR['SNOMED'], 'code': '10828004', 'display': 'Positive'}
LOINC_CODE = {'occupation': {'system': FHIR['LOINC'], 'code': '11341-5', 'display': 'History of Occupation'},
              'smoking': {'system': FHIR['LOINC'], 'code': '72166-2', 'display': 'Tobacco smoking status'}}

sched = json.load(open(sys.argv[1]))
obs = sched['observations']['observation']
assigned = {r['code']: r['resource'] for r in csv.DictReader(open(sys.argv[2]), delimiter='\t')}
owners = defaultdict(set)
for o in obs:
    for cv in (o.get('codedValues') or {}).get('codedValue') or []:
        owners[(cv['codeSystem'], cv['code'])].add(o['observationCode'])

def pick(o, order):
    cvs = [cv for cv in (o.get('codedValues') or {}).get('codedValue') or [] if cv['codeSystem'] in order]
    cvs.sort(key=lambda cv: order.index(cv['codeSystem']))
    unique = [cv for cv in cvs if owners[(cv['codeSystem'], cv['code'])] == {o['observationCode']}]
    chosen = unique[:1] or cvs[:1]
    codings = [{'system': FHIR[cv['codeSystem']], 'code': cv['code'], 'display': (cv.get('text') or '').strip() or None} for cv in chosen]
    return codings, not unique

out = {}
for o in obs:
    code, title, a = o['observationCode'], (o.get('observationTitle') or '').strip(), assigned[o['observationCode']]
    cdsi = {'system': CDSI, 'code': code, 'display': title}
    e = {'title': title}
    if a.startswith('Observation(') and a != 'Observation(pregnancy)':
        kind = a[len('Observation('):-1]
        codings, needs = pick(o, PREFER[kind])
        if kind == 'laboratory':
            e.update(resource='Observation', category='laboratory', code=codings, value=[POSITIVE])
        else:
            e.update(resource='Observation', category='social-history', code=[LOINC_CODE[kind]], value=codings)
        if needs or not codings:
            (e['value'] if kind != 'laboratory' else e['code']).append(cdsi)
    elif a == 'NO STANDARD CODE':
        e.update(resource='Observation', category=None, code=[cdsi])
    else:
        r = {'Condition|Observation(pregnancy)': 'Condition', 'Immunization?': 'Immunization'}.get(a, a)
        codings, needs = pick(o, PREFER[r])
        if needs or not codings: codings.append(cdsi)
        e.update(resource=r, code=codings)
    e['cdsiCodeAdded'] = any(c['system'] == CDSI for c in e.get('code', []) + e.get('value', []))
    out[code] = e
json.dump(out, open(sys.argv[3], 'w'), indent=1, sort_keys=True)
from collections import Counter
print(Counter(v['resource'] + ('+cdsi' if v['cdsiCodeAdded'] else '') for v in out.values()))
