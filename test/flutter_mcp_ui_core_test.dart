import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('flutter_mcp_ui_core', () {
    test('should export all core classes', () {
      // Test that all main classes are available
      expect(WidgetConfig, isNotNull);
      expect(ActionConfig, isNotNull);
      expect(BindingConfig, isNotNull);
      expect(ThemeDefinition, isNotNull);
      expect(ColorSchemeDefinition, isNotNull);
      expect(TypographyDefinition, isNotNull);
      expect(SpacingDefinition, isNotNull);
      expect(ShapeDefinition, isNotNull);
      expect(ElevationDefinition, isNotNull);
      expect(MotionDefinition, isNotNull);
      expect(DensityDefinition, isNotNull);
      expect(BreakpointsDefinition, isNotNull);
      expect(BorderDefinition, isNotNull);
      expect(OpacityDefinition, isNotNull);
      expect(FocusRingDefinition, isNotNull);
      expect(ZIndexDefinition, isNotNull);
      expect(ComponentTokensDefinition, isNotNull);
      expect(SeedPalette, isNotNull);
      expect(DtcgCodec, isNotNull);
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
      expect(MCPUIDSLVersion.current, equals('1.3'));
      expect(MCPUIDSLVersion.minimum, equals('1.3'));
      expect(MCPUIDSLVersion.supported, equals(['1.3']));
      expect(MCPUIDSLVersion.isCompatible('1.3'), isTrue);
      expect(MCPUIDSLVersion.isCompatible('1.3.0'), isTrue);
      expect(MCPUIDSLVersion.isCompatible('1.2.0'), isFalse);
      expect(MCPUIDSLVersion.isCompatible('2.0.0'), isFalse);
    });

    test('should create basic widget configuration', () {
      final widget = WidgetConfig(
        type: WidgetTypes.text,
        properties: {PropertyKeys.content: 'Hello World'},
      );

      expect(widget.type, equals(WidgetTypes.text));
      expect(widget.properties[PropertyKeys.content], equals('Hello World'));
    });

    test('should validate widget types', () {
      expect(WidgetTypes.isValidType(WidgetTypes.box), isTrue);
      expect(WidgetTypes.isValidType(WidgetTypes.text), isTrue);
      expect(WidgetTypes.isValidType('unknown'), isFalse);
      
      expect(WidgetTypes.getCategoryForType(WidgetTypes.box), equals('layout'));
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

    test('ThemeDefinition default light/dark — M3 + HCT seed', () {
      final light = ThemeDefinition.defaultLight();
      expect(light.mode, equals('light'));
      expect(light.color, isNotNull);
      expect(light.color!.primary, isNotNull);
      expect(light.typography?.bodyLarge?.fontSize, equals(16));
      expect(light.spacing?.md, equals(16));
      expect(light.shape?.full?.uniform, equals(9999));
      expect(light.elevation?.level3?.shadow, equals(6));

      final dark = ThemeDefinition.defaultDark();
      expect(dark.mode, equals('dark'));
      expect(dark.color, isNotNull);
      expect(dark.color!.primary, isNotNull);
      expect(dark.color!.primary, isNot(equals(light.color!.primary)));
    });

    test('ThemeDefinition DTCG round-trip', () {
      final original = ThemeDefinition.defaultLight();
      final dtcg = original.toDtcg();
      expect(dtcg['mode'], equals('light'));
      expect(dtcg['color'], isNotNull);
      // Spacing dimension wrapper.
      expect((dtcg['spacing'] as Map)['md'][r'$type'], equals('dimension'));
      expect((dtcg['spacing'] as Map)['md'][r'$value'], equals('16px'));
      // Re-import.
      final reimported = ThemeDefinition.fromDtcg(dtcg);
      expect(reimported.mode, equals('light'));
      expect(reimported.color?.primary, equals(original.color?.primary));
      expect(reimported.spacing?.md, equals(16));
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
        content: {'type': 'box', 'children': []},
      );
      
      expect(page.title, equals('Home Page'));
      expect(page.route, equals('/'));
      expect(page.type, equals('page'));
      expect(page.content['type'], equals('box'));
      
      final json = page.toJson();
      expect(json['type'], equals('page'));
      expect(json['title'], equals('Home Page'));
      
      final fromJson = PageConfig.fromJson(json);
      expect(fromJson.title, equals(page.title));
      expect(fromJson.route, equals(page.route));
    });

    test('should create ActionConfig instances', () {
      // Tool action
      final toolAction = ActionConfig.tool('submitForm', {'data': '{{formData}}'});
      expect(toolAction.type, equals('tool'));
      expect(toolAction.toolName, equals('submitForm'));
      expect(toolAction.toolParams?['data'], equals('{{formData}}'));

      // State action
      final stateAction = ActionConfig.state(
        action: 'set',
        binding: 'user.name',
        value: 'John',
      );
      expect(stateAction.type, equals('state'));
      expect(stateAction.stateAction, equals('set'));
      expect(stateAction.stateBinding, equals('user.name'));
      expect(stateAction.stateValue, equals('John'));

      // Navigation action
      final navAction = ActionConfig.navigation(
        action: 'push',
        route: '/dashboard',
        params: {'id': '123'},
      );
      expect(navAction.type, equals('navigation'));
      expect(navAction.navigationAction, equals('push'));
      expect(navAction.navigationRoute, equals('/dashboard'));
      expect(navAction.navigationParams?['id'], equals('123'));

      // Batch action
      final batchAction = ActionConfig.batch([toolAction, stateAction]);
      expect(batchAction.type, equals('batch'));
      expect(batchAction.actions, hasLength(2));

      // Conditional action
      final conditionalAction = ActionConfig.conditional(
        condition: '{{user.isLoggedIn}}',
        thenAction: navAction,
        elseAction: stateAction,
      );
      expect(conditionalAction.type, equals('conditional'));
      expect(conditionalAction.condition, equals('{{user.isLoggedIn}}'));
      expect(conditionalAction.thenAction, equals(navAction));
      expect(conditionalAction.elseAction, equals(stateAction));
    });

    test('should validate ActionConfig', () {
      // Valid actions
      expect(ActionConfig.tool('test', {}).isValid(), isTrue);
      expect(ActionConfig.state(action: 'set', binding: 'value').isValid(), isTrue);
      expect(ActionConfig.navigation(action: 'push', route: '/test').isValid(), isTrue);

      // Invalid actions
      expect(ActionConfig.tool('', {}).isValid(), isFalse);
      expect(ActionConfig.state(action: '', binding: 'value').isValid(), isFalse);
      expect(ActionConfig.navigation(action: '', route: '/test').isValid(), isFalse);
    });

    test('should serialize and deserialize ActionConfig', () {
      final original = ActionConfig.conditional(
        condition: '{{isActive}}',
        thenAction: ActionConfig.state(action: 'set', binding: 'status', value: 'active'),
        elseAction: ActionConfig.tool('deactivate', {'reason': 'inactive'}),
      );

      final json = original.toJson();
      final restored = ActionConfig.fromJson(json);

      expect(restored.type, equals(original.type));
      expect(restored.condition, equals(original.condition));
      expect(restored.thenAction?.type, equals(original.thenAction?.type));
      expect(restored.elseAction?.type, equals(original.elseAction?.type));
    });
  });
}