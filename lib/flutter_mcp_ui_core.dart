/// Flutter MCP UI Core
/// 
/// Core models, constants, and utilities for Flutter MCP UI system.
/// This package provides the foundational classes and definitions that are
/// shared between the renderer and generator packages.
library flutter_mcp_ui_core;

// Core models (strongly-typed Definition classes - recommended)
export 'src/models/application_definition.dart';
export 'src/models/timestamp_info.dart';
export 'src/models/page_definition.dart';
export 'src/models/widget_definition.dart';
export 'src/models/action_definition.dart';
export 'src/models/theme_definition.dart';
export 'src/models/theme.dart'; // 14 sub models + DTCG codec + seed palette
export 'src/models/permission_definition.dart';
export 'src/models/channel_definition.dart';
export 'src/models/template_definition.dart';
export 'src/models/template_library.dart';

// Legacy Config classes (deprecated, use *Definition classes instead)
export 'src/models/widget_config.dart'; // @Deprecated: use WidgetDefinition
export 'src/models/action_config.dart'; // @Deprecated: use ActionDefinition
export 'src/models/application_config.dart'; // @Deprecated: use ApplicationDefinition
export 'src/models/page_config.dart'; // @Deprecated: use PageDefinition
// theme_config.dart removed — 1.3 modern theme spec only (no legacy alias).

// Supporting model classes (active, used by validators and widget configs)
export 'src/models/binding_config.dart';
export 'src/models/property_spec.dart';
export 'src/models/accessibility_config.dart';
export 'src/models/i18n_config.dart';
export 'src/models/cache_policy.dart';

// Constants
export 'src/constants/widget_types.dart';
export 'src/constants/property_keys.dart';
export 'src/constants/defaults.dart';
export 'src/constants/dsl_version.dart';
export 'src/constants/accessibility.dart';
export 'src/constants/i18n.dart';
export 'src/constants/conformance.dart';
export 'src/constants/action_types.dart';
export 'src/constants/client_resource_schemes.dart';

// Validators
export 'src/validators/ui_validator.dart';
export 'src/validators/definition_validator.dart';
export 'src/validators/schema_definitions.dart';

// Utilities
export 'src/utils/json_utils.dart';
export 'src/utils/type_converters.dart';
export 'src/utils/property_helpers.dart';

// Exceptions
export 'src/exceptions/validation_exception.dart';
export 'src/exceptions/ui_exception.dart';

// Specifications
export 'src/spec/widget_spec_registry.dart';
export 'src/spec/action_spec_registry.dart';

// Generated widget-registry JSON Schema + validator (spec §17.3).
export 'src/schema/widget_validator.dart'
    show
        WidgetValidationError,
        WidgetValidationResult,
        validateMcpUiDslWidget;