import 'package:meta/meta.dart';

/// Template definition for MCP UI DSL v1.1 (TM-01)
///
/// Templates are reusable widget definitions with typed parameters,
/// content slots, and validation. They can be instantiated using the
/// `use` widget type.
@immutable
class TemplateDefinition {
  /// Template name (unique identifier)
  final String name;

  /// Template description
  final String? description;

  /// Template parameters with type and validation info
  final Map<String, TemplateParam>? params;

  /// The widget tree that defines the template body
  final Map<String, dynamic> body;

  /// Named content slots that can be filled when using the template
  final List<String>? slots;

  /// Default values for parameters
  final Map<String, dynamic>? defaults;

  /// Instance-scoped local state initial values (v1.3)
  final Map<String, dynamic>? stateDefaults;

  /// Actions executed when template instance is mounted (v1.3)
  final List<Map<String, dynamic>>? onMount;

  /// Actions executed when template instance is unmounted (v1.3)
  final List<Map<String, dynamic>>? onUnmount;

  const TemplateDefinition({
    required this.name,
    this.description,
    this.params,
    required this.body,
    this.slots,
    this.defaults,
    this.stateDefaults,
    this.onMount,
    this.onUnmount,
  });

  factory TemplateDefinition.fromJson(Map<String, dynamic> json) {
    // Parse params
    Map<String, TemplateParam>? params;
    if (json['params'] != null) {
      params = {};
      final paramsJson = json['params'] as Map<String, dynamic>;
      for (final entry in paramsJson.entries) {
        if (entry.value is Map<String, dynamic>) {
          params[entry.key] = TemplateParam.fromJson(
              entry.value as Map<String, dynamic>);
        } else {
          // Short form: just the type string
          params[entry.key] = TemplateParam(type: entry.value.toString());
        }
      }
    }

    return TemplateDefinition(
      name: json['name'] as String,
      description: json['description'] as String?,
      params: params,
      body: json['body'] as Map<String, dynamic>,
      slots: (json['slots'] as List<dynamic>?)?.cast<String>(),
      defaults: json['defaults'] as Map<String, dynamic>?,
      stateDefaults: json['stateDefaults'] as Map<String, dynamic>?,
      onMount: (json['onMount'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      onUnmount: (json['onUnmount'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (params != null)
        'params': params!.map((k, v) => MapEntry(k, v.toJson())),
      'body': body,
      if (slots != null) 'slots': slots,
      if (defaults != null) 'defaults': defaults,
      if (stateDefaults != null) 'stateDefaults': stateDefaults,
      if (onMount != null) 'onMount': onMount,
      if (onUnmount != null) 'onUnmount': onUnmount,
    };
  }

  /// Validate provided arguments against template params
  List<String> validate(Map<String, dynamic> args) {
    final errors = <String>[];

    if (params == null) return errors;

    for (final entry in params!.entries) {
      final param = entry.value;
      final value = args[entry.key] ?? defaults?[entry.key];

      if (param.required && value == null) {
        errors.add('Required parameter "${entry.key}" is missing');
      }

      if (value != null && param.type != null) {
        if (!_typeMatches(value, param.type!)) {
          errors.add(
              'Parameter "${entry.key}" expected ${param.type}, got ${value.runtimeType}');
        }
      }
    }

    return errors;
  }

  bool _typeMatches(dynamic value, String type) {
    switch (type) {
      case 'string':
        return value is String;
      case 'number':
        return value is num;
      case 'boolean':
        return value is bool;
      case 'object':
        return value is Map;
      case 'array':
        return value is List;
      case 'widget':
        return value is Map<String, dynamic> && value.containsKey('type');
      default:
        return true;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TemplateDefinition) return false;
    if (runtimeType != other.runtimeType) return false;
    if (name != other.name) return false;
    if (description != other.description) return false;
    if (body.length != other.body.length) return false;
    for (final key in body.keys) {
      if (!other.body.containsKey(key) || body[key] != other.body[key]) {
        return false;
      }
    }
    final aSlots = slots;
    final bSlots = other.slots;
    if (aSlots == null && bSlots != null) return false;
    if (aSlots != null && bSlots == null) return false;
    if (aSlots != null && bSlots != null) {
      if (aSlots.length != bSlots.length) return false;
      for (int i = 0; i < aSlots.length; i++) {
        if (aSlots[i] != bSlots[i]) return false;
      }
    }
    final aDefaults = defaults;
    final bDefaults = other.defaults;
    if (aDefaults == null && bDefaults != null) return false;
    if (aDefaults != null && bDefaults == null) return false;
    if (aDefaults != null && bDefaults != null) {
      if (aDefaults.length != bDefaults.length) return false;
      for (final key in aDefaults.keys) {
        if (!bDefaults.containsKey(key) || aDefaults[key] != bDefaults[key]) {
          return false;
        }
      }
    }
    if (stateDefaults != other.stateDefaults) return false;
    if (onMount?.length != other.onMount?.length) return false;
    if (onUnmount?.length != other.onUnmount?.length) return false;
    return true;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      body.hashCode ^
      slots.hashCode ^
      defaults.hashCode ^
      stateDefaults.hashCode ^
      onMount.hashCode ^
      onUnmount.hashCode;

  @override
  String toString() => 'TemplateDefinition(name: $name)';
}

/// Template parameter definition
@immutable
class TemplateParam {
  /// Parameter type: 'string', 'number', 'boolean', 'object', 'array', 'widget'
  final String? type;

  /// Whether the parameter is required
  final bool required;

  /// Default value
  final dynamic defaultValue;

  /// Description of the parameter
  final String? description;

  const TemplateParam({
    this.type,
    this.required = false,
    this.defaultValue,
    this.description,
  });

  factory TemplateParam.fromJson(Map<String, dynamic> json) {
    return TemplateParam(
      type: json['type'] as String?,
      required: json['required'] as bool? ?? false,
      defaultValue: json['default'],
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (required) 'required': required,
      if (defaultValue != null) 'default': defaultValue,
      if (description != null) 'description': description,
    };
  }
}
