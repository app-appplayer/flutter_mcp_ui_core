import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Opacity scale (M3 standard 11-step).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.11.2. Keys are free-form — the standard set is 0/4/8/12/16/24/38/50/64/87/100.
@immutable
class OpacityDefinition {
  final Map<String, num> values;

  const OpacityDefinition(this.values);

  factory OpacityDefinition.fromJson(Map<String, dynamic> json) {
    final m = <String, num>{};
    for (final e in json.entries) {
      if (e.value is num) m[e.key] = e.value as num;
    }
    return OpacityDefinition(m);
  }

  Map<String, dynamic> toJson() => {...values};

  num? operator [](String key) => values[key];

  OpacityDefinition copyWith({Map<String, num>? values}) =>
      OpacityDefinition(values ?? this.values);
}
