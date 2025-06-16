import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('flutter_mcp_ui_core', () {
    test('should export all core classes', () {
      // Test that all main classes are available
      expect(UIDefinition, isNotNull);
      expect(WidgetConfig, isNotNull);
      expect(ActionConfig, isNotNull);
      expect(BindingConfig, isNotNull);
      expect(ThemeConfig, isNotNull);
      expect(ApplicationConfig, isNotNull);
      expect(PageConfig, isNotNull);
      expect(PropertySpec, isNotNull);
      
      expect(WidgetTypes, isNotNull);
      expect(PropertyKeys, isNotNull);
      expect(Defaults, isNotNull);
      expect(MCPUIDSLVersion, isNotNull);
      
      expect(UIValidator, isNotNull);
      expect(JsonUtils, isNotNull);
      expect(TypeConverters, isNotNull);
      expect(PropertyHelpers, isNotNull);
      
      expect(UIException, isNotNull);
      expect(ValidationException, isNotNull);
    });

    test('should have correct DSL version', () {
      expect(MCPUIDSLVersion.current, equals('1.0.0'));
      expect(MCPUIDSLVersion.supported, contains('1.0.0'));
      expect(MCPUIDSLVersion.isCompatible('1.0.0'), isTrue);
      expect(MCPUIDSLVersion.isCompatible('2.0.0'), isFalse);
    });

    test('should create basic UI definition', () {
      final definition = UIDefinition(
        layout: WidgetConfig(
          type: WidgetTypes.text,
          properties: {PropertyKeys.content: 'Hello World'},
        ),
        dslVersion: '1.0.0',
      );

      expect(definition.layout.type, equals(WidgetTypes.text));
      expect(definition.dslVersion, equals('1.0.0'));
      expect(definition.layout.properties[PropertyKeys.content], equals('Hello World'));
    });

    test('should validate widget types', () {
      expect(WidgetTypes.isValidType(WidgetTypes.container), isTrue);
      expect(WidgetTypes.isValidType(WidgetTypes.text), isTrue);
      expect(WidgetTypes.isValidType('unknown'), isFalse);
      
      expect(WidgetTypes.getCategoryForType(WidgetTypes.container), equals('layout'));
      expect(WidgetTypes.getCategoryForType(WidgetTypes.text), equals('display'));
      expect(WidgetTypes.getCategoryForType(WidgetTypes.button), equals('input'));
    });

    test('should handle type conversion', () {
      expect(TypeConverters.toInt('123'), equals(123));
      expect(TypeConverters.toInt('invalid', 0), equals(0));
      
      expect(TypeConverters.toDouble('12.5'), equals(12.5));
      expect(TypeConverters.toDouble('invalid', 0.0), equals(0.0));
      
      expect(TypeConverters.toBool('true'), isTrue);
      expect(TypeConverters.toBool('false'), isFalse);
      expect(TypeConverters.toBool('invalid', false), isFalse);
      
      expect(TypeConverters.toColorHex('red'), equals('#FFF44336'));
      expect(TypeConverters.toColorHex('#FF0000'), equals('#FF0000'));
    });

    test('should handle JSON utilities', () {
      final json = {'user': {'name': 'John', 'age': 30}};
      
      expect(JsonUtils.getValueAtPath(json, 'user.name'), equals('John'));
      expect(JsonUtils.getValueAtPath(json, 'user.age'), equals(30));
      expect(JsonUtils.getValueAtPath(json, 'user.invalid'), isNull);
      
      final copy = JsonUtils.deepCopy(json);
      expect(copy, equals(json));
      expect(identical(copy, json), isFalse);
      
      JsonUtils.setValueAtPath(copy, 'user.name', 'Jane');
      expect((copy['user'] as Map)['name'], equals('Jane'));
      expect((json['user'] as Map)['name'], equals('John')); // Original unchanged
    });

    test('should create ThemeConfig with defaults', () {
      final theme = ThemeConfig(mode: 'light');
      expect(theme.mode, equals('light'));
      
      final defaultLight = ThemeConfig.defaultLight();
      expect(defaultLight.mode, equals('light'));
      expect(defaultLight.colors?['primary'], equals('#2196F3'));
      
      final defaultDark = ThemeConfig.defaultDark();
      expect(defaultDark.mode, equals('dark'));
      expect(defaultDark.colors?['background'], equals('#121212'));
    });

    test('should create ApplicationConfig', () {
      final app = ApplicationConfig(
        title: 'Test App',
        version: '1.0.0',
        routes: {'/': 'home', '/settings': 'settings'},
      );
      
      expect(app.title, equals('Test App'));
      expect(app.version, equals('1.0.0'));
      expect(app.initialRoute, equals('/'));
      expect(app.routes['/'], equals('home'));
      
      final json = app.toJson();
      expect(json['type'], equals('application'));
      expect(json['title'], equals('Test App'));
      
      final fromJson = ApplicationConfig.fromJson(json);
      expect(fromJson.title, equals(app.title));
      expect(fromJson.version, equals(app.version));
    });

    test('should create PageConfig', () {
      final page = PageConfig(
        title: 'Home Page',
        route: '/',
        content: {'type': 'container', 'children': []},
      );
      
      expect(page.title, equals('Home Page'));
      expect(page.route, equals('/'));
      expect(page.type, equals('page'));
      expect(page.content['type'], equals('container'));
      
      final json = page.toJson();
      expect(json['type'], equals('page'));
      expect(json['title'], equals('Home Page'));
      
      final fromJson = PageConfig.fromJson(json);
      expect(fromJson.title, equals(page.title));
      expect(fromJson.route, equals(page.route));
    });
  });
}