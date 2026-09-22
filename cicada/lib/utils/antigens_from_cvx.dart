import 'package:cicada/cicada.dart';

/// Adds a single immunization
List<String> antigensFromCvx(String? cvx) {
  if (cvx == null) {
    return <String>[];
  } else {
    final diseases = <String>[];

    /// Make sure there's a matching CVX code in the CvxMap
    final cvxIndex = activeScheduleData.cvxToAntigenMap?.cvxMap?.indexWhere(
      (element) =>
          element.cvx != null &&
          int.tryParse(element.cvx!) == int.tryParse(cvx) &&
          int.tryParse(cvx) != null,
    );

    /// If we find an index for that code in the supporting data
    if (cvxIndex != null && cvxIndex != -1) {
      /// Select the appropriate entry
      final cvxEntry = activeScheduleData.cvxToAntigenMap!.cvxMap![cvxIndex];

      /// As lon as we find some associations
      if (cvxEntry.association != null && cvxEntry.association!.isNotEmpty) {
        for (final e in cvxEntry.association ?? <Association>[]) {
          if (e.antigen != null) {
            diseases.add(e.antigen!);
          }
        }
      }
    }

    diseases.retainWhere((element) => element != '');
    return diseases;
  }
}
