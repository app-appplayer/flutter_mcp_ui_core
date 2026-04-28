// TC-081 ~ TC-091: DefinitionValidator Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  const validator = DefinitionValidator();

  // =========================================================================
  // TC-081: DefinitionValidator.validateApplication
  // =========================================================================
  group('TC-081: DefinitionValidator.validateApplication', () {
    test('Normal: valid application definition', () {
      final json = {
        'type': 'application',
        'title': 'My App',
        'version': '1.0',
        'initialRoute': '/',
        'routes': {'/': 'main.json'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('Boundary: application with empty routes table -> error', () {
      final json = {
        'type': 'application',
        'title': 'My App',
        'version': '1.0',
        'routes': {},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
    });

    test('Error: missing title -> error', () {
      final json = {
        'type': 'application',
        'version': '1.0',
        'routes': {'/': 'main.json'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.path == 'title'), isTrue);
    });

    test('Error: initialRoute not in routes -> error', () {
      final json = {
        'type': 'application',
        'title': 'My App',
        'version': '1.0',
        'initialRoute': '/missing',
        'routes': {'/': 'main.json'},
      };

      final result = validator.validateApplication(json);
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) =>
          e.path == 'initialRoute'), isTrue);
    });
  });

  // =========================================================================
  // TC-082: DefinitionValidator.validatePage
  // =========================================================================
  group('TC-082: DefinitionValidator.validatePage', () {
    test('Normal: valid page with content widget', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'Hello'},
      };

      final result = validator.validatePage(json);
      expect(result.isValid, isTrue);
    });

    test('Boundary: page with only content (no state, no lifecycle)', () {
      final json = {
        'type': 'page',
        'content': {'type': 'text', 'content': 'Minimal'},
      };

      final result = validator.validatePage(json);
      expect(result.isValid, isTrue);
    });

    test('Error: missing content -> error', () {
      final json = {'type': 'page', 'title': 'NoContent'};

      final result = validator.validatePage(json);
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.path == 'content'), isTrue);
    });
  });

  // =========================================================================
  // TC-083: DefinitionValidator.validateWidget
  // =========================================================================
  group('TC-083: DefinitionValidator.validateWidget', () {
    test('Normal: valid text widget', () {
      final json = {'type': 'text', 'content': 'Hello'};
      final result = validator.validateWidget(json);
      expect(result.isValid, isTrue);
    });

    test('Error: missing type -> error', () {
      final json = {'content': 'Hello'};
      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
    });

    test('Error: unknown widget type -> error', () {
      final json = {'type': 'nonexistent_widget'};
      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
    });

    test('Error: linear without direction -> error', () {
      final json = {
        'type': 'linear',
        'children': [
          {'type': 'text', 'content': 'Hello'},
        ],
      };
      final result = validator.validateWidget(json);
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) =>
          e.path != null && e.path!.contains('direction')), isTrue);
    });
  });

  // =========================================================================
  // TC-084: DefinitionValidator.validateAction
  // =========================================================================
  group('TC-084: DefinitionValidator.validateAction', () {
    test('Normal: valid state action', () {
      final json = {
        'type': 'state',
        'action': 'set',
        'binding': 'count',
        'value': 42,
      };
      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: unknown action type -> error', () {
      final json = {'type': 'unknown_action'};
      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });

    test('Boundary: client.readFile is valid (client.* prefix)', () {
      final json = {
        'type': 'client.readFile',
        'params': {'path': './file.txt'},
      };
      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: navigation push without route -> error', () {
      final json = {
        'type': 'navigation',
        'action': 'push',
      };
      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });
  });

  // =========================================================================
  // TC-085: ValidationResult structure
  // =========================================================================
  group('TC-085: ValidationResult structure', () {
    test('Normal: isValid true with empty errors list', () {
      final result = ValidationResult.success();
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('Boundary: isValid false with multiple ValidationError entries', () {
      final result = ValidationResult.failure([
        ValidationError.requiredField('field1'),
        ValidationError.requiredField('field2'),
      ]);
      expect(result.isValid, isFalse);
      expect(result.errors, hasLength(2));
    });

    test('Normal: fromErrors determines isValid from severity', () {
      final withErrors = ValidationResult.fromErrors([
        ValidationError.requiredField('field1'),
      ]);
      expect(withErrors.isValid, isFalse);

      final withWarnings = ValidationResult.fromErrors([
        ValidationError.deprecatedUsage('field1', '1.0'),
      ]);
      expect(withWarnings.isValid, isTrue);
      expect(withWarnings.hasWarnings, isTrue);
    });
  });

  // =========================================================================
  // TC-086: Color format validation
  // =========================================================================
  group('TC-086: Color format validation', () {
    test('Normal: #2196F3 -> valid', () {
      final json = {'type': 'text', 'color': '#2196F3'};
      final result = validator.validateWidget(json);
      // No color format errors
      expect(result.errors.where((e) =>
          e.code == 'PATTERN_MISMATCH'), isEmpty);
    });

    test('Normal: #FF2196F3 (8-digit) -> valid', () {
      final json = {'type': 'text', 'color': '#FF2196F3'};
      final result = validator.validateWidget(json);
      expect(result.errors.where((e) =>
          e.code == 'PATTERN_MISMATCH'), isEmpty);
    });

    test('Boundary: #fff (3 digits) -> invalid', () {
      final json = {'type': 'text', 'color': '#fff'};
      final result = validator.validateWidget(json);
      expect(result.errors.any((e) =>
          e.code == 'PATTERN_MISMATCH'), isTrue);
    });

    test('Error: #GGHHII (non-hex) -> invalid', () {
      final json = {'type': 'text', 'color': '#GGHHII'};
      final result = validator.validateWidget(json);
      expect(result.errors.any((e) =>
          e.code == 'PATTERN_MISMATCH'), isTrue);
    });
  });

  // =========================================================================
  // TC-087: Route format validation
  // =========================================================================
  group('TC-087: Route format validation', () {
    test('Normal: /dashboard -> valid', () {
      final json = {
        'type': 'navigation',
        'action': 'push',
        'route': '/dashboard',
      };
      final result = validator.validateAction(json);
      expect(result.errors.where((e) =>
          e.path != null && e.path!.contains('route') &&
          e.code != 'REQUIRED_FIELD_MISSING'), isEmpty);
    });

    test('Boundary: / (root) -> valid', () {
      final json = {
        'type': 'navigation',
        'action': 'push',
        'route': '/',
      };
      final result = validator.validateAction(json);
      expect(result.isValid, isTrue);
    });

    test('Error: dashboard (no leading /) -> invalid', () {
      final json = {
        'type': 'navigation',
        'action': 'push',
        'route': 'dashboard',
      };
      final result = validator.validateAction(json);
      expect(result.isValid, isFalse);
    });
  });

  // =========================================================================
  // TC-088: Widget type must be known constant
  // =========================================================================
  group('TC-088: Widget type must be known constant', () {
    test('Normal: type "text" -> valid', () {
      final result = validator.validateWidget({'type': 'text'});
      expect(result.errors.where((e) =>
          e.code == 'INVALID_VALUE' &&
          e.path != null &&
          e.path!.contains('type')), isEmpty);
    });

    test('Boundary: type "container" (legacy alias) -> valid', () {
      // container is in WidgetTypes.isValidType (it is in categories)
      final result = validator.validateWidget({'type': 'container'});
      expect(result.errors.where((e) =>
          e.code == 'INVALID_VALUE' &&
          e.path != null &&
          e.path!.contains('type')), isEmpty);
    });

    test('Error: type "nonexistent_widget" -> error', () {
      final result = validator.validateWidget({'type': 'nonexistent_widget'});
      expect(result.errors.any((e) =>
          e.code == 'INVALID_VALUE'), isTrue);
    });
  });

  // =========================================================================
  // TC-089: Layout widget requires children or child
  // =========================================================================
  group('TC-089: Layout widget requires children or child', () {
    test('Normal: linear with children array -> valid', () {
      final result = validator.validateWidget({
        'type': 'linear',
        'direction': 'vertical',
        'children': [
          {'type': 'text', 'content': 'A'},
        ],
      });
      expect(result.isValid, isTrue);
    });

    test('Boundary: box with single child -> valid', () {
      final result = validator.validateWidget({
        'type': 'box',
        'child': {'type': 'text', 'content': 'Inside'},
      });
      expect(result.isValid, isTrue);
    });
  });

  // =========================================================================
  // TC-090: Direction required on linear widget
  // =========================================================================
  group('TC-090: Direction required on linear widget', () {
    test('Normal: linear with direction vertical -> valid', () {
      final result = validator.validateWidget({
        'type': 'linear',
        'direction': 'vertical',
        'children': [
          {'type': 'text'},
        ],
      });
      expect(result.isValid, isTrue);
    });

    test('Boundary: linear with direction horizontal -> valid', () {
      final result = validator.validateWidget({
        'type': 'linear',
        'direction': 'horizontal',
        'children': [
          {'type': 'text'},
        ],
      });
      expect(result.isValid, isTrue);
    });

    test('Error: linear without direction -> error', () {
      final result = validator.validateWidget({
        'type': 'linear',
        'children': [
          {'type': 'text'},
        ],
      });
      expect(result.isValid, isFalse);
    });
  });

  // =========================================================================
  // TC-091: Action type must be known
  // =========================================================================
  group('TC-091: Action type must be known', () {
    test('Normal: type "state" -> valid', () {
      final result = validator.validateAction({
        'type': 'state',
        'binding': 'count',
        'value': 0,
      });
      expect(result.isValid, isTrue);
    });

    test('Boundary: type "client.readFile" -> valid', () {
      final result = validator.validateAction({
        'type': 'client.readFile',
      });
      expect(result.isValid, isTrue);
    });

    test('Error: type "unknown_action" -> error', () {
      final result = validator.validateAction({
        'type': 'unknown_action',
      });
      expect(result.isValid, isFalse);
    });
  });
}
