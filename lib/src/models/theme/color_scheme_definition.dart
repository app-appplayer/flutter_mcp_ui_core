import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Color scheme.
///
/// Material 3 28 role + 6 semantic role + optional [seed] (HCT) + state layer.
/// Surface family follows the post-2024 M3 expressive tonal scale (5-step
/// surface containers + bright/dim) — `background` / `surfaceVariant` are
/// no longer dedicated slots (aligned with Flutter 3.22+ ColorScheme).
/// See `specs/mcp_ui_dsl/05_Theme.md` § 5.3 for details.
@immutable
class ColorSchemeDefinition {
  // M3 — Primary family
  final String? primary;
  final String? onPrimary;
  final String? primaryContainer;
  final String? onPrimaryContainer;

  // M3 — Secondary family
  final String? secondary;
  final String? onSecondary;
  final String? secondaryContainer;
  final String? onSecondaryContainer;

  // M3 — Tertiary family
  final String? tertiary;
  final String? onTertiary;
  final String? tertiaryContainer;
  final String? onTertiaryContainer;

  // M3 — Error family
  final String? error;
  final String? onError;
  final String? errorContainer;
  final String? onErrorContainer;

  // M3 — Surface family (expressive tonal scale)
  final String? surface;
  final String? onSurface;
  final String? onSurfaceVariant;
  final String? surfaceTint;
  final String? surfaceBright;
  final String? surfaceDim;
  final String? surfaceContainerLowest;
  final String? surfaceContainerLow;
  final String? surfaceContainer;
  final String? surfaceContainerHigh;
  final String? surfaceContainerHighest;

  // M3 — Outline family
  final String? outline;
  final String? outlineVariant;

  // M3 — Inverse family
  final String? inverseSurface;
  final String? onInverseSurface;
  final String? inversePrimary;

  // M3 — Misc
  final String? scrim;
  final String? shadow;

  // Semantic (additions beyond M3).
  final String? success;
  final String? onSuccess;
  final String? warning;
  final String? onWarning;
  final String? info;
  final String? onInfo;

  /// HCT seed — when present, the runtime auto-derives the full 28 role + dark variants.
  final String? seed;

  /// State layer opacity overrides (default: hover 0.08, focus 0.12, pressed 0.16, disabled 0.38).
  final StateLayerOpacity? stateLayer;

  const ColorSchemeDefinition({
    this.primary,
    this.onPrimary,
    this.primaryContainer,
    this.onPrimaryContainer,
    this.secondary,
    this.onSecondary,
    this.secondaryContainer,
    this.onSecondaryContainer,
    this.tertiary,
    this.onTertiary,
    this.tertiaryContainer,
    this.onTertiaryContainer,
    this.error,
    this.onError,
    this.errorContainer,
    this.onErrorContainer,
    this.surface,
    this.onSurface,
    this.onSurfaceVariant,
    this.surfaceTint,
    this.surfaceBright,
    this.surfaceDim,
    this.surfaceContainerLowest,
    this.surfaceContainerLow,
    this.surfaceContainer,
    this.surfaceContainerHigh,
    this.surfaceContainerHighest,
    this.outline,
    this.outlineVariant,
    this.inverseSurface,
    this.onInverseSurface,
    this.inversePrimary,
    this.scrim,
    this.shadow,
    this.success,
    this.onSuccess,
    this.warning,
    this.onWarning,
    this.info,
    this.onInfo,
    this.seed,
    this.stateLayer,
  });

  factory ColorSchemeDefinition.fromJson(Map<String, dynamic> json) {
    return ColorSchemeDefinition(
      primary: json['primary'] as String?,
      onPrimary: json['onPrimary'] as String?,
      primaryContainer: json['primaryContainer'] as String?,
      onPrimaryContainer: json['onPrimaryContainer'] as String?,
      secondary: json['secondary'] as String?,
      onSecondary: json['onSecondary'] as String?,
      secondaryContainer: json['secondaryContainer'] as String?,
      onSecondaryContainer: json['onSecondaryContainer'] as String?,
      tertiary: json['tertiary'] as String?,
      onTertiary: json['onTertiary'] as String?,
      tertiaryContainer: json['tertiaryContainer'] as String?,
      onTertiaryContainer: json['onTertiaryContainer'] as String?,
      error: json['error'] as String?,
      onError: json['onError'] as String?,
      errorContainer: json['errorContainer'] as String?,
      onErrorContainer: json['onErrorContainer'] as String?,
      surface: json['surface'] as String?,
      onSurface: json['onSurface'] as String?,
      onSurfaceVariant: json['onSurfaceVariant'] as String?,
      surfaceTint: json['surfaceTint'] as String?,
      surfaceBright: json['surfaceBright'] as String?,
      surfaceDim: json['surfaceDim'] as String?,
      surfaceContainerLowest: json['surfaceContainerLowest'] as String?,
      surfaceContainerLow: json['surfaceContainerLow'] as String?,
      surfaceContainer: json['surfaceContainer'] as String?,
      surfaceContainerHigh: json['surfaceContainerHigh'] as String?,
      surfaceContainerHighest: json['surfaceContainerHighest'] as String?,
      outline: json['outline'] as String?,
      outlineVariant: json['outlineVariant'] as String?,
      inverseSurface: json['inverseSurface'] as String?,
      onInverseSurface: json['onInverseSurface'] as String?,
      inversePrimary: json['inversePrimary'] as String?,
      scrim: json['scrim'] as String?,
      shadow: json['shadow'] as String?,
      success: json['success'] as String?,
      onSuccess: json['onSuccess'] as String?,
      warning: json['warning'] as String?,
      onWarning: json['onWarning'] as String?,
      info: json['info'] as String?,
      onInfo: json['onInfo'] as String?,
      seed: json['seed'] as String?,
      stateLayer: json['stateLayer'] is Map<String, dynamic>
          ? StateLayerOpacity.fromJson(
              json['stateLayer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, Object? v) {
      if (v != null) m[k] = v;
    }

    put('primary', primary);
    put('onPrimary', onPrimary);
    put('primaryContainer', primaryContainer);
    put('onPrimaryContainer', onPrimaryContainer);
    put('secondary', secondary);
    put('onSecondary', onSecondary);
    put('secondaryContainer', secondaryContainer);
    put('onSecondaryContainer', onSecondaryContainer);
    put('tertiary', tertiary);
    put('onTertiary', onTertiary);
    put('tertiaryContainer', tertiaryContainer);
    put('onTertiaryContainer', onTertiaryContainer);
    put('error', error);
    put('onError', onError);
    put('errorContainer', errorContainer);
    put('onErrorContainer', onErrorContainer);
    put('surface', surface);
    put('onSurface', onSurface);
    put('onSurfaceVariant', onSurfaceVariant);
    put('surfaceTint', surfaceTint);
    put('surfaceBright', surfaceBright);
    put('surfaceDim', surfaceDim);
    put('surfaceContainerLowest', surfaceContainerLowest);
    put('surfaceContainerLow', surfaceContainerLow);
    put('surfaceContainer', surfaceContainer);
    put('surfaceContainerHigh', surfaceContainerHigh);
    put('surfaceContainerHighest', surfaceContainerHighest);
    put('outline', outline);
    put('outlineVariant', outlineVariant);
    put('inverseSurface', inverseSurface);
    put('onInverseSurface', onInverseSurface);
    put('inversePrimary', inversePrimary);
    put('scrim', scrim);
    put('shadow', shadow);
    put('success', success);
    put('onSuccess', onSuccess);
    put('warning', warning);
    put('onWarning', onWarning);
    put('info', info);
    put('onInfo', onInfo);
    put('seed', seed);
    if (stateLayer != null) m['stateLayer'] = stateLayer!.toJson();
    return m;
  }

  ColorSchemeDefinition copyWith({
    String? primary,
    String? onPrimary,
    String? primaryContainer,
    String? onPrimaryContainer,
    String? secondary,
    String? onSecondary,
    String? secondaryContainer,
    String? onSecondaryContainer,
    String? tertiary,
    String? onTertiary,
    String? tertiaryContainer,
    String? onTertiaryContainer,
    String? error,
    String? onError,
    String? errorContainer,
    String? onErrorContainer,
    String? surface,
    String? onSurface,
    String? onSurfaceVariant,
    String? surfaceTint,
    String? surfaceBright,
    String? surfaceDim,
    String? surfaceContainerLowest,
    String? surfaceContainerLow,
    String? surfaceContainer,
    String? surfaceContainerHigh,
    String? surfaceContainerHighest,
    String? outline,
    String? outlineVariant,
    String? inverseSurface,
    String? onInverseSurface,
    String? inversePrimary,
    String? scrim,
    String? shadow,
    String? success,
    String? onSuccess,
    String? warning,
    String? onWarning,
    String? info,
    String? onInfo,
    String? seed,
    StateLayerOpacity? stateLayer,
  }) {
    return ColorSchemeDefinition(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer:
          onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      scrim: scrim ?? this.scrim,
      shadow: shadow ?? this.shadow,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      seed: seed ?? this.seed,
      stateLayer: stateLayer ?? this.stateLayer,
    );
  }
}

/// State layer opacity (M3 standard).
@immutable
class StateLayerOpacity {
  final double hover;
  final double focus;
  final double pressed;
  final double disabledForeground;
  final double disabledBackground;

  const StateLayerOpacity({
    this.hover = 0.08,
    this.focus = 0.12,
    this.pressed = 0.16,
    this.disabledForeground = 0.38,
    this.disabledBackground = 0.12,
  });

  static const StateLayerOpacity defaults = StateLayerOpacity();

  factory StateLayerOpacity.fromJson(Map<String, dynamic> json) =>
      StateLayerOpacity(
        hover: (json['hover'] as num?)?.toDouble() ?? 0.08,
        focus: (json['focus'] as num?)?.toDouble() ?? 0.12,
        pressed: (json['pressed'] as num?)?.toDouble() ?? 0.16,
        disabledForeground:
            (json['disabledForeground'] as num? ?? json['disabled'] as num?)
                    ?.toDouble() ??
                0.38,
        disabledBackground:
            (json['disabledBackground'] as num?)?.toDouble() ?? 0.12,
      );

  Map<String, dynamic> toJson() => {
        'hover': hover,
        'focus': focus,
        'pressed': pressed,
        'disabledForeground': disabledForeground,
        'disabledBackground': disabledBackground,
      };
}
