// TC-067 ~ TC-069: TemplateDefinition Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-067: TemplateDefinition.fromJson
  // =========================================================================
  group('TC-067: TemplateDefinition.fromJson', () {
    test('Normal: parse all fields', () {
      final json = {
        'name': 'card',
        'description': 'A reusable card template',
        'params': {
          'title': {'type': 'string', 'required': true},
          'subtitle': {'type': 'string', 'default': ''},
        },
        'content': {'type': 'box', 'child': {'type': 'text', 'content': '{{title}}'}},
        'slots': ['header', 'footer'],
        'defaults': {'subtitle': 'Default subtitle'},
      };

      final def = TemplateDefinition.fromJson(json);
      expect(def.name, equals('card'));
      expect(def.description, equals('A reusable card template'));
      expect(def.params, isNotNull);
      expect(def.params!['title']!.type, equals('string'));
      expect(def.params!['title']!.required, isTrue);
      expect(def.params!['subtitle']!.defaultValue, equals(''));
      expect(def.content['type'], equals('box'));
      expect(def.slots, equals(['header', 'footer']));
      expect(def.defaults, equals({'subtitle': 'Default subtitle'}));
    });

    test('Boundary: only name and body required', () {
      final json = {
        'name': 'minimal',
        'content': {'type': 'text', 'content': 'Hello'},
      };

      final def = TemplateDefinition.fromJson(json);
      expect(def.name, equals('minimal'));
      expect(def.description, isNull);
      expect(def.params, isNull);
      expect(def.slots, isNull);
      expect(def.defaults, isNull);
    });

    test('Boundary: short form params (type string only)', () {
      final json = {
        'name': 'simple',
        'params': {
          'title': 'string',
        },
        'content': {'type': 'text'},
      };

      final def = TemplateDefinition.fromJson(json);
      expect(def.params!['title']!.type, equals('string'));
    });
  });

  // =========================================================================
  // TC-068: TemplateParam.fromJson
  // =========================================================================
  group('TC-068: TemplateParam.fromJson', () {
    test('Normal: parse type, required, defaultValue, description', () {
      final json = {
        'type': 'string',
        'required': true,
        'default': 'Hello',
        'description': 'The greeting text',
      };

      final param = TemplateParam.fromJson(json);
      expect(param.type, equals('string'));
      expect(param.required, isTrue);
      expect(param.defaultValue, equals('Hello'));
      expect(param.description, equals('The greeting text'));
    });

    test('Boundary: required defaults to false', () {
      final json = {'type': 'number'};
      final param = TemplateParam.fromJson(json);
      expect(param.required, isFalse);
    });

    test('Boundary: type is optional', () {
      final json = <String, dynamic>{'required': true};
      final param = TemplateParam.fromJson(json);
      expect(param.type, isNull);
      expect(param.required, isTrue);
    });

    test('Normal: all param types', () {
      for (final type in ['string', 'number', 'boolean', 'object', 'array', 'widget']) {
        final param = TemplateParam.fromJson({'type': type});
        expect(param.type, equals(type));
      }
    });
  });

  // =========================================================================
  // TC-069: TemplateDefinition.validate
  // =========================================================================
  group('TC-069: TemplateDefinition.validate', () {
    test('Normal: valid args matching param specs returns empty errors', () {
      final def = TemplateDefinition.fromJson({
        'name': 'card',
        'params': {
          'title': {'type': 'string', 'required': true},
          'count': {'type': 'number'},
        },
        'content': {'type': 'text'},
      });

      final errors = def.validate({'title': 'Hello', 'count': 5});
      expect(errors, isEmpty);
    });

    test('Boundary: missing optional params accepted', () {
      final def = TemplateDefinition.fromJson({
        'name': 'card',
        'params': {
          'title': {'type': 'string', 'required': true},
          'subtitle': {'type': 'string'},
        },
        'content': {'type': 'text'},
      });

      final errors = def.validate({'title': 'Hello'});
      expect(errors, isEmpty);
    });

    test('Error: missing required param returns error', () {
      final def = TemplateDefinition.fromJson({
        'name': 'card',
        'params': {
          'title': {'type': 'string', 'required': true},
        },
        'content': {'type': 'text'},
      });

      final errors = def.validate({});
      expect(errors, isNotEmpty);
      expect(errors.first, contains('title'));
    });

    test('Error: wrong type returns error', () {
      final def = TemplateDefinition.fromJson({
        'name': 'card',
        'params': {
          'count': {'type': 'number', 'required': true},
        },
        'content': {'type': 'text'},
      });

      final errors = def.validate({'count': 'not-a-number'});
      expect(errors, isNotEmpty);
      expect(errors.first, contains('count'));
    });

    test('Boundary: defaults used when arg not provided', () {
      final def = TemplateDefinition(
        name: 'card',
        params: {
          'title': TemplateParam(type: 'string', required: true),
        },
        content: {'type': 'text'},
        defaults: {'title': 'Default Title'},
      );

      // title not in args, but available in defaults
      final errors = def.validate({});
      expect(errors, isEmpty);
    });
  });
}
