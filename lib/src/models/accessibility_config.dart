import 'package:meta/meta.dart';

/// Accessibility configuration for MCP UI DSL v1.0
/// 
/// Represents accessibility properties for widgets as defined in the spec.
@immutable
class AccessibilityConfig {
  /// Semantic role (button, link, heading, etc.)
  final String? role;
  
  /// Screen reader label
  final String? label;
  
  /// Additional description for screen readers
  final String? description;
  
  /// Live region behavior (polite, assertive, off)
  final String? live;
  
  /// Accessibility properties
  final AccessibilityProperties? properties;
  
  /// WCAG compliance information
  final WcagCompliance? wcag;

  const AccessibilityConfig({
    this.role,
    this.label,
    this.description,
    this.live,
    this.properties,
    this.wcag,
  });

  /// Create from JSON
  factory AccessibilityConfig.fromJson(Map<String, dynamic> json) {
    return AccessibilityConfig(
      role: json['role'] as String?,
      label: json['label'] as String?,
      description: json['description'] as String?,
      live: json['live'] as String?,
      properties: json['properties'] != null
          ? AccessibilityProperties.fromJson(json['properties'] as Map<String, dynamic>)
          : null,
      wcag: json['wcag'] != null
          ? WcagCompliance.fromJson(json['wcag'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    
    if (role != null) result['role'] = role;
    if (label != null) result['label'] = label;
    if (description != null) result['description'] = description;
    if (live != null) result['live'] = live;
    if (properties != null) result['properties'] = properties!.toJson();
    if (wcag != null) result['wcag'] = wcag!.toJson();
    
    return result;
  }

  /// Create a copy with modified values
  AccessibilityConfig copyWith({
    String? role,
    String? label,
    String? description,
    String? live,
    AccessibilityProperties? properties,
    WcagCompliance? wcag,
  }) {
    return AccessibilityConfig(
      role: role ?? this.role,
      label: label ?? this.label,
      description: description ?? this.description,
      live: live ?? this.live,
      properties: properties ?? this.properties,
      wcag: wcag ?? this.wcag,
    );
  }

  /// Check if this configuration has any accessibility settings
  bool get hasAccessibilitySettings =>
      role != null ||
      label != null ||
      description != null ||
      live != null ||
      properties != null ||
      wcag != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityConfig &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          label == other.label &&
          description == other.description &&
          live == other.live &&
          properties == other.properties &&
          wcag == other.wcag;

  @override
  int get hashCode =>
      role.hashCode ^
      label.hashCode ^
      description.hashCode ^
      live.hashCode ^
      properties.hashCode ^
      wcag.hashCode;

  @override
  String toString() {
    return 'AccessibilityConfig(role: $role, label: $label, live: $live)';
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