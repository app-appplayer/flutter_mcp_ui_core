import 'package:meta/meta.dart';

/// Structured creation/update timestamps for ApplicationDefinition (v1.2).
///
/// Wraps bundle timestamp fields (createdAt, updatedAt) for UI display.
/// publishedAt is intentionally excluded as it is a bundle lifecycle concern,
/// not a UI display concern.
@immutable
class TimestampInfo {
  /// Creation timestamp (ISO 8601).
  final DateTime? createdAt;

  /// Last update timestamp (ISO 8601).
  final DateTime? updatedAt;

  const TimestampInfo({this.createdAt, this.updatedAt});

  /// Create from JSON.
  factory TimestampInfo.fromJson(Map<String, dynamic> json) {
    return TimestampInfo(
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// Create a copy with modifications.
  TimestampInfo copyWith({DateTime? createdAt, DateTime? updatedAt}) {
    return TimestampInfo(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimestampInfo &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => createdAt.hashCode ^ updatedAt.hashCode;

  @override
  String toString() =>
      'TimestampInfo(createdAt: $createdAt, updatedAt: $updatedAt)';

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
