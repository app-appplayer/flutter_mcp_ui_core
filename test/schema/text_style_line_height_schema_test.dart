import 'dart:convert';

import 'package:flutter_mcp_ui_core/src/schema/app_schema.g.dart';
import 'package:flutter_mcp_ui_core/src/schema/page_schema.g.dart';
import 'package:flutter_mcp_ui_core/src/schema/theme_schema.g.dart';
import 'package:flutter_mcp_ui_core/src/schema/widgets_schema.g.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every generated schema carries the same `TextStyle`: `lineHeight` is the
/// canonical line height and `height` its deprecated alias (spec 1.4 §5.4.2,
/// §17.3.2). A regeneration that loses either shows up here.
void main() {
  final schemas = {
    'app': mcpUiDslAppSchemaJson,
    'page': mcpUiDslPageSchemaJson,
    'theme': mcpUiDslThemeSchemaJson,
    'widgets': mcpUiDslWidgetsSchemaJson,
  };

  schemas.forEach((name, json) {
    test('$name schema: TextStyle has lineHeight and a deprecated height', () {
      final defs = (jsonDecode(json) as Map<String, dynamic>)[r'$defs']
          as Map<String, dynamic>;
      final textStyle = defs['TextStyle'] as Map<String, dynamic>;
      final objectForm = (textStyle['oneOf'] as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((b) => b['type'] == 'object');
      final props = objectForm['properties'] as Map<String, dynamic>;

      expect(props, contains('lineHeight'));
      expect((props['lineHeight'] as Map)['deprecated'], isNot(true));
      expect((props['height'] as Map)['deprecated'], isTrue);
    });
  });
}
