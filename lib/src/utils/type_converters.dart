/// Type conversion utilities for MCP UI DSL
/// 
/// Provides safe type conversion and validation for widget properties.
class TypeConverters {
  /// Convert value to string safely
  static String toStringValue(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// Convert value to int safely
  static int toInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    
    return defaultValue;
  }

  /// Convert value to double safely
  static double toDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    
    return defaultValue;
  }

  /// Convert value to bool safely
  static bool toBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) return defaultValue;
    
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes') return true;
      if (lower == 'false' || lower == '0' || lower == 'no') return false;
    }
    if (value is int) {
      return value != 0;
    }
    
    return defaultValue;
  }

  /// Convert value to List safely
  static List<T> toList<T>(dynamic value, [List<T> defaultValue = const []]) {
    if (value == null) return defaultValue;
    
    if (value is List<T>) return value;
    if (value is List) {
      try {
        return value.cast<T>();
      } catch (e) {
        return defaultValue;
      }
    }
    
    return defaultValue;
  }

  /// Convert value to Map safely
  static Map<String, dynamic> toMap(dynamic value, [Map<String, dynamic>? defaultValue]) {
    defaultValue ??= <String, dynamic>{};
    
    if (value == null) return defaultValue;
    
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (e) {
        return defaultValue;
      }
    }
    
    return defaultValue;
  }

  /// Convert color string to ARGB hex
  static String toColorHex(dynamic value, [String defaultValue = '#000000']) {
    if (value == null) return defaultValue;
    
    final str = value.toString().trim();
    
    // Already in hex format
    if (str.startsWith('#')) {
      if (str.length == 7 || str.length == 9) {
        return str.toUpperCase();
      }
      // Convert short hex (#RGB) to full hex (#RRGGBB)
      if (str.length == 4) {
        final r = str[1];
        final g = str[2];
        final b = str[3];
        return '#$r$r$g$g$b$b'.toUpperCase();
      }
    }
    
    // Named colors
    final namedColor = _namedColors[str.toLowerCase()];
    if (namedColor != null) {
      return namedColor;
    }
    
    // RGB/RGBA format
    if (str.startsWith('rgb')) {
      return _parseRgbColor(str) ?? defaultValue;
    }
    
    return defaultValue;
  }

  /// Convert alignment string to alignment object
  static Map<String, dynamic> toAlignment(dynamic value) {
    if (value == null) return {'x': 0.0, 'y': 0.0};
    
    if (value is Map) {
      return {
        'x': toDouble(value['x'], 0.0),
        'y': toDouble(value['y'], 0.0),
      };
    }
    
    final str = toStringValue(value).toLowerCase();
    switch (str) {
      case 'topleft':
        return {'x': -1.0, 'y': -1.0};
      case 'topcenter':
        return {'x': 0.0, 'y': -1.0};
      case 'topright':
        return {'x': 1.0, 'y': -1.0};
      case 'centerleft':
        return {'x': -1.0, 'y': 0.0};
      case 'center':
        return {'x': 0.0, 'y': 0.0};
      case 'centerright':
        return {'x': 1.0, 'y': 0.0};
      case 'bottomleft':
        return {'x': -1.0, 'y': 1.0};
      case 'bottomcenter':
        return {'x': 0.0, 'y': 1.0};
      case 'bottomright':
        return {'x': 1.0, 'y': 1.0};
      default:
        return {'x': 0.0, 'y': 0.0};
    }
  }

  /// Convert edge insets value to standardized format
  static Map<String, double> toEdgeInsets(dynamic value) {
    if (value == null) {
      return {'left': 0.0, 'top': 0.0, 'right': 0.0, 'bottom': 0.0};
    }
    
    if (value is Map) {
      // Handle all/horizontal/vertical shorthand
      if (value.containsKey('all')) {
        final all = toDouble(value['all']);
        return {'left': all, 'top': all, 'right': all, 'bottom': all};
      }
      
      final left = toDouble(value['left'] ?? value['horizontal'], 0.0);
      final top = toDouble(value['top'] ?? value['vertical'], 0.0);
      final right = toDouble(value['right'] ?? value['horizontal'], 0.0);
      final bottom = toDouble(value['bottom'] ?? value['vertical'], 0.0);
      
      return {'left': left, 'top': top, 'right': right, 'bottom': bottom};
    }
    
    // Single value - apply to all sides
    final all = toDouble(value);
    return {'left': all, 'top': all, 'right': all, 'bottom': all};
  }

  /// Convert border radius value to standardized format
  static Map<String, double> toBorderRadius(dynamic value) {
    if (value == null) {
      return {'topLeft': 0.0, 'topRight': 0.0, 'bottomLeft': 0.0, 'bottomRight': 0.0};
    }
    
    if (value is Map) {
      // Handle all shorthand
      if (value.containsKey('all')) {
        final all = toDouble(value['all']);
        return {'topLeft': all, 'topRight': all, 'bottomLeft': all, 'bottomRight': all};
      }
      
      return {
        'topLeft': toDouble(value['topLeft'], 0.0),
        'topRight': toDouble(value['topRight'], 0.0),
        'bottomLeft': toDouble(value['bottomLeft'], 0.0),
        'bottomRight': toDouble(value['bottomRight'], 0.0),
      };
    }
    
    // Single value - apply to all corners
    final all = toDouble(value);
    return {'topLeft': all, 'topRight': all, 'bottomLeft': all, 'bottomRight': all};
  }

  /// Convert font weight string to numeric value
  static int toFontWeight(dynamic value, [int defaultValue = 400]) {
    if (value == null) return defaultValue;
    
    if (value is int) {
      return value.clamp(100, 900);
    }
    
    final str = toStringValue(value).toLowerCase();
    switch (str) {
      case 'thin':
        return 100;
      case 'extralight':
      case 'ultralight':
        return 200;
      case 'light':
        return 300;
      case 'normal':
      case 'regular':
        return 400;
      case 'medium':
        return 500;
      case 'semibold':
      case 'demibold':
        return 600;
      case 'bold':
        return 700;
      case 'extrabold':
      case 'ultrabold':
        return 800;
      case 'black':
      case 'heavy':
        return 900;
      default:
        return toInt(value, defaultValue);
    }
  }

  /// Convert text align string to standardized format
  static String toTextAlign(dynamic value, [String defaultValue = 'left']) {
    if (value == null) return defaultValue;
    
    final str = toStringValue(value).toLowerCase();
    switch (str) {
      case 'left':
      case 'start':
        return 'left';
      case 'right':
      case 'end':
        return 'right';
      case 'center':
        return 'center';
      case 'justify':
        return 'justify';
      default:
        return defaultValue;
    }
  }

  /// Convert main axis alignment string to standardized format
  static String toMainAxisAlignment(dynamic value, [String defaultValue = 'start']) {
    if (value == null) return defaultValue;
    
    final str = toStringValue(value).toLowerCase();
    switch (str) {
      case 'start':
        return 'start';
      case 'end':
        return 'end';
      case 'center':
        return 'center';
      case 'spacebetween':
      case 'space-between':
        return 'spaceBetween';
      case 'spacearound':
      case 'space-around':
        return 'spaceAround';
      case 'spaceevenly':
      case 'space-evenly':
        return 'spaceEvenly';
      default:
        return defaultValue;
    }
  }

  /// Convert cross axis alignment string to standardized format
  static String toCrossAxisAlignment(dynamic value, [String defaultValue = 'center']) {
    if (value == null) return defaultValue;
    
    final str = toStringValue(value).toLowerCase();
    switch (str) {
      case 'start':
        return 'start';
      case 'end':
        return 'end';
      case 'center':
        return 'center';
      case 'stretch':
        return 'stretch';
      case 'baseline':
        return 'baseline';
      default:
        return defaultValue;
    }
  }

  /// Validate if a value can be converted to the specified type
  static bool canConvertTo(dynamic value, Type targetType) {
    if (value == null) return true; // null can be converted to any type
    
    switch (targetType) {
      case String:
        return true; // Any value can be converted to string
      case int:
        return value is int || 
               value is double ||
               (value is String && int.tryParse(value) != null);
      case double:
        return value is num ||
               (value is String && double.tryParse(value) != null);
      case bool:
        return value is bool ||
               (value is String && _isBooleanString(value)) ||
               value is int;
      case List:
        return value is List;
      case Map:
        return value is Map;
      default:
        return true;
    }
  }

  /// Get the actual type of a value as a string
  static String getValueType(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return 'string';
    if (value is int) return 'integer';
    if (value is double) return 'double';
    if (value is bool) return 'boolean';
    if (value is List) return 'array';
    if (value is Map) return 'object';
    return 'unknown';
  }

  // Private helper methods
  static String? _parseRgbColor(String rgbString) {
    final regex = RegExp(r'rgba?\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([\d.]+))?\s*\)');
    final match = regex.firstMatch(rgbString);
    
    if (match != null) {
      final r = int.parse(match.group(1)!);
      final g = int.parse(match.group(2)!);
      final b = int.parse(match.group(3)!);
      final a = match.group(4) != null ? (double.parse(match.group(4)!) * 255).round() : 255;
      
      return '#${a.toRadixString(16).padLeft(2, '0')}'
             '${r.toRadixString(16).padLeft(2, '0')}'
             '${g.toRadixString(16).padLeft(2, '0')}'
             '${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
    }
    
    return null;
  }

  static bool _isBooleanString(String value) {
    final lower = value.toLowerCase();
    return ['true', 'false', '1', '0', 'yes', 'no'].contains(lower);
  }

  // Named colors mapping
  static const Map<String, String> _namedColors = {
    'transparent': '#00000000',
    'black': '#FF000000',
    'white': '#FFFFFFFF',
    'red': '#FFF44336',
    'green': '#FF4CAF50',
    'blue': '#FF2196F3',
    'yellow': '#FFFFFF00',
    'orange': '#FFFF9800',
    'purple': '#FF9C27B0',
    'pink': '#FFE91E63',
    'cyan': '#FF00BCD4',
    'teal': '#FF009688',
    'indigo': '#FF3F51B5',
    'amber': '#FFFFC107',
    'lime': '#FFCDDC39',
    'grey': '#FF9E9E9E',
    'gray': '#FF9E9E9E',
    'brown': '#FF795548',
    'deeporange': '#FFFF5722',
    'deeppurple': '#FF673AB7',
    'lightblue': '#FF03A9F4',
    'lightgreen': '#FF8BC34A',
    'bluegrey': '#FF607D8B',
    'bluegray': '#FF607D8B',
  };
}