import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

/// Widget Types Test - MCP UI DSL v1.0 Spec Compliant
/// 
/// Tests all widget type constants against the official MCP UI DSL v1.0 specification.
/// No legacy support - only spec-compliant widget names.
void main() {
  group('WidgetTypes - MCP UI DSL v1.0 Compliance', () {
    group('Widget Type Constants by Category', () {
      test('Layout widgets should match spec exactly', () {
        // From spec: 9 core layout widgets + additional
        expect(WidgetTypes.linear, equals('linear'));
        expect(WidgetTypes.stack, equals('stack'));
        expect(WidgetTypes.box, equals('box'));
        expect(WidgetTypes.center, equals('center'));
        expect(WidgetTypes.padding, equals('padding'));
        expect(WidgetTypes.sizedBox, equals('sizedBox')); // CamelCase per spec
        expect(WidgetTypes.expanded, equals('expanded'));
        expect(WidgetTypes.flexible, equals('flexible'));
        expect(WidgetTypes.conditional, equals('conditional'));
        
        // Additional layout widgets
        expect(WidgetTypes.align, equals('align'));
        expect(WidgetTypes.margin, equals('margin'));
        expect(WidgetTypes.spacer, equals('spacer'));
        expect(WidgetTypes.wrap, equals('wrap'));
        expect(WidgetTypes.flow, equals('flow'));
        expect(WidgetTypes.table, equals('table'));
        expect(WidgetTypes.dataTable, equals('dataTable'));
        expect(WidgetTypes.positioned, equals('positioned'));
        expect(WidgetTypes.intrinsicHeight, equals('intrinsicHeight')); // CamelCase
        expect(WidgetTypes.intrinsicWidth, equals('intrinsicWidth')); // CamelCase
        expect(WidgetTypes.visibility, equals('visibility'));
      });

      test('Display widgets should match spec exactly', () {
        // From spec: 8 core display widgets
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

      test('Basic input widgets should match spec exactly', () {
        // From spec: 7 basic input widgets
        expect(WidgetTypes.button, equals('button'));
        expect(WidgetTypes.textInput, equals('textInput')); // CamelCase
        expect(WidgetTypes.select, equals('select'));
        expect(WidgetTypes.toggle, equals('toggle'));
        expect(WidgetTypes.slider, equals('slider'));
        expect(WidgetTypes.checkbox, equals('checkbox'));
        expect(WidgetTypes.radio, equals('radio'));
      });

      test('Extended input widgets should match spec exactly', () {
        // From spec: 8 extended input widgets
        expect(WidgetTypes.numberField, equals('numberField')); // CamelCase
        expect(WidgetTypes.colorPicker, equals('colorPicker')); // CamelCase
        expect(WidgetTypes.dateField, equals('dateField')); // CamelCase
        expect(WidgetTypes.timeField, equals('timeField')); // CamelCase
        expect(WidgetTypes.radioGroup, equals('radioGroup')); // CamelCase
        expect(WidgetTypes.checkboxGroup, equals('checkboxGroup')); // CamelCase
        expect(WidgetTypes.segmentedControl, equals('segmentedControl')); // CamelCase
        expect(WidgetTypes.dateRangePicker, equals('dateRangePicker')); // CamelCase
        
        // Additional input widgets
        expect(WidgetTypes.iconButton, equals('iconButton')); // CamelCase
        expect(WidgetTypes.textFormField, equals('textFormField')); // CamelCase
        expect(WidgetTypes.rangeSlider, equals('rangeSlider')); // CamelCase
        expect(WidgetTypes.popupMenuButton, equals('popupMenuButton')); // CamelCase
        expect(WidgetTypes.form, equals('form'));
      });

      test('Navigation widgets should match spec exactly', () {
        // From spec: 4 core navigation widgets
        expect(WidgetTypes.headerBar, equals('headerBar')); // CamelCase
        expect(WidgetTypes.bottomNavigation, equals('bottomNavigation')); // CamelCase
        expect(WidgetTypes.drawer, equals('drawer'));
        expect(WidgetTypes.tabBar, equals('tabBar')); // CamelCase
        
        // Additional navigation widgets
        expect(WidgetTypes.tabBarView, equals('tabBarView')); // CamelCase
        expect(WidgetTypes.navigationRail, equals('navigationRail')); // CamelCase
        expect(WidgetTypes.floatingActionButton, equals('floatingActionButton')); // CamelCase
      });

      test('List widgets should match spec exactly', () {
        // From spec: 3 list widgets
        expect(WidgetTypes.list, equals('list'));
        expect(WidgetTypes.grid, equals('grid'));
        expect(WidgetTypes.listTile, equals('listTile')); // CamelCase
      });

      test('Scroll widgets should match spec exactly', () {
        expect(WidgetTypes.scrollView, equals('scrollView')); // CamelCase
        expect(WidgetTypes.singleChildScrollView, equals('singleChildScrollView')); // CamelCase
        expect(WidgetTypes.scrollBar, equals('scrollBar')); // CamelCase
      });

      test('Interactive widgets should match spec exactly', () {
        expect(WidgetTypes.gestureDetector, equals('gestureDetector')); // CamelCase
        expect(WidgetTypes.inkWell, equals('inkWell')); // CamelCase
        expect(WidgetTypes.draggable, equals('draggable'));
        expect(WidgetTypes.dragTarget, equals('dragTarget')); // CamelCase
      });

      test('Animation widgets should be defined', () {
        expect(WidgetTypes.animatedContainer, equals('animatedContainer')); // CamelCase
      });

      test('Dialog widgets should be defined', () {
        expect(WidgetTypes.alertDialog, equals('alertDialog')); // CamelCase
        expect(WidgetTypes.snackBar, equals('snackBar')); // CamelCase
        expect(WidgetTypes.bottomSheet, equals('bottomSheet')); // CamelCase
      });

      test('Advanced widgets should match spec exactly', () {
        expect(WidgetTypes.chart, equals('chart'));
        expect(WidgetTypes.map, equals('map'));
        expect(WidgetTypes.mediaPlayer, equals('mediaPlayer')); // CamelCase
        expect(WidgetTypes.calendar, equals('calendar'));
        expect(WidgetTypes.timeline, equals('timeline'));
        expect(WidgetTypes.gauge, equals('gauge'));
        expect(WidgetTypes.heatmap, equals('heatmap'));
        expect(WidgetTypes.tree, equals('tree'));
        expect(WidgetTypes.graph, equals('graph'));
      });
    });

    group('Widget Categories Structure', () {
      test('should have all required categories', () {
        final categories = WidgetTypes.categories;
        
        expect(categories.containsKey('layout'), isTrue);
        expect(categories.containsKey('display'), isTrue);
        expect(categories.containsKey('input'), isTrue);
        expect(categories.containsKey('list'), isTrue);
        expect(categories.containsKey('navigation'), isTrue);
        expect(categories.containsKey('scroll'), isTrue);
        expect(categories.containsKey('animation'), isTrue);
        expect(categories.containsKey('interactive'), isTrue);
        expect(categories.containsKey('dialog'), isTrue);
        expect(categories.containsKey('advanced'), isTrue);
      });

      test('layout category should contain correct widgets', () {
        final layoutWidgets = WidgetTypes.categories['layout']!;
        expect(layoutWidgets, contains('linear'));
        expect(layoutWidgets, contains('stack'));
        expect(layoutWidgets, contains('box'));
        expect(layoutWidgets, contains('sizedBox'));
        expect(layoutWidgets, contains('conditional'));
        expect(layoutWidgets, contains('intrinsicHeight'));
        expect(layoutWidgets, contains('intrinsicWidth'));
      });

      test('display category should contain correct widgets', () {
        final displayWidgets = WidgetTypes.categories['display']!;
        expect(displayWidgets, contains('text'));
        expect(displayWidgets, contains('richText'));
        expect(displayWidgets, contains('loadingIndicator'));
        expect(displayWidgets, contains('verticalDivider'));
      });

      test('input category should contain correct widgets', () {
        final inputWidgets = WidgetTypes.categories['input']!;
        expect(inputWidgets, contains('button'));
        expect(inputWidgets, contains('textInput'));
        expect(inputWidgets, contains('numberField'));
        expect(inputWidgets, contains('colorPicker'));
        expect(inputWidgets, contains('dateRangePicker'));
      });

      test('list category should contain correct widgets', () {
        final listWidgets = WidgetTypes.categories['list']!;
        expect(listWidgets, containsAll(['list', 'grid', 'listItem', 'listTile']));
        expect(listWidgets.length, equals(4));
      });

      test('navigation category should contain correct widgets', () {
        final navWidgets = WidgetTypes.categories['navigation']!;
        expect(navWidgets, contains('headerBar'));
        expect(navWidgets, contains('bottomNavigation'));
        expect(navWidgets, contains('floatingActionButton'));
      });

      test('scroll category should contain correct widgets', () {
        final scrollWidgets = WidgetTypes.categories['scroll']!;
        expect(scrollWidgets, containsAll(['scrollView', 'singleChildScrollView', 'scrollBar', 'pageView']));
        expect(scrollWidgets.length, equals(4));
      });
    });

    group('Widget Type Methods', () {
      test('allTypes should return all widget types', () {
        final allTypes = WidgetTypes.allTypes;
        
        // Should contain key widgets from each category
        expect(allTypes, contains('linear'));
        expect(allTypes, contains('textInput'));
        expect(allTypes, contains('loadingIndicator'));
        expect(allTypes, contains('numberField'));
        expect(allTypes, contains('headerBar'));
        expect(allTypes, contains('scrollView'));
        
        // Should not contain duplicates
        final uniqueTypes = allTypes.toSet();
        expect(uniqueTypes.length, equals(allTypes.length));
      });

      test('getCategoryForType should return correct category', () {
        // Layout widgets
        expect(WidgetTypes.getCategoryForType('linear'), equals('layout'));
        expect(WidgetTypes.getCategoryForType('sizedBox'), equals('layout'));
        
        // Display widgets
        expect(WidgetTypes.getCategoryForType('text'), equals('display'));
        expect(WidgetTypes.getCategoryForType('loadingIndicator'), equals('display'));
        
        // Input widgets
        expect(WidgetTypes.getCategoryForType('button'), equals('input'));
        expect(WidgetTypes.getCategoryForType('textInput'), equals('input'));
        expect(WidgetTypes.getCategoryForType('numberField'), equals('input'));
        
        // List widgets
        expect(WidgetTypes.getCategoryForType('list'), equals('list'));
        expect(WidgetTypes.getCategoryForType('grid'), equals('list'));
        expect(WidgetTypes.getCategoryForType('listTile'), equals('list'));
        
        // Navigation widgets
        expect(WidgetTypes.getCategoryForType('headerBar'), equals('navigation'));
        expect(WidgetTypes.getCategoryForType('bottomNavigation'), equals('navigation'));
        
        // Advanced widgets
        expect(WidgetTypes.getCategoryForType('chart'), equals('advanced'));
        expect(WidgetTypes.getCategoryForType('mediaPlayer'), equals('advanced'));
        
        // Invalid type
        expect(WidgetTypes.getCategoryForType('unknown'), isNull);
      });

      test('isValidType should validate widget types correctly', () {
        // Valid spec-compliant types
        expect(WidgetTypes.isValidType('linear'), isTrue);
        expect(WidgetTypes.isValidType('textInput'), isTrue);
        expect(WidgetTypes.isValidType('loadingIndicator'), isTrue);
        expect(WidgetTypes.isValidType('numberField'), isTrue);
        expect(WidgetTypes.isValidType('scrollView'), isTrue);
        expect(WidgetTypes.isValidType('headerBar'), isTrue);
        expect(WidgetTypes.isValidType('bottomNavigation'), isTrue);
        expect(WidgetTypes.isValidType('mediaPlayer'), isTrue);
        
        // Invalid types (including legacy names)
        expect(WidgetTypes.isValidType('column'), isFalse); // Legacy
        expect(WidgetTypes.isValidType('row'), isFalse); // Legacy
        expect(WidgetTypes.isValidType('container'), isTrue); // Legacy alias for box
        expect(WidgetTypes.isValidType('textfield'), isFalse); // Legacy
        expect(WidgetTypes.isValidType('text-input'), isFalse); // Hyphenated
        expect(WidgetTypes.isValidType('loading-indicator'), isFalse); // Hyphenated
        expect(WidgetTypes.isValidType('invalid'), isFalse);
        expect(WidgetTypes.isValidType(''), isFalse);
      });

      test('getTypesByCategory should return correct widget lists', () {
        // Layout category
        final layoutTypes = WidgetTypes.getTypesByCategory('layout');
        expect(layoutTypes, isNotEmpty);
        expect(layoutTypes, contains('linear'));
        expect(layoutTypes, contains('box'));
        expect(layoutTypes, contains('sizedBox'));
        
        // Display category
        final displayTypes = WidgetTypes.getTypesByCategory('display');
        expect(displayTypes, isNotEmpty);
        expect(displayTypes, contains('text'));
        expect(displayTypes, contains('loadingIndicator'));
        
        // Invalid category
        expect(WidgetTypes.getTypesByCategory('invalid'), isEmpty);
      });
    });

    group('Spec Compliance Verification', () {
      test('no hyphenated widget names should exist', () {
        final allTypes = WidgetTypes.allTypes;
        for (final type in allTypes) {
          expect(type.contains('-'), isFalse,
              reason: 'Widget type "$type" should not contain hyphens');
        }
      });

      test('naming convention should be consistent', () {
        final allTypes = WidgetTypes.allTypes;
        for (final type in allTypes) {
          if (type.toLowerCase() == type) {
            // Single word - should be all lowercase
            expect(type.contains(RegExp(r'[A-Z]')), isFalse,
                reason: 'Single-word widget "$type" should be all lowercase');
          } else {
            // Multi-word - should use CamelCase
            expect(type[0], equals(type[0].toLowerCase()),
                reason: 'Multi-word widget "$type" should start with lowercase');
            expect(type.contains(RegExp(r'[A-Z]')), isTrue,
                reason: 'Multi-word widget "$type" should use CamelCase');
          }
        }
      });

      test('every widget should belong to exactly one category', () {
        final allTypes = WidgetTypes.allTypes;
        for (final type in allTypes) {
          int categoryCount = 0;
          for (final category in WidgetTypes.categories.values) {
            if (category.contains(type)) {
              categoryCount++;
            }
          }
          expect(categoryCount, equals(1),
              reason: 'Widget type "$type" should belong to exactly one category');
        }
      });
    });
  });
}