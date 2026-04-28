import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimestampInfo', () {
    test('creates with all fields', () {
      final ts = TimestampInfo(
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 3, 1),
      );
      expect(ts.createdAt, equals(DateTime(2026, 1, 1)));
      expect(ts.updatedAt, equals(DateTime(2026, 3, 1)));
    });

    test('creates with no fields', () {
      const ts = TimestampInfo();
      expect(ts.createdAt, isNull);
      expect(ts.updatedAt, isNull);
    });

    test('fromJson parses ISO 8601 strings', () {
      final ts = TimestampInfo.fromJson({
        'createdAt': '2026-01-01T00:00:00.000',
        'updatedAt': '2026-03-01T00:00:00.000',
      });
      expect(ts.createdAt, equals(DateTime(2026, 1, 1)));
      expect(ts.updatedAt, equals(DateTime(2026, 3, 1)));
    });

    test('fromJson handles null values', () {
      final ts = TimestampInfo.fromJson({});
      expect(ts.createdAt, isNull);
      expect(ts.updatedAt, isNull);
    });

    test('fromJson handles invalid date strings', () {
      final ts = TimestampInfo.fromJson({
        'createdAt': 'not-a-date',
        'updatedAt': 'also-not-a-date',
      });
      expect(ts.createdAt, isNull);
      expect(ts.updatedAt, isNull);
    });

    test('toJson serializes correctly', () {
      final ts = TimestampInfo(
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 3, 1),
      );
      final json = ts.toJson();
      expect(json['createdAt'], equals('2026-01-01T00:00:00.000Z'));
      expect(json['updatedAt'], equals('2026-03-01T00:00:00.000Z'));
    });

    test('toJson omits null fields', () {
      const ts = TimestampInfo();
      final json = ts.toJson();
      expect(json.containsKey('createdAt'), isFalse);
      expect(json.containsKey('updatedAt'), isFalse);
    });

    test('copyWith creates modified copy', () {
      final ts = TimestampInfo(createdAt: DateTime(2026, 1, 1));
      final updated = ts.copyWith(updatedAt: DateTime(2026, 3, 1));
      expect(updated.createdAt, equals(DateTime(2026, 1, 1)));
      expect(updated.updatedAt, equals(DateTime(2026, 3, 1)));
    });

    test('equality', () {
      final a = TimestampInfo(
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 3, 1),
      );
      final b = TimestampInfo(
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 3, 1),
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString', () {
      const ts = TimestampInfo();
      expect(ts.toString(), contains('TimestampInfo'));
    });
  });
}
