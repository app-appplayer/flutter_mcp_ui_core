import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-011: ApplicationDefinition.fromJson
  group('TC-011: ApplicationDefinition.fromJson', () {
    test('Normal: parse complete JSON with all fields', () {
      final json = {
        'type': 'application',
        'title': 'Test App',
        'version': '1.0.0',
        'initialRoute': '/dashboard',
        'routes': {'/dashboard': 'ui://pages/dashboard', '/settings': 'ui://pages/settings'},
        'theme': {'mode': 'light', 'colors': {'primary': '#2196F3'}},
        'navigation': {
          'type': 'bottomNavigation',
          'items': [
            {'title': 'Home', 'icon': 'home', 'route': '/dashboard'},
            {'title': 'Settings', 'route': '/settings'},
          ]
        },
        'state': {'initial': {'counter': 0, 'user': 'John'}},
        'lifecycle': {'onInit': 'doSomething'},
        'services': {'api': {'baseUrl': 'https://api.test.com'}},
      };

      final app = ApplicationDefinition.fromJson(json);

      expect(app.type, equals('application'));
      expect(app.title, equals('Test App'));
      expect(app.version, equals('1.0.0'));
      expect(app.initialRoute, equals('/dashboard'));
      expect(app.routes.length, equals(2));
      expect(app.routes['/dashboard'], equals('ui://pages/dashboard'));
      expect(app.theme, isNotNull);
      expect(app.theme!.mode, equals('light'));
      expect(app.navigation, isNotNull);
      expect(app.navigation!.type, equals('bottomNavigation'));
      expect(app.navigation!.items.length, equals(2));
      expect(app.initialState, isNotNull);
      expect(app.initialState!['counter'], equals(0));
      expect(app.lifecycle, isNotNull);
      expect(app.services, isNotNull);
    });

    test('Boundary: parse with only required fields', () {
      final json = {
        'title': 'Minimal App',
        'version': '1.0',
        'routes': {'/': 'ui://pages/home'},
      };

      final app = ApplicationDefinition.fromJson(json);

      expect(app.type, equals('application'));
      expect(app.title, equals('Minimal App'));
      expect(app.version, equals('1.0'));
      expect(app.initialRoute, equals('/'));
      expect(app.theme, isNull);
      expect(app.navigation, isNull);
      expect(app.initialState, isNull);
      expect(app.lifecycle, isNull);
      expect(app.services, isNull);
    });

    test('Normal: parse initialState from both state.initial and initialState', () {
      final json1 = {
        'title': 'App',
        'version': '1.0',
        'routes': {'/': 'ui://pages/home'},
        'state': {'initial': {'key': 'value1'}},
      };
      final json2 = {
        'title': 'App',
        'version': '1.0',
        'routes': {'/': 'ui://pages/home'},
        'initialState': {'key': 'value2'},
      };

      expect(ApplicationDefinition.fromJson(json1).initialState!['key'], equals('value1'));
      expect(ApplicationDefinition.fromJson(json2).initialState!['key'], equals('value2'));
    });
  });

  // TC-012: ApplicationDefinition.toJson
  group('TC-012: ApplicationDefinition.toJson', () {
    test('Normal: full definition round-trips', () {
      final original = ApplicationDefinition(
        title: 'Test App',
        version: '1.0.0',
        initialRoute: '/dashboard',
        routes: {'/dashboard': 'ui://pages/dashboard'},
        theme: ThemeDefinition(mode: 'dark'),
        navigation: NavigationConfig(
          type: 'drawer',
          items: [NavigationItem(title: 'Home', route: '/', icon: 'home')],
        ),
        initialState: {'counter': 0},
        lifecycle: {'onInit': 'action'},
        services: {'api': {'url': 'test'}},
      );

      final json = original.toJson();
      final restored = ApplicationDefinition.fromJson(json);

      expect(restored.title, equals(original.title));
      expect(restored.version, equals(original.version));
      expect(restored.initialRoute, equals(original.initialRoute));
      expect(restored.routes, equals(original.routes));
      expect(restored.theme!.mode, equals(original.theme!.mode));
      expect(restored.navigation!.type, equals(original.navigation!.type));
    });

    test('Boundary: optional null fields omitted from JSON', () {
      final app = ApplicationDefinition(
        title: 'Test',
        version: '1.0',
        routes: {'/': 'ui://home'},
      );

      final json = app.toJson();

      expect(json.containsKey('theme'), isFalse);
      expect(json.containsKey('navigation'), isFalse);
      expect(json.containsKey('state'), isFalse);
      expect(json.containsKey('lifecycle'), isFalse);
      expect(json.containsKey('services'), isFalse);
    });
  });

  // TC-039: NavigationConfig.fromJson
  group('TC-039: NavigationConfig.fromJson', () {
    test('Normal: parse with type and items', () {
      final json = {
        'type': 'drawer',
        'items': [
          {'title': 'Home', 'route': '/', 'icon': 'home'},
          {'title': 'Settings', 'route': '/settings'},
        ],
      };

      final nav = NavigationConfig.fromJson(json);

      expect(nav.type, equals('drawer'));
      expect(nav.items.length, equals(2));
      expect(nav.items[0].title, equals('Home'));
      expect(nav.items[0].icon, equals('home'));
      expect(nav.items[0].route, equals('/'));
      expect(nav.items[1].icon, isNull);
    });

    test('Boundary: all 3 navigation types', () {
      for (final navType in ['drawer', 'bottomNavigation', 'tabBar']) {
        final json = {
          'type': navType,
          'items': [{'title': 'Item', 'route': '/'}],
        };
        final nav = NavigationConfig.fromJson(json);
        expect(nav.type, equals(navType));
      }
    });

    test('Normal: NavigationItem supports label fallback', () {
      final json = {'label': 'Old Label', 'route': '/test'};
      final item = NavigationItem.fromJson(json);
      expect(item.title, equals('Old Label'));
    });

    test('Normal: NavigationConfig toJson round-trip', () {
      final original = NavigationConfig(
        type: 'bottomNavigation',
        items: [
          NavigationItem(title: 'Home', route: '/', icon: 'home'),
          NavigationItem(title: 'Profile', route: '/profile'),
        ],
      );

      final json = original.toJson();
      final restored = NavigationConfig.fromJson(json);

      expect(restored.type, equals(original.type));
      expect(restored.items.length, equals(original.items.length));
      expect(restored.items[0].title, equals('Home'));
      expect(restored.items[1].icon, isNull);
    });
  });
}
