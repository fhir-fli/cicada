# Where other guides put Immunization data

`scan_immunization.py` reads every Immunization example and profile in a set of FHIR
packages and writes one row per resource. Run 2026-11-02 over the packages below,
downloaded from packages.fhir.org, plus the R4 core `examples-json.zip`:

hl7.fhir.us.core 3.1.0 and 9.0.0, hl7.fhir.us.immds 1.0.0, hl7.fhir.uv.ips 2.0.1,
hl7.fhir.uv.ipa 1.1.0, hl7.fhir.eu.base 2.0.1, hl7.fhir.au.base 6.0.0, hl7.fhir.au.core 2.0.0,
fhir.r4.ukcore.stu2 2.0.2, ca.infoway.io.psca 1.1.0, ca.infoway.io.cafex 2.0.0,
fhir.org.nz.ig.base 3.1.0, ch.fhir.ig.ch-core 6.0.0, de.basisprofil.r4 1.6.0,
nictiz.fhir.nl.r4.immunization 2.0.0, smart.who.int.immunizations 1.0.0,
hl7.fhir.uv.v2mappings 1.0.0.

```bash
python3 -I scan_immunization.py imm_examples.tsv imm_profiles.tsv <package dirs...> zip:<examples-json.zip>
```

Outputs: `imm_examples.tsv` (48 examples, 14 sources), `imm_profiles.tsv` (177 element constraints).
