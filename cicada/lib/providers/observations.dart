// ignore_for_file: use_setters_to_change_properties
import 'package:cicada/cicada.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'observations.g.dart';

@riverpod
class Observations extends _$Observations {
  @override
  VaxObservations build() => VaxObservations();

  void setValue(VaxObservations newValue) => state = newValue;
}
