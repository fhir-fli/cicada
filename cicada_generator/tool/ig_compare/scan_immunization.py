"""Scan FHIR packages for Immunization examples and profiles; one row per resource, flushed.

Usage: python3 -I scan_immunization.py <out_examples.tsv> <out_profiles.tsv> <pkgdir>... [zip:<path>]
"""
import json, sys, os, zipfile

def ref_form(ref, res):
    if ref is None: return '-'
    parts = []
    r = ref.get('reference')
    if r: parts.append('contained#' if r.startswith('#') else ('urn' if r.startswith('urn:') else 'literal'))
    if ref.get('identifier'): parts.append('identifier(sys=%s)' % ref['identifier'].get('system', '-'))
    if ref.get('display'): parts.append('display')
    if r and r.startswith('#'):
        for c in res.get('contained', []):
            if c.get('id') == r[1:]:
                ids = [i.get('system', '-') for i in c.get('identifier', [])]
                parts.append('contained %s ids=%s name=%s' % (c['resourceType'], ids, 'name' in c))
    return '+'.join(parts) or 'empty'

def codings(cc):
    return ','.join(sorted({c.get('system', '-') for c in (cc or {}).get('coding', [])})) + ('+text' if (cc or {}).get('text') else '')

def ex_row(src, name, r):
    occ = [k for k in r if k.startswith('occurrence')]
    exts = ','.join(sorted({e.get('url', '').rsplit('/', 1)[-1] for e in r.get('extension', [])}))
    return [src, name, r.get('id', ''), r.get('status', ''), codings(r.get('vaccineCode')),
            ref_form(r.get('manufacturer'), r), 'lot' if r.get('lotNumber') else '-',
            ','.join(occ), ref_form(r.get('patient'), r), str(r.get('primarySource', '-')),
            str(len(r.get('protocolApplied', []))), exts]

def prof_rows(src, name, sd):
    out = []
    for e in sd.get('differential', {}).get('element', []):
        p = e.get('path', '')
        if not p.startswith('Immunization.'): continue
        keys = {k: e[k] for k in ('min', 'max', 'mustSupport', 'sliceName', 'fixedUri', 'patternUri', 'patternCoding', 'patternCodeableConcept') if k in e}
        b = e.get('binding', {})
        if b: keys['binding'] = '%s %s' % (b.get('strength'), b.get('valueSet'))
        if 'type' in e: keys['type'] = [(t['code'], t.get('targetProfile')) for t in e['type']]
        out.append([src, name, sd.get('url', ''), e.get('id', p), json.dumps(keys)[:400]])
    return out

def visit(src, name, d, ex, pr):
    rt = d.get('resourceType')
    if rt == 'Immunization':
        ex.write('\t'.join(ex_row(src, name, d)) + '\n'); ex.flush()
    elif rt == 'StructureDefinition' and d.get('type') == 'Immunization' and d.get('derivation') == 'constraint':
        for row in prof_rows(src, name, d): pr.write('\t'.join(row) + '\n')
        pr.flush()
    elif rt == 'Bundle':
        for e in d.get('entry', []):
            if e.get('resource'): visit(src, name + '>bundle', e['resource'], ex, pr)
    elif rt == 'Parameters':
        for p in d.get('parameter', []):
            if p.get('resource'): visit(src, name + '>param:' + p.get('name', ''), p['resource'], ex, pr)
    for c in d.get('contained', []) if rt != 'Immunization' else []:
        visit(src, name + '>contained', c, ex, pr)

def main():
    ex = open(sys.argv[1], 'w'); pr = open(sys.argv[2], 'w')
    ex.write('\t'.join(['source', 'file', 'id', 'status', 'vaccineCode systems', 'manufacturer', 'lot', 'occurrence', 'patient', 'primarySource', 'protocolApplied', 'extensions']) + '\n')
    pr.write('\t'.join(['source', 'file', 'profile', 'element', 'constraint']) + '\n')
    for arg in sys.argv[3:]:
        if arg.startswith('zip:'):
            z = zipfile.ZipFile(arg[4:])
            for n in z.namelist():
                if n.endswith('.json'):
                    try: d = json.loads(z.read(n))
                    except Exception: continue
                    visit('R4-core-examples', n.split('/')[-1], d, ex, pr)
            continue
        src = os.path.basename(arg.rstrip('/'))
        for root, _, files in os.walk(arg):
            for f in files:
                if not f.endswith('.json') or f.startswith('.'): continue
                try: d = json.load(open(os.path.join(root, f)))
                except Exception: continue
                if isinstance(d, dict): visit(src, f, d, ex, pr)
    ex.close(); pr.close()

main()
