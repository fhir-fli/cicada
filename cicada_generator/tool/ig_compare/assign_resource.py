"""Draft a target resource type for each CDSi observation from classified.tsv. Rules in order.
Usage: python3 -I assign_resource.py classified.tsv out.tsv"""
import csv, sys, re
from collections import Counter
rows = list(csv.DictReader(open(sys.argv[1]), delimiter='\t'))
out = open(sys.argv[2], 'w'); out.write('code\ttext\tsystems\tsnomed_tags\tresource\trule\n')
c = Counter()
for r in rows:
    s, t, x = r['systems'].split(','), r['snomed_tags'], r['text'].lower()
    first = t.split(';')[0].split('=')[0] if t else ''
    if re.search(r'allerg|adverse reaction|reaction after|anaphyla', x): res, rule = 'AllergyIntolerance', 'title: allergy/reaction'
    elif 'RXNORM' in s: res, rule = 'MedicationStatement', 'RxNorm code'
    # A procedure not yet performed ("Undergoing elective splenectomy") is an order. Read
    # 2026-11-09 at hl7.org/fhir/R4B/procedure.html, Scope and Usage: Procedure records "current
    # and historical procedures performed on or for a patient". hl7.org/fhir/R4B/servicerequest.html,
    # Scope and Usage: ServiceRequest is "a record of a request for a procedure or diagnostic or
    # other service to be planned, proposed, or performed". OpenEvidence 2026-11-09: the trigger is
    # the order, since vaccination is due 14+ days before surgery (CDSI-OE-ADJUDICATED.md 18).
    elif x.startswith('undergoing'): res, rule = 'ServiceRequest', 'planned procedure'
    elif first == 'procedure' or s == ['CPT']: res, rule = 'Procedure', 'SNOMED procedure or CPT'
    elif 'LOINC' in s: res, rule = 'Observation(laboratory)', 'LOINC code'
    elif first == 'occupation': res, rule = 'Observation(occupation)', 'SNOMED occupation'
    elif re.search(r'pregnan', x): res, rule = 'Condition|Observation(pregnancy)', 'pregnancy'
    elif re.search(r'smok', x): res, rule = 'Observation(smoking)', 'smoking'
    elif first in ('disorder', 'finding', 'not-in-umls', 'event', 'qualifier value', 'observable entity', 'environment', 'substance') or 'ICD10CM' in s:
        res, rule = 'Condition', 'SNOMED ' + (first or 'none') + ' / ICD-10-CM'
    elif s == ['CVX'] or ('CVX' in s): res, rule = 'Immunization?', 'CVX only'
    elif s == ['']: res, rule = 'NO STANDARD CODE', 'CDC lists no code'
    else: res, rule = 'UNASSIGNED', ''
    c[res] += 1
    out.write('\t'.join([r['code'], r['text'], r['systems'], t, res, rule]) + '\n'); out.flush()
for k, v in c.most_common(): print(v, k, flush=True)
