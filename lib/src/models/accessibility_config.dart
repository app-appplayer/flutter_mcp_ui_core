import 'package:meta/meta.dart';

/// Accessibility configuration for MCP UI DSL v1.0/v1.1
///
/// Represents accessibility properties for widgets as defined in the spec.
/// Field names follow spec conventions (semanticLabel, semanticHint, liveRegion).
/// fromJson accepts both spec keys and short aliases (label, description, live)
/// for backward compatibility.
@immutable
class AccessibilityConfig {
  /// Semantic role (button, link, heading, etc.)
  final String? role;

  /// Screen reader label (spec: semanticLabel)
  final String? semanticLabel;

  /// Additional description for screen readers (spec: semanticHint)
  final String? semanticHint;

  /// Live region behavior (polite, assertive, off) (spec: liveRegion)
  final String? liveRegion;

  /// Whether to exclude from semantics tree
  final bool? excludeFromSemantics;

  /// Whether the widget is focusable
  final bool? focusable;

  /// Ordered list of widget keys for focus traversal
  final List<String>? focusOrder;

  /// Whether focus should be trapped within this widget
  final bool? focusTrap;

  /// Key of widget to receive initial focus
  final String? initialFocus;

  /// Whether to restore focus when returning to this widget
  final bool? restoreFocus;

  /// Whether this is an atomic live region
  final bool? atomic;

  /// Accessibility properties
  final AccessibilityProperties? properties;

  /// WCAG compliance information
  final WcagCompliance? wcag;

  const AccessibilityConfig({
    this.role,
    this.semanticLabel,
    this.semanticHint,
    this.liveRegion,
    this.excludeFromSemantics,
    this.focusable,
    this.focusOrder,
    this.focusTrap,
    this.initialFocus,
    this.restoreFocus,
    this.atomic,
    this.properties,
    this.wcag,
  });

  /// Create from JSON
  /// Supports both spec keys (semanticLabel, semanticHint, liveRegion)
  /// and short aliases (label, description, live) for backward compatibility
  factory AccessibilityConfig.fromJson(Map<String, dynamic> json) {
    // Parse focusOrder: accept both List<String> (spec) and int (legacy)
    List<String>? focusOrder;
    final rawFocusOrder = json['focusOrder'];
    if (rawFocusOrder is List) {
      focusOrder = rawFocusOrder.cast<String>();
    } else if (rawFocusOrder is int) {
      focusOrder = [rawFocusOrder.toString()];
    }

    // Parse initialFocus: accept both String (spec) and bool (legacy)
    String? initialFocus;
    final rawInitialFocus = json['initialFocus'];
    if (rawInitialFocus is String) {
      initialFocus = rawInitialFocus;
    } else if (rawInitialFocus is bool && rawInitialFocus) {
      initialFocus = '_self';
    }

    return AccessibilityConfig(
      role: json['role'] as String?,
      semanticLabel: (json['semanticLabel'] ?? json['label']) as String?,
      semanticHint: (json['semanticHint'] ?? json['description']) as String?,
      liveRegion: (json['liveRegion'] ?? json['live']) as String?,
      excludeFromSemantics: json['excludeFromSemantics'] as bool?,
      focusable: json['focusable'] as bool?,
      focusOrder: focusOrder,
      focusTrap: json['focusTrap'] as bool?,
      initialFocus: initialFocus,
      restoreFocus: json['restoreFocus'] as bool?,
      atomic: json['atomic'] as bool?,
      properties: json['properties'] != null
          ? AccessibilityProperties.fromJson(json['properties'] as Map<String, dynamic>)
          : null,
      wcag: json['wcag'] != null
          ? WcagCompliance.fromJson(json['wcag'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON using spec-canonical field names
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    if (role != null) result['role'] = role;
    if (semanticLabel != null) result['semanticLabel'] = semanticLabel;
    if (semanticHint != null) result['semanticHint'] = semanticHint;
    if (liveRegion != null) result['liveRegion'] = liveRegion;
    if (excludeFromSemantics != null) result['excludeFromSemantics'] = excludeFromSemantics;
    if (focusable != null) result['focusable'] = focusable;
    if (focusOrder != null) result['focusOrder'] = focusOrder;
    if (focusTrap != null) result['focusTrap'] = focusTrap;
    if (initialFocus != null) result['initialFocus'] = initialFocus;
    if (restoreFocus != null) result['restoreFocus'] = restoreFocus;
    if (atomic != null) result['atomic'] = atomic;
    if (properties != null) result['properties'] = properties!.toJson();
    if (wcag != null) result['wcag'] = wcag!.toJson();

    return result;
  }

  /// Create a copy with modified values
  AccessibilityConfig copyWith({
    String? role,
    String? semanticLabel,
    String? semanticHint,
    String? liveRegion,
    bool? excludeFromSemantics,
    bool? focusable,
    List<String>? focusOrder,
    bool? focusTrap,
    String? initialFocus,
    bool? restoreFocus,
    bool? atomic,
    AccessibilityProperties? properties,
    WcagCompliance? wcag,
  }) {
    return AccessibilityConfig(
      role: role ?? this.role,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      semanticHint: semanticHint ?? this.semanticHint,
      liveRegion: liveRegion ?? this.liveRegion,
      excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
      focusable: focusable ?? this.focusable,
      focusOrder: focusOrder ?? this.focusOrder,
      focusTrap: focusTrap ?? this.focusTrap,
      initialFocus: initialFocus ?? this.initialFocus,
      restoreFocus: restoreFocus ?? this.restoreFocus,
      atomic: atomic ?? this.atomic,
      properties: properties ?? this.properties,
      wcag: wcag ?? this.wcag,
    );
  }

  /// Check if this configuration has any accessibility settings
  bool get hasAccessibilitySettings =>
      role != null ||
      semanticLabel != null ||
      semanticHint != null ||
      liveRegion != null ||
      excludeFromSemantics != null ||
      focusable != null ||
      focusOrder != null ||
      focusTrap != null ||
      initialFocus != null ||
      restoreFocus != null ||
      atomic != null ||
      properties != null ||
      wcag != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityConfig &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          semanticLabel == other.semanticLabel &&
          semanticHint == other.semanticHint &&
          liveRegion == other.liveRegion &&
          excludeFromSemantics == other.excludeFromSemantics &&
          focusable == other.focusable &&
          _listEquals(focusOrder, other.focusOrder) &&
          focusTrap == other.focusTrap &&
          initialFocus == other.initialFocus &&
          restoreFocus == other.restoreFocus &&
          atomic == other.atomic &&
          properties == other.properties &&
          wcag == other.wcag;

  @override
  int get hashCode =>
      role.hashCode ^
      semanticLabel.hashCode ^
      semanticHint.hashCode ^
      liveRegion.hashCode ^
      excludeFromSemantics.hashCode ^
      focusable.hashCode ^
      focusOrder.hashCode ^
      focusTrap.hashCode ^
      initialFocus.hashCode ^
      restoreFocus.hashCode ^
      atomic.hashCode ^
      properties.hashCode ^
      wcag.hashCode;

  @override
  String toString() {
    return 'AccessibilityConfig(role: $role, semanticLabel: $semanticLabel, liveRegion: $liveRegion)';
  }

  bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Accessibility properties as defined in spec v1.0
@immutable
class AccessibilityProperties {
  final int? level;
  final bool? expanded;
  final bool? selected;
  final bool? disabled;
  final bool? readonly;
  final bool? required;
  final bool? checked;
  final bool? pressed;
  final num? valueMin;
  final num? valueMax;
  final num? valueNow;
  final String? valueText;
  final bool? multiSelectable;
  final String? orientation;
  final String? sort;
  final String? autoComplete;
  final bool? hasPopup;
  final String? invalid;
  final bool? hidden;
  final bool? busy;

  const AccessibilityProperties({
    this.level,
    this.expanded,
    this.selected,
    this.disabled,
    this.readonly,
    this.required,
    this.checked,
    this.pressed,
    this.valueMin,
    this.valueMax,
    this.valueNow,
    this.valueText,
    this.multiSelectable,
    this.orientation,
    this.sort,
    this.autoComplete,
    this.hasPopup,
    this.invalid,
    this.hidden,
    this.busy,
  });

  /// Create from JSON
  factory AccessibilityProperties.fromJson(Map<String, dynamic> json) {
    return AccessibilityProperties(
      level: json['level'] as int?,
      expanded: json['expanded'] as bool?,
      selected: json['selected'] as bool?,
      disabled: json['disabled'] as bool?,
      readonly: json['readonly'] as bool?,
      required: json['required'] as bool?,
      checked: json['checked'] as bool?,
      pressed: json['pressed'] as bool?,
      valueMin: json['valueMin'] as num?,
      valueMax: json['valueMax'] as num?,
      valueNow: json['valueNow'] as num?,
      valueText: json['valueText'] as String?,
      multiSelectable: json['multiSelectable'] as bool?,
      orientation: json['orientation'] as String?,
      sort: json['sort'] as String?,
      autoComplete: json['autoComplete'] as String?,
      hasPopup: json['hasPopup'] as bool?,
      invalid: json['invalid'] as String?,
      hidden: json['hidden'] as bool?,
      busy: json['busy'] as bool?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    if (level != null) result['level'] = level;
    if (expanded != null) result['expanded'] = expanded;
    if (selected != null) result['selected'] = selected;
    if (disabled != null) result['disabled'] = disabled;
    if (readonly != null) result['readonly'] = readonly;
    if (required != null) result['required'] = required;
    if (checked != null) result['checked'] = checked;
    if (pressed != null) result['pressed'] = pressed;
    if (valueMin != null) result['valueMin'] = valueMin;
    if (valueMax != null) result['valueMax'] = valueMax;
    if (valueNow != null) result['valueNow'] = valueNow;
    if (valueText != null) result['valueText'] = valueText;
    if (multiSelectable != null) result['multiSelectable'] = multiSelectable;
    if (orientation != null) result['orientation'] = orientation;
    if (sort != null) result['sort'] = sort;
    if (autoComplete != null) result['autoComplete'] = autoComplete;
    if (hasPopup != null) result['hasPopup'] = hasPopup;
    if (invalid != null) result['invalid'] = invalid;
    if (hidden != null) result['hidden'] = hidden;
    if (busy != null) result['busy'] = busy;

    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityProperties &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          expanded == other.expanded &&
          selected == other.selected &&
          disabled == other.disabled &&
          readonly == other.readonly &&
          required == other.required &&
          checked == other.checked &&
          pressed == other.pressed &&
          valueMin == other.valueMin &&
          valueMax == other.valueMax &&
          valueNow == other.valueNow &&
          valueText == other.valueText &&
          multiSelectable == other.multiSelectable &&
          orientation == other.orientation &&
          sort == other.sort &&
          autoComplete == other.autoComplete &&
          hasPopup == other.hasPopup &&
          invalid == other.invalid &&
          hidden == other.hidden &&
          busy == other.busy;

  @override
  int get hashCode =>
      level.hashCode ^
      expanded.hashCode ^
      selected.hashCode ^
      disabled.hashCode ^
      readonly.hashCode ^
      required.hashCode ^
      checked.hashCode ^
      pressed.hashCode ^
      valueMin.hashCode ^
      valueMax.hashCode ^
      valueNow.hashCode ^
      valueText.hashCode ^
      multiSelectable.hashCode ^
      orientation.hashCode ^
      sort.hashCode ^
      autoComplete.hashCode ^
      hasPopup.hashCode ^
      invalid.hashCode ^
      hidden.hashCode ^
      busy.hashCode;
}

/// WCAG compliance information
@immutable
class WcagCompliance {
  /// Compliance level (A, AA, AAA)
  final String level;

  /// Applicable WCAG guidelines
  final List<String> guidelines;

  const WcagCompliance({
    required this.level,
    this.guidelines = const [],
  });

  /// Create from JSON
  factory WcagCompliance.fromJson(Map<String, dynamic> json) {
    return WcagCompliance(
      level: json['level'] as String,
      guidelines: (json['guidelines'] as List?)?.cast<String>() ?? [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'guidelines': guidelines,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WcagCompliance &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          _listEquals(guidelines, other.guidelines);

  @override
  int get hashCode => level.hashCode ^ guidelines.hashCode;

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
