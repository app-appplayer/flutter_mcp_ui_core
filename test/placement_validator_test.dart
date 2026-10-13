/// Registry `placement` applied to widget trees.
///
/// Cases follow the runtime measurement (2026-10-09, runtime 0.8.4): which
/// parents actually lay out `expanded` / `flexible` / `spacer` /
/// `positioned` / `animatedPositioned`, and which widgets in between are
/// transparent. The runtime-side conformance test renders the same shapes.
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:test/test.dart';

Map<String, dynamic> w(String type, [Map<String, dynamic> props = const {}]) =>
    {'type': type, ...props};

const _text = {'type': 'text', 'value': 'x'};

List<String> paths(Object? tree) =>
    validateMcpUiDslPlacement(tree).errors.map((e) => e.path).toList();

void main() {
  group('flex children', () {
    for (final child in ['expanded', 'flexible', 'spacer']) {
      final node = child == 'spacer' ? w(child) : w(child, {'child': _text});

      test('$child inside linear is valid', () {
        expect(paths(w('linear', {'children': [node]})), isEmpty);
      });

      test('$child inside row / column aliases is valid', () {
        expect(paths(w('row', {'children': [node]})), isEmpty);
        expect(paths(w('column', {'children': [node]})), isEmpty);
      });

      test('$child at the tree root is reported', () {
        expect(paths(node), ['#']);
      });

      test('$child inside stack is reported', () {
        expect(paths(w('stack', {'children': [node]})), ['#/children/0']);
      });

      test('$child behind a box inside linear is reported', () {
        final tree = w('linear', {
          'children': [
            w('box', {'child': node}),
          ],
        });
        expect(paths(tree), ['#/children/0/child']);
      });
    }

    test('linear with wrap: true is not a flex parent', () {
      final tree = w('linear', {
        'wrap': true,
        'children': [
          w('expanded', {'child': _text}),
        ],
      });
      final errors = validateMcpUiDslPlacement(tree).errors;
      expect(errors.map((e) => e.path), ['#/children/0']);
      expect(errors.single.message, contains('`linear` with `wrap: true`'));
    });

    test('a list item template is not a flex parent', () {
      final tree = w('list', {
        'items': '{{rows}}',
        'itemTemplate': w('expanded', {'child': _text}),
      });
      expect(paths(tree), ['#/itemTemplate']);
    });
  });

  group('stack children', () {
    for (final child in ['positioned', 'animatedPositioned']) {
      final node = w(child, {'top': 0, 'child': _text});

      test('$child inside stack is valid', () {
        expect(paths(w('stack', {'children': [node]})), isEmpty);
      });

      test('$child inside indexedStack is reported', () {
        expect(paths(w('indexedStack', {'children': [node]})),
            ['#/children/0']);
      });

      test('$child inside linear is reported', () {
        expect(paths(w('linear', {'children': [node]})), ['#/children/0']);
      });
    }
  });

  group('transparent widgets', () {
    final expanded = w('expanded', {'child': _text});

    test('conditional then / else keep the outer parent', () {
      final tree = w('linear', {
        'children': [
          w('conditional', {
            'condition': '{{flag}}',
            'then': expanded,
            'else': w('spacer'),
          }),
        ],
      });
      expect(paths(tree), isEmpty);
    });

    test('conditional cases keep the outer parent', () {
      final tree = w('linear', {
        'children': [
          w('conditional', {
            'switch': '{{mode}}',
            'cases': [
              {'value': 'a', 'child': expanded},
            ],
            'default': w('spacer'),
          }),
        ],
      });
      expect(paths(tree), isEmpty);
    });

    test('conditional does not make a parent out of nothing', () {
      expect(paths(w('conditional', {'then': expanded})), ['#/then']);
    });

    test('visibility child and replacement keep the outer parent', () {
      final tree = w('linear', {
        'children': [
          w('visibility', {
            'visible': '{{show}}',
            'child': expanded,
            'replacement': w('spacer'),
          }),
        ],
      });
      expect(paths(tree), isEmpty);
    });

    for (final flag in [
      'maintainState',
      'maintainSize',
      'maintainAnimation',
      'maintainInteractivity',
    ]) {
      test('visibility with $flag: true is opaque', () {
        final tree = w('linear', {
          'children': [
            w('visibility', {flag: true, 'child': expanded}),
          ],
        });
        expect(paths(tree), ['#/children/0/child']);
      });
    }

    test('nested transparent widgets are looked through', () {
      final tree = w('stack', {
        'children': [
          w('conditional', {
            'then': w('visibility', {
              'child': w('positioned', {'top': 0, 'child': _text}),
            }),
          }),
        ],
      });
      expect(paths(tree), isEmpty);
    });
  });

  group('what the walk does not descend into', () {
    test('a gradient typed linear inside a decoration is not a widget', () {
      final tree = w('box', {
        'decoration': {
          'gradient': {
            'type': 'linear',
            'colors': ['#000000', '#ffffff'],
          },
        },
        'child': w('expanded', {'child': _text}),
      });
      expect(paths(tree), ['#/child']);
    });

    test('a widget carried by an action is not a child of the button', () {
      final tree = w('linear', {
        'children': [
          w('button', {
            'label': 'Open',
            'click': {
              'type': 'showDialog',
              'content': w('expanded', {'child': _text}),
            },
          }),
        ],
      });
      expect(paths(tree), isEmpty);
    });

    test('an unknown type is left to the schema check', () {
      final tree = w('notAWidget', {
        'children': [
          w('expanded', {'child': _text}),
        ],
      });
      expect(paths(tree), isEmpty);
    });

    test('a null or non-map root has nothing to place', () {
      expect(paths(null), isEmpty);
      expect(paths('text'), isEmpty);
    });
  });

  group('widgets inside named-type properties', () {
    final expanded = w('expanded', {'child': _text});

    test('a stepper step content is not a flex parent', () {
      final tree = w('stepper', {
        'steps': [
          {'title': 'One', 'content': expanded},
        ],
      });
      expect(paths(tree), ['#/steps/0/content']);
    });

    test('a linear inside a step content is', () {
      final tree = w('stepper', {
        'steps': [
          {
            'title': 'One',
            'content': w('linear', {'children': [expanded]}),
          },
        ],
      });
      expect(paths(tree), isEmpty);
    });

    test('table cells, richText widget spans, popup items, slivers', () {
      expect(paths(w('table', {'rows': [{'cells': [expanded]}]})), ['#/rows/0/cells/0']);
      expect(paths(w('richText', {'spans': [{'widget': expanded}]})), ['#/spans/0/widget']);
      expect(paths(w('popupMenuButton', {'items': [{'value': 'a', 'child': expanded}]})), ['#/items/0/child']);
      expect(paths(w('scrollView', {'slivers': [{'type': 'sliverList', 'children': [expanded]}]})),
          ['#/slivers/0/children/0']);
    });
  });

  group('table', () {
    test('every rule names canonical parents', () {
      for (final rule in mcpUiDslPlacementRules.values) {
        for (final parent in rule.parents) {
          expect(isMcpUiDslWidgetType(parent), isTrue, reason: parent);
        }
      }
    });
  });
}
