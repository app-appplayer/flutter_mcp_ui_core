/// Default values for MCP UI DSL properties
/// 
/// Contains default values used when properties are not specified.
/// This ensures consistent behavior across renderer and generator.
class Defaults {
  // Layout Defaults
  static const double defaultWidth = double.infinity;
  static const double defaultHeight = double.infinity;
  static const double defaultPadding = 0.0;
  static const double defaultMargin = 0.0;
  static const String defaultAlignment = 'center';
  static const String defaultMainAxisAlignment = 'start';
  static const String defaultCrossAxisAlignment = 'center';
  static const String defaultMainAxisSize = 'max';
  
  // Style Defaults
  static const String defaultColor = '#000000';
  static const String defaultBackgroundColor = 'transparent';
  static const double defaultFontSize = 14.0;
  static const String defaultFontWeight = 'normal';
  static const String defaultFontFamily = 'Roboto';
  static const String defaultTextAlign = 'left';
  static const double defaultElevation = 0.0;
  static const double defaultBorderRadius = 0.0;
  
  // Content Defaults
  static const String defaultText = '';
  static const String defaultLabel = '';
  static const String defaultHintText = '';
  static const String defaultPlaceholder = '';
  
  // Icon Defaults
  static const String defaultIcon = 'help';
  static const double defaultIconSize = 24.0;
  static const String defaultIconColor = '#000000';
  
  // Interaction Defaults
  static const bool defaultEnabled = true;
  static const bool defaultVisible = true;
  static const bool defaultSelected = false;
  static const bool defaultChecked = false;
  
  // Form Defaults
  static const bool defaultRequired = false;
  static const bool defaultObscureText = false;
  static const String defaultKeyboardType = 'text';
  static const int defaultMaxLength = -1; // No limit
  static const int defaultMaxLines = 1;
  
  // List Defaults
  static const bool defaultShrinkWrap = false;
  static const String defaultPhysics = 'scrollable';
  static const String defaultScrollDirection = 'vertical';
  static const int defaultItemCount = 0;
  
  // Grid Defaults
  static const int defaultCrossAxisCount = 2;
  static const double defaultMainAxisSpacing = 0.0;
  static const double defaultCrossAxisSpacing = 0.0;
  static const double defaultChildAspectRatio = 1.0;
  
  // Navigation Defaults
  static const bool defaultAutomaticallyImplyLeading = true;
  
  // Dialog Defaults
  static const bool defaultBarrierDismissible = true;
  static const int defaultDuration = 4000; // milliseconds
  
  // Animation Defaults
  static const String defaultCurve = 'ease';
  static const int defaultAnimationDuration = 300; // milliseconds
  
  // Flex Defaults
  static const int defaultFlex = 1;
  
  // Position Defaults
  static const double defaultPosition = 0.0;
  
  // Slider Defaults
  static const double defaultSliderMin = 0.0;
  static const double defaultSliderMax = 100.0;
  static const double defaultSliderValue = 0.0;
  
  // Avatar Defaults
  static const double defaultAvatarRadius = 20.0;
  
  // FloatingActionButton Defaults
  static const bool defaultMini = false;
  static const bool defaultExtended = false;
  
  // Progress Defaults
  static const double defaultProgress = 0.0;
  static const bool defaultIndeterminate = false;
  
  // Image Defaults
  static const String defaultImageFit = 'contain';
  static const double defaultAspectRatio = 1.0;
  
  /// Get default value for a property
  static dynamic getDefaultValue(String property) {
    switch (property) {
      // Layout
      case 'width': return defaultWidth;
      case 'height': return defaultHeight;
      case 'padding': return defaultPadding;
      case 'margin': return defaultMargin;
      case 'alignment': return defaultAlignment;
      case 'mainAxisAlignment': return defaultMainAxisAlignment;
      case 'crossAxisAlignment': return defaultCrossAxisAlignment;
      case 'mainAxisSize': return defaultMainAxisSize;
      
      // Style
      case 'color': return defaultColor;
      case 'backgroundColor': return defaultBackgroundColor;
      case 'fontSize': return defaultFontSize;
      case 'fontWeight': return defaultFontWeight;
      case 'fontFamily': return defaultFontFamily;
      case 'textAlign': return defaultTextAlign;
      case 'elevation': return defaultElevation;
      case 'borderRadius': return defaultBorderRadius;
      
      // Content
      case 'text': return defaultText;
      case 'content': return defaultText;
      case 'label': return defaultLabel;
      case 'hintText': return defaultHintText;
      case 'placeholder': return defaultPlaceholder;
      
      // Icon
      case 'icon': return defaultIcon;
      case 'iconSize': return defaultIconSize;
      case 'iconColor': return defaultIconColor;
      
      // Interaction
      case 'enabled': return defaultEnabled;
      case 'visible': return defaultVisible;
      case 'selected': return defaultSelected;
      case 'checked': return defaultChecked;
      
      // Form
      case 'required': return defaultRequired;
      case 'obscureText': return defaultObscureText;
      case 'keyboardType': return defaultKeyboardType;
      case 'maxLength': return defaultMaxLength;
      case 'maxLines': return defaultMaxLines;
      
      // List
      case 'shrinkWrap': return defaultShrinkWrap;
      case 'physics': return defaultPhysics;
      case 'scrollDirection': return defaultScrollDirection;
      case 'itemCount': return defaultItemCount;
      
      // Grid
      case 'crossAxisCount': return defaultCrossAxisCount;
      case 'mainAxisSpacing': return defaultMainAxisSpacing;
      case 'crossAxisSpacing': return defaultCrossAxisSpacing;
      case 'childAspectRatio': return defaultChildAspectRatio;
      
      // Navigation
      case 'automaticallyImplyLeading': return defaultAutomaticallyImplyLeading;
      
      // Dialog
      case 'barrierDismissible': return defaultBarrierDismissible;
      case 'duration': return defaultDuration;
      
      // Animation
      case 'curve': return defaultCurve;
      
      // Flex
      case 'flex': return defaultFlex;
      
      // Slider
      case 'min': return defaultSliderMin;
      case 'max': return defaultSliderMax;
      case 'value': return defaultSliderValue;
      
      // Avatar
      case 'radius': return defaultAvatarRadius;
      
      // FloatingActionButton
      case 'mini': return defaultMini;
      case 'extended': return defaultExtended;
      
      // Progress
      case 'progress': return defaultProgress;
      case 'indeterminate': return defaultIndeterminate;
      
      // Image
      case 'fit': return defaultImageFit;
      case 'aspectRatio': return defaultAspectRatio;
      
      default: return null;
    }
  }
}