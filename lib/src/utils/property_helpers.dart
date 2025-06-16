import '../constants/property_keys.dart';
import '../models/property_spec.dart';
import 'type_converters.dart';

/// Helper utilities for working with widget properties
class PropertyHelpers {
  /// Extract style properties from a widget properties map
  static Map<String, dynamic> extractStyle(Map<String, dynamic> properties) {
    final style = <String, dynamic>{};
    
    // Direct style object
    if (properties.containsKey(PropertyKeys.style)) {
      final styleValue = properties[PropertyKeys.style];
      if (styleValue is Map<String, dynamic>) {
        style.addAll(styleValue);
      }
    }
    
    // Individual style properties
    const styleProperties = [
      PropertyKeys.fontSize,
      PropertyKeys.fontWeight,
      PropertyKeys.fontFamily,
      PropertyKeys.color,
      PropertyKeys.textAlign,
    ];
    
    for (final prop in styleProperties) {
      if (properties.containsKey(prop)) {
        style[prop] = properties[prop];
      }
    }
    
    return style;
  }

  /// Extract layout properties from a widget properties map
  static Map<String, dynamic> extractLayout(Map<String, dynamic> properties) {
    final layout = <String, dynamic>{};
    
    const layoutProperties = [
      PropertyKeys.width,
      PropertyKeys.height,
      PropertyKeys.padding,
      PropertyKeys.margin,
      PropertyKeys.alignment,
      PropertyKeys.mainAxisAlignment,
      PropertyKeys.crossAxisAlignment,
      PropertyKeys.mainAxisSize,
    ];
    
    for (final prop in layoutProperties) {
      if (properties.containsKey(prop)) {
        layout[prop] = properties[prop];
      }
    }
    
    return layout;
  }

  /// Extract action properties from a widget properties map
  static Map<String, dynamic> extractActions(Map<String, dynamic> properties) {
    final actions = <String, dynamic>{};
    
    for (final entry in properties.entries) {
      if (entry.key.startsWith('on') && entry.value is Map) {
        actions[entry.key] = entry.value;
      }
    }
    
    return actions;
  }

  /// Get all binding expressions from properties
  static List<String> extractBindings(Map<String, dynamic> properties) {
    final bindings = <String>[];
    
    void extractFromValue(dynamic value) {
      if (value is String && value.startsWith('{{') && value.endsWith('}}')) {
        bindings.add(value);
      } else if (value is Map) {
        value.values.forEach(extractFromValue);
      } else if (value is List) {
        value.forEach(extractFromValue);
      }
    }
    
    extractFromValue(properties);
    return bindings.toSet().toList(); // Remove duplicates
  }

  /// Apply default values to properties based on property specs
  static Map<String, dynamic> applyDefaults(
    Map<String, dynamic> properties,
    Map<String, PropertySpec> specs,
  ) {
    final result = Map<String, dynamic>.from(properties);
    
    for (final entry in specs.entries) {
      final key = entry.key;
      final spec = entry.value;
      
      // Apply default if property is missing and has a default value
      if (!result.containsKey(key) && spec.defaultValue != null) {
        result[key] = spec.defaultValue;
      }
    }
    
    return result;
  }

  /// Validate properties against specifications
  static List<String> validateProperties(
    Map<String, dynamic> properties,
    Map<String, PropertySpec> specs,
  ) {
    final errors = <String>[];
    
    // Check for required properties
    for (final entry in specs.entries) {
      if (entry.value.required && !properties.containsKey(entry.key)) {
        errors.add('Required property missing: ${entry.key}');
      }
    }
    
    // Validate existing properties
    for (final entry in properties.entries) {
      final spec = specs[entry.key];
      if (spec != null && !spec.isValid(entry.value)) {
        errors.add('Invalid value for property ${entry.key}: ${entry.value}');
      }
    }
    
    return errors;
  }

  /// Convert properties using type converters
  static Map<String, dynamic> convertProperties(Map<String, dynamic> properties) {
    final converted = <String, dynamic>{};
    
    for (final entry in properties.entries) {
      converted[entry.key] = convertProperty(entry.key, entry.value);
    }
    
    return converted;
  }

  /// Convert a single property value
  static dynamic convertProperty(String key, dynamic value) {
    switch (key) {
      // String properties
      case PropertyKeys.content:
      case PropertyKeys.text:
      case PropertyKeys.label:
      case PropertyKeys.title:
      case PropertyKeys.subtitle:
      case PropertyKeys.hint:
      case PropertyKeys.hintText:
      case PropertyKeys.placeholder:
        return TypeConverters.toStringValue(value);
      
      // Number properties
      case PropertyKeys.width:
      case PropertyKeys.height:
      case PropertyKeys.fontSize:
      case PropertyKeys.iconSize:
      case PropertyKeys.elevation:
      case PropertyKeys.aspectRatio:
      case PropertyKeys.radius:
      case PropertyKeys.progress:
        return TypeConverters.toDouble(value);
      
      // Integer properties
      case PropertyKeys.maxLength:
      case PropertyKeys.maxLines:
      case PropertyKeys.itemCount:
      case PropertyKeys.crossAxisCount:
      case PropertyKeys.flex:
      case PropertyKeys.divisions:
        return TypeConverters.toInt(value);
      
      // Boolean properties
      case PropertyKeys.enabled:
      case PropertyKeys.disabled:
      case PropertyKeys.visible:
      case PropertyKeys.selected:
      case PropertyKeys.checked:
      case PropertyKeys.required:
      case PropertyKeys.obscureText:
      case PropertyKeys.shrinkWrap:
      case PropertyKeys.mini:
      case PropertyKeys.extended:
      case PropertyKeys.indeterminate:
        return TypeConverters.toBool(value);
      
      // Color properties
      case PropertyKeys.color:
      case PropertyKeys.backgroundColor:
      case PropertyKeys.foregroundColor:
      case PropertyKeys.iconColor:
        return TypeConverters.toColorHex(value);
      
      // Special properties
      case PropertyKeys.fontWeight:
        return TypeConverters.toFontWeight(value);
      
      case PropertyKeys.textAlign:
        return TypeConverters.toTextAlign(value);
      
      case PropertyKeys.mainAxisAlignment:
        return TypeConverters.toMainAxisAlignment(value);
      
      case PropertyKeys.crossAxisAlignment:
        return TypeConverters.toCrossAxisAlignment(value);
      
      case PropertyKeys.alignment:
        return TypeConverters.toAlignment(value);
      
      case PropertyKeys.padding:
      case PropertyKeys.margin:
        return TypeConverters.toEdgeInsets(value);
      
      case PropertyKeys.borderRadius:
        return TypeConverters.toBorderRadius(value);
      
      // List properties
      case PropertyKeys.items:
      case PropertyKeys.actions:
        return TypeConverters.toList(value);
      
      // Map properties
      case PropertyKeys.style:
      case PropertyKeys.decoration:
      case PropertyKeys.onTap:
      case PropertyKeys.onPressed:
      case PropertyKeys.onChanged:
        return TypeConverters.toMap(value);
      
      default:
        return value; // Return as-is for unknown properties
    }
  }

  /// Merge multiple property maps (later ones override earlier ones)
  static Map<String, dynamic> mergeProperties(List<Map<String, dynamic>> propertyMaps) {
    final result = <String, dynamic>{};
    
    for (final properties in propertyMaps) {
      for (final entry in properties.entries) {
        result[entry.key] = entry.value;
      }
    }
    
    return result;
  }

  /// Filter properties by category
  static Map<String, dynamic> filterProperties(
    Map<String, dynamic> properties,
    List<String> allowedKeys,
  ) {
    final filtered = <String, dynamic>{};
    
    for (final key in allowedKeys) {
      if (properties.containsKey(key)) {
        filtered[key] = properties[key];
      }
    }
    
    return filtered;
  }

  /// Get property categories
  static const Map<String, List<String>> propertyCategories = {
    'style': [
      PropertyKeys.style,
      PropertyKeys.color,
      PropertyKeys.backgroundColor,
      PropertyKeys.foregroundColor,
      PropertyKeys.fontSize,
      PropertyKeys.fontWeight,
      PropertyKeys.fontFamily,
      PropertyKeys.textAlign,
      PropertyKeys.decoration,
      PropertyKeys.border,
      PropertyKeys.borderRadius,
      PropertyKeys.shadow,
      PropertyKeys.elevation,
    ],
    'layout': [
      PropertyKeys.width,
      PropertyKeys.height,
      PropertyKeys.padding,
      PropertyKeys.margin,
      PropertyKeys.alignment,
      PropertyKeys.mainAxisAlignment,
      PropertyKeys.crossAxisAlignment,
      PropertyKeys.mainAxisSize,
      PropertyKeys.flex,
    ],
    'content': [
      PropertyKeys.content,
      PropertyKeys.text,
      PropertyKeys.label,
      PropertyKeys.title,
      PropertyKeys.subtitle,
      PropertyKeys.value,
      PropertyKeys.hint,
      PropertyKeys.hintText,
      PropertyKeys.placeholder,
    ],
    'interaction': [
      PropertyKeys.onTap,
      PropertyKeys.onPressed,
      PropertyKeys.onChanged,
      PropertyKeys.onSubmitted,
      PropertyKeys.enabled,
      PropertyKeys.disabled,
    ],
    'state': [
      PropertyKeys.bindTo,
      PropertyKeys.selected,
      PropertyKeys.checked,
      PropertyKeys.visible,
      PropertyKeys.value,
    ],
    'form': [
      PropertyKeys.validator,
      PropertyKeys.required,
      PropertyKeys.obscureText,
      PropertyKeys.keyboardType,
      PropertyKeys.maxLength,
      PropertyKeys.maxLines,
    ],
    'list': [
      PropertyKeys.items,
      PropertyKeys.itemTemplate,
      PropertyKeys.itemBuilder,
      PropertyKeys.itemCount,
      PropertyKeys.shrinkWrap,
      PropertyKeys.physics,
      PropertyKeys.scrollDirection,
    ],
  };

  /// Get properties by category
  static Map<String, dynamic> getPropertiesByCategory(
    Map<String, dynamic> properties,
    String category,
  ) {
    final categoryKeys = propertyCategories[category] ?? [];
    return filterProperties(properties, categoryKeys);
  }

  /// Check if a property key is valid
  static bool isValidPropertyKey(String key) {
    return PropertyKeys.allKeys.contains(key);
  }

  /// Get property type from key
  static Type? getPropertyType(String key) {
    switch (key) {
      // String properties
      case PropertyKeys.content:
      case PropertyKeys.text:
      case PropertyKeys.label:
      case PropertyKeys.title:
      case PropertyKeys.subtitle:
      case PropertyKeys.hint:
      case PropertyKeys.hintText:
      case PropertyKeys.placeholder:
      case PropertyKeys.src:
      case PropertyKeys.icon:
      case PropertyKeys.fontFamily:
      case PropertyKeys.textAlign:
      case PropertyKeys.mainAxisAlignment:
      case PropertyKeys.crossAxisAlignment:
      case PropertyKeys.keyboardType:
      case PropertyKeys.physics:
      case PropertyKeys.scrollDirection:
        return String;
      
      // Number properties
      case PropertyKeys.width:
      case PropertyKeys.height:
      case PropertyKeys.fontSize:
      case PropertyKeys.iconSize:
      case PropertyKeys.elevation:
      case PropertyKeys.aspectRatio:
      case PropertyKeys.radius:
      case PropertyKeys.progress:
      case PropertyKeys.min:
      case PropertyKeys.max:
        return double;
      
      // Integer properties
      case PropertyKeys.maxLength:
      case PropertyKeys.maxLines:
      case PropertyKeys.itemCount:
      case PropertyKeys.crossAxisCount:
      case PropertyKeys.flex:
      case PropertyKeys.divisions:
      case PropertyKeys.fontWeight:
        return int;
      
      // Boolean properties
      case PropertyKeys.enabled:
      case PropertyKeys.disabled:
      case PropertyKeys.visible:
      case PropertyKeys.selected:
      case PropertyKeys.checked:
      case PropertyKeys.required:
      case PropertyKeys.obscureText:
      case PropertyKeys.shrinkWrap:
      case PropertyKeys.mini:
      case PropertyKeys.extended:
      case PropertyKeys.indeterminate:
        return bool;
      
      // List properties
      case PropertyKeys.items:
      case PropertyKeys.actions:
        return List;
      
      // Map properties
      case PropertyKeys.style:
      case PropertyKeys.decoration:
      case PropertyKeys.onTap:
      case PropertyKeys.onPressed:
      case PropertyKeys.onChanged:
      case PropertyKeys.padding:
      case PropertyKeys.margin:
      case PropertyKeys.alignment:
      case PropertyKeys.borderRadius:
        return Map;
      
      default:
        return null; // Unknown property type
    }
  }

  /// Get suggested property names (for autocomplete/suggestions)
  static List<String> getSuggestedProperties(String widgetType) {
    // Base properties that most widgets support
    final base = [
      PropertyKeys.width,
      PropertyKeys.height,
      PropertyKeys.padding,
      PropertyKeys.margin,
      PropertyKeys.alignment,
    ];
    
    // Widget-specific suggestions
    switch (widgetType) {
      case 'text':
        return base + [
          PropertyKeys.content,
          PropertyKeys.style,
          PropertyKeys.textAlign,
          PropertyKeys.fontSize,
          PropertyKeys.fontWeight,
          PropertyKeys.color,
        ];
      
      case 'button':
        return base + [
          PropertyKeys.label,
          PropertyKeys.onTap,
          PropertyKeys.enabled,
          PropertyKeys.icon,
          PropertyKeys.backgroundColor,
        ];
      
      case 'textfield':
        return base + [
          PropertyKeys.label,
          PropertyKeys.value,
          PropertyKeys.hintText,
          PropertyKeys.bindTo,
          PropertyKeys.onChanged,
          PropertyKeys.validator,
          PropertyKeys.obscureText,
        ];
      
      case 'image':
        return base + [
          PropertyKeys.src,
          PropertyKeys.fit,
          PropertyKeys.aspectRatio,
        ];
      
      case 'container':
        return base + [
          PropertyKeys.backgroundColor,
          PropertyKeys.decoration,
          PropertyKeys.borderRadius,
          PropertyKeys.elevation,
        ];
      
      default:
        return base;
    }
  }
}