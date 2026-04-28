/// MCP UI DSL version contract.
///
/// Core owns the single source of truth for the DSL version. Runtime and
/// generator consume these constants; they do not declare their own.
class MCPUIDSLVersion {
  /// Current canonical DSL version (2-part `major.minor` form).
  static const String current = '1.3';

  /// Minimum supported DSL version. Pre-launch the canonical form was
  /// reset at 1.3 — older 1.0/1.1/1.2 shapes are not a supported runtime
  /// contract and any stamp below [current] is normalised by [resolve].
  static const String minimum = '1.3';

  /// All supported DSL versions (2-part `major.minor`).
  static const List<String> supported = ['1.3'];

  /// Version changelog.
  static const Map<String, String> changelog = {
    '1.3': 'Canonical baseline — widgets, actions, state, theming, '
        'permissions, channels, templates, bundle metadata, dashboard '
        'compact rendering.',
  };

  /// Check if a version is compatible. Accepts both 2-part (`1.3`) and
  /// 3-part (`1.3.0`) forms — comparison uses `major.minor` only.
  static bool isCompatible(String version) {
    final normalized = _normalize(version);
    return supported.contains(normalized);
  }

  /// Get the latest compatible version.
  static String getLatestCompatible() => current;

  /// Resolve a raw `version` stamp from a DSL document to a supported
  /// canonical value. Returns [current] when the stamp is null, not a
  /// String, or not recognised — the runtime and DSL ship together, so
  /// unknown stamps collapse to the canonical form rather than raising.
  static String resolve(Object? raw) {
    if (raw is! String) return current;
    final normalized = _normalize(raw);
    return supported.contains(normalized) ? normalized : current;
  }

  /// Normalize a version string to 2-part `major.minor` form. Accepts
  /// both `1.3` and `1.3.0` input.
  static String _normalize(String version) {
    final parts = version.split('.');
    if (parts.length >= 2) {
      return '${parts[0]}.${parts[1]}';
    }
    return version;
  }
}

/// Channel action type constants for the MCP UI DSL.
///
/// These action types control bidirectional communication channels.
class ChannelActionTypes {
  ChannelActionTypes._();

  /// Start a channel
  static const String start = 'channel.start';

  /// Stop a channel
  static const String stop = 'channel.stop';

  /// Toggle a channel on/off
  static const String toggle = 'channel.toggle';

  /// Restart a channel (stop and start)
  static const String restart = 'channel.restart';

  /// Send data to a channel
  static const String send = 'channel.send';

  /// All channel action types
  static const List<String> all = [start, stop, toggle, restart, send];

  /// Check if an action type is a channel action
  static bool isChannelAction(String? actionType) {
    if (actionType == null) return false;
    return actionType.startsWith('channel.');
  }
}
