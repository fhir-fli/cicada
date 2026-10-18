#!/usr/bin/env bash
# Rebuild the chart-code -> CDSi observation map and everything generated from it,
# in the order cicada/CLAUDE.md gives: builder -> main.dart -> IG terminology.
# Run after any change to observation_map_policy.json or CROSSWALK-REVIEW.tsv.
#
# Usage: cicada_generator/tool/rebuild_observation_map.sh [UMLS META dir]
# The decisions TSV and logs go to scratch/observation_map/ (gitignored scratch).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
META="${1:-/home/grey/dev/graiai/2025AB/META}"
OUT="$ROOT/scratch/observation_map"
mkdir -p "$OUT"
cd "$ROOT"

python3 -I cicada_generator/tool/build_observation_concept_map.py \
  cicada_generator/lib/generated_files/schedule_supporting_data.json "$META" \
  cicada_generator/lib/crosswalk/observation_map_policy.json CROSSWALK-REVIEW.tsv \
  cicada_generator/lib/crosswalk/ConceptMap-cdsi-observations.json "$OUT/map_decisions.tsv"

dart run cicada_generator/lib/main.dart > "$OUT/main_dart.log" 2>&1 \
  || { echo "main.dart failed, see $OUT/main_dart.log" >&2; exit 1; }
echo "main.dart done -> $OUT/main_dart.log"

python3 -I cicada_generator/tool/generate_ig_terminology.py \
  cicada_generator/lib/crosswalk/ConceptMap-cdsi-observations.json cicada_ig

# Verify the Dart map was written from this ConceptMap. main.dart folds the
# dependsOn alternatives of one (code, observation, equivalence) into a single
# target with resultAnyOf, so count the ConceptMap the same way.
python3 -I - <<'EOF'
import json, re, sys
cm = json.load(open('cicada_generator/lib/crosswalk/ConceptMap-cdsi-observations.json'))
n_json = len({(g['source'], e['code'], t['code'], t['equivalence'])
              for g in cm['group'] for e in g['element'] for t in e['target']})
dart = open('cicada/lib/generated_files/observation_concept_map.dart').read()
n_dart = len(re.findall(r'ObservationMapTarget\(', dart))
print(f'ConceptMap targets (alternatives folded) {n_json}; Dart targets {n_dart}', flush=True)
sys.exit(0 if n_json == n_dart else 1)
EOF
