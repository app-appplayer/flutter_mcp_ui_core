import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Motion (Material 3 — 13 duration + 4 easing).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.8.
@immutable
class MotionDefinition {
  final MotionDurationDefinition? duration;
  final MotionEasingDefinition? easing;

  const MotionDefinition({this.duration, this.easing});

  factory MotionDefinition.fromJson(Map<String, dynamic> json) =>
      MotionDefinition(
        duration: json['duration'] is Map<String, dynamic>
            ? MotionDurationDefinition.fromJson(
                json['duration'] as Map<String, dynamic>)
            : null,
        easing: json['easing'] is Map<String, dynamic>
            ? MotionEasingDefinition.fromJson(
                json['easing'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (duration != null) 'duration': duration!.toJson(),
        if (easing != null) 'easing': easing!.toJson(),
      };

  MotionDefinition copyWith({
    MotionDurationDefinition? duration,
    MotionEasingDefinition? easing,
  }) =>
      MotionDefinition(
        duration: duration ?? this.duration,
        easing: easing ?? this.easing,
      );
}

/// 13 duration tokens (ms).
@immutable
class MotionDurationDefinition {
  final num? short1, short2, short3, short4;
  final num? medium1, medium2, medium3, medium4;
  final num? long1, long2, long3, long4;
  final num? extraLong;
  final Map<String, num>? extras;

  const MotionDurationDefinition({
    this.short1,
    this.short2,
    this.short3,
    this.short4,
    this.medium1,
    this.medium2,
    this.medium3,
    this.medium4,
    this.long1,
    this.long2,
    this.long3,
    this.long4,
    this.extraLong,
    this.extras,
  });

  factory MotionDurationDefinition.fromJson(Map<String, dynamic> json) {
    const known = {
      'short1', 'short2', 'short3', 'short4',
      'medium1', 'medium2', 'medium3', 'medium4',
      'long1', 'long2', 'long3', 'long4',
      'extraLong',
    };
    final extras = <String, num>{};
    for (final e in json.entries) {
      if (!known.contains(e.key) && e.value is num) {
        extras[e.key] = e.value as num;
      }
    }
    return MotionDurationDefinition(
      short1: json['short1'] as num?,
      short2: json['short2'] as num?,
      short3: json['short3'] as num?,
      short4: json['short4'] as num?,
      medium1: json['medium1'] as num?,
      medium2: json['medium2'] as num?,
      medium3: json['medium3'] as num?,
      medium4: json['medium4'] as num?,
      long1: json['long1'] as num?,
      long2: json['long2'] as num?,
      long3: json['long3'] as num?,
      long4: json['long4'] as num?,
      extraLong: json['extraLong'] as num?,
      extras: extras.isEmpty ? null : extras,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, num? v) {
      if (v != null) m[k] = v;
    }

    put('short1', short1);
    put('short2', short2);
    put('short3', short3);
    put('short4', short4);
    put('medium1', medium1);
    put('medium2', medium2);
    put('medium3', medium3);
    put('medium4', medium4);
    put('long1', long1);
    put('long2', long2);
    put('long3', long3);
    put('long4', long4);
    put('extraLong', extraLong);
    if (extras != null) m.addAll(extras!);
    return m;
  }
}

/// 4 easing curves — cubic-bezier string or array.
@immutable
class MotionEasingDefinition {
  final String? standard;
  final String? emphasized;
  final String? decelerate;
  final String? accelerate;
  final Map<String, String>? extras;

  const MotionEasingDefinition({
    this.standard,
    this.emphasized,
    this.decelerate,
    this.accelerate,
    this.extras,
  });

  factory MotionEasingDefinition.fromJson(Map<String, dynamic> json) {
    const known = {'standard', 'emphasized', 'decelerate', 'accelerate'};
    final extras = <String, String>{};
    for (final e in json.entries) {
      if (!known.contains(e.key) && e.value is String) {
        extras[e.key] = e.value as String;
      }
    }
    return MotionEasingDefinition(
      standard: json['standard'] as String?,
      emphasized: json['emphasized'] as String?,
      decelerate: json['decelerate'] as String?,
      accelerate: json['accelerate'] as String?,
      extras: extras.isEmpty ? null : extras,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, String? v) {
      if (v != null) m[k] = v;
    }

    put('standard', standard);
    put('emphasized', emphasized);
    put('decelerate', decelerate);
    put('accelerate', accelerate);
    if (extras != null) m.addAll(extras!);
    return m;
  }
}
