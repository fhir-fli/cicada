// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_for_assessment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PatientForAssessment)
final patientForAssessmentProvider = PatientForAssessmentFamily._();

final class PatientForAssessmentProvider
    extends $NotifierProvider<PatientForAssessment, VaxPatient> {
  PatientForAssessmentProvider._(
      {required PatientForAssessmentFamily super.from,
      required Parameters super.argument})
      : super(
          retry: null,
          name: r'patientForAssessmentProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$patientForAssessmentHash();

  @override
  String toString() {
    return r'patientForAssessmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PatientForAssessment create() => PatientForAssessment();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VaxPatient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VaxPatient>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PatientForAssessmentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$patientForAssessmentHash() =>
    r'bf99327ee64abf290eb053e7bf4f74f8e023ad5b';

final class PatientForAssessmentFamily extends $Family
    with
        $ClassFamilyOverride<PatientForAssessment, VaxPatient, VaxPatient,
            VaxPatient, Parameters> {
  PatientForAssessmentFamily._()
      : super(
          retry: null,
          name: r'patientForAssessmentProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PatientForAssessmentProvider call(
    Parameters parameters,
  ) =>
      PatientForAssessmentProvider._(argument: parameters, from: this);

  @override
  String toString() => r'patientForAssessmentProvider';
}

abstract class _$PatientForAssessment extends $Notifier<VaxPatient> {
  late final _$args = ref.$arg as Parameters;
  Parameters get parameters => _$args;

  VaxPatient build(
    Parameters parameters,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VaxPatient, VaxPatient>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<VaxPatient, VaxPatient>, VaxPatient, Object?, Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
