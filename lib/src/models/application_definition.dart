import 'package:mcp_bundle/mcp_bundle.dart' show PublisherInfo, SplashConfig;
import 'package:meta/meta.dart';

import 'application_config.dart';
import 'template_definition.dart';
import 'template_library.dart';
import 'theme_definition.dart';
import 'timestamp_info.dart';

/// Strongly-typed application definition for MCP UI DSL v1.0+
///
/// Provides explicit typed fields for application structure, routing,
/// navigation, and theme that [ApplicationConfig] stores in untyped maps.
///
/// v1.2 additions: optional metadata fields (id, description, icon, splash,
/// category, publisher, timestamps, screenshots) for bundle serving and
/// app marketplace support. All v1.2 fields are optional for backward
/// compatibility.
@immutable
class ApplicationDefinition {
  /// Application type (should be 'application')
  final String type;

  /// Application title
  final String title;

  /// Application version
  final String version;

  /// Initial route to display
  final String initialRoute;

  /// Route definitions mapping paths to resource URIs
  final Map<String, String> routes;

  /// Theme configuration
  final ThemeDefinition? theme;

  /// Navigation configuration
  final NavigationConfig? navigation;

  /// Initial application state
  final Map<String, dynamic>? initialState;

  /// Application lifecycle hooks
  final Map<String, dynamic>? lifecycle;

  /// Application services configuration
  final Map<String, dynamic>? services;

  // -- v1.2 metadata fields (all optional) --

  /// Application identifier (v1.2)
  final String? id;

  /// Human-readable description (v1.2)
  final String? description;

  /// App icon reference — URL, data URI, or asset path (v1.2)
  final String? icon;

  /// Splash screen configuration, reused from mcp_bundle (v1.2)
  final SplashConfig? splash;

  /// Application category as free-form string (v1.2)
  final String? category;

  /// Publisher information, reused from mcp_bundle (v1.2)
  final PublisherInfo? publisher;

  /// Creation/update timestamps (v1.2)
  final TimestampInfo? timestamps;

  /// Screenshot references — URLs, data URIs, or asset paths (v1.2)
  final List<String>? screenshots;

  // -- templates (v1.1) --

  /// Reusable template definitions (v1.1 TM-01)
  final Map<String, TemplateDefinition>? templates;

  // -- i18n fields (spec v1.0 §application.i18n) --

  /// Default locale for the application (e.g., 'en', 'ko')
  final String? defaultLocale;

  /// List of supported locales
  final List<String>? supportedLocales;

  /// Fallback locale when translation is missing
  final String? fallbackLocale;

  // -- v1.3 --

  /// Remote template libraries (v1.3)
  final List<TemplateLibrary>? templateLibraries;

  /// Dashboard compact rendering configuration (v1.3)
  final DashboardConfig? dashboard;

  const ApplicationDefinition({
    this.type = 'application',
    required this.title,
    required this.version,
    this.initialRoute = '/',
    required this.routes,
    this.theme,
    this.navigation,
    this.initialState,
    this.lifecycle,
    this.services,
    // v1.2
    this.id,
    this.description,
    this.icon,
    this.splash,
    this.category,
    this.publisher,
    this.timestamps,
    this.screenshots,
    // templates
    this.templates,
    // i18n
    this.defaultLocale,
    this.supportedLocales,
    this.fallbackLocale,
    // v1.3
    this.templateLibraries,
    this.dashboard,
  });

  /// Create an ApplicationDefinition from JSON
  factory ApplicationDefinition.fromJson(Map<String, dynamic> json) {
    // Parse routes: cast each value to String
    final rawRoutes = json['routes'] as Map;
    final routes = rawRoutes.map<String, String>(
        (key, value) => MapEntry(key as String, value as String));

    // Parse theme
    final theme = json['theme'] != null
        ? ThemeDefinition.fromJson(json['theme'] as Map<String, dynamic>)
        : null;

    // Parse navigation
    final navigation = json['navigation'] != null
        ? NavigationConfig.fromJson(
            json['navigation'] as Map<String, dynamic>)
        : null;

    // Parse initial state from json['state']['initial'] or json['initialState']
    final initialState =
        (json['state'] as Map<String, dynamic>?)?['initial']
                as Map<String, dynamic>? ??
            json['initialState'] as Map<String, dynamic>?;

    // Parse v1.2 metadata fields
    final timestamps = json['timestamps'] != null
        ? TimestampInfo.fromJson(json['timestamps'] as Map<String, dynamic>)
        : null;
    final splash = json['splash'] != null
        ? SplashConfig.fromJson(json['splash'] as Map<String, dynamic>)
        : null;
    final publisher = json['publisher'] != null
        ? PublisherInfo.fromJson(json['publisher'] as Map<String, dynamic>)
        : null;
    final screenshots = (json['screenshots'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList();

    return ApplicationDefinition(
      type: json['type'] as String? ?? 'application',
      title: json['title'] as String,
      version: json['version'] as String,
      initialRoute: json['initialRoute'] as String? ?? '/',
      routes: routes,
      theme: theme,
      navigation: navigation,
      initialState: initialState,
      lifecycle: json['lifecycle'] as Map<String, dynamic>?,
      services: json['services'] as Map<String, dynamic>?,
      // v1.2
      id: json['id'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      splash: splash,
      category: json['category'] as String?,
      publisher: publisher,
      timestamps: timestamps,
      screenshots: screenshots,
      // templates
      templates: json['templates'] != null
          ? (json['templates'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                TemplateDefinition.fromJson({
                  'name': key,
                  ...value as Map<String, dynamic>,
                }),
              ),
            )
          : null,
      // i18n
      defaultLocale: (json['i18n'] as Map<String, dynamic>?)?['defaultLocale'] as String? ??
          json['defaultLocale'] as String?,
      supportedLocales: ((json['i18n'] as Map<String, dynamic>?)?['supportedLocales'] as List<dynamic>?)
              ?.cast<String>() ??
          (json['supportedLocales'] as List<dynamic>?)?.cast<String>(),
      fallbackLocale: (json['i18n'] as Map<String, dynamic>?)?['fallbackLocale'] as String? ??
          json['fallbackLocale'] as String?,
      // v1.3
      templateLibraries: (json['templateLibraries'] as List<dynamic>?)
          ?.map((e) => TemplateLibrary.fromJson(e as Map<String, dynamic>))
          .toList(),
      dashboard: json['dashboard'] != null
          ? DashboardConfig.fromJson(json['dashboard'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'type': type,
      'title': title,
      'version': version,
      'initialRoute': initialRoute,
      'routes': routes,
    };

    if (theme != null) {
      result['theme'] = theme!.toJson();
    }

    if (navigation != null) {
      result['navigation'] = navigation!.toJson();
    }

    if (initialState != null) {
      result['state'] = {'initial': initialState};
    }

    if (lifecycle != null) {
      result['lifecycle'] = lifecycle;
    }

    if (services != null) {
      result['services'] = services;
    }

    // v1.2 metadata fields
    if (id != null) result['id'] = id;
    if (description != null) result['description'] = description;
    if (icon != null) result['icon'] = icon;
    if (splash != null) result['splash'] = splash!.toJson();
    if (category != null) result['category'] = category;
    if (publisher != null) result['publisher'] = publisher!.toJson();
    if (timestamps != null) result['timestamps'] = timestamps!.toJson();
    if (screenshots != null && screenshots!.isNotEmpty) {
      result['screenshots'] = screenshots;
    }

    // templates
    if (templates != null && templates!.isNotEmpty) {
      result['templates'] = templates!.map(
        (key, value) => MapEntry(key, value.toJson()..remove('name')),
      );
    }

    // i18n fields
    if (defaultLocale != null || supportedLocales != null || fallbackLocale != null) {
      result['i18n'] = <String, dynamic>{
        if (defaultLocale != null) 'defaultLocale': defaultLocale,
        if (supportedLocales != null) 'supportedLocales': supportedLocales,
        if (fallbackLocale != null) 'fallbackLocale': fallbackLocale,
      };
    }

    // v1.3
    if (templateLibraries != null && templateLibraries!.isNotEmpty) {
      result['templateLibraries'] =
          templateLibraries!.map((t) => t.toJson()).toList();
    }
    if (dashboard != null) result['dashboard'] = dashboard!.toJson();

    return result;
  }

  /// Convert to legacy [ApplicationConfig]
  ApplicationConfig toConfig() {
    return ApplicationConfig(
      type: type,
      title: title,
      version: version,
      initialRoute: initialRoute,
      routes: Map<String, dynamic>.from(routes),
      theme: theme?.toJson(),
      navigation: navigation?.toJson(),
      state: initialState != null ? {'initial': initialState} : null,
      lifecycle: lifecycle,
      services: services,
    );
  }

  /// Create from legacy [ApplicationConfig]
  factory ApplicationDefinition.fromConfig(ApplicationConfig config) {
    // Cast routes from Map<String, dynamic> to Map<String, String>
    final routes = config.routes.map<String, String>(
        (key, value) => MapEntry(key, value as String));

    // Parse theme map as ThemeDefinition
    final theme = config.theme != null
        ? ThemeDefinition.fromJson(config.theme!)
        : null;

    // Parse navigation map as NavigationConfig
    final navigation = config.navigation != null
        ? NavigationConfig.fromJson(config.navigation!)
        : null;

    // Parse initial state from state map
    final initialState =
        config.state?['initial'] as Map<String, dynamic>?;

    return ApplicationDefinition(
      type: config.type,
      title: config.title,
      version: config.version,
      initialRoute: config.initialRoute,
      routes: routes,
      theme: theme,
      navigation: navigation,
      initialState: initialState,
      lifecycle: config.lifecycle,
      services: config.services,
    );
  }

  /// Create a copy with modified properties
  ApplicationDefinition copyWith({
    String? type,
    String? title,
    String? version,
    String? initialRoute,
    Map<String, String>? routes,
    ThemeDefinition? theme,
    NavigationConfig? navigation,
    Map<String, dynamic>? initialState,
    Map<String, dynamic>? lifecycle,
    Map<String, dynamic>? services,
    // v1.2
    String? id,
    String? description,
    String? icon,
    SplashConfig? splash,
    String? category,
    PublisherInfo? publisher,
    TimestampInfo? timestamps,
    List<String>? screenshots,
    // templates
    Map<String, TemplateDefinition>? templates,
    // i18n
    String? defaultLocale,
    List<String>? supportedLocales,
    String? fallbackLocale,
    // v1.3
    List<TemplateLibrary>? templateLibraries,
    DashboardConfig? dashboard,
  }) {
    return ApplicationDefinition(
      type: type ?? this.type,
      title: title ?? this.title,
      version: version ?? this.version,
      initialRoute: initialRoute ?? this.initialRoute,
      routes: routes ?? this.routes,
      theme: theme ?? this.theme,
      navigation: navigation ?? this.navigation,
      initialState: initialState ?? this.initialState,
      lifecycle: lifecycle ?? this.lifecycle,
      services: services ?? this.services,
      // v1.2
      id: id ?? this.id,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      splash: splash ?? this.splash,
      category: category ?? this.category,
      publisher: publisher ?? this.publisher,
      timestamps: timestamps ?? this.timestamps,
      screenshots: screenshots ?? this.screenshots,
      // templates
      templates: templates ?? this.templates,
      // i18n
      defaultLocale: defaultLocale ?? this.defaultLocale,
      supportedLocales: supportedLocales ?? this.supportedLocales,
      fallbackLocale: fallbackLocale ?? this.fallbackLocale,
      // v1.3
      templateLibraries: templateLibraries ?? this.templateLibraries,
      dashboard: dashboard ?? this.dashboard,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationDefinition &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          version == other.version &&
          initialRoute == other.initialRoute &&
          _mapsEqual(routes, other.routes) &&
          theme == other.theme &&
          navigation == other.navigation &&
          _dynamicMapsEqual(initialState, other.initialState) &&
          _dynamicMapsEqual(lifecycle, other.lifecycle) &&
          _dynamicMapsEqual(services, other.services) &&
          id == other.id &&
          description == other.description &&
          icon == other.icon &&
          splash == other.splash &&
          category == other.category &&
          publisher == other.publisher &&
          timestamps == other.timestamps &&
          _listsEqual(screenshots, other.screenshots) &&
          _templateMapsEqual(templates, other.templates) &&
          defaultLocale == other.defaultLocale &&
          _listsEqual(supportedLocales, other.supportedLocales) &&
          fallbackLocale == other.fallbackLocale &&
          _dynamicListsEqual(templateLibraries, other.templateLibraries) &&
          dashboard == other.dashboard;

  @override
  int get hashCode =>
      type.hashCode ^
      title.hashCode ^
      version.hashCode ^
      initialRoute.hashCode ^
      routes.hashCode ^
      theme.hashCode ^
      navigation.hashCode ^
      initialState.hashCode ^
      lifecycle.hashCode ^
      services.hashCode ^
      id.hashCode ^
      description.hashCode ^
      icon.hashCode ^
      splash.hashCode ^
      category.hashCode ^
      publisher.hashCode ^
      timestamps.hashCode ^
      screenshots.hashCode ^
      templates.hashCode ^
      defaultLocale.hashCode ^
      supportedLocales.hashCode ^
      fallbackLocale.hashCode ^
      templateLibraries.hashCode ^
      dashboard.hashCode;

  @override
  String toString() {
    return 'ApplicationDefinition(title: $title, version: $version, '
        'routes: ${routes.length})';
  }

  bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  bool _listsEqual(List<String>? a, List<String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _templateMapsEqual(Map<String, TemplateDefinition>? a,
      Map<String, TemplateDefinition>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  bool _dynamicListsEqual(List? a, List? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _dynamicMapsEqual(Map? a, Map? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

/// Typed navigation configuration
@immutable
class NavigationConfig {
  /// Navigation type ('bottomNavigation', 'drawer', 'tabs')
  final String type;

  /// Navigation items
  final List<NavigationItem> items;

  const NavigationConfig({
    required this.type,
    required this.items,
  });

  /// Create from JSON
  factory NavigationConfig.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? [];
    final items = rawItems
        .map((item) =>
            NavigationItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return NavigationConfig(
      type: json['type'] as String,
      items: items,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  /// Create a copy with modified properties
  NavigationConfig copyWith({
    String? type,
    List<NavigationItem>? items,
  }) {
    return NavigationConfig(
      type: type ?? this.type,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationConfig &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          _listsEqual(items, other.items);

  @override
  int get hashCode => type.hashCode ^ items.hashCode;

  @override
  String toString() {
    return 'NavigationConfig(type: $type, items: ${items.length})';
  }

  bool _listsEqual(List<NavigationItem> a, List<NavigationItem> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Typed navigation item
@immutable
class NavigationItem {
  /// Display title for the navigation item
  final String title;

  /// Icon identifier (e.g., 'home', 'settings')
  final String? icon;

  /// Route path this item navigates to
  final String route;

  const NavigationItem({
    required this.title,
    this.icon,
    required this.route,
  });

  /// Create from JSON (reads 'title', falls back to 'label' for compatibility)
  factory NavigationItem.fromJson(Map<String, dynamic> json) {
    return NavigationItem(
      title: (json['title'] ?? json['label']) as String,
      icon: json['icon'] as String?,
      route: json['route'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'title': title,
      'route': route,
    };

    if (icon != null) {
      result['icon'] = icon;
    }

    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          icon == other.icon &&
          route == other.route;

  @override
  int get hashCode => title.hashCode ^ icon.hashCode ^ route.hashCode;

  @override
  String toString() {
    return 'NavigationItem(title: $title, icon: $icon, route: $route)';
  }
}

/// Dashboard compact rendering configuration (v1.3)
///
/// Defines a compact widget tree for embedding app content
/// in multi-app dashboard contexts.
@immutable
class DashboardConfig {
  /// Widget tree for the dashboard view
  final Map<String, dynamic> content;

  /// Auto-refresh interval in milliseconds
  final int? refreshInterval;

  /// Action when dashboard card is tapped (typically openApp navigation)
  final Map<String, dynamic>? onTap;

  const DashboardConfig({
    required this.content,
    this.refreshInterval,
    this.onTap,
  });

  /// Create from JSON
  factory DashboardConfig.fromJson(Map<String, dynamic> json) {
    return DashboardConfig(
      content: json['content'] as Map<String, dynamic>,
      refreshInterval: json['refreshInterval'] as int?,
      onTap: json['onTap'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'content': content,
    };
    if (refreshInterval != null) result['refreshInterval'] = refreshInterval;
    if (onTap != null) result['onTap'] = onTap;
    return result;
  }

  /// Create a copy with modified properties
  DashboardConfig copyWith({
    Map<String, dynamic>? content,
    int? refreshInterval,
    Map<String, dynamic>? onTap,
  }) {
    return DashboardConfig(
      content: content ?? this.content,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardConfig &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          refreshInterval == other.refreshInterval &&
          onTap == other.onTap;

  @override
  int get hashCode => content.hashCode ^ refreshInterval.hashCode ^ onTap.hashCode;

  @override
  String toString() {
    return 'DashboardConfig(refreshInterval: $refreshInterval)';
  }
}
