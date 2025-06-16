import 'package:meta/meta.dart';
import 'action_config.dart';
import 'property_spec.dart';

/// Configuration for a widget in the MCP UI DSL
/// 
/// Represents a single widget definition with its type, properties, and children.
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

  const WidgetConfig({
    required this.type,
    this.properties = const {},
    this.children = const [],
    this.metadata = const {},
  });

  /// Create a WidgetConfig from JSON
  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    return WidgetConfig(
      type: json['type'] as String,
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      children: (json['children'] as List?)
          ?.map((child) => WidgetConfig.fromJson(child as Map<String, dynamic>))
          .toList() ?? [],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
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

  /// Get all action properties
  List<ActionConfig> getActions() {
    final actions = <ActionConfig>[];
    
    for (final entry in properties.entries) {
      if (entry.key.startsWith('on') && entry.value is Map<String, dynamic>) {
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
  }) {
    return WidgetConfig(
      type: type ?? this.type,
      properties: properties ?? this.properties,
      children: children ?? this.children,
      metadata: metadata ?? this.metadata,
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

  /// Check if this widget can have children (based on type)
  bool get canHaveChildren {
    const childrenSupportingTypes = {
      'container', 'column', 'row', 'stack', 'center', 'align',
      'padding', 'margin', 'expanded', 'flexible', 'wrap',
      'card', 'listview', 'gridview', 'scrollview',
      'form', 'appbar', 'tabbar', 'drawer',
      'gesturedetector', 'inkwell', 'draggable', 'dragtarget',
      'conditional', 'singlechildscrollview', 'scrollbar',
      'tabbarview', 'bottomnavigationbar', 'navigationrail',
      'floatingactionbutton', 'animatedcontainer', 'flow',
      'table', 'positioned', 'intrinsicheight', 'intrinsicwidth',
      'visibility', 'sizedbox', 'spacer', 'alertdialog',
      'snackbar', 'bottomsheet',
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