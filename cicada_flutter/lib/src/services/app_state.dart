import 'package:cicada/cicada.dart';
import 'package:cicada_flutter/src/models/entered_dose.dart';
import 'package:cicada_flutter/src/models/patient_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current patient demographics.
class PatientInfoNotifier extends Notifier<PatientInfo?> {
  @override
  PatientInfo? build() => null;

  PatientInfo? get value => state;

  set value(PatientInfo? info) => state = info;

  void clear() => state = null;
}

final patientInfoProvider = NotifierProvider<PatientInfoNotifier, PatientInfo?>(
  PatientInfoNotifier.new,
);

/// List of entered vaccine doses.
class EnteredDosesNotifier extends Notifier<List<EnteredDose>> {
  @override
  List<EnteredDose> build() => [];

  List<EnteredDose> get value => state;

  set value(List<EnteredDose> doses) => state = doses;

  void add(EnteredDose dose) => state = [...state, dose];

  void addAll(List<EnteredDose> doses) => state = [...state, ...doses];

  void removeAt(int index) {
    final list = [...state]..removeAt(index);
    state = list;
  }

  void clear() => state = [];
}

final enteredDosesProvider =
    NotifierProvider<EnteredDosesNotifier, List<EnteredDose>>(
      EnteredDosesNotifier.new,
    );

/// Forecast result — null until a forecast is run.
class ForecastResultNotifier extends Notifier<ForecastResult?> {
  @override
  ForecastResult? build() => null;

  ForecastResult? get value => state;

  set value(ForecastResult? result) => state = result;

  void clear() => state = null;
}

final forecastResultProvider =
    NotifierProvider<ForecastResultNotifier, ForecastResult?>(
      ForecastResultNotifier.new,
    );
