# Advanced Topics

This guide covers advanced features and techniques for building sophisticated applications with MCP UI Runtime.

## State Management Patterns

### Computed Properties

Define derived state values that automatically update:

```json
{
  "state": {
    "initial": {
      "items": [],
      "filter": "all"
    },
    "computed": {
      "filteredItems": "{{filter === 'all' ? items : items.filter(i => i.status === filter)}}",
      "completedCount": "{{items.filter(i => i.completed).length}}",
      "pendingCount": "{{items.length - completedCount}}"
    }
  }
}
```

### State Watchers

React to state changes with watchers:

```json
{
  "state": {
    "watchers": [
      {
        "watch": "user.isAuthenticated",
        "actions": [
          {
            "type": "conditional",
            "condition": "{{!user.isAuthenticated}}",
            "then": {
              "type": "navigate",
              "route": "/login"
            }
          }
        ]
      }
    ]
  }
}
```

### Global vs Local State

Manage state at different scopes:

```dart
// Global application state
{
  "type": "application",
  "state": {
    "initial": {
      "user": null,
      "theme": "light",
      "language": "en"
    }
  }
}

// Page-specific state
{
  "type": "page",
  "state": {
    "initial": {
      "formData": {},
      "isSubmitting": false
    }
  }
}
```

Access global state from pages:

```json
{
  "type": "text",
  "value": "Welcome {{$global.user.name}}"
}
```

## Advanced Subscription Patterns

### Conditional Subscriptions

Subscribe based on state:

```json
{
  "type": "container",
  "visible": "{{monitoringEnabled}}",
  "child": {
    "type": "text",
    "value": "Temperature: {{temperature}}°C"
  },
  "lifecycle": {
    "onMount": [
      {
        "type": "conditional",
        "condition": "{{monitoringEnabled}}",
        "then": {
          "type": "resource",
          "action": "subscribe",
          "uri": "data://temperature",
          "binding": "temperature"
        }
      }
    ],
    "onUnmount": [
      {
        "type": "resource",
        "action": "unsubscribe",
        "uri": "data://temperature"
      }
    ]
  }
}
```

### Multiple Subscriptions

Handle multiple data streams:

```dart
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final subscriptions = <String, String>{
    'data://temperature': 'currentTemp',
    'data://humidity': 'currentHumidity',
    'data://pressure': 'currentPressure',
  };
  
  @override
  void initState() {
    super.initState();
    _subscribeAll();
  }
  
  Future<void> _subscribeAll() async {
    for (final entry in subscriptions.entries) {
      await widget.mcpClient.subscribeResource(entry.key);
      widget.runtime.registerResourceSubscription(entry.key, entry.value);
    }
  }
  
  @override
  void dispose() {
    for (final uri in subscriptions.keys) {
      widget.mcpClient.unsubscribeResource(uri);
    }
    super.dispose();
  }
}
```

### Subscription Optimization

Use extended mode for high-frequency updates:

```dart
// Server implementation
class OptimizedServer {
  // Batch updates for efficiency
  final _pendingUpdates = <String, dynamic>{};
  Timer? _batchTimer;
  
  void queueUpdate(String uri, dynamic data) {
    _pendingUpdates[uri] = data;
    
    _batchTimer?.cancel();
    _batchTimer = Timer(Duration(milliseconds: 16), () {
      // Send all updates in one batch
      for (final entry in _pendingUpdates.entries) {
        server.notifyResourceUpdated(
          entry.key,
          content: ResourceContent(
            uri: entry.key,
            text: jsonEncode(entry.value),
          ),
        );
      }
      _pendingUpdates.clear();
    });
  }
}
```

## Complex UI Patterns

### Dynamic Forms

Build forms with dynamic fields:

```json
{
  "type": "page",
  "content": {
    "type": "column",
    "children": [
      {
        "type": "text",
        "value": "Dynamic Form",
        "style": {"fontSize": 24}
      },
      {
        "type": "listView",
        "shrinkWrap": true,
        "itemCount": "{{formFields.length}}",
        "itemBuilder": {
          "type": "container",
          "padding": 8,
          "child": {
            "type": "conditional",
            "condition": "{{formFields[index].type}}",
            "cases": {
              "text": {
                "type": "textField",
                "label": "{{formFields[index].label}}",
                "bindTo": "formData.{{formFields[index].name}}"
              },
              "number": {
                "type": "textField",
                "label": "{{formFields[index].label}}",
                "keyboardType": "number",
                "bindTo": "formData.{{formFields[index].name}}"
              },
              "boolean": {
                "type": "checkbox",
                "label": "{{formFields[index].label}}",
                "bindTo": "formData.{{formFields[index].name}}"
              },
              "select": {
                "type": "dropdownButton",
                "bindTo": "formData.{{formFields[index].name}}",
                "items": "{{formFields[index].options}}",
                "placeholder": "{{formFields[index].label}}"
              }
            }
          }
        }
      }
    ]
  },
  "state": {
    "initial": {
      "formFields": [],
      "formData": {}
    }
  },
  "lifecycle": {
    "onInitialize": [
      {
        "type": "tool",
        "tool": "loadFormDefinition"
      }
    ]
  }
}
```

### Master-Detail Pattern

Implement responsive master-detail views:

```json
{
  "type": "page",
  "content": {
    "type": "row",
    "children": [
      {
        "type": "expanded",
        "flex": 1,
        "child": {
          "type": "listView",
          "itemCount": "{{items.length}}",
          "itemBuilder": {
            "type": "listTile",
            "title": {"type": "text", "value": "{{items[index].name}}"},
            "selected": "{{selectedIndex === index}}",
            "onTap": {
              "type": "setState",
              "updates": {"selectedIndex": "{{index}}"}
            }
          }
        }
      },
      {
        "type": "expanded",
        "flex": 2,
        "child": {
          "type": "conditional",
          "condition": "{{selectedIndex !== null}}",
          "then": {
            "type": "container",
            "padding": 16,
            "child": {
              "type": "column",
              "children": [
                {"type": "text", "value": "{{items[selectedIndex].name}}"},
                {"type": "text", "value": "{{items[selectedIndex].description}}"}
              ]
            }
          },
          "else": {
            "type": "center",
            "child": {"type": "text", "value": "Select an item"}
          }
        }
      }
    ]
  }
}
```

### Wizard/Stepper Pattern

Multi-step forms with validation:

```json
{
  "type": "page",
  "content": {
    "type": "column",
    "children": [
      {
        "type": "linearProgressIndicator",
        "value": "{{(currentStep + 1) / totalSteps}}"
      },
      {
        "type": "expanded",
        "child": {
          "type": "indexedStack",
          "index": "{{currentStep}}",
          "children": [
            {
              "type": "container",
              "padding": 16,
              "child": {
                "type": "column",
                "children": [
                  {"type": "text", "value": "Step 1: Basic Info"},
                  {
                    "type": "textField",
                    "label": "Name",
                    "bindTo": "wizardData.name",
                    "validation": {"required": true}
                  }
                ]
              }
            },
            {
              "type": "container",
              "padding": 16,
              "child": {
                "type": "column",
                "children": [
                  {"type": "text", "value": "Step 2: Details"},
                  {
                    "type": "textField",
                    "label": "Email",
                    "bindTo": "wizardData.email",
                    "validation": {"required": true, "email": true}
                  }
                ]
              }
            }
          ]
        }
      },
      {
        "type": "row",
        "mainAxisAlignment": "spaceBetween",
        "children": [
          {
            "type": "button",
            "label": "Previous",
            "enabled": "{{currentStep > 0}}",
            "onTap": {
              "type": "setState",
              "updates": {"currentStep": "{{currentStep - 1}}"}
            }
          },
          {
            "type": "button",
            "label": "{{currentStep < totalSteps - 1 ? 'Next' : 'Submit'}}",
            "onTap": {
              "type": "conditional",
              "condition": "{{currentStep < totalSteps - 1}}",
              "then": {
                "type": "setState",
                "updates": {"currentStep": "{{currentStep + 1}}"}
              },
              "else": {
                "type": "tool",
                "tool": "submitWizard",
                "args": {"data": "{{wizardData}}"}
              }
            }
          }
        ]
      }
    ]
  },
  "state": {
    "initial": {
      "currentStep": 0,
      "totalSteps": 2,
      "wizardData": {}
    }
  }
}
```

## Performance Optimization

### Lazy Loading

Load content on demand:

```dart
class LazyImageFactory implements WidgetFactory {
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    final source = context.resolveBinding(definition['source']);
    final placeholder = definition['placeholder'];
    
    return FutureBuilder<ui.Image>(
      future: _loadImage(source),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RawImage(image: snapshot.data);
        }
        return placeholder != null
            ? Image.asset(placeholder)
            : CircularProgressIndicator();
      },
    );
  }
}
```

### Virtual Scrolling

Handle large lists efficiently:

```json
{
  "type": "listView",
  "cacheExtent": 200,
  "itemExtent": 80,
  "itemCount": "{{items.length}}",
  "itemBuilder": {
    "type": "container",
    "height": 80,
    "child": {
      "type": "listTile",
      "title": {"type": "text", "value": "{{items[index].title}}"}
    }
  }
}
```

### Memoization

Cache expensive computations:

```dart
class MemoizedRenderer {
  final _cache = <String, Widget>{};
  
  Widget renderWithCache(
    Map<String, dynamic> definition,
    RenderContext context,
  ) {
    final cacheKey = _generateCacheKey(definition, context);
    
    return _cache[cacheKey] ??= _renderWidget(definition, context);
  }
  
  String _generateCacheKey(
    Map<String, dynamic> definition,
    RenderContext context,
  ) {
    // Create unique key based on definition and relevant state
    final relevantState = _extractRelevantState(definition, context);
    return '${definition.hashCode}:${relevantState.hashCode}';
  }
}
```

## Security Best Practices

### Input Validation

Always validate on both client and server:

```dart
// Client-side validation in widget factory
class SecureInputFactory implements WidgetFactory {
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    final validation = definition['validation'] as Map<String, dynamic>?;
    
    return TextFormField(
      validator: (value) {
        if (validation != null) {
          return _validate(value, validation);
        }
        return null;
      },
      inputFormatters: [
        if (validation?['maxLength'] != null)
          LengthLimitingTextInputFormatter(validation!['maxLength']),
        if (validation?['pattern'] != null)
          FilteringTextInputFormatter.allow(
            RegExp(validation!['pattern']),
          ),
      ],
    );
  }
}

// Server-side validation
server.addTool(
  name: 'submitForm',
  handler: (args) async {
    final data = args['data'] as Map<String, dynamic>;
    
    // Validate all inputs
    final errors = <String, String>{};
    
    if (data['email'] != null && !isValidEmail(data['email'])) {
      errors['email'] = 'Invalid email address';
    }
    
    if (errors.isNotEmpty) {
      return CallToolResult(
        content: [TextContent(text: jsonEncode({
          'success': false,
          'errors': errors,
        }))],
      );
    }
    
    // Process valid data...
  },
);
```

### Safe Action Handling

Prevent action injection:

```dart
class SafeActionHandler {
  final _allowedTools = <String>{
    'increment',
    'decrement',
    'submitForm',
    // Explicitly list allowed tools
  };
  
  Future<void> handleAction(dynamic action) async {
    if (action is Map && action['type'] == 'tool') {
      final tool = action['tool'] as String?;
      
      if (tool == null || !_allowedTools.contains(tool)) {
        throw SecurityException('Unauthorized tool: $tool');
      }
    }
    
    // Process safe action...
  }
}
```

## Testing Strategies

### Integration Tests

Test complete user flows:

```dart
testWidgets('complete checkout flow', (tester) async {
  final runtime = MCPUIRuntime();
  await runtime.initialize(checkoutAppDefinition);
  
  await tester.pumpWidget(
    MaterialApp(home: runtime.buildUI()),
  );
  
  // Add item to cart
  await tester.tap(find.text('Add to Cart'));
  await tester.pumpAndSettle();
  
  // Navigate to checkout
  await tester.tap(find.text('Checkout'));
  await tester.pumpAndSettle();
  
  // Fill shipping info
  await tester.enterText(
    find.byKey(Key('shipping-name')),
    'John Doe',
  );
  
  // Complete order
  await tester.tap(find.text('Place Order'));
  await tester.pumpAndSettle();
  
  // Verify success
  expect(find.text('Order Confirmed'), findsOneWidget);
});
```

### Performance Tests

Measure and optimize performance:

```dart
testWidgets('renders large list efficiently', (tester) async {
  final runtime = MCPUIRuntime();
  
  // Create large dataset
  final items = List.generate(1000, (i) => {
    'id': i,
    'title': 'Item $i',
  });
  
  await runtime.initialize({
    'type': 'page',
    'content': {
      'type': 'listView',
      'itemCount': '{{items.length}}',
      'itemBuilder': {
        'type': 'text',
        'value': '{{items[index].title}}',
      },
    },
    'state': {
      'initial': {'items': items},
    },
  });
  
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpWidget(
    MaterialApp(home: runtime.buildUI()),
  );
  
  stopwatch.stop();
  
  // Should render in reasonable time
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
  
  // Should only render visible items
  expect(find.byType(Text), findsNWidgets(lessThan(20)));
});
```

## Debugging Tools

### Custom Debug Overlay

Add debug information to your app:

```dart
class DebugOverlay extends StatelessWidget {
  final MCPUIRuntime runtime;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        runtime.buildUI(),
        if (kDebugMode)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'State Keys: ${runtime.stateManager.keys.length}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Subscriptions: ${runtime.engine.subscriptionCount}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Widgets: ${runtime.engine.widgetCount}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
```

### State Inspector

Inspect and modify state at runtime:

```dart
class StateInspector extends StatelessWidget {
  final StateManager stateManager;
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: AnimatedBuilder(
        animation: stateManager,
        builder: (context, child) {
          final state = stateManager.toJson();
          
          return ListView(
            children: [
              DrawerHeader(
                child: Text('State Inspector'),
              ),
              ...state.entries.map((entry) => ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value.toString()),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editValue(context, entry.key),
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}
```

## Next Steps

- Explore [Examples](../examples/) for complete applications
- Read [Performance Guide](./performance.md) for optimization tips
- Check [Troubleshooting](./troubleshooting.md) for common issues