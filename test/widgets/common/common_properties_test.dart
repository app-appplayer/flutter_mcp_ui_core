import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-001: id property (key, testKey)
  group('TC-001: id property', () {
    // Normal
    test('fromJson with key field sets key', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'key': 'widget-1',
        'testKey': 'test-widget-1',
      });

      expect(widget.key, equals('widget-1'));
      expect(widget.testKey, equals('test-widget-1'));
    });

    test('key and testKey are independent', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'key': 'my-key',
      });

      expect(widget.key, equals('my-key'));
      expect(widget.testKey, isNull);
    });

    // Boundary
    test('key and testKey are null when not provided', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
      });

      expect(widget.key, isNull);
      expect(widget.testKey, isNull);
    });

    test('empty string key is preserved', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'key': '',
      });

      expect(widget.key, equals(''));
    });
  });

  // TC-002: visible property
  group('TC-002: visible property', () {
    // Normal
    test('explicit boolean true sets visible', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'visible': true,
      });

      expect(widget.visible, isTrue);
      expect(widget.visibleExpression, isNull);
    });

    test('explicit boolean false sets visible', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'visible': false,
      });

      expect(widget.visible, isFalse);
      expect(widget.visibleExpression, isNull);
    });

    test('binding expression string sets visibleExpression', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'visible': '{{isVisible}}',
      });

      expect(widget.visible, isNull);
      expect(widget.visibleExpression, equals('{{isVisible}}'));
    });

    // Boundary
    test('visible is null when not provided', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
      });

      expect(widget.visible, isNull);
      expect(widget.visibleExpression, isNull);
    });

    test('toJson serializes visible boolean correctly', () {
      final widget = WidgetDefinition(type: 'text', visible: false);
      final json = widget.toJson();

      expect(json['visible'], isFalse);
    });

    test('toJson serializes visibleExpression as visible', () {
      final widget = WidgetDefinition(
        type: 'text',
        visibleExpression: '{{show}}',
      );
      final json = widget.toJson();

      expect(json['visible'], equals('{{show}}'));
    });
  });

  // TC-003: key property for Flutter identity
  group('TC-003: key property', () {
    // Normal
    test('key is stored in the key field', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'button',
        'key': 'submit-btn',
      });

      expect(widget.key, equals('submit-btn'));
      // key should NOT appear in properties
      expect(widget.properties.containsKey('key'), isFalse);
    });

    // Boundary
    test('key with special characters is preserved', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'key': 'widget-123_abc.def',
      });

      expect(widget.key, equals('widget-123_abc.def'));
    });

    test('key roundtrips through toJson/fromJson', () {
      final original = WidgetDefinition(type: 'text', key: 'my-key');
      final restored = WidgetDefinition.fromJson(original.toJson());

      expect(restored.key, equals('my-key'));
    });
  });

  // TC-004: style property stored in properties map
  group('TC-004: style property', () {
    // Normal
    test('inline style map stored in properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'style': {'fontSize': 16, 'fontWeight': 'bold'},
      });

      expect(widget.properties['style'], isA<Map>());
      expect(widget.properties['style']['fontSize'], equals(16));
      expect(widget.properties['style']['fontWeight'], equals('bold'));
    });

    // Boundary
    test('empty style map is preserved', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'style': {},
      });

      expect(widget.properties['style'], isA<Map>());
      expect((widget.properties['style'] as Map).isEmpty, isTrue);
    });

    test('style roundtrips through toJson/fromJson', () {
      final original = WidgetDefinition.fromJson({
        'type': 'text',
        'style': {'color': '#FF0000', 'fontSize': 14},
      });
      final restored = WidgetDefinition.fromJson(original.toJson());

      expect(restored.properties['style'], equals(original.properties['style']));
    });
  });

  // TC-005: accessibility — AccessibilityConfig
  group('TC-005: accessibility', () {
    // Normal
    test('AccessibilityConfig with semanticLabel, hint, role, liveRegion', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'button',
        'accessibility': {
          'semanticLabel': 'Submit form',
          'semanticHint': 'Double tap to submit',
          'role': 'button',
          'liveRegion': 'polite',
        },
      });

      expect(widget.accessibility, isNotNull);
      expect(widget.accessibility!.semanticLabel, equals('Submit form'));
      expect(widget.accessibility!.semanticHint, equals('Double tap to submit'));
      expect(widget.accessibility!.role, equals('button'));
      expect(widget.accessibility!.liveRegion, equals('polite'));
    });

    test('AccessibilityConfig with focusable and excludeFromSemantics', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'accessibility': {
          'focusable': true,
          'excludeFromSemantics': false,
        },
      });

      expect(widget.accessibility!.focusable, isTrue);
      expect(widget.accessibility!.excludeFromSemantics, isFalse);
    });

    test('AccessibilityConfig with short aliases (label, description)', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'accessibility': {
          'label': 'Short label alias',
          'description': 'Short hint alias',
          'live': 'assertive',
        },
      });

      expect(widget.accessibility!.semanticLabel, equals('Short label alias'));
      expect(widget.accessibility!.semanticHint, equals('Short hint alias'));
      expect(widget.accessibility!.liveRegion, equals('assertive'));
    });

    // Boundary
    test('accessibility is null when not provided', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
      });

      expect(widget.accessibility, isNull);
    });

    test('empty accessibility config has no settings', () {
      final config = AccessibilityConfig();

      expect(config.hasAccessibilitySettings, isFalse);
    });

    test('accessibility roundtrips through toJson/fromJson', () {
      final original = WidgetDefinition.fromJson({
        'type': 'button',
        'accessibility': {
          'semanticLabel': 'OK',
          'role': 'button',
          'liveRegion': 'polite',
          'focusable': true,
        },
      });
      final restored = WidgetDefinition.fromJson(original.toJson());

      expect(restored.accessibility, equals(original.accessibility));
    });
  });

  // TC-006: Event naming convention (kebab-case)
  group('TC-006: Event naming convention', () {
    // Normal
    test('onTap event property stored in properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'button',
        'onTap': 'handleClick',
      });

      expect(widget.properties['onTap'], equals('handleClick'));
    });

    test('on-change event property stored in properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'textInput',
        'on-change': 'handleChange',
      });

      expect(widget.properties['on-change'], equals('handleChange'));
    });

    test('multiple kebab-case event properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'button',
        'onTap': 'doClick',
        'on-long-press': 'doLongPress',
        'on-hover': 'doHover',
      });

      expect(widget.properties['onTap'], equals('doClick'));
      expect(widget.properties['on-long-press'], equals('doLongPress'));
      expect(widget.properties['on-hover'], equals('doHover'));
    });

    // Boundary
    test('event properties with map values', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'button',
        'onTap': {
          'action': 'navigate',
          'target': '/home',
        },
      });

      expect(widget.properties['onTap'], isA<Map>());
      expect(widget.properties['onTap']['action'], equals('navigate'));
    });

    test('event properties roundtrip through toJson/fromJson', () {
      final original = WidgetDefinition.fromJson({
        'type': 'button',
        'onTap': 'submit',
        'on-hover': 'highlight',
      });
      final restored = WidgetDefinition.fromJson(original.toJson());

      expect(restored.properties['onTap'], equals('submit'));
      expect(restored.properties['on-hover'], equals('highlight'));
    });
  });
}
