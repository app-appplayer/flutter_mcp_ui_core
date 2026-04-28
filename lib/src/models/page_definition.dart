import 'package:meta/meta.dart';

import 'action_definition.dart';
import 'channel_definition.dart';
import 'page_config.dart';
import 'permission_definition.dart';
import 'theme_definition.dart';
import 'widget_definition.dart';

/// Strongly-typed page definition for MCP UI DSL v1.0 / v1.1
///
/// Provides explicit typed fields for page structure, lifecycle hooks,
/// and theme overrides that [PageConfig] stores in untyped maps.
///
/// v1.1 additions: [version], [permissions], [channels] fields for
/// client resource access, permission control, and bidirectional channels.
@immutable
class PageDefinition {
  /// Page type (should be 'page')
  final String type;

  /// Page title
  final String? title;

  /// Page route
  final String? route;

  /// v1.1: MCP UI DSL version ("1.0" default, "1.1" for v1.1 features)
  final String? version;

  /// Page content widget tree
  final WidgetDefinition content;

  /// Page-specific theme override
  final ThemeDefinition? themeOverride;

  /// v1.1: Required client permissions at page level
  final PermissionDefinition? permissions;

  /// v1.1: Bidirectional communication channel definitions
  final Map<String, ChannelDefinition>? channels;

  /// Initial page state
  final Map<String, dynamic>? initialState;

  /// Actions to execute when the page is initialized
  final List<ActionDefinition>? onInit;

  /// Actions to execute when the page is destroyed
  final List<ActionDefinition>? onDestroy;

  /// Actions to execute when the page is ready (layout complete)
  final List<ActionDefinition>? onReady;

  /// Actions to execute when the page is mounted into the widget tree
  final List<ActionDefinition>? onMount;

  /// Actions to execute when the page is unmounted from the widget tree
  final List<ActionDefinition>? onUnmount;

  /// Actions to execute when the page is paused (backgrounded)
  final List<ActionDefinition>? onPause;

  /// Actions to execute when the page is resumed (foregrounded)
  final List<ActionDefinition>? onResume;

  /// Error boundary configuration for graceful error handling
  /// Structure: {fallback: WidgetDefinition, onError?: ActionDefinition}
  final Map<String, dynamic>? errorBoundary;

  /// Offline fallback content when network is unavailable
  /// Structure: {condition?: String, content: WidgetDefinition, cachedData?: bool}
  final Map<String, dynamic>? offlineFallback;

  /// Error recovery strategy
  final Map<String, dynamic>? errorRecovery;

  /// Page metadata
  final Map<String, dynamic>? metadata;

  const PageDefinition({
    this.type = 'page',
    this.title,
    this.route,
    this.version,
    required this.content,
    this.themeOverride,
    this.permissions,
    this.channels,
    this.initialState,
    this.onInit,
    this.onDestroy,
    this.onReady,
    this.onMount,
    this.onUnmount,
    this.onPause,
    this.onResume,
    this.errorBoundary,
    this.offlineFallback,
    this.errorRecovery,
    this.metadata,
  });

  /// Whether this page uses v1.1 features
  bool get isV1_1 =>
      version == '1.1' || permissions != null || channels != null;

  /// Create a PageDefinition from JSON
  factory PageDefinition.fromJson(Map<String, dynamic> json) {
    // Parse content as WidgetDefinition
    final content = WidgetDefinition.fromJson(
        json['content'] as Map<String, dynamic>);

    // Parse theme override
    final themeOverride = json['themeOverride'] != null
        ? ThemeDefinition.fromJson(
            json['themeOverride'] as Map<String, dynamic>)
        : null;

    // Parse initial state from json['state']['initial'] or json['initialState']
    final initialState =
        (json['state'] as Map<String, dynamic>?)?['initial']
                as Map<String, dynamic>? ??
            json['initialState'] as Map<String, dynamic>?;

    // Parse lifecycle hooks from json['lifecycle'] or direct keys
    final lifecycle = json['lifecycle'] as Map<String, dynamic>?;

    final onInit = _parseHookActions(lifecycle?['onInit'] ?? json['onInit']);
    final onDestroy =
        _parseHookActions(lifecycle?['onDestroy'] ?? json['onDestroy']);
    final onReady =
        _parseHookActions(lifecycle?['onReady'] ?? json['onReady']);
    final onMount =
        _parseHookActions(lifecycle?['onMount'] ?? json['onMount']);
    final onUnmount =
        _parseHookActions(lifecycle?['onUnmount'] ?? json['onUnmount']);
    final onPause =
        _parseHookActions(lifecycle?['onPause'] ?? json['onPause']);
    final onResume =
        _parseHookActions(lifecycle?['onResume'] ?? json['onResume']);

    // v1.1: Parse permissions
    final permissions = json['permissions'] != null
        ? PermissionDefinition.fromJson(
            json['permissions'] as Map<String, dynamic>)
        : null;

    // v1.1: Parse channels
    Map<String, ChannelDefinition>? channels;
    if (json['channels'] != null) {
      channels = {};
      final channelsJson = json['channels'] as Map<String, dynamic>;
      for (final entry in channelsJson.entries) {
        channels[entry.key] = ChannelDefinition.fromJson(
            entry.value as Map<String, dynamic>);
      }
    }

    // Parse error handling fields (CM-20)
    final errorBoundary =
        json['errorBoundary'] as Map<String, dynamic>?;
    final offlineFallback =
        json['offlineFallback'] as Map<String, dynamic>?;
    final errorRecovery =
        json['errorRecovery'] as Map<String, dynamic>?;

    return PageDefinition(
      type: json['type'] as String? ?? 'page',
      title: json['title'] as String?,
      route: json['route'] as String?,
      version: json['version'] as String?,
      content: content,
      themeOverride: themeOverride,
      permissions: permissions,
      channels: channels,
      initialState: initialState,
      onInit: onInit,
      onDestroy: onDestroy,
      onReady: onReady,
      onMount: onMount,
      onUnmount: onUnmount,
      onPause: onPause,
      onResume: onResume,
      errorBoundary: errorBoundary,
      offlineFallback: offlineFallback,
      errorRecovery: errorRecovery,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'type': type,
    };

    if (version != null) {
      result['version'] = version;
    }

    if (title != null) {
      result['title'] = title;
    }

    if (route != null) {
      result['route'] = route;
    }

    if (permissions != null) {
      result['permissions'] = permissions!.toJson();
    }

    if (channels != null) {
      result['channels'] = channels!
          .map((key, value) => MapEntry(key, value.toJson()));
    }

    result['content'] = content.toJson();

    if (themeOverride != null) {
      result['themeOverride'] = themeOverride!.toJson();
    }

    if (initialState != null) {
      result['state'] = {'initial': initialState};
    }

    // Put lifecycle hooks under 'lifecycle' key for backward compatibility
    final lifecycle = <String, dynamic>{};
    if (onInit != null && onInit!.isNotEmpty) {
      lifecycle['onInit'] =
          onInit!.map((a) => a.toJson()).toList();
    }
    if (onDestroy != null && onDestroy!.isNotEmpty) {
      lifecycle['onDestroy'] =
          onDestroy!.map((a) => a.toJson()).toList();
    }
    if (onReady != null && onReady!.isNotEmpty) {
      lifecycle['onReady'] =
          onReady!.map((a) => a.toJson()).toList();
    }
    if (onMount != null && onMount!.isNotEmpty) {
      lifecycle['onMount'] =
          onMount!.map((a) => a.toJson()).toList();
    }
    if (onUnmount != null && onUnmount!.isNotEmpty) {
      lifecycle['onUnmount'] =
          onUnmount!.map((a) => a.toJson()).toList();
    }
    if (onPause != null && onPause!.isNotEmpty) {
      lifecycle['onPause'] =
          onPause!.map((a) => a.toJson()).toList();
    }
    if (onResume != null && onResume!.isNotEmpty) {
      lifecycle['onResume'] =
          onResume!.map((a) => a.toJson()).toList();
    }
    if (lifecycle.isNotEmpty) {
      result['lifecycle'] = lifecycle;
    }

    if (errorBoundary != null) {
      result['errorBoundary'] = errorBoundary;
    }

    if (offlineFallback != null) {
      result['offlineFallback'] = offlineFallback;
    }

    if (errorRecovery != null) {
      result['errorRecovery'] = errorRecovery;
    }

    if (metadata != null) {
      result['metadata'] = metadata;
    }

    return result;
  }

  /// Convert to legacy [PageConfig]
  PageConfig toConfig() {
    // Build lifecycle map from individual hook lists
    final lifecycle = <String, dynamic>{};
    if (onInit != null && onInit!.isNotEmpty) {
      lifecycle['onInit'] =
          onInit!.map((a) => a.toJson()).toList();
    }
    if (onDestroy != null && onDestroy!.isNotEmpty) {
      lifecycle['onDestroy'] =
          onDestroy!.map((a) => a.toJson()).toList();
    }
    if (onReady != null && onReady!.isNotEmpty) {
      lifecycle['onReady'] =
          onReady!.map((a) => a.toJson()).toList();
    }
    if (onMount != null && onMount!.isNotEmpty) {
      lifecycle['onMount'] =
          onMount!.map((a) => a.toJson()).toList();
    }
    if (onUnmount != null && onUnmount!.isNotEmpty) {
      lifecycle['onUnmount'] =
          onUnmount!.map((a) => a.toJson()).toList();
    }
    if (onPause != null && onPause!.isNotEmpty) {
      lifecycle['onPause'] =
          onPause!.map((a) => a.toJson()).toList();
    }
    if (onResume != null && onResume!.isNotEmpty) {
      lifecycle['onResume'] =
          onResume!.map((a) => a.toJson()).toList();
    }

    return PageConfig(
      type: type,
      title: title,
      route: route,
      content: content.toJson(),
      themeOverride: themeOverride?.toJson(),
      state: initialState != null ? {'initial': initialState} : null,
      lifecycle: lifecycle.isNotEmpty ? lifecycle : null,
      metadata: metadata,
    );
  }

  /// Create from legacy [PageConfig]
  factory PageDefinition.fromConfig(PageConfig config) {
    // Parse content map as WidgetDefinition
    final content = WidgetDefinition.fromJson(config.content);

    // Parse theme override map as ThemeDefinition
    final themeOverride = config.themeOverride != null
        ? ThemeDefinition.fromJson(config.themeOverride!)
        : null;

    // Parse initial state from state map
    final initialState =
        config.state?['initial'] as Map<String, dynamic>?;

    // Parse lifecycle map into individual hook lists
    final lifecycle = config.lifecycle;
    final onInit = _parseHookActions(lifecycle?['onInit']);
    final onDestroy = _parseHookActions(lifecycle?['onDestroy']);
    final onReady = _parseHookActions(lifecycle?['onReady']);
    final onMount = _parseHookActions(lifecycle?['onMount']);
    final onUnmount = _parseHookActions(lifecycle?['onUnmount']);
    final onPause = _parseHookActions(lifecycle?['onPause']);
    final onResume = _parseHookActions(lifecycle?['onResume']);

    return PageDefinition(
      type: config.type,
      title: config.title,
      route: config.route,
      content: content,
      themeOverride: themeOverride,
      initialState: initialState,
      onInit: onInit,
      onDestroy: onDestroy,
      onReady: onReady,
      onMount: onMount,
      onUnmount: onUnmount,
      onPause: onPause,
      onResume: onResume,
      metadata: config.metadata,
    );
  }

  /// Create a copy with modified properties
  PageDefinition copyWith({
    String? type,
    String? title,
    String? route,
    String? version,
    WidgetDefinition? content,
    ThemeDefinition? themeOverride,
    PermissionDefinition? permissions,
    Map<String, ChannelDefinition>? channels,
    Map<String, dynamic>? initialState,
    List<ActionDefinition>? onInit,
    List<ActionDefinition>? onDestroy,
    List<ActionDefinition>? onReady,
    List<ActionDefinition>? onMount,
    List<ActionDefinition>? onUnmount,
    List<ActionDefinition>? onPause,
    List<ActionDefinition>? onResume,
    Map<String, dynamic>? errorBoundary,
    Map<String, dynamic>? offlineFallback,
    Map<String, dynamic>? errorRecovery,
    Map<String, dynamic>? metadata,
  }) {
    return PageDefinition(
      type: type ?? this.type,
      title: title ?? this.title,
      route: route ?? this.route,
      version: version ?? this.version,
      content: content ?? this.content,
      themeOverride: themeOverride ?? this.themeOverride,
      permissions: permissions ?? this.permissions,
      channels: channels ?? this.channels,
      initialState: initialState ?? this.initialState,
      onInit: onInit ?? this.onInit,
      onDestroy: onDestroy ?? this.onDestroy,
      onReady: onReady ?? this.onReady,
      onMount: onMount ?? this.onMount,
      onUnmount: onUnmount ?? this.onUnmount,
      onPause: onPause ?? this.onPause,
      onResume: onResume ?? this.onResume,
      errorBoundary: errorBoundary ?? this.errorBoundary,
      offlineFallback: offlineFallback ?? this.offlineFallback,
      errorRecovery: errorRecovery ?? this.errorRecovery,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageDefinition &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          route == other.route &&
          version == other.version &&
          content == other.content &&
          themeOverride == other.themeOverride &&
          permissions == other.permissions &&
          _mapsEqual(initialState, other.initialState) &&
          _listsEqual(onInit, other.onInit) &&
          _listsEqual(onDestroy, other.onDestroy) &&
          _listsEqual(onReady, other.onReady) &&
          _listsEqual(onMount, other.onMount) &&
          _listsEqual(onUnmount, other.onUnmount) &&
          _listsEqual(onPause, other.onPause) &&
          _listsEqual(onResume, other.onResume) &&
          _channelsEqual(channels, other.channels) &&
          _mapsEqual(errorBoundary, other.errorBoundary) &&
          _mapsEqual(offlineFallback, other.offlineFallback) &&
          _mapsEqual(errorRecovery, other.errorRecovery) &&
          _mapsEqual(metadata, other.metadata);

  @override
  int get hashCode =>
      type.hashCode ^
      title.hashCode ^
      route.hashCode ^
      version.hashCode ^
      content.hashCode ^
      themeOverride.hashCode ^
      permissions.hashCode ^
      channels.hashCode ^
      initialState.hashCode ^
      onInit.hashCode ^
      onDestroy.hashCode ^
      onReady.hashCode ^
      onMount.hashCode ^
      onUnmount.hashCode ^
      onPause.hashCode ^
      onResume.hashCode ^
      errorBoundary.hashCode ^
      offlineFallback.hashCode ^
      errorRecovery.hashCode ^
      metadata.hashCode;

  @override
  String toString() {
    return 'PageDefinition(type: $type, title: $title, route: $route)';
  }

  /// Parse a lifecycle hook value into a list of ActionDefinition
  static List<ActionDefinition>? _parseHookActions(dynamic raw) {
    if (raw == null) return null;
    if (raw is List) {
      return raw
          .map((item) =>
              ActionDefinition.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    // Single action object
    if (raw is Map<String, dynamic>) {
      return [ActionDefinition.fromJson(raw)];
    }
    return null;
  }

  bool _mapsEqual(Map? a, Map? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  bool _listsEqual(
      List<ActionDefinition>? a, List<ActionDefinition>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _channelsEqual(
      Map<String, ChannelDefinition>? a, Map<String, ChannelDefinition>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
