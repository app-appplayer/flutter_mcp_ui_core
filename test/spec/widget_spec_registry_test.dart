import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('WidgetSpecRegistry', () {
    group('getSpec', () {
      test('returns spec for valid widget types', () {
        // Test single-word widgets
        expect(WidgetSpecRegistry.getSpec('text'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('button'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('box'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('image'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('icon'), isNotNull);
        
        // Test multi-word widgets with CamelCase
        expect(WidgetSpecRegistry.getSpec('textInput'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('loadingIndicator'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('bottomNavigation'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('headerBar'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('scrollView'), isNotNull);
        expect(WidgetSpecRegistry.getSpec('mediaPlayer'), isNotNull);
      });

      test('returns null for invalid widget types', () {
        expect(WidgetSpecRegistry.getSpec('invalidWidget'), isNull);
        expect(WidgetSpecRegistry.getSpec(''), isNull);
        expect(WidgetSpecRegistry.getSpec('text-input'), isNull); // Wrong format
        expect(WidgetSpecRegistry.getSpec('loading-indicator'), isNull); // Wrong format
      });

      test('widget specs have correct properties', () {
        final textSpec = WidgetSpecRegistry.getSpec('text')!;
        expect(textSpec.type, equals('text'));
        expect(textSpec.category, equals('display'));
        expect(textSpec.canHaveChildren, isFalse);
        expect(textSpec.canHaveChild, isFalse);
        expect(textSpec.requiredParameters, contains('content'));
        expect(textSpec.parameters.containsKey('content'), isTrue);
        expect(textSpec.parameters.containsKey('style'), isTrue);

        final boxSpec = WidgetSpecRegistry.getSpec('box')!;
        expect(boxSpec.type, equals('box'));
        expect(boxSpec.category, equals('layout'));
        expect(boxSpec.canHaveChild, isTrue);
        expect(boxSpec.canHaveChildren, isFalse);

        final linearSpec = WidgetSpecRegistry.getSpec('linear')!;
        expect(linearSpec.type, equals('linear'));
        expect(linearSpec.category, equals('layout'));
        expect(linearSpec.canHaveChildren, isTrue);
        expect(linearSpec.requiredParameters, contains('children'));
      });
    });

    group('validateParameters', () {
      test('validates required parameters', () {
        expect(
          () => WidgetSpecRegistry.validateParameters('text', {}),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Required parameter "content" missing'),
          )),
        );

        expect(
          () => WidgetSpecRegistry.validateParameters('button', {
            'label': 'Click me',
          }),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Required parameter "click" missing'),
          )),
        );
      });

      test('applies default values', () {
        final buttonParams = WidgetSpecRegistry.validateParameters('button', {
          'label': 'Test',
          'click': {'type': 'tool', 'name': 'test'},
        });
        expect(buttonParams['style'], equals('elevated'));
        expect(buttonParams['disabled'], equals(false));
        expect(buttonParams['loading'], equals(false));

        final iconParams = WidgetSpecRegistry.validateParameters('icon', {
          'icon': 'home',
        });
        expect(iconParams['size'], equals(24.0));
      });

      test('validates allowed values', () {
        expect(
          () => WidgetSpecRegistry.validateParameters('button', {
            'label': 'Test',
            'click': {},
            'style': 'invalid-style',
          }),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid value "invalid-style"'),
          )),
        );

        expect(
          () => WidgetSpecRegistry.validateParameters('linear', {
            'children': [],
            'direction': 'diagonal',
          }),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid value "diagonal"'),
          )),
        );
      });

      test('accepts valid parameters', () {
        final params = WidgetSpecRegistry.validateParameters('textInput', {
          'label': 'Username',
          'value': 'john',
          'change': {'type': 'state', 'action': 'set', 'path': 'username'},
          'placeholder': 'Enter username',
          'maxLength': 20,
        });

        expect(params['label'], equals('Username'));
        expect(params['value'], equals('john'));
        expect(params['placeholder'], equals('Enter username'));
        expect(params['maxLength'], equals(20));
        expect(params['obscureText'], equals(false)); // default value
      });

      test('ignores unknown parameters', () {
        final params = WidgetSpecRegistry.validateParameters('text', {
          'content': 'Hello',
          'unknownParam': 'value',
        });

        expect(params.containsKey('content'), isTrue);
        expect(params.containsKey('unknownParam'), isFalse);
      });
    });

    group('getTypesByCategory', () {
      test('returns correct types for each category', () {
        final layoutTypes = WidgetSpecRegistry.getTypesByCategory('layout');
        expect(layoutTypes, contains('linear'));
        expect(layoutTypes, contains('box'));
        expect(layoutTypes, contains('stack'));

        final displayTypes = WidgetSpecRegistry.getTypesByCategory('display');
        expect(displayTypes, contains('text'));
        expect(displayTypes, contains('image'));
        expect(displayTypes, contains('loadingIndicator')); // CamelCase

        final inputTypes = WidgetSpecRegistry.getTypesByCategory('input');
        expect(inputTypes, contains('button'));
        expect(inputTypes, contains('textInput')); // CamelCase
        expect(inputTypes, contains('checkbox'));

        final navigationTypes = WidgetSpecRegistry.getTypesByCategory('navigation');
        expect(navigationTypes, contains('headerBar')); // CamelCase
        expect(navigationTypes, contains('bottomNavigation')); // CamelCase
      });

      test('returns empty list for invalid category', () {
        expect(WidgetSpecRegistry.getTypesByCategory('invalid'), isEmpty);
      });
    });

    group('allSpecs', () {
      test('contains all defined widgets', () {
        final allSpecs = WidgetSpecRegistry.allSpecs;
        
        // Single-word widgets
        expect(allSpecs.containsKey('text'), isTrue);
        expect(allSpecs.containsKey('button'), isTrue);
        expect(allSpecs.containsKey('box'), isTrue);
        
        // Multi-word widgets with CamelCase
        expect(allSpecs.containsKey('textInput'), isTrue);
        expect(allSpecs.containsKey('loadingIndicator'), isTrue);
        expect(allSpecs.containsKey('bottomNavigation'), isTrue);
        expect(allSpecs.containsKey('scrollView'), isTrue);
        expect(allSpecs.containsKey('mediaPlayer'), isTrue);
        
        // Should NOT contain hyphenated names
        expect(allSpecs.containsKey('text-input'), isFalse);
        expect(allSpecs.containsKey('loading-indicator'), isFalse);
        expect(allSpecs.containsKey('bottom-navigation'), isFalse);
      });
    });

    group('hasType', () {
      test('returns true for valid types', () {
        expect(WidgetSpecRegistry.hasType('text'), isTrue);
        expect(WidgetSpecRegistry.hasType('textInput'), isTrue);
        expect(WidgetSpecRegistry.hasType('bottomNavigation'), isTrue);
      });

      test('returns false for invalid types', () {
        expect(WidgetSpecRegistry.hasType('invalid'), isFalse);
        expect(WidgetSpecRegistry.hasType('text-input'), isFalse);
        expect(WidgetSpecRegistry.hasType(''), isFalse);
      });
    });

    group('parameter specs', () {
      test('have correct types and defaults', () {
        final textSpec = WidgetSpecRegistry.getSpec('text')!;
        final contentParam = textSpec.parameters['content']!;
        expect(contentParam.type, equals(String));
        expect(contentParam.required, isTrue);

        final buttonSpec = WidgetSpecRegistry.getSpec('button')!;
        final styleParam = buttonSpec.parameters['style']!;
        expect(styleParam.type, equals(String));
        expect(styleParam.defaultValue, equals('elevated'));
        expect(styleParam.allowedValues, contains('elevated'));
        expect(styleParam.allowedValues, contains('outlined'));

        final linearSpec = WidgetSpecRegistry.getSpec('linear')!;
        final directionParam = linearSpec.parameters['direction']!;
        expect(directionParam.allowedValues, equals(['vertical', 'horizontal']));
        expect(directionParam.defaultValue, equals('vertical'));
      });
    });
  });
}