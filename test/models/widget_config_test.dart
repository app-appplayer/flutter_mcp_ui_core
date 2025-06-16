import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('WidgetConfig', () {
    group('New Widget Type Configurations', () {
      test('should create number field configuration', () {
        final widget = WidgetConfig(
          type: WidgetTypes.numberField,
          properties: {
            'label': 'Quantity',
            'value': 5.0,
            'min': 0.0,
            'max': 100.0,
            'step': 0.5,
            'decimalPlaces': 1,
            'format': 'decimal',
            'prefix': '',
            'suffix': ' units',
            'thousandSeparator': ',',
            'bindTo': 'quantity',
          },
        );

        expect(widget.type, equals(WidgetTypes.numberField));
        expect(widget.properties['label'], equals('Quantity'));
        expect(widget.properties['value'], equals(5.0));
        expect(widget.properties['min'], equals(0.0));
        expect(widget.properties['max'], equals(100.0));
        expect(widget.properties['step'], equals(0.5));
        expect(widget.properties['suffix'], equals(' units'));
        expect(widget.hasProperty('bindTo'), isTrue);
        expect(widget.getProperty<String>('bindTo'), equals('quantity'));
      });

      test('should create color picker configuration', () {
        final widget = WidgetConfig(
          type: WidgetTypes.colorPicker,
          properties: {
            'value': '#FF5722',
            'showAlpha': false,
            'showLabel': true,
            'pickerType': 'material',
            'enableHistory': true,
            'bindTo': 'theme.accentColor',
          },
        );

        expect(widget.type, equals(WidgetTypes.colorPicker));
        expect(widget.properties['value'], equals('#FF5722'));
        expect(widget.properties['showAlpha'], isFalse);
        expect(widget.properties['pickerType'], equals('material'));
        expect(widget.hasProperty('bindTo'), isTrue);
        expect(widget.getProperty<String>('bindTo'), equals('theme.accentColor'));
      });

      test('should create radio group configuration', () {
        final options = [
          {'label': 'Small', 'value': 'S'},
          {'label': 'Medium', 'value': 'M'},
          {'label': 'Large', 'value': 'L'},
          {'label': 'Extra Large', 'value': 'XL'},
        ];

        final widget = WidgetConfig(
          type: WidgetTypes.radioGroup,
          properties: {
            'value': 'M',
            'options': options,
            'orientation': 'horizontal',
            'bindTo': 'selectedSize',
          },
        );

        expect(widget.type, equals(WidgetTypes.radioGroup));
        expect(widget.properties['value'], equals('M'));
        expect(widget.properties['options'], equals(options));
        expect(widget.properties['orientation'], equals('horizontal'));
        expect(widget.hasProperty('bindTo'), isTrue);
      });

      test('should create checkbox group configuration', () {
        final options = [
          {'label': 'Newsletter', 'value': 'newsletter'},
          {'label': 'Updates', 'value': 'updates'},
          {'label': 'Promotions', 'value': 'promotions'},
        ];

        final widget = WidgetConfig(
          type: WidgetTypes.checkboxGroup,
          properties: {
            'value': ['newsletter', 'updates'],
            'options': options,
            'orientation': 'vertical',
            'bindTo': 'preferences',
          },
        );

        expect(widget.type, equals(WidgetTypes.checkboxGroup));
        expect(widget.properties['value'], equals(['newsletter', 'updates']));
        expect(widget.properties['options'], equals(options));
        expect(widget.hasProperty('bindTo'), isTrue);
      });

      test('should create segmented control configuration', () {
        final options = [
          {'label': 'Day', 'value': 'day'},
          {'label': 'Week', 'value': 'week'},
          {'label': 'Month', 'value': 'month'},
          {'label': 'Year', 'value': 'year'},
        ];

        final widget = WidgetConfig(
          type: WidgetTypes.segmentedControl,
          properties: {
            'value': 'week',
            'options': options,
            'style': 'cupertino',
            'bindTo': 'viewMode',
          },
        );

        expect(widget.type, equals(WidgetTypes.segmentedControl));
        expect(widget.properties['value'], equals('week'));
        expect(widget.properties['style'], equals('cupertino'));
      });

      test('should create date field configuration', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dateField,
          properties: {
            'label': 'Event Date',
            'value': '2024-06-15',
            'format': 'yyyy-MM-dd',
            'firstDate': '2024-01-01',
            'lastDate': '2024-12-31',
            'mode': 'calendar',
            'locale': 'en_US',
            'bindTo': 'eventDate',
          },
        );

        expect(widget.type, equals(WidgetTypes.dateField));
        expect(widget.properties['label'], equals('Event Date'));
        expect(widget.properties['value'], equals('2024-06-15'));
        expect(widget.properties['format'], equals('yyyy-MM-dd'));
        expect(widget.properties['mode'], equals('calendar'));
      });

      test('should create time field configuration', () {
        final widget = WidgetConfig(
          type: WidgetTypes.timeField,
          properties: {
            'label': 'Appointment Time',
            'value': '09:30',
            'format': 'HH:mm',
            'use24HourFormat': true,
            'mode': 'spinner',
            'bindTo': 'appointmentTime',
          },
        );

        expect(widget.type, equals(WidgetTypes.timeField));
        expect(widget.properties['label'], equals('Appointment Time'));
        expect(widget.properties['value'], equals('09:30'));
        expect(widget.properties['use24HourFormat'], isTrue);
      });

      test('should create date range picker configuration', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dateRangePicker,
          properties: {
            'startDate': '2024-01-01',
            'endDate': '2024-01-07',
            'firstDate': '2023-01-01',
            'lastDate': '2025-12-31',
            'format': 'MMM dd, yyyy',
            'locale': 'en_US',
            'saveText': 'Select',
          },
        );

        expect(widget.type, equals(WidgetTypes.dateRangePicker));
        expect(widget.properties['startDate'], equals('2024-01-01'));
        expect(widget.properties['endDate'], equals('2024-01-07'));
        expect(widget.properties['saveText'], equals('Select'));
      });

      test('should create scroll view configuration', () {
        final widget = WidgetConfig(
          type: WidgetTypes.scrollView,
          properties: {
            'scrollDirection': 'horizontal',
            'physics': 'bouncing',
            'padding': {'horizontal': 16.0, 'vertical': 8.0},
            'reverse': false,
            'primary': true,
            'shrinkWrap': false,
          },
          children: [
            WidgetConfig(
              type: WidgetTypes.container,
              properties: {'width': 100.0, 'height': 100.0},
            ),
          ],
        );

        expect(widget.type, equals(WidgetTypes.scrollView));
        expect(widget.properties['scrollDirection'], equals('horizontal'));
        expect(widget.properties['physics'], equals('bouncing'));
        expect(widget.children.length, equals(1));
      });

      test('should create draggable configuration', () {
        final feedbackWidget = {
          'type': 'container',
          'properties': {
            'color': '#80000000',
            'padding': {'all': 8.0},
          },
          'children': [
            {
              'type': 'text',
              'properties': {'content': 'Dragging...'},
            }
          ],
        };

        final widget = WidgetConfig(
          type: WidgetTypes.draggable,
          properties: {
            'data': {'id': 'item1', 'name': 'Item 1'},
            'feedback': feedbackWidget,
            'axis': 'horizontal',
            'maxSimultaneousDrags': 1,
          },
          children: [
            WidgetConfig(
              type: WidgetTypes.card,
              children: [
                WidgetConfig(
                  type: WidgetTypes.text,
                  properties: {'content': 'Draggable Item'},
                ),
              ],
            ),
          ],
        );

        expect(widget.type, equals(WidgetTypes.draggable));
        expect(widget.properties['data'], equals({'id': 'item1', 'name': 'Item 1'}));
        expect(widget.properties['feedback'], equals(feedbackWidget));
        expect(widget.properties['axis'], equals('horizontal'));
      });

      test('should create drag target configuration', () {
        final builderWidget = {
          'type': 'container',
          'properties': {
            'width': 200.0,
            'height': 200.0,
            'color': '{{candidateData != null ? "#FFE0E0E0" : "#FFFFFFFF"}}',
          },
          'children': [
            {
              'type': 'center',
              'children': [
                {
                  'type': 'text',
                  'properties': {'content': 'Drop here'},
                }
              ],
            }
          ],
        };

        final widget = WidgetConfig(
          type: WidgetTypes.dragTarget,
          properties: {
            'builder': builderWidget,
            'onWillAccept': 'return data != null && data.type == "item";',
            'onAccept': ActionConfig.state(
              action: 'add',
              binding: 'droppedItems',
              value: '{{data}}',
            ).toJson(),
            'onHover': ActionConfig.state(
              action: 'set',
              binding: 'hovering',
              value: true,
            ).toJson(),
            'onLeave': ActionConfig.state(
              action: 'set',
              binding: 'hovering',
              value: false,
            ).toJson(),
          },
        );

        expect(widget.type, equals(WidgetTypes.dragTarget));
        expect(widget.properties['builder'], equals(builderWidget));
        expect(widget.properties['onWillAccept'], contains('data.type'));
        expect(widget.properties['onAccept'], isNotNull);
      });

      test('should create conditional configuration', () {
        final trueChild = {
          'type': 'text',
          'properties': {
            'content': 'You are an admin',
            'style': {'color': '#4CAF50'},
          },
        };

        final falseChild = {
          'type': 'text',
          'properties': {
            'content': 'Access denied',
            'style': {'color': '#F44336'},
          },
        };

        final widget = WidgetConfig(
          type: WidgetTypes.conditional,
          properties: {
            'condition': '{{user.role == "admin"}}',
            'trueChild': trueChild,
            'falseChild': falseChild,
          },
        );

        expect(widget.type, equals(WidgetTypes.conditional));
        expect(widget.properties['condition'], equals('{{user.role == "admin"}}'));
        expect(widget.properties['trueChild'], equals(trueChild));
        expect(widget.properties['falseChild'], equals(falseChild));
      });
    });

    group('JSON Serialization', () {
      test('should serialize and deserialize number field', () {
        final original = WidgetConfig(
          type: WidgetTypes.numberField,
          properties: {
            'label': 'Price',
            'value': 99.99,
            'min': 0.0,
            'max': 1000.0,
            'step': 0.01,
            'decimalPlaces': 2,
            'format': 'currency',
            'prefix': '\$',
            'bindTo': 'product.price',
          },
        );

        final json = original.toJson();
        final deserialized = WidgetConfig.fromJson(json);

        expect(deserialized.type, equals(original.type));
        expect(deserialized.properties['label'], equals('Price'));
        expect(deserialized.properties['value'], equals(99.99));
        expect(deserialized.properties['format'], equals('currency'));
        expect(deserialized.properties['prefix'], equals('\$'));
        expect(deserialized.getProperty<String>('bindTo'), equals('product.price'));
      });

      test('should serialize and deserialize complex nested structure', () {
        final original = WidgetConfig(
          type: WidgetTypes.conditional,
          properties: {
            'condition': '{{showAdvanced}}',
            'trueChild': {
              'type': WidgetTypes.column,
              'children': [
                {
                  'type': WidgetTypes.colorPicker,
                  'properties': {
                    'bindTo': 'settings.primaryColor',
                    'showAlpha': true,
                  },
                },
                {
                  'type': WidgetTypes.dateRangePicker,
                  'properties': {
                    'startDate': '2024-01-01',
                    'endDate': '2024-12-31',
                  },
                },
              ],
            },
          },
        );

        final json = original.toJson();
        final deserialized = WidgetConfig.fromJson(json);

        expect(deserialized.type, equals(WidgetTypes.conditional));
        expect(deserialized.properties['condition'], equals('{{showAdvanced}}'));
        
        final trueChild = deserialized.properties['trueChild'] as Map<String, dynamic>;
        expect(trueChild['type'], equals(WidgetTypes.column));
        
        final children = trueChild['children'] as List;
        expect(children.length, equals(2));
        expect(children[0]['type'], equals(WidgetTypes.colorPicker));
        expect(children[1]['type'], equals(WidgetTypes.dateRangePicker));
      });
    });

    group('Property Access Methods', () {
      test('should get property values for new widgets', () {
        final widget = WidgetConfig(
          type: WidgetTypes.numberField,
          properties: {
            'value': 42.5,
            'min': 0.0,
            'max': 100.0,
            'bindTo': 'score',
          },
        );

        expect(widget.getProperty<double>('value'), equals(42.5));
        expect(widget.getProperty<double>('min'), equals(0.0));
        expect(widget.getProperty<double>('max'), equals(100.0));
        expect(widget.getProperty<String>('bindTo'), equals('score'));
        expect(widget.getProperty<double>('nonexistent', 0.0), equals(0.0));
      });

      test('should check property existence', () {
        final widget = WidgetConfig(
          type: WidgetTypes.radioGroup,
          properties: {
            'options': [
              {'label': 'Yes', 'value': true},
              {'label': 'No', 'value': false},
            ],
            'value': true,
          },
        );

        expect(widget.hasProperty('options'), isTrue);
        expect(widget.hasProperty('value'), isTrue);
        expect(widget.hasProperty('bindTo'), isFalse);
        expect(widget.hasProperty('orientation'), isFalse);
      });
    });

    group('Action Configuration', () {
      test('should handle actions for new input widgets', () {
        final widget = WidgetConfig(
          type: WidgetTypes.colorPicker,
          properties: {
            'onChange': ActionConfig.batch([
              ActionConfig.state(
                action: 'set',
                binding: 'theme.primary',
                value: '{{value}}',
              ),
              ActionConfig.tool('updateTheme', {'color': '{{value}}'}),
            ]).toJson(),
          },
        );

        final onChange = widget.properties['onChange'] as Map<String, dynamic>;
        expect(onChange['type'], equals('batch'));
        expect(onChange['actions'], isNotNull);
        expect((onChange['actions'] as List).length, equals(2));
      });
    });
  });
}