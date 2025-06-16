# flutter_mcp_ui_core

## 🙌 Support This Project

If you find this package useful, consider supporting ongoing development on Patreon.

[![Support on Patreon](https://c5.patreon.com/external/logo/become_a_patron_button.png)](https://www.patreon.com/mcpdevstudio)

### 🔗 MCP Dart Package Family

- [`mcp_server`](https://pub.dev/packages/mcp_server): Exposes tools, resources, and prompts to LLMs. Acts as the AI server.
- [`mcp_client`](https://pub.dev/packages/mcp_client): Connects Flutter/Dart apps to MCP servers. Acts as the client interface.
- [`mcp_llm`](https://pub.dev/packages/mcp_llm): Bridges LLMs (Claude, OpenAI, etc.) to MCP clients/servers. Acts as the LLM brain.
- [`flutter_mcp`](https://pub.dev/packages/flutter_mcp): Complete Flutter plugin for MCP integration with platform features.
- [`flutter_mcp_ui_core`](https://pub.dev/packages/flutter_mcp_ui_core): Core models, constants, and utilities for Flutter MCP UI system. 
- [`flutter_mcp_ui_runtime`](https://pub.dev/packages/flutter_mcp_ui_runtime): Comprehensive runtime for building dynamic, reactive UIs through JSON specifications. (v0.1.0)
- [`flutter_mcp_ui_generator`](https://pub.dev/packages/flutter_mcp_ui_generator): JSON generation toolkit for creating UI definitions with templates and fluent API. 

---

Core models, constants, and utilities for Flutter MCP UI system. This package provides the foundational classes and definitions that are shared between the renderer and generator packages.

📋 **Based on [MCP UI DSL v1.0 Specification](./doc/specification/MCP_UI_DSL_v1.0_Specification.md)** - The standard specification for Model Context Protocol UI Definition Language.

## Features

- **Shared Data Models**: Common models for UI definitions, widgets, actions, and bindings
- **Type-Safe Constants**: Centralized widget types and property key definitions  
- **Validation Framework**: Comprehensive validation for UI definitions and components
- **Utility Functions**: Helpers for JSON manipulation, type conversion, and property handling
- **Error Handling**: Structured exception hierarchy for better error reporting
- **DSL Version Management**: Version compatibility checking and migration support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_mcp_ui_core: ^0.1.0
```

## Core Models

### UIDefinition
Represents a complete UI definition including layout, state, computed values, and methods:

```dart
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

final uiDefinition = UIDefinition(
  layout: WidgetConfig(
    type: WidgetTypes.column,
    children: [
      WidgetConfig(
        type: WidgetTypes.text,
        properties: {'content': 'Hello World'},
      ),
    ],
  ),
  initialState: {'counter': 0},
  dslVersion: '1.0.0',
);
```

### WidgetConfig
Represents individual widget configurations:

```dart
final widget = WidgetConfig(
  type: WidgetTypes.button,
  properties: {
    PropertyKeys.label: 'Click Me',
    PropertyKeys.onTap: ActionConfig.tool('handleClick').toJson(),
  },
);
```

### ActionConfig
Represents user interactions and actions:

```dart
// Tool action
final toolAction = ActionConfig.tool('processData', {'id': '123'});

// State action
final stateAction = ActionConfig.state(
  action: 'set',
  binding: 'user.name',
  value: 'John Doe',
);

// Navigation action
final navAction = ActionConfig.navigation(
  action: 'push',
  route: '/details',
  params: {'id': '{{selectedItem.id}}'},
);
```

### New Widget Examples

#### Number Field
```dart
final numberField = WidgetConfig(
  type: WidgetTypes.numberField,
  properties: {
    'label': 'Quantity',
    'value': 1.0,
    'min': 0.0,
    'max': 100.0,
    'step': 1.0,
    'format': 'decimal',
    'bindTo': 'quantity',
  },
);
```

#### Color Picker
```dart
final colorPicker = WidgetConfig(
  type: WidgetTypes.colorPicker,
  properties: {
    'value': '#2196F3',
    'showAlpha': true,
    'pickerType': 'both',
    'bindTo': 'selectedColor',
  },
);
```

#### Date Field
```dart
final dateField = WidgetConfig(
  type: WidgetTypes.dateField,
  properties: {
    'label': 'Select Date',
    'format': 'yyyy-MM-dd',
    'mode': 'calendar',
    'bindTo': 'selectedDate',
  },
);
```

#### Conditional Widget
```dart
final conditional = WidgetConfig(
  type: WidgetTypes.conditional,
  properties: {
    'condition': '{{isLoggedIn}}',
    'trueChild': {
      'type': 'text',
      'properties': {'content': 'Welcome back!'},
    },
    'falseChild': {
      'type': 'button',
      'properties': {'label': 'Login'},
    },
  },
);
```

## Constants

### Widget Types
```dart
// Use predefined widget type constants
final container = WidgetConfig(type: WidgetTypes.container);
final button = WidgetConfig(type: WidgetTypes.button);

// Check if a widget type is valid
if (WidgetTypes.isValidType('unknown')) {
  // Handle invalid type
}

// Get widget category
final category = WidgetTypes.getCategoryForType(WidgetTypes.button); // 'input'
```

### Property Keys
```dart
// Use predefined property key constants
final properties = {
  PropertyKeys.width: 200.0,
  PropertyKeys.height: 100.0,
  PropertyKeys.backgroundColor: '#FF0000',
};
```

## Validation

### Basic Validation
```dart
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

// Validate a UI definition
final result = UIValidator.validateUIDefinition(uiDefinition);

if (result.isValid) {
  print('UI definition is valid');
} else {
  for (final error in result.criticalErrors) {
    print('Error: ${error.message}');
  }
}
```

### Property Validation
```dart
// Validate widget properties
final widget = WidgetConfig(
  type: WidgetTypes.button,
  properties: {'label': 'Click Me'},
);

final validationResult = UIValidator.validateWidget(widget);
validationResult.throwIfInvalid(); // Throws ValidationException if invalid
```

## Utilities

### JSON Utilities
```dart
// Pretty print JSON
final prettyJson = JsonUtils.prettyPrint(uiDefinition.toJson());

// Deep copy JSON objects
final copy = JsonUtils.deepCopy(originalJson);

// Get value at path
final value = JsonUtils.getValueAtPath(json, 'user.profile.name');

// Set value at path
JsonUtils.setValueAtPath(json, 'user.profile.age', 30);
```

### Type Conversion
```dart
// Safe type conversion
final stringValue = TypeConverters.toStringValue(dynamicValue, 'default');
final intValue = TypeConverters.toInt(dynamicValue, 0);
final boolValue = TypeConverters.toBool(dynamicValue, false);

// Convert colors
final hexColor = TypeConverters.toColorHex('red'); // '#FFF44336'

// Convert alignment
final alignment = TypeConverters.toAlignment('center'); // {x: 0.0, y: 0.0}
```

### Property Helpers
```dart
// Extract style properties
final style = PropertyHelpers.extractStyle(widget.properties);

// Apply default values
final withDefaults = PropertyHelpers.applyDefaults(
  properties, 
  propertySpecs,
);

// Validate properties
final errors = PropertyHelpers.validateProperties(
  properties,
  propertySpecs,
);
```

## Error Handling

The package provides a comprehensive exception hierarchy:

```dart
try {
  final result = UIValidator.validateUIDefinition(definition);
  result.throwIfInvalid();
} on ValidationException catch (e) {
  print('Validation failed: ${e.message}');
  for (final error in e.errors) {
    print('  - ${error.message}');
  }
} on InvalidWidgetException catch (e) {
  print('Invalid widget: ${e.widgetType} - ${e.message}');
} on UIException catch (e) {
  print('UI error: ${e.message}');
}
```

## DSL Version Management

```dart
// Check DSL version compatibility
if (MCPUIDSLVersion.isCompatible('1.0.0')) {
  // Process UI definition
} else {
  throw IncompatibleVersionException('Unsupported DSL version');
}

// Get supported versions
final supported = MCPUIDSLVersion.supported; // ['1.0.0']
final current = MCPUIDSLVersion.current; // '1.0.0'
```

## Widget Categories

The package organizes widgets into logical categories:

- **Layout** (20 widgets): `container`, `column`, `row`, `stack`, `padding`, `conditional`, etc.
- **Display** (16 widgets): `text`, `image`, `icon`, `card`, `chip`, etc.  
- **Input** (20 widgets): `button`, `textfield`, `checkbox`, `slider`, `numberfield`, `colorpicker`, `radiogroup`, `checkboxgroup`, `segmentedcontrol`, `datefield`, `timefield`, `daterangepicker`, etc.
- **List** (3 widgets): `listview`, `gridview`, `listtile`
- **Navigation** (7 widgets): `appbar`, `drawer`, `bottomnavigationbar`, etc.
- **Scroll** (3 widgets): `singlechildscrollview`, `scrollbar`, `scrollview`
- **Animation** (1 widget): `animatedcontainer`
- **Interactive** (4 widgets): `gesturedetector`, `inkwell`, `draggable`, `dragtarget`
- **Dialog** (3 widgets): `alertdialog`, `snackbar`, `bottomsheet`

Total: 77 supported widgets

## Documentation

- [MCP UI DSL v1.0 Specification](./doc/specification/MCP_UI_DSL_v1.0_Specification.md) - Complete specification for Model Context Protocol UI Definition Language
- [API Reference](./doc/api/) - Detailed API documentation
- [Architecture Overview](./doc/architecture/overview.md) - System architecture and design
- [Getting Started Guide](./doc/guides/getting-started.md) - Quick start guide
- [Examples](./doc/examples/) - Sample implementations

## Contributing

This package is part of the Flutter MCP UI ecosystem. See the main repository for contribution guidelines.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.