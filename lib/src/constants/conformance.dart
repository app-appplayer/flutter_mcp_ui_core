/// Conformance level constants for MCP UI DSL v1.0
/// 
/// Defines the three conformance levels for implementations
/// as specified in the MCP UI DSL v1.0 specification.
class ConformanceLevels {
  /// Level 1: Core (Required)
  /// All implementations MUST support these features
  static const String core = 'core';
  
  /// Level 2: Standard (Recommended)
  /// Includes Core plus extended features
  static const String standard = 'standard';
  
  /// Level 3: Advanced (Optional)
  /// Includes Standard plus premium features
  static const String advanced = 'advanced';
  
  /// All conformance levels
  static const List<String> allLevels = [core, standard, advanced];
  
  /// Core widgets that MUST be supported
  static const List<String> coreWidgets = [
    'text',
    'image',
    'button',
    'linear',
    'stack',
    'box',
    'container', // legacy
    'padding',
    'center',
  ];
  
  /// Core properties that MUST be supported
  static const List<String> coreProperties = [
    'width',
    'height',
    'padding',
    'margin',
    'color',
    'backgroundColor',
    'visible',
    'enabled',
  ];
  
  /// Core features that MUST be supported
  static const List<String> coreFeatures = [
    'data-binding-simple',
    'event-handling-basic',
    'state-management-basic',
    'tool-action-execution',
  ];
  
  /// Core accessibility features
  static const List<String> coreAccessibility = [
    'semantic-labels',
    'focus-management',
    'keyboard-navigation',
  ];
  
  /// Standard widgets (Core + these)
  static const List<String> standardWidgets = [
    ...coreWidgets,
    'text-input',
    'checkbox',
    'radio',
    'toggle',
    'slider',
    'select',
    'listview',
    'gridview',
    'form',
    'navigation',
    'tabbar',
    'drawer',
  ];
  
  /// Standard features (Core + these)
  static const List<String> standardFeatures = [
    ...coreFeatures,
    'expression-language-full',
    'theme-support',
    'navigation-system',
    'resource-subscriptions',
  ];
  
  /// Standard accessibility features
  static const List<String> standardAccessibility = [
    ...coreAccessibility,
    'aria-roles-full',
    'live-regions',
    'screen-reader-optimization',
  ];
  
  /// Advanced widgets (Standard + these)
  static const List<String> advancedWidgets = [
    ...standardWidgets,
    'chart',
    'map',
    'calendar',
    'timeline',
    'gauge',
    'heatmap',
    'tree',
    'graph',
    'animation',
    'custom-widgets',
  ];
  
  /// Advanced features (Standard + these)
  static const List<String> advancedFeatures = [
    ...standardFeatures,
    'background-services',
    'offline-support',
    'advanced-caching',
    'performance-optimizations',
    'custom-expressions',
    'plugin-system',
  ];
  
  /// Check if a conformance level is valid
  static bool isValidLevel(String level) {
    return allLevels.contains(level);
  }
  
  /// Check if a widget is required for a conformance level
  static bool isWidgetRequiredForLevel(String widget, String level) {
    switch (level) {
      case core:
        return coreWidgets.contains(widget);
      case standard:
        return standardWidgets.contains(widget);
      case advanced:
        return advancedWidgets.contains(widget);
      default:
        return false;
    }
  }
  
  /// Check if a feature is required for a conformance level
  static bool isFeatureRequiredForLevel(String feature, String level) {
    switch (level) {
      case core:
        return coreFeatures.contains(feature);
      case standard:
        return standardFeatures.contains(feature);
      case advanced:
        return advancedFeatures.contains(feature);
      default:
        return false;
    }
  }
  
  /// Get all widgets for a conformance level
  static List<String> getWidgetsForLevel(String level) {
    switch (level) {
      case core:
        return coreWidgets;
      case standard:
        return standardWidgets;
      case advanced:
        return advancedWidgets;
      default:
        return [];
    }
  }
  
  /// Get all features for a conformance level
  static List<String> getFeaturesForLevel(String level) {
    switch (level) {
      case core:
        return coreFeatures;
      case standard:
        return standardFeatures;
      case advanced:
        return advancedFeatures;
      default:
        return [];
    }
  }
  
  /// Calculate conformance level for an implementation
  static String calculateConformanceLevel({
    required List<String> supportedWidgets,
    required List<String> supportedFeatures,
  }) {
    // Check if all advanced requirements are met
    if (_hasAllRequirements(
      supportedWidgets: supportedWidgets,
      supportedFeatures: supportedFeatures,
      requiredWidgets: advancedWidgets,
      requiredFeatures: advancedFeatures,
    )) {
      return advanced;
    }
    
    // Check if all standard requirements are met
    if (_hasAllRequirements(
      supportedWidgets: supportedWidgets,
      supportedFeatures: supportedFeatures,
      requiredWidgets: standardWidgets,
      requiredFeatures: standardFeatures,
    )) {
      return standard;
    }
    
    // Check if all core requirements are met
    if (_hasAllRequirements(
      supportedWidgets: supportedWidgets,
      supportedFeatures: supportedFeatures,
      requiredWidgets: coreWidgets,
      requiredFeatures: coreFeatures,
    )) {
      return core;
    }
    
    // Does not meet minimum requirements
    return 'non-conformant';
  }
  
  static bool _hasAllRequirements({
    required List<String> supportedWidgets,
    required List<String> supportedFeatures,
    required List<String> requiredWidgets,
    required List<String> requiredFeatures,
  }) {
    // Check widgets
    for (final widget in requiredWidgets) {
      if (!supportedWidgets.contains(widget)) {
        return false;
      }
    }
    
    // Check features
    for (final feature in requiredFeatures) {
      if (!supportedFeatures.contains(feature)) {
        return false;
      }
    }
    
    return true;
  }
}