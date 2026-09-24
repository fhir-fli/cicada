#!/usr/bin/env python3
"""PostToolUse on Edit|Write: after an edit to an engine file, every
decision-bearing function must still name the CDSi rule it implements.

Runs cicada/tool_check_spec_citations.py and exits 2 with its output when a
function has no rule id, so the edit is flagged in the same turn. This replaces
the reply-reading Stop hook warn-invented-rule.py (0 correct firings in 4,
removed 2026-09-19): an invented rule is visible in the code, not in a reply.
"""
import json
import subprocess
import sys
from pathlib import Path

PKG = Path(__file__).resolve().parents[2] / 'cicada'
ENGINE = {'lib/models/vax_patient.dart', 'lib/models/vax_antigen.dart',
          'lib/models/vax_group.dart', 'lib/models/vax_series.dart',
          'lib/models/vax_dose.dart', 'lib/forecast/forecast.dart',
          'lib/utils/relevant_series.dart'}


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    path = (payload.get('tool_input') or {}).get('file_path', '')
    try:
        rel = str(Path(path).resolve().relative_to(PKG))
    except ValueError:
        return 0
    if rel not in ENGINE:
        return 0
    run = subprocess.run([sys.executable, 'tool_check_spec_citations.py'],
                         cwd=PKG, capture_output=True, text=True)
    if run.returncode == 0:
        return 0
    sys.stderr.write(
        run.stdout + '\nEvery decision in the engine names the CDSi rule it '
        'implements (CONDSKIP-1, Table 6-7, ...) or is marked DELIBERATE '
        'DEVIATION with its adjudication. A case id is not a rule. If the spec '
        'has no rule for it, the engine is right to fail that case.\n')
    return 2


if __name__ == '__main__':
    sys.exit(main())
