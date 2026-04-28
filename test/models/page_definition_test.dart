import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-013: PageDefinition.fromJson
  group('TC-013: PageDefinition.fromJson', () {
    test('Normal: parse page with all fields', () {
      final json = {
        'type': 'page',
        'title': 'Dashboard',
        'route': '/dashboard',
        'version': '1.1',
        'content': {'type': 'text', 'content': 'Hello'},
        'themeOverride': {'mode': 'dark'},
        'permissions': {'file': ['read']},
        'channels': {
          'monitor': {'type': 'client.systemMonitor', 'metrics': ['cpu']},
        },
        'initialState': {'count': 0},
        'metadata': {'author': 'test'},
        'onInit': [{'type': 'state', 'action': 'set', 'binding': 'loaded', 'value': true}],
        'onDestroy': [{'type': 'state', 'action': 'set', 'binding': 'loaded', 'value': false}],
        'errorBoundary': {
          'fallback': {'type': 'text', 'content': 'Error occurred'},
          'onError': {'type': 'tool', 'tool': 'logError'},
        },
        'offlineFallback': {
          'condition': '{{!client.network.online}}',
          'content': {'type': 'text', 'content': 'Offline'},
          'cachedData': true,
        },
        'errorRecovery': {'strategy': 'retry', 'maxAttempts': 3},
      };

      final page = PageDefinition.fromJson(json);

      expect(page.type, equals('page'));
      expect(page.title, equals('Dashboard'));
      expect(page.route, equals('/dashboard'));
      expect(page.version, equals('1.1'));
      expect(page.content.type, equals('text'));
      expect(page.themeOverride, isNotNull);
      expect(page.permissions, isNotNull);
      expect(page.channels, isNotNull);
      expect(page.channels!['monitor'], isNotNull);
      expect(page.initialState!['count'], equals(0));
      expect(page.onInit, isNotNull);
      expect(page.onInit!.length, equals(1));
      expect(page.onDestroy!.length, equals(1));
      expect(page.errorBoundary, isNotNull);
      expect(page.errorBoundary!['fallback'], isNotNull);
      expect(page.errorBoundary!['onError'], isNotNull);
      expect(page.offlineFallback, isNotNull);
      expect(page.offlineFallback!['condition'], equals('{{!client.network.online}}'));
      expect(page.offlineFallback!['cachedData'], isTrue);
      expect(page.errorRecovery, isNotNull);
      expect(page.metadata!['author'], equals('test'));
    });

    test('Boundary: parse with minimal fields (type + content)', () {
      final json = {
        'content': {'type': 'text', 'content': 'Hello'},
      };

      final page = PageDefinition.fromJson(json);

      expect(page.type, equals('page'));
      expect(page.content.type, equals('text'));
      expect(page.title, isNull);
      expect(page.route, isNull);
      expect(page.version, isNull);
      expect(page.themeOverride, isNull);
      expect(page.permissions, isNull);
      expect(page.channels, isNull);
      expect(page.initialState, isNull);
      expect(page.onInit, isNull);
    });

    test('Normal: parse lifecycle from nested lifecycle key', () {
      final json = {
        'content': {'type': 'text', 'content': 'Hello'},
        'lifecycle': {
          'onInit': [{'type': 'state', 'action': 'set', 'binding': 'x', 'value': 1}],
          'onReady': [{'type': 'state', 'action': 'set', 'binding': 'y', 'value': 2}],
        },
      };

      final page = PageDefinition.fromJson(json);
      expect(page.onInit!.length, equals(1));
      expect(page.onReady!.length, equals(1));
    });

    test('Normal: parse state from state.initial', () {
      final json = {
        'content': {'type': 'text', 'content': 'Hello'},
        'state': {'initial': {'key': 'value'}},
      };

      final page = PageDefinition.fromJson(json);
      expect(page.initialState!['key'], equals('value'));
    });
  });

  // TC-014: PageDefinition version field
  group('TC-014: PageDefinition version', () {
    test('Normal: version 1.1 activates v1.1 features', () {
      final page = PageDefinition(
        version: '1.1',
        content: WidgetDefinition(type: 'text'),
      );
      expect(page.isV1_1, isTrue);
    });

    test('Boundary: version 1.0 (default) is not v1.1', () {
      final page = PageDefinition(
        content: WidgetDefinition(type: 'text'),
      );
      expect(page.isV1_1, isFalse);
    });

    test('Normal: permissions presence makes isV1_1 true', () {
      final page = PageDefinition(
        content: WidgetDefinition(type: 'text'),
        permissions: PermissionDefinition(
          file: FilePermission(read: FileReadPermission()),
        ),
      );
      expect(page.isV1_1, isTrue);
    });

    test('Normal: channels presence makes isV1_1 true', () {
      final page = PageDefinition(
        content: WidgetDefinition(type: 'text'),
        channels: {
          'test': ChannelDefinition(type: 'client.poll'),
        },
      );
      expect(page.isV1_1, isTrue);
    });
  });

  // PageDefinition toJson round-trip
  group('PageDefinition.toJson round-trip', () {
    test('Normal: full page round-trips', () {
      final original = PageDefinition(
        title: 'Test',
        route: '/test',
        version: '1.1',
        content: WidgetDefinition(type: 'text', properties: {'content': 'Hello'}),
        initialState: {'count': 0},
        onInit: [StateActionDefinition(action: 'set', binding: 'x', value: 1)],
        onDestroy: [StateActionDefinition(action: 'set', binding: 'x', value: 0)],
      );

      final json = original.toJson();
      final restored = PageDefinition.fromJson(json);

      expect(restored.title, equals(original.title));
      expect(restored.route, equals(original.route));
      expect(restored.version, equals(original.version));
      expect(restored.content.type, equals(original.content.type));
      expect(restored.onInit!.length, equals(1));
      expect(restored.onDestroy!.length, equals(1));
    });

    test('Boundary: minimal page round-trips', () {
      final original = PageDefinition(
        content: WidgetDefinition(type: 'text'),
      );

      final json = original.toJson();
      final restored = PageDefinition.fromJson(json);

      expect(restored.type, equals('page'));
      expect(restored.content.type, equals('text'));
    });
  });
}
