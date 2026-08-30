import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // TC-001: Widget type constants completeness
  group('TC-001: WidgetTypes', () {
    // Counted against the registry rather than against a number written here.
    // The magic numbers this replaced were satisfied by any 29 layout widgets,
    // so 37 canonical types could go missing from `WidgetTypes` — and did —
    // while the test stayed green. `isValidType` is built from this map and is
    // public API: a type absent here is a valid document the core validators
    // reject.
    test('Normal: every canonical widget type is categorised', () {
      final declared = _registryWidgetTypes();
      expect(declared.length, greaterThanOrEqualTo(158),
          reason: 'registry not found or unexpectedly small');

      final categorised = <String>{
        for (final types in WidgetTypes.categories.values) ...types,
      };
      expect(declared.difference(categorised), isEmpty,
          reason: 'canonical types missing from WidgetTypes.categories');
      for (final type in declared) {
        expect(WidgetTypes.isValidType(type), isTrue,
            reason: '`$type` is in the registry and the validators reject it');
      }
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
    test('Normal: the Core Profile action types are all declared', () {
      // §17.2.2's Core list, read from the spec instead of counted here.
      // Compared against every declared constant rather than `coreTypes`
      // alone: this class groups by the version a type arrived in, the spec
      // groups by profile, and `animation` / `cancel` are Core-profile types
      // that arrived in v1.1.
      final declared = <String>{
        ...ActionTypes.coreTypes,
        ...ActionTypes.v11Types,
        ...ActionTypes.v14Types,
        ...ActionTypes.paymentTypes,
      };
      for (final type in _coreProfileActionTypes()) {
        expect(declared, contains(type),
            reason: '§17.2.2 lists `$type` as Core and it has no constant');
      }
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
      expect(
        all.length,
        equals(ActionTypes.coreTypes.length +
            ActionTypes.v11Types.length +
            ActionTypes.v14Types.length +
            ActionTypes.paymentTypes.length +
            ActionTypes.locationTypes.length),
      );
    });

    test('Normal: v1.4 identity types are registered (§8.9.3)', () {
      expect(ActionTypes.v14Types, contains('identity.promote'));
      expect(ActionTypes.v14Types, contains('identity.release'));
      expect(ActionTypes.isValid('identity.promote'), isTrue);
      expect(ActionTypes.isIdentityAction('identity.release'), isTrue);
      expect(ActionTypes.isIdentityAction('state'), isFalse);
    });

    test('Normal: location is declared and valid (§4.25, Location Profile)',
        () {
      // Same reason as payment: its own Profile, not implied by Core, and
      // still in `all` — a validator built from this class must not reject a
      // conformant document.
      expect(ActionTypes.locationTypes, contains('location'));
      expect(ActionTypes.all, contains('location'));
      expect(ActionTypes.isValid('location'), isTrue);
      // Not a dotted family: there is one question, so there is one name.
      expect(ActionTypes.isClientAction('location'), isFalse);
    });

    test('Normal: payment is declared and valid (§4.24, Payment Profile)', () {
      // Its own list because the Payment Profile is not implied by Core; it
      // still has to be in `all`, or a validator built from this class
      // rejects a conformant document.
      expect(ActionTypes.paymentTypes, contains('payment'));
      expect(ActionTypes.all, contains('payment'));
      expect(ActionTypes.isValid('payment'), isTrue);
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


/// Canonical widget types declared by the spec registry.
Set<String> _registryWidgetTypes() {
  final dir = Directory(
      '${_repoRoot()}/specs/mcp_ui_dsl/spec/1.4/widgets');
  final out = <String>{};
  if (!dir.existsSync()) return out;
  for (final f in dir.listSync(recursive: true).whereType<File>()) {
    if (!f.path.endsWith('.yaml')) continue;
    final m = RegExp(r'^type:\s*(\S+)', multiLine: true)
        .firstMatch(f.readAsStringSync());
    if (m != null) out.add(m.group(1)!);
  }
  return out;
}

/// The Core Profile action types listed in §17.2.2.
List<String> _coreProfileActionTypes() {
  final f = File('${_repoRoot()}/specs/mcp_ui_dsl/spec/1.4/17_Naming.md');
  if (!f.existsSync()) return const [];
  final section = f
      .readAsStringSync()
      .split('### 17.2.2 Action Types')[1]
      .split('#### Client Profile')[0];
  return RegExp(r'`([a-zA-Z][\w.]*)`')
      .allMatches(section)
      .map((m) => m.group(1)!)
      .where((t) => !t.endsWith('.md'))
      .toList();
}

String _repoRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 12; i++) {
    if (Directory('${dir.path}/specs/mcp_ui_dsl').existsSync()) return dir.path;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  throw StateError('repo root not found from ${Directory.current.path}');
}
