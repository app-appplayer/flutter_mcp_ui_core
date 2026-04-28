import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Density (3-step VisualDensity).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.9.
@immutable
class DensityDefinition {
  final DensityLevel? comfortable;
  final DensityLevel? standard;
  final DensityLevel? compact;

  /// Active selection — `comfortable` / `standard` / `compact` / null (runtime auto).
  final String? active;

  const DensityDefinition({
    this.comfortable,
    this.standard,
    this.compact,
    this.active,
  });

  factory DensityDefinition.fromJson(Map<String, dynamic> json) =>
      DensityDefinition(
        comfortable: json['comfortable'] is Map<String, dynamic>
            ? DensityLevel.fromJson(
                json['comfortable'] as Map<String, dynamic>)
            : null,
        standard: json['standard'] is Map<String, dynamic>
            ? DensityLevel.fromJson(json['standard'] as Map<String, dynamic>)
            : null,
        compact: json['compact'] is Map<String, dynamic>
            ? DensityLevel.fromJson(json['compact'] as Map<String, dynamic>)
            : null,
        active: json['active'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (comfortable != null) 'comfortable': comfortable!.toJson(),
        if (standard != null) 'standard': standard!.toJson(),
        if (compact != null) 'compact': compact!.toJson(),
        if (active != null) 'active': active,
      };

  DensityDefinition copyWith({
    DensityLevel? comfortable,
    DensityLevel? standard,
    DensityLevel? compact,
    String? active,
  }) =>
      DensityDefinition(
        comfortable: comfortable ?? this.comfortable,
        standard: standard ?? this.standard,
        compact: compact ?? this.compact,
        active: active ?? this.active,
      );

  /// Resolve the active density level by name (e.g. `comfortable` /
  /// `standard` / `compact`). Returns `null` if the named slot is unset.
  DensityLevel? level(String name) {
    switch (name) {
      case 'comfortable':
        return comfortable;
      case 'standard':
        return standard;
      case 'compact':
        return compact;
    }
    return null;
  }

  /// Convenience accessor for the currently active level (resolves [active]
  /// against the named slots).
  DensityLevel? get activeLevel =>
      active == null ? null : level(active!);
}

/// Material VisualDensity — vertical / horizontal (range -4 ~ 4).
@immutable
class DensityLevel {
  final num vertical;
  final num horizontal;

  const DensityLevel({required this.vertical, required this.horizontal});

  factory DensityLevel.fromJson(Map<String, dynamic> json) => DensityLevel(
        vertical: (json['vertical'] as num?) ?? 0,
        horizontal: (json['horizontal'] as num?) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'vertical': vertical,
        'horizontal': horizontal,
      };
}
