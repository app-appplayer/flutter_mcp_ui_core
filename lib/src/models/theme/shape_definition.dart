import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Shape (Material 3 — 7 family + per-corner override).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.6.
@immutable
class ShapeDefinition {
  final ShapeCorner? none;
  final ShapeCorner? extraSmall;
  final ShapeCorner? small;
  final ShapeCorner? medium;
  final ShapeCorner? large;
  final ShapeCorner? extraLarge;
  final ShapeCorner? full;

  /// Custom named shapes (e.g. per-corner overrides).
  final Map<String, ShapeCorner>? extras;

  const ShapeDefinition({
    this.none,
    this.extraSmall,
    this.small,
    this.medium,
    this.large,
    this.extraLarge,
    this.full,
    this.extras,
  });

  factory ShapeDefinition.fromJson(Map<String, dynamic> json) {
    const known = {
      'none',
      'extraSmall',
      'small',
      'medium',
      'large',
      'extraLarge',
      'full',
    };
    final extras = <String, ShapeCorner>{};
    for (final entry in json.entries) {
      if (!known.contains(entry.key)) {
        final c = ShapeCorner.fromAny(entry.value);
        if (c != null) extras[entry.key] = c;
      }
    }
    return ShapeDefinition(
      none: ShapeCorner.fromAny(json['none']),
      extraSmall: ShapeCorner.fromAny(json['extraSmall']),
      small: ShapeCorner.fromAny(json['small']),
      medium: ShapeCorner.fromAny(json['medium']),
      large: ShapeCorner.fromAny(json['large']),
      extraLarge: ShapeCorner.fromAny(json['extraLarge']),
      full: ShapeCorner.fromAny(json['full']),
      extras: extras.isEmpty ? null : extras,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, ShapeCorner? v) {
      if (v != null) m[k] = v.toAny();
    }

    put('none', none);
    put('extraSmall', extraSmall);
    put('small', small);
    put('medium', medium);
    put('large', large);
    put('extraLarge', extraLarge);
    put('full', full);
    if (extras != null) {
      for (final e in extras!.entries) {
        m[e.key] = e.value.toAny();
      }
    }
    return m;
  }

  ShapeDefinition copyWith({
    ShapeCorner? none,
    ShapeCorner? extraSmall,
    ShapeCorner? small,
    ShapeCorner? medium,
    ShapeCorner? large,
    ShapeCorner? extraLarge,
    ShapeCorner? full,
    Map<String, ShapeCorner>? extras,
  }) =>
      ShapeDefinition(
        none: none ?? this.none,
        extraSmall: extraSmall ?? this.extraSmall,
        small: small ?? this.small,
        medium: medium ?? this.medium,
        large: large ?? this.large,
        extraLarge: extraLarge ?? this.extraLarge,
        full: full ?? this.full,
        extras: extras ?? this.extras,
      );
}

/// Shape corner — either a uniform `num` or a per-corner object.
@immutable
class ShapeCorner {
  /// Uniform radius — applied to all corners.
  final num? uniform;

  /// Per-corner override — RTL auto-flips (LTR maps topStart=topLeft).
  final num? topStart;
  final num? topEnd;
  final num? bottomStart;
  final num? bottomEnd;

  const ShapeCorner.uniform(this.uniform)
      : topStart = null,
        topEnd = null,
        bottomStart = null,
        bottomEnd = null;

  const ShapeCorner.perCorner({
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
  }) : uniform = null;

  bool get isUniform => uniform != null;

  static ShapeCorner? fromAny(dynamic v) {
    if (v is num) return ShapeCorner.uniform(v);
    if (v is Map<String, dynamic>) {
      return ShapeCorner.perCorner(
        topStart: v['topStart'] as num?,
        topEnd: v['topEnd'] as num?,
        bottomStart: v['bottomStart'] as num?,
        bottomEnd: v['bottomEnd'] as num?,
      );
    }
    return null;
  }

  Object toAny() {
    if (isUniform) return uniform!;
    final m = <String, num>{};
    if (topStart != null) m['topStart'] = topStart!;
    if (topEnd != null) m['topEnd'] = topEnd!;
    if (bottomStart != null) m['bottomStart'] = bottomStart!;
    if (bottomEnd != null) m['bottomEnd'] = bottomEnd!;
    return m;
  }
}
