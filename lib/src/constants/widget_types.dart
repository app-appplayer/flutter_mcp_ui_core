/// Widget type constants for MCP UI DSL v1.0
/// 
/// Contains all supported widget types organized by category.
/// This ensures consistency between renderer and generator packages.
/// Fully compliant with MCP UI DSL v1.0 specification - no legacy support.
class WidgetTypes {
  // Layout Widgets - MCP UI DSL v1.0 spec compliant
  static const String linear = 'linear';
  static const String stack = 'stack';
  static const String box = 'box';
  static const String center = 'center';
  static const String align = 'align';
  static const String padding = 'padding';
  static const String margin = 'margin';
  static const String sizedBox = 'sizedBox'; // CamelCase
  static const String expanded = 'expanded';
  static const String flexible = 'flexible';
  static const String spacer = 'spacer';
  static const String wrap = 'wrap';
  static const String flow = 'flow';
  static const String table = 'table';
  static const String positioned = 'positioned';
  static const String intrinsicHeight = 'intrinsicHeight'; // CamelCase
  static const String intrinsicWidth = 'intrinsicWidth'; // CamelCase
  static const String visibility = 'visibility';
  static const String conditional = 'conditional';

  // Display Widgets - MCP UI DSL v1.0 spec compliant
  static const String text = 'text';
  static const String richText = 'richText'; // CamelCase
  static const String image = 'image';
  static const String icon = 'icon';
  static const String card = 'card';
  static const String divider = 'divider';
  static const String verticalDivider = 'verticalDivider'; // CamelCase
  static const String badge = 'badge';
  static const String chip = 'chip';
  static const String avatar = 'avatar';
  static const String tooltip = 'tooltip';
  static const String loadingIndicator = 'loadingIndicator'; // CamelCase
  static const String placeholder = 'placeholder';
  static const String decoration = 'decoration';

  // Input Widgets - MCP UI DSL v1.0 spec compliant
  static const String button = 'button';
  static const String iconButton = 'iconButton'; // CamelCase
  static const String textInput = 'textInput'; // CamelCase
  static const String textFormField = 'textFormField'; // CamelCase
  static const String checkbox = 'checkbox';
  static const String radio = 'radio';
  static const String toggle = 'toggle';
  static const String slider = 'slider';
  static const String rangeSlider = 'rangeSlider'; // CamelCase
  static const String select = 'select';
  static const String popupMenuButton = 'popupMenuButton'; // CamelCase
  static const String form = 'form';
  static const String numberField = 'numberField'; // CamelCase per spec
  static const String colorPicker = 'colorPicker'; // CamelCase per spec
  static const String radioGroup = 'radioGroup'; // CamelCase per spec
  static const String checkboxGroup = 'checkboxGroup'; // CamelCase per spec
  static const String segmentedControl = 'segmentedControl'; // CamelCase per spec
  static const String dateField = 'dateField'; // CamelCase per spec
  static const String timeField = 'timeField'; // CamelCase per spec
  static const String dateRangePicker = 'dateRangePicker'; // CamelCase per spec

  // List Widgets - MCP UI DSL v1.0 spec compliant
  static const String list = 'list';
  static const String grid = 'grid';
  static const String listTile = 'listTile'; // CamelCase

  // Navigation Widgets - MCP UI DSL v1.0 spec compliant
  static const String headerBar = 'headerBar'; // CamelCase
  static const String tabBar = 'tabBar'; // CamelCase
  static const String tabBarView = 'tabBarView'; // CamelCase
  static const String drawer = 'drawer';
  static const String bottomNavigation = 'bottomNavigation'; // CamelCase
  static const String navigationRail = 'navigationRail'; // CamelCase
  static const String floatingActionButton = 'floatingActionButton'; // CamelCase

  // Scroll Widgets - MCP UI DSL v1.0 spec compliant
  static const String scrollView = 'scrollView'; // CamelCase
  static const String singleChildScrollView = 'singleChildScrollView'; // CamelCase
  static const String scrollBar = 'scrollBar'; // CamelCase

  // Animation Widgets
  static const String animatedContainer = 'animatedContainer'; // CamelCase

  // Interactive Widgets
  static const String gestureDetector = 'gestureDetector'; // CamelCase
  static const String inkWell = 'inkWell'; // CamelCase
  static const String draggable = 'draggable';
  static const String dragTarget = 'dragTarget'; // CamelCase

  // Dialog Widgets
  static const String alertDialog = 'alertDialog'; // CamelCase
  static const String snackBar = 'snackBar'; // CamelCase
  static const String bottomSheet = 'bottomSheet'; // CamelCase
  
  // Advanced Widgets - MCP UI DSL v1.0 spec compliant
  static const String chart = 'chart';
  static const String map = 'map';
  static const String mediaPlayer = 'mediaPlayer'; // CamelCase
  static const String calendar = 'calendar';
  static const String timeline = 'timeline';
  static const String gauge = 'gauge';
  static const String heatmap = 'heatmap';
  static const String tree = 'tree';
  static const String graph = 'graph';

  /// All widget types grouped by category - MCP UI DSL v1.0 spec compliant only
  static const Map<String, List<String>> categories = {
    'layout': [
      linear, stack, box, center, align, padding, margin,
      sizedBox, expanded, flexible, spacer, wrap, flow, table,
      positioned, intrinsicHeight, intrinsicWidth, visibility, conditional,
    ],
    'display': [
      text, richText, image, icon, card, divider, verticalDivider,
      badge, chip, avatar, tooltip, loadingIndicator,
      placeholder, decoration,
    ],
    'input': [
      button, iconButton, textInput, textFormField, checkbox, radio,
      toggle, slider, rangeSlider, select, popupMenuButton, form,
      numberField, colorPicker, radioGroup, checkboxGroup, segmentedControl,
      dateField, timeField, dateRangePicker,
    ],
    'list': [
      list, grid, listTile,
    ],
    'navigation': [
      headerBar, tabBar, tabBarView, drawer, bottomNavigation,
      navigationRail, floatingActionButton,
    ],
    'scroll': [
      scrollView, singleChildScrollView, scrollBar,
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
    'advanced': [
      chart, map, mediaPlayer, calendar, timeline, gauge, heatmap, tree, graph,
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