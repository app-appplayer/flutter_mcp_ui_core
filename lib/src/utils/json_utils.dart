import 'dart:convert';

/// Utility functions for JSON handling in MCP UI DSL
class JsonUtils {
  /// Pretty print JSON with custom indentation
  static String prettyPrint(Map<String, dynamic> json, {String indent = '  '}) {
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(json);
  }

  /// Minify JSON (remove all whitespace)
  static String minify(Map<String, dynamic> json) {
    return jsonEncode(json);
  }

  /// Deep copy a JSON object
  static Map<String, dynamic> deepCopy(Map<String, dynamic> original) {
    return jsonDecode(jsonEncode(original)) as Map<String, dynamic>;
  }

  /// Deep copy a list of JSON objects
  static List<Map<String, dynamic>> deepCopyList(List<Map<String, dynamic>> original) {
    return original.map((item) => deepCopy(item)).toList();
  }

  /// Merge two JSON objects (second overwrites first)
  static Map<String, dynamic> merge(
    Map<String, dynamic> base,
    Map<String, dynamic> override,
  ) {
    final result = deepCopy(base);
    _mergeRecursive(result, override);
    return result;
  }

  /// Recursively merge JSON objects
  static void _mergeRecursive(
    Map<String, dynamic> base,
    Map<String, dynamic> override,
  ) {
    for (final entry in override.entries) {
      if (base[entry.key] is Map<String, dynamic> &&
          entry.value is Map<String, dynamic>) {
        _mergeRecursive(
          base[entry.key] as Map<String, dynamic>,
          entry.value as Map<String, dynamic>,
        );
      } else {
        base[entry.key] = entry.value;
      }
    }
  }

  /// Extract value at a dot-notation path
  static dynamic getValueAtPath(Map<String, dynamic> json, String path) {
    final parts = path.split('.');
    dynamic current = json;

    for (final part in parts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else if (current is List && _isValidIndex(part, current)) {
        final index = int.parse(part);
        current = current[index];
      } else {
        return null;
      }
    }

    return current;
  }

  /// Set value at a dot-notation path
  static void setValueAtPath(
    Map<String, dynamic> json,
    String path,
    dynamic value,
  ) {
    final parts = path.split('.');
    dynamic current = json;

    for (int i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      
      if (current is Map<String, dynamic>) {
        if (!current.containsKey(part)) {
          // Create intermediate object or array based on next part
          final nextPart = parts[i + 1];
          current[part] = _isNumeric(nextPart) ? [] : <String, dynamic>{};
        }
        current = current[part];
      } else if (current is List && _isValidIndex(part, current)) {
        final index = int.parse(part);
        current = current[index];
      } else {
        throw ArgumentError('Invalid path: $path');
      }
    }

    final lastPart = parts.last;
    if (current is Map<String, dynamic>) {
      current[lastPart] = value;
    } else if (current is List && _isValidIndex(lastPart, current)) {
      final index = int.parse(lastPart);
      current[index] = value;
    } else {
      throw ArgumentError('Cannot set value at path: $path');
    }
  }

  /// Check if value exists at path
  static bool hasValueAtPath(Map<String, dynamic> json, String path) {
    return getValueAtPath(json, path) != null;
  }

  /// Remove value at path
  static void removeValueAtPath(Map<String, dynamic> json, String path) {
    final parts = path.split('.');
    dynamic current = json;

    for (int i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else if (current is List && _isValidIndex(part, current)) {
        final index = int.parse(part);
        current = current[index];
      } else {
        return; // Path doesn't exist
      }
    }

    final lastPart = parts.last;
    if (current is Map<String, dynamic>) {
      current.remove(lastPart);
    } else if (current is List && _isValidIndex(lastPart, current)) {
      final index = int.parse(lastPart);
      current.removeAt(index);
    }
  }

  /// Get all paths in a JSON object
  static List<String> getAllPaths(Map<String, dynamic> json) {
    final paths = <String>[];
    _collectPaths(json, '', paths);
    return paths;
  }

  /// Recursively collect all paths
  static void _collectPaths(
    dynamic value,
    String currentPath,
    List<String> paths,
  ) {
    if (value is Map<String, dynamic>) {
      for (final entry in value.entries) {
        final newPath = currentPath.isEmpty ? entry.key : '$currentPath.${entry.key}';
        paths.add(newPath);
        _collectPaths(entry.value, newPath, paths);
      }
    } else if (value is List) {
      for (int i = 0; i < value.length; i++) {
        final newPath = '$currentPath[$i]';
        paths.add(newPath);
        _collectPaths(value[i], newPath, paths);
      }
    }
  }

  /// Flatten nested JSON to dot notation
  static Map<String, dynamic> flatten(Map<String, dynamic> json) {
    final result = <String, dynamic>{};
    _flattenRecursive(json, '', result);
    return result;
  }

  /// Recursively flatten JSON
  static void _flattenRecursive(
    dynamic value,
    String prefix,
    Map<String, dynamic> result,
  ) {
    if (value is Map<String, dynamic>) {
      for (final entry in value.entries) {
        final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
        _flattenRecursive(entry.value, key, result);
      }
    } else if (value is List) {
      for (int i = 0; i < value.length; i++) {
        final key = '$prefix[$i]';
        _flattenRecursive(value[i], key, result);
      }
    } else {
      result[prefix] = value;
    }
  }

  /// Unflatten dot notation to nested JSON
  static Map<String, dynamic> unflatten(Map<String, dynamic> flatJson) {
    final result = <String, dynamic>{};
    
    for (final entry in flatJson.entries) {
      setValueAtPath(result, entry.key, entry.value);
    }
    
    return result;
  }

  /// Validate JSON against a simple schema
  static bool validateSchema(
    Map<String, dynamic> json,
    Map<String, dynamic> schema,
  ) {
    try {
      _validateRecursive(json, schema);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Recursively validate JSON schema
  static void _validateRecursive(
    dynamic value,
    dynamic schema,
  ) {
    if (schema is Map<String, dynamic>) {
      if (schema.containsKey('type')) {
        final expectedType = schema['type'] as String;
        if (!_isCorrectType(value, expectedType)) {
          throw ArgumentError('Type mismatch: expected $expectedType');
        }
      }
      
      if (schema.containsKey('required') && value is Map<String, dynamic>) {
        final required = schema['required'] as List<String>;
        for (final field in required) {
          if (!value.containsKey(field)) {
            throw ArgumentError('Required field missing: $field');
          }
        }
      }
      
      if (schema.containsKey('properties') && value is Map<String, dynamic>) {
        final properties = schema['properties'] as Map<String, dynamic>;
        for (final entry in properties.entries) {
          if (value.containsKey(entry.key)) {
            _validateRecursive(value[entry.key], entry.value);
          }
        }
      }
    }
  }

  /// Helper methods
  static bool _isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  static bool _isValidIndex(String str, List list) {
    final index = int.tryParse(str);
    return index != null && index >= 0 && index < list.length;
  }

  static bool _isCorrectType(dynamic value, String expectedType) {
    switch (expectedType) {
      case 'string':
        return value is String;
      case 'number':
        return value is num;
      case 'integer':
        return value is int;
      case 'boolean':
        return value is bool;
      case 'array':
        return value is List;
      case 'object':
        return value is Map;
      case 'null':
        return value == null;
      default:
        return true;
    }
  }

  /// Convert a JSON path to array notation
  static String pathToArrayNotation(String path) {
    return path.replaceAllMapped(
      RegExp(r'\.(\d+)'),
      (match) => '[${match.group(1)}]',
    );
  }

  /// Convert array notation to dot notation
  static String arrayNotationToPath(String arrayNotation) {
    return arrayNotation.replaceAllMapped(
      RegExp(r'\[(\d+)\]'),
      (match) => '.${match.group(1)}',
    );
  }

  /// Get the size (in bytes) of a JSON object when serialized
  static int getJsonSize(Map<String, dynamic> json) {
    return utf8.encode(jsonEncode(json)).length;
  }

  /// Compare two JSON objects for structural equality
  static bool isEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    return jsonEncode(a) == jsonEncode(b);
  }

  /// Get the difference between two JSON objects
  static Map<String, dynamic> diff(
    Map<String, dynamic> original,
    Map<String, dynamic> modified,
  ) {
    final result = <String, dynamic>{};
    
    // Find added or modified keys
    for (final entry in modified.entries) {
      if (!original.containsKey(entry.key) || 
          original[entry.key] != entry.value) {
        result[entry.key] = entry.value;
      }
    }
    
    // Find removed keys
    for (final key in original.keys) {
      if (!modified.containsKey(key)) {
        result[key] = null;
      }
    }
    
    return result;
  }
}