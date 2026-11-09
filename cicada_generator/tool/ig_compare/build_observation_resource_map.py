"""Build the map the test generator uses to turn each CDSi observation into the FHIR resource a
chart would hold (see TEST-RESOURCE-REVIEW.md). One entry per observation, written as it goes.

Usage: python3 -I build_observation_resource_map.py <schedule_supporting_data.json> <assigned.tsv>
       <ConceptMap-cdsi-observations.json> <out.json>

Per entry: resource (Condition, AllergyIntolerance, Procedure, MedicationStatement, Immunization,
Observation), observationCategory and code/value for Observations, the codings to send, and
whether the CDSi code is added.

A chart code is sent alone only when the engine's ConceptMap (cicada_generator/lib/crosswalk/)
asserts exactly this observation from it, read as the engine reads it: an asserting equivalence
(equivalent, equal, wider, subsumes) and, for rows that need a result, the Positive value the
laboratory resource carries. Otherwise the CDSi code is added, and the engine's direct-code pass
decides. Only exact rows are checked, not the engine's SNOMED-ancestor pass, so a code that would
assert only through an ancestor also gets the CDSi code.

A ServiceRequest (a planned procedure) asserts its observation when its code asserts the
observation the completed procedure would (ORDERED_FROM), mirroring the engine's reader.
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

ASSERTING = {'equivalent', 'equal', 'wider', 'subsumes'}
# Planned procedure -> the observation a completed one asserts (engine: patient_for_assessment.dart).
ORDERED_FROM = {'002': '160'}

sched = json.load(open(sys.argv[1]))
cm = json.load(open(sys.argv[3]))
rows = defaultdict(list)  # (system, code) -> [(observation, {(system, code) results} or empty)]
for g in cm['group']:
    for el in g['element']:
        for t in el.get('target', []):
            if t['equivalence'] not in ASSERTING: continue
            need = {(d['system'], d['value']) for d in t.get('dependsOn', [])}
            rows[(g['source'], el['code'])].append((t['code'], need))
# (observation, system) -> [(code, display)] the map asserts, in code order, for candidate codes.
mapped = defaultdict(list)
for g in cm['group']:
    for el in sorted(g['element'], key=lambda e: e['code']):
        for t in el.get('target', []):
            if t['equivalence'] in ASSERTING and (g['source'], el['code']) not in {(g['source'], c) for c, _ in mapped[(t['code'], g['source'])]}:
                mapped[(t['code'], g['source'])].append((el['code'], el.get('display')))
POSITIVE_RESULT = {('http://snomed.info/sct', '10828004')}

def asserted(coding, results=frozenset()):
    """Observations the map asserts for one coding, given the results the resource carries."""
    return {o for o, need in rows[(coding['system'], coding['code'])] if not need or need & results}

obs = sched['observations']['observation']
assigned = {r['code']: r['resource'] for r in csv.DictReader(open(sys.argv[2]), delimiter='\t')}
owners = defaultdict(set)
for o in obs:
    for cv in (o.get('codedValues') or {}).get('codedValue') or []:
        owners[(cv['codeSystem'], cv['code'])].add(o['observationCode'])

def pick(o, order, results=frozenset(), through_map=True):
    """The chart code to send, and whether the CDSi code must be added. Prefer a code the map
    asserts as this observation alone; then one CDC lists for this observation alone; then any.
    An Immunization is read as a dose, never through the map (through_map=False): CDC's own
    listing decides, as before."""
    cvs = [cv for cv in (o.get('codedValues') or {}).get('codedValue') or [] if cv['codeSystem'] in order]
    cvs.sort(key=lambda cv: order.index(cv['codeSystem']))
    coding = lambda cv: {'system': FHIR[cv['codeSystem']], 'code': cv['code'], 'display': (cv.get('text') or '').strip() or None}
    # The map's own rows for this observation are candidates too: CDC's list is no longer where
    # the engine reads chart codes from (ConceptMap-cdsi-observations.json is).
    listed = {(cv['codeSystem'], cv['code']) for cv in cvs}
    if through_map:
        for name in order:
            for c, d in mapped.get((o['observationCode'], FHIR[name]), []):
                if (name, c) not in listed:
                    cvs.append({'codeSystem': name, 'code': c, 'text': d, 'fromMap': True}); listed.add((name, c))
    exact = [cv for cv in cvs if asserted(coding(cv), results) == {o['observationCode']}]
    unique = [cv for cv in cvs if not cv.get('fromMap') and owners[(cv['codeSystem'], cv['code'])] == {o['observationCode']}]
    chosen = exact[:1] or unique[:1] or cvs[:1]
    return [coding(cv) for cv in chosen], not (exact if through_map else unique)

def pick_order(code):
    """A planned procedure: a code the map asserts as the completed procedure's observation."""
    target = ORDERED_FROM[code]
    for (system, c), targets in sorted(rows.items()):
        if system == FHIR['CPT'] and any(o == target and not need for o, need in targets):
            return [{'system': system, 'code': c, 'display': None}], False
    return [], True

out = {}
for o in obs:
    code, title, a = o['observationCode'], (o.get('observationTitle') or '').strip(), assigned[o['observationCode']]
    cdsi = {'system': CDSI, 'code': code, 'display': title}
    e = {'title': title}
    if a.startswith('Observation(') and a != 'Observation(pregnancy)':
        kind = a[len('Observation('):-1]
        codings, needs = pick(o, PREFER[kind], frozenset(POSITIVE_RESULT) if kind == 'laboratory' else frozenset())
        if kind == 'laboratory':
            e.update(resource='Observation', category='laboratory', code=codings, value=[POSITIVE])
        else:
            e.update(resource='Observation', category='social-history', code=[LOINC_CODE[kind]], value=codings)
        if needs or not codings:
            (e['value'] if kind != 'laboratory' else e['code']).append(cdsi)
    elif a == 'NO STANDARD CODE':
        e.update(resource='Observation', category=None, code=[cdsi])
    elif a == 'ServiceRequest':
        codings, needs = pick_order(code)
        if needs or not codings: codings.append(cdsi)
        e.update(resource='ServiceRequest', code=codings)
    else:
        r = {'Condition|Observation(pregnancy)': 'Condition', 'Immunization?': 'Immunization'}.get(a, a)
        codings, needs = pick(o, PREFER[r], through_map=r != 'Immunization')
        if needs or not codings: codings.append(cdsi)
        e.update(resource=r, code=codings)
    e['cdsiCodeAdded'] = any(c['system'] == CDSI for c in e.get('code', []) + e.get('value', []))
    out[code] = e
json.dump(out, open(sys.argv[4], 'w'), indent=1, sort_keys=True)
from collections import Counter
print(Counter(v['resource'] + ('+cdsi' if v['cdsiCodeAdded'] else '') for v in out.values()))
