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
    'double-click': EventSpec(
      name: 'double-click',
      propertyKey: 'double-click',
      description: 'Double click/tap event',
      supportsModifiers: true,
    ),
    'long-press': EventSpec(
      name: 'long-press',
      propertyKey: 'long-press',
      description: 'Long press event',
      supportsModifiers: false,
    ),
    'right-click': EventSpec(
      name: 'right-click',
      propertyKey: 'right-click',
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
          allowedValues: ['set', 'toggle', 'increment', 'decrement', 'push', 'pop', 'remove', 'append', 'removeAt'],
          description: 'State modification action',
        ),
        'binding': ParameterSpec(
          name: 'binding',
          type: String,
          required: true,
          description: 'State binding path to modify',
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
      requiredParameters: ['type', 'action', 'binding'],
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
          allowedValues: ['push', 'pop', 'replace', 'pushAndClear', 'setIndex', 'popToRoot'],
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
          allowedValues: ['read', 'list', 'subscribe', 'unsubscribe'],
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
        'binding': ParameterSpec(
          name: 'binding',
          type: String,
          description: 'State binding path to store result',
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

    // v1.1 Channel actions
    'channel.start': ActionSpec(
      type: 'channel.start',
      description: 'Start a bidirectional channel',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'channel.start',
          description: 'Action type identifier',
        ),
        'channel': ParameterSpec(
          name: 'channel',
          type: String,
          required: true,
          description: 'Channel name to start',
        ),
      },
      requiredParameters: ['type', 'channel'],
    ),

    'channel.stop': ActionSpec(
      type: 'channel.stop',
      description: 'Stop a bidirectional channel',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'channel.stop',
          description: 'Action type identifier',
        ),
        'channel': ParameterSpec(
          name: 'channel',
          type: String,
          required: true,
          description: 'Channel name to stop',
        ),
      },
      requiredParameters: ['type', 'channel'],
    ),

    'channel.toggle': ActionSpec(
      type: 'channel.toggle',
      description: 'Toggle a bidirectional channel on/off',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'channel.toggle',
          description: 'Action type identifier',
        ),
        'channel': ParameterSpec(
          name: 'channel',
          type: String,
          required: true,
          description: 'Channel name to toggle',
        ),
      },
      requiredParameters: ['type', 'channel'],
    ),

    'permission.revoke': ActionSpec(
      type: 'permission.revoke',
      description: 'Revoke a previously granted permission',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'permission.revoke',
          description: 'Action type identifier',
        ),
        'permission': ParameterSpec(
          name: 'permission',
          type: String,
          required: true,
          description: 'Permission type to revoke (e.g., file.read, http)',
        ),
      },
      requiredParameters: ['type', 'permission'],
    ),

    // Dialog action
    'dialog': ActionSpec(
      type: 'dialog',
      description: 'Show a dialog to the user',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'dialog',
          description: 'Action type identifier',
        ),
        'dialogType': ParameterSpec(
          name: 'dialogType',
          type: String,
          defaultValue: 'alert',
          allowedValues: ['alert', 'confirm', 'prompt', 'custom'],
          description: 'Type of dialog to display',
        ),
        'title': ParameterSpec(
          name: 'title',
          type: String,
          description: 'Dialog title',
        ),
        'message': ParameterSpec(
          name: 'message',
          type: String,
          description: 'Dialog message body',
        ),
      },
      requiredParameters: ['type'],
    ),

    // Notification action
    'notification': ActionSpec(
      type: 'notification',
      description: 'Show a notification (snackbar/toast)',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'notification',
          description: 'Action type identifier',
        ),
        'message': ParameterSpec(
          name: 'message',
          type: String,
          required: true,
          description: 'Notification message',
        ),
        'severity': ParameterSpec(
          name: 'severity',
          type: String,
          defaultValue: 'info',
          allowedValues: ['info', 'success', 'warning', 'error'],
          description: 'Notification severity level',
        ),
      },
      requiredParameters: ['type', 'message'],
    ),

    // Parallel action
    'parallel': ActionSpec(
      type: 'parallel',
      description: 'Execute multiple actions in parallel',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'parallel',
          description: 'Action type identifier',
        ),
        'actions': ParameterSpec(
          name: 'actions',
          type: List,
          required: true,
          description: 'List of actions to execute in parallel',
        ),
      },
      requiredParameters: ['type', 'actions'],
    ),

    // Sequence action
    'sequence': ActionSpec(
      type: 'sequence',
      description: 'Execute multiple actions in sequence',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'sequence',
          description: 'Action type identifier',
        ),
        'actions': ParameterSpec(
          name: 'actions',
          type: List,
          required: true,
          description: 'List of actions to execute sequentially',
        ),
        'stopOnError': ParameterSpec(
          name: 'stopOnError',
          type: bool,
          defaultValue: false,
          description: 'Whether to stop on first error',
        ),
      },
      requiredParameters: ['type', 'actions'],
    ),

    // Animation action
    'animation': ActionSpec(
      type: 'animation',
      description: 'Trigger a widget animation',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'animation',
          description: 'Action type identifier',
        ),
        'target': ParameterSpec(
          name: 'target',
          type: String,
          required: true,
          description: 'Target widget ID to animate',
        ),
        'animation': ParameterSpec(
          name: 'animation',
          type: String,
          required: true,
          description: 'Animation type (e.g., fadeIn, slideUp)',
        ),
      },
      requiredParameters: ['type', 'target', 'animation'],
    ),

    // Cancel action
    'cancel': ActionSpec(
      type: 'cancel',
      description: 'Cancel a running action or operation',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'cancel',
          description: 'Action type identifier',
        ),
        'target': ParameterSpec(
          name: 'target',
          type: String,
          required: true,
          description: 'ID of the action or operation to cancel',
        ),
      },
      requiredParameters: ['type', 'target'],
    ),

    // Channel restart action
    'channel.restart': ActionSpec(
      type: 'channel.restart',
      description: 'Restart a bidirectional channel',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'channel.restart',
          description: 'Action type identifier',
        ),
        'channel': ParameterSpec(
          name: 'channel',
          type: String,
          required: true,
          description: 'Channel name to restart',
        ),
      },
      requiredParameters: ['type', 'channel'],
    ),

    // Channel send action
    'channel.send': ActionSpec(
      type: 'channel.send',
      description: 'Send a message through a channel',
      parameters: {
        'type': ParameterSpec(
          name: 'type',
          type: String,
          required: true,
          defaultValue: 'channel.send',
          description: 'Action type identifier',
        ),
        'channel': ParameterSpec(
          name: 'channel',
          type: String,
          required: true,
          description: 'Channel name to send through',
        ),
        'message': ParameterSpec(
          name: 'message',
          type: dynamic,
          required: true,
          description: 'Message payload to send',
        ),
      },
      requiredParameters: ['type', 'channel', 'message'],
    ),

    // Client actions (10 types)
    'client.selectFile': ActionSpec(
      type: 'client.selectFile',
      description: 'Open a file selection dialog on the client',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.selectFile', description: 'Action type identifier'),
        'accept': ParameterSpec(name: 'accept', type: String, description: 'Accepted file types (e.g., ".jpg,.png")'),
        'multiple': ParameterSpec(name: 'multiple', type: bool, defaultValue: false, description: 'Allow multiple file selection'),
      },
      requiredParameters: ['type'],
    ),

    'client.readFile': ActionSpec(
      type: 'client.readFile',
      description: 'Read a file from the client filesystem',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.readFile', description: 'Action type identifier'),
        'path': ParameterSpec(name: 'path', type: String, required: true, description: 'File path to read'),
      },
      requiredParameters: ['type', 'path'],
    ),

    'client.writeFile': ActionSpec(
      type: 'client.writeFile',
      description: 'Write data to a file on the client filesystem',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.writeFile', description: 'Action type identifier'),
        'path': ParameterSpec(name: 'path', type: String, required: true, description: 'File path to write'),
        'data': ParameterSpec(name: 'data', type: dynamic, required: true, description: 'Data to write'),
      },
      requiredParameters: ['type', 'path', 'data'],
    ),

    'client.saveFile': ActionSpec(
      type: 'client.saveFile',
      description: 'Open a save file dialog on the client',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.saveFile', description: 'Action type identifier'),
        'data': ParameterSpec(name: 'data', type: dynamic, required: true, description: 'Data to save'),
        'suggestedName': ParameterSpec(name: 'suggestedName', type: String, description: 'Suggested file name'),
      },
      requiredParameters: ['type', 'data'],
    ),

    'client.httpRequest': ActionSpec(
      type: 'client.httpRequest',
      description: 'Make an HTTP request from the client',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.httpRequest', description: 'Action type identifier'),
        'url': ParameterSpec(name: 'url', type: String, required: true, description: 'Request URL'),
        'method': ParameterSpec(name: 'method', type: String, defaultValue: 'GET', description: 'HTTP method'),
        'headers': ParameterSpec(name: 'headers', type: Map, description: 'Request headers'),
        'body': ParameterSpec(name: 'body', type: dynamic, description: 'Request body'),
      },
      requiredParameters: ['type', 'url'],
    ),

    'client.getSystemInfo': ActionSpec(
      type: 'client.getSystemInfo',
      description: 'Get client system information',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.getSystemInfo', description: 'Action type identifier'),
      },
      requiredParameters: ['type'],
    ),

    'client.clipboard': ActionSpec(
      type: 'client.clipboard',
      description: 'Read from or write to the client clipboard',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.clipboard', description: 'Action type identifier'),
        'action': ParameterSpec(name: 'action', type: String, required: true, allowedValues: ['read', 'write'], description: 'Clipboard action'),
        'data': ParameterSpec(name: 'data', type: String, description: 'Data to write to clipboard'),
      },
      requiredParameters: ['type', 'action'],
    ),

    'client.exec': ActionSpec(
      type: 'client.exec',
      description: 'Execute a command on the client (requires permission)',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.exec', description: 'Action type identifier'),
        'command': ParameterSpec(name: 'command', type: String, required: true, description: 'Command to execute'),
        'args': ParameterSpec(name: 'args', type: List, description: 'Command arguments'),
      },
      requiredParameters: ['type', 'command'],
    ),

    'client.notification': ActionSpec(
      type: 'client.notification',
      description: 'Show a native client notification',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.notification', description: 'Action type identifier'),
        'title': ParameterSpec(name: 'title', type: String, required: true, description: 'Notification title'),
        'body': ParameterSpec(name: 'body', type: String, description: 'Notification body text'),
      },
      requiredParameters: ['type', 'title'],
    ),

    'client.listFiles': ActionSpec(
      type: 'client.listFiles',
      description: 'List files in a client directory',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.listFiles', description: 'Action type identifier'),
        'path': ParameterSpec(name: 'path', type: String, required: true, description: 'Directory path to list'),
        'pattern': ParameterSpec(name: 'pattern', type: String, description: 'Glob pattern to filter files'),
      },
      requiredParameters: ['type', 'path'],
    ),

    // Storage actions
    'client.storage.get': ActionSpec(
      type: 'client.storage.get',
      description: 'Get a value from client storage',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.storage.get', description: 'Action type identifier'),
        'key': ParameterSpec(name: 'key', type: String, required: true, description: 'Storage key to retrieve'),
      },
      requiredParameters: ['type', 'key'],
    ),

    'client.storage.set': ActionSpec(
      type: 'client.storage.set',
      description: 'Set a value in client storage',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.storage.set', description: 'Action type identifier'),
        'key': ParameterSpec(name: 'key', type: String, required: true, description: 'Storage key to set'),
        'value': ParameterSpec(name: 'value', type: dynamic, required: true, description: 'Value to store'),
      },
      requiredParameters: ['type', 'key', 'value'],
    ),

    'client.storage.remove': ActionSpec(
      type: 'client.storage.remove',
      description: 'Remove a value from client storage',
      parameters: {
        'type': ParameterSpec(name: 'type', type: String, required: true, defaultValue: 'client.storage.remove', description: 'Action type identifier'),
        'key': ParameterSpec(name: 'key', type: String, required: true, description: 'Storage key to remove'),
      },
      requiredParameters: ['type', 'key'],
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