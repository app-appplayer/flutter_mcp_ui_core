// TC-019 ~ TC-021: PageDefinition Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-019: PageDefinition.fromJson — all fields
  // =========================================================================
  group('TC-019: PageDefinition.fromJson — all fields', () {
    test('Normal: parse page with all fields', () {
      final json = {
        'type': 'page',
        'title': 'Dashboard',
        'route': '/dashboard',
        'version': '1.1',
        'themeOverride': {'mode': 'dark'},
        'permissions': {
          'file': ['read'],
        },
        'channels': {
          'monitor': {
            'type': 'client.systemMonitor',
            'metrics': ['cpu'],
            'interval': 5000,
            'binding': 'systemStats',
          },
        },
        'content': {'type': 'text', 'content': 'Hello'},
        'state': {
          'initial': {'count': 0}
        },
        'metadata': {'author': 'test'},
        'lifecycle': {
          'onInit': [
            {'type': 'state', 'action': 'set', 'binding': 'loaded', 'value': true}
          ],
          'onDestroy': [
            {'type': 'state', 'action': 'set', 'binding': 'loaded', 'value': false}
          ],
        },
        'errorBoundary': {
          'fallback': {'type': 'text', 'content': 'Error'},
        },
        'offlineFallback': {
          'content': {'type': 'text', 'content': 'Offline'},
        },
        'errorRecovery': {
          'handlers': [
            {'errorType': 'NetworkError', 'action': {'type': 'notification', 'message': 'Network error'}},
          ],
        },
      };

      final def = PageDefinition.fromJson(json);
      expect(def.type, equals('page'));
      expect(def.title, equals('Dashboard'));
      expect(def.route, equals('/dashboard'));
      expect(def.version, equals('1.1'));
      expect(def.themeOverride, isNotNull);
      expect(def.permissions, isNotNull);
      expect(def.channels, isNotNull);
      expect(def.channels!['monitor'], isNotNull);
      expect(def.content.type, equals('text'));
      expect(def.initialState, equals({'count': 0}));
      expect(def.metadata, equals({'author': 'test'}));
      expect(def.onInit, isNotNull);
      expect(def.onInit, hasLength(1));
      expect(def.onDestroy, hasLength(1));
      expect(def.errorBoundary, isNotNull);
      expect(def.offlineFallback, isNotNull);
      expect(def.errorRecovery, isNotNull);
    });

    test('Boundary: parse with minimal fields', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'Minimal'},
      };
      final def = PageDefinition.fromJson(json);
      expect(def.type, equals('page'));
      expect(def.content.type, equals('text'));
      expect(def.version, isNull);
      expect(def.title, isNull);
      expect(def.permissions, isNull);
      expect(def.channels, isNull);
    });

    test('Error: missing content field throws', () {
      final json = {'type': 'page', 'title': 'NoContent'};
      expect(() => PageDefinition.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  // =========================================================================
  // TC-020: PageDefinition version field
  // =========================================================================
  group('TC-020: PageDefinition version field', () {
    test('Normal: version 1.1 activates v1.1 features', () {
      final json = {
        'type': 'page',
        'version': '1.1',
        'content': {'type': 'text', 'content': 'v1.1'},
        'permissions': {'file': ['read']},
      };
      final def = PageDefinition.fromJson(json);
      expect(def.version, equals('1.1'));
      expect(def.isV1_1, isTrue);
    });

    test('Boundary: default version null — isV1_1 false without v1.1 features', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'v1.0'},
      };
      final def = PageDefinition.fromJson(json);
      expect(def.version, isNull);
      expect(def.isV1_1, isFalse);
    });

    test('Error: version 2.0 handled gracefully', () {
      final json = {
        'type': 'page',
        'version': '2.0',
        'content': {'type': 'text', 'content': 'future'},
      };
      // Should parse without exception
      final def = PageDefinition.fromJson(json);
      expect(def.version, equals('2.0'));
    });
  });

  // =========================================================================
  // TC-021: PageDefinition error handling fields
  // =========================================================================
  group('TC-021: PageDefinition error handling fields', () {
    test('Normal: parse errorBoundary, offlineFallback, errorRecovery', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'x'},
        'errorBoundary': {
          'fallback': {'type': 'text', 'content': 'Error occurred'},
          'onError': {'type': 'notification', 'message': 'Error!'},
        },
        'offlineFallback': {
          'condition': '{{!isOnline}}',
          'content': {'type': 'text', 'content': 'Offline'},
          'cachedData': true,
        },
        'errorRecovery': {
          'handlers': [
            {'errorType': 'TimeoutError', 'action': {'type': 'notification', 'message': 'Timeout'}},
          ],
          'default': {'type': 'notification', 'message': 'Unknown error'},
        },
      };

      final def = PageDefinition.fromJson(json);
      expect(def.errorBoundary!['fallback'], isNotNull);
      expect(def.offlineFallback!['condition'], equals('{{!isOnline}}'));
      expect(def.errorRecovery!['handlers'], isA<List>());
    });

    test('Boundary: only errorBoundary present, others null', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'x'},
        'errorBoundary': {
          'fallback': {'type': 'text', 'content': 'Error'},
        },
      };
      final def = PageDefinition.fromJson(json);
      expect(def.errorBoundary, isNotNull);
      expect(def.offlineFallback, isNull);
      expect(def.errorRecovery, isNull);
    });
  });
}
