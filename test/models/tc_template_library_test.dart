// TemplateLibrary Tests — remote template library reference (v1.3)
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TemplateLibrary.fromJson — all fields
  // =========================================================================
  group('TemplateLibrary.fromJson', () {
    test('Normal: parse all fields', () {
      final lib = TemplateLibrary.fromJson({
        'url': 'https://cdn.example.com/templates/material.json',
        'name': 'material-components',
        'version': '2.1.0',
        'templates': [
          {
            'name': 'card',
            'body': {'type': 'box', 'child': {'type': 'text'}},
          },
          {
            'name': 'header',
            'body': {'type': 'text', 'properties': {'content': 'Header'}},
          },
        ],
      });
      expect(lib.url, equals('https://cdn.example.com/templates/material.json'));
      expect(lib.name, equals('material-components'));
      expect(lib.version, equals('2.1.0'));
      expect(lib.templates, isNotNull);
      expect(lib.templates!.length, equals(2));
      expect(lib.templates![0].name, equals('card'));
      expect(lib.templates![1].name, equals('header'));
    });

    test('Boundary: only url required, optional fields null', () {
      final lib = TemplateLibrary.fromJson({
        'url': 'https://cdn.example.com/lib.json',
      });
      expect(lib.url, equals('https://cdn.example.com/lib.json'));
      expect(lib.name, isNull);
      expect(lib.version, isNull);
      expect(lib.templates, isNull);
    });

    test('Normal: url with name but no version or templates', () {
      final lib = TemplateLibrary.fromJson({
        'url': 'https://example.com/widgets.json',
        'name': 'my-lib',
      });
      expect(lib.name, equals('my-lib'));
      expect(lib.version, isNull);
      expect(lib.templates, isNull);
    });
  });

  // =========================================================================
  // TemplateLibrary.toJson
  // =========================================================================
  group('TemplateLibrary.toJson', () {
    test('Normal: full round-trip', () {
      final original = TemplateLibrary.fromJson({
        'url': 'https://cdn.example.com/templates.json',
        'name': 'design-system',
        'version': '1.0.0',
        'templates': [
          {
            'name': 'button',
            'body': {'type': 'button', 'properties': {'label': 'Click'}},
          },
        ],
      });

      final json = original.toJson();
      final restored = TemplateLibrary.fromJson(json);

      expect(restored.url, equals(original.url));
      expect(restored.name, equals(original.name));
      expect(restored.version, equals(original.version));
      expect(restored.templates!.length, equals(original.templates!.length));
    });

    test('Boundary: optional fields omitted from JSON when null', () {
      final lib = TemplateLibrary(url: 'https://example.com/lib.json');
      final json = lib.toJson();
      expect(json['url'], equals('https://example.com/lib.json'));
      expect(json.containsKey('name'), isFalse);
      expect(json.containsKey('version'), isFalse);
      expect(json.containsKey('templates'), isFalse);
    });

    test('Normal: toJson includes all non-null fields', () {
      final lib = TemplateLibrary(
        url: 'https://example.com/lib.json',
        name: 'test-lib',
        version: '0.5.0',
      );
      final json = lib.toJson();
      expect(json['url'], equals('https://example.com/lib.json'));
      expect(json['name'], equals('test-lib'));
      expect(json['version'], equals('0.5.0'));
    });
  });

  // =========================================================================
  // TemplateLibrary — basic construction and equality
  // =========================================================================
  group('TemplateLibrary construction and equality', () {
    test('Normal: const constructor', () {
      const lib = TemplateLibrary(
        url: 'https://example.com/lib.json',
        name: 'test',
        version: '1.0',
      );
      expect(lib.url, equals('https://example.com/lib.json'));
      expect(lib.name, equals('test'));
      expect(lib.version, equals('1.0'));
      expect(lib.templates, isNull);
    });

    test('Normal: equality based on url, name, version', () {
      final a = TemplateLibrary(
        url: 'https://example.com/lib.json',
        name: 'test',
        version: '1.0',
      );
      final b = TemplateLibrary(
        url: 'https://example.com/lib.json',
        name: 'test',
        version: '1.0',
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Boundary: inequality when url differs', () {
      final a = TemplateLibrary(url: 'https://a.com/lib.json');
      final b = TemplateLibrary(url: 'https://b.com/lib.json');
      expect(a, isNot(equals(b)));
    });

    test('Normal: copyWith creates modified copy', () {
      final original = TemplateLibrary(
        url: 'https://example.com/lib.json',
        name: 'original',
        version: '1.0',
      );
      final modified = original.copyWith(name: 'modified', version: '2.0');
      expect(modified.url, equals(original.url));
      expect(modified.name, equals('modified'));
      expect(modified.version, equals('2.0'));
    });

    test('Normal: toString contains url and name', () {
      final lib = TemplateLibrary(
        url: 'https://example.com/lib.json',
        name: 'test',
      );
      final str = lib.toString();
      expect(str, contains('https://example.com/lib.json'));
      expect(str, contains('test'));
    });
  });

  // =========================================================================
  // TemplateLibrary in ApplicationDefinition
  // =========================================================================
  group('TemplateLibrary in ApplicationDefinition', () {
    test('Normal: ApplicationDefinition parses templateLibraries', () {
      final appDef = ApplicationDefinition.fromJson({
        'type': 'application',
        'title': 'Test App',
        'version': '1.3',
        'initialRoute': '/',
        'routes': {'/': 'resource://main'},
        'templateLibraries': [
          {
            'url': 'https://cdn.example.com/material.json',
            'name': 'material',
            'version': '1.0.0',
          },
          {
            'url': 'https://cdn.example.com/custom.json',
            'name': 'custom',
          },
        ],
      });
      expect(appDef.templateLibraries, isNotNull);
      expect(appDef.templateLibraries!.length, equals(2));
      expect(appDef.templateLibraries![0].name, equals('material'));
      expect(appDef.templateLibraries![1].name, equals('custom'));
    });

    test('Boundary: templateLibraries null when not specified', () {
      final appDef = ApplicationDefinition.fromJson({
        'type': 'application',
        'title': 'Test',
        'version': '1.0',
        'initialRoute': '/',
        'routes': {'/': 'resource://main'},
      });
      expect(appDef.templateLibraries, isNull);
    });

    test('Normal: templateLibraries round-trip via toJson/fromJson', () {
      final appDef = ApplicationDefinition.fromJson({
        'type': 'application',
        'title': 'Test',
        'version': '1.3',
        'initialRoute': '/',
        'routes': {'/': 'resource://main'},
        'templateLibraries': [
          {
            'url': 'https://example.com/lib.json',
            'name': 'lib',
            'version': '1.0',
          },
        ],
      });
      final json = appDef.toJson();
      final restored = ApplicationDefinition.fromJson(json);
      expect(restored.templateLibraries!.length, equals(1));
      expect(restored.templateLibraries![0].url,
          equals('https://example.com/lib.json'));
    });
  });
}
