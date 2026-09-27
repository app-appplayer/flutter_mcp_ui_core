import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Line height under both names the 1.4 spec gives it — `lineHeight`
/// (05_Theme §5.4.2) and the `TextStyle` primitive's `height`.
void main() {
  group('lineHeightMultiplier', () {
    test('lineHeight below 16 is a multiplier', () {
      expect(lineHeightMultiplier(lineHeight: 1.5, fontSize: 57), 1.5);
      expect(lineHeightMultiplier(lineHeight: 15.9, fontSize: 100), 15.9);
    });

    test('lineHeight at or above 16 is px divided by fontSize', () {
      expect(lineHeightMultiplier(lineHeight: 16, fontSize: 16), 1.0);
      expect(lineHeightMultiplier(lineHeight: 64, fontSize: 57), 64 / 57);
    });

    test('px lineHeight with no font size gives nothing on its own', () {
      expect(lineHeightMultiplier(lineHeight: 64), isNull);
      expect(lineHeightMultiplier(lineHeight: 64, fontSize: 0), isNull);
    });

    test('height is always a multiplier', () {
      expect(lineHeightMultiplier(height: 1.123, fontSize: 57), 1.123);
      expect(lineHeightMultiplier(height: 20), 20);
    });

    test('lineHeight wins over height when both are set', () {
      expect(
          lineHeightMultiplier(lineHeight: 64, height: 2, fontSize: 32), 2.0);
      expect(lineHeightMultiplier(lineHeight: 1.2, height: 2), 1.2);
    });

    test('height applies when px lineHeight has no font size', () {
      expect(lineHeightMultiplier(lineHeight: 64, height: 1.1), 1.1);
    });

    test('non-positive or missing values give null', () {
      expect(lineHeightMultiplier(), isNull);
      expect(lineHeightMultiplier(lineHeight: 0, height: 0), isNull);
      expect(lineHeightMultiplier(lineHeight: -2, height: -1), isNull);
    });
  });

  group('TextStyleDefinition', () {
    test('reads height from JSON and round-trips it', () {
      final s = TextStyleDefinition.fromJson({'fontSize': 57, 'height': 1.123});
      expect(s.height, 1.123);
      expect(s.lineHeightMultiplierValue, 1.123);
      expect(s.toJson(), {'fontSize': 57, 'height': 1.123});
    });

    test('lineHeight keeps its §5.4.2 meaning', () {
      expect(
          TextStyleDefinition.fromJson({'fontSize': 57, 'lineHeight': 64})
              .lineHeightMultiplierValue,
          64 / 57);
      expect(
          TextStyleDefinition.fromJson({'fontSize': 57, 'lineHeight': 1.5})
              .lineHeightMultiplierValue,
          1.5);
    });

    test('copyWith carries height', () {
      final s = const TextStyleDefinition(fontSize: 10).copyWith(height: 2);
      expect(s.height, 2);
    });
  });

  group('DTCG typography line height', () {
    TextStyleDefinition decode(Map<String, dynamic> value) =>
        DtcgCodec.decodeTypography({
          'bodyLarge': {r'$type': 'typography', r'$value': value}
        }).bodyLarge!;

    Map<String, dynamic> encode(TextStyleDefinition s) =>
        (DtcgCodec.encodeTypography(TypographyDefinition(bodyLarge: s))[
            'bodyLarge'] as Map)[r'$value'] as Map<String, dynamic>;

    test('a bare number is DTCG\'s multiplier', () {
      final s = decode({'fontSize': '16px', 'lineHeight': 1.5});
      expect(s.lineHeightMultiplierValue, 1.5);
    });

    test('px at or above 16 stays px', () {
      final s = decode({'fontSize': '57px', 'lineHeight': '64px'});
      expect(s.lineHeight, 64);
      expect(s.lineHeightMultiplierValue, 64 / 57);
    });

    test('px below 16 is read as px, not as a multiplier', () {
      final s = decode({'fontSize': '11px', 'lineHeight': '12px'});
      expect(s.lineHeightMultiplierValue, closeTo(12 / 11, 1e-9));
    });

    test('export writes px for every name the style used', () {
      expect(
          encode(const TextStyleDefinition(fontSize: 57, lineHeight: 64))[
              'lineHeight'],
          '64px');
      expect(
          encode(const TextStyleDefinition(fontSize: 16, lineHeight: 1.5))[
              'lineHeight'],
          '24px');
      expect(
          encode(const TextStyleDefinition(fontSize: 57, height: 1.123))[
              'lineHeight'],
          '64.01px');
    });

    test('a multiplier with no font size exports as a number', () {
      expect(encode(const TextStyleDefinition(height: 1.5))['lineHeight'], 1.5);
    });

    test('no line height, no key', () {
      expect(encode(const TextStyleDefinition(fontSize: 14)),
          isNot(contains('lineHeight')));
    });
  });
}
