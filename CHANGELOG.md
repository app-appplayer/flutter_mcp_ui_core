## [0.3.1] - 2026-04-30 - TemplateDefinition spec alignment

### Changed (breaking — pre-launch spec alignment)
- `TemplateDefinition` widget tree wrapper field renamed `body` → `content` to align with MCP UI DSL 1.3 §9.2.2 (canonical key per `specs/mcp_ui_dsl/spec/1.3/09_Templates.md`). `params` field name retained — it is canonical at both the definition site and the `use` widget invocation site, keeping the API symmetric. Previous wire format (`body`) is removed; bundles must emit `content`.

---

## [0.3.0] - 2026-04-28 - MCP UI DSL 1.3 (Material 3 + DTCG)

### Changed (breaking)
- **`ThemeDefinition` rewritten** to the canonical 14-token-domain spec (color, typography, spacing, shape, elevation, motion, density, breakpoints, border, opacity, focus ring, z-index, components) with optional light/dark mode overrides. Replaces the 1.2 5-section `ThemeConfig` (no alias).
- **Color** — Material 3 28-role plus 6 semantic roles, surface tonal scale (`surfaceContainerLowest`..`Highest`, `surfaceBright/Dim`). Deprecated `background` / `surfaceVariant` / `textOn*` names removed; `inverseOnSurface` renamed to `onInverseSurface`.
- **Typography** — M3 15-role (display/headline/title/body/label × L/M/S). Legacy `h1`–`h6`, `subtitle1/2`, `body1/2`, `caption`, `button`, `overline` removed.
- **Spacing** — 9-step 8pt grid (`xxs/xs/sm/md/lg/xl/2xl/3xl/4xl`) plus 4 layout aliases.
- **Shape** — M3 7-family with `ShapeCorner.uniform` / `perCorner` (RTL-aware).
- **Elevation** — 6-level with shadow + optional surface tint, tonal fallback.
- License changed from Apache-2.0 to MIT.

### Added
- **HCT seed palettes** — `SeedPalette.lightFromSeed` / `darkFromSeed` derive a 28-role palette via `material_color_utilities`.
- **DTCG codec** — `ThemeDefinition.toDtcg()` / `fromDtcg()` round-trip the entire theme through W3C Design Tokens Community Group format. Compatible with Tokens Studio, Style Dictionary, Claude Design exports.
- M3 standard state-layer opacities (hover 0.08, focus 0.12, pressed 0.16, disabled 0.38).
- New dependency: `mcp_bundle ^0.3.0`.

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