import 'package:flutter/foundation.dart';

/// A vaccine dose entered by the user.
@immutable
class EnteredDose {
  const EnteredDose({
    required this.vaccineId,
    required this.vaccineLabel,
    required this.cvx,
    required this.dateGiven,
    this.isComboGenerated = false,
  });

  /// References [VaccineCardEntry.id].
  final String vaccineId;

  /// Display label (e.g., "DTaP").
  final String vaccineLabel;

  /// CVX code for the engine.
  final String cvx;

  /// Date the dose was administered.
  final DateTime dateGiven;

  /// True if this dose was auto-generated from a combo vaccine selection.
  final bool isComboGenerated;

  EnteredDose copyWith({DateTime? dateGiven}) => EnteredDose(
    vaccineId: vaccineId,
    vaccineLabel: vaccineLabel,
    cvx: cvx,
    dateGiven: dateGiven ?? this.dateGiven,
    isComboGenerated: isComboGenerated,
  );
}
