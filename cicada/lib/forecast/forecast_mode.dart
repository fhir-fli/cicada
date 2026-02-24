import '../cicada.dart';

/// Selects between CDC (CDSi) and WHO immunization supporting data.
enum ForecastMode { cdc, who }

ForecastMode _currentMode = ForecastMode.cdc;

/// The currently active forecast mode.
ForecastMode get currentForecastMode => _currentMode;

/// Sets the active forecast mode. This determines which supporting data
/// (antigen definitions, schedule data, vaccine groups) is used by the engine.
void setForecastMode(ForecastMode mode) {
  _currentMode = mode;
}

/// Returns the antigen supporting data map for the active mode.
Map<String, AntigenSupportingData> get activeAntigenMap =>
    _currentMode == ForecastMode.who
        ? whoAntigenSupportingDataMap
        : antigenSupportingDataMap;

/// Returns the schedule supporting data for the active mode.
ScheduleSupportingData get activeScheduleData =>
    _currentMode == ForecastMode.who
        ? whoScheduleSupportingData
        : scheduleSupportingData;

/// Returns multi-antigen vaccine groups derived from the active schedule data.
/// A multi-antigen group is any vaccine group that maps to more than one antigen.
Map<String, List<String>> get activeMultiAntigenGroups {
  final vgMap = activeScheduleData.vaccineGroupToAntigenMap?.vaccineGroupMap;
  if (vgMap == null) return {};
  final result = <String, List<String>>{};
  for (final entry in vgMap) {
    if (entry.name != null &&
        entry.antigen != null &&
        entry.antigen!.length > 1) {
      result[entry.name!] = entry.antigen!;
    }
  }
  return result;
}
