// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_outcomes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OperationOutcomes)
final operationOutcomesProvider = OperationOutcomesProvider._();

final class OperationOutcomesProvider
    extends $NotifierProvider<OperationOutcomes, List<OperationOutcomes>> {
  OperationOutcomesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'operationOutcomesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$operationOutcomesHash();

  @$internal
  @override
  OperationOutcomes create() => OperationOutcomes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<OperationOutcomes> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<OperationOutcomes>>(value),
    );
  }
}

String _$operationOutcomesHash() => r'15d4bda087b43faa5afe724f82199621562fa969';

abstract class _$OperationOutcomes extends $Notifier<List<OperationOutcomes>> {
  List<OperationOutcomes> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<OperationOutcomes>, List<OperationOutcomes>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<OperationOutcomes>, List<OperationOutcomes>>,
        List<OperationOutcomes>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
