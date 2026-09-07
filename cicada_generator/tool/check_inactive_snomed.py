#!/usr/bin/env python3
"""Check every SNOMED coded value in the CDC schedule supporting data for
inactivity, and name the observations left with no active SNOMED concept.

    python3 cicada_generator/tool/check_inactive_snomed.py

Reads cicada_generator/lib/generated_files/schedule_supporting_data.json (the
Excel parse), asks tx.fhir.org `CodeSystem/$lookup` with the `inactive` and
`effectiveTime` properties for each code (International by default; the US
edition 731000124108 when International does not have the concept), and writes
cicada_generator/results/inactive_snomed.tsv one row per code as it goes. The
instrument is checked first: a known-active concept must read inactive=false.
Behind CDC-REPORT.md finding 10.
"""
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
DATA = ROOT / "cicada_generator" / "lib" / "generated_files" / "schedule_supporting_data.json"
OUT = ROOT / "cicada_generator" / "results" / "inactive_snomed.tsv"
TX = "https://tx.fhir.org/r4"
US = "http://snomed.info/sct/731000124108"


def lookup(code, version=None):
    url = f"{TX}/CodeSystem/$lookup?system=http://snomed.info/sct&code={code}&property=inactive&property=effectiveTime"
    if version:
        url += "&version=" + version
    raw = subprocess.run(["curl", "-s", url, "-H", "Accept: application/fhir+json"],
                         capture_output=True, text=True).stdout
    try:
        j = json.loads(raw)
    except json.JSONDecodeError:
        return None
    if j.get("resourceType") != "Parameters":
        return None
    display = next((p.get("valueString") for p in j["parameter"] if p["name"] == "display"), "?")
    ver = next((p.get("valueString") for p in j["parameter"] if p["name"] == "version"), "?")
    props = {}
    for p in j["parameter"]:
        if p["name"] == "property":
            parts = {q["name"]: q for q in p["part"]}
            props[parts["code"]["valueCode"]] = parts.get("value", {}).get(
                "valueBoolean", parts.get("value", {}).get("valueString"))
    return {"inactive": props.get("inactive"), "effectiveTime": props.get("effectiveTime"),
            "display": display, "version": ver.split("/")[-1]}


control = lookup("73211009")
if not control or control["inactive"] is not False:
    sys.exit(f"instrument check failed: 73211009 should be active, got {control}")

sched = json.load(open(DATA))
observations = sched["observations"]["observation"]
OUT.parent.mkdir(parents=True, exist_ok=True)
inactive_total = 0
no_active = []
with open(OUT, "w") as out:
    out.write("observation\ttitle\tcode\tcdc_text\tedition\tversion\tinactive\teffectiveTime\tpreferred_term\n")
    out.flush()
    for o in observations:
        codes = [cv for cv in ((o.get("codedValues") or {}).get("codedValue") or [])
                 if cv.get("codeSystem") == "SNOMED"]
        active = 0
        for cv in codes:
            r = lookup(cv["code"])
            edition = "International"
            if r is None:
                r = lookup(cv["code"], US)
                edition = "US"
            if r is None:
                r = {"inactive": None, "effectiveTime": None, "display": "NOT FOUND", "version": ""}
                edition = "none"
            if r["inactive"] is False:
                active += 1
            if r["inactive"] is True:
                inactive_total += 1
            out.write("\t".join(str(x) for x in [
                o["observationCode"], o["observationTitle"], cv["code"], cv.get("text", ""),
                edition, r["version"], r["inactive"], r["effectiveTime"], r["display"]]) + "\n")
            out.flush()
            print(o["observationCode"], cv["code"], edition, r["version"], "inactive=" + str(r["inactive"]), r["display"][:50], flush=True)
        if codes and active == 0:
            no_active.append(f"{o['observationCode']} {o['observationTitle']}")
print(f"\n{sum(1 for o in observations for cv in ((o.get('codedValues') or {}).get('codedValue') or []) if cv.get('codeSystem')=='SNOMED')} SNOMED coded values checked, {inactive_total} inactive.", flush=True)
print(f"{len(no_active)} observations with no active SNOMED concept:", flush=True)
for n in no_active:
    print("  ", n, flush=True)
print(OUT, flush=True)
