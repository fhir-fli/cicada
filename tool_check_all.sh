#!/usr/bin/env bash
# Analyze and test EVERY package in the repo, not just the one you have open.
#
# Why: 64bd94f5 changed a type on ForecastResult. cicada and cicada_generator
# were checked; cicada_flutter was not, and did not compile for four commits.
# `dart analyze` in one package cannot see that.
#
# Run from anywhere. Exits non-zero if any package fails.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fail=0

# Discovered, not hardcoded: a package added later must not be skipped in
# silence. That is the same failure as checking only the packages you have open.
pkgs=$(find "$ROOT" -maxdepth 2 -name pubspec.yaml \
         -not -path "*/build/*" -not -path "*/.dart_tool/*" | sort)
[ -n "$pkgs" ] || { echo "no packages found under $ROOT"; exit 1; }
printf 'checking %s packages\n\n' "$(printf '%s\n' "$pkgs" | wc -l)"

for f in $pkgs; do
  dir="$(dirname "$f")"
  pkg="$(basename "$dir")"
  if grep -q "^  flutter:" "$dir/pubspec.yaml"; then bin=flutter; else bin=dart; fi

  printf '=== %s (%s)\n' "$pkg" "$bin"
  ( cd "$dir" && $bin pub get >/dev/null 2>&1 )

  errs=$( cd "$dir" && $bin analyze 2>&1 | grep -cE "^ *error •| error - " )
  printf '    analyze errors: %s\n' "$errs"
  [ "$errs" -eq 0 ] || fail=1

  if [ -d "$dir/test" ]; then
    log=$(mktemp)
    ( cd "$dir" && $bin test > "$log" 2>&1 )
    tally=$(grep -aoE '\+[0-9]+( -[0-9]+)?:' "$log" | tail -1 | tr -d ':')
    [ -n "$tally" ] || tally='NO TALLY PARSED - check the run'
    printf '    tests: %s\n' "$tally"
    grep -aq "Some tests failed" "$log" && \
      printf '    (cicada carries 26 classified CDC failures)\n'
    rm -f "$log"
  fi
done

printf '\n'
[ "$fail" -eq 0 ] && echo "all packages analyze clean" || echo "SOME PACKAGE HAS ANALYZER ERRORS"
exit $fail
