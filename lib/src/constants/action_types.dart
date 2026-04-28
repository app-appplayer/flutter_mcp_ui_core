/// Action type constants for MCP UI DSL v1.0/v1.1
///
/// Contains all supported action types.
/// This ensures consistency between renderer and generator packages.
class ActionTypes {
  ActionTypes._();

  // Core action types (v1.0)
  static const String state = 'state';
  static const String navigation = 'navigation';
  static const String tool = 'tool';
  static const String resource = 'resource';
  static const String dialog = 'dialog';
  static const String batch = 'batch';
  static const String conditional = 'conditional';
  static const String notification = 'notification';
  static const String parallel = 'parallel';
  static const String sequence = 'sequence';

  // Extended action types (v1.1)
  static const String animation = 'animation';
  static const String cancel = 'cancel';
  static const String permissionRevoke = 'permission.revoke';

  // Client action types (v1.1)
  static const String clientSelectFile = 'client.selectFile';
  static const String clientReadFile = 'client.readFile';
  static const String clientWriteFile = 'client.writeFile';
  static const String clientSaveFile = 'client.saveFile';
  static const String clientListFiles = 'client.listFiles';
  static const String clientHttpRequest = 'client.httpRequest';
  static const String clientGetSystemInfo = 'client.getSystemInfo';
  static const String clientClipboard = 'client.clipboard';
  static const String clientExec = 'client.exec';
  static const String clientNotification = 'client.notification';
  static const String clientStorageGet = 'client.storage.get';
  static const String clientStorageSet = 'client.storage.set';
  static const String clientStorageRemove = 'client.storage.remove';

  // Channel action types (v1.1)
  static const String channelStart = 'channel.start';
  static const String channelStop = 'channel.stop';
  static const String channelRestart = 'channel.restart';
  static const String channelToggle = 'channel.toggle';
  static const String channelSend = 'channel.send';

  /// All core action types
  static const List<String> coreTypes = [
    state, navigation, tool, resource, dialog,
    batch, conditional, notification, parallel, sequence,
  ];

  /// All v1.1 action types
  static const List<String> v11Types = [
    animation, cancel, permissionRevoke,
    clientSelectFile, clientReadFile, clientWriteFile,
    clientSaveFile, clientListFiles, clientHttpRequest,
    clientGetSystemInfo, clientClipboard, clientExec, clientNotification,
    clientStorageGet, clientStorageSet, clientStorageRemove,
    channelStart, channelStop, channelRestart,
    channelToggle, channelSend,
  ];

  /// All action types combined
  static List<String> get all => [...coreTypes, ...v11Types];

  /// Check if an action type is a client action
  static bool isClientAction(String type) => type.startsWith('client.');

  /// Check if an action type is a channel action
  static bool isChannelAction(String type) => type.startsWith('channel.');

  /// Check if an action type is valid
  static bool isValid(String type) => all.contains(type);
}

/// Event name constants for MCP UI DSL v1.0
class EventNames {
  EventNames._();

  static const String click = 'click';
  static const String doubleClick = 'double-click';
  static const String rightClick = 'right-click';
  static const String longPress = 'long-press';
  static const String change = 'change';
  static const String focus = 'focus';
  static const String blur = 'blur';
  static const String hover = 'hover';
  static const String submit = 'submit';

  static const List<String> all = [
    click, doubleClick, rightClick, longPress,
    change, focus, blur, hover, submit,
  ];

  /// Check if an event name is valid
  static bool isValid(String name) => all.contains(name);
}

/// Button variant constants for MCP UI DSL v1.0
class ButtonVariants {
  ButtonVariants._();

  static const String elevated = 'elevated';
  static const String filled = 'filled';
  static const String outlined = 'outlined';
  static const String text = 'text';
  static const String icon = 'icon';

  static const List<String> all = [
    elevated, filled, outlined, text, icon,
  ];

  /// Check if a variant is valid
  static bool isValid(String variant) => all.contains(variant);
}

/// Size unit constants for MCP UI DSL v1.0
class SizeUnits {
  SizeUnits._();

  static const String px = 'px';
  static const String percent = 'percent';
  static const String em = 'em';
  static const String rem = 'rem';
  static const String vw = 'vw';
  static const String vh = 'vh';

  static const List<String> all = [
    px, percent, em, rem, vw, vh,
  ];

  /// Check if a unit is valid
  static bool isValid(String unit) => all.contains(unit);
}

/// Theme mode constants for MCP UI DSL v1.0
class ThemeModes {
  ThemeModes._();

  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';

  static const List<String> all = [light, dark, system];

  /// Check if a mode is valid
  static bool isValid(String mode) => all.contains(mode);
}

/// Binding prefix constants for MCP UI DSL v1.0/v1.1
class BindingPrefixes {
  BindingPrefixes._();

  // v1.0 prefixes
  static const String local = 'local.';
  static const String page = 'page.';
  static const String app = 'app.';
  static const String routeParams = 'route.params.';
  static const String theme = 'theme.';
  static const String event = 'event.';
  static const String item = 'item';
  static const String index = 'index';

  // v1.1 prefixes
  static const String client = 'client.';
  static const String clientFile = 'client.file.';
  static const String clientSystem = 'client.system.';
  static const String clientTheme = 'client.theme.';
  static const String permissions = 'permissions.';
  static const String channels = 'channels.';
  static const String resources = 'resources.';
  static const String sync = 'sync.';
  static const String runtime = 'runtime.';
  static const String clientEnv = 'client.env.';

  /// All v1.0 prefixes
  static const List<String> v10Prefixes = [
    local, page, app, routeParams, theme, event, item, index,
  ];

  /// All v1.1 prefixes
  static const List<String> v11Prefixes = [
    client, clientFile, clientSystem, clientTheme, clientEnv,
    permissions, channels, resources, sync, runtime,
  ];

  /// All prefixes combined
  static List<String> get all => [...v10Prefixes, ...v11Prefixes];
}

/// Validation rule type constants for MCP UI DSL v1.0
class ValidationRuleTypes {
  ValidationRuleTypes._();

  static const String required = 'required';
  static const String minLength = 'minLength';
  static const String maxLength = 'maxLength';
  static const String min = 'min';
  static const String max = 'max';
  static const String pattern = 'pattern';
  static const String email = 'email';
  static const String url = 'url';
  static const String match = 'match';
  static const String oneOf = 'oneOf';
  static const String custom = 'custom';
  static const String async = 'async';

  static const List<String> all = [
    required, minLength, maxLength, min, max,
    pattern, email, url, match, oneOf, custom, async,
  ];

  /// Check if a rule type is valid
  static bool isValid(String type) => all.contains(type);
}

/// State operation constants for MCP UI DSL v1.0
class StateOperations {
  StateOperations._();

  static const String set = 'set';
  static const String increment = 'increment';
  static const String decrement = 'decrement';
  static const String toggle = 'toggle';
  static const String append = 'append';
  static const String remove = 'remove';
  static const String push = 'push';
  static const String pop = 'pop';
  static const String removeAt = 'removeAt';

  static const List<String> all = [
    set, increment, decrement, toggle,
    append, remove, push, pop, removeAt,
  ];

  /// Check if an operation is valid
  static bool isValid(String op) => all.contains(op);
}

/// Navigation action constants for MCP UI DSL v1.0
class NavigationActions {
  NavigationActions._();

  static const String push = 'push';
  static const String replace = 'replace';
  static const String pop = 'pop';
  static const String popToRoot = 'popToRoot';
  static const String pushAndClear = 'pushAndClear';
  static const String setIndex = 'setIndex';
  static const String openApp = 'openApp'; // v1.3

  static const List<String> all = [
    push, replace, pop, popToRoot, pushAndClear, setIndex, openApp,
  ];

  /// Check if an action is valid
  static bool isValid(String action) => all.contains(action);
}
