import '../constants/widget_types.dart';
import '../models/property_spec.dart';
import '../exceptions/validation_exception.dart';

/// Schema definitions for MCP UI DSL validation
class SchemaDefinitions {
  /// Get property specifications for a widget type
  static Map<String, PropertySpec>? getWidgetPropertySpecs(String widgetType) {
    return _widgetPropertySpecs[widgetType];
  }

  /// Validate JSON against basic MCP UI DSL schema
  static List<ValidationError> validateAgainstSchema(Map<String, dynamic> json) {
    final errors = <ValidationError>[];
    
    // Validate root structure
    errors.addAll(_validateRootSchema(json));
    
    // Validate layout
    if (json.containsKey('layout')) {
      errors.addAll(_validateLayoutSchema(json['layout'], 'layout'));
    }
    
    // Validate initial state
    if (json.containsKey('initialState')) {
      errors.addAll(_validateStateSchema(json['initialState'], 'initialState'));
    }
    
    // Validate computed values
    if (json.containsKey('computedValues')) {
      errors.addAll(_validateComputedValuesSchema(json['computedValues'], 'computedValues'));
    }
    
    // Validate methods
    if (json.containsKey('methods')) {
      errors.addAll(_validateMethodsSchema(json['methods'], 'methods'));
    }
    
    return errors;
  }

  // Private validation methods

  static List<ValidationError> _validateRootSchema(Map<String, dynamic> json) {
    final errors = <ValidationError>[];
    
    // Required fields
    if (!json.containsKey('layout')) {
      errors.add(ValidationError.requiredField('layout'));
    }
    
    // Optional but typed fields
    if (json.containsKey('dslVersion') && json['dslVersion'] is! String) {
      errors.add(ValidationError.typeMismatch('dslVersion', String, json['dslVersion'].runtimeType));
    }
    
    if (json.containsKey('initialState') && json['initialState'] is! Map) {
      errors.add(ValidationError.typeMismatch('initialState', Map, json['initialState'].runtimeType));
    }
    
    if (json.containsKey('computedValues') && json['computedValues'] is! Map) {
      errors.add(ValidationError.typeMismatch('computedValues', Map, json['computedValues'].runtimeType));
    }
    
    if (json.containsKey('methods') && json['methods'] is! Map) {
      errors.add(ValidationError.typeMismatch('methods', Map, json['methods'].runtimeType));
    }
    
    if (json.containsKey('theme') && json['theme'] is! Map) {
      errors.add(ValidationError.typeMismatch('theme', Map, json['theme'].runtimeType));
    }
    
    if (json.containsKey('metadata') && json['metadata'] is! Map) {
      errors.add(ValidationError.typeMismatch('metadata', Map, json['metadata'].runtimeType));
    }
    
    return errors;
  }

  static List<ValidationError> _validateLayoutSchema(dynamic layout, String path) {
    final errors = <ValidationError>[];
    
    if (layout is! Map<String, dynamic>) {
      errors.add(ValidationError.typeMismatch(path, Map, layout.runtimeType));
      return errors;
    }
    
    final layoutMap = layout;
    
    // Required type field
    if (!layoutMap.containsKey('type')) {
      errors.add(ValidationError.requiredField('$path.type'));
    } else if (layoutMap['type'] is! String) {
      errors.add(ValidationError.typeMismatch('$path.type', String, layoutMap['type'].runtimeType));
    }
    
    // Optional properties field
    if (layoutMap.containsKey('properties') && layoutMap['properties'] is! Map) {
      errors.add(ValidationError.typeMismatch('$path.properties', Map, layoutMap['properties'].runtimeType));
    }
    
    // Optional children field
    if (layoutMap.containsKey('children')) {
      if (layoutMap['children'] is! List) {
        errors.add(ValidationError.typeMismatch('$path.children', List, layoutMap['children'].runtimeType));
      } else {
        final children = layoutMap['children'] as List;
        for (int i = 0; i < children.length; i++) {
          errors.addAll(_validateLayoutSchema(children[i], '$path.children[$i]'));
        }
      }
    }
    
    return errors;
  }

  static List<ValidationError> _validateStateSchema(dynamic state, String path) {
    final errors = <ValidationError>[];
    
    if (state is! Map) {
      errors.add(ValidationError.typeMismatch(path, Map, state.runtimeType));
      return errors;
    }
    
    // State can contain any valid JSON values
    // Additional validation would be application-specific
    
    return errors;
  }

  static List<ValidationError> _validateComputedValuesSchema(dynamic computedValues, String path) {
    final errors = <ValidationError>[];
    
    if (computedValues is! Map) {
      errors.add(ValidationError.typeMismatch(path, Map, computedValues.runtimeType));
      return errors;
    }
    
    final map = computedValues;
    for (final entry in map.entries) {
      if (entry.key is! String) {
        errors.add(ValidationError.typeMismatch('$path.${entry.key}', String, entry.key.runtimeType));
      }
      if (entry.value is! String) {
        errors.add(ValidationError.typeMismatch('$path.${entry.key}', String, entry.value.runtimeType));
      }
    }
    
    return errors;
  }

  static List<ValidationError> _validateMethodsSchema(dynamic methods, String path) {
    final errors = <ValidationError>[];
    
    if (methods is! Map) {
      errors.add(ValidationError.typeMismatch(path, Map, methods.runtimeType));
      return errors;
    }
    
    final map = methods;
    for (final entry in map.entries) {
      if (entry.key is! String) {
        errors.add(ValidationError.typeMismatch('$path.${entry.key}', String, entry.key.runtimeType));
      }
      if (entry.value is! String) {
        errors.add(ValidationError.typeMismatch('$path.${entry.key}', String, entry.value.runtimeType));
      }
    }
    
    return errors;
  }

  /// Widget property specifications
  static final Map<String, Map<String, PropertySpec>> _widgetPropertySpecs = {
    // Layout Widgets
    WidgetTypes.container: {
      'width': const PropertySpec(type: double, defaultValue: null),
      'height': const PropertySpec(type: double, defaultValue: null),
      'padding': const PropertySpec(type: Map, defaultValue: null),
      'margin': const PropertySpec(type: Map, defaultValue: null),
      'color': const PropertySpec(type: String, defaultValue: null),
      'decoration': const PropertySpec(type: Map, defaultValue: null),
      'alignment': const PropertySpec(type: dynamic, defaultValue: null),
    },
    
    WidgetTypes.column: {
      'mainAxisAlignment': const PropertySpec(type: String, defaultValue: 'start'),
      'crossAxisAlignment': const PropertySpec(type: String, defaultValue: 'center'),
      'mainAxisSize': const PropertySpec(type: String, defaultValue: 'max'),
    },
    
    WidgetTypes.row: {
      'mainAxisAlignment': const PropertySpec(type: String, defaultValue: 'start'),
      'crossAxisAlignment': const PropertySpec(type: String, defaultValue: 'center'),
      'mainAxisSize': const PropertySpec(type: String, defaultValue: 'max'),
    },
    
    WidgetTypes.padding: {
      'padding': const PropertySpec(type: Map, required: true),
    },
    
    WidgetTypes.expanded: {
      'flex': const PropertySpec(type: int, defaultValue: 1),
    },
    
    WidgetTypes.flexible: {
      'flex': const PropertySpec(type: int, defaultValue: 1),
    },
    
    // Display Widgets
    WidgetTypes.text: {
      'content': const PropertySpec(type: String, required: true),
      'style': const PropertySpec(type: Map, defaultValue: null),
      'textAlign': const PropertySpec(type: String, defaultValue: 'left'),
      'maxLines': const PropertySpec(type: int, defaultValue: null),
    },
    
    WidgetTypes.image: {
      'src': const PropertySpec(type: String, required: true),
      'width': const PropertySpec(type: double, defaultValue: null),
      'height': const PropertySpec(type: double, defaultValue: null),
      'fit': const PropertySpec(type: String, defaultValue: 'contain'),
    },
    
    WidgetTypes.icon: {
      'icon': const PropertySpec(type: String, required: true),
      'size': const PropertySpec(type: double, defaultValue: 24.0),
      'color': const PropertySpec(type: String, defaultValue: null),
    },
    
    // Input Widgets
    WidgetTypes.button: {
      'label': const PropertySpec(type: String, required: true),
      'onTap': const PropertySpec(type: Map, defaultValue: null),
      'onPressed': const PropertySpec(type: Map, defaultValue: null),
      'enabled': const PropertySpec(type: bool, defaultValue: true),
      'variant': const PropertySpec(type: String, defaultValue: 'elevated'),
      'icon': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.textField: {
      'label': const PropertySpec(type: String, defaultValue: null),
      'value': const PropertySpec(type: String, defaultValue: null),
      'hintText': const PropertySpec(type: String, defaultValue: null),
      'obscureText': const PropertySpec(type: bool, defaultValue: false),
      'enabled': const PropertySpec(type: bool, defaultValue: true),
      'maxLines': const PropertySpec(type: int, defaultValue: 1),
      'maxLength': const PropertySpec(type: int, defaultValue: null),
      'keyboardType': const PropertySpec(type: String, defaultValue: 'text'),
      'onChanged': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.checkbox: {
      'value': const PropertySpec(type: bool, defaultValue: false),
      'label': const PropertySpec(type: String, defaultValue: null),
      'onChanged': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.slider: {
      'value': const PropertySpec(type: double, defaultValue: 0.0),
      'min': const PropertySpec(type: double, defaultValue: 0.0),
      'max': const PropertySpec(type: double, defaultValue: 100.0),
      'divisions': const PropertySpec(type: int, defaultValue: null),
      'onChanged': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    // List Widgets
    WidgetTypes.listView: {
      'items': const PropertySpec(type: String, defaultValue: null),
      'itemTemplate': const PropertySpec(type: Map, defaultValue: null),
      'shrinkWrap': const PropertySpec(type: bool, defaultValue: false),
      'physics': const PropertySpec(type: String, defaultValue: null),
      'scrollDirection': const PropertySpec(type: String, defaultValue: 'vertical'),
    },
    
    WidgetTypes.gridView: {
      'items': const PropertySpec(type: String, defaultValue: null),
      'itemTemplate': const PropertySpec(type: Map, defaultValue: null),
      'crossAxisCount': const PropertySpec(type: int, defaultValue: 2),
      'mainAxisSpacing': const PropertySpec(type: double, defaultValue: 0.0),
      'crossAxisSpacing': const PropertySpec(type: double, defaultValue: 0.0),
      'childAspectRatio': const PropertySpec(type: double, defaultValue: 1.0),
    },
    
    WidgetTypes.listTile: {
      'title': const PropertySpec(type: String, required: true),
      'subtitle': const PropertySpec(type: String, defaultValue: null),
      'leading': const PropertySpec(type: Map, defaultValue: null),
      'trailing': const PropertySpec(type: Map, defaultValue: null),
      'onTap': const PropertySpec(type: Map, defaultValue: null),
    },
    
    // Navigation Widgets
    WidgetTypes.appBar: {
      'title': const PropertySpec(type: String, required: true),
      'backgroundColor': const PropertySpec(type: String, defaultValue: null),
      'actions': const PropertySpec(type: List, defaultValue: null),
      'leading': const PropertySpec(type: Map, defaultValue: null),
      'automaticallyImplyLeading': const PropertySpec(type: bool, defaultValue: true),
    },
    
    WidgetTypes.floatingActionButton: {
      'icon': const PropertySpec(type: String, defaultValue: 'add'),
      'onPressed': const PropertySpec(type: Map, defaultValue: null),
      'mini': const PropertySpec(type: bool, defaultValue: false),
      'backgroundColor': const PropertySpec(type: String, defaultValue: null),
    },
    
    // Form Widgets
    WidgetTypes.form: {
      'key': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.textFormField: {
      'label': const PropertySpec(type: String, required: true),
      'bindTo': const PropertySpec(type: String, required: true),
      'hintText': const PropertySpec(type: String, defaultValue: null),
      'validator': const PropertySpec(type: String, defaultValue: null),
      'obscureText': const PropertySpec(type: bool, defaultValue: false),
      'keyboardType': const PropertySpec(type: String, defaultValue: 'text'),
    },
    
    // New Input Widgets
    WidgetTypes.numberField: {
      'label': const PropertySpec(type: String, defaultValue: null),
      'value': const PropertySpec(type: double, defaultValue: 0.0),
      'min': const PropertySpec(type: double, defaultValue: null),
      'max': const PropertySpec(type: double, defaultValue: null),
      'step': const PropertySpec(type: double, defaultValue: 1.0),
      'decimalPlaces': const PropertySpec(type: int, defaultValue: 0),
      'format': const PropertySpec(type: String, defaultValue: 'decimal'),
      'prefix': const PropertySpec(type: String, defaultValue: ''),
      'suffix': const PropertySpec(type: String, defaultValue: ''),
      'thousandSeparator': const PropertySpec(type: String, defaultValue: ','),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.colorPicker: {
      'value': const PropertySpec(type: String, defaultValue: '#000000'),
      'showAlpha': const PropertySpec(type: bool, defaultValue: true),
      'showLabel': const PropertySpec(type: bool, defaultValue: true),
      'pickerType': const PropertySpec(type: String, defaultValue: 'both'),
      'enableHistory': const PropertySpec(type: bool, defaultValue: true),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.radioGroup: {
      'value': const PropertySpec(type: String, defaultValue: null),
      'options': const PropertySpec(type: List, required: true),
      'orientation': const PropertySpec(type: String, defaultValue: 'vertical'),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.checkboxGroup: {
      'value': const PropertySpec(type: List, defaultValue: []),
      'options': const PropertySpec(type: List, required: true),
      'orientation': const PropertySpec(type: String, defaultValue: 'vertical'),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.segmentedControl: {
      'value': const PropertySpec(type: String, defaultValue: null),
      'options': const PropertySpec(type: List, required: true),
      'style': const PropertySpec(type: String, defaultValue: 'material'),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.dateField: {
      'label': const PropertySpec(type: String, defaultValue: null),
      'value': const PropertySpec(type: String, defaultValue: null),
      'format': const PropertySpec(type: String, defaultValue: 'yyyy-MM-dd'),
      'firstDate': const PropertySpec(type: String, defaultValue: null),
      'lastDate': const PropertySpec(type: String, defaultValue: null),
      'mode': const PropertySpec(type: String, defaultValue: 'calendar'),
      'locale': const PropertySpec(type: String, defaultValue: 'en_US'),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.timeField: {
      'label': const PropertySpec(type: String, defaultValue: null),
      'value': const PropertySpec(type: String, defaultValue: null),
      'format': const PropertySpec(type: String, defaultValue: 'HH:mm'),
      'use24HourFormat': const PropertySpec(type: bool, defaultValue: true),
      'mode': const PropertySpec(type: String, defaultValue: 'spinner'),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
      'bindTo': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.dateRangePicker: {
      'startDate': const PropertySpec(type: String, defaultValue: null),
      'endDate': const PropertySpec(type: String, defaultValue: null),
      'firstDate': const PropertySpec(type: String, defaultValue: null),
      'lastDate': const PropertySpec(type: String, defaultValue: null),
      'format': const PropertySpec(type: String, defaultValue: 'yyyy-MM-dd'),
      'locale': const PropertySpec(type: String, defaultValue: 'en_US'),
      'saveText': const PropertySpec(type: String, defaultValue: 'Save'),
      'onChange': const PropertySpec(type: Map, defaultValue: null),
    },
    
    // Scroll Widgets
    WidgetTypes.scrollView: {
      'scrollDirection': const PropertySpec(type: String, defaultValue: 'vertical'),
      'physics': const PropertySpec(type: String, defaultValue: 'bouncing'),
      'padding': const PropertySpec(type: Map, defaultValue: null),
      'reverse': const PropertySpec(type: bool, defaultValue: false),
      'primary': const PropertySpec(type: bool, defaultValue: true),
      'shrinkWrap': const PropertySpec(type: bool, defaultValue: false),
      'controller': const PropertySpec(type: String, defaultValue: null),
    },
    
    // Interactive Widgets
    WidgetTypes.draggable: {
      'data': const PropertySpec(type: dynamic, required: true),
      'feedback': const PropertySpec(type: Map, required: true),
      'childWhenDragging': const PropertySpec(type: Map, defaultValue: null),
      'maxSimultaneousDrags': const PropertySpec(type: int, defaultValue: null),
      'axis': const PropertySpec(type: String, defaultValue: null),
    },
    
    WidgetTypes.dragTarget: {
      'onAccept': const PropertySpec(type: Map, defaultValue: null),
      'onWillAccept': const PropertySpec(type: String, defaultValue: null),
      'onHover': const PropertySpec(type: Map, defaultValue: null),
      'onLeave': const PropertySpec(type: Map, defaultValue: null),
      'builder': const PropertySpec(type: Map, required: true),
    },
    
    // Layout Widgets
    WidgetTypes.conditional: {
      'condition': const PropertySpec(type: String, required: true),
      'trueChild': const PropertySpec(type: Map, defaultValue: null),
      'falseChild': const PropertySpec(type: Map, defaultValue: null),
      'child': const PropertySpec(type: Map, defaultValue: null),
    },
    
    // Additional widgets can be added here...
  };

  /// Get all available widget types with their property specifications
  static Map<String, Map<String, PropertySpec>> get allWidgetSpecs => 
      Map.unmodifiable(_widgetPropertySpecs);

  /// Check if a widget type has property specifications
  static bool hasSpecs(String widgetType) {
    return _widgetPropertySpecs.containsKey(widgetType);
  }

  /// Get all property names for a widget type
  static List<String> getPropertyNames(String widgetType) {
    final specs = _widgetPropertySpecs[widgetType];
    return specs?.keys.toList() ?? [];
  }

  /// Get required properties for a widget type
  static List<String> getRequiredProperties(String widgetType) {
    final specs = _widgetPropertySpecs[widgetType];
    if (specs == null) return [];
    
    return specs.entries
        .where((entry) => entry.value.required)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get optional properties for a widget type
  static List<String> getOptionalProperties(String widgetType) {
    final specs = _widgetPropertySpecs[widgetType];
    if (specs == null) return [];
    
    return specs.entries
        .where((entry) => !entry.value.required)
        .map((entry) => entry.key)
        .toList();
  }

  /// Validate a single property value against its specification
  static ValidationError? validateProperty(
    String widgetType,
    String propertyName,
    dynamic value,
  ) {
    final specs = _widgetPropertySpecs[widgetType];
    if (specs == null) {
      return ValidationError(
        message: 'No property specifications found for widget type: $widgetType',
        code: 'NO_WIDGET_SPECS',
        severity: ValidationSeverity.warning,
      );
    }
    
    final spec = specs[propertyName];
    if (spec == null) {
      return ValidationError(
        message: 'Unknown property "$propertyName" for widget "$widgetType"',
        code: 'UNKNOWN_PROPERTY',
        severity: ValidationSeverity.warning,
      );
    }
    
    if (!spec.isValid(value)) {
      return ValidationError.invalidValue(propertyName, value);
    }
    
    return null;
  }

  /// Get the JSON schema for MCP UI DSL (simplified version)
  static Map<String, dynamic> getMCPUISchema() {
    return {
      'type': 'object',
      'required': ['layout'],
      'properties': {
        'layout': {
          'type': 'object',
          'required': ['type'],
          'properties': {
            'type': {'type': 'string'},
            'properties': {'type': 'object'},
            'children': {
              'type': 'array',
              'items': {'\$ref': '#/properties/layout'}
            }
          }
        },
        'dslVersion': {'type': 'string'},
        'initialState': {'type': 'object'},
        'computedValues': {
          'type': 'object',
          'additionalProperties': {'type': 'string'}
        },
        'methods': {
          'type': 'object',
          'additionalProperties': {'type': 'string'}
        },
        'theme': {'type': 'object'},
        'metadata': {'type': 'object'}
      }
    };
  }
}