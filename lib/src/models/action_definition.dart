import 'package:meta/meta.dart';

import 'action_config.dart';
import 'widget_definition.dart';

/// Strongly-typed action definition hierarchy for MCP UI DSL v1.0
///
/// Sealed class hierarchy providing type-safe action definitions.
/// This is the recommended replacement for [ActionConfig] which uses
/// a flat structure with untyped parameters map.
sealed class ActionDefinition {
  const ActionDefinition();

  /// The action type identifier used in JSON serialization
  String get type;

  /// Serialize this action definition to JSON
  Map<String, dynamic> toJson();

  /// Convert to legacy [ActionConfig] for backward compatibility
  ActionConfig toConfig();

  /// Create an [ActionDefinition] from JSON, dispatching to the correct subtype
  factory ActionDefinition.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    if (type == null) {
      throw ArgumentError('ActionDefinition.fromJson requires a "type" field, '
          'but none was found in: $json');
    }

    // Client actions have type starting with 'client.'
    if (type.startsWith('client.')) {
      return ClientActionDefinition.fromJson(json);
    }

    // Channel actions have type starting with 'channel.'
    if (type.startsWith('channel.')) {
      return ChannelActionDefinition.fromJson(json);
    }

    // Permission actions have type starting with 'permission.'
    if (type.startsWith('permission.')) {
      return PermissionRevokeActionDefinition.fromJson(json);
    }

    return switch (type) {
      'state' => StateActionDefinition.fromJson(json),
      'navigation' => NavigationActionDefinition.fromJson(json),
      'tool' => ToolActionDefinition.fromJson(json),
      'resource' => ResourceActionDefinition.fromJson(json),
      'dialog' => DialogActionDefinition.fromJson(json),
      'batch' => BatchActionDefinition.fromJson(json),
      'conditional' => ConditionalActionDefinition.fromJson(json),
      'notification' => NotificationActionDefinition.fromJson(json),
      'parallel' => ParallelActionDefinition.fromJson(json),
      'sequence' => SequenceActionDefinition.fromJson(json),
      'animation' => AnimationActionDefinition.fromJson(json),
      'cancel' => CancelActionDefinition.fromJson(json),
      _ => throw ArgumentError(
          'Unknown ActionDefinition type "$type". '
          'Supported types: state, navigation, tool, resource, dialog, '
          'batch, conditional, notification, parallel, sequence, '
          'animation, cancel, permission.*, client.*, channel.*'),
    };
  }

  /// Create an [ActionDefinition] from a legacy [ActionConfig]
  factory ActionDefinition.fromConfig(ActionConfig config) {
    // Client actions have type starting with 'client.'
    if (config.type.startsWith('client.')) {
      return ClientActionDefinition(
        action: config.type,
        params: config.getParameter<Map<String, dynamic>>('params'),
        onSuccess: _parseConfigSingleAction(config.getParameter('onSuccess')),
        onError: _parseConfigSingleAction(config.getParameter('onError')),
        confirmMessage: config.getParameter<String>('confirmMessage'),
        requireConfirmation: config.getParameter<bool>('requireConfirmation'),
      );
    }

    // Channel actions have type starting with 'channel.'
    if (config.type.startsWith('channel.')) {
      return ChannelActionDefinition(
        action: config.type.replaceFirst('channel.', ''),
        channel: config.getParameter<String>('channel') ?? '',
      );
    }

    return switch (config.type) {
      'state' => StateActionDefinition(
          action: config.getParameter<String>('action') ?? 'set',
          binding: config.getParameter<String>('binding') ?? '',
          value: config.getParameter('value'),
        ),
      'navigation' => NavigationActionDefinition(
          action: config.getParameter<String>('action') ?? 'push',
          route: config.getParameter<String>('route'),
          params: config.getParameter<Map<String, dynamic>>('params'),
          index: config.getParameter<int>('index'),
        ),
      'tool' => ToolActionDefinition(
          tool: config.getParameter<String>('tool') ?? '',
          params: config.getParameter<Map<String, dynamic>>('params'),
          onSuccess: _parseConfigSingleAction(
              config.getParameter<Map<String, dynamic>>('onSuccess')),
          onError: _parseConfigSingleAction(
              config.getParameter<Map<String, dynamic>>('onError')),
          retry: config.getParameter<Map<String, dynamic>>('retry') != null
              ? RetryStrategy.fromJson(
                  config.getParameter<Map<String, dynamic>>('retry')!)
              : null,
          bindResult: config.getParameter<String>('bindResult'),
          timeout: config.getParameter<int>('timeout'),
          onTimeout: _parseConfigSingleAction(
              config.getParameter<Map<String, dynamic>>('onTimeout')),
          cancellable: config.getParameter<bool>('cancellable'),
          onCancel: _parseConfigSingleAction(
              config.getParameter<Map<String, dynamic>>('onCancel')),
          loading: _parseConfigLoading(config.getParameter('loading')),
        ),
      'resource' => ResourceActionDefinition(
          action: config.getParameter<String>('action') ?? 'subscribe',
          uri: config.getParameter<String>('uri') ?? '',
          binding: config.getParameter<String>('binding'),
          method: config.getParameter<String>('method'),
          target: config.getParameter<String>('target'),
          data: config.getParameter('data'),
          bindResult: config.getParameter<String>('bindResult'),
          scope: config.getParameter<String>('scope'),
        ),
      'dialog' => DialogActionDefinition(
          dialogType: config.getParameter<String>('dialogType') ?? 'alert',
          title: config.getParameter<String>('title'),
          content: config.getParameter<String>('content'),
          dismissible: config.getParameter<bool>('dismissible'),
          actions: _parseDialogButtons(config.getParameter<List>('actions')),
          child: config.getParameter<Map<String, dynamic>>('child') != null
              ? WidgetDefinition.fromJson(
                  config.getParameter<Map<String, dynamic>>('child')!)
              : config.getParameter<Map<String, dynamic>>('body') != null
                  ? WidgetDefinition.fromJson(
                      config.getParameter<Map<String, dynamic>>('body')!)
                  : null,
        ),
      'batch' => BatchActionDefinition(
          actions: config.actions
                  ?.map(ActionDefinition.fromConfig)
                  .toList() ??
              const [],
        ),
      'conditional' => ConditionalActionDefinition(
          condition: config.condition ?? '',
          thenAction: config.thenAction != null
              ? ActionDefinition.fromConfig(config.thenAction!)
              : const StateActionDefinition(
                  action: 'set', binding: '', value: null),
          elseAction: config.elseAction != null
              ? ActionDefinition.fromConfig(config.elseAction!)
              : null,
        ),
      'notification' => NotificationActionDefinition(
          message: config.getParameter<String>('message') ?? '',
          severity: config.getParameter<String>('severity'),
          duration: config.getParameter<int>('duration'),
          position: config.getParameter<String>('position'),
          action: config.getParameter<Map<String, dynamic>>('action') != null
              ? NotificationAction.fromJson(
                  config.getParameter<Map<String, dynamic>>('action')!)
              : null,
        ),
      'parallel' => ParallelActionDefinition(
          actions: config.actions
                  ?.map(ActionDefinition.fromConfig)
                  .toList() ??
              const [],
        ),
      'sequence' => SequenceActionDefinition(
          actions: config.actions
                  ?.map(ActionDefinition.fromConfig)
                  .toList() ??
              const [],
        ),
      'animation' => AnimationActionDefinition(
          action: config.getParameter<String>('action') ?? 'play',
          target: config.getParameter<String>('target') ?? '',
          duration: config.getParameter<int>('duration'),
          curve: config.getParameter<String>('curve'),
        ),
      'cancel' => CancelActionDefinition(
          target: config.getParameter<String>('target') ?? '',
        ),
      _ => throw ArgumentError(
          'Unknown ActionConfig type "${config.type}". '
          'Cannot convert to ActionDefinition.'),
    };
  }

  /// Parse a single action JSON object from a config parameter
  static ActionDefinition? _parseConfigSingleAction(
      Map<String, dynamic>? json) {
    if (json == null) return null;
    return ActionDefinition.fromJson(json);
  }

  /// Parse loading config from a config parameter (string or map)
  static LoadingConfig? _parseConfigLoading(dynamic value) {
    if (value == null) return null;
    if (value is String) return LoadingConfig(binding: value);
    if (value is Map<String, dynamic>) return LoadingConfig.fromJson(value);
    return null;
  }

  /// Parse dialog button list from config parameter
  static List<DialogButton>? _parseDialogButtons(List<dynamic>? list) {
    if (list == null) return null;
    return list
        .whereType<Map<String, dynamic>>()
        .map(DialogButton.fromJson)
        .toList();
  }
}

// ---------------------------------------------------------------------------
// StateActionDefinition
// ---------------------------------------------------------------------------

/// Action that modifies application state
@immutable
class StateActionDefinition extends ActionDefinition {
  /// The state operation: 'set', 'increment', 'decrement', 'toggle',
  /// 'append', 'remove', 'push', 'pop', 'removeAt'
  final String action;

  /// The state binding path to modify
  final String binding;

  /// The value to apply (interpretation depends on [action])
  final dynamic value;

  const StateActionDefinition({
    required this.action,
    required this.binding,
    this.value,
  });

  @override
  String get type => 'state';

  /// Create a [StateActionDefinition] from JSON
  factory StateActionDefinition.fromJson(Map<String, dynamic> json) {
    return StateActionDefinition(
      action: json['action'] as String? ?? 'set',
      binding: json['binding'] as String? ?? '',
      value: json['value'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'action': action,
      'binding': binding,
      if (value != null) 'value': value,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'action': action,
        'binding': binding,
        if (value != null) 'value': value,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateActionDefinition &&
          runtimeType == other.runtimeType &&
          action == other.action &&
          binding == other.binding &&
          value == other.value;

  @override
  int get hashCode => action.hashCode ^ binding.hashCode ^ value.hashCode;

  @override
  String toString() =>
      'StateActionDefinition(action: $action, binding: $binding, value: $value)';
}

// ---------------------------------------------------------------------------
// NavigationActionDefinition
// ---------------------------------------------------------------------------

/// Action that performs navigation
@immutable
class NavigationActionDefinition extends ActionDefinition {
  /// The navigation operation: 'push', 'replace', 'pop', 'popToRoot',
  /// 'pushAndClear', 'setIndex'
  final String action;

  /// The target route path
  final String? route;

  /// Additional navigation parameters
  final Map<String, dynamic>? params;

  /// The index for setIndex navigation action
  final int? index;

  const NavigationActionDefinition({
    required this.action,
    this.route,
    this.params,
    this.index,
  });

  @override
  String get type => 'navigation';

  /// Create a [NavigationActionDefinition] from JSON
  factory NavigationActionDefinition.fromJson(Map<String, dynamic> json) {
    return NavigationActionDefinition(
      action: json['action'] as String? ?? 'push',
      route: json['route'] as String?,
      params: json['params'] != null
          ? Map<String, dynamic>.from(json['params'] as Map)
          : null,
      index: json['index'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'action': action,
      if (route != null) 'route': route,
      if (params != null) 'params': params,
      if (index != null) 'index': index,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'action': action,
        if (route != null) 'route': route!,
        if (params != null) 'params': params!,
        if (index != null) 'index': index!,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationActionDefinition &&
          runtimeType == other.runtimeType &&
          action == other.action &&
          route == other.route &&
          index == other.index &&
          _mapsEqual(params, other.params);

  @override
  int get hashCode =>
      action.hashCode ^ route.hashCode ^ params.hashCode ^ index.hashCode;

  @override
  String toString() =>
      'NavigationActionDefinition(action: $action, route: $route, params: $params, index: $index)';
}

// ---------------------------------------------------------------------------
// ToolActionDefinition
// ---------------------------------------------------------------------------

/// Action that invokes an MCP tool
@immutable
class ToolActionDefinition extends ActionDefinition {
  /// The MCP tool name to invoke
  final String tool;

  /// Parameters to pass to the tool
  final Map<String, dynamic>? params;

  /// Action to execute on successful tool completion
  final ActionDefinition? onSuccess;

  /// Action to execute on tool error
  final ActionDefinition? onError;

  /// Retry strategy for failed tool calls
  final RetryStrategy? retry;

  /// State binding path to store the tool result
  final String? bindResult;

  /// Timeout in milliseconds for the tool call
  final int? timeout;

  /// Action to execute when the tool call times out
  final ActionDefinition? onTimeout;

  /// Whether this tool action can be cancelled
  final bool? cancellable;

  /// Action to execute when the tool call is cancelled
  final ActionDefinition? onCancel;

  /// Loading state configuration
  final LoadingConfig? loading;

  const ToolActionDefinition({
    required this.tool,
    this.params,
    this.onSuccess,
    this.onError,
    this.retry,
    this.bindResult,
    this.timeout,
    this.onTimeout,
    this.cancellable,
    this.onCancel,
    this.loading,
  });

  @override
  String get type => 'tool';

  /// Create a [ToolActionDefinition] from JSON
  factory ToolActionDefinition.fromJson(Map<String, dynamic> json) {
    return ToolActionDefinition(
      tool: json['tool'] as String? ?? '',
      params: json['params'] != null
          ? Map<String, dynamic>.from(json['params'] as Map)
          : null,
      onSuccess: json['onSuccess'] != null
          ? ActionDefinition.fromJson(
              json['onSuccess'] as Map<String, dynamic>)
          : null,
      onError: json['onError'] != null
          ? ActionDefinition.fromJson(
              json['onError'] as Map<String, dynamic>)
          : null,
      retry: json['retry'] != null
          ? RetryStrategy.fromJson(json['retry'] as Map<String, dynamic>)
          : null,
      bindResult: json['bindResult'] as String?,
      timeout: json['timeout'] as int?,
      onTimeout: json['onTimeout'] != null
          ? ActionDefinition.fromJson(
              json['onTimeout'] as Map<String, dynamic>)
          : null,
      cancellable: json['cancellable'] as bool?,
      onCancel: json['onCancel'] != null
          ? ActionDefinition.fromJson(
              json['onCancel'] as Map<String, dynamic>)
          : null,
      // Accept string binding or map with binding+text
      loading: json['loading'] is String
          ? LoadingConfig(binding: json['loading'] as String)
          : json['loading'] is Map<String, dynamic>
              ? LoadingConfig.fromJson(json['loading'] as Map<String, dynamic>)
              : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'tool': tool,
      if (params != null) 'params': params,
      if (onSuccess != null) 'onSuccess': onSuccess!.toJson(),
      if (onError != null) 'onError': onError!.toJson(),
      if (retry != null) 'retry': retry!.toJson(),
      if (bindResult != null) 'bindResult': bindResult,
      if (timeout != null) 'timeout': timeout,
      if (onTimeout != null) 'onTimeout': onTimeout!.toJson(),
      if (cancellable != null) 'cancellable': cancellable,
      if (onCancel != null) 'onCancel': onCancel!.toJson(),
      if (loading != null) 'loading': loading!.toJson(),
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'tool': tool,
        if (params != null) 'params': params!,
        if (onSuccess != null) 'onSuccess': onSuccess!.toJson(),
        if (onError != null) 'onError': onError!.toJson(),
        if (retry != null) 'retry': retry!.toJson(),
        if (bindResult != null) 'bindResult': bindResult!,
        if (timeout != null) 'timeout': timeout!,
        if (onTimeout != null) 'onTimeout': onTimeout!.toJson(),
        if (cancellable != null) 'cancellable': cancellable!,
        if (onCancel != null) 'onCancel': onCancel!.toJson(),
        if (loading != null) 'loading': loading!.toJson(),
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolActionDefinition &&
          runtimeType == other.runtimeType &&
          tool == other.tool &&
          _mapsEqual(params, other.params) &&
          onSuccess == other.onSuccess &&
          onError == other.onError &&
          retry == other.retry &&
          bindResult == other.bindResult &&
          timeout == other.timeout &&
          onTimeout == other.onTimeout &&
          cancellable == other.cancellable &&
          onCancel == other.onCancel &&
          loading == other.loading;

  @override
  int get hashCode =>
      tool.hashCode ^
      params.hashCode ^
      onSuccess.hashCode ^
      onError.hashCode ^
      retry.hashCode ^
      bindResult.hashCode ^
      timeout.hashCode ^
      onTimeout.hashCode ^
      cancellable.hashCode ^
      onCancel.hashCode ^
      loading.hashCode;

  @override
  String toString() =>
      'ToolActionDefinition(tool: $tool, params: $params, '
      'onSuccess: $onSuccess, onError: $onError, '
      'retry: $retry, timeout: $timeout, '
      'cancellable: $cancellable, loading: $loading)';
}

// ---------------------------------------------------------------------------
// ResourceActionDefinition
// ---------------------------------------------------------------------------

/// Action that manages MCP resource subscriptions
@immutable
class ResourceActionDefinition extends ActionDefinition {
  /// The resource operation: 'subscribe', 'unsubscribe', 'read', 'list'
  final String action;

  /// The resource URI
  final String uri;

  /// The state binding path to store the resource data
  final String? binding;

  /// HTTP method for HTTP-style resource actions (e.g., 'GET', 'POST', 'PUT', 'DELETE')
  final String? method;

  /// Target path for HTTP-style resource actions
  final String? target;

  /// Data payload for HTTP-style resource actions
  final dynamic data;

  /// State binding path to store the result of HTTP-style resource actions
  final String? bindResult;

  /// Optional permission scope for this resource action
  final String? scope;

  const ResourceActionDefinition({
    required this.action,
    required this.uri,
    this.binding,
    this.method,
    this.target,
    this.data,
    this.bindResult,
    this.scope,
  });

  @override
  String get type => 'resource';

  /// Create a [ResourceActionDefinition] from JSON
  factory ResourceActionDefinition.fromJson(Map<String, dynamic> json) {
    return ResourceActionDefinition(
      action: json['action'] as String? ?? 'subscribe',
      uri: json['uri'] as String? ?? '',
      binding: json['binding'] as String?,
      method: json['method'] as String?,
      target: json['target'] as String?,
      data: json['data'],
      bindResult: json['bindResult'] as String?,
      scope: json['scope'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'action': action,
      'uri': uri,
      if (binding != null) 'binding': binding,
      if (method != null) 'method': method,
      if (target != null) 'target': target,
      if (data != null) 'data': data,
      if (bindResult != null) 'bindResult': bindResult,
      if (scope != null) 'scope': scope,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'action': action,
        'uri': uri,
        if (binding != null) 'binding': binding!,
        if (method != null) 'method': method!,
        if (target != null) 'target': target!,
        if (data != null) 'data': data,
        if (bindResult != null) 'bindResult': bindResult!,
        if (scope != null) 'scope': scope!,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceActionDefinition &&
          runtimeType == other.runtimeType &&
          action == other.action &&
          uri == other.uri &&
          binding == other.binding &&
          method == other.method &&
          target == other.target &&
          data == other.data &&
          bindResult == other.bindResult &&
          scope == other.scope;

  @override
  int get hashCode =>
      action.hashCode ^
      uri.hashCode ^
      binding.hashCode ^
      method.hashCode ^
      target.hashCode ^
      data.hashCode ^
      bindResult.hashCode ^
      scope.hashCode;

  @override
  String toString() =>
      'ResourceActionDefinition(action: $action, uri: $uri, binding: $binding, '
      'method: $method, target: $target, data: $data, bindResult: $bindResult, scope: $scope)';
}

// ---------------------------------------------------------------------------
// DialogActionDefinition
// ---------------------------------------------------------------------------

/// Action that shows a dialog or bottom sheet
@immutable
class DialogActionDefinition extends ActionDefinition {
  /// The dialog variant: 'alert', 'simple', 'custom', 'bottomSheet'
  final String dialogType;

  /// The dialog title
  final String? title;

  /// The dialog content text
  final String? content;

  /// Whether the dialog can be dismissed by tapping outside
  final bool? dismissible;

  /// Button definitions for the dialog
  final List<DialogButton>? actions;

  /// The child widget definition for custom dialogs and bottom sheets
  final WidgetDefinition? child;

  const DialogActionDefinition({
    required this.dialogType,
    this.title,
    this.content,
    this.dismissible,
    this.actions,
    this.child,
  });

  @override
  String get type => 'dialog';

  /// Create a [DialogActionDefinition] from JSON
  ///
  /// Supports both flat and nested dialog structures:
  /// - Flat: `{type: "dialog", dialogType: "alert", title: "..."}`
  /// - Nested: `{type: "dialog", dialog: {type: "alert", title: "..."}}`
  factory DialogActionDefinition.fromJson(Map<String, dynamic> json) {
    // Support nested dialog structure: {type: "dialog", dialog: {type: "alert", ...}}
    final dialogMap = json['dialog'] as Map<String, dynamic>?;
    final source = dialogMap ?? json;

    return DialogActionDefinition(
      dialogType: (dialogMap != null
              ? source['type'] as String?
              : source['dialogType'] as String?) ??
          'alert',
      title: source['title'] as String?,
      content: source['content'] as String?,
      dismissible: source['dismissible'] as bool?,
      actions: source['actions'] != null
          ? (source['actions'] as List)
              .map((e) => DialogButton.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : null,
      child: source['child'] != null
          ? WidgetDefinition.fromJson(source['child'] as Map<String, dynamic>)
          : source['body'] != null
              ? WidgetDefinition.fromJson(source['body'] as Map<String, dynamic>)
              : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dialog': {
        'type': dialogType,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (dismissible != null) 'dismissible': dismissible,
        if (actions != null)
          'actions': actions!.map((a) => a.toJson()).toList(),
        if (child != null) 'child': child!.toJson(),
      },
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'dialogType': dialogType,
        if (title != null) 'title': title!,
        if (content != null) 'content': content!,
        if (dismissible != null) 'dismissible': dismissible!,
        if (actions != null)
          'actions': actions!.map((a) => a.toJson()).toList(),
        if (child != null) 'child': child!.toJson(),
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogActionDefinition &&
          runtimeType == other.runtimeType &&
          dialogType == other.dialogType &&
          title == other.title &&
          content == other.content &&
          dismissible == other.dismissible &&
          _dialogButtonListsEqual(actions, other.actions) &&
          child == other.child;

  @override
  int get hashCode =>
      dialogType.hashCode ^
      title.hashCode ^
      content.hashCode ^
      dismissible.hashCode ^
      actions.hashCode ^
      child.hashCode;

  @override
  String toString() =>
      'DialogActionDefinition(dialogType: $dialogType, title: $title, '
      'content: $content, dismissible: $dismissible)';
}

// ---------------------------------------------------------------------------
// DialogButton
// ---------------------------------------------------------------------------

/// A button definition for use within a [DialogActionDefinition]
@immutable
class DialogButton {
  /// The button label text
  final String label;

  /// The action to perform: "close" string or ActionDefinition JSON map
  final dynamic action;

  /// Whether this is the primary (emphasized) button
  final bool? primary;

  const DialogButton({
    required this.label,
    this.action,
    this.primary,
  });

  /// Create a [DialogButton] from JSON
  factory DialogButton.fromJson(Map<String, dynamic> json) {
    return DialogButton(
      label: json['label'] as String? ?? '',
      action: json['action'],
      primary: json['primary'] as bool?,
    );
  }

  /// Serialize this button definition to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      if (action != null)
        'action': action is ActionDefinition
            ? (action as ActionDefinition).toJson()
            : action,
      if (primary != null) 'primary': primary,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogButton &&
          label == other.label &&
          primary == other.primary;

  @override
  int get hashCode => label.hashCode ^ primary.hashCode;
}

// ---------------------------------------------------------------------------
// BatchActionDefinition
// ---------------------------------------------------------------------------

/// Action that executes multiple actions sequentially (legacy batch)
@immutable
class BatchActionDefinition extends ActionDefinition {
  /// The list of actions to execute
  final List<ActionDefinition> actions;

  /// Whether to execute actions sequentially (true) or in parallel (false)
  final bool sequential;

  /// Whether to stop execution on first error
  final bool stopOnError;

  const BatchActionDefinition({
    required this.actions,
    this.sequential = true,
    this.stopOnError = false,
  });

  @override
  String get type => 'batch';

  /// Create a [BatchActionDefinition] from JSON
  factory BatchActionDefinition.fromJson(Map<String, dynamic> json) {
    return BatchActionDefinition(
      actions: json['actions'] != null
          ? (json['actions'] as List)
              .map((e) =>
                  ActionDefinition.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      sequential: json['sequential'] as bool? ?? true,
      stopOnError: json['stopOnError'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'actions': actions.map((a) => a.toJson()).toList(),
      if (!sequential) 'sequential': sequential,
      if (stopOnError) 'stopOnError': stopOnError,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      actions: actions.map((a) => a.toConfig()).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatchActionDefinition &&
          runtimeType == other.runtimeType &&
          sequential == other.sequential &&
          stopOnError == other.stopOnError &&
          _actionListsEqual(actions, other.actions);

  @override
  int get hashCode => Object.hash(actions.hashCode, sequential, stopOnError);

  @override
  String toString() =>
      'BatchActionDefinition(actions: [${actions.length} actions])';
}

// ---------------------------------------------------------------------------
// ConditionalActionDefinition
// ---------------------------------------------------------------------------

/// Action that conditionally executes one of two branches
@immutable
class ConditionalActionDefinition extends ActionDefinition {
  /// The condition expression to evaluate
  final String condition;

  /// Action to execute when condition is true
  final ActionDefinition thenAction;

  /// Action to execute when condition is false (optional)
  final ActionDefinition? elseAction;

  const ConditionalActionDefinition({
    required this.condition,
    required this.thenAction,
    this.elseAction,
  });

  @override
  String get type => 'conditional';

  /// Create a [ConditionalActionDefinition] from JSON
  factory ConditionalActionDefinition.fromJson(Map<String, dynamic> json) {
    return ConditionalActionDefinition(
      condition: json['condition'] as String? ?? '',
      thenAction:
          ActionDefinition.fromJson(json['then'] as Map<String, dynamic>),
      elseAction: json['else'] != null
          ? ActionDefinition.fromJson(json['else'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'condition': condition,
      'then': thenAction.toJson(),
      if (elseAction != null) 'else': elseAction!.toJson(),
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      condition: condition,
      thenAction: thenAction.toConfig(),
      elseAction: elseAction?.toConfig(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConditionalActionDefinition &&
          runtimeType == other.runtimeType &&
          condition == other.condition &&
          thenAction == other.thenAction &&
          elseAction == other.elseAction;

  @override
  int get hashCode =>
      condition.hashCode ^ thenAction.hashCode ^ elseAction.hashCode;

  @override
  String toString() =>
      'ConditionalActionDefinition(condition: $condition, '
      'thenAction: $thenAction, elseAction: $elseAction)';
}

// ---------------------------------------------------------------------------
// NotificationActionDefinition
// ---------------------------------------------------------------------------

/// Action that shows a notification or snackbar
@immutable
class NotificationActionDefinition extends ActionDefinition {
  /// The notification message text
  final String message;

  /// The notification severity: 'info', 'success', 'warning', 'error'
  final String? severity;

  /// Display duration in milliseconds
  final int? duration;

  /// Notification position: 'top', 'bottom', 'center'
  final String? position;

  /// Action button for the notification
  final NotificationAction? action;

  const NotificationActionDefinition({
    required this.message,
    this.severity,
    this.duration,
    this.position,
    this.action,
  });

  @override
  String get type => 'notification';

  /// Create a [NotificationActionDefinition] from JSON
  factory NotificationActionDefinition.fromJson(Map<String, dynamic> json) {
    return NotificationActionDefinition(
      message: json['message'] as String? ?? '',
      severity: json['severity'] as String?,
      duration: json['duration'] as int?,
      position: json['position'] as String?,
      action: json['action'] != null
          ? NotificationAction.fromJson(
              json['action'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      if (severity != null) 'severity': severity,
      if (duration != null) 'duration': duration,
      if (position != null) 'position': position,
      if (action != null) 'action': action!.toJson(),
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'message': message,
        if (severity != null) 'severity': severity!,
        if (duration != null) 'duration': duration!,
        if (position != null) 'position': position!,
        if (action != null) 'action': action!.toJson(),
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationActionDefinition &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          severity == other.severity &&
          duration == other.duration &&
          position == other.position &&
          action == other.action;

  @override
  int get hashCode =>
      message.hashCode ^
      severity.hashCode ^
      duration.hashCode ^
      position.hashCode ^
      action.hashCode;

  @override
  String toString() =>
      'NotificationActionDefinition(message: $message, severity: $severity, '
      'duration: $duration)';
}

// ---------------------------------------------------------------------------
// ParallelActionDefinition
// ---------------------------------------------------------------------------

/// Action that executes multiple actions in parallel
@immutable
class ParallelActionDefinition extends ActionDefinition {
  /// The list of actions to execute concurrently
  final List<ActionDefinition> actions;

  /// Action to execute when all parallel actions complete
  final ActionDefinition? onAllComplete;

  /// Action to execute when any parallel action errors
  final ActionDefinition? onAnyError;

  const ParallelActionDefinition({
    required this.actions,
    this.onAllComplete,
    this.onAnyError,
  });

  @override
  String get type => 'parallel';

  /// Create a [ParallelActionDefinition] from JSON
  factory ParallelActionDefinition.fromJson(Map<String, dynamic> json) {
    return ParallelActionDefinition(
      actions: json['actions'] != null
          ? (json['actions'] as List)
              .map((e) =>
                  ActionDefinition.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      onAllComplete: json['onAllComplete'] != null
          ? ActionDefinition.fromJson(
              json['onAllComplete'] as Map<String, dynamic>)
          : null,
      onAnyError: json['onAnyError'] != null
          ? ActionDefinition.fromJson(
              json['onAnyError'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'actions': actions.map((a) => a.toJson()).toList(),
      if (onAllComplete != null) 'onAllComplete': onAllComplete!.toJson(),
      if (onAnyError != null) 'onAnyError': onAnyError!.toJson(),
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      actions: actions.map((a) => a.toConfig()).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParallelActionDefinition &&
          runtimeType == other.runtimeType &&
          onAllComplete == other.onAllComplete &&
          onAnyError == other.onAnyError &&
          _actionListsEqual(actions, other.actions);

  @override
  int get hashCode => Object.hash(actions.hashCode, onAllComplete, onAnyError);

  @override
  String toString() =>
      'ParallelActionDefinition(actions: [${actions.length} actions])';
}

// ---------------------------------------------------------------------------
// SequenceActionDefinition
// ---------------------------------------------------------------------------

/// Action that executes multiple actions sequentially with ordering guarantees
@immutable
class SequenceActionDefinition extends ActionDefinition {
  /// The ordered list of actions to execute sequentially
  final List<ActionDefinition> actions;

  /// Whether to stop execution on first error (Spec default: true)
  final bool stopOnError;

  /// Action to execute when the entire sequence completes
  final ActionDefinition? onComplete;

  const SequenceActionDefinition({
    required this.actions,
    this.stopOnError = true,
    this.onComplete,
  });

  @override
  String get type => 'sequence';

  /// Create a [SequenceActionDefinition] from JSON
  factory SequenceActionDefinition.fromJson(Map<String, dynamic> json) {
    return SequenceActionDefinition(
      actions: json['actions'] != null
          ? (json['actions'] as List)
              .map((e) =>
                  ActionDefinition.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      stopOnError: json['stopOnError'] as bool? ?? true,
      onComplete: json['onComplete'] != null
          ? ActionDefinition.fromJson(
              json['onComplete'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'actions': actions.map((a) => a.toJson()).toList(),
      if (!stopOnError) 'stopOnError': false,
      if (onComplete != null) 'onComplete': onComplete!.toJson(),
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      actions: actions.map((a) => a.toConfig()).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SequenceActionDefinition &&
          runtimeType == other.runtimeType &&
          stopOnError == other.stopOnError &&
          onComplete == other.onComplete &&
          _actionListsEqual(actions, other.actions);

  @override
  int get hashCode => Object.hash(actions.hashCode, stopOnError, onComplete);

  @override
  String toString() =>
      'SequenceActionDefinition(actions: [${actions.length} actions])';
}

// ---------------------------------------------------------------------------
// ClientActionDefinition
// ---------------------------------------------------------------------------

/// Action that invokes a client-side capability
///
/// Client actions have types like 'client.selectFile', 'client.readFile',
/// 'client.writeFile', 'client.httpRequest', 'client.getSystemInfo',
/// 'client.exec'. The [action] field IS the type for serialization.
@immutable
class ClientActionDefinition extends ActionDefinition {
  /// The client action identifier (e.g., 'client.selectFile', 'client.exec')
  /// This value is also used as the [type] for JSON serialization.
  final String action;

  /// Parameters to pass to the client action
  final Map<String, dynamic>? params;

  /// Action to execute on successful completion
  final ActionDefinition? onSuccess;

  /// Action to execute on error
  final ActionDefinition? onError;

  /// Confirmation message to display before executing (v1.1)
  final String? confirmMessage;

  /// Whether to require user confirmation before executing (v1.1)
  final bool? requireConfirmation;

  const ClientActionDefinition({
    required this.action,
    this.params,
    this.onSuccess,
    this.onError,
    this.confirmMessage,
    this.requireConfirmation,
  });

  @override
  String get type => action;

  /// Create a [ClientActionDefinition] from JSON
  factory ClientActionDefinition.fromJson(Map<String, dynamic> json) {
    return ClientActionDefinition(
      action: json['type'] as String? ?? '',
      params: json['params'] != null
          ? Map<String, dynamic>.from(json['params'] as Map)
          : null,
      onSuccess: json['onSuccess'] != null
          ? ActionDefinition.fromJson(
              json['onSuccess'] as Map<String, dynamic>)
          : null,
      onError: json['onError'] != null
          ? ActionDefinition.fromJson(
              json['onError'] as Map<String, dynamic>)
          : null,
      confirmMessage: json['confirmMessage'] as String?,
      requireConfirmation: json['requireConfirmation'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': action,
      if (params != null) 'params': params,
      if (onSuccess != null) 'onSuccess': onSuccess!.toJson(),
      if (onError != null) 'onError': onError!.toJson(),
      if (confirmMessage != null) 'confirmMessage': confirmMessage,
      if (requireConfirmation != null)
        'requireConfirmation': requireConfirmation,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: action,
      parameters: {
        if (params != null) 'params': params!,
        if (onSuccess != null) 'onSuccess': onSuccess!.toJson(),
        if (onError != null) 'onError': onError!.toJson(),
        if (confirmMessage != null) 'confirmMessage': confirmMessage!,
        if (requireConfirmation != null)
          'requireConfirmation': requireConfirmation!,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientActionDefinition &&
          runtimeType == other.runtimeType &&
          action == other.action &&
          _mapsEqual(params, other.params) &&
          onSuccess == other.onSuccess &&
          onError == other.onError &&
          confirmMessage == other.confirmMessage &&
          requireConfirmation == other.requireConfirmation;

  @override
  int get hashCode =>
      action.hashCode ^
      params.hashCode ^
      onSuccess.hashCode ^
      onError.hashCode ^
      confirmMessage.hashCode ^
      requireConfirmation.hashCode;

  @override
  String toString() =>
      'ClientActionDefinition(action: $action, params: $params, '
      'onSuccess: $onSuccess, onError: $onError)';
}

// ---------------------------------------------------------------------------
// ChannelActionDefinition
// ---------------------------------------------------------------------------

/// Action that controls a bidirectional communication channel (v1.1)
///
/// Channel actions reference a channel defined in the page's
/// `channels` configuration map. The [action] field stores 'start',
/// 'stop', 'toggle', 'restart', or 'send', and the JSON type is
/// constructed as 'channel.$action'.
@immutable
class ChannelActionDefinition extends ActionDefinition {
  /// The channel action: 'start', 'stop', 'toggle', 'restart', 'send'
  final String action;

  /// The channel name (key in the page's `channels` map)
  final String channel;

  /// Data to send (for 'send' action)
  final dynamic data;

  const ChannelActionDefinition({
    required this.action,
    required this.channel,
    this.data,
  });

  @override
  String get type => 'channel.$action';

  /// Create a [ChannelActionDefinition] from JSON
  factory ChannelActionDefinition.fromJson(Map<String, dynamic> json) {
    final rawType = json['type'] as String? ?? 'channel.start';
    return ChannelActionDefinition(
      action: rawType.replaceFirst('channel.', ''),
      channel: json['channel'] as String? ?? '',
      data: json['data'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'channel.$action',
      'channel': channel,
      if (data != null) 'data': data,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: 'channel.$action',
      parameters: {
        'channel': channel,
        if (data != null) 'data': data,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelActionDefinition &&
          runtimeType == other.runtimeType &&
          action == other.action &&
          channel == other.channel;

  @override
  int get hashCode => action.hashCode ^ channel.hashCode;

  @override
  String toString() =>
      'ChannelActionDefinition(action: $action, channel: $channel)';
}

// ---------------------------------------------------------------------------
// RetryStrategy
// ---------------------------------------------------------------------------

/// Retry strategy configuration for tool actions
@immutable
class RetryStrategy {
  /// Maximum number of retry attempts
  final int maxAttempts;

  /// Base delay between retries in milliseconds
  final int delay;

  /// Backoff strategy: 'fixed', 'linear', 'exponential'
  final String backoff;

  /// Multiplier for backoff calculation
  final num? multiplier;

  /// Maximum delay cap in milliseconds
  final int? maxDelay;

  /// List of error types/codes that trigger retry
  final List<String>? retryOn;

  const RetryStrategy({
    this.maxAttempts = 3,
    this.delay = 1000,
    this.backoff = 'exponential',
    this.multiplier,
    this.maxDelay,
    this.retryOn,
  });

  factory RetryStrategy.fromJson(Map<String, dynamic> json) {
    return RetryStrategy(
      maxAttempts: json['maxAttempts'] as int? ?? 3,
      delay: json['delay'] as int? ?? 1000,
      backoff: json['backoff'] as String? ?? 'exponential',
      multiplier: json['multiplier'] as num?,
      maxDelay: json['maxDelay'] as int?,
      retryOn: (json['retryOn'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxAttempts': maxAttempts,
      'delay': delay,
      'backoff': backoff,
      if (multiplier != null) 'multiplier': multiplier,
      if (maxDelay != null) 'maxDelay': maxDelay,
      if (retryOn != null) 'retryOn': retryOn,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RetryStrategy &&
          maxAttempts == other.maxAttempts &&
          delay == other.delay &&
          backoff == other.backoff &&
          multiplier == other.multiplier &&
          maxDelay == other.maxDelay;

  @override
  int get hashCode =>
      maxAttempts.hashCode ^
      delay.hashCode ^
      backoff.hashCode ^
      multiplier.hashCode ^
      maxDelay.hashCode;

  @override
  String toString() =>
      'RetryStrategy(maxAttempts: $maxAttempts, delay: $delay, backoff: $backoff)';
}

// ---------------------------------------------------------------------------
// LoadingConfig
// ---------------------------------------------------------------------------

/// Loading state configuration for tool actions
@immutable
class LoadingConfig {
  /// State binding path to set loading status
  final String? binding;

  /// Loading indicator type: 'spinner', 'progress', 'skeleton'
  final String? indicator;

  /// Loading text to display alongside the indicator
  final String? text;

  const LoadingConfig({
    this.binding,
    this.indicator,
    this.text,
  });

  factory LoadingConfig.fromJson(Map<String, dynamic> json) {
    return LoadingConfig(
      binding: json['binding'] as String?,
      indicator: json['indicator'] as String?,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (binding != null) 'binding': binding,
      if (indicator != null) 'indicator': indicator,
      if (text != null) 'text': text,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingConfig &&
          binding == other.binding &&
          indicator == other.indicator &&
          text == other.text;

  @override
  int get hashCode => binding.hashCode ^ indicator.hashCode ^ text.hashCode;

  @override
  String toString() =>
      'LoadingConfig(binding: $binding, indicator: $indicator, text: $text)';
}

// ---------------------------------------------------------------------------
// NotificationAction (for notification action buttons)
// ---------------------------------------------------------------------------

/// Action button for notification definitions
@immutable
class NotificationAction {
  /// The button label text
  final String label;

  /// Action to execute on click
  final ActionDefinition? click;

  const NotificationAction({
    required this.label,
    this.click,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) {
    return NotificationAction(
      label: json['label'] as String? ?? '',
      click: json['click'] != null
          ? ActionDefinition.fromJson(json['click'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      if (click != null) 'click': click!.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationAction &&
          label == other.label &&
          click == other.click;

  @override
  int get hashCode => label.hashCode ^ click.hashCode;
}

// ---------------------------------------------------------------------------
// AnimationActionDefinition
// ---------------------------------------------------------------------------

/// Action that controls animations
@immutable
class AnimationActionDefinition extends ActionDefinition {
  /// The animation action: 'play', 'reverse', 'pause', 'resume', 'reset', 'stop'
  final String action;

  /// Target animation ID
  final String target;

  /// Animation duration in milliseconds
  final int? duration;

  /// Animation curve name
  final String? curve;

  const AnimationActionDefinition({
    required this.action,
    required this.target,
    this.duration,
    this.curve,
  });

  @override
  String get type => 'animation';

  factory AnimationActionDefinition.fromJson(Map<String, dynamic> json) {
    return AnimationActionDefinition(
      action: json['action'] as String? ?? 'play',
      target: json['target'] as String? ?? '',
      duration: json['duration'] as int?,
      curve: json['curve'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'action': action,
      'target': target,
      if (duration != null) 'duration': duration,
      if (curve != null) 'curve': curve,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'action': action,
        'target': target,
        if (duration != null) 'duration': duration!,
        if (curve != null) 'curve': curve!,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationActionDefinition &&
          action == other.action &&
          target == other.target &&
          duration == other.duration &&
          curve == other.curve;

  @override
  int get hashCode =>
      action.hashCode ^ target.hashCode ^ duration.hashCode ^ curve.hashCode;

  @override
  String toString() =>
      'AnimationActionDefinition(action: $action, target: $target)';
}

// ---------------------------------------------------------------------------
// CancelActionDefinition
// ---------------------------------------------------------------------------

/// Action that cancels a running action by target ID
@immutable
class CancelActionDefinition extends ActionDefinition {
  /// The target action ID to cancel
  final String target;

  const CancelActionDefinition({
    required this.target,
  });

  @override
  String get type => 'cancel';

  factory CancelActionDefinition.fromJson(Map<String, dynamic> json) {
    return CancelActionDefinition(
      target: json['target'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'target': target,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'target': target,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CancelActionDefinition && target == other.target;

  @override
  int get hashCode => target.hashCode;

  @override
  String toString() => 'CancelActionDefinition(target: $target)';
}

// ---------------------------------------------------------------------------
// PermissionRevokeActionDefinition
// ---------------------------------------------------------------------------

/// Action that revokes a permission
@immutable
class PermissionRevokeActionDefinition extends ActionDefinition {
  /// The permission types to revoke (e.g., ['file.read', 'http'])
  final List<String> permissions;

  const PermissionRevokeActionDefinition({
    required this.permissions,
  });

  @override
  String get type => 'permission.revoke';

  factory PermissionRevokeActionDefinition.fromJson(Map<String, dynamic> json) {
    // Support both singular 'permission' (old) and plural 'permissions' (design doc)
    final permissions = json['permissions'];
    if (permissions is List) {
      return PermissionRevokeActionDefinition(
        permissions: permissions.cast<String>(),
      );
    }
    final permission = json['permission'] as String?;
    return PermissionRevokeActionDefinition(
      permissions: permission != null ? [permission] : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'permissions': permissions,
    };
  }

  @override
  ActionConfig toConfig() {
    return ActionConfig(
      type: type,
      parameters: {
        'permissions': permissions,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionRevokeActionDefinition &&
          _listStrEquals(permissions, other.permissions);

  @override
  int get hashCode => permissions.hashCode;

  @override
  String toString() =>
      'PermissionRevokeActionDefinition(permissions: $permissions)';

  bool _listStrEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ---------------------------------------------------------------------------
// Shared equality helpers (top-level private functions)
// ---------------------------------------------------------------------------

/// Compare two nullable maps for equality
bool _mapsEqual(Map<String, dynamic>? a, Map<String, dynamic>? b) {
  if (identical(a, b)) return true;
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}

/// Compare two nullable lists of [ActionDefinition] for equality
bool _actionListsEqual(
    List<ActionDefinition>? a, List<ActionDefinition>? b) {
  if (identical(a, b)) return true;
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Compare two nullable lists of [DialogButton] for equality
bool _dialogButtonListsEqual(List<DialogButton>? a, List<DialogButton>? b) {
  if (identical(a, b)) return true;
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Deep equality check for lists of maps
// ignore: unused_element
bool _deepEquals(
    List<Map<String, dynamic>>? a, List<Map<String, dynamic>>? b) {
  if (identical(a, b)) return true;
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (!_mapsEqual(a[i], b[i])) return false;
  }
  return true;
}
