// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_group_complete.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This provider is used to track the completion of a series group. Each
/// antigen has a multiple series of vaccines that can provide immunity.
/// These series are put into groups. This provider tracks the completion
/// of each series group.

@ProviderFor(SeriesGroupComplete)
final seriesGroupCompleteProvider = SeriesGroupCompleteProvider._();

/// This provider is used to track the completion of a series group. Each
/// antigen has a multiple series of vaccines that can provide immunity.
/// These series are put into groups. This provider tracks the completion
/// of each series group.
final class SeriesGroupCompleteProvider extends $NotifierProvider<
    SeriesGroupComplete, Map<String, Map<String, bool>>> {
  /// This provider is used to track the completion of a series group. Each
  /// antigen has a multiple series of vaccines that can provide immunity.
  /// These series are put into groups. This provider tracks the completion
  /// of each series group.
  SeriesGroupCompleteProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'seriesGroupCompleteProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$seriesGroupCompleteHash();

  @$internal
  @override
  SeriesGroupComplete create() => SeriesGroupComplete();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Map<String, bool>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<String, Map<String, bool>>>(value),
    );
  }
}

String _$seriesGroupCompleteHash() =>
    r'385025cfeb98282631a230cc68eb7b2691ab96fe';

/// This provider is used to track the completion of a series group. Each
/// antigen has a multiple series of vaccines that can provide immunity.
/// These series are put into groups. This provider tracks the completion
/// of each series group.

abstract class _$SeriesGroupComplete
    extends $Notifier<Map<String, Map<String, bool>>> {
  Map<String, Map<String, bool>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<Map<String, Map<String, bool>>, Map<String, Map<String, bool>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, Map<String, bool>>,
            Map<String, Map<String, bool>>>,
        Map<String, Map<String, bool>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
