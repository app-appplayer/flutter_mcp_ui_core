import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Spacing (8pt grid · 9 slots + 4 layout primitives).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.5.
@immutable
class SpacingDefinition {
  final num? xxs;
  final num? xs;
  final num? sm;
  final num? md;
  final num? lg;
  final num? xl;
  final num? xxl; // 2xl
  final num? xxxl; // 3xl
  final num? xxxxl; // 4xl

  // Layout primitives
  final num? screenPadding;
  final num? cardPadding;
  final num? sectionGap;
  final num? inlineGap;

  /// Optional extra slots — e.g. `5xl`, `6xl` (spec MAY).
  final Map<String, num>? extras;

  const SpacingDefinition({
    this.xxs,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.xxxl,
    this.xxxxl,
    this.screenPadding,
    this.cardPadding,
    this.sectionGap,
    this.inlineGap,
    this.extras,
  });

  factory SpacingDefinition.fromJson(Map<String, dynamic> json) {
    final extras = <String, num>{};
    const known = {
      'xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl', '4xl',
      'screenPadding', 'cardPadding', 'sectionGap', 'inlineGap',
    };
    for (final entry in json.entries) {
      if (!known.contains(entry.key) && entry.value is num) {
        extras[entry.key] = entry.value as num;
      }
    }
    return SpacingDefinition(
      xxs: json['xxs'] as num?,
      xs: json['xs'] as num?,
      sm: json['sm'] as num?,
      md: json['md'] as num?,
      lg: json['lg'] as num?,
      xl: json['xl'] as num?,
      xxl: json['2xl'] as num?,
      xxxl: json['3xl'] as num?,
      xxxxl: json['4xl'] as num?,
      screenPadding: json['screenPadding'] as num?,
      cardPadding: json['cardPadding'] as num?,
      sectionGap: json['sectionGap'] as num?,
      inlineGap: json['inlineGap'] as num?,
      extras: extras.isEmpty ? null : extras,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, num? v) {
      if (v != null) m[k] = v;
    }

    put('xxs', xxs);
    put('xs', xs);
    put('sm', sm);
    put('md', md);
    put('lg', lg);
    put('xl', xl);
    put('2xl', xxl);
    put('3xl', xxxl);
    put('4xl', xxxxl);
    put('screenPadding', screenPadding);
    put('cardPadding', cardPadding);
    put('sectionGap', sectionGap);
    put('inlineGap', inlineGap);
    if (extras != null) m.addAll(extras!);
    return m;
  }

  SpacingDefinition copyWith({
    num? xxs,
    num? xs,
    num? sm,
    num? md,
    num? lg,
    num? xl,
    num? xxl,
    num? xxxl,
    num? xxxxl,
    num? screenPadding,
    num? cardPadding,
    num? sectionGap,
    num? inlineGap,
    Map<String, num>? extras,
  }) =>
      SpacingDefinition(
        xxs: xxs ?? this.xxs,
        xs: xs ?? this.xs,
        sm: sm ?? this.sm,
        md: md ?? this.md,
        lg: lg ?? this.lg,
        xl: xl ?? this.xl,
        xxl: xxl ?? this.xxl,
        xxxl: xxxl ?? this.xxxl,
        xxxxl: xxxxl ?? this.xxxxl,
        screenPadding: screenPadding ?? this.screenPadding,
        cardPadding: cardPadding ?? this.cardPadding,
        sectionGap: sectionGap ?? this.sectionGap,
        inlineGap: inlineGap ?? this.inlineGap,
        extras: extras ?? this.extras,
      );
}
