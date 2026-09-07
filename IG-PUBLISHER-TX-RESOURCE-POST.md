# For Zulip #IG creation (or a hapifhir/org.hl7.fhir.core issue). Grey posts.

**Title:** Publisher fetches an external CodeSystem from the tx registry, then sends
all of it back on every validate-code as `tx-resource` (28 MB for ICD-10-CM)

Our IG has a ValueSet of 96 ICD-10-CM codes and a ConceptMap from ICD-10-CM. From
2026-09-01 every build parked in *Generating Narratives* or *Validating Conformance
Resources* and never finished. What we found, with the publisher's own tx log
(`Running Terminology Log:`), jstack, and curl replays:

1. No package we depend on (hl7.terminology.r4 7.3.0, hl7.fhir.us.core 3.1.0,
   hl7.fhir.us.immds 1.0.0, hl7.fhir.r4.core) carries a CodeSystem for
   `http://hl7.org/fhir/sid/icd-10-cm`, so the local lookup fails.
2. `BaseWorkerContext.doFindTxResource` asks the tx registry, gets tx.fhir.org, does
   `CodeSystem?url=http://hl7.org/fhir/sid/icd-10-cm`, and receives the **complete**
   ICD-10-CM: 28.7 MB, 98,505 concepts, `content: complete`, version 2026-04-01. It is
   cached as `input-cache/txcache/cs-<uuid>.json` (listed in `cs-externals.json`) and
   `cacheResource()`d into the context.
3. `BaseWorkerContext.addDependentCodeSystem` attaches every local CodeSystem whose
   content is `complete` or `fragment` as a `tx-resource` parameter. The server-fetched
   copy qualifies, so the next ICD-10-CM `CodeSystem/$validate-code` and every
   `ValueSet/$expand` touching ICD-10-CM carries the 28.7 MB CodeSystem. The tx log
   truncates bodies at 100,000 characters, which hides the size.
4. tx.fhir.org never answers that request (main thread in `SSLSocketInputRecord.read`
   under `TerminologyClientR4.validateCS`, RetryInterceptor looping, killed after 8
   minutes). CSIRO's public Ontoserver answers it in 3 min 36 s per request, three
   times per build.

Workaround that fixed it: an IG-local `CodeSystem` for that URL with
`content = #not-present` and `special-url` in sushi-config. The local lookup then
succeeds, nothing is fetched, nothing is attached. Same command, same server:
parked and killed at 8 min without it; finished in 14 min 11 s with it, request log
with nothing over 9 KB.

Suggested fix: a CodeSystem obtained from the terminology ecosystem (via
`findCodeSystemOnServer` / `TerminologyCache.cacheCodeSystem`) should not be a
candidate for `tx-resource`; the server it came from already has it, and other servers
are asked about it by URL. Alternatively cap the size of what `checkAddToParams` will
attach.

Publisher: the 2026-02-03 build of `publisher.jar` (core 2.1.0 per the manifest
class-path). Source lines above are from `hapifhir/org.hl7.fhir.core` master on
2026-09-06.

Separately observed the same day, and this one is on us: our publisher.jar was
core 2.1.0 (2026-02), which makes its own cache-id. tx.fhir.org now only accepts ids it
issued via `$cache-control?mode=start`, and on `CodeSystem/$validate-code` it **hangs**
on a foreign id rather than returning the "never issued by this server" error it
returns elsewhere (every endpoint: r4, r5, http, https, tx-dev; the same request with an
issued id answers in 0.15 s). A cold build makes ~400 such calls, so an out-of-date
publisher now never finishes instead of failing fast. Worth a hang-to-error fix on the
server, and perhaps a louder "your publisher is too old" at startup.

Third, smaller, found while fixing the SNOMED edition: the `ig-expansion-parameters`
IG parameter does nothing. `PublisherIGLoader` collects it into `expParamMap` keyed by
the parameter code, then runs `for (String n : expParamMap.values())
getExpansionParameters().addParameter(n, expParamMap.get(n))`, which adds one empty
parameter named after the value ("cicada-expansions") and never loads the Parameters
resource. `path-expansion-params` (a path relative to the IG resource's directory, so
`../../input/resources/...` for a SUSHI project) works.
