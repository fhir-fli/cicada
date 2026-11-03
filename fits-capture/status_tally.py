"""Tally the ImmDS ForecastStatus codes cicada sent in a FITS run.
Writes one row per response (seq, statuses) and prints the totals."""
import glob, os, sys, collections, xml.etree.ElementTree as ET
NS = {'f': 'http://hl7.org/fhir'}
SYS = 'http://hl7.org/fhir/us/immds/CodeSystem/ForecastStatus'
total = collections.Counter()
with open(sys.argv[2], 'w') as fh:
    for f in sorted(glob.glob(os.path.join(sys.argv[1], '*_response.xml'))):
        root = ET.parse(f).getroot()
        codes = []
        for rec in root.iter('{http://hl7.org/fhir}recommendation'):
            for c in rec.findall('f:forecastStatus/f:coding', NS):
                if c.find('f:system', NS).get('value') == SYS:
                    codes.append(c.find('f:code', NS).get('value'))
        total.update(codes)
        fh.write(f"{os.path.basename(f)}\t{','.join(codes)}\n"); fh.flush()
print(dict(total), flush=True)
