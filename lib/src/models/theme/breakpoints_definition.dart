import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Breakpoints (Material 3 — 5 class).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.10. logical px width thresholds.
@immutable
class BreakpointsDefinition {
  final num? compact;
  final num? medium;
  final num? expanded;
  final num? large;
  final num? extraLarge;
  final Map<String, num>? extras;

  const BreakpointsDefinition({
    this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
    this.extras,
  });

  factory BreakpointsDefinition.fromJson(Map<String, dynamic> json) {
    const known = {'compact', 'medium', 'expanded', 'large', 'extraLarge'};
    final extras = <String, num>{};
    for (final e in json.entries) {
      if (!known.contains(e.key) && e.value is num) {
        extras[e.key] = e.value as num;
      }
    }
    return BreakpointsDefinition(
      compact: json['compact'] as num?,
      medium: json['medium'] as num?,
      expanded: json['expanded'] as num?,
      large: json['large'] as num?,
      extraLarge: json['extraLarge'] as num?,
      extras: extras.isEmpty ? null : extras,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, num? v) {
      if (v != null) m[k] = v;
    }

    put('compact', compact);
    put('medium', medium);
    put('expanded', expanded);
    put('large', large);
    put('extraLarge', extraLarge);
    if (extras != null) m.addAll(extras!);
    return m;
  }

  BreakpointsDefinition copyWith({
    num? compact,
    num? medium,
    num? expanded,
    num? large,
    num? extraLarge,
    Map<String, num>? extras,
  }) =>
      BreakpointsDefinition(
        compact: compact ?? this.compact,
        medium: medium ?? this.medium,
        expanded: expanded ?? this.expanded,
        large: large ?? this.large,
        extraLarge: extraLarge ?? this.extraLarge,
        extras: extras ?? this.extras,
      );
}
