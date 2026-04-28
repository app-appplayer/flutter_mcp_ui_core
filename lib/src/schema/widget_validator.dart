/// MCP UI DSL widget validator — a thin wrapper around the code-generated
/// JSON Schema (`widgets_schema.g.dart`) produced by
/// `tools/spec_codegen/bin/spec_codegen.dart`.
///
/// Callers feed a raw widget DSL value (the `content` / page tree — anything
/// expected to conform to the `Widget` union in the registry) and receive a
/// [WidgetValidationResult] describing any issues. Runtime packages hook this
/// into their initialisation path so non-conformant DSL is rejected before it
/// reaches rendering.

import 'package:json_schema/json_schema.dart';

import 'widgets_schema.g.dart';

/// Lazily-parsed singleton; parsing the schema is comparatively expensive so
/// we avoid doing it more than once per process.
JsonSchema? _cachedSchema;

JsonSchema _schema() {
  return _cachedSchema ??= JsonSchema.create(mcpUiDslWidgetsSchemaJson);
}

class WidgetValidationError {
  WidgetValidationError({required this.path, required this.message});

  /// JSON-Pointer-like path into the input value, e.g. `#/child/padding`.
  final String path;
  final String message;

  @override
  String toString() => '$path: $message';
}

class WidgetValidationResult {
  WidgetValidationResult(this.errors);

  final List<WidgetValidationError> errors;

  bool get isValid => errors.isEmpty;

  @override
  String toString() {
    if (isValid) return 'WidgetValidationResult(ok)';
    final lines = errors.map((e) => '  - $e').join('\n');
    return 'WidgetValidationResult(${errors.length} error(s)):\n$lines';
  }
}

/// Validates [widget] against the generated widget registry schema.
///
/// Returns a [WidgetValidationResult]; callers decide whether to throw or
/// surface a warning. Passing `null` or a non-map value returns a single
/// error; the schema's root is the `Widget` union so a map is required.
WidgetValidationResult validateMcpUiDslWidget(Object? widget) {
  if (widget == null) {
    return WidgetValidationResult([
      WidgetValidationError(path: '#', message: 'Widget value is null'),
    ]);
  }
  if (widget is! Map<String, dynamic>) {
    return WidgetValidationResult([
      WidgetValidationError(
        path: '#',
        message: 'Widget must be a JSON object (got ${widget.runtimeType})',
      ),
    ]);
  }
  final schema = _schema();
  final result = schema.validate(widget);
  if (result.isValid) return WidgetValidationResult(const []);
  return WidgetValidationResult([
    for (final e in result.errors)
      WidgetValidationError(
        path: e.instancePath.isEmpty ? '#' : '#${e.instancePath}',
        message: e.message,
      ),
  ]);
}
