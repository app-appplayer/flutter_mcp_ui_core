import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Typography (Material 3 — 15 role).
///
/// 5 family (display/headline/title/body/label) × 3 size (Large/Medium/Small).
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.4.
@immutable
class TypographyDefinition {
  final TextStyleDefinition? displayLarge;
  final TextStyleDefinition? displayMedium;
  final TextStyleDefinition? displaySmall;
  final TextStyleDefinition? headlineLarge;
  final TextStyleDefinition? headlineMedium;
  final TextStyleDefinition? headlineSmall;
  final TextStyleDefinition? titleLarge;
  final TextStyleDefinition? titleMedium;
  final TextStyleDefinition? titleSmall;
  final TextStyleDefinition? bodyLarge;
  final TextStyleDefinition? bodyMedium;
  final TextStyleDefinition? bodySmall;
  final TextStyleDefinition? labelLarge;
  final TextStyleDefinition? labelMedium;
  final TextStyleDefinition? labelSmall;

  const TypographyDefinition({
    this.displayLarge,
    this.displayMedium,
    this.displaySmall,
    this.headlineLarge,
    this.headlineMedium,
    this.headlineSmall,
    this.titleLarge,
    this.titleMedium,
    this.titleSmall,
    this.bodyLarge,
    this.bodyMedium,
    this.bodySmall,
    this.labelLarge,
    this.labelMedium,
    this.labelSmall,
  });

  /// 15 role names — reused by TypographyInspector / generator and similar.
  static const List<String> roles = <String>[
    'displayLarge', 'displayMedium', 'displaySmall',
    'headlineLarge', 'headlineMedium', 'headlineSmall',
    'titleLarge', 'titleMedium', 'titleSmall',
    'bodyLarge', 'bodyMedium', 'bodySmall',
    'labelLarge', 'labelMedium', 'labelSmall',
  ];

  TextStyleDefinition? styleFor(String role) {
    switch (role) {
      case 'displayLarge': return displayLarge;
      case 'displayMedium': return displayMedium;
      case 'displaySmall': return displaySmall;
      case 'headlineLarge': return headlineLarge;
      case 'headlineMedium': return headlineMedium;
      case 'headlineSmall': return headlineSmall;
      case 'titleLarge': return titleLarge;
      case 'titleMedium': return titleMedium;
      case 'titleSmall': return titleSmall;
      case 'bodyLarge': return bodyLarge;
      case 'bodyMedium': return bodyMedium;
      case 'bodySmall': return bodySmall;
      case 'labelLarge': return labelLarge;
      case 'labelMedium': return labelMedium;
      case 'labelSmall': return labelSmall;
    }
    return null;
  }

  TypographyDefinition setStyle(String role, TextStyleDefinition? style) {
    return copyWith(
      displayLarge: role == 'displayLarge' ? style : displayLarge,
      displayMedium: role == 'displayMedium' ? style : displayMedium,
      displaySmall: role == 'displaySmall' ? style : displaySmall,
      headlineLarge: role == 'headlineLarge' ? style : headlineLarge,
      headlineMedium: role == 'headlineMedium' ? style : headlineMedium,
      headlineSmall: role == 'headlineSmall' ? style : headlineSmall,
      titleLarge: role == 'titleLarge' ? style : titleLarge,
      titleMedium: role == 'titleMedium' ? style : titleMedium,
      titleSmall: role == 'titleSmall' ? style : titleSmall,
      bodyLarge: role == 'bodyLarge' ? style : bodyLarge,
      bodyMedium: role == 'bodyMedium' ? style : bodyMedium,
      bodySmall: role == 'bodySmall' ? style : bodySmall,
      labelLarge: role == 'labelLarge' ? style : labelLarge,
      labelMedium: role == 'labelMedium' ? style : labelMedium,
      labelSmall: role == 'labelSmall' ? style : labelSmall,
    );
  }

  factory TypographyDefinition.fromJson(Map<String, dynamic> json) {
    TextStyleDefinition? r(String k) {
      final v = json[k];
      if (v is Map<String, dynamic>) return TextStyleDefinition.fromJson(v);
      return null;
    }

    return TypographyDefinition(
      displayLarge: r('displayLarge'),
      displayMedium: r('displayMedium'),
      displaySmall: r('displaySmall'),
      headlineLarge: r('headlineLarge'),
      headlineMedium: r('headlineMedium'),
      headlineSmall: r('headlineSmall'),
      titleLarge: r('titleLarge'),
      titleMedium: r('titleMedium'),
      titleSmall: r('titleSmall'),
      bodyLarge: r('bodyLarge'),
      bodyMedium: r('bodyMedium'),
      bodySmall: r('bodySmall'),
      labelLarge: r('labelLarge'),
      labelMedium: r('labelMedium'),
      labelSmall: r('labelSmall'),
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    for (final role in roles) {
      final s = styleFor(role);
      if (s != null) m[role] = s.toJson();
    }
    return m;
  }

  TypographyDefinition copyWith({
    TextStyleDefinition? displayLarge,
    TextStyleDefinition? displayMedium,
    TextStyleDefinition? displaySmall,
    TextStyleDefinition? headlineLarge,
    TextStyleDefinition? headlineMedium,
    TextStyleDefinition? headlineSmall,
    TextStyleDefinition? titleLarge,
    TextStyleDefinition? titleMedium,
    TextStyleDefinition? titleSmall,
    TextStyleDefinition? bodyLarge,
    TextStyleDefinition? bodyMedium,
    TextStyleDefinition? bodySmall,
    TextStyleDefinition? labelLarge,
    TextStyleDefinition? labelMedium,
    TextStyleDefinition? labelSmall,
  }) {
    return TypographyDefinition(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }
}

/// Text style — fontFamily / fontSize / fontWeight / lineHeight / letterSpacing / fontFeatureSettings.
@immutable
class TextStyleDefinition {
  /// `string` or `string[]` (fallback chain).
  final Object? fontFamily;
  final num? fontSize;

  /// `100`-`900` (number) or `'regular' / 'medium' / 'bold'` (alias).
  final Object? fontWeight;

  /// Multiplier (e.g. 1.5) or absolute logical px.
  final num? lineHeight;
  final num? letterSpacing;
  final List<String>? fontFeatureSettings;

  const TextStyleDefinition({
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.fontFeatureSettings,
  });

  factory TextStyleDefinition.fromJson(Map<String, dynamic> json) =>
      TextStyleDefinition(
        fontFamily: json['fontFamily'],
        fontSize: json['fontSize'] as num?,
        fontWeight: json['fontWeight'],
        lineHeight: json['lineHeight'] as num?,
        letterSpacing: json['letterSpacing'] as num?,
        fontFeatureSettings: json['fontFeatureSettings'] is List
            ? List<String>.from(json['fontFeatureSettings'] as List)
            : null,
      );

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    if (fontFamily != null) m['fontFamily'] = fontFamily;
    if (fontSize != null) m['fontSize'] = fontSize;
    if (fontWeight != null) m['fontWeight'] = fontWeight;
    if (lineHeight != null) m['lineHeight'] = lineHeight;
    if (letterSpacing != null) m['letterSpacing'] = letterSpacing;
    if (fontFeatureSettings != null) {
      m['fontFeatureSettings'] = fontFeatureSettings;
    }
    return m;
  }

  TextStyleDefinition copyWith({
    Object? fontFamily,
    num? fontSize,
    Object? fontWeight,
    num? lineHeight,
    num? letterSpacing,
    List<String>? fontFeatureSettings,
  }) =>
      TextStyleDefinition(
        fontFamily: fontFamily ?? this.fontFamily,
        fontSize: fontSize ?? this.fontSize,
        fontWeight: fontWeight ?? this.fontWeight,
        lineHeight: lineHeight ?? this.lineHeight,
        letterSpacing: letterSpacing ?? this.letterSpacing,
        fontFeatureSettings: fontFeatureSettings ?? this.fontFeatureSettings,
      );
}
