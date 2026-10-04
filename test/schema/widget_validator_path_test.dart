// Every validation error carries a JSON pointer rooted at `#`.
//
// json_schema types `ValidationError.instancePath` as nullable before 5.2.1
// and non-null from 5.2.1, and the package allows both. Run against either,
// a failed widget must report a pointer — never a crash, never `#null`.

import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:test/test.dart';

void main() {
  test('a valid widget reports no errors', () {
    expect(
      validateMcpUiDslWidget({'type': 'text', 'content': 'x'}).errors,
      isEmpty,
    );
  });

  for (final widget in <Map<String, dynamic>>[
    {'type': 'nope'},
    {'type': 'icon', 'icon': 'home', 'color': 5},
    {'type': 'text', 'content': 'x', 'maxLines': 'two'},
    {
      'type': 'linear',
      'children': [
        {'type': 'text', 'content': 3},
      ],
    },
  ]) {
    test('errors in $widget point into the document', () {
      final errors = validateMcpUiDslWidget(widget).errors;
      expect(errors, isNotEmpty);
      for (final e in errors) {
        expect(e.path, startsWith('#'));
        expect(e.path, isNot(contains('null')));
        expect(e.message, isNotEmpty);
      }
    });
  }
}
