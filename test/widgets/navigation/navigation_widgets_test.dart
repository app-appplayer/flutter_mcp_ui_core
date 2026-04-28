// TC-136 ~ TC-145: Navigation Widget Definition Tests
// Tests navigation widget types using the generic WidgetDefinition class
// with type string field and properties map for widget-specific data.
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // ===========================================================================
  // TC-136: HeaderBar widget definition
  // ===========================================================================
  group('TC-136: HeaderBar widget definition', () {
    test('Normal: headerBar with title, leading, and actions', () {
      final json = {
        'type': 'headerBar',
        'title': 'Dashboard',
        'leading': {
          'type': 'iconButton',
          'icon': 'menu',
          'onTap': {
            'type': 'state',
            'action': 'toggle',
            'binding': 'drawerOpen',
          },
        },
        'actions': [
          {
            'type': 'iconButton',
            'icon': 'search',
            'onTap': {
              'type': 'navigate',
              'route': '/search',
            },
          },
          {
            'type': 'iconButton',
            'icon': 'notifications',
            'onTap': {
              'type': 'navigate',
              'route': '/notifications',
            },
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('headerBar'));
      expect(def.properties['title'], equals('Dashboard'));
      expect(def.properties['leading'], isA<Map>());
      expect(
        (def.properties['leading'] as Map)['type'],
        equals('iconButton'),
      );
      expect(def.properties['actions'], isA<List>());
      expect((def.properties['actions'] as List).length, equals(2));
    });

    test('Boundary: headerBar with title only', () {
      final json = {
        'type': 'headerBar',
        'title': 'Simple Page',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('headerBar'));
      expect(def.properties['title'], equals('Simple Page'));
      expect(def.properties['leading'], isNull);
      expect(def.properties['actions'], isNull);
    });

    test('Error: headerBar without title', () {
      final json = {'type': 'headerBar'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('headerBar'));
      expect(def.properties['title'], isNull);
    });
  });

  // ===========================================================================
  // TC-137: BottomNavigation widget definition
  // ===========================================================================
  group('TC-137: BottomNavigation widget definition', () {
    test('Normal: bottomNav with items containing labels, icons, and routes', () {
      final json = {
        'type': 'bottomNav',
        'items': [
          {'label': 'Home', 'icon': 'home', 'route': '/home'},
          {'label': 'Search', 'icon': 'search', 'route': '/search'},
          {'label': 'Profile', 'icon': 'person', 'route': '/profile'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('bottomNav'));
      expect(def.properties['items'], isA<List>());
      final items = def.properties['items'] as List;
      expect(items.length, equals(3));
      expect((items[0] as Map)['label'], equals('Home'));
      expect((items[0] as Map)['icon'], equals('home'));
      expect((items[0] as Map)['route'], equals('/home'));
    });

    test('Boundary: bottomNav with selected index', () {
      final json = {
        'type': 'bottomNav',
        'selectedIndex': 1,
        'items': [
          {'label': 'Tab1', 'icon': 'tab1', 'route': '/tab1'},
          {'label': 'Tab2', 'icon': 'tab2', 'route': '/tab2'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['selectedIndex'], equals(1));
    });

    test('Error: bottomNav with empty items', () {
      final json = {
        'type': 'bottomNav',
        'items': <Map<String, dynamic>>[],
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['items'] as List), isEmpty);
    });
  });

  // ===========================================================================
  // TC-138: Drawer widget definition
  // ===========================================================================
  group('TC-138: Drawer widget definition', () {
    test('Normal: drawer with header and items', () {
      final json = {
        'type': 'drawer',
        'header': {
          'type': 'box',
          'children': [
            {'type': 'avatar', 'src': 'avatar.png'},
            {'type': 'text', 'content': 'John Doe'},
          ],
        },
        'items': [
          {
            'label': 'Home',
            'icon': 'home',
            'route': '/home',
          },
          {
            'label': 'Settings',
            'icon': 'settings',
            'route': '/settings',
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('drawer'));
      expect(def.properties['header'], isA<Map>());
      expect(
        (def.properties['header'] as Map)['type'],
        equals('box'),
      );
      expect(def.properties['items'], isA<List>());
      expect((def.properties['items'] as List).length, equals(2));
    });

    test('Boundary: drawer without header', () {
      final json = {
        'type': 'drawer',
        'items': [
          {'label': 'Home', 'icon': 'home', 'route': '/home'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['header'], isNull);
      expect((def.properties['items'] as List).length, equals(1));
    });

    test('Error: drawer with no items', () {
      final json = {'type': 'drawer'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('drawer'));
      expect(def.properties['items'], isNull);
    });
  });

  // ===========================================================================
  // TC-139: TabBar widget definition
  // ===========================================================================
  group('TC-139: TabBar widget definition', () {
    test('Normal: tabBar with tabs', () {
      final json = {
        'type': 'tabBar',
        'tabs': [
          {'label': 'Tab 1'},
          {'label': 'Tab 2'},
          {'label': 'Tab 3'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('tabBar'));
      expect(def.properties['tabs'], isA<List>());
      expect((def.properties['tabs'] as List).length, equals(3));
      expect(
        ((def.properties['tabs'] as List)[0] as Map)['label'],
        equals('Tab 1'),
      );
    });

    test('Boundary: tabBar with icons in tabs', () {
      final json = {
        'type': 'tabBar',
        'tabs': [
          {'label': 'Home', 'icon': 'home'},
          {'label': 'Profile', 'icon': 'person'},
        ],
        'isScrollable': true,
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['isScrollable'], isTrue);
      final tabs = def.properties['tabs'] as List;
      expect((tabs[0] as Map)['icon'], equals('home'));
    });

    test('Error: tabBar with single tab', () {
      final json = {
        'type': 'tabBar',
        'tabs': [
          {'label': 'Only Tab'},
        ],
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['tabs'] as List).length, equals(1));
    });
  });

  // ===========================================================================
  // TC-140: NavigationRail widget definition
  // ===========================================================================
  group('TC-140: NavigationRail widget definition', () {
    test('Normal: navigationRail with items', () {
      final json = {
        'type': 'navigationRail',
        'items': [
          {'label': 'Home', 'icon': 'home'},
          {'label': 'Favorites', 'icon': 'favorite'},
          {'label': 'Settings', 'icon': 'settings'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('navigationRail'));
      expect(def.properties['items'], isA<List>());
      expect((def.properties['items'] as List).length, equals(3));
    });

    test('Boundary: navigationRail with extended mode', () {
      final json = {
        'type': 'navigationRail',
        'extended': true,
        'selectedIndex': 0,
        'items': [
          {'label': 'Dashboard', 'icon': 'dashboard'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['extended'], isTrue);
      expect(def.properties['selectedIndex'], equals(0));
    });

    test('Error: navigationRail with empty items', () {
      final json = {
        'type': 'navigationRail',
        'items': <Map<String, dynamic>>[],
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['items'] as List), isEmpty);
    });
  });

  // ===========================================================================
  // TC-141: FloatingActionButton widget definition
  // ===========================================================================
  group('TC-141: FloatingActionButton widget definition', () {
    test('Normal: floatingActionButton with icon and onTap', () {
      final json = {
        'type': 'floatingActionButton',
        'icon': 'add',
        'onTap': {
          'type': 'navigate',
          'route': '/create',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('floatingActionButton'));
      expect(def.properties['icon'], equals('add'));
      expect(def.properties['onTap'], isA<Map>());
      expect(
        (def.properties['onTap'] as Map)['route'],
        equals('/create'),
      );
    });

    test('Boundary: floatingActionButton with extended label', () {
      final json = {
        'type': 'floatingActionButton',
        'icon': 'add',
        'label': 'Create New',
        'extended': true,
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['label'], equals('Create New'));
      expect(def.properties['extended'], isTrue);
    });

    test('Error: floatingActionButton without icon', () {
      final json = {
        'type': 'floatingActionButton',
        'onTap': {'type': 'navigate', 'route': '/new'},
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('floatingActionButton'));
      expect(def.properties['icon'], isNull);
    });
  });

  // ===========================================================================
  // TC-142: TabBarView widget definition
  // ===========================================================================
  group('TC-142: TabBarView widget definition', () {
    test('Normal: tabBarView with children', () {
      final json = {
        'type': 'tabBarView',
        'children': [
          {
            'type': 'linear',
            'direction': 'vertical',
            'children': [
              {'type': 'text', 'content': 'Tab 1 content'},
            ],
          },
          {
            'type': 'linear',
            'direction': 'vertical',
            'children': [
              {'type': 'text', 'content': 'Tab 2 content'},
            ],
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('tabBarView'));
      expect(def.children, hasLength(2));
      expect(def.children![0].type, equals('linear'));
    });

    test('Boundary: tabBarView with empty children', () {
      final json = {
        'type': 'tabBarView',
        'children': <Map<String, dynamic>>[],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.children, isNotNull);
      expect(def.children, isEmpty);
    });

    test('Error: tabBarView without children', () {
      final json = {'type': 'tabBarView'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('tabBarView'));
      expect(def.children, isNull);
    });
  });

  // ===========================================================================
  // TC-143: PopupMenuButton widget definition
  // ===========================================================================
  group('TC-143: PopupMenuButton widget definition', () {
    test('Normal: popupMenuButton with items', () {
      final json = {
        'type': 'popupMenuButton',
        'items': [
          {
            'label': 'Edit',
            'value': 'edit',
            'icon': 'edit',
          },
          {
            'label': 'Delete',
            'value': 'delete',
            'icon': 'delete',
          },
          {
            'label': 'Share',
            'value': 'share',
            'icon': 'share',
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('popupMenuButton'));
      expect(def.properties['items'], isA<List>());
      final items = def.properties['items'] as List;
      expect(items.length, equals(3));
      expect((items[0] as Map)['label'], equals('Edit'));
    });

    test('Boundary: popupMenuButton with on-select handler', () {
      final json = {
        'type': 'popupMenuButton',
        'items': [
          {'label': 'Action', 'value': 'action'},
        ],
        'on-select': {
          'type': 'state',
          'action': 'set',
          'binding': 'selectedAction',
          'value': '{{value}}',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['on-select'], isA<Map>());
    });

    test('Error: popupMenuButton with empty items', () {
      final json = {
        'type': 'popupMenuButton',
        'items': <Map<String, dynamic>>[],
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['items'] as List), isEmpty);
    });
  });

  // ===========================================================================
  // TC-144: Navigation widget with route params
  // ===========================================================================
  group('TC-144: Navigation widget with route params', () {
    test('Boundary: bottomNav item with route parameters', () {
      final json = {
        'type': 'bottomNav',
        'items': [
          {
            'label': 'Profile',
            'icon': 'person',
            'route': '/profile/:userId',
            'params': {
              'userId': '{{currentUser.id}}',
            },
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      final items = def.properties['items'] as List;
      final profileItem = items[0] as Map;
      expect(profileItem['route'], equals('/profile/:userId'));
      expect(profileItem['params'], isA<Map>());
      expect(
        (profileItem['params'] as Map)['userId'],
        equals('{{currentUser.id}}'),
      );
    });

    test('Boundary: headerBar action with route and query params', () {
      final json = {
        'type': 'headerBar',
        'title': 'Page',
        'actions': [
          {
            'type': 'iconButton',
            'icon': 'filter',
            'onTap': {
              'type': 'navigate',
              'route': '/results',
              'params': {
                'category': '{{selectedCategory}}',
                'sort': 'desc',
              },
            },
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      final actions = def.properties['actions'] as List;
      final action = actions[0] as Map;
      final onTap = action['onTap'] as Map;
      expect(onTap['route'], equals('/results'));
      expect((onTap['params'] as Map)['sort'], equals('desc'));
    });
  });

  // ===========================================================================
  // TC-145: Navigation widget toJson then fromJson roundtrip
  // ===========================================================================
  group('TC-145: Navigation widget toJson/fromJson roundtrip', () {
    test('Boundary: headerBar survives roundtrip', () {
      final json = {
        'type': 'headerBar',
        'title': 'Dashboard',
        'leading': {
          'type': 'iconButton',
          'icon': 'menu',
        },
        'actions': [
          {'type': 'iconButton', 'icon': 'search'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('headerBar'));
      expect(restored.properties['title'], equals('Dashboard'));
      expect(restored.properties['leading'], isA<Map>());
      expect(restored.properties['actions'], isA<List>());
    });

    test('Boundary: bottomNav survives roundtrip', () {
      final json = {
        'type': 'bottomNav',
        'items': [
          {'label': 'Home', 'icon': 'home', 'route': '/home'},
          {'label': 'Profile', 'icon': 'person', 'route': '/profile'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('bottomNav'));
      final items = restored.properties['items'] as List;
      expect(items.length, equals(2));
      expect((items[0] as Map)['label'], equals('Home'));
    });

    test('Boundary: tabBar with children in tabBarView survives roundtrip', () {
      final json = {
        'type': 'tabBarView',
        'children': [
          {'type': 'text', 'content': 'Page 1'},
          {'type': 'text', 'content': 'Page 2'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('tabBarView'));
      expect(restored.children, hasLength(2));
      expect(
        restored.children![0].properties['content'],
        equals('Page 1'),
      );
    });
  });
}
