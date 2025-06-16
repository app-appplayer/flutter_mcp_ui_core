/// Base exception class for MCP UI DSL errors
class UIException implements Exception {
  /// Error message
  final String message;
  
  /// Error code for programmatic handling
  final String? code;
  
  /// Additional context or details
  final Map<String, dynamic>? details;
  
  /// Stack trace where the error occurred
  final StackTrace? stackTrace;

  const UIException(
    this.message, {
    this.code,
    this.details,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('UIException: $message');
    if (code != null) {
      buffer.write(' (Code: $code)');
    }
    if (details != null && details!.isNotEmpty) {
      buffer.write('\nDetails: $details');
    }
    return buffer.toString();
  }
}

/// Exception thrown when widget configuration is invalid
class InvalidWidgetException extends UIException {
  /// The invalid widget type
  final String? widgetType;
  
  /// The invalid property key
  final String? propertyKey;
  
  /// The invalid property value
  final dynamic propertyValue;

  const InvalidWidgetException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.widgetType,
    this.propertyKey,
    this.propertyValue,
  });

  @override
  String toString() {
    final buffer = StringBuffer('InvalidWidgetException: $message');
    if (widgetType != null) {
      buffer.write('\nWidget Type: $widgetType');
    }
    if (propertyKey != null) {
      buffer.write('\nProperty: $propertyKey');
    }
    if (propertyValue != null) {
      buffer.write('\nValue: $propertyValue');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Exception thrown when binding expressions are invalid
class InvalidBindingException extends UIException {
  /// The invalid binding expression
  final String? expression;
  
  /// The invalid path
  final String? path;

  const InvalidBindingException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.expression,
    this.path,
  });

  @override
  String toString() {
    final buffer = StringBuffer('InvalidBindingException: $message');
    if (expression != null) {
      buffer.write('\nExpression: $expression');
    }
    if (path != null) {
      buffer.write('\nPath: $path');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Exception thrown when action configuration is invalid
class InvalidActionException extends UIException {
  /// The invalid action type
  final String? actionType;
  
  /// The action configuration
  final Map<String, dynamic>? actionConfig;

  const InvalidActionException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.actionType,
    this.actionConfig,
  });

  @override
  String toString() {
    final buffer = StringBuffer('InvalidActionException: $message');
    if (actionType != null) {
      buffer.write('\nAction Type: $actionType');
    }
    if (actionConfig != null) {
      buffer.write('\nAction Config: $actionConfig');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Exception thrown when JSON structure is invalid
class InvalidJsonException extends UIException {
  /// The invalid JSON path
  final String? jsonPath;
  
  /// The expected structure
  final String? expectedStructure;

  const InvalidJsonException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.jsonPath,
    this.expectedStructure,
  });

  @override
  String toString() {
    final buffer = StringBuffer('InvalidJsonException: $message');
    if (jsonPath != null) {
      buffer.write('\nJSON Path: $jsonPath');
    }
    if (expectedStructure != null) {
      buffer.write('\nExpected: $expectedStructure');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Exception thrown when theme configuration is invalid
class InvalidThemeException extends UIException {
  /// The invalid theme property
  final String? themeProperty;
  
  /// The theme name
  final String? themeName;

  const InvalidThemeException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.themeProperty,
    this.themeName,
  });

  @override
  String toString() {
    final buffer = StringBuffer('InvalidThemeException: $message');
    if (themeName != null) {
      buffer.write('\nTheme: $themeName');
    }
    if (themeProperty != null) {
      buffer.write('\nProperty: $themeProperty');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Exception thrown when DSL version is incompatible
class IncompatibleVersionException extends UIException {
  /// The requested DSL version
  final String? requestedVersion;
  
  /// The supported DSL versions
  final List<String>? supportedVersions;

  const IncompatibleVersionException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.requestedVersion,
    this.supportedVersions,
  });

  @override
  String toString() {
    final buffer = StringBuffer('IncompatibleVersionException: $message');
    if (requestedVersion != null) {
      buffer.write('\nRequested Version: $requestedVersion');
    }
    if (supportedVersions != null) {
      buffer.write('\nSupported Versions: ${supportedVersions!.join(', ')}');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Exception thrown when rendering fails
class RenderException extends UIException {
  /// The widget type that failed to render
  final String? widgetType;
  
  /// The render context
  final Map<String, dynamic>? context;

  const RenderException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.widgetType,
    this.context,
  });

  @override
  String toString() {
    final buffer = StringBuffer('RenderException: $message');
    if (widgetType != null) {
      buffer.write('\nWidget Type: $widgetType');
    }
    if (context != null) {
      buffer.write('\nContext: $context');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Exception thrown when state management operations fail
class StateException extends UIException {
  /// The state path that caused the error
  final String? statePath;
  
  /// The state operation that failed
  final String? operation;

  const StateException(
    super.message, {
    super.code,
    super.details,
    super.stackTrace,
    this.statePath,
    this.operation,
  });

  @override
  String toString() {
    final buffer = StringBuffer('StateException: $message');
    if (operation != null) {
      buffer.write('\nOperation: $operation');
    }
    if (statePath != null) {
      buffer.write('\nState Path: $statePath');
    }
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    return buffer.toString();
  }
}

/// Utility class for creating common UI exceptions
class UIExceptions {
  /// Create an invalid widget type exception
  static InvalidWidgetException invalidWidgetType(String type) {
    return InvalidWidgetException(
      'Unknown widget type: $type',
      code: 'INVALID_WIDGET_TYPE',
      widgetType: type,
    );
  }

  /// Create an invalid property exception
  static InvalidWidgetException invalidProperty(
    String widgetType,
    String property,
    dynamic value,
  ) {
    return InvalidWidgetException(
      'Invalid property "$property" for widget "$widgetType": $value',
      code: 'INVALID_PROPERTY',
      widgetType: widgetType,
      propertyKey: property,
      propertyValue: value,
    );
  }

  /// Create a required property missing exception
  static InvalidWidgetException requiredPropertyMissing(
    String widgetType,
    String property,
  ) {
    return InvalidWidgetException(
      'Required property "$property" missing for widget "$widgetType"',
      code: 'REQUIRED_PROPERTY_MISSING',
      widgetType: widgetType,
      propertyKey: property,
    );
  }

  /// Create an invalid binding expression exception
  static InvalidBindingException invalidBinding(String expression) {
    return InvalidBindingException(
      'Invalid binding expression: $expression',
      code: 'INVALID_BINDING',
      expression: expression,
    );
  }

  /// Create an invalid action configuration exception
  static InvalidActionException invalidAction(
    String actionType,
    Map<String, dynamic> config,
  ) {
    return InvalidActionException(
      'Invalid action configuration for type: $actionType',
      code: 'INVALID_ACTION',
      actionType: actionType,
      actionConfig: config,
    );
  }

  /// Create an incompatible version exception
  static IncompatibleVersionException incompatibleVersion(
    String requested,
    List<String> supported,
  ) {
    return IncompatibleVersionException(
      'DSL version $requested is not supported. Supported versions: ${supported.join(', ')}',
      code: 'INCOMPATIBLE_VERSION',
      requestedVersion: requested,
      supportedVersions: supported,
    );
  }

  /// Create a JSON structure validation exception
  static InvalidJsonException invalidJsonStructure(
    String path,
    String expected,
  ) {
    return InvalidJsonException(
      'Invalid JSON structure at path: $path',
      code: 'INVALID_JSON_STRUCTURE',
      jsonPath: path,
      expectedStructure: expected,
    );
  }

  /// Create a render failure exception
  static RenderException renderFailure(
    String widgetType,
    String reason, [
    Map<String, dynamic>? context,
  ]) {
    return RenderException(
      'Failed to render widget "$widgetType": $reason',
      code: 'RENDER_FAILURE',
      widgetType: widgetType,
      context: context,
    );
  }

  /// Create a state operation failure exception
  static StateException stateOperationFailure(
    String operation,
    String path,
    String reason,
  ) {
    return StateException(
      'State operation "$operation" failed at path "$path": $reason',
      code: 'STATE_OPERATION_FAILURE',
      operation: operation,
      statePath: path,
    );
  }
}