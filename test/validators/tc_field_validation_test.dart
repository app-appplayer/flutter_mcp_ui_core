// TC-092 ~ TC-099: Field Validation Rules Tests per core-models.md spec
// These tests verify PropertySpec validation methods and ValidationRuleTypes
// constants which implement the field validation concepts from the DSL spec.
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-092: Field validation - required
  // =========================================================================
  group('TC-092: Field validation - required', () {
    test('Normal: non-null field passes', () {
      const spec = PropertySpec(type: String, required: true);
      expect(spec.isValid('hello'), isTrue);
    });

    test('Error: null value for required field fails', () {
      const spec = PropertySpec(type: String, required: true);
      expect(spec.isValid(null), isFalse);
    });

    test('Boundary: required rule type is defined in ValidationRuleTypes', () {
      expect(ValidationRuleTypes.isValid('required'), isTrue);
    });
  });

  // =========================================================================
  // TC-093: Field validation - minLength / maxLength
  // =========================================================================
  group('TC-093: Field validation - minLength / maxLength', () {
    test('Normal: ValidationRuleTypes define minLength and maxLength', () {
      expect(ValidationRuleTypes.all, contains('minLength'));
      expect(ValidationRuleTypes.all, contains('maxLength'));
    });

    test('Normal: string pattern validation (analogous to length check)', () {
      // PropertySpec uses pattern for string validation
      const spec = PropertySpec(
        type: String,
        pattern: r'^.{3,10}$', // 3-10 chars
      );
      expect(spec.isValid('abc'), isTrue); // exactly at min
      expect(spec.isValid('abcdefghij'), isTrue); // exactly at max
    });

    test('Error: string below min length fails pattern', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^.{3,10}$',
      );
      expect(spec.isValid('ab'), isFalse);
    });

    test('Error: string exceeding max length fails pattern', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^.{3,10}$',
      );
      expect(spec.isValid('abcdefghijk'), isFalse); // 11 chars
    });
  });

  // =========================================================================
  // TC-094: Field validation - min / max
  // =========================================================================
  group('TC-094: Field validation - min / max', () {
    test('Normal: number within range passes', () {
      const spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(50), isTrue);
    });

    test('Boundary: number exactly at min/max passes', () {
      const spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(0), isTrue);
      expect(spec.isValid(100), isTrue);
    });

    test('Error: below min fails', () {
      const spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(-1), isFalse);
    });

    test('Error: above max fails', () {
      const spec = PropertySpec(type: num, minValue: 0, maxValue: 100);
      expect(spec.isValid(101), isFalse);
    });

    test('Normal: min and max rule types defined', () {
      expect(ValidationRuleTypes.all, contains('min'));
      expect(ValidationRuleTypes.all, contains('max'));
    });
  });

  // =========================================================================
  // TC-095: Field validation - pattern
  // =========================================================================
  group('TC-095: Field validation - pattern', () {
    test('Normal: input matching regex passes', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^[A-Z]{3}$',
      );
      expect(spec.isValid('ABC'), isTrue);
    });

    test('Boundary: complex regex pattern', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$',
      );
      expect(spec.isValid('#2196F3'), isTrue);
      expect(spec.isValid('#FF2196F3'), isTrue);
    });

    test('Error: input not matching fails', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^[A-Z]{3}$',
      );
      expect(spec.isValid('abc'), isFalse);
      expect(spec.isValid('ABCD'), isFalse);
    });

    test('Normal: pattern rule type defined', () {
      expect(ValidationRuleTypes.all, contains('pattern'));
    });
  });

  // =========================================================================
  // TC-096: Field validation - email
  // =========================================================================
  group('TC-096: Field validation - email', () {
    test('Normal: email rule type defined', () {
      expect(ValidationRuleTypes.all, contains('email'));
      expect(ValidationRuleTypes.isValid('email'), isTrue);
    });

    test('Normal: email pattern validation via PropertySpec', () {
      // Simulate email validation using pattern
      const spec = PropertySpec(
        type: String,
        pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      );
      expect(spec.isValid('test@example.com'), isTrue);
    });

    test('Error: invalid email fails pattern', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      );
      expect(spec.isValid('invalid-email'), isFalse);
      expect(spec.isValid('@domain.com'), isFalse);
    });
  });

  // =========================================================================
  // TC-097: Field validation - url
  // =========================================================================
  group('TC-097: Field validation - url', () {
    test('Normal: url rule type defined', () {
      expect(ValidationRuleTypes.all, contains('url'));
      expect(ValidationRuleTypes.isValid('url'), isTrue);
    });

    test('Normal: url pattern validation via PropertySpec', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^https?://.*',
      );
      expect(spec.isValid('https://example.com'), isTrue);
      expect(spec.isValid('http://localhost:3000/path?q=1'), isTrue);
    });

    test('Error: not-a-url fails', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^https?://.*',
      );
      expect(spec.isValid('not-a-url'), isFalse);
    });
  });

  // =========================================================================
  // TC-098: Field validation - match
  // =========================================================================
  group('TC-098: Field validation - match', () {
    test('Normal: match rule type defined', () {
      expect(ValidationRuleTypes.all, contains('match'));
      expect(ValidationRuleTypes.isValid('match'), isTrue);
    });

    // Match validation requires runtime context (comparing two fields)
    // which is outside the scope of PropertySpec
  });

  // =========================================================================
  // TC-099: Field validation - async
  // =========================================================================
  group('TC-099: Field validation - async', () {
    test('Normal: async rule type defined', () {
      expect(ValidationRuleTypes.all, contains('async'));
      expect(ValidationRuleTypes.isValid('async'), isTrue);
    });

    // Async validation requires runtime tool execution
    // which is outside the scope of the core package
  });
}
