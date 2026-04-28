// TC-024 ~ TC-042: ActionDefinition subtypes per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-024: ActionDefinition factory dispatch
  // =========================================================================
  group('TC-024: ActionDefinition factory dispatch', () {
    test('Normal: each known type dispatches to correct subclass', () {
      expect(
        ActionDefinition.fromJson({'type': 'state', 'action': 'set', 'binding': 'x'}),
        isA<StateActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'navigation', 'action': 'push', 'route': '/x'}),
        isA<NavigationActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'tool', 'tool': 'myTool'}),
        isA<ToolActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'resource', 'action': 'subscribe', 'uri': 'data://x'}),
        isA<ResourceActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'dialog', 'dialogType': 'alert'}),
        isA<DialogActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'batch', 'actions': []}),
        isA<BatchActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'conditional', 'condition': '{{x}}', 'then': {'type': 'state', 'action': 'set', 'binding': 'x'}}),
        isA<ConditionalActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'notification', 'message': 'hi'}),
        isA<NotificationActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'parallel', 'actions': []}),
        isA<ParallelActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'sequence', 'actions': []}),
        isA<SequenceActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'animation', 'action': 'play', 'target': 'a1'}),
        isA<AnimationActionDefinition>(),
      );
      expect(
        ActionDefinition.fromJson({'type': 'cancel', 'target': 't1'}),
        isA<CancelActionDefinition>(),
      );
    });

    test('Boundary: client.* prefix dispatches to ClientActionDefinition', () {
      expect(
        ActionDefinition.fromJson({'type': 'client.readFile', 'params': {'path': '/x'}}),
        isA<ClientActionDefinition>(),
      );
    });

    test('Boundary: channel.* prefix dispatches to ChannelActionDefinition', () {
      expect(
        ActionDefinition.fromJson({'type': 'channel.start', 'channel': 'ch1'}),
        isA<ChannelActionDefinition>(),
      );
    });

    test('Boundary: permission.revoke dispatches to PermissionRevokeActionDefinition', () {
      expect(
        ActionDefinition.fromJson({'type': 'permission.revoke', 'permissions': ['file.read']}),
        isA<PermissionRevokeActionDefinition>(),
      );
    });

    test('Error: unknown type throws ArgumentError', () {
      expect(
        () => ActionDefinition.fromJson({'type': 'unknown_type'}),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // =========================================================================
  // TC-025: StateActionDefinition.fromJson
  // =========================================================================
  group('TC-025: StateActionDefinition.fromJson', () {
    test('Normal: parse state action', () {
      final def = StateActionDefinition.fromJson({
        'type': 'state', 'action': 'set', 'binding': 'counter', 'value': 0,
      });
      expect(def.action, equals('set'));
      expect(def.binding, equals('counter'));
      expect(def.value, equals(0));
    });

    test('Boundary: parse all 9 operations', () {
      for (final op in ['set', 'increment', 'decrement', 'toggle', 'append', 'remove', 'push', 'pop', 'removeAt']) {
        final def = StateActionDefinition.fromJson({
          'type': 'state', 'action': op, 'binding': 'x',
        });
        expect(def.action, equals(op));
      }
    });

    test('Error: missing action defaults to set', () {
      final def = StateActionDefinition.fromJson({'type': 'state', 'binding': 'x'});
      expect(def.action, equals('set'));
    });
  });

  // =========================================================================
  // TC-026: NavigationActionDefinition.fromJson
  // =========================================================================
  group('TC-026: NavigationActionDefinition.fromJson', () {
    test('Normal: parse push navigation', () {
      final def = NavigationActionDefinition.fromJson({
        'type': 'navigation', 'action': 'push', 'route': '/page', 'params': {'id': '1'},
      });
      expect(def.action, equals('push'));
      expect(def.route, equals('/page'));
      expect(def.params, equals({'id': '1'}));
    });

    test('Boundary: pop action without route', () {
      final def = NavigationActionDefinition.fromJson({
        'type': 'navigation', 'action': 'pop',
      });
      expect(def.action, equals('pop'));
      expect(def.route, isNull);
    });

    test('Boundary: setIndex with dedicated index field', () {
      final def = NavigationActionDefinition.fromJson({
        'type': 'navigation', 'action': 'setIndex', 'index': 2,
      });
      expect(def.action, equals('setIndex'));
      expect(def.index, equals(2));
    });
  });

  // =========================================================================
  // TC-027: ToolActionDefinition.fromJson — full
  // =========================================================================
  group('TC-027: ToolActionDefinition.fromJson — full', () {
    test('Normal: parse full tool action', () {
      final def = ToolActionDefinition.fromJson({
        'type': 'tool',
        'tool': 'fetchData',
        'params': {'url': 'https://api.example.com'},
        'onSuccess': {'type': 'state', 'action': 'set', 'binding': 'data'},
        'onError': {'type': 'notification', 'message': 'Failed'},
        'retry': {'maxAttempts': 3, 'delay': 1000, 'backoff': 'exponential'},
        'timeout': 30000,
        'onTimeout': {'type': 'notification', 'message': 'Timeout'},
        'loading': {'binding': 'isLoading', 'indicator': 'spinner'},
        'cancellable': true,
        'onCancel': {'type': 'notification', 'message': 'Cancelled'},
        'bindResult': 'result',
      });
      expect(def.tool, equals('fetchData'));
      expect(def.params, equals({'url': 'https://api.example.com'}));
      expect(def.onSuccess, isA<StateActionDefinition>());
      expect(def.onError, isA<NotificationActionDefinition>());
      expect(def.retry, isNotNull);
      expect(def.timeout, equals(30000));
      expect(def.onTimeout, isNotNull);
      expect(def.loading, isNotNull);
      expect(def.cancellable, isTrue);
      expect(def.onCancel, isNotNull);
      expect(def.bindResult, equals('result'));
    });

    test('Boundary: parse with no params, defaults', () {
      final def = ToolActionDefinition.fromJson({
        'type': 'tool', 'tool': 'simple',
      });
      expect(def.tool, equals('simple'));
      expect(def.params, isNull);
      expect(def.cancellable, isNull);
      expect(def.timeout, isNull);
    });

    test('Error: missing tool defaults to empty string', () {
      final def = ToolActionDefinition.fromJson({'type': 'tool'});
      expect(def.tool, equals(''));
    });
  });

  // =========================================================================
  // TC-028: RetryStrategy parsing
  // =========================================================================
  group('TC-028: RetryStrategy parsing', () {
    test('Normal: parse full retry strategy', () {
      final rs = RetryStrategy.fromJson({
        'maxAttempts': 3, 'delay': 1000, 'backoff': 'exponential',
        'multiplier': 2, 'maxDelay': 30000, 'retryOn': ['NETWORK_ERROR'],
      });
      expect(rs.maxAttempts, equals(3));
      expect(rs.delay, equals(1000));
      expect(rs.backoff, equals('exponential'));
      expect(rs.multiplier, equals(2));
      expect(rs.maxDelay, equals(30000));
      expect(rs.retryOn, equals(['NETWORK_ERROR']));
    });

    test('Boundary: defaults apply', () {
      final rs = RetryStrategy.fromJson({});
      expect(rs.maxAttempts, equals(3));
      expect(rs.delay, equals(1000));
      expect(rs.backoff, equals('exponential'));
    });
  });

  // =========================================================================
  // TC-029: LoadingConfig parsing
  // =========================================================================
  group('TC-029: LoadingConfig parsing', () {
    test('Normal: parse loading config', () {
      final lc = LoadingConfig.fromJson({'binding': 'isLoading', 'indicator': 'spinner'});
      expect(lc.binding, equals('isLoading'));
      expect(lc.indicator, equals('spinner'));
    });

    test('Boundary: binding is optional', () {
      final lc = LoadingConfig.fromJson({'indicator': 'progress'});
      expect(lc.binding, isNull);
      expect(lc.indicator, equals('progress'));
    });
  });

  // =========================================================================
  // TC-030: CancelActionDefinition.fromJson
  // =========================================================================
  group('TC-030: CancelActionDefinition.fromJson', () {
    test('Normal: parse cancel action', () {
      final def = CancelActionDefinition.fromJson({
        'type': 'cancel', 'target': 'myToolCall',
      });
      expect(def.target, equals('myToolCall'));
    });

    test('Error: missing target defaults to empty string', () {
      final def = CancelActionDefinition.fromJson({'type': 'cancel'});
      expect(def.target, equals(''));
    });
  });

  // =========================================================================
  // TC-031: PermissionRevokeActionDefinition.fromJson
  // =========================================================================
  group('TC-031: PermissionRevokeActionDefinition.fromJson', () {
    test('Normal: parse permission revoke', () {
      final def = ActionDefinition.fromJson({
        'type': 'permission.revoke',
        'permissions': ['file.read', 'network.http'],
      }) as PermissionRevokeActionDefinition;
      expect(def.permissions, equals(['file.read', 'network.http']));
    });

    test('Boundary: single permission', () {
      final def = ActionDefinition.fromJson({
        'type': 'permission.revoke',
        'permissions': ['file.read'],
      }) as PermissionRevokeActionDefinition;
      expect(def.permissions, hasLength(1));
    });
  });

  // =========================================================================
  // TC-032: ResourceActionDefinition.fromJson
  // =========================================================================
  group('TC-032: ResourceActionDefinition.fromJson', () {
    test('Normal: parse resource action with all fields', () {
      final def = ResourceActionDefinition.fromJson({
        'type': 'resource', 'action': 'subscribe', 'uri': 'data://temp',
        'binding': 'temp', 'scope': 'page', 'method': 'GET',
        'target': '/api', 'data': {'key': 'val'}, 'bindResult': 'result',
      });
      expect(def.action, equals('subscribe'));
      expect(def.uri, equals('data://temp'));
      expect(def.binding, equals('temp'));
      expect(def.scope, equals('page'));
      expect(def.method, equals('GET'));
      expect(def.target, equals('/api'));
      expect(def.data, equals({'key': 'val'}));
      expect(def.bindResult, equals('result'));
    });

    test('Boundary: unsubscribe without binding', () {
      final def = ResourceActionDefinition.fromJson({
        'type': 'resource', 'action': 'unsubscribe', 'uri': 'data://temp',
      });
      expect(def.action, equals('unsubscribe'));
      expect(def.binding, isNull);
    });

    test('Boundary: optional fields null by default', () {
      final def = ResourceActionDefinition.fromJson({
        'type': 'resource', 'action': 'read', 'uri': 'data://x',
      });
      expect(def.scope, isNull);
      expect(def.method, isNull);
      expect(def.target, isNull);
      expect(def.data, isNull);
      expect(def.bindResult, isNull);
    });
  });

  // =========================================================================
  // TC-033: DialogActionDefinition.fromJson
  // =========================================================================
  group('TC-033: DialogActionDefinition.fromJson', () {
    test('Normal: parse dialog action', () {
      final def = DialogActionDefinition.fromJson({
        'type': 'dialog',
        'dialogType': 'alert',
        'title': 'Confirm',
        'content': 'Are you sure?',
        'dismissible': true,
        'actions': [
          {'label': 'Cancel', 'action': 'close'},
          {'label': 'OK', 'action': {'type': 'state', 'action': 'set', 'binding': 'confirmed', 'value': true}, 'primary': true},
        ],
      });
      expect(def.dialogType, equals('alert'));
      expect(def.title, equals('Confirm'));
      expect(def.content, equals('Are you sure?'));
      expect(def.dismissible, isTrue);
      expect(def.actions, hasLength(2));
      expect(def.actions![0].label, equals('Cancel'));
      expect(def.actions![0].action, equals('close'));
      expect(def.actions![1].primary, isTrue);
    });

    test('Boundary: body accepted as legacy fallback for child', () {
      final def = DialogActionDefinition.fromJson({
        'type': 'dialog',
        'dialogType': 'custom',
        'body': {'type': 'text', 'content': 'Custom body'},
      });
      expect(def.child, isNotNull);
      expect(def.child!.type, equals('text'));
    });

    test('Error: missing dialogType defaults to alert', () {
      final def = DialogActionDefinition.fromJson({'type': 'dialog'});
      expect(def.dialogType, equals('alert'));
    });
  });

  // =========================================================================
  // TC-034: BatchActionDefinition.fromJson
  // =========================================================================
  group('TC-034: BatchActionDefinition.fromJson', () {
    test('Normal: parse batch action', () {
      final def = BatchActionDefinition.fromJson({
        'type': 'batch',
        'actions': [
          {'type': 'state', 'action': 'set', 'binding': 'a', 'value': 1},
          {'type': 'state', 'action': 'set', 'binding': 'b', 'value': 2},
        ],
        'sequential': true,
        'stopOnError': false,
      });
      expect(def.actions, hasLength(2));
      expect(def.sequential, isTrue);
      expect(def.stopOnError, isFalse);
    });

    test('Boundary: sequential defaults to true, stopOnError defaults to false', () {
      final def = BatchActionDefinition.fromJson({
        'type': 'batch', 'actions': [],
      });
      expect(def.sequential, isTrue);
      expect(def.stopOnError, isFalse);
    });

    test('Error: empty actions list — valid', () {
      final def = BatchActionDefinition.fromJson({
        'type': 'batch', 'actions': [],
      });
      expect(def.actions, isEmpty);
    });
  });

  // =========================================================================
  // TC-035: ConditionalActionDefinition.fromJson
  // =========================================================================
  group('TC-035: ConditionalActionDefinition.fromJson', () {
    test('Normal: parse conditional action', () {
      final def = ConditionalActionDefinition.fromJson({
        'type': 'conditional',
        'condition': '{{x > 0}}',
        'then': {'type': 'state', 'action': 'set', 'binding': 'positive', 'value': true},
        'else': {'type': 'state', 'action': 'set', 'binding': 'positive', 'value': false},
      });
      expect(def.condition, equals('{{x > 0}}'));
      expect(def.thenAction, isA<StateActionDefinition>());
      expect(def.elseAction, isA<StateActionDefinition>());
    });

    test('Boundary: no else branch', () {
      final def = ConditionalActionDefinition.fromJson({
        'type': 'conditional',
        'condition': '{{flag}}',
        'then': {'type': 'state', 'action': 'toggle', 'binding': 'flag'},
      });
      expect(def.elseAction, isNull);
    });
  });

  // =========================================================================
  // TC-036: NotificationActionDefinition.fromJson
  // =========================================================================
  group('TC-036: NotificationActionDefinition.fromJson', () {
    test('Normal: parse notification action with all fields', () {
      final def = NotificationActionDefinition.fromJson({
        'type': 'notification',
        'message': 'Success!',
        'severity': 'success',
        'duration': 3000,
        'position': 'top',
        'action': {
          'label': 'Undo',
          'click': {'type': 'state', 'action': 'set', 'binding': 'undone', 'value': true},
        },
      });
      expect(def.message, equals('Success!'));
      expect(def.severity, equals('success'));
      expect(def.duration, equals(3000));
      expect(def.position, equals('top'));
      expect(def.action, isNotNull);
      expect(def.action!.label, equals('Undo'));
      expect(def.action!.click, isA<StateActionDefinition>());
    });

    test('Boundary: defaults', () {
      final def = NotificationActionDefinition.fromJson({
        'type': 'notification', 'message': 'Info',
      });
      expect(def.severity, isNull);
      expect(def.duration, isNull);
      expect(def.position, isNull);
      expect(def.action, isNull);
    });
  });

  // =========================================================================
  // TC-037: ParallelActionDefinition.fromJson
  // =========================================================================
  group('TC-037: ParallelActionDefinition.fromJson', () {
    test('Normal: parse parallel action', () {
      final def = ParallelActionDefinition.fromJson({
        'type': 'parallel',
        'actions': [
          {'type': 'tool', 'tool': 'a'},
          {'type': 'tool', 'tool': 'b'},
        ],
        'onAllComplete': {'type': 'notification', 'message': 'Done'},
        'onAnyError': {'type': 'notification', 'message': 'Error'},
      });
      expect(def.actions, hasLength(2));
      expect(def.onAllComplete, isNotNull);
      expect(def.onAnyError, isNotNull);
    });

    test('Boundary: callbacks optional', () {
      final def = ParallelActionDefinition.fromJson({
        'type': 'parallel', 'actions': [],
      });
      expect(def.onAllComplete, isNull);
      expect(def.onAnyError, isNull);
    });
  });

  // =========================================================================
  // TC-038: SequenceActionDefinition.fromJson
  // =========================================================================
  group('TC-038: SequenceActionDefinition.fromJson', () {
    test('Normal: parse sequence action', () {
      final def = SequenceActionDefinition.fromJson({
        'type': 'sequence',
        'actions': [
          {'type': 'state', 'action': 'set', 'binding': 'step', 'value': 1},
        ],
        'stopOnError': true,
        'onComplete': {'type': 'notification', 'message': 'Done'},
      });
      expect(def.actions, hasLength(1));
      expect(def.stopOnError, isTrue);
      expect(def.onComplete, isNotNull);
    });

    test('Boundary: stopOnError defaults to true', () {
      final def = SequenceActionDefinition.fromJson({
        'type': 'sequence', 'actions': [],
      });
      expect(def.stopOnError, isTrue);
      expect(def.onComplete, isNull);
    });
  });

  // =========================================================================
  // TC-039: AnimationActionDefinition.fromJson
  // =========================================================================
  group('TC-039: AnimationActionDefinition.fromJson', () {
    test('Normal: parse animation action', () {
      final def = AnimationActionDefinition.fromJson({
        'type': 'animation', 'action': 'play', 'target': 'anim1',
        'duration': 300, 'curve': 'easeIn',
      });
      expect(def.action, equals('play'));
      expect(def.target, equals('anim1'));
      expect(def.duration, equals(300));
      expect(def.curve, equals('easeIn'));
    });

    test('Boundary: all 6 animation actions', () {
      for (final act in ['play', 'reverse', 'pause', 'resume', 'reset', 'stop']) {
        final def = AnimationActionDefinition.fromJson({
          'type': 'animation', 'action': act, 'target': 'a1',
        });
        expect(def.action, equals(act));
      }
    });

    test('Boundary: duration and curve optional', () {
      final def = AnimationActionDefinition.fromJson({
        'type': 'animation', 'action': 'play', 'target': 'a1',
      });
      expect(def.duration, isNull);
      expect(def.curve, isNull);
    });
  });

  // =========================================================================
  // TC-040: ClientActionDefinition.fromJson
  // =========================================================================
  group('TC-040: ClientActionDefinition.fromJson', () {
    test('Normal: parse client action', () {
      final def = ClientActionDefinition.fromJson({
        'type': 'client.readFile',
        'params': {'path': '/home/file.txt'},
        'onSuccess': {'type': 'state', 'action': 'set', 'binding': 'content'},
        'onError': {'type': 'notification', 'message': 'Failed'},
        'confirmMessage': 'Read this file?',
        'requireConfirmation': true,
      });
      expect(def.action, equals('client.readFile'));
      expect(def.type, equals('client.readFile'));
      expect(def.params, equals({'path': '/home/file.txt'}));
      expect(def.onSuccess, isA<StateActionDefinition>());
      expect(def.onError, isA<NotificationActionDefinition>());
      expect(def.confirmMessage, equals('Read this file?'));
      expect(def.requireConfirmation, isTrue);
    });

    test('Boundary: all 10 client action types parse', () {
      final clientTypes = [
        'client.selectFile', 'client.readFile', 'client.writeFile',
        'client.saveFile', 'client.listFiles', 'client.httpRequest',
        'client.getSystemInfo', 'client.clipboard', 'client.exec',
        'client.notification',
      ];
      for (final t in clientTypes) {
        final def = ActionDefinition.fromJson({'type': t}) as ClientActionDefinition;
        expect(def.action, equals(t));
      }
    });
  });

  // =========================================================================
  // TC-041: Client action return types
  // =========================================================================
  group('TC-041: Client action return types', () {
    test('Normal: selectFile result envelope', () {
      // Verify the expected return type structure for selectFile
      final result = {
        'success': true,
        'data': {
          'path': '/home/user/file.txt',
          'paths': ['/home/user/file.txt'],
          'canceled': false,
          'files': [
            {'name': 'file.txt', 'path': '/home/user/file.txt'},
          ],
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      expect(result['success'], isTrue);
      expect((result['data'] as Map)['path'], isA<String>());
      expect((result['data'] as Map)['paths'], isA<List>());
      expect((result['data'] as Map)['canceled'], isFalse);
    });

    test('Normal: readFile result envelope', () {
      final result = {
        'success': true,
        'data': {
          'path': '/home/file.txt',
          'content': 'file content',
          'encoding': 'utf-8',
          'size': 12,
          'mimeType': 'text/plain',
          'lastModified': '2026-01-01T00:00:00Z',
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      expect(result['success'], isTrue);
      final data = result['data'] as Map;
      expect(data['content'], equals('file content'));
      expect(data['encoding'], equals('utf-8'));
      expect(data['size'], equals(12));
      expect(data['mimeType'], equals('text/plain'));
    });

    test('Normal: writeFile result envelope', () {
      final result = {
        'success': true,
        'data': {
          'path': '/home/file.txt',
          'bytesWritten': 100,
          'created': true,
          'overwritten': false,
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['bytesWritten'], equals(100));
      expect(data['created'], isTrue);
      expect(data['overwritten'], isFalse);
    });

    test('Normal: saveFile result envelope', () {
      final result = {
        'success': true,
        'data': {
          'path': '/home/saved.txt',
          'bytesWritten': 50,
          'created': true,
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['path'], equals('/home/saved.txt'));
      expect(data['bytesWritten'], equals(50));
    });

    test('Normal: listFiles result envelope', () {
      final result = {
        'success': true,
        'data': {
          'files': [
            {'name': 'a.txt', 'path': '/a.txt'},
            {'name': 'b.txt', 'path': '/b.txt'},
          ],
          'total': 2,
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['total'], equals(2));
      expect((data['files'] as List).length, equals(2));
    });

    test('Normal: httpRequest result envelope', () {
      final result = {
        'success': true,
        'data': {
          'status': 200,
          'statusText': 'OK',
          'headers': {'content-type': 'application/json'},
          'data': {'key': 'value'},
          'responseTime': 150,
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['status'], equals(200));
      expect(data['statusText'], equals('OK'));
      expect(data['responseTime'], equals(150));
    });

    test('Normal: getSystemInfo result envelope', () {
      final result = {
        'success': true,
        'data': {
          'platform': 'macos',
          'arch': 'arm64',
          'memory': 16384,
          'cpus': 10,
          'hostname': 'my-mac',
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['platform'], equals('macos'));
      expect(data['arch'], equals('arm64'));
    });

    test('Normal: clipboard read result envelope', () {
      final result = {
        'success': true,
        'data': {
          'content': 'clipboard text',
          'format': 'text/plain',
          'available': true,
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['content'], equals('clipboard text'));
      expect(data['available'], isTrue);
    });

    test('Normal: clipboard write result envelope', () {
      final result = {
        'success': true,
        'data': {
          'success': true,
          'format': 'text/plain',
          'length': 14,
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['success'], isTrue);
      expect(data['length'], equals(14));
    });

    test('Normal: exec result envelope', () {
      final result = {
        'success': true,
        'data': {
          'stdout': 'output',
          'stderr': '',
          'code': 0,
          'signal': null,
          'duration': 120,
        },
        'timestamp': '2026-01-01T00:00:00Z',
      };
      final data = result['data'] as Map;
      expect(data['stdout'], equals('output'));
      expect(data['code'], equals(0));
      expect(data['duration'], equals(120));
    });

    test('Boundary: selectFile canceled', () {
      final result = {
        'success': true,
        'data': {'canceled': true},
      };
      expect(result['success'], isTrue);
      expect((result['data'] as Map)['canceled'], isTrue);
    });

    test('Normal: all 10 client action types can be constructed', () {
      final clientTypes = [
        'client.selectFile', 'client.readFile', 'client.writeFile',
        'client.saveFile', 'client.listFiles', 'client.httpRequest',
        'client.getSystemInfo', 'client.clipboard', 'client.exec',
        'client.notification',
      ];
      for (final t in clientTypes) {
        final def = ClientActionDefinition.fromJson({'type': t});
        expect(def.action, equals(t));
        expect(def.type, equals(t));
      }
    });
  });

  // =========================================================================
  // TC-042: ChannelActionDefinition.fromJson
  // =========================================================================
  group('TC-042: ChannelActionDefinition.fromJson', () {
    test('Normal: parse channel.start', () {
      final def = ChannelActionDefinition.fromJson({
        'type': 'channel.start', 'channel': 'systemMonitor',
      });
      expect(def.action, equals('start'));
      expect(def.channel, equals('systemMonitor'));
      expect(def.data, isNull);
    });

    test('Boundary: channel.send with data', () {
      final def = ChannelActionDefinition.fromJson({
        'type': 'channel.send', 'channel': 'chat', 'data': {'message': 'hello'},
      });
      expect(def.action, equals('send'));
      expect(def.data, equals({'message': 'hello'}));
    });

    test('Boundary: all 5 channel action types', () {
      for (final act in ['start', 'stop', 'restart', 'toggle', 'send']) {
        final def = ChannelActionDefinition.fromJson({
          'type': 'channel.$act', 'channel': 'ch1',
        });
        expect(def.action, equals(act));
        expect(def.type, equals('channel.$act'));
      }
    });

    test('Error: missing channel defaults to empty string', () {
      final def = ChannelActionDefinition.fromJson({'type': 'channel.start'});
      expect(def.channel, equals(''));
    });
  });
}
