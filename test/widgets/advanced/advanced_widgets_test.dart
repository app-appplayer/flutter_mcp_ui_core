// TC-146 ~ TC-150: Advanced Widget Definition Tests
// Tests advanced widget types using the generic WidgetDefinition class
// with type string field and properties map for widget-specific data.
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // ===========================================================================
  // TC-146: Chart widget definition
  // ===========================================================================
  group('TC-146: Chart widget definition', () {
    test('Normal: chart with chartType, data, and options', () {
      final json = {
        'type': 'chart',
        'chartType': 'line',
        'data': [
          {'x': 1, 'y': 10},
          {'x': 2, 'y': 25},
          {'x': 3, 'y': 15},
          {'x': 4, 'y': 30},
        ],
        'options': {
          'title': 'Sales Trend',
          'xAxis': {'label': 'Month'},
          'yAxis': {'label': 'Revenue'},
          'legend': true,
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('chart'));
      expect(def.properties['chartType'], equals('line'));
      expect(def.properties['data'], isA<List>());
      expect((def.properties['data'] as List).length, equals(4));
      expect(def.properties['options'], isA<Map>());
      expect(
        (def.properties['options'] as Map)['title'],
        equals('Sales Trend'),
      );
    });

    test('Boundary: chart with bar type and grouped data', () {
      final json = {
        'type': 'chart',
        'chartType': 'bar',
        'data': [
          {'label': 'Q1', 'value': 100},
          {'label': 'Q2', 'value': 200},
        ],
        'options': {
          'stacked': false,
          'horizontal': true,
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['chartType'], equals('bar'));
      expect(
        (def.properties['options'] as Map)['horizontal'],
        isTrue,
      );
    });

    test('Error: chart without chartType', () {
      final json = {
        'type': 'chart',
        'data': [],
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('chart'));
      expect(def.properties['chartType'], isNull);
    });

    test('Boundary: chart toJson/fromJson roundtrip', () {
      final json = {
        'type': 'chart',
        'chartType': 'pie',
        'data': [
          {'label': 'A', 'value': 30},
          {'label': 'B', 'value': 70},
        ],
        'options': {'showLabels': true},
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('chart'));
      expect(restored.properties['chartType'], equals('pie'));
      expect((restored.properties['data'] as List).length, equals(2));
    });
  });

  // ===========================================================================
  // TC-147: Map widget definition
  // ===========================================================================
  group('TC-147: Map widget definition', () {
    test('Normal: map with location and markers', () {
      final json = {
        'type': 'map',
        'location': {
          'latitude': 37.5665,
          'longitude': 126.9780,
          'zoom': 12,
        },
        'markers': [
          {
            'latitude': 37.5665,
            'longitude': 126.9780,
            'title': 'Seoul City Hall',
            'icon': 'pin',
          },
          {
            'latitude': 37.5512,
            'longitude': 126.9882,
            'title': 'Namsan Tower',
            'icon': 'pin',
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('map'));
      expect(def.properties['location'], isA<Map>());
      final location = def.properties['location'] as Map;
      expect(location['latitude'], equals(37.5665));
      expect(location['longitude'], equals(126.9780));
      expect(location['zoom'], equals(12));
      expect(def.properties['markers'], isA<List>());
      expect((def.properties['markers'] as List).length, equals(2));
    });

    test('Boundary: map without markers', () {
      final json = {
        'type': 'map',
        'location': {
          'latitude': 0.0,
          'longitude': 0.0,
          'zoom': 2,
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('map'));
      expect(def.properties['markers'], isNull);
    });

    test('Error: map without location', () {
      final json = {'type': 'map'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('map'));
      expect(def.properties['location'], isNull);
    });
  });

  // ===========================================================================
  // TC-148: MediaPlayer widget definition
  // ===========================================================================
  group('TC-148: MediaPlayer widget definition', () {
    test('Normal: mediaPlayer with src and autoplay', () {
      final json = {
        'type': 'mediaPlayer',
        'src': 'video.mp4',
        'autoplay': false,
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('mediaPlayer'));
      expect(def.properties['src'], equals('video.mp4'));
      expect(def.properties['autoplay'], isFalse);
    });

    test('Boundary: mediaPlayer with controls and loop', () {
      final json = {
        'type': 'mediaPlayer',
        'src': 'https://example.com/stream.m3u8',
        'autoplay': true,
        'controls': true,
        'loop': true,
        'muted': false,
        'poster': 'thumbnail.jpg',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['autoplay'], isTrue);
      expect(def.properties['controls'], isTrue);
      expect(def.properties['loop'], isTrue);
      expect(def.properties['poster'], equals('thumbnail.jpg'));
    });

    test('Error: mediaPlayer without src', () {
      final json = {'type': 'mediaPlayer', 'autoplay': false};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('mediaPlayer'));
      expect(def.properties['src'], isNull);
    });

    test('Boundary: mediaPlayer toJson/fromJson roundtrip', () {
      final json = {
        'type': 'mediaPlayer',
        'src': 'audio.mp3',
        'autoplay': false,
        'controls': true,
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.properties['src'], equals('audio.mp3'));
      expect(restored.properties['autoplay'], isFalse);
      expect(restored.properties['controls'], isTrue);
    });
  });

  // ===========================================================================
  // TC-149: Calendar widget definition
  // ===========================================================================
  group('TC-149: Calendar widget definition', () {
    test('Normal: calendar with events and month view', () {
      final json = {
        'type': 'calendar',
        'events': [
          {
            'title': 'Meeting',
            'date': '2024-06-15',
            'color': '#4CAF50',
          },
          {
            'title': 'Deadline',
            'date': '2024-06-20',
            'color': '#F44336',
          },
        ],
        'view': 'month',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('calendar'));
      expect(def.properties['events'], isA<List>());
      expect((def.properties['events'] as List).length, equals(2));
      expect(def.properties['view'], equals('month'));
    });

    test('Boundary: calendar with week and day views', () {
      for (final view in ['week', 'day']) {
        final json = {
          'type': 'calendar',
          'events': <Map<String, dynamic>>[],
          'view': view,
        };
        final def = WidgetDefinition.fromJson(json);
        expect(def.properties['view'], equals(view));
      }
    });

    test('Error: calendar without events or view', () {
      final json = {'type': 'calendar'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('calendar'));
      expect(def.properties['events'], isNull);
      expect(def.properties['view'], isNull);
    });

    test('Boundary: calendar with event binding', () {
      final json = {
        'type': 'calendar',
        'events': '{{schedule.events}}',
        'view': 'month',
        'on-event-click': {
          'type': 'navigate',
          'route': '/event/{{event.id}}',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['events'], equals('{{schedule.events}}'));
      expect(def.properties['on-event-click'], isA<Map>());
    });
  });

  // ===========================================================================
  // TC-150: Timeline widget definition
  // ===========================================================================
  group('TC-150: Timeline widget definition', () {
    test('Normal: timeline with items', () {
      final json = {
        'type': 'timeline',
        'items': [
          {
            'title': 'Order Placed',
            'description': 'Your order has been placed',
            'timestamp': '2024-06-01T10:00:00Z',
            'icon': 'shopping_cart',
            'status': 'completed',
          },
          {
            'title': 'Processing',
            'description': 'Order is being processed',
            'timestamp': '2024-06-02T14:30:00Z',
            'icon': 'hourglass',
            'status': 'active',
          },
          {
            'title': 'Shipped',
            'description': 'Waiting for shipment',
            'timestamp': null,
            'icon': 'local_shipping',
            'status': 'pending',
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('timeline'));
      expect(def.properties['items'], isA<List>());
      final items = def.properties['items'] as List;
      expect(items.length, equals(3));
      expect((items[0] as Map)['title'], equals('Order Placed'));
      expect((items[0] as Map)['status'], equals('completed'));
      expect((items[1] as Map)['status'], equals('active'));
      expect((items[2] as Map)['status'], equals('pending'));
    });

    test('Boundary: timeline with empty items', () {
      final json = {
        'type': 'timeline',
        'items': <Map<String, dynamic>>[],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('timeline'));
      expect((def.properties['items'] as List), isEmpty);
    });

    test('Error: timeline without items', () {
      final json = {'type': 'timeline'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('timeline'));
      expect(def.properties['items'], isNull);
    });

    test('Boundary: timeline toJson/fromJson roundtrip', () {
      final json = {
        'type': 'timeline',
        'items': [
          {
            'title': 'Step 1',
            'status': 'done',
          },
          {
            'title': 'Step 2',
            'status': 'current',
          },
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('timeline'));
      final items = restored.properties['items'] as List;
      expect(items.length, equals(2));
      expect((items[0] as Map)['title'], equals('Step 1'));
      expect((items[1] as Map)['status'], equals('current'));
    });
  });
}
