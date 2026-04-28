// TC-070 ~ TC-073: ParameterSpec, WidgetSpec, WidgetSpecRegistry, PropertySpec
// Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:flutter_mcp_ui_core/src/spec/parameter_spec.dart';

void main() {
  // =========================================================================
  // TC-070: ParameterSpec fields
  // =========================================================================
  group('TC-070: ParameterSpec fields', () {
    test('Normal: parse all fields', () {
      const spec = ParameterSpec(
        name: 'direction',
        type: String,
        required: false,
        defaultValue: 'vertical',
        allowedValues: ['vertical', 'horizontal'],
        description: 'Layout direction',
      );

      expect(spec.name, equals('direction'));
      expect(spec.type, equals(String));
      expect(spec.required, isFalse);
      expect(spec.defaultValue, equals('vertical'));
      expect(spec.allowedValues, equals(['vertical', 'horizontal']));
      expect(spec.description, equals('Layout direction'));
    });

    test('Boundary: allowedValues null (no enum constraint)', () {
      const spec = ParameterSpec(
        name: 'content',
        type: String,
      );
      expect(spec.allowedValues, isNull);
    });

    test('Boundary: required defaults to false', () {
      const spec = ParameterSpec(name: 'width', type: num);
      expect(spec.required, isFalse);
    });
  });

  // =========================================================================
  // TC-071: WidgetSpec fields
  // =========================================================================
  group('TC-071: WidgetSpec fields', () {
    test('Normal: parse all fields', () {
      const spec = WidgetSpec(
        type: 'linear',
        category: 'layout',
        parameters: {
          'direction': ParameterSpec(
            name: 'direction',
            type: String,
            defaultValue: 'vertical',
          ),
        },
        requiredParameters: ['children'],
        canHaveChildren: true,
        canHaveChild: false,
        defaults: {'spacing': 0},
        description: 'Linear layout widget',
      );

      expect(spec.type, equals('linear'));
      expect(spec.category, equals('layout'));
      expect(spec.parameters, hasLength(1));
      expect(spec.requiredParameters, contains('children'));
      expect(spec.canHaveChildren, isTrue);
      expect(spec.canHaveChild, isFalse);
      expect(spec.defaults, equals({'spacing': 0}));
      expect(spec.description, equals('Linear layout widget'));
    });

    test('Boundary: supportsChildContent getter', () {
      const withChildren = WidgetSpec(
        type: 'linear',
        category: 'layout',
        parameters: {},
        canHaveChildren: true,
        canHaveChild: false,
      );
      expect(withChildren.supportsChildContent, isTrue);

      const withChild = WidgetSpec(
        type: 'box',
        category: 'layout',
        parameters: {},
        canHaveChildren: false,
        canHaveChild: true,
      );
      expect(withChild.supportsChildContent, isTrue);

      const noChild = WidgetSpec(
        type: 'text',
        category: 'display',
        parameters: {},
        canHaveChildren: false,
        canHaveChild: false,
      );
      expect(noChild.supportsChildContent, isFalse);
    });
  });

  // =========================================================================
  // TC-072: WidgetSpecRegistry lookup
  // =========================================================================
  group('TC-072: WidgetSpecRegistry lookup', () {
    test('Normal: registry contains known widget types', () {
      final textSpec = WidgetSpecRegistry.getSpec('text');
      expect(textSpec, isNotNull);
      expect(textSpec!.type, equals('text'));

      final linearSpec = WidgetSpecRegistry.getSpec('linear');
      expect(linearSpec, isNotNull);
      expect(linearSpec!.type, equals('linear'));
    });

    test('Boundary: lookup for unknown widget type returns null', () {
      final unknown = WidgetSpecRegistry.getSpec('nonexistent_widget');
      expect(unknown, isNull);
    });
  });

  // =========================================================================
  // TC-073: PropertySpec fields
  // =========================================================================
  group('TC-073: PropertySpec fields', () {
    test('Normal: parse all fields', () {
      final spec = PropertySpec(
        type: String,
        required: true,
        defaultValue: 'Hello',
        description: 'Content text',
        enumValues: ['a', 'b', 'c'],
        minValue: 0,
        maxValue: 100,
        pattern: r'^[a-z]+$',
        addedInVersion: '1.0.0',
        deprecatedInVersion: '1.1.0',
        replacedBy: 'newProperty',
      );

      expect(spec.type, equals(String));
      expect(spec.required, isTrue);
      expect(spec.defaultValue, equals('Hello'));
      expect(spec.description, equals('Content text'));
      expect(spec.enumValues, equals(['a', 'b', 'c']));
      expect(spec.minValue, equals(0));
      expect(spec.maxValue, equals(100));
      expect(spec.pattern, equals(r'^[a-z]+$'));
      expect(spec.addedInVersion, equals('1.0.0'));
      expect(spec.deprecatedInVersion, equals('1.1.0'));
      expect(spec.replacedBy, equals('newProperty'));
    });

    test('Boundary: deprecated property with deprecatedInVersion and replacedBy', () {
      const spec = PropertySpec(
        type: String,
        deprecatedInVersion: '1.1.0',
        replacedBy: 'newProp',
      );
      expect(spec.isDeprecated, isTrue);
      expect(spec.deprecationMessage, contains('1.1.0'));
      expect(spec.deprecationMessage, contains('newProp'));
    });

    test('Boundary: non-deprecated property', () {
      const spec = PropertySpec(type: String);
      expect(spec.isDeprecated, isFalse);
      expect(spec.deprecationMessage, isNull);
    });

    test('Boundary: addedInVersion defaults to 1.0.0', () {
      const spec = PropertySpec(type: String);
      expect(spec.addedInVersion, equals('1.0.0'));
    });

    test('Normal: isValid validates correctly', () {
      const spec = PropertySpec(
        type: num,
        required: true,
        minValue: 0,
        maxValue: 100,
      );

      expect(spec.isValid(50), isTrue);
      expect(spec.isValid(0), isTrue);
      expect(spec.isValid(100), isTrue);
      expect(spec.isValid(null), isFalse); // required
      expect(spec.isValid(-1), isFalse); // below min
      expect(spec.isValid(101), isFalse); // above max
    });

    test('Normal: isValid with enumValues', () {
      const spec = PropertySpec(
        type: String,
        enumValues: ['a', 'b', 'c'],
      );
      expect(spec.isValid('a'), isTrue);
      expect(spec.isValid('d'), isFalse);
    });

    test('Normal: isValid with pattern', () {
      const spec = PropertySpec(
        type: String,
        pattern: r'^#[0-9A-Fa-f]{6}$',
      );
      expect(spec.isValid('#2196F3'), isTrue);
      expect(spec.isValid('invalid'), isFalse);
    });

    test('Boundary: null value valid when not required', () {
      const spec = PropertySpec(type: String, required: false);
      expect(spec.isValid(null), isTrue);
    });

    test('Normal: getEffectiveValue returns default for null', () {
      const spec = PropertySpec(type: String, defaultValue: 'default');
      expect(spec.getEffectiveValue(null), equals('default'));
      expect(spec.getEffectiveValue('value'), equals('value'));
    });

    test('Normal: validator function returns bool', () {
      final spec = PropertySpec(
        type: int,
        validator: (value) => value is int && value % 2 == 0,
      );
      expect(spec.isValid(4), isTrue);
      expect(spec.isValid(3), isFalse);
    });
  });
}
