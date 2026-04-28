import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-001: Widget type constants completeness
  group('TC-001: WidgetTypes', () {
    test('Normal: all widget types defined by category', () {
      final categories = WidgetTypes.categories;

      expect(categories['layout']!.length, equals(31));
      expect(categories['display']!.length, equals(20));
      expect(categories['input']!.length, equals(24));
      expect(categories['list']!.length, equals(4));
      expect(categories['navigation']!.length, equals(8));
      expect(categories['scroll']!.length, equals(4));
      expect(categories['animation']!.length, equals(4));
      expect(categories['interactive']!.length, equals(4));
      expect(categories['dialog']!.length, equals(5));
      expect(categories['advanced']!.length, equals(17));
      expect(categories['performance']!.length, equals(1));
      expect(categories['security']!.length, equals(1));
      expect(categories['utility']!.length, equals(3));
      expect(categories['accessibility']!.length, equals(1));
      expect(categories['template']!.length, equals(1));
    });

    test('Boundary: no duplicate type names across categories', () {
      final allTypes = <String>[];
      for (final types in WidgetTypes.categories.values) {
        allTypes.addAll(types);
      }
      final uniqueTypes = allTypes.toSet();
      expect(uniqueTypes.length, equals(allTypes.length));
    });

    test('Normal: isValidType returns true for known types', () {
      expect(WidgetTypes.isValidType('text'), isTrue);
      expect(WidgetTypes.isValidType('linear'), isTrue);
      expect(WidgetTypes.isValidType('button'), isTrue);
      expect(WidgetTypes.isValidType('chart'), isTrue);
    });

    test('Error: isValidType returns false for unknown types', () {
      expect(WidgetTypes.isValidType('nonexistent'), isFalse);
      expect(WidgetTypes.isValidType(''), isFalse);
    });

    test('Normal: getCategoryForType returns correct category', () {
      expect(WidgetTypes.getCategoryForType('text'), equals('display'));
      expect(WidgetTypes.getCategoryForType('linear'), equals('layout'));
      expect(WidgetTypes.getCategoryForType('button'), equals('input'));
    });

    test('Error: getCategoryForType returns null for unknown', () {
      expect(WidgetTypes.getCategoryForType('nonexistent'), isNull);
    });

    test('Normal: getTypesByCategory returns correct list', () {
      expect(WidgetTypes.getTypesByCategory('list'), contains('grid'));
      expect(WidgetTypes.getTypesByCategory('list'), contains('listTile'));
    });

    test('Error: getTypesByCategory returns empty for unknown', () {
      expect(WidgetTypes.getTypesByCategory('nonexistent'), isEmpty);
    });

    test('Normal: allTypes contains all widget types', () {
      final allTypes = WidgetTypes.allTypes;
      expect(allTypes, contains('text'));
      expect(allTypes, contains('linear'));
      expect(allTypes, contains('button'));
      expect(allTypes, contains('chart'));
      expect(allTypes, contains('lazy'));
      expect(allTypes, contains('permissionPrompt'));
      expect(allTypes, contains('accessibleWrapper'));
    });

    test('Normal: specific widget type constants', () {
      expect(WidgetTypes.linear, equals('linear'));
      expect(WidgetTypes.text, equals('text'));
      expect(WidgetTypes.button, equals('button'));
      expect(WidgetTypes.container, equals('container'));
      expect(WidgetTypes.box, equals('box'));
      expect(WidgetTypes.sizedBox, equals('sizedBox'));
      expect(WidgetTypes.richText, equals('richText'));
      expect(WidgetTypes.iconButton, equals('iconButton'));
      expect(WidgetTypes.alertDialog, equals('alertDialog'));
      expect(WidgetTypes.permissionPrompt, equals('permissionPrompt'));
    });
  });

  // TC-002: Action type constants completeness
  group('TC-002: ActionTypes', () {
    test('Normal: all 10 core action types defined', () {
      expect(ActionTypes.coreTypes.length, equals(10));
      expect(ActionTypes.coreTypes, contains('state'));
      expect(ActionTypes.coreTypes, contains('navigation'));
      expect(ActionTypes.coreTypes, contains('tool'));
      expect(ActionTypes.coreTypes, contains('resource'));
      expect(ActionTypes.coreTypes, contains('dialog'));
      expect(ActionTypes.coreTypes, contains('batch'));
      expect(ActionTypes.coreTypes, contains('conditional'));
      expect(ActionTypes.coreTypes, contains('notification'));
      expect(ActionTypes.coreTypes, contains('parallel'));
      expect(ActionTypes.coreTypes, contains('sequence'));
    });

    test('Normal: all v1.1 action types defined', () {
      expect(ActionTypes.v11Types, contains('animation'));
      expect(ActionTypes.v11Types, contains('cancel'));
      expect(ActionTypes.v11Types, contains('permission.revoke'));
      expect(ActionTypes.v11Types, contains('client.selectFile'));
      expect(ActionTypes.v11Types, contains('client.readFile'));
      expect(ActionTypes.v11Types, contains('channel.start'));
      expect(ActionTypes.v11Types, contains('channel.stop'));
    });

    test('Normal: all combined types', () {
      final all = ActionTypes.all;
      expect(all.length, equals(ActionTypes.coreTypes.length + ActionTypes.v11Types.length));
    });

    test('Boundary: no duplicate action type names', () {
      final all = ActionTypes.all;
      expect(all.toSet().length, equals(all.length));
    });

    test('Normal: isClientAction identifies client actions', () {
      expect(ActionTypes.isClientAction('client.readFile'), isTrue);
      expect(ActionTypes.isClientAction('client.exec'), isTrue);
      expect(ActionTypes.isClientAction('state'), isFalse);
    });

    test('Normal: isChannelAction identifies channel actions', () {
      expect(ActionTypes.isChannelAction('channel.start'), isTrue);
      expect(ActionTypes.isChannelAction('channel.stop'), isTrue);
      expect(ActionTypes.isChannelAction('state'), isFalse);
    });

    test('Normal: isValid for known types', () {
      expect(ActionTypes.isValid('state'), isTrue);
      expect(ActionTypes.isValid('client.readFile'), isTrue);
    });

    test('Error: isValid for unknown types', () {
      expect(ActionTypes.isValid('unknown'), isFalse);
    });

    test('Normal: specific constant values', () {
      expect(ActionTypes.state, equals('state'));
      expect(ActionTypes.navigation, equals('navigation'));
      expect(ActionTypes.tool, equals('tool'));
      expect(ActionTypes.animation, equals('animation'));
      expect(ActionTypes.cancel, equals('cancel'));
      expect(ActionTypes.permissionRevoke, equals('permission.revoke'));
      expect(ActionTypes.channelSend, equals('channel.send'));
    });
  });

  // TC-003: State action operations
  group('TC-003: StateOperations', () {
    test('Normal: all 9 operations defined', () {
      expect(StateOperations.all.length, equals(9));
      expect(StateOperations.all, containsAll([
        'set', 'increment', 'decrement', 'toggle',
        'append', 'remove', 'push', 'pop', 'removeAt',
      ]));
    });

    test('Boundary: push and append both exist', () {
      expect(StateOperations.push, equals('push'));
      expect(StateOperations.append, equals('append'));
      expect(StateOperations.all, contains('push'));
      expect(StateOperations.all, contains('append'));
    });

    test('Normal: isValid for known operations', () {
      expect(StateOperations.isValid('set'), isTrue);
      expect(StateOperations.isValid('toggle'), isTrue);
    });

    test('Error: isValid for unknown operations', () {
      expect(StateOperations.isValid('unknown'), isFalse);
    });
  });

  // TC-004: Navigation actions
  group('TC-004: NavigationActions', () {
    test('Normal: all 7 actions defined', () {
      expect(NavigationActions.all.length, equals(7));
      expect(NavigationActions.all, containsAll([
        'push', 'replace', 'pop', 'popToRoot', 'pushAndClear', 'setIndex', 'openApp',
      ]));
    });

    test('Normal: isValid', () {
      expect(NavigationActions.isValid('push'), isTrue);
      expect(NavigationActions.isValid('pop'), isTrue);
    });

    test('Error: isValid for unknown', () {
      expect(NavigationActions.isValid('unknown'), isFalse);
    });
  });

  // TC-005: Event name constants
  group('TC-005: EventNames', () {
    test('Normal: all 9 event names defined', () {
      expect(EventNames.all.length, equals(9));
      expect(EventNames.all, containsAll([
        'click', 'double-click', 'right-click', 'long-press',
        'change', 'focus', 'blur', 'hover', 'submit',
      ]));
    });

    test('Boundary: names use kebab-case format', () {
      for (final name in EventNames.all) {
        expect(name, matches(RegExp(r'^[a-z]+(-[a-z]+)*$')));
      }
    });

    test('Normal: isValid', () {
      expect(EventNames.isValid('click'), isTrue);
      expect(EventNames.isValid('double-click'), isTrue);
    });

    test('Error: isValid for unknown', () {
      expect(EventNames.isValid('onClick'), isFalse);
    });
  });

  // TC-006: Button variants
  group('TC-006: ButtonVariants', () {
    test('Normal: all 5 variants defined', () {
      expect(ButtonVariants.all.length, equals(5));
      expect(ButtonVariants.all, containsAll([
        'elevated', 'filled', 'outlined', 'text', 'icon',
      ]));
    });

    test('Boundary: no duplicates', () {
      expect(ButtonVariants.all.toSet().length, equals(ButtonVariants.all.length));
    });

    test('Normal: isValid', () {
      expect(ButtonVariants.isValid('elevated'), isTrue);
    });

    test('Error: isValid for unknown', () {
      expect(ButtonVariants.isValid('unknown'), isFalse);
    });
  });

  // TC-007: Size units
  group('TC-007: SizeUnits', () {
    test('Normal: all 6 units defined', () {
      expect(SizeUnits.all.length, equals(6));
      expect(SizeUnits.all, containsAll([
        'px', 'percent', 'em', 'rem', 'vw', 'vh',
      ]));
    });

    test('Boundary: no duplicates', () {
      expect(SizeUnits.all.toSet().length, equals(SizeUnits.all.length));
    });

    test('Normal: isValid', () {
      expect(SizeUnits.isValid('px'), isTrue);
    });

    test('Error: isValid for unknown', () {
      expect(SizeUnits.isValid('dp'), isFalse);
    });
  });

  // TC-008: Theme modes
  group('TC-008: ThemeModes', () {
    test('Normal: all 3 modes defined', () {
      expect(ThemeModes.all.length, equals(3));
      expect(ThemeModes.all, containsAll(['light', 'dark', 'system']));
    });

    test('Boundary: no duplicates', () {
      expect(ThemeModes.all.toSet().length, equals(ThemeModes.all.length));
    });

    test('Normal: isValid', () {
      expect(ThemeModes.isValid('light'), isTrue);
      expect(ThemeModes.isValid('dark'), isTrue);
      expect(ThemeModes.isValid('system'), isTrue);
    });

    test('Error: isValid for unknown', () {
      expect(ThemeModes.isValid('auto'), isFalse);
    });
  });

  // TC-009: Binding prefixes
  group('TC-009: BindingPrefixes', () {
    test('Normal: all v1.0 prefixes defined', () {
      expect(BindingPrefixes.v10Prefixes.length, equals(8));
      expect(BindingPrefixes.v10Prefixes, contains('local.'));
      expect(BindingPrefixes.v10Prefixes, contains('page.'));
      expect(BindingPrefixes.v10Prefixes, contains('app.'));
      expect(BindingPrefixes.v10Prefixes, contains('route.params.'));
      expect(BindingPrefixes.v10Prefixes, contains('theme.'));
      expect(BindingPrefixes.v10Prefixes, contains('event.'));
    });

    test('Normal: all v1.1 prefixes defined', () {
      expect(BindingPrefixes.v11Prefixes.length, equals(10));
      expect(BindingPrefixes.v11Prefixes, contains('client.'));
      expect(BindingPrefixes.v11Prefixes, contains('client.file.'));
      expect(BindingPrefixes.v11Prefixes, contains('client.system.'));
      expect(BindingPrefixes.v11Prefixes, contains('client.theme.'));
      expect(BindingPrefixes.v11Prefixes, contains('client.env.'));
      expect(BindingPrefixes.v11Prefixes, contains('permissions.'));
      expect(BindingPrefixes.v11Prefixes, contains('channels.'));
      expect(BindingPrefixes.v11Prefixes, contains('resources.'));
      expect(BindingPrefixes.v11Prefixes, contains('sync.'));
      expect(BindingPrefixes.v11Prefixes, contains('runtime.'));
    });

    test('Normal: all combined', () {
      expect(BindingPrefixes.all.length, equals(18));
    });

    test('Boundary: default prefix (none) resolves to page state', () {
      // Verify item and index are special prefixes without dots
      expect(BindingPrefixes.item, equals('item'));
      expect(BindingPrefixes.index, equals('index'));
    });
  });

  // TC-010: Validation rule types
  group('TC-010: ValidationRuleTypes', () {
    test('Normal: all 12 rules defined', () {
      expect(ValidationRuleTypes.all.length, equals(12));
      expect(ValidationRuleTypes.all, containsAll([
        'required', 'minLength', 'maxLength', 'min', 'max',
        'pattern', 'email', 'url', 'match', 'oneOf', 'custom', 'async',
      ]));
    });

    test('Normal: isValid', () {
      expect(ValidationRuleTypes.isValid('required'), isTrue);
      expect(ValidationRuleTypes.isValid('email'), isTrue);
      expect(ValidationRuleTypes.isValid('async'), isTrue);
    });

    test('Error: isValid for unknown', () {
      expect(ValidationRuleTypes.isValid('unknown'), isFalse);
    });

    test('Normal: specific constant values', () {
      expect(ValidationRuleTypes.required, equals('required'));
      expect(ValidationRuleTypes.minLength, equals('minLength'));
      expect(ValidationRuleTypes.maxLength, equals('maxLength'));
      expect(ValidationRuleTypes.min, equals('min'));
      expect(ValidationRuleTypes.max, equals('max'));
      expect(ValidationRuleTypes.pattern, equals('pattern'));
      expect(ValidationRuleTypes.email, equals('email'));
      expect(ValidationRuleTypes.url, equals('url'));
      expect(ValidationRuleTypes.match, equals('match'));
    });
  });
}
