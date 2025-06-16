import 'package:meta/meta.dart';

/// Page definition for MCP UI DSL v1.0
/// 
/// Represents a single page with content, state, and optional theme override.
@immutable
class PageConfig {
  /// Page type (should be 'page')
  final String type;
  
  /// Page title
  final String? title;
  
  /// Page route
  final String? route;
  
  /// Page content widget
  final Map<String, dynamic> content;
  
  /// Page-specific theme override
  final Map<String, dynamic>? themeOverride;
  
  /// Page-specific state
  final Map<String, dynamic>? state;
  
  /// Page lifecycle hooks
  final Map<String, dynamic>? lifecycle;
  
  /// Page metadata
  final Map<String, dynamic>? metadata;

  const PageConfig({
    this.type = 'page',
    this.title,
    this.route,
    required this.content,
    this.themeOverride,
    this.state,
    this.lifecycle,
    this.metadata,
  });

  /// Create from JSON
  factory PageConfig.fromJson(Map<String, dynamic> json) {
    return PageConfig(
      type: json['type'] as String? ?? 'page',
      title: json['title'] as String?,
      route: json['route'] as String?,
      content: Map<String, dynamic>.from(json['content'] as Map),
      themeOverride: json['themeOverride'] as Map<String, dynamic>?,
      state: json['state'] as Map<String, dynamic>?,
      lifecycle: json['lifecycle'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (title != null) 'title': title,
      if (route != null) 'route': route,
      'content': content,
      if (themeOverride != null) 'themeOverride': themeOverride,
      if (state != null) 'state': state,
      if (lifecycle != null) 'lifecycle': lifecycle,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Check if page has theme override
  bool get hasThemeOverride => themeOverride != null;

  /// Check if page has state
  bool get hasState => state != null;

  /// Check if page has lifecycle hooks
  bool get hasLifecycle => lifecycle != null;

  /// Get initial state
  Map<String, dynamic>? get initialState {
    return state?['initial'] as Map<String, dynamic>?;
  }

  /// Create a copy with modified properties
  PageConfig copyWith({
    String? type,
    String? title,
    String? route,
    Map<String, dynamic>? content,
    Map<String, dynamic>? themeOverride,
    Map<String, dynamic>? state,
    Map<String, dynamic>? lifecycle,
    Map<String, dynamic>? metadata,
  }) {
    return PageConfig(
      type: type ?? this.type,
      title: title ?? this.title,
      route: route ?? this.route,
      content: content ?? this.content,
      themeOverride: themeOverride ?? this.themeOverride,
      state: state ?? this.state,
      lifecycle: lifecycle ?? this.lifecycle,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageConfig &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          route == other.route &&
          _mapsEqual(content, other.content) &&
          _mapsEqual(themeOverride, other.themeOverride) &&
          _mapsEqual(state, other.state) &&
          _mapsEqual(lifecycle, other.lifecycle) &&
          _mapsEqual(metadata, other.metadata);

  @override
  int get hashCode =>
      type.hashCode ^
      title.hashCode ^
      route.hashCode ^
      content.hashCode ^
      themeOverride.hashCode ^
      state.hashCode ^
      lifecycle.hashCode ^
      metadata.hashCode;

  bool _mapsEqual(Map? a, Map? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'PageConfig(type: $type, title: $title, route: $route)';
  }
}