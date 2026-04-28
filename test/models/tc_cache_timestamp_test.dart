// TC-060 ~ TC-062: CachePolicy and TimestampInfo Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-060: CachePolicy (Core layer).fromJson
  // =========================================================================
  group('TC-060: CachePolicy (Core layer).fromJson', () {
    test('Normal: parse all 6 fields', () {
      final json = {
        'strategy': 'cacheFirst',
        'maxSize': 10485760,
        'maxEntries': 100,
        'evictionPolicy': 'lfu',
        'ttl': 300000,
        'persistent': true,
      };

      final cp = CachePolicy.fromJson(json);
      expect(cp.strategy, equals('cacheFirst'));
      expect(cp.maxSize, equals(10485760));
      expect(cp.maxEntries, equals(100));
      expect(cp.evictionPolicy, equals('lfu'));
      expect(cp.ttl, equals(300000));
      expect(cp.persistent, isTrue);
    });

    test('Boundary: strategy values', () {
      for (final strategy in [
        'networkFirst',
        'cacheFirst',
        'staleWhileRevalidate',
        'networkOnly',
        'cacheOnly'
      ]) {
        final cp = CachePolicy.fromJson({'strategy': strategy});
        expect(cp.strategy, equals(strategy));
      }
    });

    test('Boundary: evictionPolicy values', () {
      for (final policy in ['lru', 'lfu', 'fifo', 'ttl']) {
        final cp = CachePolicy.fromJson({'evictionPolicy': policy});
        expect(cp.evictionPolicy, equals(policy));
      }
    });

    test('Boundary: defaults — strategy networkFirst, evictionPolicy lru', () {
      final cp = CachePolicy.fromJson({});
      expect(cp.strategy, equals('networkFirst'));
      expect(cp.evictionPolicy, equals('lru'));
    });

    test('Error: invalid strategy value handled gracefully', () {
      final cp = CachePolicy.fromJson({'strategy': 'invalid'});
      expect(cp.strategy, equals('invalid'));
    });
  });

  // =========================================================================
  // TC-061: CachePolicy (Runtime layer) — same class, additional defaults
  // =========================================================================
  group('TC-061: CachePolicy defaults and runtime-level fields', () {
    test('Normal: constructor defaults match spec', () {
      const cp = CachePolicy();
      expect(cp.strategy, equals('networkFirst'));
      expect(cp.evictionPolicy, equals('lru'));
      expect(cp.maxSize, isNull);
      expect(cp.maxEntries, isNull);
      expect(cp.ttl, isNull);
      expect(cp.persistent, isNull);
    });
  });

  // =========================================================================
  // TC-062: TimestampInfo.fromJson
  // =========================================================================
  group('TC-062: TimestampInfo.fromJson', () {
    test('Normal: parse createdAt and updatedAt as ISO 8601', () {
      final json = {
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-06-01T12:00:00.000Z',
      };

      final ts = TimestampInfo.fromJson(json);
      expect(ts.createdAt, isNotNull);
      expect(ts.createdAt!.year, equals(2024));
      expect(ts.createdAt!.month, equals(1));
      expect(ts.updatedAt, isNotNull);
      expect(ts.updatedAt!.month, equals(6));
    });

    test('Boundary: only createdAt provided (updatedAt null)', () {
      final json = {
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      final ts = TimestampInfo.fromJson(json);
      expect(ts.createdAt, isNotNull);
      expect(ts.updatedAt, isNull);
    });

    test('Boundary: both null', () {
      final ts = TimestampInfo.fromJson({});
      expect(ts.createdAt, isNull);
      expect(ts.updatedAt, isNull);
    });

    test('Error: invalid ISO 8601 format handled gracefully', () {
      final json = {
        'createdAt': 'not-a-date',
      };
      // DateTime.tryParse returns null for invalid strings
      final ts = TimestampInfo.fromJson(json);
      expect(ts.createdAt, isNull);
    });
  });
}
