"""Read SNOMED CT US, its relationships and NLM's ICD-10-CM map from a UMLS release.

One edition for everything: the hierarchy, the attribute relationships and the
map all come from the same UMLS release (2025AB carries SNOMEDCT_US_2025_09_01
and ICD10CM_2026), so no step compares concepts from two editions.

MRREL's RELA names "the relationship of the second concept or atom to the
first" (UMLS Reference Manual, MRREL). A row `A1 ... A2 ... due_to` therefore
says A2 is due to A1. `load_graph` stores edges child -> parent in that sense
and the direction is asserted against a known pair in `check_direction`.
"""
from collections import defaultdict

# RELA values, read as "second <rela> first", that make the second concept
# evidence of the first: a subtype (isa) or a disorder caused by it (due_to).
#
# Measured 2026-10-18 and left out:
#   * associated_with links HIV infection (86406008) and diabetes (73211009) to
#     'Disease (disorder)' itself, 125,202 concepts with its subtypes.
#   * has_associated_finding brings in 'Diabetes mellitus excluded',
#     'Family history of diabetes mellitus' and '... not detected' situations,
#     which assert the opposite or someone else.
#   * has_associated_procedure carries the same situation context as
#     has_associated_finding.
EVIDENCE_RELAS = ('isa', 'due_to')

PROPERLY_CLASSIFIED = '447637006'
UNCONDITIONAL = ('TRUE', 'OTHERWISE TRUE')


def snomed_atoms(meta):
    """AUI -> SNOMED concept id, and concept id -> fully specified name."""
    aui_code, names = {}, {}
    with open(f'{meta}/MRCONSO.RRF', encoding='utf-8') as f:
        for line in f:
            c = line.split('|')
            if c[11] != 'SNOMEDCT_US':
                continue
            aui_code[c[7]] = c[13]
            if c[12] == 'FN':
                names[c[13]] = c[14]
    return aui_code, names


def load_graph(meta, aui_code, relas=EVIDENCE_RELAS):
    """{rela: {child: {parent}}}, child being the second atom of each row."""
    wanted = set(relas)
    graph = {r: defaultdict(set) for r in relas}
    with open(f'{meta}/MRREL.RRF', encoding='utf-8') as f:
        for line in f:
            c = line.split('|')
            if c[10] != 'SNOMEDCT_US' or c[7] not in wanted:
                continue
            first, second = aui_code.get(c[1]), aui_code.get(c[5])
            if first and second and first != second:
                graph[c[7]][second].add(first)
    return graph


def check_direction(graph, names):
    """Fail loudly if the edges point the wrong way.

    Known pairs: 'Severe combined immunodeficiency disease' (31323000) is a
    'Combined immunodeficiency disease' (442459007), never the reverse; and
    'Bacterial infection due to human immunodeficiency virus infection'
    (838338001) is due to 'Human immunodeficiency virus infection' (86406008).
    """
    if '442459007' not in graph['isa'].get('31323000', set()):
        raise SystemExit('isa edge 31323000 -> 442459007 missing: direction or load is wrong')
    if '31323000' in graph['isa'].get('442459007', set()):
        raise SystemExit('isa edge points parent -> child: direction is wrong')
    if '86406008' not in graph['due_to'].get('838338001', set()):
        raise SystemExit('due_to edge 838338001 -> 86406008 missing: direction or load is wrong')


def inverted(graph):
    """{rela: {parent: {child}}}, built once and passed to evidence_closure."""
    inv = {}
    for rela, edges in graph.items():
        children = defaultdict(set)
        for child, parents in edges.items():
            for parent in parents:
                children[parent].add(child)
        inv[rela] = children
    return inv


def _descendants(roots, children):
    seen, stack = set(roots), list(roots)
    while stack:
        for child in children.get(stack.pop(), ()):
            if child not in seen:
                seen.add(child)
                stack.append(child)
    return seen


def evidence_closure(roots, inv):
    """Every concept that is evidence of a root.

    Subtypes are followed all the way down. A due_to link is followed ONE
    step from that set, and the disorders it reaches bring their own
    subtypes. Following attribute links transitively, with associated_with
    included, was measured on 2026-10-18 to spread from asplenia to 30
    unrelated observations (pregnancy, asthma, HIV).
    """
    base = _descendants(roots, inv['isa'])
    linked = set()
    for rela in EVIDENCE_RELAS:
        if rela == 'isa':
            continue
        for node in base:
            linked |= inv[rela].get(node, set())
    return base | _descendants(linked - base, inv['isa'])


def icd10cm_codes(meta):
    """Every ICD-10-CM code in the release (MRCONSO SAB ICD10CM) -> its preferred name (TTY PT)."""
    codes = {}
    with open(f'{meta}/MRCONSO.RRF', encoding='utf-8') as f:
        for line in f:
            c = line.split('|')
            if c[11] == 'ICD10CM':
                if c[12] == 'PT' or c[13] not in codes:
                    codes[c[13]] = c[14]
    return codes


def icd10cm_map_set(meta):
    """The MAPSETCUI of SNOMEDCT_US's map to ICD-10-CM.

    MRMAP holds two SNOMEDCT_US map sets in 2025AB: C6012685 to ICD10CM_2025
    and C6012686, the 'SNOMED CT to ICD-10 extended map' to the WHO's
    ICD10_2016 (MRSAT TOVSAB, read 2026-10-18). Until that day both were read,
    and 488 WHO-only codes (A15.1, B20.0, I50.0) asserted observations in an
    ICD-10-CM group. The map set's own MRCONSO atom (TTY XM) names its target.
    """
    found = []
    with open(f'{meta}/MRCONSO.RRF', encoding='utf-8') as f:
        for line in f:
            c = line.split('|')
            if c[11] == 'SNOMEDCT_US' and c[12] == 'XM' and ' to ICD10CM_' in c[14]:
                found.append(c[0])
    if len(set(found)) != 1:
        raise SystemExit(f'expected one SNOMEDCT_US -> ICD10CM map set, found {sorted(set(found))}')
    return found[0]


def _expand_placeholder(code, cm_codes):
    """NLM writes '?' where ICD-10-CM needs a 7th character (S39.848?).

    A chart carries the full code (S39.848A, ...D, ...S), so a placeholder
    target stands for every real ICD-10-CM code it matches.
    """
    if '?' not in code:
        return [code]
    prefix = code.rstrip('?')
    width = len(code)
    return sorted(c for c in cm_codes if len(c) == width and c.startswith(prefix))


def nlm_icd10cm_sources(meta):
    """ICD-10-CM code -> SNOMED concepts NLM maps to it unconditionally.

    Only the ICD-10-CM map set is read, placeholders are expanded, and a
    target that is not an ICD-10-CM code in this release is refused.
    """
    map_set = icd10cm_map_set(meta)
    cm_codes = icd10cm_codes(meta)
    sources = defaultdict(set)
    unknown = set()
    with open(f'{meta}/MRMAP.RRF', encoding='utf-8') as f:
        for line in f:
            c = line.split('|')
            if c[0] != map_set or c[22] != PROPERLY_CLASSIFIED:
                continue
            if c[20] not in UNCONDITIONAL or not c[16]:
                continue
            expanded = _expand_placeholder(c[16], cm_codes)
            if not expanded or any(x not in cm_codes for x in expanded):
                unknown.add(c[16])
                continue
            for code in expanded:
                sources[code].add(c[8])
    print(f'NLM ICD-10-CM map set {map_set}: {len(sources)} codes; '
          f'{len(unknown)} targets not in ICD10CM, skipped: {sorted(unknown)[:10]}', flush=True)
    return sources


def icd10cm_names(meta):
    """ICD-10-CM code -> preferred name, from the newest ICD10CM version present."""
    names = {}
    with open(f'{meta}/MRCONSO.RRF', encoding='utf-8') as f:
        for line in f:
            c = line.split('|')
            if c[11] == 'ICD10CM' and c[1] == 'ENG' and c[12] in ('PT', 'HT'):
                names.setdefault(c[13], c[14])
    return names
