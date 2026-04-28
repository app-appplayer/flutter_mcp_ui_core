/// DTCG (W3C Design Tokens Community Group draft) codec.
///
/// Implements the mapping spec in `specs/mcp_ui_dsl/05b_DTCG_Interchange.md`.
/// Surfaces `$type` / `$value` / `$description`. Reference (`{path}`) resolution
/// is planned for a future extension (currently raw values only).
library;

import '../color_scheme_definition.dart';
import '../typography_definition.dart';
import '../spacing_definition.dart';
import '../shape_definition.dart';
import '../elevation_definition.dart';
import '../motion_definition.dart';
import '../density_definition.dart';
import '../breakpoints_definition.dart';
import '../border_definition.dart';
import '../opacity_definition.dart';
import '../focus_ring_definition.dart';
import '../z_index_definition.dart';
import '../component_tokens_definition.dart';

class DtcgToken {
  final String type;
  final dynamic value;
  final String? description;

  const DtcgToken({required this.type, required this.value, this.description});

  Map<String, dynamic> toJson() => {
        r'$type': type,
        r'$value': value,
        if (description != null) r'$description': description,
      };
}

/// `"16px"` → `16`, `"0.5px"` → `0.5`, raw `16` → `16`.
num? parseDtcgDimension(dynamic v) {
  if (v is num) return v;
  if (v is String) {
    final trimmed = v.trim();
    final stripped = trimmed.endsWith('px')
        ? trimmed.substring(0, trimmed.length - 2)
        : trimmed;
    return num.tryParse(stripped);
  }
  return null;
}

/// `"150ms"` → `150`, raw `150` → `150`.
num? parseDtcgDuration(dynamic v) {
  if (v is num) return v;
  if (v is String) {
    final trimmed = v.trim();
    final stripped = trimmed.endsWith('ms')
        ? trimmed.substring(0, trimmed.length - 2)
        : trimmed;
    return num.tryParse(stripped);
  }
  return null;
}

/// Cubic bezier `[x1,y1,x2,y2]` → CSS `cubic-bezier(...)` string.
String? parseDtcgCubicBezier(dynamic v) {
  if (v is List && v.length == 4) {
    return 'cubic-bezier(${v.map((e) => e.toString()).join(', ')})';
  }
  if (v is String) return v;
  return null;
}

class DtcgCodec {
  DtcgCodec._();

  // ===== Color =====

  static Map<String, dynamic> encodeColor(ColorSchemeDefinition c) {
    final m = <String, dynamic>{};
    void put(String k, String? v) {
      if (v != null) m[k] = {r'$type': 'color', r'$value': v};
    }

    put('primary', c.primary);
    put('onPrimary', c.onPrimary);
    put('primaryContainer', c.primaryContainer);
    put('onPrimaryContainer', c.onPrimaryContainer);
    put('secondary', c.secondary);
    put('onSecondary', c.onSecondary);
    put('secondaryContainer', c.secondaryContainer);
    put('onSecondaryContainer', c.onSecondaryContainer);
    put('tertiary', c.tertiary);
    put('onTertiary', c.onTertiary);
    put('tertiaryContainer', c.tertiaryContainer);
    put('onTertiaryContainer', c.onTertiaryContainer);
    put('error', c.error);
    put('onError', c.onError);
    put('errorContainer', c.errorContainer);
    put('onErrorContainer', c.onErrorContainer);
    put('surface', c.surface);
    put('onSurface', c.onSurface);
    put('onSurfaceVariant', c.onSurfaceVariant);
    put('surfaceTint', c.surfaceTint);
    put('surfaceBright', c.surfaceBright);
    put('surfaceDim', c.surfaceDim);
    put('surfaceContainerLowest', c.surfaceContainerLowest);
    put('surfaceContainerLow', c.surfaceContainerLow);
    put('surfaceContainer', c.surfaceContainer);
    put('surfaceContainerHigh', c.surfaceContainerHigh);
    put('surfaceContainerHighest', c.surfaceContainerHighest);
    put('outline', c.outline);
    put('outlineVariant', c.outlineVariant);
    put('inverseSurface', c.inverseSurface);
    put('onInverseSurface', c.onInverseSurface);
    put('inversePrimary', c.inversePrimary);
    put('scrim', c.scrim);
    put('shadow', c.shadow);
    put('success', c.success);
    put('onSuccess', c.onSuccess);
    put('warning', c.warning);
    put('onWarning', c.onWarning);
    put('info', c.info);
    put('onInfo', c.onInfo);
    if (c.seed != null) m['seed'] = {r'$type': 'color', r'$value': c.seed};
    if (c.stateLayer != null) {
      m['stateLayer'] = {
        'hover': {r'$type': 'number', r'$value': c.stateLayer!.hover},
        'focus': {r'$type': 'number', r'$value': c.stateLayer!.focus},
        'pressed': {r'$type': 'number', r'$value': c.stateLayer!.pressed},
        'disabled': {
          r'$type': 'number',
          r'$value': c.stateLayer!.disabledForeground,
        },
      };
    }
    return m;
  }

  static ColorSchemeDefinition decodeColor(Map<String, dynamic> json) {
    String? read(String key) {
      final v = json[key];
      if (v is Map<String, dynamic> && v[r'$value'] is String) {
        return v[r'$value'] as String;
      }
      if (v is String) return v;
      return null;
    }

    StateLayerOpacity? readState() {
      final v = json['stateLayer'];
      if (v is! Map<String, dynamic>) return null;
      double get(String k, double d) {
        final entry = v[k];
        if (entry is num) return entry.toDouble();
        if (entry is Map<String, dynamic> && entry[r'$value'] is num) {
          return (entry[r'$value'] as num).toDouble();
        }
        return d;
      }

      return StateLayerOpacity(
        hover: get('hover', 0.08),
        focus: get('focus', 0.12),
        pressed: get('pressed', 0.16),
        disabledForeground: get('disabled', 0.38),
      );
    }

    return ColorSchemeDefinition(
      primary: read('primary'),
      onPrimary: read('onPrimary'),
      primaryContainer: read('primaryContainer'),
      onPrimaryContainer: read('onPrimaryContainer'),
      secondary: read('secondary'),
      onSecondary: read('onSecondary'),
      secondaryContainer: read('secondaryContainer'),
      onSecondaryContainer: read('onSecondaryContainer'),
      tertiary: read('tertiary'),
      onTertiary: read('onTertiary'),
      tertiaryContainer: read('tertiaryContainer'),
      onTertiaryContainer: read('onTertiaryContainer'),
      error: read('error'),
      onError: read('onError'),
      errorContainer: read('errorContainer'),
      onErrorContainer: read('onErrorContainer'),
      surface: read('surface'),
      onSurface: read('onSurface'),
      onSurfaceVariant: read('onSurfaceVariant'),
      surfaceTint: read('surfaceTint'),
      surfaceBright: read('surfaceBright'),
      surfaceDim: read('surfaceDim'),
      surfaceContainerLowest: read('surfaceContainerLowest'),
      surfaceContainerLow: read('surfaceContainerLow'),
      surfaceContainer: read('surfaceContainer'),
      surfaceContainerHigh: read('surfaceContainerHigh'),
      surfaceContainerHighest: read('surfaceContainerHighest'),
      outline: read('outline'),
      outlineVariant: read('outlineVariant'),
      inverseSurface: read('inverseSurface'),
      onInverseSurface: read('onInverseSurface'),
      inversePrimary: read('inversePrimary'),
      scrim: read('scrim'),
      shadow: read('shadow'),
      success: read('success'),
      onSuccess: read('onSuccess'),
      warning: read('warning'),
      onWarning: read('onWarning'),
      info: read('info'),
      onInfo: read('onInfo'),
      seed: read('seed'),
      stateLayer: readState(),
    );
  }

  // ===== Spacing =====

  static Map<String, dynamic> encodeSpacing(SpacingDefinition s) {
    final m = <String, dynamic>{};
    void put(String k, num? v) {
      if (v != null) m[k] = {r'$type': 'dimension', r'$value': '${v}px'};
    }

    put('xxs', s.xxs);
    put('xs', s.xs);
    put('sm', s.sm);
    put('md', s.md);
    put('lg', s.lg);
    put('xl', s.xl);
    put('2xl', s.xxl);
    put('3xl', s.xxxl);
    put('4xl', s.xxxxl);
    put('screenPadding', s.screenPadding);
    put('cardPadding', s.cardPadding);
    put('sectionGap', s.sectionGap);
    put('inlineGap', s.inlineGap);
    if (s.extras != null) {
      for (final e in s.extras!.entries) {
        m[e.key] = {r'$type': 'dimension', r'$value': '${e.value}px'};
      }
    }
    return m;
  }

  static SpacingDefinition decodeSpacing(Map<String, dynamic> json) {
    num? read(String k) {
      final v = json[k];
      if (v is num) return v;
      if (v is Map<String, dynamic>) return parseDtcgDimension(v[r'$value']);
      return null;
    }

    final extras = <String, num>{};
    const known = {
      'xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl', '4xl',
      'screenPadding', 'cardPadding', 'sectionGap', 'inlineGap',
    };
    for (final e in json.entries) {
      if (!known.contains(e.key)) {
        final v = read(e.key);
        if (v != null) extras[e.key] = v;
      }
    }
    return SpacingDefinition(
      xxs: read('xxs'),
      xs: read('xs'),
      sm: read('sm'),
      md: read('md'),
      lg: read('lg'),
      xl: read('xl'),
      xxl: read('2xl'),
      xxxl: read('3xl'),
      xxxxl: read('4xl'),
      screenPadding: read('screenPadding'),
      cardPadding: read('cardPadding'),
      sectionGap: read('sectionGap'),
      inlineGap: read('inlineGap'),
      extras: extras.isEmpty ? null : extras,
    );
  }

  // ===== Typography =====

  static Map<String, dynamic> encodeTypography(TypographyDefinition t) {
    final m = <String, dynamic>{};
    for (final role in TypographyDefinition.roles) {
      final s = t.styleFor(role);
      if (s == null) continue;
      m[role] = {
        r'$type': 'typography',
        r'$value': {
          if (s.fontFamily != null) 'fontFamily': s.fontFamily,
          if (s.fontSize != null) 'fontSize': '${s.fontSize}px',
          if (s.fontWeight != null) 'fontWeight': s.fontWeight,
          if (s.lineHeight != null) 'lineHeight': '${s.lineHeight}px',
          if (s.letterSpacing != null)
            'letterSpacing': '${s.letterSpacing}px',
        },
      };
    }
    return m;
  }

  static TypographyDefinition decodeTypography(Map<String, dynamic> json) {
    TextStyleDefinition? readRole(String k) {
      final v = json[k];
      Map<String, dynamic>? obj;
      if (v is Map<String, dynamic> && v[r'$value'] is Map<String, dynamic>) {
        obj = v[r'$value'] as Map<String, dynamic>;
      } else if (v is Map<String, dynamic>) {
        obj = v;
      }
      if (obj == null) return null;
      return TextStyleDefinition(
        fontFamily: obj['fontFamily'],
        fontSize: parseDtcgDimension(obj['fontSize']),
        fontWeight: obj['fontWeight'],
        lineHeight: parseDtcgDimension(obj['lineHeight']),
        letterSpacing: parseDtcgDimension(obj['letterSpacing']),
        fontFeatureSettings: obj['fontFeatureSettings'] is List
            ? List<String>.from(obj['fontFeatureSettings'] as List)
            : null,
      );
    }

    var t = const TypographyDefinition();
    for (final role in TypographyDefinition.roles) {
      final s = readRole(role);
      if (s != null) t = t.setStyle(role, s);
    }
    return t;
  }

  // ===== Shape =====

  static Map<String, dynamic> encodeShape(ShapeDefinition s) {
    final m = <String, dynamic>{};
    void put(String k, ShapeCorner? v) {
      if (v == null) return;
      if (v.isUniform) {
        m[k] = {r'$type': 'dimension', r'$value': '${v.uniform}px'};
      } else {
        m[k] = {
          r'$type': 'dimension',
          r'$value': v.toAny(),
        };
      }
    }

    put('none', s.none);
    put('extraSmall', s.extraSmall);
    put('small', s.small);
    put('medium', s.medium);
    put('large', s.large);
    put('extraLarge', s.extraLarge);
    put('full', s.full);
    if (s.extras != null) {
      for (final e in s.extras!.entries) {
        put(e.key, e.value);
      }
    }
    return m;
  }

  static ShapeDefinition decodeShape(Map<String, dynamic> json) {
    ShapeCorner? read(String k) {
      final v = json[k];
      if (v is num) return ShapeCorner.uniform(v);
      if (v is Map<String, dynamic>) {
        // DTCG wrapper or direct per-corner
        final inner = v[r'$value'] ?? v;
        if (inner is num) return ShapeCorner.uniform(inner);
        if (inner is String) {
          final n = parseDtcgDimension(inner);
          if (n != null) return ShapeCorner.uniform(n);
        }
        if (inner is Map<String, dynamic>) {
          return ShapeCorner.perCorner(
            topStart: parseDtcgDimension(inner['topStart']),
            topEnd: parseDtcgDimension(inner['topEnd']),
            bottomStart: parseDtcgDimension(inner['bottomStart']),
            bottomEnd: parseDtcgDimension(inner['bottomEnd']),
          );
        }
      }
      return null;
    }

    final extras = <String, ShapeCorner>{};
    const known = {
      'none', 'extraSmall', 'small', 'medium', 'large', 'extraLarge', 'full',
    };
    for (final e in json.entries) {
      if (!known.contains(e.key)) {
        final c = read(e.key);
        if (c != null) extras[e.key] = c;
      }
    }
    return ShapeDefinition(
      none: read('none'),
      extraSmall: read('extraSmall'),
      small: read('small'),
      medium: read('medium'),
      large: read('large'),
      extraLarge: read('extraLarge'),
      full: read('full'),
      extras: extras.isEmpty ? null : extras,
    );
  }

  // ===== Elevation =====

  static Map<String, dynamic> encodeElevation(ElevationDefinition e) {
    final m = <String, dynamic>{};
    void put(String k, ElevationLevel? v) {
      if (v == null) return;
      if (v.isShorthand) {
        m[k] = {r'$type': 'dimension', r'$value': '${v.shadow}px'};
      } else {
        m[k] = {
          r'$type': 'dimension',
          r'$value': v.toAny(),
        };
      }
    }

    put('level0', e.level0);
    put('level1', e.level1);
    put('level2', e.level2);
    put('level3', e.level3);
    put('level4', e.level4);
    put('level5', e.level5);
    return m;
  }

  static ElevationDefinition decodeElevation(Map<String, dynamic> json) {
    ElevationLevel? read(String k) {
      final v = json[k];
      if (v is num) return ElevationLevel(shadow: v);
      if (v is Map<String, dynamic>) {
        final inner = v[r'$value'] ?? v;
        if (inner is num) return ElevationLevel(shadow: inner);
        if (inner is String) {
          final n = parseDtcgDimension(inner);
          if (n != null) return ElevationLevel(shadow: n);
        }
        if (inner is Map<String, dynamic>) {
          final tintRaw = inner['tint'];
          String? tint;
          if (tintRaw is String) {
            tint = tintRaw;
          } else if (tintRaw is Map<String, dynamic> &&
              tintRaw[r'$value'] is String) {
            tint = tintRaw[r'$value'] as String;
          }
          return ElevationLevel(
            shadow: parseDtcgDimension(inner['shadow']),
            tint: tint,
          );
        }
      }
      return null;
    }

    return ElevationDefinition(
      level0: read('level0'),
      level1: read('level1'),
      level2: read('level2'),
      level3: read('level3'),
      level4: read('level4'),
      level5: read('level5'),
    );
  }

  // ===== Motion =====

  static Map<String, dynamic> encodeMotion(MotionDefinition m) {
    final out = <String, dynamic>{};
    if (m.duration != null) {
      final d = <String, dynamic>{};
      m.duration!.toJson().forEach((k, v) {
        d[k] = {r'$type': 'duration', r'$value': '${v}ms'};
      });
      out['duration'] = d;
    }
    if (m.easing != null) {
      final e = <String, dynamic>{};
      m.easing!.toJson().forEach((k, v) {
        e[k] = {r'$type': 'cubicBezier', r'$value': v};
      });
      out['easing'] = e;
    }
    return out;
  }

  static MotionDefinition decodeMotion(Map<String, dynamic> json) {
    MotionDurationDefinition? duration;
    MotionEasingDefinition? easing;

    if (json['duration'] is Map<String, dynamic>) {
      final raw = json['duration'] as Map<String, dynamic>;
      final m = <String, num>{};
      for (final e in raw.entries) {
        final v = e.value;
        if (v is num) {
          m[e.key] = v;
        } else if (v is Map<String, dynamic>) {
          final n = parseDtcgDuration(v[r'$value']);
          if (n != null) m[e.key] = n;
        }
      }
      duration = MotionDurationDefinition.fromJson(m);
    }
    if (json['easing'] is Map<String, dynamic>) {
      final raw = json['easing'] as Map<String, dynamic>;
      final m = <String, dynamic>{};
      for (final e in raw.entries) {
        final v = e.value;
        if (v is String) {
          m[e.key] = v;
        } else if (v is Map<String, dynamic>) {
          m[e.key] = parseDtcgCubicBezier(v[r'$value']);
        }
      }
      easing = MotionEasingDefinition.fromJson(m);
    }
    return MotionDefinition(duration: duration, easing: easing);
  }

  // ===== Density / Breakpoints / Border / Opacity / FocusRing / Z-index / Component
  // — DTCG serialization just adds the wrapper. Simple enough to handle generically:

  static Map<String, dynamic> encodeBreakpoints(BreakpointsDefinition b) {
    return b.toJson().map((k, v) =>
        MapEntry(k, {r'$type': 'dimension', r'$value': '${v}px'}));
  }

  static BreakpointsDefinition decodeBreakpoints(Map<String, dynamic> json) {
    final m = <String, num>{};
    for (final e in json.entries) {
      if (e.value is num) {
        m[e.key] = e.value as num;
      } else if (e.value is Map<String, dynamic>) {
        final n = parseDtcgDimension((e.value as Map)[r'$value']);
        if (n != null) m[e.key] = n;
      }
    }
    return BreakpointsDefinition.fromJson(m);
  }

  static Map<String, dynamic> encodeOpacity(OpacityDefinition o) {
    return o.values.map((k, v) =>
        MapEntry(k, {r'$type': 'number', r'$value': v}));
  }

  static OpacityDefinition decodeOpacity(Map<String, dynamic> json) {
    final m = <String, num>{};
    for (final e in json.entries) {
      if (e.value is num) {
        m[e.key] = e.value as num;
      } else if (e.value is Map<String, dynamic>) {
        final v = (e.value as Map)[r'$value'];
        if (v is num) m[e.key] = v;
      }
    }
    return OpacityDefinition(m);
  }

  static Map<String, dynamic> encodeZIndex(ZIndexDefinition z) {
    return z.toJson().map((k, v) =>
        MapEntry(k, {r'$type': 'number', r'$value': v}));
  }

  static ZIndexDefinition decodeZIndex(Map<String, dynamic> json) {
    final m = <String, dynamic>{};
    for (final e in json.entries) {
      if (e.value is num) {
        m[e.key] = e.value;
      } else if (e.value is Map<String, dynamic>) {
        final v = (e.value as Map)[r'$value'];
        if (v is num) m[e.key] = v;
      }
    }
    return ZIndexDefinition.fromJson(m);
  }

  // Border / FocusRing / Density / Component pass through without a wrapper
  // (outside the 13 standard DTCG draft types — implementation-specific).

  static Map<String, dynamic> encodeBorder(BorderDefinition b) {
    final out = <String, dynamic>{};
    if (b.width != null) {
      final w = <String, dynamic>{};
      b.width!.toJson().forEach((k, v) {
        w[k] = {r'$type': 'dimension', r'$value': '${v}px'};
      });
      out['width'] = w;
    }
    if (b.style != null) {
      out['style'] = {r'$type': 'string', r'$value': b.style};
    }
    return out;
  }

  static BorderDefinition decodeBorder(Map<String, dynamic> json) {
    BorderWidthDefinition? width;
    if (json['width'] is Map<String, dynamic>) {
      final raw = json['width'] as Map<String, dynamic>;
      final m = <String, num>{};
      for (final e in raw.entries) {
        if (e.value is num) {
          m[e.key] = e.value as num;
        } else if (e.value is Map<String, dynamic>) {
          final n = parseDtcgDimension((e.value as Map)[r'$value']);
          if (n != null) m[e.key] = n;
        }
      }
      width = BorderWidthDefinition.fromJson(m);
    }
    String? style;
    final styleVal = json['style'];
    if (styleVal is String) {
      style = styleVal;
    } else if (styleVal is Map<String, dynamic>) {
      style = styleVal[r'$value'] as String?;
    }
    return BorderDefinition(width: width, style: style);
  }

  static Map<String, dynamic> encodeFocusRing(FocusRingDefinition f) => {
        if (f.color != null)
          'color': {r'$type': 'color', r'$value': f.color},
        if (f.width != null)
          'width': {r'$type': 'dimension', r'$value': '${f.width}px'},
        if (f.offset != null)
          'offset': {r'$type': 'dimension', r'$value': '${f.offset}px'},
        if (f.radius != null)
          'radius': {r'$type': 'dimension', r'$value': '${f.radius}px'},
      };

  static FocusRingDefinition decodeFocusRing(Map<String, dynamic> json) {
    String? readColor(String k) {
      final v = json[k];
      if (v is String) return v;
      if (v is Map<String, dynamic>) return v[r'$value'] as String?;
      return null;
    }

    num? readDim(String k) {
      final v = json[k];
      if (v is num) return v;
      if (v is Map<String, dynamic>) return parseDtcgDimension(v[r'$value']);
      return null;
    }

    return FocusRingDefinition(
      color: readColor('color'),
      width: readDim('width'),
      offset: readDim('offset'),
      radius: readDim('radius'),
    );
  }

  static Map<String, dynamic> encodeDensity(DensityDefinition d) =>
      d.toJson(); // No matching DTCG standard type → pass through.

  static DensityDefinition decodeDensity(Map<String, dynamic> json) =>
      DensityDefinition.fromJson(json);

  static Map<String, dynamic> encodeComponent(ComponentTokensDefinition c) =>
      c.toJson();

  static ComponentTokensDefinition decodeComponent(Map<String, dynamic> json) =>
      ComponentTokensDefinition.fromJson(json);
}
