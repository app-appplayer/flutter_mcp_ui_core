import '../constants/widget_types.dart';
import '../exceptions/validation_exception.dart';

/// Validates that JSON maps conform to MCP UI DSL structure.
///
/// Unlike [UIValidator] which validates typed Config/Definition objects,
/// this validator works directly on raw JSON maps before deserialization.
/// This is useful for validating JSON input before attempting to parse it
/// into strongly-typed model objects.
class DefinitionValidator {
  /// Known action types supported by the MCP UI DSL
  static const _knownActionTypes = {
    // Core action types (v1.0)
    'state',
    'navigation',
    'tool',
    'resource',
    'dialog',
    'batch',
    'conditional',
    'notification',
    'parallel',
    'sequence',
    // Extended action types (v1.1)
    'animation',
    'cancel',
    'permission.revoke',
  };

  /// Color format pattern: #RRGGBB or #AARRGGBB
  static final _colorPattern = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$');

  /// Route path pattern: must start with /
  static final _routePattern = RegExp(r'^/');

  const DefinitionValidator();

  /// Validate an application definition JSON
  ValidationResult validateApplication(Map<String, dynamic> json) {
    final errors = <ValidationError>[];

    // Required fields
    _requireString(json, 'title', 'title', errors);
    _requireString(json, 'version', 'version', errors);

    if (!json.containsKey('routes') || json['routes'] is! Map) {
      errors.add(ValidationError.requiredField('routes'));
    } else {
      final routes = json['routes'] as Map;
      if (routes.isEmpty) {
        errors.add(ValidationError.invalidValue(
          'routes',
          routes,
          'Routes map must not be empty',
        ));
      }
    }

    // Validate initialRoute references an existing route
    if (json.containsKey('initialRoute') && json.containsKey('routes')) {
      final initialRoute = json['initialRoute'] as String?;
      final routes = json['routes'];
      if (initialRoute != null &&
          routes is Map &&
          !routes.containsKey(initialRoute)) {
        errors.add(ValidationError.invalidValue(
          'initialRoute',
          initialRoute,
          'Initial route must exist in routes map',
        ));
      }
    }

    // Validate theme if present
    if (json.containsKey('theme') && json['theme'] is Map<String, dynamic>) {
      _validateThemeJson(
          json['theme'] as Map<String, dynamic>, 'theme', errors);
    }

    return ValidationResult.fromErrors(errors);
  }

  /// Validate a page definition JSON
  ValidationResult validatePage(Map<String, dynamic> json) {
    final errors = <ValidationError>[];

    // Content is required
    if (!json.containsKey('content') || json['content'] is! Map) {
      errors.add(ValidationError.requiredField('content'));
    } else {
      final contentErrors = validateWidget(
          json['content'] as Map<String, dynamic>,
          path: 'content');
      errors.addAll(contentErrors.errors);
    }

    // Validate theme override if present
    if (json.containsKey('theme') && json['theme'] is Map<String, dynamic>) {
      _validateThemeJson(
          json['theme'] as Map<String, dynamic>, 'theme', errors);
    }

    return ValidationResult.fromErrors(errors);
  }

  /// Validate a widget definition JSON (recursive)
  ValidationResult validateWidget(
    Map<String, dynamic> json, {
    String path = 'widget',
  }) {
    final errors = <ValidationError>[];

    // type is required on all widgets
    if (!json.containsKey('type') || json['type'] is! String) {
      errors.add(ValidationError.requiredField('$path.type'));
      return ValidationResult.fromErrors(errors);
    }

    final type = json['type'] as String;

    // Widget type must be a known constant
    if (!WidgetTypes.isValidType(type)) {
      errors.add(ValidationError.invalidValue(
        '$path.type',
        type,
        'Unknown widget type',
      ));
    }

    // direction is required on linear widget
    if (type == 'linear' && !json.containsKey('direction')) {
      errors.add(ValidationError.requiredField('$path.direction'));
    }

    // Validate color strings in properties
    _validateColorProperties(json, path, errors);

    // Recursively validate children
    if (json.containsKey('children') && json['children'] is List) {
      final children = json['children'] as List;
      for (int i = 0; i < children.length; i++) {
        if (children[i] is Map<String, dynamic>) {
          final childResult = validateWidget(
            children[i] as Map<String, dynamic>,
            path: '$path.children[$i]',
          );
          errors.addAll(childResult.errors);
        }
      }
    }

    // Recursively validate single child
    if (json.containsKey('child') && json['child'] is Map<String, dynamic>) {
      final childResult = validateWidget(
        json['child'] as Map<String, dynamic>,
        path: '$path.child',
      );
      errors.addAll(childResult.errors);
    }

    // Validate action properties (keys starting with 'on')
    for (final entry in json.entries) {
      if (entry.key.startsWith('on') && entry.value is Map<String, dynamic>) {
        final actionResult = validateAction(
          entry.value as Map<String, dynamic>,
          path: '$path.${entry.key}',
        );
        errors.addAll(actionResult.errors);
      }
    }

    return ValidationResult.fromErrors(errors);
  }

  /// Validate an action definition JSON
  ValidationResult validateAction(
    Map<String, dynamic> json, {
    String path = 'action',
  }) {
    final errors = <ValidationError>[];

    // type is required on all actions
    if (!json.containsKey('type') || json['type'] is! String) {
      errors.add(ValidationError.requiredField('$path.type'));
      return ValidationResult.fromErrors(errors);
    }

    final type = json['type'] as String;

    // Check for known types (client.* and channel.* are also valid prefixes)
    if (!_knownActionTypes.contains(type) &&
        !type.startsWith('client.') &&
        !type.startsWith('channel.')) {
      errors.add(ValidationError.invalidValue(
        '$path.type',
        type,
        'Unknown action type',
      ));
    }

    // Type-specific validation
    switch (type) {
      case 'state':
        _requireString(json, 'binding', '$path.binding', errors);
        break;

      case 'navigation':
        final action = json['action'] as String?;
        if (action == 'push' || action == 'replace') {
          final route = json['route'] as String?;
          if (route == null || route.isEmpty) {
            errors.add(ValidationError.requiredField('$path.route'));
          } else if (!_routePattern.hasMatch(route)) {
            errors.add(ValidationError.invalidValue(
              '$path.route',
              route,
              'Route must start with /',
            ));
          }
        }
        break;

      case 'tool':
        _requireString(json, 'tool', '$path.tool', errors);
        // Validate onSuccess/onError sub-actions
        _validateSubAction(json, 'onSuccess', path, errors);
        _validateSubAction(json, 'onError', path, errors);
        break;

      case 'resource':
        _requireString(json, 'uri', '$path.uri', errors);
        break;

      case 'dialog':
        // Validate body as widget definition if present
        if (json.containsKey('body') && json['body'] is Map<String, dynamic>) {
          final bodyResult = validateWidget(
            json['body'] as Map<String, dynamic>,
            path: '$path.body',
          );
          errors.addAll(bodyResult.errors);
        }
        break;

      case 'batch':
      case 'parallel':
      case 'sequence':
        if (!json.containsKey('actions') || json['actions'] is! List) {
          errors.add(ValidationError.requiredField('$path.actions'));
        } else {
          final actions = json['actions'] as List;
          for (int i = 0; i < actions.length; i++) {
            if (actions[i] is Map<String, dynamic>) {
              final actionResult = validateAction(
                actions[i] as Map<String, dynamic>,
                path: '$path.actions[$i]',
              );
              errors.addAll(actionResult.errors);
            }
          }
        }
        break;

      case 'conditional':
        _requireString(json, 'condition', '$path.condition', errors);
        if (!json.containsKey('then') || json['then'] is! Map) {
          errors.add(ValidationError.requiredField('$path.then'));
        } else {
          final thenResult = validateAction(
            json['then'] as Map<String, dynamic>,
            path: '$path.then',
          );
          errors.addAll(thenResult.errors);
        }
        _validateSubAction(json, 'else', path, errors);
        break;

      case 'notification':
        _requireString(json, 'message', '$path.message', errors);
        break;
    }

    return ValidationResult.fromErrors(errors);
  }

  // -------------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------------

  /// Require a non-empty string field in the JSON map
  void _requireString(
    Map<String, dynamic> json,
    String field,
    String path,
    List<ValidationError> errors,
  ) {
    if (!json.containsKey(field) ||
        json[field] is! String ||
        (json[field] as String).isEmpty) {
      errors.add(ValidationError.requiredField(path));
    }
  }

  /// Validate an optional sub-action field
  void _validateSubAction(
    Map<String, dynamic> json,
    String field,
    String parentPath,
    List<ValidationError> errors,
  ) {
    if (json.containsKey(field) && json[field] is Map<String, dynamic>) {
      final result = validateAction(
        json[field] as Map<String, dynamic>,
        path: '$parentPath.$field',
      );
      errors.addAll(result.errors);
    }
  }

  /// Validate color string properties in a widget JSON
  void _validateColorProperties(
    Map<String, dynamic> json,
    String path,
    List<ValidationError> errors,
  ) {
    // Common color property keys
    const colorKeys = {'color', 'backgroundColor', 'borderColor', 'textColor'};

    for (final key in colorKeys) {
      if (json.containsKey(key) && json[key] is String) {
        final value = json[key] as String;
        if (value.startsWith('#') && !_colorPattern.hasMatch(value)) {
          errors.add(ValidationError.patternMismatch(
            '$path.$key',
            value,
            '#RRGGBB or #AARRGGBB',
          ));
        }
      }
    }
  }

  /// Validate theme JSON structure
  void _validateThemeJson(
    Map<String, dynamic> theme,
    String path,
    List<ValidationError> errors,
  ) {
    // Validate mode if present
    if (theme.containsKey('mode')) {
      final mode = theme['mode'];
      if (mode is! String || !['light', 'dark', 'system'].contains(mode)) {
        errors.add(ValidationError.invalidValue(
          '$path.mode',
          mode,
          'Theme mode must be one of: light, dark, system',
        ));
      }
    }

    // Validate colors if present
    if (theme.containsKey('colors') && theme['colors'] is Map) {
      final colors = theme['colors'] as Map;
      for (final entry in colors.entries) {
        if (entry.value is String) {
          final colorValue = entry.value as String;
          if (colorValue.startsWith('#') &&
              !_colorPattern.hasMatch(colorValue)) {
            errors.add(ValidationError.patternMismatch(
              '$path.colors.${entry.key}',
              colorValue,
              '#RRGGBB or #AARRGGBB',
            ));
          }
        }
      }
    }
  }
}
