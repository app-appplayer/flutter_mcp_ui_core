import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // Helper to create a simple child widget definition
  Map<String, dynamic> simpleChild({String type = 'text', String content = 'child'}) {
    return {'type': type, 'content': content};
  }

  // TC-007~010: linear layout
  group('TC-007~010: linear', () {
    // TC-007: Normal — horizontal linear with all properties
    test('TC-007: horizontal linear with full properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'direction': 'horizontal',
        'alignment': 'center',
        'distribution': 'spaceBetween',
        'spacing': 8,
        'children': [
          simpleChild(),
          simpleChild(content: 'child2'),
        ],
      });

      expect(widget.type, equals('linear'));
      expect(widget.properties['direction'], equals('horizontal'));
      expect(widget.properties['alignment'], equals('center'));
      expect(widget.properties['distribution'], equals('spaceBetween'));
      expect(widget.properties['spacing'], equals(8));
      expect(widget.children, isNotNull);
      expect(widget.children!.length, equals(2));
    });

    // TC-008: Normal — vertical linear
    test('TC-008: vertical linear direction', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'direction': 'vertical',
        'children': [simpleChild()],
      });

      expect(widget.properties['direction'], equals('vertical'));
    });

    // TC-009: Boundary — linear with no direction specified
    test('TC-009: linear with no direction defaults', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'children': [simpleChild()],
      });

      expect(widget.type, equals('linear'));
      expect(widget.properties['direction'], isNull);
    });

    // TC-010: Boundary — linear with no children
    test('TC-010: linear with no children', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'direction': 'horizontal',
      });

      expect(widget.children, isNull);
    });
  });

  // TC-011~014: box
  group('TC-011~014: box', () {
    // TC-011: Normal — box with decoration, sizing, padding, margin
    test('TC-011: box with full properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'box',
        'decoration': {
          'color': '#FFFFFF',
          'borderRadius': 8,
          'border': {'color': '#CCCCCC', 'width': 1},
        },
        'width': 100,
        'height': 200,
        'padding': 8,
        'margin': 16,
      });

      expect(widget.type, equals('box'));
      expect(widget.properties['decoration'], isA<Map>());
      expect(widget.properties['decoration']['color'], equals('#FFFFFF'));
      expect(widget.properties['width'], equals(100));
      expect(widget.properties['height'], equals(200));
      expect(widget.properties['padding'], equals(8));
      expect(widget.properties['margin'], equals(16));
    });

    // TC-012: Normal — box with child
    test('TC-012: box with child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'box',
        'child': simpleChild(),
      });

      expect(widget.child, isNotNull);
      expect(widget.child!.type, equals('text'));
    });

    // TC-013: Boundary — box with no size
    test('TC-013: box with no size specified', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'box',
      });

      expect(widget.properties['width'], isNull);
      expect(widget.properties['height'], isNull);
    });

    // TC-014: Boundary — box with padding as map
    test('TC-014: box with padding as map', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'box',
        'padding': {'left': 8, 'right': 8, 'top': 4, 'bottom': 4},
      });

      expect(widget.properties['padding'], isA<Map>());
      expect(widget.properties['padding']['left'], equals(8));
    });
  });

  // TC-015~016: stack
  group('TC-015~016: stack', () {
    // TC-015: Normal — stack with alignment and children
    test('TC-015: stack with alignment and children', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'stack',
        'alignment': 'center',
        'children': [
          simpleChild(),
          simpleChild(content: 'overlay'),
        ],
      });

      expect(widget.type, equals('stack'));
      expect(widget.properties['alignment'], equals('center'));
      expect(widget.children!.length, equals(2));
    });

    // TC-016: Boundary — stack with no alignment
    test('TC-016: stack with no alignment', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'stack',
        'children': [simpleChild()],
      });

      expect(widget.properties['alignment'], isNull);
    });
  });

  // TC-017: center
  group('TC-017: center', () {
    test('TC-017: center with child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'center',
        'child': simpleChild(),
      });

      expect(widget.type, equals('center'));
      expect(widget.child, isNotNull);
      expect(widget.child!.type, equals('text'));
    });
  });

  // TC-018: expanded
  group('TC-018: expanded', () {
    test('TC-018: expanded with flex and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'expanded',
        'flex': 2,
        'child': simpleChild(),
      });

      expect(widget.type, equals('expanded'));
      expect(widget.properties['flex'], equals(2));
      expect(widget.child, isNotNull);
    });
  });

  // TC-019: flexible
  group('TC-019: flexible', () {
    test('TC-019: flexible with flex and fit', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'flexible',
        'flex': 1,
        'fit': 'tight',
        'child': simpleChild(),
      });

      expect(widget.type, equals('flexible'));
      expect(widget.properties['flex'], equals(1));
      expect(widget.properties['fit'], equals('tight'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-020: sizedBox
  group('TC-020: sizedBox', () {
    test('TC-020: sizedBox with width and height', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'sizedBox',
        'width': 100,
        'height': 50,
      });

      expect(widget.type, equals('sizedBox'));
      expect(widget.properties['width'], equals(100));
      expect(widget.properties['height'], equals(50));
    });
  });

  // TC-021: padding
  group('TC-021: padding', () {
    test('TC-021: padding with all-sides value and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'padding',
        'padding': {'all': 16},
        'child': simpleChild(),
      });

      expect(widget.type, equals('padding'));
      expect(widget.properties['padding'], isA<Map>());
      expect(widget.properties['padding']['all'], equals(16));
      expect(widget.child, isNotNull);
    });
  });

  // TC-022: align
  group('TC-022: align', () {
    test('TC-022: align with alignment and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'align',
        'alignment': 'topLeft',
        'child': simpleChild(),
      });

      expect(widget.type, equals('align'));
      expect(widget.properties['alignment'], equals('topLeft'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-023: wrap
  group('TC-023: wrap', () {
    test('TC-023: wrap with direction, spacing, runSpacing', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'wrap',
        'direction': 'horizontal',
        'spacing': 8,
        'runSpacing': 4,
        'children': [simpleChild(), simpleChild(content: 'b')],
      });

      expect(widget.type, equals('wrap'));
      expect(widget.properties['direction'], equals('horizontal'));
      expect(widget.properties['spacing'], equals(8));
      expect(widget.properties['runSpacing'], equals(4));
      expect(widget.children!.length, equals(2));
    });
  });

  // TC-024: conditional
  group('TC-024: conditional', () {
    test('TC-024: conditional with binding expression and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'conditional',
        'condition': '{{isAdmin}}',
        'child': simpleChild(),
      });

      expect(widget.type, equals('conditional'));
      expect(widget.properties['condition'], equals('{{isAdmin}}'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-025: table
  group('TC-025: table', () {
    test('TC-025: table with columns and rows', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'table',
        'columns': 3,
        'rows': [
          {'cells': ['A', 'B', 'C']},
        ],
        'children': [simpleChild()],
      });

      expect(widget.type, equals('table'));
      expect(widget.properties['columns'], equals(3));
      expect(widget.properties['rows'], isA<List>());
    });
  });

  // TC-026: positioned
  group('TC-026: positioned', () {
    test('TC-026: positioned with top, left, and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'positioned',
        'top': 10,
        'left': 20,
        'child': simpleChild(),
      });

      expect(widget.type, equals('positioned'));
      expect(widget.properties['top'], equals(10));
      expect(widget.properties['left'], equals(20));
      expect(widget.child, isNotNull);
    });
  });

  // TC-027~028: intrinsicHeight / intrinsicWidth
  group('TC-027~028: intrinsicHeight/Width', () {
    test('TC-027: intrinsicHeight with child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'intrinsicHeight',
        'child': simpleChild(),
      });

      expect(widget.type, equals('intrinsicHeight'));
      expect(widget.child, isNotNull);
    });

    test('TC-028: intrinsicWidth with child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'intrinsicWidth',
        'child': simpleChild(),
      });

      expect(widget.type, equals('intrinsicWidth'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-029: aspectRatio
  group('TC-029: aspectRatio', () {
    test('TC-029: aspectRatio with ratio and child', () {
      final ratio = 16 / 9;
      final widget = WidgetDefinition.fromJson({
        'type': 'aspectRatio',
        'ratio': ratio,
        'child': simpleChild(),
      });

      expect(widget.type, equals('aspectRatio'));
      expect(widget.properties['ratio'], closeTo(1.7778, 0.001));
      expect(widget.child, isNotNull);
    });
  });

  // TC-030: baseline
  group('TC-030: baseline', () {
    test('TC-030: baseline with baselineType to avoid type conflict', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'baseline',
        'baseline': 24,
        'baselineType': 'alphabetic',
        'child': simpleChild(),
      });

      expect(widget.type, equals('baseline'));
      expect(widget.properties['baseline'], equals(24));
      expect(widget.properties['baselineType'], equals('alphabetic'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-031 (constrainedBox) removed — `constrainedBox` is no longer a
  // separate widget. Min/max constraints are properties of `box`.

  // TC-032: fittedBox
  group('TC-032: fittedBox', () {
    test('TC-032: fittedBox with fit and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'fittedBox',
        'fit': 'contain',
        'child': simpleChild(),
      });

      expect(widget.type, equals('fittedBox'));
      expect(widget.properties['fit'], equals('contain'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-033: limitedBox
  group('TC-033: limitedBox', () {
    test('TC-033: limitedBox with maxWidth and maxHeight', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'limitedBox',
        'maxWidth': 200,
        'maxHeight': 100,
      });

      expect(widget.type, equals('limitedBox'));
      expect(widget.properties['maxWidth'], equals(200));
      expect(widget.properties['maxHeight'], equals(100));
    });
  });

  // TC-034: flow
  group('TC-034: flow', () {
    test('TC-034: flow with children', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'flow',
        'children': [simpleChild(), simpleChild(content: 'b')],
      });

      expect(widget.type, equals('flow'));
      expect(widget.children!.length, equals(2));
    });
  });

  // TC-035: margin
  group('TC-035: margin', () {
    test('TC-035: margin with all-sides value and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'margin',
        'margin': {'all': 16},
        'child': simpleChild(),
      });

      expect(widget.type, equals('margin'));
      expect(widget.properties['margin'], isA<Map>());
      expect(widget.properties['margin']['all'], equals(16));
      expect(widget.child, isNotNull);
    });
  });

  // TC-036: fractionallySized (v1.1)
  group('TC-036: fractionallySized', () {
    test('TC-036: fractionallySized with width/height factors', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'fractionallySized',
        'widthFactor': 0.5,
        'heightFactor': 0.8,
      });

      expect(widget.type, equals('fractionallySized'));
      expect(widget.properties['widthFactor'], equals(0.5));
      expect(widget.properties['heightFactor'], equals(0.8));
    });
  });

  // TC-037: mediaQuery (v1.1)
  group('TC-037: mediaQuery', () {
    test('TC-037: mediaQuery with breakpoints', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'mediaQuery',
        'breakpoints': {
          'mobile': {'maxWidth': 600},
          'tablet': {'maxWidth': 1024},
          'desktop': {'minWidth': 1025},
        },
      });

      expect(widget.type, equals('mediaQuery'));
      expect(widget.properties['breakpoints'], isA<Map>());
      expect(widget.properties['breakpoints']['mobile']['maxWidth'], equals(600));
    });
  });

  // TC-038: safeArea (v1.1)
  group('TC-038: safeArea', () {
    test('TC-038: safeArea with top and bottom', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'safeArea',
        'top': true,
        'bottom': true,
      });

      expect(widget.type, equals('safeArea'));
      expect(widget.properties['top'], isTrue);
      expect(widget.properties['bottom'], isTrue);
    });
  });

  // TC-039: errorBoundary (v1.1)
  group('TC-039: errorBoundary', () {
    test('TC-039: errorBoundary with fallback', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'errorBoundary',
        'fallback': {'type': 'text', 'content': 'Error occurred'},
        'child': simpleChild(),
      });

      expect(widget.type, equals('errorBoundary'));
      expect(widget.properties['fallback'], isA<Map>());
      expect(widget.properties['fallback']['content'], equals('Error occurred'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-040~050: Boundary / edge cases
  group('TC-040~050: Layout boundary/edge cases', () {
    // TC-040: Layout with empty children list
    test('TC-040: layout with empty children list', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'direction': 'horizontal',
        'children': [],
      });

      expect(widget.children, isNotNull);
      expect(widget.children!.isEmpty, isTrue);
    });

    // TC-041: Layout with null direction defaults
    test('TC-041: layout with null direction defaults', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
      });

      expect(widget.properties['direction'], isNull);
      expect(widget.children, isNull);
    });

    // TC-042: Layout with negative spacing still parses
    test('TC-042: layout with negative spacing still parses', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'spacing': -5,
        'children': [simpleChild()],
      });

      expect(widget.properties['spacing'], equals(-5));
    });

    // TC-043: Nested layouts (linear inside box inside stack)
    test('TC-043: nested layouts (linear inside box inside stack)', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'stack',
        'children': [
          {
            'type': 'box',
            'width': 200,
            'child': {
              'type': 'linear',
              'direction': 'vertical',
              'children': [
                simpleChild(content: 'nested'),
              ],
            },
          },
        ],
      });

      expect(widget.type, equals('stack'));
      final box = widget.children![0];
      expect(box.type, equals('box'));
      expect(box.properties['width'], equals(200));
      final linear = box.child!;
      expect(linear.type, equals('linear'));
      expect(linear.properties['direction'], equals('vertical'));
      expect(linear.children![0].properties['content'], equals('nested'));
    });

    // TC-044: Layout with visible=false
    test('TC-044: layout with visible=false', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'visible': false,
        'children': [simpleChild()],
      });

      expect(widget.visible, isFalse);
    });

    // TC-045: Layout with binding expression visibility
    test('TC-045: layout with binding expression visibility', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'box',
        'visible': '{{showPanel}}',
        'child': simpleChild(),
      });

      expect(widget.visible, isNull);
      expect(widget.visibleExpression, equals('{{showPanel}}'));
    });

    // TC-046: Layout with accessibility config
    test('TC-046: layout with accessibility config', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'linear',
        'accessibility': {
          'role': 'list',
          'semanticLabel': 'Menu items',
        },
        'children': [simpleChild()],
      });

      expect(widget.accessibility, isNotNull);
      expect(widget.accessibility!.role, equals('list'));
      expect(widget.accessibility!.semanticLabel, equals('Menu items'));
    });

    // TC-047: Layout with metadata
    test('TC-047: layout with metadata', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'box',
        'metadata': {
          'author': 'designer',
          'version': 1,
        },
      });

      expect(widget.metadata['author'], equals('designer'));
      expect(widget.metadata['version'], equals(1));
    });

    // TC-048: Layout toJson -> fromJson roundtrip preserves data
    test('TC-048: layout toJson -> fromJson roundtrip', () {
      final original = WidgetDefinition.fromJson({
        'type': 'linear',
        'direction': 'horizontal',
        'alignment': 'center',
        'spacing': 12,
        'visible': true,
        'key': 'main-row',
        'children': [
          {'type': 'text', 'content': 'A'},
          {'type': 'text', 'content': 'B'},
        ],
      });

      final json = original.toJson();
      final restored = WidgetDefinition.fromJson(json);

      expect(restored.type, equals(original.type));
      expect(restored.properties['direction'], equals(original.properties['direction']));
      expect(restored.properties['alignment'], equals(original.properties['alignment']));
      expect(restored.properties['spacing'], equals(original.properties['spacing']));
      expect(restored.visible, equals(original.visible));
      expect(restored.key, equals(original.key));
      expect(restored.children!.length, equals(original.children!.length));
      expect(restored.children![0].properties['content'], equals('A'));
      expect(restored.children![1].properties['content'], equals('B'));
    });

    // TC-049: Layout copyWith changes specific fields
    test('TC-049: layout copyWith changes specific fields', () {
      final original = WidgetDefinition(
        type: 'linear',
        properties: {'direction': 'horizontal', 'spacing': 8},
        visible: true,
        key: 'row-1',
      );

      final modified = original.copyWith(
        key: 'row-2',
        visible: false,
      );

      expect(modified.key, equals('row-2'));
      expect(modified.visible, isFalse);
      // Unchanged fields preserved
      expect(modified.type, equals('linear'));
      expect(modified.properties['direction'], equals('horizontal'));
      expect(modified.properties['spacing'], equals(8));
    });

    // TC-050: Layout with all optional fields omitted — defaults
    test('TC-050: layout with all optional fields omitted', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'box',
      });

      expect(widget.type, equals('box'));
      expect(widget.visible, isNull);
      expect(widget.visibleExpression, isNull);
      expect(widget.key, isNull);
      expect(widget.testKey, isNull);
      expect(widget.properties, isEmpty);
      expect(widget.children, isNull);
      expect(widget.child, isNull);
      expect(widget.accessibility, isNull);
      expect(widget.i18n, isNull);
      expect(widget.metadata, isEmpty);
    });
  });
}
