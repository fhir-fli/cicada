// ignore_for_file: invalid_annotation_target

import '../../cicada.dart';

class ConditionalSkip {
  ConditionalSkip({
    this.context,
    this.setLogic,
    this.set_,
  });

  final SkipContext? context;
  final String? setLogic;
  final List<VaxSet>? set_;

  factory ConditionalSkip.fromJson(Map<String, dynamic> json) {
    return ConditionalSkip(
      context: json['context'] == null
          ? null
          : SkipContext.fromJson(json['context'] as String),
      setLogic: json['setLogic'] as String?,
      set_: (json['set'] as List<dynamic>?)
          ?.map((e) => VaxSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (context != null) 'context': context?.toJson(),
      if (setLogic != null) 'setLogic': setLogic,
      if (set_ != null) 'set': set_?.map((e) => e.toJson()).toList(),
    };
  }

  ConditionalSkip copyWith({
    SkipContext? context,
    String? setLogic,
    List<VaxSet>? set_,
  }) {
    return ConditionalSkip(
      context: context ?? this.context,
      setLogic: setLogic ?? this.setLogic,
      set_: set_ ?? this.set_,
    );
  }
}
