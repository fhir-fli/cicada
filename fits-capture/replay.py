"""Replay captured FITS requests to the local server; compare forecast dates
with the captured (old-code) responses. One TSV row per request, flushed."""
import glob, os, sys, urllib.request, xml.etree.ElementTree as ET
NS = {'f': 'http://hl7.org/fhir'}
def forecast(xml):
    root = ET.fromstring(xml); out = []
    for rec in root.iter('{http://hl7.org/fhir}recommendation'):
        dis = [c.get('value') for c in rec.findall('f:targetDisease/f:coding/f:code', NS)]
        vac = [c.get('value') for c in rec.findall('f:vaccineCode/f:coding/f:code', NS)]
        st = [c.get('value') for c in rec.findall('f:forecastStatus/f:coding/f:code', NS)]
        dates = [(d.find('f:code/f:coding/f:code', NS).get('value'), d.find('f:value', NS).get('value'))
                 for d in rec.findall('f:dateCriterion', NS)]
        out.append((tuple(dis) or tuple(vac), tuple(st), tuple(sorted(dates))))
    return sorted(out)
src, dst = sys.argv[1], sys.argv[2]
with open(dst, 'w') as fh:
    fh.write('request\tsame\told_n\tnew_n\tdiffs\n'); fh.flush()
    for req in sorted(glob.glob(os.path.join(src, '*_request.xml'))):
        seq = os.path.basename(req).rsplit('_', 2)[1]
        resp = glob.glob(os.path.join(src, f'*_{seq}_response.xml'))
        if len(resp) != 1:
            fh.write(f"{os.path.basename(req)}\tNO_PAIR\t\t\t{len(resp)}\n"); fh.flush(); continue
        old = open(resp[0], 'rb').read()
        body = open(req, 'rb').read()
        r = urllib.request.Request('http://localhost:8080/$immds-forecast', data=body,
            headers={'Content-Type': 'application/fhir+xml', 'Accept': 'application/fhir+xml'})
        new = urllib.request.urlopen(r, timeout=60).read()
        a, b = forecast(old), forecast(new)
        diffs = [x for x in b if x not in a]
        fh.write(f"{os.path.basename(req)}\t{a == b}\t{len(a)}\t{len(b)}\t{diffs}\n"); fh.flush()
