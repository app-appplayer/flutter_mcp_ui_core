import '../constants/dsl_version.dart';
import '../constants/widget_types.dart';
import '../models/ui_definition.dart';
import '../models/widget_config.dart';
import '../models/action_config.dart';
import '../models/binding_config.dart';
import '../exceptions/validation_exception.dart';
import 'schema_definitions.dart';

/// Comprehensive validator for MCP UI DSL
class UIValidator {
  /// Validate a complete UI definition
  static ValidationResult validateUIDefinition(UIDefinition definition) {
    final errors = <ValidationError>[];
    
    // Validate DSL version
    errors.addAll(_validateDSLVersion(definition.dslVersion));
    
    // Validate layout
    errors.addAll(_validateWidget(definition.layout).errors);
    
    // Validate initial state
    errors.addAll(_validateState(definition.initialState));
    
    // Validate computed values
    errors.addAll(_validateComputedValues(definition.computedValues));
    
    // Validate methods
    errors.addAll(_validateMethods(definition.methods));
    
    // Validate theme
    if (definition.theme != null) {
      errors.addAll(_validateTheme(definition.theme!));
    }
    
    // Cross-validation: check bindings reference valid state paths
    errors.addAll(_validateBindingReferences(definition));
    
    return ValidationResult.fromErrors(errors);
  }

  /// Validate a widget configuration
  static ValidationResult validateWidget(WidgetConfig widget) {
    return ValidationResult.fromErrors(_validateWidget(widget).errors);
  }

  /// Validate an action configuration
  static ValidationResult validateAction(ActionConfig action) {
    return ValidationResult.fromErrors(_validateAction(action));
  }

  /// Validate a binding configuration
  static ValidationResult validateBinding(BindingConfig binding) {
    return ValidationResult.fromErrors(_validateBinding(binding));
  }

  /// Validate JSON against MCP UI DSL schema
  static ValidationResult validateJson(Map<String, dynamic> json) {
    final errors = <ValidationError>[];
    
    try {
      // Basic structure validation
      if (!json.containsKey('layout')) {
        errors.add(ValidationError.requiredField('layout'));
      }
      
      // Validate against schema
      final schemaErrors = SchemaDefinitions.validateAgainstSchema(json);
      errors.addAll(schemaErrors);
      
      // If basic structure is valid, validate as UI definition
      if (errors.isEmpty) {
        final definition = UIDefinition.fromJson(json);
        final validationResult = validateUIDefinition(definition);
        errors.addAll(validationResult.errors);
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

  static List<ValidationError> _validateDSLVersion(String version) {
    final errors = <ValidationError>[];
    
    if (version.isEmpty) {
      errors.add(ValidationError.requiredField('dslVersion'));
    } else if (!MCPUIDSLVersion.isCompatible(version)) {
      errors.add(ValidationError.invalidValue(
        'dslVersion',
        version,
        'Unsupported version. Supported: ${MCPUIDSLVersion.supported.join(', ')}',
      ));
    }
    
    return errors;
  }

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
        if (action.navigationRoute == null || action.navigationRoute!.isEmpty) {
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

  static List<ValidationError> _validateComputedValues(Map<String, String> computedValues) {
    final errors = <ValidationError>[];
    
    for (final entry in computedValues.entries) {
      if (entry.key.isEmpty) {
        errors.add(ValidationError.invalidValue(
          'computedValues',
          entry.key,
          'Computed value name cannot be empty',
        ));
      }
      
      if (entry.value.isEmpty) {
        errors.add(ValidationError.invalidValue(
          'computedValues.${entry.key}',
          entry.value,
          'Computed value expression cannot be empty',
        ));
      }
      
      // Basic syntax validation (could be expanded)
      if (!_isValidExpression(entry.value)) {
        errors.add(ValidationError.invalidValue(
          'computedValues.${entry.key}',
          entry.value,
          'Invalid expression syntax',
        ));
      }
    }
    
    return errors;
  }

  static List<ValidationError> _validateMethods(Map<String, String> methods) {
    final errors = <ValidationError>[];
    
    for (final entry in methods.entries) {
      if (entry.key.isEmpty) {
        errors.add(ValidationError.invalidValue(
          'methods',
          entry.key,
          'Method name cannot be empty',
        ));
      }
      
      if (entry.value.isEmpty) {
        errors.add(ValidationError.invalidValue(
          'methods.${entry.key}',
          entry.value,
          'Method code cannot be empty',
        ));
      }
      
      // Basic JavaScript function validation
      if (!_isValidJavaScriptFunction(entry.value)) {
        errors.add(ValidationError.invalidValue(
          'methods.${entry.key}',
          entry.value,
          'Invalid JavaScript function syntax',
        ));
      }
    }
    
    return errors;
  }

  static List<ValidationError> _validateTheme(dynamic theme) {
    final errors = <ValidationError>[];
    
    // Theme validation would depend on the theme structure
    // For now, just basic checks
    if (theme is! Map) {
      errors.add(ValidationError.typeMismatch('theme', Map, theme.runtimeType));
    }
    
    return errors;
  }

  static List<ValidationError> _validateBindingReferences(UIDefinition definition) {
    final errors = <ValidationError>[];
    final availablePaths = _getAvailableStatePaths(definition);
    final usedBindings = definition.getAllBindings();
    
    for (final binding in usedBindings) {
      final path = binding.replaceAll(RegExp(r'[{}]'), '').trim();
      if (!availablePaths.contains(path) && !_isComputedValue(path, definition)) {
        errors.add(ValidationError(
          message: 'Binding references undefined state path: $path',
          code: 'UNDEFINED_BINDING_PATH',
          path: 'bindings',
          actualValue: path,
          severity: ValidationSeverity.warning,
        ));
      }
    }
    
    return errors;
  }

  // Helper methods

  static List<String> _getAvailableStatePaths(UIDefinition definition) {
    final paths = <String>[];
    
    void collectPaths(Map<String, dynamic> obj, String prefix) {
      for (final entry in obj.entries) {
        final path = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
        paths.add(path);
        
        if (entry.value is Map<String, dynamic>) {
          collectPaths(entry.value, path);
        } else if (entry.value is List) {
          paths.add('$path.length');
          // Add indexed paths for arrays
          for (int i = 0; i < (entry.value as List).length; i++) {
            paths.add('$path[$i]');
          }
        }
      }
    }
    
    collectPaths(definition.initialState, '');
    return paths;
  }

  static bool _isComputedValue(String path, UIDefinition definition) {
    return definition.computedValues.containsKey(path.split('.').first);
  }

  static bool _isValidStatePath(String path) {
    // Basic path validation
    return RegExp(r'^[a-zA-Z_][a-zA-Z0-9_.[\]]*$').hasMatch(path);
  }

  static bool _isValidExpression(String expression) {
    // Basic expression validation (could be more sophisticated)
    return expression.trim().isNotEmpty && !expression.contains('{{') && !expression.contains('}}');
  }

  static bool _isValidJavaScriptFunction(String code) {
    // Basic JavaScript function validation
    final trimmed = code.trim();
    return trimmed.isNotEmpty && 
           (trimmed.startsWith('function') || 
            trimmed.startsWith('(') || 
            trimmed.contains('=>'));
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
}