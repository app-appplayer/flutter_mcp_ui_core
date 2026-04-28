import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Component tokens (button · input · card · dialog · menu · list ...).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.12. Per-component free-form token bundle —
/// runtimes recognize 6 standard components; the rest are application-specific.
@immutable
class ComponentTokensDefinition {
  /// Component name → free-form token map.
  final Map<String, Map<String, dynamic>> components;

  const ComponentTokensDefinition(this.components);

  factory ComponentTokensDefinition.fromJson(Map<String, dynamic> json) {
    final m = <String, Map<String, dynamic>>{};
    for (final e in json.entries) {
      if (e.value is Map<String, dynamic>) {
        m[e.key] = Map<String, dynamic>.from(e.value as Map);
      }
    }
    return ComponentTokensDefinition(m);
  }

  Map<String, dynamic> toJson() => {...components};

  Map<String, dynamic>? operator [](String component) => components[component];

  /// Six standard component names — runtimes SHOULD recognize.
  static const List<String> standardComponents = <String>[
    'button',
    'input',
    'card',
    'dialog',
    'menu',
    'list',
  ];

  ComponentTokensDefinition copyWith({
    Map<String, Map<String, dynamic>>? components,
  }) =>
      ComponentTokensDefinition(components ?? this.components);
}
