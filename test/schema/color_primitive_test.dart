// The `Color` primitive accepts exactly the spellings the runtime resolves.
//
// This exists because a case-insensitive branch was first written with an
// inline `(?i:...)` flag. JSON Schema regexes are ECMA-262, which has no such
// flag: rather than matching case-insensitively, the pattern is not a valid
// regex, and the branch stopped constraining anything — every string passed,
// including colors the runtime has never heard of. A document could name
// `tomato`, validate, and then draw nothing.
//
// Any change to the primitive has to keep both halves true: everything the
// runtime's `parseColor` resolves is accepted, and everything else is not.

import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:test/test.dart';

/// Wraps a color value in the smallest widget that carries one.
Map<String, dynamic> _withColor(Object? value) => <String, dynamic>{
      'type': 'icon',
      'icon': 'home',
      'color': value,
    };

void main() {
  group('Color primitive', () {
    test('accepts every Material 3 scheme slot', () {
      // §5.3. These are the only spelling that follows light / dark mode, so
      // rejecting them would push authors to hard-coded hex.
      const slots = <String>[
        'primary', 'onPrimary', 'primaryContainer', 'onPrimaryContainer',
        'secondary', 'onSecondary', 'tertiary', 'error', 'onError',
        'surface', 'onSurface', 'onSurfaceVariant', 'surfaceTint',
        'surfaceContainerHighest', 'outline', 'outlineVariant',
        'inverseSurface', 'inversePrimary', 'scrim', 'shadow',
        'success', 'onSuccess', 'warning', 'onWarning', 'info', 'onInfo',
      ];
      for (final slot in slots) {
        expect(validateMcpUiDslWidget(_withColor(slot)).isValid, isTrue,
            reason: 'scheme slot "$slot" must validate');
      }
    });

    test('accepts the legacy spellings §5.3.1 keeps', () {
      // Material 3 folded the background family into surface and retired
      // `surfaceVariant`; `inverseOnSurface` is the earlier spelling of
      // `onInverseSurface`. All four are documented in §5.3.1 and resolved by
      // `ThemeManager`, so rejecting them would make the schema disagree with
      // both the prose and the runtime.
      for (final slot in const ['background', 'onBackground', 'surfaceVariant',
        'inverseOnSurface']) {
        expect(validateMcpUiDslWidget(_withColor(slot)).isValid, isTrue,
            reason: 'legacy slot "$slot" must validate');
      }
    });

    test('accepts the three hex lengths, in any case', () {
      for (final hex in const ['#fff', '#FFF', '#ff0000', '#FF0000',
        '#80ff0000', '#80FF0000']) {
        expect(validateMcpUiDslWidget(_withColor(hex)).isValid, isTrue,
            reason: '$hex must validate');
      }
    });

    test('rejects malformed hex', () {
      for (final hex in const ['#', '#ff', '#fffff', '#gggggg', 'ff0000']) {
        expect(validateMcpUiDslWidget(_withColor(hex)).isValid, isFalse,
            reason: '$hex must not validate');
      }
    });

    test('accepts the ten basic names the runtime resolves, in any case', () {
      const names = <String>['red', 'blue', 'green', 'yellow', 'orange',
        'purple', 'black', 'white', 'grey', 'gray'];
      for (final name in names) {
        for (final spelling in <String>[
          name,
          name.toUpperCase(),
          name[0].toUpperCase() + name.substring(1),
        ]) {
          expect(validateMcpUiDslWidget(_withColor(spelling)).isValid, isTrue,
              reason: '"$spelling" must validate');
        }
      }
    });

    test('rejects a colour name the runtime cannot resolve', () {
      // The regression: `parseColor` has no CSS table beyond the ten basic
      // names, so accepting these would validate a document that draws
      // nothing. `tomato` is the one that reached a browser.
      for (final name in const ['tomato', 'rebeccapurple', 'chartreuse',
        'notacolor', '']) {
        expect(validateMcpUiDslWidget(_withColor(name)).isValid, isFalse,
            reason: '"$name" must not validate — the runtime cannot resolve it');
      }
    });

    test('accepts a binding in the colour position', () {
      expect(validateMcpUiDslWidget(_withColor('{{theme.accent}}')).isValid,
          isTrue);
    });
  });
}
