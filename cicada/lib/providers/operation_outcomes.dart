import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'operation_outcomes.g.dart';

@riverpod
class OperationOutcomes extends _$OperationOutcomes {
  @override
  List<OperationOutcomes> build() => <OperationOutcomes>[];

  void addError(String errorString) {}
}
