import 'package:meta/meta.dart';

/// Application definition for MCP UI DSL v1.0
/// 
/// Represents a complete multi-page application with routing, navigation,
/// theme, and global state management.
@immutable
class ApplicationConfig {
  /// Application type (should be 'application')
  final String type;
  
  /// Application title
  final String title;
  
  /// Application version
  final String version;
  
  /// Initial route to display
  final String initialRoute;
  
  /// Route definitions mapping paths to resource URIs
  final Map<String, dynamic> routes;
  
  /// Theme configuration
  final Map<String, dynamic>? theme;
  
  /// Navigation configuration
  final Map<String, dynamic>? navigation;
  
  /// Initial application state
  final Map<String, dynamic>? state;
  
  /// Application lifecycle hooks
  final Map<String, dynamic>? lifecycle;
  
  /// Application services configuration
  final Map<String, dynamic>? services;

  const ApplicationConfig({
    this.type = 'application',
    required this.title,
    required this.version,
    required this.routes,
    this.initialRoute = '/',
    this.theme,
    this.navigation,
    this.state,
    this.lifecycle,
    this.services,
  });

  /// Create from JSON
  factory ApplicationConfig.fromJson(Map<String, dynamic> json) {
    return ApplicationConfig(
      type: json['type'] as String? ?? 'application',
      title: json['title'] as String,
      version: json['version'] as String,
      routes: Map<String, dynamic>.from(json['routes'] as Map),
      initialRoute: json['initialRoute'] as String? ?? '/',
      theme: json['theme'] as Map<String, dynamic>?,
      navigation: json['navigation'] as Map<String, dynamic>?,
      state: json['state'] as Map<String, dynamic>?,
      lifecycle: json['lifecycle'] as Map<String, dynamic>?,
      services: json['services'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'version': version,
      'initialRoute': initialRoute,
      'routes': routes,
      if (theme != null) 'theme': theme,
      if (navigation != null) 'navigation': navigation,
      if (state != null) 'state': state,
      if (lifecycle != null) 'lifecycle': lifecycle,
      if (services != null) 'services': services,
    };
  }

  /// Check if application has theme
  bool get hasTheme => theme != null;

  /// Check if application has navigation
  bool get hasNavigation => navigation != null;

  /// Check if application has initial state
  bool get hasInitialState => state != null && state!['initial'] != null;

  /// Get initial state
  Map<String, dynamic>? get initialState {
    return state?['initial'] as Map<String, dynamic>?;
  }

  /// Get navigation type
  String? get navigationType {
    return navigation?['type'] as String?;
  }

  /// Get navigation items
  List<dynamic>? get navigationItems {
    return navigation?['items'] as List<dynamic>? ?? 
           navigation?['tabs'] as List<dynamic>?;
  }

  /// Create a copy with modified properties
  ApplicationConfig copyWith({
    String? type,
    String? title,
    String? version,
    String? initialRoute,
    Map<String, dynamic>? routes,
    Map<String, dynamic>? theme,
    Map<String, dynamic>? navigation,
    Map<String, dynamic>? state,
    Map<String, dynamic>? lifecycle,
    Map<String, dynamic>? services,
  }) {
    return ApplicationConfig(
      type: type ?? this.type,
      title: title ?? this.title,
      version: version ?? this.version,
      initialRoute: initialRoute ?? this.initialRoute,
      routes: routes ?? this.routes,
      theme: theme ?? this.theme,
      navigation: navigation ?? this.navigation,
      state: state ?? this.state,
      lifecycle: lifecycle ?? this.lifecycle,
      services: services ?? this.services,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationConfig &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          version == other.version &&
          initialRoute == other.initialRoute &&
          _mapsEqual(routes, other.routes) &&
          _mapsEqual(theme, other.theme) &&
          _mapsEqual(navigation, other.navigation) &&
          _mapsEqual(state, other.state) &&
          _mapsEqual(lifecycle, other.lifecycle) &&
          _mapsEqual(services, other.services);

  @override
  int get hashCode =>
      type.hashCode ^
      title.hashCode ^
      version.hashCode ^
      initialRoute.hashCode ^
      routes.hashCode ^
      theme.hashCode ^
      navigation.hashCode ^
      state.hashCode ^
      lifecycle.hashCode ^
      services.hashCode;

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
    return 'ApplicationConfig(title: $title, version: $version, routes: ${routes.length})';
  }
}