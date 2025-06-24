# MCP UI DSL v1.0 Specification

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Core Concepts](#core-concepts)
   - 3.1 [UI Definition in Resources](#1-ui-definition-in-resources)
   - 3.2 [Data Binding](#2-data-binding)
   - 3.3 [Tool Integration](#3-tool-integration)
4. [Platform Abstraction](#platform-abstraction)
   - 4.1 [Widget Naming Convention](#widget-naming-convention)
   - 4.2 [Layout System](#layout-system)
   - 4.3 [Event System](#event-system)
   - 4.4 [Size Units](#size-units)
5. [Widget Catalog](#widget-catalog)
   - 5.1 [Layout Widgets](#layout-widgets)
   - 5.2 [Display Widgets](#display-widgets)
   - 5.3 [Input Widgets](#input-widgets)
   - 5.4 [List Widgets](#list-widgets)
6. [Data Binding & State Management](#data-binding--state-management)
7. [Actions](#actions)
8. [MCP Protocol Integration](#mcp-protocol-integration)
9. [Theme System](#theme-system)
10. [Platform Considerations](#platform-considerations)
11. [Security](#security)
12. [Versioning](#versioning)
13. [Accessibility](#accessibility)
14. [Internationalization](#internationalization)
15. [Advanced Widgets](#advanced-widgets)
    - 15.1 [Chart](#chart)
    - 15.2 [Table](#table)
    - 15.3 [Scroll View](#scroll-view)
    - 15.4 [Draggable & DragTarget](#draggable--dragtarget)
16. [Dialog Widgets](#dialog-widgets)
    - 16.1 [AlertDialog](#alertdialog)
    - 16.2 [SimpleDialog](#simpledialog)
    - 16.3 [BottomSheet](#bottomsheet)
17. [Validation System](#validation-system)
18. [Error Handling](#error-handling)
19. [Performance Optimization](#performance-optimization)
20. [Complete Example](#complete-example)
21. [Lifecycle Management](#lifecycle-management)
22. [Background Services](#background-services)
23. [Service Architecture](#service-architecture)
24. [Cache Management](#cache-management)
25. [Runtime Configuration](#runtime-configuration)
26. [Future Extensions](#future-extensions)
27. [Testing Support](#testing-support)
28. [Conformance Requirements](#conformance-requirements)
29. [Glossary](#glossary)

## Overview

MCP UI DSL (Domain Specific Language) is a JSON-based language for defining and rendering dynamic UIs in the MCP (Model Context Protocol) environment. This specification is platform-agnostic and can be implemented across various platforms, frameworks, and programming languages.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Resources  │     │    Tools    │     │   Prompts   │
│             │     │             │     │             │
│ • UI Defs   │     │ • Actions   │     │ • AI Inter. │
│ • Static    │     │ • Queries   │     │             │
│   Data      │     │ • Streams   │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
        │                   │                   │
        └───────────────────┴───────────────────┘
                           │
                    ┌──────────────┐
                    │ MCP UI Client │
                    └──────────────┘
```

## Core Concepts

### 1. UI Definition in Resources

UI is stored as MCP Resources and defined in JSON format. From v1.0, it supports both single pages and multi-page applications.

#### 1.1 Application Definition
Top-level resource that defines an entire application:

```json
{
  "type": "application",
  "title": "My MCP Application",
  "version": "1.0.0",
  "initialRoute": "/dashboard",
  "theme": {
    "mode": "light",  // "light" | "dark" | "system"
    "colors": {
      // Colors support both 6-digit (#RRGGBB) and 8-digit (#AARRGGBB) hex formats
      // 6-digit format assumes full opacity (FF alpha)
      "primary": "#2196F3",        // Blue (6-digit)
      "secondary": "#FFFF4081",    // Pink with full opacity (8-digit)
      "background": "#FFFFFFFF",   // White with full opacity (8-digit)
      "surface": "#F5F5F5",        // Light gray (6-digit)
      "error": "#F44336",          // Red (6-digit)
      "textOnPrimary": "#FFFFFF",
      "textOnSecondary": "#FF000000",  // Black with full opacity (8-digit)
      "textOnBackground": "#000000",
      "textOnSurface": "#000000",
      "textOnError": "#FFFFFF"
    },
    "typography": {
      "h1": {
        "fontSize": 32,
        "fontWeight": "bold",
        "letterSpacing": -1.5
      },
      "h2": {
        "fontSize": 28,
        "fontWeight": "bold",
        "letterSpacing": -0.5
      },
      "h3": {
        "fontSize": 24,
        "fontWeight": "bold",
        "letterSpacing": 0
      },
      "h4": {
        "fontSize": 20,
        "fontWeight": "bold",
        "letterSpacing": 0.25
      },
      "h5": {
        "fontSize": 18,
        "fontWeight": "bold",
        "letterSpacing": 0
      },
      "h6": {
        "fontSize": 16,
        "fontWeight": "bold",
        "letterSpacing": 0.15
      },
      "body1": {
        "fontSize": 16,
        "fontWeight": "normal",
        "letterSpacing": 0.5
      },
      "body2": {
        "fontSize": 14,
        "fontWeight": "normal",
        "letterSpacing": 0.25
      },
      "caption": {
        "fontSize": 12,
        "fontWeight": "normal",
        "letterSpacing": 0.4
      },
      "button": {
        "fontSize": 14,
        "fontWeight": "medium",
        "letterSpacing": 1.25,
        "textTransform": "uppercase"
      }
    },
    "spacing": {
      "xs": 4,
      "sm": 8,
      "md": 16,
      "lg": 24,
      "xl": 32,
      "xxl": 48
    },
    "borderRadius": {
      "sm": 4,
      "md": 8,
      "lg": 16,
      "xl": 24,
      "round": 9999
    },
    "elevation": {
      "none": 0,
      "sm": 2,
      "md": 4,
      "lg": 8,
      "xl": 16
    }
  },
  "routes": {
    "/dashboard": "ui://pages/dashboard",
    "/settings": "ui://pages/settings",
    "/profile": "ui://pages/profile",
    "/users/:id": "ui://pages/user-detail"
  },
  "state": {
    "initial": {
      "user": {
        "name": "Guest",
        "isAuthenticated": false
      },
      "themeMode": "light",
      "language": "en"
    }
  },
  "navigation": {
    "type": "drawer",
    "items": [
      {"title": "Dashboard", "route": "/dashboard", "icon": "dashboard"},
      {"title": "Settings", "route": "/settings", "icon": "settings"},
      {"title": "Profile", "route": "/profile", "icon": "person"}
    ]
  }
}
```

#### 1.2 Page Definition
Defines individual pages:

```json
{
  "type": "page",
  "title": "Dashboard",
  "route": "/dashboard",
  "themeOverride": {  // Optional: page-specific theme override
    "colors": {
      "primary": "#4CAF50"  // Primary color for this page only
    }
  },
  "content": {
    "type": "linear",
    "direction": "vertical",
    "children": [...]
  }
}
```

#### 1.3 Theme System
The theme system defines consistent styling across the entire application.

##### 1.3.1 Theme Mode
```json
{
  "theme": {
    "mode": "light",  // "light" | "dark" | "system"
    // When mode is "system", follows OS settings
  }
}
```

##### 1.3.2 Dark Mode Support
Define light/dark themes separately:
```json
{
  "theme": {
    "mode": "{{app.themeMode}}",  // Bind to state
    "light": {
      "colors": {
        "primary": "#2196F3",
        "background": "#FFFFFFFF"  // 8-digit format for precise alpha control
      }
    },
    "dark": {
      "colors": {
        "primary": "#1976D2",
        "background": "#FF121212"  // Dark background with full opacity
      }
    }
  }
}
```

##### 1.3.3 Color Format Specification
Colors in MCP UI DSL support two hex formats:

1. **6-digit format (#RRGGBB)**: Standard RGB format, assumes full opacity (alpha = FF)
   - Example: `#2196F3` (blue)
   - Example: `#FFFFFF` (white)

2. **8-digit format (#AARRGGBB)**: ARGB format with explicit alpha channel
   - Example: `#FF2196F3` (blue with full opacity)
   - Example: `#80000000` (black with 50% opacity)
   - Example: `#00FFFFFF` (fully transparent white)

Implementations MUST support both formats. When parsing:
- 6-digit: Prepend "FF" for full opacity
- 8-digit: Use as-is with alpha channel

##### 1.3.4 Theme Binding
Reference theme values in widgets:
```json
{
  "type": "box",
  "color": "{{theme.colors.surface}}",
  "padding": "{{theme.spacing.md}}",
  "borderRadius": "{{theme.borderRadius.md}}",
  "child": {
    "type": "text",
    "content": "Hello",
    "style": {
      "color": "{{theme.colors.onSurface}}",
      "fontSize": "{{theme.typography.body1.fontSize}}"
    }
  }
}
```

### 2. Data Binding

#### 2.1 Static Binding
Access both local page state and global app state:

```json
{
  "type": "text",
  "content": "{{user.name}}"  // Local page state
}
```

```json
{
  "type": "text",
  "content": "{{app.user.name}}"  // Global app state
}
```

#### 2.1.1 Route Parameters
Access route parameters:

```json
{
  "type": "text",
  "content": "User ID: {{route.params.id}}"
}
```

#### 2.1.2 Theme Values
Access theme values:

```json
{
  "type": "text",
  "content": "Primary Color: {{theme.colors.primary}}"
}
```

#### 2.2 Tool-based Data Loading
```json
{
  "type": "list",
  "dataSource": {
    "type": "tool",
    "name": "getUsers",
    "params": {"status": "active"}
  }
}
```

### 3. Tool Integration

Tools serve multiple purposes in MCP UI DSL:

#### 3.1 Action Execution
```json
{
  "type": "button",
  "label": "Create User",
  "click": {
    "type": "tool",
    "name": "createUser",
    "params": {
      "name": "{{form.name}}",
      "email": "{{form.email}}"
    }
  }
}
```

#### 3.2 Data Query
```json
{
  "onInit": {
    "type": "tool",
    "name": "loadUserData",
    "params": {"userId": "{{route.params.id}}"}
  }
}
```

## Platform Abstraction

MCP UI DSL is designed to be platform-neutral. Each platform implements widgets according to its native capabilities while maintaining consistent behavior.

### Widget Naming Convention

MCP UI DSL follows a consistent naming convention for all widget types:

#### Naming Rules
1. **Single-word widgets**: Use lowercase
   - Examples: `text`, `button`, `box`, `image`, `icon`

2. **Multi-word widgets**: Use CamelCase
   - Examples: `textInput`, `sizedBox`, `loadingIndicator`, `bottomNavigation`

#### Core Widget Types

| Widget Type | Description | Category |
|------------|-------------|----------|
| **Layout Widgets** | | |
| `linear` | Linear layout container (replaces row/column) | Layout |
| `stack` | Overlapping layout | Layout |
| `box` | Container widget (replaces container) | Layout |
| `center` | Centers child widget | Layout |
| `padding` | Adds padding around child | Layout |
| `sizedBox` | Fixed size container | Layout |
| **Display Widgets** | | |
| `text` | Text display | Display |
| `richText` | Styled text spans | Display |
| `image` | Image display | Display |
| `icon` | Icon display | Display |
| `card` | Card container | Display |
| `badge` | Badge indicator | Display |
| `loadingIndicator` | Progress/loading indicator | Display |
| **Input Widgets** | | |
| `button` | Clickable button | Input |
| `textInput` | Text input field | Input |
| `select` | Dropdown selection | Input |
| `toggle` | Toggle switch | Input |
| `slider` | Value slider | Input |
| `checkbox` | Checkbox | Input |
| `radio` | Radio button | Input |
| **Extended Input Widgets** | | |
| `numberField` | Numeric input | Input |
| `colorPicker` | Color selection | Input |
| `dateField` | Date picker | Input |
| `timeField` | Time picker | Input |
| `radioGroup` | Radio button group | Input |
| `checkboxGroup` | Checkbox group | Input |
| **Navigation Widgets** | | |
| `headerBar` | App header/toolbar | Navigation |
| `bottomNavigation` | Bottom navigation bar | Navigation |
| `drawer` | Navigation drawer | Navigation |
| `tabBar` | Tab navigation | Navigation |
| **List Widgets** | | |
| `list` | Scrollable list view | List |
| `grid` | Grid layout view | List |
| `listTile` | List item widget | List |
| **Advanced Widgets** | | |
| `scrollView` | Scrollable container | Scroll |
| `chart` | Data visualization | Advanced |
| `map` | Map display | Advanced |
| `mediaPlayer` | Audio/video player | Advanced |

### Layout System

The layout system uses platform-neutral properties:

- `direction`: "horizontal" | "vertical" (for linear layouts)
- `alignment`: "start" | "center" | "end" | "stretch" 
- `distribution`: "start" | "center" | "end" | "space-between" | "space-around" | "space-evenly"

### Event System

Events use standard names across all platforms:

- `click`: Primary activation (mouse click, tap, Enter key)
- `double-click`: Double click/tap activation
- `right-click`: Secondary/context menu activation (where supported)
- `long-press`: Extended press/touch (mobile/touch devices)
- `change`: Value changed (input fields, selections)
- `focus`/`blur`: Focus gained/lost
- `hover`: Pointer hovering (where supported)

### Size Units

Sizes can be specified with explicit units:

```json
{
  "width": {"value": 100, "unit": "px"},
  "height": {"value": 50, "unit": "percent"}
}
```

Supported units: `px`, `percent`, `em`, `rem`, `vw`, `vh`

## Widget Catalog

### Layout Widgets

#### Container
```json
{
  "type": "box",
  "width": {"value": 200, "unit": "px"},
  "height": {"value": 100, "unit": "px"},
  "padding": {"all": {"value": 16, "unit": "px"}},
  "margin": {"horizontal": {"value": 8, "unit": "px"}},
  "decoration": {
    "color": "#ffffff",
    "borderRadius": 8,
    "border": {
      "color": "#e0e0e0",
      "width": 1
    }
  },
  "child": {...}
}
```

#### Linear Layout (Vertical)
```json
{
  "type": "linear",
  "direction": "vertical",
  "alignment": "center",
  "distribution": "start",
  "children": [...]
}
```

#### Linear Layout (Horizontal)
```json
{
  "type": "linear", 
  "direction": "horizontal",
  "alignment": "center",
  "distribution": "space-between",
  "children": [...]
}
```

#### Stack
```json
{
  "type": "stack",
  "alignment": "center",
  "children": [...]
}
```

#### Center
```json
{
  "type": "center",
  "child": {...}
}
```

#### Expanded
```json
{
  "type": "expanded",
  "flex": 1,
  "child": {...}
}
```

#### Flexible
```json
{
  "type": "flexible",
  "flex": 1,
  "fit": "loose",
  "child": {...}
}
```

#### Conditional
Renders different widgets based on a condition:

```json
{
  "type": "conditional",
  "condition": "{{user.isAuthenticated}}",
  "then": {
    "type": "text",
    "content": "Welcome, {{user.name}}!"
  },
  "else": {
    "type": "button",
    "label": "Sign In",
    "click": {
      "type": "navigation",
      "action": "push",
      "route": "/login"
    }
  }
}
```

Or with a single child (only renders when true):

```json
{
  "type": "conditional",
  "condition": "{{showAdvancedOptions}}",
  "then": {
    "type": "box",
    "child": {...}
  }
}
```

### Display Widgets

#### Text
```json
{
  "type": "text",
  "content": "Hello {{name}}",
  "style": {
    "fontSize": 16,
    "fontWeight": "bold",
    "color": "#333333"
  }
}
```

#### Image
```json
{
  "type": "image",
  "src": "https://example.com/image.png",
  "width": 200,
  "height": 150,
  "fit": "cover"
}
```

#### Icon
```json
{
  "type": "icon",
  "icon": "home",
  "size": 24,
  "color": "#2196f3"
}
```

#### Divider
```json
{
  "type": "divider",
  "thickness": 1,
  "color": "#e0e0e0",
  "indent": 16,
  "endIndent": 16
}
```

#### Card
```json
{
  "type": "card",
  "elevation": 2,
  "margin": {"all": 8},
  "shape": {
    "type": "rounded",
    "radius": 12
  },
  "child": {...}
}
```

### Input Widgets

#### Button
```json
{
  "type": "button",
  "label": "Submit",
  "style": "primary",
  "click": {
    "type": "tool",
    "name": "submitForm"
  }
}
```

With multiple event handlers:
```json
{
  "type": "button",
  "label": "Edit Item",
  "click": {
    "type": "state",
    "action": "set",
    "path": "mode",
    "value": "view"
  },
  "double-click": {
    "type": "state",
    "action": "set",
    "path": "mode",
    "value": "edit"
  },
  "long-press": {
    "type": "tool",
    "name": "showContextMenu",
    "params": {"itemId": "{{item.id}}"}
  }
}
```

#### Text Input
```json
{
  "type": "textInput",
  "label": "Email",
  "placeholder": "Enter your email",
  "value": "{{form.email}}",
  "change": {
    "type": "state",
    "action": "set",
    "binding": "form.email",
    "value": "{{event.value}}"
  }
}
```

#### Checkbox
```json
{
  "type": "checkbox",
  "value": "{{settings.notifications}}",
  "change": {
    "type": "state",
    "action": "toggle",
    "binding": "settings.notifications"
  }
}
```

#### Toggle Switch
```json
{
  "type": "toggle",
  "value": "{{settings.darkMode}}",
  "change": {
    "type": "state",
    "action": "toggle",
    "binding": "settings.darkMode"
  }
}
```

#### Slider
```json
{
  "type": "slider",
  "value": "{{settings.volume}}",
  "min": 0,
  "max": 100,
  "divisions": 10,
  "change": {
    "type": "state",
    "action": "set",
    "binding": "settings.volume",
    "value": "{{event.value}}"
  }
}
```

#### NumberField
Specialized input field for numeric input:

```json
{
  "type": "numberField",
  "label": "Quantity",
  "value": "{{form.quantity}}",
  "min": 1,
  "max": 100,
  "step": 1,
  "decimalPlaces": 0,
  "format": "decimal",
  "prefix": "$",
  "suffix": "",
  "thousandSeparator": ",",
  "change": {
    "type": "state",
    "action": "set",
    "binding": "form.quantity",
    "value": "{{event.value}}"
  }
}
```

#### ColorPicker
Widget for color selection:

```json
{
  "type": "colorPicker",
  "value": "{{theme.primaryColor}}",
  "showAlpha": true,
  "showLabel": true,
  "pickerType": "wheel",  // "wheel" | "palette" | "both"
  "enableHistory": true,
  "change": {
    "type": "state",
    "action": "set",
    "binding": "theme.primaryColor",
    "value": "{{event.value}}"
  }
}
```

#### RadioGroup
Radio button group for single selection:

```json
{
  "type": "radioGroup",
  "value": "{{settings.language}}",
  "options": [
    {"value": "en", "label": "English"},
    {"value": "es", "label": "Español"},
    {"value": "fr", "label": "Français"}
  ],
  "orientation": "vertical",  // "vertical" | "horizontal"
  "change": {
    "type": "state",
    "action": "set",
    "binding": "settings.language",
    "value": "{{event.value}}"
  }
}
```

#### CheckboxGroup
Checkbox group for multiple selection:

```json
{
  "type": "checkboxGroup",
  "value": "{{form.interests}}",
  "options": [
    {"value": "sports", "label": "Sports"},
    {"value": "music", "label": "Music"},
    {"value": "reading", "label": "Reading"},
    {"value": "travel", "label": "Travel"}
  ],
  "orientation": "vertical",
  "change": {
    "type": "state",
    "action": "set",
    "binding": "form.interests",
    "value": "{{event.value}}"
  }
}
```

#### SegmentedControl
iOS-style segmented control:

```json
{
  "type": "segmentedControl",
  "value": "{{viewMode}}",
  "options": [
    {"value": "list", "label": "List", "icon": "list"},
    {"value": "grid", "label": "Grid", "icon": "grid_view"},
    {"value": "card", "label": "Card", "icon": "view_agenda"}
  ],
  "style": "segmented",  // "segmented" | "tabs" | "buttons"
  "change": {
    "type": "state",
    "action": "set",
    "binding": "viewMode",
    "value": "{{event.value}}"
  }
}
```

#### DateField
Field for date input:

```json
{
  "type": "dateField",
  "label": "Birth Date",
  "value": "{{user.birthdate}}",
  "format": "yyyy-MM-dd",
  "firstDate": "1900-01-01",
  "lastDate": "{{today}}",
  "mode": "calendar",  // "calendar" | "input" | "both"
  "locale": "en_US",
  "change": {
    "type": "state",
    "action": "set",
    "binding": "user.birthdate",
    "value": "{{event.value}}"
  }
}
```

#### TimeField
Field for time input:

```json
{
  "type": "timeField",
  "label": "Notification Time",
  "value": "{{settings.notificationTime}}",
  "format": "HH:mm",
  "use24HourFormat": true,
  "mode": "spinner",  // "spinner" | "input" | "dial"
  "change": {
    "type": "state",
    "action": "set",
    "binding": "settings.notificationTime",
    "value": "{{event.value}}"
  }
}
```

#### DateRangePicker
Widget for date range selection:

```json
{
  "type": "dateRangePicker",
  "startDate": "{{filter.startDate}}",
  "endDate": "{{filter.endDate}}",
  "firstDate": "2020-01-01",
  "lastDate": "{{today}}",
  "format": "yyyy-MM-dd",
  "locale": "en_US",
  "saveText": "Save",
  "change": {
    "type": "batch",
    "actions": [
      {
        "type": "state",
        "action": "set",
        "binding": "filter.startDate",
        "value": "{{event.startDate}}"
      },
      {
        "type": "state",
        "action": "set",
        "binding": "filter.endDate",
        "value": "{{event.endDate}}"
      }
    ]
  }
}
```

### List Widgets

#### List View
```json
{
  "type": "list",
  "items": "{{users}}",
  "spacing": 8,
  "orientation": "vertical",
  "itemTemplate": {
    "type": "card",
    "child": {...}
  }
}
```

#### Grid View
```json
{
  "type": "grid",
  "items": "{{products}}",
  "columns": 2,
  "rowGap": 12,
  "columnGap": 12,
  "itemAspectRatio": 0.75,
  "itemTemplate": {
    "type": "card",
    "child": {...}
  }
}
```

## Data Binding & State Management

### Binding Expressions

```json
// Simple binding
"{{count}}"

// Nested property
"{{user.profile.name}}"

// Array index
"{{items[0].title}}"

// Expression
"{{count > 0 ? 'Has items' : 'Empty'}}"

// Mixed content
"Total: {{count}} items"
```

### Expression Language Grammar

MCP UI DSL uses a formal expression language for data binding:

```
Expression      := Literal | Variable | BinaryOp | UnaryOp | Conditional | FunctionCall | ArrayAccess
Literal         := String | Number | Boolean | Null
String          := '"' Character* '"' | "'" Character* "'"
Number          := Integer | Float
Boolean         := "true" | "false"
Null            := "null"
Variable        := "{{" Path "}}"
Path            := Identifier ("." Identifier | "[" Expression "]")*
Identifier      := Letter (Letter | Digit | "_")*
BinaryOp        := Expression BinaryOperator Expression
UnaryOp         := UnaryOperator Expression
Conditional     := Expression "?" Expression ":" Expression
FunctionCall    := Identifier "(" ArgumentList? ")"
ArgumentList    := Expression ("," Expression)*
ArrayAccess     := Expression "[" Expression "]"

BinaryOperator  := "+" | "-" | "*" | "/" | "%" | "==" | "!=" | "<" | ">" | "<=" | ">=" | "&&" | "||"
UnaryOperator   := "!" | "-" | "+"
```

### Operator Precedence

From highest to lowest:
1. `()` `[]` `.` - Grouping, array access, member access
2. `!` `-` `+` - Unary operators
3. `*` `/` `%` - Multiplication, division, modulo
4. `+` `-` - Addition, subtraction
5. `<` `<=` `>` `>=` - Comparison
6. `==` `!=` - Equality
7. `&&` - Logical AND
8. `||` - Logical OR
9. `? :` - Conditional (ternary)

### Type Coercion

Automatic type conversion rules:
- String + Number → String concatenation
- Number + Number → Numeric addition
- Boolean in numeric context → 1 (true) or 0 (false)
- Null in string context → Empty string
- Undefined property access → null

### Built-in Functions

```json
"{{toUpperCase(name)}}"
"{{toLowerCase(text)}}"
"{{trim(input)}}"
"{{round(price, 2)}}"
"{{floor(value)}}"
"{{ceil(value)}}"
"{{max(a, b)}}"
"{{min(a, b)}}"
"{{length(array)}}"
"{{contains(text, 'search')}}"
"{{replace(text, 'old', 'new')}}"
"{{split(text, ',')}}"
"{{join(array, ', ')}}"
"{{format(date, 'YYYY-MM-DD')}}"
```

### Context Variables

In list/grid templates:
- `{{item}}` - Current item
- `{{index}}` - Current index
- `{{isFirst}}` - Boolean
- `{{isLast}}` - Boolean
- `{{isEven}}` - Boolean
- `{{isOdd}}` - Boolean

In event handlers:
- `{{event.value}}` - Input value
- `{{event.target}}` - Event target element
- `{{event.data}}` - Custom event data

## Actions

### State Actions
Manipulate both local page state and global app state:

```json
{
  "type": "state",
  "action": "set|increment|decrement|toggle|append|remove",
  "binding": "user.name",  // Local page state
  "value": "John"
}
```

```json
{
  "type": "state",
  "action": "set",
  "binding": "app.theme",  // Global app state
  "value": "dark"
}
```

### Navigation Actions
Navigate between pages:

```json
{
  "type": "navigation",
  "action": "push|replace|pop|popToRoot",
  "route": "/profile",
  "params": {
    "userId": "{{user.id}}",
    "from": "dashboard"
  }
}
```

Navigation Actions:
- `push`: Add new page to stack
- `replace`: Replace current page
- `pop`: Go back to previous page
- `popToRoot`: Go back to root page

### Dialog Actions
Show modal dialogs and bottom sheets:

```json
{
  "type": "dialog",
  "dialog": {
    "type": "alert",
    "title": "Delete Item",
    "content": "Are you sure you want to delete this item?",
    "dismissible": false,
    "actions": [
      {
        "label": "Cancel",
        "action": "close"
      },
      {
        "label": "Delete",
        "action": {
          "type": "tool",
          "tool": "deleteItem",
          "params": {"id": "{{item.id}}"}
        },
        "primary": true
      }
    ]
  }
}
```

Dialog Types:
- `alert`: Standard alert dialog with title, content, and actions
- `simple`: Simple selection dialog with list of options
- `custom`: Custom dialog with any widget as content
- `bottomSheet`: Modal bottom sheet

Special Actions:
- `close`: Closes the current dialog

### Tool Actions
Tool Actions call MCP server tools and process results.

#### Basic Tool Action Format
```json
{
  "type": "tool",
  "tool": "increment",
  "params": {
    "amount": 1
  },
  "onSuccess": {
    "type": "notification",
    "message": "Counter updated!"
  },
  "onError": {
    "type": "notification",
    "message": "Failed to update counter"
  }
}
```

**Key Fields:**
- `tool`: Tool name to call on MCP server (required)
- `params`: Parameters to pass to tool (optional, default: {})
- `onSuccess`: Action to execute on success (optional)
- `onError`: Action to execute on failure (optional)

#### Tool Response Format
MCP server tools must respond in this format:

**Success Response:**
```json
{
  "content": [
    {
      "type": "text",
      "text": "{\"counter\": 5, \"message\": \"incremented successfully\"}"
    }
  ],
  "isError": false
}
```

**Failure Response:**
```json
{
  "content": [
    {
      "type": "text",
      "text": "{\"error\": \"Invalid input\", \"message\": \"Counter cannot be negative\"}"
    }
  ],
  "isError": true
}
```

#### Automatic State Binding
Runtime automatically merges tool response JSON data into state:

1. **Server Response:** `{"counter": 5, "doubleValue": 10}`
2. **Automatic State Update:** `state.counter = 5`, `state.doubleValue = 10`
3. **UI Auto Re-render:** `{{counter}}` display updates to 5

**State Merge Rules:**
- All top-level keys in JSON object are set as state variables
- Existing state variables are overwritten
- Nested objects are completely replaced (not merged)

#### Tool Execution Flow
1. **User Interaction:** Button click, form submission, etc.
2. **Tool Action Trigger:** `{"type": "tool", "tool": "increment"}`
3. **MCP Server Call:** Runtime automatically calls server tool
4. **Response Processing:**
   - **Success:** Auto-merge JSON data to state → Execute `onSuccess` action
   - **Failure:** Execute `onError` action
5. **UI Update:** Auto re-render UI based on changed state

#### Real Example: Counter Tool
**UI Definition:**
```json
{
  "type": "button",
  "label": "+",
  "click": {
    "type": "tool",
    "tool": "increment",
    "params": {}
  }
}
```

**MCP Server Tool:**
```pseudocode
// Server-side tool handler
function incrementTool(args):
    counter = counter + 1
    return {
        content: [{
            type: "text",
            text: JSON.stringify({counter: counter})
        }],
        isError: false
    }
```

**Result:**
1. Button click → Call `increment` tool
2. Server responds with `{"counter": 1}`
3. Runtime automatically sets `state.counter = 1`
4. UI `{{counter}}` display updates to 1

#### Error Handling
```json
{
  "type": "tool",
  "tool": "validateAndSave",
  "params": {
    "data": "{{formData}}"
  },
  "onSuccess": {
    "type": "batch",
    "actions": [
      {
        "type": "notification",
        "message": "Data saved successfully!"
      },
      {
        "type": "navigation",
        "action": "push",
        "route": "/success"
      }
    ]
  },
  "onError": {
    "type": "batch",
    "actions": [
      {
        "type": "notification",
        "message": "Validation failed: {{error.message}}"
      },
      {
        "type": "state",
        "action": "set",
        "binding": "formErrors",
        "value": "{{error.details}}"
      }
    ]
  }
}
```

### Resource Actions
Resource Actions subscribe/unsubscribe to MCP server resources for real-time data updates.

#### Resource Action Structure
```json
{
  "type": "resource",
  "action": "subscribe|unsubscribe",
  "uri": "<resource-uri>",
  "binding": "<state-binding-path>"  // Required only for subscribe
}
```

#### Action Types
- `subscribe`: Start resource subscription. Automatically receive notifications on resource changes
- `unsubscribe`: Cancel resource subscription. Stop receiving updates

#### Lifecycle Auto-subscription
Automatically subscribe/unsubscribe on page initialization/destruction:

```json
{
  "type": "page",
  "onInit": [
    {
      "type": "resource",
      "action": "subscribe",
      "uri": "ui://state/user",
      "binding": "currentUser"
    },
    {
      "type": "resource",
      "action": "subscribe",
      "uri": "ui://stream/notifications",
      "binding": "notifications"
    }
  ],
  "onDestroy": [
    {
      "type": "resource",
      "action": "unsubscribe",
      "uri": "ui://state/user"
    },
    {
      "type": "resource",
      "action": "unsubscribe",
      "uri": "ui://stream/notifications"
    }
  ],
  "content": {
    "type": "text",
    "value": "Welcome {{currentUser.name}}"
  }
}
```

#### Manual Subscribe/Unsubscribe
Control subscriptions with button clicks:

```json
{
  "type": "linear",
  "direction": "vertical",
  "children": [
    {
      "type": "text",
      "value": "Temperature: {{temperature.value || 'Not connected'}}°C"
    },
    {
      "type": "button",
      "label": "Start Monitoring",
      "click": {
        "type": "resource",
        "action": "subscribe",
        "uri": "ui://sensors/room1/temperature",
        "binding": "temperature"
      }
    },
    {
      "type": "button",
      "label": "Stop Monitoring",
      "click": {
        "type": "resource",
        "action": "unsubscribe",
        "uri": "ui://sensors/room1/temperature"
      }
    }
  ]
}
```

#### Toggle Pattern
Toggle subscribe/unsubscribe with one button:

```json
{
  "type": "button",
  "label": "{{isMonitoring ? 'Stop' : 'Start'}}",
  "click": {
    "type": "conditional",
    "condition": "{{isMonitoring}}",
    "then": {
      "type": "batch",
      "actions": [
        {
          "type": "resource",
          "action": "unsubscribe",
          "uri": "ui://stream/live-data"
        },
        {
          "type": "state",
          "action": "set",
          "binding": "isMonitoring",
          "value": false
        }
      ]
    },
    "else": {
      "type": "batch",
      "actions": [
        {
          "type": "resource",
          "action": "subscribe",
          "uri": "ui://stream/live-data",
          "binding": "liveData"
        },
        {
          "type": "state",
          "action": "set",
          "binding": "isMonitoring",
          "value": true
        }
      ]
    }
  }
}
```

#### Multiple Resource Subscriptions
Subscribe to multiple resources simultaneously:

```json
{
  "type": "batch",
  "actions": [
    {
      "type": "resource",
      "action": "subscribe",
      "uri": "ui://metrics/cpu",
      "binding": "metrics.cpu"
    },
    {
      "type": "resource",
      "action": "subscribe",
      "uri": "ui://metrics/memory",
      "binding": "metrics.memory"
    },
    {
      "type": "resource",
      "action": "subscribe",
      "uri": "ui://metrics/network",
      "binding": "metrics.network"
    }
  ]
}
```

#### Conditional Subscription
Decide subscription based on conditions:

```json
{
  "type": "conditional",
  "condition": "{{settings.enableLiveUpdates}}",
  "then": {
    "type": "resource",
    "action": "subscribe",
    "uri": "ui://stream/market-prices",
    "binding": "marketPrices"
  }
}
```

#### Server Implementation
Server must notify subscribers when resources change:

```json
// Resource update notification
{
  "method": "notifications/resources/updated",
  "params": {
    "uri": "ui://sensors/temperature",
    "content": {
      "uri": "ui://sensors/temperature",
      "mimeType": "application/json",
      "text": "{\"value\": 23.5, \"unit\": \"celsius\", \"timestamp\": \"2024-01-01T12:00:00Z\"}"
    }
  }
}
```

#### Runtime Behavior

MCP UI Runtime supports two subscription modes:

##### 1. Standard Mode
Strictly follows MCP protocol standard:

1. **Start Subscription**: Call `resources/subscribe` MCP method
2. **Receive Notification**: Receive `notifications/resources/updated` notification (URI only)
3. **Re-read Resource**: Call `resources/read` with notified URI
4. **Update State**: Update data at path specified by binding
5. **Re-render UI**: Automatically update bound UI components
6. **Unsubscribe**: Call `resources/unsubscribe` MCP method

**Standard Mode Flow:**
```
Client                          Server
  |                               |
  |-- resources/subscribe ------->|
  |<-- OK ------------------------|
  |                               |
  |<-- notifications/resources/   |
  |    updated (uri only) --------|
  |                               |
  |-- resources/read(uri) ------->|
  |<-- resource content ----------|
  |                               |
  |-- Update UI ----------------->|
```

##### 2. Extended Mode
Performance-optimized mode that includes content in notifications:

1. **Start Subscription**: Call `resources/subscribe` MCP method
2. **Receive Notification**: Receive extended notification (URI + content)
3. **Update State**: Extract data directly from content and update
4. **Re-render UI**: Automatically update bound UI components
5. **Unsubscribe**: Call `resources/unsubscribe` MCP method

**Extended Mode Flow:**
```
Client                          Server
  |                               |
  |-- resources/subscribe ------->|
  |<-- OK ------------------------|
  |                               |
  |<-- Extended notification      |
  |    (uri + content) -----------|
  |                               |
  |-- Update UI directly -------->|
```

##### Mode Selection Guide

**Standard Mode Use Cases:**
- Environments requiring strict MCP protocol compliance
- Environments requiring compatibility with various MCP servers
- Large resources with low change frequency

**Extended Mode Use Cases:**
- Real-time data streaming (e.g., sensor data)
- Environments requiring minimal network latency
- Environments where both server and client implementation can be controlled

##### Runtime Configuration Example

```json
{
  "runtime": {
    "subscription": {
      "mode": "standard",  // "standard" | "extended"
      "fallbackToStandard": true,  // Fall back to standard mode on extended mode failure
      "cacheSubscribedResources": false  // Whether to cache subscribed resources
    }
  }
}
```

### Batch Actions
```json
{
  "type": "batch",
  "actions": [
    {"type": "state", "action": "set", "binding": "loading", "value": true},
    {"type": "tool", "name": "saveData"},
    {"type": "state", "action": "set", "binding": "loading", "value": false}
  ]
}
```

### Conditional Actions
```json
{
  "type": "conditional",
  "condition": "{{isValid}}",
  "then": {"type": "tool", "name": "submit"},
  "else": {"type": "notification", "message": "Please fix errors"}
}
```

## MCP Protocol Integration

### Resource-based UI Delivery

MCP servers provide application and page definitions through the `resources/read` method:

```json
// Resource response for UI definition
{
  "uri": "ui://counter",
  "name": "Counter Page Definition", 
  "mimeType": "application/json",
  "text": "{
    \"type\": \"page\",
    \"content\": {
      \"type\": \"center\",
      \"child\": {
        \"type\": \"linear\",
        \"direction\": \"vertical\",
        \"children\": [
          {
            \"type\": \"text\",
            \"content\": \"Counter: {{counter}}\",
            \"style\": {\"fontSize\": 20}
          },
          {
            \"type\": \"button\",
            \"label\": \"+\",
            \"click\": {
              \"type\": \"tool\",
              \"tool\": \"increment\",
              \"args\": {}
            }
          }
        ]
      }
    },
    \"state\": {
      \"initial\": {
        \"counter\": 0
      }
    }
  }"
}
```

### Tool-based Action Handling

UI actions are processed through MCP tool calls, with tool responses automatically bound to state:

```json
// Tool definition
{
  "name": "increment",
  "description": "Increment the counter",
  "inputSchema": {
    "type": "object",
    "properties": {}
  }
}

// Tool response format
{
  "content": [
    {
      "type": "text",
      "text": "{\"counter\": 5, \"message\": \"Counter incremented to 5\"}"
    }
  ],
  "isError": false
}
```

### Runtime Tool Integration

Client runtime automatically calls tools through MCP client and processes responses:

```pseudocode
// Runtime tool call handling
function handleToolCall(tool, args):
    try:
        // Call MCP server tool
        result = mcpClient.callTool(tool, args)
        
        if result.content is not empty:
            content = result.content[0]
            if content.type == "text":
                // Parse JSON response
                responseData = parseJSON(content.text)
                
                // Automatic state merge
                for each key, value in responseData:
                    if key != "error" and key != "message":
                        runtime.stateManager.set(key, value)
    catch error:
        // Error handling
        runtime.logError("Tool execution failed: " + error)
```

### Client-Server Communication Flow

1. **UI Load:**
   ```json
   // Client request
   {"method": "resources/read", "params": {"uri": "ui://counter"}}
   
   // Server response with UI definition
   {"result": {"contents": [{"uri": "ui://counter", "text": "..."}]}}
   ```

2. **Tool Call:**
   ```json
   // User clicks button → Trigger tool action
   {
     "method": "tools/call",
     "params": {
       "name": "increment",
       "arguments": {}
     }
   }
   ```

3. **Server Processing:**
   ```json
   // Server tool response
   {
     "content": [
       {"type": "text", "text": "{\"counter\": 1}"}
     ],
     "isError": false
   }
   ```

4. **Client State Update:**
   ```pseudocode
   // Runtime automatically merges state
   runtime.stateManager.set("counter", 1)
   // UI auto re-renders: {{counter}} → 1
   ```

### Notification-based Real-time Updates

Real-time data is sent via MCP notifications:

```json
{
  "method": "notifications/message",
  "params": {
    "level": "info",
    "logger": "state-update",
    "message": {
      "type": "state-update",
      "path": "app.user.name",
      "value": "Updated Name"
    }
  }
}
```

### Runtime Implementation Requirements

Runtime must provide handlers for MCP client integration:

#### Handler Interface
```typescript
interface RuntimeHandlers {
  // Tool execution handler
  onToolCall: (tool: string, args: object) => Promise<any>;
  
  // Resource subscription handler
  onResourceSubscribe: (uri: string, binding: string) => Promise<void>;
  
  // Resource unsubscription handler
  onResourceUnsubscribe: (uri: string) => Promise<void>;
  
  // Resource read handler (for standard mode)
  onResourceRead?: (uri: string) => Promise<string>;
}
```

#### Implementation Example

##### Unified Implementation
Runtime handles both standard and extended modes with one notification handler:

```pseudocode
// Pseudocode for handling resource notifications
function handleResourceNotification(params):
    uri = params.uri
    binding = runtime.getBindingForUri(uri)
    if binding is null:
        return
    
    // Auto-detect mode by checking if content is included
    if params contains 'content':
        // Extended mode: content included in notification
        content = params.content
        data = parseJSON(content.text)
        runtime.updateState(binding, data)
    else:
        // Standard mode: URI only, must re-read resource
        try:
            resource = mcpClient.readResource(uri)
            content = resource.contents[0].text
            data = parseJSON(content)
            runtime.updateState(binding, data)
        catch error:
            runtime.handleError('Failed to read resource: ' + error)

// Initialize runtime with handlers
runtime.initialize({
    onToolCall: function(tool, args):
        return mcpClient.callTool(tool, args)
    
    onResourceSubscribe: function(uri, binding):
        mcpClient.subscribeResource(uri)
        runtime.registerSubscription(uri, binding)
    
    onResourceUnsubscribe: function(uri):
        mcpClient.unsubscribeResource(uri)
        runtime.unregisterSubscription(uri)
})
```

##### 1. Standard Mode Only Implementation
When using only standard MCP protocol:

```pseudocode
// Standard mode implementation
function setupStandardMode(runtime, mcpClient):
    // Standard method: use onResourceUpdated (receives URI only)
    mcpClient.onResourceUpdated(function(uri):
        binding = runtime.getBindingForUri(uri)
        if binding is null:
            return
        
        // Re-read resource
        try:
            resource = await mcpClient.readResource(uri)
            content = resource.contents[0].text
            
            if content is not null:
                data = parseJSON(content)
                runtime.updateState(binding, data)
        catch error:
            runtime.handleError('Failed to read resource: ' + error)
    )
```

##### 2. Extended Mode Only Implementation
When performance optimization is needed:

```pseudocode
// Extended mode implementation
function setupExtendedMode(runtime, mcpClient):
    // Extended method: use onResourceContentUpdated (includes content)
    mcpClient.onResourceContentUpdated(function(uri, content):
        binding = runtime.getBindingForUri(uri)
        if binding is null:
            return
        
        if content.text is not null:
            data = parseJSON(content.text)
            runtime.updateState(binding, data)
    )
```

#### Notification Handling
Runtime must be able to handle MCP notifications:
```typescript
runtime.handleNotification(notification: MCPNotification);
```

Platform implementation example:
```pseudocode
// MCP notification handling
mcpClient.onNotification(function(notification):
    if notification.method == 'resources/updated':
        runtime.handleNotification(
            notification.params.uri,
            notification.params
        )
)
```

#### Implementation Example
```javascript
// Initialize runtime
const runtime = new MCPUIRuntime();
await runtime.initialize(uiDefinition);

// Set up handlers
runtime.setHandlers({
  onToolCall: async (tool, args) => {
    return await mcpClient.callTool(tool, args);
  },
  
  onResourceSubscribe: async (uri, binding) => {
    await mcpClient.subscribeResource(uri);
  },
  
  onResourceUnsubscribe: async (uri) => {
    await mcpClient.unsubscribeResource(uri);
  }
});

// Handle MCP notifications
mcpClient.on('notification', (notification) => {
  runtime.handleNotification(notification);
});

// Render UI
runtime.render();
```

## Theme System

### Theme Definition
```json
{
  "colors": {
    "primary": "#2196f3",
    "secondary": "#ff4081",
    "background": "#ffffff",
    "surface": "#f5f5f5",
    "error": "#f44336",
    "onPrimary": "#ffffff",
    "onSecondary": "#000000"
  },
  "typography": {
    "h1": {"fontSize": 32, "fontWeight": "bold"},
    "body1": {"fontSize": 16, "fontWeight": "normal"}
  },
  "spacing": {
    "small": 8,
    "medium": 16,
    "large": 24
  }
}
```

### Theme Usage
```json
{
  "type": "text",
  "content": "Title",
  "style": "{{theme.typography.h1}}",
  "color": "{{theme.colors.primary}}"
}
```

## Platform Considerations

Each platform implementing MCP UI DSL should:

### Rendering Approach
- Map abstract widgets to native components
- Maintain consistent behavior across platforms
- Optimize for platform-specific performance characteristics

### Styling System
- Translate abstract style properties to platform conventions
- Support theme inheritance and overrides
- Handle unit conversions appropriately

### Event Handling
- Map standard events to platform-specific handlers
- Ensure consistent event propagation
- Support platform-specific gesture recognition where applicable

### State Management
- Implement reactive updates efficiently
- Handle concurrent state modifications
- Provide debugging capabilities

## Security

MCP UI DSL implements multiple security layers to protect against common vulnerabilities.

### Expression Sandboxing

All expressions are evaluated in a secure sandbox:

```json
{
  "security": {
    "expressions": {
      "allowedGlobals": ["Math", "Date", "JSON"],
      "timeout": 1000,
      "maxDepth": 10,
      "maxIterations": 1000
    }
  }
}
```

### Content Security

Prevent XSS and injection attacks:

```json
{
  "type": "text",
  "content": "{{userInput}}",
  "security": {
    "sanitize": "strict",  // strict, basic, none
    "allowedTags": [],
    "allowedAttributes": []
  }
}
```

### Resource Access Control

Control access to external resources:

```json
{
  "security": {
    "resources": {
      "allowedSchemes": ["https", "data"],
      "allowedDomains": ["trusted-cdn.com", "api.example.com"],
      "blockList": ["malicious.com"],
      "contentSecurityPolicy": "default-src 'self'; img-src https:; script-src 'none';"
    }
  }
}
```

### Tool Execution Security

Server-side validation for all tool calls:

```json
{
  "security": {
    "tools": {
      "allowedTools": ["getData", "saveData"],
      "parameterValidation": true,
      "rateLimiting": {
        "maxRequests": 100,
        "windowMs": 60000
      }
    }
  }
}
```

### Input Validation

Automatic validation for all user inputs:

```json
{
  "type": "textInput",
  "validation": {
    "type": "email",
    "sanitize": true,
    "maxLength": 255,
    "pattern": "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
  }
}
```

### State Protection

Prevent unauthorized state modifications:

```json
{
  "security": {
    "state": {
      "readOnlyPaths": ["user.id", "session.token"],
      "protectedPaths": ["user.role", "permissions"],
      "allowedOrigins": ["https://app.example.com"]
    }
  }
}
```

## Versioning

- Current Version: 1.0.0
- Compatibility: Forward compatible within major versions
- Extension: Via `experimental` namespace

## Accessibility

MCP UI DSL prioritizes accessibility to ensure UIs are usable by everyone, including users with disabilities.

### Semantic Properties

Every widget can include accessibility properties:

```json
{
  "type": "button",
  "label": "Submit",
  "accessibility": {
    "label": "Submit form",
    "hint": "Double tap to submit the form",
    "role": "button",
    "enabled": true,
    "focusable": true
  }
}
```

### Roles

Standard ARIA-like roles for semantic meaning:

- `button`: Clickable button
- `link`: Navigation link
- `heading`: Section heading (with level 1-6)
- `image`: Image or graphic
- `textbox`: Text input field
- `checkbox`: Checkbox input
- `radio`: Radio button
- `list`: List container
- `listitem`: List item
- `navigation`: Navigation region
- `main`: Main content region
- `complementary`: Supporting content
- `form`: Form container

### Focus Management

```json
{
  "type": "linear",
  "accessibility": {
    "focusTraversalOrder": ["email-input", "password-input", "submit-button"]
  },
  "children": [...]
}
```

### Screen Reader Support

```json
{
  "type": "image",
  "src": "chart.png",
  "accessibility": {
    "label": "Sales chart showing 25% growth in Q3",
    "role": "image"
  }
}
```

### Live Regions

For dynamic content updates:

```json
{
  "type": "text",
  "content": "{{status}}",
  "accessibility": {
    "live": "polite",
    "atomic": true
  }
}
```

Live region types:
- `polite`: Announces when user is idle
- `assertive`: Interrupts current speech
- `off`: No announcement

## Internationalization

MCP UI DSL supports internationalization (i18n) for multi-language applications.

### Text Localization

Use keys instead of hardcoded text:

```json
{
  "type": "text",
  "i18n": {
    "key": "welcome.message",
    "params": {
      "name": "{{user.name}}"
    }
  }
}
```

### Locale-Specific Formatting

Numbers, dates, and currencies:

```json
{
  "type": "text",
  "content": "{{price}}",
  "i18n": {
    "format": "currency",
    "currency": "USD",
    "locale": "{{app.locale}}"
  }
}
```

### Pluralization

Handle plural forms correctly:

```json
{
  "type": "text",
  "i18n": {
    "key": "items.count",
    "count": "{{items.length}}",
    "zero": "No items",
    "one": "One item", 
    "other": "{count} items"
  }
}
```

### RTL Support

Right-to-left language support:

```json
{
  "type": "linear",
  "direction": "horizontal",
  "i18n": {
    "rtl": "auto"  // auto, true, false
  },
  "children": [...]
}
```

### Date/Time Formatting

```json
{
  "type": "text",
  "content": "{{date}}",
  "i18n": {
    "format": "date",
    "style": "long",  // short, medium, long, full
    "locale": "{{app.locale}}"
  }
}
```

## Advanced Widgets

### Chart
```json
{
  "type": "chart",
  "chartType": "line|bar|pie|scatter|gauge",
  "data": {
    "labels": ["Jan", "Feb", "Mar"],
    "datasets": [{
      "label": "Sales",
      "data": [100, 200, 150],
      "borderColor": "#2196F3",
      "backgroundColor": "rgba(33, 150, 243, 0.2)"
    }]
  },
  "options": {
    "responsive": true,
    "animation": {"duration": 1000}
  }
}
```

### Table
```json
{
  "type": "table",
  "columns": [
    {"key": "id", "label": "ID", "width": 100},
    {"key": "name", "label": "Name", "sortable": true},
    {"key": "status", "label": "Status", "align": "center"}
  ],
  "rows": "{{items}}",
  "selectable": true,
  "rowClick": {
    "type": "navigation",
    "action": "push",
    "route": "/detail/{{row.id}}"
  }
}
```

### Scroll View
Scrollable container for content that exceeds viewport:

```json
{
  "type": "scrollView",
  "direction": "vertical",  // "vertical" | "horizontal" | "both"
  "scrollBehavior": "auto",  // "auto" | "smooth" | "instant"
  "padding": {"all": 16},
  "reverse": false,
  "showScrollbar": "auto",  // "auto" | "always" | "never"
  "child": {
    "type": "linear",
    "direction": "vertical",
    "children": [...]
  }
}
```

### Draggable
Widget that can be dragged:

```json
{
  "type": "draggable",
  "data": "{{item.id}}",
  "feedback": {
    "type": "box",
    "padding": {"all": 8},
    "decoration": {
      "color": "#2196F3",
      "borderRadius": 8,
      "boxShadow": [
        {
          "color": "rgba(0,0,0,0.3)",
          "blurRadius": 8,
          "offset": {"x": 0, "y": 4}
        }
      ]
    },
    "child": {
      "type": "text",
      "content": "{{item.name}}",
      "style": {"color": "#FFFFFF"}
    }
  },
  "childWhenDragging": {
    "type": "box",
    "decoration": {
      "color": "#E0E0E0",
      "borderRadius": 8
    },
    "child": {
      "type": "text",
      "content": "Dragging...",
      "style": {"color": "#9E9E9E"}
    }
  },
  "child": {
    "type": "card",
    "child": {
      "type": "listtile",
      "title": "{{item.name}}",
      "subtitle": "{{item.description}}"
    }
  }
}
```

### DragTarget
Drop area that can receive dragged widgets:

```json
{
  "type": "dragTarget",
  "drop": {
    "type": "tool",
    "tool": "moveItem",
    "params": {
      "itemId": "{{event.data}}",
      "targetId": "{{targetId}}"
    }
  },
  "canDrop": "{{canAcceptItem}}",
  "dragEnter": {
    "type": "state",
    "action": "set",
    "binding": "hoveredTargetId",
    "value": "{{targetId}}"
  },
  "dragLeave": {
    "type": "state",
    "action": "set",
    "binding": "hoveredTargetId",
    "value": null
  },
  "builder": {
    "type": "box",
    "padding": {"all": 16},
    "decoration": {
      "color": "{{hoveredTargetId == targetId ? '#E3F2FD' : '#F5F5F5'}}",
      "borderRadius": 8,
      "border": {
        "color": "{{hoveredTargetId == targetId ? '#2196F3' : '#E0E0E0'}}",
        "width": 2,
        "style": "dashed"
      }
    },
    "child": {
      "type": "center",
      "child": {
        "type": "text",
        "content": "Drop here",
        "style": {"color": "#9E9E9E"}
      }
    }
  }
}
```

## Dialog Widgets

### AlertDialog
Shows a modal dialog with title, content, and actions:

```json
{
  "type": "alertDialog",
  "title": "Confirm Action",
  "content": "Are you sure you want to proceed?",
  "barrierDismissible": true,
  "actions": [
    {
      "label": "Cancel",
      "style": "text",
      "action": {
        "type": "navigation",
        "action": "pop"
      }
    },
    {
      "label": "Confirm",
      "style": "elevated",
      "primary": true,
      "action": {
        "type": "batch",
        "actions": [
          {
            "type": "tool",
            "tool": "deleteItem",
            "params": {"id": "{{item.id}}"}
          },
          {
            "type": "navigation",
            "action": "pop"
          }
        ]
      }
    }
  ]
}
```

### SimpleDialog
Shows a dialog with a list of options:

```json
{
  "type": "simpleDialog",
  "title": "Choose an option",
  "options": [
    {
      "label": "Option 1",
      "value": "option1",
      "icon": "check"
    },
    {
      "label": "Option 2",
      "value": "option2",
      "icon": "close"
    }
  ],
  "onSelect": {
    "type": "state",
    "action": "set",
    "binding": "selectedOption",
    "value": "{{event.value}}"
  }
}
```

### BottomSheet
Shows a modal bottom sheet:

```json
{
  "type": "bottomSheet",
  "isDismissible": true,
  "enableDrag": true,
  "backgroundColor": "#FFFFFF",
  "shape": {
    "type": "rounded",
    "radius": {"top": 16}
  },
  "child": {
    "type": "linear",
    "direction": "vertical",
    "padding": {"all": 16},
    "children": [
      {
        "type": "text",
        "content": "Share via",
        "style": {"fontSize": 18, "fontWeight": "bold"}
      },
      {
        "type": "list",
        "shrinkWrap": true,
        "items": [
          {"icon": "email", "label": "Email"},
          {"icon": "message", "label": "Message"},
          {"icon": "share", "label": "Other apps"}
        ]
      }
    ]
  }
}
```


## Validation System

### Input Validation
```json
{
  "type": "textInput",
  "value": "{{email}}",
  "validation": [
    {
      "type": "required",
      "message": "Email is required"
    },
    {
      "type": "email",
      "message": "Invalid email format"
    },
    {
      "type": "custom",
      "validator": "checkEmailUnique",
      "message": "Email already exists"
    }
  ]
}
```

### Form Validation
```json
{
  "type": "form",
  "onSubmit": {
    "type": "conditional",
    "condition": "{{form.isValid}}",
    "then": {
      "type": "tool",
      "tool": "submitForm",
      "params": "{{form.data}}"
    },
    "else": {
      "type": "notification",
      "message": "Please fix form errors"
    }
  }
}
```

## Error Handling

### Error Boundaries
```json
{
  "errorBoundary": {
    "fallback": {
      "type": "box",
      "child": {
        "type": "text",
        "content": "Something went wrong",
        "style": {"color": "#F44336"}
      }
    },
    "onError": {
      "type": "tool",
      "tool": "logError",
      "params": {
        "error": "{{error}}",
        "context": "{{errorContext}}"
      }
    }
  }
}
```

## Performance Optimization

### Lazy Loading
```json
{
  "type": "lazy",
  "placeholder": {
    "type": "box",
    "height": 200,
    "child": {"type": "loadingIndicator"}
  },
  "content": {
    "source": "ui://pages/heavy-component"
  }
}
```

### Virtual Scrolling
```json
{
  "type": "list",
  "itemCount": 10000,
  "itemBuilder": "{{itemTemplate}}",
  "virtual": true,
  "cacheExtent": 250
}
```

## Complete Example

### Multi-Page Application
```json
{
  "type": "application",
  "title": "Device Manager",
  "version": "1.0.0",
  "initialRoute": "/dashboard",
  "routes": {
    "/dashboard": "ui://pages/dashboard",
    "/devices": "ui://pages/device-list",
    "/device/:id": "ui://pages/device-detail",
    "/settings": "ui://pages/settings"
  },
  "state": {
    "initial": {
      "user": {
        "name": "Admin",
        "role": "administrator"
      },
      "theme": "light"
    }
  },
  "navigation": {
    "type": "drawer",
    "items": [
      {"title": "Dashboard", "route": "/dashboard", "icon": "dashboard"},
      {"title": "Devices", "route": "/devices", "icon": "devices"},
      {"title": "Settings", "route": "/settings", "icon": "settings"}
    ]
  }
}
```

## Lifecycle Management

### Application Lifecycle
Manages application and page lifecycle:

```json
{
  "lifecycle": {
    "onInitialize": [
      {
        "type": "tool",
        "tool": "initializeApp",
        "params": {"config": "{{app.config}}"}
      }
    ],
    "onReady": [
      {
        "type": "tool",
        "tool": "loadUserPreferences"
      },
      {
        "type": "state",
        "action": "set",
        "binding": "app.isReady",
        "value": true
      }
    ],
    "onMount": [
      {
        "type": "tool",
        "tool": "startBackgroundServices"
      }
    ],
    "onUnmount": [
      {
        "type": "tool",
        "tool": "cleanup"
      }
    ],
    "onDestroy": [
      {
        "type": "tool",
        "tool": "saveState"
      }
    ]
  }
}
```

### Page Lifecycle
Individual page lifecycle:

```json
{
  "type": "page",
  "lifecycle": {
    "onEnter": [
      {
        "type": "tool",
        "tool": "logPageView",
        "params": {"page": "{{route.path}}"}
      }
    ],
    "onLeave": [
      {
        "type": "tool",
        "tool": "savePageState"
      }
    ],
    "onResume": [
      {
        "type": "tool",
        "tool": "refreshData"
      }
    ],
    "onPause": [
      {
        "type": "tool",
        "tool": "savePageState"
      }
    ]
  }
}
```

## Background Services

### Service Definition
Define services that run in the background:

```json
{
  "services": {
    "backgroundSync": {
      "type": "periodic",
      "interval": 300000,  // 5 minutes
      "tool": "syncData",
      "runInBackground": true,
      "wakeDevice": false
    },
    "locationTracking": {
      "type": "continuous",
      "tool": "trackLocation",
      "permissions": ["location.background"],
      "battery": "optimized"
    },
    "messageListener": {
      "type": "event",
      "events": ["push_notification", "data_message"],
      "tool": "handleMessage",
      "priority": "high"
    }
  }
}
```

### Background Task Management
```json
{
  "backgroundTasks": [
    {
      "id": "data-sync",
      "type": "scheduled",
      "schedule": "0 */6 * * *",  // Every 6 hours
      "tool": "fullDataSync",
      "constraints": {
        "network": "unmetered",
        "battery": "not_low",
        "storage": "not_low"
      }
    },
    {
      "id": "cleanup",
      "type": "oneoff",
      "delay": 86400000,  // 24 hours
      "tool": "cleanupOldData"
    }
  ]
}
```

## Service Architecture

### Core Services
Core services provided by MCP UI Runtime:

```json
{
  "runtime": {
    "services": {
      "state": {
        "initialState": {
          "user": null,
          "theme": "system"
        },
        "persist": ["user", "theme"],
        "computed": {
          "isAuthenticated": "state.user !== null",
          "isDarkMode": "state.theme === 'dark' || (state.theme === 'system' && systemIsDark)"
        },
        "watchers": [
          {
            "binding": "user",
            "handler": {
              "type": "tool",
              "tool": "onUserChanged"
            }
          }
        ]
      },
      "navigation": {
        "mode": "stack",
        "defaultRoute": "/",
        "guards": [
          {
            "routes": ["/admin/*"],
            "condition": "{{state.user.role === 'admin'}}",
            "redirect": "/unauthorized"
          }
        ]
      },
      "dialog": {
        "defaultOptions": {
          "dismissible": true,
          "barrierColor": "rgba(0,0,0,0.5)"
        }
      },
      "notification": {
        "channels": {
          "default": {
            "importance": "high",
            "sound": true,
            "vibrate": true
          },
          "background": {
            "importance": "low",
            "showBadge": false
          }
        }
      }
    }
  }
}
```

### Service Communication
Inter-service communication:

```json
{
  "serviceActions": {
    "showDialog": {
      "service": "dialog",
      "method": "show",
      "params": {
        "type": "confirm",
        "title": "{{title}}",
        "message": "{{message}}"
      }
    },
    "navigate": {
      "service": "navigation",
      "method": "push",
      "params": {
        "route": "{{route}}",
        "params": "{{params}}"
      }
    }
  }
}
```

## Cache Management

### Cache Configuration
Cache policies and offline support:

```json
{
  "cache": {
    "enabled": true,
    "strategy": "networkFirst",  // networkFirst, cacheFirst, networkOnly, cacheOnly
    "maxAge": 3600000,  // 1 hour
    "maxSize": 52428800,  // 50MB
    "offlineMode": {
      "enabled": true,
      "fallbackPage": "ui://offline",
      "syncOnReconnect": true
    },
    "rules": [
      {
        "pattern": "ui://pages/*",
        "strategy": "cacheFirst",
        "maxAge": 86400000  // 24 hours
      },
      {
        "pattern": "api://data/*",
        "strategy": "networkFirst",
        "maxAge": 300000  // 5 minutes
      }
    ]
  }
}
```

### Cache Invalidation
```json
{
  "cacheInvalidation": {
    "triggers": [
      {
        "event": "user_logout",
        "clear": ["api://user/*", "ui://private/*"]
      },
      {
        "event": "app_update",
        "clear": "all"
      }
    ],
    "scheduled": {
      "daily": ["api://stats/*"],
      "weekly": ["ui://pages/*"]
    }
  }
}
```

## Runtime Configuration

### Initialization Options
```json
{
  "runtime": {
    "mode": "production",  // development, production
    "debug": {
      "enabled": false,
      "showPerformanceOverlay": false,
      "showSemanticDebugger": false,
      "debugShowCheckedModeBanner": false
    },
    "performance": {
      "enableProfiling": false,
      "trackWidgetBuilds": false,
      "trackLayoutBuilds": false
    },
    "errorHandling": {
      "onError": {
        "type": "tool",
        "tool": "reportError"
      },
      "fallbackUI": "ui://error",
      "enableCrashlytics": true
    }
  }
}
```

### Feature Flags
```json
{
  "features": {
    "experimentalWidgets": false,
    "betaFeatures": ["newChart", "advancedAnimations"],
    "rollout": {
      "darkMode": {
        "enabled": true,
        "percentage": 100
      },
      "newDashboard": {
        "enabled": true,
        "percentage": 50,
        "userGroups": ["beta_testers"]
      }
    }
  }
}
```

## Future Extensions

- Animation support with timeline control
- Custom widget registration system
- Advanced layout algorithms
- Gesture recognition and custom gestures
- Enhanced accessibility features
- WebAssembly support for compute-intensive tasks
- Progressive enhancement

## Testing Support

MCP UI DSL provides built-in support for testing and automation.

### Widget Identification

Every widget can have a test identifier:

```json
{
  "type": "button",
  "testId": "submit-button",
  "label": "Submit"
}
```

### Test Selectors

Multiple ways to select widgets in tests:

```json
{
  "testSelectors": {
    "id": "submit-button",
    "role": "button",
    "label": "Submit",
    "xpath": "//button[@label='Submit']"
  }
}
```

### Test Data

Provide mock data for testing:

```json
{
  "type": "list",
  "items": "{{products}}",
  "testData": {
    "products": [
      {"id": 1, "name": "Test Product 1"},
      {"id": 2, "name": "Test Product 2"}
    ]
  }
}
```

### Assertions

Define expected states for validation:

```json
{
  "type": "text",
  "content": "{{status}}",
  "testAssertions": {
    "visible": true,
    "content": "Ready",
    "style": {
      "color": "#4CAF50"
    }
  }
}
```

### Test Hooks

Execute actions during tests:

```json
{
  "testHooks": {
    "beforeRender": {
      "type": "state",
      "action": "set",
      "binding": "testMode",
      "value": true
    },
    "afterRender": {
      "type": "tool",
      "tool": "captureScreenshot"
    }
  }
}
```

### Interaction Recording

Record user interactions for replay:

```json
{
  "testRecording": {
    "enabled": true,
    "events": ["click", "input", "scroll"],
    "storage": "session"
  }
}
```

## Conformance Requirements

### Conformance Levels

MCP UI DSL defines three conformance levels for implementations:

#### Level 1: Core (Required)
All implementations MUST support:

1. **Core Widgets**
   - text, image, button
   - linear (vertical/horizontal), stack
   - container, padding, center

2. **Basic Properties**
   - width, height, padding, margin
   - color, backgroundColor
   - visible, enabled

3. **Core Features**
   - Data binding with simple expressions
   - Basic event handling (click, change)
   - State management (get/set)
   - Tool action execution

4. **Accessibility**
   - Basic semantic labels
   - Focus management
   - Keyboard navigation

#### Level 2: Standard (Recommended)
Includes Core plus:

1. **Extended Widgets**
   - All input widgets
   - List and grid views
   - Navigation widgets
   - Form widgets

2. **Advanced Features**
   - Full expression language
   - Theme support
   - Navigation system
   - Resource subscriptions

3. **Enhanced Accessibility**
   - Full ARIA role support
   - Live regions
   - Screen reader optimization

#### Level 3: Advanced (Optional)
Includes Standard plus:

1. **Advanced Widgets**
   - Charts and visualizations
   - Custom widgets
   - Animation widgets

2. **Premium Features**
   - Background services
   - Offline support
   - Advanced caching
   - Performance optimizations

### Implementation Requirements

#### Widget Rendering
- MUST render all supported widgets according to specification
- MUST handle unknown widgets gracefully (show error or skip)
- MUST respect platform conventions while maintaining behavior

#### Data Binding
- MUST implement expression parser for supported expressions
- MUST handle binding errors without crashing
- MUST update UI when bound data changes

#### Event Handling  
- MUST support standard event names
- MUST provide event context variables
- MUST handle event errors gracefully

#### State Management
- MUST maintain state isolation between pages
- MUST persist state across navigation (where specified)
- MUST handle concurrent state updates correctly

#### Security
- MUST sanitize all user inputs
- MUST validate expressions before execution
- MUST enforce resource access controls
- MUST prevent script injection

#### Performance
- SHOULD optimize rendering for large lists
- SHOULD implement efficient state updates
- SHOULD cache parsed expressions
- SHOULD minimize memory usage

### Testing Requirements

Conformant implementations MUST pass:

1. **Widget Test Suite** - Validates all widget rendering
2. **Expression Test Suite** - Tests expression evaluation
3. **State Test Suite** - Verifies state management
4. **Security Test Suite** - Checks security measures
5. **Accessibility Test Suite** - Ensures accessibility compliance

### Certification Process

1. Run automated test suites
2. Submit test results
3. Provide implementation documentation
4. Demonstrate example applications
5. Receive conformance certificate

### Non-Conformance

Implementations that do not meet requirements:
- MUST NOT claim MCP UI DSL conformance
- SHOULD document deviations clearly
- MAY use subset with "Partial MCP UI DSL" designation

## Glossary

### A-D

**Action**: An operation triggered by user interaction or system events. Types include state, navigation, tool, resource, batch, and conditional actions.

**Binding**: A connection between UI elements and data using expression syntax `{{expression}}`.

**Container**: A widget that can contain a single child widget and apply styling, padding, or decoration.

**Context Variable**: Special variables available in specific scopes, such as `{{item}}` in lists or `{{event}}` in handlers.

### E-H

**Expression**: A statement within `{{}}` that evaluates to a value, supporting operators, functions, and property access.

**Event**: User or system interaction such as click, change, focus, or hover.

**Handler**: A function or action that responds to events.

### I-L

**i18n**: Internationalization - Support for multiple languages and locales.

**Layout**: Arrangement of widgets on screen. Types include linear, stack, and grid.

**Lifecycle**: Stages in the life of an application, page, or widget (initialize, mount, unmount, destroy).

### M-P

**MCP**: Model Context Protocol - The underlying protocol for communication between UI and server.

**Navigation**: Moving between pages or screens in an application.

**Platform**: The target environment (Flutter, Web, Python, etc.) where the UI is rendered.

### Q-T

**Resource**: MCP resources that can be subscribed to for real-time updates.

**Runtime**: The execution environment that interprets and renders MCP UI DSL.

**State**: Application data that can change over time and trigger UI updates.

**Theme**: Visual styling configuration including colors, typography, spacing, and other design tokens.

**Tool**: MCP server-side functions that can be called from the UI.

### U-Z

**UI DSL**: User Interface Domain Specific Language - The JSON-based language for defining UIs.

**Validation**: Checking user input or data against rules and constraints.

**Widget**: A UI component such as text, button, or container. The basic building block of MCP UI DSL interfaces.