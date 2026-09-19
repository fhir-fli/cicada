"""Quick checks of cicada's project hooks. The slow half (the fast suite passing
and failing, ~27 s each) was verified by hand on 2026-09-19: a test broken in
version_stamp_test.dart blocked the stop and named itself; restored, it passed.
"""
import json
import subprocess
import sys
from pathlib import Path

H = Path(__file__).resolve().parent
PKG = H.parents[1] / 'cicada'
ok = True


def run(hook, payload):
    return subprocess.run([sys.executable, str(H / hook)], input=json.dumps(payload),
                          capture_output=True, text=True).returncode


def check(label, got, want):
    global ok
    ok &= got == want
    print(('ok  ' if got == want else 'FAIL'), label, flush=True)


probe = PKG / 'lib' / '_hook_probe.dart'
probe.write_text('int probe() => "not an int";\n')
try:
    check('analyze blocks a type error', run('analyze_edited.py', {'tool_input': {'file_path': str(probe)}}), 2)
finally:
    probe.unlink()
check('analyze passes a clean engine file',
      run('analyze_edited.py', {'tool_input': {'file_path': str(PKG / 'lib/utils/relevant_series.dart')}}), 0)
check('analyze ignores non-Dart files', run('analyze_edited.py', {'tool_input': {'file_path': str(PKG.parent / 'README.md')}}), 0)
check('fast tests honour stop_hook_active', run('fast_tests_on_stop.py', {'stop_hook_active': True}), 0)
sys.exit(0 if ok else 1)
