import 'package:meta/meta.dart';

/// Specification for a widget property
/// 
/// Defines the type, requirements, and validation rules for widget properties.
@immutable
class PropertySpec {
  /// The expected type of the property value
  final Type type;
  
  /// Whether this property is required
  final bool required;
  
  /// Default value if not provided
  final dynamic defaultValue;
  
  /// Description of the property
  final String? description;
  
  /// Validation function for the property value
  final bool Function(dynamic value)? validator;
  
  /// Enum values if this is an enum property
  final List<String>? enumValues;
  
  /// Minimum value for numeric properties
  final num? minValue;
  
  /// Maximum value for numeric properties
  final num? maxValue;
  
  /// Pattern for string validation
  final String? pattern;
  
  /// DSL version when this property was added
  final String addedInVersion;
  
  /// DSL version when this property was deprecated
  final String? deprecatedInVersion;
  
  /// Replacement property if deprecated
  final String? replacedBy;

  const PropertySpec({
    required this.type,
    this.required = false,
    this.defaultValue,
    this.description,
    this.validator,
    this.enumValues,
    this.minValue,
    this.maxValue,
    this.pattern,
    this.addedInVersion = '1.0.0',
    this.deprecatedInVersion,
    this.replacedBy,
  });

  /// Validates a value against this property specification
  bool isValid(dynamic value) {
    // Check if required and null
    if (required && value == null) {
      return false;
    }
    
    // If null and not required, it's valid
    if (value == null && !required) {
      return true;
    }
    
    // Check type
    if (!_isCorrectType(value)) {
      return false;
    }
    
    // Check enum values
    if (enumValues != null && !enumValues!.contains(value.toString())) {
      return false;
    }
    
    // Check numeric ranges
    if (value is num) {
      if (minValue != null && value < minValue!) return false;
      if (maxValue != null && value > maxValue!) return false;
    }
    
    // Check string pattern
    if (value is String && pattern != null) {
      final regex = RegExp(pattern!);
      if (!regex.hasMatch(value)) return false;
    }
    
    // Run custom validator
    if (validator != null) {
      return validator!(value);
    }
    
    return true;
  }
  
  /// Get the effective value (considering defaults)
  dynamic getEffectiveValue(dynamic value) {
    return value ?? defaultValue;
  }
  
  /// Check if the property is deprecated
  bool get isDeprecated => deprecatedInVersion != null;
  
  /// Get deprecation message
  String? get deprecationMessage {
    if (!isDeprecated) return null;
    
    String message = 'Property deprecated since version $deprecatedInVersion';
    if (replacedBy != null) {
      message += '. Use $replacedBy instead.';
    }
    return message;
  }

  bool _isCorrectType(dynamic value) {
    switch (type) {
      case String:
        return value is String;
      case int:
        return value is int;
      case double:
        return value is double || value is int; // int can be converted to double
      case num:
        return value is num;
      case bool:
        return value is bool;
      case List:
        return value is List;
      case Map:
        return value is Map;
      default:
        return true; // Allow any type for dynamic
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertySpec &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          required == other.required &&
          defaultValue == other.defaultValue &&
          description == other.description &&
          enumValues == other.enumValues &&
          minValue == other.minValue &&
          maxValue == other.maxValue &&
          pattern == other.pattern &&
          addedInVersion == other.addedInVersion &&
          deprecatedInVersion == other.deprecatedInVersion &&
          replacedBy == other.replacedBy;

  @override
  int get hashCode =>
      type.hashCode ^
      required.hashCode ^
      defaultValue.hashCode ^
      description.hashCode ^
      enumValues.hashCode ^
      minValue.hashCode ^
      maxValue.hashCode ^
      pattern.hashCode ^
      addedInVersion.hashCode ^
      deprecatedInVersion.hashCode ^
      replacedBy.hashCode;

  @override
  String toString() {
    return 'PropertySpec(type: $type, required: $required, defaultValue: $defaultValue)';
  }
}