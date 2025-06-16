# Counter App Example

A simple interactive counter application demonstrating state management and tool calls in MCP UI Runtime.

## Features

- Increment and decrement counter
- Reset to zero
- Display current count
- Server-side state management

## Server Implementation

```dart
// server.dart
import 'package:mcp_server/mcp_server.dart';
import 'dart:convert';

void main() async {
  // Create server
  final server = McpServer.createServer(
    McpServerConfig(
      name: 'Counter Server',
      version: '1.0.0',
      capabilities: ServerCapabilities(
        resources: ResourcesCapability(),
        tools: ToolsCapability(),
      ),
    ),
  );

  // Server state
  int counter = 0;

  // Add counter page resource
  server.addResource(
    uri: 'ui://pages/counter',
    name: 'Counter Page',
    mimeType: 'application/json',
    handler: (uri, params) async {
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
                  'mainAxisAlignment': 'center',
                  'children': [
                    {
                      'type': 'text',
                      'value': 'Simple Counter Demo',
                      'style': {
                        'fontSize': 24,
                        'fontWeight': 'bold'
                      }
                    },
                    {
                      'type': 'sizedBox',
                      'height': 20
                    },
                    {
                      'type': 'container',
                      'padding': 20,
                      'decoration': {
                        'borderRadius': 10,
                        'color': '#F5F5F5'
                      },
                      'child': {
                        'type': 'text',
                        'value': 'Count: {{counter}}',
                        'style': {
                          'fontSize': 32,
                          'fontWeight': 'bold'
                        }
                      }
                    },
                    {
                      'type': 'sizedBox',
                      'height': 20
                    },
                    {
                      'type': 'row',
                      'mainAxisAlignment': 'center',
                      'children': [
                        {
                          'type': 'button',
                          'label': '-',
                          'style': 'elevated',
                          'onTap': {
                            'type': 'tool',
                            'tool': 'decrement',
                            'args': {}
                          }
                        },
                        {
                          'type': 'sizedBox',
                          'width': 20
                        },
                        {
                          'type': 'button',
                          'label': '+',
                          'style': 'elevated',
                          'onTap': {
                            'type': 'tool',
                            'tool': 'increment',
                            'args': {}
                          }
                        },
                        {
                          'type': 'sizedBox',
                          'width': 20
                        },
                        {
                          'type': 'button',
                          'label': 'Reset',
                          'style': 'outlined',
                          'onTap': {
                            'type': 'tool',
                            'tool': 'reset',
                            'args': {}
                          }
                        }
                      ]
                    },
                    {
                      'type': 'sizedBox',
                      'height': 20
                    },
                    {
                      'type': 'text',
                      'value': 'Last action: {{lastAction}}',
                      'style': {
                        'fontSize': 14,
                        'color': '#666666'
                      }
                    }
                  ]
                }
              },
              'state': {
                'initial': {
                  'counter': counter,
                  'lastAction': 'None'
                }
              }
            }),
          ),
        ],
      );
    },
  );

  // Add increment tool
  server.addTool(
    name: 'increment',
    description: 'Increment the counter by 1',
    inputSchema: {
      'type': 'object',
      'properties': {}
    },
    handler: (args) async {
      counter++;
      
      return CallToolResult(
        content: [
          TextContent(
            text: jsonEncode({
              'counter': counter,
              'lastAction': 'Incremented'
            }),
          ),
        ],
      );
    },
  );

  // Add decrement tool
  server.addTool(
    name: 'decrement',
    description: 'Decrement the counter by 1',
    inputSchema: {
      'type': 'object',
      'properties': {}
    },
    handler: (args) async {
      counter--;
      
      return CallToolResult(
        content: [
          TextContent(
            text: jsonEncode({
              'counter': counter,
              'lastAction': 'Decremented'
            }),
          ),
        ],
      );
    },
  );

  // Add reset tool
  server.addTool(
    name: 'reset',
    description: 'Reset the counter to 0',
    inputSchema: {
      'type': 'object',
      'properties': {}
    },
    handler: (args) async {
      counter = 0;
      
      return CallToolResult(
        content: [
          TextContent(
            text: jsonEncode({
              'counter': counter,
              'lastAction': 'Reset'
            }),
          ),
        ],
      );
    },
  );

  // Connect to transport
  final transport = McpServer.createStdioTransport();
  server.connect(transport.get());
  
  print('Counter server started on stdio');
  
  // Keep server running
  await Completer<void>().future;
}
```

## Client Implementation

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';
import 'package:mcp_client/mcp_client.dart';
import 'dart:convert';

void main() {
  runApp(CounterApp());
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCP Counter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  Client? _mcpClient;
  MCPUIRuntime? _runtime;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Connect to MCP server
      final config = McpClient.simpleConfig(
        name: 'Counter Client',
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
      final resource = await _mcpClient!.readResource('ui://pages/counter');
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

  Future<void> _handleToolCall(String tool, Map<String, dynamic> args) async {
    if (_mcpClient == null) return;
    
    try {
      // Call tool on server
      final result = await _mcpClient!.callTool(tool, args);
      
      // Parse response
      if (result.content.isNotEmpty) {
        final response = jsonDecode((result.content.first as TextContent).text);
        
        // Update runtime state
        if (_runtime?.isInitialized == true) {
          response.forEach((key, value) {
            _runtime!.updateState(key, value);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Failed to connect',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(_error!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initialize,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      body: _runtime!.buildUI(
        onToolCall: _handleToolCall,
      ),
    );
  }

  @override
  void dispose() {
    _runtime?.destroy();
    _mcpClient?.dispose();
    super.dispose();
  }
}
```

## Key Concepts

### 1. State Management

The counter value is managed on the server and synchronized with the client through tool calls:

```json
{
  "state": {
    "initial": {
      "counter": 0,
      "lastAction": "None"
    }
  }
}
```

### 2. Tool Calls

Each button triggers a tool call to the server:

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

### 3. Data Binding

The UI automatically updates when state changes:

```json
{
  "type": "text",
  "value": "Count: {{counter}}"
}
```

## Running the Example

1. Start the server:
```bash
dart run server.dart
```

2. Run the Flutter app:
```bash
flutter run
```

## Variations

### Local State Version

For a purely client-side counter:

```json
{
  "type": "button",
  "label": "+",
  "onTap": {
    "type": "setState",
    "updates": {
      "counter": "{{counter + 1}}",
      "lastAction": "Incremented locally"
    }
  }
}
```

### With Animation

Add smooth transitions:

```json
{
  "type": "animatedContainer",
  "duration": 300,
  "padding": "{{counter > 10 ? 30 : 20}}",
  "decoration": {
    "color": "{{counter > 10 ? '#4CAF50' : '#F5F5F5'}}"
  },
  "child": {
    "type": "text",
    "value": "Count: {{counter}}"
  }
}
```

### With Persistence

Save counter value between sessions:

```dart
// In server
final prefs = await SharedPreferences.getInstance();
counter = prefs.getInt('counter') ?? 0;

// In tool handlers
await prefs.setInt('counter', counter);
```

## Next Steps

- Add keyboard shortcuts for increment/decrement
- Implement undo/redo functionality
- Add multiple counters with labels
- Create a counter history graph
- Add sound effects for actions