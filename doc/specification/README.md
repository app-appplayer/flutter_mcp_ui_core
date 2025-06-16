# MCP UI DSL Specifications

This directory contains the official specifications for the MCP UI Domain Specific Language.

## Current Version

- [MCP UI DSL v1.0](./mcp-ui-dsl-v1.0.md) - Current stable version

## Legacy Versions

- [MCP UI DSL v1.0 (Korean)](./MCP_UI_DSL_v1.0_Specification.md) - Original Korean specification

## Specification Structure

The MCP UI DSL specification covers:

1. **Core Concepts**
   - UI Definition Types (Application, Page, Widget)
   - Resource Management
   - State Management
   - Data Binding

2. **Widget System**
   - Layout Widgets
   - Display Widgets
   - Input Widgets
   - Navigation Widgets

3. **Actions and Events**
   - Tool Actions
   - State Actions
   - Navigation Actions
   - Resource Actions

4. **Subscriptions**
   - Standard Mode (MCP compliant)
   - Extended Mode (Performance optimized)

5. **Implementation Guidelines**
   - Platform-specific considerations
   - Performance optimizations
   - Security best practices

## Version History

### v1.0 (Current)
- Initial stable release
- Full widget system
- Multi-page application support
- Resource subscription modes
- State management
- Navigation system

### Future Versions
- v1.1 - Animation support (planned)
- v1.2 - Advanced data transformations (planned)
- v2.0 - Plugin system (planned)

## Contributing

To propose changes to the specification:

1. Create an issue describing the proposed change
2. Submit a pull request with specification updates
3. Include examples and use cases
4. Update version history

## Implementation Status

| Platform | Version | Status |
|----------|---------|--------|
| Flutter | v1.0 | ✅ Complete |
| React | v1.0 | 🚧 In Progress |
| Vue | v1.0 | 📋 Planned |
| Python | v1.0 | 📋 Planned |

## Compliance Testing

Implementations should pass the compliance test suite:

```bash
# Run compliance tests
dart test test/compliance/
```

## Related Documents

- [Architecture Overview](../architecture/overview.md)
- [API Reference](../api/)
- [Implementation Guide](../guides/)