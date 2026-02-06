// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observations.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Observations)
final observationsProvider = ObservationsProvider._();

final class ObservationsProvider
    extends $NotifierProvider<Observations, VaxObservations> {
  ObservationsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'observationsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$observationsHash();

  @$internal
  @override
  Observations create() => Observations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VaxObservations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VaxObservations>(value),
    );
  }
}

String _$observationsHash() => r'bb1526d031a17fa2f8acab67f61c07b4786ada48';

abstract class _$Observations extends $Notifier<VaxObservations> {
  VaxObservations build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VaxObservations, VaxObservations>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<VaxObservations, VaxObservations>,
        VaxObservations,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
