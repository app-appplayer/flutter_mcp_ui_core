/// MCP UI DSL placement check — the registry `placement` field applied to a
/// widget tree.
///
/// Some widgets are laid out by their parent rather than by themselves:
/// `expanded` / `flexible` / `spacer` take a share of a `linear`, and
/// `positioned` / `animatedPositioned` are placed by a `stack`. Anything
/// between the two breaks the layout, and a JSON Schema cannot say so — it
/// describes a node, not the node above it. This walk does.
///
/// Rules come from `widget_placement.g.dart`, generated from the same registry
/// YAML as the schema, so an editor, a server check and the runtime agree on
/// one table.
library;

import 'widget_placement.g.dart';
import 'widget_validator.dart';

/// Validates where each parent-dependent widget in [widget] sits.
///
/// [widget] is a widget tree root (a page `content`, a dialog body …); the
/// root has no parent, so a widget that needs one is reported there too.
/// Transparent widgets (`conditional`, `visibility` without preserved state)
/// are looked through. Unknown types are left to [validateMcpUiDslWidget]
/// and not descended into.
WidgetValidationResult validateMcpUiDslPlacement(Object? widget) {
  final errors = <WidgetValidationError>[];
  _walk(widget, null, '#', errors);
  return WidgetValidationResult(errors);
}

/// The layout parent a node sees: a canonical type, or a description of why
/// it is not a usable parent. `null` = tree root.
typedef _Parent = ({String type, String? disqualifiedBy});

void _walk(
  Object? value,
  _Parent? parent,
  String path,
  List<WidgetValidationError> errors,
) {
  if (value is List) {
    for (var i = 0; i < value.length; i++) {
      _walk(value[i], parent, '$path/$i', errors);
    }
    return;
  }
  if (value is! Map) return;

  final rawType = value['type'];
  if (rawType == null) {
    // Not a widget but inside a widget slot (a `cases` entry, a `lazy`
    // content descriptor): its widgets still sit in that slot.
    for (final entry in value.entries) {
      _walk(entry.value, parent, '$path/${entry.key}', errors);
    }
    return;
  }
  final type = _canonical(rawType);
  if (type == null) return;

  final rule = mcpUiDslPlacementRules[type];
  if (rule != null && rule.parents.isNotEmpty) {
    final fits = parent != null &&
        parent.disqualifiedBy == null &&
        rule.parents.contains(parent.type);
    if (!fits) {
      errors.add(WidgetValidationError(
        path: path,
        message: '`$rawType` must be a direct child of '
            '${rule.parents.map((t) => '`$t`').join(' or ')} '
            '(found: ${_describe(parent)})',
      ));
    }
  }

  final _Parent? childParent;
  if (rule != null &&
      rule.transparent &&
      !rule.opaqueWhen.any((k) => value[k] == true)) {
    childParent = parent;
  } else {
    final blocker =
        rule?.notParentWhen.where((k) => value[k] == true).firstOrNull;
    childParent = (type: type, disqualifiedBy: blocker);
  }

  for (final key in mcpUiDslWidgetSlots[type] ?? const <String>[]) {
    if (value.containsKey(key)) {
      _walk(value[key], childParent, '$path/$key', errors);
    }
  }
  // Widgets inside named-type properties (`steps[].content`): the owning
  // widget is their parent, as for a direct slot.
  for (final nested in mcpUiDslWidgetNestedSlots[type] ?? const <String>[]) {
    _descend(value, _segments(nested), 0, childParent, path, errors);
  }
}

/// `steps[].content` -> [`steps`, `[]`, `content`].
List<String> _segments(String nested) => [
      for (final part in nested.split('.'))
        for (final m in RegExp(r'([^\[\]]+)|(\[\])').allMatches(part)) m[0]!,
    ];

void _descend(
  Object? value,
  List<String> segments,
  int i,
  _Parent? parent,
  String path,
  List<WidgetValidationError> errors,
) {
  if (i == segments.length) {
    _walk(value, parent, path, errors);
    return;
  }
  final seg = segments[i];
  if (seg == '[]') {
    if (value is! List) return;
    for (var k = 0; k < value.length; k++) {
      _descend(value[k], segments, i + 1, parent, '$path/$k', errors);
    }
    return;
  }
  if (value is! Map || !value.containsKey(seg)) return;
  _descend(value[seg], segments, i + 1, parent, '$path/$seg', errors);
}

String? _canonical(Object? type) {
  if (type is! String) return null;
  if (mcpUiDslWidgetSlots.containsKey(type)) return type;
  return mcpUiDslWidgetAliases[type];
}

String _describe(_Parent? parent) {
  if (parent == null) return 'the tree root';
  final blocker = parent.disqualifiedBy;
  if (blocker != null) return '`${parent.type}` with `$blocker: true`';
  return '`${parent.type}`';
}
