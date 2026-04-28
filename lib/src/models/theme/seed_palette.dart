import 'package:material_color_utilities/material_color_utilities.dart';

import 'color_scheme_definition.dart';

/// HCT seed → automatically generated tonal palette.
///
/// Uses Material Design 3's dynamic color algorithm (Hue · Chroma · Tone)
/// to derive a 28-role + dark-mode palette from a single seed color.
class SeedPalette {
  SeedPalette._();

  /// Parses a `#RRGGBB` or `#AARRGGBB` hex color into an ARGB int.
  static int? _parseHex(String hex) {
    var s = hex.replaceFirst('#', '').replaceFirst('0x', '').toUpperCase();
    if (s.length == 6) s = 'FF$s';
    if (s.length != 8) return null;
    return int.tryParse(s, radix: 16);
  }

  static String _toHex(int argb) {
    final hex = argb.toRadixString(16).toUpperCase().padLeft(8, '0');
    return '#${hex.substring(2)}'; // drop alpha for readability
  }

  /// Auto-generates a light-mode 28-role color scheme.
  ///
  /// Returns an empty [ColorSchemeDefinition] if [seedHex] is malformed.
  static ColorSchemeDefinition lightFromSeed(String seedHex) {
    final argb = _parseHex(seedHex);
    if (argb == null) return ColorSchemeDefinition(seed: seedHex);
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(argb),
      isDark: false,
      contrastLevel: 0.0,
    );
    return _fromScheme(scheme, seedHex);
  }

  /// Auto-generates a dark-mode 28-role color scheme.
  static ColorSchemeDefinition darkFromSeed(String seedHex) {
    final argb = _parseHex(seedHex);
    if (argb == null) return ColorSchemeDefinition(seed: seedHex);
    final scheme = SchemeTonalSpot(
      sourceColorHct: Hct.fromInt(argb),
      isDark: true,
      contrastLevel: 0.0,
    );
    return _fromScheme(scheme, seedHex);
  }

  static ColorSchemeDefinition _fromScheme(DynamicScheme s, String seedHex) {
    return ColorSchemeDefinition(
      seed: seedHex,
      primary: _toHex(MaterialDynamicColors.primary.getArgb(s)),
      onPrimary: _toHex(MaterialDynamicColors.onPrimary.getArgb(s)),
      primaryContainer:
          _toHex(MaterialDynamicColors.primaryContainer.getArgb(s)),
      onPrimaryContainer:
          _toHex(MaterialDynamicColors.onPrimaryContainer.getArgb(s)),
      secondary: _toHex(MaterialDynamicColors.secondary.getArgb(s)),
      onSecondary: _toHex(MaterialDynamicColors.onSecondary.getArgb(s)),
      secondaryContainer:
          _toHex(MaterialDynamicColors.secondaryContainer.getArgb(s)),
      onSecondaryContainer:
          _toHex(MaterialDynamicColors.onSecondaryContainer.getArgb(s)),
      tertiary: _toHex(MaterialDynamicColors.tertiary.getArgb(s)),
      onTertiary: _toHex(MaterialDynamicColors.onTertiary.getArgb(s)),
      tertiaryContainer:
          _toHex(MaterialDynamicColors.tertiaryContainer.getArgb(s)),
      onTertiaryContainer:
          _toHex(MaterialDynamicColors.onTertiaryContainer.getArgb(s)),
      error: _toHex(MaterialDynamicColors.error.getArgb(s)),
      onError: _toHex(MaterialDynamicColors.onError.getArgb(s)),
      errorContainer: _toHex(MaterialDynamicColors.errorContainer.getArgb(s)),
      onErrorContainer:
          _toHex(MaterialDynamicColors.onErrorContainer.getArgb(s)),
      surface: _toHex(MaterialDynamicColors.surface.getArgb(s)),
      onSurface: _toHex(MaterialDynamicColors.onSurface.getArgb(s)),
      onSurfaceVariant:
          _toHex(MaterialDynamicColors.onSurfaceVariant.getArgb(s)),
      surfaceTint: _toHex(MaterialDynamicColors.surfaceTint.getArgb(s)),
      surfaceBright: _toHex(MaterialDynamicColors.surfaceBright.getArgb(s)),
      surfaceDim: _toHex(MaterialDynamicColors.surfaceDim.getArgb(s)),
      surfaceContainerLowest:
          _toHex(MaterialDynamicColors.surfaceContainerLowest.getArgb(s)),
      surfaceContainerLow:
          _toHex(MaterialDynamicColors.surfaceContainerLow.getArgb(s)),
      surfaceContainer:
          _toHex(MaterialDynamicColors.surfaceContainer.getArgb(s)),
      surfaceContainerHigh:
          _toHex(MaterialDynamicColors.surfaceContainerHigh.getArgb(s)),
      surfaceContainerHighest:
          _toHex(MaterialDynamicColors.surfaceContainerHighest.getArgb(s)),
      outline: _toHex(MaterialDynamicColors.outline.getArgb(s)),
      outlineVariant: _toHex(MaterialDynamicColors.outlineVariant.getArgb(s)),
      inverseSurface: _toHex(MaterialDynamicColors.inverseSurface.getArgb(s)),
      onInverseSurface:
          _toHex(MaterialDynamicColors.inverseOnSurface.getArgb(s)),
      inversePrimary: _toHex(MaterialDynamicColors.inversePrimary.getArgb(s)),
      shadow: _toHex(MaterialDynamicColors.shadow.getArgb(s)),
      scrim: _toHex(MaterialDynamicColors.scrim.getArgb(s)),
    );
  }
}
