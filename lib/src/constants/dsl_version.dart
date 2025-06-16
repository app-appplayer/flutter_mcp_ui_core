/// MCP UI DSL Version information and compatibility
class MCPUIDSLVersion {
  /// Current DSL version
  static const String current = '1.0.0';
  
  /// Minimum supported DSL version
  static const String minimum = '1.0.0';
  
  /// All supported DSL versions
  static const List<String> supported = ['1.0.0'];
  
  /// Version changelog
  static const Map<String, String> changelog = {
    '1.0.0': 'Initial release with 65 widgets, actions, and state management',
  };
  
  /// Check if a version is compatible
  static bool isCompatible(String version) {
    return supported.contains(version);
  }
  
  /// Get the latest compatible version
  static String getLatestCompatible() {
    return current;
  }
}