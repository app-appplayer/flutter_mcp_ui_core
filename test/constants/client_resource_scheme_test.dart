import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-049: ClientResourceSchemes constants
  group('TC-049: ClientResourceSchemes constants', () {
    test('Normal: protocol constant defined', () {
      expect(ClientResourceSchemes.protocol, equals('client://'));
    });

    test('Normal: file scheme constant defined', () {
      expect(ClientResourceSchemes.file, equals('client://file'));
      expect(ClientResourceSchemes.file, startsWith(ClientResourceSchemes.protocol));
    });

    test('Normal: workspace scheme constant defined', () {
      expect(ClientResourceSchemes.workspace, equals('client://workspace'));
      expect(ClientResourceSchemes.workspace, startsWith(ClientResourceSchemes.protocol));
    });

    test('Normal: temp scheme constant defined', () {
      expect(ClientResourceSchemes.temp, equals('client://temp'));
      expect(ClientResourceSchemes.temp, startsWith(ClientResourceSchemes.protocol));
    });

    test('Normal: cache scheme constant defined', () {
      expect(ClientResourceSchemes.cache, equals('client://cache'));
      expect(ClientResourceSchemes.cache, startsWith(ClientResourceSchemes.protocol));
    });

    test('Normal: all 5 scheme constants are distinct', () {
      final schemes = {
        ClientResourceSchemes.protocol,
        ClientResourceSchemes.file,
        ClientResourceSchemes.workspace,
        ClientResourceSchemes.temp,
        ClientResourceSchemes.cache,
      };
      expect(schemes.length, equals(5));
    });
  });

  // ChannelActionTypes constants
  group('ChannelActionTypes constants', () {
    test('Normal: all 5 channel action types defined', () {
      expect(ChannelActionTypes.start, equals('channel.start'));
      expect(ChannelActionTypes.stop, equals('channel.stop'));
      expect(ChannelActionTypes.toggle, equals('channel.toggle'));
      expect(ChannelActionTypes.restart, equals('channel.restart'));
      expect(ChannelActionTypes.send, equals('channel.send'));
    });

    test('Normal: all list contains all types', () {
      expect(ChannelActionTypes.all, containsAll([
        'channel.start', 'channel.stop', 'channel.toggle',
        'channel.restart', 'channel.send',
      ]));
      expect(ChannelActionTypes.all.length, equals(5));
    });

    test('Normal: isChannelAction recognizes valid types', () {
      expect(ChannelActionTypes.isChannelAction('channel.start'), isTrue);
      expect(ChannelActionTypes.isChannelAction('channel.stop'), isTrue);
      expect(ChannelActionTypes.isChannelAction('channel.custom'), isTrue);
    });

    test('Boundary: isChannelAction rejects non-channel types', () {
      expect(ChannelActionTypes.isChannelAction('state'), isFalse);
      expect(ChannelActionTypes.isChannelAction('tool'), isFalse);
      expect(ChannelActionTypes.isChannelAction(null), isFalse);
    });
  });

  // MCPUIDSLVersion constants
  group('MCPUIDSLVersion constants', () {
    test('Normal: current version is 1.3', () {
      expect(MCPUIDSLVersion.current, equals('1.3'));
    });

    test('Normal: minimum version is 1.3', () {
      expect(MCPUIDSLVersion.minimum, equals('1.3'));
    });

    test('Normal: supported list is [1.3]', () {
      expect(MCPUIDSLVersion.supported, equals(['1.3']));
    });

    test('Normal: isCompatible works for 2-part and 3-part 1.3', () {
      expect(MCPUIDSLVersion.isCompatible('1.3'), isTrue);
      expect(MCPUIDSLVersion.isCompatible('1.3.0'), isTrue);
      expect(MCPUIDSLVersion.isCompatible('1.3.5'), isTrue);
    });

    test('Boundary: isCompatible rejects pre-reset and future versions', () {
      expect(MCPUIDSLVersion.isCompatible('1.0.0'), isFalse);
      expect(MCPUIDSLVersion.isCompatible('1.2.0'), isFalse);
      expect(MCPUIDSLVersion.isCompatible('2.0.0'), isFalse);
    });

    test('Normal: resolve collapses unknown / missing stamps to current', () {
      expect(MCPUIDSLVersion.resolve(null), equals('1.3'));
      expect(MCPUIDSLVersion.resolve(123), equals('1.3'));
      expect(MCPUIDSLVersion.resolve('9.9'), equals('1.3'));
      expect(MCPUIDSLVersion.resolve('1.0'), equals('1.3'));
      expect(MCPUIDSLVersion.resolve('1.3'), equals('1.3'));
      expect(MCPUIDSLVersion.resolve('1.3.0'), equals('1.3'));
    });

    test('Normal: getLatestCompatible returns current', () {
      expect(MCPUIDSLVersion.getLatestCompatible(), equals(MCPUIDSLVersion.current));
    });
  });
}
