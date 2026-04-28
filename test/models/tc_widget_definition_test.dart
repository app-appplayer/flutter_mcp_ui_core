// TC-022 ~ TC-023: WidgetDefinition Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-022: WidgetDefinition.fromJson
  // =========================================================================
  group('TC-022: WidgetDefinition.fromJson', () {
    test('Normal: parse widget with all fields', () {
      final json = {
        'type': 'text',
        'visible': true,
        'key': 'myText',
        'testKey': 'text_widget',
        'content': 'Hello World',
        'style': {'fontSize': 16},
        'metadata': {'custom': 'data'},
        'accessibility': {
          'semanticLabel': 'Greeting text',
          'role': 'text',
        },
        'i18n': {
          'key': 'greeting',
          'default': 'Hello',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('text'));
      expect(def.visible, isTrue);
      expect(def.key, equals('myText'));
      expect(def.testKey, equals('text_widget'));
      expect(def.properties['content'], equals('Hello World'));
      expect(def.metadata, equals({'custom': 'data'}));
      expect(def.accessibility, isNotNull);
      expect(def.accessibility!.semanticLabel, equals('Greeting text'));
      expect(def.i18n, isNotNull);
      expect(def.i18n!.text!.key, equals('greeting'));
    });

    test('Boundary: visible as binding expression stored in visibleExpression', () {
      final json = {
        'type': 'text',
        'visible': '{{showItem}}',
        'content': 'Conditional',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.visible, isNull);
      expect(def.visibleExpression, equals('{{showItem}}'));
    });

    test('Boundary: metadata defaults to empty map', () {
      final json = {'type': 'text', 'content': 'no meta'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.metadata, isEmpty);
    });

    test('Error: missing type field throws', () {
      final json = {'content': 'No type'};
      expect(() => WidgetDefinition.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  // =========================================================================
  // TC-023: WidgetDefinition child vs children
  // =========================================================================
  group('TC-023: WidgetDefinition child vs children', () {
    test('Normal: widget with children list', () {
      final json = {
        'type': 'linear',
        'direction': 'vertical',
        'children': [
          {'type': 'text', 'content': 'A'},
          {'type': 'text', 'content': 'B'},
        ],
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.children, hasLength(2));
      expect(def.children![0].type, equals('text'));
      expect(def.child, isNull);
    });

    test('Boundary: widget with single child', () {
      final json = {
        'type': 'box',
        'child': {'type': 'text', 'content': 'Inside'},
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.child, isNotNull);
      expect(def.child!.type, equals('text'));
      expect(def.children, isNull);
    });

    test('Error: widget with both child and children — both parsed', () {
      final json = {
        'type': 'box',
        'child': {'type': 'text', 'content': 'Single'},
        'children': [
          {'type': 'text', 'content': 'List1'},
        ],
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.child, isNotNull);
      expect(def.children, isNotNull);
    });
  });
}
