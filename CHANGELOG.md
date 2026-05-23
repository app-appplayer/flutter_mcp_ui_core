## [0.4.1] - 2026-05-23 — common widget property fanout (spec 1.3.4) + template validate fix + mcp_bundle 0.4.0 cascade

### Changed
- `widgets_schema.g.dart` regenerated — every widget def in the embedded `widgets.schema.json` now admits the common `click: Action` and `tooltip: string` properties (spec 1.3.4 §2.2). Sourced from `specs/mcp_ui_dsl/spec/1.3/widgets/_common.yaml` and merged by the codegen into each widget's effective property set; a widget-declared same-named property still wins. Additive — bundles that omit `click` / `tooltip` are unaffected.
- `mcp_bundle` caret bumped from `^0.3.0` to `^0.4.0`. The downstream bundle package switched its `UiSection.pages` representation from a list to a map (`Map<String, PageDefinition>`) to align with `mcp_ui_dsl 1.3 app.schema.json`. flutter_mcp_ui_core does not call that field directly, so the only consumer change here is the caret bump; consumers of this package should bump to `^0.4.1`.
- `theme_schema.g.dart` description regenerated to English-only (drift removed from the upstream `theme.schema.json`).

### Fixed
- `TemplateDefinition.validate` now skips declared-type checks when the supplied argument is a binding expression (`"{{...}}"`). Previously a template param declared `type: boolean` rejected every expression-bound argument (always a String at validate time), causing `use` invocations to fall through `templateRegistry.resolve` and surface the runtime's `Template not found:` placeholder. Spec §9.3.1 mandates only required / default / enum / validator — strict type rejection is not required and expressions must be exempt regardless. Non-expression arguments still take the type path unchanged. Regression: `test/models/tc_template_definition_test.dart` (12/12).

## [0.4.0] - 2026-05-03 - Spec ↔ implementation alignment (1.3.3)

- App / page / theme JSON schema mirrored as generated Dart constants alongside the existing widgets schema.
- `ApplicationDefinition` typed i18n fields, `TemplateLibrary` integrity, `ColorScheme` spec-spelling acceptance — all backward compatible.

## [0.3.2] - 2026-05-02 - M3 token shorthand + ResponsiveValue schema

Schema additions to support widget-side consumption of the M3 token
domains declared in 0.3.0. Backward-compatible — existing bundles
continue to validate.

- M3 token shorthand on `text.variant` / `box.padding` /
  `card.shape` / `card.elevation` / `button.elevation` / `icon.size` /
  `icon.sizeToken`.
- `$defs.ResponsiveValue` formalised for per-form-factor property
  overrides.
- `14_Responsive_Events.md` rewritten on M3 5-class
  (`compact` / `medium` / `expanded` / `large` / `extraLarge` +
  `embedded`); `xs/sm/md/lg/xl` labels removed.
- `{{runtime.breakpoint}}` renamed to `{{runtime.formFactor}}`.

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