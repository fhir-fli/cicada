"""Every decision-bearing function in the engine must name the rule it
implements. Prints the ones that do not. Exit 1 if any."""
import re, sys
from pathlib import Path

FILES = ['lib/models/01_vax_patient.dart','lib/models/02_vax_antigen.dart',
         'lib/models/03_vax_group.dart','lib/models/04_vax_series.dart',
         'lib/models/05_vax_dose.dart','lib/forecast/forecast.dart',
         'lib/utils/relevant_series.dart']
SPEC = re.compile(
    r'CONDSKIP-\d|FORECASTDT\w*-\d|FORECASTVG-\d|FORECASTPRIORITY-\d|'
    r'FORECASTRECVAC-\d|SELECTPATSER-\d|SELECTSCORE-\d|SELECTB-\d|CALCDT\w*-\d|'
    r'SINGLEANTVG-\d|MULTIANTVG-\d|FORECASTDN-\d|Table \d+-\d+|Figure \d+-\d+|'
    r'section \d+\.\d+|Chapter \d+|step \d+[a-z]?|KNOWN DEVIATION|DEVIATION', re.I)
# Mechanical: no clinical decision, nothing to cite.
MECHANICAL = re.compile(
    r'^(toJson|fromJson|copyWith|add|newDose|newSeries|indexDoses|_traceDose|'
    r'parseTypes|parseVolume|setOptionalProperties|evaluate|forecast|'
    r'setUnsatisfiedDoses|determineAgeIndex|updatePreferredInterval|'
    r'updateAllowedInterval|setAgeReason|markAsInadvertent|_filterAges|'
    r'_filterIntervals|forecastFromMap|forecastFromParameters|'
    r'evaluateForForecast|_extractForecastVaccineInfo)$')

missing = []
for f in FILES:
    lines = Path(f).read_text().splitlines()
    funcs = []
    for i, l in enumerate(lines):
        # A DEFINITION, not a call site: at most 2 spaces of indent, an
        # optional return type that may not be pure whitespace, and a line that
        # opens a body or an arrow. The first version let the return-type group
        # match leading indentation, so every call site counted as a function
        # and the check reported 65 where the real number is far smaller.
        m = re.match(
            r'^ {0,2}(?:@override +)?(?:static +)?'
            r'(?:[\w<>,\?\[\]{}():]+(?:<[^>]*>)? +)?'
            r'(\w+)\s*\([^;]*$', l)
        if m and not re.search(r'[{=]\s*$|,\s*$|\(\s*$', l):
            m = None
        if m and m.group(1) not in ('if','for','while','switch','catch','return','print','assert'):
            funcs.append((i, m.group(1)))
    classes = set(re.findall(r'^class (\w+)', '\n'.join(lines), re.M))
    for idx, (i, name) in enumerate(funcs):
        # A constructor decides nothing; it has no rule to cite.
        if MECHANICAL.match(name) or name in classes:
            continue
        end = funcs[idx+1][0] if idx+1 < len(funcs) else len(lines)
        # Look back only as far as the previous function ends. A fixed window
        # let a function borrow its neighbour's citation and pass by accident:
        # skipByInterval had none of its own and went green for exactly that
        # reason until a longer comment above it pushed the match out of range.
        floor = funcs[idx-1][0] + 1 if idx else 0
        block = '\n'.join(lines[max(floor, i-22):end])
        if not SPEC.search(block):
            missing.append(f'{f}:{i+1} {name}')

for m in missing:
    print(f'  NO SPEC CITATION: {m}', flush=True)
print(f'\n{len(missing)} decision-bearing functions without a rule id', flush=True)
sys.exit(1 if missing else 0)
