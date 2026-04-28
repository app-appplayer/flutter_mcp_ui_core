import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-015: WidgetDefinition.fromJson
  group('TC-015: WidgetDefinition.fromJson', () {
    test('Normal: parse with all fields', () {
      final json = {
        'type': 'text',
        'visible': true,
        'key': 'myText',
        'testKey': 'test_text',
        'content': 'Hello World',
        'style': {'fontSize': 16},
        'accessibility': {'label': 'Greeting text', 'role': 'text'},
        'i18n': {'key': 'greeting', 'fallback': 'Hello'},
        'metadata': {'custom': 'data'},
      };

      final widget = WidgetDefinition.fromJson(json);

      expect(widget.type, equals('text'));
      expect(widget.visible, isTrue);
      expect(widget.key, equals('myText'));
      expect(widget.testKey, equals('test_text'));
      expect(widget.properties['content'], equals('Hello World'));
      expect(widget.accessibility, isNotNull);
      expect(widget.accessibility!.semanticLabel, equals('Greeting text'));
      expect(widget.i18n, isNotNull);
      expect(widget.metadata['custom'], equals('data'));
    });

    test('Boundary: visible as binding expression string', () {
      final json = {'type': 'text', 'visible': '{{showWidget}}'};
      final widget = WidgetDefinition.fromJson(json);

      expect(widget.visible, isNull);
      expect(widget.visibleExpression, equals('{{showWidget}}'));
    });

    test('Normal: children parsing', () {
      final json = {
        'type': 'linear',
        'direction': 'vertical',
        'children': [
          {'type': 'text', 'content': 'A'},
          {'type': 'text', 'content': 'B'},
        ],
      };

      final widget = WidgetDefinition.fromJson(json);
      expect(widget.children!.length, equals(2));
      expect(widget.children![0].type, equals('text'));
    });

    test('Normal: single child parsing', () {
      final json = {
        'type': 'center',
        'child': {'type': 'text', 'content': 'Centered'},
      };

      final widget = WidgetDefinition.fromJson(json);
      expect(widget.child, isNotNull);
      expect(widget.child!.type, equals('text'));
    });

    test('Normal: toJson round-trip', () {
      final original = WidgetDefinition(
        type: 'text',
        visible: true,
        key: 'myKey',
        properties: {'content': 'Hello'},
      );

      final json = original.toJson();
      final restored = WidgetDefinition.fromJson(json);

      expect(restored.type, equals('text'));
      expect(restored.visible, isTrue);
      expect(restored.key, equals('myKey'));
      expect(restored.properties['content'], equals('Hello'));
    });

    test('Normal: visibleExpression serializes in toJson', () {
      final widget = WidgetDefinition(type: 'text', visibleExpression: '{{show}}');
      final json = widget.toJson();
      expect(json['visible'], equals('{{show}}'));
    });
  });

  // TC-040: AccessibilityConfig.fromJson
  group('TC-040: AccessibilityConfig', () {
    test('Normal: parse all fields', () {
      final json = {
        'semanticLabel': 'Submit button',
        'semanticHint': 'Double tap to submit',
        'role': 'button',
        'excludeFromSemantics': false,
        'focusable': true,
        'focusOrder': 1,
        'focusTrap': false,
        'initialFocus': true,
        'restoreFocus': true,
        'liveRegion': 'polite',
        'atomic': false,
      };

      final a11y = AccessibilityConfig.fromJson(json);

      expect(a11y.semanticLabel, equals('Submit button'));
      expect(a11y.semanticHint, equals('Double tap to submit'));
      expect(a11y.role, equals('button'));
      expect(a11y.excludeFromSemantics, isFalse);
      expect(a11y.focusable, isTrue);
      expect(a11y.focusOrder, equals(['1']));
      expect(a11y.focusTrap, isFalse);
      expect(a11y.initialFocus, equals('_self'));
      expect(a11y.restoreFocus, isTrue);
      expect(a11y.liveRegion, equals('polite'));
      expect(a11y.atomic, isFalse);
    });

    test('Normal: supports short alias keys (label, description, live)', () {
      final json = {'label': 'My label', 'description': 'My description', 'live': 'assertive'};
      final a11y = AccessibilityConfig.fromJson(json);

      expect(a11y.semanticLabel, equals('My label'));
      expect(a11y.semanticHint, equals('My description'));
      expect(a11y.liveRegion, equals('assertive'));
    });

    test('Boundary: liveRegion values', () {
      for (final value in ['polite', 'assertive', 'off']) {
        final a11y = AccessibilityConfig.fromJson({'liveRegion': value});
        expect(a11y.liveRegion, equals(value));
      }
    });

    test('Normal: hasAccessibilitySettings', () {
      expect(AccessibilityConfig().hasAccessibilitySettings, isFalse);
      expect(AccessibilityConfig(semanticLabel: 'test').hasAccessibilitySettings, isTrue);
    });

    test('Normal: toJson round-trip', () {
      final original = AccessibilityConfig(semanticLabel: 'Button', role: 'button', liveRegion: 'polite');
      final json = original.toJson();
      final restored = AccessibilityConfig.fromJson(json);

      expect(restored.semanticLabel, equals('Button'));
      expect(restored.role, equals('button'));
      expect(restored.liveRegion, equals('polite'));
    });
  });

  // TC-041: I18nConfig.fromJson
  group('TC-041: I18nConfig', () {
    test('Normal: flat format (design doc)', () {
      final json = {
        'key': 'greeting',
        'params': {'name': 'John'},
        'fallback': 'Hello',
      };

      final i18n = I18nConfig.fromJson(json);
      expect(i18n.text, isNotNull);
      expect(i18n.text!.key, equals('greeting'));
      expect(i18n.text!.params['name'], equals('John'));
      expect(i18n.text!.defaultText, equals('Hello'));
    });

    test('Normal: nested format (implementation)', () {
      final json = {
        'text': {'key': 'greeting', 'default': 'Hello', 'params': {'name': 'World'}},
        'pluralization': {'key': 'items', 'count': 5, 'other': '{{count}} items', 'one': '1 item'},
      };

      final i18n = I18nConfig.fromJson(json);
      expect(i18n.text!.key, equals('greeting'));
      expect(i18n.pluralization, isNotNull);
      expect(i18n.pluralization!.count, equals(5));
    });

    test('Normal: hasI18nSettings', () {
      expect(I18nConfig().hasI18nSettings, isFalse);
      expect(I18nConfig(text: I18nText(key: 'k', defaultText: 'd')).hasI18nSettings, isTrue);
    });

    test('Normal: with currency format', () {
      final json = {'key': 'price', 'fallback': '\$100', 'currency': 'USD'};
      final i18n = I18nConfig.fromJson(json);
      expect(i18n.numberFormat, isNotNull);
      expect(i18n.numberFormat!.currency, equals('USD'));
    });
  });

  // TC-042: CachePolicy.fromJson
  group('TC-042: CachePolicy', () {
    test('Normal: parse all fields', () {
      final json = {
        'ttl': 60000,
        'strategy': 'cacheFirst',
        'maxSize': 1048576,
        'maxEntries': 100,
        'evictionPolicy': 'lru',
      };

      final policy = CachePolicy.fromJson(json);

      expect(policy.ttl, equals(60000));
      expect(policy.strategy, equals('cacheFirst'));
      expect(policy.maxSize, equals(1048576));
      expect(policy.maxEntries, equals(100));
      expect(policy.evictionPolicy, equals('lru'));
    });

    test('Boundary: strategy values', () {
      for (final strategy in ['networkFirst', 'cacheFirst', 'networkOnly', 'cacheOnly']) {
        final policy = CachePolicy.fromJson({'strategy': strategy});
        expect(policy.strategy, equals(strategy));
      }
    });

    test('Boundary: defaults', () {
      final policy = CachePolicy.fromJson({});
      expect(policy.strategy, equals('networkFirst'));
      expect(policy.evictionPolicy, equals('lru'));
    });

    test('Normal: toJson round-trip', () {
      final original = CachePolicy(ttl: 5000, strategy: 'cacheFirst', maxEntries: 50);
      final json = original.toJson();
      final restored = CachePolicy.fromJson(json);
      expect(restored, equals(original));
    });
  });

  // TC-043~046: PermissionDefinition
  group('TC-043: PermissionDefinition', () {
    test('Normal: parse complete permission config', () {
      final json = {
        'file': {
          'read': {'paths': ['./config'], 'extensions': ['json', 'txt']},
          'write': {'paths': ['./output'], 'maxSize': '10MB'},
        },
        'network': {
          'http': {'domains': ['api.example.com', '*.mydomain.com']},
          'websocket': {'domains': ['ws.example.com']},
        },
        'system': {
          'info': ['platform', 'memory'],
          'exec': {'commands': ['ls', 'cat']},
          'clipboard': true,
        },
      };

      final perm = PermissionDefinition.fromJson(json);

      expect(perm.file, isNotNull);
      expect(perm.file!.read, isNotNull);
      expect(perm.file!.read!.paths, contains('./config'));
      expect(perm.file!.write, isNotNull);
      expect(perm.file!.write!.maxSize, equals('10MB'));
      expect(perm.network, isNotNull);
      expect(perm.network!.http!.domains, contains('api.example.com'));
      expect(perm.network!.websocket!.domains, contains('ws.example.com'));
      expect(perm.system, isNotNull);
      expect(perm.system!.info, containsAll(['platform', 'memory']));
      expect(perm.system!.exec!.commands, contains('ls'));
      expect(perm.system!.clipboard, isTrue);
    });

    test('Boundary: simplified form (list of strings)', () {
      final json = {
        'file': ['read', 'write'],
        'network': ['http'],
      };

      final perm = PermissionDefinition.fromJson(json);

      expect(perm.file!.read, isNotNull);
      expect(perm.file!.write, isNotNull);
      expect(perm.network!.http, isNotNull);
    });
  });

  // TC-044: FilePermission detailed parsing
  group('TC-044: FilePermission', () {
    test('Normal: parse read with restrictions', () {
      final json = {
        'read': {
          'paths': ['./data'],
          'extensions': ['json'],
          'excludePaths': ['./data/secret'],
          'maxSize': '5MB',
        },
      };

      final perm = FilePermission.fromJson(json);
      expect(perm.read!.paths, contains('./data'));
      expect(perm.read!.extensions, contains('json'));
      expect(perm.read!.excludePaths, contains('./data/secret'));
      expect(perm.read!.maxSize, equals('5MB'));
    });

    test('Normal: parse write with all fields', () {
      final json = {
        'write': {
          'paths': ['./output'],
          'extensions': ['txt'],
          'maxSize': '10MB',
          'excludePaths': ['./output/locked'],
          'createDirectories': true,
          'overwritePolicy': 'prompt',
        },
      };

      final perm = FilePermission.fromJson(json);
      expect(perm.write!.createDirectories, isTrue);
      expect(perm.write!.overwritePolicy, equals('prompt'));
    });
  });

  // TC-045: NetworkPermission parsing
  group('TC-045: NetworkPermission', () {
    test('Normal: parse domains with wildcards', () {
      final json = {
        'http': {'domains': ['api.example.com', '*.mydomain.com']},
        'websocket': {'domains': ['ws.example.com']},
      };

      final perm = NetworkPermission.fromJson(json);
      expect(perm.http!.domains, contains('*.mydomain.com'));
      expect(perm.websocket!.domains, contains('ws.example.com'));
    });

    test('Boundary: empty domains list', () {
      final perm = NetworkHttpPermission.fromJson({'domains': []});
      expect(perm.domains, isEmpty);
    });
  });

  // TC-046: SystemPermission parsing
  group('TC-046: SystemPermission', () {
    test('Normal: parse system permission', () {
      final json = {
        'info': ['platform', 'memory'],
        'exec': {'commands': ['ls', 'cat']},
        'clipboard': true,
      };

      final perm = SystemPermission.fromJson(json);
      expect(perm.info, containsAll(['platform', 'memory']));
      expect(perm.exec!.commands, containsAll(['ls', 'cat']));
      expect(perm.clipboard, isTrue);
    });

    test('Boundary: clipboard defaults', () {
      final perm = SystemPermission.fromJson({});
      expect(perm.clipboard, isNull);
    });
  });

  // TC-047~048: ChannelDefinition
  group('TC-047: ChannelDefinition', () {
    test('Normal: parse all 5 channel types', () {
      final types = [
        {'type': 'client.watchFile', 'path': './config.json', 'events': ['change']},
        {'type': 'client.watchDirectory', 'path': './data', 'recursive': true},
        {'type': 'client.systemMonitor', 'metrics': ['cpu', 'memory'], 'interval': 5000},
        {
          'type': 'client.poll',
          'action': {'type': 'tool', 'tool': 'fetchStatus'},
          'interval': 10000,
          'binding': 'status',
        },
        {'type': 'client.websocket', 'url': 'ws://localhost:8080'},
      ];

      for (final json in types) {
        final channel = ChannelDefinition.fromJson(json);
        expect(channel.type, equals(json['type']));
      }
    });

    test('Boundary: autoStart defaults to false', () {
      final channel = ChannelDefinition.fromJson({'type': 'client.watchFile', 'path': 'test'});
      expect(channel.autoStart, isFalse);
    });

    test('Normal: autoStart can be set to true', () {
      final channel = ChannelDefinition.fromJson({'type': 'client.watchFile', 'path': 'test', 'autoStart': true});
      expect(channel.autoStart, isTrue);
    });
  });

  // TC-048: ChannelDefinition per-type parameters
  group('TC-048: ChannelDefinition params', () {
    test('Normal: watchFile params', () {
      final channel = ChannelDefinition.fromJson({
        'type': 'client.watchFile',
        'path': './config.json',
        'events': ['change', 'rename'],
      });

      expect(channel.params!['path'], equals('./config.json'));
      expect(channel.params!['events'], containsAll(['change', 'rename']));
    });

    test('Normal: poll channel with nested action', () {
      final channel = ChannelDefinition.fromJson({
        'type': 'client.poll',
        'action': {'type': 'tool', 'tool': 'fetchStatus'},
        'interval': 5000,
        'binding': 'apiStatus',
      });

      expect(channel.action, isNotNull);
      expect(channel.binding, equals('apiStatus'));
      expect(channel.params!['interval'], equals(5000));
    });

    test('Normal: toJson round-trip', () {
      final original = ChannelDefinition(
        type: 'client.systemMonitor',
        params: {'metrics': ['cpu'], 'interval': 3000},
        binding: 'sysInfo',
        autoStart: true,
      );

      final json = original.toJson();
      final restored = ChannelDefinition.fromJson(json);

      expect(restored.type, equals('client.systemMonitor'));
      expect(restored.binding, equals('sysInfo'));
    });
  });
}
