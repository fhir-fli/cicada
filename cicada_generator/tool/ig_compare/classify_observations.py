"""Classify each CDSi observation by the codes CDC lists for it.
SNOMED semantic tag from the UMLS fully specified name (MRCONSO SAB=SNOMEDCT_US TTY=FN).
Usage: python3 -I classify_observations.py <schedule_supporting_data.json> <MRCONSO.RRF> <out.tsv>"""
import json, sys, re
from collections import Counter
sched = json.load(open(sys.argv[1]))
obs = sched['observations']['observation']
want = set()
for o in obs:
    for cv in (o.get('codedValues') or {}).get('codedValue') or []:
        if cv.get('codeSystem') == 'SNOMED': want.add(cv['code'])
tag = {}
with open(sys.argv[2], encoding='utf-8') as f:
    for line in f:
        p = line.split('|')
        if p[11] == 'SNOMEDCT_US' and p[12] == 'FN' and p[13] in want:
            m = re.search(r'\(([^()]*)\)$', p[14])
            if m: tag[p[13]] = m.group(1)
out = open(sys.argv[3], 'w')
out.write('code\ttext\tsystems\tsnomed_tags\n')
for o in obs:
    cvs = (o.get('codedValues') or {}).get('codedValue') or []
    systems = ','.join(sorted({cv.get('codeSystem') for cv in cvs}))
    tags = Counter(tag.get(cv['code'], 'not-in-umls') for cv in cvs if cv.get('codeSystem') == 'SNOMED')
    out.write('\t'.join([o['observationCode'], (o.get('observationTitle') or '').replace('\n', ' ')[:120], systems,
                         ';'.join(f'{k}={v}' for k, v in tags.most_common())]) + '\n')
    out.flush()
out.close()
