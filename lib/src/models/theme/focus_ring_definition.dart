import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Focus ring (color · width · offset · radius).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.11.3.
@immutable
class FocusRingDefinition {
  /// Color value or a `{{theme.color.primary}}` binding.
  final String? color;
  final num? width;
  final num? offset;
  final num? radius;

  const FocusRingDefinition({
    this.color,
    this.width,
    this.offset,
    this.radius,
  });

  factory FocusRingDefinition.fromJson(Map<String, dynamic> json) =>
      FocusRingDefinition(
        color: json['color'] as String?,
        width: json['width'] as num?,
        offset: json['offset'] as num?,
        radius: json['radius'] as num?,
      );

  Map<String, dynamic> toJson() => {
        if (color != null) 'color': color,
        if (width != null) 'width': width,
        if (offset != null) 'offset': offset,
        if (radius != null) 'radius': radius,
      };

  FocusRingDefinition copyWith({
    String? color,
    num? width,
    num? offset,
    num? radius,
  }) =>
      FocusRingDefinition(
        color: color ?? this.color,
        width: width ?? this.width,
        offset: offset ?? this.offset,
        radius: radius ?? this.radius,
      );
}
