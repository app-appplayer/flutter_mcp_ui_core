import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('ActionSpecRegistry', () {
    group('Event Specifications', () {
      test('getEventSpec returns correct specs', () {
        final clickSpec = ActionSpecRegistry.getEventSpec('click');
        expect(clickSpec, isNotNull);
        expect(clickSpec!.name, equals('click'));
        expect(clickSpec.propertyKey, equals('click'));
        expect(clickSpec.supportsModifiers, isTrue);

        final doubleClickSpec = ActionSpecRegistry.getEventSpec('doubleClick');
        expect(doubleClickSpec, isNotNull);
        expect(doubleClickSpec!.propertyKey, equals('doubleClick')); // CamelCase

        final rightClickSpec = ActionSpecRegistry.getEventSpec('rightClick');
        expect(rightClickSpec, isNotNull);
        expect(rightClickSpec!.propertyKey, equals('rightClick')); // CamelCase

        final longPressSpec = ActionSpecRegistry.getEventSpec('longPress');
        expect(longPressSpec, isNotNull);
        expect(longPressSpec!.propertyKey, equals('longPress')); // CamelCase
        expect(longPressSpec.supportsModifiers, isFalse);
      });

      test('getEventSpec returns null for invalid events', () {
        expect(ActionSpecRegistry.getEventSpec('invalid'), isNull);
        expect(ActionSpecRegistry.getEventSpec(''), isNull);
        expect(ActionSpecRegistry.getEventSpec('double-click'), isNull); // Wrong format
      });

      test('getEventPropertyKey returns correct keys', () {
        expect(ActionSpecRegistry.getEventPropertyKey('click'), equals('click'));
        expect(ActionSpecRegistry.getEventPropertyKey('doubleClick'), equals('doubleClick'));
        expect(ActionSpecRegistry.getEventPropertyKey('rightClick'), equals('rightClick'));
        expect(ActionSpecRegistry.getEventPropertyKey('longPress'), equals('longPress'));
        expect(ActionSpecRegistry.getEventPropertyKey('invalid'), isNull);
      });

      test('allEventNames contains all events', () {
        final eventNames = ActionSpecRegistry.allEventNames;
        expect(eventNames, contains('click'));
        expect(eventNames, contains('doubleClick'));
        expect(eventNames, contains('rightClick'));
        expect(eventNames, contains('longPress'));
        expect(eventNames, contains('hover'));
        expect(eventNames, contains('focus'));
        expect(eventNames, contains('blur'));
        expect(eventNames, contains('change'));
        expect(eventNames, contains('submit'));
      });
    });

    group('Action Specifications', () {
      test('getActionSpec returns correct specs', () {
        final toolSpec = ActionSpecRegistry.getActionSpec('tool');
        expect(toolSpec, isNotNull);
        expect(toolSpec!.type, equals('tool'));
        expect(toolSpec.requiredParameters, contains('type'));
        expect(toolSpec.requiredParameters, contains('name'));

        final stateSpec = ActionSpecRegistry.getActionSpec('state');
        expect(stateSpec, isNotNull);
        expect(stateSpec!.requiredParameters, contains('type'));
        expect(stateSpec.requiredParameters, contains('action'));
        expect(stateSpec.requiredParameters, contains('path'));

        final navigationSpec = ActionSpecRegistry.getActionSpec('navigation');
        expect(navigationSpec, isNotNull);
        expect(navigationSpec!.requiredParameters, contains('type'));
        expect(navigationSpec.requiredParameters, contains('action'));
      });

      test('getActionSpec returns null for invalid types', () {
        expect(ActionSpecRegistry.getActionSpec('invalid'), isNull);
        expect(ActionSpecRegistry.getActionSpec(''), isNull);
      });

      test('allActionTypes contains all action types', () {
        final actionTypes = ActionSpecRegistry.allActionTypes;
        expect(actionTypes, contains('tool'));
        expect(actionTypes, contains('state'));
        expect(actionTypes, contains('navigation'));
        expect(actionTypes, contains('resource'));
        expect(actionTypes, contains('batch'));
        expect(actionTypes, contains('conditional'));
      });
    });

    group('validateAction', () {
      test('validates required type field', () {
        expect(
          () => ActionSpecRegistry.validateAction({}),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Action must have a "type" field'),
          )),
        );
      });

      test('validates unknown action types', () {
        expect(
          () => ActionSpecRegistry.validateAction({'type': 'invalid'}),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Unknown action type: invalid'),
          )),
        );
      });

      test('validates required parameters for tool action', () {
        expect(
          () => ActionSpecRegistry.validateAction({
            'type': 'tool',
          }),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Required parameter "name" missing'),
          )),
        );

        final validTool = ActionSpecRegistry.validateAction({
          'type': 'tool',
          'name': 'saveTool',
          'params': {'data': 'test'},
        });
        expect(validTool['type'], equals('tool'));
        expect(validTool['name'], equals('saveTool'));
        expect(validTool['params'], equals({'data': 'test'}));
      });

      test('validates allowed values for state action', () {
        expect(
          () => ActionSpecRegistry.validateAction({
            'type': 'state',
            'action': 'invalid',
            'path': 'test.path',
          }),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid value "invalid"'),
          )),
        );

        final validState = ActionSpecRegistry.validateAction({
          'type': 'state',
          'action': 'set',
          'path': 'user.name',
          'value': 'John',
        });
        expect(validState['action'], equals('set'));
      });

      test('validates navigation actions', () {
        expect(
          () => ActionSpecRegistry.validateAction({
            'type': 'navigation',
            'action': 'invalid',
          }),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid value "invalid"'),
          )),
        );

        final validNav = ActionSpecRegistry.validateAction({
          'type': 'navigation',
          'action': 'push',
          'route': '/settings',
        });
        expect(validNav['action'], equals('push'));
        expect(validNav['route'], equals('/settings'));
      });

      test('applies default values', () {
        final stateAction = ActionSpecRegistry.validateAction({
          'type': 'state',
          'action': 'increment',
          'path': 'counter',
        });
        expect(stateAction['amount'], equals(1)); // default value

        final batchAction = ActionSpecRegistry.validateAction({
          'type': 'batch',
          'actions': [],
        });
        expect(batchAction['parallel'], equals(false)); // default value
      });

      test('ignores unknown parameters', () {
        final action = ActionSpecRegistry.validateAction({
          'type': 'tool',
          'name': 'test',
          'unknownParam': 'value',
        });
        expect(action.containsKey('unknownParam'), isFalse);
      });
    });

    group('createAction', () {
      test('creates valid tool action', () {
        final action = ActionSpecRegistry.createAction(
          type: 'tool',
          params: {
            'name': 'saveData',
            'params': {'data': 'test'},
          },
        );
        expect(action['type'], equals('tool'));
        expect(action['name'], equals('saveData'));
      });

      test('creates valid state action', () {
        final action = ActionSpecRegistry.createAction(
          type: 'state',
          params: {
            'action': 'set',
            'path': 'form.field',
            'value': 'new value',
          },
        );
        expect(action['type'], equals('state'));
        expect(action['action'], equals('set'));
        expect(action['path'], equals('form.field'));
      });

      test('throws for unknown action type', () {
        expect(
          () => ActionSpecRegistry.createAction(type: 'invalid'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('action parameter specs', () {
      test('tool action parameters', () {
        final toolSpec = ActionSpecRegistry.getActionSpec('tool')!;
        expect(toolSpec.parameters['type']!.required, isTrue);
        expect(toolSpec.parameters['type']!.defaultValue, equals('tool'));
        expect(toolSpec.parameters['name']!.required, isTrue);
        expect(toolSpec.parameters['params']!.required, isFalse);
      });

      test('state action parameters', () {
        final stateSpec = ActionSpecRegistry.getActionSpec('state')!;
        final actionParam = stateSpec.parameters['action']!;
        expect(actionParam.allowedValues, contains('set'));
        expect(actionParam.allowedValues, contains('toggle'));
        expect(actionParam.allowedValues, contains('increment'));
        expect(actionParam.allowedValues, contains('decrement'));
      });

      test('navigation action parameters', () {
        final navSpec = ActionSpecRegistry.getActionSpec('navigation')!;
        final actionParam = navSpec.parameters['action']!;
        expect(actionParam.allowedValues, contains('push'));
        expect(actionParam.allowedValues, contains('pop'));
        expect(actionParam.allowedValues, contains('replace'));
        expect(actionParam.allowedValues, contains('setIndex'));
      });

      test('conditional action parameters', () {
        final condSpec = ActionSpecRegistry.getActionSpec('conditional')!;
        expect(condSpec.parameters['condition']!.required, isTrue);
        expect(condSpec.parameters['then']!.required, isTrue);
        expect(condSpec.parameters['else']!.required, isFalse);
      });
    });
  });
}