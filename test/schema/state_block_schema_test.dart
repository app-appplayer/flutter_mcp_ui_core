import 'dart:convert';

import 'package:flutter_mcp_ui_core/src/schema/app_schema.g.dart';
import 'package:flutter_mcp_ui_core/src/schema/page_schema.g.dart';
import 'package:flutter_test/flutter_test.dart';

/// Spec 03 §3.8 and §3.9 describe `state.computed` and `state.watchers`, and
/// the runtime executes both. The closed `StateBlock` rejected them, so a
/// document using either failed validation.
void main() {
  final schemas = {
    'app': mcpUiDslAppSchemaJson,
    'page': mcpUiDslPageSchemaJson,
  };

  schemas.forEach((name, json) {
    group('$name schema StateBlock', () {
      late Map<String, dynamic> block;
      late Map<String, dynamic> props;

      setUp(() {
        final defs = (jsonDecode(json) as Map<String, dynamic>)[r'$defs']
            as Map<String, dynamic>;
        block = defs['StateBlock'] as Map<String, dynamic>;
        props = block['properties'] as Map<String, dynamic>;
      });

      test('keeps `initial` and the block stays closed', () {
        expect(props, contains('initial'));
        expect(block['additionalProperties'], isFalse);
      });

      test('accepts `computed` as name to expression string', () {
        final computed = props['computed'] as Map<String, dynamic>;
        expect(computed['type'], 'object');
        expect((computed['additionalProperties'] as Map)['type'], 'string');
      });

      test('accepts `watchers` with watch, condition and actions', () {
        final watchers = props['watchers'] as Map<String, dynamic>;
        expect(watchers['type'], 'array');
        final item = watchers['items'] as Map<String, dynamic>;
        expect((item['properties'] as Map).keys,
            containsAll(['watch', 'condition', 'actions']));
        expect(item['required'], containsAll(['watch', 'actions']));
      });
    });
  });
}
