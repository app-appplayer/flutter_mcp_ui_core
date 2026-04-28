// TC-053 ~ TC-059: I18nConfig Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-053: I18nConfig.fromJson - canonical (nested) format
  // =========================================================================
  group('TC-053: I18nConfig.fromJson - canonical (nested) format', () {
    test('Normal: parse canonical format with all sub-objects', () {
      final json = {
        'text': {
          'key': 'greeting',
          'default': 'Hello, World',
          'params': {'name': 'World'},
        },
        'pluralization': {
          'key': 'item_count',
          'count': '{{count}}',
          'zero': 'No items',
          'one': '1 item',
          'other': '{{count}} items',
        },
        'formatting': {
          'number': {
            'value': 1234.56,
            'style': 'currency',
            'currency': 'USD',
          },
          'date': {
            'value': '2024-01-01',
            'style': 'long',
          },
        },
      };

      final config = I18nConfig.fromJson(json);
      expect(config.text, isNotNull);
      expect(config.text!.key, equals('greeting'));
      expect(config.text!.defaultText, equals('Hello, World'));
      expect(config.pluralization, isNotNull);
      expect(config.pluralization!.key, equals('item_count'));
      expect(config.numberFormat, isNotNull);
      expect(config.numberFormat!.style, equals('currency'));
      expect(config.dateFormat, isNotNull);
      expect(config.dateFormat!.style, equals('long'));
    });

    test('Boundary: only text present, others null', () {
      final json = {
        'text': {
          'key': 'greeting',
          'default': 'Hello',
        },
      };

      final config = I18nConfig.fromJson(json);
      expect(config.text, isNotNull);
      expect(config.pluralization, isNull);
      expect(config.numberFormat, isNull);
      expect(config.dateFormat, isNull);
    });
  });

  // =========================================================================
  // TC-054: I18nConfig.fromJson - compatibility (flat) format
  // =========================================================================
  group('TC-054: I18nConfig.fromJson - compatibility (flat) format', () {
    test('Normal: parse flat format auto-detected by top-level key', () {
      final json = {
        'key': 'greeting',
        'fallback': 'Hello, {{name}}',
        'params': {'name': 'World'},
      };

      final config = I18nConfig.fromJson(json);
      expect(config.text, isNotNull);
      expect(config.text!.key, equals('greeting'));
      expect(config.text!.defaultText, equals('Hello, {{name}}'));
      expect(config.text!.params, equals({'name': 'World'}));
    });

    test('Boundary: default accepted as alias for fallback', () {
      final json = {
        'key': 'greeting',
        'default': 'Hello',
      };

      final config = I18nConfig.fromJson(json);
      expect(config.text!.defaultText, equals('Hello'));
    });
  });

  // =========================================================================
  // TC-055: I18nConfig.toJson - canonical normalization
  // =========================================================================
  group('TC-055: I18nConfig.toJson - canonical normalization', () {
    test('Normal: toJson always outputs canonical (nested) format', () {
      final config = I18nConfig(
        text: I18nText(key: 'greeting', defaultText: 'Hello'),
      );

      final json = config.toJson();
      expect(json.containsKey('text'), isTrue);
      expect(json['text']['key'], equals('greeting'));
      expect(json['text']['default'], equals('Hello'));
    });

    test('Boundary: flat input normalizes to nested output on round-trip', () {
      final flatJson = {
        'key': 'greeting',
        'fallback': 'Hello, {{name}}',
        'params': {'name': 'World'},
      };

      final config = I18nConfig.fromJson(flatJson);
      final output = config.toJson();

      // Output is always nested/canonical
      expect(output.containsKey('text'), isTrue);
      expect(output['text']['key'], equals('greeting'));
      expect(output.containsKey('key'), isFalse);
    });
  });

  // =========================================================================
  // TC-056: I18nText.fromJson
  // =========================================================================
  group('TC-056: I18nText.fromJson', () {
    test('Normal: parse key, defaultText, params', () {
      final json = {
        'key': 'welcome',
        'default': 'Welcome, {{user}}',
        'params': {'user': 'Alice'},
      };

      final text = I18nText.fromJson(json);
      expect(text.key, equals('welcome'));
      expect(text.defaultText, equals('Welcome, {{user}}'));
      expect(text.params, equals({'user': 'Alice'}));
    });

    test('Boundary: empty params map', () {
      final json = {
        'key': 'hello',
        'default': 'Hello',
        'params': {},
      };

      final text = I18nText.fromJson(json);
      expect(text.params, isEmpty);
    });

    test('Boundary: missing params defaults to empty', () {
      final json = {
        'key': 'hello',
        'default': 'Hello',
      };

      final text = I18nText.fromJson(json);
      expect(text.params, isEmpty);
    });
  });

  // =========================================================================
  // TC-057: I18nPluralization.fromJson
  // =========================================================================
  group('TC-057: I18nPluralization.fromJson', () {
    test('Normal: parse all plural forms', () {
      final json = {
        'key': 'item_count',
        'count': '{{itemCount}}',
        'zero': 'No items',
        'one': '1 item',
        'two': '2 items',
        'few': 'A few items',
        'many': 'Many items',
        'other': '{{count}} items',
      };

      final plural = I18nPluralization.fromJson(json);
      expect(plural.key, equals('item_count'));
      expect(plural.count, equals('{{itemCount}}'));
      expect(plural.zero, equals('No items'));
      expect(plural.one, equals('1 item'));
      expect(plural.two, equals('2 items'));
      expect(plural.few, equals('A few items'));
      expect(plural.many, equals('Many items'));
      expect(plural.other, equals('{{count}} items'));
    });

    test('Boundary: only key, count, and other (required fallback)', () {
      final json = {
        'key': 'item_count',
        'count': 5,
        'other': '{{count}} items',
      };

      final plural = I18nPluralization.fromJson(json);
      expect(plural.key, equals('item_count'));
      expect(plural.count, equals(5));
      expect(plural.other, equals('{{count}} items'));
      expect(plural.zero, isNull);
      expect(plural.one, isNull);
      expect(plural.two, isNull);
      expect(plural.few, isNull);
      expect(plural.many, isNull);
    });

    test('Error: missing other throws', () {
      final json = {
        'key': 'item_count',
        'count': 5,
      };
      expect(() => I18nPluralization.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  // =========================================================================
  // TC-058: I18nNumberFormat.fromJson
  // =========================================================================
  group('TC-058: I18nNumberFormat.fromJson', () {
    test('Normal: parse all fields', () {
      final json = {
        'value': 1234.56,
        'style': 'currency',
        'currency': 'USD',
        'currencyDisplay': 'symbol',
        'unit': 'kilogram',
        'unitDisplay': 'short',
        'minimumIntegerDigits': 1,
        'minimumFractionDigits': 2,
        'maximumFractionDigits': 2,
        'minimumSignificantDigits': 1,
        'maximumSignificantDigits': 5,
      };

      final fmt = I18nNumberFormat.fromJson(json);
      expect(fmt.value, equals(1234.56));
      expect(fmt.style, equals('currency'));
      expect(fmt.currency, equals('USD'));
      expect(fmt.currencyDisplay, equals('symbol'));
      expect(fmt.unit, equals('kilogram'));
      expect(fmt.unitDisplay, equals('short'));
      expect(fmt.minimumIntegerDigits, equals(1));
      expect(fmt.minimumFractionDigits, equals(2));
      expect(fmt.maximumFractionDigits, equals(2));
      expect(fmt.minimumSignificantDigits, equals(1));
      expect(fmt.maximumSignificantDigits, equals(5));
    });

    test('Boundary: only value provided', () {
      final json = {'value': 42};
      final fmt = I18nNumberFormat.fromJson(json);
      expect(fmt.value, equals(42));
      expect(fmt.style, isNull);
      expect(fmt.currency, isNull);
    });
  });

  // =========================================================================
  // TC-059: I18nDateFormat.fromJson
  // =========================================================================
  group('TC-059: I18nDateFormat.fromJson', () {
    test('Normal: parse all fields', () {
      final json = {
        'value': '2024-01-01T00:00:00Z',
        'style': 'long',
        'dateStyle': 'full',
        'timeStyle': 'short',
        'pattern': 'yyyy-MM-dd',
        'timeZone': 'America/New_York',
        'hour24': true,
      };

      final fmt = I18nDateFormat.fromJson(json);
      expect(fmt.value, equals('2024-01-01T00:00:00Z'));
      expect(fmt.style, equals('long'));
      expect(fmt.dateStyle, equals('full'));
      expect(fmt.timeStyle, equals('short'));
      expect(fmt.pattern, equals('yyyy-MM-dd'));
      expect(fmt.timeZone, equals('America/New_York'));
      expect(fmt.hour24, isTrue);
    });

    test('Boundary: only value and pattern provided', () {
      final json = {
        'value': '2024-06-15',
        'pattern': 'yyyy-MM-dd',
      };

      final fmt = I18nDateFormat.fromJson(json);
      expect(fmt.value, equals('2024-06-15'));
      expect(fmt.pattern, equals('yyyy-MM-dd'));
      expect(fmt.style, isNull);
      expect(fmt.dateStyle, isNull);
      expect(fmt.timeStyle, isNull);
    });
  });
}
