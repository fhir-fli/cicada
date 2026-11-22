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
# The compiler's sidecar files are not served.
rm -f "$out"/main.dart.js.deps "$out"/main.dart.js.map
ls -l "$out"
