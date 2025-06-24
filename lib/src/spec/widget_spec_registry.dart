import '../constants/widget_types.dart';
import 'parameter_spec.dart';

/// Represents a complete widget specification
class WidgetSpec {
  final String type;
  final String category;
  final Map<String, ParameterSpec> parameters;
  final List<String> requiredParameters;
  final bool canHaveChildren;
  final bool canHaveChild;
  final Map<String, dynamic> defaults;
  final String? description;

  const WidgetSpec({
    required this.type,
    required this.category,
    required this.parameters,
    this.requiredParameters = const [],
    this.canHaveChildren = false,
    this.canHaveChild = false,
    this.defaults = const {},
    this.description,
  });

  /// Check if this widget supports any child content
  bool get supportsChildContent => canHaveChildren || canHaveChild;
}

/// Central registry for all widget specifications
class WidgetSpecRegistry {
  static final Map<String, WidgetSpec> _specs = {
    // ===== Layout Widgets =====
    WidgetTypes.linear: const WidgetSpec(
      type: WidgetTypes.linear,
      category: 'layout',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'List of child widgets',
        ),
        'direction': ParameterSpec(
          name: 'direction',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Layout direction',
        ),
        'distribution': ParameterSpec(
          name: 'distribution',
          type: String,
          defaultValue: 'start',
          allowedValues: ['start', 'end', 'center', 'spaceBetween', 'spaceAround', 'spaceEvenly'],
          description: 'How to distribute children along the main axis',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'center',
          allowedValues: ['start', 'end', 'center', 'stretch', 'baseline'],
          description: 'How to align children along the cross axis',
        ),
        'gap': ParameterSpec(
          name: 'gap',
          type: double,
          defaultValue: 0.0,
          description: 'Spacing between items',
        ),
        'wrap': ParameterSpec(
          name: 'wrap',
          type: bool,
          defaultValue: false,
          description: 'Whether items wrap to next line',
        ),
      },
      requiredParameters: ['children'],
    ),

    WidgetTypes.box: const WidgetSpec(
      type: WidgetTypes.box,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Single child widget',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: double,
          description: 'Box width',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: double,
          description: 'Box height',
        ),
        'padding': ParameterSpec(
          name: 'padding',
          type: Map,
          description: 'Inner padding',
        ),
        'margin': ParameterSpec(
          name: 'margin',
          type: Map,
          description: 'Outer margin',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Background color',
        ),
        'decoration': ParameterSpec(
          name: 'decoration',
          type: Map,
          description: 'Box decoration (border, shadow, etc)',
        ),
      },
      requiredParameters: [],
    ),

    WidgetTypes.stack: const WidgetSpec(
      type: WidgetTypes.stack,
      category: 'layout',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'List of overlapping child widgets',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'topLeft',
          description: 'How to align children',
        ),
        'fit': ParameterSpec(
          name: 'fit',
          type: String,
          defaultValue: 'loose',
          allowedValues: ['loose', 'expand', 'passthrough'],
          description: 'How to size the stack',
        ),
      },
      requiredParameters: ['children'],
    ),

    // ===== Display Widgets =====
    WidgetTypes.text: const WidgetSpec(
      type: WidgetTypes.text,
      category: 'display',
      parameters: {
        'content': ParameterSpec(
          name: 'content',
          type: String,
          required: true,
          description: 'Text content to display',
        ),
        'style': ParameterSpec(
          name: 'style',
          type: Map,
          description: 'Text style configuration',
        ),
        'textAlign': ParameterSpec(
          name: 'textAlign',
          type: String,
          allowedValues: ['left', 'right', 'center', 'justify', 'start', 'end'],
          description: 'Text alignment',
        ),
        'maxLines': ParameterSpec(
          name: 'maxLines',
          type: int,
          description: 'Maximum number of lines',
        ),
        'overflow': ParameterSpec(
          name: 'overflow',
          type: String,
          allowedValues: ['clip', 'fade', 'ellipsis', 'visible'],
          description: 'How to handle overflow',
        ),
      },
      requiredParameters: ['content'],
    ),

    WidgetTypes.image: const WidgetSpec(
      type: WidgetTypes.image,
      category: 'display',
      parameters: {
        'src': ParameterSpec(
          name: 'src',
          type: String,
          required: true,
          description: 'Image source URL or path',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: double,
          description: 'Image width',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: double,
          description: 'Image height',
        ),
        'fit': ParameterSpec(
          name: 'fit',
          type: String,
          defaultValue: 'cover',
          allowedValues: ['fill', 'contain', 'cover', 'fitWidth', 'fitHeight', 'none', 'scaleDown'],
          description: 'How to fit the image',
        ),
      },
      requiredParameters: ['src'],
    ),

    WidgetTypes.icon: const WidgetSpec(
      type: WidgetTypes.icon,
      category: 'display',
      parameters: {
        'icon': ParameterSpec(
          name: 'icon',
          type: String,
          required: true,
          description: 'Icon identifier',
        ),
        'size': ParameterSpec(
          name: 'size',
          type: double,
          defaultValue: 24.0,
          description: 'Icon size',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Icon color',
        ),
      },
      requiredParameters: ['icon'],
    ),

    WidgetTypes.loadingIndicator: const WidgetSpec(
      type: WidgetTypes.loadingIndicator,
      category: 'display',
      parameters: {
        'size': ParameterSpec(
          name: 'size',
          type: double,
          defaultValue: 24.0,
          description: 'Indicator size',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Indicator color',
        ),
        'value': ParameterSpec(
          name: 'value',
          type: double,
          description: 'Progress value (0.0 to 1.0)',
        ),
        'indicatorType': ParameterSpec(
          name: 'indicatorType',
          type: String,
          defaultValue: 'circular',
          allowedValues: ['circular', 'linear'],
          description: 'Type of indicator',
        ),
        'message': ParameterSpec(
          name: 'message',
          type: String,
          description: 'Loading message',
        ),
      },
      requiredParameters: [],
    ),

    // ===== Input Widgets =====
    WidgetTypes.button: const WidgetSpec(
      type: WidgetTypes.button,
      category: 'input',
      parameters: {
        'label': ParameterSpec(
          name: 'label',
          type: String,
          required: true,
          description: 'Button label',
        ),
        'click': ParameterSpec(
          name: 'click',
          type: Map,
          required: true,
          description: 'Click action',
        ),
        'doubleClick': ParameterSpec(
          name: 'doubleClick',
          type: Map,
          description: 'Double click action',
        ),
        'longPress': ParameterSpec(
          name: 'longPress',
          type: Map,
          description: 'Long press action',
        ),
        'rightClick': ParameterSpec(
          name: 'rightClick',
          type: Map,
          description: 'Right click action',
        ),
        'style': ParameterSpec(
          name: 'style',
          type: String,
          defaultValue: 'elevated',
          allowedValues: ['elevated', 'filled', 'outlined', 'text', 'icon'],
          description: 'Button style',
        ),
        'icon': ParameterSpec(
          name: 'icon',
          type: String,
          description: 'Button icon',
        ),
        'disabled': ParameterSpec(
          name: 'disabled',
          type: bool,
          defaultValue: false,
          description: 'Whether button is disabled',
        ),
        'loading': ParameterSpec(
          name: 'loading',
          type: bool,
          defaultValue: false,
          description: 'Whether button shows loading state',
        ),
      },
      requiredParameters: ['label', 'click'],
    ),

    WidgetTypes.textInput: const WidgetSpec(
      type: WidgetTypes.textInput,
      category: 'input',
      parameters: {
        'label': ParameterSpec(
          name: 'label',
          type: String,
          required: true,
          description: 'Input label',
        ),
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current value',
        ),
        'change': ParameterSpec(
          name: 'change',
          type: Map,
          required: true,
          description: 'Change action',
        ),
        'placeholder': ParameterSpec(
          name: 'placeholder',
          type: String,
          description: 'Placeholder text',
        ),
        'helperText': ParameterSpec(
          name: 'helperText',
          type: String,
          description: 'Helper text',
        ),
        'errorText': ParameterSpec(
          name: 'errorText',
          type: String,
          description: 'Error text',
        ),
        'obscureText': ParameterSpec(
          name: 'obscureText',
          type: bool,
          defaultValue: false,
          description: 'Whether to obscure text',
        ),
        'maxLength': ParameterSpec(
          name: 'maxLength',
          type: int,
          description: 'Maximum character length',
        ),
        'multiline': ParameterSpec(
          name: 'multiline',
          type: bool,
          defaultValue: false,
          description: 'Whether input supports multiple lines',
        ),
      },
      requiredParameters: ['label', 'value', 'change'],
    ),

    WidgetTypes.checkbox: const WidgetSpec(
      type: WidgetTypes.checkbox,
      category: 'input',
      parameters: {
        'label': ParameterSpec(
          name: 'label',
          type: String,
          required: true,
          description: 'Checkbox label',
        ),
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current value (true/false as string)',
        ),
        'change': ParameterSpec(
          name: 'change',
          type: Map,
          required: true,
          description: 'Change action',
        ),
        'disabled': ParameterSpec(
          name: 'disabled',
          type: bool,
          defaultValue: false,
          description: 'Whether checkbox is disabled',
        ),
      },
      requiredParameters: ['label', 'value', 'change'],
    ),

    WidgetTypes.select: const WidgetSpec(
      type: WidgetTypes.select,
      category: 'input',
      parameters: {
        'label': ParameterSpec(
          name: 'label',
          type: String,
          required: true,
          description: 'Select label',
        ),
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Selected value',
        ),
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'List of select items',
        ),
        'change': ParameterSpec(
          name: 'change',
          type: Map,
          required: true,
          description: 'Change action',
        ),
        'placeholder': ParameterSpec(
          name: 'placeholder',
          type: String,
          description: 'Placeholder text',
        ),
      },
      requiredParameters: ['label', 'value', 'items', 'change'],
    ),

    // ===== Navigation Widgets =====
    WidgetTypes.headerBar: const WidgetSpec(
      type: WidgetTypes.headerBar,
      category: 'navigation',
      parameters: {
        'title': ParameterSpec(
          name: 'title',
          type: String,
          required: true,
          description: 'Header title',
        ),
        'leading': ParameterSpec(
          name: 'leading',
          type: Map,
          description: 'Leading widget',
        ),
        'actions': ParameterSpec(
          name: 'actions',
          type: List,
          description: 'Action widgets',
        ),
        'elevation': ParameterSpec(
          name: 'elevation',
          type: double,
          defaultValue: 4.0,
          description: 'Header elevation',
        ),
        'backgroundColor': ParameterSpec(
          name: 'backgroundColor',
          type: String,
          description: 'Background color',
        ),
      },
      requiredParameters: ['title'],
    ),

    WidgetTypes.bottomNavigation: const WidgetSpec(
      type: WidgetTypes.bottomNavigation,
      category: 'navigation',
      parameters: {
        'currentIndex': ParameterSpec(
          name: 'currentIndex',
          type: int,
          required: true,
          description: 'Currently selected index',
        ),
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'Navigation items',
        ),
        'click': ParameterSpec(
          name: 'click',
          type: Map,
          required: true,
          description: 'Click action for item selection',
        ),
        'type': ParameterSpec(
          name: 'type',
          type: String,
          defaultValue: 'fixed',
          allowedValues: ['fixed', 'shifting'],
          description: 'Navigation bar type',
        ),
      },
      requiredParameters: ['currentIndex', 'items', 'click'],
    ),

    // ===== List Widgets =====
    WidgetTypes.list: const WidgetSpec(
      type: WidgetTypes.list,
      category: 'list',
      parameters: {
        'items': ParameterSpec(
          name: 'items',
          type: String,
          required: true,
          description: 'Data binding expression for list items',
        ),
        'template': ParameterSpec(
          name: 'template',
          type: Map,
          required: true,
          description: 'Item template widget',
        ),
        'direction': ParameterSpec(
          name: 'direction',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Scroll direction',
        ),
        'shrinkWrap': ParameterSpec(
          name: 'shrinkWrap',
          type: bool,
          defaultValue: false,
          description: 'Whether to shrink wrap contents',
        ),
      },
      requiredParameters: ['items', 'template'],
    ),

    // ===== Advanced Widgets =====
    WidgetTypes.scrollView: const WidgetSpec(
      type: WidgetTypes.scrollView,
      category: 'scroll',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to scroll',
        ),
        'scrollDirection': ParameterSpec(
          name: 'scrollDirection',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Scroll direction',
        ),
        'reverse': ParameterSpec(
          name: 'reverse',
          type: bool,
          defaultValue: false,
          description: 'Whether to reverse scroll direction',
        ),
        'padding': ParameterSpec(
          name: 'padding',
          type: Map,
          description: 'Scroll view padding',
        ),
      },
      requiredParameters: ['child'],
    ),

    WidgetTypes.mediaPlayer: const WidgetSpec(
      type: WidgetTypes.mediaPlayer,
      category: 'advanced',
      parameters: {
        'source': ParameterSpec(
          name: 'source',
          type: String,
          required: true,
          description: 'Media source URL',
        ),
        'mediaType': ParameterSpec(
          name: 'mediaType',
          type: String,
          defaultValue: 'video',
          allowedValues: ['video', 'audio'],
          description: 'Type of media',
        ),
        'autoplay': ParameterSpec(
          name: 'autoplay',
          type: bool,
          defaultValue: false,
          description: 'Whether to autoplay',
        ),
        'controls': ParameterSpec(
          name: 'controls',
          type: bool,
          defaultValue: true,
          description: 'Whether to show controls',
        ),
      },
      requiredParameters: ['source'],
    ),
  };

  /// Get specification for a widget type
  static WidgetSpec? getSpec(String type) => _specs[type];

  /// Get all widget specifications
  static Map<String, WidgetSpec> get allSpecs => Map.unmodifiable(_specs);

  /// Get all widget types
  static List<String> get allTypes => _specs.keys.toList();

  /// Get widget types by category
  static List<String> getTypesByCategory(String category) {
    return _specs.entries
        .where((entry) => entry.value.category == category)
        .map((entry) => entry.key)
        .toList();
  }

  /// Check if a widget type exists
  static bool hasType(String type) => _specs.containsKey(type);

  /// Get all categories
  static List<String> get allCategories {
    return _specs.values
        .map((spec) => spec.category)
        .toSet()
        .toList();
  }

  /// Validate parameters for a widget
  static Map<String, dynamic> validateParameters(
    String type,
    Map<String, dynamic> params,
  ) {
    final spec = getSpec(type);
    if (spec == null) {
      throw Exception('Unknown widget type: $type');
    }

    final validatedParams = <String, dynamic>{};

    // Check required parameters
    for (final requiredParam in spec.requiredParameters) {
      if (!params.containsKey(requiredParam)) {
        throw Exception('Required parameter "$requiredParam" missing for widget type "$type"');
      }
    }

    // Validate and apply parameters
    for (final entry in params.entries) {
      final paramSpec = spec.parameters[entry.key];
      if (paramSpec == null) {
        // Skip unknown parameters
        continue;
      }

      // Validate allowed values
      if (paramSpec.allowedValues != null && 
          !paramSpec.allowedValues!.contains(entry.value)) {
        throw Exception(
          'Invalid value "${entry.value}" for parameter "${entry.key}". '
          'Allowed values: ${paramSpec.allowedValues!.join(", ")}'
        );
      }

      validatedParams[entry.key] = entry.value;
    }

    // Apply defaults for missing optional parameters
    for (final entry in spec.parameters.entries) {
      if (!validatedParams.containsKey(entry.key) && 
          entry.value.defaultValue != null) {
        validatedParams[entry.key] = entry.value.defaultValue;
      }
    }

    return validatedParams;
  }
}