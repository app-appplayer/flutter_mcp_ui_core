# MCP UI DSL v1.0 Specification

## Overview

MCP UI DSL (Domain Specific Language) is a JSON-based language for defining and rendering dynamic UIs in the MCP (Model Context Protocol) environment. This specification is platform-agnostic and can be implemented in Flutter, React, Python, and various other environments.

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

#### 1.1 Application Definition (NEW)
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
      "primary": "#2196F3",
      "secondary": "#FF4081",
      "background": "#FFFFFF",
      "surface": "#F5F5F5",
      "error": "#F44336",
      "onPrimary": "#FFFFFF",
      "onSecondary": "#000000",
      "onBackground": "#000000",
      "onSurface": "#000000",
      "onError": "#FFFFFF"
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
    "type": "column",
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
        "background": "#FFFFFF"
      }
    },
    "dark": {
      "colors": {
        "primary": "#1976D2",
        "background": "#121212"
      }
    }
  }
}
```

##### 1.3.3 Theme Binding
Reference theme values in widgets:
```json
{
  "type": "container",
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
  "type": "listview",
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
  "onTap": {
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

## Widget Catalog

### Layout Widgets

#### Container
```json
{
  "type": "container",
  "width": 200,
  "height": 100,
  "padding": {"all": 16},
  "margin": {"horizontal": 8},
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

#### Column
```json
{
  "type": "column",
  "mainAxisAlignment": "start",
  "crossAxisAlignment": "center",
  "mainAxisSize": "max",
  "children": [...]
}
```

#### Row
```json
{
  "type": "row",
  "mainAxisAlignment": "spaceBetween",
  "crossAxisAlignment": "center",
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
  "trueChild": {
    "type": "text",
    "content": "Welcome, {{user.name}}!"
  },
  "falseChild": {
    "type": "button",
    "label": "Sign In",
    "onTap": {
      "type": "navigation",
      "action": "push",
      "route": "/login"
    }
  }
}
```

Or with a single child:

```json
{
  "type": "conditional",
  "condition": "{{showAdvancedOptions}}",
  "child": {
    "type": "container",
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
  "style": "elevated",
  "onTap": {
    "type": "tool",
    "name": "submitForm"
  }
}
```

#### TextField
```json
{
  "type": "textfield",
  "label": "Email",
  "placeholder": "Enter your email",
  "value": "{{form.email}}",
  "onChange": {
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
  "onChange": {
    "type": "state",
    "action": "toggle",
    "binding": "settings.notifications"
  }
}
```

#### Switch
```json
{
  "type": "switch",
  "value": "{{settings.darkMode}}",
  "onChange": {
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
  "onChange": {
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
  "onChange": {
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
  "pickerType": "both",  // "both" | "material" | "block"
  "enableHistory": true,
  "onChange": {
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
  "onChange": {
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
  "onChange": {
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
  "style": "material",  // "material" | "cupertino"
  "onChange": {
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
  "onChange": {
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
  "onChange": {
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
  "onChange": {
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

#### ListView
```json
{
  "type": "listview",
  "items": "{{users}}",
  "itemSpacing": 8,
  "shrinkWrap": true,
  "itemTemplate": {
    "type": "card",
    "child": {...}
  }
}
```

#### GridView
```json
{
  "type": "gridview",
  "items": "{{products}}",
  "crossAxisCount": 2,
  "mainAxisSpacing": 12,
  "crossAxisSpacing": 12,
  "childAspectRatio": 0.75,
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

### Context Variables

In list/grid templates:
- `{{item}}` - Current item
- `{{index}}` - Current index
- `{{isFirst}}` - Boolean
- `{{isLast}}` - Boolean
- `{{isEven}}` - Boolean
- `{{isOdd}}` - Boolean

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

### Navigation Actions (NEW)
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

### Tool Actions
Tool Actions call MCP server tools and process results.

#### Basic Tool Action Format
```json
{
  "type": "tool",
  "tool": "increment",
  "args": {
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
- `args`: Arguments to pass to tool (optional, default: {})
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
  "onTap": {
    "type": "tool",
    "tool": "increment",
    "args": {}
  }
}
```

**MCP Server Tool:**
```dart
server.addTool('increment', (args) {
  counter++;
  return CallToolResult(
    content: [
      TextContent(text: jsonEncode({'counter': counter}))
    ],
    isError: false,
  );
});
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
  "args": {
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
  "type": "column",
  "children": [
    {
      "type": "text",
      "value": "Temperature: {{temperature.value || 'Not connected'}}°C"
    },
    {
      "type": "button",
      "label": "Start Monitoring",
      "onTap": {
        "type": "resource",
        "action": "subscribe",
        "uri": "ui://sensors/room1/temperature",
        "binding": "temperature"
      }
    },
    {
      "type": "button",
      "label": "Stop Monitoring",
      "onTap": {
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
  "onTap": {
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

```dart
// When resource updates
server.notifyResourceUpdated(
  'ui://sensors/temperature',
  ResourceContentInfo(
    uri: 'ui://sensors/temperature',
    mimeType: 'application/json',
    text: jsonEncode({
      'value': 23.5,
      'unit': 'celsius',
      'timestamp': DateTime.now().toIso8601String()
    }),
  ),
);
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

```dart
// Server-side resource registration
server.addResource(
  uri: 'ui://counter',
  name: 'Counter Page Definition',
  handler: (uri) async {
    return ReadResourceResult(
      contents: [
        ResourceContentInfo(
          uri: uri,
          mimeType: 'application/json',
          text: jsonEncode({
            'type': 'page',
            'content': {
              'type': 'center',
              'child': {
                'type': 'column',
                'children': [
                  {
                    'type': 'text',
                    'value': 'Counter: {{counter}}',
                    'style': {'fontSize': 20}
                  },
                  {
                    'type': 'button',
                    'label': '+',
                    'onTap': {
                      'type': 'tool',
                      'tool': 'increment',
                      'args': {}
                    }
                  }
                ]
              }
            },
            'runtime': {
              'services': {
                'state': {
                  'initialState': {'counter': 0}
                }
              }
            }
          }),
        )
      ],
    );
  },
);
```

### Tool-based Action Handling

UI actions are processed through MCP tool calls, with tool responses automatically bound to state:

```dart
server.addTool(
  name: 'increment',
  description: 'Increment the counter',
  inputSchema: {
    'type': 'object',
    'properties': {}
  },
  handler: (arguments) async {
    // Update server state
    counter++;
    
    // Response for client state synchronization
    return CallToolResult(
      content: [
        TextContent(
          text: jsonEncode({
            'counter': counter,
            'message': 'Counter incremented to $counter'
          })
        )
      ],
      isError: false,
    );
  },
);
```

### Runtime Tool Integration

Client runtime automatically calls tools through MCP client and processes responses:

```dart
// Runtime tool call handling
Future<void> _handleToolCall(String tool, Map<String, dynamic> args) async {
  try {
    // MCP server tool call
    final result = await _mcpClient.callTool(tool, args);
    
    if (result.content.isNotEmpty) {
      final firstContent = result.content.first;
      if (firstContent is TextContent) {
        // Parse JSON response
        final responseData = jsonDecode(firstContent.text) as Map<String, dynamic>;
        
        // Automatic state merge
        responseData.forEach((key, value) {
          if (key != 'error' && key != 'message') {
            _runtime.stateManager.set(key, value);
          }
        });
      }
    }
  } catch (e) {
    // Error handling
    print('Tool execution failed: $e');
  }
}
```

### Client-Server Communication Flow

1. **UI Load:**
   ```dart
   // Client requests UI definition
   final resource = await mcpClient.readResource('ui://counter');
   final definition = jsonDecode(resource.contents.first.text);
   await runtime.initialize(definition);
   ```

2. **Tool Call:**
   ```dart
   // User clicks button → Trigger tool action
   {
     "type": "tool",
     "tool": "increment",
     "args": {}
   }
   ```

3. **Server Processing:**
   ```dart
   // Server executes tool and responds
   return CallToolResult(
     content: [TextContent(text: '{"counter": 1}')],
     isError: false
   );
   ```

4. **Client State Update:**
   ```dart
   // Runtime automatically merges state
   runtime.stateManager.set('counter', 1);
   // UI auto re-renders: {{counter}} → 1
   ```

### Notification-based Real-time Updates

Real-time data is sent via MCP notifications:

```dart
server.sendNotification(
  'notifications/message',
  {
    'level': 'info',
    'logger': 'state-update',
    'message': jsonEncode({
      'type': 'state-update',
      'path': 'app.user.name',
      'value': 'Updated Name'
    }),
  },
);
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

```dart
// Flutter implementation example
class MCPClientIntegration {
  final MCPUIRuntime runtime = MCPUIRuntime();
  final Client mcpClient;
  
  void initialize() {
    // Handle all cases with one notification handler
    mcpClient.onNotification('notifications/resources/updated', (params) {
      _handleResourceNotification(params);
    });
  }
  
  Future<void> _handleResourceNotification(Map<String, dynamic> params) async {
    final uri = params['uri'] as String;
    final binding = runtime.getBindingForUri(uri);
    if (binding == null) return;
    
    // Auto-detect mode by checking if content is included
    if (params.containsKey('content')) {
      // Extended mode: content included in notification
      final contentData = params['content'] as Map<String, dynamic>;
      final content = ResourceContentInfo.fromJson(contentData);
      
      if (content.text != null) {
        final data = jsonDecode(content.text!);
        runtime.updateState(binding, data);
      }
    } else {
      // Standard mode: URI only, must re-read resource
      try {
        final resource = await mcpClient.readResource(uri);
        final content = resource.contents.first.text;
        
        if (content != null) {
          final data = jsonDecode(content);
          runtime.updateState(binding, data);
        }
      } catch (e) {
        runtime.handleError('Failed to read resource: $e');
      }
    }
  }
  
  Widget build() {
    return runtime.buildUI(
      onToolCall: (tool, args) async {
        return await mcpClient.callTool(tool, args);
      },
      onResourceSubscribe: (uri, binding) async {
        await mcpClient.subscribeResource(uri);
        runtime.registerSubscription(uri, binding);
      },
      onResourceUnsubscribe: (uri) async {
        await mcpClient.unsubscribeResource(uri);
        runtime.unregisterSubscription(uri);
      },
    );
  }
}
```

##### 1. Standard Mode Only Implementation
When using only standard MCP protocol:

```dart
// Flutter implementation example
class StandardModeClient {
  final MCPUIRuntime runtime = MCPUIRuntime();
  final Client mcpClient;
  
  void setupStandardMode() {
    // Standard method: use onResourceUpdated (receives URI only)
    mcpClient.onResourceUpdated((uri) async {
      final binding = runtime.getBindingForUri(uri);
      if (binding == null) return;
      
      // Re-read resource
      try {
        final resource = await mcpClient.readResource(uri);
        final content = resource.contents.first.text;
        
        if (content != null) {
          final data = jsonDecode(content);
          runtime.updateState(binding, data);
        }
      } catch (e) {
        runtime.handleError('Failed to read resource: $e');
      }
    });
  }
}
```

##### 2. Extended Mode Only Implementation
When performance optimization is needed:

```dart
// Flutter implementation example
class ExtendedModeClient {
  final MCPUIRuntime runtime = MCPUIRuntime();
  final Client mcpClient;
  
  void setupExtendedMode() {
    // Extended method: use onResourceContentUpdated (includes content)
    mcpClient.onResourceContentUpdated((uri, content) {
      final binding = runtime.getBindingForUri(uri);
      if (binding == null) return;
      
      if (content.text != null) {
        final data = jsonDecode(content.text!);
        runtime.updateState(binding, data);
      }
    });
  }
}
```

#### Notification Handling
Runtime must be able to handle MCP notifications:
```typescript
runtime.handleNotification(notification: MCPNotification);
```

Flutter implementation:
```dart
// MCP notification handling
mcpClient.onNotification((notification) {
  if (notification.method == 'resources/updated') {
    runtime.handleNotification(
      notification.params['uri'],
      notification.params,
    );
  }
});
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

### Flutter Implementation
- Direct widget mapping
- Native performance
- Hot reload support

### Web Implementation
- React/Vue component mapping
- CSS-in-JS styling
- Virtual DOM optimization

### Python Implementation
- Tkinter/PyQt mapping
- Native OS widgets
- Async event handling

## Security

1. **Expression Evaluation**: Sandboxed expression parser
2. **Tool Execution**: Server-side validation
3. **Data Binding**: Input sanitization
4. **Navigation**: URL validation

## Versioning

- Current Version: 1.0.0
- Compatibility: Forward compatible within major versions
- Extension: Via `experimental` namespace

## Advanced Widgets

### Chart
```json
{
  "type": "chart",
  "properties": {
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
}
```

### Table
```json
{
  "type": "table",
  "properties": {
    "columns": [
      {"key": "id", "label": "ID", "width": 100},
      {"key": "name", "label": "Name", "sortable": true},
      {"key": "status", "label": "Status", "align": "center"}
    ],
    "rows": "{{items}}",
    "selectable": true,
    "onRowTap": {
      "type": "navigation",
      "action": "push",
      "route": "/detail/{{row.id}}"
    }
  }
}
```

### ScrollView
Scroll view for custom scrolling behavior:

```json
{
  "type": "scrollView",
  "scrollDirection": "vertical",  // "vertical" | "horizontal"
  "physics": "bouncing",  // "bouncing" | "clamping" | "neverScrollable" | "alwaysScrollable"
  "padding": {"all": 16},
  "reverse": false,
  "primary": true,
  "shrinkWrap": false,
  "controller": "{{scrollController}}",
  "child": {
    "type": "column",
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
    "type": "container",
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
    "type": "container",
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
  "onAccept": {
    "type": "tool",
    "tool": "moveItem",
    "args": {
      "itemId": "{{event.data}}",
      "targetId": "{{targetId}}"
    }
  },
  "onWillAccept": "{{canAcceptItem}}",
  "onHover": {
    "type": "state",
    "action": "set",
    "binding": "hoveredTargetId",
    "value": "{{targetId}}"
  },
  "onLeave": {
    "type": "state",
    "action": "set",
    "binding": "hoveredTargetId",
    "value": null
  },
  "builder": {
    "type": "container",
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

## Validation System

### Input Validation
```json
{
  "type": "textfield",
  "properties": {
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
}
```

### Form Validation
```json
{
  "type": "form",
  "properties": {
    "onSubmit": {
      "type": "conditional",
      "condition": "{{form.isValid}}",
      "then": {
        "type": "tool",
        "tool": "submitForm",
        "args": "{{form.data}}"
      },
      "else": {
        "type": "notification",
        "message": "Please fix form errors"
      }
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
      "type": "container",
      "properties": {
        "child": {
          "type": "text",
          "properties": {
            "content": "Something went wrong",
            "style": {"color": "#F44336"}
          }
        }
      }
    },
    "onError": {
      "type": "tool",
      "tool": "logError",
      "args": {
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
    "type": "container",
    "height": 200,
    "child": {"type": "loading-indicator"}
  },
  "content": {
    "source": "ui://pages/heavy-component"
  }
}
```

### Virtual Scrolling
```json
{
  "type": "listview",
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
        "args": {"config": "{{app.config}}"}
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
        "args": {"page": "{{route.path}}"}
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