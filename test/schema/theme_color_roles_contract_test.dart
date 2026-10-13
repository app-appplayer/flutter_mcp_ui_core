// Every colour role §5.3.1 lists is one a theme document may declare.
//
// §5.3.1 says each role derives from `seed` "when the bundle does not declare
// it" — so each must be declarable. The theme schema's `Color` is closed
// (`additionalProperties: false`), and it once lacked the M3 surface
// containers, `surfaceBright` / `surfaceDim` and `onInverseSurface`: a theme
// that set them was rejected while the runtime would have painted them.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_mcp_ui_core/src/schema/theme_schema.g.dart';
import 'package:flutter_test/flutter_test.dart';

String _repoRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 12; i++) {
    if (Directory('${dir.path}/specs/mcp_ui_dsl').existsSync()) return dir.path;
    if (dir.parent.path == dir.path) break;
    dir = dir.parent;
  }
  throw StateError('specs/mcp_ui_dsl not found above ${Directory.current}');
}

void main() {
  test('the theme Color config accepts every §5.3.1 role', () {
    final md = File('${_repoRoot()}/specs/mcp_ui_dsl/spec/1.4/05_Theme.md')
        .readAsStringSync();
    final section =
        md.substring(md.indexOf('### 5.3.1'), md.indexOf('### 5.3.2'));
    final roles = [
      for (final m
          in RegExp(r'^\| `(\w+)` \|', multiLine: true).allMatches(section))
        m.group(1)!,
    ];
    expect(roles.length, greaterThan(40));

    final schema =
        jsonDecode(mcpUiDslThemeSchemaJson) as Map<String, dynamic>;
    final color = (schema[r'$defs'] as Map)['Color'] as Map;
    expect(color['additionalProperties'], isFalse,
        reason: 'the check below only matters for a closed object');
    final declarable = (color['properties'] as Map).keys.toSet();
    final missing = [for (final r in roles) if (!declarable.contains(r)) r];
    expect(missing, isEmpty,
        reason: 'roles §5.3.1 lists that a theme cannot declare: $missing');
  });
}
