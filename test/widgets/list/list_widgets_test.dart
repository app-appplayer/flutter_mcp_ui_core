// TC-131 ~ TC-135: List Widget Definition Tests
// Tests list widget types using the generic WidgetDefinition class
// with type string field and properties map for widget-specific data.
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // ===========================================================================
  // TC-131: List widget definition
  // ===========================================================================
  group('TC-131: List widget definition', () {
    test('Normal: list with children, direction, and separator', () {
      final json = {
        'type': 'list',
        'direction': 'vertical',
        'separator': true,
        'children': [
          {'type': 'text', 'content': 'Item 1'},
          {'type': 'text', 'content': 'Item 2'},
          {'type': 'text', 'content': 'Item 3'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('list'));
      expect(def.properties['direction'], equals('vertical'));
      expect(def.properties['separator'], isTrue);
      expect(def.children, hasLength(3));
      expect(def.children![0].type, equals('text'));
      expect(def.children![0].properties['content'], equals('Item 1'));
    });

    test('Boundary: list with horizontal direction', () {
      final json = {
        'type': 'list',
        'direction': 'horizontal',
        'children': [
          {'type': 'icon', 'name': 'star'},
          {'type': 'icon', 'name': 'heart'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['direction'], equals('horizontal'));
      expect(def.children, hasLength(2));
    });

    test('Error: list without direction defaults to null in properties', () {
      final json = {
        'type': 'list',
        'children': [
          {'type': 'text', 'content': 'Solo'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('list'));
      expect(def.properties['direction'], isNull);
      expect(def.children, hasLength(1));
    });
  });

  // ===========================================================================
  // TC-132: Grid widget definition
  // ===========================================================================
  group('TC-132: Grid widget definition', () {
    test('Normal: grid with columns, spacing, and children', () {
      final json = {
        'type': 'grid',
        'columns': 3,
        'spacing': 8,
        'children': [
          {'type': 'card', 'content': 'Card 1'},
          {'type': 'card', 'content': 'Card 2'},
          {'type': 'card', 'content': 'Card 3'},
          {'type': 'card', 'content': 'Card 4'},
          {'type': 'card', 'content': 'Card 5'},
          {'type': 'card', 'content': 'Card 6'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('grid'));
      expect(def.properties['columns'], equals(3));
      expect(def.properties['spacing'], equals(8));
      expect(def.children, hasLength(6));
    });

    test('Boundary: grid with single column', () {
      final json = {
        'type': 'grid',
        'columns': 1,
        'children': [
          {'type': 'text', 'content': 'Full width'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['columns'], equals(1));
      expect(def.children, hasLength(1));
    });

    test('Error: grid without columns property', () {
      final json = {
        'type': 'grid',
        'children': [
          {'type': 'text', 'content': 'No columns'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('grid'));
      expect(def.properties['columns'], isNull);
    });
  });

  // ===========================================================================
  // TC-133: ListTile widget definition
  // ===========================================================================
  group('TC-133: ListTile widget definition', () {
    test('Normal: listTile with title, subtitle, leading, trailing, onTap', () {
      final json = {
        'type': 'listTile',
        'title': 'Item Title',
        'subtitle': 'Subtitle',
        'leading': {
          'type': 'avatar',
          'src': 'user.png',
        },
        'trailing': {
          'type': 'icon',
          'name': 'chevron_right',
        },
        'onTap': {
          'type': 'navigate',
          'route': '/detail',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('listTile'));
      expect(def.properties['title'], equals('Item Title'));
      expect(def.properties['subtitle'], equals('Subtitle'));
      expect(def.properties['leading'], isA<Map>());
      expect(
        (def.properties['leading'] as Map)['type'],
        equals('avatar'),
      );
      expect(def.properties['trailing'], isA<Map>());
      expect(
        (def.properties['trailing'] as Map)['type'],
        equals('icon'),
      );
      expect(def.properties['onTap'], isA<Map>());
      expect(
        (def.properties['onTap'] as Map)['type'],
        equals('navigate'),
      );
    });

    test('Boundary: listTile with only title', () {
      final json = {
        'type': 'listTile',
        'title': 'Simple Item',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('listTile'));
      expect(def.properties['title'], equals('Simple Item'));
      expect(def.properties['subtitle'], isNull);
      expect(def.properties['leading'], isNull);
      expect(def.properties['trailing'], isNull);
    });

    test('Error: listTile without title still parses', () {
      final json = {'type': 'listTile'};

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('listTile'));
      expect(def.properties['title'], isNull);
    });
  });

  // ===========================================================================
  // TC-134: List with empty children
  // ===========================================================================
  group('TC-134: List with empty children', () {
    test('Boundary: list with empty children creates definition with empty list', () {
      final json = {
        'type': 'list',
        'direction': 'vertical',
        'children': <Map<String, dynamic>>[],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('list'));
      expect(def.children, isNotNull);
      expect(def.children, isEmpty);
      expect(def.properties['direction'], equals('vertical'));
    });

    test('Boundary: grid with empty children', () {
      final json = {
        'type': 'grid',
        'columns': 2,
        'children': <Map<String, dynamic>>[],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.children, isNotNull);
      expect(def.children, isEmpty);
    });

    test('Boundary: list without children field at all', () {
      final json = {
        'type': 'list',
        'direction': 'vertical',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.children, isNull);
    });
  });

  // ===========================================================================
  // TC-135: Grid with dynamic column count from binding expression
  // ===========================================================================
  group('TC-135: Grid with dynamic column count from binding', () {
    test('Boundary: grid with binding expression for columns', () {
      final json = {
        'type': 'grid',
        'columns': '{{layout.columnCount}}',
        'spacing': 8,
        'children': [
          {'type': 'card', 'content': 'Dynamic'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('grid'));
      expect(
        def.properties['columns'],
        equals('{{layout.columnCount}}'),
      );
    });

    test('Boundary: grid toJson preserves binding expression in columns', () {
      final json = {
        'type': 'grid',
        'columns': '{{responsive.cols}}',
        'children': [
          {'type': 'text', 'content': 'A'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(
        restored.properties['columns'],
        equals('{{responsive.cols}}'),
      );
      expect(restored.children, hasLength(1));
    });
  });
}
