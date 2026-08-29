import 'dart:io';

/// The cicada repository root, found from this file's own location.
///
/// Every tool here reads paths like `cicada/test/conditionTestCases.ndjson`,
/// which only resolve when the process happens to be started from the repo
/// root. Run from `cicada_generator/` instead and `audit_case` reported
/// "no case ... in either test-case file" for every id — a missing file
/// looking exactly like a missing test case.
///
/// Walks up from this library until it finds the directory holding both
/// packages. Falls back to the current directory when the script location is
/// unavailable (compiled snapshots), which preserves the old behaviour.
String get repoRoot {
  Directory? dir;
  try {
    dir = File.fromUri(Platform.script).parent;
  } catch (_) {
    dir = Directory.current;
  }
  for (var d = dir; d.path != d.parent.path; d = d.parent) {
    if (Directory('${d.path}/cicada').existsSync() &&
        Directory('${d.path}/cicada_generator').existsSync()) {
      return d.path;
    }
  }
  return Directory.current.path;
}

/// [relative] resolved against [repoRoot].
String repoPath(String relative) => '$repoRoot/$relative';
