import 'package:meta/meta.dart';

import 'theme.dart';

/// MCP UI DSL 1.3 — Strongly-typed theme definition.
///
/// Maps 1:1 to the 14 token domains in `specs/mcp_ui_dsl/05_Theme.md`.
/// Material 3 naming + DTCG W3C compatibility + HCT seed.
///
/// Does not include legacy aliases (h1-h6 / headline1-6 / subtitle /
/// overline / textOnPrimary / divider / borderRadius / spacing.small,
/// etc.) — per the no-legacy-accretion policy.
@immutable
class ThemeDefinition {
  /// `'light'` / `'dark'` / `'system'`.
  final String mode;

  // 14 token domains.
  final ColorSchemeDefinition? color;
  final TypographyDefinition? typography;
  final SpacingDefinition? spacing;
  final ShapeDefinition? shape;
  final ElevationDefinition? elevation;
  final MotionDefinition? motion;
  final DensityDefinition? density;
  final BreakpointsDefinition? breakpoints;
  final BorderDefinition? border;
  final OpacityDefinition? opacity;
  final FocusRingDefinition? focusRing;
  final ZIndexDefinition? zIndex;
  final ComponentTokensDefinition? component;

  /// Mode-specific override.
  final ThemeDefinition? light;
  final ThemeDefinition? dark;

  const ThemeDefinition({
    this.mode = 'system',
    this.color,
    this.typography,
    this.spacing,
    this.shape,
    this.elevation,
    this.motion,
    this.density,
    this.breakpoints,
    this.border,
    this.opacity,
    this.focusRing,
    this.zIndex,
    this.component,
    this.light,
    this.dark,
  });

  factory ThemeDefinition.fromJson(Map<String, dynamic> json) {
    T? read<T>(String k, T Function(Map<String, dynamic>) ctor) {
      final v = json[k];
      return v is Map<String, dynamic> ? ctor(v) : null;
    }

    return ThemeDefinition(
      mode: (json['mode'] as String?) ?? 'system',
      color: read('color', ColorSchemeDefinition.fromJson),
      typography: read('typography', TypographyDefinition.fromJson),
      spacing: read('spacing', SpacingDefinition.fromJson),
      shape: read('shape', ShapeDefinition.fromJson),
      elevation: read('elevation', ElevationDefinition.fromJson),
      motion: read('motion', MotionDefinition.fromJson),
      density: read('density', DensityDefinition.fromJson),
      breakpoints: read('breakpoints', BreakpointsDefinition.fromJson),
      border: read('border', BorderDefinition.fromJson),
      opacity: read('opacity', OpacityDefinition.fromJson),
      focusRing: read('focusRing', FocusRingDefinition.fromJson),
      zIndex: read('zIndex', ZIndexDefinition.fromJson),
      component: read('component', ComponentTokensDefinition.fromJson),
      light: read('light', ThemeDefinition.fromJson),
      dark: read('dark', ThemeDefinition.fromJson),
    );
  }

  /// Imports a theme from DTCG W3C form — handles `$type` / `$value`.
  factory ThemeDefinition.fromDtcg(Map<String, dynamic> json) {
    return ThemeDefinition(
      mode: (json['mode'] as String?) ?? 'system',
      color: json['color'] is Map<String, dynamic>
          ? DtcgCodec.decodeColor(json['color'] as Map<String, dynamic>)
          : null,
      typography: json['typography'] is Map<String, dynamic>
          ? DtcgCodec.decodeTypography(
              json['typography'] as Map<String, dynamic>)
          : null,
      spacing: json['spacing'] is Map<String, dynamic>
          ? DtcgCodec.decodeSpacing(json['spacing'] as Map<String, dynamic>)
          : null,
      shape: json['shape'] is Map<String, dynamic>
          ? DtcgCodec.decodeShape(json['shape'] as Map<String, dynamic>)
          : null,
      elevation: json['elevation'] is Map<String, dynamic>
          ? DtcgCodec.decodeElevation(json['elevation'] as Map<String, dynamic>)
          : null,
      motion: json['motion'] is Map<String, dynamic>
          ? DtcgCodec.decodeMotion(json['motion'] as Map<String, dynamic>)
          : null,
      density: json['density'] is Map<String, dynamic>
          ? DtcgCodec.decodeDensity(json['density'] as Map<String, dynamic>)
          : null,
      breakpoints: json['breakpoints'] is Map<String, dynamic>
          ? DtcgCodec.decodeBreakpoints(
              json['breakpoints'] as Map<String, dynamic>)
          : null,
      border: json['border'] is Map<String, dynamic>
          ? DtcgCodec.decodeBorder(json['border'] as Map<String, dynamic>)
          : null,
      opacity: json['opacity'] is Map<String, dynamic>
          ? DtcgCodec.decodeOpacity(json['opacity'] as Map<String, dynamic>)
          : null,
      focusRing: json['focusRing'] is Map<String, dynamic>
          ? DtcgCodec.decodeFocusRing(
              json['focusRing'] as Map<String, dynamic>)
          : null,
      zIndex: json['zIndex'] is Map<String, dynamic>
          ? DtcgCodec.decodeZIndex(json['zIndex'] as Map<String, dynamic>)
          : null,
      component: json['component'] is Map<String, dynamic>
          ? DtcgCodec.decodeComponent(
              json['component'] as Map<String, dynamic>)
          : null,
      light: json['light'] is Map<String, dynamic>
          ? ThemeDefinition.fromDtcg(json['light'] as Map<String, dynamic>)
          : null,
      dark: json['dark'] is Map<String, dynamic>
          ? ThemeDefinition.fromDtcg(json['dark'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{'mode': mode};
    if (color != null) m['color'] = color!.toJson();
    if (typography != null) m['typography'] = typography!.toJson();
    if (spacing != null) m['spacing'] = spacing!.toJson();
    if (shape != null) m['shape'] = shape!.toJson();
    if (elevation != null) m['elevation'] = elevation!.toJson();
    if (motion != null) m['motion'] = motion!.toJson();
    if (density != null) m['density'] = density!.toJson();
    if (breakpoints != null) m['breakpoints'] = breakpoints!.toJson();
    if (border != null) m['border'] = border!.toJson();
    if (opacity != null) m['opacity'] = opacity!.toJson();
    if (focusRing != null) m['focusRing'] = focusRing!.toJson();
    if (zIndex != null) m['zIndex'] = zIndex!.toJson();
    if (component != null) m['component'] = component!.toJson();
    if (light != null) m['light'] = light!.toJson();
    if (dark != null) m['dark'] = dark!.toJson();
    return m;
  }

  /// Exports the theme in DTCG W3C form.
  Map<String, dynamic> toDtcg() {
    final m = <String, dynamic>{
      r'$description': 'MCP UI DSL 1.3 theme — DTCG export',
      'mode': mode,
    };
    if (color != null) m['color'] = DtcgCodec.encodeColor(color!);
    if (typography != null) m['typography'] = DtcgCodec.encodeTypography(typography!);
    if (spacing != null) m['spacing'] = DtcgCodec.encodeSpacing(spacing!);
    if (shape != null) m['shape'] = DtcgCodec.encodeShape(shape!);
    if (elevation != null) m['elevation'] = DtcgCodec.encodeElevation(elevation!);
    if (motion != null) m['motion'] = DtcgCodec.encodeMotion(motion!);
    if (density != null) m['density'] = DtcgCodec.encodeDensity(density!);
    if (breakpoints != null) m['breakpoints'] = DtcgCodec.encodeBreakpoints(breakpoints!);
    if (border != null) m['border'] = DtcgCodec.encodeBorder(border!);
    if (opacity != null) m['opacity'] = DtcgCodec.encodeOpacity(opacity!);
    if (focusRing != null) m['focusRing'] = DtcgCodec.encodeFocusRing(focusRing!);
    if (zIndex != null) m['zIndex'] = DtcgCodec.encodeZIndex(zIndex!);
    if (component != null) m['component'] = DtcgCodec.encodeComponent(component!);
    if (light != null) m['light'] = light!.toDtcg();
    if (dark != null) m['dark'] = dark!.toDtcg();
    return m;
  }

  ThemeDefinition copyWith({
    String? mode,
    ColorSchemeDefinition? color,
    TypographyDefinition? typography,
    SpacingDefinition? spacing,
    ShapeDefinition? shape,
    ElevationDefinition? elevation,
    MotionDefinition? motion,
    DensityDefinition? density,
    BreakpointsDefinition? breakpoints,
    BorderDefinition? border,
    OpacityDefinition? opacity,
    FocusRingDefinition? focusRing,
    ZIndexDefinition? zIndex,
    ComponentTokensDefinition? component,
    ThemeDefinition? light,
    ThemeDefinition? dark,
  }) =>
      ThemeDefinition(
        mode: mode ?? this.mode,
        color: color ?? this.color,
        typography: typography ?? this.typography,
        spacing: spacing ?? this.spacing,
        shape: shape ?? this.shape,
        elevation: elevation ?? this.elevation,
        motion: motion ?? this.motion,
        density: density ?? this.density,
        breakpoints: breakpoints ?? this.breakpoints,
        border: border ?? this.border,
        opacity: opacity ?? this.opacity,
        focusRing: focusRing ?? this.focusRing,
        zIndex: zIndex ?? this.zIndex,
        component: component ?? this.component,
        light: light ?? this.light,
        dark: dark ?? this.dark,
      );

  /// Deep-merges non-null values from another [ThemeDefinition] over this one.
  ThemeDefinition merge(ThemeDefinition other) {
    return copyWith(
      mode: other.mode,
      color: other.color ?? color,
      typography: other.typography ?? typography,
      spacing: other.spacing ?? spacing,
      shape: other.shape ?? shape,
      elevation: other.elevation ?? elevation,
      motion: other.motion ?? motion,
      density: other.density ?? density,
      breakpoints: other.breakpoints ?? breakpoints,
      border: other.border ?? border,
      opacity: other.opacity ?? opacity,
      focusRing: other.focusRing ?? focusRing,
      zIndex: other.zIndex ?? zIndex,
      component: other.component ?? component,
      light: other.light ?? light,
      dark: other.dark ?? dark,
    );
  }

  /// M3 default light theme — derived from a seed color.
  static ThemeDefinition defaultLight({String seedHex = '#3F51B5'}) {
    return ThemeDefinition(
      mode: 'light',
      color: SeedPalette.lightFromSeed(seedHex),
      typography: _defaultTypography(),
      spacing: _defaultSpacing(),
      shape: _defaultShape(),
      elevation: _defaultElevation(),
    );
  }

  /// M3 default dark theme — derived from a seed color.
  static ThemeDefinition defaultDark({String seedHex = '#3F51B5'}) {
    return ThemeDefinition(
      mode: 'dark',
      color: SeedPalette.darkFromSeed(seedHex),
      typography: _defaultTypography(),
      spacing: _defaultSpacing(),
      shape: _defaultShape(),
      elevation: _defaultElevation(),
    );
  }

  static TypographyDefinition _defaultTypography() {
    const r = 'regular';
    const m = 'medium';
    return const TypographyDefinition(
      displayLarge: TextStyleDefinition(
          fontSize: 57, fontWeight: r, lineHeight: 64, letterSpacing: -0.25),
      displayMedium: TextStyleDefinition(
          fontSize: 45, fontWeight: r, lineHeight: 52, letterSpacing: 0),
      displaySmall: TextStyleDefinition(
          fontSize: 36, fontWeight: r, lineHeight: 44, letterSpacing: 0),
      headlineLarge: TextStyleDefinition(
          fontSize: 32, fontWeight: r, lineHeight: 40, letterSpacing: 0),
      headlineMedium: TextStyleDefinition(
          fontSize: 28, fontWeight: r, lineHeight: 36, letterSpacing: 0),
      headlineSmall: TextStyleDefinition(
          fontSize: 24, fontWeight: r, lineHeight: 32, letterSpacing: 0),
      titleLarge: TextStyleDefinition(
          fontSize: 22, fontWeight: m, lineHeight: 28, letterSpacing: 0),
      titleMedium: TextStyleDefinition(
          fontSize: 16, fontWeight: m, lineHeight: 24, letterSpacing: 0.15),
      titleSmall: TextStyleDefinition(
          fontSize: 14, fontWeight: m, lineHeight: 20, letterSpacing: 0.1),
      bodyLarge: TextStyleDefinition(
          fontSize: 16, fontWeight: r, lineHeight: 24, letterSpacing: 0.5),
      bodyMedium: TextStyleDefinition(
          fontSize: 14, fontWeight: r, lineHeight: 20, letterSpacing: 0.25),
      bodySmall: TextStyleDefinition(
          fontSize: 12, fontWeight: r, lineHeight: 16, letterSpacing: 0.4),
      labelLarge: TextStyleDefinition(
          fontSize: 14, fontWeight: m, lineHeight: 20, letterSpacing: 0.1),
      labelMedium: TextStyleDefinition(
          fontSize: 12, fontWeight: m, lineHeight: 16, letterSpacing: 0.5),
      labelSmall: TextStyleDefinition(
          fontSize: 11, fontWeight: m, lineHeight: 16, letterSpacing: 0.5),
    );
  }

  static SpacingDefinition _defaultSpacing() => const SpacingDefinition(
        xxs: 2,
        xs: 4,
        sm: 8,
        md: 16,
        lg: 24,
        xl: 32,
        xxl: 48,
        xxxl: 64,
        xxxxl: 96,
        screenPadding: 16,
        cardPadding: 16,
        sectionGap: 24,
        inlineGap: 8,
      );

  static ShapeDefinition _defaultShape() => const ShapeDefinition(
        none: ShapeCorner.uniform(0),
        extraSmall: ShapeCorner.uniform(4),
        small: ShapeCorner.uniform(8),
        medium: ShapeCorner.uniform(12),
        large: ShapeCorner.uniform(16),
        extraLarge: ShapeCorner.uniform(28),
        full: ShapeCorner.uniform(9999),
      );

  static ElevationDefinition _defaultElevation() => const ElevationDefinition(
        level0: ElevationLevel(shadow: 0),
        level1: ElevationLevel(shadow: 1),
        level2: ElevationLevel(shadow: 3),
        level3: ElevationLevel(shadow: 6),
        level4: ElevationLevel(shadow: 8),
        level5: ElevationLevel(shadow: 12),
      );
}
