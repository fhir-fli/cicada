"""For each (type, path, kind, system) our test cases use, how many guide examples use the same.
Usage: python3 -I compare_ours.py census.tsv out.tsv"""
import csv, sys
from collections import defaultdict
rows = list(csv.DictReader(open(sys.argv[1]), delimiter='\t'))
ours = {'cicada-healthy', 'cicada-condition'}
theirs = defaultdict(set)      # (type,path,kind,system) -> sources
theirs_path = defaultdict(set) # (type,path) -> 'kind|system' seen
for r in rows:
    if r['source'] in ours or r['path'] == '#examples': continue
    theirs[(r['type'], r['path'], r['kind'], r['system'])].add(r['source'])
    theirs_path[(r['type'], r['path'])].add(r['kind'] + ('|' + r['system'] if r['system'] else ''))
out = open(sys.argv[2], 'w')
out.write('type\tpath\tkind\tsystem\tour_count\tguides_same\tguides_same_path_other_forms\n')
seen = set()
for r in rows:
    if r['source'] not in ours or r['path'] == '#examples': continue
    k = (r['type'], r['path'], r['kind'], r['system'])
    if k in seen: continue
    seen.add(k)
    n = sum(int(x['count']) for x in rows if x['source'] in ours and (x['type'], x['path'], x['kind'], x['system']) == k)
    same = sorted(theirs.get(k, ()))
    other = sorted(theirs_path.get((r['type'], r['path']), set()) - {r['kind'] + ('|' + r['system'] if r['system'] else '')})
    out.write('\t'.join([*k, str(n), str(len(same)) + ':' + ','.join(s.split('#')[0] for s in same), ';'.join(other)[:300]]) + '\n')
    out.flush()
out.close()
