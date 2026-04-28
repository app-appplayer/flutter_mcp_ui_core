import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Border (5 width alias + style).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.11.1.
@immutable
class BorderDefinition {
  final BorderWidthDefinition? width;

  /// `solid` / `dashed` / `dotted`.
  final String? style;

  const BorderDefinition({this.width, this.style});

  factory BorderDefinition.fromJson(Map<String, dynamic> json) =>
      BorderDefinition(
        width: json['width'] is Map<String, dynamic>
            ? BorderWidthDefinition.fromJson(
                json['width'] as Map<String, dynamic>)
            : null,
        style: json['style'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (width != null) 'width': width!.toJson(),
        if (style != null) 'style': style,
      };

  BorderDefinition copyWith({
    BorderWidthDefinition? width,
    String? style,
  }) =>
      BorderDefinition(
        width: width ?? this.width,
        style: style ?? this.style,
      );
}

/// Border width 5 alias.
@immutable
class BorderWidthDefinition {
  final num? hairline;
  final num? thin;
  final num? normal;
  final num? thick;
  final num? heavy;
  final Map<String, num>? extras;

  const BorderWidthDefinition({
    this.hairline,
    this.thin,
    this.normal,
    this.thick,
    this.heavy,
    this.extras,
  });

  factory BorderWidthDefinition.fromJson(Map<String, dynamic> json) {
    const known = {'hairline', 'thin', 'normal', 'thick', 'heavy'};
    final extras = <String, num>{};
    for (final e in json.entries) {
      if (!known.contains(e.key) && e.value is num) {
        extras[e.key] = e.value as num;
      }
    }
    return BorderWidthDefinition(
      hairline: json['hairline'] as num?,
      thin: json['thin'] as num?,
      normal: json['normal'] as num?,
      thick: json['thick'] as num?,
      heavy: json['heavy'] as num?,
      extras: extras.isEmpty ? null : extras,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, num? v) {
      if (v != null) m[k] = v;
    }

    put('hairline', hairline);
    put('thin', thin);
    put('normal', normal);
    put('thick', thick);
    put('heavy', heavy);
    if (extras != null) m.addAll(extras!);
    return m;
  }
}
