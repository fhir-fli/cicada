#!/usr/bin/env bash
# Build the display-only chart-tab page into build/web.
#
#   tool/build_web.sh <SMART client ID>
#
# The client ID is the app's on the EHR's app record (for the Epic sandbox,
# the non-production client ID). Serve build/web from the site root: the
# registered redirect URI is <origin>/callback.html.
set -u
cd "$(dirname "$0")/.." || exit 1
[ $# -eq 1 ] || { echo "usage: $0 <client id>"; exit 2; }
out=build/web
rm -rf "$out" && mkdir -p "$out" || exit 1
dart compile js -O2 -DCICADA_CLIENT_ID="$1" -o "$out/main.dart.js" web/main.dart || exit 1
cp web/index.html web/callback.html "$out/" || exit 1
# The compiler's sidecar files are not served. Its part files
# (main.dart.js_<n>.part.js, the chart read, engine and display that
# main.dart loads on its own) are, beside main.dart.js.
rm -f "$out"/*.deps "$out"/*.map
ls "$out"/main.dart.js_*.part.js > /dev/null || { echo "no part files: the split is gone"; exit 1; }
ls -l "$out"
