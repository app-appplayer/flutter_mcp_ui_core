// TC-050 ~ TC-052: AccessibilityConfig Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-050: AccessibilityConfig.fromJson
  // =========================================================================
  group('TC-050: AccessibilityConfig.fromJson', () {
    test('Normal: parse all 13 fields', () {
      final json = {
        'semanticLabel': 'Submit button',
        'semanticHint': 'Double tap to submit the form',
        'role': 'button',
        'excludeFromSemantics': false,
        'focusable': true,
        'focusOrder': ['field1', 'field2', 'submit'],
        'focusTrap': true,
        'initialFocus': 'field1',
        'restoreFocus': true,
        'liveRegion': 'polite',
        'atomic': false,
        'properties': {
          'expanded': true,
          'pressed': false,
        },
        'wcag': {
          'level': 'AA',
          'guidelines': ['1.1.1', '1.4.3'],
        },
      };

      final config = AccessibilityConfig.fromJson(json);
      expect(config.semanticLabel, equals('Submit button'));
      expect(config.semanticHint, equals('Double tap to submit the form'));
      expect(config.role, equals('button'));
      expect(config.excludeFromSemantics, isFalse);
      expect(config.focusable, isTrue);
      expect(config.focusOrder, equals(['field1', 'field2', 'submit']));
      expect(config.focusTrap, isTrue);
      expect(config.initialFocus, equals('field1'));
      expect(config.restoreFocus, isTrue);
      expect(config.liveRegion, equals('polite'));
      expect(config.atomic, isFalse);
      expect(config.properties, isNotNull);
      expect(config.properties!.expanded, isTrue);
      expect(config.wcag, isNotNull);
      expect(config.wcag!.level, equals('AA'));
    });

    test('Boundary: short aliases accepted (label, description, live)', () {
      final json = {
        'label': 'My Label',
        'description': 'My Hint',
        'live': 'assertive',
      };

      final config = AccessibilityConfig.fromJson(json);
      expect(config.semanticLabel, equals('My Label'));
      expect(config.semanticHint, equals('My Hint'));
      expect(config.liveRegion, equals('assertive'));
    });

    test('Boundary: liveRegion values polite, assertive, off', () {
      for (final value in ['polite', 'assertive', 'off']) {
        final config = AccessibilityConfig.fromJson({'liveRegion': value});
        expect(config.liveRegion, equals(value));
      }
    });

    test('Error: invalid role value handled gracefully', () {
      final json = {'role': 'invalid_role'};
      // Should parse without exception
      final config = AccessibilityConfig.fromJson(json);
      expect(config.role, equals('invalid_role'));
    });
  });

  // =========================================================================
  // TC-051: AccessibilityProperties.fromJson
  // =========================================================================
  group('TC-051: AccessibilityProperties.fromJson', () {
    test('Normal: parse all 20 fields', () {
      final json = {
        'level': 2,
        'expanded': true,
        'selected': false,
        'disabled': false,
        'readonly': true,
        'required': true,
        'checked': false,
        'pressed': true,
        'valueMin': 0,
        'valueMax': 100,
        'valueNow': 50,
        'valueText': '50%',
        'multiSelectable': true,
        'orientation': 'horizontal',
        'sort': 'ascending',
        'autoComplete': 'both',
        'hasPopup': true,
        'invalid': 'false',
        'hidden': false,
        'busy': false,
      };

      final props = AccessibilityProperties.fromJson(json);
      expect(props.level, equals(2));
      expect(props.expanded, isTrue);
      expect(props.selected, isFalse);
      expect(props.disabled, isFalse);
      expect(props.readonly, isTrue);
      expect(props.required, isTrue);
      expect(props.checked, isFalse);
      expect(props.pressed, isTrue);
      expect(props.valueMin, equals(0));
      expect(props.valueMax, equals(100));
      expect(props.valueNow, equals(50));
      expect(props.valueText, equals('50%'));
      expect(props.multiSelectable, isTrue);
      expect(props.orientation, equals('horizontal'));
      expect(props.sort, equals('ascending'));
      expect(props.autoComplete, equals('both'));
      expect(props.hasPopup, isTrue);
      expect(props.invalid, equals('false'));
      expect(props.hidden, isFalse);
      expect(props.busy, isFalse);
    });

    test('Boundary: orientation values', () {
      for (final value in ['horizontal', 'vertical']) {
        final props = AccessibilityProperties.fromJson({'orientation': value});
        expect(props.orientation, equals(value));
      }
    });

    test('Boundary: sort values', () {
      for (final value in ['ascending', 'descending', 'none']) {
        final props = AccessibilityProperties.fromJson({'sort': value});
        expect(props.sort, equals(value));
      }
    });

    test('Boundary: autoComplete values', () {
      for (final value in ['inline', 'list', 'both', 'none']) {
        final props = AccessibilityProperties.fromJson({'autoComplete': value});
        expect(props.autoComplete, equals(value));
      }
    });

    test('Boundary: invalid values', () {
      for (final value in ['grammar', 'spelling', 'true', 'false']) {
        final props = AccessibilityProperties.fromJson({'invalid': value});
        expect(props.invalid, equals(value));
      }
    });

    test('Error: level outside 1-6 range handled gracefully', () {
      final props = AccessibilityProperties.fromJson({'level': 10});
      expect(props.level, equals(10));
    });
  });

  // =========================================================================
  // TC-052: WcagCompliance.fromJson
  // =========================================================================
  group('TC-052: WcagCompliance.fromJson', () {
    test('Normal: parse level AA and guidelines', () {
      final json = {
        'level': 'AA',
        'guidelines': ['1.1.1', '1.4.3'],
      };

      final wcag = WcagCompliance.fromJson(json);
      expect(wcag.level, equals('AA'));
      expect(wcag.guidelines, equals(['1.1.1', '1.4.3']));
    });

    test('Boundary: level values A, AA, AAA', () {
      for (final level in ['A', 'AA', 'AAA']) {
        final wcag = WcagCompliance.fromJson({'level': level});
        expect(wcag.level, equals(level));
      }
    });

    test('Boundary: empty guidelines list', () {
      final wcag = WcagCompliance.fromJson({'level': 'A', 'guidelines': []});
      expect(wcag.guidelines, isEmpty);
    });

    test('Boundary: missing guidelines defaults to empty', () {
      final wcag = WcagCompliance.fromJson({'level': 'AA'});
      expect(wcag.guidelines, isEmpty);
    });

    test('Error: invalid level value handled gracefully', () {
      // Should parse without exception since level is just a String
      final wcag = WcagCompliance.fromJson({'level': 'INVALID'});
      expect(wcag.level, equals('INVALID'));
    });
  });
}
