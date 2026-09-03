#!/usr/bin/env python3
"""Fetch the SNOMED descendant closure for every code the engine matches on.

WHY. `_matchCodingsToObservation` compares system and code by exact string
equality. SNOMED is a hierarchy and clinicians record specific concepts, so a
patient coded with any descendant of a listed concept matches nothing and the
CDSi observation is silently absent, which makes the forecast read as though
the patient had no risk condition. Measured 2026-09-03: 132 of the 244 listed
codes have descendants, 9,402 concepts in all, and 111 of those 132 sit on an
observation that gates an indication, contraindication or evidence of immunity.

Output is a TSV of descendant -> listed ancestor for the generator to turn into
Dart. Rows are written as they land.

Usage: fetch_snomed_closure.py <codes.txt> <out.tsv>
"""
import json, sys, urllib.request

TX = "https://tx.fhir.org/r4/ValueSet/$expand"
PAGE = 1000


def expand(code, offset, count):
    body = {"resourceType": "Parameters", "parameter": [
        {"name": "valueSet", "resource": {"resourceType": "ValueSet", "compose": {"include": [
            {"system": "http://snomed.info/sct",
             "filter": [{"property": "concept", "op": "is-a", "value": code}]}]}}},
        {"name": "offset", "valueInteger": offset},
        {"name": "count", "valueInteger": count}]}
    req = urllib.request.Request(TX, data=json.dumps(body).encode(),
                                 headers={"Content-Type": "application/fhir+json"})
    with urllib.request.urlopen(req, timeout=120) as r:
        return json.load(r)


codes = [c.strip() for c in open(sys.argv[1]) if c.strip()]
out = open(sys.argv[2], "w")
out.write("descendant\tancestor\tdisplay\n")
out.flush()
total = 0
for i, code in enumerate(codes, 1):
    got, offset, expected = 0, 0, None
    while True:
        try:
            d = expand(code, offset, PAGE)
        except Exception as ex:
            print(f"{i}/{len(codes)} {code} ERROR {type(ex).__name__} at offset {offset}", flush=True)
            break
        e = d.get("expansion", {})
        if expected is None:
            expected = e.get("total")
        rows = e.get("contains", [])
        for c in rows:
            # is-a includes the concept itself; only strict descendants are wanted.
            if c.get("code") == code:
                continue
            out.write(f'{c.get("code")}\t{code}\t{c.get("display", "")}\n')
            got += 1
            total += 1
        out.flush()
        offset += len(rows)
        if not rows or (expected is not None and offset >= expected):
            break
    # A read that stops short of the server's own total is truncated, and must
    # be visible rather than silently becoming a smaller closure.
    short = "" if expected is None else ("" if got >= expected - 1 else f" SHORT of {expected - 1}")
    print(f"{i}/{len(codes)} {code} -> {got}{short}", flush=True)
out.close()
print(f"TOTAL {total}", flush=True)
