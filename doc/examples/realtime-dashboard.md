# Real-Time Dashboard Example

A comprehensive dashboard demonstrating real-time data updates using MCP resource subscriptions.

## Features

- Multiple data streams (temperature, humidity, CPU usage)
- Real-time charts and gauges
- Standard and extended subscription modes
- Performance monitoring
- Alert system

## Server Implementation

```dart
// server.dart
import 'package:mcp_server/mcp_server.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

void main() async {
  final server = McpServer.createServer(
    McpServerConfig(
      name: 'Dashboard Server',
      version: '1.0.0',
      capabilities: ServerCapabilities(
        resources: ResourcesCapability(subscribe: true),
        tools: ToolsCapability(),
      ),
    ),
  );

  // Sensor data
  final sensorData = SensorData();
  
  // Dashboard page
  server.addResource(
    uri: 'ui://pages/dashboard',
    name: 'Real-Time Dashboard',
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
                'type': 'column',
                'children': [
                  // Header
                  {
                    'type': 'container',
                    'padding': 16,
                    'decoration': {
                      'color': '#1976D2',
                    },
                    'child': {
                      'type': 'row',
                      'mainAxisAlignment': 'spaceBetween',
                      'children': [
                        {
                          'type': 'text',
                          'value': 'System Dashboard',
                          'style': {
                            'fontSize': 24,
                            'fontWeight': 'bold',
                            'color': '#FFFFFF'
                          }
                        },
                        {
                          'type': 'text',
                          'value': 'Status: {{systemStatus}}',
                          'style': {
                            'fontSize': 14,
                            'color': '#FFFFFF'
                          }
                        }
                      ]
                    }
                  },
                  // Metrics Grid
                  {
                    'type': 'expanded',
                    'child': {
                      'type': 'padding',
                      'padding': 16,
                      'child': {
                        'type': 'gridView',
                        'crossAxisCount': 2,
                        'mainAxisSpacing': 16,
                        'crossAxisSpacing': 16,
                        'childAspectRatio': 1.5,
                        'children': [
                          // Temperature Card
                          {
                            'type': 'card',
                            'elevation': 4,
                            'child': {
                              'type': 'padding',
                              'padding': 16,
                              'child': {
                                'type': 'column',
                                'mainAxisAlignment': 'spaceBetween',
                                'children': [
                                  {
                                    'type': 'row',
                                    'mainAxisAlignment': 'spaceBetween',
                                    'children': [
                                      {
                                        'type': 'text',
                                        'value': 'Temperature',
                                        'style': {'fontSize': 16}
                                      },
                                      {
                                        'type': 'icon',
                                        'icon': 'thermostat',
                                        'color': '#FF5722'
                                      }
                                    ]
                                  },
                                  {
                                    'type': 'text',
                                    'value': '{{temperature}}°C',
                                    'style': {
                                      'fontSize': 28,
                                      'fontWeight': 'bold',
                                      'color': '{{temperature > 30 ? "#FF5722" : "#4CAF50"}}'
                                    }
                                  },
                                  {
                                    'type': 'linearProgressIndicator',
                                    'value': '{{temperature / 50}}',
                                    'color': '{{temperature > 30 ? "#FF5722" : "#4CAF50"}}'
                                  }
                                ]
                              }
                            }
                          },
                          // Humidity Card
                          {
                            'type': 'card',
                            'elevation': 4,
                            'child': {
                              'type': 'padding',
                              'padding': 16,
                              'child': {
                                'type': 'column',
                                'mainAxisAlignment': 'spaceBetween',
                                'children': [
                                  {
                                    'type': 'row',
                                    'mainAxisAlignment': 'spaceBetween',
                                    'children': [
                                      {
                                        'type': 'text',
                                        'value': 'Humidity',
                                        'style': {'fontSize': 16}
                                      },
                                      {
                                        'type': 'icon',
                                        'icon': 'water_drop',
                                        'color': '#2196F3'
                                      }
                                    ]
                                  },
                                  {
                                    'type': 'text',
                                    'value': '{{humidity}}%',
                                    'style': {
                                      'fontSize': 28,
                                      'fontWeight': 'bold',
                                      'color': '#2196F3'
                                    }
                                  },
                                  {
                                    'type': 'linearProgressIndicator',
                                    'value': '{{humidity / 100}}',
                                    'color': '#2196F3'
                                  }
                                ]
                              }
                            }
                          },
                          // CPU Usage Card
                          {
                            'type': 'card',
                            'elevation': 4,
                            'child': {
                              'type': 'padding',
                              'padding': 16,
                              'child': {
                                'type': 'column',
                                'mainAxisAlignment': 'spaceBetween',
                                'children': [
                                  {
                                    'type': 'row',
                                    'mainAxisAlignment': 'spaceBetween',
                                    'children': [
                                      {
                                        'type': 'text',
                                        'value': 'CPU Usage',
                                        'style': {'fontSize': 16}
                                      },
                                      {
                                        'type': 'icon',
                                        'icon': 'memory',
                                        'color': '#9C27B0'
                                      }
                                    ]
                                  },
                                  {
                                    'type': 'text',
                                    'value': '{{cpuUsage}}%',
                                    'style': {
                                      'fontSize': 28,
                                      'fontWeight': 'bold',
                                      'color': '{{cpuUsage > 80 ? "#FF5722" : "#9C27B0"}}'
                                    }
                                  },
                                  {
                                    'type': 'circularProgressIndicator',
                                    'value': '{{cpuUsage / 100}}',
                                    'color': '{{cpuUsage > 80 ? "#FF5722" : "#9C27B0"}}'
                                  }
                                ]
                              }
                            }
                          },
                          // Memory Usage Card
                          {
                            'type': 'card',
                            'elevation': 4,
                            'child': {
                              'type': 'padding',
                              'padding': 16,
                              'child': {
                                'type': 'column',
                                'mainAxisAlignment': 'spaceBetween',
                                'children': [
                                  {
                                    'type': 'row',
                                    'mainAxisAlignment': 'spaceBetween',
                                    'children': [
                                      {
                                        'type': 'text',
                                        'value': 'Memory',
                                        'style': {'fontSize': 16}
                                      },
                                      {
                                        'type': 'icon',
                                        'icon': 'storage',
                                        'color': '#00BCD4'
                                      }
                                    ]
                                  },
                                  {
                                    'type': 'text',
                                    'value': '{{memoryUsed}}/{{memoryTotal}}GB',
                                    'style': {
                                      'fontSize': 20,
                                      'fontWeight': 'bold',
                                      'color': '#00BCD4'
                                    }
                                  },
                                  {
                                    'type': 'linearProgressIndicator',
                                    'value': '{{memoryUsed / memoryTotal}}',
                                    'color': '#00BCD4'
                                  }
                                ]
                              }
                            }
                          }
                        ]
                      }
                    }
                  },
                  // Subscription Controls
                  {
                    'type': 'container',
                    'padding': 16,
                    'decoration': {
                      'color': '#F5F5F5',
                      'border': {
                        'color': '#E0E0E0',
                        'width': 1
                      }
                    },
                    'child': {
                      'type': 'column',
                      'children': [
                        {
                          'type': 'text',
                          'value': 'Subscription Mode',
                          'style': {
                            'fontSize': 18,
                            'fontWeight': 'bold'
                          }
                        },
                        {
                          'type': 'sizedBox',
                          'height': 8
                        },
                        {
                          'type': 'row',
                          'mainAxisAlignment': 'spaceEvenly',
                          'children': [
                            {
                              'type': 'button',
                              'label': 'Standard Mode',
                              'style': '{{subscriptionMode === "standard" ? "elevated" : "outlined"}}',
                              'onTap': {
                                'type': 'tool',
                                'tool': 'setSubscriptionMode',
                                'args': {'mode': 'standard'}
                              }
                            },
                            {
                              'type': 'button',
                              'label': 'Extended Mode',
                              'style': '{{subscriptionMode === "extended" ? "elevated" : "outlined"}}',
                              'onTap': {
                                'type': 'tool',
                                'tool': 'setSubscriptionMode',
                                'args': {'mode': 'extended'}
                              }
                            }
                          ]
                        },
                        {
                          'type': 'sizedBox',
                          'height': 8
                        },
                        {
                          'type': 'row',
                          'mainAxisAlignment': 'center',
                          'children': [
                            {
                              'type': 'button',
                              'label': '{{isSubscribed ? "Unsubscribe" : "Subscribe"}}',
                              'style': 'elevated',
                              'onTap': {
                                'type': 'conditional',
                                'condition': '{{isSubscribed}}',
                                'then': {
                                  'type': 'composite',
                                  'actions': [
                                    {'type': 'resource', 'action': 'unsubscribe', 'uri': 'data://sensors/temperature'},
                                    {'type': 'resource', 'action': 'unsubscribe', 'uri': 'data://sensors/humidity'},
                                    {'type': 'resource', 'action': 'unsubscribe', 'uri': 'data://system/cpu'},
                                    {'type': 'resource', 'action': 'unsubscribe', 'uri': 'data://system/memory'},
                                    {'type': 'setState', 'updates': {'isSubscribed': false}}
                                  ]
                                },
                                'else': {
                                  'type': 'composite',
                                  'actions': [
                                    {'type': 'resource', 'action': 'subscribe', 'uri': '{{subscriptionMode === "standard" ? "data://sensors/temperature" : "data://sensors/temperature-extended"}}', 'binding': 'temperature'},
                                    {'type': 'resource', 'action': 'subscribe', 'uri': '{{subscriptionMode === "standard" ? "data://sensors/humidity" : "data://sensors/humidity-extended"}}', 'binding': 'humidity'},
                                    {'type': 'resource', 'action': 'subscribe', 'uri': 'data://system/cpu', 'binding': 'cpuUsage'},
                                    {'type': 'resource', 'action': 'subscribe', 'uri': 'data://system/memory', 'binding': 'memoryData'},
                                    {'type': 'setState', 'updates': {'isSubscribed': true}}
                                  ]
                                }
                              }
                            }
                          ]
                        },
                        {
                          'type': 'text',
                          'value': 'Updates: {{updateCount}} | Latency: {{latency}}ms',
                          'style': {
                            'fontSize': 12,
                            'color': '#666666'
                          }
                        }
                      ]
                    }
                  }
                ]
              },
              'state': {
                'initial': {
                  'temperature': 20.0,
                  'humidity': 50,
                  'cpuUsage': 0,
                  'memoryUsed': 0,
                  'memoryTotal': 16,
                  'systemStatus': 'Online',
                  'subscriptionMode': 'extended',
                  'isSubscribed': false,
                  'updateCount': 0,
                  'latency': 0
                },
                'computed': {
                  'memoryData': '{{{"used": memoryUsed, "total": memoryTotal}}}'
                }
              }
            }),
          ),
        ],
      );
    },
  );

  // Add sensor resources
  _addSensorResources(server, sensorData);
  
  // Add tools
  _addTools(server);
  
  // Start sensor simulation
  sensorData.startSimulation(server);

  // Connect transport
  final transport = McpServer.createStdioTransport();
  server.connect(transport.get());
  
  await Completer<void>().future;
}

void _addSensorResources(Server server, SensorData data) {
  // Temperature resources (standard and extended)
  server.addResource(
    uri: 'data://sensors/temperature',
    name: 'Temperature Sensor',
    handler: (uri, params) async {
      return ReadResourceResult(
        contents: [
          ResourceContentInfo(
            uri: uri,
            text: jsonEncode({'temperature': data.temperature}),
          ),
        ],
      );
    },
  );
  
  server.addResource(
    uri: 'data://sensors/temperature-extended',
    name: 'Temperature Sensor (Extended)',
    handler: (uri, params) async {
      return ReadResourceResult(
        contents: [
          ResourceContentInfo(
            uri: uri,
            text: jsonEncode({'temperature': data.temperature}),
          ),
        ],
      );
    },
  );
  
  // Similar for humidity, CPU, memory...
}

void _addTools(Server server) {
  server.addTool(
    name: 'setSubscriptionMode',
    handler: (args) async {
      final mode = args['mode'] as String;
      
      return CallToolResult(
        content: [
          TextContent(
            text: jsonEncode({
              'subscriptionMode': mode,
              'message': 'Subscription mode set to $mode'
            }),
          ),
        ],
      );
    },
  );
}

class SensorData {
  double temperature = 20.0;
  int humidity = 50;
  int cpuUsage = 20;
  double memoryUsed = 4.5;
  
  Timer? _updateTimer;
  final _random = Random();
  
  void startSimulation(Server server) {
    _updateTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      // Update values
      temperature = 15 + _random.nextDouble() * 25;
      humidity = 30 + _random.nextInt(50);
      cpuUsage = 10 + _random.nextInt(80);
      memoryUsed = 2 + _random.nextDouble() * 12;
      
      // Send notifications
      // Standard mode - URI only
      server.notifyResourceUpdated('data://sensors/temperature');
      server.notifyResourceUpdated('data://sensors/humidity');
      
      // Extended mode - with content
      server.notifyResourceUpdated(
        'data://sensors/temperature-extended',
        content: ResourceContent(
          uri: 'data://sensors/temperature-extended',
          text: jsonEncode({'temperature': temperature.toStringAsFixed(1)}),
        ),
      );
      
      server.notifyResourceUpdated(
        'data://sensors/humidity-extended',
        content: ResourceContent(
          uri: 'data://sensors/humidity-extended',
          text: jsonEncode({'humidity': humidity}),
        ),
      );
      
      // System metrics always use extended mode
      server.notifyResourceUpdated(
        'data://system/cpu',
        content: ResourceContent(
          uri: 'data://system/cpu',
          text: jsonEncode({'cpuUsage': cpuUsage}),
        ),
      );
      
      server.notifyResourceUpdated(
        'data://system/memory',
        content: ResourceContent(
          uri: 'data://system/memory',
          text: jsonEncode({
            'memoryUsed': memoryUsed.toStringAsFixed(1),
            'memoryTotal': 16
          }),
        ),
      );
    });
  }
  
  void dispose() {
    _updateTimer?.cancel();
  }
}
```

## Client Implementation

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_mcp_ui_runtime/flutter_mcp_ui_runtime.dart';
import 'package:mcp_client/mcp_client.dart';

class DashboardApp extends StatefulWidget {
  @override
  _DashboardAppState createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  Client? _mcpClient;
  MCPUIRuntime? _runtime;
  final _updateMetrics = <String, int>{};
  
  @override
  void initState() {
    super.initState();
    _initialize();
  }
  
  Future<void> _initialize() async {
    // Connect to server
    final config = McpClient.simpleConfig(
      name: 'Dashboard Client',
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
    
    // Setup notification handlers
    _setupNotificationHandlers();
    
    // Load dashboard
    final resource = await _mcpClient!.readResource('ui://pages/dashboard');
    final definition = jsonDecode(resource.contents.first.text!);
    
    _runtime = MCPUIRuntime();
    await _runtime!.initialize(definition);
    
    setState(() {});
  }
  
  void _setupNotificationHandlers() {
    _mcpClient!.onNotification('notifications/resources/updated', (params) async {
      final startTime = DateTime.now();
      
      if (_runtime?.isInitialized == true) {
        await _runtime!.handleNotification({
          'method': 'notifications/resources/updated',
          'params': params,
        }, resourceReader: (uri) async {
          final resource = await _mcpClient!.readResource(uri);
          return resource.contents.first.text!;
        });
        
        // Update metrics
        final latency = DateTime.now().difference(startTime).inMilliseconds;
        final uri = params['uri'] as String;
        
        _updateMetrics[uri] = (_updateMetrics[uri] ?? 0) + 1;
        final totalUpdates = _updateMetrics.values.fold(0, (a, b) => a + b);
        
        _runtime!.updateState('updateCount', totalUpdates);
        _runtime!.updateState('latency', latency);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_runtime == null || !_runtime!.isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    
    return MaterialApp(
      title: 'Real-Time Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _runtime!.buildUI(
          onToolCall: _handleToolCall,
          onResourceSubscribe: _handleSubscribe,
          onResourceUnsubscribe: _handleUnsubscribe,
        ),
      ),
    );
  }
  
  Future<void> _handleToolCall(String tool, Map<String, dynamic> args) async {
    final result = await _mcpClient!.callTool(tool, args);
    
    if (result.content.isNotEmpty) {
      final response = jsonDecode((result.content.first as TextContent).text);
      
      response.forEach((key, value) {
        _runtime!.updateState(key, value);
      });
    }
  }
  
  Future<void> _handleSubscribe(String uri, String binding) async {
    await _mcpClient!.subscribeResource(uri);
    _runtime!.registerResourceSubscription(uri, binding);
  }
  
  Future<void> _handleUnsubscribe(String uri) async {
    await _mcpClient!.unsubscribeResource(uri);
    _runtime!.unregisterResourceSubscription(uri);
  }
  
  @override
  void dispose() {
    _runtime?.destroy();
    _mcpClient?.dispose();
    super.dispose();
  }
}
```

## Key Features Explained

### 1. Multiple Data Streams

The dashboard subscribes to multiple resources simultaneously:
- Temperature sensor
- Humidity sensor
- CPU usage
- Memory usage

### 2. Subscription Modes

Users can switch between:
- **Standard Mode**: Notifications contain URI only, client fetches data
- **Extended Mode**: Notifications include data for better performance

### 3. Real-Time Metrics

The dashboard tracks:
- Update count per resource
- Latency measurements
- System status

### 4. Visual Indicators

- Color-coded metrics based on thresholds
- Progress bars for visual representation
- Icons for quick identification

## Performance Considerations

### 1. Update Frequency

Balance between real-time feel and performance:
```dart
Timer.periodic(Duration(milliseconds: 500), (timer) {
  // Update every 500ms instead of continuously
});
```

### 2. Batch Updates

Group multiple state changes:
```dart
_runtime!.stateManager.batchUpdate(() {
  _runtime!.updateState('temperature', temp);
  _runtime!.updateState('humidity', humidity);
  _runtime!.updateState('cpuUsage', cpu);
});
```

### 3. Selective Rendering

Only update changed widgets:
```json
{
  "type": "animatedBuilder",
  "animation": "{{temperature}}",
  "builder": {
    "type": "text",
    "value": "{{temperature}}°C"
  }
}
```

## Customization Options

### 1. Add New Metrics

```dart
// Add network speed monitoring
server.addResource(
  uri: 'data://network/speed',
  handler: (uri, params) async {
    return ReadResourceResult(
      contents: [
        ResourceContentInfo(
          uri: uri,
          text: jsonEncode({
            'download': networkSpeed.download,
            'upload': networkSpeed.upload,
          }),
        ),
      ],
    );
  },
);
```

### 2. Custom Visualizations

Register custom chart widgets:
```dart
runtime.widgetRegistry.register('lineChart', LineChartFactory());
runtime.widgetRegistry.register('gaugeChart', GaugeChartFactory());
```

### 3. Alert System

Add threshold-based alerts:
```json
{
  "state": {
    "watchers": [
      {
        "watch": "temperature",
        "condition": "{{temperature > 35}}",
        "actions": [
          {
            "type": "tool",
            "tool": "sendAlert",
            "args": {
              "type": "temperature",
              "value": "{{temperature}}"
            }
          }
        ]
      }
    ]
  }
}
```

## Next Steps

- Add historical data storage
- Implement data export functionality
- Create custom chart widgets
- Add predictive analytics
- Implement alert notifications