import 'package:meta/meta.dart';

import 'accessibility_config.dart';
import 'i18n_config.dart';
import 'widget_config.dart';

/// Strongly-typed widget definition for MCP UI DSL v1.0
///
/// Provides explicit typed fields for common widget properties that
/// [WidgetConfig] stores in an untyped properties map.
@immutable
class WidgetDefinition {
  /// The widget type (e.g., 'container', 'text', 'button')
  final String type;

  /// Whether the widget is visible (explicit boolean)
  final bool? visible;

  /// Binding expression for visibility (e.g., "{{showItem}}")
  final String? visibleExpression;

  /// Unique key for the widget
  final String? key;

  /// Test identifier key for automated testing
  final String? testKey;

  /// Widget properties as key-value pairs
  final Map<String, dynamic> properties;

  /// Child widgets (if applicable)
  final List<WidgetDefinition>? children;

  /// Single child widget (convenience for single-child layouts)
  final WidgetDefinition? child;

  /// Accessibility configuration
  final AccessibilityConfig? accessibility;

  /// Internationalization configuration
  final I18nConfig? i18n;

  /// Metadata for the widget
  final Map<String, dynamic> metadata;

  const WidgetDefinition({
    required this.type,
    this.visible,
    this.visibleExpression,
    this.key,
    this.testKey,
    this.properties = const {},
    this.children,
    this.child,
    this.accessibility,
    this.i18n,
    this.metadata = const {},
  });

  /// Create a WidgetDefinition from JSON
  factory WidgetDefinition.fromJson(Map<String, dynamic> json) {
    // Parse visible: can be bool or binding expression string
    bool? visible;
    String? visibleExpression;
    final rawVisible = json['visible'];
    if (rawVisible is bool) {
      visible = rawVisible;
    } else if (rawVisible is String) {
      visibleExpression = rawVisible;
    }

    // Parse children recursively
    final rawChildren = json['children'] as List?;
    final children = rawChildren
        ?.map((child) =>
            WidgetDefinition.fromJson(child as Map<String, dynamic>))
        .toList();

    // Parse single child
    final rawChild = json['child'];
    final child = rawChild != null
        ? WidgetDefinition.fromJson(rawChild as Map<String, dynamic>)
        : null;

    // Parse accessibility
    final accessibility = json['accessibility'] != null
        ? AccessibilityConfig.fromJson(
            json['accessibility'] as Map<String, dynamic>)
        : null;

    // Parse i18n
    final i18n = json['i18n'] != null
        ? I18nConfig.fromJson(json['i18n'] as Map<String, dynamic>)
        : null;

    // Parse metadata
    final metadata = Map<String, dynamic>.from(json['metadata'] ?? {});

    // Known structural keys that are NOT properties
    const structuralKeys = {
      'type',
      'visible',
      'key',
      'testKey',
      'children',
      'child',
      'accessibility',
      'i18n',
      'metadata',
    };

    // All other fields become properties
    final properties = <String, dynamic>{};
    for (final entry in json.entries) {
      if (!structuralKeys.contains(entry.key)) {
        properties[entry.key] = entry.value;
      }
    }

    // For backward compatibility, merge nested 'properties' field
    if (json.containsKey('properties') && json['properties'] is Map) {
      properties
          .addAll(Map<String, dynamic>.from(json['properties'] as Map));
    }

    return WidgetDefinition(
      type: json['type'] as String,
      visible: visible,
      visibleExpression: visibleExpression,
      key: json['key'] as String?,
      testKey: json['testKey'] as String?,
      properties: properties,
      children: children,
      child: child,
      accessibility: accessibility,
      i18n: i18n,
      metadata: metadata,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'type': type,
    };

    // Serialize visible as expression string or bool
    if (visibleExpression != null) {
      result['visible'] = visibleExpression;
    } else if (visible != null) {
      result['visible'] = visible;
    }

    if (key != null) {
      result['key'] = key;
    }

    if (testKey != null) {
      result['testKey'] = testKey;
    }

    // Spread properties at the top level
    result.addAll(properties);

    if (children != null && children!.isNotEmpty) {
      result['children'] =
          children!.map((child) => child.toJson()).toList();
    }

    if (child != null) {
      result['child'] = child!.toJson();
    }

    if (accessibility != null) {
      result['accessibility'] = accessibility!.toJson();
    }

    if (i18n != null) {
      result['i18n'] = i18n!.toJson();
    }

    if (metadata.isNotEmpty) {
      result['metadata'] = metadata;
    }

    return result;
  }

  /// Convert to legacy [WidgetConfig]
  WidgetConfig toConfig() {
    // Merge visible, key, testKey into the properties map
    final mergedProperties = Map<String, dynamic>.from(properties);
    if (visible != null) {
      mergedProperties['visible'] = visible;
    }
    if (visibleExpression != null) {
      mergedProperties['visible'] = visibleExpression;
    }
    if (key != null) {
      mergedProperties['key'] = key;
    }
    if (testKey != null) {
      mergedProperties['testKey'] = testKey;
    }

    // Merge child into the front of the children list
    final mergedChildren = <WidgetConfig>[];
    if (child != null) {
      mergedChildren.add(child!.toConfig());
    }
    if (children != null) {
      mergedChildren.addAll(children!.map((c) => c.toConfig()));
    }

    return WidgetConfig(
      type: type,
      properties: mergedProperties,
      children: mergedChildren,
      metadata: metadata,
      accessibility: accessibility,
      i18n: i18n,
    );
  }

  /// Create from legacy [WidgetConfig]
  factory WidgetDefinition.fromConfig(WidgetConfig config) {
    final props = Map<String, dynamic>.from(config.properties);

    // Extract visible from properties
    bool? visible;
    String? visibleExpression;
    final rawVisible = props.remove('visible');
    if (rawVisible is bool) {
      visible = rawVisible;
    } else if (rawVisible is String) {
      visibleExpression = rawVisible;
    }

    // Extract key and testKey from properties
    final key = props.remove('key') as String?;
    final testKey = props.remove('testKey') as String?;

    // Convert first child to single child, rest to children list
    WidgetDefinition? child;
    List<WidgetDefinition>? children;
    if (config.children.isNotEmpty) {
      child = WidgetDefinition.fromConfig(config.children.first);
      if (config.children.length > 1) {
        children = config.children
            .skip(1)
            .map((c) => WidgetDefinition.fromConfig(c))
            .toList();
      }
    }

    return WidgetDefinition(
      type: config.type,
      visible: visible,
      visibleExpression: visibleExpression,
      key: key,
      testKey: testKey,
      properties: props,
      children: children,
      child: child,
      accessibility: config.accessibility,
      i18n: config.i18n,
      metadata: config.metadata,
    );
  }

  /// Create a copy with modified properties
  WidgetDefinition copyWith({
    String? type,
    bool? visible,
    String? visibleExpression,
    String? key,
    String? testKey,
    Map<String, dynamic>? properties,
    List<WidgetDefinition>? children,
    WidgetDefinition? child,
    AccessibilityConfig? accessibility,
    I18nConfig? i18n,
    Map<String, dynamic>? metadata,
  }) {
    return WidgetDefinition(
      type: type ?? this.type,
      visible: visible ?? this.visible,
      visibleExpression: visibleExpression ?? this.visibleExpression,
      key: key ?? this.key,
      testKey: testKey ?? this.testKey,
      properties: properties ?? this.properties,
      children: children ?? this.children,
      child: child ?? this.child,
      accessibility: accessibility ?? this.accessibility,
      i18n: i18n ?? this.i18n,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetDefinition &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          visible == other.visible &&
          visibleExpression == other.visibleExpression &&
          key == other.key &&
          testKey == other.testKey &&
          _mapsEqual(properties, other.properties) &&
          _listsEqual(children, other.children) &&
          child == other.child &&
          accessibility == other.accessibility &&
          i18n == other.i18n &&
          _mapsEqual(metadata, other.metadata);

  @override
  int get hashCode =>
      type.hashCode ^
      visible.hashCode ^
      visibleExpression.hashCode ^
      key.hashCode ^
      testKey.hashCode ^
      properties.hashCode ^
      children.hashCode ^
      child.hashCode ^
      accessibility.hashCode ^
      i18n.hashCode ^
      metadata.hashCode;

  @override
  String toString() {
    return 'WidgetDefinition(type: $type, key: $key, '
        'visible: ${visibleExpression ?? visible}, '
        'properties: ${properties.keys}, '
        'children: ${children?.length ?? 0})';
  }

  bool _mapsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  bool _listsEqual(
      List<WidgetDefinition>? a, List<WidgetDefinition>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
