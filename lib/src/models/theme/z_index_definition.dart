import 'package:meta/meta.dart';

/// MCP UI DSL 1.3 — Z-index (9 standard layers).
///
/// `specs/mcp_ui_dsl/05_Theme.md` § 5.11.4.
@immutable
class ZIndexDefinition {
  final int? base;
  final int? dropdown;
  final int? sticky;
  final int? overlay;
  final int? modal;
  final int? popover;
  final int? tooltip;
  final int? toast;
  final int? system;
  final Map<String, int>? extras;

  const ZIndexDefinition({
    this.base,
    this.dropdown,
    this.sticky,
    this.overlay,
    this.modal,
    this.popover,
    this.tooltip,
    this.toast,
    this.system,
    this.extras,
  });

  factory ZIndexDefinition.fromJson(Map<String, dynamic> json) {
    const known = {
      'base',
      'dropdown',
      'sticky',
      'overlay',
      'modal',
      'popover',
      'tooltip',
      'toast',
      'system',
    };
    final extras = <String, int>{};
    for (final e in json.entries) {
      if (!known.contains(e.key) && e.value is num) {
        extras[e.key] = (e.value as num).toInt();
      }
    }
    return ZIndexDefinition(
      base: (json['base'] as num?)?.toInt(),
      dropdown: (json['dropdown'] as num?)?.toInt(),
      sticky: (json['sticky'] as num?)?.toInt(),
      overlay: (json['overlay'] as num?)?.toInt(),
      modal: (json['modal'] as num?)?.toInt(),
      popover: (json['popover'] as num?)?.toInt(),
      tooltip: (json['tooltip'] as num?)?.toInt(),
      toast: (json['toast'] as num?)?.toInt(),
      system: (json['system'] as num?)?.toInt(),
      extras: extras.isEmpty ? null : extras,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    void put(String k, int? v) {
      if (v != null) m[k] = v;
    }

    put('base', base);
    put('dropdown', dropdown);
    put('sticky', sticky);
    put('overlay', overlay);
    put('modal', modal);
    put('popover', popover);
    put('tooltip', tooltip);
    put('toast', toast);
    put('system', system);
    if (extras != null) m.addAll(extras!);
    return m;
  }
}
