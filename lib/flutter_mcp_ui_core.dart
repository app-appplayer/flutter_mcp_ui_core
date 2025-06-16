/// Flutter MCP UI Core
/// 
/// Core models, constants, and utilities for Flutter MCP UI system.
/// This package provides the foundational classes and definitions that are
/// shared between the renderer and generator packages.
library flutter_mcp_ui_core;

// Core models
export 'src/models/ui_definition.dart';
export 'src/models/widget_config.dart';
export 'src/models/action_config.dart';
export 'src/models/binding_config.dart';
export 'src/models/theme_config.dart';
export 'src/models/application_config.dart';
export 'src/models/page_config.dart';
export 'src/models/property_spec.dart';

// Constants
export 'src/constants/widget_types.dart';
export 'src/constants/property_keys.dart';
export 'src/constants/defaults.dart';
export 'src/constants/dsl_version.dart';

// Validators
export 'src/validators/ui_validator.dart';
export 'src/validators/schema_definitions.dart';

// Utilities
export 'src/utils/json_utils.dart';
export 'src/utils/type_converters.dart';
export 'src/utils/property_helpers.dart';

// Exceptions
export 'src/exceptions/validation_exception.dart';
export 'src/exceptions/ui_exception.dart';