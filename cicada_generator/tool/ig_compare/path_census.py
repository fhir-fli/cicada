"""Field census: for each resource type, every populated element path, its value kind and,
for codings/identifiers, the system. One row per (source, type, path, kind, system), counted.

Usage: python3 -I path_census.py <out.tsv> <types,comma,sep> <source>...
  source: a package dir, zip:<examples.zip>, or ndjson:<label>=<file>
"""
import json, sys, os, zipfile
from collections import Counter

TYPES = set(sys.argv[2].split(','))
census = Counter()
examples = Counter()

def walk(src, rt, node, path):
    if isinstance(node, dict):
        if 'system' in node and ('code' in node or 'value' in node):
            kind = 'Coding' if 'code' in node else 'Identifier'
            census[(src, rt, path, kind, node.get('system', ''))] += 1
        if 'reference' in node or ('display' in node and len(node) <= 3 and 'code' not in node and 'system' not in node):
            r = node.get('reference', '')
            form = 'contained' if r.startswith('#') else ('urn' if r.startswith('urn:') else ('literal' if r else 'no-reference'))
            census[(src, rt, path, 'Reference:' + form, '')] += 1
        for k, v in node.items():
            if k in ('text',) and isinstance(v, dict) and 'div' in v: continue
            if k == 'resource' and isinstance(v, dict) and 'resourceType' in v:
                visit(src, v); census[(src, rt, path + '.resource', 'resource:' + v['resourceType'], '')] += 1; continue
            if k == 'contained':
                for c in v: census[(src, rt, path + '.contained', 'resource:' + c.get('resourceType', ''), '')] += 1
                for c in v: walk(src, rt, c, path + '.contained(' + c.get('resourceType', '') + ')')
                continue
            if k == 'extension' or k == 'modifierExtension':
                for e in v:
                    u = e.get('url', '')
                    walk(src, rt, e, path + '.' + k + '[' + u + ']')
                continue
            walk(src, rt, v, path + '.' + k)
    elif isinstance(node, list):
        for x in node: walk(src, rt, x, path)
    else:
        kind = type(node).__name__
        census[(src, rt, path, kind, '')] += 1

def visit(src, d):
    if not isinstance(d, dict): return
    rt = d.get('resourceType')
    if rt == 'Bundle':
        for e in d.get('entry', []): visit(src, e.get('resource'))
        return
    if rt in TYPES:
        examples[(src, rt)] += 1
        walk(src, rt, d, rt)

def main():
    out = open(sys.argv[1], 'w')
    for arg in sys.argv[3:]:
        if arg.startswith('zip:'):
            z = zipfile.ZipFile(arg[4:])
            for n in z.namelist():
                if n.endswith('.json') and not n.split('/')[-1].startswith(('valueset', 'codesystem', 'conceptmap', 'sc-', 'structuredefinition')) and '.profile.' not in n:
                    try: visit('R4-core-examples', json.loads(z.read(n)))
                    except Exception: pass
        elif arg.startswith('ndjson:'):
            label, f = arg[7:].split('=', 1)
            for line in open(f):
                visit(label, json.loads(line))
        else:
            src = os.path.basename(arg.rstrip('/'))
            for root, _, files in os.walk(arg):
                for f in files:
                    if f.endswith('.json') and not f.startswith('.'):
                        try: d = json.load(open(os.path.join(root, f)))
                        except Exception: continue
                        if isinstance(d, dict) and d.get('resourceType') not in ('StructureDefinition', 'ValueSet', 'CodeSystem', 'ConceptMap', 'ImplementationGuide', 'SearchParameter', 'CapabilityStatement', 'OperationDefinition', 'NamingSystem'):
                            visit(src, d)
        print('done', arg, flush=True)
    out.write('source\ttype\tpath\tkind\tsystem\tcount\n')
    for (src, rt), n in sorted(examples.items()):
        out.write('\t'.join([src, rt, '#examples', '', '', str(n)]) + '\n')
    for k, n in sorted(census.items()):
        out.write('\t'.join(list(k) + [str(n)]) + '\n')
    out.close()

main()
