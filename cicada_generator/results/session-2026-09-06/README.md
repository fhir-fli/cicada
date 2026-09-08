# Session record, 2026-09-06 and 07

The measurements behind the commits of those two days (2f2c2c8c … 08df1b0f), copied
from the session scratchpad so they outlive it. Referenced from the commit messages and
from the project memory as "the session record".

- `ig-run*.log` — every IG publisher build, 1 to 18, in order. Runs 1 and 4 were
  killed deliberately (parked, and 412 hanging calls on a cold cache); 15 died because
  SUSHI was run beside it.
- `run*-qa.txt` — the publisher's qa.txt for the builds that finished.
- `jstack-run*.txt` — thread dumps of the parked builds: the terminology upload.
- `bisect.tsv` — the curl bisection of the publisher's validate-code request on
  tx.fhir.org: `cache-id` alone makes it hang; a server-issued id answers in 0.15 s.
- `snomed-displays.tsv`, `disease-codes-status.tsv` — the 29 target-disease concepts:
  preferred terms, and inactive status in both editions (397428000 is the inactive one).
- `snomed-search.tsv` — the searches that found 1354584007 (meningococcal serogroup B
  disease) and 414015000 (disease caused by Orthopoxvirus).
- `observation-code-status.tsv`, `inactive-snomed*.tsv` — CDC finding 10's per-code
  lookups; `../inactive_snomed.tsv` is the reproducible one from the tool.
- `excel_vs_xml*.log`, `roundtrip-*.log`, `sched-*.log` — the Excel-parse proofs, in
  order, ending 30/30, 30/30, 22/22, 5/5, 5/5.
- `generate*.log` — the engine regenerations.
