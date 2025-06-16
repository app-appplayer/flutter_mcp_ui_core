import 'package:meta/meta.dart';

/// Theme configuration for MCP UI DSL v1.0
/// 
/// Represents the complete theme system including colors, typography,
/// spacing, and support for light/dark modes.
@immutable
class ThemeConfig {
  /// Theme mode: 'light', 'dark', or 'system'
  final String? mode;
  
  /// Theme colors
  final Map<String, dynamic>? colors;
  
  /// Typography configuration
  final Map<String, dynamic>? typography;
  
  /// Spacing configuration
  final Map<String, dynamic>? spacing;
  
  /// Border radius configuration
  final Map<String, dynamic>? borderRadius;
  
  /// Elevation configuration
  final Map<String, dynamic>? elevation;
  
  /// Light theme configuration (when mode supports switching)
  final Map<String, dynamic>? light;
  
  /// Dark theme configuration (when mode supports switching)
  final Map<String, dynamic>? dark;

  const ThemeConfig({
    this.mode,
    this.colors,
    this.typography,
    this.spacing,
    this.borderRadius,
    this.elevation,
    this.light,
    this.dark,
  });

  /// Create from JSON
  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      mode: json['mode'] as String?,
      colors: json['colors'] as Map<String, dynamic>?,
      typography: json['typography'] as Map<String, dynamic>?,
      spacing: json['spacing'] as Map<String, dynamic>?,
      borderRadius: json['borderRadius'] as Map<String, dynamic>?,
      elevation: json['elevation'] as Map<String, dynamic>?,
      light: json['light'] as Map<String, dynamic>?,
      dark: json['dark'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    
    if (mode != null) result['mode'] = mode;
    if (colors != null) result['colors'] = colors;
    if (typography != null) result['typography'] = typography;
    if (spacing != null) result['spacing'] = spacing;
    if (borderRadius != null) result['borderRadius'] = borderRadius;
    if (elevation != null) result['elevation'] = elevation;
    if (light != null) result['light'] = light;
    if (dark != null) result['dark'] = dark;
    
    return result;
  }

  /// Get default light theme
  static ThemeConfig defaultLight() {
    return ThemeConfig(
      mode: 'light',
      colors: {
        'primary': '#2196F3',
        'secondary': '#FF4081',
        'background': '#FFFFFF',
        'surface': '#F5F5F5',
        'error': '#F44336',
        'onPrimary': '#FFFFFF',
        'onSecondary': '#000000',
        'onBackground': '#000000',
        'onSurface': '#000000',
        'onError': '#FFFFFF',
      },
      typography: _defaultTypography(),
      spacing: _defaultSpacing(),
      borderRadius: _defaultBorderRadius(),
      elevation: _defaultElevation(),
    );
  }

  /// Get default dark theme
  static ThemeConfig defaultDark() {
    return ThemeConfig(
      mode: 'dark',
      colors: {
        'primary': '#1976D2',
        'secondary': '#F57C00',
        'background': '#121212',
        'surface': '#1E1E1E',
        'error': '#CF6679',
        'onPrimary': '#FFFFFF',
        'onSecondary': '#000000',
        'onBackground': '#FFFFFF',
        'onSurface': '#FFFFFF',
        'onError': '#000000',
      },
      typography: _defaultTypography(),
      spacing: _defaultSpacing(),
      borderRadius: _defaultBorderRadius(),
      elevation: _defaultElevation(),
    );
  }

  static Map<String, dynamic> _defaultTypography() {
    return {
      'h1': {'fontSize': 32, 'fontWeight': 'bold', 'letterSpacing': -1.5},
      'h2': {'fontSize': 28, 'fontWeight': 'bold', 'letterSpacing': -0.5},
      'h3': {'fontSize': 24, 'fontWeight': 'bold', 'letterSpacing': 0},
      'h4': {'fontSize': 20, 'fontWeight': 'bold', 'letterSpacing': 0.25},
      'h5': {'fontSize': 18, 'fontWeight': 'bold', 'letterSpacing': 0},
      'h6': {'fontSize': 16, 'fontWeight': 'bold', 'letterSpacing': 0.15},
      'body1': {'fontSize': 16, 'fontWeight': 'normal', 'letterSpacing': 0.5},
      'body2': {'fontSize': 14, 'fontWeight': 'normal', 'letterSpacing': 0.25},
      'caption': {'fontSize': 12, 'fontWeight': 'normal', 'letterSpacing': 0.4},
      'button': {'fontSize': 14, 'fontWeight': 'medium', 'letterSpacing': 1.25, 'textTransform': 'uppercase'},
    };
  }

  static Map<String, dynamic> _defaultSpacing() {
    return {
      'xs': 4,
      'sm': 8,
      'md': 16,
      'lg': 24,
      'xl': 32,
      'xxl': 48,
    };
  }

  static Map<String, dynamic> _defaultBorderRadius() {
    return {
      'sm': 4,
      'md': 8,
      'lg': 16,
      'xl': 24,
      'round': 9999,
    };
  }

  static Map<String, dynamic> _defaultElevation() {
    return {
      'none': 0,
      'sm': 2,
      'md': 4,
      'lg': 8,
      'xl': 16,
    };
  }

  /// Check if theme supports dark mode
  bool get supportsDarkMode => dark != null || mode == 'system';

  /// Check if theme has custom colors
  bool get hasCustomColors => colors != null && colors!.isNotEmpty;

  /// Check if theme has custom typography
  bool get hasCustomTypography => typography != null && typography!.isNotEmpty;

  /// Get value at path (e.g., 'colors.primary')
  dynamic getValue(String path) {
    final parts = path.split('.');
    dynamic current = toJson();
    
    for (final part in parts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return null;
      }
    }
    
    return current;
  }

  /// Create a copy with modified properties
  ThemeConfig copyWith({
    String? mode,
    Map<String, dynamic>? colors,
    Map<String, dynamic>? typography,
    Map<String, dynamic>? spacing,
    Map<String, dynamic>? borderRadius,
    Map<String, dynamic>? elevation,
    Map<String, dynamic>? light,
    Map<String, dynamic>? dark,
  }) {
    return ThemeConfig(
      mode: mode ?? this.mode,
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      light: light ?? this.light,
      dark: dark ?? this.dark,
    );
  }

  /// Merge with another theme (other theme values override this)
  ThemeConfig merge(ThemeConfig other) {
    return ThemeConfig(
      mode: other.mode ?? mode,
      colors: _mergeMaps(colors, other.colors),
      typography: _mergeMaps(typography, other.typography),
      spacing: _mergeMaps(spacing, other.spacing),
      borderRadius: _mergeMaps(borderRadius, other.borderRadius),
      elevation: _mergeMaps(elevation, other.elevation),
      light: _mergeMaps(light, other.light),
      dark: _mergeMaps(dark, other.dark),
    );
  }

  Map<String, dynamic>? _mergeMaps(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null) return b;
    if (b == null) return a;
    
    final result = Map<String, dynamic>.from(a);
    b.forEach((key, value) {
      if (value is Map<String, dynamic> && result[key] is Map<String, dynamic>) {
        result[key] = _mergeMaps(result[key], value);
      } else {
        result[key] = value;
      }
    });
    
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeConfig &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          _mapsEqual(colors, other.colors) &&
          _mapsEqual(typography, other.typography) &&
          _mapsEqual(spacing, other.spacing) &&
          _mapsEqual(borderRadius, other.borderRadius) &&
          _mapsEqual(elevation, other.elevation) &&
          _mapsEqual(light, other.light) &&
          _mapsEqual(dark, other.dark);

  @override
  int get hashCode =>
      mode.hashCode ^
      colors.hashCode ^
      typography.hashCode ^
      spacing.hashCode ^
      borderRadius.hashCode ^
      elevation.hashCode ^
      light.hashCode ^
      dark.hashCode;

  bool _mapsEqual(Map? a, Map? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'ThemeConfig(mode: $mode, hasColors: ${colors != null}, hasTypography: ${typography != null})';
  }
}