// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_for_assessment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$patientForAssessmentHash() =>
    r'e351ed00f681c56f5fc4de85f1caf4e68f013a10';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PatientForAssessment
    extends BuildlessAutoDisposeNotifier<VaxPatient> {
  late final Parameters parameters;

  VaxPatient build(
    Parameters parameters,
  );
}

/// See also [PatientForAssessment].
@ProviderFor(PatientForAssessment)
const patientForAssessmentProvider = PatientForAssessmentFamily();

/// See also [PatientForAssessment].
class PatientForAssessmentFamily extends Family<VaxPatient> {
  /// See also [PatientForAssessment].
  const PatientForAssessmentFamily();

  /// See also [PatientForAssessment].
  PatientForAssessmentProvider call(
    Parameters parameters,
  ) {
    return PatientForAssessmentProvider(
      parameters,
    );
  }

  @override
  PatientForAssessmentProvider getProviderOverride(
    covariant PatientForAssessmentProvider provider,
  ) {
    return call(
      provider.parameters,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'patientForAssessmentProvider';
}

/// See also [PatientForAssessment].
class PatientForAssessmentProvider
    extends AutoDisposeNotifierProviderImpl<PatientForAssessment, VaxPatient> {
  /// See also [PatientForAssessment].
  PatientForAssessmentProvider(
    Parameters parameters,
  ) : this._internal(
          () => PatientForAssessment()..parameters = parameters,
          from: patientForAssessmentProvider,
          name: r'patientForAssessmentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$patientForAssessmentHash,
          dependencies: PatientForAssessmentFamily._dependencies,
          allTransitiveDependencies:
              PatientForAssessmentFamily._allTransitiveDependencies,
          parameters: parameters,
        );

  PatientForAssessmentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parameters,
  }) : super.internal();

  final Parameters parameters;

  @override
  VaxPatient runNotifierBuild(
    covariant PatientForAssessment notifier,
  ) {
    return notifier.build(
      parameters,
    );
  }

  @override
  Override overrideWith(PatientForAssessment Function() create) {
    return ProviderOverride(
      origin: this,
      override: PatientForAssessmentProvider._internal(
        () => create()..parameters = parameters,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parameters: parameters,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PatientForAssessment, VaxPatient>
      createElement() {
    return _PatientForAssessmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PatientForAssessmentProvider &&
        other.parameters == parameters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parameters.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PatientForAssessmentRef on AutoDisposeNotifierProviderRef<VaxPatient> {
  /// The parameter `parameters` of this provider.
  Parameters get parameters;
}

class _PatientForAssessmentProviderElement
    extends AutoDisposeNotifierProviderElement<PatientForAssessment, VaxPatient>
    with PatientForAssessmentRef {
  _PatientForAssessmentProviderElement(super.provider);

  @override
  Parameters get parameters =>
      (origin as PatientForAssessmentProvider).parameters;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
