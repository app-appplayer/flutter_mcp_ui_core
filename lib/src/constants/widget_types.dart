/// Widget type constants for MCP UI DSL v1.0/v1.1
///
/// Contains all supported widget types organized by category.
/// This ensures consistency between renderer and generator packages.
/// Fully compliant with MCP UI DSL v1.0/v1.1 specification.
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
  static const String dataTable = 'dataTable';
  static const String positioned = 'positioned';
  static const String intrinsicHeight = 'intrinsicHeight'; // CamelCase
  static const String intrinsicWidth = 'intrinsicWidth'; // CamelCase
  static const String visibility = 'visibility';
  static const String conditional = 'conditional';
  static const String indexedStack = 'indexedStack'; // CamelCase
  static const String container = 'container'; // legacy alias for box
  static const String baseline = 'baseline';
  static const String fittedBox = 'fittedBox'; // CamelCase
  static const String limitedBox = 'limitedBox'; // CamelCase
  static const String mediaQuery = 'mediaQuery'; // CamelCase (v1.1)
  static const String safeArea = 'safeArea'; // CamelCase (v1.1)
  static const String aspectRatio = 'aspectRatio'; // CamelCase
  static const String fractionallySized = 'fractionallySized'; // CamelCase
  static const String layoutBuilder = 'layoutBuilder'; // CamelCase

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
  static const String clipOval = 'clipOval'; // CamelCase
  static const String clipRRect = 'clipRRect'; // CamelCase
  static const String progressBar = 'progressBar'; // CamelCase
  static const String banner = 'banner';

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
  static const String datePicker = 'datePicker'; // CamelCase
  static const String timePicker = 'timePicker'; // CamelCase
  static const String stepper = 'stepper';
  static const String numberStepper = 'numberStepper'; // CamelCase
  static const String rating = 'rating';

  // List Widgets - MCP UI DSL v1.0 spec compliant
  static const String list = 'list';
  static const String grid = 'grid';
  static const String listItem = 'listItem'; // Canonical per spec 17_Naming §17.2.1
  static const String listTile = 'listTile'; // Legacy alias of listItem per §17.3.1

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
  static const String pageView = 'pageView'; // CamelCase

  // Animation Widgets
  static const String animatedContainer = 'animatedContainer'; // CamelCase
  static const String lottieAnimation = 'lottieAnimation'; // CamelCase (v1.1)
  static const String opacity = 'opacity'; // v1.3
  static const String transform = 'transform'; // v1.3

  // Display Widgets (v1.3)
  static const String canvas = 'canvas'; // v1.3

  // Interactive Widgets
  static const String gestureDetector = 'gestureDetector'; // CamelCase
  static const String inkWell = 'inkWell'; // CamelCase
  static const String draggable = 'draggable';
  static const String dragTarget = 'dragTarget'; // CamelCase

  // Dialog Widgets
  static const String alertDialog = 'alertDialog'; // CamelCase
  static const String snackBar = 'snackBar'; // CamelCase
  static const String bottomSheet = 'bottomSheet'; // CamelCase
  static const String simpleDialog = 'simpleDialog'; // CamelCase
  static const String customDialog = 'customDialog'; // CamelCase
  
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
  static const String networkGraph = 'networkGraph'; // CamelCase
  static const String codeEditor = 'codeEditor'; // CamelCase
  static const String terminal = 'terminal';
  static const String fileExplorer = 'fileExplorer'; // CamelCase
  static const String markdown = 'markdown';
  static const String webView = 'webView'; // CamelCase
  static const String signature = 'signature';

  // Performance Widgets
  static const String lazy = 'lazy';

  // Security Widgets (v1.1)
  static const String permissionPrompt = 'permissionPrompt'; // CamelCase (v1.1)

  // Utility Widgets (v1.1) — error recovery and offline handling
  static const String errorBoundary = 'errorBoundary'; // CamelCase (v1.1)
  static const String offlineFallback = 'offlineFallback'; // CamelCase (v1.1)
  static const String errorRecovery = 'errorRecovery'; // CamelCase (v1.1)

  // Accessibility Widgets
  static const String accessibleWrapper = 'accessibleWrapper'; // CamelCase

  // Template Reference Widget (v1.1)
  static const String use = 'use'; // Template reference widget

  /// All widget types grouped by category - MCP UI DSL v1.0/v1.1 spec compliant
  static const Map<String, List<String>> categories = {
    'layout': [
      linear, stack, box, center, align, padding, margin,
      sizedBox, expanded, flexible, spacer, wrap, flow,
      positioned, intrinsicHeight, intrinsicWidth, visibility, conditional, table,
      indexedStack, container, baseline,
      fittedBox, limitedBox, mediaQuery, safeArea, aspectRatio, fractionallySized,
      layoutBuilder,
    ],
    'display': [
      text, richText, image, icon, card, divider, verticalDivider,
      badge, chip, avatar, tooltip, loadingIndicator,
      placeholder, decoration, clipOval, clipRRect, progressBar, banner,
      canvas,
    ],
    'input': [
      button, iconButton, textInput, textFormField, checkbox, radio,
      toggle, slider, rangeSlider, select, form,
      numberField, colorPicker, radioGroup, checkboxGroup, segmentedControl,
      dateField, timeField, dateRangePicker,
      datePicker, timePicker, stepper, numberStepper, rating,
    ],
    'list': [
      list, grid, listItem, listTile,
    ],
    'navigation': [
      headerBar, tabBar, tabBarView, drawer, bottomNavigation,
      navigationRail, floatingActionButton, popupMenuButton,
    ],
    'scroll': [
      scrollView, singleChildScrollView, scrollBar, pageView,
    ],
    'animation': [
      animatedContainer, lottieAnimation, opacity, transform,
    ],
    'interactive': [
      gestureDetector, inkWell, draggable, dragTarget,
    ],
    'dialog': [
      alertDialog, snackBar, bottomSheet, simpleDialog, customDialog,
    ],
    'advanced': [
      chart, map, mediaPlayer, calendar, timeline, gauge, heatmap, tree, graph, networkGraph,
      codeEditor, terminal, fileExplorer, markdown, webView, signature, dataTable,
    ],
    'performance': [
      lazy,
    ],
    'security': [
      permissionPrompt,
    ],
    'utility': [
      errorBoundary,
      offlineFallback,
      errorRecovery,
    ],
    'accessibility': [
      accessibleWrapper,
    ],
    'template': [
      use,
    ],
  };

  /// Legacy aliases mapping deprecated widget type names to their current names.
  ///
  /// Only kebab-case aliases and the `container` semantic alias are accepted.
  /// All other legacy names (column, row, switch, etc.) are invalid.
  static const Map<String, String> legacyAliases = {
    // Kebab-case to camelCase aliases (per core-models.md §3.1)
    'text-input': textInput,
    'header-bar': headerBar,
    'scroll-view': scrollView,
    'alert-dialog': alertDialog,
    'simple-dialog': simpleDialog,
    'custom-dialog': customDialog,
    'bottom-sheet': bottomSheet,
    'bottom-navigation': bottomNavigation,
    'floating-action-button': floatingActionButton,
    'snack-bar': snackBar,
    'tab-bar': tabBar,
    'popup-menu-button': popupMenuButton,
    'animated-container': animatedContainer,
    'gesture-detector': gestureDetector,
    'ink-well': inkWell,
    'drag-target': dragTarget,
    'list-item': listItem,
    'list-tile': listItem, // Legacy kebab alias resolves to canonical listItem
    'listTile': listItem, // Legacy camelCase alias resolves to canonical
    'list-view': list,
    'grid-view': grid,
    'rich-text': richText,
    'sized-box': sizedBox,
    'range-slider': rangeSlider,
    'text-form-field': textInput, // Legacy kebab alias resolves to canonical textInput per spec §17.3.1
    'textFormField': textInput, // Legacy camelCase alias resolves to canonical textInput
    'textfield': textInput, // Legacy lowercase alias per spec §17.3.1
    'textField': textInput, // Legacy camelCase alias per spec §17.3.1
    'icon-button': iconButton,
    'date-picker': datePicker,
    'time-picker': timePicker,
    'navigation-rail': navigationRail,
    'tab-bar-view': tabBarView,
    'single-child-scroll-view': singleChildScrollView,
    'scroll-bar': scrollBar,
    'page-view': pageView,
    'lottie-animation': lottieAnimation,
    'indexed-stack': indexedStack,
    'layout-builder': layoutBuilder,
    'loading-indicator': loadingIndicator,
    'vertical-divider': verticalDivider,
    'clip-oval': clipOval,
    'clip-r-rect': clipRRect,
    'progress-bar': progressBar,
    'intrinsic-height': intrinsicHeight,
    'intrinsic-width': intrinsicWidth,
    'aspect-ratio': aspectRatio,
    'fractionally-sized': fractionallySized,
    'fitted-box': fittedBox,
    'limited-box': limitedBox,
    'media-query': mediaQuery,
    'safe-area': safeArea,
    'accessible-wrapper': accessibleWrapper,
    'media-player': mediaPlayer,
    'network-graph': networkGraph,
    'code-editor': codeEditor,
    'file-explorer': fileExplorer,
    'web-view': webView,
    'number-field': numberField,
    'number-stepper': numberStepper,
    'color-picker': colorPicker,
    'date-field': dateField,
    'time-field': timeField,
    'date-range-picker': dateRangePicker,
    'radio-group': radioGroup,
    'checkbox-group': checkboxGroup,
    'segmented-control': segmentedControl,
    'permission-prompt': permissionPrompt,
    'error-boundary': errorBoundary,
    'offline-fallback': offlineFallback,
    'error-recovery': errorRecovery,
    // Semantic alias: only 'container' is retained per spec
    'container': box,
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

  /// Check if a widget type is valid or is a recognized legacy alias
  static bool isValidTypeOrAlias(String type) {
    return allTypes.contains(type) || legacyAliases.containsKey(type);
  }

  /// Resolve a widget type, converting legacy aliases to their current names
  static String resolveType(String type) {
    return legacyAliases[type] ?? type;
  }

  /// Get widget types by category
  static List<String> getTypesByCategory(String category) {
    return categories[category] ?? [];
  }
}