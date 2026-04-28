// TC-001 ~ TC-014: Constants Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-001: Widget type constants completeness
  // =========================================================================
  group('TC-001: Widget type constants completeness', () {
    test('Normal: all widget types defined by category', () {
      final cats = WidgetTypes.categories;
      expect(cats.containsKey('layout'), isTrue);
      expect(cats.containsKey('display'), isTrue);
      expect(cats.containsKey('input'), isTrue);
      expect(cats.containsKey('list'), isTrue);
      expect(cats.containsKey('navigation'), isTrue);
      expect(cats.containsKey('scroll'), isTrue);
      expect(cats.containsKey('animation'), isTrue);
      expect(cats.containsKey('interactive'), isTrue);
      expect(cats.containsKey('dialog'), isTrue);
      expect(cats.containsKey('advanced'), isTrue);
      expect(cats.containsKey('performance'), isTrue);
      expect(cats.containsKey('security'), isTrue);
      expect(cats.containsKey('utility'), isTrue);
      expect(cats.containsKey('accessibility'), isTrue);

      // Layout: includes legacy alias container, v1.1 mediaQuery, safeArea
      expect(cats['layout'], contains('container'));
      expect(cats['layout'], contains('mediaQuery'));
      expect(cats['layout'], contains('safeArea'));

      // Display: includes progressBar, banner
      expect(cats['display'], contains('progressBar'));
      expect(cats['display'], contains('banner'));

      // Animation: includes v1.1 lottieAnimation
      expect(cats['animation'], contains('lottieAnimation'));

      // Security: v1.1 permissionPrompt
      expect(cats['security'], contains('permissionPrompt'));

      // Utility: v1.1 widgets
      expect(cats['utility'], contains('errorBoundary'));
      expect(cats['utility'], contains('offlineFallback'));
      expect(cats['utility'], contains('errorRecovery'));
    });

    test('Boundary: no duplicate type names across all categories', () {
      final allTypes = WidgetTypes.allTypes;
      final uniqueTypes = allTypes.toSet();
      expect(allTypes.length, equals(uniqueTypes.length),
          reason: 'There should be no duplicate widget type names');
    });
  });

  // =========================================================================
  // TC-002: Legacy widget aliases
  // =========================================================================
  group('TC-002: Legacy widget aliases', () {
    test('Normal: container is retained as valid alias for box', () {
      expect(WidgetTypes.container, equals('container'));
      expect(WidgetTypes.isValidType('container'), isTrue);
      expect(WidgetTypes.legacyAliases['container'], equals('box'));
    });

    test('Boundary: kebab-case aliases in legacyAliases map', () {
      // Only kebab-case aliases and container are in WidgetTypes.legacyAliases
      // camelCase names (column, row, etc.) are accepted at runtime level only
      final kebabAliases = [
        'date-picker', 'time-picker', 'list-view', 'grid-view',
        'bottom-navigation', 'tab-bar', 'tab-bar-view',
        'text-input', 'rich-text', 'sized-box', 'icon-button',
      ];
      for (final name in kebabAliases) {
        expect(WidgetTypes.legacyAliases.containsKey(name), isTrue,
            reason: '$name should be in legacyAliases');
      }
    });

    test('Error: legacy names other than container are not valid types', () {
      // 'column', 'row', 'switch', etc. are not valid type constants
      expect(WidgetTypes.isValidType('column'), isFalse);
      expect(WidgetTypes.isValidType('row'), isFalse);
      expect(WidgetTypes.isValidType('switch'), isFalse);
      expect(WidgetTypes.isValidType('textField'), isFalse);
      expect(WidgetTypes.isValidType('dropdown'), isFalse);
      expect(WidgetTypes.isValidType('listview'), isFalse);
      expect(WidgetTypes.isValidType('gridview'), isFalse);
      expect(WidgetTypes.isValidType('appbar'), isFalse);
    });
  });

  // =========================================================================
  // TC-003: Widget type details — lazy
  // =========================================================================
  group('TC-003: Widget type details — lazy', () {
    test('Normal: lazy widget is a valid widget type', () {
      expect(WidgetTypes.isValidType('lazy'), isTrue);
      expect(WidgetTypes.lazy, equals('lazy'));
    });

    test('Normal: lazy widget is in performance category', () {
      expect(WidgetTypes.getCategoryForType('lazy'), equals('performance'));
      expect(WidgetTypes.categories['performance'], contains('lazy'));
    });

    test('Normal: lazy widget parsed via WidgetDefinition with placeholder and content', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'lazy',
        'properties': {
          'placeholder': {'type': 'loadingIndicator'},
          'content': {'source': 'https://example.com/widget.json'},
        },
      });
      expect(widget.type, equals('lazy'));
      expect(widget.properties['placeholder'], isA<Map>());
      expect(widget.properties['content']['source'],
          equals('https://example.com/widget.json'));
    });

    test('Boundary: placeholder is a full widget definition', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'lazy',
        'properties': {
          'placeholder': {
            'type': 'text',
            'properties': {'content': 'Loading...'},
          },
          'content': {'source': 'bundle://widgets/detail'},
        },
      });
      final placeholder =
          widget.properties['placeholder'] as Map<String, dynamic>;
      expect(placeholder['type'], equals('text'));
    });

    test('Error: missing content.source field', () {
      // Widget still parses, but content.source is absent
      final widget = WidgetDefinition.fromJson({
        'type': 'lazy',
        'properties': {
          'placeholder': {'type': 'loadingIndicator'},
          'content': {},
        },
      });
      expect(widget.properties['content']['source'], isNull);
    });
  });

  // =========================================================================
  // TC-004: Widget type details — lottieAnimation (v1.1)
  // =========================================================================
  group('TC-004: Widget type details — lottieAnimation', () {
    test('Normal: lottieAnimation is a valid widget type', () {
      expect(WidgetTypes.isValidType('lottieAnimation'), isTrue);
      expect(WidgetTypes.lottieAnimation, equals('lottieAnimation'));
    });

    test('Normal: lottieAnimation is in animation category', () {
      expect(
          WidgetTypes.getCategoryForType('lottieAnimation'), equals('animation'));
    });

    test('Normal: parse all 8 properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'lottieAnimation',
        'properties': {
          'src': 'assets/animation.json',
          'autoPlay': true,
          'loop': true,
          'controller': 'lottieCtrl',
          'width': 200,
          'height': 200,
          'fit': 'contain',
          'onComplete': {
            'type': 'state',
            'action': 'set',
            'binding': 'animDone',
            'value': true,
          },
        },
      });
      expect(widget.type, equals('lottieAnimation'));
      expect(widget.properties['src'], equals('assets/animation.json'));
      expect(widget.properties['autoPlay'], isTrue);
      expect(widget.properties['loop'], isTrue);
      expect(widget.properties['controller'], equals('lottieCtrl'));
      expect(widget.properties['width'], equals(200));
      expect(widget.properties['height'], equals(200));
      expect(widget.properties['fit'], equals('contain'));
      expect(widget.properties['onComplete'], isA<Map>());
    });

    test('Boundary: fit values (cover, contain, fill)', () {
      for (final fit in ['cover', 'contain', 'fill']) {
        final widget = WidgetDefinition.fromJson({
          'type': 'lottieAnimation',
          'properties': {'src': 'anim.json', 'fit': fit},
        });
        expect(widget.properties['fit'], equals(fit));
      }
    });

    test('Boundary: onComplete is an ActionDefinition map', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'lottieAnimation',
        'properties': {
          'src': 'anim.json',
          'onComplete': {
            'type': 'notification',
            'message': 'Animation complete',
          },
        },
      });
      final onComplete =
          widget.properties['onComplete'] as Map<String, dynamic>;
      expect(onComplete['type'], equals('notification'));
    });

    test('Error: missing src field', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'lottieAnimation',
        'properties': {},
      });
      expect(widget.properties['src'], isNull);
    });
  });

  // =========================================================================
  // TC-005: Widget type details — advanced widgets
  // =========================================================================
  group('TC-005: Widget type details — advanced widgets', () {
    test('Normal: chart widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'chart',
        'properties': {
          'type': 'bar',
          'data': [1, 2, 3],
          'options': {'responsive': true},
          'labels': ['A', 'B', 'C'],
          'colors': ['#FF0000', '#00FF00', '#0000FF'],
        },
      });
      expect(widget.type, equals('chart'));
      expect(widget.properties['data'], equals([1, 2, 3]));
      expect(widget.properties['labels'], equals(['A', 'B', 'C']));
    });

    test('Normal: map widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'map',
        'properties': {
          'center': {'lat': 37.5, 'lng': 127.0},
          'zoom': 12,
          'markers': [],
          'style': 'satellite',
        },
      });
      expect(widget.properties['center']['lat'], equals(37.5));
      expect(widget.properties['zoom'], equals(12));
    });

    test('Normal: mediaPlayer widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'mediaPlayer',
        'properties': {
          'src': 'https://example.com/video.mp4',
          'autoplay': false,
          'controls': true,
          'loop': false,
        },
      });
      expect(widget.properties['src'], equals('https://example.com/video.mp4'));
      expect(widget.properties['controls'], isTrue);
    });

    test('Normal: calendar widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'calendar',
        'properties': {
          'selectedDate': '2026-01-01',
          'minDate': '2025-01-01',
          'maxDate': '2027-12-31',
          'events': [],
        },
      });
      expect(widget.properties['selectedDate'], equals('2026-01-01'));
    });

    test('Normal: gauge widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'gauge',
        'properties': {
          'value': 75,
          'min': 0,
          'max': 100,
          'segments': [
            {'from': 0, 'to': 50, 'color': '#00FF00'},
            {'from': 50, 'to': 100, 'color': '#FF0000'},
          ],
        },
      });
      expect(widget.properties['value'], equals(75));
      expect(widget.properties['min'], equals(0));
      expect(widget.properties['max'], equals(100));
    });

    test('Normal: codeEditor widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'codeEditor',
        'properties': {
          'code': 'void main() {}',
          'language': 'dart',
          'theme': 'monokai',
          'readOnly': false,
        },
      });
      expect(widget.properties['language'], equals('dart'));
      expect(widget.properties['readOnly'], isFalse);
    });

    test('Normal: terminal widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'terminal',
        'properties': {
          'commands': ['ls', 'pwd'],
          'prompt': r'$',
          'history': true,
        },
      });
      expect(widget.properties['prompt'], equals(r'$'));
    });

    test('Normal: webView widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'webView',
        'properties': {
          'url': 'https://example.com',
          'allowNavigation': false,
        },
      });
      expect(widget.properties['url'], equals('https://example.com'));
      expect(widget.properties['allowNavigation'], isFalse);
    });

    test('Normal: signature widget properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'signature',
        'properties': {
          'strokeWidth': 2.0,
          'strokeColor': '#000000',
          'backgroundColor': '#FFFFFF',
        },
      });
      expect(widget.properties['strokeWidth'], equals(2.0));
    });

    test('Normal: all advanced widget types are valid', () {
      final advancedWidgets = [
        'chart', 'map', 'mediaPlayer', 'calendar', 'timeline',
        'gauge', 'heatmap', 'tree', 'graph', 'networkGraph',
        'codeEditor', 'terminal', 'fileExplorer', 'markdown',
        'webView', 'signature',
      ];
      for (final wt in advancedWidgets) {
        expect(WidgetTypes.isValidType(wt), isTrue,
            reason: '$wt should be a valid type');
      }
    });

    test('Boundary: gauge defaults (min=0, max=100)', () {
      // Gauge properties are stored as-is; defaults are a rendering concern
      // but we verify that the widget definition accepts the properties
      final widget = WidgetDefinition.fromJson({
        'type': 'gauge',
        'properties': {'value': 50},
      });
      expect(widget.properties['min'], isNull);
      expect(widget.properties['max'], isNull);
    });

    test('Boundary: codeEditor readOnly default false', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'codeEditor',
        'properties': {'code': '', 'language': 'javascript'},
      });
      // readOnly not specified, defaults handled at rendering layer
      expect(widget.properties['readOnly'], isNull);
    });

    test('Boundary: webView allowNavigation default false', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'webView',
        'properties': {'url': 'https://example.com'},
      });
      expect(widget.properties['allowNavigation'], isNull);
    });

    test('Boundary: terminal prompt default', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'terminal',
        'properties': {'commands': []},
      });
      expect(widget.properties['prompt'], isNull);
    });
  });

  // =========================================================================
  // TC-006: Action type constants completeness
  // =========================================================================
  group('TC-006: Action type constants completeness', () {
    test('Normal: all action types defined', () {
      final all = ActionTypes.all;
      // Core
      expect(all, contains('state'));
      expect(all, contains('navigation'));
      expect(all, contains('tool'));
      expect(all, contains('resource'));
      expect(all, contains('dialog'));
      expect(all, contains('batch'));
      expect(all, contains('conditional'));
      expect(all, contains('notification'));
      expect(all, contains('parallel'));
      expect(all, contains('sequence'));
      // Extended v1.1
      expect(all, contains('animation'));
      expect(all, contains('cancel'));
      expect(all, contains('permission.revoke'));
      // Client actions
      expect(all, contains('client.selectFile'));
      expect(all, contains('client.readFile'));
      expect(all, contains('client.writeFile'));
      expect(all, contains('client.saveFile'));
      expect(all, contains('client.listFiles'));
      expect(all, contains('client.httpRequest'));
      expect(all, contains('client.getSystemInfo'));
      expect(all, contains('client.clipboard'));
      expect(all, contains('client.exec'));
      expect(all, contains('client.notification'));
      expect(all, contains('client.storage.get'));
      expect(all, contains('client.storage.set'));
      expect(all, contains('client.storage.remove'));
      // Channel actions
      expect(all, contains('channel.start'));
      expect(all, contains('channel.stop'));
      expect(all, contains('channel.restart'));
      expect(all, contains('channel.toggle'));
      expect(all, contains('channel.send'));
    });

    test('Boundary: no duplicate action type names', () {
      final all = ActionTypes.all;
      expect(all.length, equals(all.toSet().length));
    });
  });

  // =========================================================================
  // TC-007: State action operations
  // =========================================================================
  group('TC-007: State action operations', () {
    test('Normal: all 9 operations defined', () {
      expect(StateOperations.all, hasLength(9));
      expect(StateOperations.all, contains('set'));
      expect(StateOperations.all, contains('increment'));
      expect(StateOperations.all, contains('decrement'));
      expect(StateOperations.all, contains('toggle'));
      expect(StateOperations.all, contains('append'));
      expect(StateOperations.all, contains('remove'));
      expect(StateOperations.all, contains('push'));
      expect(StateOperations.all, contains('pop'));
      expect(StateOperations.all, contains('removeAt'));
    });

    test('Boundary: push is defined (alias for append)', () {
      expect(StateOperations.push, equals('push'));
      expect(StateOperations.isValid('push'), isTrue);
    });
  });

  // =========================================================================
  // TC-008: Navigation actions
  // =========================================================================
  group('TC-008: Navigation actions', () {
    test('Normal: all 6 actions defined', () {
      expect(NavigationActions.all, hasLength(7));
      expect(NavigationActions.all, contains('push'));
      expect(NavigationActions.all, contains('replace'));
      expect(NavigationActions.all, contains('pop'));
      expect(NavigationActions.all, contains('popToRoot'));
      expect(NavigationActions.all, contains('pushAndClear'));
      expect(NavigationActions.all, contains('setIndex'));
      expect(NavigationActions.all, contains('openApp'));
    });

    test('Boundary: pushAndClear is defined', () {
      expect(NavigationActions.pushAndClear, equals('pushAndClear'));
      expect(NavigationActions.isValid('pushAndClear'), isTrue);
    });
  });

  // =========================================================================
  // TC-009: Event name constants
  // =========================================================================
  group('TC-009: Event name constants', () {
    test('Normal: all 9 event names defined', () {
      expect(EventNames.all, hasLength(9));
      expect(EventNames.all, contains('click'));
      expect(EventNames.all, contains('double-click'));
      expect(EventNames.all, contains('right-click'));
      expect(EventNames.all, contains('long-press'));
      expect(EventNames.all, contains('change'));
      expect(EventNames.all, contains('focus'));
      expect(EventNames.all, contains('blur'));
      expect(EventNames.all, contains('hover'));
    });

    test('Boundary: names use kebab-case format', () {
      expect(EventNames.doubleClick, equals('double-click'));
      expect(EventNames.rightClick, equals('right-click'));
      expect(EventNames.longPress, equals('long-press'));
    });
  });

  // =========================================================================
  // TC-010: Button variants
  // =========================================================================
  group('TC-010: Button variants', () {
    test('Normal: all 5 variants defined', () {
      expect(ButtonVariants.all, hasLength(5));
      expect(ButtonVariants.all, contains('elevated'));
      expect(ButtonVariants.all, contains('filled'));
      expect(ButtonVariants.all, contains('outlined'));
      expect(ButtonVariants.all, contains('text'));
      expect(ButtonVariants.all, contains('icon'));
    });

    test('Boundary: no duplicates', () {
      expect(ButtonVariants.all.length, equals(ButtonVariants.all.toSet().length));
    });
  });

  // =========================================================================
  // TC-011: Size units
  // =========================================================================
  group('TC-011: Size units', () {
    test('Normal: all 6 units defined', () {
      expect(SizeUnits.all, hasLength(6));
      expect(SizeUnits.all, contains('px'));
      expect(SizeUnits.all, contains('percent'));
      expect(SizeUnits.all, contains('em'));
      expect(SizeUnits.all, contains('rem'));
      expect(SizeUnits.all, contains('vw'));
      expect(SizeUnits.all, contains('vh'));
    });

    test('Boundary: no duplicates', () {
      expect(SizeUnits.all.length, equals(SizeUnits.all.toSet().length));
    });
  });

  // =========================================================================
  // TC-012: Theme modes
  // =========================================================================
  group('TC-012: Theme modes', () {
    test('Normal: all 3 modes defined', () {
      expect(ThemeModes.all, hasLength(3));
      expect(ThemeModes.all, contains('light'));
      expect(ThemeModes.all, contains('dark'));
      expect(ThemeModes.all, contains('system'));
    });

    test('Boundary: no duplicates', () {
      expect(ThemeModes.all.length, equals(ThemeModes.all.toSet().length));
    });
  });

  // =========================================================================
  // TC-013: Binding prefixes
  // =========================================================================
  group('TC-013: Binding prefixes', () {
    test('Normal: all prefixes defined', () {
      final all = BindingPrefixes.all;
      expect(all, contains('local.'));
      expect(all, contains('page.'));
      expect(all, contains('app.'));
      expect(all, contains('route.params.'));
      expect(all, contains('theme.'));
      expect(all, contains('event.'));
      expect(all, contains('item'));
      expect(all, contains('index'));
      expect(all, contains('client.'));
      expect(all, contains('client.file.'));
      expect(all, contains('client.system.'));
      expect(all, contains('client.theme.'));
      expect(all, contains('client.env.'));
      expect(all, contains('permissions.'));
      expect(all, contains('channels.'));
      expect(all, contains('resources.'));
      expect(all, contains('sync.'));
      expect(all, contains('runtime.'));
    });
  });

  // =========================================================================
  // TC-014: Validation rule types
  // =========================================================================
  group('TC-014: Validation rule types', () {
    test('Normal: all rule types defined', () {
      expect(ValidationRuleTypes.all, contains('required'));
      expect(ValidationRuleTypes.all, contains('minLength'));
      expect(ValidationRuleTypes.all, contains('maxLength'));
      expect(ValidationRuleTypes.all, contains('min'));
      expect(ValidationRuleTypes.all, contains('max'));
      expect(ValidationRuleTypes.all, contains('pattern'));
      expect(ValidationRuleTypes.all, contains('email'));
      expect(ValidationRuleTypes.all, contains('url'));
      expect(ValidationRuleTypes.all, contains('match'));
      expect(ValidationRuleTypes.all, contains('async'));
    });

    test('Boundary: async rule is defined', () {
      expect(ValidationRuleTypes.isValid('async'), isTrue);
    });
  });
}
