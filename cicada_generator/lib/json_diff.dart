/// Every leaf where two JSON trees disagree, as "path: a -> b".
///
/// Numeric text that names the same number ("100" and "100.0") is not a
/// difference: CDC's XML writes whole numbers with a decimal, workbooks do not.
List<String> jsonDiff(dynamic a, dynamic b, [String path = '']) {
  final out = <String>[];
  if (a is Map && b is Map) {
    for (final k in {...a.keys, ...b.keys}) {
      out.addAll(jsonDiff(a[k], b[k], '$path/$k'));
    }
  } else if (a is List && b is List) {
    final n = a.length > b.length ? a.length : b.length;
    for (var i = 0; i < n; i++) {
      out.addAll(jsonDiff(
          i < a.length ? a[i] : null, i < b.length ? b[i] : null, '$path[$i]'));
    }
  } else if (a != b && !_sameNumber(a, b)) {
    out.add('$path: ${_short(a)} -> ${_short(b)}');
  }
  return out;
}

bool _sameNumber(dynamic a, dynamic b) {
  if (a is! String || b is! String) return false;
  final x = double.tryParse(a);
  final y = double.tryParse(b);
  return x != null && y != null && x == y;
}

String _short(dynamic v) {
  final s = v == null ? 'null' : v.toString();
  return s.length > 70 ? '${s.substring(0, 70)}…' : s;
}
