import 'package:meta/meta.dart';

/// Configuration for data binding in the MCP UI DSL
/// 
/// Represents data binding expressions and their evaluation context.
@immutable
class BindingConfig {
  /// The binding expression (e.g., '{{user.name}}', '{{items.length}}')
  final String expression;
  
  /// The path to bind to in the state
  final String path;
  
  /// Type of binding ('value', 'text', 'visible', 'enabled', etc.)
  final String type;
  
  /// Default value if binding resolves to null
  final dynamic defaultValue;
  
  /// Whether this is a two-way binding
  final bool twoWay;
  
  /// Formatter function name for the bound value
  final String? formatter;
  
  /// Validator function name for two-way bindings
  final String? validator;

  const BindingConfig({
    required this.expression,
    required this.path,
    this.type = 'value',
    this.defaultValue,
    this.twoWay = false,
    this.formatter,
    this.validator,
  });

  /// Create a BindingConfig from a binding expression
  factory BindingConfig.fromExpression(String expression) {
    // Extract path from expression like '{{user.name}}'
    final path = expression.replaceAll(RegExp(r'[{}]'), '').trim();
    
    return BindingConfig(
      expression: expression,
      path: path,
    );
  }

  /// Create a BindingConfig from JSON
  factory BindingConfig.fromJson(Map<String, dynamic> json) {
    return BindingConfig(
      expression: json['expression'] as String,
      path: json['path'] as String,
      type: json['type'] as String? ?? 'value',
      defaultValue: json['defaultValue'],
      twoWay: json['twoWay'] as bool? ?? false,
      formatter: json['formatter'] as String?,
      validator: json['validator'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'path': path,
      'type': type,
      if (defaultValue != null) 'defaultValue': defaultValue,
      'twoWay': twoWay,
      if (formatter != null) 'formatter': formatter,
      if (validator != null) 'validator': validator,
    };
  }

  /// Check if this is a valid binding expression
  bool get isValidExpression {
    return expression.startsWith('{{') && 
           expression.endsWith('}}') && 
           path.isNotEmpty;
  }

  /// Get the root object from the path
  String get rootObject {
    final parts = path.split('.');
    return parts.isNotEmpty ? parts.first : '';
  }

  /// Get all path segments
  List<String> get pathSegments {
    return path.split('.');
  }

  /// Check if this is a simple property binding (e.g., '{{name}}')
  bool get isSimpleProperty {
    return !path.contains('.');
  }

  /// Check if this is a nested property binding (e.g., '{{user.profile.name}}')
  bool get isNestedProperty {
    return path.contains('.');
  }

  /// Check if this is an array access binding (e.g., '{{items[0].name}}')
  bool get isArrayAccess {
    return path.contains('[') && path.contains(']');
  }

  /// Extract array index from path (if applicable)
  int? get arrayIndex {
    if (!isArrayAccess) return null;
    
    final match = RegExp(r'\[(\d+)\]').firstMatch(path);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  /// Get the property name without array access
  String get propertyName {
    return path.replaceAll(RegExp(r'\[\d+\]'), '');
  }

  /// Create a copy with modified properties
  BindingConfig copyWith({
    String? expression,
    String? path,
    String? type,
    dynamic defaultValue,
    bool? twoWay,
    String? formatter,
    String? validator,
  }) {
    return BindingConfig(
      expression: expression ?? this.expression,
      path: path ?? this.path,
      type: type ?? this.type,
      defaultValue: defaultValue ?? this.defaultValue,
      twoWay: twoWay ?? this.twoWay,
      formatter: formatter ?? this.formatter,
      validator: validator ?? this.validator,
    );
  }

  /// Create a two-way binding version
  BindingConfig asTwoWay({String? validator}) {
    return copyWith(
      twoWay: true,
      validator: validator ?? this.validator,
    );
  }

  /// Create a formatted binding
  BindingConfig withFormatter(String formatter) {
    return copyWith(formatter: formatter);
  }

  /// Create a validated binding
  BindingConfig withValidator(String validator) {
    return copyWith(validator: validator);
  }

  /// Validate the binding configuration
  bool isValid() {
    return isValidExpression && path.isNotEmpty;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BindingConfig &&
          runtimeType == other.runtimeType &&
          expression == other.expression &&
          path == other.path &&
          type == other.type &&
          defaultValue == other.defaultValue &&
          twoWay == other.twoWay &&
          formatter == other.formatter &&
          validator == other.validator;

  @override
  int get hashCode =>
      expression.hashCode ^
      path.hashCode ^
      type.hashCode ^
      defaultValue.hashCode ^
      twoWay.hashCode ^
      formatter.hashCode ^
      validator.hashCode;

  @override
  String toString() {
    return 'BindingConfig(expression: $expression, path: $path, type: $type, twoWay: $twoWay)';
  }
}

/// Utility class for working with binding expressions
class BindingUtils {
  /// Extract all binding expressions from a value
  static List<String> extractBindings(dynamic value) {
    final bindings = <String>[];
    
    void extract(dynamic val) {
      if (val is String && val.startsWith('{{') && val.endsWith('}}')) {
        bindings.add(val);
      } else if (val is Map) {
        val.values.forEach(extract);
      } else if (val is List) {
        val.forEach(extract);
      }
    }
    
    extract(value);
    return bindings;
  }

  /// Check if a value contains any binding expressions
  static bool hasBindings(dynamic value) {
    return extractBindings(value).isNotEmpty;
  }

  /// Create BindingConfig objects from extracted expressions
  static List<BindingConfig> createBindings(List<String> expressions) {
    return expressions.map((expr) => BindingConfig.fromExpression(expr)).toList();
  }

  /// Validate a binding expression format
  static bool isValidBindingExpression(String expression) {
    if (!expression.startsWith('{{') || !expression.endsWith('}}')) {
      return false;
    }
    
    final path = expression.replaceAll(RegExp(r'[{}]'), '').trim();
    return path.isNotEmpty && RegExp(r'^[a-zA-Z_][a-zA-Z0-9_.[\]]*$').hasMatch(path);
  }

  /// Extract the path from a binding expression
  static String extractPath(String expression) {
    return expression.replaceAll(RegExp(r'[{}]'), '').trim();
  }
}