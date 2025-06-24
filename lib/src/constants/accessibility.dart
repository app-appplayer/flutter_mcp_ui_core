/// Accessibility constants for MCP UI DSL v1.0
/// 
/// Contains ARIA-like role definitions and accessibility properties
/// as defined in the MCP UI DSL v1.0 specification.
class AccessibilityConstants {
  // Semantic Roles - Based on spec v1.0
  static const String roleButton = 'button';
  static const String roleLink = 'link';
  static const String roleHeading = 'heading';
  static const String roleNavigation = 'navigation';
  static const String roleMain = 'main';
  static const String roleComplementary = 'complementary';
  static const String roleForm = 'form';
  static const String roleSearch = 'search';
  static const String roleBanner = 'banner';
  static const String roleContentInfo = 'contentinfo';
  static const String roleRegion = 'region';
  static const String roleAlert = 'alert';
  static const String roleAlertDialog = 'alertdialog';
  static const String roleDialog = 'dialog';
  static const String roleImage = 'image';
  static const String roleList = 'list';
  static const String roleListItem = 'listitem';
  static const String roleMenu = 'menu';
  static const String roleMenuBar = 'menubar';
  static const String roleMenuItem = 'menuitem';
  static const String roleProgressBar = 'progressbar';
  static const String roleRadio = 'radio';
  static const String roleRadioGroup = 'radiogroup';
  static const String roleSlider = 'slider';
  static const String roleSpinButton = 'spinbutton';
  static const String roleSwitch = 'switch';
  static const String roleTab = 'tab';
  static const String roleTabList = 'tablist';
  static const String roleTabPanel = 'tabpanel';
  static const String roleTextBox = 'textbox';
  static const String roleTimer = 'timer';
  static const String roleToolbar = 'toolbar';
  static const String roleTooltip = 'tooltip';
  static const String roleTree = 'tree';
  static const String roleTreeItem = 'treeitem';
  static const String roleGrid = 'grid';
  static const String roleGridCell = 'gridcell';
  static const String roleRow = 'row';
  static const String roleRowHeader = 'rowheader';
  static const String roleColumnHeader = 'columnheader';
  
  // Live Region Values
  static const String livePolite = 'polite';
  static const String liveAssertive = 'assertive';
  static const String liveOff = 'off';
  
  // WCAG Levels
  static const String wcagLevelA = 'A';
  static const String wcagLevelAA = 'AA';
  static const String wcagLevelAAA = 'AAA';
  
  // Common Accessibility Properties
  static const String propertyLabel = 'label';
  static const String propertyDescription = 'description';
  static const String propertyRole = 'role';
  static const String propertyLive = 'live';
  static const String propertyLevel = 'level';
  static const String propertyExpanded = 'expanded';
  static const String propertySelected = 'selected';
  static const String propertyDisabled = 'disabled';
  static const String propertyReadonly = 'readonly';
  static const String propertyRequired = 'required';
  static const String propertyChecked = 'checked';
  static const String propertyPressed = 'pressed';
  static const String propertyValueMin = 'valuemin';
  static const String propertyValueMax = 'valuemax';
  static const String propertyValueNow = 'valuenow';
  static const String propertyValueText = 'valuetext';
  static const String propertyMultiSelectable = 'multiselectable';
  static const String propertyOrientation = 'orientation';
  static const String propertySort = 'sort';
  static const String propertyAutoComplete = 'autocomplete';
  static const String propertyHasPopup = 'haspopup';
  static const String propertyInvalid = 'invalid';
  static const String propertyHidden = 'hidden';
  static const String propertyBusy = 'busy';
  
  /// All valid semantic roles
  static const List<String> allRoles = [
    roleButton, roleLink, roleHeading, roleNavigation, roleMain,
    roleComplementary, roleForm, roleSearch, roleBanner, roleContentInfo,
    roleRegion, roleAlert, roleAlertDialog, roleDialog, roleImage,
    roleList, roleListItem, roleMenu, roleMenuBar, roleMenuItem,
    roleProgressBar, roleRadio, roleRadioGroup, roleSlider, roleSpinButton,
    roleSwitch, roleTab, roleTabList, roleTabPanel, roleTextBox,
    roleTimer, roleToolbar, roleTooltip, roleTree, roleTreeItem,
    roleGrid, roleGridCell, roleRow, roleRowHeader, roleColumnHeader,
  ];
  
  /// Map widget types to default semantic roles
  static const Map<String, String> defaultRoles = {
    'button': roleButton,
    'link': roleLink,
    'text-input': roleTextBox,
    'checkbox': 'checkbox',
    'radio': roleRadio,
    'toggle': roleSwitch,
    'slider': roleSlider,
    'select': 'combobox',
    'listview': roleList,
    'listtile': roleListItem,
    'header-bar': roleBanner,
    'navigation': roleNavigation,
    'form': roleForm,
    'image': roleImage,
    'progressindicator': roleProgressBar,
    'circularprogressindicator': roleProgressBar,
    'linearprogressindicator': roleProgressBar,
    'tabbar': roleTabList,
    'tab': roleTab,
    'tabbarview': roleTabPanel,
    'alertdialog': roleAlertDialog,
    'dialog': roleDialog,
    'tooltip': roleTooltip,
    'gridview': roleGrid,
    'tree': roleTree,
  };
  
  /// Check if a role is valid
  static bool isValidRole(String role) {
    return allRoles.contains(role);
  }
  
  /// Get default role for a widget type
  static String? getDefaultRole(String widgetType) {
    return defaultRoles[widgetType];
  }
  
  /// Check if a live region value is valid
  static bool isValidLiveValue(String value) {
    return [livePolite, liveAssertive, liveOff].contains(value);
  }
  
  /// Check if a WCAG level is valid
  static bool isValidWcagLevel(String level) {
    return [wcagLevelA, wcagLevelAA, wcagLevelAAA].contains(level);
  }
}