import 'parameter_spec.dart';

/// Represents an action type specification
class ActionSpec {
  final String type;
  final Map<String, ParameterSpec> parameters;
  final List<String> requiredParameters;
  final String description;

  const ActionSpec({
    required this.type,
    required this.parameters,
    this.requiredParameters = const [],
    required this.description,
  });
}

/// Represents an event specification
class EventSpec {
  final String name;
  final String propertyKey;
  final String description;
  final bool supportsModifiers;

  const EventSpec({
    required this.name,
    required this.propertyKey,
    required this.description,
    this.supportsModifiers = false,
  });
}

/// Central registry for action and event specifications
class ActionSpecRegistry {
  // ===== Event Specifications =====
  static const Map<String, EventSpec> events = {
    'click': EventSpec(
      name: 'click',
      propertyKey: 'click',
      description: 'Standard click/tap event',
      supportsModifiers: true,
    ),
    'doubleClick': EventSpec(
      name: 'doubleClick',
      propertyKey: 'doubleClick',
      description: 'Double click/tap event',
      supportsModifiers: true,
    ),
    'longPress': EventSpec(
      name: 'longPress',
      propertyKey: 'longPress',
      description: 'Long press event',
      supportsModifiers: false,
    ),
    'rightClick': EventSpec(
      name: 'rightClick',
      propertyKey: 'rightClick',
      description: 'Right click event (desktop)',
      supportsModifiers: true,
    ),
    'hover': EventSpec(
      name: 'hover',
      propertyKey: 'hover',
      description: 'Mouse hover event',
      supportsModifiers: false,
    ),
    'focus': EventSpec(
      name: 'focus',
      propertyKey: 'focus',
      description: 'Focus gained event',
      supportsModifiers: false,
    ),
    'blur': EventSpec(
      name: 'blur',
      propertyKey: 'blur',
      description: 'Focus lost event',
      supportsModifiers: false,
    ),
    'change': EventSpec(
      name: 'change',
      propertyKey: 'change',
      description: 'Value change event',
      supportsModifiers: false,
    ),
    'submit': EventSpec(
      name: 'submit',
      propertyKey: 'submit',
      description: 'Form submission event',
      supportsModifiers: false,
    ),
  };

  // ===== Action Type Specifications =====
  static const Map<String, ActionSpec> actions = {
    'tool': ActionSpec(
      type: 'tool',
      description: 'Execute an MCP tool',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'tool',
          description: 'Action type identifier',
        ),
        'name': ParameterSpec(
          name: 'name',
          type: String,
          required: true,
          description: 'Tool name to execute',
        ),
        'params': ParameterSpec(
          name: 'params',
          type: Map,
          description: 'Parameters to pass to the tool',
        ),
      },
      requiredParameters: ['type', 'name'],
    ),
    
    'state': ActionSpec(
      type: 'state',
      description: 'Modify application state',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'state',
          description: 'Action type identifier',
        ),
        'action': ParameterSpec(
          name: 'action',
          type: String,
          required: true,
          allowedValues: ['set', 'toggle', 'increment', 'decrement', 'push', 'pop', 'remove'],
          description: 'State modification action',
        ),
        'path': ParameterSpec(
          name: 'path',
          type: String,
          required: true,
          description: 'State path to modify',
        ),
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          description: 'Value to set (for set action)',
        ),
        'amount': ParameterSpec(
          name: 'amount',
          type: num,
          defaultValue: 1,
          description: 'Amount for increment/decrement',
        ),
      },
      requiredParameters: ['type', 'action', 'path'],
    ),
    
    'navigation': ActionSpec(
      type: 'navigation',
      description: 'Navigate within the application',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'navigation',
          description: 'Action type identifier',
        ),
        'action': ParameterSpec(
          name: 'action',
          type: String,
          required: true,
          allowedValues: ['push', 'pop', 'replace', 'pushAndClear', 'setIndex'],
          description: 'Navigation action',
        ),
        'route': ParameterSpec(
          name: 'route',
          type: String,
          description: 'Route to navigate to',
        ),
        'params': ParameterSpec(
          name: 'params',
          type: Map,
          description: 'Parameters to pass to the route',
        ),
        'index': ParameterSpec(
          name: 'index',
          type: String,
          description: 'Index for setIndex action (can be binding expression)',
        ),
      },
      requiredParameters: ['type', 'action'],
    ),
    
    'resource': ActionSpec(
      type: 'resource',
      description: 'Access MCP resources',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'resource',
          description: 'Action type identifier',
        ),
        'action': ParameterSpec(
          name: 'action',
          type: String,
          required: true,
          allowedValues: ['read', 'list'],
          description: 'Resource action',
        ),
        'uri': ParameterSpec(
          name: 'uri',
          type: String,
          description: 'Resource URI',
        ),
        'pattern': ParameterSpec(
          name: 'pattern',
          type: String,
          description: 'Pattern for list action',
        ),
        'target': ParameterSpec(
          name: 'target',
          type: String,
          description: 'State path to store result',
        ),
      },
      requiredParameters: ['type', 'action'],
    ),
    
    'batch': ActionSpec(
      type: 'batch',
      description: 'Execute multiple actions',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'batch',
          description: 'Action type identifier',
        ),
        'actions': ParameterSpec(
          name: 'actions',
          type: List,
          required: true,
          description: 'List of actions to execute',
        ),
        'parallel': ParameterSpec(
          name: 'parallel',
          type: bool,
          defaultValue: false,
          description: 'Whether to execute actions in parallel',
        ),
      },
      requiredParameters: ['type', 'actions'],
    ),
    
    'conditional': ActionSpec(
      type: 'conditional',
      description: 'Execute action based on condition',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'conditional',
          description: 'Action type identifier',
        ),
        'condition': ParameterSpec(
          name: 'condition',
          type: String,
          required: true,
          description: 'Condition expression',
        ),
        'then': ParameterSpec(
          name: 'then',
          type: Map,
          required: true,
          description: 'Action to execute if condition is true',
        ),
        'else': ParameterSpec(
          name: 'else',
          type: Map,
          description: 'Action to execute if condition is false',
        ),
      },
      requiredParameters: ['type', 'condition', 'then'],
    ),
  };

  /// Get event specification by name
  static EventSpec? getEventSpec(String name) => events[name];

  /// Get action specification by type
  static ActionSpec? getActionSpec(String type) => actions[type];

  /// Get all event names
  static List<String> get allEventNames => events.keys.toList();

  /// Get all action types
  static List<String> get allActionTypes => actions.keys.toList();

  /// Get property key for an event
  static String? getEventPropertyKey(String eventName) {
    return events[eventName]?.propertyKey;
  }

  /// Validate action parameters
  static Map<String, dynamic> validateAction(Map<String, dynamic> action) {
    final type = action['type'] as String?;
    if (type == null) {
      throw Exception('Action must have a "type" field');
    }

    final spec = getActionSpec(type);
    if (spec == null) {
      throw Exception('Unknown action type: $type');
    }

    final validated = <String, dynamic>{'type': type};

    // Check required parameters
    for (final param in spec.requiredParameters) {
      if (!action.containsKey(param)) {
        throw Exception('Required parameter "$param" missing for action type "$type"');
      }
    }

    // Validate parameters
    for (final entry in action.entries) {
      final paramSpec = spec.parameters[entry.key];
      if (paramSpec == null) {
        // Skip unknown parameters
        continue;
      }

      // Validate allowed values
      if (paramSpec.allowedValues != null && 
          !paramSpec.allowedValues!.contains(entry.value)) {
        throw Exception(
          'Invalid value "${entry.value}" for parameter "${entry.key}". '
          'Allowed values: ${paramSpec.allowedValues!.join(", ")}'
        );
      }

      validated[entry.key] = entry.value;
    }

    // Apply defaults
    for (final entry in spec.parameters.entries) {
      if (!validated.containsKey(entry.key) && 
          entry.value.defaultValue != null) {
        validated[entry.key] = entry.value.defaultValue;
      }
    }

    return validated;
  }

  /// Create a standard action map
  static Map<String, dynamic> createAction({
    required String type,
    Map<String, dynamic>? params,
  }) {
    final spec = getActionSpec(type);
    if (spec == null) {
      throw Exception('Unknown action type: $type');
    }

    final action = <String, dynamic>{'type': type};
    
    if (params != null) {
      action.addAll(params);
    }

    return validateAction(action);
  }
}