// TC-096 ~ TC-130: Input Widget Definition Tests
// Tests input widget types using the generic WidgetDefinition class
// with type string field and properties map for widget-specific data.
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // ===========================================================================
  // TC-096: Button widget definition
  // ===========================================================================
  group('TC-096: Button widget definition', () {
    test('Normal: button with primary variant and onTap action', () {
      final json = {
        'type': 'button',
        'label': 'Submit',
        'variant': 'primary',
        'disabled': false,
        'onTap': {
          'type': 'state',
          'action': 'set',
          'binding': 'formSubmitted',
          'value': true,
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('button'));
      expect(def.properties['label'], equals('Submit'));
      expect(def.properties['variant'], equals('primary'));
      expect(def.properties['disabled'], isFalse);
      expect(def.properties['onTap'], isA<Map>());
      expect(
        (def.properties['onTap'] as Map)['type'],
        equals('state'),
      );
    });

    test('Normal: button variants — secondary, outlined, text, icon', () {
      for (final variant in ['secondary', 'outlined', 'text', 'icon']) {
        final json = {
          'type': 'button',
          'label': 'Action',
          'variant': variant,
        };
        final def = WidgetDefinition.fromJson(json);
        expect(def.properties['variant'], equals(variant));
      }
    });

    test('Boundary: button with disabled binding expression', () {
      final json = {
        'type': 'button',
        'label': 'Save',
        'variant': 'primary',
        'disabled': '{{!form.isValid}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['disabled'], equals('{{!form.isValid}}'));
    });

    test('Error: button without label still parses', () {
      final json = {'type': 'button', 'variant': 'primary'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('button'));
      expect(def.properties['label'], isNull);
    });
  });

  // ===========================================================================
  // TC-097: TextInput widget definition
  // ===========================================================================
  group('TC-097: TextInput widget definition', () {
    test('Normal: textInput with binding and validation', () {
      final json = {
        'type': 'textInput',
        'label': 'Name',
        'placeholder': 'Enter name',
        'binding': '{{form.name}}',
        'required': true,
        'maxLength': 100,
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('textInput'));
      expect(def.properties['label'], equals('Name'));
      expect(def.properties['placeholder'], equals('Enter name'));
      expect(def.properties['binding'], equals('{{form.name}}'));
      expect(def.properties['required'], isTrue);
      expect(def.properties['maxLength'], equals(100));
    });

    test('Normal: textInput inputType variants', () {
      for (final inputType in ['text', 'email', 'password', 'number']) {
        final json = {
          'type': 'textInput',
          'label': 'Field',
          'inputType': inputType,
        };
        final def = WidgetDefinition.fromJson(json);
        expect(def.properties['inputType'], equals(inputType));
      }
    });

    test('Boundary: textInput with zero maxLength', () {
      final json = {
        'type': 'textInput',
        'label': 'Empty',
        'maxLength': 0,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['maxLength'], equals(0));
    });

    test('Error: textInput without label parses with null label', () {
      final json = {
        'type': 'textInput',
        'binding': '{{field}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('textInput'));
      expect(def.properties['label'], isNull);
    });
  });

  // ===========================================================================
  // TC-098: Select widget definition
  // ===========================================================================
  group('TC-098: Select widget definition', () {
    test('Normal: select with options and binding', () {
      final json = {
        'type': 'select',
        'label': 'Country',
        'options': [
          {'label': 'US', 'value': 'us'},
          {'label': 'UK', 'value': 'uk'},
          {'label': 'Korea', 'value': 'kr'},
        ],
        'binding': '{{form.country}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('select'));
      expect(def.properties['label'], equals('Country'));
      expect(def.properties['options'], isA<List>());
      expect((def.properties['options'] as List).length, equals(3));
      expect(def.properties['binding'], equals('{{form.country}}'));
    });

    test('Boundary: select with single option', () {
      final json = {
        'type': 'select',
        'options': [
          {'label': 'Only', 'value': 'only'},
        ],
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['options'] as List).length, equals(1));
    });

    test('Error: select with empty options list', () {
      final json = {
        'type': 'select',
        'label': 'Empty',
        'options': <Map<String, dynamic>>[],
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['options'] as List), isEmpty);
    });
  });

  // ===========================================================================
  // TC-099: Switch/Toggle widget definition
  // ===========================================================================
  group('TC-099: Switch widget definition', () {
    test('Normal: switch with label and binding', () {
      final json = {
        'type': 'switch',
        'label': 'Notifications',
        'binding': '{{settings.notifications}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('switch'));
      expect(def.properties['label'], equals('Notifications'));
      expect(
        def.properties['binding'],
        equals('{{settings.notifications}}'),
      );
    });

    test('Boundary: switch with initial value true', () {
      final json = {
        'type': 'switch',
        'label': 'Dark Mode',
        'binding': '{{settings.darkMode}}',
        'value': true,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['value'], isTrue);
    });

    test('Error: switch without binding still parses', () {
      final json = {'type': 'switch', 'label': 'Toggle'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('switch'));
      expect(def.properties['binding'], isNull);
    });
  });

  // ===========================================================================
  // TC-100: Slider widget definition
  // ===========================================================================
  group('TC-100: Slider widget definition', () {
    test('Normal: slider with min, max, step, and binding', () {
      final json = {
        'type': 'slider',
        'min': 0,
        'max': 100,
        'step': 5,
        'binding': '{{volume}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('slider'));
      expect(def.properties['min'], equals(0));
      expect(def.properties['max'], equals(100));
      expect(def.properties['step'], equals(5));
      expect(def.properties['binding'], equals('{{volume}}'));
    });

    test('Boundary: slider with floating point step', () {
      final json = {
        'type': 'slider',
        'min': 0.0,
        'max': 1.0,
        'step': 0.1,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['step'], equals(0.1));
    });

    test('Error: slider with negative min/max', () {
      final json = {
        'type': 'slider',
        'min': -100,
        'max': -10,
        'step': 1,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['min'], equals(-100));
      expect(def.properties['max'], equals(-10));
    });
  });

  // ===========================================================================
  // TC-101: Checkbox widget definition
  // ===========================================================================
  group('TC-101: Checkbox widget definition', () {
    test('Normal: checkbox with label and binding', () {
      final json = {
        'type': 'checkbox',
        'label': 'Accept',
        'binding': '{{accepted}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('checkbox'));
      expect(def.properties['label'], equals('Accept'));
      expect(def.properties['binding'], equals('{{accepted}}'));
    });

    test('Boundary: checkbox with initial value', () {
      final json = {
        'type': 'checkbox',
        'label': 'Agree',
        'binding': '{{agreed}}',
        'value': false,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['value'], isFalse);
    });

    test('Error: checkbox without label', () {
      final json = {'type': 'checkbox', 'binding': '{{flag}}'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('checkbox'));
      expect(def.properties['label'], isNull);
    });
  });

  // ===========================================================================
  // TC-102: NumberField widget definition
  // ===========================================================================
  group('TC-102: NumberField widget definition', () {
    test('Normal: numberField with label, min, and max', () {
      final json = {
        'type': 'numberField',
        'label': 'Quantity',
        'min': 0,
        'max': 999,
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('numberField'));
      expect(def.properties['label'], equals('Quantity'));
      expect(def.properties['min'], equals(0));
      expect(def.properties['max'], equals(999));
    });

    test('Boundary: numberField with decimal step', () {
      final json = {
        'type': 'numberField',
        'label': 'Price',
        'min': 0.0,
        'max': 10000.0,
        'step': 0.01,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['step'], equals(0.01));
    });

    test('Error: numberField with min greater than max still parses', () {
      final json = {
        'type': 'numberField',
        'min': 100,
        'max': 10,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['min'], equals(100));
      expect(def.properties['max'], equals(10));
    });
  });

  // ===========================================================================
  // TC-103: DateField widget definition
  // ===========================================================================
  group('TC-103: DateField widget definition', () {
    test('Normal: dateField with label and format', () {
      final json = {
        'type': 'dateField',
        'label': 'Birthday',
        'format': 'YYYY-MM-DD',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('dateField'));
      expect(def.properties['label'], equals('Birthday'));
      expect(def.properties['format'], equals('YYYY-MM-DD'));
    });

    test('Boundary: dateField with firstDate and lastDate constraints', () {
      final json = {
        'type': 'dateField',
        'label': 'Event',
        'format': 'YYYY-MM-DD',
        'firstDate': '2024-01-01',
        'lastDate': '2024-12-31',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['firstDate'], equals('2024-01-01'));
      expect(def.properties['lastDate'], equals('2024-12-31'));
    });

    test('Error: dateField without format still parses', () {
      final json = {'type': 'dateField', 'label': 'Date'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('dateField'));
      expect(def.properties['format'], isNull);
    });
  });

  // ===========================================================================
  // TC-104: TimeField widget definition
  // ===========================================================================
  group('TC-104: TimeField widget definition', () {
    test('Normal: timeField with label', () {
      final json = {
        'type': 'timeField',
        'label': 'Time',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('timeField'));
      expect(def.properties['label'], equals('Time'));
    });

    test('Boundary: timeField with 24-hour format', () {
      final json = {
        'type': 'timeField',
        'label': 'Alarm',
        'use24HourFormat': true,
        'format': 'HH:mm',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['use24HourFormat'], isTrue);
      expect(def.properties['format'], equals('HH:mm'));
    });

    test('Error: timeField with no properties besides type', () {
      final json = {'type': 'timeField'};
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('timeField'));
      expect(def.properties, isEmpty);
    });
  });

  // ===========================================================================
  // TC-105: RadioGroup widget definition
  // ===========================================================================
  group('TC-105: RadioGroup widget definition', () {
    test('Normal: radioGroup with options and binding', () {
      final json = {
        'type': 'radioGroup',
        'options': [
          {'label': 'Small', 'value': 'S'},
          {'label': 'Medium', 'value': 'M'},
          {'label': 'Large', 'value': 'L'},
        ],
        'binding': '{{selected}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('radioGroup'));
      expect(def.properties['options'], isA<List>());
      expect((def.properties['options'] as List).length, equals(3));
      expect(def.properties['binding'], equals('{{selected}}'));
    });

    test('Boundary: radioGroup with orientation', () {
      final json = {
        'type': 'radioGroup',
        'options': [
          {'label': 'A', 'value': 'a'},
        ],
        'orientation': 'horizontal',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['orientation'], equals('horizontal'));
    });

    test('Error: radioGroup with empty options', () {
      final json = {
        'type': 'radioGroup',
        'options': <Map<String, dynamic>>[],
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['options'] as List), isEmpty);
    });
  });

  // ===========================================================================
  // TC-106: CheckboxGroup widget definition
  // ===========================================================================
  group('TC-106: CheckboxGroup widget definition', () {
    test('Normal: checkboxGroup with options and binding', () {
      final json = {
        'type': 'checkboxGroup',
        'options': [
          {'label': 'Red', 'value': 'red'},
          {'label': 'Blue', 'value': 'blue'},
          {'label': 'Green', 'value': 'green'},
        ],
        'binding': '{{selectedItems}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('checkboxGroup'));
      expect((def.properties['options'] as List).length, equals(3));
      expect(def.properties['binding'], equals('{{selectedItems}}'));
    });

    test('Boundary: checkboxGroup with initial selected values', () {
      final json = {
        'type': 'checkboxGroup',
        'options': [
          {'label': 'A', 'value': 'a'},
          {'label': 'B', 'value': 'b'},
        ],
        'value': ['a'],
        'binding': '{{items}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['value'], equals(['a']));
    });
  });

  // ===========================================================================
  // TC-107: Radio widget definition
  // ===========================================================================
  group('TC-107: Radio widget definition', () {
    test('Normal: radio with label, value, and groupBinding', () {
      final json = {
        'type': 'radio',
        'label': 'Option A',
        'value': 'a',
        'groupBinding': '{{group}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('radio'));
      expect(def.properties['label'], equals('Option A'));
      expect(def.properties['value'], equals('a'));
      expect(def.properties['groupBinding'], equals('{{group}}'));
    });

    test('Boundary: radio with numeric value', () {
      final json = {
        'type': 'radio',
        'label': 'Option 1',
        'value': 1,
        'groupBinding': '{{selection}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['value'], equals(1));
    });
  });

  // ===========================================================================
  // TC-108: ColorPicker widget definition
  // ===========================================================================
  group('TC-108: ColorPicker widget definition', () {
    test('Normal: colorPicker with binding', () {
      final json = {
        'type': 'colorPicker',
        'binding': '{{color}}',
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('colorPicker'));
      expect(def.properties['binding'], equals('{{color}}'));
    });

    test('Boundary: colorPicker with initial value and options', () {
      final json = {
        'type': 'colorPicker',
        'binding': '{{themeColor}}',
        'value': '#FF5722',
        'showAlpha': true,
        'pickerType': 'material',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['value'], equals('#FF5722'));
      expect(def.properties['showAlpha'], isTrue);
      expect(def.properties['pickerType'], equals('material'));
    });
  });

  // ===========================================================================
  // TC-109: DateRangePicker widget definition
  // ===========================================================================
  group('TC-109: DateRangePicker widget definition', () {
    test('Normal: dateRangePicker basic creation', () {
      final json = {'type': 'dateRangePicker'};

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('dateRangePicker'));
    });

    test('Boundary: dateRangePicker with date constraints', () {
      final json = {
        'type': 'dateRangePicker',
        'startDate': '2024-01-01',
        'endDate': '2024-06-30',
        'firstDate': '2023-01-01',
        'lastDate': '2025-12-31',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['startDate'], equals('2024-01-01'));
      expect(def.properties['endDate'], equals('2024-06-30'));
    });
  });

  // ===========================================================================
  // TC-110: SegmentedControl widget definition
  // ===========================================================================
  group('TC-110: SegmentedControl widget definition', () {
    test('Normal: segmentedControl with options', () {
      final json = {
        'type': 'segmentedControl',
        'options': [
          {'label': 'Day', 'value': 'day'},
          {'label': 'Week', 'value': 'week'},
          {'label': 'Month', 'value': 'month'},
        ],
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('segmentedControl'));
      expect((def.properties['options'] as List).length, equals(3));
    });

    test('Boundary: segmentedControl with selected value', () {
      final json = {
        'type': 'segmentedControl',
        'options': [
          {'label': 'A', 'value': 'a'},
          {'label': 'B', 'value': 'b'},
        ],
        'value': 'b',
        'binding': '{{mode}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['value'], equals('b'));
    });
  });

  // ===========================================================================
  // TC-111: RangeSlider widget definition
  // ===========================================================================
  group('TC-111: RangeSlider widget definition', () {
    test('Normal: rangeSlider with min and max', () {
      final json = {
        'type': 'rangeSlider',
        'min': 0,
        'max': 100,
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('rangeSlider'));
      expect(def.properties['min'], equals(0));
      expect(def.properties['max'], equals(100));
    });

    test('Boundary: rangeSlider with start and end values', () {
      final json = {
        'type': 'rangeSlider',
        'min': 0,
        'max': 1000,
        'startValue': 200,
        'endValue': 800,
        'step': 50,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['startValue'], equals(200));
      expect(def.properties['endValue'], equals(800));
    });
  });

  // ===========================================================================
  // TC-112: IconButton widget definition
  // ===========================================================================
  group('TC-112: IconButton widget definition', () {
    test('Normal: iconButton with icon and onTap', () {
      final json = {
        'type': 'iconButton',
        'icon': 'add',
        'onTap': {
          'type': 'state',
          'action': 'increment',
          'binding': 'counter',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('iconButton'));
      expect(def.properties['icon'], equals('add'));
      expect(def.properties['onTap'], isA<Map>());
    });

    test('Boundary: iconButton with tooltip and size', () {
      final json = {
        'type': 'iconButton',
        'icon': 'delete',
        'tooltip': 'Delete item',
        'size': 24.0,
        'color': '#FF0000',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['tooltip'], equals('Delete item'));
      expect(def.properties['size'], equals(24.0));
    });
  });

  // ===========================================================================
  // TC-113: Form widget definition
  // ===========================================================================
  group('TC-113: Form widget definition', () {
    test('Normal: form with children and on-submit', () {
      final json = {
        'type': 'form',
        'children': [
          {'type': 'textInput', 'label': 'Name', 'binding': '{{name}}'},
          {'type': 'textInput', 'label': 'Email', 'binding': '{{email}}'},
        ],
        'on-submit': {
          'type': 'api',
          'method': 'POST',
          'url': '/api/submit',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('form'));
      expect(def.children, hasLength(2));
      expect(def.children![0].type, equals('textInput'));
      expect(def.properties['on-submit'], isA<Map>());
    });

    test('Boundary: form with nested form fields', () {
      final json = {
        'type': 'form',
        'children': [
          {
            'type': 'textFormField',
            'label': 'Username',
            'validator': {'required': true, 'minLength': 3},
          },
        ],
        'autovalidate': true,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.children, hasLength(1));
      expect(def.properties['autovalidate'], isTrue);
    });

    test('Error: form with empty children', () {
      final json = {
        'type': 'form',
        'children': <Map<String, dynamic>>[],
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.children, isEmpty);
    });
  });

  // ===========================================================================
  // TC-114: TextFormField widget definition
  // ===========================================================================
  group('TC-114: TextFormField widget definition', () {
    test('Normal: textFormField with validator', () {
      final json = {
        'type': 'textFormField',
        'validator': {
          'required': true,
          'minLength': 2,
          'maxLength': 50,
          'pattern': r'^[a-zA-Z]+$',
        },
      };

      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('textFormField'));
      expect(def.properties['validator'], isA<Map>());
      expect(
        (def.properties['validator'] as Map)['required'],
        isTrue,
      );
    });

    test('Boundary: textFormField with custom error messages', () {
      final json = {
        'type': 'textFormField',
        'label': 'Email',
        'validator': {
          'required': true,
          'pattern': r'^[\w-]+@[\w-]+\.\w+$',
          'message': 'Enter a valid email',
        },
      };
      final def = WidgetDefinition.fromJson(json);
      expect(
        (def.properties['validator'] as Map)['message'],
        equals('Enter a valid email'),
      );
    });
  });

  // ===========================================================================
  // TC-115 ~ TC-120: v1.1 widget types — basic fromJson/toJson roundtrip
  // ===========================================================================
  group('TC-115: DatePicker (v1.1) roundtrip', () {
    test('Normal: datePicker fromJson/toJson roundtrip', () {
      final json = {
        'type': 'datePicker',
        'label': 'Select Date',
        'mode': 'calendar',
      };
      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('datePicker'));
      expect(restored.properties['label'], equals('Select Date'));
      expect(restored.properties['mode'], equals('calendar'));
    });
  });

  group('TC-116: TimePicker (v1.1) roundtrip', () {
    test('Normal: timePicker fromJson/toJson roundtrip', () {
      final json = {
        'type': 'timePicker',
        'label': 'Select Time',
        'use24HourFormat': false,
      };
      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('timePicker'));
      expect(restored.properties['use24HourFormat'], isFalse);
    });
  });

  group('TC-117: Stepper (v1.1) roundtrip', () {
    test('Normal: stepper fromJson/toJson roundtrip', () {
      final json = {
        'type': 'stepper',
        'currentStep': 0,
        'children': [
          {'type': 'text', 'content': 'Step 1'},
          {'type': 'text', 'content': 'Step 2'},
        ],
      };
      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('stepper'));
      expect(restored.properties['currentStep'], equals(0));
      expect(restored.children, hasLength(2));
    });
  });

  group('TC-118: NumberStepper (v1.1) roundtrip', () {
    test('Normal: numberStepper fromJson/toJson roundtrip', () {
      final json = {
        'type': 'numberStepper',
        'min': 0,
        'max': 10,
        'step': 1,
        'value': 5,
      };
      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('numberStepper'));
      expect(restored.properties['value'], equals(5));
      expect(restored.properties['min'], equals(0));
    });
  });

  group('TC-119: Rating (v1.1) roundtrip', () {
    test('Normal: rating fromJson/toJson roundtrip', () {
      final json = {
        'type': 'rating',
        'maxRating': 5,
        'value': 3.5,
        'allowHalf': true,
      };
      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('rating'));
      expect(restored.properties['value'], equals(3.5));
      expect(restored.properties['allowHalf'], isTrue);
    });
  });

  group('TC-120: PopupMenuButton (v1.1) roundtrip', () {
    test('Normal: popupMenuButton fromJson/toJson roundtrip', () {
      final json = {
        'type': 'popupMenuButton',
        'items': [
          {'label': 'Edit', 'value': 'edit'},
          {'label': 'Delete', 'value': 'delete'},
        ],
        'icon': 'more_vert',
      };
      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals('popupMenuButton'));
      expect((restored.properties['items'] as List).length, equals(2));
    });
  });

  // ===========================================================================
  // TC-121 ~ TC-130: Boundary/edge cases for input widgets
  // ===========================================================================
  group('TC-121: Empty options list for select/radioGroup', () {
    test('Boundary: select with empty options', () {
      final json = {
        'type': 'select',
        'options': <Map<String, dynamic>>[],
        'binding': '{{choice}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['options'] as List), isEmpty);
    });

    test('Boundary: radioGroup with empty options', () {
      final json = {
        'type': 'radioGroup',
        'options': <Map<String, dynamic>>[],
        'binding': '{{choice}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect((def.properties['options'] as List), isEmpty);
    });
  });

  group('TC-122: Missing binding for input widget', () {
    test('Boundary: textInput without binding still creates valid definition', () {
      final json = {
        'type': 'textInput',
        'label': 'No Binding',
        'placeholder': 'Enter something',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.type, equals('textInput'));
      expect(def.properties['binding'], isNull);
      expect(def.properties['label'], equals('No Binding'));
    });
  });

  group('TC-123: Negative min/max for slider', () {
    test('Boundary: slider with negative range', () {
      final json = {
        'type': 'slider',
        'min': -50,
        'max': -10,
        'step': 1,
        'binding': '{{temperature}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['min'], equals(-50));
      expect(def.properties['max'], equals(-10));
    });

    test('Boundary: slider with range crossing zero', () {
      final json = {
        'type': 'slider',
        'min': -100,
        'max': 100,
        'step': 10,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['min'], equals(-100));
      expect(def.properties['max'], equals(100));
    });
  });

  group('TC-124: Input with validation rules', () {
    test('Boundary: textInput with multiple validation rules', () {
      final json = {
        'type': 'textInput',
        'label': 'Username',
        'binding': '{{username}}',
        'validation': {
          'required': true,
          'minLength': 3,
          'maxLength': 20,
          'pattern': r'^[a-zA-Z0-9_]+$',
          'message': 'Username must be 3-20 alphanumeric characters',
        },
      };
      final def = WidgetDefinition.fromJson(json);
      final validation = def.properties['validation'] as Map;
      expect(validation['required'], isTrue);
      expect(validation['minLength'], equals(3));
      expect(validation['maxLength'], equals(20));
    });
  });

  group('TC-125: Input with on-change event handler', () {
    test('Boundary: textInput with on-change action', () {
      final json = {
        'type': 'textInput',
        'label': 'Search',
        'binding': '{{query}}',
        'on-change': {
          'type': 'api',
          'method': 'GET',
          'url': '/api/search',
          'params': {'q': '{{value}}'},
        },
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['on-change'], isA<Map>());
      expect(
        (def.properties['on-change'] as Map)['type'],
        equals('api'),
      );
    });
  });

  group('TC-126: Input with disabled=true', () {
    test('Boundary: textInput with disabled flag', () {
      final json = {
        'type': 'textInput',
        'label': 'Read Only',
        'binding': '{{readonlyField}}',
        'disabled': true,
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['disabled'], isTrue);
    });

    test('Boundary: button disabled via binding expression', () {
      final json = {
        'type': 'button',
        'label': 'Submit',
        'disabled': '{{!isValid}}',
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.properties['disabled'], equals('{{!isValid}}'));
    });
  });

  group('TC-127: Input toJson then fromJson roundtrip', () {
    test('Boundary: complex input widget survives roundtrip', () {
      final json = {
        'type': 'textInput',
        'label': 'Full Name',
        'placeholder': 'John Doe',
        'binding': '{{profile.name}}',
        'required': true,
        'maxLength': 100,
        'inputType': 'text',
        'on-change': {
          'type': 'state',
          'action': 'set',
          'binding': 'dirty',
          'value': true,
        },
      };

      final def = WidgetDefinition.fromJson(json);
      final output = def.toJson();
      final restored = WidgetDefinition.fromJson(output);

      expect(restored.type, equals(def.type));
      expect(restored.properties['label'], equals(def.properties['label']));
      expect(
        restored.properties['binding'],
        equals(def.properties['binding']),
      );
      expect(
        restored.properties['required'],
        equals(def.properties['required']),
      );
      expect(
        restored.properties['maxLength'],
        equals(def.properties['maxLength']),
      );
      expect(
        restored.properties['on-change'],
        equals(def.properties['on-change']),
      );
    });
  });

  group('TC-128: Input copyWith modifications', () {
    test('Boundary: copyWith changes type and preserves properties', () {
      final original = WidgetDefinition.fromJson({
        'type': 'textInput',
        'label': 'Name',
        'binding': '{{name}}',
      });

      final modified = original.copyWith(
        type: 'textFormField',
        properties: {
          ...original.properties,
          'validator': {'required': true},
        },
      );

      expect(modified.type, equals('textFormField'));
      expect(modified.properties['label'], equals('Name'));
      expect(modified.properties['validator'], isA<Map>());
    });

    test('Boundary: copyWith preserves unmodified fields', () {
      final original = WidgetDefinition.fromJson({
        'type': 'slider',
        'key': 'vol',
        'min': 0,
        'max': 100,
        'visible': true,
      });

      final modified = original.copyWith(
        properties: {...original.properties, 'step': 5},
      );

      expect(modified.type, equals('slider'));
      expect(modified.key, equals('vol'));
      expect(modified.visible, isTrue);
      expect(modified.properties['step'], equals(5));
    });
  });

  group('TC-129: Input with accessibility config', () {
    test('Boundary: textInput with accessibility', () {
      final json = {
        'type': 'textInput',
        'label': 'Email',
        'binding': '{{email}}',
        'accessibility': {
          'semanticLabel': 'Email input field',
          'role': 'textField',
          'hint': 'Enter your email address',
        },
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.accessibility, isNotNull);
      expect(
        def.accessibility!.semanticLabel,
        equals('Email input field'),
      );
    });

    test('Boundary: button with accessibility role', () {
      final json = {
        'type': 'button',
        'label': 'Submit',
        'accessibility': {
          'semanticLabel': 'Submit form button',
          'role': 'button',
        },
      };
      final def = WidgetDefinition.fromJson(json);
      expect(def.accessibility, isNotNull);
      expect(
        def.accessibility!.semanticLabel,
        equals('Submit form button'),
      );
    });
  });

  group('TC-130: Input with all optional fields omitted', () {
    test('Boundary: minimal button definition', () {
      final json = {'type': 'button'};
      final def = WidgetDefinition.fromJson(json);

      expect(def.type, equals('button'));
      expect(def.visible, isNull);
      expect(def.visibleExpression, isNull);
      expect(def.key, isNull);
      expect(def.testKey, isNull);
      expect(def.children, isNull);
      expect(def.child, isNull);
      expect(def.accessibility, isNull);
      expect(def.i18n, isNull);
      expect(def.metadata, isEmpty);
      expect(def.properties, isEmpty);
    });

    test('Boundary: minimal textInput definition', () {
      final json = {'type': 'textInput'};
      final def = WidgetDefinition.fromJson(json);

      expect(def.type, equals('textInput'));
      expect(def.properties, isEmpty);
    });

    test('Boundary: minimal slider definition', () {
      final json = {'type': 'slider'};
      final def = WidgetDefinition.fromJson(json);

      expect(def.type, equals('slider'));
      expect(def.properties['min'], isNull);
      expect(def.properties['max'], isNull);
    });
  });
}
