import 'ui_exception.dart';

/// Exception thrown during validation of UI definitions, widgets, or properties
class ValidationException extends UIException {
  /// List of validation errors
  final List<ValidationError> errors;
  
  /// The object that failed validation
  final dynamic validatedObject;

  const ValidationException(
    super.message,
    this.errors, {
    super.code,
    super.details,
    super.stackTrace,
    this.validatedObject,
  });

  /// Create a ValidationException from a single error
  factory ValidationException.single(ValidationError error, [dynamic object]) {
    return ValidationException(
      error.message,
      [error],
      code: 'VALIDATION_FAILED',
      validatedObject: object,
    );
  }

  /// Create a ValidationException from multiple errors
  factory ValidationException.multiple(List<ValidationError> errors, [dynamic object]) {
    final message = errors.length == 1
        ? errors.first.message
        : '${errors.length} validation errors occurred';
    
    return ValidationException(
      message,
      errors,
      code: 'VALIDATION_FAILED',
      validatedObject: object,
    );
  }

  /// Check if validation has any errors
  bool get hasErrors => errors.isNotEmpty;

  /// Get all error messages
  List<String> get errorMessages => errors.map((e) => e.message).toList();

  /// Get errors by severity
  List<ValidationError> getErrorsBySeverity(ValidationSeverity severity) {
    return errors.where((e) => e.severity == severity).toList();
  }

  /// Get only critical errors
  List<ValidationError> get criticalErrors => getErrorsBySeverity(ValidationSeverity.error);

  /// Get only warnings
  List<ValidationError> get warnings => getErrorsBySeverity(ValidationSeverity.warning);

  /// Get only info messages
  List<ValidationError> get infos => getErrorsBySeverity(ValidationSeverity.info);

  @override
  String toString() {
    final buffer = StringBuffer('ValidationException: $message');
    
    if (errors.isNotEmpty) {
      buffer.write('\nValidation Errors:');
      for (int i = 0; i < errors.length; i++) {
        buffer.write('\n  ${i + 1}. ${errors[i]}');
      }
    }
    
    if (code != null) {
      buffer.write('\nCode: $code');
    }
    
    return buffer.toString();
  }
}

/// Individual validation error
class ValidationError {
  /// Error message
  final String message;
  
  /// Error severity
  final ValidationSeverity severity;
  
  /// Error code for programmatic handling
  final String? code;
  
  /// Path to the problematic field/property
  final String? path;
  
  /// The actual value that failed validation
  final dynamic actualValue;
  
  /// The expected value or constraint
  final dynamic expectedValue;
  
  /// Additional context
  final Map<String, dynamic>? context;

  const ValidationError({
    required this.message,
    this.severity = ValidationSeverity.error,
    this.code,
    this.path,
    this.actualValue,
    this.expectedValue,
    this.context,
  });

  /// Create a required field error
  factory ValidationError.requiredField(String field) {
    return ValidationError(
      message: 'Required field is missing: $field',
      code: 'REQUIRED_FIELD_MISSING',
      path: field,
      severity: ValidationSeverity.error,
    );
  }

  /// Create a type mismatch error
  factory ValidationError.typeMismatch(
    String field,
    Type expected,
    Type actual,
  ) {
    return ValidationError(
      message: 'Type mismatch for field "$field": expected $expected, got $actual',
      code: 'TYPE_MISMATCH',
      path: field,
      expectedValue: expected,
      actualValue: actual,
      severity: ValidationSeverity.error,
    );
  }

  /// Create an invalid value error
  factory ValidationError.invalidValue(
    String field,
    dynamic value, [
    String? reason,
  ]) {
    final msg = reason != null
        ? 'Invalid value for field "$field": $value ($reason)'
        : 'Invalid value for field "$field": $value';
    
    return ValidationError(
      message: msg,
      code: 'INVALID_VALUE',
      path: field,
      actualValue: value,
      severity: ValidationSeverity.error,
    );
  }

  /// Create a range error
  factory ValidationError.outOfRange(
    String field,
    dynamic value,
    dynamic min,
    dynamic max,
  ) {
    return ValidationError(
      message: 'Value for field "$field" is out of range: $value (expected: $min - $max)',
      code: 'OUT_OF_RANGE',
      path: field,
      actualValue: value,
      expectedValue: {'min': min, 'max': max},
      severity: ValidationSeverity.error,
    );
  }

  /// Create an enum value error
  factory ValidationError.invalidEnum(
    String field,
    dynamic value,
    List<dynamic> allowedValues,
  ) {
    return ValidationError(
      message: 'Invalid enum value for field "$field": $value (allowed: ${allowedValues.join(', ')})',
      code: 'INVALID_ENUM_VALUE',
      path: field,
      actualValue: value,
      expectedValue: allowedValues,
      severity: ValidationSeverity.error,
    );
  }

  /// Create a pattern mismatch error
  factory ValidationError.patternMismatch(
    String field,
    String value,
    String pattern,
  ) {
    return ValidationError(
      message: 'Value for field "$field" does not match pattern: $value (pattern: $pattern)',
      code: 'PATTERN_MISMATCH',
      path: field,
      actualValue: value,
      expectedValue: pattern,
      severity: ValidationSeverity.error,
    );
  }

  /// Create a deprecated usage warning
  factory ValidationError.deprecatedUsage(
    String field,
    String deprecatedSince, [
    String? replacement,
  ]) {
    final msg = replacement != null
        ? 'Field "$field" is deprecated since $deprecatedSince. Use $replacement instead.'
        : 'Field "$field" is deprecated since $deprecatedSince.';
    
    return ValidationError(
      message: msg,
      code: 'DEPRECATED_USAGE',
      path: field,
      severity: ValidationSeverity.warning,
      context: {
        'deprecatedSince': deprecatedSince,
        if (replacement != null) 'replacement': replacement,
      },
    );
  }

  /// Create an info message
  factory ValidationError.info(String message, [String? field]) {
    return ValidationError(
      message: message,
      code: 'INFO',
      path: field,
      severity: ValidationSeverity.info,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    
    // Add severity prefix
    switch (severity) {
      case ValidationSeverity.error:
        buffer.write('ERROR: ');
        break;
      case ValidationSeverity.warning:
        buffer.write('WARNING: ');
        break;
      case ValidationSeverity.info:
        buffer.write('INFO: ');
        break;
    }
    
    buffer.write(message);
    
    if (path != null) {
      buffer.write(' (at $path)');
    }
    
    if (code != null) {
      buffer.write(' [$code]');
    }
    
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          severity == other.severity &&
          code == other.code &&
          path == other.path &&
          actualValue == other.actualValue &&
          expectedValue == other.expectedValue;

  @override
  int get hashCode =>
      message.hashCode ^
      severity.hashCode ^
      code.hashCode ^
      path.hashCode ^
      actualValue.hashCode ^
      expectedValue.hashCode;
}

/// Severity levels for validation errors
enum ValidationSeverity {
  /// Critical error that prevents operation
  error,
  
  /// Warning that should be addressed but doesn't prevent operation
  warning,
  
  /// Informational message
  info,
}

/// Result of a validation operation
class ValidationResult {
  /// List of validation errors/warnings/info
  final List<ValidationError> errors;
  
  /// Whether validation passed (no critical errors)
  final bool isValid;

  const ValidationResult._(this.errors, this.isValid);

  /// Create a successful validation result
  factory ValidationResult.success([List<ValidationError>? warnings]) {
    return ValidationResult._(warnings ?? [], true);
  }

  /// Create a failed validation result
  factory ValidationResult.failure(List<ValidationError> errors) {
    return ValidationResult._(errors, false);
  }

  /// Create a validation result from errors
  factory ValidationResult.fromErrors(List<ValidationError> errors) {
    final hasErrors = errors.any((e) => e.severity == ValidationSeverity.error);
    return ValidationResult._(errors, !hasErrors);
  }

  /// Check if there are any errors
  bool get hasErrors => errors.any((e) => e.severity == ValidationSeverity.error);

  /// Check if there are any warnings
  bool get hasWarnings => errors.any((e) => e.severity == ValidationSeverity.warning);

  /// Get all error messages
  List<String> get errorMessages => errors.map((e) => e.message).toList();

  /// Get errors by severity
  List<ValidationError> getErrorsBySeverity(ValidationSeverity severity) {
    return errors.where((e) => e.severity == severity).toList();
  }

  /// Get only critical errors
  List<ValidationError> get criticalErrors => getErrorsBySeverity(ValidationSeverity.error);

  /// Get only warnings
  List<ValidationError> get warnings => getErrorsBySeverity(ValidationSeverity.warning);

  /// Get only info messages
  List<ValidationError> get infos => getErrorsBySeverity(ValidationSeverity.info);

  /// Throw ValidationException if validation failed
  void throwIfInvalid([dynamic validatedObject]) {
    if (!isValid) {
      throw ValidationException.multiple(criticalErrors, validatedObject);
    }
  }

  /// Combine with another validation result
  ValidationResult combine(ValidationResult other) {
    final combinedErrors = [...errors, ...other.errors];
    return ValidationResult.fromErrors(combinedErrors);
  }

  @override
  String toString() {
    if (isValid) {
      return hasWarnings 
          ? 'ValidationResult: VALID (${warnings.length} warnings)'
          : 'ValidationResult: VALID';
    } else {
      return 'ValidationResult: INVALID (${criticalErrors.length} errors)';
    }
  }
}