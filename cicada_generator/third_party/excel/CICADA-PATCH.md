# excel 4.0.6, patched

Copied from `~/.pub-cache/hosted/pub.dev/excel-4.0.6` on 2026-09-06 and used
through `dependency_overrides` in `cicada_generator/pubspec.yaml`.

Two touches. `SharedStrings` (`lib/src/sharedStrings/shared_strings.dart`)
gains `addFromFile`, which records every `<si>` at its file position, and
`value(i)` answers from those positions when a file was read.
`Parser._parseSharedString` (`lib/src/parser/parse.dart`) calls it. Cell
references index positions in `sharedStrings.xml`; upstream dedupes by value
on load, which shifts every index after a duplicate and makes the last one
resolve to null, dereferenced with `!` in `Parser._parseCell`. Writing is
untouched: `add`, `indexOf` and saving still dedupe, which is correct because
the saved table is unique and cells are re-indexed. (A first version changed
`add` itself; that broke writing: 280 cell indexes against 144 saved strings.)

Trigger: CDC's `AntigenSupportingData- Hib-508.xlsx` (CDSi 4.65-508) carries
the text "Hib" twice in `sharedStrings.xml` (508 entries, uniqueCount="508",
507 distinct). With upstream 4.0.6 the workbook cannot be opened; with this
patch it parses and matches CDC's XML rendering exactly.

Upstream: https://github.com/justkawal/excel . Not yet reported.
Remove this directory and the override once a release carries the fix.
