// TC-123 ~ TC-133: JSON Serialization Round-trip Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-123: Round-trip - ApplicationDefinition
  // =========================================================================
  group('TC-123: Round-trip - ApplicationDefinition', () {
    test('Normal: full definition survives round-trip', () {
      final original = ApplicationDefinition(
        title: 'RT App',
        version: '1.0',
        routes: {'/': 'main.json', '/settings': 'settings.json'},
        initialState: {'count': 0, 'name': 'test'},
        defaultLocale: 'en',
        supportedLocales: ['en', 'ko', 'ja'],
        fallbackLocale: 'en',
      );

      final json = original.toJson();
      final restored = ApplicationDefinition.fromJson(json);

      expect(restored.title, equals(original.title));
      expect(restored.version, equals(original.version));
      expect(restored.routes, equals(original.routes));
      expect(restored.initialState, equals(original.initialState));
      expect(restored.defaultLocale, equals(original.defaultLocale));
      expect(restored.supportedLocales, equals(original.supportedLocales));
      expect(restored.fallbackLocale, equals(original.fallbackLocale));
    });

    test('Boundary: minimal definition round-trip', () {
      final original = ApplicationDefinition(
        title: 'Min',
        version: '1.0',
        routes: {'/': 'main.json'},
      );

      final json = original.toJson();
      final restored = ApplicationDefinition.fromJson(json);

      expect(restored.title, equals(original.title));
      expect(restored.theme, isNull);
      expect(restored.navigation, isNull);
    });

    test('Boundary: initialState serialized as state.initial', () {
      final def = ApplicationDefinition(
        title: 'App',
        version: '1.0',
        routes: {'/': 'main.json'},
        initialState: {'x': 1},
      );

      final json = def.toJson();
      expect(json.containsKey('state'), isTrue);
      expect((json['state'] as Map)['initial'], equals({'x': 1}));
    });
  });

  // =========================================================================
  // TC-124: Round-trip - PageDefinition
  // =========================================================================
  group('TC-124: Round-trip - PageDefinition', () {
    test('Normal: full page with lifecycle hooks round-trips', () {
      final json = {
        'type': 'page',
        'title': 'Dashboard',
        'route': '/dashboard',
        'content': {'type': 'text', 'content': 'Hello'},
        'lifecycle': {
          'onInit': [
            {'type': 'state', 'action': 'set', 'binding': 'loaded', 'value': true}
          ],
        },
      };

      final page = PageDefinition.fromJson(json);
      final output = page.toJson();
      final restored = PageDefinition.fromJson(output);

      expect(restored.title, equals('Dashboard'));
      expect(restored.content.type, equals('text'));
      expect(restored.onInit, isNotNull);
    });

    test('Boundary: error handling fields round-trip', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'x'},
        'errorBoundary': {
          'fallback': {'type': 'text', 'content': 'Error'},
        },
        'offlineFallback': {
          'content': {'type': 'text', 'content': 'Offline'},
        },
        'errorRecovery': {
          'handlers': [
            {'errorType': 'NetworkError', 'action': {'type': 'notification', 'message': 'Error'}},
          ],
        },
      };

      final page = PageDefinition.fromJson(json);
      final output = page.toJson();
      final restored = PageDefinition.fromJson(output);

      expect(restored.errorBoundary, isNotNull);
      expect(restored.offlineFallback, isNotNull);
      expect(restored.errorRecovery, isNotNull);
    });
  });

  // =========================================================================
  // TC-125: Round-trip - all ActionDefinition subtypes
  // =========================================================================
  group('TC-125: Round-trip - ActionDefinition subtypes', () {
    test('Normal: state action round-trips', () {
      final json = {
        'type': 'state',
        'action': 'set',
        'binding': 'count',
        'value': 42,
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<StateActionDefinition>());
      expect((restored as StateActionDefinition).binding, equals('count'));
    });

    test('Normal: navigation action round-trips', () {
      final json = {
        'type': 'navigation',
        'action': 'push',
        'route': '/page',
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<NavigationActionDefinition>());
      expect((restored as NavigationActionDefinition).route, equals('/page'));
    });

    test('Normal: tool action round-trips', () {
      final json = {
        'type': 'tool',
        'tool': 'myTool',
        'params': {'key': 'value'},
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<ToolActionDefinition>());
    });

    test('Normal: batch action with nested actions round-trips', () {
      final json = {
        'type': 'batch',
        'actions': [
          {'type': 'state', 'action': 'set', 'binding': 'a', 'value': 1},
          {'type': 'state', 'action': 'set', 'binding': 'b', 'value': 2},
        ],
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<BatchActionDefinition>());
      expect((restored as BatchActionDefinition).actions, hasLength(2));
    });

    test('Normal: conditional action round-trips', () {
      final json = {
        'type': 'conditional',
        'condition': '{{x > 0}}',
        'then': {'type': 'state', 'action': 'set', 'binding': 'result', 'value': true},
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<ConditionalActionDefinition>());
    });

    test('Normal: notification action round-trips', () {
      final json = {
        'type': 'notification',
        'message': 'Hello',
        'severity': 'info',
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<NotificationActionDefinition>());
    });

    test('Normal: client action round-trips', () {
      final json = {
        'type': 'client.readFile',
        'params': {'path': './file.txt'},
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<ClientActionDefinition>());
    });

    test('Normal: channel action round-trips', () {
      final json = {
        'type': 'channel.start',
        'channel': 'monitor',
      };
      final action = ActionDefinition.fromJson(json);
      final output = action.toJson();
      final restored = ActionDefinition.fromJson(output);
      expect(restored, isA<ChannelActionDefinition>());
    });
  });

  // =========================================================================
  // TC-126: Round-trip - ThemeDefinition
  // =========================================================================
  group('TC-126: Round-trip - ThemeDefinition (1.3 — 14 domain)', () {
    test('Normal: default light theme round-trips through JSON', () {
      final original = ThemeDefinition.defaultLight();
      final json = original.toJson();
      final restored = ThemeDefinition.fromJson(json);

      expect(restored.mode, equals(original.mode));
      expect(restored.color?.primary, equals(original.color?.primary));
      expect(restored.typography?.bodyLarge?.fontSize,
          equals(original.typography?.bodyLarge?.fontSize));
      expect(restored.spacing?.md, equals(original.spacing?.md));
      expect(restored.shape?.medium?.uniform,
          equals(original.shape?.medium?.uniform));
      expect(restored.elevation?.level3?.shadow,
          equals(original.elevation?.level3?.shadow));
    });

    test('Boundary: dual-theme (system + light/dark overrides) round-trips', () {
      final original = ThemeDefinition(
        mode: 'system',
        light: ThemeDefinition.defaultLight(),
        dark: ThemeDefinition.defaultDark(),
      );
      final json = original.toJson();
      final restored = ThemeDefinition.fromJson(json);

      expect(restored.light, isNotNull);
      expect(restored.dark, isNotNull);
      expect(restored.light!.mode, equals('light'));
      expect(restored.dark!.mode, equals('dark'));
    });

    test('Boundary: ColorSchemeDefinition emits only canonical M3 keys', () {
      const cs = ColorSchemeDefinition(
        primary: '#2196F3',
        onPrimary: '#FFFFFF',
      );
      final json = cs.toJson();
      expect(json['onPrimary'], equals('#FFFFFF'));
      // No legacy `textOnPrimary` alias.
      expect(json.containsKey('textOnPrimary'), isFalse);
    });

    test('DTCG round-trip preserves canonical types', () {
      final original = ThemeDefinition.defaultLight();
      final dtcg = original.toDtcg();
      final restored = ThemeDefinition.fromDtcg(dtcg);

      expect(restored.mode, equals(original.mode));
      expect(restored.color?.primary, equals(original.color?.primary));
      expect(restored.spacing?.md, equals(original.spacing?.md));
    });
  });

  // =========================================================================
  // TC-127: Round-trip - I18nConfig
  // =========================================================================
  group('TC-127: Round-trip - I18nConfig', () {
    test('Normal: canonical format round-trips', () {
      final original = I18nConfig(
        text: I18nText(key: 'greeting', defaultText: 'Hello'),
        pluralization: I18nPluralization(
          key: 'items',
          count: '{{count}}',
          other: '{{count}} items',
          one: '1 item',
        ),
      );

      final json = original.toJson();
      final restored = I18nConfig.fromJson(json);

      expect(restored.text!.key, equals('greeting'));
      expect(restored.text!.defaultText, equals('Hello'));
      expect(restored.pluralization!.key, equals('items'));
      expect(restored.pluralization!.one, equals('1 item'));
    });

    test('Boundary: flat format input normalizes to nested output', () {
      final flatJson = {
        'key': 'greeting',
        'fallback': 'Hello',
      };

      final config = I18nConfig.fromJson(flatJson);
      final output = config.toJson();

      // Output is always nested format
      expect(output.containsKey('text'), isTrue);
      expect(output.containsKey('key'), isFalse);
    });
  });

  // =========================================================================
  // TC-128: Round-trip - PermissionDefinition (v1.1)
  // =========================================================================
  group('TC-128: Round-trip - PermissionDefinition', () {
    test('Normal: complete permission round-trips', () {
      final json = {
        'file': {
          'read': {'paths': ['./data'], 'extensions': ['json']},
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
      final output = perm.toJson();
      final restored = PermissionDefinition.fromJson(output);

      expect(restored.file, isNotNull);
      expect(restored.file!.read, isNotNull);
      expect(restored.network, isNotNull);
      expect(restored.system, isNotNull);
    });
  });

  // =========================================================================
  // TC-129: Round-trip - ChannelDefinition (v1.1)
  // =========================================================================
  group('TC-129: Round-trip - ChannelDefinition', () {
    test('Normal: systemMonitor channel round-trips', () {
      final json = {
        'type': 'client.systemMonitor',
        'metrics': ['cpu', 'memory'],
        'interval': 5000,
        'binding': 'stats',
      };

      final ch = ChannelDefinition.fromJson(json);
      final output = ch.toJson();
      final restored = ChannelDefinition.fromJson(output);

      expect(restored.type, equals('client.systemMonitor'));
      expect(restored.binding, equals('stats'));
    });

    test('Boundary: poll channel with nested action round-trips', () {
      final json = {
        'type': 'client.poll',
        'action': {
          'type': 'tool',
          'tool': 'checkStatus',
        },
        'interval': 10000,
        'binding': 'status',
      };

      final ch = ChannelDefinition.fromJson(json);
      final output = ch.toJson();
      final restored = ChannelDefinition.fromJson(output);

      expect(restored.type, equals('client.poll'));
      expect(restored.action, isNotNull);
    });
  });

  // =========================================================================
  // TC-130: Round-trip - TimestampInfo
  // =========================================================================
  group('TC-130: Round-trip - TimestampInfo', () {
    test('Normal: both timestamps round-trip as ISO 8601', () {
      final original = TimestampInfo(
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 6, 1, 12, 0),
      );

      final json = original.toJson();
      final restored = TimestampInfo.fromJson(json);

      expect(restored.createdAt!.year, equals(2024));
      expect(restored.createdAt!.month, equals(1));
      expect(restored.updatedAt!.month, equals(6));
    });

    test('Boundary: single timestamp field round-trips', () {
      final original = TimestampInfo(
        createdAt: DateTime.utc(2024, 1, 1),
      );

      final json = original.toJson();
      final restored = TimestampInfo.fromJson(json);

      expect(restored.createdAt, isNotNull);
      expect(restored.updatedAt, isNull);
    });
  });

  // =========================================================================
  // TC-131: Round-trip - BindingConfig
  // =========================================================================
  group('TC-131: Round-trip - BindingConfig', () {
    test('Normal: full BindingConfig round-trips', () {
      const original = BindingConfig(
        expression: '{{user.name}}',
        path: 'user.name',
        type: 'text',
        defaultValue: 'Anonymous',
        twoWay: true,
        formatter: 'uppercase',
        validator: 'notEmpty',
      );

      final json = original.toJson();
      final restored = BindingConfig.fromJson(json);

      expect(restored.expression, equals(original.expression));
      expect(restored.path, equals(original.path));
      expect(restored.type, equals(original.type));
      expect(restored.defaultValue, equals(original.defaultValue));
      expect(restored.twoWay, equals(original.twoWay));
      expect(restored.formatter, equals(original.formatter));
      expect(restored.validator, equals(original.validator));
    });

    test('Boundary: minimal config round-trips', () {
      const original = BindingConfig(
        expression: '{{count}}',
        path: 'count',
      );

      final json = original.toJson();
      final restored = BindingConfig.fromJson(json);

      expect(restored.expression, equals('{{count}}'));
      expect(restored.path, equals('count'));
      expect(restored.type, equals('value'));
      expect(restored.twoWay, isFalse);
    });
  });

  // =========================================================================
  // TC-132: Round-trip - TemplateDefinition
  // =========================================================================
  group('TC-132: Round-trip - TemplateDefinition', () {
    test('Normal: template with params, slots, defaults round-trips', () {
      final original = TemplateDefinition.fromJson({
        'name': 'card',
        'description': 'A card template',
        'params': {
          'title': {'type': 'string', 'required': true},
        },
        'body': {'type': 'box', 'child': {'type': 'text'}},
        'slots': ['header', 'footer'],
        'defaults': {'title': 'Default'},
      });

      final json = original.toJson();
      final restored = TemplateDefinition.fromJson(json);

      expect(restored.name, equals('card'));
      expect(restored.description, equals('A card template'));
      expect(restored.params, isNotNull);
      expect(restored.slots, equals(['header', 'footer']));
      expect(restored.defaults, equals({'title': 'Default'}));
    });

    test('Boundary: minimal template round-trips', () {
      final original = TemplateDefinition.fromJson({
        'name': 'minimal',
        'body': {'type': 'text'},
      });

      final json = original.toJson();
      final restored = TemplateDefinition.fromJson(json);

      expect(restored.name, equals('minimal'));
      expect(restored.params, isNull);
      expect(restored.slots, isNull);
      expect(restored.defaults, isNull);
    });
  });

  // =========================================================================
  // TC-133: Client action result envelope structure
  // =========================================================================
  group('TC-133: Client action result envelope structure', () {
    // The result envelope is a runtime concern (the client returns results
    // in this format). Here we verify the ClientActionDefinition parsing
    // for all 10 client action types can handle the type field correctly.
    test('Normal: all 10 client action types parse correctly', () {
      final clientTypes = [
        'client.selectFile',
        'client.readFile',
        'client.writeFile',
        'client.saveFile',
        'client.listFiles',
        'client.httpRequest',
        'client.getSystemInfo',
        'client.clipboard',
        'client.exec',
        'client.notification',
      ];

      for (final type in clientTypes) {
        final action = ActionDefinition.fromJson({'type': type});
        expect(action, isA<ClientActionDefinition>());
        expect((action as ClientActionDefinition).type, equals(type));
      }
    });

    test('Boundary: client action with onSuccess/onError', () {
      final json = {
        'type': 'client.readFile',
        'params': {'path': './file.txt'},
        'onSuccess': {
          'type': 'state',
          'action': 'set',
          'binding': 'content',
          'value': '{{result.data.content}}',
        },
        'onError': {
          'type': 'notification',
          'message': 'Read failed',
        },
      };

      final action = ActionDefinition.fromJson(json) as ClientActionDefinition;
      expect(action.onSuccess, isNotNull);
      expect(action.onError, isNotNull);
    });
  });
}
