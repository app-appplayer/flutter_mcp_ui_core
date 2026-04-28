/// Property key constants for MCP UI DSL
/// 
/// Contains all standard property names used across widgets.
/// This ensures consistency in property naming.
class PropertyKeys {
  // Core Properties
  static const String type = 'type';
  static const String children = 'children';
  
  // Layout Properties - Updated to match spec v1.0
  static const String width = 'width';
  static const String height = 'height';
  static const String padding = 'padding';
  static const String margin = 'margin';
  static const String alignment = 'alignment';
  static const String distribution = 'distribution'; // spec v1.0: replaces mainAxisAlignment
  static const String direction = 'direction'; // spec v1.0: for linear layouts
  static const String spacing = 'spacing'; // spec v1.0: spacing between items
  static const String gap = 'gap'; // legacy alias for spacing
  static const String wrap = 'wrap'; // spec v1.0: whether items wrap
  
  // Legacy Flutter layout names (for backward compatibility)
  static const String mainAxisAlignment = 'mainAxisAlignment';
  static const String crossAxisAlignment = 'crossAxisAlignment';
  static const String mainAxisSize = 'mainAxisSize';
  
  // Style Properties
  static const String style = 'style';
  static const String color = 'color';
  static const String backgroundColor = 'backgroundColor';
  static const String foregroundColor = 'foregroundColor';
  static const String fontSize = 'fontSize';
  static const String fontWeight = 'fontWeight';
  static const String fontFamily = 'fontFamily';
  static const String textAlign = 'textAlign';
  static const String decoration = 'decoration';
  static const String border = 'border';
  static const String borderRadius = 'borderRadius';
  static const String shadow = 'shadow';
  static const String elevation = 'elevation';
  
  // Content Properties
  static const String content = 'content';
  static const String text = 'text';
  static const String label = 'label';
  static const String title = 'title';
  static const String subtitle = 'subtitle';
  static const String value = 'value';
  static const String hint = 'hint';
  static const String hintText = 'hintText';
  static const String placeholder = 'placeholder';
  
  // Image Properties
  static const String src = 'src';
  static const String image = 'image';
  static const String fit = 'fit';
  static const String aspectRatio = 'aspectRatio';
  
  // Icon Properties
  static const String icon = 'icon';
  static const String iconSize = 'iconSize';
  static const String iconColor = 'iconColor';
  
  // Interaction Properties - on + PascalCase (optimal)
  static const String onTap = 'onTap';
  static const String onDoubleTap = 'onDoubleTap';
  static const String onLongPress = 'onLongPress';
  static const String onSubmit = 'onSubmit';
  static const String onSelect = 'onSelect';
  static const String onOpen = 'onOpen';
  static const String onCommand = 'onCommand';
  // Legacy short names (accepted as aliases for backward compatibility)
  static const String click = 'click';
  static const String doubleClick = 'double-click';
  static const String rightClick = 'right-click';
  static const String longPress = 'long-press';
  static const String doubleClickLegacy = 'doubleClick';
  static const String rightClickLegacy = 'rightClick';
  static const String longPressLegacy = 'longPress';
  static const String change = 'change';
  static const String submit = 'submit';
  static const String focus = 'focus';
  static const String blur = 'blur';
  static const String hover = 'hover';
  static const String enabled = 'enabled';
  static const String disabled = 'disabled';

  // Legacy Flutter event names (for backward compatibility)
  static const String onPressed = 'onPressed';
  static const String onChanged = 'onChanged';
  static const String onSubmitted = 'onSubmitted';
  
  // State Properties
  static const String bindTo = 'bindTo';
  static const String selected = 'selected';
  static const String checked = 'checked';
  static const String visible = 'visible';
  
  // Button Properties
  static const String variant = 'variant'; // spec v1.0: button variant

  // Form Properties
  static const String validator = 'validator';
  static const String required = 'required';
  static const String obscureText = 'obscureText';
  static const String inputType = 'inputType'; // spec v1.0: input type
  static const String keyboardType = 'keyboardType'; // legacy alias for inputType
  static const String maxLength = 'maxLength';
  static const String maxLines = 'maxLines';
  
  // List Properties
  static const String options = 'options'; // spec v1.0: select/radio/checkbox options
  static const String items = 'items'; // legacy alias for options
  static const String itemTemplate = 'itemTemplate';
  static const String itemBuilder = 'itemBuilder';
  static const String itemCount = 'itemCount';
  static const String shrinkWrap = 'shrinkWrap';
  static const String physics = 'physics';
  static const String scrollDirection = 'scrollDirection';
  
  // Grid Properties
  static const String crossAxisCount = 'crossAxisCount';
  static const String mainAxisSpacing = 'mainAxisSpacing';
  static const String crossAxisSpacing = 'crossAxisSpacing';
  static const String childAspectRatio = 'childAspectRatio';
  
  // Navigation Properties
  static const String leading = 'leading';
  static const String trailing = 'trailing';
  static const String actions = 'actions';
  static const String bottomNav = 'bottom';
  static const String automaticallyImplyLeading = 'automaticallyImplyLeading';
  
  // Dialog Properties
  static const String barrierDismissible = 'barrierDismissible';
  static const String duration = 'duration';
  
  // Animation Properties
  static const String curve = 'curve';
  static const String begin = 'begin';
  static const String end = 'end';
  
  // Flex Properties
  static const String flex = 'flex';
  
  // Position Properties
  static const String left = 'left';
  static const String top = 'top';
  static const String right = 'right';
  static const String bottom = 'bottom';
  
  // Size Properties
  static const String minWidth = 'minWidth';
  static const String maxWidth = 'maxWidth';
  static const String minHeight = 'minHeight';
  static const String maxHeight = 'maxHeight';
  
  // Slider Properties
  static const String min = 'min';
  static const String max = 'max';
  static const String divisions = 'divisions';
  
  // Chip Properties
  static const String onDeleted = 'onDeleted';
  static const String deleteIcon = 'deleteIcon';
  
  // Avatar Properties
  static const String radius = 'radius';
  
  // FloatingActionButton Properties
  static const String mini = 'mini';
  static const String extended = 'extended';
  
  // Progress Properties
  static const String progress = 'progress';
  static const String indeterminate = 'indeterminate';
  
  // Table Properties
  static const String columnWidths = 'columnWidths';
  static const String defaultVerticalAlignment = 'defaultVerticalAlignment';

  // Binding Properties
  static const String binding = 'binding';
  static const String source = 'source';
  static const String target = 'target';
  static const String transform = 'transform';
  static const String defaultValue = 'defaultValue';

  // Validation Properties
  static const String validation = 'validation';
  static const String pattern = 'pattern';
  static const String minLength = 'minLength';
  static const String errorMessage = 'errorMessage';
  static const String rules = 'rules';

  // Condition Properties
  static const String condition = 'condition';
  static const String when = 'when';
  static const String show = 'show';
  static const String hide = 'hide';

  // i18n Properties
  static const String i18n = 'i18n';
  static const String locale = 'locale';
  static const String rtl = 'rtl';
  static const String translations = 'translations';

  // Accessibility Properties
  static const String semanticLabel = 'semanticLabel';
  static const String role = 'role';
  static const String ariaLabel = 'ariaLabel';
  static const String ariaHidden = 'ariaHidden';
  static const String focusOrder = 'focusOrder';
  static const String liveRegion = 'liveRegion';

  // Event Properties
  static const String onChange = 'onChange';
  static const String onFocus = 'onFocus';
  static const String onBlur = 'onBlur';
  static const String onDelete = 'onDelete';

  // Callback Properties (v1.0+) - on + PascalCase per naming conventions
  static const String onSuccess = 'onSuccess';
  static const String onError = 'onError';
  static const String onMessage = 'onMessage';
  static const String onMount = 'onMount';
  static const String onUnmount = 'onUnmount';

  // Child/Slot Properties
  static const String child = 'child';
  static const String params = 'params';
  static const String slots = 'slots';
  static const String template = 'template';

  // Canvas Coordinate Properties (v1.3)
  static const String x = 'x';
  static const String y = 'y';
  static const String x1 = 'x1';
  static const String y1 = 'y1';
  static const String x2 = 'x2';
  static const String y2 = 'y2';

  // Canvas Properties (v1.3)
  static const String commands = 'commands';
  static const String op = 'op';
  static const String cx = 'cx';
  static const String cy = 'cy';
  static const String startAngle = 'startAngle';
  static const String endAngle = 'endAngle';
  static const String strokeCap = 'strokeCap';
  static const String cornerRadius = 'cornerRadius';
  static const String fill = 'fill';
  static const String stroke = 'stroke';
  static const String strokeWidth = 'strokeWidth';
  static const String d = 'd';

  // Transform/Opacity Properties (v1.3)
  static const String rotate = 'rotate';
  static const String scale = 'scale';
  static const String translate = 'translate';
  static const String origin = 'origin';
  static const String animated = 'animated';
  static const String opacity = 'opacity';

  // Template State Properties (v1.3)
  static const String stateDefaults = 'stateDefaults';

  /// Get all property keys as a list
  static List<String> get allKeys => [
    type, children,
    width, height, padding, margin, alignment,
    distribution, direction, spacing, gap, wrap,
    mainAxisAlignment, crossAxisAlignment, mainAxisSize,
    style, color, backgroundColor, foregroundColor,
    fontSize, fontWeight, fontFamily, textAlign,
    decoration, border, borderRadius, shadow, elevation,
    content, text, label, title, subtitle, value,
    hint, hintText, placeholder,
    src, image, fit, aspectRatio,
    icon, iconSize, iconColor,
    onTap, onDoubleTap, onLongPress, onSubmit, onSelect, onOpen, onCommand,
    click, doubleClick, rightClick, longPress,
    doubleClickLegacy, rightClickLegacy, longPressLegacy,
    change, focus, blur, hover, submit, variant,
    onPressed, onChanged, onSubmitted,
    enabled, disabled,
    bindTo, selected, checked, visible,
    validator, required, obscureText, keyboardType,
    maxLength, maxLines,
    options, items, itemTemplate, itemBuilder, itemCount, inputType,
    shrinkWrap, physics, scrollDirection,
    crossAxisCount, mainAxisSpacing, crossAxisSpacing, childAspectRatio,
    leading, trailing, actions, bottomNav, automaticallyImplyLeading,
    barrierDismissible, duration,
    curve, begin, end,
    flex,
    left, top, right, bottom,
    minWidth, maxWidth, minHeight, maxHeight,
    min, max, divisions,
    onDeleted, deleteIcon,
    radius,
    mini, extended,
    progress, indeterminate,
    columnWidths, defaultVerticalAlignment,
    binding, source, target, transform, defaultValue,
    validation, pattern, minLength, errorMessage, rules,
    condition, when, show, hide,
    i18n, locale, rtl, translations,
    semanticLabel, role, ariaLabel, ariaHidden, focusOrder, liveRegion,
    onChange, onFocus, onBlur, onDelete,
    onSuccess, onError, onMessage, onMount, onUnmount,
    child, params, slots, template,
    x, y, x1, y1, x2, y2,
    commands, op, cx, cy, startAngle, endAngle,
    strokeCap, cornerRadius, fill, stroke, strokeWidth, d,
    rotate, scale, translate, origin, animated, opacity,
    stateDefaults,
  ];
}