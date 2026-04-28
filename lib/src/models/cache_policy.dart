import 'package:meta/meta.dart';

/// Cache policy configuration for MCP UI DSL v1.1
///
/// Defines how resources should be cached, including strategy selection,
/// size limits, entry counts, and eviction behavior.
@immutable
class CachePolicy {
  /// Caching strategy
  ///
  /// Supported values:
  /// - `networkFirst`: Try network, fall back to cache
  /// - `cacheFirst`: Try cache, fall back to network
  /// - `staleWhileRevalidate`: Serve stale cache while fetching fresh data
  /// - `networkOnly`: Always use network, never cache
  /// - `cacheOnly`: Only use cache, never fetch
  final String strategy;

  /// Maximum cache size in bytes
  final int? maxSize;

  /// Maximum number of cache entries
  final int? maxEntries;

  /// Eviction policy when cache is full
  ///
  /// Supported values: `lru` (least recently used), `lfu` (least frequently used),
  /// `fifo` (first in first out), `ttl` (time-to-live based)
  final String evictionPolicy;

  /// Time-to-live in milliseconds for cached entries
  final int? ttl;

  /// Whether to persist cache across sessions
  final bool? persistent;

  const CachePolicy({
    this.strategy = 'networkFirst',
    this.maxSize,
    this.maxEntries,
    this.evictionPolicy = 'lru',
    this.ttl,
    this.persistent,
  });

  /// Create a CachePolicy from JSON
  factory CachePolicy.fromJson(Map<String, dynamic> json) {
    return CachePolicy(
      strategy: json['strategy'] as String? ?? 'networkFirst',
      maxSize: json['maxSize'] as int?,
      maxEntries: json['maxEntries'] as int?,
      evictionPolicy: json['evictionPolicy'] as String? ?? 'lru',
      ttl: json['ttl'] as int?,
      persistent: json['persistent'] as bool?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy,
      if (maxSize != null) 'maxSize': maxSize,
      if (maxEntries != null) 'maxEntries': maxEntries,
      'evictionPolicy': evictionPolicy,
      if (ttl != null) 'ttl': ttl,
      if (persistent != null) 'persistent': persistent,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachePolicy &&
          runtimeType == other.runtimeType &&
          strategy == other.strategy &&
          maxSize == other.maxSize &&
          maxEntries == other.maxEntries &&
          evictionPolicy == other.evictionPolicy &&
          ttl == other.ttl &&
          persistent == other.persistent;

  @override
  int get hashCode =>
      strategy.hashCode ^
      maxSize.hashCode ^
      maxEntries.hashCode ^
      evictionPolicy.hashCode ^
      ttl.hashCode ^
      persistent.hashCode;

  @override
  String toString() {
    return 'CachePolicy(strategy: $strategy, evictionPolicy: $evictionPolicy, persistent: $persistent)';
  }
}
