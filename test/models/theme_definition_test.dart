import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('ThemeDefinition (1.3 — M3 14 domains)', () {
    test('parse complete theme — all 14 domains', () {
      final json = {
        'mode': 'dark',
        'color': {
          'primary': '#1976D2',
          'onPrimary': '#FFFFFF',
          'secondary': '#F57C00',
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
        'shape': {
          'small': 8,
          'medium': 12,
          'large': 16,
          'full': 9999,
        },
        'elevation': {
          'level0': {'shadow': 0},
          'level1': {'shadow': 1},
          'level3': {'shadow': 6},
        },
      };

      final theme = ThemeDefinition.fromJson(json);

      expect(theme.mode, equals('dark'));
      expect(theme.color, isNotNull);
      expect(theme.color!.primary, equals('#1976D2'));
      expect(theme.color!.surface, equals('#1E1E1E'));
      expect(theme.typography, isNotNull);
      expect(theme.typography!.displayLarge?.fontSize, equals(57));
      expect(theme.spacing, isNotNull);
      expect(theme.spacing!.md, equals(16));
      expect(theme.shape, isNotNull);
      expect(theme.shape!.medium?.uniform, equals(12));
      expect(theme.elevation, isNotNull);
      expect(theme.elevation!.level3?.shadow, equals(6));
    });

    test('dual-theme with light and dark overrides', () {
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

      final theme = ThemeDefinition.fromJson(json);

      expect(theme.mode, equals('system'));
      expect(theme.light, isNotNull);
      expect(theme.light!.mode, equals('light'));
      expect(theme.light!.color!.primary, equals('#2196F3'));
      expect(theme.dark, isNotNull);
      expect(theme.dark!.color!.primary, equals('#1976D2'));
    });

    test('default mode is system when omitted', () {
      final theme = ThemeDefinition.fromJson({});
      expect(theme.mode, equals('system'));
    });

    test('toJson round-trip preserves seed-derived theme', () {
      final original = ThemeDefinition.defaultLight();
      final json = original.toJson();
      final restored = ThemeDefinition.fromJson(json);

      expect(restored.mode, equals(original.mode));
      expect(restored.color!.primary, equals(original.color!.primary));
      expect(restored.typography!.bodyLarge!.fontSize,
          equals(original.typography!.bodyLarge!.fontSize));
      expect(restored.spacing!.md, equals(original.spacing!.md));
    });
  });

  group('ColorSchemeDefinition (M3 28-role)', () {
    test('parses M3 surface family expressive scale', () {
      final colors = ColorSchemeDefinition.fromJson({
        'primary': '#2196F3',
        'onPrimary': '#FFFFFF',
        'surface': '#FFFFFF',
        'onSurface': '#1A1A1A',
        'surfaceContainerLow': '#F7F7F7',
        'surfaceContainer': '#F0F0F0',
        'surfaceContainerHigh': '#E8E8E8',
        'onSurfaceVariant': '#444444',
        'outline': '#9E9E9E',
        'inverseSurface': '#202020',
        'onInverseSurface': '#F0F0F0',
      });

      expect(colors.primary, equals('#2196F3'));
      expect(colors.surfaceContainer, equals('#F0F0F0'));
      expect(colors.surfaceContainerHigh, equals('#E8E8E8'));
      expect(colors.onInverseSurface, equals('#F0F0F0'));
    });

    test('handles 6-digit and 8-digit hex colors', () {
      final colors = ColorSchemeDefinition.fromJson({
        'primary': '#2196F3',
        'secondary': '#FF2196F3',
      });

      expect(colors.primary, equals('#2196F3'));
      expect(colors.secondary, equals('#FF2196F3'));
    });

    test('seed token round-trips through JSON', () {
      final original = ColorSchemeDefinition(seed: '#3F51B5');
      final restored = ColorSchemeDefinition.fromJson(original.toJson());
      expect(restored.seed, equals('#3F51B5'));
    });

    test('toJson only includes non-null values', () {
      final colors = ColorSchemeDefinition(primary: '#2196F3');
      final json = colors.toJson();

      expect(json['primary'], equals('#2196F3'));
      expect(json.containsKey('secondary'), isFalse);
      expect(json.containsKey('surface'), isFalse);
    });

    test('copyWith preserves untouched fields', () {
      final original = ColorSchemeDefinition(primary: '#2196F3');
      final modified = original.copyWith(secondary: '#FF4081');

      expect(modified.primary, equals('#2196F3'));
      expect(modified.secondary, equals('#FF4081'));
    });
  });

  group('TypographyDefinition (M3 15-role)', () {
    test('parses all 15 M3 type roles', () {
      final json = {
        for (final role in TypographyDefinition.roles)
          role: {'fontSize': 16, 'fontWeight': 'regular'},
      };

      final typo = TypographyDefinition.fromJson(json);

      for (final role in TypographyDefinition.roles) {
        expect(typo.styleFor(role), isNotNull, reason: role);
      }
      expect(typo.displayLarge!.fontSize, equals(16));
    });

    test('TextStyleDefinition with all fields', () {
      final style = TextStyleDefinition.fromJson({
        'fontSize': 16,
        'fontWeight': 'bold',
        'letterSpacing': 0.5,
        'fontFamily': 'Roboto',
        'lineHeight': 24,
      });

      expect(style.fontSize, equals(16));
      expect(style.fontWeight, equals('bold'));
      expect(style.letterSpacing, equals(0.5));
      expect(style.fontFamily, equals('Roboto'));
      expect(style.lineHeight, equals(24));
    });

    test('fontWeight accepts string aliases and numeric values', () {
      final str =
          TextStyleDefinition.fromJson({'fontWeight': 'medium'});
      final num = TextStyleDefinition.fromJson({'fontWeight': 500});
      expect(str.fontWeight, equals('medium'));
      expect(num.fontWeight, equals(500));
    });

    test('toJson round-trip', () {
      final original = TextStyleDefinition(fontSize: 16, fontWeight: 'bold');
      final json = original.toJson();
      final restored = TextStyleDefinition.fromJson(json);

      expect(restored.fontSize, equals(16));
      expect(restored.fontWeight, equals('bold'));
    });
  });

  group('Spacing / Shape / Elevation', () {
    test('SpacingDefinition parses 9 primitives via canonical 2xl/3xl/4xl wire keys', () {
      final spacing = SpacingDefinition.fromJson({
        'xxs': 2,
        'xs': 4,
        'sm': 8,
        'md': 16,
        'lg': 24,
        'xl': 32,
        '2xl': 48,
        '3xl': 64,
        '4xl': 96,
      });

      expect(spacing.xxs, equals(2));
      expect(spacing.xs, equals(4));
      expect(spacing.sm, equals(8));
      expect(spacing.md, equals(16));
      expect(spacing.lg, equals(24));
      expect(spacing.xl, equals(32));
      expect(spacing.xxl, equals(48));
      expect(spacing.xxxl, equals(64));
      expect(spacing.xxxxl, equals(96));
    });

    test('ShapeDefinition parses M3 7-family', () {
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

    test('ShapeCorner per-corner override', () {
      final shape = ShapeDefinition.fromJson({
        'medium': {'topStart': 12, 'topEnd': 4, 'bottomStart': 0, 'bottomEnd': 0},
      });

      expect(shape.medium?.uniform, isNull);
      expect(shape.medium?.topStart, equals(12));
      expect(shape.medium?.topEnd, equals(4));
    });

    test('ElevationDefinition parses M3 6-level with shadow + tint', () {
      final elev = ElevationDefinition.fromJson({
        'level0': {'shadow': 0},
        'level1': {'shadow': 1, 'tint': '#FF6750A4'},
        'level3': {'shadow': 6},
        'level5': {'shadow': 12},
      });

      expect(elev.level0?.shadow, equals(0));
      expect(elev.level1?.shadow, equals(1));
      expect(elev.level1?.tint, equals('#FF6750A4'));
      expect(elev.level3?.shadow, equals(6));
      expect(elev.level5?.shadow, equals(12));
    });
  });
}
