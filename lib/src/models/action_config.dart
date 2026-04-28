import 'package:meta/meta.dart';

/// Configuration for actions in the MCP UI DSL
///
/// Represents user interactions and their corresponding actions.
///
/// Deprecated: Use [ActionDefinition] sealed class hierarchy for type-safe action handling.
/// This class is retained for backward compatibility.
@Deprecated('Use ActionDefinition sealed hierarchy instead. This class uses flat untyped parameters.')
@immutable
class ActionConfig {
  /// Type of action (e.g., 'tool', 'state', 'navigation', 'batch', 'conditional')
  final String type;
  
  /// Action-specific parameters
  final Map<String, dynamic> parameters;
  
  /// Condition for conditional actions
  final String? condition;
  
  /// Action to execute if condition is true (for conditional actions) - DSL v1.0 compliant
  final ActionConfig? thenAction;
  
  /// Action to execute if condition is false (for conditional actions) - DSL v1.0 compliant
  final ActionConfig? elseAction;
  
  /// Multiple actions to execute (for batch actions)
  final List<ActionConfig>? actions;

  const ActionConfig({
    required this.type,
    this.parameters = const {},
    this.condition,
    this.thenAction,
    this.elseAction,
    this.actions,
  });

  /// Create an ActionConfig from JSON
  factory ActionConfig.fromJson(Map<String, dynamic> json) {
    return ActionConfig(
      type: json['type'] as String,
      parameters: Map<String, dynamic>.from(json).also((map) {
        map.remove('type');
        map.remove('condition');
        map.remove('then');
        map.remove('else');
        map.remove('actions');
      }),
      condition: json['condition'] as String?,
      thenAction: json['then'] != null
          ? ActionConfig.fromJson(json['then'] as Map<String, dynamic>)
          : null,
      elseAction: json['else'] != null
          ? ActionConfig.fromJson(json['else'] as Map<String, dynamic>)
          : null,
      actions: (json['actions'] as List?)
          ?.map((action) => ActionConfig.fromJson(action as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'type': type,
      ...parameters,
    };
    
    if (condition != null) {
      result['condition'] = condition;
    }
    
    if (thenAction != null) {
      result['then'] = thenAction!.toJson();
    }
    
    if (elseAction != null) {
      result['else'] = elseAction!.toJson();
    }
    
    if (actions != null) {
      result['actions'] = actions!.map((action) => action.toJson()).toList();
    }
    
    return result;
  }

  /// Create a tool action
  factory ActionConfig.tool(String tool, [Map<String, dynamic>? params]) {
    return ActionConfig(
      type: 'tool',
      parameters: {
        'tool': tool,
        if (params != null) 'params': params,
      },
    );
  }

  /// Create a state action
  factory ActionConfig.state({
    required String action,
    required String binding,
    dynamic value,
  }) {
    return ActionConfig(
      type: 'state',
      parameters: {
        'action': action,
        'binding': binding,
        if (value != null) 'value': value,
      },
    );
  }

  /// Create a navigation action (DSL v1.0 compliant)
  factory ActionConfig.navigation({
    required String action,
    required String route,
    Map<String, dynamic>? params,
  }) {
    return ActionConfig(
      type: 'navigation',
      parameters: {
        'action': action,
        'route': route,
        if (params != null) 'params': params,
      },
    );
  }

  /// Create a resource action
  factory ActionConfig.resource({
    required String action,
    required String uri,
    String? binding,
  }) {
    return ActionConfig(
      type: 'resource',
      parameters: {
        'action': action,
        'uri': uri,
        if (binding != null) 'binding': binding,
      },
    );
  }

  /// Create a batch action
  factory ActionConfig.batch(List<ActionConfig> actions) {
    return ActionConfig(
      type: 'batch',
      actions: actions,
    );
  }

  /// Create a conditional action
  factory ActionConfig.conditional({
    required String condition,
    required ActionConfig thenAction,
    ActionConfig? elseAction,
  }) {
    return ActionConfig(
      type: 'conditional',
      condition: condition,
      thenAction: thenAction,
      elseAction: elseAction,
    );
  }

  /// Create a dialog action
  factory ActionConfig.dialog({
    required String dialogType,
    String? title,
    String? content,
    bool? dismissible,
    List<Map<String, dynamic>>? actions,
    Map<String, dynamic>? body,
  }) {
    return ActionConfig(
      type: 'dialog',
      parameters: {
        'dialogType': dialogType,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (dismissible != null) 'dismissible': dismissible,
        if (actions != null) 'actions': actions,
        if (body != null) 'body': body,
      },
    );
  }

  /// Create a notification action
  factory ActionConfig.notification({
    required String message,
    String? severity,
    int? duration,
  }) {
    return ActionConfig(
      type: 'notification',
      parameters: {
        'message': message,
        if (severity != null) 'severity': severity,
        if (duration != null) 'duration': duration,
      },
    );
  }

  /// Create a parallel action
  factory ActionConfig.parallel(List<ActionConfig> actions) {
    return ActionConfig(
      type: 'parallel',
      actions: actions,
    );
  }

  /// Create a sequence action
  factory ActionConfig.sequence(List<ActionConfig> actions) {
    return ActionConfig(
      type: 'sequence',
      actions: actions,
    );
  }

  /// Get a parameter value with type safety
  T? getParameter<T>(String key, [T? defaultValue]) {
    final value = parameters[key];
    if (value is T) return value;
    return defaultValue;
  }

  /// Check if this is a tool action
  bool get isToolAction => type == 'tool';

  /// Check if this is a state action
  bool get isStateAction => type == 'state';

  /// Check if this is a navigation action
  bool get isNavigationAction => type == 'navigation';

  /// Check if this is a batch action
  bool get isBatchAction => type == 'batch';

  /// Check if this is a conditional action
  bool get isConditionalAction => type == 'conditional';

  /// Check if this is a resource action
  bool get isResourceAction => type == 'resource';

  /// Check if this is a dialog action
  bool get isDialogAction => type == 'dialog';

  /// Check if this is a notification action
  bool get isNotificationAction => type == 'notification';

  /// Check if this is a parallel action
  bool get isParallelAction => type == 'parallel';

  /// Check if this is a sequence action
  bool get isSequenceAction => type == 'sequence';

  /// Get the tool name (for tool actions)
  String? get toolName => getParameter<String>('tool');

  /// Get the tool parameters (for tool actions)
  Map<String, dynamic>? get toolParams => getParameter<Map<String, dynamic>>('params');

  /// Get the state action type (for state actions)
  String? get stateAction => getParameter<String>('action');

  /// Get the state binding (for state actions)
  String? get stateBinding => getParameter<String>('binding');

  /// Get the state value (for state actions)
  dynamic get stateValue => getParameter('value');

  /// Get the navigation action type (for navigation actions)
  String? get navigationAction => getParameter<String>('action');

  /// Get the navigation route (for navigation actions) - DSL v1.0 compliant
  String? get navigationRoute => getParameter<String>('route');

  /// Get the navigation parameters (for navigation actions)
  Map<String, dynamic>? get navigationParams => getParameter<Map<String, dynamic>>('params');

  /// Get the resource action type (for resource actions)
  String? get resourceAction => getParameter<String>('action');

  /// Get the resource URI (for resource actions)
  String? get resourceUri => getParameter<String>('uri');

  /// Get the resource binding (for resource actions)
  String? get resourceBinding => getParameter<String>('binding');

  /// Validate the action configuration
  bool isValid() {
    if (type.isEmpty) return false;
    
    switch (type) {
      case 'tool':
        return toolName != null && toolName!.isNotEmpty;
      case 'state':
        return stateAction != null && stateAction!.isNotEmpty && 
               stateBinding != null && stateBinding!.isNotEmpty;
      case 'navigation':
        return navigationAction != null && navigationAction!.isNotEmpty && 
               navigationRoute != null && navigationRoute!.isNotEmpty;
      case 'resource':
        return resourceAction != null && resourceUri != null && 
               (resourceAction == 'unsubscribe' || resourceBinding != null);
      case 'batch':
        return actions != null && actions!.isNotEmpty && actions!.every((action) => action.isValid());
      case 'conditional':
        return condition != null &&
               thenAction != null &&
               thenAction!.isValid() &&
               (elseAction == null || elseAction!.isValid());
      case 'dialog':
        final dialogType = getParameter<String>('dialogType');
        return dialogType != null && dialogType.isNotEmpty;
      case 'notification':
        final message = getParameter<String>('message');
        return message != null && message.isNotEmpty;
      case 'parallel':
        return actions != null && actions!.isNotEmpty && actions!.every((action) => action.isValid());
      case 'sequence':
        return actions != null && actions!.isNotEmpty && actions!.every((action) => action.isValid());
      default:
        return true; // Allow custom action types
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionConfig &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          _mapsEqual(parameters, other.parameters) &&
          condition == other.condition &&
          thenAction == other.thenAction &&
          elseAction == other.elseAction &&
          _listsEqual(actions, other.actions);

  @override
  int get hashCode =>
      type.hashCode ^
      parameters.hashCode ^
      condition.hashCode ^
      thenAction.hashCode ^
      elseAction.hashCode ^
      actions.hashCode;

  bool _mapsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  bool _listsEqual(List<ActionConfig>? a, List<ActionConfig>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'ActionConfig(type: $type, parameters: $parameters)';
  }
}

extension on Map<String, dynamic> {
  Map<String, dynamic> also(void Function(Map<String, dynamic>) block) {
    block(this);
    return this;
  }
}