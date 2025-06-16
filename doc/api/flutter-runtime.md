# Flutter MCP UI Runtime API Reference

## Core Classes

### MCPUIRuntime

The main entry point for using the MCP UI Runtime in Flutter applications.

```dart
class MCPUIRuntime {
  MCPUIRuntime({bool enableDebugMode = false});
}
```

#### Properties

- `bool isInitialized` - Whether the runtime has been initialized
- `StateManager stateManager` - Access to the state management system
- `ThemeManager themeManager` - Access to theme management
- `RuntimeEngine? engine` - The underlying runtime engine

#### Methods

##### initialize
Initializes the runtime with a UI definition.

```dart
Future<void> initialize(
  Map<String, dynamic> definition, {
  Function(String)? pageLoader,
  bool useCache = true,
})
```

**Parameters:**
- `definition` - The UI definition (application or page)
- `pageLoader` - Function to load page definitions (required for applications)
- `useCache` - Whether to use caching for resources

**Example:**
```dart
final runtime = MCPUIRuntime();
await runtime.initialize(
  definition,
  pageLoader: (uri) async {
    final resource = await mcpClient.readResource(uri);
    return jsonDecode(resource.contents.first.text!);
  },
);
```

##### buildUI
Builds the UI widget from the loaded definition.

```dart
Widget buildUI({
  BuildContext? context,
  Map<String, dynamic>? initialState,
  Function(String, Map<String, dynamic>)? onToolCall,
  Function(String, String)? onResourceSubscribe,
  Function(String)? onResourceUnsubscribe,
})
```

**Parameters:**
- `context` - Build context (optional)
- `initialState` - Initial state values
- `onToolCall` - Handler for tool calls
- `onResourceSubscribe` - Handler for resource subscriptions
- `onResourceUnsubscribe` - Handler for unsubscribing

**Example:**
```dart
return runtime.buildUI(
  onToolCall: (tool, args) async {
    final result = await mcpClient.callTool(tool, args);
    // Handle result
  },
  onResourceSubscribe: (uri, binding) async {
    await mcpClient.subscribeResource(uri);
    runtime.registerResourceSubscription(uri, binding);
  },
);
```

##### handleNotification
Handles MCP notifications for resource updates.

```dart
Future<void> handleNotification(
  Map<String, dynamic> notification, {
  Function(String)? resourceReader,
})
```

**Parameters:**
- `notification` - The notification object with method and params
- `resourceReader` - Function to read resources (for standard mode)

**Example:**
```dart
mcpClient.onNotification('notifications/resources/updated', (params) async {
  await runtime.handleNotification({
    'method': 'notifications/resources/updated',
    'params': params,
  }, resourceReader: (uri) async {
    final resource = await mcpClient.readResource(uri);
    return resource.contents.first.text!;
  });
});
```

##### registerResourceSubscription
Registers a resource subscription for tracking.

```dart
void registerResourceSubscription(String uri, String binding)
```

##### updateState
Updates a state value directly.

```dart
void updateState(String binding, dynamic value)
```

##### destroy
Cleans up resources and destroys the runtime.

```dart
Future<void> destroy()
```

### RuntimeEngine

The core engine that powers the MCP UI Runtime.

```dart
class RuntimeEngine with ChangeNotifier {
  RuntimeEngine({bool enableDebugMode = false});
}
```

#### Key Properties

- `bool isInitialized` - Engine initialization status
- `bool isReady` - Whether engine is ready for rendering
- `ServiceRegistry services` - Access to registered services
- `StateManager stateManager` - State management
- `Renderer renderer` - Widget rendering engine
- `WidgetRegistry widgetRegistry` - Registered widget factories

### StateManager

Manages application and page state with reactive updates.

```dart
class StateManager extends ChangeNotifier {
  void set(String path, dynamic value);
  dynamic get(String path);
  void setState(Map<String, dynamic> newState);
  void update(String path, Function(dynamic) updater);
}
```

#### Methods

##### set
Sets a value at the specified path.

```dart
stateManager.set('user.name', 'John Doe');
stateManager.set('items[0].checked', true);
```

##### get
Gets a value from the specified path.

```dart
final userName = stateManager.get('user.name');
final isChecked = stateManager.get('items[0].checked');
```

##### setState
Replaces the entire state.

```dart
stateManager.setState({
  'user': {'name': 'Jane', 'age': 30},
  'theme': 'dark',
});
```

##### update
Updates a value using a function.

```dart
stateManager.update('counter', (current) => (current ?? 0) + 1);
```

### Renderer

Renders widgets from JSON definitions.

```dart
class Renderer {
  Widget renderWidget(
    Map<String, dynamic> definition,
    RenderContext context,
  );
  
  Widget renderPage(Map<String, dynamic> pageDefinition);
}
```

### WidgetRegistry

Registry for widget factories.

```dart
class WidgetRegistry {
  void register(String type, WidgetFactory factory);
  WidgetFactory? getFactory(String type);
  bool hasFactory(String type);
}
```

#### Registering Custom Widgets

```dart
runtime.widgetRegistry.register('customChart', CustomChartFactory());
```

### ActionHandler

Handles user actions and interactions.

```dart
class ActionHandler {
  void registerToolExecutor(String name, Function executor);
  Future<void> handleAction(
    dynamic action,
    RenderContext context,
  );
}
```

## Widget Definitions

### Common Widget Properties

All widgets support these common properties:

```dart
{
  "type": "widgetType",     // Required: Widget type
  "visible": true,          // Optional: Visibility
  "key": "uniqueKey",       // Optional: Widget key
  "testKey": "testId"       // Optional: Test identifier
}
```

### Layout Widgets

#### Column
```dart
{
  "type": "column",
  "mainAxisAlignment": "center",  // start, end, center, spaceBetween, spaceAround, spaceEvenly
  "crossAxisAlignment": "start",  // start, end, center, stretch
  "children": [...]
}
```

#### Row
```dart
{
  "type": "row",
  "mainAxisAlignment": "start",
  "crossAxisAlignment": "center",
  "children": [...]
}
```

#### Container
```dart
{
  "type": "container",
  "padding": 16,              // or {"left": 8, "right": 8, "top": 4, "bottom": 4}
  "margin": 8,
  "width": 200,
  "height": 100,
  "decoration": {
    "color": "#FFFFFF",
    "borderRadius": 8,
    "border": {
      "color": "#000000",
      "width": 1
    }
  },
  "child": {...}
}
```

### Display Widgets

#### Text
```dart
{
  "type": "text",
  "value": "Hello {{name}}",
  "style": {
    "fontSize": 16,
    "fontWeight": "bold",    // normal, bold
    "color": "#333333",
    "fontFamily": "Roboto"
  },
  "textAlign": "center"      // left, right, center, justify
}
```

#### Image
```dart
{
  "type": "image",
  "source": "https://example.com/image.png",
  "width": 200,
  "height": 200,
  "fit": "cover"            // fill, contain, cover, fitWidth, fitHeight, none
}
```

### Input Widgets

#### Button
```dart
{
  "type": "button",
  "label": "Click Me",
  "style": "elevated",      // elevated, outlined, text
  "onTap": {
    "type": "tool",
    "tool": "handleClick",
    "args": {"id": "{{itemId}}"}
  }
}
```

#### TextField
```dart
{
  "type": "textField",
  "label": "Enter name",
  "bindTo": "userName",
  "initialValue": "",
  "validation": {
    "required": true,
    "minLength": 3,
    "maxLength": 50,
    "pattern": "^[a-zA-Z ]+$",
    "errorMessage": "Please enter a valid name"
  }
}
```

#### Checkbox
```dart
{
  "type": "checkbox",
  "label": "I agree to terms",
  "bindTo": "agreedToTerms",
  "onChange": {
    "type": "setState",
    "updates": {"formValid": "{{agreedToTerms}}"}
  }
}
```

## Action Types

### Tool Action
Calls an MCP tool on the server.

```dart
{
  "type": "tool",
  "tool": "createUser",
  "args": {
    "name": "{{formData.name}}",
    "email": "{{formData.email}}"
  }
}
```

### State Action
Updates local state.

```dart
{
  "type": "setState",
  "updates": {
    "counter": "{{counter + 1}}",
    "lastUpdated": "{{timestamp()}}"
  }
}
```

### Navigation Action
Navigates to a different page.

```dart
{
  "type": "navigate",
  "route": "/profile",
  "params": {
    "userId": "{{selectedUser.id}}"
  }
}
```

### Resource Action
Manages resource subscriptions.

```dart
{
  "type": "resource",
  "action": "subscribe",    // subscribe or unsubscribe
  "uri": "data://temperature",
  "binding": "currentTemp"
}
```

## Data Binding

### Simple Binding
```dart
"{{userName}}"              // Simple property
"{{user.profile.name}}"     // Nested property
"{{items[0].title}}"        // Array access
"{{items.length}}"          // Array length
```

### Expression Binding
```dart
"{{price * quantity}}"      // Arithmetic
"{{firstName + ' ' + lastName}}"  // String concatenation
"{{isActive ? 'Active' : 'Inactive'}}"  // Ternary
"{{count > 0}}"            // Comparison
```

### Mixed Content
```dart
"Total: {{price * quantity}} USD"
"Welcome, {{user.name}}!"
```

## Services

### StateService
Manages application state.

```dart
final stateService = runtime.services.get<StateService>('state');
stateService.setState({'key': 'value'});
final value = stateService.getState('key');
```

### NavigationService
Handles navigation between pages.

```dart
final navService = runtime.services.get<NavigationService>('navigation');
navService.navigate('/profile', params: {'id': '123'});
```

### NotificationService
Manages in-app notifications.

```dart
final notificationService = runtime.services.get<NotificationService>('notifications');
notificationService.show(
  title: 'Success',
  message: 'Operation completed',
  type: NotificationType.success,
);
```

## Lifecycle Hooks

### Page Lifecycle
```dart
{
  "lifecycle": {
    "onInitialize": [{
      "type": "tool",
      "tool": "loadPageData"
    }],
    "onMount": [{
      "type": "resource",
      "action": "subscribe",
      "uri": "data://updates"
    }],
    "onUnmount": [{
      "type": "resource",
      "action": "unsubscribe",
      "uri": "data://updates"
    }]
  }
}
```

### Available Hooks
- `onInitialize` - When page/app is initialized
- `onReady` - When runtime is ready
- `onMount` - When page is mounted
- `onUnmount` - When page is unmounted
- `onDestroy` - When page/app is destroyed
- `onPause` - When app is paused
- `onResume` - When app is resumed

## Error Handling

### Widget Errors
If a widget fails to render, an error placeholder is shown:

```dart
ErrorWidget.builder = (FlutterErrorDetails details) {
  return Container(
    color: Colors.red.shade100,
    child: Center(
      child: Text('Widget Error: ${details.exception}'),
    ),
  );
};
```

### Action Errors
Handle errors in action callbacks:

```dart
onToolCall: (tool, args) async {
  try {
    final result = await mcpClient.callTool(tool, args);
    // Handle success
  } catch (e) {
    // Handle error
    runtime.stateManager.set('error', e.toString());
  }
}
```

## Testing

### Unit Testing
```dart
test('renders text widget', () {
  final runtime = MCPUIRuntime();
  final widget = runtime.renderer.renderWidget(
    {'type': 'text', 'value': 'Hello'},
    mockContext,
  );
  
  expect(widget, isA<Text>());
  expect((widget as Text).data, 'Hello');
});
```

### Widget Testing
```dart
testWidgets('button tap calls tool', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: runtime.buildUI(
        onToolCall: expectAsync2((tool, args) {
          expect(tool, 'increment');
        }),
      ),
    ),
  );
  
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
});
```

### Integration Testing
```dart
testWidgets('full app flow', (tester) async {
  final runtime = MCPUIRuntime();
  await runtime.initialize(appDefinition);
  
  await tester.pumpWidget(
    MaterialApp(home: runtime.buildUI()),
  );
  
  // Test navigation
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  
  expect(find.text('Settings Page'), findsOneWidget);
});
```