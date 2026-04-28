// TC-049: NavigationConfig Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-049: NavigationConfig.fromJson
  // =========================================================================
  group('TC-049: NavigationConfig.fromJson', () {
    test('Normal: parse drawer navigation with items', () {
      final json = {
        'type': 'drawer',
        'items': [
          {'title': 'Home', 'route': '/home', 'icon': 'home'},
          {'title': 'Settings', 'route': '/settings', 'icon': 'settings'},
        ],
      };

      final nav = NavigationConfig.fromJson(json);
      expect(nav.type, equals('drawer'));
      expect(nav.items, hasLength(2));
      expect(nav.items[0].title, equals('Home'));
      expect(nav.items[0].route, equals('/home'));
      expect(nav.items[0].icon, equals('home'));
    });

    test('Boundary: all 3 navigation types', () {
      for (final navType in ['drawer', 'bottomNavigation', 'tabBar']) {
        final json = {
          'type': navType,
          'items': [
            {'title': 'Tab1', 'route': '/tab1'},
          ],
        };
        final nav = NavigationConfig.fromJson(json);
        expect(nav.type, equals(navType));
      }
    });

    test('Boundary: NavigationItem.icon is optional', () {
      final json = {
        'type': 'drawer',
        'items': [
          {'title': 'Home', 'route': '/home'},
        ],
      };

      final nav = NavigationConfig.fromJson(json);
      expect(nav.items[0].icon, isNull);
    });

    test('Error: missing type field throws', () {
      final json = {
        'items': [
          {'title': 'Home', 'route': '/home'},
        ],
      };
      expect(() => NavigationConfig.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
