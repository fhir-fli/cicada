export 'forecast/forecast.dart';
export 'forecast/forecast_mode.dart';
export 'forecast/immds_response.dart';
export 'generated_files/generated_supporting_data.dart';
export 'generated_files/who/who_generated_supporting_data.dart';
export 'models/models.dart';
export 'providers/providers.dart';
export 'supporting_data/supporting_data.dart';
export 'utils/utils.dart';

/// The engine version stamped into every response.
///
/// ICE stamps its own version on every evaluated shot and every recommendation
/// (`dataSourceType code="ICE_1.22.1"`). Without it a stored response cannot be
/// traced to the code that produced it, which is the whole basis of being able
/// to reproduce a forecast.
///
/// Must match `version:` in pubspec.yaml; `version_stamp_test.dart` fails if it
/// drifts.
const String cicadaEngineVersion = '0.0.1';

/// The CDSi supporting-data release the generated antigen files were built
/// from. A forecast is a function of the engine AND the schedule data, so both
/// belong in the response.
const String cdsiSupportingDataVersion = '4.65-508';
