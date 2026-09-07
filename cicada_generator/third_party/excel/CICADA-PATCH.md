# excel 4.0.6, patched

Copied from `~/.pub-cache/hosted/pub.dev/excel-4.0.6` on 2026-09-06 and used
through `dependency_overrides` in `cicada_generator/pubspec.yaml`.

One change, in `lib/src/sharedStrings/shared_strings.dart`, `SharedStrings.add`:
shared strings are kept at their file position instead of being deduplicated
by value on load. Cell references index positions in `sharedStrings.xml`;
deduplicating shifts every index after a duplicate and makes the last one
resolve to null, which `Parser._parseCell` dereferences with `!`.

Trigger: CDC's `AntigenSupportingData- Hib-508.xlsx` (CDSi 4.65-508) carries
the text "Hib" twice in `sharedStrings.xml` (508 entries, uniqueCount="508",
507 distinct). With upstream 4.0.6 the workbook cannot be opened; with this
patch it parses and matches CDC's XML rendering exactly.

Upstream: https://github.com/justkawal/excel . Not yet reported.
Remove this directory and the override once a release carries the fix.
