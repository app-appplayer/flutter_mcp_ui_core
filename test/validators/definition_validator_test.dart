import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  late DefinitionValidator validator;

  setUp(() {
    validator = const DefinitionValidator();
  });

  // TC-050: DefinitionValidator.validateApplication
  group('TC-050: validateApplication', () {
    test('Normal: valid application definition', () {
      final json = {
        'title': 'Test App',
        'version': '1.0.0',
        'initialRoute': '/',
        'routes': {'/': 'ui://pages/home'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('Boundary: application with empty routes table', () {
      final json = {
        'title': 'App',
        'version': '1.0',
        'routes': {},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
    });

    test('Error: missing title', () {
      final json = {
        'version': '1.0',
        'routes': {'/': 'ui://home'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.path?.contains('title') ?? false), isTrue);
    });

    test('Error: missing version', () {
      final json = {
        'title': 'App',
        'routes': {'/': 'ui://home'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
    });

    test('Error: initialRoute not in routes', () {
      final json = {
        'title': 'App',
        'version': '1.0',
        'initialRoute': '/nonexistent',
        'routes': {'/': 'ui://home'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
    });

    test('Normal: validates theme if present', () {
      final json = {
        'title': 'App',
        'version': '1.0',
        'routes': {'/': 'ui://home'},
        'theme': {'mode': 'light', 'colors': {'primary': '#2196F3'}},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isTrue);
    });

    test('Error: invalid theme mode', () {
      final json = {
        'title': 'App',
        'version': '1.0',
        'routes': {'/': 'ui://home'},
        'theme': {'mode': 'invalid'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
    });
  });

  // TC-051: DefinitionValidator.validatePage
  group('TC-051: validatePage', () {
    test('Normal: valid page with content widget', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'Hello'},
      };

      final result = validator.validatePage(json);
      expect(result.isValid, isTrue);
    });

    test('Boundary: page with only content', () {
      final json = {
        'content': {'type': 'text', 'content': 'Hello'},
      };

      final result = validator.validatePage(json);
      expect(result.isValid, isTrue);
    });

    test('Error: missing content', () {
      final json = {'type': 'page'};

      final result = validator.validatePage(json);
      expect(result.isValid, isFalse);
    });

    test('Error: content is not a map', () {
      final json = {'type': 'page', 'content': 'not a map'};

      final result = validator.validatePage(json);
      expect(result.isValid, isFalse);
    });
  });

  // TC-052: DefinitionValidator.validateWidget
  group('TC-052: validateWidget', () {
    test('Normal: valid text widget', () {
      final json = {'type': 'text', 'content': 'Hello'};

      final result = validator.validateWidget(json);
      expect(result.isValid, isTrue);
    });

    test('Error: missing type', () {
      final json = {'content': 'Hello'};

      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
    });

    test('Error: unknown widget type', () {
      final json = {'type': 'nonexistent_widget'};

      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
    });

    test('Error: linear without direction', () {
      final json = {'type': 'linear', 'children': []};

      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
    });

    test('Normal: linear with direction', () {
      final json = {
        'type': 'linear',
        'direction': 'vertical',
        'children': [
          {'type': 'text', 'content': 'A'},
        ],
      };

      final result = validator.validateWidget(json);
      expect(result.isValid, isTrue);
    });

    test('Normal: recursively validates children', () {
      final json = {
        'type': 'linear',
        'direction': 'vertical',
        'children': [
          {'type': 'text', 'content': 'OK'},
          {'content': 'no type'},
        ],
      };

      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
    });

    test('Normal: recursively validates single child', () {
      final json = {
        'type': 'center',
        'child': {'content': 'no type'},
      };

      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
    });
  });

  // TC-053: DefinitionValidator.validateAction
  group('TC-053: validateAction', () {
    test('Normal: valid state action', () {
      final json = {'type': 'state', 'action': 'set', 'binding': 'counter', 'value': 0};

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: missing type', () {
      final json = {'action': 'set', 'binding': 'counter'};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Error: unknown action type', () {
      final json = {'type': 'unknown_type'};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Error: state action missing binding', () {
      final json = {'type': 'state', 'action': 'set', 'value': 0};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Error: navigation push without route', () {
      final json = {'type': 'navigation', 'action': 'push'};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Normal: navigation pop without route is valid', () {
      final json = {'type': 'navigation', 'action': 'pop'};

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: tool action missing tool name', () {
      final json = {'type': 'tool'};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Normal: tool action with sub-actions validated', () {
      final json = {
        'type': 'tool',
        'tool': 'fetchData',
        'onSuccess': {'type': 'state', 'action': 'set', 'binding': 'data', 'value': null},
      };

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Normal: batch action validates nested actions', () {
      final json = {
        'type': 'batch',
        'actions': [
          {'type': 'state', 'action': 'set', 'binding': 'a', 'value': 1},
          {'type': 'state', 'action': 'set', 'binding': 'b', 'value': 2},
        ],
      };

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: batch without actions list', () {
      final json = {'type': 'batch'};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Normal: conditional action validated', () {
      final json = {
        'type': 'conditional',
        'condition': '{{x > 0}}',
        'then': {'type': 'state', 'action': 'set', 'binding': 'result', 'value': 'yes'},
      };

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: conditional without condition', () {
      final json = {
        'type': 'conditional',
        'then': {'type': 'state', 'action': 'set', 'binding': 'x'},
      };

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Error: notification without message', () {
      final json = {'type': 'notification'};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Normal: client.* actions recognized', () {
      final json = {'type': 'client.readFile', 'params': {'path': '/test'}};

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Normal: channel.* actions recognized', () {
      final json = {'type': 'channel.start', 'channel': 'monitor'};

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });
  });

  // TC-054: Color format validation
  group('TC-054: Color format validation', () {
    test('Normal: valid 6-digit hex color', () {
      final json = {'type': 'box', 'color': '#2196F3'};

      final result = validator.validateWidget(json);
      expect(result.errors.where((e) => e.path?.contains('color') ?? false), isEmpty);
    });

    test('Normal: valid 8-digit hex color', () {
      final json = {'type': 'box', 'color': '#FF2196F3'};

      final result = validator.validateWidget(json);
      expect(result.errors.where((e) => e.path?.contains('color') ?? false), isEmpty);
    });

    test('Error: invalid hex color (non-hex chars)', () {
      final json = {'type': 'box', 'color': '#GGHHII'};

      final result = validator.validateWidget(json);
      expect(result.errors.where((e) => e.path?.contains('color') ?? false), isNotEmpty);
    });

    test('Boundary: 3-digit color is invalid', () {
      final json = {'type': 'box', 'color': '#fff'};

      final result = validator.validateWidget(json);
      expect(result.errors.where((e) => e.path?.contains('color') ?? false), isNotEmpty);
    });
  });

  // TC-055: Route format validation
  group('TC-055: Route format validation', () {
    test('Normal: valid route /dashboard', () {
      final json = {'type': 'navigation', 'action': 'push', 'route': '/dashboard'};

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Boundary: root route /', () {
      final json = {'type': 'navigation', 'action': 'push', 'route': '/'};

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Normal: route with params /users/:id', () {
      final json = {'type': 'navigation', 'action': 'push', 'route': '/users/:id'};

      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: route without leading /', () {
      final json = {'type': 'navigation', 'action': 'push', 'route': 'dashboard'};

      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });
  });

  // TC-056: Widget type must be known constant
  group('TC-056: Widget type validation', () {
    test('Normal: text type is valid', () {
      final result = validator.validateWidget({'type': 'text'});
      expect(result.errors.where((e) => e.message.contains('Unknown widget')), isEmpty);
    });

    test('Error: nonexistent_widget is invalid', () {
      final result = validator.validateWidget({'type': 'nonexistent_widget'});
      expect(result.errors.where((e) => e.message.contains('Unknown widget')), isNotEmpty);
    });
  });

  // TC-057: Layout widget requires children or child
  group('TC-057: Layout widget structure', () {
    test('Normal: linear with children array', () {
      final json = {
        'type': 'linear',
        'direction': 'vertical',
        'children': [{'type': 'text', 'content': 'A'}],
      };

      final result = validator.validateWidget(json);
      expect(result.isValid, isTrue);
    });

    test('Normal: box with single child', () {
      final json = {
        'type': 'box',
        'child': {'type': 'text', 'content': 'A'},
      };

      final result = validator.validateWidget(json);
      expect(result.isValid, isTrue);
    });
  });
}
