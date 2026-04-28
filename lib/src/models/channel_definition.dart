import 'package:meta/meta.dart';

import 'action_definition.dart';

/// v1.1: Strongly-typed channel definition for bidirectional communication
///
/// Declares a bidirectional communication channel at page level.
/// Channels provide continuous data flow between client and server.
@immutable
class ChannelDefinition {
  /// Channel type: 'client.watchFile', 'client.watchDirectory',
  /// 'client.systemMonitor', 'client.poll', 'client.websocket'
  final String type;

  /// Type-specific parameters
  final Map<String, dynamic>? params;

  /// State binding path for channel data
  final String? binding;

  /// Action to execute on channel events (primarily for poll type)
  final ActionDefinition? action;

  /// Whether the channel starts automatically on page load
  final bool autoStart;

  const ChannelDefinition({
    required this.type,
    this.params,
    this.binding,
    this.action,
    this.autoStart = false,
  });

  /// Create from JSON
  ///
  /// Supports channel definition formats from the v1.1 spec:
  /// ```json
  /// {
  ///   "type": "client.watchFile",
  ///   "path": "./config.json",
  ///   "events": ["change", "rename", "delete"]
  /// }
  /// ```
  /// Or with nested params:
  /// ```json
  /// {
  ///   "type": "client.poll",
  ///   "action": {...},
  ///   "interval": 5000,
  ///   "binding": "apiStatus"
  /// }
  /// ```
  factory ChannelDefinition.fromJson(Map<String, dynamic> json) {
    // Extract known top-level fields
    final type = json['type'] as String;
    final binding = json['binding'] as String?;
    final autoStart = json['autoStart'] as bool? ?? false;

    // Parse action if present
    ActionDefinition? action;
    if (json['action'] != null) {
      action = ActionDefinition.fromJson(
          json['action'] as Map<String, dynamic>);
    }

    // Collect remaining fields as params
    // (path, events, recursive, metrics, interval, pattern, etc.)
    final params = <String, dynamic>{};
    final reservedKeys = {'type', 'binding', 'autoStart', 'action'};
    for (final entry in json.entries) {
      if (!reservedKeys.contains(entry.key)) {
        params[entry.key] = entry.value;
      }
    }

    // Also merge explicit 'params' if present
    if (json['params'] != null && json['params'] is Map) {
      params.addAll(Map<String, dynamic>.from(json['params'] as Map));
    }

    return ChannelDefinition(
      type: type,
      params: params.isNotEmpty ? params : null,
      binding: binding,
      action: action,
      autoStart: autoStart,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'type': type,
    };

    // Spread params into top-level for spec-compliant output
    if (params != null) {
      result.addAll(params!);
    }

    if (binding != null) {
      result['binding'] = binding;
    }

    if (action != null) {
      result['action'] = action!.toJson();
    }

    if (autoStart) {
      result['autoStart'] = autoStart;
    }

    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelDefinition &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          _mapsEqual(params, other.params) &&
          binding == other.binding &&
          action == other.action &&
          autoStart == other.autoStart;

  @override
  int get hashCode =>
      type.hashCode ^
      params.hashCode ^
      binding.hashCode ^
      action.hashCode ^
      autoStart.hashCode;

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
  String toString() =>
      'ChannelDefinition(type: $type, binding: $binding, autoStart: $autoStart)';
}
