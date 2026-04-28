import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:mcp_bundle/mcp_bundle.dart' show PublisherInfo, SplashConfig;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApplicationDefinition v1.2 metadata', () {
    test('all v1.2 fields are optional', () {
      const def = ApplicationDefinition(
        title: 'Test',
        version: '1.0.0',
        routes: {'/': 'ui://pages/home'},
      );
      expect(def.id, isNull);
      expect(def.description, isNull);
      expect(def.icon, isNull);
      expect(def.splash, isNull);
      expect(def.category, isNull);
      expect(def.publisher, isNull);
      expect(def.timestamps, isNull);
      expect(def.screenshots, isNull);
    });

    test('accepts all v1.2 fields', () {
      final def = ApplicationDefinition(
        title: 'My App',
        version: '1.0.0',
        routes: {'/': 'ui://pages/home'},
        id: 'com.example.app',
        description: 'A test app',
        icon: 'https://example.com/icon.png',
        splash: const SplashConfig(
          image: 'splash.png',
          backgroundColor: '#FFFFFF',
          duration: 3000,
        ),
        category: 'productivity',
        publisher: const PublisherInfo(name: 'Test Publisher'),
        timestamps: TimestampInfo(
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 3, 1),
        ),
        screenshots: const ['s1.png', 's2.png'],
      );
      expect(def.id, equals('com.example.app'));
      expect(def.description, equals('A test app'));
      expect(def.icon, equals('https://example.com/icon.png'));
      expect(def.splash!.backgroundColor, equals('#FFFFFF'));
      expect(def.category, equals('productivity'));
      expect(def.publisher!.name, equals('Test Publisher'));
      expect(def.timestamps!.createdAt, equals(DateTime.utc(2026, 1, 1)));
      expect(def.screenshots, hasLength(2));
    });

    test('fromJson parses v1.2 fields', () {
      final json = <String, dynamic>{
        'title': 'My App',
        'version': '1.0.0',
        'routes': {'/': 'ui://pages/home'},
        'id': 'com.example.app',
        'description': 'Test',
        'icon': 'icon.png',
        'category': 'productivity',
        'publisher': {'name': 'Publisher'},
        'splash': {'image': 'splash.png', 'duration': 2000},
        'timestamps': {
          'createdAt': '2026-01-01T00:00:00.000Z',
          'updatedAt': '2026-03-01T00:00:00.000Z',
        },
        'screenshots': ['s1.png', 's2.png'],
      };
      final def = ApplicationDefinition.fromJson(json);
      expect(def.id, equals('com.example.app'));
      expect(def.description, equals('Test'));
      expect(def.icon, equals('icon.png'));
      expect(def.category, equals('productivity'));
      expect(def.publisher!.name, equals('Publisher'));
      expect(def.splash!.duration, equals(2000));
      expect(def.timestamps!.createdAt, equals(DateTime.utc(2026, 1, 1)));
      expect(def.screenshots, equals(['s1.png', 's2.png']));
    });

    test('fromJson without v1.2 fields (backward compatible)', () {
      final json = <String, dynamic>{
        'title': 'Old App',
        'version': '1.0.0',
        'routes': {'/': 'ui://pages/home'},
      };
      final def = ApplicationDefinition.fromJson(json);
      expect(def.title, equals('Old App'));
      expect(def.id, isNull);
      expect(def.description, isNull);
      expect(def.icon, isNull);
      expect(def.splash, isNull);
      expect(def.category, isNull);
      expect(def.publisher, isNull);
      expect(def.timestamps, isNull);
      expect(def.screenshots, isNull);
    });

    test('toJson includes v1.2 fields when present', () {
      final def = ApplicationDefinition(
        title: 'My App',
        version: '1.0.0',
        routes: {'/': 'ui://pages/home'},
        id: 'com.example.app',
        description: 'Test',
        category: 'productivity',
        timestamps: TimestampInfo(
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      );
      final json = def.toJson();
      expect(json['id'], equals('com.example.app'));
      expect(json['description'], equals('Test'));
      expect(json['category'], equals('productivity'));
      expect((json['timestamps'] as Map)['createdAt'],
          equals('2026-01-01T00:00:00.000Z'));
    });

    test('toJson omits absent v1.2 fields', () {
      const def = ApplicationDefinition(
        title: 'My App',
        version: '1.0.0',
        routes: {'/': 'ui://pages/home'},
      );
      final json = def.toJson();
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('description'), isFalse);
      expect(json.containsKey('icon'), isFalse);
      expect(json.containsKey('splash'), isFalse);
      expect(json.containsKey('category'), isFalse);
      expect(json.containsKey('publisher'), isFalse);
      expect(json.containsKey('timestamps'), isFalse);
      expect(json.containsKey('screenshots'), isFalse);
    });

    test('copyWith updates v1.2 fields', () {
      const def = ApplicationDefinition(
        title: 'My App',
        version: '1.0.0',
        routes: {'/': 'ui://pages/home'},
      );
      final updated = def.copyWith(
        id: 'com.example.app',
        category: 'education',
      );
      expect(updated.id, equals('com.example.app'));
      expect(updated.category, equals('education'));
      expect(updated.title, equals('My App'));
    });

    test('PublisherInfo reused from mcp_bundle', () {
      const publisher = PublisherInfo(
        name: 'Test',
        logo: 'logo.png',
        url: 'https://example.com',
        email: 'test@example.com',
      );
      expect(publisher.name, equals('Test'));
      expect(publisher.logo, equals('logo.png'));
      expect(publisher.url, equals('https://example.com'));
      expect(publisher.email, equals('test@example.com'));
    });

    test('SplashConfig reused from mcp_bundle', () {
      const splash = SplashConfig(
        image: 'splash.png',
        backgroundColor: '#000000',
        duration: 3000,
      );
      expect(splash.image, equals('splash.png'));
      expect(splash.backgroundColor, equals('#000000'));
      expect(splash.duration, equals(3000));
    });
  });
}
