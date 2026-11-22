#!/usr/bin/env python3
"""Fail when CDC has published CDSi supporting data or healthy test cases
newer than the ones cicada is built from.

usage: check_cdc_release.py <repo root>

Reads CDC's CDSi page (https://www.cdc.gov/iis/cdsi/index.html), which
links the current files as `supporting-data-<version>-508.zip` and
`cdsi-healthy-childhood-and-adult-test-cases-v<version>.xlsx`, and compares
them with the repo: the `Version_<version>-508` source folder and the
healthy test-case workbook in cicada_generator/lib/test_cases/.

Why: cicada ran on 4.65 for six weeks after CDC published 4.66
(2026-10-09). 4.65's influenza and RSV seasons end 2026-06-30, so every
forecast that autumn said influenza was not recommended. Nothing was
watching the page.
"""
import os
import re
import sys
import subprocess

PAGE = 'https://www.cdc.gov/iis/cdsi/index.html'


def version(s):
    return tuple(int(x) for x in s.split('.'))


def only(found, what):
    if len(found) != 1:
        print(f'expected one {what}, found {sorted(found)}', flush=True)
        sys.exit(2)
    return next(iter(found))


def main():
    root = os.path.abspath(sys.argv[1])
    gen = os.path.join(root, 'cicada_generator', 'lib')
    ours_data = only({m.group(1) for d in os.listdir(gen)
                      if (m := re.fullmatch(r'Version_([\d.]+)-508', d))},
                     'Version_*-508 folder')
    ours_cases = only({m.group(1) for f in os.listdir(os.path.join(gen, 'test_cases'))
                       if (m := re.fullmatch(
                           r'cdsi-healthy-childhood-and-adult-test-cases-v([\d.]+)\.xlsx', f))},
                      'healthy test-case workbook')

    # Fetched with curl: CDC's site answered Python's urllib 403 and curl 200
    # (2026-11-21, same URL).
    page = subprocess.run(['curl', '-sSfL', '--max-time', '60', PAGE],
                          capture_output=True, text=True, check=True).stdout
    cdc_data = only(set(re.findall(r'supporting-data-([\d.]+)-508\.zip', page)),
                    'supporting-data link on the CDC page')
    cdc_cases = only(set(re.findall(
        r'cdsi-healthy-childhood-and-adult-test-cases-v([\d.]+)\.xlsx', page)),
        'healthy test-case link on the CDC page')

    behind = False
    for what, ours, cdc in (('supporting data', ours_data, cdc_data),
                            ('healthy test cases', ours_cases, cdc_cases)):
        state = 'behind' if version(cdc) > version(ours) else 'current'
        behind |= state == 'behind'
        print(f'{what}: repo {ours}, CDC {cdc}: {state}', flush=True)
    sys.exit(1 if behind else 0)


if __name__ == '__main__':
    main()
