// TC-063 ~ TC-066: BindingConfig and BindingUtils Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-063: BindingConfig.fromExpression
  // =========================================================================
  group('TC-063: BindingConfig.fromExpression', () {
    test('Normal: create config with expression and resolved path', () {
      final config = BindingConfig.fromExpression('{{user.name}}');
      expect(config.expression, equals('{{user.name}}'));
      expect(config.path, equals('user.name'));
    });

    test('Boundary: all default fields', () {
      final config = BindingConfig.fromExpression('{{count}}');
      expect(config.type, equals('value'));
      expect(config.defaultValue, isNull);
      expect(config.twoWay, isFalse);
      expect(config.formatter, isNull);
      expect(config.validator, isNull);
    });

    test('Boundary: fromJson with all fields', () {
      final json = {
        'expression': '{{user.name}}',
        'path': 'user.name',
        'type': 'text',
        'defaultValue': 'Anonymous',
        'twoWay': true,
        'formatter': 'uppercase',
        'validator': 'notEmpty',
      };

      final config = BindingConfig.fromJson(json);
      expect(config.expression, equals('{{user.name}}'));
      expect(config.path, equals('user.name'));
      expect(config.type, equals('text'));
      expect(config.defaultValue, equals('Anonymous'));
      expect(config.twoWay, isTrue);
      expect(config.formatter, equals('uppercase'));
      expect(config.validator, equals('notEmpty'));
    });
  });

  // =========================================================================
  // TC-064: BindingConfig utility methods
  // =========================================================================
  group('TC-064: BindingConfig utility methods', () {
    test('Normal: isValidExpression returns true for valid expression', () {
      final config = BindingConfig.fromExpression('{{user.name}}');
      expect(config.isValidExpression, isTrue);
    });

    test('Normal: isSimpleProperty for simple path', () {
      final config = BindingConfig.fromExpression('{{name}}');
      expect(config.isSimpleProperty, isTrue);
      expect(config.isNestedProperty, isFalse);
    });

    test('Normal: isNestedProperty for dotted path', () {
      final config = BindingConfig.fromExpression('{{user.name}}');
      expect(config.isNestedProperty, isTrue);
      expect(config.isSimpleProperty, isFalse);
    });

    test('Normal: isArrayAccess for indexed path', () {
      final config = BindingConfig.fromExpression('{{items[0]}}');
      expect(config.isArrayAccess, isTrue);
      expect(config.arrayIndex, equals(0));
    });

    test('Boundary: isValidExpression with empty path returns false', () {
      // fromExpression('{{}}') strips braces -> empty path
      final config = BindingConfig.fromExpression('{{}}');
      expect(config.isValidExpression, isFalse);
    });

    test('Normal: rootObject and pathSegments', () {
      final config = BindingConfig.fromExpression('{{user.profile.name}}');
      expect(config.rootObject, equals('user'));
      expect(config.pathSegments, equals(['user', 'profile', 'name']));
    });
  });

  // =========================================================================
  // TC-065: BindingConfig fluent builders
  // =========================================================================
  group('TC-065: BindingConfig fluent builders', () {
    test('Normal: asTwoWay returns new config with twoWay true', () {
      final config = BindingConfig.fromExpression('{{name}}');
      final twoWayConfig = config.asTwoWay();
      expect(twoWayConfig.twoWay, isTrue);
      expect(config.twoWay, isFalse); // original unchanged
    });

    test('Normal: withFormatter sets formatter', () {
      final config = BindingConfig.fromExpression('{{name}}');
      final formatted = config.withFormatter('uppercase');
      expect(formatted.formatter, equals('uppercase'));
    });

    test('Normal: withValidator sets validator', () {
      final config = BindingConfig.fromExpression('{{email}}');
      final validated = config.withValidator('notEmpty');
      expect(validated.validator, equals('notEmpty'));
    });

    test('Boundary: chained builders', () {
      final config = BindingConfig.fromExpression('{{name}}')
          .asTwoWay()
          .withFormatter('uppercase')
          .withValidator('notEmpty');
      expect(config.twoWay, isTrue);
      expect(config.formatter, equals('uppercase'));
      expect(config.validator, equals('notEmpty'));
    });
  });

  // =========================================================================
  // TC-066: BindingUtils static helpers
  // =========================================================================
  group('TC-066: BindingUtils static helpers', () {
    test('Normal: extractBindings from string', () {
      final bindings = BindingUtils.extractBindings('{{user.name}}');
      expect(bindings, equals(['{{user.name}}']));
    });

    test('Normal: extractBindings from map', () {
      final bindings = BindingUtils.extractBindings({
        'name': '{{user.name}}',
        'age': '{{user.age}}',
        'static': 'hello',
      });
      expect(bindings, contains('{{user.name}}'));
      expect(bindings, contains('{{user.age}}'));
      expect(bindings, hasLength(2));
    });

    test('Normal: extractBindings from list', () {
      final bindings = BindingUtils.extractBindings([
        '{{a}}',
        '{{b}}',
        'not-a-binding',
      ]);
      expect(bindings, hasLength(2));
    });

    test('Normal: hasBindings returns true when bindings present', () {
      expect(BindingUtils.hasBindings('{{value}}'), isTrue);
    });

    test('Boundary: no bindings returns empty list and false', () {
      expect(BindingUtils.extractBindings('plain text'), isEmpty);
      expect(BindingUtils.hasBindings('plain text'), isFalse);
    });

    test('Normal: isValidBindingExpression validates correctly', () {
      expect(BindingUtils.isValidBindingExpression('{{user.name}}'), isTrue);
      expect(BindingUtils.isValidBindingExpression('{{count}}'), isTrue);
      expect(BindingUtils.isValidBindingExpression('{{items[0]}}'), isTrue);
    });

    test('Boundary: isValidBindingExpression rejects invalid', () {
      expect(BindingUtils.isValidBindingExpression('not-binding'), isFalse);
      expect(BindingUtils.isValidBindingExpression('{{}}'), isFalse);
    });

    test('Error: null input', () {
      expect(BindingUtils.extractBindings(null), isEmpty);
      expect(BindingUtils.hasBindings(null), isFalse);
    });
  });
}
