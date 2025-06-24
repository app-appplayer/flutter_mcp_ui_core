/// Represents a parameter specification for widgets and actions
class ParameterSpec {
  final String name;
  final Type type;
  final bool required;
  final dynamic defaultValue;
  final List<String>? allowedValues;
  final String? description;

  const ParameterSpec({
    required this.name,
    required this.type,
    this.required = false,
    this.defaultValue,
    this.allowedValues,
    this.description,
  });
}