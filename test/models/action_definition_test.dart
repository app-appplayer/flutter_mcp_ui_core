import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-017: StateActionDefinition.fromJson
  group('TC-017: StateActionDefinition', () {
    test('Normal: parse state set action', () {
      final json = {'type': 'state', 'action': 'set', 'binding': 'counter', 'value': 0};
      final action = ActionDefinition.fromJson(json) as StateActionDefinition;

      expect(action.type, equals('state'));
      expect(action.action, equals('set'));
      expect(action.binding, equals('counter'));
      expect(action.value, equals(0));
    });

    test('Boundary: all 9 operations', () {
      for (final op in ['set', 'increment', 'decrement', 'toggle', 'append', 'remove', 'push', 'pop', 'removeAt']) {
        final json = {'type': 'state', 'action': op, 'binding': 'test'};
        final action = ActionDefinition.fromJson(json) as StateActionDefinition;
        expect(action.action, equals(op));
      }
    });

    test('Normal: toJson round-trip', () {
      final original = StateActionDefinition(action: 'set', binding: 'counter', value: 42);
      final json = original.toJson();
      final restored = ActionDefinition.fromJson(json) as StateActionDefinition;

      expect(restored.action, equals('set'));
      expect(restored.binding, equals('counter'));
      expect(restored.value, equals(42));
    });
  });

  // TC-018: NavigationActionDefinition.fromJson
  group('TC-018: NavigationActionDefinition', () {
    test('Normal: parse push action', () {
      final json = {'type': 'navigation', 'action': 'push', 'route': '/page', 'params': {'id': '1'}};
      final action = ActionDefinition.fromJson(json) as NavigationActionDefinition;

      expect(action.action, equals('push'));
      expect(action.route, equals('/page'));
      expect(action.params!['id'], equals('1'));
    });

    test('Boundary: pop action no route needed', () {
      final json = {'type': 'navigation', 'action': 'pop'};
      final action = ActionDefinition.fromJson(json) as NavigationActionDefinition;
      expect(action.action, equals('pop'));
      expect(action.route, isNull);
    });

    test('Boundary: setIndex action', () {
      final json = {'type': 'navigation', 'action': 'setIndex', 'params': {'index': 2}};
      final action = ActionDefinition.fromJson(json) as NavigationActionDefinition;
      expect(action.action, equals('setIndex'));
    });
  });

  // TC-019: ToolActionDefinition.fromJson
  group('TC-019: ToolActionDefinition', () {
    test('Normal: parse with all fields', () {
      final json = {
        'type': 'tool',
        'tool': 'fetchData',
        'params': {'url': 'https://api.test.com'},
        'onSuccess': {'type': 'state', 'action': 'set', 'binding': 'data', 'value': null},
        'onError': {'type': 'notification', 'message': 'Error'},
        'timeout': 30000,
        'cancellable': true,
        'bindResult': 'result',
      };

      final action = ActionDefinition.fromJson(json) as ToolActionDefinition;

      expect(action.tool, equals('fetchData'));
      expect(action.params!['url'], equals('https://api.test.com'));
      expect(action.onSuccess, isNotNull);
      expect(action.onError, isNotNull);
      expect(action.timeout, equals(30000));
      expect(action.cancellable, isTrue);
      expect(action.bindResult, equals('result'));
    });

    test('Boundary: minimal tool action', () {
      final json = {'type': 'tool', 'tool': 'simpleTool'};
      final action = ActionDefinition.fromJson(json) as ToolActionDefinition;
      expect(action.tool, equals('simpleTool'));
      expect(action.params, isNull);
    });
  });

  // TC-024: ResourceActionDefinition.fromJson
  group('TC-024: ResourceActionDefinition', () {
    test('Normal: parse subscribe action', () {
      final json = {'type': 'resource', 'action': 'subscribe', 'uri': 'data://temp', 'binding': 'temp'};
      final action = ActionDefinition.fromJson(json) as ResourceActionDefinition;

      expect(action.action, equals('subscribe'));
      expect(action.uri, equals('data://temp'));
      expect(action.binding, equals('temp'));
    });

    test('Boundary: unsubscribe no binding', () {
      final json = {'type': 'resource', 'action': 'unsubscribe', 'uri': 'data://temp'};
      final action = ActionDefinition.fromJson(json) as ResourceActionDefinition;
      expect(action.action, equals('unsubscribe'));
    });
  });

  // TC-025: DialogActionDefinition.fromJson
  group('TC-025: DialogActionDefinition', () {
    test('Normal: parse dialog with actions', () {
      final json = {
        'type': 'dialog',
        'dialogType': 'alert',
        'title': 'Confirm',
        'content': 'Are you sure?',
        'dismissible': true,
        'actions': [
          {'label': 'Cancel', 'action': 'close'},
          {'label': 'OK', 'action': {'type': 'state', 'action': 'set', 'binding': 'confirmed', 'value': true}},
        ],
      };

      final action = ActionDefinition.fromJson(json) as DialogActionDefinition;

      expect(action.dialogType, equals('alert'));
      expect(action.title, equals('Confirm'));
      expect(action.content, equals('Are you sure?'));
      expect(action.dismissible, isTrue);
    });
  });

  // TC-026: BatchActionDefinition.fromJson
  group('TC-026: BatchActionDefinition', () {
    test('Normal: parse batch with actions', () {
      final json = {
        'type': 'batch',
        'actions': [
          {'type': 'state', 'action': 'set', 'binding': 'a', 'value': 1},
          {'type': 'state', 'action': 'set', 'binding': 'b', 'value': 2},
        ],
        'sequential': true,
        'stopOnError': false,
      };

      final action = ActionDefinition.fromJson(json) as BatchActionDefinition;

      expect(action.actions.length, equals(2));
      expect(action.sequential, isTrue);
      expect(action.stopOnError, isFalse);
    });

    test('Boundary: empty actions list', () {
      final json = {'type': 'batch', 'actions': []};
      final action = ActionDefinition.fromJson(json) as BatchActionDefinition;
      expect(action.actions, isEmpty);
    });
  });

  // TC-027: ConditionalActionDefinition.fromJson
  group('TC-027: ConditionalActionDefinition', () {
    test('Normal: parse with then and else', () {
      final json = {
        'type': 'conditional',
        'condition': '{{x > 0}}',
        'then': {'type': 'state', 'action': 'set', 'binding': 'result', 'value': 'positive'},
        'else': {'type': 'state', 'action': 'set', 'binding': 'result', 'value': 'non-positive'},
      };

      final action = ActionDefinition.fromJson(json) as ConditionalActionDefinition;

      expect(action.condition, equals('{{x > 0}}'));
      expect(action.thenAction, isNotNull);
      expect(action.elseAction, isNotNull);
    });

    test('Boundary: no else branch', () {
      final json = {
        'type': 'conditional',
        'condition': '{{flag}}',
        'then': {'type': 'state', 'action': 'toggle', 'binding': 'flag'},
      };

      final action = ActionDefinition.fromJson(json) as ConditionalActionDefinition;
      expect(action.elseAction, isNull);
    });
  });

  // TC-028: NotificationActionDefinition.fromJson
  group('TC-028: NotificationActionDefinition', () {
    test('Normal: parse with all fields', () {
      final json = {
        'type': 'notification',
        'message': 'Saved successfully',
        'severity': 'success',
        'duration': 3000,
        'position': 'bottom',
      };

      final action = ActionDefinition.fromJson(json) as NotificationActionDefinition;

      expect(action.message, equals('Saved successfully'));
      expect(action.severity, equals('success'));
      expect(action.duration, equals(3000));
    });
  });

  // TC-029: ParallelActionDefinition.fromJson
  group('TC-029: ParallelActionDefinition', () {
    test('Normal: parse parallel actions', () {
      final json = {
        'type': 'parallel',
        'actions': [
          {'type': 'tool', 'tool': 'fetchA'},
          {'type': 'tool', 'tool': 'fetchB'},
        ],
      };

      final action = ActionDefinition.fromJson(json) as ParallelActionDefinition;
      expect(action.actions.length, equals(2));
    });
  });

  // TC-030: SequenceActionDefinition.fromJson
  group('TC-030: SequenceActionDefinition', () {
    test('Normal: parse sequence actions', () {
      final json = {
        'type': 'sequence',
        'actions': [
          {'type': 'state', 'action': 'set', 'binding': 'step', 'value': 1},
          {'type': 'tool', 'tool': 'process'},
          {'type': 'state', 'action': 'set', 'binding': 'step', 'value': 2},
        ],
      };

      final action = ActionDefinition.fromJson(json) as SequenceActionDefinition;
      expect(action.actions.length, equals(3));
    });
  });

  // TC-031: AnimationActionDefinition.fromJson
  group('TC-031: AnimationActionDefinition', () {
    test('Normal: parse animation action', () {
      final json = {'type': 'animation', 'action': 'play', 'target': 'anim1'};
      final action = ActionDefinition.fromJson(json) as AnimationActionDefinition;

      expect(action.action, equals('play'));
      expect(action.target, equals('anim1'));
    });

    test('Boundary: all animation actions', () {
      for (final animAction in ['play', 'reverse', 'pause', 'resume', 'reset', 'stop']) {
        final json = {'type': 'animation', 'action': animAction, 'target': 'test'};
        final action = ActionDefinition.fromJson(json) as AnimationActionDefinition;
        expect(action.action, equals(animAction));
      }
    });
  });

  // TC-022: CancelActionDefinition.fromJson
  group('TC-022: CancelActionDefinition', () {
    test('Normal: parse cancel action', () {
      final json = {'type': 'cancel', 'target': 'myToolCall'};
      final action = ActionDefinition.fromJson(json) as CancelActionDefinition;
      expect(action.target, equals('myToolCall'));
    });
  });

  // TC-023: PermissionRevokeActionDefinition.fromJson
  group('TC-023: PermissionRevokeActionDefinition', () {
    test('Normal: parse permission revoke', () {
      final json = {'type': 'permission.revoke', 'permissions': ['file.read', 'network.http']};
      final action = ActionDefinition.fromJson(json) as PermissionRevokeActionDefinition;
      expect(action.permissions, containsAll(['file.read', 'network.http']));
    });
  });

  // TC-033: ClientActionDefinition.fromJson
  group('TC-033: ClientActionDefinition', () {
    test('Normal: parse client action', () {
      final json = {
        'type': 'client.readFile',
        'params': {'path': '/test.txt'},
        'onSuccess': {'type': 'state', 'action': 'set', 'binding': 'content', 'value': null},
        'confirmMessage': 'Read this file?',
      };

      final action = ActionDefinition.fromJson(json) as ClientActionDefinition;
      expect(action.action, equals('client.readFile'));
    });

    test('Boundary: all client action types dispatch correctly', () {
      for (final clientType in [
        'client.selectFile', 'client.readFile', 'client.writeFile',
        'client.saveFile', 'client.listFiles', 'client.httpRequest',
        'client.getSystemInfo', 'client.clipboard', 'client.exec',
      ]) {
        final json = {'type': clientType};
        final action = ActionDefinition.fromJson(json);
        expect(action, isA<ClientActionDefinition>());
      }
    });
  });

  // TC-034: ChannelActionDefinition.fromJson
  group('TC-034: ChannelActionDefinition', () {
    test('Normal: parse channel action', () {
      final json = {'type': 'channel.start', 'channel': 'systemMonitor'};
      final action = ActionDefinition.fromJson(json) as ChannelActionDefinition;
      expect(action.channel, equals('systemMonitor'));
    });

    test('Boundary: all channel action types', () {
      for (final channelType in ['channel.start', 'channel.stop', 'channel.restart', 'channel.toggle', 'channel.send']) {
        final json = {'type': channelType, 'channel': 'test'};
        final action = ActionDefinition.fromJson(json);
        expect(action, isA<ChannelActionDefinition>());
      }
    });
  });

  // TC-032: ActionDefinition factory dispatch
  group('TC-032: ActionDefinition factory dispatch', () {
    test('Normal: each type dispatches correctly', () {
      expect(ActionDefinition.fromJson({'type': 'state', 'action': 'set', 'binding': 'x'}), isA<StateActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'navigation', 'action': 'push'}), isA<NavigationActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'tool', 'tool': 'test'}), isA<ToolActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'resource', 'action': 'subscribe', 'uri': 'test'}), isA<ResourceActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'dialog', 'dialogType': 'alert'}), isA<DialogActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'batch', 'actions': []}), isA<BatchActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'conditional', 'condition': 'x', 'then': {'type': 'state', 'action': 'set', 'binding': 'x'}}), isA<ConditionalActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'notification', 'message': 'hi'}), isA<NotificationActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'parallel', 'actions': []}), isA<ParallelActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'sequence', 'actions': []}), isA<SequenceActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'animation', 'action': 'play', 'target': 'x'}), isA<AnimationActionDefinition>());
      expect(ActionDefinition.fromJson({'type': 'cancel', 'target': 'x'}), isA<CancelActionDefinition>());
    });

    test('Error: missing type field throws ArgumentError', () {
      expect(() => ActionDefinition.fromJson({}), throwsArgumentError);
    });

    test('Error: unknown type throws ArgumentError', () {
      expect(() => ActionDefinition.fromJson({'type': 'unknown_type'}), throwsArgumentError);
    });
  });
}
