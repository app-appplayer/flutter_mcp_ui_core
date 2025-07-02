import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('UIValidator', () {
    group('Application Validation', () {
      test('should validate valid application configuration', () {
        final appConfig = ApplicationConfig(
          title: 'My App',
          version: '1.0.0',
          routes: {
            '/': 'ui://pages/home',
            '/profile': 'ui://pages/profile',
            '/settings': 'ui://pages/settings',
          },
          initialRoute: '/',
          theme: {
            'primaryColor': '#2196F3',
            'secondaryColor': '#FF5722',
          },
          navigation: {
            'type': 'bottom',
            'items': [
              {'title': 'Home', 'route': '/', 'icon': 'home'},
              {'title': 'Profile', 'route': '/profile', 'icon': 'person'},
              {'title': 'Settings', 'route': '/settings', 'icon': 'settings'},
            ],
          },
          state: {
            'initial': {
              'user': null,
              'theme': 'light',
            }
          },
        );

        final result = UIValidator.validateApplicationConfig(appConfig);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should detect missing required fields in application', () {
        final appConfig = ApplicationConfig(
          title: '',  // Empty title
          version: '',  // Empty version
          routes: {},  // Empty routes
          initialRoute: '/home',  // Route not in routes map
        );

        final result = UIValidator.validateApplicationConfig(appConfig);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.path?.contains('title') ?? false), isTrue);
        expect(result.errors.any((e) => e.path?.contains('version') ?? false), isTrue);
        expect(result.errors.any((e) => e.path?.contains('routes') ?? false), isTrue);
        expect(result.errors.any((e) => e.path?.contains('initialRoute') ?? false), isTrue);
      });

      test('should validate navigation configuration', () {
        final appConfig = ApplicationConfig(
          title: 'Test App',
          version: '1.0.0',
          routes: {'/': 'ui://pages/home'},
          navigation: {
            'type': 'invalid',  // Invalid navigation type
            'items': [],  // Empty items
          },
        );

        final result = UIValidator.validateApplicationConfig(appConfig);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('drawer, tabs, bottom')), isTrue);
      });
    });

    group('Page Validation', () {
      test('should validate valid page configuration', () {
        final pageConfig = PageConfig(
          title: 'Home Page',
          route: '/home',
          content: {
            'type': 'linear',
            'direction': 'vertical',
            'children': [
              {
                'type': 'text',
                'content': 'Welcome to Home Page',
              },
              {
                'type': 'button',
                'label': 'Click Me',
                'onTap': {
                  'type': 'state',
                  'action': 'set',
                  'binding': 'clicked',
                  'value': true,
                },
              },
            ],
          },
          state: {
            'initial': {
              'clicked': false,
            }
          },
        );

        final result = UIValidator.validatePageConfig(pageConfig);
        if (!result.isValid) {
          print('Page validation errors:');
          for (final error in result.errors) {
            print('  - ${error.message} (${error.path ?? "no path"})');
          }
        }
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should validate page with theme override', () {
        final pageConfig = PageConfig(
          title: 'Settings',
          content: {
            'type': 'text',
            'content': 'Settings Page',
          },
          themeOverride: {
            'primaryColor': '#FF5722',
            'backgroundColor': '#FFFFFF',
          },
        );

        final result = UIValidator.validatePageConfig(pageConfig);
        expect(result.isValid, isTrue);
      });
    });

    group('JSON Validation', () {
      test('should validate application JSON', () {
        final json = {
          'type': 'application',
          'title': 'My App',
          'version': '1.0.0',
          'routes': {
            '/': 'ui://pages/home',
          },
        };

        final result = UIValidator.validateJson(json);
        expect(result.isValid, isTrue);
      });

      test('should validate page JSON', () {
        final json = {
          'type': 'page',
          'title': 'Home',
          'content': {
            'type': 'text',
            'content': 'Hello World',
          },
        };

        final result = UIValidator.validateJson(json);
        expect(result.isValid, isTrue);
      });

      test('should validate widget JSON', () {
        final json = {
          'type': 'button',
          'label': 'Click Me',
        };

        final result = UIValidator.validateJson(json);
        expect(result.isValid, isTrue);
      });

      test('should reject unknown structure', () {
        final json = {
          'type': 'unknown',
          'data': 'test',
        };

        final result = UIValidator.validateJson(json);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.code == 'UNKNOWN_STRUCTURE'), isTrue);
      });

      test('should handle malformed JSON gracefully', () {
        final json = {
          'type': 'application',
          'title': 123,  // Wrong type
          'routes': 'not a map',  // Wrong type
        };

        final result = UIValidator.validateJson(json);
        expect(result.isValid, isFalse);
      });
    });

    group('Widget Validation', () {
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
            'orientation': 'vertical',
            'onChange': {
              'type': 'state',
              'action': 'set',
              'binding': 'selectedOption',
              'value': '{{event.value}}'
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
      });

      test('should validate checkbox group widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.checkboxGroup,
          properties: {
            'value': ['option1', 'option3'],
            'options': [
              {'label': 'Option 1', 'value': 'option1'},
              {'label': 'Option 2', 'value': 'option2'},
              {'label': 'Option 3', 'value': 'option3'},
            ],
            'orientation': 'horizontal',
            'onChange': {
              'type': 'state',
              'action': 'set',
              'binding': 'selectedOptions',
              'value': '{{event.value}}'
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
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
            'onChange': {
              'type': 'state',
              'action': 'set',
              'binding': 'activeTab',
              'value': '{{event.value}}'
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
      });

      test('should validate date field widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dateField,
          properties: {
            'label': 'Select Date',
            'value': '2024-01-15',
            'format': 'yyyy-MM-dd',
            'firstDate': '2020-01-01',
            'lastDate': '2030-12-31',
            'onChange': {
              'type': 'state',
              'action': 'set',
              'binding': 'selectedDate',
              'value': '{{event.value}}'
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
      });

      test('should validate time field widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.timeField,
          properties: {
            'label': 'Select Time',
            'value': '14:30',
            'format': 'HH:mm',
            'use24HourFormat': true,
            'onChange': {
              'type': 'state',
              'action': 'set',
              'binding': 'selectedTime',
              'value': '{{event.value}}'
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
      });

      test('should validate date range picker widget', () {
        final widget = WidgetConfig(
          type: WidgetTypes.dateRangePicker,
          properties: {
            'label': 'Select Date Range',
            'startDate': '2024-01-01',
            'endDate': '2024-01-31',
            'format': 'yyyy-MM-dd',
            'onChange': {
              'type': 'batch',
              'actions': [
                {
                  'type': 'state',
                  'action': 'set',
                  'binding': 'dateRange.start',
                  'value': '{{event.startDate}}'
                },
                {
                  'type': 'state',
                  'action': 'set',
                  'binding': 'dateRange.end',
                  'value': '{{event.endDate}}'
                }
              ]
            }
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);
      });

      test('should validate modern layout widgets', () {
        // Test modern layout widgets
        final linearWidget = WidgetConfig(
          type: 'linear',
          properties: {
            'direction': 'vertical',
            'gap': 16.0,
            'distribution': 'space-between',
            'alignment': 'center',
          },
          children: [
            WidgetConfig(type: 'text', properties: {'content': 'Hello'}),
            WidgetConfig(type: 'text', properties: {'content': 'World'}),
          ],
        );
        expect(UIValidator.validateWidget(linearWidget).isValid, isTrue);

        final boxWidget = WidgetConfig(
          type: 'box',
          properties: {
            'width': 200.0,
            'height': 100.0,
            'padding': {'all': 16.0},
            'color': '#2196F3',
          },
          children: [
            WidgetConfig(type: 'text', properties: {'content': 'Box content'}),
          ],
        );
        expect(UIValidator.validateWidget(boxWidget).isValid, isTrue);
      });

      test('should validate widget with unknown properties', () {
        final widget = WidgetConfig(
          type: 'text',
          properties: {
            'content': 'Hello',
            'unknownProperty': 'value',  // This should generate a warning
          },
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isTrue);  // Still valid, just with warnings
        expect(result.warnings.any((w) => w.code == 'UNKNOWN_PROPERTY'), isTrue);
      });

      test('should validate unknown widget type', () {
        final widget = WidgetConfig(
          type: 'unknownWidget',
          properties: {'prop': 'value'},
        );

        final result = UIValidator.validateWidget(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
    });

    group('Action Validation', () {
      test('should validate state action', () {
        final action = ActionConfig.state(
          action: 'set',
          binding: 'counter',
          value: 42,
        );

        final result = UIValidator.validateAction(action);
        expect(result.isValid, isTrue);
      });

      test('should validate navigation action', () {
        final action = ActionConfig.navigation(
          action: 'push',
          route: '/profile',
          params: {'userId': '123'},
        );

        final result = UIValidator.validateAction(action);
        expect(result.isValid, isTrue);
      });

      test('should validate tool action', () {
        final action = ActionConfig.tool('fetchData', {
          'endpoint': '/api/users',
          'method': 'GET',
        });

        final result = UIValidator.validateAction(action);
        expect(result.isValid, isTrue);
      });

      test('should validate batch action', () {
        final action = ActionConfig.batch([
          ActionConfig.state(action: 'set', binding: 'loading', value: true),
          ActionConfig.tool('fetchData', {'id': '123'}),
          ActionConfig.state(action: 'set', binding: 'loading', value: false),
        ]);

        final result = UIValidator.validateAction(action);
        expect(result.isValid, isTrue);
      });

      test('should validate conditional action', () {
        final action = ActionConfig.conditional(
          condition: 'counter > 10',
          thenAction: ActionConfig.state(action: 'set', binding: 'status', value: 'high'),
          elseAction: ActionConfig.state(action: 'set', binding: 'status', value: 'low'),
        );

        final result = UIValidator.validateAction(action);
        expect(result.isValid, isTrue);
      });

      test('should detect missing required fields in action', () {
        // Tool action without tool name
        final action = ActionConfig(type: 'tool');
        final result = UIValidator.validateAction(action);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.path?.contains('tool') ?? false), isTrue);
      });
    });

    group('Binding Validation', () {
      test('should validate simple binding', () {
        final binding = BindingConfig.fromExpression('{{counter}}');
        final result = UIValidator.validateBinding(binding);
        expect(result.isValid, isTrue);
      });

      test('should validate nested binding', () {
        final binding = BindingConfig.fromExpression('{{user.profile.name}}');
        final result = UIValidator.validateBinding(binding);
        expect(result.isValid, isTrue);
      });

      test('should validate array binding', () {
        final binding = BindingConfig.fromExpression('{{items[0].title}}');
        final result = UIValidator.validateBinding(binding);
        expect(result.isValid, isTrue);
      });

      test('should detect invalid binding syntax', () {
        final binding = BindingConfig(
          expression: '{{invalid..path}}',
          path: 'invalid..path',
        );
        final result = UIValidator.validateBinding(binding);
        expect(result.isValid, isFalse);
      });
    });

    group('Theme Validation', () {
      test('should validate theme with all required colors', () {
        final theme = {
          'mode': 'light',
          'colors': {
            'primary': '#2196F3',
            'secondary': '#FF4081',
            'background': '#FFFFFF',
            'surface': '#F5F5F5',
            'error': '#F44336',
            'textOnPrimary': '#FFFFFF',
            'textOnSecondary': '#000000',
            'textOnBackground': '#000000',
            'textOnSurface': '#000000',
            'textOnError': '#FFFFFF',
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should detect missing required colors', () {
        final theme = {
          'colors': {
            'primary': '#2196F3',
            'secondary': '#FF4081',
            // Missing background, surface, error, and all textOn* colors
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => e.path?.contains('background') ?? false), isTrue);
        expect(result.errors.any((e) => e.path?.contains('textOnPrimary') ?? false), isTrue);
        expect(result.errors.any((e) => e.path?.contains('textOnSecondary') ?? false), isTrue);
      });

      test('should validate color formats', () {
        final theme = {
          'colors': {
            'primary': '#2196F3',      // Valid 6-digit
            'secondary': '#FFFF4081',  // Valid 8-digit
            'background': 'invalid',   // Invalid
            'surface': '#F5F5F5',
            'error': '#F44336',
            'textOnPrimary': '#FFFFFF',
            'textOnSecondary': '#000000',
            'textOnBackground': '#000000',
            'textOnSurface': '#000000',
            'textOnError': '#FFFFFF',
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => 
          e.path?.contains('background') ?? false && 
          e.message.contains('#RRGGBB or #AARRGGBB')
        ), isTrue);
      });

      test('should validate theme mode', () {
        final theme = {
          'mode': 'invalid',
          'colors': {
            'primary': '#2196F3',
            'secondary': '#FF4081',
            'background': '#FFFFFF',
            'surface': '#F5F5F5',
            'error': '#F44336',
            'textOnPrimary': '#FFFFFF',
            'textOnSecondary': '#000000',
            'textOnBackground': '#000000',
            'textOnSurface': '#000000',
            'textOnError': '#FFFFFF',
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => 
          e.path?.contains('mode') ?? false && 
          e.message.contains('light, dark, system')
        ), isTrue);
      });

      test('should validate typography', () {
        final theme = {
          'typography': {
            'h1': {
              'fontSize': 32,
              'fontWeight': 'bold',
            },
            'body1': {
              'fontSize': 'invalid', // Should be number
              'fontWeight': 'invalid-weight', // Should be valid weight
            },
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => e.path?.contains('body1.fontSize') ?? false), isTrue);
        expect(result.errors.any((e) => e.path?.contains('body1.fontWeight') ?? false), isTrue);
      });

      test('should validate spacing values', () {
        final theme = {
          'spacing': {
            'sm': 8,
            'md': 'invalid', // Should be number
            'lg': 24,
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => e.path?.contains('spacing.md') ?? false), isTrue);
      });

      test('should validate elevation values', () {
        final theme = {
          'elevation': {
            'none': 0,
            'sm': -2, // Should be >= 0
            'md': 4,
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => 
          e.path?.contains('elevation.sm') ?? false && 
          e.message.contains('at least 0')
        ), isTrue);
      });

      test('should validate nested light/dark themes', () {
        final theme = {
          'mode': 'system',
          'light': {
            'colors': {
              'primary': '#2196F3',
              'secondary': '#FF4081',
              'background': '#FFFFFF',
              'surface': '#F5F5F5',
              'error': '#F44336',
              'textOnPrimary': '#FFFFFF',
              'textOnSecondary': '#000000',
              'textOnBackground': '#000000',
              'textOnSurface': '#000000',
              'textOnError': '#FFFFFF',
            },
          },
          'dark': {
            'colors': {
              'primary': '#1976D2',
              // Missing other required colors
            },
          },
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => e.path?.contains('dark.colors') ?? false), isTrue);
      });
    });
  });
}