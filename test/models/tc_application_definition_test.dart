// TC-015 ~ TC-018: ApplicationDefinition Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-015: ApplicationDefinition.fromJson — all fields
  // =========================================================================
  group('TC-015: ApplicationDefinition.fromJson — all fields', () {
    test('Normal: parse complete JSON with all fields', () {
      final json = {
        'type': 'application',
        'title': 'My App',
        'version': '1.0.0',
        'initialRoute': '/home',
        'routes': {'/home': 'home.json', '/settings': 'settings.json'},
        'theme': {'mode': 'light'},
        'navigation': {
          'type': 'bottomNavigation',
          'items': [
            {'title': 'Home', 'route': '/home', 'icon': 'home'},
          ],
        },
        'state': {
          'initial': {'counter': 0}
        },
        'lifecycle': {'onInit': 'init'},
        'services': {'api': 'https://api.example.com'},
        'id': 'com.example.myapp',
        'description': 'A test app',
        'icon': 'bundle://icon.png',
        'category': 'productivity',
        'timestamps': {
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-06-01T00:00:00.000Z',
        },
        'screenshots': ['screenshot1.png', 'screenshot2.png'],
        'templates': {
          'myTemplate': {
            'content': {'type': 'text', 'content': 'hello'},
          },
        },
        'i18n': {
          'defaultLocale': 'en',
          'supportedLocales': ['en', 'ko', 'ja'],
          'fallbackLocale': 'en',
        },
      };

      final def = ApplicationDefinition.fromJson(json);
      expect(def.type, equals('application'));
      expect(def.title, equals('My App'));
      expect(def.version, equals('1.0.0'));
      expect(def.initialRoute, equals('/home'));
      expect(def.routes, hasLength(2));
      expect(def.theme, isNotNull);
      expect(def.navigation, isNotNull);
      expect(def.initialState, equals({'counter': 0}));
      expect(def.lifecycle, isNotNull);
      expect(def.services, isNotNull);
      expect(def.id, equals('com.example.myapp'));
      expect(def.description, equals('A test app'));
      expect(def.icon, equals('bundle://icon.png'));
      expect(def.category, equals('productivity'));
      expect(def.timestamps, isNotNull);
      expect(def.screenshots, hasLength(2));
      expect(def.templates, isNotNull);
      expect(def.templates!['myTemplate'], isNotNull);
      expect(def.defaultLocale, equals('en'));
      expect(def.supportedLocales, equals(['en', 'ko', 'ja']));
      expect(def.fallbackLocale, equals('en'));
    });

    test('Boundary: parse with only required fields', () {
      final json = {
        'type': 'application',
        'title': 'Minimal App',
        'version': '1.0',
        'initialRoute': '/',
        'routes': {'/': 'main.json'},
      };

      final def = ApplicationDefinition.fromJson(json);
      expect(def.title, equals('Minimal App'));
      expect(def.theme, isNull);
      expect(def.navigation, isNull);
      expect(def.initialState, isNull);
      expect(def.id, isNull);
      expect(def.description, isNull);
      expect(def.templates, isNull);
      expect(def.defaultLocale, isNull);
      expect(def.supportedLocales, isNull);
      expect(def.screenshots, isNull);
    });

    test('Error: missing required field type defaults to application', () {
      final json = {
        'title': 'No Type',
        'version': '1.0',
        'routes': {'/': 'main.json'},
      };
      final def = ApplicationDefinition.fromJson(json);
      expect(def.type, equals('application'));
    });
  });

  // =========================================================================
  // TC-016: ApplicationDefinition.fromJson — v1.2 metadata
  // =========================================================================
  group('TC-016: ApplicationDefinition.fromJson — v1.2 metadata', () {
    test('Normal: parse v1.2 metadata fields', () {
      final json = {
        'type': 'application',
        'title': 'V12 App',
        'version': '1.2.0',
        'routes': {'/': 'main.json'},
        'id': 'com.example.v12',
        'description': 'V1.2 app',
        'icon': 'data:image/png;base64,abc',
        'category': 'tools',
        'timestamps': {
          'createdAt': '2024-01-01T00:00:00.000Z',
        },
        'screenshots': ['s1.png'],
      };

      final def = ApplicationDefinition.fromJson(json);
      expect(def.id, equals('com.example.v12'));
      expect(def.icon, startsWith('data:image/png'));
      expect(def.category, equals('tools'));
      expect(def.timestamps!.createdAt, isNotNull);
    });

    test('Boundary: all v1.2 fields omitted for backward compatibility', () {
      final json = {
        'type': 'application',
        'title': 'Old App',
        'version': '1.0',
        'routes': {'/': 'main.json'},
      };
      final def = ApplicationDefinition.fromJson(json);
      expect(def.id, isNull);
      expect(def.description, isNull);
      expect(def.icon, isNull);
      expect(def.splash, isNull);
      expect(def.category, isNull);
      expect(def.publisher, isNull);
      expect(def.timestamps, isNull);
      expect(def.screenshots, isNull);
    });
  });

  // =========================================================================
  // TC-017: ApplicationDefinition.fromJson — i18n and templates
  // =========================================================================
  group('TC-017: ApplicationDefinition.fromJson — i18n and templates', () {
    test('Normal: parse i18n and templates', () {
      final json = {
        'type': 'application',
        'title': 'i18n App',
        'version': '1.0',
        'routes': {'/': 'main.json'},
        'i18n': {
          'defaultLocale': 'en',
          'supportedLocales': ['en', 'ko', 'ja'],
          'fallbackLocale': 'en',
        },
        'templates': {
          'card': {
            'content': {'type': 'box'},
            'params': {
              'title': {'type': 'string', 'required': true},
            },
          },
        },
      };

      final def = ApplicationDefinition.fromJson(json);
      expect(def.defaultLocale, equals('en'));
      expect(def.supportedLocales, equals(['en', 'ko', 'ja']));
      expect(def.fallbackLocale, equals('en'));
      expect(def.templates, isNotNull);
      expect(def.templates!['card']!.name, equals('card'));
    });

    test('Boundary: no i18n or templates', () {
      final json = {
        'type': 'application',
        'title': 'Minimal',
        'version': '1.0',
        'routes': {'/': 'main.json'},
      };
      final def = ApplicationDefinition.fromJson(json);
      expect(def.defaultLocale, isNull);
      expect(def.supportedLocales, isNull);
      expect(def.templates, isNull);
    });
  });

  // =========================================================================
  // TC-018: ApplicationDefinition.toJson
  // =========================================================================
  group('TC-018: ApplicationDefinition.toJson', () {
    test('Normal: round-trip preserves all fields', () {
      final original = ApplicationDefinition(
        title: 'RT App',
        version: '1.0',
        routes: {'/': 'main.json'},
        initialState: {'count': 0},
        defaultLocale: 'en',
        supportedLocales: ['en', 'ko'],
        fallbackLocale: 'en',
      );

      final json = original.toJson();
      final restored = ApplicationDefinition.fromJson(json);

      expect(restored.title, equals(original.title));
      expect(restored.initialState, equals(original.initialState));
      expect(restored.defaultLocale, equals(original.defaultLocale));
      expect(restored.supportedLocales, equals(original.supportedLocales));
    });

    test('Boundary: initialState serialized as state.initial', () {
      final def = ApplicationDefinition(
        title: 'State App',
        version: '1.0',
        routes: {'/': 'main.json'},
        initialState: {'x': 1},
      );

      final json = def.toJson();
      expect(json.containsKey('state'), isTrue);
      expect((json['state'] as Map)['initial'], equals({'x': 1}));
      expect(json.containsKey('initialState'), isFalse);
    });

    test('Boundary: null optional fields omitted from JSON', () {
      final def = ApplicationDefinition(
        title: 'Minimal',
        version: '1.0',
        routes: {'/': 'main.json'},
      );

      final json = def.toJson();
      expect(json.containsKey('theme'), isFalse);
      expect(json.containsKey('navigation'), isFalse);
      expect(json.containsKey('state'), isFalse);
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('screenshots'), isFalse);
    });

    test('Boundary: screenshots omitted when empty', () {
      final def = ApplicationDefinition(
        title: 'Empty SS',
        version: '1.0',
        routes: {'/': 'main.json'},
        screenshots: [],
      );
      final json = def.toJson();
      expect(json.containsKey('screenshots'), isFalse);
    });
  });
}
