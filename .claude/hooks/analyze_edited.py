#!/usr/bin/env python3
"""PostToolUse on Edit|Write: `dart analyze` the Dart file just edited.

Errors and warnings go back to Claude in the same turn (exit 2), so a broken
edit is caught at the edit, not at the next test run or in CI. About 0.5 s per
file in cicada (measured 2026-09-19). Infos do not block; the gate in
tool_check_all.sh still counts analyzer errors across every package.
"""
import json
import subprocess
import sys
from pathlib import Path


def package_root(path: Path):
    for parent in path.parents:
        if (parent / 'pubspec.yaml').exists():
            return parent
    return None


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return 0
    file_path = (payload.get('tool_input') or {}).get('file_path') or ''
    if not file_path.endswith('.dart'):
        return 0
    path = Path(file_path).resolve()
    root = package_root(path)
    if root is None or not path.exists():
        return 0
    try:
        run = subprocess.run(['dart', 'analyze', str(path)], cwd=root,
                             capture_output=True, text=True, timeout=60)
    except (subprocess.TimeoutExpired, OSError):
        return 0
    if run.returncode == 0:
        return 0
    sys.stderr.write(f'dart analyze {path.relative_to(root)}:\n{run.stdout[-3000:]}'
                     '\nFix these before moving on.\n')
    return 2


if __name__ == '__main__':
    sys.exit(main())
