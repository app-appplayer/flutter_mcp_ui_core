// TC-019 ~ TC-022: DashboardConfig Tests per feat-v13-widgets.md spec
// DashboardConfig is defined in application_definition.dart and provides
// the compact widget tree configuration for multi-app dashboard contexts.
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-019: Dashboard rendering mode
  // =========================================================================
  group('TC-019: Dashboard rendering mode', () {
    test('Normal: DashboardConfig parses content widget tree', () {
      final config = DashboardConfig.fromJson({
        'content': {
          'type': 'box',
          'child': {
            'type': 'text',
            'properties': {'content': 'Dashboard content'},
          },
        },
      });
      expect(config.content, isA<Map<String, dynamic>>());
      expect(config.content['type'], equals('box'));
    });

    test('Normal: ApplicationDefinition with dashboard field', () {
      final appDef = ApplicationDefinition.fromJson({
        'type': 'application',
        'title': 'Test App',
        'version': '1.3',
        'initialRoute': '/',
        'routes': {'/': 'resource://main'},
        'dashboard': {
          'content': {
            'type': 'text',
            'properties': {'content': 'Dashboard view'},
          },
        },
      });
      expect(appDef.dashboard, isNotNull);
      expect(appDef.dashboard!.content['type'], equals('text'));
    });

    test('Normal: DashboardConfig round-trips through toJson/fromJson', () {
      final original = DashboardConfig.fromJson({
        'content': {
          'type': 'linear',
          'properties': {'direction': 'vertical'},
          'children': [
            {'type': 'text', 'properties': {'content': 'Header'}},
            {'type': 'image', 'properties': {'src': 'icon.png'}},
          ],
        },
        'refreshInterval': 5000,
        'onTap': {'type': 'navigation', 'action': 'openApp'},
      });

      final json = original.toJson();
      final restored = DashboardConfig.fromJson(json);

      expect(restored.content['type'], equals('linear'));
      expect(restored.refreshInterval, equals(5000));
      expect(restored.onTap!['action'], equals('openApp'));
    });
  });

  // =========================================================================
  // TC-020: Dashboard refresh interval
  // =========================================================================
  group('TC-020: Dashboard refresh interval', () {
    test('Normal: parse refreshInterval', () {
      final config = DashboardConfig.fromJson({
        'content': {'type': 'text', 'properties': {'content': 'Time'}},
        'refreshInterval': 5000,
      });
      expect(config.refreshInterval, equals(5000));
    });

    test('Normal: refreshInterval is null when not specified', () {
      final config = DashboardConfig.fromJson({
        'content': {'type': 'text'},
      });
      expect(config.refreshInterval, isNull);
    });

    test('Normal: refreshInterval preserved in toJson', () {
      final config = DashboardConfig(
        content: {'type': 'text'},
        refreshInterval: 10000,
      );
      final json = config.toJson();
      expect(json['refreshInterval'], equals(10000));
    });

    test('Boundary: refreshInterval omitted from toJson when null', () {
      final config = DashboardConfig(content: {'type': 'text'});
      final json = config.toJson();
      expect(json.containsKey('refreshInterval'), isFalse);
    });
  });

  // =========================================================================
  // TC-021: Dashboard click action
  // =========================================================================
  group('TC-021: Dashboard click action', () {
    test('Normal: parse onTap with navigation openApp', () {
      final config = DashboardConfig.fromJson({
        'content': {'type': 'text'},
        'onTap': {'type': 'navigation', 'action': 'openApp'},
      });
      expect(config.onTap, isNotNull);
      expect(config.onTap!['type'], equals('navigation'));
      expect(config.onTap!['action'], equals('openApp'));
    });

    test('Normal: onTap is null when not specified', () {
      final config = DashboardConfig.fromJson({
        'content': {'type': 'text'},
      });
      expect(config.onTap, isNull);
    });

    test('Normal: onTap preserved in toJson', () {
      final config = DashboardConfig(
        content: {'type': 'text'},
        onTap: {'type': 'navigation', 'action': 'openApp'},
      );
      final json = config.toJson();
      expect(json['onTap'], isNotNull);
      expect(json['onTap']['action'], equals('openApp'));
    });

    test('Boundary: onTap omitted from toJson when null', () {
      final config = DashboardConfig(content: {'type': 'text'});
      final json = config.toJson();
      expect(json.containsKey('onTap'), isFalse);
    });
  });

  // =========================================================================
  // TC-022: Missing dashboard field
  // =========================================================================
  group('TC-022: Missing dashboard field', () {
    test('Error: ApplicationDefinition without dashboard field', () {
      final appDef = ApplicationDefinition.fromJson({
        'type': 'application',
        'title': 'No Dashboard App',
        'version': '1.0',
        'initialRoute': '/',
        'routes': {'/': 'resource://main'},
      });
      expect(appDef.dashboard, isNull);
    });

    test('Normal: ApplicationDefinition with null dashboard serializes correctly', () {
      final appDef = ApplicationDefinition(
        title: 'Test',
        version: '1.0',
        routes: {'/': 'resource://main'},
      );
      final json = appDef.toJson();
      expect(json.containsKey('dashboard'), isFalse);
    });

    test('Normal: DashboardConfig equality with same instance content', () {
      final content = {'type': 'text'};
      final a = DashboardConfig(
        content: content,
        refreshInterval: 5000,
      );
      final b = DashboardConfig(
        content: content,
        refreshInterval: 5000,
      );
      expect(a, equals(b));
    });

    test('Normal: DashboardConfig round-trip preserves equality', () {
      final original = DashboardConfig.fromJson({
        'content': {'type': 'text'},
        'refreshInterval': 5000,
      });
      final json = original.toJson();
      final restored = DashboardConfig.fromJson(json);
      expect(restored.refreshInterval, equals(original.refreshInterval));
      expect(restored.content['type'], equals(original.content['type']));
    });

    test('Normal: DashboardConfig copyWith', () {
      final original = DashboardConfig(
        content: {'type': 'text'},
        refreshInterval: 5000,
      );
      final modified = original.copyWith(refreshInterval: 10000);
      expect(modified.refreshInterval, equals(10000));
      expect(modified.content, equals(original.content));
    });
  });
}
