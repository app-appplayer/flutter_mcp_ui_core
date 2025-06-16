# MCP UI Runtime Documentation

Welcome to the MCP (Model Context Protocol) UI Runtime documentation. This documentation covers the specification, implementation, and usage of the MCP UI DSL (Domain Specific Language) for building dynamic, server-driven user interfaces.

## Documentation Structure

- **[Specification](./specification/)** - MCP UI DSL v1.0 specification and protocol details
- **[API Reference](./api/)** - Complete API documentation for all packages
- **[Architecture](./architecture/)** - System architecture and design decisions
- **[Guides](./guides/)** - Step-by-step guides for common tasks
- **[Examples](./examples/)** - Code examples and sample applications

## Quick Links

- [Getting Started Guide](./guides/getting-started.md)
- [MCP UI DSL Specification](./specification/MCP_UI_DSL_v1.0_Specification.md)
- [Flutter Runtime API](./api/flutter-runtime.md)
- [Architecture Overview](./architecture/overview.md)

## Overview

The MCP UI Runtime is a framework for building server-driven user interfaces using a JSON-based domain-specific language. It enables dynamic UI updates without app deployments and supports real-time data synchronization through resource subscriptions.

### Key Features

- **Server-Driven UI**: Define your entire UI in JSON on the server
- **Real-Time Updates**: Subscribe to resources for live data updates
- **Cross-Platform**: Implementations for Flutter, React, and more
- **Type-Safe**: Full TypeScript/Dart type definitions
- **Extensible**: Easy to add custom widgets and actions

### Core Concepts

1. **Resources**: UI definitions and data stored on MCP servers
2. **Tools**: Server-side functions that can be called from the UI
3. **Subscriptions**: Real-time data updates via resource notifications
4. **State Management**: Built-in state handling with bindings
5. **Navigation**: Multi-page application support with routing

## Package Structure

The MCP UI ecosystem consists of several packages:

- `flutter_mcp_ui_runtime` - Flutter implementation of the runtime
- `flutter_mcp_ui_generator` - Code generation for Flutter widgets
- `flutter_mcp_ui_core` - Core abstractions and interfaces
- `mcp_client` - MCP protocol client implementation
- `mcp_server` - MCP protocol server implementation

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.