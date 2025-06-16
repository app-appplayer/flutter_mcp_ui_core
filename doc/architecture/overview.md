# Architecture Overview

## System Architecture

The MCP UI Runtime is designed as a modular, extensible system for rendering server-driven user interfaces. The architecture follows clean architecture principles with clear separation of concerns.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        MCP Server                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  Resources  │  │    Tools    │  │ Subscriptions│        │
│  │             │  │             │  │              │        │
│  │ • UI Defs   │  │ • Business  │  │ • Real-time  │        │
│  │ • Data      │  │   Logic     │  │   Updates    │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
                            │
                    ┌───────┴────────┐
                    │  MCP Protocol  │
                    │  (JSON-RPC)    │
                    └───────┬────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                    MCP UI Runtime                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Runtime   │  │  Renderer   │  │    State    │        │
│  │   Engine    │  │             │  │  Manager    │        │
│  │             │  │ • Widget    │  │             │        │
│  │ • Lifecycle │  │   Factory   │  │ • Bindings  │        │
│  │ • Services  │  │ • Bindings  │  │ • Updates   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
                            │
                    ┌───────┴────────┐
                    │  UI Framework  │
                    │(Flutter/React) │
                    └────────────────┘
```

## Core Components

### 1. Runtime Engine

The central orchestrator that manages the entire runtime lifecycle.

**Responsibilities:**
- Initialize and configure the runtime
- Manage service lifecycle
- Handle resource loading and caching
- Coordinate between components
- Process MCP notifications

**Key Classes:**
- `RuntimeEngine` - Main engine class
- `LifecycleManager` - Manages lifecycle events
- `ServiceRegistry` - Service dependency injection
- `CacheManager` - Resource and state caching

### 2. Renderer

Transforms JSON UI definitions into platform-specific widgets.

**Responsibilities:**
- Parse widget definitions
- Create widget instances
- Apply data bindings
- Handle user interactions
- Manage widget lifecycle

**Key Classes:**
- `Renderer` - Main rendering engine
- `WidgetRegistry` - Widget factory registration
- `WidgetFactory` - Individual widget creators
- `RenderContext` - Rendering state and utilities

### 3. State Manager

Manages application and page state with reactive updates.

**Responsibilities:**
- Store and retrieve state values
- Handle state mutations
- Notify listeners of changes
- Manage computed properties
- Support state persistence

**Key Classes:**
- `StateManager` - Core state container
- `StateService` - State access service
- `BindingEngine` - Data binding resolver

### 4. Action Handler

Processes user interactions and executes actions.

**Responsibilities:**
- Route actions to handlers
- Execute tool calls via MCP
- Update local state
- Handle navigation
- Manage async operations

**Key Classes:**
- `ActionHandler` - Action dispatcher
- `ToolExecutor` - MCP tool caller
- `NavigationService` - Route management

### 5. Resource Manager

Handles resource subscriptions and notifications.

**Responsibilities:**
- Subscribe to MCP resources
- Process notifications
- Update bound state values
- Manage subscription lifecycle
- Handle reconnection

**Key Classes:**
- `NotificationManager` - Notification processor
- `SubscriptionTracker` - Active subscription management

## Data Flow

### 1. Initial Load Flow

```
User Opens App
    │
    ├─> Initialize Runtime
    │       │
    │       ├─> Load Application Definition
    │       ├─> Initialize Services
    │       └─> Set Initial State
    │
    ├─> Load Initial Route
    │       │
    │       ├─> Fetch Page Resource
    │       ├─> Parse Page Definition
    │       └─> Initialize Page State
    │
    └─> Render UI
            │
            ├─> Create Widget Tree
            ├─> Apply Data Bindings
            └─> Display to User
```

### 2. User Interaction Flow

```
User Interaction (tap, input, etc.)
    │
    ├─> Action Handler
    │       │
    │       ├─> Identify Action Type
    │       │
    │       ├─> [Tool Action]
    │       │       │
    │       │       ├─> Call MCP Tool
    │       │       ├─> Process Response
    │       │       └─> Update State
    │       │
    │       ├─> [State Action]
    │       │       │
    │       │       └─> Update Local State
    │       │
    │       └─> [Navigation Action]
    │               │
    │               └─> Load New Page
    │
    └─> Re-render Affected Widgets
```

### 3. Subscription Flow

```
Subscribe to Resource
    │
    ├─> Send MCP Subscribe Request
    │
    ├─> Register Subscription
    │       │
    │       └─> Track URI → Binding
    │
    └─> Handle Notifications
            │
            ├─> [Standard Mode]
            │       │
            │       ├─> Receive URI
            │       ├─> Read Resource
            │       └─> Update State
            │
            └─> [Extended Mode]
                    │
                    ├─> Receive URI + Content
                    └─> Update State Directly
```

## Design Patterns

### 1. Factory Pattern

Used extensively for widget creation:

```dart
abstract class WidgetFactory {
  Widget create(Map<String, dynamic> definition, RenderContext context);
}

class TextWidgetFactory implements WidgetFactory {
  @override
  Widget create(Map<String, dynamic> definition, RenderContext context) {
    // Create text widget from definition
  }
}
```

### 2. Observer Pattern

For state management and reactive updates:

```dart
class StateManager extends ChangeNotifier {
  void set(String key, dynamic value) {
    _state[key] = value;
    notifyListeners();
  }
}
```

### 3. Strategy Pattern

For different subscription modes:

```dart
abstract class SubscriptionStrategy {
  Future<void> handleNotification(Map<String, dynamic> params);
}

class StandardModeStrategy implements SubscriptionStrategy {
  // Handle URI-only notifications
}

class ExtendedModeStrategy implements SubscriptionStrategy {
  // Handle notifications with content
}
```

### 4. Dependency Injection

Via service registry:

```dart
class ServiceRegistry {
  void register<T>(String name, T service) {
    _services[name] = service;
  }
  
  T? get<T>(String name) {
    return _services[name] as T?;
  }
}
```

## Extension Points

### 1. Custom Widgets

Register custom widget factories:

```dart
runtime.widgetRegistry.register('customChart', CustomChartFactory());
```

### 2. Custom Actions

Add custom action handlers:

```dart
runtime.actionHandler.registerHandler('customAction', (args) async {
  // Handle custom action
});
```

### 3. State Transformers

Add computed properties:

```dart
runtime.stateManager.addComputed('fullName', 
  ['firstName', 'lastName'], 
  (first, last) => '$first $last'
);
```

### 4. Middleware

Intercept and modify behavior:

```dart
runtime.addMiddleware(LoggingMiddleware());
runtime.addMiddleware(AnalyticsMiddleware());
```

## Performance Optimizations

### 1. Widget Diffing

Only rebuild widgets that have changed:
- Deep equality checks on widget definitions
- Memoization of unchanged subtrees
- Key-based widget identity

### 2. State Updates

Efficient state change propagation:
- Fine-grained listeners per state key
- Batched updates within frame
- Debounced high-frequency changes

### 3. Resource Caching

Multi-level caching strategy:
- In-memory cache for active resources
- Persistent cache for offline support
- Smart cache invalidation

### 4. Lazy Loading

Load resources on demand:
- Page definitions loaded when navigated
- Images loaded when visible
- Large lists virtualized

## Security Considerations

### 1. Input Validation

- Validate all widget definitions
- Sanitize user inputs
- Validate tool arguments

### 2. Resource Access

- Verify resource permissions
- Validate URI schemes
- Prevent path traversal

### 3. State Isolation

- Page-level state isolation
- Secure state persistence
- Prevent state injection

## Testing Strategy

### 1. Unit Tests

- Widget factories
- State management
- Action handlers
- Binding resolution

### 2. Integration Tests

- Full UI rendering
- Resource subscriptions
- Navigation flows
- State persistence

### 3. Performance Tests

- Large widget trees
- High-frequency updates
- Memory usage
- Cache efficiency

## Future Enhancements

### 1. Plugin System

- Dynamic widget loading
- Third-party integrations
- Custom protocols

### 2. Advanced Features

- Animation support
- Gesture recognition
- Offline sync
- Conflict resolution

### 3. Developer Tools

- Visual UI builder
- State inspector
- Performance profiler
- Debug overlay