## [0.5.1] - 2026-08-03 — schema fixes the prose-type audit surfaced

**Patch, and deliberately so.** The 1.4 cut already announced that the schema
narrows — that is what made `0.5.0` a minor. This release does not narrow it a
second time; it applies that same cut to 51 slots it had missed. Charging a
second floor bump would make every consumer migrate twice for one change.

51 property slots across 45 widgets declared their element type as `X[]`, a form the generator does not parse, so
they emitted **no constraint at all**: `linear`, `stack`, `form` and 20 others
accepted `children: "hello"`. Normalized to `array<X>`, which the generator
does read, and those slots now require an array of the declared element type.
`graph.data` also became `required`, as its prose always said. A document
that leaned on either hole no longer validates — but such a document was
already broken against `0.5.0`'s prose.

The hole was invisible because the registry mixed both notations — 22 slots
used `array<X>` and were constrained, 51 used `X[]` and were not — and the
drift audit treats them as equivalent when comparing prose to registry, which
is correct for that comparison and blind to this one.

Regenerated after three registry defects found by a new audit section that
compares the prose type column against the widget registry.

- `graph.data` and `markdown.text` were **truncated** by the drafting tool and
  adopted verbatim: the union's `| binding` had spilled into `default:` and
  the `required` column into `description:`. Both declared that the property
  does not accept a binding, when it does.
- **`lazy` was defined twice** and the shorter copy won, so the schema carried
  only `child` — `content`, `trigger`, `onLoad` and `onError` were absent
  despite being documented.
- `box.width` / `height` are `Dimension`: the runtime accepts `{value, unit}`,
  so the registry was narrower than the code.
- Eleven type strings carried markdown backticks that the generator emits
  verbatim.

## [0.5.0] - 2026-08-03 — Asset reference axis, 23 widgets, prose enums (spec 1.4)

The embedded schema constant is regenerated from spec 1.4 after the largest
vocabulary cut since the Composition Profile.

### Changed

- README states 1.4 rather than 1.3, and its example compiles: it called
  `ThemeDefinition.lightFromSeed` (no such method — `defaultLight(seedHex:)`)
  and constructed a `UIDefinition` that does not exist.

### Changed — narrowing, which is why this is a minor rather than a patch

- **`AssetRef` slots reject a bare string carrying no scheme.** `image.src`
  (and its `source` / `backgroundImage` aliases), `avatar.src` and
  `lottieAnimation.src` were typed as plain strings while the prose said
  `AssetRef`; they now reference the primitive. A document whose source is
  absent expresses that with a **binding**, not `""` — spec §6.12.2a.
- **`icon` slots take `IconRef`.** The `icon` widget documented three forms
  while the eight other icon slots were bare strings, so a codepoint object
  could not be written outside `icon` at all. `IconRef` states the rule once
  (name · codepoint · any `AssetRef`) and every slot references it. A bare
  string carrying no known scheme is still read as a name, so the named form
  is unchanged.
- **Thirteen string properties declare their values as `enum`.** They listed
  them in `description` only, so `text.variant` rejected a typo while
  `button.variant` accepted one. `linear.distribution` carries its kebab
  spellings in the enum as well — the runtime has accepted them since v1.0 and
  no document said so (spec §17.3.1a).

Every widget in this workspace was checked against both the old and the new
schema before the change landed: 4,476 asset and icon widgets, **zero newly
invalid**.

### Added

- **`AssetRef` object form** — `{uri, origin?}`, read through MCP
  `resources/read`. No new scheme was minted for "an asset the server holds":
  MCP already reads an arbitrary resource uri, and `Origin` already says which
  server. The scheme pattern also opens from a closed enumeration to any
  RFC 3986 scheme, matching the openness `Origin` was written with.
- **23 widget definitions.** Core: `fileInput` `multiSelect` `combobox`
  `otpInput` `dateTimePicker` `accordion` `popover` `menu` `contextMenu`
  `breadcrumb` `pagination` `link`. Advanced: `qrCode` `barcode` `pdfViewer`
  `diffViewer` `richTextEditor` `splitter` `resizable` `kanban` `gantt`
  `spreadsheet`. Client: `voiceInput`.
- **20 widget aliases** (§17.3.1) and **21 properties** on existing widgets.
- **`navigation.openUrl`** — Core had no way out of the application.

## [0.4.3] - 2026-07-28 — Composition Profile in the embedded schemas (spec 1.4)

### Added — entry & identity value types (spec 1.4 §8.9)

- **`EntryContext`, `EntryIssuer`, `EntryNotice`, `IdentityContext`, `IdentityState`, `IdentitySubjectKind`** — how a definition was reached and who is looking at it. They live here, with the other spec value types, so authoring tools, validators and non-runtime consumers can name them without depending on the Flutter runtime; the runtime re-exports them and owns the behaviour (session, binding resolution, launch route).
- **`IdentityPromotion` / `PromotionOutcome`** — `promoted` · `declined` · `unavailable` · `failed`. A host returning "no identity" for all three would leave a document unable to tell "you declined, try again" from "this host cannot sign you in", which is a distinction every established credential API preserves.
- **`ActionTypes.identityPromote` / `identityRelease`**, a `v14Types` list, and `isIdentityAction`. This registry mirrors spec §17.2.2 — adding the actions to the runtime without adding them here would leave the canonical name list disagreeing with the spec it claims to mirror.

`EntryNotice.fromWire` folds an unrecognised notice kind onto `advisory` rather than dropping it, so a resolver newer than the runtime never loses a message.

### Fixed
- `ApplicationDefinition.routes` was typed `Map<String, String>`, and
  `fromConfig` cast every value with `as String`. Since v1.4 a route target may
  be a `DefinitionSource` object naming another origin, so an application with
  a composed route threw during parsing. Routes now keep their declared shape.
  The same narrowing existed on the runtime side and is fixed there too.

### Changed
- **`app/page/theme` schemas re-versioned to 1.4.** The 1.4 spec tree was seeded
  from 1.3 and these three kept 1.3 `$id`s, titles and cross-references, while
  only the widget schema had moved — so the machine-readable half of the release
  described the previous version. `configs_codegen` was pinned to `1.3`
  independently of `spec_codegen`'s `--spec-version`; it now carries a
  `_specVersion` constant that moves with it.
- **`RouteValue` widened to a `DefinitionSource`** (`$defs/Origin` added). The
  1.4 prose widened routes in §1.2.1 but the config that generates the schema
  was never updated, so a validator would have rejected a valid composed route.

### Changed — widgets schema
- `widgets_schema.g.dart` regenerated — the embedded `widgets.schema.json` now carries the **`view`** widget (`utility` category, `Composition` profile, `since: v1.4`) with its `source` / `props` / `fallback` / `loading` / `onError` / `theme` properties. Sourced from `specs/mcp_ui_dsl/spec/1.4/widgets/utility/view.yaml` and emitted by `tools/spec_codegen`, whose default `--spec-version` moved to `1.4` in the same change.
- Additive: every pre-existing widget definition is byte-identical, so bundles that never use `view` are unaffected. A runtime that does not implement the Composition Profile treats `view` as an unknown widget type (error placeholder, no crash) per spec §18.7.3.

## [0.4.2] - 2026-07-19 — `client.mcpStream` channel type in the embedded page schema (spec 1.3)

### Changed
- `page_schema.g.dart` regenerated — the `ChannelDefinition.type` enumeration now lists `client.mcpStream` alongside the existing five channel types (`client.watchFile`, `client.watchDirectory`, `client.systemMonitor`, `client.poll`, `client.websocket`). Sourced from `specs/mcp_ui_dsl/spec/1.3/configs/page/ChannelDefinition.yaml` and embedded by the codegen. Additive and version-neutral: `type` stays an open string, so bundles using the prior five types are unaffected, and the `major.minor` DSL-version gate (`MCPUIDSLVersion`) is unchanged.
- `channel_definition.dart` dartdoc lists the new type. First consumer: the `client.mcpStream` runtime channel (flutter_mcp_ui_runtime) — the first channel that carries an MCP-server-pushed live stream.
- `mcp_bundle` floor raised `^0.4.0 → ^0.4.8` (floors-at-latest on cut; no new symbol used).

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