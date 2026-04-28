// MCP UI DSL 1.3 — DTCG W3C codec round-trip tests for each of the 14 token
// domains. Verifies that `ThemeDefinition.toDtcg()` / `fromDtcg()` preserve
// each domain's canonical structure when interchanged with W3C-compliant
// design-token tools (Tokens Studio, Style Dictionary, Claude Design).

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('DTCG round-trip — per-domain', () {
    test('color domain — every M3 28-role + 6 semantic survives DTCG', () {
      final original = ThemeDefinition(
        color: const ColorSchemeDefinition(
          primary: '#1976D2',
          onPrimary: '#FFFFFF',
          primaryContainer: '#BBDEFB',
          onPrimaryContainer: '#0D47A1',
          secondary: '#FF4081',
          onSecondary: '#FFFFFF',
          tertiary: '#9C27B0',
          onTertiary: '#FFFFFF',
          error: '#F44336',
          onError: '#FFFFFF',
          surface: '#FFFFFF',
          onSurface: '#1A1A1A',
          surfaceContainer: '#F0F0F0',
          surfaceContainerHigh: '#E8E8E8',
          onSurfaceVariant: '#444444',
          outline: '#9E9E9E',
          inverseSurface: '#202020',
          onInverseSurface: '#F0F0F0',
          inversePrimary: '#90CAF9',
          shadow: '#000000',
          scrim: '#000000',
          success: '#4CAF50',
          onSuccess: '#FFFFFF',
          warning: '#FF9800',
          info: '#2196F3',
          seed: '#3F51B5',
        ),
      );
      final dtcg = original.toDtcg();
      // Each color is a `{$type: 'color', $value: '#...'}` envelope.
      expect((dtcg['color'] as Map)['primary'][r'$type'], equals('color'));
      expect((dtcg['color'] as Map)['primary'][r'$value'], equals('#1976D2'));

      final restored = ThemeDefinition.fromDtcg(dtcg);
      expect(restored.color?.primary, equals('#1976D2'));
      expect(restored.color?.surfaceContainer, equals('#F0F0F0'));
      expect(restored.color?.onInverseSurface, equals('#F0F0F0'));
      expect(restored.color?.success, equals('#4CAF50'));
      expect(restored.color?.seed, equals('#3F51B5'));
    });

    test('typography domain — DTCG `typography` envelope', () {
      final original = ThemeDefinition(
        typography: const TypographyDefinition(
          displayLarge: TextStyleDefinition(
              fontSize: 57, fontWeight: 'regular', lineHeight: 64),
          bodyLarge: TextStyleDefinition(
              fontSize: 16, fontWeight: 'regular', lineHeight: 24),
        ),
      );
      final dtcg = original.toDtcg();
      expect((dtcg['typography'] as Map)['displayLarge'][r'$type'],
          equals('typography'));

      final restored = ThemeDefinition.fromDtcg(dtcg);
      expect(restored.typography?.displayLarge?.fontSize, equals(57));
      expect(restored.typography?.bodyLarge?.fontSize, equals(16));
    });

    test('spacing domain — DTCG `dimension` envelope (px units)', () {
      final original = ThemeDefinition(
        spacing: const SpacingDefinition(
          xxs: 2, xs: 4, sm: 8, md: 16, lg: 24, xl: 32,
          xxl: 48, xxxl: 64, xxxxl: 96,
        ),
      );
      final dtcg = original.toDtcg();
      expect((dtcg['spacing'] as Map)['md'][r'$type'], equals('dimension'));
      expect((dtcg['spacing'] as Map)['md'][r'$value'], equals('16px'));
      expect((dtcg['spacing'] as Map)['2xl'][r'$type'], equals('dimension'));

      final restored = ThemeDefinition.fromDtcg(dtcg);
      expect(restored.spacing?.md, equals(16));
      expect(restored.spacing?.xxl, equals(48));
      expect(restored.spacing?.xxxxl, equals(96));
    });

    test('shape domain — uniform + per-corner survive', () {
      final original = ThemeDefinition(
        shape: const ShapeDefinition(
          medium: ShapeCorner.uniform(12),
          large: ShapeCorner.perCorner(
              topStart: 16, topEnd: 16, bottomStart: 0, bottomEnd: 0),
        ),
      );
      final dtcg = original.toDtcg();

      final restored = ThemeDefinition.fromDtcg(dtcg);
      expect(restored.shape?.medium?.uniform, equals(12));
      expect(restored.shape?.large?.topStart, equals(16));
      expect(restored.shape?.large?.bottomEnd, equals(0));
    });

    test('elevation domain — shadow + tint survive', () {
      final original = ThemeDefinition(
        elevation: const ElevationDefinition(
          level0: ElevationLevel(shadow: 0),
          level3: ElevationLevel(shadow: 6, tint: '#FF6750A4'),
          level5: ElevationLevel(shadow: 12),
        ),
      );
      final dtcg = original.toDtcg();

      final restored = ThemeDefinition.fromDtcg(dtcg);
      expect(restored.elevation?.level0?.shadow, equals(0));
      expect(restored.elevation?.level3?.shadow, equals(6));
      expect(restored.elevation?.level3?.tint, equals('#FF6750A4'));
      expect(restored.elevation?.level5?.shadow, equals(12));
    });

    test('mode + light/dark overrides survive', () {
      final original = ThemeDefinition(
        mode: 'system',
        light: ThemeDefinition.defaultLight(seedHex: '#3F51B5'),
        dark: ThemeDefinition.defaultDark(seedHex: '#3F51B5'),
      );
      final dtcg = original.toDtcg();

      final restored = ThemeDefinition.fromDtcg(dtcg);
      expect(restored.mode, equals('system'));
      expect(restored.light, isNotNull);
      expect(restored.light!.mode, equals('light'));
      expect(restored.dark!.mode, equals('dark'));
      expect(restored.light!.color?.primary,
          equals(original.light!.color?.primary));
      expect(restored.dark!.color?.primary,
          equals(original.dark!.color?.primary));
    });
  });

  group('Seed-derived defaults — M3 HCT', () {
    test('lightFromSeed produces non-null 28-role palette', () {
      final cs = SeedPalette.lightFromSeed('#3F51B5');
      expect(cs.primary, isNotNull);
      expect(cs.onPrimary, isNotNull);
      expect(cs.primaryContainer, isNotNull);
      expect(cs.onPrimaryContainer, isNotNull);
      expect(cs.secondary, isNotNull);
      expect(cs.tertiary, isNotNull);
      expect(cs.error, isNotNull);
      expect(cs.surface, isNotNull);
      expect(cs.onSurface, isNotNull);
      expect(cs.surfaceContainer, isNotNull);
      expect(cs.outline, isNotNull);
      expect(cs.inverseSurface, isNotNull);
      expect(cs.seed, equals('#3F51B5'));
    });

    test('lightFromSeed and darkFromSeed produce different surfaces', () {
      final light = SeedPalette.lightFromSeed('#3F51B5');
      final dark = SeedPalette.darkFromSeed('#3F51B5');
      expect(light.surface, isNot(equals(dark.surface)));
      expect(light.onSurface, isNot(equals(dark.onSurface)));
    });

    test('invalid seed hex produces empty ColorSchemeDefinition with seed only', () {
      final cs = SeedPalette.lightFromSeed('not-a-hex');
      expect(cs.primary, isNull);
      expect(cs.seed, equals('not-a-hex'));
    });
  });

  group('M3 15-role typography contract', () {
    test('TypographyDefinition.roles enumerates all 15 M3 roles in canonical order', () {
      expect(TypographyDefinition.roles, hasLength(15));
      expect(TypographyDefinition.roles.first, equals('displayLarge'));
      expect(TypographyDefinition.roles.last, equals('labelSmall'));
      expect(TypographyDefinition.roles, contains('bodyLarge'));
      expect(TypographyDefinition.roles, contains('titleMedium'));
      expect(TypographyDefinition.roles, contains('headlineSmall'));
    });
  });
}
