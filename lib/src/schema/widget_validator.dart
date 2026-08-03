/// MCP UI DSL widget validator — a thin wrapper around the code-generated
/// JSON Schema (`widgets_schema.g.dart`) produced by
/// `tools/spec_codegen/bin/spec_codegen.dart`.
///
/// Callers feed a raw widget DSL value (the `content` / page tree — anything
/// expected to conform to the `Widget` union in the registry) and receive a
/// [WidgetValidationResult] describing any issues. Runtime packages hook this
/// into their initialisation path so non-conformant DSL is rejected before it
/// reaches rendering.

import 'dart:convert';

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

/// Every `type` value the spec's widget registry accepts, aliases included.
///
/// A host that registers extension widgets needs to tell its own additions
/// apart from the spec's set — `registerWidget` invites extensions, and a
/// validator that cannot distinguish them ends up calling a host's own widget
/// a malformed document.
Set<String> get mcpUiDslWidgetTypes => _widgetTypes ??= _collectWidgetTypes();
Set<String>? _widgetTypes;

/// Whether [type] is a widget type this spec defines.
bool isMcpUiDslWidgetType(String type) => mcpUiDslWidgetTypes.contains(type);

Set<String> _collectWidgetTypes() {
  final decoded =
      jsonDecode(mcpUiDslWidgetsSchemaJson) as Map<String, dynamic>;
  final defs = decoded[r'$defs'] as Map<String, dynamic>? ?? const {};
  final out = <String>{};
  for (final entry in defs.entries) {
    final def = entry.value;
    if (def is! Map<String, dynamic>) continue;
    final props = def['properties'];
    if (props is! Map<String, dynamic>) continue;
    final typeProp = props['type'];
    if (typeProp is! Map<String, dynamic>) continue;
    final values = typeProp['enum'];
    if (values is! List) continue;
    // `$defs` also holds primitives whose `type` property is an enum
    // (`Gradient`, `Action`); a widget's enum always contains its own name.
    if (!values.contains(entry.key)) continue;
    for (final v in values) {
      if (v is String) out.add(v);
    }
  }
  return out;
}
