import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Elevation (Material 3 — 6 level + tonal surface).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.7.
@immutable
class ElevationDefinition {
  final ElevationLevel? level0;
  final ElevationLevel? level1;
  final ElevationLevel? level2;
  final ElevationLevel? level3;
  final ElevationLevel? level4;
  final ElevationLevel? level5;

  const ElevationDefinition({
    this.level0,
    this.level1,
    this.level2,
    this.level3,
    this.level4,
    this.level5,
  });

  factory ElevationDefinition.fromJson(Map<String, dynamic> json) {
    return ElevationDefinition(
      level0: ElevationLevel.fromAny(json['level0']),
      level1: ElevationLevel.fromAny(json['level1']),
      level2: ElevationLevel.fromAny(json['level2']),
      level3: ElevationLevel.fromAny(json['level3']),
      level4: ElevationLevel.fromAny(json['level4']),
      level5: ElevationLevel.fromAny(json['level5']),
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, ElevationLevel? v) {
      if (v != null) m[k] = v.toAny();
    }

    put('level0', level0);
    put('level1', level1);
    put('level2', level2);
    put('level3', level3);
    put('level4', level4);
    put('level5', level5);
    return m;
  }

  ElevationDefinition copyWith({
    ElevationLevel? level0,
    ElevationLevel? level1,
    ElevationLevel? level2,
    ElevationLevel? level3,
    ElevationLevel? level4,
    ElevationLevel? level5,
  }) =>
      ElevationDefinition(
        level0: level0 ?? this.level0,
        level1: level1 ?? this.level1,
        level2: level2 ?? this.level2,
        level3: level3 ?? this.level3,
        level4: level4 ?? this.level4,
        level5: level5 ?? this.level5,
      );
}

/// Single elevation level — shorthand `num` (shadow only · tonal auto),
/// or an explicit `{ shadow, tint }` object.
///
/// `shadow` is in dp (Material 3 elevation level 0/1/3/6/8/12).
/// `tint` is a surface tint color (hex string, e.g. `#FF6750A4`) — when null,
/// the runtime falls back to `colorScheme.surfaceTint`.
@immutable
class ElevationLevel {
  final num? shadow;
  final String? tint;

  const ElevationLevel({this.shadow, this.tint});

  bool get isShorthand => tint == null;

  static ElevationLevel? fromAny(dynamic v) {
    if (v is num) return ElevationLevel(shadow: v);
    if (v is Map<String, dynamic>) {
      return ElevationLevel(
        shadow: v['shadow'] as num?,
        tint: v['tint'] as String?,
      );
    }
    return null;
  }

  Object toAny() {
    return {
      if (shadow != null) 'shadow': shadow,
      if (tint != null) 'tint': tint,
    };
  }
}
