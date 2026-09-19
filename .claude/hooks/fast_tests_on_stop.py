#!/usr/bin/env python3
"""Stop: if Dart code changed since the last passing run, run the fast tests.

The fast set is 56 tests in five files, about 28 s (measured 2026-09-19): the
ImmDS response shape, series type, recommendation category, version stamp and
the CDC row-collapse sync. The 1,441-case CDC suites take minutes and stay in
tool_check_all.sh, which runs before a commit.

Runs only when a .dart file under cicada/lib or cicada/test is newer than the
last passing run, so a turn with no code change costs nothing. A failure
blocks the stop (exit 2) with the tail of the output. Honours
stop_hook_active so it cannot loop.
"""
import json
import os
import subprocess
import sys
from pathlib import Path

PKG = Path(__file__).resolve().parents[2] / 'cicada'
STAMP = PKG / '.dart_tool' / 'claude_fast_tests.ok'
FAST = ['test/immds_response_test.dart', 'test/series_type_extension_test.dart',
        'test/vaccine_recommendation_category_test.dart', 'test/version_stamp_test.dart',
        'test/cdc_row_collapse_sync_test.dart']


def newest_dart():
    newest = 0.0
    for sub in ('lib', 'test'):
        for dirpath, dirnames, filenames in os.walk(PKG / sub):
            for name in filenames:
                if name.endswith('.dart'):
                    newest = max(newest, os.stat(os.path.join(dirpath, name)).st_mtime)
    return newest


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return 0
    if payload.get('stop_hook_active'):
        return 0
    last_ok = STAMP.stat().st_mtime if STAMP.exists() else 0.0
    if newest_dart() <= last_ok:
        return 0
    try:
        run = subprocess.run(['dart', 'test', *FAST], cwd=PKG, capture_output=True,
                             text=True, timeout=150)
    except subprocess.TimeoutExpired:
        sys.stderr.write('cicada fast tests did not finish in 150 s.\n')
        return 2
    if run.returncode == 0:
        STAMP.parent.mkdir(parents=True, exist_ok=True)
        STAMP.touch()
        return 0
    sys.stderr.write('cicada fast tests FAILED after this turn\'s Dart changes:\n'
                     + run.stdout[-3000:] + '\n')
    return 2


if __name__ == '__main__':
    sys.exit(main())
