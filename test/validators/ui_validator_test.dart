import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('UIValidator', () {
    group('New Widget Type Validation', () {
      test('should validate number field widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.numberField,
          properties: {
            'label': 'Age',
            'value': 25.0,
            'min': 0.0,
            'max': 100.0,
            'step': 1.0,
            'bindTo': 'user.age'
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate color picker widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.colorPicker,
          properties: {
            'value': '#FF5722',
            'showAlpha': false,
            'pickerType': 'wheel',
            'onChange': ActionConfig.state(
              action: 'set',
              binding: 'theme.primaryColor',
              value: '{{value}}'
            ).toJson()
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate radio group widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.radioGroup,
          properties: {
            'value': 'option1',
            'options': [
              {'label': 'Option 1', 'value': 'option1'},
              {'label': 'Option 2', 'value': 'option2'},
              {'label': 'Option 3', 'value': 'option3'},
            ],
            'orientation': 'horizontal',
            'bindTo': 'selectedOption'
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate checkbox group widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.checkboxGroup,
          properties: {
            'value': ['option1', 'option3'],
            'options': [
              {'label': 'Feature A', 'value': 'option1'},
              {'label': 'Feature B', 'value': 'option2'},
              {'label': 'Feature C', 'value': 'option3'},
            ],
            'onChange': ActionConfig.state(
              action: 'set',
              binding: 'selectedFeatures',
              value: '{{value}}'
            ).toJson()
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate segmented control widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.segmentedControl,
          properties: {
            'value': 'tab1',
            'options': [
              {'label': 'Tab 1', 'value': 'tab1'},
              {'label': 'Tab 2', 'value': 'tab2'},
              {'label': 'Tab 3', 'value': 'tab3'},
            ],
            'style': 'cupertino',
            'bindTo': 'activeTab'
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate date field widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dateField,
          properties: {
            'label': 'Select Date',
            'value': '2024-01-15',
            'format': 'dd/MM/yyyy',
            'firstDate': '2020-01-01',
            'lastDate': '2030-12-31',
            'mode': 'input',
            'locale': 'en_GB',
            'bindTo': 'selectedDate'
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate time field widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.timeField,
          properties: {
            'label': 'Select Time',
            'value': '14:30',
            'format': 'h:mm a',
            'use24HourFormat': false,
            'mode': 'dial',
            'bindTo': 'selectedTime'
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate date range picker widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dateRangePicker,
          properties: {
            'startDate': '2024-01-01',
            'endDate': '2024-01-31',
            'firstDate': '2020-01-01',
            'lastDate': '2030-12-31',
            'format': 'MMM dd, yyyy',
            'locale': 'en_US',
            'saveText': 'Apply',
            'onChange': ActionConfig.batch([
              ActionConfig.state(action: 'set', binding: 'startDate', value: '{{startDate}}'),
              ActionConfig.state(action: 'set', binding: 'endDate', value: '{{endDate}}'),
            ]).toJson()
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate scroll view widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.scrollView,
          properties: {
            'scrollDirection': 'horizontal',
            'physics': 'never',
            'padding': {'all': 16.0},
            'reverse': false,
            'shrinkWrap': true
          },
          children: [
            WidgetConfig(
              type: WidgetTypes.container,
              properties: {'width': 200.0, 'height': 100.0}
            ),
          ],
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate draggable widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.draggable,
          properties: {
            'data': 'item_1',
            'feedback': {
              'type': 'container',
              'properties': {
                'color': '#80000000',
                'padding': {'all': 8.0}
              },
              'children': [
                {
                  'type': 'text',
                  'properties': {'content': 'Dragging...'}
                }
              ]
            },
            'axis': 'vertical',
            'maxSimultaneousDrags': 1
          },
          children: [
            WidgetConfig(
              type: WidgetTypes.text,
              properties: {'content': 'Drag me'}
            ),
          ],
        );

        final result = UIValidator.validateWidget(widget);
        if (!result.isValid) {
          print('Draggable validation errors: ${result.errors.map((e) => e.message).join(', ')}');
        }
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate drag target widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dragTarget,
          properties: {
            'onAccept': ActionConfig.state(
              action: 'set',
              binding: 'droppedItem',
              value: '{{data}}'
            ).toJson(),
            'onWillAccept': 'return data != null;',
            'builder': {
              'type': 'container',
              'properties': {
                'color': '{{candidateData != null ? "#FFE0E0E0" : "#FFFFFFFF"}}',
                'padding': {'all': 16.0}
              },
              'children': [
                {
                  'type': 'text',
                  'properties': {'content': 'Drop here'}
                }
              ]
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate conditional widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.conditional,
          properties: {
            'condition': '{{user.isLoggedIn}}',
            'trueChild': {
              'type': 'text',
              'properties': {'content': 'Welcome, {{user.name}}!'}
            },
            'falseChild': {
              'type': 'button',
              'properties': {
                'label': 'Login',
                'onTap': ActionConfig.navigation(
                  action: 'push',
                  route: '/login'
                ).toJson()
              }
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });
    });

    group('Required Property Validation for New Widgets', () {
      test('should fail when radio group missing required options', () {
        final widget = WidgetConfig(
          type: WidgetTypes.radioGroup,
          properties: {
            'value': 'option1',
            'orientation': 'vertical'
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('options')), isTrue);
      });

      test('should fail when checkbox group missing required options', () {
        final widget = WidgetConfig(
          type: WidgetTypes.checkboxGroup,
          properties: {
            'value': [],
            'bindTo': 'selections'
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('options')), isTrue);
      });

      test('should fail when draggable missing required properties', () {
        final widget = WidgetConfig(
          type: WidgetTypes.draggable,
          properties: {
            'axis': 'horizontal'
          },
          children: [
            WidgetConfig(type: WidgetTypes.text, properties: {'content': 'Drag me'})
          ],
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('data')), isTrue);
        expect(result.errors.any((e) => e.message.contains('feedback')), isTrue);
      });

      test('should fail when conditional missing required condition', () {
        final widget = WidgetConfig(
          type: WidgetTypes.conditional,
          properties: {
            'trueChild': {'type': 'text', 'properties': {'content': 'True'}},
            'falseChild': {'type': 'text', 'properties': {'content': 'False'}}
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('condition')), isTrue);
      });
    });

    group('Complex UI Definition Validation with New Widgets', () {
      test('should validate complete form with new input widgets', () {
        final uiDefinition = UIDefinition(
          layout: WidgetConfig(
            type: WidgetTypes.form,
            children: [
              WidgetConfig(
                type: WidgetTypes.textField,
                properties: {
                  'label': 'Name',
                  'bindTo': 'formData.name',
                  'hintText': 'Enter your full name'
                }
              ),
              WidgetConfig(
                type: WidgetTypes.numberField,
                properties: {
                  'label': 'Age',
                  'bindTo': 'formData.age',
                  'min': 18.0,
                  'max': 120.0,
                  'step': 1.0
                }
              ),
              WidgetConfig(
                type: WidgetTypes.dateField,
                properties: {
                  'label': 'Birth Date',
                  'bindTo': 'formData.birthDate',
                  'lastDate': DateTime.now().toIso8601String().split('T')[0]
                }
              ),
              WidgetConfig(
                type: WidgetTypes.colorPicker,
                properties: {
                  'bindTo': 'formData.favoriteColor',
                  'showLabel': true
                }
              ),
              WidgetConfig(
                type: WidgetTypes.radioGroup,
                properties: {
                  'bindTo': 'formData.gender',
                  'options': [
                    {'label': 'Male', 'value': 'male'},
                    {'label': 'Female', 'value': 'female'},
                    {'label': 'Other', 'value': 'other'}
                  ]
                }
              ),
              WidgetConfig(
                type: WidgetTypes.checkboxGroup,
                properties: {
                  'bindTo': 'formData.interests',
                  'options': [
                    {'label': 'Sports', 'value': 'sports'},
                    {'label': 'Music', 'value': 'music'},
                    {'label': 'Art', 'value': 'art'},
                    {'label': 'Technology', 'value': 'tech'}
                  ]
                }
              ),
              WidgetConfig(
                type: WidgetTypes.button,
                properties: {
                  'label': 'Submit',
                  'onTap': ActionConfig.tool('submitForm', {
                    'data': '{{formData}}'
                  }).toJson()
                }
              )
            ],
          ),
          initialState: {
            'formData': {
              'name': '',
              'age': 18,
              'birthDate': null,
              'favoriteColor': '#2196F3',
              'gender': null,
              'interests': []
            }
          },
          dslVersion: '1.0.0',
        );

        final result = UIValidator.validateUIDefinition(uiDefinition);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate interactive drag and drop UI', () {
        final uiDefinition = UIDefinition(
          layout: WidgetConfig(
            type: WidgetTypes.row,
            children: [
              WidgetConfig(
                type: WidgetTypes.expanded,
                properties: {'flex': 1},
                children: [
                  WidgetConfig(
                    type: WidgetTypes.column,
                    children: List.generate(3, (i) => WidgetConfig(
                  type: WidgetTypes.draggable,
                  properties: {
                    'data': 'item_$i',
                    'feedback': {
                      'type': 'card',
                      'properties': {'elevation': 8.0},
                      'children': [
                        {
                          'type': 'text',
                          'properties': {'content': 'Item $i'}
                        }
                      ]
                    }
                  },
                  children: [
                    WidgetConfig(
                      type: WidgetTypes.card,
                      children: [
                        WidgetConfig(
                          type: WidgetTypes.listTile,
                          properties: {
                            'title': 'Item $i',
                            'subtitle': 'Drag me'
                          }
                        )
                      ]
                    )
                  ]
                ))
                  )
                ]
              ),
              WidgetConfig(
                type: WidgetTypes.dragTarget,
                properties: {
                  'builder': {
                    'type': 'container',
                    'properties': {
                      'width': 200.0,
                      'height': 400.0,
                      'color': '#FFE0E0E0',
                      'padding': {'all': 16.0}
                    },
                    'children': [
                      {
                        'type': 'text',
                        'properties': {'content': 'Drop items here'}
                      }
                    ]
                  },
                  'onAccept': ActionConfig.state(
                    action: 'add',
                    binding: 'droppedItems',
                    value: '{{data}}'
                  ).toJson()
                }
              )
            ],
          ),
          initialState: {
            'droppedItems': []
          },
          dslVersion: '1.0.0',
        );

        final result = UIValidator.validateUIDefinition(uiDefinition);
        if (!result.isValid) {
          print('Drag and drop validation errors: ${result.errors.map((e) => e.message).join(', ')}');
        }
        expect(result.isValid, isTrue);
        // The 'data' binding in dragTarget generates a warning since it's dynamic
        expect(result.criticalErrors, isEmpty);
      });

      test('should validate conditional UI with authentication flow', () {
        final uiDefinition = UIDefinition(
          layout: WidgetConfig(
            type: WidgetTypes.conditional,
            properties: {
              'condition': '{{isAuthenticated}}',
              'trueChild': {
                'type': 'column',
                'children': [
                  {
                    'type': 'text',
                    'properties': {
                      'content': 'Welcome back, {{user.name}}!',
                      'style': {'fontSize': 24.0}
                    }
                  },
                  {
                    'type': 'segmentedcontrol',
                    'properties': {
                      'bindTo': 'activeSection',
                      'options': [
                        {'label': 'Profile', 'value': 'profile'},
                        {'label': 'Settings', 'value': 'settings'},
                        {'label': 'Activity', 'value': 'activity'}
                      ]
                    }
                  },
                  {
                    'type': 'conditional',
                    'properties': {
                      'condition': '{{activeSection == "profile"}}',
                      'child': {
                        'type': 'column',
                        'children': [
                          {
                            'type': 'colorpicker',
                            'properties': {
                              'bindTo': 'user.themeColor',
                              'showLabel': true
                            }
                          },
                          {
                            'type': 'datefield',
                            'properties': {
                              'label': 'Member since',
                              'value': '{{user.joinDate}}',
                              'enabled': false
                            }
                          }
                        ]
                      }
                    }
                  }
                ]
              },
              'falseChild': {
                'type': 'center',
                'children': [
                  {
                    'type': 'card',
                    'properties': {
                      'padding': {'all': 24.0}
                    },
                    'children': [
                      {
                        'type': 'text',
                        'properties': {
                          'content': 'Please log in to continue',
                          'style': {'fontSize': 18.0}
                        }
                      },
                      {
                        'type': 'button',
                        'properties': {
                          'label': 'Login',
                          'onTap': ActionConfig.navigation(
                            action: 'push',
                            route: '/login'
                          ).toJson()
                        }
                      }
                    ]
                  }
                ]
              }
            }
          ),
          initialState: {
            'isAuthenticated': false,
            'activeSection': 'profile',
            'user': {
              'name': null,
              'joinDate': null,
              'themeColor': '#2196F3'
            }
          },
          dslVersion: '1.0.0',
        );

        final result = UIValidator.validateUIDefinition(uiDefinition);
        expect(result.isValid, isTrue);
        // The condition expression might generate a warning, but that's OK
        expect(result.criticalErrors, isEmpty);
      });
    });

    group('Binding Validation for New Widgets', () {
      test('should validate bindings for all new input widgets', () {
        final uiDefinition = UIDefinition(
          layout: WidgetConfig(
            type: WidgetTypes.column,
            children: [
              WidgetConfig(
                type: WidgetTypes.numberField,
                properties: {'bindTo': 'values.number'}
              ),
              WidgetConfig(
                type: WidgetTypes.colorPicker,
                properties: {'bindTo': 'values.color'}
              ),
              WidgetConfig(
                type: WidgetTypes.radioGroup,
                properties: {
                  'bindTo': 'values.radio',
                  'options': [{'label': 'A', 'value': 'a'}]
                }
              ),
              WidgetConfig(
                type: WidgetTypes.checkboxGroup,
                properties: {
                  'bindTo': 'values.checkboxes',
                  'options': [{'label': 'A', 'value': 'a'}]
                }
              ),
              WidgetConfig(
                type: WidgetTypes.segmentedControl,
                properties: {
                  'bindTo': 'values.segment',
                  'options': [{'label': 'A', 'value': 'a'}]
                }
              ),
              WidgetConfig(
                type: WidgetTypes.dateField,
                properties: {'bindTo': 'values.date'}
              ),
              WidgetConfig(
                type: WidgetTypes.timeField,
                properties: {'bindTo': 'values.time'}
              ),
            ],
          ),
          initialState: {
            'values': {
              'number': 0,
              'color': '#000000',
              'radio': null,
              'checkboxes': [],
              'segment': null,
              'date': null,
              'time': null
            }
          },
          dslVersion: '1.0.0',
        );

        final result = UIValidator.validateUIDefinition(uiDefinition);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should detect invalid bindings for new widgets', () {
        final uiDefinition = UIDefinition(
          layout: WidgetConfig(
            type: WidgetTypes.column,
            children: [
              WidgetConfig(
                type: WidgetTypes.numberField,
                properties: {
                  'value': '{{nonexistent.value}}',
                  'onChange': {
                    'type': 'state',
                    'action': 'set',
                    'binding': 'nonexistent.value',
                    'value': '{{event.value}}'
                  }
                }
              ),
              WidgetConfig(
                type: WidgetTypes.colorPicker,
                properties: {
                  'value': '{{another.missing.path}}',
                  'onChange': {
                    'type': 'state',
                    'action': 'set',
                    'binding': 'another.missing.path',
                    'value': '{{event.value}}'
                  }
                }
              ),
            ],
          ),
          initialState: {
            'existingValue': 42
          },
          dslVersion: '1.0.0',
        );

        final result = UIValidator.validateUIDefinition(uiDefinition);
        // Missing bindings generate warnings, not errors
        expect(result.hasWarnings, isTrue);
        expect(result.warnings.any((w) => w.message.contains('nonexistent.value')), isTrue);
        expect(result.warnings.any((w) => w.message.contains('another.missing.path')), isTrue);
      });
    });

    group('Action Validation for New Widgets', () {
      test('should validate onChange actions for new input widgets', () {
        final widget = WidgetConfig(
          type: WidgetTypes.numberField,
          properties: {
            'onChange': ActionConfig.conditional(
              condition: '{{value > 100}}',
              thenAction: ActionConfig.state(
                action: 'set',
                binding: 'warnings.highValue',
                value: true
              ),
              elseAction: ActionConfig.state(
                action: 'set',
                binding: 'warnings.highValue',
                value: false
              )
            ).toJson()
          }
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
      });

      test('should validate complex date range picker actions', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dateRangePicker,
          properties: {
            'onChange': ActionConfig.batch([
              ActionConfig.state(
                action: 'set',
                binding: 'dateRange.start',
                value: '{{startDate}}'
              ),
              ActionConfig.state(
                action: 'set',
                binding: 'dateRange.end',
                value: '{{endDate}}'
              ),
              ActionConfig.tool('calculateDuration', {
                'start': '{{startDate}}',
                'end': '{{endDate}}'
              })
            ]).toJson()
          }
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
      });
    });
  });
}