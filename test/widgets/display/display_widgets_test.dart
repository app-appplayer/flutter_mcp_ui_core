import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // Helper to create a simple child widget
  Map<String, dynamic> simpleChild({String type = 'text', String content = 'child'}) {
    return {'type': type, 'content': content};
  }

  // TC-051~053: text
  group('TC-051~053: text', () {
    // TC-051: Normal — text with content and style
    test('TC-051: text with content and style', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Hello',
        'style': {'fontSize': 16, 'fontWeight': 'bold', 'color': '#FF0000'},
      });

      expect(widget.type, equals('text'));
      expect(widget.properties['content'], equals('Hello'));
      expect(widget.properties['style'], isA<Map>());
      expect(widget.properties['style']['fontSize'], equals(16));
      expect(widget.properties['style']['fontWeight'], equals('bold'));
      expect(widget.properties['style']['color'], equals('#FF0000'));
    });

    // TC-052: Normal — text with maxLines and overflow
    test('TC-052: text with maxLines and overflow', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Long text content',
        'maxLines': 2,
        'overflow': 'ellipsis',
      });

      expect(widget.properties['maxLines'], equals(2));
      expect(widget.properties['overflow'], equals('ellipsis'));
    });

    // TC-053: Normal — text with textAlign
    test('TC-053: text with textAlign', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Centered',
        'textAlign': 'center',
      });

      expect(widget.properties['textAlign'], equals('center'));
    });
  });

  // TC-054: richText
  group('TC-054: richText', () {
    test('TC-054: richText with segments', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'richText',
        'segments': [
          {'text': 'Hello ', 'style': {'fontWeight': 'bold'}},
          {'text': 'World'},
        ],
      });

      expect(widget.type, equals('richText'));
      expect(widget.properties['segments'], isA<List>());
      final segments = widget.properties['segments'] as List;
      expect(segments.length, equals(2));
      expect(segments[0]['text'], equals('Hello '));
      expect(segments[0]['style']['fontWeight'], equals('bold'));
      expect(segments[1]['text'], equals('World'));
    });
  });

  // TC-055: image
  group('TC-055: image', () {
    test('TC-055: image with src, sizing, fit, alt', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'image',
        'src': 'https://example.com/img.png',
        'width': 200,
        'height': 100,
        'fit': 'cover',
        'alt': 'Logo',
      });

      expect(widget.type, equals('image'));
      expect(widget.properties['src'], equals('https://example.com/img.png'));
      expect(widget.properties['width'], equals(200));
      expect(widget.properties['height'], equals(100));
      expect(widget.properties['fit'], equals('cover'));
      expect(widget.properties['alt'], equals('Logo'));
    });
  });

  // TC-056: icon
  group('TC-056: icon', () {
    test('TC-056: icon with name, size, color', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'icon',
        'name': 'home',
        'size': 24,
        'color': '#333333',
      });

      expect(widget.type, equals('icon'));
      expect(widget.properties['name'], equals('home'));
      expect(widget.properties['size'], equals(24));
      expect(widget.properties['color'], equals('#333333'));
    });
  });

  // TC-057: divider
  group('TC-057: divider', () {
    test('TC-057: divider with thickness, color, indent', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'divider',
        'thickness': 2,
        'color': '#CCCCCC',
        'indent': 16,
      });

      expect(widget.type, equals('divider'));
      expect(widget.properties['thickness'], equals(2));
      expect(widget.properties['color'], equals('#CCCCCC'));
      expect(widget.properties['indent'], equals(16));
    });
  });

  // TC-058: card
  group('TC-058: card', () {
    test('TC-058: card with elevation, borderRadius, child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'card',
        'elevation': 4,
        'borderRadius': 8,
        'child': simpleChild(),
      });

      expect(widget.type, equals('card'));
      expect(widget.properties['elevation'], equals(4));
      expect(widget.properties['borderRadius'], equals(8));
      expect(widget.child, isNotNull);
      expect(widget.child!.type, equals('text'));
    });
  });

  // TC-059: badge
  group('TC-059: badge', () {
    test('TC-059: badge with label, color, child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'badge',
        'label': '5',
        'color': '#FF0000',
        'child': simpleChild(type: 'icon', content: 'mail'),
      });

      expect(widget.type, equals('badge'));
      expect(widget.properties['label'], equals('5'));
      expect(widget.properties['color'], equals('#FF0000'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-060: chip
  group('TC-060: chip', () {
    test('TC-060: chip with label, deletable, color', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'chip',
        'label': 'Tag',
        'deletable': true,
        'color': '#2196F3',
      });

      expect(widget.type, equals('chip'));
      expect(widget.properties['label'], equals('Tag'));
      expect(widget.properties['deletable'], isTrue);
      expect(widget.properties['color'], equals('#2196F3'));
    });
  });

  // TC-061: avatar
  group('TC-061: avatar', () {
    test('TC-061: avatar with src, size, initials', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'avatar',
        'src': 'https://example.com/avatar.png',
        'size': 48,
        'initials': 'JD',
      });

      expect(widget.type, equals('avatar'));
      expect(widget.properties['src'], equals('https://example.com/avatar.png'));
      expect(widget.properties['size'], equals(48));
      expect(widget.properties['initials'], equals('JD'));
    });
  });

  // TC-062: tooltip
  group('TC-062: tooltip', () {
    test('TC-062: tooltip with message and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'tooltip',
        'message': 'Help text',
        'child': simpleChild(type: 'icon', content: 'info'),
      });

      expect(widget.type, equals('tooltip'));
      expect(widget.properties['message'], equals('Help text'));
      expect(widget.child, isNotNull);
    });
  });

  // TC-063: placeholder
  group('TC-063: placeholder', () {
    test('TC-063: placeholder with width and height', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'placeholder',
        'width': 100,
        'height': 100,
      });

      expect(widget.type, equals('placeholder'));
      expect(widget.properties['width'], equals(100));
      expect(widget.properties['height'], equals(100));
    });
  });

  // TC-064: progressBar
  group('TC-064: progressBar', () {
    test('TC-064: progressBar with value and color', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'progressBar',
        'value': 0.75,
        'color': '#4CAF50',
      });

      expect(widget.type, equals('progressBar'));
      expect(widget.properties['value'], equals(0.75));
      expect(widget.properties['color'], equals('#4CAF50'));
    });
  });

  // TC-065: loadingIndicator
  group('TC-065: loadingIndicator', () {
    test('TC-065: loadingIndicator with size and color', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'loadingIndicator',
        'size': 'large',
        'color': '#2196F3',
      });

      expect(widget.type, equals('loadingIndicator'));
      expect(widget.properties['size'], equals('large'));
      expect(widget.properties['color'], equals('#2196F3'));
    });
  });

  // TC-066: banner
  group('TC-066: banner', () {
    test('TC-066: banner with message and severity', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'banner',
        'message': 'Notice',
        'severity': 'warning',
      });

      expect(widget.type, equals('banner'));
      expect(widget.properties['message'], equals('Notice'));
      expect(widget.properties['severity'], equals('warning'));
    });
  });

  // TC-067: verticalDivider
  group('TC-067: verticalDivider', () {
    test('TC-067: verticalDivider with width', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'verticalDivider',
        'width': 2,
      });

      expect(widget.type, equals('verticalDivider'));
      expect(widget.properties['width'], equals(2));
    });
  });

  // TC-068~070: decoration / clip widgets (decoratedBox removed —
  // expressed as `box` with `decoration`).
  group('TC-068~070: decoration/clip widgets', () {
    // TC-069: clipOval
    test('TC-069: clipOval with child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'clipOval',
        'child': {'type': 'image', 'src': 'https://example.com/avatar.png'},
      });

      expect(widget.type, equals('clipOval'));
      expect(widget.child, isNotNull);
      expect(widget.child!.type, equals('image'));
    });

    // TC-070: clipRRect
    test('TC-070: clipRRect with borderRadius and child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'clipRRect',
        'borderRadius': 16,
        'child': simpleChild(),
      });

      expect(widget.type, equals('clipRRect'));
      expect(widget.properties['borderRadius'], equals(16));
      expect(widget.child, isNotNull);
    });
  });

  // TC-071~095: Boundary / edge cases
  group('TC-071~095: Display boundary/edge cases', () {
    // TC-071: Text with empty content
    test('TC-071: text with empty content', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': '',
      });

      expect(widget.type, equals('text'));
      expect(widget.properties['content'], equals(''));
    });

    // TC-072: Text with binding expression content
    test('TC-072: text with binding expression content', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': '{{user.name}}',
      });

      expect(widget.properties['content'], equals('{{user.name}}'));
    });

    // TC-073: Image with missing src
    test('TC-073: image with missing src', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'image',
        'width': 100,
        'height': 100,
      });

      expect(widget.type, equals('image'));
      expect(widget.properties['src'], isNull);
    });

    // TC-074: Icon with unknown icon name
    test('TC-074: icon with unknown icon name', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'icon',
        'name': 'nonexistent_icon_xyz',
        'size': 24,
      });

      // Parsing should still succeed; name is just a string property
      expect(widget.type, equals('icon'));
      expect(widget.properties['name'], equals('nonexistent_icon_xyz'));
    });

    // TC-075: Display widget toJson -> fromJson roundtrip
    test('TC-075: display widget toJson -> fromJson roundtrip', () {
      final original = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Roundtrip test',
        'style': {'fontSize': 18, 'color': '#000000'},
        'maxLines': 3,
        'overflow': 'ellipsis',
        'key': 'rt-text',
        'visible': true,
      });

      final json = original.toJson();
      final restored = WidgetDefinition.fromJson(json);

      expect(restored.type, equals(original.type));
      expect(restored.properties['content'], equals(original.properties['content']));
      expect(restored.properties['style'], equals(original.properties['style']));
      expect(restored.properties['maxLines'], equals(original.properties['maxLines']));
      expect(restored.properties['overflow'], equals(original.properties['overflow']));
      expect(restored.key, equals(original.key));
      expect(restored.visible, equals(original.visible));
    });

    // TC-076: Display widget with child
    test('TC-076: display widget with child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'card',
        'elevation': 2,
        'child': simpleChild(),
      });

      expect(widget.child, isNotNull);
      expect(widget.child!.type, equals('text'));
      expect(widget.child!.properties['content'], equals('child'));
    });

    // TC-077: Display widget with children
    test('TC-077: display widget with children', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'card',
        'children': [
          simpleChild(content: 'title'),
          simpleChild(content: 'body'),
        ],
      });

      expect(widget.children, isNotNull);
      expect(widget.children!.length, equals(2));
      expect(widget.children![0].properties['content'], equals('title'));
      expect(widget.children![1].properties['content'], equals('body'));
    });

    // TC-078: Display widget with metadata
    test('TC-078: display widget with metadata', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Info',
        'metadata': {
          'source': 'api',
          'timestamp': 1234567890,
        },
      });

      expect(widget.metadata['source'], equals('api'));
      expect(widget.metadata['timestamp'], equals(1234567890));
    });

    // TC-079: Display widget with accessibility
    test('TC-079: display widget with accessibility', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'image',
        'src': 'https://example.com/photo.jpg',
        'accessibility': {
          'semanticLabel': 'Profile photo',
          'role': 'image',
        },
      });

      expect(widget.accessibility, isNotNull);
      expect(widget.accessibility!.semanticLabel, equals('Profile photo'));
      expect(widget.accessibility!.role, equals('image'));
    });

    // TC-080: Display widget with i18n config
    test('TC-080: display widget with i18n config', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Hello',
        'i18n': {
          'text': {
            'key': 'greeting.hello',
            'default': 'Hello',
          },
        },
      });

      expect(widget.i18n, isNotNull);
      expect(widget.i18n!.text, isNotNull);
      expect(widget.i18n!.text!.key, equals('greeting.hello'));
      expect(widget.i18n!.text!.defaultText, equals('Hello'));
    });

    // TC-081: Text with null style
    test('TC-081: text with no style', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Plain text',
      });

      expect(widget.properties['style'], isNull);
    });

    // TC-082: Image toJson -> fromJson roundtrip
    test('TC-082: image toJson -> fromJson roundtrip', () {
      final original = WidgetDefinition.fromJson({
        'type': 'image',
        'src': 'https://example.com/img.png',
        'width': 300,
        'height': 200,
        'fit': 'contain',
        'alt': 'Test image',
      });

      final restored = WidgetDefinition.fromJson(original.toJson());

      expect(restored.type, equals('image'));
      expect(restored.properties['src'], equals(original.properties['src']));
      expect(restored.properties['width'], equals(original.properties['width']));
      expect(restored.properties['fit'], equals(original.properties['fit']));
      expect(restored.properties['alt'], equals(original.properties['alt']));
    });

    // TC-083: Icon copyWith changes color
    test('TC-083: icon copyWith changes properties', () {
      final original = WidgetDefinition(
        type: 'icon',
        properties: {'name': 'home', 'size': 24, 'color': '#333333'},
      );

      final modified = original.copyWith(
        properties: {'name': 'home', 'size': 32, 'color': '#FF0000'},
      );

      expect(modified.properties['size'], equals(32));
      expect(modified.properties['color'], equals('#FF0000'));
      expect(modified.properties['name'], equals('home'));
    });

    // TC-084: Divider with no properties
    test('TC-084: divider with no properties', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'divider',
      });

      expect(widget.type, equals('divider'));
      expect(widget.properties, isEmpty);
    });

    // TC-085: Card with nested display widgets
    test('TC-085: card with nested display widgets', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'card',
        'elevation': 4,
        'children': [
          {'type': 'text', 'content': 'Title', 'style': {'fontWeight': 'bold'}},
          {'type': 'divider', 'thickness': 1},
          {'type': 'text', 'content': 'Body text'},
        ],
      });

      expect(widget.children!.length, equals(3));
      expect(widget.children![0].type, equals('text'));
      expect(widget.children![1].type, equals('divider'));
      expect(widget.children![2].type, equals('text'));
    });

    // TC-086: Badge with no child
    test('TC-086: badge with no child', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'badge',
        'label': '3',
      });

      expect(widget.type, equals('badge'));
      expect(widget.child, isNull);
    });

    // TC-087: Chip with deletable=false
    test('TC-087: chip with deletable=false', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'chip',
        'label': 'ReadOnly',
        'deletable': false,
      });

      expect(widget.properties['deletable'], isFalse);
    });

    // TC-088: Avatar with no src (initials only)
    test('TC-088: avatar with initials only, no src', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'avatar',
        'initials': 'AB',
        'size': 40,
      });

      expect(widget.properties['src'], isNull);
      expect(widget.properties['initials'], equals('AB'));
    });

    // TC-089: ProgressBar with value=0 boundary
    test('TC-089: progressBar with value=0', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'progressBar',
        'value': 0.0,
      });

      expect(widget.properties['value'], equals(0.0));
    });

    // TC-090: ProgressBar with value=1 boundary
    test('TC-090: progressBar with value=1', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'progressBar',
        'value': 1.0,
      });

      expect(widget.properties['value'], equals(1.0));
    });

    // TC-091: LoadingIndicator with no size specified
    test('TC-091: loadingIndicator with no size', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'loadingIndicator',
      });

      expect(widget.type, equals('loadingIndicator'));
      expect(widget.properties['size'], isNull);
    });

    // TC-092: Banner severity values
    test('TC-092: banner with info severity', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'banner',
        'message': 'Info message',
        'severity': 'info',
      });

      expect(widget.properties['severity'], equals('info'));
    });

    // TC-093: Display widget with visible=false
    test('TC-093: display widget with visible=false', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
        'content': 'Hidden',
        'visible': false,
      });

      expect(widget.visible, isFalse);
    });

    // TC-094: Display widget with all optional fields omitted
    test('TC-094: display widget with all optional fields omitted', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'text',
      });

      expect(widget.type, equals('text'));
      expect(widget.visible, isNull);
      expect(widget.visibleExpression, isNull);
      expect(widget.key, isNull);
      expect(widget.testKey, isNull);
      expect(widget.properties, isEmpty);
      expect(widget.children, isNull);
      expect(widget.child, isNull);
      expect(widget.accessibility, isNull);
      expect(widget.i18n, isNull);
      expect(widget.metadata, isEmpty);
    });

    // TC-095: RichText with empty segments list
    test('TC-095: richText with empty segments list', () {
      final widget = WidgetDefinition.fromJson({
        'type': 'richText',
        'segments': [],
      });

      expect(widget.type, equals('richText'));
      expect(widget.properties['segments'], isA<List>());
      expect((widget.properties['segments'] as List).isEmpty, isTrue);
    });
  });
}
