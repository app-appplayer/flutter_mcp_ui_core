# MCP UI DSL v1.0 완전 준수 검증 테스트 설계

## 1. 테스트 구조 개요

### 1.1 테스트 카테고리
```
tests/
├── conformance/              # DSL 사양 준수 테스트
│   ├── structure/           # 구조적 요소 테스트
│   ├── widgets/             # 위젯 테스트
│   ├── binding/             # 데이터 바인딩 테스트
│   ├── actions/             # 액션 시스템 테스트
│   ├── navigation/          # 네비게이션 테스트
│   ├── theme/               # 테마 시스템 테스트
│   └── lifecycle/           # 라이프사이클 테스트
├── integration/             # 통합 테스트
│   ├── mcp_protocol/        # MCP 프로토콜 통합
│   ├── state_management/    # 상태 관리 통합
│   └── runtime/             # 런타임 동작
├── performance/             # 성능 테스트
├── edge_cases/              # 엣지 케이스
└── visual_regression/       # 시각적 회귀 테스트
```

### 1.2 테스트 레벨
1. **Unit Tests**: 개별 컴포넌트 동작 검증
2. **Widget Tests**: 위젯 렌더링 및 속성 검증
3. **Integration Tests**: 시스템 간 통합 검증
4. **E2E Tests**: 전체 애플리케이션 플로우 검증

## 2. DSL 사양 준수 체크리스트

### 2.1 구조적 요소
- [ ] Application 정의 검증
- [ ] Page 정의 검증
- [ ] 라우팅 테이블 검증
- [ ] 초기 상태 설정 검증
- [ ] 테마 정의 검증

### 2.2 위젯 시스템
- [ ] 모든 레이아웃 위젯 (Container, Column, Row, Stack, Center, Expanded, Flexible)
- [ ] 모든 디스플레이 위젯 (Text, Image, Icon, Divider, Card)
- [ ] 모든 입력 위젯 (Button, TextField, Checkbox, Switch, Slider)
- [ ] 모든 리스트 위젯 (ListView, GridView)
- [ ] 고급 위젯 (Chart, Table)

### 2.3 데이터 바인딩
- [ ] 단순 바인딩 표현식
- [ ] 중첩 속성 접근
- [ ] 배열 인덱스 접근
- [ ] 조건부 표현식
- [ ] 혼합 콘텐츠
- [ ] 컨텍스트 변수 (item, index, isFirst, isLast, isEven, isOdd)

### 2.4 액션 시스템
- [ ] State Actions (set, increment, decrement, toggle, append, remove)
- [ ] Navigation Actions (push, replace, pop, popToRoot)
- [ ] Tool Actions (기본 호출, 성공/실패 핸들링)
- [ ] Resource Actions (subscribe, unsubscribe)
- [ ] Batch Actions
- [ ] Conditional Actions

### 2.5 MCP 프로토콜 통합
- [ ] Resource 읽기
- [ ] Tool 호출 및 응답 처리
- [ ] 알림 처리
- [ ] 구독/구독 해제

## 3. 상세 테스트 케이스

### 3.1 Application 정의 테스트
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
      
      // 모든 필수 속성이 파싱되었는지 검증
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
      expect(runtime.version, equals("1.0.0")); // 기본값
      expect(runtime.initialRoute, equals("/")); // 첫 번째 라우트
    });

    test('should validate required fields', () {
      final invalidApp = {
        "type": "application"
        // title 누락
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

### 3.2 위젯 준수 테스트
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

          // Container 속성 검증
          final container = tester.widget<Container>(find.byType(Container));
          expect(container.constraints?.maxWidth, equals(200));
          expect(container.constraints?.maxHeight, equals(100));
          
          // Decoration 검증
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.color, equals(Color(0xFFFFFFFF)));
          expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
          expect(decoration.border?.top.width, equals(1));
          
          // Child 존재 검증
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

      // Row, Stack, Center, Expanded, Flexible 테스트...
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

      // Image, Icon, Divider, Card 테스트...
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

            // 버튼 타입에 따른 위젯 찾기
            expect(find.text('Test Button'), findsOneWidget);
            expect(find.byIcon(Icons.add), findsOneWidget);
            
            // 탭 이벤트 테스트
            await tester.tap(find.byType(InkWell));
            await tester.pump();
            
            // onTap 액션이 트리거되었는지 검증
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

          // 빈 값으로 검증
          await tester.enterText(find.byType(TextField), '');
          await tester.pump();
          expect(runtime.state['form']['errors']['email'], 
            equals('Email is required'));

          // 잘못된 이메일 형식으로 검증
          await tester.enterText(find.byType(TextField), 'invalid-email');
          await tester.pump();
          expect(runtime.state['form']['errors']['email'], 
            equals('Invalid email format'));

          // 올바른 이메일로 검증
          await tester.enterText(find.byType(TextField), 'test@example.com');
          await tester.pump();
          expect(runtime.state['form']['errors']['email'], isNull);
          expect(runtime.state['form']['email'], equals('test@example.com'));
        });
      });

      // Checkbox, Switch, Slider 테스트...
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

          // 아이템 렌더링 검증
          expect(find.text('1. Item 1'), findsOneWidget);
          expect(find.text('2. Item 2'), findsOneWidget);
          expect(find.text('3. Item 3'), findsOneWidget);

          // 인덱스 검증
          expect(find.text('Index: 0'), findsOneWidget);
          expect(find.text('Index: 1'), findsOneWidget);
          expect(find.text('Index: 2'), findsOneWidget);

          // ListView 속성 검증
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

            // 첫 번째 아이템 (index 0)
            expect(find.text('First'), findsOneWidget);
            expect(find.text('Even'), findsNWidgets(2)); // index 0, 2

            // 마지막 아이템 (index 2)
            expect(find.text('Last'), findsOneWidget);

            // 홀수 인덱스
            expect(find.text('Odd'), findsOneWidget); // index 1
          });
        });
      });

      // GridView 테스트...
    });
  });
}
```

### 3.3 데이터 바인딩 테스트
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

        // 리소스가 다시 읽혔는지 검증
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

        // 리소스 읽기가 호출되지 않았는지 검증 (콘텐츠가 이미 포함됨)
        verifyNever(mockClient.readResource(any));
        
        // 상태가 직접 업데이트되었는지 검증
        expect(runtime.state.get('temperature.value'), equals(23.5));
        expect(runtime.state.get('temperature.unit'), equals('celsius'));
      });

      test('multiple subscriptions handling', () async {
        // 여러 구독 설정
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

        // CPU 업데이트
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

        // Memory 업데이트
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

        // 상태 검증
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

        // 모든 최상위 키가 상태에 병합되었는지 검증
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
        
        // 에러 응답은 상태에 병합되지 않음
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

        // 구독이 설정되었는지 검증
        verify(mockClient.subscribeResource('ui://state/user')).called(1);
        
        // Tool이 호출되었는지 검증
        verify(mockClient.callTool('loadPageData', any)).called(1);
        
        // 상태가 설정되었는지 검증
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

        // 구독이 해제되었는지 검증
        verify(mockClient.unsubscribeResource('ui://state/user')).called(1);
        verify(mockClient.unsubscribeResource('ui://stream/notifications')).called(1);
        
        // Tool이 호출되었는지 검증
        verify(mockClient.callTool('savePageState', any)).called(1);
        
        // 구독 목록이 정리되었는지 검증
        expect(runtime.subscriptions.isEmpty, isTrue);
      });
    });
  });
}
```

### 3.6 테마 시스템 테스트
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

      // 모든 테마 속성이 올바르게 설정되었는지 검증
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
        
        // Padding 검증
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

      // 다크 모드로 전환
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
      
      // 페이지 테마가 적용되었는지 검증
      expect(runtime.currentTheme.colors['primary'], equals('#4CAF50'));
      
      runtime.popPage();
      
      // 원래 테마로 복원되었는지 검증
      expect(runtime.currentTheme.colors['primary'], equals('#2196F3'));
    });
  });
}
```

### 3.7 성능 및 엣지 케이스 테스트
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
      
      // Null 안전 연산자
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
      final longString = 'x' * 1000000; // 1MB 문자열
      runtime.state.set('longString', longString);
      
      final result = runtime.resolveBinding('{{longString}}');
      expect(result, equals(longString));
      
      // 텍스트 위젯에서도 처리되는지 확인
      final textWidget = {
        "type": "text",
        "content": "{{longString}}"
      };
      
      expect(() => runtime.buildWidget(textWidget), returnsNormally);
    });

    test('widget without required properties', () {
      // 필수 속성이 없는 위젯들
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