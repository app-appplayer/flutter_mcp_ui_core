import 'package:meta/meta.dart';

import 'template_definition.dart';

/// Remote template library reference per spec § 9.11.1.
///
/// Spec entry schema: `{ uri, version?, integrity? }`. The class also
/// preserves `name` and `templates` (used by the loaded library
/// document body, § 9.11.3) for round-trip with older bundle data.
@immutable
class TemplateLibrary {
  /// Library location (spec § 9.11.1 — `uri`). Older bundles emit
  /// `url`; both keys are accepted on parse and stored here.
  final String uri;
  final String? name;
  final String? version;
  /// Subresource integrity hash (e.g. `sha256-…`) per spec § 9.11.1.
  final String? integrity;
  final List<TemplateDefinition>? templates;

  /// Legacy alias of [uri] retained for backward compatibility.
  String get url => uri;

  const TemplateLibrary({
    required this.uri,
    this.name,
    this.version,
    this.integrity,
    this.templates,
  });

  factory TemplateLibrary.fromJson(Map<String, dynamic> json) {
    return TemplateLibrary(
      uri: (json['uri'] ?? json['url']) as String,
      name: json['name'] as String?,
      version: json['version'] as String?,
      integrity: json['integrity'] as String?,
      templates: (json['templates'] as List<dynamic>?)
          ?.map((e) => TemplateDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (integrity != null) 'integrity': integrity,
      if (templates != null)
        'templates': templates!.map((t) => t.toJson()).toList(),
    };
  }

  TemplateLibrary copyWith({
    String? uri,
    String? name,
    String? version,
    String? integrity,
    List<TemplateDefinition>? templates,
  }) {
    return TemplateLibrary(
      uri: uri ?? this.uri,
      name: name ?? this.name,
      version: version ?? this.version,
      integrity: integrity ?? this.integrity,
      templates: templates ?? this.templates,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TemplateLibrary) return false;
    return uri == other.uri &&
        name == other.name &&
        version == other.version &&
        integrity == other.integrity;
  }

  @override
  int get hashCode =>
      uri.hashCode ^ name.hashCode ^ version.hashCode ^ integrity.hashCode;

  @override
  String toString() => 'TemplateLibrary(uri: $uri, name: $name)';
}
