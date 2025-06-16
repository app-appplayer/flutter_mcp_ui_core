/// Widget type constants for MCP UI DSL
/// 
/// Contains all supported widget types organized by category.
/// This ensures consistency between renderer and generator packages.
class WidgetTypes {
  // Layout Widgets (20)
  static const String column = 'column';
  static const String row = 'row';
  static const String stack = 'stack';
  static const String container = 'container';
  static const String center = 'center';
  static const String align = 'align';
  static const String padding = 'padding';
  static const String margin = 'margin';
  static const String sizedBox = 'sizedbox';
  static const String expanded = 'expanded';
  static const String flexible = 'flexible';
  static const String spacer = 'spacer';
  static const String wrap = 'wrap';
  static const String flow = 'flow';
  static const String table = 'table';
  static const String positioned = 'positioned';
  static const String intrinsicHeight = 'intrinsicheight';
  static const String intrinsicWidth = 'intrinsicwidth';
  static const String visibility = 'visibility';
  static const String conditional = 'conditional';

  // Display Widgets (16)
  static const String text = 'text';
  static const String richText = 'richtext';
  static const String image = 'image';
  static const String icon = 'icon';
  static const String card = 'card';
  static const String divider = 'divider';
  static const String verticalDivider = 'verticaldivider';
  static const String badge = 'badge';
  static const String chip = 'chip';
  static const String avatar = 'avatar';
  static const String tooltip = 'tooltip';
  static const String progressIndicator = 'progressindicator';
  static const String circularProgressIndicator = 'circularprogressindicator';
  static const String linearProgressIndicator = 'linearprogressindicator';
  static const String placeholder = 'placeholder';
  static const String decoration = 'decoration';

  // Input Widgets (20)
  static const String button = 'button';
  static const String iconButton = 'iconbutton';
  static const String textField = 'textfield';
  static const String textFormField = 'textformfield';
  static const String checkbox = 'checkbox';
  static const String radio = 'radio';
  static const String switchWidget = 'switch';
  static const String slider = 'slider';
  static const String rangeSlider = 'rangeslider';
  static const String dropdown = 'dropdown';
  static const String popupMenuButton = 'popupmenubutton';
  static const String form = 'form';
  static const String numberField = 'numberfield';
  static const String colorPicker = 'colorpicker';
  static const String radioGroup = 'radiogroup';
  static const String checkboxGroup = 'checkboxgroup';
  static const String segmentedControl = 'segmentedcontrol';
  static const String dateField = 'datefield';
  static const String timeField = 'timefield';
  static const String dateRangePicker = 'daterangepicker';

  // List Widgets (3)
  static const String listView = 'listview';
  static const String gridView = 'gridview';
  static const String listTile = 'listtile';

  // Navigation Widgets (7)
  static const String appBar = 'appbar';
  static const String tabBar = 'tabbar';
  static const String tabBarView = 'tabbarview';
  static const String drawer = 'drawer';
  static const String bottomNavigationBar = 'bottomnavigationbar';
  static const String navigationRail = 'navigationrail';
  static const String floatingActionButton = 'floatingactionbutton';

  // Scroll Widgets (3)
  static const String singleChildScrollView = 'singlechildscrollview';
  static const String scrollBar = 'scrollbar';
  static const String scrollView = 'scrollview';

  // Animation Widgets (1)
  static const String animatedContainer = 'animatedcontainer';

  // Interactive Widgets (4)
  static const String gestureDetector = 'gesturedetector';
  static const String inkWell = 'inkwell';
  static const String draggable = 'draggable';
  static const String dragTarget = 'dragtarget';

  // Dialog Widgets (3)
  static const String alertDialog = 'alertdialog';
  static const String snackBar = 'snackbar';
  static const String bottomSheet = 'bottomsheet';

  /// All widget types grouped by category
  static const Map<String, List<String>> categories = {
    'layout': [
      column, row, stack, container, center, align, padding, margin,
      sizedBox, expanded, flexible, spacer, wrap, flow, table,
      positioned, intrinsicHeight, intrinsicWidth, visibility, conditional,
    ],
    'display': [
      text, richText, image, icon, card, divider, verticalDivider,
      badge, chip, avatar, tooltip, progressIndicator,
      circularProgressIndicator, linearProgressIndicator, placeholder, decoration,
    ],
    'input': [
      button, iconButton, textField, textFormField, checkbox, radio,
      switchWidget, slider, rangeSlider, dropdown, popupMenuButton, form,
      numberField, colorPicker, radioGroup, checkboxGroup, segmentedControl,
      dateField, timeField, dateRangePicker,
    ],
    'list': [
      listView, gridView, listTile,
    ],
    'navigation': [
      appBar, tabBar, tabBarView, drawer, bottomNavigationBar,
      navigationRail, floatingActionButton,
    ],
    'scroll': [
      singleChildScrollView, scrollBar, scrollView,
    ],
    'animation': [
      animatedContainer,
    ],
    'interactive': [
      gestureDetector, inkWell, draggable, dragTarget,
    ],
    'dialog': [
      alertDialog, snackBar, bottomSheet,
    ],
  };

  /// Get all widget types as a flat list
  static List<String> get allTypes {
    return categories.values.expand((types) => types).toList();
  }

  /// Get category for a widget type
  static String? getCategoryForType(String type) {
    for (final entry in categories.entries) {
      if (entry.value.contains(type)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Check if a widget type is valid
  static bool isValidType(String type) {
    return allTypes.contains(type);
  }

  /// Get widget types by category
  static List<String> getTypesByCategory(String category) {
    return categories[category] ?? [];
  }
}