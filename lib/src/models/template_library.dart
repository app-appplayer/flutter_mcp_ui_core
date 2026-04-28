import 'package:meta/meta.dart';

import 'template_definition.dart';

/// Remote template library reference (v1.3)
@immutable
class TemplateLibrary {
  final String url;
  final String? name;
  final String? version;
  final List<TemplateDefinition>? templates;

  const TemplateLibrary({
    required this.url,
    this.name,
    this.version,
    this.templates,
  });

  factory TemplateLibrary.fromJson(Map<String, dynamic> json) {
    return TemplateLibrary(
      url: json['url'] as String,
      name: json['name'] as String?,
      version: json['version'] as String?,
      templates: (json['templates'] as List<dynamic>?)
          ?.map((e) => TemplateDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (templates != null)
        'templates': templates!.map((t) => t.toJson()).toList(),
    };
  }

  TemplateLibrary copyWith({
    String? url,
    String? name,
    String? version,
    List<TemplateDefinition>? templates,
  }) {
    return TemplateLibrary(
      url: url ?? this.url,
      name: name ?? this.name,
      version: version ?? this.version,
      templates: templates ?? this.templates,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TemplateLibrary) return false;
    return url == other.url &&
        name == other.name &&
        version == other.version;
  }

  @override
  int get hashCode => url.hashCode ^ name.hashCode ^ version.hashCode;

  @override
  String toString() => 'TemplateLibrary(url: $url, name: $name)';
}
