# Getting Started with MCP UI Runtime

This guide will help you get started with the MCP UI Runtime for building server-driven user interfaces.

## Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Basic knowledge of Flutter and Dart
- Understanding of JSON

## Installation

### 1. Add Dependencies

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_mcp_ui_runtime: ^1.0.0
  mcp_client: ^0.1.0
```

### 2. Install Packages

```bash
flutter pub get
```

## Quick Start

### 1. Create a Simple MCP Server

First, create a simple MCP server that provides UI definitions:

```dart
// server.dart
import 'package:mcp_server/mcp_server.dart';

void main() async {
  final server = McpServer.createServer(
    McpServerConfig(
      name: 'My UI Server',
      version: '1.0.0',
      capabilities: ServerCapabilities(
        resources: ResourcesCapability(),
      ),
    ),
  );

  // Add a simple page resource
  server.addResource(
    uri: 'ui://pages/hello',
    name: 'Hello Page',
    mimeType: 'application/json',
    handler: (uri, params) async {
      return ReadResourceResult(
        contents: [
          ResourceContentInfo(
            uri: uri,
            mimeType: 'application/json',
            text: '''
            {
              "type": "page",
              "content": {
                "type": "center",
                "child": {
                  "type": "text",
                  "value": "Hello, MCP UI!",
                  "style": {"fontSize": 24}
                }
              }
            }
            ''',
          ),
        ],
      );
    },
  );

  // Connect to transport
  final transport = McpServer.createStdioTransport();
  server.connect(transport.get());
  
  // Keep server running
  await Completer<void>().future;
}
```

### 2. Create a Flutter Client

Create a Flutter app that connects to the MCP server:

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';
import 'package:mcp_client/mcp_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCP UI Demo',
      home: MCPUIScreen(),
    );
  }
}

class MCPUIScreen extends StatefulWidget {
  @override
  _MCPUIScreenState createState() => _MCPUIScreenState();
}

class _MCPUIScreenState extends State<MCPUIScreen> {
  Client? _mcpClient;
  MCPUIRuntime? _runtime;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _connectAndLoad();
  }

  Future<void> _connectAndLoad() async {
    try {
      // Connect to MCP server
      final config = McpClient.simpleConfig(
        name: 'Flutter UI Client',
        version: '1.0.0',
      );
      
      final transport = TransportConfig.stdio(
        command: 'dart',
        arguments: ['run', 'server.dart'],
      );
      
      final result = await McpClient.createAndConnect(
        config: config,
        transportConfig: transport,
      );
      
      _mcpClient = result.get();
      
      // Load UI definition
      final resource = await _mcpClient!.readResource('ui://pages/hello');
      final definition = jsonDecode(resource.contents.first.text!);
      
      // Initialize runtime
      _runtime = MCPUIRuntime();
      await _runtime!.initialize(definition);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text('Error: $_error'),
        ),
      );
    }
    
    return _runtime!.buildUI();
  }
  
  @override
  void dispose() {
    _runtime?.destroy();
    _mcpClient?.dispose();
    super.dispose();
  }
}
```

## Building Interactive UIs

### 1. Add State and Actions

Update your server to include interactive elements:

```dart
server.addResource(
  uri: 'ui://pages/counter',
  name: 'Counter Page',
  handler: (uri, params) async {
    return ReadResourceResult(
      contents: [
        ResourceContentInfo(
          uri: uri,
          text: '''
          {
            "type": "page",
            "content": {
              "type": "column",
              "mainAxisAlignment": "center",
              "children": [
                {
                  "type": "text",
                  "value": "Count: {{count}}",
                  "style": {"fontSize": 32}
                },
                {
                  "type": "row",
                  "mainAxisAlignment": "center",
                  "children": [
                    {
                      "type": "button",
                      "label": "-",
                      "onTap": {
                        "type": "tool",
                        "tool": "decrement"
                      }
                    },
                    {
                      "type": "button",
                      "label": "+",
                      "onTap": {
                        "type": "tool",
                        "tool": "increment"
                      }
                    }
                  ]
                }
              ]
            },
            "state": {
              "initial": {
                "count": 0
              }
            }
          }
          ''',
        ),
      ],
    );
  },
);

// Add tools
server.addTool(
  name: 'increment',
  handler: (args) async {
    // In real app, update server state
    return CallToolResult(
      content: [TextContent(text: '{"count": 1}')],
    );
  },
);
```

### 2. Handle Tool Calls in Client

Update your client to handle tool calls:

```dart
// In _connectAndLoad method, update buildUI call:
return _runtime!.buildUI(
  onToolCall: (tool, args) async {
    // Call the tool on the server
    final result = await _mcpClient!.callTool(tool, args);
    
    // Parse response and update state
    if (result.content.isNotEmpty) {
      final response = jsonDecode((result.content.first as TextContent).text);
      
      // Update runtime state
      if (response.containsKey('count')) {
        _runtime!.updateState('count', response['count']);
      }
    }
  },
);
```

## Working with Subscriptions

### 1. Create a Real-Time Data Resource

Add a resource that updates in real-time:

```dart
// In server.dart
Timer? _timer;
double _temperature = 20.0;

// Start temperature updates
_timer = Timer.periodic(Duration(seconds: 1), (timer) {
  _temperature = 15 + Random().nextDouble() * 15;
  
  // Notify subscribers
  server.notifyResourceUpdated(
    'data://temperature',
    content: ResourceContent(
      uri: 'data://temperature',
      text: jsonEncode({'temperature': _temperature}),
    ),
  );
});

// Add temperature resource
server.addResource(
  uri: 'data://temperature',
  name: 'Temperature Data',
  handler: (uri, params) async {
    return ReadResourceResult(
      contents: [
        ResourceContentInfo(
          uri: uri,
          text: jsonEncode({'temperature': _temperature}),
        ),
      ],
    );
  },
);
```

### 2. Subscribe from UI

Create a UI that subscribes to the temperature:

```dart
{
  "type": "page",
  "content": {
    "type": "column",
    "children": [
      {
        "type": "text",
        "value": "Temperature: {{temperature}}°C",
        "style": {"fontSize": 24}
      },
      {
        "type": "button",
        "label": "Subscribe",
        "onTap": {
          "type": "resource",
          "action": "subscribe",
          "uri": "data://temperature",
          "binding": "temperature"
        }
      }
    ]
  }
}
```

### 3. Handle Notifications in Client

Set up notification handling:

```dart
// After connecting to MCP server
_mcpClient!.onNotification('notifications/resources/updated', (params) async {
  if (_runtime?.isInitialized == true) {
    await _runtime!.handleNotification({
      'method': 'notifications/resources/updated',
      'params': params,
    });
  }
});

// In buildUI
return _runtime!.buildUI(
  onResourceSubscribe: (uri, binding) async {
    await _mcpClient!.subscribeResource(uri);
    _runtime!.registerResourceSubscription(uri, binding);
  },
  onResourceUnsubscribe: (uri) async {
    await _mcpClient!.unsubscribeResource(uri);
    _runtime!.unregisterResourceSubscription(uri);
  },
);
```

## Building Multi-Page Applications

### 1. Create Application Definition

```dart
server.addResource(
  uri: 'ui://app',
  name: 'My Application',
  handler: (uri, params) async {
    return ReadResourceResult(
      contents: [
        ResourceContentInfo(
          uri: uri,
          text: '''
          {
            "type": "application",
            "title": "My App",
            "initialRoute": "/home",
            "routes": {
              "/home": "ui://pages/home",
              "/settings": "ui://pages/settings"
            },
            "navigation": {
              "type": "bottom",
              "items": [
                {"title": "Home", "route": "/home", "icon": "home"},
                {"title": "Settings", "route": "/settings", "icon": "settings"}
              ]
            }
          }
          ''',
        ),
      ],
    );
  },
);
```

### 2. Initialize with Page Loader

```dart
_runtime = MCPUIRuntime();
await _runtime!.initialize(
  appDefinition,
  pageLoader: (uri) async {
    final resource = await _mcpClient!.readResource(uri);
    return jsonDecode(resource.contents.first.text!);
  },
);
```

## Best Practices

### 1. Error Handling

Always wrap MCP operations in try-catch:

```dart
try {
  final result = await _mcpClient!.callTool(tool, args);
  // Handle result
} catch (e) {
  // Show error to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

### 2. State Management

- Keep state minimal and normalized
- Use computed properties for derived values
- Avoid deeply nested state structures

### 3. Performance

- Use resource subscriptions wisely
- Implement proper cleanup in dispose methods
- Cache UI definitions when appropriate

### 4. Security

- Validate all inputs on the server
- Don't expose sensitive data in UI definitions
- Use proper authentication for MCP connections

## Next Steps

- Read the [API Reference](../api/flutter-runtime.md) for detailed documentation
- Check out [Examples](../examples/) for more complex scenarios
- Learn about [Custom Widgets](./custom-widgets.md)
- Explore [Advanced Topics](./advanced-topics.md)

## Troubleshooting

### Common Issues

1. **Connection Failed**
   - Check server is running
   - Verify transport configuration
   - Check for port conflicts

2. **UI Not Updating**
   - Ensure state bindings are correct
   - Check notification handling
   - Verify state changes are notified

3. **Tool Calls Failing**
   - Verify tool is registered on server
   - Check argument format
   - Look for server-side errors

### Debug Mode

Enable debug logging:

```dart
_runtime = MCPUIRuntime(enableDebugMode: true);
```

This will provide detailed logs about:
- Widget rendering
- State changes
- Binding resolution
- Action handling