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
          allowedValues: [
            'start', 'end', 'center',
            'spaceBetween', 'spaceAround', 'spaceEvenly',
            // Kebab-case aliases for DSL JSON compatibility
            'space-between', 'space-around', 'space-evenly',
          ],
          description: 'How to distribute children along the main axis',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'start',
          allowedValues: ['start', 'end', 'center', 'stretch', 'baseline'],
          description: 'How to align children along the cross axis',
        ),
        'spacing': ParameterSpec(
          name: 'spacing',
          type: dynamic, // Support both number and MCP UI DSL v1.0 format
          defaultValue: 0.0,
          description: 'Spacing between children - supports both number and MCP UI DSL v1.0 format',
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
          type: dynamic, // Support both number and MCP UI DSL v1.0 format {"value": X, "unit": "px"}
          description: 'Box width - supports both number and MCP UI DSL v1.0 format',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic, // Support both number and MCP UI DSL v1.0 format {"value": X, "unit": "px"}
          description: 'Box height - supports both number and MCP UI DSL v1.0 format',
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
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          allowedValues: [
            'topStart', 'topCenter', 'topEnd',
            'centerStart', 'center', 'centerEnd',
            'bottomStart', 'bottomCenter', 'bottomEnd',
          ],
          description: 'Alignment of child within the box',
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
          defaultValue: 'topStart',
          allowedValues: [
            'topStart', 'topCenter', 'topEnd',
            'centerStart', 'center', 'centerEnd',
            'bottomStart', 'bottomCenter', 'bottomEnd',
            // Legacy LTR aliases for backward compatibility
            'topLeft', 'topRight',
            'centerLeft', 'centerRight',
            'bottomLeft', 'bottomRight',
          ],
          description: 'How to align children (RTL-safe)',
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

    WidgetTypes.sizedBox: const WidgetSpec(
      type: WidgetTypes.sizedBox,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Optional child widget',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Fixed width - supports both number and MCP UI DSL v1.0 format',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Fixed height - supports both number and MCP UI DSL v1.0 format',
        ),
      },
      requiredParameters: [],
      description: 'A box with a specified size, optionally containing a child',
    ),

    WidgetTypes.expanded: const WidgetSpec(
      type: WidgetTypes.expanded,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to expand',
        ),
        'flex': ParameterSpec(
          name: 'flex',
          type: int,
          defaultValue: 1,
          description: 'Flex factor for how much space to occupy',
        ),
      },
      requiredParameters: ['child'],
      description: 'Expands a child to fill available space in a linear layout',
    ),

    WidgetTypes.flexible: const WidgetSpec(
      type: WidgetTypes.flexible,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget',
        ),
        'flex': ParameterSpec(
          name: 'flex',
          type: int,
          defaultValue: 1,
          description: 'Flex factor for how much space to occupy',
        ),
        'fit': ParameterSpec(
          name: 'fit',
          type: String,
          defaultValue: 'loose',
          allowedValues: ['loose', 'tight'],
          description: 'How the child fills available space',
        ),
      },
      requiredParameters: ['child'],
      description: 'Gives a child flexibility within a linear layout',
    ),

    WidgetTypes.padding: const WidgetSpec(
      type: WidgetTypes.padding,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to apply padding to',
        ),
        'padding': ParameterSpec(
          name: 'padding',
          type: Map,
          required: true,
          description: 'Padding values (all, horizontal, vertical, top, bottom, left, right)',
        ),
      },
      requiredParameters: ['child', 'padding'],
      description: 'Applies padding around a child widget',
    ),

    WidgetTypes.center: const WidgetSpec(
      type: WidgetTypes.center,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to center',
        ),
        'widthFactor': ParameterSpec(
          name: 'widthFactor',
          type: dynamic,
          description: 'Width factor relative to child size',
        ),
        'heightFactor': ParameterSpec(
          name: 'heightFactor',
          type: dynamic,
          description: 'Height factor relative to child size',
        ),
      },
      requiredParameters: ['child'],
      description: 'Centers its child within available space',
    ),

    WidgetTypes.container: const WidgetSpec(
      type: WidgetTypes.container,
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
          type: dynamic,
          description: 'Container width - supports both number and MCP UI DSL v1.0 format',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Container height - supports both number and MCP UI DSL v1.0 format',
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
      description: 'Legacy alias for box - a container with optional decoration and child',
    ),

    WidgetTypes.conditional: const WidgetSpec(
      type: WidgetTypes.conditional,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'condition': ParameterSpec(
          name: 'condition',
          type: dynamic,
          description: 'Boolean expression or binding to evaluate (if/then mode)',
        ),
        'then': ParameterSpec(
          name: 'then',
          type: Map,
          description: 'Widget to render when condition is true (if/then mode)',
        ),
        'else': ParameterSpec(
          name: 'else',
          type: Map,
          description: 'Widget to render when condition is false',
        ),
        'switch': ParameterSpec(
          name: 'switch',
          type: String,
          description: 'Expression to switch on (switch/cases mode)',
        ),
        'cases': ParameterSpec(
          name: 'cases',
          type: List,
          description: 'Array of {value, child} objects for switch mode',
        ),
        'default': ParameterSpec(
          name: 'default',
          type: Map,
          description: 'Default child widget if no case matches in switch mode',
        ),
      },
      requiredParameters: [],
      description: 'Conditionally renders a widget based on a boolean expression or switch',
    ),

    WidgetTypes.align: const WidgetSpec(
      type: WidgetTypes.align,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to align',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'center',
          allowedValues: [
            'topStart', 'topCenter', 'topEnd',
            'centerStart', 'center', 'centerEnd',
            'bottomStart', 'bottomCenter', 'bottomEnd',
            // Legacy LTR aliases for backward compatibility
            'topLeft', 'topRight',
            'centerLeft', 'centerRight',
            'bottomLeft', 'bottomRight',
          ],
          description: 'Alignment position within parent (RTL-safe)',
        ),
        'widthFactor': ParameterSpec(
          name: 'widthFactor',
          type: dynamic,
          description: 'Width factor relative to child',
        ),
        'heightFactor': ParameterSpec(
          name: 'heightFactor',
          type: dynamic,
          description: 'Height factor relative to child',
        ),
      },
      requiredParameters: ['child'],
      description: 'Aligns a child within its parent',
    ),

    WidgetTypes.spacer: const WidgetSpec(
      type: WidgetTypes.spacer,
      category: 'layout',
      parameters: {
        'flex': ParameterSpec(
          name: 'flex',
          type: int,
          defaultValue: 1,
          description: 'Flex factor for space allocation',
        ),
      },
      requiredParameters: [],
      description: 'An empty spacer that takes up space in a linear layout',
    ),

    WidgetTypes.wrap: const WidgetSpec(
      type: WidgetTypes.wrap,
      category: 'layout',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'List of child widgets that wrap to next line',
        ),
        'direction': ParameterSpec(
          name: 'direction',
          type: String,
          defaultValue: 'horizontal',
          allowedValues: ['horizontal', 'vertical'],
          description: 'Primary layout direction',
        ),
        'spacing': ParameterSpec(
          name: 'spacing',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Spacing between children along main axis',
        ),
        'runSpacing': ParameterSpec(
          name: 'runSpacing',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Spacing between runs (lines)',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'start',
          allowedValues: ['start', 'end', 'center', 'spaceBetween', 'spaceAround', 'spaceEvenly'],
          description: 'How children are aligned along the main axis',
        ),
        'runAlignment': ParameterSpec(
          name: 'runAlignment',
          type: String,
          defaultValue: 'start',
          allowedValues: ['start', 'end', 'center', 'spaceBetween', 'spaceAround', 'spaceEvenly'],
          description: 'How runs (lines) are aligned along the cross axis',
        ),
      },
      requiredParameters: ['children'],
      description: 'Wraps children to the next line when they overflow',
    ),

    WidgetTypes.positioned: const WidgetSpec(
      type: WidgetTypes.positioned,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to position within a stack',
        ),
        'top': ParameterSpec(
          name: 'top',
          type: dynamic,
          description: 'Distance from the top edge',
        ),
        'bottom': ParameterSpec(
          name: 'bottom',
          type: dynamic,
          description: 'Distance from the bottom edge',
        ),
        'left': ParameterSpec(
          name: 'left',
          type: dynamic,
          description: 'Distance from the left edge',
        ),
        'right': ParameterSpec(
          name: 'right',
          type: dynamic,
          description: 'Distance from the right edge',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Fixed width of the positioned child',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Fixed height of the positioned child',
        ),
      },
      requiredParameters: ['child'],
      description: 'Positions a child within a stack at specific coordinates',
    ),

    WidgetTypes.visibility: const WidgetSpec(
      type: WidgetTypes.visibility,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to show or hide',
        ),
        'visible': ParameterSpec(
          name: 'visible',
          type: bool,
          defaultValue: true,
          description: 'Whether the child is visible',
        ),
        'maintainSize': ParameterSpec(
          name: 'maintainSize',
          type: bool,
          defaultValue: false,
          description: 'Whether to maintain the child size when hidden',
        ),
        'replacement': ParameterSpec(
          name: 'replacement',
          type: Map,
          description: 'Widget to show when not visible',
        ),
        'maintainState': ParameterSpec(
          name: 'maintainState',
          type: bool,
          defaultValue: false,
          description: 'Whether to maintain widget state when hidden',
        ),
      },
      requiredParameters: ['child'],
      description: 'Controls visibility of a child widget',
    ),

    WidgetTypes.constrained: const WidgetSpec(
      type: WidgetTypes.constrained,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget to constrain',
        ),
        'minWidth': ParameterSpec(
          name: 'minWidth',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Minimum width constraint',
        ),
        'maxWidth': ParameterSpec(
          name: 'maxWidth',
          type: dynamic,
          description: 'Maximum width constraint',
        ),
        'minHeight': ParameterSpec(
          name: 'minHeight',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Minimum height constraint',
        ),
        'maxHeight': ParameterSpec(
          name: 'maxHeight',
          type: dynamic,
          description: 'Maximum height constraint',
        ),
      },
      requiredParameters: [],
      description: 'Applies size constraints to a child widget',
    ),

    WidgetTypes.aspectRatio: const WidgetSpec(
      type: WidgetTypes.aspectRatio,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget',
        ),
        'aspectRatio': ParameterSpec(
          name: 'aspectRatio',
          type: dynamic,
          required: true,
          description: 'Width-to-height ratio (e.g., 16/9 = 1.778)',
        ),
      },
      requiredParameters: ['aspectRatio'],
      description: 'Constrains a child to a specific aspect ratio',
    ),

    WidgetTypes.safeArea: const WidgetSpec(
      type: WidgetTypes.safeArea,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to inset from system UI',
        ),
        'top': ParameterSpec(
          name: 'top',
          type: bool,
          defaultValue: true,
          description: 'Whether to apply top safe area inset',
        ),
        'bottom': ParameterSpec(
          name: 'bottom',
          type: bool,
          defaultValue: true,
          description: 'Whether to apply bottom safe area inset',
        ),
        'left': ParameterSpec(
          name: 'left',
          type: bool,
          defaultValue: true,
          description: 'Whether to apply left safe area inset',
        ),
        'right': ParameterSpec(
          name: 'right',
          type: bool,
          defaultValue: true,
          description: 'Whether to apply right safe area inset',
        ),
      },
      requiredParameters: ['child'],
      description: 'Insets child to avoid system UI overlaps (notch, status bar)',
    ),

    WidgetTypes.indexedStack: const WidgetSpec(
      type: WidgetTypes.indexedStack,
      category: 'layout',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'List of child widgets, only one visible at a time',
        ),
        'index': ParameterSpec(
          name: 'index',
          type: int,
          defaultValue: 0,
          description: 'Index of the currently visible child',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'start',
          allowedValues: [
            'topStart', 'topCenter', 'topEnd',
            'centerStart', 'center', 'centerEnd',
            'bottomStart', 'bottomCenter', 'bottomEnd',
            // Legacy LTR aliases for backward compatibility
            'topLeft', 'topRight',
            'centerLeft', 'centerRight',
            'bottomLeft', 'bottomRight',
          ],
          description: 'How to align children (RTL-safe)',
        ),
      },
      requiredParameters: ['children'],
      description: 'Shows a single child from a list of children based on index',
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
          type: dynamic, // Support both number and MCP UI DSL v1.0 format
          description: 'Image width - supports both number and MCP UI DSL v1.0 format',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic, // Support both number and MCP UI DSL v1.0 format
          description: 'Image height - supports both number and MCP UI DSL v1.0 format',
        ),
        'fit': ParameterSpec(
          name: 'fit',
          type: String,
          defaultValue: 'contain',
          allowedValues: ['fill', 'contain', 'cover', 'fitWidth', 'fitHeight', 'none', 'scaleDown'],
          description: 'How to fit the image',
        ),
        'fallback': ParameterSpec(
          name: 'fallback',
          type: Map,
          description: 'Fallback widget to display on load failure',
        ),
        'fallbackUrl': ParameterSpec(
          name: 'fallbackUrl',
          type: String,
          description: 'Fallback image URL on load failure',
        ),
        'fallbackBehavior': ParameterSpec(
          name: 'fallbackBehavior',
          type: String,
          defaultValue: 'placeholder',
          allowedValues: ['hide', 'placeholder'],
          description: 'Behavior on image load failure',
        ),
        'loading': ParameterSpec(
          name: 'loading',
          type: Map,
          description: 'Loading placeholder widget shown while image loads',
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
          type: dynamic, // Support both number and MCP UI DSL v1.0 format
          defaultValue: 24.0,
          description: 'Icon size - supports both number and MCP UI DSL v1.0 format',
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
          type: dynamic, // Support both number and MCP UI DSL v1.0 format
          defaultValue: 24.0,
          description: 'Indicator size - supports both number and MCP UI DSL v1.0 format',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Indicator color',
        ),
        'value': ParameterSpec(
          name: 'value',
          type: dynamic, // Support both number and MCP UI DSL v1.0 format
          description: 'Progress value (0.0 to 1.0) - supports both number and MCP UI DSL v1.0 format',
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
        'onTap': ParameterSpec(
          name: 'onTap',
          type: Map,
          required: true,
          description: 'Click action',
        ),
        'onDoubleTap': ParameterSpec(
          name: 'onDoubleTap',
          type: Map,
          description: 'Double click action',
        ),
        'onLongPress': ParameterSpec(
          name: 'onLongPress',
          type: Map,
          description: 'Long press action',
        ),
        'onRightClick': ParameterSpec(
          name: 'onRightClick',
          type: Map,
          description: 'Right click action',
        ),
        'variant': ParameterSpec(
          name: 'variant',
          type: String,
          defaultValue: 'elevated',
          allowedValues: ['elevated', 'filled', 'outlined', 'text', 'icon'],
          description: 'Button variant',
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
      requiredParameters: ['label', 'onTap'],
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
        'onChange': ParameterSpec(
          name: 'onChange',
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
      requiredParameters: ['label', 'value', 'onChange'],
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
        'onChange': ParameterSpec(
          name: 'onChange',
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
      requiredParameters: ['label', 'value', 'onChange'],
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
        'onChange': ParameterSpec(
          name: 'onChange',
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
      requiredParameters: ['label', 'value', 'items', 'onChange'],
    ),

    // ===== Navigation Widgets =====
    WidgetTypes.headerBar: const WidgetSpec(
      type: WidgetTypes.headerBar,
      category: 'navigation',
      parameters: {
        'title': ParameterSpec(
          name: 'title',
          type: dynamic,
          required: true,
          description: 'Header title - accepts String or Widget Map',
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
          type: dynamic, // Support both number and MCP UI DSL v1.0 format
          defaultValue: 4.0,
          description: 'Header elevation - supports both number and MCP UI DSL v1.0 format',
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
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Selection change action',
        ),
        'type': ParameterSpec(
          name: 'type',
          type: String,
          defaultValue: 'fixed',
          allowedValues: ['fixed', 'shifting'],
          description: 'Navigation bar type',
        ),
      },
      requiredParameters: ['currentIndex', 'items', 'onChange'],
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
        'itemTemplate': ParameterSpec(
          name: 'itemTemplate',
          type: Map,
          required: true,
          description: 'Item template widget',
        ),
        'orientation': ParameterSpec(
          name: 'orientation',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Scroll direction',
        ),
        'spacing': ParameterSpec(
          name: 'spacing',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Spacing between list items',
        ),
        'shrinkWrap': ParameterSpec(
          name: 'shrinkWrap',
          type: bool,
          defaultValue: false,
          description: 'Whether to shrink wrap contents',
        ),
      },
      requiredParameters: ['items', 'itemTemplate'],
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
        'direction': ParameterSpec(
          name: 'direction',
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

    // ===== Display Widgets (extended) =====
    WidgetTypes.card: const WidgetSpec(
      type: WidgetTypes.card,
      category: 'display',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Single child widget',
        ),
        'elevation': ParameterSpec(
          name: 'elevation',
          type: dynamic,
          defaultValue: 1.0,
          description: 'Card elevation shadow depth',
        ),
        'margin': ParameterSpec(
          name: 'margin',
          type: Map,
          description: 'Outer margin',
        ),
        'shape': ParameterSpec(
          name: 'shape',
          type: Map,
          description: 'Card shape (type, radius)',
        ),
      },
      requiredParameters: [],
    ),

    WidgetTypes.divider: const WidgetSpec(
      type: WidgetTypes.divider,
      category: 'display',
      parameters: {
        'thickness': ParameterSpec(
          name: 'thickness',
          type: dynamic,
          defaultValue: 1.0,
          description: 'Divider thickness',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Divider color',
        ),
        'indent': ParameterSpec(
          name: 'indent',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Leading indent',
        ),
        'endIndent': ParameterSpec(
          name: 'endIndent',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Trailing indent',
        ),
      },
      requiredParameters: [],
    ),

    WidgetTypes.badge: const WidgetSpec(
      type: WidgetTypes.badge,
      category: 'display',
      canHaveChild: true,
      parameters: {
        'label': ParameterSpec(
          name: 'label',
          type: String,
          required: true,
          description: 'Badge label text',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Badge background color',
        ),
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget the badge is attached to',
        ),
      },
      requiredParameters: ['label'],
    ),

    WidgetTypes.chip: const WidgetSpec(
      type: WidgetTypes.chip,
      category: 'display',
      parameters: {
        'label': ParameterSpec(
          name: 'label',
          type: String,
          required: true,
          description: 'Chip label text',
        ),
        'avatar': ParameterSpec(
          name: 'avatar',
          type: Map,
          description: 'Leading widget (icon or image)',
        ),
        'deleteIcon': ParameterSpec(
          name: 'deleteIcon',
          type: Map,
          description: 'Custom delete icon widget',
        ),
        'onDelete': ParameterSpec(
          name: 'onDelete',
          type: Map,
          description: 'Action when delete icon is tapped',
        ),
        'selected': ParameterSpec(
          name: 'selected',
          type: bool,
          defaultValue: false,
          description: 'Whether the chip is selected',
        ),
        'variant': ParameterSpec(
          name: 'variant',
          type: String,
          defaultValue: 'filled',
          allowedValues: ['filled', 'outlined'],
          description: 'Visual variant of the chip',
        ),
      },
      requiredParameters: ['label'],
    ),

    WidgetTypes.avatar: const WidgetSpec(
      type: WidgetTypes.avatar,
      category: 'display',
      parameters: {
        'src': ParameterSpec(
          name: 'src',
          type: String,
          description: 'Image URL or path',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Fallback initials or text',
        ),
        'size': ParameterSpec(
          name: 'size',
          type: dynamic,
          defaultValue: 40.0,
          description: 'Diameter of the avatar',
        ),
        'backgroundColor': ParameterSpec(
          name: 'backgroundColor',
          type: String,
          defaultValue: '#E0E0E0',
          description: 'Background color when showing label',
        ),
      },
      requiredParameters: [],
    ),

    WidgetTypes.tooltip: const WidgetSpec(
      type: WidgetTypes.tooltip,
      category: 'display',
      canHaveChild: true,
      parameters: {
        'message': ParameterSpec(
          name: 'message',
          type: String,
          required: true,
          description: 'Tooltip message text',
        ),
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Widget that triggers the tooltip',
        ),
      },
      requiredParameters: ['message', 'child'],
    ),

    // ===== Input Widgets (extended) =====
    WidgetTypes.slider: const WidgetSpec(
      type: WidgetTypes.slider,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Current slider value',
        ),
        'min': ParameterSpec(
          name: 'min',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Minimum value',
        ),
        'max': ParameterSpec(
          name: 'max',
          type: dynamic,
          defaultValue: 1.0,
          description: 'Maximum value',
        ),
        'divisions': ParameterSpec(
          name: 'divisions',
          type: int,
          description: 'Number of discrete divisions',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action',
        ),
      },
      requiredParameters: ['value', 'onChange'],
    ),

    WidgetTypes.radio: const WidgetSpec(
      type: WidgetTypes.radio,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Value this radio represents',
        ),
        'groupValue': ParameterSpec(
          name: 'groupValue',
          type: dynamic,
          required: true,
          description: 'Currently selected value in the group',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action',
        ),
      },
      requiredParameters: ['value', 'groupValue', 'onChange'],
    ),

    WidgetTypes.toggle: const WidgetSpec(
      type: WidgetTypes.toggle,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Current toggle value (true/false)',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action',
        ),
      },
      requiredParameters: ['value', 'onChange'],
    ),

    WidgetTypes.form: const WidgetSpec(
      type: WidgetTypes.form,
      category: 'input',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'Input widgets within the form',
        ),
        'onSubmit': ParameterSpec(
          name: 'onSubmit',
          type: Map,
          description: 'Action triggered on form submission',
        ),
      },
      requiredParameters: ['children'],
    ),

    // ===== Navigation Widgets (extended) =====
    WidgetTypes.tabBar: const WidgetSpec(
      type: WidgetTypes.tabBar,
      category: 'navigation',
      parameters: {
        'tabs': ParameterSpec(
          name: 'tabs',
          type: List,
          required: true,
          description: 'Array of tab objects ({label, icon})',
        ),
        'content': ParameterSpec(
          name: 'content',
          type: List,
          description: 'Content widgets for each tab',
        ),
      },
      requiredParameters: ['tabs'],
    ),

    WidgetTypes.drawer: const WidgetSpec(
      type: WidgetTypes.drawer,
      category: 'navigation',
      canHaveChild: true,
      parameters: {
        'header': ParameterSpec(
          name: 'header',
          type: Map,
          description: 'Drawer header widget',
        ),
        'items': ParameterSpec(
          name: 'items',
          type: List,
          description: 'Navigation items ({title, icon, route})',
        ),
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Custom drawer content widget',
        ),
      },
      requiredParameters: [],
    ),

    // ===== List Widgets (extended) =====
    WidgetTypes.grid: const WidgetSpec(
      type: WidgetTypes.grid,
      category: 'list',
      parameters: {
        'items': ParameterSpec(
          name: 'items',
          type: String,
          required: true,
          description: 'Data binding expression for grid items',
        ),
        'columns': ParameterSpec(
          name: 'columns',
          type: int,
          required: true,
          description: 'Number of columns',
        ),
        'rowGap': ParameterSpec(
          name: 'rowGap',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Gap between rows',
        ),
        'columnGap': ParameterSpec(
          name: 'columnGap',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Gap between columns',
        ),
        'itemAspectRatio': ParameterSpec(
          name: 'itemAspectRatio',
          type: dynamic,
          defaultValue: 1.0,
          description: 'Aspect ratio for each grid item',
        ),
        'itemTemplate': ParameterSpec(
          name: 'itemTemplate',
          type: Map,
          required: true,
          description: 'Template widget for each grid item',
        ),
      },
      requiredParameters: ['items', 'columns', 'itemTemplate'],
    ),

    // ===== Advanced Widgets (extended) =====
    WidgetTypes.table: const WidgetSpec(
      type: WidgetTypes.table,
      category: 'layout',
      parameters: {
        'rows': ParameterSpec(
          name: 'rows',
          type: List,
          required: true,
          description: 'Array of {cells: [...]} objects. Each cell is a widget definition',
        ),
        'border': ParameterSpec(
          name: 'border',
          type: Map,
          description: 'Table border configuration ({color, width})',
        ),
        'defaultColumnWidth': ParameterSpec(
          name: 'defaultColumnWidth',
          type: String,
          description: 'Default column width strategy',
        ),
        'defaultVerticalAlignment': ParameterSpec(
          name: 'defaultVerticalAlignment',
          type: String,
          defaultValue: 'top',
          allowedValues: ['top', 'middle', 'bottom', 'baseline'],
          description: 'Default vertical alignment for cells',
        ),
        'textDirection': ParameterSpec(
          name: 'textDirection',
          type: String,
          allowedValues: ['ltr', 'rtl'],
          description: 'Text direction for the table',
        ),
      },
      requiredParameters: ['rows'],
      description: 'Layout table for arranging widgets in rows and columns (Flutter Table)',
    ),

    WidgetTypes.dataTable: const WidgetSpec(
      type: WidgetTypes.dataTable,
      category: 'advanced',
      parameters: {
        'columns': ParameterSpec(
          name: 'columns',
          type: List,
          required: true,
          description: 'Column definitions ({key, label, width, sortable, align})',
        ),
        'rows': ParameterSpec(
          name: 'rows',
          type: dynamic,
          required: true,
          description: 'Row data binding expression or array',
        ),
        'selectable': ParameterSpec(
          name: 'selectable',
          type: bool,
          defaultValue: false,
          description: 'Whether rows are selectable',
        ),
        'pagination': ParameterSpec(
          name: 'pagination',
          type: Map,
          description: 'Pagination configuration',
        ),
        'rowClick': ParameterSpec(
          name: 'rowClick',
          type: Map,
          description: 'Action when a row is clicked',
        ),
      },
      requiredParameters: ['columns', 'rows'],
      description: 'Data-bound table with column definitions, sorting, selection, and row actions',
    ),

    // ===== Dialog Widgets =====
    WidgetTypes.snackBar: const WidgetSpec(
      type: WidgetTypes.snackBar,
      category: 'dialog',
      parameters: {
        'content': ParameterSpec(
          name: 'content',
          type: dynamic,
          required: true,
          description: 'Message text or custom widget',
        ),
        'action': ParameterSpec(
          name: 'action',
          type: Map,
          description: 'Optional action (e.g., Undo)',
        ),
        'duration': ParameterSpec(
          name: 'duration',
          type: int,
          defaultValue: 4000,
          description: 'Display duration in milliseconds',
        ),
      },
      requiredParameters: ['content'],
    ),

    WidgetTypes.alertDialog: const WidgetSpec(
      type: WidgetTypes.alertDialog,
      category: 'dialog',
      parameters: {
        'title': ParameterSpec(
          name: 'title',
          type: String,
          required: true,
          description: 'Dialog title',
        ),
        'content': ParameterSpec(
          name: 'content',
          type: dynamic,
          description: 'Dialog content text or widget',
        ),
        'dismissible': ParameterSpec(
          name: 'dismissible',
          type: bool,
          defaultValue: true,
          description: 'Whether dialog can be dismissed by tapping outside',
        ),
        'actions': ParameterSpec(
          name: 'actions',
          type: List,
          description: 'Dialog action buttons ({label, action, primary})',
        ),
      },
      requiredParameters: ['title'],
    ),

    // ===== Display Widgets (additional) =====
    WidgetTypes.progressBar: const WidgetSpec(
      type: WidgetTypes.progressBar,
      category: 'display',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          description: 'Progress value (0.0 to 1.0), null for indeterminate',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Progress bar color',
        ),
        'backgroundColor': ParameterSpec(
          name: 'backgroundColor',
          type: String,
          description: 'Background track color',
        ),
        'type': ParameterSpec(
          name: 'type',
          type: String,
          defaultValue: 'linear',
          allowedValues: ['linear', 'circular'],
          description: 'Type of progress indicator',
        ),
      },
      requiredParameters: [],
      description: 'Displays progress as a linear or circular bar',
    ),

    WidgetTypes.richText: const WidgetSpec(
      type: WidgetTypes.richText,
      category: 'display',
      parameters: {
        'spans': ParameterSpec(
          name: 'spans',
          type: List,
          required: true,
          description: 'List of text spans with individual styles',
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
      requiredParameters: ['spans'],
      description: 'Displays text with mixed styles using text spans',
    ),

    WidgetTypes.verticalDivider: const WidgetSpec(
      type: WidgetTypes.verticalDivider,
      category: 'display',
      parameters: {
        'thickness': ParameterSpec(
          name: 'thickness',
          type: dynamic,
          defaultValue: 1.0,
          description: 'Divider thickness',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Divider color',
        ),
        'indent': ParameterSpec(
          name: 'indent',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Top indent',
        ),
        'endIndent': ParameterSpec(
          name: 'endIndent',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Bottom indent',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Total width including the divider line',
        ),
      },
      requiredParameters: [],
      description: 'A vertical line divider for horizontal layouts',
    ),

    WidgetTypes.placeholder: const WidgetSpec(
      type: WidgetTypes.placeholder,
      category: 'display',
      parameters: {
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Placeholder width',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Placeholder height',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          defaultValue: '#9E9E9E',
          description: 'Placeholder cross-hatch color',
        ),
      },
      requiredParameters: [],
      description: 'A placeholder widget that draws a cross-hatch pattern',
    ),

    WidgetTypes.banner: const WidgetSpec(
      type: WidgetTypes.banner,
      category: 'display',
      canHaveChildren: true,
      parameters: {
        'content': ParameterSpec(
          name: 'content',
          type: dynamic,
          required: true,
          description: 'Banner message text or widget',
        ),
        'actions': ParameterSpec(
          name: 'actions',
          type: List,
          description: 'Action buttons for the banner',
        ),
        'leading': ParameterSpec(
          name: 'leading',
          type: Map,
          description: 'Leading icon or widget',
        ),
        'backgroundColor': ParameterSpec(
          name: 'backgroundColor',
          type: String,
          description: 'Banner background color',
        ),
      },
      requiredParameters: ['content'],
      description: 'A banner displayed at the top of a screen with optional actions',
    ),

    // ===== Input Widgets (additional) =====
    WidgetTypes.iconButton: const WidgetSpec(
      type: WidgetTypes.iconButton,
      category: 'input',
      parameters: {
        'icon': ParameterSpec(
          name: 'icon',
          type: String,
          required: true,
          description: 'Icon identifier',
        ),
        'onTap': ParameterSpec(
          name: 'onTap',
          type: Map,
          required: true,
          description: 'Click action',
        ),
        'size': ParameterSpec(
          name: 'size',
          type: dynamic,
          defaultValue: 24.0,
          description: 'Icon size',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Icon color',
        ),
        'tooltip': ParameterSpec(
          name: 'tooltip',
          type: String,
          description: 'Tooltip message on hover/long-press',
        ),
        'disabled': ParameterSpec(
          name: 'disabled',
          type: bool,
          defaultValue: false,
          description: 'Whether button is disabled',
        ),
      },
      requiredParameters: ['icon', 'onTap'],
      description: 'A button that displays an icon without a label',
    ),

    WidgetTypes.textFormField: const WidgetSpec(
      type: WidgetTypes.textFormField,
      category: 'input',
      parameters: {
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current value',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
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
          description: 'Helper text below the field',
        ),
        'errorText': ParameterSpec(
          name: 'errorText',
          type: String,
          description: 'Error message text',
        ),
        'validator': ParameterSpec(
          name: 'validator',
          type: Map,
          description: 'Validation rules for the field',
        ),
        'obscureText': ParameterSpec(
          name: 'obscureText',
          type: bool,
          defaultValue: false,
          description: 'Whether to obscure text input',
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
      requiredParameters: ['value', 'onChange'],
      description: 'A text input field with built-in form validation support',
    ),

    WidgetTypes.rangeSlider: const WidgetSpec(
      type: WidgetTypes.rangeSlider,
      category: 'input',
      parameters: {
        'values': ParameterSpec(
          name: 'values',
          type: List,
          required: true,
          description: 'Current range values [start, end]',
        ),
        'min': ParameterSpec(
          name: 'min',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Minimum value',
        ),
        'max': ParameterSpec(
          name: 'max',
          type: dynamic,
          defaultValue: 1.0,
          description: 'Maximum value',
        ),
        'divisions': ParameterSpec(
          name: 'divisions',
          type: int,
          description: 'Number of discrete divisions',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when range changes',
        ),
      },
      requiredParameters: ['values', 'onChange'],
      description: 'A slider that selects a range between two values',
    ),

    WidgetTypes.radioGroup: const WidgetSpec(
      type: WidgetTypes.radioGroup,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Currently selected value',
        ),
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'List of radio items ({value, label})',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when selection changes',
        ),
        'direction': ParameterSpec(
          name: 'direction',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Layout direction for radio items',
        ),
      },
      requiredParameters: ['value', 'items', 'onChange'],
      description: 'A group of radio buttons for single selection',
    ),

    WidgetTypes.checkboxGroup: const WidgetSpec(
      type: WidgetTypes.checkboxGroup,
      category: 'input',
      parameters: {
        'values': ParameterSpec(
          name: 'values',
          type: List,
          required: true,
          description: 'List of currently selected values',
        ),
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'List of checkbox items ({value, label})',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when selection changes',
        ),
        'direction': ParameterSpec(
          name: 'direction',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Layout direction for checkbox items',
        ),
      },
      requiredParameters: ['values', 'items', 'onChange'],
      description: 'A group of checkboxes for multiple selection',
    ),

    WidgetTypes.segmentedControl: const WidgetSpec(
      type: WidgetTypes.segmentedControl,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Currently selected segment value',
        ),
        'segments': ParameterSpec(
          name: 'segments',
          type: List,
          required: true,
          description: 'List of segment items ({value, label, icon})',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when segment changes',
        ),
      },
      requiredParameters: ['value', 'segments', 'onChange'],
      description: 'A horizontal set of mutually exclusive segments',
    ),

    WidgetTypes.dateField: const WidgetSpec(
      type: WidgetTypes.dateField,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current date value (ISO 8601 format)',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when date changes',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
        'firstDate': ParameterSpec(
          name: 'firstDate',
          type: String,
          description: 'Earliest selectable date (ISO 8601)',
        ),
        'lastDate': ParameterSpec(
          name: 'lastDate',
          type: String,
          description: 'Latest selectable date (ISO 8601)',
        ),
      },
      requiredParameters: ['value', 'onChange'],
      description: 'A date input field with date picker support',
    ),

    WidgetTypes.timeField: const WidgetSpec(
      type: WidgetTypes.timeField,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current time value (HH:mm format)',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when time changes',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
      },
      requiredParameters: ['value', 'onChange'],
      description: 'A time input field with time picker support',
    ),

    WidgetTypes.stepper: const WidgetSpec(
      type: WidgetTypes.stepper,
      category: 'input',
      parameters: {
        'currentStep': ParameterSpec(
          name: 'currentStep',
          type: int,
          required: true,
          description: 'Index of the currently active step',
        ),
        'steps': ParameterSpec(
          name: 'steps',
          type: List,
          required: true,
          description: 'List of step objects ({title, content, subtitle})',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Action when step changes',
        ),
        'type': ParameterSpec(
          name: 'type',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Stepper layout direction',
        ),
      },
      requiredParameters: ['currentStep', 'steps'],
      description: 'A multi-step form or wizard interface',
    ),

    WidgetTypes.popupMenuButton: const WidgetSpec(
      type: WidgetTypes.popupMenuButton,
      category: 'navigation',
      parameters: {
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'List of menu items ({value, label, icon})',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Action when a menu item is selected',
        ),
        'icon': ParameterSpec(
          name: 'icon',
          type: String,
          description: 'Icon for the menu button',
        ),
        'tooltip': ParameterSpec(
          name: 'tooltip',
          type: String,
          description: 'Tooltip message',
        ),
      },
      requiredParameters: ['items', 'onChange'],
      description: 'A button that shows a popup menu when pressed',
    ),

    // ===== List Widgets (additional) =====
    WidgetTypes.listTile: const WidgetSpec(
      type: WidgetTypes.listTile,
      category: 'list',
      parameters: {
        'title': ParameterSpec(
          name: 'title',
          type: dynamic,
          required: true,
          description: 'Title text or widget',
        ),
        'subtitle': ParameterSpec(
          name: 'subtitle',
          type: dynamic,
          description: 'Subtitle text or widget',
        ),
        'leading': ParameterSpec(
          name: 'leading',
          type: Map,
          description: 'Leading widget (icon, avatar, etc.)',
        ),
        'trailing': ParameterSpec(
          name: 'trailing',
          type: Map,
          description: 'Trailing widget (icon, text, etc.)',
        ),
        'onTap': ParameterSpec(
          name: 'onTap',
          type: Map,
          description: 'Action when tile is tapped',
        ),
        'dense': ParameterSpec(
          name: 'dense',
          type: bool,
          defaultValue: false,
          description: 'Whether to use dense layout',
        ),
      },
      requiredParameters: ['title'],
      description: 'A single row in a list with optional leading and trailing widgets',
    ),

    // ===== Navigation Widgets (additional) =====
    WidgetTypes.tabBarView: const WidgetSpec(
      type: WidgetTypes.tabBarView,
      category: 'navigation',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'Content widgets for each tab',
        ),
      },
      requiredParameters: ['children'],
      description: 'Displays content for the selected tab in a tabBar',
    ),

    WidgetTypes.navigationRail: const WidgetSpec(
      type: WidgetTypes.navigationRail,
      category: 'navigation',
      parameters: {
        'selectedIndex': ParameterSpec(
          name: 'selectedIndex',
          type: int,
          required: true,
          description: 'Currently selected destination index',
        ),
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'List of navigation items ({icon, label})',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Action when selection changes',
        ),
        'extended': ParameterSpec(
          name: 'extended',
          type: bool,
          defaultValue: false,
          description: 'Whether to show labels next to icons',
        ),
        'leading': ParameterSpec(
          name: 'leading',
          type: Map,
          description: 'Widget above the destinations',
        ),
      },
      requiredParameters: ['selectedIndex', 'items', 'onChange'],
      description: 'A vertical navigation rail for desktop/tablet layouts',
    ),

    WidgetTypes.floatingActionButton: const WidgetSpec(
      type: WidgetTypes.floatingActionButton,
      category: 'navigation',
      parameters: {
        'onTap': ParameterSpec(
          name: 'onTap',
          type: Map,
          required: true,
          description: 'Click action',
        ),
        'icon': ParameterSpec(
          name: 'icon',
          type: String,
          description: 'Button icon',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Button label (for extended FAB)',
        ),
        'extended': ParameterSpec(
          name: 'extended',
          type: bool,
          defaultValue: false,
          description: 'Whether to show as extended FAB with label',
        ),
        'tooltip': ParameterSpec(
          name: 'tooltip',
          type: String,
          description: 'Tooltip message',
        ),
      },
      requiredParameters: ['onTap'],
      description: 'A floating action button for primary screen actions',
    ),

    // ===== Scroll Widgets (additional) =====
    WidgetTypes.singleChildScrollView: const WidgetSpec(
      type: WidgetTypes.singleChildScrollView,
      category: 'scroll',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Single child widget to scroll',
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
          description: 'Content padding',
        ),
      },
      requiredParameters: ['child'],
      description: 'A scroll view for a single child that might exceed available space',
    ),

    WidgetTypes.pageView: const WidgetSpec(
      type: WidgetTypes.pageView,
      category: 'scroll',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'List of page widgets',
        ),
        'scrollDirection': ParameterSpec(
          name: 'scrollDirection',
          type: String,
          defaultValue: 'horizontal',
          allowedValues: ['horizontal', 'vertical'],
          description: 'Page scroll direction',
        ),
        'initialPage': ParameterSpec(
          name: 'initialPage',
          type: int,
          defaultValue: 0,
          description: 'Initial page index',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Action when page changes',
        ),
      },
      requiredParameters: ['children'],
      description: 'A scrollable page view with swipe-based page navigation',
    ),

    // ===== Dialog Widgets (additional) =====
    WidgetTypes.bottomSheet: const WidgetSpec(
      type: WidgetTypes.bottomSheet,
      category: 'dialog',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Content widget of the bottom sheet',
        ),
        'dismissible': ParameterSpec(
          name: 'dismissible',
          type: bool,
          defaultValue: true,
          description: 'Whether the sheet can be dismissed by dragging',
        ),
        'showDragHandle': ParameterSpec(
          name: 'showDragHandle',
          type: bool,
          defaultValue: true,
          description: 'Whether to show a drag handle at the top',
        ),
      },
      requiredParameters: ['child'],
      description: 'A bottom sheet that slides up from the bottom of the screen',
    ),

    WidgetTypes.simpleDialog: const WidgetSpec(
      type: WidgetTypes.simpleDialog,
      category: 'dialog',
      parameters: {
        'title': ParameterSpec(
          name: 'title',
          type: String,
          description: 'Dialog title',
        ),
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'List of selectable items ({label, value, icon})',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Action when an item is selected',
        ),
      },
      requiredParameters: ['items'],
      description: 'A simple dialog with a list of selectable options',
    ),

    WidgetTypes.customDialog: const WidgetSpec(
      type: WidgetTypes.customDialog,
      category: 'dialog',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Custom dialog content widget',
        ),
        'dismissible': ParameterSpec(
          name: 'dismissible',
          type: bool,
          defaultValue: true,
          description: 'Whether dialog can be dismissed by tapping outside',
        ),
        'shape': ParameterSpec(
          name: 'shape',
          type: Map,
          description: 'Dialog shape configuration',
        ),
      },
      requiredParameters: ['child'],
      description: 'A fully custom dialog with arbitrary content',
    ),

    // ===== Interactive Widgets =====
    WidgetTypes.gestureDetector: const WidgetSpec(
      type: WidgetTypes.gestureDetector,
      category: 'interactive',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget that receives gestures',
        ),
        'onTap': ParameterSpec(
          name: 'onTap',
          type: Map,
          description: 'Tap action',
        ),
        'onDoubleTap': ParameterSpec(
          name: 'onDoubleTap',
          type: Map,
          description: 'Double tap action',
        ),
        'onLongPress': ParameterSpec(
          name: 'onLongPress',
          type: Map,
          description: 'Long press action',
        ),
        'pan': ParameterSpec(
          name: 'pan',
          type: Map,
          description: 'Pan/drag gesture action',
        ),
      },
      requiredParameters: ['child'],
      description: 'Detects gestures on a child widget',
    ),

    WidgetTypes.inkWell: const WidgetSpec(
      type: WidgetTypes.inkWell,
      category: 'interactive',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget with ink splash effect',
        ),
        'onTap': ParameterSpec(
          name: 'onTap',
          type: Map,
          description: 'Tap action',
        ),
        'onDoubleTap': ParameterSpec(
          name: 'onDoubleTap',
          type: Map,
          description: 'Double tap action',
        ),
        'onLongPress': ParameterSpec(
          name: 'onLongPress',
          type: Map,
          description: 'Long press action',
        ),
        'splashColor': ParameterSpec(
          name: 'splashColor',
          type: String,
          description: 'Ink splash color',
        ),
        'borderRadius': ParameterSpec(
          name: 'borderRadius',
          type: dynamic,
          description: 'Border radius for ink splash clipping',
        ),
      },
      requiredParameters: ['child'],
      description: 'A material ink well effect wrapper with gesture detection',
    ),

    // ===== Animation Widgets =====
    WidgetTypes.animatedContainer: const WidgetSpec(
      type: WidgetTypes.animatedContainer,
      category: 'animation',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget',
        ),
        'duration': ParameterSpec(
          name: 'duration',
          type: int,
          defaultValue: 300,
          description: 'Animation duration in milliseconds',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Animated width',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Animated height',
        ),
        'color': ParameterSpec(
          name: 'color',
          type: String,
          description: 'Animated background color',
        ),
        'padding': ParameterSpec(
          name: 'padding',
          type: Map,
          description: 'Animated padding',
        ),
        'margin': ParameterSpec(
          name: 'margin',
          type: Map,
          description: 'Animated margin',
        ),
        'decoration': ParameterSpec(
          name: 'decoration',
          type: Map,
          description: 'Animated decoration',
        ),
        'curve': ParameterSpec(
          name: 'curve',
          type: String,
          defaultValue: 'easeInOut',
          description: 'Animation curve',
        ),
      },
      requiredParameters: [],
      description: 'A container that animates property changes',
    ),

    // ===== Advanced Widgets (additional) =====
    WidgetTypes.chart: const WidgetSpec(
      type: WidgetTypes.chart,
      category: 'advanced',
      parameters: {
        'chartType': ParameterSpec(
          name: 'chartType',
          type: String,
          required: true,
          allowedValues: ['line', 'bar', 'pie', 'scatter', 'area', 'radar'],
          description: 'Type of chart to render',
        ),
        'data': ParameterSpec(
          name: 'data',
          type: dynamic,
          required: true,
          description: 'Chart data series',
        ),
        'title': ParameterSpec(
          name: 'title',
          type: String,
          description: 'Chart title',
        ),
        'legend': ParameterSpec(
          name: 'legend',
          type: bool,
          defaultValue: true,
          description: 'Whether to show legend',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Chart width',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Chart height',
        ),
      },
      requiredParameters: ['chartType', 'data'],
      description: 'A chart widget supporting multiple chart types',
    ),

    WidgetTypes.calendar: const WidgetSpec(
      type: WidgetTypes.calendar,
      category: 'advanced',
      parameters: {
        'selectedDate': ParameterSpec(
          name: 'selectedDate',
          type: String,
          description: 'Currently selected date (ISO 8601)',
        ),
        'firstDate': ParameterSpec(
          name: 'firstDate',
          type: String,
          description: 'Earliest selectable date',
        ),
        'lastDate': ParameterSpec(
          name: 'lastDate',
          type: String,
          description: 'Latest selectable date',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Action when date selection changes',
        ),
        'events': ParameterSpec(
          name: 'events',
          type: dynamic,
          description: 'Event data for calendar dates',
        ),
      },
      requiredParameters: [],
      description: 'A calendar widget for date display and selection',
    ),

    WidgetTypes.markdown: const WidgetSpec(
      type: WidgetTypes.markdown,
      category: 'advanced',
      parameters: {
        'content': ParameterSpec(
          name: 'content',
          type: String,
          required: true,
          description: 'Markdown content string',
        ),
        'selectable': ParameterSpec(
          name: 'selectable',
          type: bool,
          defaultValue: false,
          description: 'Whether text is selectable',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Width of the markdown container',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Height of the markdown container',
        ),
        'fontSize': ParameterSpec(
          name: 'fontSize',
          type: dynamic,
          description: 'Base font size for markdown text',
        ),
        'textColor': ParameterSpec(
          name: 'textColor',
          type: String,
          description: 'Default text color for markdown content',
        ),
        'linkColor': ParameterSpec(
          name: 'linkColor',
          type: String,
          description: 'Color for hyperlinks in markdown',
        ),
        'onLinkTap': ParameterSpec(
          name: 'onLinkTap',
          type: Map,
          description: 'Action to execute when a link is tapped',
        ),
      },
      requiredParameters: ['content'],
      description: 'Renders markdown content as formatted text',
    ),

    WidgetTypes.webView: const WidgetSpec(
      type: WidgetTypes.webView,
      category: 'advanced',
      parameters: {
        'url': ParameterSpec(
          name: 'url',
          type: String,
          required: true,
          description: 'URL to load in the web view',
        ),
        'enableJavaScript': ParameterSpec(
          name: 'enableJavaScript',
          type: bool,
          defaultValue: true,
          description: 'Whether JavaScript is enabled',
        ),
        'enableZoom': ParameterSpec(
          name: 'enableZoom',
          type: bool,
          defaultValue: true,
          description: 'Whether pinch-to-zoom is enabled',
        ),
        'html': ParameterSpec(
          name: 'html',
          type: String,
          description: 'Raw HTML content to render instead of a URL',
        ),
        'onPageStarted': ParameterSpec(
          name: 'onPageStarted',
          type: Map,
          description: 'Action when page starts loading',
        ),
        'onPageFinished': ParameterSpec(
          name: 'onPageFinished',
          type: Map,
          description: 'Action when page finishes loading',
        ),
        'onError': ParameterSpec(
          name: 'onError',
          type: Map,
          description: 'Action when a page load error occurs',
        ),
      },
      requiredParameters: ['url'],
      description: 'An embedded web view for displaying web content',
    ),

    // ===== Performance Widgets =====
    WidgetTypes.lazy: const WidgetSpec(
      type: WidgetTypes.lazy,
      category: 'performance',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to lazily load',
        ),
        'placeholder': ParameterSpec(
          name: 'placeholder',
          type: Map,
          description: 'Placeholder widget shown while loading',
        ),
      },
      requiredParameters: ['child'],
      description: 'Lazily loads a child widget for performance optimization',
    ),

    // ===== Security Widgets =====
    WidgetTypes.errorBoundary: const WidgetSpec(
      type: WidgetTypes.errorBoundary,
      category: 'utility',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to wrap with error handling',
        ),
        'fallback': ParameterSpec(
          name: 'fallback',
          type: Map,
          description: 'Widget to display when an error occurs',
        ),
        'onError': ParameterSpec(
          name: 'onError',
          type: Map,
          description: 'Action to execute when an error is caught',
        ),
      },
      requiredParameters: ['child'],
      description: 'Catches errors in the child widget tree and shows a fallback',
    ),

    WidgetTypes.permissionPrompt: const WidgetSpec(
      type: WidgetTypes.permissionPrompt,
      category: 'security',
      canHaveChild: true,
      parameters: {
        'permission': ParameterSpec(
          name: 'permission',
          type: String,
          required: true,
          description: 'Permission type to request (e.g., camera, location, storage)',
        ),
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget shown after permission is granted',
        ),
        'deniedFallback': ParameterSpec(
          name: 'deniedFallback',
          type: Map,
          description: 'Widget shown when permission is denied',
        ),
        'rationale': ParameterSpec(
          name: 'rationale',
          type: String,
          description: 'Explanation of why the permission is needed',
        ),
      },
      requiredParameters: ['permission', 'child'],
      description: 'Prompts the user for a permission before showing child content',
    ),

    WidgetTypes.offlineFallback: const WidgetSpec(
      type: WidgetTypes.offlineFallback,
      category: 'security',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget shown when online',
        ),
        'fallback': ParameterSpec(
          name: 'fallback',
          type: Map,
          description: 'Widget shown when offline',
        ),
        'showRetry': ParameterSpec(
          name: 'showRetry',
          type: bool,
          defaultValue: true,
          description: 'Whether to show a retry button when offline',
        ),
      },
      requiredParameters: ['child'],
      description: 'Shows a fallback widget when the device is offline',
    ),

    WidgetTypes.errorRecovery: const WidgetSpec(
      type: WidgetTypes.errorRecovery,
      category: 'security',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to wrap with error recovery',
        ),
        'fallback': ParameterSpec(
          name: 'fallback',
          type: Map,
          description: 'Widget shown during error state',
        ),
        'retryAction': ParameterSpec(
          name: 'retryAction',
          type: Map,
          description: 'Action to execute on retry',
        ),
        'maxRetries': ParameterSpec(
          name: 'maxRetries',
          type: int,
          defaultValue: 3,
          description: 'Maximum number of automatic retry attempts',
        ),
      },
      requiredParameters: ['child'],
      description: 'Wraps a child with automatic error recovery and retry logic',
    ),

    // ===== Accessibility Widgets =====
    WidgetTypes.accessibleWrapper: const WidgetSpec(
      type: WidgetTypes.accessibleWrapper,
      category: 'accessibility',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to wrap with accessibility semantics',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Semantic label for screen readers',
        ),
        'hint': ParameterSpec(
          name: 'hint',
          type: String,
          description: 'Accessibility hint describing the action',
        ),
        'excludeSemantics': ParameterSpec(
          name: 'excludeSemantics',
          type: bool,
          defaultValue: false,
          description: 'Whether to exclude child semantics',
        ),
      },
      requiredParameters: ['child'],
      description: 'Wraps a child with accessibility semantics for screen readers',
    ),

    // ===== Layout Widgets (additional) =====
    WidgetTypes.margin: const WidgetSpec(
      type: WidgetTypes.margin,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to apply margin to',
        ),
        'margin': ParameterSpec(
          name: 'margin',
          type: Map,
          required: true,
          description: 'Margin values (all, horizontal, vertical, top, bottom, left, right)',
        ),
      },
      requiredParameters: ['child', 'margin'],
      description: 'Applies margin (outer spacing) around a child widget',
    ),

    WidgetTypes.flow: const WidgetSpec(
      type: WidgetTypes.flow,
      category: 'layout',
      canHaveChildren: true,
      parameters: {
        'children': ParameterSpec(
          name: 'children',
          type: List,
          required: true,
          description: 'List of child widgets arranged by a flow delegate',
        ),
        'delegate': ParameterSpec(
          name: 'delegate',
          type: Map,
          description: 'Flow delegate configuration for custom layout',
        ),
      },
      requiredParameters: ['children'],
      description: 'Positions children using a custom flow delegate layout',
    ),

    WidgetTypes.intrinsicHeight: const WidgetSpec(
      type: WidgetTypes.intrinsicHeight,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to size to its intrinsic height',
        ),
      },
      requiredParameters: ['child'],
      description: 'Sizes its child to the intrinsic height of the child',
    ),

    WidgetTypes.intrinsicWidth: const WidgetSpec(
      type: WidgetTypes.intrinsicWidth,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to size to its intrinsic width',
        ),
        'stepWidth': ParameterSpec(
          name: 'stepWidth',
          type: dynamic,
          description: 'Step width to round up to',
        ),
        'stepHeight': ParameterSpec(
          name: 'stepHeight',
          type: dynamic,
          description: 'Step height to round up to',
        ),
      },
      requiredParameters: ['child'],
      description: 'Sizes its child to the intrinsic width of the child',
    ),

    WidgetTypes.constrainedBox: const WidgetSpec(
      type: WidgetTypes.constrainedBox,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget to constrain',
        ),
        'minWidth': ParameterSpec(
          name: 'minWidth',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Minimum width constraint',
        ),
        'maxWidth': ParameterSpec(
          name: 'maxWidth',
          type: dynamic,
          description: 'Maximum width constraint',
        ),
        'minHeight': ParameterSpec(
          name: 'minHeight',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Minimum height constraint',
        ),
        'maxHeight': ParameterSpec(
          name: 'maxHeight',
          type: dynamic,
          description: 'Maximum height constraint',
        ),
      },
      requiredParameters: [],
      description: 'Applies box constraints to a child widget (CamelCase alias for constrained)',
    ),

    WidgetTypes.baseline: const WidgetSpec(
      type: WidgetTypes.baseline,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to position at the baseline',
        ),
        'baseline': ParameterSpec(
          name: 'baseline',
          type: dynamic,
          required: true,
          description: 'Number of logical pixels from the top of this widget to the baseline',
        ),
        'baselineType': ParameterSpec(
          name: 'baselineType',
          type: String,
          defaultValue: 'alphabetic',
          allowedValues: ['alphabetic', 'ideographic'],
          description: 'Type of baseline to use',
        ),
      },
      requiredParameters: ['child', 'baseline'],
      description: 'Positions a child at a specific baseline offset',
    ),

    WidgetTypes.fittedBox: const WidgetSpec(
      type: WidgetTypes.fittedBox,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to scale and position',
        ),
        'fit': ParameterSpec(
          name: 'fit',
          type: String,
          defaultValue: 'contain',
          allowedValues: ['fill', 'contain', 'cover', 'fitWidth', 'fitHeight', 'none', 'scaleDown'],
          description: 'How to inscribe the child into the available space',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'center',
          description: 'Alignment of the child within the box',
        ),
      },
      requiredParameters: ['child'],
      description: 'Scales and positions its child to fit within the available space',
    ),

    WidgetTypes.limitedBox: const WidgetSpec(
      type: WidgetTypes.limitedBox,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget to constrain',
        ),
        'maxWidth': ParameterSpec(
          name: 'maxWidth',
          type: dynamic,
          defaultValue: double.infinity,
          description: 'Maximum width when unconstrained by parent',
        ),
        'maxHeight': ParameterSpec(
          name: 'maxHeight',
          type: dynamic,
          defaultValue: double.infinity,
          description: 'Maximum height when unconstrained by parent',
        ),
      },
      requiredParameters: [],
      description: 'Limits the size of its child only when unconstrained by its parent',
    ),

    WidgetTypes.mediaQuery: const WidgetSpec(
      type: WidgetTypes.mediaQuery,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to provide media query data to',
        ),
        'breakpoints': ParameterSpec(
          name: 'breakpoints',
          type: Map,
          description: 'Breakpoint definitions for responsive layout',
        ),
      },
      requiredParameters: ['child'],
      description: 'Provides media query data for responsive layout decisions',
    ),

    WidgetTypes.fractionallySized: const WidgetSpec(
      type: WidgetTypes.fractionallySized,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget to size fractionally',
        ),
        'widthFactor': ParameterSpec(
          name: 'widthFactor',
          type: dynamic,
          description: 'Fraction of parent width (0.0 to 1.0)',
        ),
        'heightFactor': ParameterSpec(
          name: 'heightFactor',
          type: dynamic,
          description: 'Fraction of parent height (0.0 to 1.0)',
        ),
        'alignment': ParameterSpec(
          name: 'alignment',
          type: String,
          defaultValue: 'center',
          description: 'Alignment of the child within the fractional space',
        ),
      },
      requiredParameters: [],
      description: 'Sizes its child to a fraction of the available space',
    ),

    // ===== Display Widgets (additional) =====
    WidgetTypes.clipOval: const WidgetSpec(
      type: WidgetTypes.clipOval,
      category: 'display',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to clip into an oval shape',
        ),
      },
      requiredParameters: ['child'],
      description: 'Clips its child to an oval (or circle) shape',
    ),

    WidgetTypes.clipRRect: const WidgetSpec(
      type: WidgetTypes.clipRRect,
      category: 'display',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to clip with rounded corners',
        ),
        'borderRadius': ParameterSpec(
          name: 'borderRadius',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Border radius for the rounded rectangle clip',
        ),
      },
      requiredParameters: ['child'],
      description: 'Clips its child to a rounded rectangle shape',
    ),

    WidgetTypes.decoration: const WidgetSpec(
      type: WidgetTypes.decoration,
      category: 'display',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget to decorate',
        ),
        'decoration': ParameterSpec(
          name: 'decoration',
          type: Map,
          required: true,
          description: 'Decoration configuration (color, border, borderRadius, shadow, gradient)',
        ),
        'position': ParameterSpec(
          name: 'position',
          type: String,
          defaultValue: 'background',
          allowedValues: ['background', 'foreground'],
          description: 'Whether decoration is painted behind or in front of child',
        ),
      },
      requiredParameters: ['decoration'],
      description: 'Paints a decoration around or behind a child widget',
    ),

    WidgetTypes.decoratedBox: const WidgetSpec(
      type: WidgetTypes.decoratedBox,
      category: 'display',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Child widget to decorate',
        ),
        'decoration': ParameterSpec(
          name: 'decoration',
          type: Map,
          required: true,
          description: 'Box decoration (color, border, borderRadius, shadow, gradient)',
        ),
        'position': ParameterSpec(
          name: 'position',
          type: String,
          defaultValue: 'background',
          allowedValues: ['background', 'foreground'],
          description: 'Whether decoration is painted behind or in front of child',
        ),
      },
      requiredParameters: ['decoration'],
      description: 'A box that paints a decoration before or after its child',
    ),

    // ===== Input Widgets (additional) =====
    WidgetTypes.numberField: const WidgetSpec(
      type: WidgetTypes.numberField,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Current numeric value',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when value changes',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
        'min': ParameterSpec(
          name: 'min',
          type: dynamic,
          description: 'Minimum allowed value',
        ),
        'max': ParameterSpec(
          name: 'max',
          type: dynamic,
          description: 'Maximum allowed value',
        ),
        'step': ParameterSpec(
          name: 'step',
          type: dynamic,
          defaultValue: 1,
          description: 'Step increment for value changes',
        ),
        'placeholder': ParameterSpec(
          name: 'placeholder',
          type: String,
          description: 'Placeholder text',
        ),
        'errorText': ParameterSpec(
          name: 'errorText',
          type: String,
          description: 'Error message text',
        ),
      },
      requiredParameters: ['value', 'onChange'],
      description: 'A numeric input field with optional min/max constraints',
    ),

    WidgetTypes.colorPicker: const WidgetSpec(
      type: WidgetTypes.colorPicker,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current color value (hex string)',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when color changes',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
        'enableAlpha': ParameterSpec(
          name: 'enableAlpha',
          type: bool,
          defaultValue: false,
          description: 'Whether to allow alpha channel selection',
        ),
      },
      requiredParameters: ['value', 'onChange'],
      description: 'A color picker input for selecting colors',
    ),

    WidgetTypes.dateRangePicker: const WidgetSpec(
      type: WidgetTypes.dateRangePicker,
      category: 'input',
      parameters: {
        'startDate': ParameterSpec(
          name: 'startDate',
          type: String,
          required: true,
          description: 'Start date of the range (ISO 8601)',
        ),
        'endDate': ParameterSpec(
          name: 'endDate',
          type: String,
          required: true,
          description: 'End date of the range (ISO 8601)',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when date range changes',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
        'firstDate': ParameterSpec(
          name: 'firstDate',
          type: String,
          description: 'Earliest selectable date (ISO 8601)',
        ),
        'lastDate': ParameterSpec(
          name: 'lastDate',
          type: String,
          description: 'Latest selectable date (ISO 8601)',
        ),
      },
      requiredParameters: ['startDate', 'endDate', 'onChange'],
      description: 'A date range picker for selecting a start and end date',
    ),

    WidgetTypes.datePicker: const WidgetSpec(
      type: WidgetTypes.datePicker,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current date value (ISO 8601)',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when date changes',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
        'firstDate': ParameterSpec(
          name: 'firstDate',
          type: String,
          description: 'Earliest selectable date (ISO 8601)',
        ),
        'lastDate': ParameterSpec(
          name: 'lastDate',
          type: String,
          description: 'Latest selectable date (ISO 8601)',
        ),
        'mode': ParameterSpec(
          name: 'mode',
          type: String,
          defaultValue: 'calendar',
          allowedValues: ['calendar', 'input'],
          description: 'Picker display mode',
        ),
      },
      requiredParameters: ['value', 'onChange'],
      description: 'A date picker widget for selecting a single date',
    ),

    WidgetTypes.timePicker: const WidgetSpec(
      type: WidgetTypes.timePicker,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current time value (HH:mm format)',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when time changes',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
        'use24HourFormat': ParameterSpec(
          name: 'use24HourFormat',
          type: bool,
          defaultValue: false,
          description: 'Whether to use 24-hour format',
        ),
      },
      requiredParameters: ['value', 'onChange'],
      description: 'A time picker widget for selecting a time of day',
    ),

    WidgetTypes.numberStepper: const WidgetSpec(
      type: WidgetTypes.numberStepper,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Current numeric value',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          required: true,
          description: 'Change action when value changes',
        ),
        'min': ParameterSpec(
          name: 'min',
          type: dynamic,
          defaultValue: 0,
          description: 'Minimum value',
        ),
        'max': ParameterSpec(
          name: 'max',
          type: dynamic,
          defaultValue: 100,
          description: 'Maximum value',
        ),
        'step': ParameterSpec(
          name: 'step',
          type: dynamic,
          defaultValue: 1,
          description: 'Step increment',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Field label',
        ),
      },
      requiredParameters: ['value', 'onChange'],
      description: 'A numeric stepper with increment and decrement buttons',
    ),

    // ===== Scroll Widgets (additional) =====
    WidgetTypes.scrollBar: const WidgetSpec(
      type: WidgetTypes.scrollBar,
      category: 'scroll',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Scrollable child widget to attach the scrollbar to',
        ),
        'thumbVisibility': ParameterSpec(
          name: 'thumbVisibility',
          type: bool,
          defaultValue: false,
          description: 'Whether the scrollbar thumb is always visible',
        ),
        'thickness': ParameterSpec(
          name: 'thickness',
          type: dynamic,
          description: 'Thickness of the scrollbar',
        ),
      },
      requiredParameters: ['child'],
      description: 'Adds a scrollbar indicator to a scrollable child widget',
    ),

    // ===== Animation Widgets (additional) =====
    WidgetTypes.lottieAnimation: const WidgetSpec(
      type: WidgetTypes.lottieAnimation,
      category: 'animation',
      parameters: {
        'source': ParameterSpec(
          name: 'source',
          type: String,
          required: true,
          description: 'Lottie animation source URL or asset path',
        ),
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          description: 'Animation width',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          description: 'Animation height',
        ),
        'repeat': ParameterSpec(
          name: 'repeat',
          type: bool,
          defaultValue: true,
          description: 'Whether the animation loops',
        ),
        'autoplay': ParameterSpec(
          name: 'autoplay',
          type: bool,
          defaultValue: true,
          description: 'Whether the animation plays automatically',
        ),
        'fit': ParameterSpec(
          name: 'fit',
          type: String,
          defaultValue: 'contain',
          allowedValues: ['fill', 'contain', 'cover', 'fitWidth', 'fitHeight', 'none', 'scaleDown'],
          description: 'How to fit the animation within bounds',
        ),
      },
      requiredParameters: ['source'],
      description: 'Plays a Lottie animation from a JSON source',
    ),

    // ===== Interactive Widgets (additional) =====
    WidgetTypes.draggable: const WidgetSpec(
      type: WidgetTypes.draggable,
      category: 'interactive',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget that can be dragged',
        ),
        'data': ParameterSpec(
          name: 'data',
          type: dynamic,
          description: 'Data payload carried during the drag',
        ),
        'feedback': ParameterSpec(
          name: 'feedback',
          type: Map,
          description: 'Widget displayed under the pointer during drag',
        ),
        'childWhenDragging': ParameterSpec(
          name: 'childWhenDragging',
          type: Map,
          description: 'Widget shown in place while child is being dragged',
        ),
        'axis': ParameterSpec(
          name: 'axis',
          type: String,
          allowedValues: ['horizontal', 'vertical'],
          description: 'Restricts drag to a single axis',
        ),
        'affinity': ParameterSpec(
          name: 'affinity',
          type: String,
          allowedValues: ['horizontal', 'vertical', 'both'],
          description: 'Drag affinity direction preference',
        ),
      },
      requiredParameters: ['child'],
      description: 'Makes a child widget draggable with optional data payload',
    ),

    WidgetTypes.dragTarget: const WidgetSpec(
      type: WidgetTypes.dragTarget,
      category: 'interactive',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget that acts as a drop target',
        ),
        'onAccept': ParameterSpec(
          name: 'onAccept',
          type: Map,
          description: 'Action when a draggable is dropped on this target',
        ),
        'onWillAccept': ParameterSpec(
          name: 'onWillAccept',
          type: Map,
          description: 'Condition to determine if a draggable can be accepted',
        ),
      },
      requiredParameters: ['child'],
      description: 'A target area that accepts draggable widgets',
    ),

    // ===== Advanced Widgets (additional) =====
    WidgetTypes.map: const WidgetSpec(
      type: WidgetTypes.map,
      category: 'advanced',
      parameters: {
        'center': ParameterSpec(
          name: 'center',
          type: Map,
          description: 'Center coordinates ({lat, lng})',
        ),
        'zoom': ParameterSpec(
          name: 'zoom',
          type: dynamic,
          defaultValue: 13.0,
          description: 'Map zoom level',
        ),
        'markers': ParameterSpec(
          name: 'markers',
          type: List,
          description: 'List of map markers ({lat, lng, label, icon})',
        ),
        'mapType': ParameterSpec(
          name: 'mapType',
          type: String,
          defaultValue: 'normal',
          allowedValues: ['normal', 'satellite', 'terrain', 'hybrid'],
          description: 'Map display type',
        ),
        'interactive': ParameterSpec(
          name: 'interactive',
          type: bool,
          defaultValue: true,
          description: 'Whether the map supports user interaction',
        ),
      },
      requiredParameters: [],
      description: 'An interactive map widget with markers and zoom control',
    ),

    WidgetTypes.timeline: const WidgetSpec(
      type: WidgetTypes.timeline,
      category: 'advanced',
      parameters: {
        'items': ParameterSpec(
          name: 'items',
          type: List,
          required: true,
          description: 'List of timeline items ({title, subtitle, icon, color, content})',
        ),
        'direction': ParameterSpec(
          name: 'direction',
          type: String,
          defaultValue: 'vertical',
          allowedValues: ['vertical', 'horizontal'],
          description: 'Timeline layout direction',
        ),
      },
      requiredParameters: ['items'],
      description: 'Displays a chronological timeline of events',
    ),

    WidgetTypes.gauge: const WidgetSpec(
      type: WidgetTypes.gauge,
      category: 'advanced',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Current gauge value',
        ),
        'min': ParameterSpec(
          name: 'min',
          type: dynamic,
          defaultValue: 0.0,
          description: 'Minimum value',
        ),
        'max': ParameterSpec(
          name: 'max',
          type: dynamic,
          defaultValue: 100.0,
          description: 'Maximum value',
        ),
        'label': ParameterSpec(
          name: 'label',
          type: String,
          description: 'Gauge label text',
        ),
        'segments': ParameterSpec(
          name: 'segments',
          type: List,
          description: 'Color segments for different value ranges',
        ),
      },
      requiredParameters: ['value'],
      description: 'A gauge widget displaying a value within a range',
    ),

    WidgetTypes.heatmap: const WidgetSpec(
      type: WidgetTypes.heatmap,
      category: 'advanced',
      parameters: {
        'data': ParameterSpec(
          name: 'data',
          type: dynamic,
          required: true,
          description: 'Heatmap data (2D array or list of {x, y, value})',
        ),
        'colorScale': ParameterSpec(
          name: 'colorScale',
          type: List,
          description: 'Color scale from low to high values',
        ),
        'xLabels': ParameterSpec(
          name: 'xLabels',
          type: List,
          description: 'Labels for the x-axis',
        ),
        'yLabels': ParameterSpec(
          name: 'yLabels',
          type: List,
          description: 'Labels for the y-axis',
        ),
      },
      requiredParameters: ['data'],
      description: 'Displays a color-coded heatmap of data values',
    ),

    WidgetTypes.tree: const WidgetSpec(
      type: WidgetTypes.tree,
      category: 'advanced',
      parameters: {
        'data': ParameterSpec(
          name: 'data',
          type: dynamic,
          required: true,
          description: 'Tree data with nested children ({label, children, icon})',
        ),
        'expandAll': ParameterSpec(
          name: 'expandAll',
          type: bool,
          defaultValue: false,
          description: 'Whether all nodes start expanded',
        ),
        'selectable': ParameterSpec(
          name: 'selectable',
          type: bool,
          defaultValue: false,
          description: 'Whether nodes are selectable',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Action when selection changes',
        ),
      },
      requiredParameters: ['data'],
      description: 'A hierarchical tree view with expandable nodes',
    ),

    WidgetTypes.graph: const WidgetSpec(
      type: WidgetTypes.graph,
      category: 'advanced',
      parameters: {
        'nodes': ParameterSpec(
          name: 'nodes',
          type: List,
          required: true,
          description: 'List of graph nodes ({id, label, x, y})',
        ),
        'edges': ParameterSpec(
          name: 'edges',
          type: List,
          required: true,
          description: 'List of graph edges ({source, target, label})',
        ),
        'directed': ParameterSpec(
          name: 'directed',
          type: bool,
          defaultValue: false,
          description: 'Whether the graph is directed',
        ),
        'interactive': ParameterSpec(
          name: 'interactive',
          type: bool,
          defaultValue: true,
          description: 'Whether nodes can be dragged',
        ),
      },
      requiredParameters: ['nodes', 'edges'],
      description: 'Renders a graph with nodes and edges',
    ),

    WidgetTypes.networkGraph: const WidgetSpec(
      type: WidgetTypes.networkGraph,
      category: 'advanced',
      parameters: {
        'nodes': ParameterSpec(
          name: 'nodes',
          type: List,
          required: true,
          description: 'List of network nodes ({id, label, group, size})',
        ),
        'edges': ParameterSpec(
          name: 'edges',
          type: List,
          required: true,
          description: 'List of connections ({source, target, weight})',
        ),
        'layout': ParameterSpec(
          name: 'layout',
          type: String,
          defaultValue: 'force',
          allowedValues: ['force', 'circular', 'hierarchical'],
          description: 'Graph layout algorithm',
        ),
        'interactive': ParameterSpec(
          name: 'interactive',
          type: bool,
          defaultValue: true,
          description: 'Whether the graph supports interaction',
        ),
      },
      requiredParameters: ['nodes', 'edges'],
      description: 'An interactive network graph with force-directed layout',
    ),

    WidgetTypes.codeEditor: const WidgetSpec(
      type: WidgetTypes.codeEditor,
      category: 'advanced',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: String,
          required: true,
          description: 'Current code content',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Change action when code is edited',
        ),
        'language': ParameterSpec(
          name: 'language',
          type: String,
          description: 'Programming language for syntax highlighting',
        ),
        'readOnly': ParameterSpec(
          name: 'readOnly',
          type: bool,
          defaultValue: false,
          description: 'Whether the editor is read-only',
        ),
        'lineNumbers': ParameterSpec(
          name: 'lineNumbers',
          type: bool,
          defaultValue: true,
          description: 'Whether to show line numbers',
        ),
        'theme': ParameterSpec(
          name: 'theme',
          type: String,
          defaultValue: 'dark',
          allowedValues: ['dark', 'light'],
          description: 'Editor color theme',
        ),
      },
      requiredParameters: ['value'],
      description: 'A code editor with syntax highlighting and line numbers',
    ),

    WidgetTypes.terminal: const WidgetSpec(
      type: WidgetTypes.terminal,
      category: 'advanced',
      parameters: {
        'output': ParameterSpec(
          name: 'output',
          type: dynamic,
          description: 'Terminal output content (string or list of lines)',
        ),
        'onInput': ParameterSpec(
          name: 'onInput',
          type: Map,
          description: 'Action when user enters a command',
        ),
        'readOnly': ParameterSpec(
          name: 'readOnly',
          type: bool,
          defaultValue: false,
          description: 'Whether the terminal is read-only (output only)',
        ),
        'prompt': ParameterSpec(
          name: 'prompt',
          type: String,
          defaultValue: '\$ ',
          description: 'Command prompt string',
        ),
      },
      requiredParameters: [],
      description: 'A terminal emulator widget for command-line interaction',
    ),

    WidgetTypes.fileExplorer: const WidgetSpec(
      type: WidgetTypes.fileExplorer,
      category: 'advanced',
      parameters: {
        'data': ParameterSpec(
          name: 'data',
          type: dynamic,
          required: true,
          description: 'File tree data ({name, type, children})',
        ),
        'selectable': ParameterSpec(
          name: 'selectable',
          type: bool,
          defaultValue: true,
          description: 'Whether files and folders are selectable',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Action when selection changes',
        ),
        'showIcons': ParameterSpec(
          name: 'showIcons',
          type: bool,
          defaultValue: true,
          description: 'Whether to show file type icons',
        ),
      },
      requiredParameters: ['data'],
      description: 'A file explorer tree view for browsing file hierarchies',
    ),

    WidgetTypes.signature: const WidgetSpec(
      type: WidgetTypes.signature,
      category: 'advanced',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: String,
          description: 'Base64-encoded signature image data',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Change action when signature is drawn or cleared',
        ),
        'penColor': ParameterSpec(
          name: 'penColor',
          type: String,
          defaultValue: '#000000',
          description: 'Pen stroke color',
        ),
        'penWidth': ParameterSpec(
          name: 'penWidth',
          type: dynamic,
          defaultValue: 2.0,
          description: 'Pen stroke width',
        ),
        'backgroundColor': ParameterSpec(
          name: 'backgroundColor',
          type: String,
          defaultValue: '#FFFFFF',
          description: 'Canvas background color',
        ),
      },
      requiredParameters: [],
      description: 'A signature pad for capturing handwritten signatures',
    ),

    // ===== Layout Widgets (responsive) =====
    WidgetTypes.layoutBuilder: const WidgetSpec(
      type: WidgetTypes.layoutBuilder,
      category: 'layout',
      canHaveChild: true,
      parameters: {
        'breakpoints': ParameterSpec(
          name: 'breakpoints',
          type: Map,
          description: 'Map of breakpoint names to min-width values',
        ),
        'layouts': ParameterSpec(
          name: 'layouts',
          type: Map,
          description: 'Map of breakpoint names to widget definitions',
        ),
        'default': ParameterSpec(
          name: 'default',
          type: Map,
          description: 'Widget definition when no breakpoint matches',
        ),
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          description: 'Fallback child widget (alias for default)',
        ),
      },
      requiredParameters: [],
      description: 'Renders different child widgets based on parent constraints for responsive layouts',
    ),

    // ===== Template Widget =====
    WidgetTypes.use: const WidgetSpec(
      type: WidgetTypes.use,
      category: 'layout',
      parameters: {
        'template': ParameterSpec(
          name: 'template',
          type: String,
          required: true,
          description: 'Name of the template to use',
        ),
        'params': ParameterSpec(
          name: 'params',
          type: Map,
          description: 'Parameters to pass to the template',
        ),
      },
      requiredParameters: ['template'],
      description: 'Renders a registered template by name with parameters',
    ),

    // ===== Input Widget: rating =====
    WidgetTypes.rating: const WidgetSpec(
      type: WidgetTypes.rating,
      category: 'input',
      parameters: {
        'value': ParameterSpec(
          name: 'value',
          type: dynamic,
          required: true,
          description: 'Current rating value',
        ),
        'maxRating': ParameterSpec(
          name: 'maxRating',
          type: int,
          defaultValue: 5,
          description: 'Maximum rating value',
        ),
        'allowHalf': ParameterSpec(
          name: 'allowHalf',
          type: bool,
          defaultValue: false,
          description: 'Whether half-star ratings are allowed',
        ),
        'readOnly': ParameterSpec(
          name: 'readOnly',
          type: bool,
          defaultValue: false,
          description: 'Whether the rating is read-only',
        ),
        'onChange': ParameterSpec(
          name: 'onChange',
          type: Map,
          description: 'Action triggered on value change',
        ),
      },
      requiredParameters: ['value'],
      description: 'Star-based rating input widget',
    ),

    // ===== v1.3 Widgets =====
    WidgetTypes.canvas: const WidgetSpec(
      type: WidgetTypes.canvas,
      category: 'display',
      parameters: {
        'width': ParameterSpec(
          name: 'width',
          type: dynamic,
          required: true,
          description: 'Canvas width',
        ),
        'height': ParameterSpec(
          name: 'height',
          type: dynamic,
          required: true,
          description: 'Canvas height',
        ),
        'commands': ParameterSpec(
          name: 'commands',
          type: List,
          required: true,
          description: 'Array of drawing commands (rect, circle, arc, line, path, text, image)',
        ),
        'backgroundColor': ParameterSpec(
          name: 'backgroundColor',
          type: String,
          description: 'Canvas background color',
        ),
      },
      requiredParameters: ['width', 'height', 'commands'],
      description: 'Custom 2D drawing canvas with drawing commands (v1.3)',
    ),

    WidgetTypes.opacity: const WidgetSpec(
      type: WidgetTypes.opacity,
      category: 'animation',
      canHaveChild: true,
      parameters: {
        'opacity': ParameterSpec(
          name: 'opacity',
          type: dynamic,
          required: true,
          description: 'Opacity value (0.0-1.0)',
        ),
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget',
        ),
        'animated': ParameterSpec(
          name: 'animated',
          type: bool,
          defaultValue: false,
          description: 'Whether opacity changes are animated',
        ),
        'duration': ParameterSpec(
          name: 'duration',
          type: int,
          defaultValue: 300,
          description: 'Animation duration in milliseconds',
        ),
        'curve': ParameterSpec(
          name: 'curve',
          type: String,
          defaultValue: 'easeInOut',
          description: 'Animation curve',
        ),
      },
      requiredParameters: ['opacity', 'child'],
      description: 'Controls opacity of a child widget with optional animation (v1.3)',
    ),

    WidgetTypes.transform: const WidgetSpec(
      type: WidgetTypes.transform,
      category: 'animation',
      canHaveChild: true,
      parameters: {
        'child': ParameterSpec(
          name: 'child',
          type: Map,
          required: true,
          description: 'Child widget to transform',
        ),
        'rotate': ParameterSpec(
          name: 'rotate',
          type: dynamic,
          description: 'Rotation angle in radians',
        ),
        'scale': ParameterSpec(
          name: 'scale',
          type: dynamic,
          description: 'Scale factor (number or {x, y})',
        ),
        'translate': ParameterSpec(
          name: 'translate',
          type: Map,
          description: 'Translation offset {x, y}',
        ),
        'origin': ParameterSpec(
          name: 'origin',
          type: Map,
          description: 'Transform origin {x, y} (0.0-1.0)',
        ),
        'animated': ParameterSpec(
          name: 'animated',
          type: bool,
          defaultValue: false,
          description: 'Whether transform changes are animated',
        ),
        'duration': ParameterSpec(
          name: 'duration',
          type: int,
          defaultValue: 300,
          description: 'Animation duration in milliseconds',
        ),
        'curve': ParameterSpec(
          name: 'curve',
          type: String,
          defaultValue: 'easeInOut',
          description: 'Animation curve',
        ),
      },
      requiredParameters: ['child'],
      description: 'Applies geometric transforms to a child widget (v1.3)',
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