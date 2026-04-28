# flutter_mcp_ui_core

Core models, constants, and utilities for the Flutter MCP UI system. Shared foundation for the renderer and generator packages, implementing the **MCP UI DSL 1.3** specification.

## Features

- **Shared data models** — UI definitions, widgets, actions, bindings.
- **Material 3 theme system** — `ThemeDefinition` mirrors the canonical 14-token-domain spec (color, typography, spacing, shape, elevation, motion, density, breakpoints, border, opacity, focus ring, z-index, components) with optional light/dark overrides.
- **M3 28-role color** + 6 semantic roles, surface tonal scale, HCT seed palettes.
- **15-role typography**, 9-step spacing on the 8pt grid, 7-family shapes, 6-level elevation, M3 state-layer opacities.
- **DTCG (W3C Design Tokens)** codec — `ThemeDefinition.toDtcg()` / `fromDtcg()` for round-trip with Tokens Studio, Style Dictionary, Claude Design exports.
- **Type-safe constants** — widget types and property keys.
- **Validation framework** — schema, references, and theme validators.
- **Utilities** — JSON manipulation, type conversion, property helpers.
- **Structured exceptions** for clear error reporting.
- **DSL version management** — compatibility checks and migration utilities.

## Quick Start

```dart
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

final theme = ThemeDefinition.lightFromSeed(const Color(0xFF6750A4));
final dtcg = theme.toDtcg();
final restored = ThemeDefinition.fromDtcg(dtcg);

final ui = UIDefinition(
  layout: WidgetConfig(
    type: WidgetTypes.linear,
    properties: {'direction': 'vertical'},
    children: [
      WidgetConfig(type: WidgetTypes.text, properties: {'value': 'Hello'}),
    ],
  ),
);
```

## Support

- [Issue Tracker](https://github.com/app-appplayer/flutter_mcp_ui_core/issues)
- [Discussions](https://github.com/app-appplayer/flutter_mcp_ui_core/discussions)

## License

MIT — see [LICENSE](LICENSE).
