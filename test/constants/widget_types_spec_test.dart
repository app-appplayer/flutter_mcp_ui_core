import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

/// MCP UI DSL v1.0 Specification Compliance Test
/// 
/// This test verifies that the WidgetTypes constants exactly match
/// the MCP UI DSL v1.0 specification with no legacy support.
void main() {
  group('MCP UI DSL v1.0 Specification Compliance', () {
    group('Layout Widgets (9 total)', () {
      test('should define all layout widgets per spec', () {
        // Core layout widgets from spec
        expect(WidgetTypes.linear, equals('linear'));
        expect(WidgetTypes.stack, equals('stack'));
        expect(WidgetTypes.box, equals('box'));
        expect(WidgetTypes.center, equals('center'));
        expect(WidgetTypes.padding, equals('padding'));
        expect(WidgetTypes.sizedBox, equals('sizedBox')); // CamelCase
        expect(WidgetTypes.expanded, equals('expanded'));
        expect(WidgetTypes.flexible, equals('flexible'));
        expect(WidgetTypes.conditional, equals('conditional'));
        
        // Additional layout widgets found in spec
        expect(WidgetTypes.align, equals('align'));
        expect(WidgetTypes.positioned, equals('positioned'));
        expect(WidgetTypes.intrinsicHeight, equals('intrinsicHeight')); // CamelCase
        expect(WidgetTypes.intrinsicWidth, equals('intrinsicWidth')); // CamelCase
        expect(WidgetTypes.visibility, equals('visibility'));
        expect(WidgetTypes.spacer, equals('spacer'));
        expect(WidgetTypes.wrap, equals('wrap'));
        expect(WidgetTypes.flow, equals('flow'));
        expect(WidgetTypes.margin, equals('margin'));
      });
    });

    group('Display Widgets (8+ total)', () {
      test('should define all display widgets per spec', () {
        // Core display widgets from spec
        expect(WidgetTypes.text, equals('text'));
        expect(WidgetTypes.richText, equals('richText')); // CamelCase
        expect(WidgetTypes.image, equals('image'));
        expect(WidgetTypes.icon, equals('icon'));
        expect(WidgetTypes.card, equals('card'));
        expect(WidgetTypes.badge, equals('badge'));
        expect(WidgetTypes.loadingIndicator, equals('loadingIndicator')); // CamelCase
        expect(WidgetTypes.divider, equals('divider'));
        
        // Additional display widgets
        expect(WidgetTypes.verticalDivider, equals('verticalDivider')); // CamelCase
        expect(WidgetTypes.chip, equals('chip'));
        expect(WidgetTypes.avatar, equals('avatar'));
        expect(WidgetTypes.tooltip, equals('tooltip'));
        expect(WidgetTypes.placeholder, equals('placeholder'));
        expect(WidgetTypes.decoration, equals('decoration'));
      });
    });

    group('Input Widgets (7 basic + 8 extended)', () {
      test('should define all basic input widgets per spec', () {
        expect(WidgetTypes.button, equals('button'));
        expect(WidgetTypes.textInput, equals('textInput')); // CamelCase
        expect(WidgetTypes.select, equals('select'));
        expect(WidgetTypes.toggle, equals('toggle'));
        expect(WidgetTypes.slider, equals('slider'));
        expect(WidgetTypes.checkbox, equals('checkbox'));
        expect(WidgetTypes.radio, equals('radio'));
      });

      test('should define all extended input widgets per spec', () {
        expect(WidgetTypes.numberField, equals('numberField')); // CamelCase
        expect(WidgetTypes.colorPicker, equals('colorPicker')); // CamelCase
        expect(WidgetTypes.dateField, equals('dateField')); // CamelCase
        expect(WidgetTypes.timeField, equals('timeField')); // CamelCase
        expect(WidgetTypes.radioGroup, equals('radioGroup')); // CamelCase
        expect(WidgetTypes.checkboxGroup, equals('checkboxGroup')); // CamelCase
        expect(WidgetTypes.segmentedControl, equals('segmentedControl')); // CamelCase
        expect(WidgetTypes.dateRangePicker, equals('dateRangePicker')); // CamelCase
      });

      test('should define additional input widgets', () {
        expect(WidgetTypes.iconButton, equals('iconButton')); // CamelCase
        expect(WidgetTypes.textFormField, equals('textFormField')); // CamelCase
        expect(WidgetTypes.rangeSlider, equals('rangeSlider')); // CamelCase
        expect(WidgetTypes.popupMenuButton, equals('popupMenuButton')); // CamelCase
        expect(WidgetTypes.form, equals('form'));
      });
    });

    group('Navigation Widgets (4+ total)', () {
      test('should define all navigation widgets per spec', () {
        expect(WidgetTypes.headerBar, equals('headerBar')); // CamelCase
        expect(WidgetTypes.bottomNavigation, equals('bottomNavigation')); // CamelCase
        expect(WidgetTypes.drawer, equals('drawer'));
        expect(WidgetTypes.tabBar, equals('tabBar')); // CamelCase
        
        // Additional navigation widgets
        expect(WidgetTypes.tabBarView, equals('tabBarView')); // CamelCase
        expect(WidgetTypes.navigationRail, equals('navigationRail')); // CamelCase
        expect(WidgetTypes.floatingActionButton, equals('floatingActionButton')); // CamelCase
      });
    });

    group('List Widgets (3 total)', () {
      test('should define all list widgets per spec', () {
        expect(WidgetTypes.list, equals('list'));
        expect(WidgetTypes.grid, equals('grid'));
        expect(WidgetTypes.listTile, equals('listTile')); // CamelCase
      });
    });

    group('Advanced Widgets (8+ total)', () {
      test('should define scroll widgets per spec', () {
        expect(WidgetTypes.scrollView, equals('scrollView')); // CamelCase
        expect(WidgetTypes.singleChildScrollView, equals('singleChildScrollView')); // CamelCase
        expect(WidgetTypes.scrollBar, equals('scrollBar')); // CamelCase
      });

      test('should define data visualization widgets per spec', () {
        expect(WidgetTypes.chart, equals('chart'));
        expect(WidgetTypes.map, equals('map'));
        expect(WidgetTypes.mediaPlayer, equals('mediaPlayer')); // CamelCase
        expect(WidgetTypes.table, equals('table'));
        expect(WidgetTypes.dataTable, equals('dataTable'));
      });

      test('should define additional advanced widgets', () {
        expect(WidgetTypes.calendar, equals('calendar'));
        expect(WidgetTypes.timeline, equals('timeline'));
        expect(WidgetTypes.gauge, equals('gauge'));
        expect(WidgetTypes.heatmap, equals('heatmap'));
        expect(WidgetTypes.tree, equals('tree'));
        expect(WidgetTypes.graph, equals('graph'));
      });

      test('should define interactive widgets per spec', () {
        expect(WidgetTypes.draggable, equals('draggable'));
        expect(WidgetTypes.dragTarget, equals('dragTarget')); // CamelCase
        expect(WidgetTypes.gestureDetector, equals('gestureDetector')); // CamelCase
        expect(WidgetTypes.inkWell, equals('inkWell')); // CamelCase
      });

      test('should define animation widgets', () {
        expect(WidgetTypes.animatedContainer, equals('animatedContainer')); // CamelCase
      });

      test('should define dialog widgets', () {
        expect(WidgetTypes.alertDialog, equals('alertDialog')); // CamelCase
        expect(WidgetTypes.snackBar, equals('snackBar')); // CamelCase
        expect(WidgetTypes.bottomSheet, equals('bottomSheet')); // CamelCase
      });
    });

    group('Widget Naming Convention Compliance', () {
      test('single-word widgets should use lowercase', () {
        final singleWordWidgets = [
          'linear', 'stack', 'box', 'center', 'padding', 'expanded', 
          'flexible', 'conditional', 'align', 'positioned', 'visibility',
          'spacer', 'wrap', 'flow', 'margin', 'text', 'image', 'icon',
          'card', 'badge', 'divider', 'chip', 'avatar', 'tooltip',
          'placeholder', 'decoration', 'button', 'select', 'toggle',
          'slider', 'checkbox', 'radio', 'form', 'drawer', 'list',
          'grid', 'chart', 'map', 'table', 'calendar', 'timeline',
          'gauge', 'heatmap', 'tree', 'graph', 'draggable'
        ];

        for (final widget in singleWordWidgets) {
          expect(widget, equals(widget.toLowerCase()),
              reason: 'Single-word widget "$widget" should be lowercase');
          expect(WidgetTypes.isValidType(widget), isTrue,
              reason: 'Widget "$widget" should be valid');
        }
      });

      test('multi-word widgets should use CamelCase', () {
        final camelCaseWidgets = [
          'sizedBox', 'intrinsicHeight', 'intrinsicWidth', 'richText',
          'loadingIndicator', 'verticalDivider', 'textInput', 'numberField',
          'colorPicker', 'dateField', 'timeField', 'radioGroup',
          'checkboxGroup', 'segmentedControl', 'dateRangePicker',
          'iconButton', 'textFormField', 'rangeSlider', 'popupMenuButton',
          'headerBar', 'bottomNavigation', 'tabBar', 'tabBarView',
          'navigationRail', 'floatingActionButton', 'listTile', 'scrollView',
          'singleChildScrollView', 'scrollBar', 'mediaPlayer', 'dragTarget',
          'gestureDetector', 'inkWell', 'animatedContainer', 'alertDialog',
          'snackBar', 'bottomSheet'
        ];

        for (final widget in camelCaseWidgets) {
          // Check that it's not all lowercase
          expect(widget, isNot(equals(widget.toLowerCase())),
              reason: 'Multi-word widget "$widget" should use CamelCase');
          // Check that it doesn't contain hyphens
          expect(widget.contains('-'), isFalse,
              reason: 'Widget "$widget" should not contain hyphens');
          expect(WidgetTypes.isValidType(widget), isTrue,
              reason: 'Widget "$widget" should be valid');
        }
      });
    });

    group('Category Organization', () {
      test('all widgets should be categorized', () {
        final allTypes = WidgetTypes.allTypes;
        expect(allTypes, isNotEmpty);

        // Every widget should belong to exactly one category
        for (final type in allTypes) {
          final category = WidgetTypes.getCategoryForType(type);
          expect(category, isNotNull,
              reason: 'Widget "$type" should have a category');
        }
      });

      test('no duplicate widgets across categories', () {
        final allTypes = WidgetTypes.allTypes;
        final uniqueTypes = allTypes.toSet();
        expect(uniqueTypes.length, equals(allTypes.length),
            reason: 'There should be no duplicate widget types');
      });

      test('categories should match spec organization', () {
        expect(WidgetTypes.categories.keys, containsAll([
          'layout',
          'display',
          'input',
          'list',
          'navigation',
          'scroll',
          'animation',
          'interactive',
          'dialog',
          'advanced'
        ]));
      });
    });

    group('No Legacy Support', () {
      test('should not contain Flutter-specific legacy names', () {
        // These legacy names should NOT exist
        final legacyNames = [
          'column', 'row', 'textfield', 'dropdown',
          'switch', 'listview', 'gridview', 'appbar',
          'bottomnavigationbar', 'circularprogressindicator',
          'linearprogressindicator', 'switchwidget'
        ];

        for (final legacy in legacyNames) {
          expect(WidgetTypes.isValidType(legacy), isFalse,
              reason: 'Legacy widget "$legacy" should not be valid');
        }
      });

      test('should not contain hyphenated names', () {
        // All hyphenated names should be converted to CamelCase
        final allTypes = WidgetTypes.allTypes;
        for (final type in allTypes) {
          expect(type.contains('-'), isFalse,
              reason: 'Widget "$type" should not contain hyphens');
        }
      });
    });

    group('Helper Methods', () {
      test('getTypesByCategory should return correct widgets', () {
        final layoutWidgets = WidgetTypes.getTypesByCategory('layout');
        expect(layoutWidgets, contains('linear'));
        expect(layoutWidgets, contains('box'));
        expect(layoutWidgets, contains('sizedBox'));

        final inputWidgets = WidgetTypes.getTypesByCategory('input');
        expect(inputWidgets, contains('button'));
        expect(inputWidgets, contains('textInput'));
        expect(inputWidgets, contains('numberField'));
      });

      test('isValidType should work correctly', () {
        // Valid types
        expect(WidgetTypes.isValidType('linear'), isTrue);
        expect(WidgetTypes.isValidType('textInput'), isTrue);
        expect(WidgetTypes.isValidType('loadingIndicator'), isTrue);

        // Invalid types
        expect(WidgetTypes.isValidType('invalid'), isFalse);
        expect(WidgetTypes.isValidType(''), isFalse);
        expect(WidgetTypes.isValidType('column'), isFalse); // Legacy
      });
    });
  });
}