## 0.2.3

* Bug fixes

## 0.2.2

## 0.2.1

### Bug Fixes
- Fixed ThemeConfig color keys to match MCP UI DSL v1.0 specification (textOnPrimary instead of onPrimary)
- Implemented comprehensive theme validation in UIValidator
- Added color format validation for #RRGGBB and #AARRGGBB formats
- Fixed theme validation to check all 10 required colors (5 background + 5 text colors)
- Added validation for theme mode (light, dark, system)
- Added typography, spacing, borderRadius, and elevation validation
- Fixed nested theme validation path issues
- Removed UIDefinition model that didn't follow MCP UI DSL spec
- Updated UIValidator to validate ApplicationConfig and PageConfig instead of UIDefinition

## 0.2.0

### Refactoring
- Major internal refactoring for improved maintainability
- Enhanced code organization and structure
- Improved type safety and validation
- Better separation of concerns

## 0.1.0

### Initial Release

- Core models for UI definitions (`UIDefinition`, `WidgetConfig`, `ActionConfig`)
- Constants for 77+ supported widget types across 9 categories
- Comprehensive validation framework with `UIValidator`
- Type-safe property key constants
- Utility functions for JSON manipulation and type conversion
- Property helpers for style extraction and validation
- DSL version management (v1.0.0)
- Structured exception hierarchy for error handling
- Full support for MCP UI DSL v1.0 specification