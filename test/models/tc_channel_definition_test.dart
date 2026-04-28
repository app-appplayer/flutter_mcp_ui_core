// TC-078 ~ TC-079: ChannelDefinition Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-078: ChannelDefinition.fromJson (v1.1)
  // =========================================================================
  group('TC-078: ChannelDefinition.fromJson', () {
    test('Normal: parse all fields', () {
      final json = {
        'type': 'client.systemMonitor',
        'metrics': ['cpu', 'memory'],
        'interval': 5000,
        'binding': 'systemStats',
        'autoStart': true,
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.type, equals('client.systemMonitor'));
      expect(ch.params, isNotNull);
      expect(ch.params!['metrics'], equals(['cpu', 'memory']));
      expect(ch.params!['interval'], equals(5000));
      expect(ch.binding, equals('systemStats'));
      expect(ch.autoStart, isTrue);
    });

    test('Boundary: autoStart defaults to false', () {
      final json = {
        'type': 'client.watchFile',
        'path': './config.json',
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.autoStart, isFalse);
    });

    test('Boundary: all 5 channel types', () {
      final types = [
        'client.watchFile',
        'client.watchDirectory',
        'client.systemMonitor',
        'client.poll',
        'client.websocket',
      ];

      for (final type in types) {
        final ch = ChannelDefinition.fromJson({'type': type});
        expect(ch.type, equals(type));
      }
    });

    test('Error: unknown channel type handled gracefully', () {
      final json = {'type': 'client.unknownChannel'};
      // Should parse without exception
      final ch = ChannelDefinition.fromJson(json);
      expect(ch.type, equals('client.unknownChannel'));
    });
  });

  // =========================================================================
  // TC-079: ChannelDefinition per-type parameters
  // =========================================================================
  group('TC-079: ChannelDefinition per-type parameters', () {
    test('Normal: watchFile params', () {
      final json = {
        'type': 'client.watchFile',
        'path': './config.json',
        'events': ['change', 'rename', 'delete'],
        'binding': 'fileStatus',
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.params!['path'], equals('./config.json'));
      expect(ch.params!['events'], equals(['change', 'rename', 'delete']));
    });

    test('Normal: watchDirectory params', () {
      final json = {
        'type': 'client.watchDirectory',
        'path': './data',
        'recursive': true,
        'pattern': '*.json',
        'events': ['change', 'create', 'delete'],
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.params!['path'], equals('./data'));
      expect(ch.params!['recursive'], isTrue);
      expect(ch.params!['pattern'], equals('*.json'));
    });

    test('Normal: systemMonitor params', () {
      final json = {
        'type': 'client.systemMonitor',
        'metrics': ['cpu', 'memory'],
        'interval': 5000,
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.params!['metrics'], equals(['cpu', 'memory']));
      expect(ch.params!['interval'], equals(5000));
    });

    test('Normal: poll channel with action', () {
      final json = {
        'type': 'client.poll',
        'action': {
          'type': 'tool',
          'tool': 'checkStatus',
        },
        'interval': 10000,
        'binding': 'apiStatus',
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.action, isNotNull);
      expect(ch.action, isA<ToolActionDefinition>());
      expect(ch.params!['interval'], equals(10000));
    });

    test('Normal: websocket params', () {
      final json = {
        'type': 'client.websocket',
        'url': 'wss://api.example.com/ws',
        'protocols': ['graphql-ws'],
        'headers': {'Authorization': 'Bearer token'},
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.params!['url'], equals('wss://api.example.com/ws'));
      expect(ch.params!['protocols'], equals(['graphql-ws']));
      expect(ch.params!['headers'], isA<Map>());
    });

    test('Boundary: watchFile events subset', () {
      final json = {
        'type': 'client.watchFile',
        'path': './file.txt',
        'events': ['change'],
      };

      final ch = ChannelDefinition.fromJson(json);
      expect(ch.params!['events'], equals(['change']));
    });
  });
}
