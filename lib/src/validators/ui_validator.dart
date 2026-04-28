import '../constants/widget_types.dart';
import '../models/widget_config.dart';
import '../models/action_config.dart';
import '../models/binding_config.dart';
import '../models/application_config.dart';
import '../models/page_config.dart';
import '../exceptions/validation_exception.dart';
import 'schema_definitions.dart';

/// Comprehensive validator for MCP UI DSL
class UIValidator {
  /// Validate an application configuration
  static ValidationResult validateApplicationConfig(ApplicationConfig config) {
    final errors = <ValidationError>[];
    
    // Validate required fields
    if (config.title.isEmpty) {
      errors.add(ValidationError.requiredField('title'));
    }
    
    if (config.version.isEmpty) {
      errors.add(ValidationError.requiredField('version'));
    }
    
    if (config.routes.isEmpty) {
      errors.add(ValidationError.requiredField('routes'));
    }
    
    // Validate initial route exists in routes
    if (!config.routes.containsKey(config.initialRoute)) {
      errors.add(ValidationError.invalidValue(
        'initialRoute',
        config.initialRoute,
        'Initial route must exist in routes map',
      ));
    }
    
    // Validate theme if present
    if (config.theme != null) {
      errors.addAll(_validateTheme(config.theme!));
    }
    
    // Validate navigation if present
    if (config.navigation != null) {
      errors.addAll(_validateNavigation(config.navigation!));
    }
    
    // Validate initial state if present
    if (config.state != null && config.state!['initial'] != null) {
      errors.addAll(_validateState(config.state!['initial'] as Map<String, dynamic>));
    }
    
    return ValidationResult.fromErrors(errors);
  }
  
  /// Validate a page configuration
  static ValidationResult validatePageConfig(PageConfig config) {
    final errors = <ValidationError>[];
    
    // Validate content (required)
    final contentResult = _validateWidget(
      WidgetConfig.fromJson(config.content),
      'content'
    );
    errors.addAll(contentResult.errors);
    
    // Validate theme override if present
    if (config.themeOverride != null) {
      errors.addAll(_validateTheme(config.themeOverride!));
    }
    
    // Validate initial state if present
    if (config.state != null && config.state!['initial'] != null) {
      errors.addAll(_validateState(config.state!['initial'] as Map<String, dynamic>));
    }
    
    return ValidationResult.fromErrors(errors);
  }

  /// Validate a widget configuration
  static ValidationResult validateWidget(WidgetConfig widget) {
    return ValidationResult.fromErrors(_validateWidget(widget, 'widget').errors);
  }

  /// Validate an action configuration
  static ValidationResult validateAction(ActionConfig action) {
    return ValidationResult.fromErrors(_validateAction(action));
  }

  /// Validate a binding configuration
  static ValidationResult validateBinding(BindingConfig binding) {
    return ValidationResult.fromErrors(_validateBinding(binding));
  }

  /// Validate a theme configuration
  static ValidationResult validateTheme(Map<String, dynamic> theme) {
    return ValidationResult.fromErrors(_validateTheme(theme));
  }

  /// Validate JSON against MCP UI DSL schema
  static ValidationResult validateJson(Map<String, dynamic> json) {
    final errors = <ValidationError>[];
    
    try {
      // Check for type field to determine validation path
      final type = json['type'] as String?;
      
      if (type == 'application') {
        // Validate required fields before creating ApplicationConfig
        if (!json.containsKey('title') || json['title'] == null || (json['title'] as String).isEmpty) {
          errors.add(ValidationError(
            message: 'Required field missing: title',
            code: 'REQUIRED_FIELD',
            severity: ValidationSeverity.error,
            path: 'title',
          ));
        }
        if (!json.containsKey('version') || json['version'] == null || (json['version'] as String).isEmpty) {
          errors.add(ValidationError(
            message: 'Required field missing: version',
            code: 'REQUIRED_FIELD',
            severity: ValidationSeverity.error,
            path: 'version',
          ));
        }
        if (!json.containsKey('routes') || json['routes'] == null || (json['routes'] as Map).isEmpty) {
          errors.add(ValidationError(
            message: 'Required field missing: routes',
            code: 'REQUIRED_FIELD',
            severity: ValidationSeverity.error,
            path: 'routes',
          ));
        }
        
        // If we have errors already, return them
        if (errors.isNotEmpty) {
          return ValidationResult.fromErrors(errors);
        }
        
        // Validate as application
        try {
          final appConfig = ApplicationConfig.fromJson(json);
          return validateApplicationConfig(appConfig);
        } catch (e) {
          errors.add(ValidationError(
            message: 'Invalid application configuration: ${e.toString()}',
            code: 'INVALID_APPLICATION',
            severity: ValidationSeverity.error,
          ));
        }
      } else if (type == 'page') {
        // Validate as page
        try {
          final pageConfig = PageConfig.fromJson(json);
          return validatePageConfig(pageConfig);
        } catch (e) {
          errors.add(ValidationError(
            message: 'Invalid page configuration: ${e.toString()}',
            code: 'INVALID_PAGE',
            severity: ValidationSeverity.error,
          ));
        }
      } else if (json.containsKey('type') && WidgetTypes.isValidType(json['type'] as String)) {
        // Validate as widget
        try {
          final widget = WidgetConfig.fromJson(json);
          return validateWidget(widget);
        } catch (e) {
          errors.add(ValidationError(
            message: 'Invalid widget configuration: ${e.toString()}',
            code: 'INVALID_WIDGET',
            severity: ValidationSeverity.error,
          ));
        }
      } else if (json.containsKey('type')) {
        // Has type but it's not a valid widget type
        final typeValue = json['type'];
        if (typeValue is String && typeValue.isNotEmpty) {
          // Check if it's a known invalid type (like column, row, etc.)
          errors.add(ValidationError(
            message: 'Unknown widget type: $typeValue',
            code: 'UNKNOWN_WIDGET_TYPE',
            severity: ValidationSeverity.error,
            path: 'type',
          ));
        } else {
          errors.add(ValidationError(
            message: 'Invalid type value',
            code: 'INVALID_TYPE',
            severity: ValidationSeverity.error,
            path: 'type',
          ));
        }
      } else {
        // No type field at all
        errors.add(ValidationError(
          message: 'Unknown UI structure. Expected type: "application", "page", or valid widget type',
          code: 'UNKNOWN_STRUCTURE',
          severity: ValidationSeverity.error,
          path: 'type',
        ));
      }
    } catch (e) {
      errors.add(ValidationError(
        message: 'Failed to parse JSON: ${e.toString()}',
        code: 'JSON_PARSE_ERROR',
        severity: ValidationSeverity.error,
      ));
    }
    
    return ValidationResult.fromErrors(errors);
  }

  // Private validation methods

  static ValidationResult _validateWidget(WidgetConfig widget, [String path = 'layout']) {
    final errors = <ValidationError>[];
    
    // Validate widget type
    if (widget.type.isEmpty) {
      errors.add(ValidationError.requiredField('$path.type'));
    } else if (!WidgetTypes.isValidType(widget.type)) {
      errors.add(ValidationError.invalidValue(
        '$path.type',
        widget.type,
        'Unknown widget type',
      ));
    }
    
    // Validate properties
    errors.addAll(_validateWidgetProperties(widget, path));
    
    // Validate children
    if (widget.hasChildren) {
      if (!widget.canHaveChildren) {
        errors.add(ValidationError.invalidValue(
          '$path.children',
          'children not allowed',
          'Widget type "${widget.type}" cannot have children',
        ));
      } else {
        for (int i = 0; i < widget.children.length; i++) {
          final childResult = _validateWidget(widget.children[i], '$path.children[$i]');
          errors.addAll(childResult.errors);
        }
      }
    }
    
    // Validate actions in properties
    for (final entry in widget.properties.entries) {
      if (entry.key.startsWith('on') && entry.value is Map<String, dynamic>) {
        try {
          final action = ActionConfig.fromJson(entry.value as Map<String, dynamic>);
          errors.addAll(_validateAction(action, '$path.properties.${entry.key}'));
        } catch (e) {
          errors.add(ValidationError.invalidValue(
            '$path.properties.${entry.key}',
            entry.value,
            'Invalid action configuration',
          ));
        }
      }
    }
    
    return ValidationResult.fromErrors(errors);
  }

  static List<ValidationError> _validateWidgetProperties(WidgetConfig widget, String path) {
    final errors = <ValidationError>[];
    final specs = SchemaDefinitions.getWidgetPropertySpecs(widget.type);
    
    if (specs == null) {
      // Widget type not found in specs, skip property validation
      return errors;
    }
    
    // Check required properties
    for (final entry in specs.entries) {
      if (entry.value.required && !widget.properties.containsKey(entry.key)) {
        errors.add(ValidationError.requiredField('$path.properties.${entry.key}'));
      }
    }
    
    // Validate existing properties
    for (final entry in widget.properties.entries) {
      final spec = specs[entry.key];
      final propertyPath = '$path.properties.${entry.key}';
      
      if (spec == null) {
        // Unknown property - add warning
        errors.add(ValidationError(
          message: 'Unknown property "${entry.key}" for widget "${widget.type}"',
          code: 'UNKNOWN_PROPERTY',
          path: propertyPath,
          severity: ValidationSeverity.warning,
        ));
      } else {
        // Validate against spec
        if (!spec.isValid(entry.value)) {
          errors.add(ValidationError.invalidValue(
            propertyPath,
            entry.value,
            'Does not meet property specification',
          ));
        }
        
        // Check for deprecated properties
        if (spec.isDeprecated) {
          errors.add(ValidationError.deprecatedUsage(
            propertyPath,
            spec.deprecatedInVersion!,
            spec.replacedBy,
          ));
        }
      }
    }
    
    return errors;
  }

  static List<ValidationError> _validateAction(ActionConfig action, [String path = 'action']) {
    final errors = <ValidationError>[];
    
    // Validate action type
    if (action.type.isEmpty) {
      errors.add(ValidationError.requiredField('$path.type'));
      return errors;
    }
    
    // Validate based on action type
    switch (action.type) {
      case 'tool':
        if (action.toolName == null || action.toolName!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.tool'));
        }
        break;
        
      case 'state':
        if (action.stateAction == null || action.stateAction!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.action'));
        }
        if (action.stateBinding == null || action.stateBinding!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.binding'));
        }
        break;
        
      case 'navigation':
        if (action.navigationAction == null || action.navigationAction!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.action'));
        }
        // Route is only required for push and replace actions
        if ((action.navigationAction == 'push' || action.navigationAction == 'replace') &&
            (action.navigationRoute == null || action.navigationRoute!.isEmpty)) {
          errors.add(ValidationError.requiredField('$path.route'));
        }
        break;
        
      case 'resource':
        if (action.resourceAction == null || action.resourceAction!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.action'));
        }
        if (action.resourceUri == null || action.resourceUri!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.uri'));
        }
        if (action.resourceAction == 'subscribe' && 
            (action.resourceBinding == null || action.resourceBinding!.isEmpty)) {
          errors.add(ValidationError.requiredField('$path.binding'));
        }
        break;
        
      case 'batch':
        if (action.actions == null || action.actions!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.actions'));
        } else {
          for (int i = 0; i < action.actions!.length; i++) {
            errors.addAll(_validateAction(action.actions![i], '$path.actions[$i]'));
          }
        }
        break;
        
      case 'conditional':
        if (action.condition == null || action.condition!.isEmpty) {
          errors.add(ValidationError.requiredField('$path.condition'));
        }
        if (action.thenAction == null) {
          errors.add(ValidationError.requiredField('$path.then'));
        } else {
          errors.addAll(_validateAction(action.thenAction!, '$path.then'));
        }
        if (action.elseAction != null) {
          errors.addAll(_validateAction(action.elseAction!, '$path.else'));
        }
        break;
        
      default:
        // Custom action type - minimal validation
        break;
    }
    
    return errors;
  }

  static List<ValidationError> _validateBinding(BindingConfig binding, [String path = 'binding']) {
    final errors = <ValidationError>[];
    
    if (!binding.isValidExpression) {
      errors.add(ValidationError.invalidValue(
        '$path.expression',
        binding.expression,
        'Invalid binding expression format',
      ));
    }
    
    if (binding.path.isEmpty) {
      errors.add(ValidationError.requiredField('$path.path'));
    }
    
    // Validate path format
    if (!_isValidStatePath(binding.path)) {
      errors.add(ValidationError.invalidValue(
        '$path.path',
        binding.path,
        'Invalid state path format',
      ));
    }
    
    return errors;
  }

  static List<ValidationError> _validateState(Map<String, dynamic> state) {
    final errors = <ValidationError>[];
    
    // Validate state structure (basic checks)
    for (final entry in state.entries) {
      if (entry.key.isEmpty) {
        errors.add(ValidationError.invalidValue(
          'initialState',
          entry.key,
          'State key cannot be empty',
        ));
      }
      
      // Check for circular references in nested objects
      try {
        _checkCircularReferences(entry.value, 'initialState.${entry.key}');
      } catch (e) {
        errors.add(ValidationError.invalidValue(
          'initialState.${entry.key}',
          entry.value,
          'Circular reference detected',
        ));
      }
    }
    
    return errors;
  }


  static List<ValidationError> _validateTheme(dynamic theme) {
    final errors = <ValidationError>[];
    
    if (theme is! Map<String, dynamic>) {
      errors.add(ValidationError.typeMismatch('theme', Map, theme.runtimeType));
      return errors;
    }
    
    final themeMap = theme;
    
    // Validate mode if present
    if (themeMap.containsKey('mode')) {
      final mode = themeMap['mode'];
      if (mode is! String || !['light', 'dark', 'system'].contains(mode)) {
        errors.add(ValidationError.invalidValue(
          'theme.mode',
          mode,
          'Theme mode must be one of: light, dark, system',
        ));
      }
    }
    
    // Validate colors if present
    if (themeMap.containsKey('colors')) {
      errors.addAll(_validateThemeColors(themeMap['colors'], 'theme.colors'));
    }
    
    // Validate typography if present
    if (themeMap.containsKey('typography')) {
      errors.addAll(_validateThemeTypography(themeMap['typography'], 'theme.typography'));
    }
    
    // Validate spacing if present
    if (themeMap.containsKey('spacing')) {
      errors.addAll(_validateNumericMap(themeMap['spacing'], 'theme.spacing', 'spacing'));
    }
    
    // Validate borderRadius if present
    if (themeMap.containsKey('borderRadius')) {
      errors.addAll(_validateNumericMap(themeMap['borderRadius'], 'theme.borderRadius', 'border radius'));
    }
    
    // Validate elevation if present
    if (themeMap.containsKey('elevation')) {
      errors.addAll(_validateNumericMap(themeMap['elevation'], 'theme.elevation', 'elevation', minValue: 0));
    }
    
    // Validate light theme if present
    if (themeMap.containsKey('light')) {
      final lightErrors = _validateTheme(themeMap['light']);
      for (final error in lightErrors) {
        errors.add(ValidationError(
          message: error.message,
          code: error.code,
          path: error.path != null 
            ? error.path!.startsWith('theme.') 
              ? 'theme.light.${error.path!.substring(6)}' 
              : 'theme.light.${error.path}'
            : 'theme.light',
          severity: error.severity,
        ));
      }
    }
    
    // Validate dark theme if present
    if (themeMap.containsKey('dark')) {
      final darkErrors = _validateTheme(themeMap['dark']);
      for (final error in darkErrors) {
        errors.add(ValidationError(
          message: error.message,
          code: error.code,
          path: error.path != null 
            ? error.path!.startsWith('theme.') 
              ? 'theme.dark.${error.path!.substring(6)}' 
              : 'theme.dark.${error.path}'
            : 'theme.dark',
          severity: error.severity,
        ));
      }
    }
    
    return errors;
  }
  
  static List<ValidationError> _validateNavigation(Map<String, dynamic> navigation) {
    final errors = <ValidationError>[];
    
    // Validate navigation type
    final type = navigation['type'] as String?;
    if (type == null || type.isEmpty) {
      errors.add(ValidationError.requiredField('navigation.type'));
    } else if (!['drawer', 'tabs', 'bottom'].contains(type)) {
      errors.add(ValidationError.invalidValue(
        'navigation.type',
        type,
        'Navigation type must be one of: drawer, tabs, bottom',
      ));
    }
    
    // Validate navigation items
    final items = navigation['items'] as List<dynamic>? ?? 
                  navigation['tabs'] as List<dynamic>?;
    if (items == null || items.isEmpty) {
      errors.add(ValidationError.requiredField('navigation.items'));
    } else {
      for (int i = 0; i < items.length; i++) {
        if (items[i] is Map<String, dynamic>) {
          final item = items[i] as Map<String, dynamic>;
          if (!item.containsKey('title') && !item.containsKey('label')) {
            errors.add(ValidationError.requiredField('navigation.items[$i].title'));
          }
          if (!item.containsKey('route')) {
            errors.add(ValidationError.requiredField('navigation.items[$i].route'));
          }
        }
      }
    }
    
    return errors;
  }

  // Helper methods

  static bool _isValidStatePath(String path) {
    // Basic path validation
    // Must start with letter or underscore
    // Cannot have consecutive dots
    // Can contain letters, numbers, dots, underscores, and brackets
    if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_.\[\]]*$').hasMatch(path)) {
      return false;
    }
    
    // Check for invalid patterns
    if (path.contains('..') || path.contains('.[') || path.contains('.]')) {
      return false;
    }
    
    return true;
  }


  static void _checkCircularReferences(dynamic value, String path, [Set<Object>? visited]) {
    visited ??= <Object>{};
    
    if (value == null) return;
    
    if (value is Map || value is List) {
      if (visited.contains(value)) {
        throw StateError('Circular reference at $path');
      }
      
      visited.add(value);
      
      if (value is Map) {
        for (final entry in value.entries) {
          _checkCircularReferences(entry.value, '$path.${entry.key}', visited);
        }
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          _checkCircularReferences(value[i], '$path[$i]', visited);
        }
      }
      
      visited.remove(value);
    }
  }

  static List<ValidationError> _validateThemeColors(dynamic colors, String path) {
    final errors = <ValidationError>[];
    
    if (colors is! Map<String, dynamic>) {
      errors.add(ValidationError.typeMismatch(path, Map, colors.runtimeType));
      return errors;
    }
    
    // Required color keys according to spec
    const requiredColorKeys = [
      'primary', 'secondary', 'background', 'surface', 'error',
      'onPrimary', 'onSecondary', 'onBackground', 'onSurface', 'onError'
    ];
    
    // Check for required colors
    final missingColors = <String>[];
    for (final key in requiredColorKeys) {
      if (!colors.containsKey(key)) {
        missingColors.add(key);
      }
    }
    
    // If some colors are defined but not all, it's a warning
    if (missingColors.isNotEmpty) {
      errors.add(ValidationError(
        message: 'Missing required theme colors: ${missingColors.join(', ')}',
        code: 'MISSING_THEME_COLORS',
        path: path,
        severity: ValidationSeverity.warning,
      ));
    }
    
    // Validate color format for each color
    for (final entry in colors.entries) {
      final colorPath = '$path.${entry.key}';
      if (entry.value is! String) {
        errors.add(ValidationError.typeMismatch(colorPath, String, entry.value.runtimeType));
      } else if (!_isValidColorFormat(entry.value as String)) {
        errors.add(ValidationError.invalidValue(
          colorPath,
          entry.value,
          'Color must be in #RRGGBB or #AARRGGBB format',
        ));
      }
    }
    
    return errors;
  }

  static List<ValidationError> _validateThemeTypography(dynamic typography, String path) {
    final errors = <ValidationError>[];
    
    if (typography is! Map<String, dynamic>) {
      errors.add(ValidationError.typeMismatch(path, Map, typography.runtimeType));
      return errors;
    }
    
    // Standard typography keys
    const standardKeys = [
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
      'body1', 'body2', 'caption', 'button'
    ];
    
    for (final entry in typography.entries) {
      final stylePath = '$path.${entry.key}';
      
      // Warn if not a standard key
      if (!standardKeys.contains(entry.key)) {
        errors.add(ValidationError(
          message: 'Non-standard typography key: ${entry.key}',
          code: 'NON_STANDARD_KEY',
          path: stylePath,
          severity: ValidationSeverity.warning,
        ));
      }
      
      if (entry.value is! Map<String, dynamic>) {
        errors.add(ValidationError.typeMismatch(stylePath, Map, entry.value.runtimeType));
        continue;
      }
      
      final style = entry.value as Map<String, dynamic>;
      
      // Validate fontSize (required)
      if (!style.containsKey('fontSize')) {
        errors.add(ValidationError.requiredField('$stylePath.fontSize'));
      } else if (style['fontSize'] is! num) {
        errors.add(ValidationError.typeMismatch('$stylePath.fontSize', num, style['fontSize'].runtimeType));
      }
      
      // Validate fontWeight (required)
      if (!style.containsKey('fontWeight')) {
        errors.add(ValidationError.requiredField('$stylePath.fontWeight'));
      } else if (style['fontWeight'] is! String || 
                 !['normal', 'bold', 'medium', 'light', 'thin'].contains(style['fontWeight'])) {
        errors.add(ValidationError.invalidValue(
          '$stylePath.fontWeight',
          style['fontWeight'],
          'Font weight must be one of: normal, bold, medium, light, thin',
        ));
      }
      
      // Validate letterSpacing (optional)
      if (style.containsKey('letterSpacing') && style['letterSpacing'] is! num) {
        errors.add(ValidationError.typeMismatch('$stylePath.letterSpacing', num, style['letterSpacing'].runtimeType));
      }
      
      // Validate textTransform (optional)
      if (style.containsKey('textTransform') && 
          (style['textTransform'] is! String || 
           !['uppercase', 'lowercase', 'capitalize', 'none'].contains(style['textTransform']))) {
        errors.add(ValidationError.invalidValue(
          '$stylePath.textTransform',
          style['textTransform'],
          'Text transform must be one of: uppercase, lowercase, capitalize, none',
        ));
      }
    }
    
    return errors;
  }

  static List<ValidationError> _validateNumericMap(
    dynamic map, 
    String path, 
    String description,
    {num? minValue, num? maxValue}
  ) {
    final errors = <ValidationError>[];
    
    if (map is! Map<String, dynamic>) {
      errors.add(ValidationError.typeMismatch(path, Map, map.runtimeType));
      return errors;
    }
    
    for (final entry in map.entries) {
      final valuePath = '$path.${entry.key}';
      
      if (entry.value is! num) {
        errors.add(ValidationError.typeMismatch(valuePath, num, entry.value.runtimeType));
      } else {
        final value = entry.value as num;
        if (minValue != null && value < minValue) {
          errors.add(ValidationError.invalidValue(
            valuePath,
            value,
            '$description value must be at least $minValue',
          ));
        }
        if (maxValue != null && value > maxValue) {
          errors.add(ValidationError.invalidValue(
            valuePath,
            value,
            '$description value must be at most $maxValue',
          ));
        }
      }
    }
    
    return errors;
  }

  static bool _isValidColorFormat(String color) {
    // Validate #RRGGBB or #AARRGGBB format
    final regex = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$');
    return regex.hasMatch(color);
  }
}