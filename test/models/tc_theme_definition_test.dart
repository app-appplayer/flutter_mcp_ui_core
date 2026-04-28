// MCP UI DSL 1.3 — ThemeDefinition tests (M3 14 token domains).
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('ThemeDefinition.fromJson — 14 domains', () {
    test('parse complete theme with multiple sub-definitions', () {
      final json = {
        'mode': 'dark',
        'color': {
          'primary': '#1976D2',
          'onPrimary': '#FFFFFF',
          'surface': '#1E1E1E',
          'onSurface': '#FFFFFF',
          'error': '#CF6679',
          'onError': '#000000',
        },
        'typography': {
          'displayLarge': {'fontSize': 57, 'fontWeight': 'regular'},
          'bodyLarge': {'fontSize': 16, 'fontWeight': 'regular'},
        },
        'spacing': {'xxs': 2, 'xs': 4, 'sm': 8, 'md': 16, 'lg': 24, 'xl': 32},
        'shape': {'small': 8, 'medium': 12, 'large': 16, 'full': 9999},
        'elevation': {
          'level0': {'shadow': 0},
          'level3': {'shadow': 6},
        },
      };

      final def = ThemeDefinition.fromJson(json);
      expect(def.mode, equals('dark'));
      expect(def.color, isNotNull);
      expect(def.color!.primary, equals('#1976D2'));
      expect(def.typography, isNotNull);
      expect(def.typography!.displayLarge?.fontSize, equals(57));
      expect(def.spacing, isNotNull);
      expect(def.spacing!.md, equals(16));
      expect(def.shape, isNotNull);
      expect(def.shape!.medium?.uniform, equals(12));
      expect(def.elevation, isNotNull);
      expect(def.elevation!.level3?.shadow, equals(6));
    });

    test('dual-theme with separate light/dark sections', () {
      final json = {
        'mode': 'system',
        'light': {
          'mode': 'light',
          'color': {'primary': '#2196F3'},
        },
        'dark': {
          'mode': 'dark',
          'color': {'primary': '#1976D2'},
        },
      };

      final def = ThemeDefinition.fromJson(json);
      expect(def.mode, equals('system'));
      expect(def.light, isNotNull);
      expect(def.light!.mode, equals('light'));
      expect(def.light!.color!.primary, equals('#2196F3'));
      expect(def.dark, isNotNull);
      expect(def.dark!.color!.primary, equals('#1976D2'));
    });

    test('arbitrary mode string parsed without exception', () {
      final def = ThemeDefinition.fromJson({'mode': 'invalid_mode'});
      expect(def.mode, equals('invalid_mode'));
    });
  });

  group('ColorSchemeDefinition — M3 28-role + state layer', () {
    test('parses primary/secondary/tertiary/error families', () {
      final json = {
        'primary': '#2196F3',
        'onPrimary': '#FFFFFF',
        'primaryContainer': '#BBDEFB',
        'onPrimaryContainer': '#0D47A1',
        'secondary': '#FF4081',
        'onSecondary': '#FFFFFF',
        'tertiary': '#9C27B0',
        'onTertiary': '#FFFFFF',
        'error': '#F44336',
        'onError': '#FFFFFF',
      };

      final cs = ColorSchemeDefinition.fromJson(json);
      expect(cs.primary, equals('#2196F3'));
      expect(cs.onPrimary, equals('#FFFFFF'));
      expect(cs.primaryContainer, equals('#BBDEFB'));
      expect(cs.onPrimaryContainer, equals('#0D47A1'));
      expect(cs.secondary, equals('#FF4081'));
      expect(cs.tertiary, equals('#9C27B0'));
      expect(cs.error, equals('#F44336'));
    });

    test('parses M3 expressive surface tonal scale', () {
      final json = {
        'surface': '#FFFFFF',
        'onSurface': '#1A1A1A',
        'surfaceContainerLowest': '#FFFFFF',
        'surfaceContainerLow': '#F7F7F7',
        'surfaceContainer': '#F0F0F0',
        'surfaceContainerHigh': '#E8E8E8',
        'surfaceContainerHighest': '#E0E0E0',
        'onSurfaceVariant': '#444444',
        'surfaceBright': '#FAFAFA',
        'surfaceDim': '#D8D8D8',
      };

      final cs = ColorSchemeDefinition.fromJson(json);
      expect(cs.surface, equals('#FFFFFF'));
      expect(cs.surfaceContainerLowest, equals('#FFFFFF'));
      expect(cs.surfaceContainerLow, equals('#F7F7F7'));
      expect(cs.surfaceContainer, equals('#F0F0F0'));
      expect(cs.surfaceContainerHigh, equals('#E8E8E8'));
      expect(cs.surfaceContainerHighest, equals('#E0E0E0'));
      expect(cs.onSurfaceVariant, equals('#444444'));
      expect(cs.surfaceBright, equals('#FAFAFA'));
      expect(cs.surfaceDim, equals('#D8D8D8'));
    });

    test('parses inverse and outline families', () {
      final cs = ColorSchemeDefinition.fromJson({
        'outline': '#9E9E9E',
        'outlineVariant': '#E0E0E0',
        'inverseSurface': '#202020',
        'onInverseSurface': '#F0F0F0',
        'inversePrimary': '#90CAF9',
        'scrim': '#000000',
        'shadow': '#000000',
      });
      expect(cs.outline, equals('#9E9E9E'));
      expect(cs.onInverseSurface, equals('#F0F0F0'));
      expect(cs.inversePrimary, equals('#90CAF9'));
    });

    test('parses 6-semantic family + seed token', () {
      final cs = ColorSchemeDefinition.fromJson({
        'success': '#4CAF50',
        'onSuccess': '#FFFFFF',
        'warning': '#FF9800',
        'onWarning': '#000000',
        'info': '#2196F3',
        'onInfo': '#FFFFFF',
        'seed': '#3F51B5',
      });
      expect(cs.success, equals('#4CAF50'));
      expect(cs.warning, equals('#FF9800'));
      expect(cs.info, equals('#2196F3'));
      expect(cs.seed, equals('#3F51B5'));
    });

    test('state layer opacity defaults follow M3 standard', () {
      final cs = ColorSchemeDefinition.fromJson(<String, dynamic>{
        'stateLayer': <String, dynamic>{},
      });
      expect(cs.stateLayer, isNotNull);
      expect(cs.stateLayer!.hover, equals(0.08));
      expect(cs.stateLayer!.focus, equals(0.12));
      expect(cs.stateLayer!.pressed, equals(0.16));
      expect(cs.stateLayer!.disabledForeground, equals(0.38));
    });

    test('state layer opacity custom overrides parsed', () {
      final cs = ColorSchemeDefinition.fromJson(<String, dynamic>{
        'stateLayer': <String, dynamic>{'hover': 0.10, 'pressed': 0.20},
      });
      expect(cs.stateLayer, isNotNull);
      expect(cs.stateLayer!.hover, equals(0.10));
      expect(cs.stateLayer!.pressed, equals(0.20));
      expect(cs.stateLayer!.focus, equals(0.12));
    });

    test('toJson omits null fields', () {
      final cs = ColorSchemeDefinition(primary: '#2196F3', onPrimary: '#FFFFFF');
      final json = cs.toJson();
      expect(json['primary'], equals('#2196F3'));
      expect(json['onPrimary'], equals('#FFFFFF'));
      expect(json.containsKey('secondary'), isFalse);
      expect(json.containsKey('surface'), isFalse);
    });

    test('6-digit and 8-digit hex color formats', () {
      final cs = ColorSchemeDefinition.fromJson({
        'primary': '#2196F3',
        'secondary': '#FF2196F3',
      });
      expect(cs.primary, equals('#2196F3'));
      expect(cs.secondary, equals('#FF2196F3'));
    });
  });

  group('TypographyDefinition — M3 15-role', () {
    test('all 15 roles round-trip through JSON', () {
      final json = <String, dynamic>{
        for (final role in TypographyDefinition.roles)
          role: {'fontSize': 16, 'fontWeight': 'regular'},
      };

      final typo = TypographyDefinition.fromJson(json);
      for (final role in TypographyDefinition.roles) {
        expect(typo.styleFor(role), isNotNull, reason: role);
      }
    });

    test('TextStyleDefinition all fields', () {
      final style = TextStyleDefinition.fromJson({
        'fontFamily': 'Roboto',
        'fontSize': 16,
        'fontWeight': 'medium',
        'lineHeight': 24,
        'letterSpacing': 0.5,
      });

      expect(style.fontFamily, equals('Roboto'));
      expect(style.fontSize, equals(16));
      expect(style.fontWeight, equals('medium'));
      expect(style.lineHeight, equals(24));
      expect(style.letterSpacing, equals(0.5));
    });

    test('fontWeight accepts string and numeric forms', () {
      final str = TextStyleDefinition.fromJson({'fontWeight': 'medium'});
      final num = TextStyleDefinition.fromJson({'fontWeight': 500});
      expect(str.fontWeight, equals('medium'));
      expect(num.fontWeight, equals(500));
    });

    test('arbitrary fontWeight string parsed without exception', () {
      final style = TextStyleDefinition.fromJson({'fontWeight': 'superHeavy'});
      expect(style.fontWeight, equals('superHeavy'));
    });
  });

  group('SpacingDefinition — 9 primitives', () {
    test('parse 9-step spacing scale via canonical 2xl/3xl/4xl wire keys', () {
      final json = {
        'xxs': 2,
        'xs': 4,
        'sm': 8,
        'md': 16,
        'lg': 24,
        'xl': 32,
        '2xl': 48,
        '3xl': 64,
        '4xl': 96,
      };

      final sp = SpacingDefinition.fromJson(json);
      expect(sp.xxs, equals(2));
      expect(sp.xs, equals(4));
      expect(sp.sm, equals(8));
      expect(sp.md, equals(16));
      expect(sp.lg, equals(24));
      expect(sp.xl, equals(32));
      expect(sp.xxl, equals(48));
      expect(sp.xxxl, equals(64));
      expect(sp.xxxxl, equals(96));
    });

    test('accepts int or double', () {
      final sp = SpacingDefinition.fromJson({'xs': 4.5, 'sm': 8});
      expect(sp.xs, equals(4.5));
      expect(sp.sm, equals(8));
    });

    test('extras (custom slots) preserved', () {
      final sp = SpacingDefinition.fromJson({'gutter': 12, 'columnGap': 24});
      expect(sp.extras?['gutter'], equals(12));
      expect(sp.extras?['columnGap'], equals(24));
    });
  });

  group('ShapeDefinition — M3 7-family + per-corner override', () {
    test('parse 7-family uniform corners', () {
      final shape = ShapeDefinition.fromJson({
        'none': 0,
        'extraSmall': 4,
        'small': 8,
        'medium': 12,
        'large': 16,
        'extraLarge': 28,
        'full': 9999,
      });

      expect(shape.none?.uniform, equals(0));
      expect(shape.extraSmall?.uniform, equals(4));
      expect(shape.small?.uniform, equals(8));
      expect(shape.medium?.uniform, equals(12));
      expect(shape.large?.uniform, equals(16));
      expect(shape.extraLarge?.uniform, equals(28));
      expect(shape.full?.uniform, equals(9999));
    });

    test('parse per-corner override', () {
      final shape = ShapeDefinition.fromJson({
        'large': {'topStart': 16, 'topEnd': 16, 'bottomStart': 0, 'bottomEnd': 0},
      });

      expect(shape.large?.uniform, isNull);
      expect(shape.large?.topStart, equals(16));
      expect(shape.large?.bottomEnd, equals(0));
    });
  });

  group('ElevationDefinition — M3 6-level (shadow + tint)', () {
    test('parse 6 levels with shadow and optional tonal tint', () {
      final json = {
        'level0': {'shadow': 0},
        'level1': {'shadow': 1, 'tint': '#FF6750A4'},
        'level2': {'shadow': 3},
        'level3': {'shadow': 6},
        'level4': {'shadow': 8},
        'level5': {'shadow': 12},
      };

      final elev = ElevationDefinition.fromJson(json);
      expect(elev.level0?.shadow, equals(0));
      expect(elev.level1?.shadow, equals(1));
      expect(elev.level1?.tint, equals('#FF6750A4'));
      expect(elev.level2?.shadow, equals(3));
      expect(elev.level3?.shadow, equals(6));
      expect(elev.level4?.shadow, equals(8));
      expect(elev.level5?.shadow, equals(12));
    });
  });
}
