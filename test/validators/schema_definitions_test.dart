import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('SchemaDefinitions', () {
    group('Widget Property Specifications', () {
      test('should have property specs for all new input widgets', () {
        // Number Field
        final numberFieldSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.numberField);
        expect(numberFieldSpecs, isNotNull);
        expect(numberFieldSpecs!['label'], isNotNull);
        expect(numberFieldSpecs['value']!.defaultValue, equals(0.0));
        expect(numberFieldSpecs['min'], isNotNull);
        expect(numberFieldSpecs['max'], isNotNull);
        expect(numberFieldSpecs['step']!.defaultValue, equals(1.0));
        expect(numberFieldSpecs['decimalPlaces']!.defaultValue, equals(0));
        expect(numberFieldSpecs['format']!.defaultValue, equals('decimal'));
        expect(numberFieldSpecs['prefix']!.defaultValue, equals(''));
        expect(numberFieldSpecs['suffix']!.defaultValue, equals(''));
        expect(numberFieldSpecs['thousandSeparator']!.defaultValue, equals(','));
        expect(numberFieldSpecs['onChange'], isNotNull);
        expect(numberFieldSpecs['bindTo'], isNotNull);

        // Color Picker
        final colorPickerSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.colorPicker);
        expect(colorPickerSpecs, isNotNull);
        expect(colorPickerSpecs!['value']!.defaultValue, equals('#000000'));
        expect(colorPickerSpecs['showAlpha']!.defaultValue, equals(true));
        expect(colorPickerSpecs['showLabel']!.defaultValue, equals(true));
        expect(colorPickerSpecs['pickerType']!.defaultValue, equals('both'));
        expect(colorPickerSpecs['enableHistory']!.defaultValue, equals(true));
        expect(colorPickerSpecs['onChange'], isNotNull);
        expect(colorPickerSpecs['bindTo'], isNotNull);

        // Radio Group
        final radioGroupSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.radioGroup);
        expect(radioGroupSpecs, isNotNull);
        expect(radioGroupSpecs!['value'], isNotNull);
        expect(radioGroupSpecs['options']!.required, isTrue);
        expect(radioGroupSpecs['orientation']!.defaultValue, equals('vertical'));
        expect(radioGroupSpecs['onChange'], isNotNull);
        expect(radioGroupSpecs['bindTo'], isNotNull);

        // Checkbox Group
        final checkboxGroupSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.checkboxGroup);
        expect(checkboxGroupSpecs, isNotNull);
        expect(checkboxGroupSpecs!['value']!.defaultValue, equals([]));
        expect(checkboxGroupSpecs['options']!.required, isTrue);
        expect(checkboxGroupSpecs['orientation']!.defaultValue, equals('vertical'));
        expect(checkboxGroupSpecs['onChange'], isNotNull);
        expect(checkboxGroupSpecs['bindTo'], isNotNull);

        // Segmented Control
        final segmentedControlSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.segmentedControl);
        expect(segmentedControlSpecs, isNotNull);
        expect(segmentedControlSpecs!['value'], isNotNull);
        expect(segmentedControlSpecs['options']!.required, isTrue);
        expect(segmentedControlSpecs['style']!.defaultValue, equals('material'));
        expect(segmentedControlSpecs['onChange'], isNotNull);
        expect(segmentedControlSpecs['bindTo'], isNotNull);

        // Date Field
        final dateFieldSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.dateField);
        expect(dateFieldSpecs, isNotNull);
        expect(dateFieldSpecs!['label'], isNotNull);
        expect(dateFieldSpecs['value'], isNotNull);
        expect(dateFieldSpecs['format']!.defaultValue, equals('yyyy-MM-dd'));
        expect(dateFieldSpecs['firstDate'], isNotNull);
        expect(dateFieldSpecs['lastDate'], isNotNull);
        expect(dateFieldSpecs['mode']!.defaultValue, equals('calendar'));
        expect(dateFieldSpecs['locale']!.defaultValue, equals('en_US'));
        expect(dateFieldSpecs['onChange'], isNotNull);
        expect(dateFieldSpecs['bindTo'], isNotNull);

        // Time Field
        final timeFieldSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.timeField);
        expect(timeFieldSpecs, isNotNull);
        expect(timeFieldSpecs!['label'], isNotNull);
        expect(timeFieldSpecs['value'], isNotNull);
        expect(timeFieldSpecs['format']!.defaultValue, equals('HH:mm'));
        expect(timeFieldSpecs['use24HourFormat']!.defaultValue, equals(true));
        expect(timeFieldSpecs['mode']!.defaultValue, equals('spinner'));
        expect(timeFieldSpecs['onChange'], isNotNull);
        expect(timeFieldSpecs['bindTo'], isNotNull);

        // Date Range Picker
        final dateRangePickerSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.dateRangePicker);
        expect(dateRangePickerSpecs, isNotNull);
        expect(dateRangePickerSpecs!['startDate'], isNotNull);
        expect(dateRangePickerSpecs['endDate'], isNotNull);
        expect(dateRangePickerSpecs['firstDate'], isNotNull);
        expect(dateRangePickerSpecs['lastDate'], isNotNull);
        expect(dateRangePickerSpecs['format']!.defaultValue, equals('yyyy-MM-dd'));
        expect(dateRangePickerSpecs['locale']!.defaultValue, equals('en_US'));
        expect(dateRangePickerSpecs['saveText']!.defaultValue, equals('Save'));
        expect(dateRangePickerSpecs['onChange'], isNotNull);
      });

      test('should have property specs for scroll widgets', () {
        final scrollViewSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.scrollView);
        expect(scrollViewSpecs, isNotNull);
        expect(scrollViewSpecs!['scrollDirection']!.defaultValue, equals('vertical'));
        expect(scrollViewSpecs['physics']!.defaultValue, equals('bouncing'));
        expect(scrollViewSpecs['padding'], isNotNull);
        expect(scrollViewSpecs['reverse']!.defaultValue, equals(false));
        expect(scrollViewSpecs['primary']!.defaultValue, equals(true));
        expect(scrollViewSpecs['shrinkWrap']!.defaultValue, equals(false));
        expect(scrollViewSpecs['controller'], isNotNull);
      });

      test('should have property specs for interactive widgets', () {
        // Draggable
        final draggableSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.draggable);
        expect(draggableSpecs, isNotNull);
        expect(draggableSpecs!['data']!.required, isTrue);
        expect(draggableSpecs['feedback']!.required, isTrue);
        expect(draggableSpecs['childWhenDragging'], isNotNull);
        expect(draggableSpecs['maxSimultaneousDrags'], isNotNull);
        expect(draggableSpecs['axis'], isNotNull);

        // Drag Target
        final dragTargetSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.dragTarget);
        expect(dragTargetSpecs, isNotNull);
        expect(dragTargetSpecs!['onAccept'], isNotNull);
        expect(dragTargetSpecs['onWillAccept'], isNotNull);
        expect(dragTargetSpecs['onHover'], isNotNull);
        expect(dragTargetSpecs['onLeave'], isNotNull);
        expect(dragTargetSpecs['builder']!.required, isTrue);
      });

      test('should have property specs for conditional widget', () {
        final conditionalSpecs = SchemaDefinitions.getWidgetPropertySpecs(WidgetTypes.conditional);
        expect(conditionalSpecs, isNotNull);
        expect(conditionalSpecs!['condition']!.required, isTrue);
        expect(conditionalSpecs['trueChild'], isNotNull);
        expect(conditionalSpecs['falseChild'], isNotNull);
        expect(conditionalSpecs['child'], isNotNull);
      });
    });

    group('Property Spec Methods', () {
      test('hasSpecs should identify widgets with specifications', () {
        // New widgets should have specs
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.numberField), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.colorPicker), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.radioGroup), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.checkboxGroup), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.segmentedControl), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.dateField), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.timeField), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.dateRangePicker), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.scrollView), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.draggable), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.dragTarget), isTrue);
        expect(SchemaDefinitions.hasSpecs(WidgetTypes.conditional), isTrue);
        
        // Unknown widget should not have specs
        expect(SchemaDefinitions.hasSpecs('unknown'), isFalse);
      });

      test('getPropertyNames should return all property names for a widget', () {
        final numberFieldProps = SchemaDefinitions.getPropertyNames(WidgetTypes.numberField);
        expect(numberFieldProps, contains('label'));
        expect(numberFieldProps, contains('value'));
        expect(numberFieldProps, contains('min'));
        expect(numberFieldProps, contains('max'));
        expect(numberFieldProps, contains('step'));
        expect(numberFieldProps, contains('decimalPlaces'));
        expect(numberFieldProps, contains('format'));
        expect(numberFieldProps, contains('prefix'));
        expect(numberFieldProps, contains('suffix'));
        expect(numberFieldProps, contains('thousandSeparator'));
        expect(numberFieldProps, contains('onChange'));
        expect(numberFieldProps, contains('bindTo'));
        expect(numberFieldProps.length, equals(12));
      });

      test('getRequiredProperties should return only required properties', () {
        final radioGroupRequired = SchemaDefinitions.getRequiredProperties(WidgetTypes.radioGroup);
        expect(radioGroupRequired, equals(['options']));

        final checkboxGroupRequired = SchemaDefinitions.getRequiredProperties(WidgetTypes.checkboxGroup);
        expect(checkboxGroupRequired, equals(['options']));

        final draggableRequired = SchemaDefinitions.getRequiredProperties(WidgetTypes.draggable);
        expect(draggableRequired.toSet(), equals({'data', 'feedback'}));

        final conditionalRequired = SchemaDefinitions.getRequiredProperties(WidgetTypes.conditional);
        expect(conditionalRequired, equals(['condition']));
      });

      test('getOptionalProperties should return only optional properties', () {
        final numberFieldOptional = SchemaDefinitions.getOptionalProperties(WidgetTypes.numberField);
        expect(numberFieldOptional.length, equals(12)); // All properties are optional
        expect(numberFieldOptional, contains('label'));
        expect(numberFieldOptional, contains('value'));
        expect(numberFieldOptional, contains('bindTo'));

        final radioGroupOptional = SchemaDefinitions.getOptionalProperties(WidgetTypes.radioGroup);
        expect(radioGroupOptional.toSet(), equals({'value', 'orientation', 'onChange', 'bindTo'}));
      });
    });

    group('Property Validation', () {
      test('validateProperty should validate number field properties', () {
        // Valid properties
        expect(SchemaDefinitions.validateProperty(WidgetTypes.numberField, 'value', 10.5), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.numberField, 'min', -100.0), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.numberField, 'max', 100.0), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.numberField, 'step', 0.1), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.numberField, 'decimalPlaces', 2), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.numberField, 'format', 'currency'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.numberField, 'prefix', '\$'), isNull);

        // Unknown property
        final unknownPropError = SchemaDefinitions.validateProperty(
          WidgetTypes.numberField, 
          'unknownProp', 
          'value'
        );
        expect(unknownPropError, isNotNull);
        expect(unknownPropError!.code, equals('UNKNOWN_PROPERTY'));
      });

      test('validateProperty should validate color picker properties', () {
        expect(SchemaDefinitions.validateProperty(WidgetTypes.colorPicker, 'value', '#FF0000'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.colorPicker, 'showAlpha', true), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.colorPicker, 'showLabel', false), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.colorPicker, 'pickerType', 'wheel'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.colorPicker, 'enableHistory', true), isNull);
      });

      test('validateProperty should validate date field properties', () {
        expect(SchemaDefinitions.validateProperty(WidgetTypes.dateField, 'value', '2024-01-15'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.dateField, 'format', 'dd/MM/yyyy'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.dateField, 'firstDate', '2020-01-01'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.dateField, 'lastDate', '2030-12-31'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.dateField, 'mode', 'spinner'), isNull);
        expect(SchemaDefinitions.validateProperty(WidgetTypes.dateField, 'locale', 'fr_FR'), isNull);
      });

      test('validateProperty should validate list properties', () {
        expect(SchemaDefinitions.validateProperty(
          WidgetTypes.checkboxGroup, 
          'value', 
          ['option1', 'option2']
        ), isNull);
        
        expect(SchemaDefinitions.validateProperty(
          WidgetTypes.checkboxGroup, 
          'options', 
          [
            {'label': 'Option 1', 'value': 'opt1'},
            {'label': 'Option 2', 'value': 'opt2'}
          ]
        ), isNull);
      });
    });

    group('Schema Validation', () {
      test('validateAgainstSchema should validate root structure', () {
        final validJson = {
          'layout': {
            'type': 'container',
            'properties': {}
          }
        };
        
        final errors = SchemaDefinitions.validateAgainstSchema(validJson);
        expect(errors, isEmpty);
      });

      test('validateAgainstSchema should detect missing layout', () {
        final invalidJson = {
          'dslVersion': '1.0.0'
        };
        
        final errors = SchemaDefinitions.validateAgainstSchema(invalidJson);
        expect(errors.length, equals(1));
        expect(errors.first.code, equals('REQUIRED_FIELD_MISSING'));
        expect(errors.first.message, contains('layout'));
      });

      test('validateAgainstSchema should validate layout with new widgets', () {
        final jsonWithNewWidgets = {
          'layout': {
            'type': 'column',
            'children': [
              {
                'type': 'numberfield',
                'properties': {
                  'label': 'Age',
                  'min': 0,
                  'max': 150,
                  'bindTo': 'user.age'
                }
              },
              {
                'type': 'colorpicker',
                'properties': {
                  'value': '#FF0000',
                  'bindTo': 'theme.primaryColor'
                }
              },
              {
                'type': 'datefield',
                'properties': {
                  'label': 'Birth Date',
                  'format': 'yyyy-MM-dd',
                  'bindTo': 'user.birthDate'
                }
              }
            ]
          }
        };
        
        final errors = SchemaDefinitions.validateAgainstSchema(jsonWithNewWidgets);
        expect(errors, isEmpty);
      });

      test('validateAgainstSchema should validate complex nested structure', () {
        final complexJson = {
          'layout': {
            'type': 'container',
            'children': [
              {
                'type': 'conditional',
                'properties': {
                  'condition': '{{showForm}}'
                },
                'children': [
                  {
                    'type': 'form',
                    'children': [
                      {
                        'type': 'radiogroup',
                        'properties': {
                          'options': [
                            {'label': 'Yes', 'value': 'yes'},
                            {'label': 'No', 'value': 'no'}
                          ],
                          'bindTo': 'response'
                        }
                      },
                      {
                        'type': 'checkboxgroup',
                        'properties': {
                          'options': [
                            {'label': 'Option A', 'value': 'a'},
                            {'label': 'Option B', 'value': 'b'}
                          ],
                          'bindTo': 'selectedOptions'
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          },
          'initialState': {
            'showForm': true,
            'response': null,
            'selectedOptions': []
          }
        };
        
        final errors = SchemaDefinitions.validateAgainstSchema(complexJson);
        expect(errors, isEmpty);
      });
    });

    group('getMCPUISchema', () {
      test('should return valid JSON schema structure', () {
        final schema = SchemaDefinitions.getMCPUISchema();
        
        expect(schema['type'], equals('object'));
        expect(schema['required'], equals(['layout']));
        expect(schema['properties'], isNotNull);
        expect(schema['properties']['layout'], isNotNull);
        expect(schema['properties']['layout']['required'], equals(['type']));
        expect(schema['properties']['dslVersion']['type'], equals('string'));
        expect(schema['properties']['initialState']['type'], equals('object'));
        expect(schema['properties']['computedValues']['type'], equals('object'));
        expect(schema['properties']['methods']['type'], equals('object'));
        expect(schema['properties']['theme']['type'], equals('object'));
        expect(schema['properties']['metadata']['type'], equals('object'));
      });
    });

    group('allWidgetSpecs', () {
      test('should include all new widget types', () {
        final allSpecs = SchemaDefinitions.allWidgetSpecs;
        
        expect(allSpecs.containsKey(WidgetTypes.numberField), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.colorPicker), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.radioGroup), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.checkboxGroup), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.segmentedControl), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.dateField), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.timeField), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.dateRangePicker), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.scrollView), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.draggable), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.dragTarget), isTrue);
        expect(allSpecs.containsKey(WidgetTypes.conditional), isTrue);
      });

      test('should be unmodifiable', () {
        final allSpecs = SchemaDefinitions.allWidgetSpecs;
        
        expect(() {
          allSpecs['newWidget'] = {};
        }, throwsUnsupportedError);
      });
    });
  });
}