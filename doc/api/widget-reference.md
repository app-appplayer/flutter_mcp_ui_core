# Widget Reference

This document provides a comprehensive reference for all widgets available in the MCP UI DSL.

## Widget Categories

- [Layout Widgets](#layout-widgets)
- [Display Widgets](#display-widgets)
- [Input Widgets](#input-widgets)
- [List Widgets](#list-widgets)
- [Navigation Widgets](#navigation-widgets)
- [Utility Widgets](#utility-widgets)

## Common Properties

All widgets support these base properties:

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `type` | string | **Required.** The widget type | - |
| `visible` | boolean/string | Widget visibility. Can be a binding | true |
| `key` | string | Unique identifier for the widget | null |
| `testKey` | string | Key for widget testing | null |

## Layout Widgets

### Column

Arranges children vertically.

```json
{
  "type": "column",
  "mainAxisAlignment": "start",
  "crossAxisAlignment": "center",
  "mainAxisSize": "max",
  "children": []
}
```

| Property | Type | Description | Values |
|----------|------|-------------|---------|
| `mainAxisAlignment` | string | Alignment along main axis | `start`, `end`, `center`, `spaceBetween`, `spaceAround`, `spaceEvenly` |
| `crossAxisAlignment` | string | Alignment along cross axis | `start`, `end`, `center`, `stretch` |
| `mainAxisSize` | string | Size along main axis | `min`, `max` |
| `children` | array | Child widgets | [] |

### Row

Arranges children horizontally.

```json
{
  "type": "row",
  "mainAxisAlignment": "start",
  "crossAxisAlignment": "center",
  "mainAxisSize": "max",
  "children": []
}
```

Properties are identical to Column but apply horizontally.

### Container

A box with optional decoration, padding, and constraints.

```json
{
  "type": "container",
  "width": 200,
  "height": 100,
  "padding": 16,
  "margin": 8,
  "alignment": "center",
  "decoration": {
    "color": "#FFFFFF",
    "borderRadius": 8,
    "border": {
      "color": "#000000",
      "width": 1
    },
    "boxShadow": [
      {
        "color": "#00000033",
        "blurRadius": 4,
        "offset": {"dx": 0, "dy": 2}
      }
    ]
  },
  "child": {}
}
```

| Property | Type | Description |
|----------|------|-------------|
| `width` | number | Container width |
| `height` | number | Container height |
| `padding` | number/object | Inner spacing |
| `margin` | number/object | Outer spacing |
| `alignment` | string | Child alignment |
| `decoration` | object | Visual decoration |
| `child` | object | Single child widget |

### Stack

Overlays children on top of each other.

```json
{
  "type": "stack",
  "alignment": "topLeft",
  "fit": "loose",
  "children": []
}
```

| Property | Type | Description | Values |
|----------|------|-------------|---------|
| `alignment` | string | Default alignment for children | `topLeft`, `topCenter`, `topRight`, `centerLeft`, `center`, `centerRight`, `bottomLeft`, `bottomCenter`, `bottomRight` |
| `fit` | string | How to size the stack | `loose`, `expand`, `passthrough` |

### Center

Centers its child widget.

```json
{
  "type": "center",
  "child": {}
}
```

### Expanded

Expands to fill available space in a Row/Column.

```json
{
  "type": "expanded",
  "flex": 1,
  "child": {}
}
```

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `flex` | number | Flex factor | 1 |

### SizedBox

A box with specific dimensions.

```json
{
  "type": "sizedBox",
  "width": 100,
  "height": 50,
  "child": {}
}
```

### Padding

Adds padding around a child.

```json
{
  "type": "padding",
  "padding": 16,
  "child": {}
}
```

| Property | Type | Description |
|----------|------|-------------|
| `padding` | number/object | Padding amount |

Padding object format:
```json
{
  "left": 8,
  "right": 8,
  "top": 16,
  "bottom": 16
}
```

## Display Widgets

### Text

Displays text with optional styling.

```json
{
  "type": "text",
  "value": "Hello {{name}}",
  "style": {
    "fontSize": 16,
    "fontWeight": "bold",
    "color": "#333333",
    "fontFamily": "Roboto",
    "decoration": "underline",
    "letterSpacing": 1.2,
    "wordSpacing": 2.0,
    "height": 1.5
  },
  "textAlign": "center",
  "maxLines": 2,
  "overflow": "ellipsis"
}
```

| Property | Type | Description | Values |
|----------|------|-------------|---------|
| `value` | string | **Required.** Text content (supports bindings) | - |
| `style` | object | Text styling | See style properties |
| `textAlign` | string | Text alignment | `left`, `right`, `center`, `justify` |
| `maxLines` | number | Maximum lines | null (unlimited) |
| `overflow` | string | Overflow behavior | `clip`, `fade`, `ellipsis`, `visible` |

### RichText

Displays formatted text with multiple styles.

```json
{
  "type": "richText",
  "spans": [
    {
      "text": "Hello ",
      "style": {"fontWeight": "normal"}
    },
    {
      "text": "{{name}}",
      "style": {"fontWeight": "bold", "color": "#FF0000"}
    }
  ]
}
```

### Image

Displays an image from various sources.

```json
{
  "type": "image",
  "source": "https://example.com/image.png",
  "width": 200,
  "height": 200,
  "fit": "cover",
  "placeholder": "assets/placeholder.png",
  "errorWidget": {
    "type": "icon",
    "icon": "error",
    "color": "#FF0000"
  }
}
```

| Property | Type | Description | Values |
|----------|------|-------------|---------|
| `source` | string | **Required.** Image URL or asset path | - |
| `width` | number | Image width | null |
| `height` | number | Image height | null |
| `fit` | string | How to fit the image | `fill`, `contain`, `cover`, `fitWidth`, `fitHeight`, `none`, `scaleDown` |
| `placeholder` | string | Loading placeholder | null |
| `errorWidget` | object | Widget shown on error | null |

### Icon

Displays an icon.

```json
{
  "type": "icon",
  "icon": "home",
  "size": 24,
  "color": "#000000"
}
```

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `icon` | string | **Required.** Icon name | - |
| `size` | number | Icon size | 24 |
| `color` | string | Icon color | Theme default |

### CircularProgressIndicator

Shows a circular loading indicator.

```json
{
  "type": "circularProgressIndicator",
  "value": 0.7,
  "color": "#2196F3",
  "backgroundColor": "#E0E0E0",
  "strokeWidth": 4
}
```

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `value` | number | Progress (0.0-1.0), null for indeterminate | null |
| `color` | string | Progress color | Theme primary |
| `backgroundColor` | string | Background track color | Transparent |
| `strokeWidth` | number | Line thickness | 4.0 |

### LinearProgressIndicator

Shows a linear loading bar.

```json
{
  "type": "linearProgressIndicator",
  "value": 0.5,
  "color": "#4CAF50",
  "backgroundColor": "#E0E0E0",
  "minHeight": 4
}
```

## Input Widgets

### Button

A clickable button with various styles.

```json
{
  "type": "button",
  "label": "Click Me",
  "style": "elevated",
  "icon": "add",
  "enabled": true,
  "onTap": {
    "type": "tool",
    "tool": "handleClick"
  }
}
```

| Property | Type | Description | Values |
|----------|------|-------------|---------|
| `label` | string | **Required.** Button text | - |
| `style` | string | Button style | `elevated`, `outlined`, `text` |
| `icon` | string | Optional icon | Icon name |
| `enabled` | boolean/string | Whether enabled (can be binding) | true |
| `onTap` | object | Tap action | Action object |

### TextField

Single-line text input.

```json
{
  "type": "textField",
  "label": "Username",
  "bindTo": "username",
  "initialValue": "",
  "placeholder": "Enter username",
  "enabled": true,
  "obscureText": false,
  "maxLength": 50,
  "keyboardType": "text",
  "validation": {
    "required": true,
    "minLength": 3,
    "pattern": "^[a-zA-Z0-9_]+$",
    "errorMessage": "Invalid username"
  },
  "onChanged": {
    "type": "setState",
    "updates": {"isDirty": true}
  }
}
```

| Property | Type | Description | Values |
|----------|------|-------------|---------|
| `label` | string | Field label | - |
| `bindTo` | string | **Required.** State binding path | - |
| `initialValue` | string | Initial value | "" |
| `placeholder` | string | Placeholder text | - |
| `enabled` | boolean | Whether enabled | true |
| `obscureText` | boolean | Hide text (passwords) | false |
| `maxLength` | number | Maximum characters | null |
| `keyboardType` | string | Keyboard type | `text`, `number`, `email`, `phone`, `url` |
| `validation` | object | Validation rules | - |
| `onChanged` | object | Change action | - |

### Checkbox

A toggleable checkbox.

```json
{
  "type": "checkbox",
  "label": "I agree to terms",
  "bindTo": "agreedToTerms",
  "tristate": false,
  "enabled": true,
  "onChange": {
    "type": "setState",
    "updates": {"canSubmit": "{{agreedToTerms}}"}
  }
}
```

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `label` | string | Checkbox label | - |
| `bindTo` | string | **Required.** State binding | - |
| `tristate` | boolean | Allow null state | false |
| `enabled` | boolean | Whether enabled | true |
| `onChange` | object | Change action | - |

### Switch

A toggle switch.

```json
{
  "type": "switch",
  "label": "Enable notifications",
  "bindTo": "notificationsEnabled",
  "enabled": true,
  "onChange": {
    "type": "tool",
    "tool": "updateSettings",
    "args": {"notifications": "{{notificationsEnabled}}"}
  }
}
```

Properties are similar to Checkbox.

### Slider

A value slider.

```json
{
  "type": "slider",
  "bindTo": "volume",
  "min": 0,
  "max": 100,
  "divisions": 10,
  "label": "{{volume}}",
  "enabled": true,
  "onChanged": {
    "type": "setState",
    "updates": {"volumePercent": "{{volume / 100}}"}
  }
}
```

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `bindTo` | string | **Required.** State binding | - |
| `min` | number | Minimum value | 0.0 |
| `max` | number | Maximum value | 1.0 |
| `divisions` | number | Discrete divisions | null (continuous) |
| `label` | string | Current value label | null |

### DropdownButton

A dropdown selection.

```json
{
  "type": "dropdownButton",
  "bindTo": "selectedCountry",
  "items": [
    {"value": "us", "label": "United States"},
    {"value": "uk", "label": "United Kingdom"},
    {"value": "ca", "label": "Canada"}
  ],
  "placeholder": "Select a country",
  "enabled": true,
  "onChanged": {
    "type": "tool",
    "tool": "loadStates",
    "args": {"country": "{{selectedCountry}}"}
  }
}
```

## List Widgets

### ListView

A scrollable list of widgets.

```json
{
  "type": "listView",
  "scrollDirection": "vertical",
  "padding": 8,
  "itemCount": "{{items.length}}",
  "itemBuilder": {
    "type": "listTile",
    "title": {
      "type": "text",
      "value": "{{items[index].name}}"
    },
    "subtitle": {
      "type": "text",
      "value": "{{items[index].description}}"
    },
    "onTap": {
      "type": "navigate",
      "route": "/detail",
      "params": {"id": "{{items[index].id}}"}
    }
  }
}
```

| Property | Type | Description | Values |
|----------|------|-------------|---------|
| `scrollDirection` | string | Scroll direction | `vertical`, `horizontal` |
| `padding` | number/object | List padding | 0 |
| `itemCount` | string/number | Number of items (binding) | **Required** |
| `itemBuilder` | object | Widget template for items | **Required** |

### ListTile

A standard list item.

```json
{
  "type": "listTile",
  "leading": {
    "type": "icon",
    "icon": "person"
  },
  "title": {
    "type": "text",
    "value": "John Doe"
  },
  "subtitle": {
    "type": "text",
    "value": "john.doe@example.com"
  },
  "trailing": {
    "type": "icon",
    "icon": "chevron_right"
  },
  "onTap": {
    "type": "tool",
    "tool": "selectUser"
  }
}
```

### GridView

A scrollable grid of widgets.

```json
{
  "type": "gridView",
  "crossAxisCount": 2,
  "mainAxisSpacing": 8,
  "crossAxisSpacing": 8,
  "padding": 16,
  "itemCount": "{{products.length}}",
  "itemBuilder": {
    "type": "container",
    "child": {
      "type": "column",
      "children": [
        {
          "type": "image",
          "source": "{{products[index].image}}"
        },
        {
          "type": "text",
          "value": "{{products[index].name}}"
        }
      ]
    }
  }
}
```

## Navigation Widgets

### AppBar

Application bar typically at the top.

```json
{
  "type": "appBar",
  "title": {
    "type": "text",
    "value": "My App"
  },
  "actions": [
    {
      "type": "iconButton",
      "icon": "search",
      "onTap": {
        "type": "navigate",
        "route": "/search"
      }
    }
  ],
  "backgroundColor": "#2196F3"
}
```

### BottomNavigationBar

Bottom navigation for switching between views.

```json
{
  "type": "bottomNavigationBar",
  "currentIndex": "{{currentTab}}",
  "items": [
    {
      "icon": "home",
      "label": "Home"
    },
    {
      "icon": "search",
      "label": "Search"
    },
    {
      "icon": "person",
      "label": "Profile"
    }
  ],
  "onTap": {
    "type": "setState",
    "updates": {"currentTab": "{{index}}"}
  }
}
```

### Drawer

Side navigation drawer.

```json
{
  "type": "drawer",
  "child": {
    "type": "listView",
    "children": [
      {
        "type": "drawerHeader",
        "child": {
          "type": "text",
          "value": "Menu"
        }
      },
      {
        "type": "listTile",
        "title": {"type": "text", "value": "Home"},
        "onTap": {
          "type": "navigate",
          "route": "/home"
        }
      }
    ]
  }
}
```

## Utility Widgets

### SingleChildScrollView

Makes a single child scrollable.

```json
{
  "type": "singleChildScrollView",
  "scrollDirection": "vertical",
  "padding": 16,
  "child": {
    "type": "column",
    "children": []
  }
}
```

### Card

A material design card.

```json
{
  "type": "card",
  "elevation": 4,
  "margin": 8,
  "child": {
    "type": "padding",
    "padding": 16,
    "child": {}
  }
}
```

### Divider

A horizontal line separator.

```json
{
  "type": "divider",
  "height": 1,
  "thickness": 1,
  "color": "#E0E0E0",
  "indent": 16,
  "endIndent": 16
}
```

### Spacer

Flexible space that expands.

```json
{
  "type": "spacer",
  "flex": 1
}
```

### Visibility

Conditionally shows/hides a child.

```json
{
  "type": "visibility",
  "visible": "{{showDetails}}",
  "child": {
    "type": "text",
    "value": "Details..."
  },
  "replacement": {
    "type": "text",
    "value": "Hidden"
  }
}
```

## Custom Widgets

You can register custom widgets:

```dart
runtime.widgetRegistry.register('myCustomWidget', MyCustomWidgetFactory());
```

Then use in definitions:

```json
{
  "type": "myCustomWidget",
  "customProperty": "value"
}
```

## Widget Binding Context

When inside list builders, additional context is available:

- `{{index}}` - Current item index
- `{{item}}` - Current item (if items is an array of objects)
- `{{[binding][index]}}` - Access array item by index

Example:
```json
{
  "type": "listView",
  "itemCount": "{{users.length}}",
  "itemBuilder": {
    "type": "text",
    "value": "{{users[index].name}} ({{index + 1}} of {{users.length}})"
  }
}
```