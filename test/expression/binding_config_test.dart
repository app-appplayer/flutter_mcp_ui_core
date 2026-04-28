import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-066~088: Expression and binding tests (core-level)
  // Note: Runtime expression evaluation tests are in the runtime package.
  // These tests cover BindingConfig and BindingUtils in the core package.

  // TC-066: Simple variable resolution (config level)
  group('TC-066: BindingConfig from expression', () {
    test('Normal: simple variable binding', () {
      final config = BindingConfig.fromExpression('{{count}}');
      expect(config.path, equals('count'));
      expect(config.expression, equals('{{count}}'));
      expect(config.isSimpleProperty, isTrue);
    });

    test('Boundary: deeply nested path', () {
      final config = BindingConfig.fromExpression('{{deeply.nested.path.value}}');
      expect(config.path, equals('deeply.nested.path.value'));
      expect(config.isNestedProperty, isTrue);
      expect(config.pathSegments, equals(['deeply', 'nested', 'path', 'value']));
    });

    test('Normal: rootObject extraction', () {
      final config = BindingConfig.fromExpression('{{user.profile.name}}');
      expect(config.rootObject, equals('user'));
    });
  });

  // TC-068: Array access binding config
  group('TC-068: Array access binding', () {
    test('Normal: array access path', () {
      final config = BindingConfig.fromExpression('{{items[0].name}}');
      expect(config.isArrayAccess, isTrue);
      expect(config.arrayIndex, equals(0));
      expect(config.propertyName, equals('items.name'));
    });

    test('Boundary: no array access', () {
      final config = BindingConfig.fromExpression('{{simple}}');
      expect(config.isArrayAccess, isFalse);
      expect(config.arrayIndex, isNull);
    });
  });

  // TC-086: BindingConfig validation
  group('TC-086: BindingConfig validation', () {
    test('Normal: valid expression', () {
      final config = BindingConfig(expression: '{{value}}', path: 'value');
      expect(config.isValidExpression, isTrue);
      expect(config.isValid(), isTrue);
    });

    test('Boundary: empty path is invalid', () {
      final config = BindingConfig(expression: '{{}}', path: '');
      expect(config.isValidExpression, isFalse);
    });

    test('Boundary: missing closing braces', () {
      final config = BindingConfig(expression: '{{value', path: 'value');
      expect(config.isValidExpression, isFalse);
    });
  });

  // BindingUtils tests
  group('BindingUtils', () {
    test('Normal: extractBindings from string', () {
      final bindings = BindingUtils.extractBindings('{{name}}');
      expect(bindings, contains('{{name}}'));
    });

    test('Normal: extractBindings from map', () {
      final bindings = BindingUtils.extractBindings({
        'content': '{{title}}',
        'label': '{{subtitle}}',
        'static': 'no binding',
      });
      expect(bindings.length, equals(2));
      expect(bindings, contains('{{title}}'));
      expect(bindings, contains('{{subtitle}}'));
    });

    test('Normal: extractBindings from list', () {
      final bindings = BindingUtils.extractBindings(['{{a}}', '{{b}}', 'static']);
      expect(bindings.length, equals(2));
    });

    test('Normal: hasBindings returns true for binding expressions', () {
      expect(BindingUtils.hasBindings('{{count}}'), isTrue);
      expect(BindingUtils.hasBindings('static text'), isFalse);
    });

    test('Normal: isValidBindingExpression', () {
      expect(BindingUtils.isValidBindingExpression('{{count}}'), isTrue);
      expect(BindingUtils.isValidBindingExpression('{{user.name}}'), isTrue);
      expect(BindingUtils.isValidBindingExpression('not a binding'), isFalse);
      expect(BindingUtils.isValidBindingExpression('{{}}'), isFalse);
    });

    test('Normal: extractPath', () {
      expect(BindingUtils.extractPath('{{user.name}}'), equals('user.name'));
      expect(BindingUtils.extractPath('{{count}}'), equals('count'));
    });

    test('Normal: createBindings from expressions', () {
      final configs = BindingUtils.createBindings(['{{name}}', '{{age}}']);
      expect(configs.length, equals(2));
      expect(configs[0].path, equals('name'));
      expect(configs[1].path, equals('age'));
    });
  });

  // BindingConfig features
  group('BindingConfig features', () {
    test('Normal: fromJson and toJson round-trip', () {
      final original = BindingConfig(
        expression: '{{user.name}}',
        path: 'user.name',
        type: 'text',
        twoWay: true,
        formatter: 'uppercase',
      );

      final json = original.toJson();
      final restored = BindingConfig.fromJson(json);

      expect(restored.expression, equals(original.expression));
      expect(restored.path, equals(original.path));
      expect(restored.type, equals(original.type));
      expect(restored.twoWay, equals(original.twoWay));
      expect(restored.formatter, equals(original.formatter));
    });

    test('Normal: copyWith creates modified copy', () {
      final original = BindingConfig(expression: '{{x}}', path: 'x');
      final modified = original.copyWith(twoWay: true);

      expect(modified.expression, equals('{{x}}'));
      expect(modified.twoWay, isTrue);
      expect(original.twoWay, isFalse);
    });

    test('Normal: asTwoWay creates two-way binding', () {
      final config = BindingConfig(expression: '{{value}}', path: 'value');
      final twoWay = config.asTwoWay(validator: 'notEmpty');

      expect(twoWay.twoWay, isTrue);
      expect(twoWay.validator, equals('notEmpty'));
    });

    test('Normal: withFormatter adds formatter', () {
      final config = BindingConfig(expression: '{{name}}', path: 'name');
      final formatted = config.withFormatter('uppercase');

      expect(formatted.formatter, equals('uppercase'));
    });

    test('Normal: equality', () {
      final a = BindingConfig(expression: '{{x}}', path: 'x');
      final b = BindingConfig(expression: '{{x}}', path: 'x');
      final c = BindingConfig(expression: '{{y}}', path: 'y');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  // TC-088: Special characters in state keys
  group('TC-088: Special characters in paths', () {
    test('Normal: path with dots', () {
      final config = BindingConfig.fromExpression('{{user.profile.name}}');
      expect(config.pathSegments.length, equals(3));
    });

    test('Normal: path with array access', () {
      final config = BindingConfig.fromExpression('{{items[0]}}');
      expect(config.isArrayAccess, isTrue);
    });
  });
}
