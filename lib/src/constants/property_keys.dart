/// Property key constants for MCP UI DSL
/// 
/// Contains all standard property names used across widgets.
/// This ensures consistency in property naming.
class PropertyKeys {
  // Core Properties
  static const String type = 'type';
  static const String children = 'children';
  
  // Layout Properties
  static const String width = 'width';
  static const String height = 'height';
  static const String padding = 'padding';
  static const String margin = 'margin';
  static const String alignment = 'alignment';
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
  
  // Interaction Properties
  static const String onTap = 'onTap';
  static const String onPressed = 'onPressed';
  static const String onChanged = 'onChanged';
  static const String onSubmitted = 'onSubmitted';
  static const String enabled = 'enabled';
  static const String disabled = 'disabled';
  
  // State Properties
  static const String bindTo = 'bindTo';
  static const String selected = 'selected';
  static const String checked = 'checked';
  static const String visible = 'visible';
  
  // Form Properties
  static const String validator = 'validator';
  static const String required = 'required';
  static const String obscureText = 'obscureText';
  static const String keyboardType = 'keyboardType';
  static const String maxLength = 'maxLength';
  static const String maxLines = 'maxLines';
  
  // List Properties
  static const String items = 'items';
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
  
  /// Get all property keys as a list
  static List<String> get allKeys => [
    type, children,
    width, height, padding, margin, alignment,
    mainAxisAlignment, crossAxisAlignment, mainAxisSize,
    style, color, backgroundColor, foregroundColor,
    fontSize, fontWeight, fontFamily, textAlign,
    decoration, border, borderRadius, shadow, elevation,
    content, text, label, title, subtitle, value,
    hint, hintText, placeholder,
    src, image, fit, aspectRatio,
    icon, iconSize, iconColor,
    onTap, onPressed, onChanged, onSubmitted,
    enabled, disabled,
    bindTo, selected, checked, visible,
    validator, required, obscureText, keyboardType,
    maxLength, maxLines,
    items, itemTemplate, itemBuilder, itemCount,
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
  ];
}