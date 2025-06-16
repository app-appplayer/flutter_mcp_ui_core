# Creating Custom Widgets

This guide explains how to create and register custom widgets in the MCP UI Runtime.

## Overview

The MCP UI Runtime provides a flexible widget system that allows you to create custom widgets for specialized functionality. Custom widgets integrate seamlessly with the existing widget ecosystem and support all standard features like data binding, actions, and styling.

## Creating a Widget Factory

All widgets are created through factory classes that implement the `WidgetFactory` interface.

### Basic Structure

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';

class CustomChartFactory implements WidgetFactory {
  @override
  String get type => 'customChart';

  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    // Extract properties from definition
    final data = context.resolveBinding(definition['data']);
    final title = context.resolveBinding(definition['title']) ?? '';
    final height = definition['height']?.toDouble() ?? 200.0;
    
    // Create and return your custom widget
    return CustomChartWidget(
      data: data,
      title: title,
      height: height,
    );
  }
}
```

### Using RenderContext

The `RenderContext` provides access to essential runtime services:

```dart
Widget create(Map<String, dynamic> definition, RenderContext context) {
  // Resolve data bindings
  final value = context.resolveBinding(definition['value']);
  
  // Access state
  final currentTheme = context.getState('theme');
  
  // Get theme manager
  final primaryColor = context.themeManager.primaryColor;
  
  // Render child widgets
  final child = definition['child'] != null
      ? context.renderer.renderWidget(definition['child'], context)
      : null;
  
  // Handle actions
  if (definition['onTap'] != null) {
    return GestureDetector(
      onTap: () => context.handleAction(definition['onTap']),
      child: MyWidget(value: value),
    );
  }
  
  return MyWidget(value: value);
}
```

## Registering Custom Widgets

Register your custom widget factory with the runtime:

```dart
// During runtime initialization
final runtime = MCPUIRuntime();
runtime.engine.widgetRegistry.register('customChart', CustomChartFactory());

// Or after initialization
runtime.widgetRegistry.register('customChart', CustomChartFactory());
```

## Complete Example: Rating Widget

Here's a complete example of a custom star rating widget:

### 1. Define the Widget Factory

```dart
class RatingWidgetFactory implements WidgetFactory {
  @override
  String get type => 'rating';

  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    // Extract properties
    final bindTo = definition['bindTo'] as String?;
    final maxRating = definition['maxRating']?.toInt() ?? 5;
    final size = definition['size']?.toDouble() ?? 30.0;
    final color = definition['color'] ?? '#FFB800';
    final readOnly = context.resolveBinding(definition['readOnly']) ?? false;
    
    // Get current value from state
    final currentRating = bindTo != null
        ? (context.getState(bindTo) ?? 0.0).toDouble()
        : 0.0;
    
    // Handle change action
    final onChange = definition['onChange'];
    
    return RatingWidget(
      value: currentRating,
      maxRating: maxRating,
      size: size,
      color: _parseColor(color),
      readOnly: readOnly,
      onChanged: readOnly || bindTo == null ? null : (rating) {
        // Update state
        context.stateManager.set(bindTo, rating);
        
        // Execute onChange action if provided
        if (onChange != null) {
          context.handleAction(onChange);
        }
      },
    );
  }
  
  Color _parseColor(dynamic color) {
    if (color is String && color.startsWith('#')) {
      return Color(int.parse(color.substring(1), radix: 16) | 0xFF000000);
    }
    return Colors.amber;
  }
}
```

### 2. Create the Flutter Widget

```dart
class RatingWidget extends StatelessWidget {
  final double value;
  final int maxRating;
  final double size;
  final Color color;
  final bool readOnly;
  final ValueChanged<double>? onChanged;

  const RatingWidget({
    Key? key,
    required this.value,
    required this.maxRating,
    required this.size,
    required this.color,
    required this.readOnly,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final rating = index + 1.0;
        final filled = rating <= value;
        
        return GestureDetector(
          onTap: readOnly ? null : () => onChanged?.call(rating),
          child: Icon(
            filled ? Icons.star : Icons.star_border,
            size: size,
            color: color,
          ),
        );
      }),
    );
  }
}
```

### 3. Register the Widget

```dart
void main() async {
  final runtime = MCPUIRuntime();
  
  // Register custom widget
  runtime.engine.widgetRegistry.register('rating', RatingWidgetFactory());
  
  // Initialize runtime
  await runtime.initialize(definition);
  
  runApp(MyApp(runtime: runtime));
}
```

### 4. Use in UI Definition

```json
{
  "type": "page",
  "content": {
    "type": "column",
    "children": [
      {
        "type": "text",
        "value": "Rate this product:"
      },
      {
        "type": "rating",
        "bindTo": "productRating",
        "maxRating": 5,
        "size": 40,
        "color": "#FFB800",
        "onChange": {
          "type": "tool",
          "tool": "submitRating",
          "args": {
            "productId": "{{productId}}",
            "rating": "{{productRating}}"
          }
        }
      },
      {
        "type": "text",
        "value": "Your rating: {{productRating}} stars"
      }
    ]
  },
  "state": {
    "initial": {
      "productRating": 0,
      "productId": "12345"
    }
  }
}
```

## Advanced Features

### Supporting Child Widgets

For container-like custom widgets:

```dart
Widget create(Map<String, dynamic> definition, RenderContext context) {
  final children = definition['children'] as List?;
  
  final childWidgets = children?.map((childDef) {
    return context.renderer.renderWidget(
      childDef as Map<String, dynamic>,
      context,
    );
  }).toList() ?? [];
  
  return CustomContainer(children: childWidgets);
}
```

### Handling Complex Actions

```dart
Widget create(Map<String, dynamic> definition, RenderContext context) {
  final actions = definition['actions'] as Map<String, dynamic>?;
  
  return CustomWidget(
    onEvent: (eventType) async {
      final action = actions?[eventType];
      if (action != null) {
        await context.handleAction(action);
      }
    },
  );
}
```

### State Management Integration

```dart
class StatefulWidgetFactory implements WidgetFactory {
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    final stateKey = definition['stateKey'] as String;
    
    return AnimatedBuilder(
      animation: context.stateManager,
      builder: (context, child) {
        final value = context.stateManager.get(stateKey);
        return CustomWidget(value: value);
      },
    );
  }
}
```

### Validation Support

```dart
Widget create(Map<String, dynamic> definition, RenderContext context) {
  final validation = definition['validation'] as Map<String, dynamic>?;
  final bindTo = definition['bindTo'] as String;
  
  return CustomInput(
    onChanged: (value) {
      // Validate
      if (validation != null) {
        final error = _validate(value, validation);
        context.stateManager.set('$bindTo.error', error);
      }
      
      // Update value
      context.stateManager.set(bindTo, value);
    },
  );
}

String? _validate(dynamic value, Map<String, dynamic> rules) {
  if (rules['required'] == true && (value == null || value.toString().isEmpty)) {
    return rules['errorMessage'] ?? 'This field is required';
  }
  
  if (rules['minLength'] != null && value.toString().length < rules['minLength']) {
    return rules['errorMessage'] ?? 'Too short';
  }
  
  return null;
}
```

## Best Practices

### 1. Property Handling

Always provide sensible defaults:

```dart
final fontSize = definition['fontSize']?.toDouble() ?? 16.0;
final color = definition['color'] ?? '#000000';
final enabled = context.resolveBinding(definition['enabled']) ?? true;
```

### 2. Binding Resolution

Always resolve bindings for dynamic values:

```dart
// Wrong
final text = definition['text'] as String;

// Correct
final text = context.resolveBinding(definition['text'])?.toString() ?? '';
```

### 3. Error Handling

Handle missing or invalid properties gracefully:

```dart
Widget create(Map<String, dynamic> definition, RenderContext context) {
  try {
    final requiredProp = definition['required'];
    if (requiredProp == null) {
      return ErrorWidget('Missing required property');
    }
    
    return MyWidget(prop: requiredProp);
  } catch (e) {
    return ErrorWidget('Error creating widget: $e');
  }
}
```

### 4. Performance

Cache expensive computations:

```dart
class ChartFactory implements WidgetFactory {
  final _processedDataCache = <String, ProcessedData>{};
  
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    final dataKey = definition['dataKey'] as String;
    final rawData = context.getState(dataKey);
    
    // Use cached processed data if available
    final cacheKey = '$dataKey:${rawData.hashCode}';
    final processedData = _processedDataCache[cacheKey] ??= 
        _processData(rawData);
    
    return ChartWidget(data: processedData);
  }
}
```

### 5. Testing

Write tests for your custom widgets:

```dart
void main() {
  group('RatingWidgetFactory', () {
    late MockRenderContext context;
    late RatingWidgetFactory factory;
    
    setUp(() {
      context = MockRenderContext();
      factory = RatingWidgetFactory();
    });
    
    test('creates widget with default properties', () {
      final widget = factory.create({
        'bindTo': 'rating',
      }, context);
      
      expect(widget, isA<RatingWidget>());
      expect((widget as RatingWidget).maxRating, 5);
      expect(widget.size, 30.0);
    });
    
    test('handles state binding', () {
      when(context.getState('userRating')).thenReturn(3.5);
      
      final widget = factory.create({
        'bindTo': 'userRating',
      }, context) as RatingWidget;
      
      expect(widget.value, 3.5);
    });
  });
}
```

## Common Patterns

### Wrapper Widgets

Create widgets that enhance existing ones:

```dart
class TooltipWrapperFactory implements WidgetFactory {
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    final message = context.resolveBinding(definition['tooltip']) ?? '';
    final child = context.renderer.renderWidget(
      definition['child'] as Map<String, dynamic>,
      context,
    );
    
    return Tooltip(
      message: message,
      child: child,
    );
  }
}
```

### Composite Widgets

Build complex widgets from simpler ones:

```dart
class UserCardFactory implements WidgetFactory {
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    final user = context.resolveBinding(definition['user']);
    
    // Build using existing widgets
    final cardDefinition = {
      'type': 'card',
      'child': {
        'type': 'padding',
        'padding': 16,
        'child': {
          'type': 'row',
          'children': [
            {
              'type': 'image',
              'source': user['avatar'],
              'width': 60,
              'height': 60,
            },
            {
              'type': 'sizedBox',
              'width': 16,
            },
            {
              'type': 'column',
              'crossAxisAlignment': 'start',
              'children': [
                {
                  'type': 'text',
                  'value': user['name'],
                  'style': {'fontSize': 18, 'fontWeight': 'bold'},
                },
                {
                  'type': 'text',
                  'value': user['email'],
                  'style': {'color': '#666666'},
                },
              ],
            },
          ],
        },
      },
    };
    
    return context.renderer.renderWidget(cardDefinition, context);
  }
}
```

## Debugging

Enable debug mode to see detailed logs:

```dart
class CustomWidgetFactory implements WidgetFactory {
  final bool debugMode;
  
  CustomWidgetFactory({this.debugMode = false});
  
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    if (debugMode) {
      print('[CustomWidget] Definition: $definition');
      print('[CustomWidget] Resolved value: ${context.resolveBinding(definition['value'])}');
    }
    
    // Widget creation logic...
  }
}
```

## Next Steps

- See [Widget Reference](../api/widget-reference.md) for built-in widgets
- Check [Examples](../examples/) for more custom widget examples
- Read [Testing Guide](./testing.md) for testing custom widgets