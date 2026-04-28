import 'package:meta/meta.dart';
import 'action_config.dart';
import 'property_spec.dart';
import 'accessibility_config.dart';
import 'i18n_config.dart';

/// Configuration for a widget in the MCP UI DSL
///
/// Represents a single widget definition with its type, properties, and children.
///
/// Deprecated: Use [WidgetDefinition] for strongly-typed fields (visible, key, testKey, child).
/// This class is retained for backward compatibility.
@Deprecated('Use WidgetDefinition instead. This class lacks explicit visible/key/testKey/child fields.')
@immutable
class WidgetConfig {
  /// The widget type (e.g., 'container', 'text', 'button')
  final String type;
  
  /// Widget properties as key-value pairs
  final Map<String, dynamic> properties;
  
  /// Child widgets (if applicable)
  final List<WidgetConfig> children;
  
  /// Metadata for the widget
  final Map<String, dynamic> metadata;
  
  /// Accessibility configuration (spec v1.0)
  final AccessibilityConfig? accessibility;
  
  /// Internationalization configuration (spec v1.0)
  final I18nConfig? i18n;

  const WidgetConfig({
    required this.type,
    this.properties = const {},
    this.children = const [],
    this.metadata = const {},
    this.accessibility,
    this.i18n,
  });

  /// Create a WidgetConfig from JSON
  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    // Extract type (required)
    final type = json['type'] as String;
    
    // Extract known structural fields
    final children = (json['children'] as List?)
        ?.map((child) => WidgetConfig.fromJson(child as Map<String, dynamic>))
        .toList() ?? [];
    final metadata = Map<String, dynamic>.from(json['metadata'] ?? {});
    final accessibility = json['accessibility'] != null
        ? AccessibilityConfig.fromJson(json['accessibility'] as Map<String, dynamic>)
        : null;
    final i18n = json['i18n'] != null
        ? I18nConfig.fromJson(json['i18n'] as Map<String, dynamic>)
        : null;
    
    // All other fields are properties (MCP UI DSL v1.0 spec)
    final properties = <String, dynamic>{};
    for (final entry in json.entries) {
      if (entry.key != 'type' && 
          entry.key != 'children' && 
          entry.key != 'metadata' && 
          entry.key != 'accessibility' && 
          entry.key != 'i18n') {
        properties[entry.key] = entry.value;
      }
    }
    
    // For backward compatibility, if 'properties' field exists, merge it
    if (json.containsKey('properties') && json['properties'] is Map) {
      properties.addAll(Map<String, dynamic>.from(json['properties'] as Map));
    }
    
    return WidgetConfig(
      type: type,
      properties: properties,
      children: children,
      metadata: metadata,
      accessibility: accessibility,
      i18n: i18n,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'type': type,
    };
    
    if (properties.isNotEmpty) {
      result['properties'] = properties;
    }
    
    if (children.isNotEmpty) {
      result['children'] = children.map((child) => child.toJson()).toList();
    }
    
    if (metadata.isNotEmpty) {
      result['metadata'] = metadata;
    }
    
    if (accessibility != null) {
      result['accessibility'] = accessibility!.toJson();
    }
    
    if (i18n != null) {
      result['i18n'] = i18n!.toJson();
    }
    
    return result;
  }

  /// Get a property value with type safety
  T? getProperty<T>(String key, [T? defaultValue]) {
    final value = properties[key];
    if (value is T) return value;
    return defaultValue;
  }

  /// Check if a property exists
  bool hasProperty(String key) {
    return properties.containsKey(key);
  }

  /// Get all action properties - Updated for spec v1.0
  List<ActionConfig> getActions() {
    final actions = <ActionConfig>[];
    
    // Spec v1.0 event names
    const specEventNames = {
      'click', 'double-click', 'right-click', 'long-press',
      'change', 'focus', 'blur', 'hover', 'submit'
    };
    
    for (final entry in properties.entries) {
      // Check for spec v1.0 event names or legacy Flutter event names (starting with 'on')
      if (specEventNames.contains(entry.key) || 
          (entry.key.startsWith('on') && entry.value is Map<String, dynamic>)) {
        try {
          actions.add(ActionConfig.fromJson(entry.value as Map<String, dynamic>));
        } catch (e) {
          // Skip invalid action configurations
        }
      }
    }
    
    return actions;
  }

  /// Get data binding expressions
  List<String> getBindings() {
    final bindings = <String>[];
    
    void extractBindings(dynamic value) {
      if (value is String && value.startsWith('{{') && value.endsWith('}}')) {
        bindings.add(value);
      } else if (value is Map) {
        value.values.forEach(extractBindings);
      } else if (value is List) {
        value.forEach(extractBindings);
      }
    }
    
    extractBindings(properties);
    
    return bindings;
  }

  /// Create a copy with modified properties
  WidgetConfig copyWith({
    String? type,
    Map<String, dynamic>? properties,
    List<WidgetConfig>? children,
    Map<String, dynamic>? metadata,
    AccessibilityConfig? accessibility,
    I18nConfig? i18n,
  }) {
    return WidgetConfig(
      type: type ?? this.type,
      properties: properties ?? this.properties,
      children: children ?? this.children,
      metadata: metadata ?? this.metadata,
      accessibility: accessibility ?? this.accessibility,
      i18n: i18n ?? this.i18n,
    );
  }

  /// Add a property
  WidgetConfig withProperty(String key, dynamic value) {
    final newProperties = Map<String, dynamic>.from(properties);
    newProperties[key] = value;
    return copyWith(properties: newProperties);
  }

  /// Remove a property
  WidgetConfig withoutProperty(String key) {
    final newProperties = Map<String, dynamic>.from(properties);
    newProperties.remove(key);
    return copyWith(properties: newProperties);
  }

  /// Add a child widget
  WidgetConfig withChild(WidgetConfig child) {
    return copyWith(children: [...children, child]);
  }

  /// Add multiple child widgets
  WidgetConfig withChildren(List<WidgetConfig> newChildren) {
    return copyWith(children: [...children, ...newChildren]);
  }

  /// Replace all children
  WidgetConfig replaceChildren(List<WidgetConfig> newChildren) {
    return copyWith(children: newChildren);
  }

  /// Check if this widget has children
  bool get hasChildren => children.isNotEmpty;

  /// Check if this widget can have children (based on type) - MCP UI DSL v1.0
  bool get canHaveChildren {
    const childrenSupportingTypes = {
      // MCP UI DSL v1.0 types (CamelCase for multi-word)
      'linear', 'box', 'stack', 'center', 'align',
      'padding', 'margin', 'expanded', 'flexible', 'wrap',
      'card', 'list', 'grid', 'scrollView',
      'form', 'headerBar', 'tabBar', 'drawer',
      'gestureDetector', 'inkWell', 'draggable', 'dragTarget',
      'conditional', 'singleChildScrollView', 'scrollBar',
      'tabBarView', 'bottomNavigation', 'navigationRail',
      'floatingActionButton', 'animatedContainer', 'flow',
      'table', 'positioned', 'intrinsicHeight', 'intrinsicWidth',
      'visibility', 'sizedBox', 'spacer', 'alertDialog',
      'snackBar', 'bottomSheet',
    };
    return childrenSupportingTypes.contains(type);
  }

  /// Validate the widget configuration
  bool isValid([Map<String, PropertySpec>? propertySpecs]) {
    // Basic validation
    if (type.isEmpty) return false;
    
    // If property specs are provided, validate against them
    if (propertySpecs != null) {
      for (final entry in properties.entries) {
        final spec = propertySpecs[entry.key];
        if (spec != null && !spec.isValid(entry.value)) {
          return false;
        }
      }
      
      // Check for required properties
      for (final entry in propertySpecs.entries) {
        if (entry.value.required && !properties.containsKey(entry.key)) {
          return false;
        }
      }
    }
    
    // Validate children
    if (!canHaveChildren && children.isNotEmpty) {
      return false;
    }
    
    // Recursively validate children
    for (final child in children) {
      if (!child.isValid()) return false;
    }
    
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetConfig &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          _mapsEqual(properties, other.properties) &&
          _listsEqual(children, other.children) &&
          _mapsEqual(metadata, other.metadata);

  @override
  int get hashCode =>
      type.hashCode ^
      properties.hashCode ^
      children.hashCode ^
      metadata.hashCode;

  bool _mapsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  bool _listsEqual(List<WidgetConfig> a, List<WidgetConfig> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'WidgetConfig(type: $type, properties: ${properties.keys}, children: ${children.length})';
  }
}