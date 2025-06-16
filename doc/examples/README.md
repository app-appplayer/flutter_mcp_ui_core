# MCP UI Runtime Examples

This directory contains example applications demonstrating various features and patterns of the MCP UI Runtime.

## Basic Examples

### 1. [Hello World](./hello-world.md)
The simplest possible MCP UI application displaying static text.

### 2. [Counter App](./counter-app.md)
Interactive counter with increment/decrement buttons demonstrating state management and tool calls.

### 3. [Form Example](./form-example.md)
Complete form with validation, various input types, and submission handling.

## Intermediate Examples

### 4. [Real-Time Dashboard](./realtime-dashboard.md)
Dashboard with live data updates using resource subscriptions.

### 5. [Multi-Page App](./multi-page-app.md)
Application with navigation, routing, and multiple pages.

### 6. [Todo List](./todo-list.md)
Classic todo application with CRUD operations and state persistence.

## Advanced Examples

### 7. [E-Commerce App](./ecommerce-app.md)
Complete shopping application with product catalog, cart, and checkout flow.

### 8. [Chat Application](./chat-app.md)
Real-time messaging app with subscriptions and dynamic UI updates.

### 9. [Data Visualization](./data-visualization.md)
Dashboard with custom chart widgets and real-time data updates.

## Running the Examples

### Prerequisites

1. Flutter SDK (>= 3.0.0)
2. Dart SDK (>= 3.0.0)
3. MCP Server implementation

### Setup

1. Clone the repository:
```bash
git clone https://github.com/makemind/mcp-ui-runtime
cd mcp-ui-runtime/examples
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the MCP server:
```bash
dart run bin/example_server.dart
```

4. Run the Flutter client:
```bash
flutter run
```

### Project Structure

Each example follows this structure:
```
example_name/
├── server/
│   └── server.dart       # MCP server implementation
├── client/
│   └── main.dart         # Flutter client
├── shared/
│   └── definitions.dart  # UI definitions
└── README.md             # Example documentation
```

## Key Concepts Demonstrated

### State Management
- Local component state
- Global application state
- Computed properties
- State persistence

### Data Binding
- Simple property binding
- Expression evaluation
- Two-way binding
- Conditional rendering

### Actions
- Tool calls to server
- Local state updates
- Navigation actions
- Composite actions

### Subscriptions
- Standard mode (URI only)
- Extended mode (with content)
- Multiple subscriptions
- Conditional subscriptions

### Custom Widgets
- Creating widget factories
- Registering custom widgets
- Complex widget composition
- Performance optimization

## Common Patterns

### Loading States
```json
{
  "type": "conditional",
  "condition": "{{isLoading}}",
  "then": {
    "type": "center",
    "child": {"type": "circularProgressIndicator"}
  },
  "else": {
    "type": "listView",
    "itemCount": "{{items.length}}",
    "itemBuilder": {...}
  }
}
```

### Error Handling
```json
{
  "type": "conditional",
  "condition": "{{error !== null}}",
  "then": {
    "type": "container",
    "padding": 16,
    "decoration": {"color": "#FFEBEE"},
    "child": {
      "type": "text",
      "value": "Error: {{error}}",
      "style": {"color": "#C62828"}
    }
  }
}
```

### Form Validation
```json
{
  "type": "textField",
  "bindTo": "email",
  "validation": {
    "required": true,
    "pattern": "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$",
    "errorMessage": "Please enter a valid email"
  }
}
```

### Responsive Layouts
```json
{
  "type": "layoutBuilder",
  "builder": {
    "type": "conditional",
    "condition": "{{screenWidth > 600}}",
    "then": {
      "type": "row",
      "children": [...]
    },
    "else": {
      "type": "column",
      "children": [...]
    }
  }
}
```

## Tips for Creating Examples

1. **Start Simple**: Begin with basic functionality and gradually add features
2. **Comment Code**: Add helpful comments explaining key concepts
3. **Error Handling**: Always include proper error handling
4. **Performance**: Demonstrate performance best practices
5. **Documentation**: Include clear README with setup instructions

## Contributing Examples

We welcome contributions! To add a new example:

1. Create a new directory with your example name
2. Follow the standard project structure
3. Include comprehensive documentation
4. Add your example to this README
5. Submit a pull request

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for more details.