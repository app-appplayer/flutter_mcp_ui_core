# MCP UI DSL v1.0 Complete Conformance Verification Test Design

## 1. Test Structure Overview

### 1.1 Test Categories
```
tests/
├── conformance/              # DSL specification conformance tests
│   ├── structure/           # Structural element tests
│   ├── widgets/             # Widget tests
│   ├── binding/             # Data binding tests
│   ├── actions/             # Action system tests
│   ├── navigation/          # Navigation tests
│   ├── theme/               # Theme system tests
│   └── lifecycle/           # Lifecycle tests
├── integration/             # Integration tests
│   ├── mcp_protocol/        # MCP protocol integration
│   ├── state_management/    # State management integration
│   └── runtime/             # Runtime behavior
├── performance/             # Performance tests
├── edge_cases/              # Edge cases
└── visual_regression/       # Visual regression tests
```

### 1.2 Test Levels
1. **Unit Tests**: Individual component behavior verification
2. **Widget Tests**: Widget rendering and property verification
3. **Integration Tests**: Inter-system integration verification
4. **E2E Tests**: Complete application flow verification

## 2. DSL Specification Conformance Checklist

### 2.1 Structural Elements
- [ ] Application definition verification
- [ ] Page definition verification
- [ ] Routing table verification
- [ ] Initial state setup verification
- [ ] Theme definition verification

### 2.2 Widget System
- [ ] All layout widgets (Container, Column, Row, Stack, Center, Expanded, Flexible)
- [ ] All display widgets (Text, Image, Icon, Divider, Card)
- [ ] All input widgets (Button, TextField, Checkbox, Switch, Slider)
- [ ] All list widgets (ListView, GridView)
- [ ] Advanced widgets (Chart, Table)

### 2.3 Data Binding
- [ ] Simple binding expressions
- [ ] Nested property access
- [ ] Array index access
- [ ] Conditional expressions
- [ ] Mixed content
- [ ] Context variables (item, index, isFirst, isLast, isEven, isOdd)

### 2.4 Action System
- [ ] State Actions (set, increment, decrement, toggle, append, remove)
- [ ] Navigation Actions (push, replace, pop, popToRoot)
- [ ] Tool Actions (basic calls, success/failure handling)
- [ ] Resource Actions (subscribe, unsubscribe)
- [ ] Batch Actions
- [ ] Conditional Actions

### 2.5 MCP Protocol Integration
- [ ] Resource reading
- [ ] Tool calls and response processing
- [ ] Notification handling
- [ ] Subscribe/unsubscribe

## 3. Detailed Test Cases

### 3.1 Application Definition Tests
```dart
// test/conformance/structure/application_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

void main() {
  group('Application Definition Conformance', () {
    test('should parse complete application definition', () {
      final appDef = {
        "type": "application",
        "title": "Test App",
        "version": "1.0.0",
        "initialRoute": "/dashboard",
        "theme": {
          "mode": "light",
          "colors": {
            "primary": "#2196F3",
            "secondary": "#FF4081",
            "background": "#FFFFFF",
            "surface": "#F5F5F5",
            "error": "#F44336",
            "onPrimary": "#FFFFFF",
            "onSecondary": "#000000",
            "onBackground": "#000000",
            "onSurface": "#000000",
            "onError": "#FFFFFF"
          },
          "typography": {
            "h1": {"fontSize": 32, "fontWeight": "bold", "letterSpacing": -1.5},
            "body1": {"fontSize": 16, "fontWeight": "normal", "letterSpacing": 0.5}
          },
          "spacing": {"xs": 4, "sm": 8, "md": 16, "lg": 24, "xl": 32, "xxl": 48},
          "borderRadius": {"sm": 4, "md": 8, "lg": 16, "xl": 24, "round": 9999},
          "elevation": {"none": 0, "sm": 2, "md": 4, "lg": 8, "xl": 16}
        },
        "routes": {
          "/dashboard": "ui://pages/dashboard",
          "/settings": "ui://pages/settings",
          "/profile": "ui://pages/profile",
          "/users/:id": "ui://pages/user-detail"
        },
        "state": {
          "initial": {
            "user": {"name": "Guest", "isAuthenticated": false},
            "themeMode": "light",
            "language": "en"
          }
        },
        "navigation": {
          "type": "drawer",
          "items": [
            {"title": "Dashboard", "route": "/dashboard", "icon": "dashboard"},
            {"title": "Settings", "route": "/settings", "icon": "settings"},
            {"title": "Profile", "route": "/profile", "icon": "person"}
          ]
        }
      };

      final runtime = MCPUIRuntime();
      expect(() => runtime.initialize(appDef), returnsNormally);
      
      // Verify that all required properties have been parsed
      expect(runtime.title, equals("Test App"));
      expect(runtime.version, equals("1.0.0"));
      expect(runtime.initialRoute, equals("/dashboard"));
      expect(runtime.routes.length, equals(4));
      expect(runtime.theme.mode, equals("light"));
      expect(runtime.theme.colors['primary'], equals("#2196F3"));
      expect(runtime.state['user']['name'], equals("Guest"));
      expect(runtime.navigation.type, equals("drawer"));
      expect(runtime.navigation.items.length, equals(3));
    });

    test('should handle missing optional fields', () {
      final minimalApp = {
        "type": "application",
        "title": "Minimal App",
        "routes": {"/": "ui://pages/home"}
      };

      final runtime = MCPUIRuntime();
      expect(() => runtime.initialize(minimalApp), returnsNormally);
      expect(runtime.version, equals("1.0.0")); // default value
      expect(runtime.initialRoute, equals("/")); // first route
    });

    test('should validate required fields', () {
      final invalidApp = {
        "type": "application"
        // title missing
      };

      final runtime = MCPUIRuntime();
      expect(
        () => runtime.initialize(invalidApp),
        throwsA(isA<ValidationError>()),
      );
    });
  });
}
```

### 3.2 Widget Conformance Tests
```dart
// test/conformance/widgets/widget_conformance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

void main() {
  group('Widget Conformance Tests', () {
    late MCPUIRuntime runtime;
    
    setUp(() {
      runtime = MCPUIRuntime();
    });

    group('Layout Widgets', () {
      test('Container - all properties', () {
        final containerDef = {
          "type": "container",
          "width": 200,
          "height": 100,
          "padding": {"all": 16},
          "margin": {"horizontal": 8},
          "decoration": {
            "color": "#ffffff",
            "borderRadius": 8,
            "border": {
              "color": "#e0e0e0",
              "width": 1
            }
          },
          "child": {"type": "text", "content": "Test"}
        };

        testWidgets('renders with all properties', (tester) async {
          await tester.pumpWidget(
            runtime.buildWidget(containerDef)
          );

          // Verify Container properties
          final container = tester.widget<Container>(find.byType(Container));
          expect(container.constraints?.maxWidth, equals(200));
          expect(container.constraints?.maxHeight, equals(100));
          
          // Verify decoration
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.color, equals(Color(0xFFFFFFFF)));
          expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
          expect(decoration.border?.top.width, equals(1));
          
          // Verify child exists
          expect(find.text('Test'), findsOneWidget);
        });
      });

      test('Column - all alignment options', () {
        final alignmentOptions = [
          'start', 'end', 'center', 'spaceBetween', 
          'spaceAround', 'spaceEvenly'
        ];

        for (final alignment in alignmentOptions) {
          final columnDef = {
            "type": "column",
            "mainAxisAlignment": alignment,
            "crossAxisAlignment": "center",
            "mainAxisSize": "max",
            "children": [
              {"type": "text", "content": "Item 1"},
              {"type": "text", "content": "Item 2"}
            ]
          };

          testWidgets('Column with $alignment alignment', (tester) async {
            await tester.pumpWidget(
              runtime.buildWidget(columnDef)
            );

            final column = tester.widget<Column>(find.byType(Column));
            expect(column.mainAxisAlignment.toString(), 
              contains(alignment));
            expect(column.crossAxisAlignment, 
              equals(CrossAxisAlignment.center));
            expect(column.mainAxisSize, equals(MainAxisSize.max));
            expect(column.children.length, equals(2));
          });
        }
      });

      // Row, Stack, Center, Expanded, Flexible tests...
    });

    group('Display Widgets', () {
      test('Text - all style properties', () {
        final textDef = {
          "type": "text",
          "content": "Styled Text",
          "style": {
            "fontSize": 20,
            "fontWeight": "bold",
            "color": "#333333",
            "letterSpacing": 1.5,
            "wordSpacing": 2.0,
            "decoration": "underline",
            "decorationColor": "#FF0000",
            "decorationStyle": "dashed",
            "fontFamily": "Roboto",
            "height": 1.5,
            "backgroundColor": "#FFFF00"
          },
          "textAlign": "center",
          "maxLines": 2,
          "overflow": "ellipsis"
        };

        testWidgets('renders with all style properties', (tester) async {
          await tester.pumpWidget(
            runtime.buildWidget(textDef)
          );

          final text = tester.widget<Text>(find.byType(Text));
          expect(text.data, equals("Styled Text"));
          expect(text.style?.fontSize, equals(20));
          expect(text.style?.fontWeight, equals(FontWeight.bold));
          expect(text.style?.color, equals(Color(0xFF333333)));
          expect(text.style?.letterSpacing, equals(1.5));
          expect(text.style?.wordSpacing, equals(2.0));
          expect(text.style?.decoration, equals(TextDecoration.underline));
          expect(text.style?.decorationColor, equals(Color(0xFFFF0000)));
          expect(text.style?.decorationStyle, equals(TextDecorationStyle.dashed));
          expect(text.style?.fontFamily, equals("Roboto"));
          expect(text.style?.height, equals(1.5));
          expect(text.style?.backgroundColor, equals(Color(0xFFFFFF00)));
          expect(text.textAlign, equals(TextAlign.center));
          expect(text.maxLines, equals(2));
          expect(text.overflow, equals(TextOverflow.ellipsis));
        });
      });

      // Image, Icon, Divider, Card tests...
    });

    group('Input Widgets', () {
      test('Button - all variants and properties', () {
        final buttonVariants = ['elevated', 'filled', 'outlined', 'text'];
        
        for (final variant in buttonVariants) {
          final buttonDef = {
            "type": "button",
            "label": "Test Button",
            "style": variant,
            "icon": "add",
            "iconPosition": "start",
            "enabled": true,
            "loading": false,
            "fullWidth": false,
            "size": "medium",
            "onTap": {
              "type": "tool",
              "tool": "handleTap"
            }
          };

          testWidgets('Button variant: $variant', (tester) async {
            await tester.pumpWidget(
              runtime.buildWidget(buttonDef)
            );

            // Find widget by button type
            expect(find.text('Test Button'), findsOneWidget);
            expect(find.byIcon(Icons.add), findsOneWidget);
            
            // Test tap event
            await tester.tap(find.byType(InkWell));
            await tester.pump();
            
            // Verify onTap action was triggered
            verify(() => runtime.actionHandler.execute(any())).called(1);
          });
        }
      });

      test('TextField - all properties and validation', () {
        final textFieldDef = {
          "type": "textfield",
          "label": "Email",
          "placeholder": "Enter your email",
          "value": "{{form.email}}",
          "helperText": "We'll never share your email",
          "errorText": "{{form.errors.email}}",
          "prefixIcon": "email",
          "suffixIcon": "clear",
          "keyboardType": "email",
          "obscureText": false,
          "maxLength": 100,
          "maxLines": 1,
          "enabled": true,
          "readOnly": false,
          "validation": [
            {
              "type": "required",
              "message": "Email is required"
            },
            {
              "type": "email",
              "message": "Invalid email format"
            }
          ],
          "onChange": {
            "type": "state",
            "action": "set",
            "binding": "form.email",
            "value": "{{event.value}}"
          }
        };

        testWidgets('renders with all properties', (tester) async {
          await tester.pumpWidget(
            runtime.buildWidget(textFieldDef)
          );

          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(textField.decoration?.labelText, equals("Email"));
          expect(textField.decoration?.hintText, equals("Enter your email"));
          expect(textField.decoration?.helperText, equals("We'll never share your email"));
          expect(textField.decoration?.prefixIcon, isNotNull);
          expect(textField.decoration?.suffixIcon, isNotNull);
          expect(textField.keyboardType, equals(TextInputType.emailAddress));
          expect(textField.obscureText, isFalse);
          expect(textField.maxLength, equals(100));
          expect(textField.maxLines, equals(1));
          expect(textField.enabled, isTrue);
          expect(textField.readOnly, isFalse);
        });

        testWidgets('validation works correctly', (tester) async {
          await tester.pumpWidget(
            runtime.buildWidget(textFieldDef)
          );

          // Validate with empty value
          await tester.enterText(find.byType(TextField), '');
          await tester.pump();
          expect(runtime.state['form']['errors']['email'], 
            equals('Email is required'));

          // Validate with invalid email format
          await tester.enterText(find.byType(TextField), 'invalid-email');
          await tester.pump();
          expect(runtime.state['form']['errors']['email'], 
            equals('Invalid email format'));

          // Validate with correct email
          await tester.enterText(find.byType(TextField), 'test@example.com');
          await tester.pump();
          expect(runtime.state['form']['errors']['email'], isNull);
          expect(runtime.state['form']['email'], equals('test@example.com'));
        });
      });

      // Checkbox, Switch, Slider tests...
    });

    group('List Widgets', () {
      test('ListView - all properties and item rendering', () {
        final listViewDef = {
          "type": "listview",
          "items": [
            {"id": 1, "name": "Item 1"},
            {"id": 2, "name": "Item 2"},
            {"id": 3, "name": "Item 3"}
          ],
          "itemSpacing": 8,
          "shrinkWrap": true,
          "physics": "neverScroll",
          "padding": {"all": 16},
          "itemTemplate": {
            "type": "container",
            "padding": {"all": 12},
            "child": {
              "type": "row",
              "children": [
                {
                  "type": "text",
                  "content": "{{item.id}}. {{item.name}}"
                },
                {
                  "type": "text",
                  "content": "Index: {{index}}"
                }
              ]
            }
          }
        };

        testWidgets('renders items with context variables', (tester) async {
          await tester.pumpWidget(
            runtime.buildWidget(listViewDef)
          );

          // Verify item rendering
          expect(find.text('1. Item 1'), findsOneWidget);
          expect(find.text('2. Item 2'), findsOneWidget);
          expect(find.text('3. Item 3'), findsOneWidget);

          // Verify index
          expect(find.text('Index: 0'), findsOneWidget);
          expect(find.text('Index: 1'), findsOneWidget);
          expect(find.text('Index: 2'), findsOneWidget);

          // Verify ListView properties
          final listView = tester.widget<ListView>(find.byType(ListView));
          expect(listView.shrinkWrap, isTrue);
          expect(listView.physics, isA<NeverScrollableScrollPhysics>());
          expect(listView.padding, equals(EdgeInsets.all(16)));
        });

        test('context variables work correctly', () {
          final contextTestDef = {
            "type": "listview",
            "items": ["A", "B", "C"],
            "itemTemplate": {
              "type": "column",
              "children": [
                {
                  "type": "text",
                  "content": "{{isFirst ? 'First' : ''}}"
                },
                {
                  "type": "text",
                  "content": "{{isLast ? 'Last' : ''}}"
                },
                {
                  "type": "text",
                  "content": "{{isEven ? 'Even' : 'Odd'}}"
                }
              ]
            }
          };

          testWidgets('context variables', (tester) async {
            await tester.pumpWidget(
              runtime.buildWidget(contextTestDef)
            );

            // First item (index 0)
            expect(find.text('First'), findsOneWidget);
            expect(find.text('Even'), findsNWidgets(2)); // index 0, 2

            // Last item (index 2)
            expect(find.text('Last'), findsOneWidget);

            // Odd index
            expect(find.text('Odd'), findsOneWidget); // index 1
          });
        });
      });

      // GridView tests...
    });
  });
}
```

### 3.3 Data Binding Tests
```dart
// test/conformance/binding/binding_conformance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

void main() {
  group('Data Binding Conformance', () {
    late MCPUIRuntime runtime;
    
    setUp(() {
      runtime = MCPUIRuntime();
      runtime.state.set('user', {
        'name': 'John Doe',
        'profile': {
          'age': 30,
          'city': 'New York'
        }
      });
      runtime.state.set('items', [
        {'title': 'Item 1'},
        {'title': 'Item 2'}
      ]);
      runtime.state.set('count', 5);
      runtime.state.set('isActive', true);
    });

    test('simple binding', () {
      final result = runtime.resolveBinding('{{count}}');
      expect(result, equals(5));
    });

    test('nested property binding', () {
      final result = runtime.resolveBinding('{{user.profile.city}}');
      expect(result, equals('New York'));
    });

    test('array index binding', () {
      final result = runtime.resolveBinding('{{items[0].title}}');
      expect(result, equals('Item 1'));
    });

    test('conditional expression', () {
      final result1 = runtime.resolveBinding('{{count > 0 ? "Has items" : "Empty"}}');
      expect(result1, equals('Has items'));

      runtime.state.set('count', 0);
      final result2 = runtime.resolveBinding('{{count > 0 ? "Has items" : "Empty"}}');
      expect(result2, equals('Empty'));
    });

    test('mixed content binding', () {
      final result = runtime.resolveBinding('Total: {{count}} items');
      expect(result, equals('Total: 5 items'));
    });

    test('complex expressions', () {
      // 산술 연산
      expect(runtime.resolveBinding('{{count * 2}}'), equals(10));
      expect(runtime.resolveBinding('{{count + 3}}'), equals(8));
      
      // 논리 연산
      expect(runtime.resolveBinding('{{isActive && count > 0}}'), isTrue);
      expect(runtime.resolveBinding('{{!isActive || count < 10}}'), isTrue);
      
      // 문자열 연결
      expect(runtime.resolveBinding('{{user.name + " - " + user.profile.city}}'), 
        equals('John Doe - New York'));
    });

    test('undefined property handling', () {
      // 정의되지 않은 속성은 null 반환
      expect(runtime.resolveBinding('{{user.nonexistent}}'), isNull);
      
      // 옵셔널 체이닝
      expect(runtime.resolveBinding('{{user.nonexistent?.property}}'), isNull);
      
      // 기본값 제공
      expect(runtime.resolveBinding('{{user.nonexistent || "default"}}'), 
        equals('default'));
    });

    test('special bindings', () {
      // 테마 바인딩
      runtime.theme.set('colors.primary', '#2196F3');
      expect(runtime.resolveBinding('{{theme.colors.primary}}'), 
        equals('#2196F3'));
      
      // 라우트 파라미터 바인딩
      runtime.route.params = {'id': '123'};
      expect(runtime.resolveBinding('{{route.params.id}}'), equals('123'));
      
      // 앱 전역 상태 바인딩
      runtime.app.state.set('user.name', 'Global User');
      expect(runtime.resolveBinding('{{app.user.name}}'), 
        equals('Global User'));
    });
  });
}
```

### 3.4 액션 시스템 테스트
```dart
// test/conformance/actions/action_conformance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

class MockMCPClient extends Mock implements MCPClient {}
class MockNavigationService extends Mock implements NavigationService {}

void main() {
  group('Action System Conformance', () {
    late MCPUIRuntime runtime;
    late MockMCPClient mockClient;
    late MockNavigationService mockNavigation;
    
    setUp(() {
      runtime = MCPUIRuntime();
      mockClient = MockMCPClient();
      mockNavigation = MockNavigationService();
      
      runtime.setMCPClient(mockClient);
      runtime.setNavigationService(mockNavigation);
    });

    group('State Actions', () {
      test('set action', () async {
        runtime.state.set('counter', 0);
        
        await runtime.executeAction({
          "type": "state",
          "action": "set",
          "binding": "counter",
          "value": 10
        });
        
        expect(runtime.state.get('counter'), equals(10));
      });

      test('increment action', () async {
        runtime.state.set('counter', 5);
        
        await runtime.executeAction({
          "type": "state",
          "action": "increment",
          "binding": "counter",
          "value": 3
        });
        
        expect(runtime.state.get('counter'), equals(8));
      });

      test('decrement action', () async {
        runtime.state.set('counter', 5);
        
        await runtime.executeAction({
          "type": "state",
          "action": "decrement",
          "binding": "counter",
          "value": 2
        });
        
        expect(runtime.state.get('counter'), equals(3));
      });

      test('toggle action', () async {
        runtime.state.set('isActive', false);
        
        await runtime.executeAction({
          "type": "state",
          "action": "toggle",
          "binding": "isActive"
        });
        
        expect(runtime.state.get('isActive'), isTrue);
        
        await runtime.executeAction({
          "type": "state",
          "action": "toggle",
          "binding": "isActive"
        });
        
        expect(runtime.state.get('isActive'), isFalse);
      });

      test('append action', () async {
        runtime.state.set('items', ['a', 'b']);
        
        await runtime.executeAction({
          "type": "state",
          "action": "append",
          "binding": "items",
          "value": "c"
        });
        
        expect(runtime.state.get('items'), equals(['a', 'b', 'c']));
      });

      test('remove action', () async {
        runtime.state.set('items', ['a', 'b', 'c']);
        
        await runtime.executeAction({
          "type": "state",
          "action": "remove",
          "binding": "items",
          "value": "b"
        });
        
        expect(runtime.state.get('items'), equals(['a', 'c']));
      });
    });

    group('Navigation Actions', () {
      test('push action', () async {
        await runtime.executeAction({
          "type": "navigation",
          "action": "push",
          "route": "/profile",
          "params": {
            "userId": "123",
            "from": "dashboard"
          }
        });
        
        verify(mockNavigation.push('/profile', params: {
          "userId": "123",
          "from": "dashboard"
        })).called(1);
      });

      test('replace action', () async {
        await runtime.executeAction({
          "type": "navigation",
          "action": "replace",
          "route": "/login"
        });
        
        verify(mockNavigation.replace('/login')).called(1);
      });

      test('pop action', () async {
        await runtime.executeAction({
          "type": "navigation",
          "action": "pop"
        });
        
        verify(mockNavigation.pop()).called(1);
      });

      test('popToRoot action', () async {
        await runtime.executeAction({
          "type": "navigation",
          "action": "popToRoot"
        });
        
        verify(mockNavigation.popToRoot()).called(1);
      });
    });

    group('Tool Actions', () {
      test('basic tool call with auto state binding', () async {
        when(mockClient.callTool('increment', any)).thenAnswer((_) async {
          return CallToolResult(
            content: [
              TextContent(text: '{"counter": 5, "message": "Incremented"}')
            ],
            isError: false,
          );
        });

        await runtime.executeAction({
          "type": "tool",
          "tool": "increment",
          "args": {"amount": 1}
        });

        // Tool이 호출되었는지 검증
        verify(mockClient.callTool('increment', {"amount": 1})).called(1);
        
        // 응답이 자동으로 상태에 바인딩되었는지 검증
        expect(runtime.state.get('counter'), equals(5));
        expect(runtime.state.get('message'), equals('Incremented'));
      });

      test('tool call with success handler', () async {
        when(mockClient.callTool('saveData', any)).thenAnswer((_) async {
          return CallToolResult(
            content: [
              TextContent(text: '{"saved": true, "id": "123"}')
            ],
            isError: false,
          );
        });

        var successHandled = false;
        
        await runtime.executeAction({
          "type": "tool",
          "tool": "saveData",
          "args": {"data": "test"},
          "onSuccess": {
            "type": "custom",
            "handler": () {
              successHandled = true;
            }
          }
        });

        expect(successHandled, isTrue);
        expect(runtime.state.get('saved'), isTrue);
        expect(runtime.state.get('id'), equals('123'));
      });

      test('tool call with error handler', () async {
        when(mockClient.callTool('saveData', any)).thenAnswer((_) async {
          return CallToolResult(
            content: [
              TextContent(text: '{"error": "Validation failed", "field": "email"}')
            ],
            isError: true,
          );
        });

        var errorHandled = false;
        
        await runtime.executeAction({
          "type": "tool",
          "tool": "saveData",
          "args": {"data": "test"},
          "onError": {
            "type": "custom",
            "handler": () {
              errorHandled = true;
            }
          }
        });

        expect(errorHandled, isTrue);
        // 에러 응답은 상태에 바인딩되지 않음
        expect(runtime.state.get('error'), isNull);
      });
    });

    group('Resource Actions', () {
      test('subscribe action', () async {
        await runtime.executeAction({
          "type": "resource",
          "action": "subscribe",
          "uri": "ui://sensors/temperature",
          "binding": "temperature"
        });

        verify(mockClient.subscribeResource('ui://sensors/temperature')).called(1);
        expect(runtime.subscriptions.containsKey('ui://sensors/temperature'), isTrue);
        expect(runtime.subscriptions['ui://sensors/temperature'], equals('temperature'));
      });

      test('unsubscribe action', () async {
        // 먼저 구독
        runtime.subscriptions['ui://sensors/temperature'] = 'temperature';
        
        await runtime.executeAction({
          "type": "resource",
          "action": "unsubscribe",
          "uri": "ui://sensors/temperature"
        });

        verify(mockClient.unsubscribeResource('ui://sensors/temperature')).called(1);
        expect(runtime.subscriptions.containsKey('ui://sensors/temperature'), isFalse);
      });
    });

    group('Batch Actions', () {
      test('executes actions in sequence', () async {
        runtime.state.set('step', 0);
        
        await runtime.executeAction({
          "type": "batch",
          "actions": [
            {
              "type": "state",
              "action": "set",
              "binding": "step",
              "value": 1
            },
            {
              "type": "state",
              "action": "increment",
              "binding": "step",
              "value": 1
            },
            {
              "type": "state",
              "action": "increment",
              "binding": "step",
              "value": 1
            }
          ]
        });

        expect(runtime.state.get('step'), equals(3));
      });

      test('stops on error if configured', () async {
        runtime.state.set('counter', 0);
        
        when(mockClient.callTool('failingTool', any)).thenThrow(Exception('Failed'));
        
        await runtime.executeAction({
          "type": "batch",
          "stopOnError": true,
          "actions": [
            {
              "type": "state",
              "action": "set",
              "binding": "counter",
              "value": 1
            },
            {
              "type": "tool",
              "tool": "failingTool"
            },
            {
              "type": "state",
              "action": "set",
              "binding": "counter",
              "value": 2
            }
          ]
        });

        // 첫 번째 액션은 실행되었지만 세 번째는 실행되지 않음
        expect(runtime.state.get('counter'), equals(1));
      });
    });

    group('Conditional Actions', () {
      test('executes then branch when condition is true', () async {
        runtime.state.set('isValid', true);
        runtime.state.set('result', null);
        
        await runtime.executeAction({
          "type": "conditional",
          "condition": "{{isValid}}",
          "then": {
            "type": "state",
            "action": "set",
            "binding": "result",
            "value": "success"
          },
          "else": {
            "type": "state",
            "action": "set",
            "binding": "result",
            "value": "failure"
          }
        });

        expect(runtime.state.get('result'), equals('success'));
      });

      test('executes else branch when condition is false', () async {
        runtime.state.set('isValid', false);
        runtime.state.set('result', null);
        
        await runtime.executeAction({
          "type": "conditional",
          "condition": "{{isValid}}",
          "then": {
            "type": "state",
            "action": "set",
            "binding": "result",
            "value": "success"
          },
          "else": {
            "type": "state",
            "action": "set",
            "binding": "result",
            "value": "failure"
          }
        });

        expect(runtime.state.get('result'), equals('failure'));
      });

      test('evaluates complex conditions', () async {
        runtime.state.set('count', 5);
        runtime.state.set('isActive', true);
        
        await runtime.executeAction({
          "type": "conditional",
          "condition": "{{count > 3 && isActive}}",
          "then": {
            "type": "state",
            "action": "set",
            "binding": "result",
            "value": "complex condition met"
          }
        });

        expect(runtime.state.get('result'), equals('complex condition met'));
      });
    });
  });
}
```

### 3.5 MCP 프로토콜 통합 테스트
```dart
// test/integration/mcp_protocol/mcp_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

void main() {
  group('MCP Protocol Integration', () {
    late MCPUIRuntime runtime;
    late MockMCPClient mockClient;
    
    setUp(() {
      runtime = MCPUIRuntime();
      mockClient = MockMCPClient();
      runtime.setMCPClient(mockClient);
    });

    group('Resource Subscription', () {
      test('standard mode - URI only notification', () async {
        // 구독 설정
        await runtime.executeAction({
          "type": "resource",
          "action": "subscribe",
          "uri": "ui://state/user",
          "binding": "currentUser"
        });

        // 표준 모드 알림 (URI만 포함)
        when(mockClient.readResource('ui://state/user')).thenAnswer((_) async {
          return ReadResourceResult(
            contents: [
              ResourceContentInfo(
                uri: 'ui://state/user',
                mimeType: 'application/json',
                text: '{"name": "John Doe", "role": "admin"}',
              )
            ],
          );
        });

        // 알림 처리
        await runtime.handleNotification({
          'method': 'notifications/resources/updated',
          'params': {
            'uri': 'ui://state/user'
          }
        });

        // Verify resource was read again
        verify(mockClient.readResource('ui://state/user')).called(1);
        
        // 상태가 업데이트되었는지 검증
        expect(runtime.state.get('currentUser.name'), equals('John Doe'));
        expect(runtime.state.get('currentUser.role'), equals('admin'));
      });

      test('extended mode - content included notification', () async {
        // 구독 설정
        await runtime.executeAction({
          "type": "resource",
          "action": "subscribe",
          "uri": "ui://sensors/temperature",
          "binding": "temperature"
        });

        // 확장 모드 알림 (콘텐츠 포함)
        await runtime.handleNotification({
          'method': 'notifications/resources/updated',
          'params': {
            'uri': 'ui://sensors/temperature',
            'content': {
              'uri': 'ui://sensors/temperature',
              'mimeType': 'application/json',
              'text': '{"value": 23.5, "unit": "celsius"}',
            }
          }
        });

        // Verify resource read was not called (content already included)
        verifyNever(mockClient.readResource(any));
        
        // Verify state was updated directly
        expect(runtime.state.get('temperature.value'), equals(23.5));
        expect(runtime.state.get('temperature.unit'), equals('celsius'));
      });

      test('multiple subscriptions handling', () async {
        // Set up multiple subscriptions
        await runtime.executeAction({
          "type": "batch",
          "actions": [
            {
              "type": "resource",
              "action": "subscribe",
              "uri": "ui://metrics/cpu",
              "binding": "metrics.cpu"
            },
            {
              "type": "resource",
              "action": "subscribe",
              "uri": "ui://metrics/memory",
              "binding": "metrics.memory"
            }
          ]
        });

        // CPU update
        await runtime.handleNotification({
          'method': 'notifications/resources/updated',
          'params': {
            'uri': 'ui://metrics/cpu',
            'content': {
              'uri': 'ui://metrics/cpu',
              'mimeType': 'application/json',
              'text': '{"usage": 45.2, "cores": 8}',
            }
          }
        });

        // Memory update
        await runtime.handleNotification({
          'method': 'notifications/resources/updated',
          'params': {
            'uri': 'ui://metrics/memory',
            'content': {
              'uri': 'ui://metrics/memory',
              'mimeType': 'application/json',
              'text': '{"used": 8192, "total": 16384}',
            }
          }
        });

        // Verify state
        expect(runtime.state.get('metrics.cpu.usage'), equals(45.2));
        expect(runtime.state.get('metrics.memory.used'), equals(8192));
      });
    });

    group('Tool Response Processing', () {
      test('successful tool response with state merge', () async {
        when(mockClient.callTool('getUserData', any)).thenAnswer((_) async {
          return CallToolResult(
            content: [
              TextContent(text: jsonEncode({
                'user': {
                  'id': '123',
                  'name': 'John Doe',
                  'email': 'john@example.com'
                },
                'permissions': ['read', 'write'],
                'lastLogin': '2024-01-01T00:00:00Z'
              }))
            ],
            isError: false,
          );
        });

        await runtime.executeAction({
          "type": "tool",
          "tool": "getUserData",
          "args": {"userId": "123"}
        });

        // Verify all top-level keys were merged into state
        expect(runtime.state.get('user.id'), equals('123'));
        expect(runtime.state.get('user.name'), equals('John Doe'));
        expect(runtime.state.get('user.email'), equals('john@example.com'));
        expect(runtime.state.get('permissions'), equals(['read', 'write']));
        expect(runtime.state.get('lastLogin'), equals('2024-01-01T00:00:00Z'));
      });

      test('error tool response handling', () async {
        when(mockClient.callTool('saveData', any)).thenAnswer((_) async {
          return CallToolResult(
            content: [
              TextContent(text: jsonEncode({
                'error': 'Validation failed',
                'message': 'Email is required',
                'field': 'email'
              }))
            ],
            isError: true,
          );
        });

        var errorHandled = false;
        String? errorMessage;

        await runtime.executeAction({
          "type": "tool",
          "tool": "saveData",
          "args": {"data": {}},
          "onError": {
            "type": "custom",
            "handler": (error) {
              errorHandled = true;
              errorMessage = error['message'];
            }
          }
        });

        expect(errorHandled, isTrue);
        expect(errorMessage, equals('Email is required'));
        
        // Error responses are not merged into state
        expect(runtime.state.get('error'), isNull);
        expect(runtime.state.get('field'), isNull);
      });
    });

    group('Lifecycle Management', () {
      test('page initialization with resource subscriptions', () async {
        final pageDef = {
          "type": "page",
          "onInit": [
            {
              "type": "resource",
              "action": "subscribe",
              "uri": "ui://state/user",
              "binding": "user"
            },
            {
              "type": "tool",
              "tool": "loadPageData"
            }
          ],
          "content": {
            "type": "text",
            "content": "Page loaded"
          }
        };

        when(mockClient.callTool('loadPageData', any)).thenAnswer((_) async {
          return CallToolResult(
            content: [TextContent(text: '{"pageData": "loaded"}')],
            isError: false,
          );
        });

        await runtime.initializePage(pageDef);

        // Verify subscription was set up
        verify(mockClient.subscribeResource('ui://state/user')).called(1);
        
        // Tool이 호출되었는지 검증
        verify(mockClient.callTool('loadPageData', any)).called(1);
        
        // Verify state was set
        expect(runtime.state.get('pageData'), equals('loaded'));
      });

      test('page destruction with resource cleanup', () async {
        // 구독 설정
        runtime.subscriptions['ui://state/user'] = 'user';
        runtime.subscriptions['ui://stream/notifications'] = 'notifications';

        final pageDef = {
          "type": "page",
          "onDestroy": [
            {
              "type": "resource",
              "action": "unsubscribe",
              "uri": "ui://state/user"
            },
            {
              "type": "resource",
              "action": "unsubscribe",
              "uri": "ui://stream/notifications"
            },
            {
              "type": "tool",
              "tool": "savePageState"
            }
          ]
        };

        when(mockClient.callTool('savePageState', any)).thenAnswer((_) async {
          return CallToolResult(
            content: [TextContent(text: '{"saved": true}')],
            isError: false,
          );
        });

        await runtime.destroyPage(pageDef);

        // Verify subscriptions were unsubscribed
        verify(mockClient.unsubscribeResource('ui://state/user')).called(1);
        verify(mockClient.unsubscribeResource('ui://stream/notifications')).called(1);
        
        // Tool이 호출되었는지 검증
        verify(mockClient.callTool('savePageState', any)).called(1);
        
        // Verify subscription list was cleaned up
        expect(runtime.subscriptions.isEmpty, isTrue);
      });
    });
  });
}
```

### 3.6 Theme System Tests
```dart
// test/conformance/theme/theme_conformance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

void main() {
  group('Theme System Conformance', () {
    late MCPUIRuntime runtime;
    
    setUp(() {
      runtime = MCPUIRuntime();
    });

    test('complete theme definition parsing', () {
      final themeDef = {
        "mode": "light",
        "colors": {
          "primary": "#2196F3",
          "secondary": "#FF4081",
          "background": "#FFFFFF",
          "surface": "#F5F5F5",
          "error": "#F44336",
          "onPrimary": "#FFFFFF",
          "onSecondary": "#000000",
          "onBackground": "#000000",
          "onSurface": "#000000",
          "onError": "#FFFFFF"
        },
        "typography": {
          "h1": {"fontSize": 32, "fontWeight": "bold", "letterSpacing": -1.5},
          "h2": {"fontSize": 28, "fontWeight": "bold", "letterSpacing": -0.5},
          "h3": {"fontSize": 24, "fontWeight": "bold", "letterSpacing": 0},
          "h4": {"fontSize": 20, "fontWeight": "bold", "letterSpacing": 0.25},
          "h5": {"fontSize": 18, "fontWeight": "bold", "letterSpacing": 0},
          "h6": {"fontSize": 16, "fontWeight": "bold", "letterSpacing": 0.15},
          "body1": {"fontSize": 16, "fontWeight": "normal", "letterSpacing": 0.5},
          "body2": {"fontSize": 14, "fontWeight": "normal", "letterSpacing": 0.25},
          "caption": {"fontSize": 12, "fontWeight": "normal", "letterSpacing": 0.4},
          "button": {"fontSize": 14, "fontWeight": "medium", "letterSpacing": 1.25, "textTransform": "uppercase"}
        },
        "spacing": {
          "xs": 4, "sm": 8, "md": 16, "lg": 24, "xl": 32, "xxl": 48
        },
        "borderRadius": {
          "sm": 4, "md": 8, "lg": 16, "xl": 24, "round": 9999
        },
        "elevation": {
          "none": 0, "sm": 2, "md": 4, "lg": 8, "xl": 16
        }
      };

      runtime.setTheme(themeDef);

      // Verify all theme properties were set correctly
      expect(runtime.theme.mode, equals('light'));
      expect(runtime.theme.colors['primary'], equals('#2196F3'));
      expect(runtime.theme.typography['h1']['fontSize'], equals(32));
      expect(runtime.theme.spacing['md'], equals(16));
      expect(runtime.theme.borderRadius['round'], equals(9999));
      expect(runtime.theme.elevation['lg'], equals(8));
    });

    test('theme binding in widgets', () {
      runtime.setTheme({
        "colors": {"primary": "#2196F3", "surface": "#F5F5F5"},
        "spacing": {"md": 16},
        "borderRadius": {"md": 8}
      });

      final widgetDef = {
        "type": "container",
        "color": "{{theme.colors.surface}}",
        "padding": "{{theme.spacing.md}}",
        "borderRadius": "{{theme.borderRadius.md}}",
        "child": {
          "type": "text",
          "content": "Themed Widget",
          "style": {
            "color": "{{theme.colors.primary}}"
          }
        }
      };

      testWidgets('renders with theme values', (tester) async {
        await tester.pumpWidget(
          runtime.buildWidget(widgetDef)
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        
        expect(decoration.color, equals(Color(0xFFF5F5F5)));
        expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
        
        // Verify padding
        final padding = tester.widget<Padding>(
          find.descendant(
            of: find.byType(Container),
            matching: find.byType(Padding)
          ).first
        );
        expect(padding.padding, equals(EdgeInsets.all(16)));
      });
    });

    test('dark mode support', () {
      final appDef = {
        "type": "application",
        "theme": {
          "mode": "{{app.themeMode}}",
          "light": {
            "colors": {
              "primary": "#2196F3",
              "background": "#FFFFFF"
            }
          },
          "dark": {
            "colors": {
              "primary": "#1976D2",
              "background": "#121212"
            }
          }
        }
      };

      runtime.app.state.set('themeMode', 'light');
      runtime.initialize(appDef);
      
      expect(runtime.theme.colors['primary'], equals('#2196F3'));
      expect(runtime.theme.colors['background'], equals('#FFFFFF'));

      // Switch to dark mode
      runtime.app.state.set('themeMode', 'dark');
      runtime.updateTheme();
      
      expect(runtime.theme.colors['primary'], equals('#1976D2'));
      expect(runtime.theme.colors['background'], equals('#121212'));
    });

    test('page-specific theme override', () {
      runtime.setTheme({
        "colors": {"primary": "#2196F3"}
      });

      final pageDef = {
        "type": "page",
        "themeOverride": {
          "colors": {
            "primary": "#4CAF50"
          }
        },
        "content": {
          "type": "text",
          "content": "Page with custom theme"
        }
      };

      runtime.pushPage(pageDef);
      
      // Verify page theme was applied
      expect(runtime.currentTheme.colors['primary'], equals('#4CAF50'));
      
      runtime.popPage();
      
      // Verify theme was restored to original
      expect(runtime.currentTheme.colors['primary'], equals('#2196F3'));
    });
  });
}
```

### 3.7 Performance and Edge Case Tests
```dart
// test/performance/performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

void main() {
  group('Performance Tests', () {
    late MCPUIRuntime runtime;
    
    setUp(() {
      runtime = MCPUIRuntime();
    });

    test('large list rendering performance', () async {
      final items = List.generate(10000, (i) => {
        'id': i,
        'title': 'Item $i',
        'description': 'Description for item $i'
      });

      final listDef = {
        "type": "listview",
        "items": items,
        "virtual": true,
        "cacheExtent": 250,
        "itemTemplate": {
          "type": "container",
          "padding": {"all": 8},
          "child": {
            "type": "column",
            "children": [
              {"type": "text", "content": "{{item.title}}"},
              {"type": "text", "content": "{{item.description}}"}
            ]
          }
        }
      };

      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(
        runtime.buildWidget(listDef)
      );
      
      stopwatch.stop();
      
      // 초기 렌더링이 100ms 이내에 완료되어야 함
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      
      // 가상 스크롤이 활성화되어 있는지 검증
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.cacheExtent, equals(250));
    });

    test('deep state nesting performance', () {
      // 깊은 중첩 상태 생성
      var deepState = {};
      var current = deepState;
      for (int i = 0; i < 100; i++) {
        current['level$i'] = {};
        current = current['level$i'];
      }
      current['value'] = 'deep value';

      runtime.state.set('deep', deepState);

      final stopwatch = Stopwatch()..start();
      
      // 깊은 경로 접근
      final result = runtime.resolveBinding(
        '{{deep' + '.level${i}' * 100 + '.value}}'
      );
      
      stopwatch.stop();
      
      expect(result, equals('deep value'));
      // 깊은 경로 접근이 10ms 이내에 완료되어야 함
      expect(stopwatch.elapsedMilliseconds, lessThan(10));
    });

    test('multiple concurrent state updates', () async {
      final updates = List.generate(1000, (i) => 
        runtime.executeAction({
          "type": "state",
          "action": "set",
          "binding": "item$i",
          "value": i
        })
      );

      final stopwatch = Stopwatch()..start();
      
      await Future.wait(updates);
      
      stopwatch.stop();
      
      // 1000개의 동시 업데이트가 100ms 이내에 완료되어야 함
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      
      // 모든 업데이트가 적용되었는지 검증
      for (int i = 0; i < 1000; i++) {
        expect(runtime.state.get('item$i'), equals(i));
      }
    });
  });

  group('Edge Cases', () {
    late MCPUIRuntime runtime;
    
    setUp(() {
      runtime = MCPUIRuntime();
    });

    test('circular reference in state', () {
      final obj1 = {'name': 'obj1'};
      final obj2 = {'name': 'obj2', 'ref': obj1};
      obj1['ref'] = obj2; // 순환 참조

      expect(
        () => runtime.state.set('circular', obj1),
        throwsA(isA<StateError>())
      );
    });

    test('invalid widget type', () {
      final invalidWidget = {
        "type": "nonexistent_widget",
        "content": "Test"
      };

      expect(
        () => runtime.buildWidget(invalidWidget),
        throwsA(isA<UnknownWidgetError>())
      );
    });

    test('malformed binding expression', () {
      runtime.state.set('value', 'test');
      
      // 잘못된 바인딩 표현식들
      expect(runtime.resolveBinding('{{}}'), equals('{{}}'));
      expect(runtime.resolveBinding('{{value'), equals('{{value'));
      expect(runtime.resolveBinding('value}}'), equals('value}}'));
      expect(runtime.resolveBinding('{{{{value}}}}'), isNotNull);
    });

    test('null and undefined handling', () {
      runtime.state.set('nullValue', null);
      runtime.state.set('obj', {'nested': null});
      
      expect(runtime.resolveBinding('{{nullValue}}'), isNull);
      expect(runtime.resolveBinding('{{undefinedValue}}'), isNull);
      expect(runtime.resolveBinding('{{obj.nested}}'), isNull);
      expect(runtime.resolveBinding('{{obj.undefined.deep}}'), isNull);
      
      // Null safety operator
      expect(runtime.resolveBinding('{{nullValue ?? "default"}}'), equals('default'));
      expect(runtime.resolveBinding('{{obj.nested?.property}}'), isNull);
    });

    test('special characters in keys', () {
      runtime.state.set('key-with-dash', 'value1');
      runtime.state.set('key.with.dots', 'value2');
      runtime.state.set('key with spaces', 'value3');
      runtime.state.set('key@special#chars', 'value4');
      
      expect(runtime.resolveBinding('{{["key-with-dash"]}}'), equals('value1'));
      expect(runtime.resolveBinding('{{["key.with.dots"]}}'), equals('value2'));
      expect(runtime.resolveBinding('{{["key with spaces"]}}'), equals('value3'));
      expect(runtime.resolveBinding('{{["key@special#chars"]}}'), equals('value4'));
    });

    test('extremely long strings', () {
      final longString = 'x' * 1000000; // 1MB string
      runtime.state.set('longString', longString);
      
      final result = runtime.resolveBinding('{{longString}}');
      expect(result, equals(longString));
      
      // Verify it can be handled in text widget
      final textWidget = {
        "type": "text",
        "content": "{{longString}}"
      };
      
      expect(() => runtime.buildWidget(textWidget), returnsNormally);
    });

    test('widget without required properties', () {
      // Widgets without required properties
      final incompleteWidgets = [
        {"type": "text"}, // content 누락
        {"type": "image"}, // src 누락
        {"type": "button"}, // label 누락
        {"type": "listview"}, // items 누락
      ];

      for (final widget in incompleteWidgets) {
        expect(
          () => runtime.buildWidget(widget),
          throwsA(isA<ValidationError>()),
          reason: 'Widget ${widget['type']} should fail validation'
        );
      }
    });

    test('recursive widget definition', () {
      // 재귀적 위젯 정의 (무한 루프 방지 테스트)
      final recursiveDef = {
        "type": "container",
        "child": null
      };
      recursiveDef['child'] = recursiveDef; // 자기 참조

      expect(
        () => runtime.buildWidget(recursiveDef),
        throwsA(isA<StackOverflowError>())
      );
    });
  });
}
```

### 3.8 자동화된 검증 스크립트
```dart
// test/run_conformance_tests.dart
import 'dart:io';
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

void main() async {
  print('MCP UI DSL v1.0 Conformance Test Suite');
  print('=====================================\n');

  final testResults = <String, TestResult>{};

  // 모든 테스트 카테고리 실행
  await runTestCategory('Structure', 'test/conformance/structure/');
  await runTestCategory('Widgets', 'test/conformance/widgets/');
  await runTestCategory('Data Binding', 'test/conformance/binding/');
  await runTestCategory('Actions', 'test/conformance/actions/');
  await runTestCategory('Navigation', 'test/conformance/navigation/');
  await runTestCategory('Theme', 'test/conformance/theme/');
  await runTestCategory('Lifecycle', 'test/conformance/lifecycle/');
  await runTestCategory('MCP Integration', 'test/integration/mcp_protocol/');
  await runTestCategory('Performance', 'test/performance/');
  await runTestCategory('Edge Cases', 'test/edge_cases/');

  // 결과 요약
  printSummary(testResults);
  
  // 적합성 보고서 생성
  generateConformanceReport(testResults);
}

Future<void> runTestCategory(String category, String path) async {
  print('Running $category tests...');
  
  final result = await Process.run('flutter', ['test', path]);
  
  if (result.exitCode == 0) {
    print('✓ $category tests passed\n');
  } else {
    print('✗ $category tests failed');
    print(result.stdout);
    print(result.stderr);
    print('');
  }
}

void generateConformanceReport(Map<String, TestResult> results) {
  final report = StringBuffer();
  
  report.writeln('# MCP UI DSL v1.0 Conformance Report');
  report.writeln('Generated: ${DateTime.now().toIso8601String()}\n');
  
  report.writeln('## Summary');
  report.writeln('- Total Categories: ${results.length}');
  report.writeln('- Passed: ${results.values.where((r) => r.passed).length}');
  report.writeln('- Failed: ${results.values.where((r) => !r.passed).length}\n');
  
  report.writeln('## Detailed Results');
  
  for (final entry in results.entries) {
    report.writeln('\n### ${entry.key}');
    report.writeln('- Status: ${entry.value.passed ? "✓ PASSED" : "✗ FAILED"}');
    report.writeln('- Tests: ${entry.value.totalTests}');
    report.writeln('- Passed: ${entry.value.passedTests}');
    report.writeln('- Failed: ${entry.value.failedTests}');
    
    if (!entry.value.passed) {
      report.writeln('\nFailed Tests:');
      for (final test in entry.value.failedTestNames) {
        report.writeln('- $test');
      }
    }
  }
  
  report.writeln('\n## Conformance Level');
  final conformanceScore = calculateConformanceScore(results);
  report.writeln('- Score: ${conformanceScore.toStringAsFixed(1)}%');
  report.writeln('- Level: ${getConformanceLevel(conformanceScore)}');
  
  File('conformance_report.md').writeAsStringSync(report.toString());
  print('\nConformance report generated: conformance_report.md');
}

double calculateConformanceScore(Map<String, TestResult> results) {
  final totalTests = results.values.fold(0, (sum, r) => sum + r.totalTests);
  final passedTests = results.values.fold(0, (sum, r) => sum + r.passedTests);
  
  return (passedTests / totalTests) * 100;
}

String getConformanceLevel(double score) {
  if (score == 100) return 'Full Conformance';
  if (score >= 95) return 'High Conformance';
  if (score >= 80) return 'Good Conformance';
  if (score >= 60) return 'Partial Conformance';
  return 'Low Conformance';
}

class TestResult {
  final bool passed;
  final int totalTests;
  final int passedTests;
  final int failedTests;
  final List<String> failedTestNames;

  TestResult({
    required this.passed,
    required this.totalTests,
    required this.passedTests,
    required this.failedTests,
    required this.failedTestNames,
  });
}
```

## 4. 테스트 실행 및 검증

### 4.1 테스트 실행 명령
```bash
# 모든 준수 테스트 실행
flutter test test/conformance/

# 특정 카테고리 테스트
flutter test test/conformance/widgets/

# 상세 결과와 함께 실행
flutter test --reporter expanded

# 적합성 검증 스크립트 실행
dart test/run_conformance_tests.dart
```

### 4.2 CI/CD 통합
```yaml
# .github/workflows/conformance.yml
name: MCP UI DSL Conformance Tests

on: [push, pull_request]

jobs:
  conformance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart test/run_conformance_tests.dart
      - uses: actions/upload-artifact@v2
        with:
          name: conformance-report
          path: conformance_report.md
```

이 테스트 구성은 MCP UI DSL v1.0 사양의 모든 측면을 철저히 검증하며, 구현이 100% 준수하는지 확인할 수 있습니다.