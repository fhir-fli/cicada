# Where other guides put Immunization data

`scan_immunization.py` reads every Immunization example and profile in a set of FHIR
packages and writes one row per resource. Run 2026-11-02 over the packages below,
downloaded from packages.fhir.org, plus the R4 core `examples-json.zip`:

hl7.fhir.us.core 3.1.0 and 9.0.0, hl7.fhir.us.immds 1.0.0, hl7.fhir.uv.ips 2.0.1,
hl7.fhir.uv.ipa 1.1.0, hl7.fhir.eu.base 2.0.1, hl7.fhir.au.base 6.0.0, hl7.fhir.au.core 2.0.0,
fhir.r4.ukcore.stu2 2.0.2, ca.infoway.io.psca 1.1.0, ca.infoway.io.cafex 2.0.0,
fhir.org.nz.ig.base 3.1.0, ch.fhir.ig.ch-core 6.0.0, de.basisprofil.r4 1.6.0,
nictiz.fhir.nl.r4.immunization 2.0.0, smart.who.int.immunizations 1.0.0,
hl7.fhir.uv.v2mappings 1.0.0, hl7.fhir.uv.immds 0.2.0 (international ImmDS),
hl7.fhir.uv.shc-vaccination 1.0.0, hl7.fhir.be.vaccination 1.1.3,
nictiz.fhir.nl.r4.vaccinationimmunization 1.0.0, vzvz.covid-vaccinations 0.1.3, ch.fhir.ig.ch-vacd 6.0.0,
ch.fhir.ig.ch-ips 2.0.0, hl7.fhir.cl.clips 0.4.0, d4l-data4life.covid-19.r4 0.8.0,
Eu.Dedalus.D4Solutions.COVID-19 1.0.2, smart.who.int.ips-pilgrimage 1.0.0,
hl7.fhir.uv.smart-health-cards-and-links 1.0.0, ihe.iti.sips 1.0.0 (31 sources).
Found by registry name searches: immds, immun, immuniz, immunis, vaccin, covid, shc, smart-health, ips, forecast, decision, cdsi.

```bash
python3 -I scan_immunization.py imm_examples.tsv imm_profiles.tsv <package dirs...> zip:<examples-json.zip>
```

Outputs: `imm_examples.tsv` (272 examples), `imm_profiles.tsv` (177 element constraints).
