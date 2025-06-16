import 'package:meta/meta.dart';
import 'widget_config.dart';
import 'theme_config.dart';

/// Complete UI definition for MCP UI DSL
/// 
/// Represents a complete UI definition including layout, state, computed values,
/// methods, and theming configuration.
@immutable
class UIDefinition {
  /// The root layout widget
  final WidgetConfig layout;
  
  /// Initial state data
  final Map<String, dynamic> initialState;
  
  /// Computed values and expressions
  final Map<String, String> computedValues;
  
  /// Custom methods and functions
  final Map<String, String> methods;
  
  /// Theme configuration
  final ThemeConfig? theme;
  
  /// Metadata for the UI definition
  final Map<String, dynamic> metadata;
  
  /// DSL version used for this definition
  final String dslVersion;

  const UIDefinition({
    required this.layout,
    this.initialState = const {},
    this.computedValues = const {},
    this.methods = const {},
    this.theme,
    this.metadata = const {},
    this.dslVersion = '1.0.0',
  });

  /// Create a UIDefinition from JSON
  factory UIDefinition.fromJson(Map<String, dynamic> json) {
    return UIDefinition(
      layout: WidgetConfig.fromJson(json['layout'] as Map<String, dynamic>),
      initialState: Map<String, dynamic>.from(json['initialState'] ?? {}),
      computedValues: Map<String, String>.from(json['computedValues'] ?? {}),
      methods: Map<String, String>.from(json['methods'] ?? {}),
      theme: json['theme'] != null 
          ? ThemeConfig.fromJson(json['theme'] as Map<String, dynamic>)
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      dslVersion: json['dslVersion'] as String? ?? '1.0.0',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'layout': layout.toJson(),
      'dslVersion': dslVersion,
    };
    
    if (initialState.isNotEmpty) {
      result['initialState'] = initialState;
    }
    
    if (computedValues.isNotEmpty) {
      result['computedValues'] = computedValues;
    }
    
    if (methods.isNotEmpty) {
      result['methods'] = methods;
    }
    
    if (theme != null) {
      result['theme'] = theme!.toJson();
    }
    
    if (metadata.isNotEmpty) {
      result['metadata'] = metadata;
    }
    
    return result;
  }

  /// Create a simple UIDefinition with just a layout
  factory UIDefinition.simple(WidgetConfig layout) {
    return UIDefinition(layout: layout);
  }

  /// Create a UIDefinition with layout and initial state
  factory UIDefinition.withState(
    WidgetConfig layout,
    Map<String, dynamic> initialState,
  ) {
    return UIDefinition(
      layout: layout,
      initialState: initialState,
    );
  }

  /// Create a UIDefinition with full configuration
  factory UIDefinition.full({
    required WidgetConfig layout,
    Map<String, dynamic>? initialState,
    Map<String, String>? computedValues,
    Map<String, String>? methods,
    ThemeConfig? theme,
    Map<String, dynamic>? metadata,
    String dslVersion = '1.0.0',
  }) {
    return UIDefinition(
      layout: layout,
      initialState: initialState ?? {},
      computedValues: computedValues ?? {},
      methods: methods ?? {},
      theme: theme,
      metadata: metadata ?? {},
      dslVersion: dslVersion,
    );
  }

  /// Get all binding expressions used in this UI definition
  List<String> getAllBindings() {
    final bindings = <String>[];
    
    void extractFromWidget(WidgetConfig widget) {
      bindings.addAll(widget.getBindings());
      for (final child in widget.children) {
        extractFromWidget(child);
      }
    }
    
    extractFromWidget(layout);
    
    // Extract from computed values
    for (final value in computedValues.values) {
      final regex = RegExp(r'\{\{([^}]+)\}\}');
      final matches = regex.allMatches(value);
      for (final match in matches) {
        bindings.add(match.group(0)!);
      }
    }
    
    return bindings.toSet().toList(); // Remove duplicates
  }

  /// Get all state paths referenced in bindings
  List<String> getReferencedStatePaths() {
    final bindings = getAllBindings();
    return bindings
        .map((binding) => binding.replaceAll(RegExp(r'[{}]'), '').trim())
        .toList();
  }

  /// Get all computed value names
  List<String> getComputedValueNames() {
    return computedValues.keys.toList();
  }

  /// Get all method names
  List<String> getMethodNames() {
    return methods.keys.toList();
  }

  /// Check if the UI definition has a theme
  bool get hasTheme => theme != null;

  /// Check if the UI definition has initial state
  bool get hasInitialState => initialState.isNotEmpty;

  /// Check if the UI definition has computed values
  bool get hasComputedValues => computedValues.isNotEmpty;

  /// Check if the UI definition has custom methods
  bool get hasMethods => methods.isNotEmpty;

  /// Validate the UI definition
  bool isValid() {
    // Validate layout
    if (!layout.isValid()) {
      return false;
    }
    
    // Validate computed values (basic syntax check)
    for (final value in computedValues.values) {
      if (value.isEmpty) return false;
    }
    
    // Validate methods (basic syntax check)
    for (final method in methods.values) {
      if (method.isEmpty) return false;
    }
    
    return true;
  }

  /// Create a copy with modified properties
  UIDefinition copyWith({
    WidgetConfig? layout,
    Map<String, dynamic>? initialState,
    Map<String, String>? computedValues,
    Map<String, String>? methods,
    ThemeConfig? theme,
    Map<String, dynamic>? metadata,
    String? dslVersion,
  }) {
    return UIDefinition(
      layout: layout ?? this.layout,
      initialState: initialState ?? this.initialState,
      computedValues: computedValues ?? this.computedValues,
      methods: methods ?? this.methods,
      theme: theme ?? this.theme,
      metadata: metadata ?? this.metadata,
      dslVersion: dslVersion ?? this.dslVersion,
    );
  }

  /// Add or update a computed value
  UIDefinition withComputedValue(String name, String expression) {
    final newComputedValues = Map<String, String>.from(computedValues);
    newComputedValues[name] = expression;
    return copyWith(computedValues: newComputedValues);
  }

  /// Add or update a method
  UIDefinition withMethod(String name, String code) {
    final newMethods = Map<String, String>.from(methods);
    newMethods[name] = code;
    return copyWith(methods: newMethods);
  }

  /// Add or update state data
  UIDefinition withState(String key, dynamic value) {
    final newState = Map<String, dynamic>.from(initialState);
    newState[key] = value;
    return copyWith(initialState: newState);
  }

  /// Set or update theme
  UIDefinition withTheme(ThemeConfig theme) {
    return copyWith(theme: theme);
  }

  /// Add metadata
  UIDefinition withMetadata(String key, dynamic value) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata[key] = value;
    return copyWith(metadata: newMetadata);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UIDefinition &&
          runtimeType == other.runtimeType &&
          layout == other.layout &&
          _mapsEqual(initialState, other.initialState) &&
          _mapsEqual(computedValues, other.computedValues) &&
          _mapsEqual(methods, other.methods) &&
          theme == other.theme &&
          _mapsEqual(metadata, other.metadata) &&
          dslVersion == other.dslVersion;

  @override
  int get hashCode =>
      layout.hashCode ^
      initialState.hashCode ^
      computedValues.hashCode ^
      methods.hashCode ^
      theme.hashCode ^
      metadata.hashCode ^
      dslVersion.hashCode;

  bool _mapsEqual(Map a, Map b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'UIDefinition(dslVersion: $dslVersion, hasTheme: $hasTheme, '
           'hasState: $hasInitialState, computedValues: ${computedValues.length}, '
           'methods: ${methods.length})';
  }
}