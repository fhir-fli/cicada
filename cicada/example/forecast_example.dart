import 'dart:convert';
import 'dart:io';

import 'package:cicada/cicada.dart';

/// Run from cicada/cicada: dart run example/forecast_example.dart
void main() {
  final input =
      jsonDecode(
            File('example/forecast-input.json').readAsStringSync(),
          )
          as Map<String, dynamic>;

  final cdc = forecastFromMap(input); // CDC schedule (default)
  final who = forecastFromMap(input, mode: ForecastMode.who);
  // An example prints its result.
  // ignore: avoid_print
  print(jsonEncode(cdc.toJson()));
  // ignore: avoid_print
  print(jsonEncode(who.toJson()));
}
