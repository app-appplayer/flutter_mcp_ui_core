import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-058: Field validation — required
  group('TC-058: PropertySpec required validation', () {
    test('Normal: non-empty field passes', () {
      final spec = PropertySpec(type: String, required: true);
      expect(spec.isValid('hello'), isTrue);
    });

    test('Error: null fails required check', () {
      final spec = PropertySpec(type: String, required: true);
      expect(spec.isValid(null), isFalse);
    });

    test('Boundary: non-required null is valid', () {
      final spec = PropertySpec(type: String);
      expect(spec.isValid(null), isTrue);
    });
  });

  // TC-059: Field validation — minLength / maxLength (via pattern)
  group('TC-059: PropertySpec pattern/length validation', () {
    test('Normal: string matching pattern passes', () {
      final spec = PropertySpec(type: String, pattern: r'^.{3,10}$');
      expect(spec.isValid('hello'), isTrue);
    });

    test('Error: string too short fails pattern', () {
      final spec = PropertySpec(type: String, pattern: r'^.{3,10}$');
      expect(spec.isValid('ab'), isFalse);
    });

    test('Boundary: string exactly at boundary passes', () {
      final spec = PropertySpec(type: String, pattern: r'^.{3,10}$');
      expect(spec.isValid('abc'), isTrue);
    });
  });

  // TC-060: Field validation — min / max
  group('TC-060: PropertySpec numeric range validation', () {
    test('Normal: number within range passes', () {
      final spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(50), isTrue);
    });

    test('Boundary: number at min passes', () {
      final spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(0), isTrue);
    });

    test('Boundary: number at max passes', () {
      final spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(100), isTrue);
    });

    test('Error: below min fails', () {
      final spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(-1), isFalse);
    });

    test('Error: above max fails', () {
      final spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(101), isFalse);
    });
  });

  // TC-061: Field validation — pattern
  group('TC-061: PropertySpec regex pattern validation', () {
    test('Normal: input matching regex passes', () {
      final spec = PropertySpec(type: String, pattern: r'^[A-Z]{3}$');
      expect(spec.isValid('ABC'), isTrue);
    });

    test('Error: input not matching fails', () {
      final spec = PropertySpec(type: String, pattern: r'^[A-Z]{3}$');
      expect(spec.isValid('abc'), isFalse);
    });

    test('Boundary: complex regex pattern', () {
      final spec = PropertySpec(type: String, pattern: r'^\d{4}-\d{2}-\d{2}$');
      expect(spec.isValid('2024-01-15'), isTrue);
      expect(spec.isValid('2024/01/15'), isFalse);
    });
  });

  // TC-062: Field validation — email (via pattern)
  group('TC-062: Email validation', () {
    test('Normal: valid email passes', () {
      final spec = PropertySpec(
        type: String,
        pattern: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      expect(spec.isValid('test@example.com'), isTrue);
    });

    test('Error: invalid email fails', () {
      final spec = PropertySpec(
        type: String,
        pattern: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      expect(spec.isValid('invalid-email'), isFalse);
    });

    test('Error: missing local part fails', () {
      final spec = PropertySpec(
        type: String,
        pattern: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      expect(spec.isValid('@domain.com'), isFalse);
    });
  });

  // TC-063: Field validation — url (via pattern)
  group('TC-063: URL validation', () {
    test('Normal: valid URL passes', () {
      final spec = PropertySpec(
        type: String,
        pattern: r'^https?://.+',
      );
      expect(spec.isValid('https://example.com'), isTrue);
    });

    test('Error: non-URL fails', () {
      final spec = PropertySpec(
        type: String,
        pattern: r'^https?://.+',
      );
      expect(spec.isValid('not-a-url'), isFalse);
    });

    test('Boundary: localhost with port', () {
      final spec = PropertySpec(
        type: String,
        pattern: r'^https?://.+',
      );
      expect(spec.isValid('http://localhost:3000/path?q=1'), isTrue);
    });
  });

  // TC-064: Field validation — enum values
  group('TC-064: PropertySpec enum validation', () {
    test('Normal: valid enum value passes', () {
      final spec = PropertySpec(type: String, enumValues: ['a', 'b', 'c']);
      expect(spec.isValid('a'), isTrue);
    });

    test('Error: invalid enum value fails', () {
      final spec = PropertySpec(type: String, enumValues: ['a', 'b', 'c']);
      expect(spec.isValid('d'), isFalse);
    });
  });

  // TC-065: Custom validator
  group('TC-065: PropertySpec custom validator', () {
    test('Normal: custom validator passes', () {
      final spec = PropertySpec(
        type: int,
        validator: (v) => v is int && v % 2 == 0,
      );
      expect(spec.isValid(4), isTrue);
    });

    test('Error: custom validator fails', () {
      final spec = PropertySpec(
        type: int,
        validator: (v) => v is int && v % 2 == 0,
      );
      expect(spec.isValid(3), isFalse);
    });
  });

  // PropertySpec additional tests
  group('PropertySpec additional', () {
    test('Normal: getEffectiveValue uses default when null', () {
      final spec = PropertySpec(type: String, defaultValue: 'default');
      expect(spec.getEffectiveValue(null), equals('default'));
      expect(spec.getEffectiveValue('custom'), equals('custom'));
    });

    test('Normal: isDeprecated and deprecationMessage', () {
      final spec = PropertySpec(
        type: String,
        deprecatedInVersion: '1.1.0',
        replacedBy: 'newProp',
      );
      expect(spec.isDeprecated, isTrue);
      expect(spec.deprecationMessage, contains('1.1.0'));
      expect(spec.deprecationMessage, contains('newProp'));
    });

    test('Normal: non-deprecated has no message', () {
      final spec = PropertySpec(type: String);
      expect(spec.isDeprecated, isFalse);
      expect(spec.deprecationMessage, isNull);
    });

    test('Normal: type checking for various types', () {
      expect(PropertySpec(type: String).isValid('hello'), isTrue);
      expect(PropertySpec(type: String).isValid(123), isFalse);
      expect(PropertySpec(type: int).isValid(42), isTrue);
      expect(PropertySpec(type: int).isValid('hello'), isFalse);
      expect(PropertySpec(type: bool).isValid(true), isTrue);
      expect(PropertySpec(type: bool).isValid('true'), isFalse);
      expect(PropertySpec(type: List).isValid([1, 2]), isTrue);
      expect(PropertySpec(type: Map).isValid({'a': 1}), isTrue);
    });
  });
}
