import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-089: Round-trip — ApplicationDefinition
  group('TC-089: ApplicationDefinition round-trip', () {
    test('Normal: full definition survives round-trip', () {
      final original = ApplicationDefinition(
        title: 'Test App',
        version: '1.0.0',
        initialRoute: '/dashboard',
        routes: {'/dashboard': 'ui://pages/dashboard', '/settings': 'ui://pages/settings'},
        theme: ThemeDefinition(
          mode: 'dark',
          color: ColorSchemeDefinition(primary: '#2196F3', secondary: '#FF9800'),
        ),
        navigation: NavigationConfig(
          type: 'bottomNavigation',
          items: [
            NavigationItem(title: 'Home', route: '/', icon: 'home'),
            NavigationItem(title: 'Settings', route: '/settings'),
          ],
        ),
        initialState: {'counter': 0, 'user': 'John'},
        lifecycle: {'onInit': 'doSomething'},
        services: {'api': {'baseUrl': 'https://api.test.com'}},
      );

      final json = original.toJson();
      final restored = ApplicationDefinition.fromJson(json);

      expect(restored.title, equals(original.title));
      expect(restored.version, equals(original.version));
      expect(restored.initialRoute, equals(original.initialRoute));
      expect(restored.routes.length, equals(original.routes.length));
      expect(restored.theme!.mode, equals(original.theme!.mode));
      expect(restored.navigation!.type, equals(original.navigation!.type));
      expect(restored.navigation!.items.length, equals(original.navigation!.items.length));
      expect(restored.initialState!['counter'], equals(0));
    });

    test('Boundary: minimal definition round-trip', () {
      final original = ApplicationDefinition(
        title: 'Min App',
        version: '1.0',
        routes: {'/': 'ui://home'},
      );

      final json = original.toJson();
      final restored = ApplicationDefinition.fromJson(json);

      expect(restored.title, equals('Min App'));
      expect(restored.version, equals('1.0'));
      expect(restored.theme, isNull);
      expect(restored.navigation, isNull);
    });
  });

  // TC-090: Round-trip — PageDefinition
  group('TC-090: PageDefinition round-trip', () {
    test('Normal: full page with lifecycle hooks round-trips', () {
      final original = PageDefinition(
        title: 'Dashboard',
        route: '/dashboard',
        content: WidgetDefinition(type: 'text', properties: {'content': 'Hello'}),
        initialState: {'loaded': false},
        onInit: [
          StateActionDefinition(action: 'set', binding: 'loaded', value: true),
        ],
      );

      final json = original.toJson();
      final restored = PageDefinition.fromJson(json);

      expect(restored.title, equals(original.title));
      expect(restored.route, equals(original.route));
      expect(restored.content.type, equals('text'));
      expect(restored.initialState!['loaded'], equals(false));
    });

    test('Boundary: minimal page round-trip', () {
      final original = PageDefinition(
        content: WidgetDefinition(type: 'text', properties: {'content': 'Hi'}),
      );

      final json = original.toJson();
      final restored = PageDefinition.fromJson(json);

      expect(restored.content.type, equals('text'));
    });
  });

  // TC-091: Round-trip — all ActionDefinition subtypes
  group('TC-091: ActionDefinition subtypes round-trip', () {
    test('Normal: StateActionDefinition round-trip', () {
      final original = StateActionDefinition(action: 'set', binding: 'counter', value: 42);
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as StateActionDefinition;

      expect(restored.action, equals('set'));
      expect(restored.binding, equals('counter'));
      expect(restored.value, equals(42));
    });

    test('Normal: NavigationActionDefinition round-trip', () {
      final original = NavigationActionDefinition(action: 'push', route: '/page');
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as NavigationActionDefinition;

      expect(restored.action, equals('push'));
      expect(restored.route, equals('/page'));
    });

    test('Normal: ToolActionDefinition round-trip', () {
      final original = ToolActionDefinition(
        tool: 'fetchData',
        params: {'url': 'https://api.test.com'},
      );
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as ToolActionDefinition;

      expect(restored.tool, equals('fetchData'));
      expect(restored.params!['url'], equals('https://api.test.com'));
    });

    test('Normal: BatchActionDefinition round-trip', () {
      final original = BatchActionDefinition(
        actions: [
          StateActionDefinition(action: 'set', binding: 'a', value: 1),
          StateActionDefinition(action: 'set', binding: 'b', value: 2),
        ],
        sequential: true,
      );
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as BatchActionDefinition;

      expect(restored.actions.length, equals(2));
      expect(restored.sequential, isTrue);
    });

    test('Normal: ConditionalActionDefinition round-trip', () {
      final original = ConditionalActionDefinition(
        condition: '{{x > 0}}',
        thenAction: StateActionDefinition(action: 'set', binding: 'r', value: 'yes'),
        elseAction: StateActionDefinition(action: 'set', binding: 'r', value: 'no'),
      );
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as ConditionalActionDefinition;

      expect(restored.condition, equals('{{x > 0}}'));
      expect(restored.thenAction, isNotNull);
      expect(restored.elseAction, isNotNull);
    });

    test('Normal: NotificationActionDefinition round-trip', () {
      final original = NotificationActionDefinition(message: 'Saved', severity: 'success');
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as NotificationActionDefinition;

      expect(restored.message, equals('Saved'));
      expect(restored.severity, equals('success'));
    });

    test('Boundary: nested actions (batch → conditional → state) round-trip', () {
      final original = BatchActionDefinition(
        actions: [
          ConditionalActionDefinition(
            condition: '{{flag}}',
            thenAction: StateActionDefinition(action: 'set', binding: 'x', value: 1),
          ),
        ],
      );
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as BatchActionDefinition;

      expect(restored.actions.length, equals(1));
      expect(restored.actions[0], isA<ConditionalActionDefinition>());
    });
  });

  // TC-092: Round-trip — ThemeDefinition
  group('TC-092: ThemeDefinition round-trip', () {
    test('Normal: complete theme round-trips', () {
      final original = ThemeDefinition(
        mode: 'dark',
        color: ColorSchemeDefinition(
          primary: '#2196F3',
          secondary: '#FF9800',
          surface: '#1E1E1E',
          onSurface: '#FFFFFF',
          error: '#CF6679',
        ),
        typography: TypographyDefinition(
          displayLarge: TextStyleDefinition(fontSize: 57, fontWeight: 'regular'),
          bodyLarge: TextStyleDefinition(fontSize: 16),
        ),
        spacing: SpacingDefinition(xs: 4, sm: 8, md: 16, lg: 24, xl: 32),
      );

      final json = original.toJson();
      final restored = ThemeDefinition.fromJson(json);

      expect(restored.mode, equals('dark'));
      expect(restored.color!.primary, equals('#2196F3'));
      expect(restored.typography!.displayLarge!.fontSize, equals(57));
      expect(restored.spacing!.md, equals(16));
    });
  });

  // TC-093: Round-trip — PermissionDefinition (v1.1)
  group('TC-093: PermissionDefinition round-trip', () {
    test('Normal: complete permission round-trips', () {
      final json = {
        'file': {
          'read': {'paths': ['./config'], 'extensions': ['json']},
          'write': {'paths': ['./output']},
        },
        'network': {
          'http': {'domains': ['api.example.com']},
        },
        'system': {
          'info': ['platform'],
          'clipboard': true,
        },
      };

      final perm = PermissionDefinition.fromJson(json);
      final restored = PermissionDefinition.fromJson(perm.toJson());

      expect(restored.file, isNotNull);
      expect(restored.file!.read, isNotNull);
      expect(restored.network, isNotNull);
      expect(restored.system, isNotNull);
    });
  });

  // TC-094: Round-trip — ChannelDefinition (v1.1)
  group('TC-094: ChannelDefinition round-trip', () {
    test('Normal: channel definitions round-trip', () {
      final types = [
        {'type': 'client.watchFile', 'path': './config.json', 'events': ['change']},
        {'type': 'client.watchDirectory', 'path': './data', 'recursive': true},
        {'type': 'client.systemMonitor', 'metrics': ['cpu'], 'interval': 5000},
        {'type': 'client.websocket', 'url': 'ws://localhost:8080'},
      ];

      for (final json in types) {
        final channel = ChannelDefinition.fromJson(json);
        final roundTripped = ChannelDefinition.fromJson(channel.toJson());
        expect(roundTripped.type, equals(json['type']));
      }
    });

    test('Boundary: poll channel with nested action round-trips', () {
      final json = {
        'type': 'client.poll',
        'action': {'type': 'tool', 'tool': 'fetchStatus'},
        'interval': 10000,
        'binding': 'status',
      };

      final channel = ChannelDefinition.fromJson(json);
      final roundTripped = ChannelDefinition.fromJson(channel.toJson());

      expect(roundTripped.type, equals('client.poll'));
      expect(roundTripped.binding, equals('status'));
    });
  });
}
