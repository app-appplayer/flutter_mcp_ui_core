import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('WidgetTypes', () {
    group('Widget Type Constants', () {
      test('should have all layout widget types', () {
        expect(WidgetTypes.column, equals('column'));
        expect(WidgetTypes.row, equals('row'));
        expect(WidgetTypes.stack, equals('stack'));
        expect(WidgetTypes.container, equals('container'));
        expect(WidgetTypes.center, equals('center'));
        expect(WidgetTypes.align, equals('align'));
        expect(WidgetTypes.padding, equals('padding'));
        expect(WidgetTypes.margin, equals('margin'));
        expect(WidgetTypes.sizedBox, equals('sizedbox'));
        expect(WidgetTypes.expanded, equals('expanded'));
        expect(WidgetTypes.flexible, equals('flexible'));
        expect(WidgetTypes.spacer, equals('spacer'));
        expect(WidgetTypes.wrap, equals('wrap'));
        expect(WidgetTypes.flow, equals('flow'));
        expect(WidgetTypes.table, equals('table'));
        expect(WidgetTypes.positioned, equals('positioned'));
        expect(WidgetTypes.intrinsicHeight, equals('intrinsicheight'));
        expect(WidgetTypes.intrinsicWidth, equals('intrinsicwidth'));
        expect(WidgetTypes.visibility, equals('visibility'));
        expect(WidgetTypes.conditional, equals('conditional'));
      });

      test('should have all display widget types', () {
        expect(WidgetTypes.text, equals('text'));
        expect(WidgetTypes.richText, equals('richtext'));
        expect(WidgetTypes.image, equals('image'));
        expect(WidgetTypes.icon, equals('icon'));
        expect(WidgetTypes.card, equals('card'));
        expect(WidgetTypes.divider, equals('divider'));
        expect(WidgetTypes.verticalDivider, equals('verticaldivider'));
        expect(WidgetTypes.badge, equals('badge'));
        expect(WidgetTypes.chip, equals('chip'));
        expect(WidgetTypes.avatar, equals('avatar'));
        expect(WidgetTypes.tooltip, equals('tooltip'));
        expect(WidgetTypes.progressIndicator, equals('progressindicator'));
        expect(WidgetTypes.circularProgressIndicator, equals('circularprogressindicator'));
        expect(WidgetTypes.linearProgressIndicator, equals('linearprogressindicator'));
        expect(WidgetTypes.placeholder, equals('placeholder'));
        expect(WidgetTypes.decoration, equals('decoration'));
      });

      test('should have all new input widget types', () {
        // Existing input widgets
        expect(WidgetTypes.button, equals('button'));
        expect(WidgetTypes.iconButton, equals('iconbutton'));
        expect(WidgetTypes.textField, equals('textfield'));
        expect(WidgetTypes.textFormField, equals('textformfield'));
        expect(WidgetTypes.checkbox, equals('checkbox'));
        expect(WidgetTypes.radio, equals('radio'));
        expect(WidgetTypes.switchWidget, equals('switch'));
        expect(WidgetTypes.slider, equals('slider'));
        expect(WidgetTypes.rangeSlider, equals('rangeslider'));
        expect(WidgetTypes.dropdown, equals('dropdown'));
        expect(WidgetTypes.popupMenuButton, equals('popupmenubutton'));
        expect(WidgetTypes.form, equals('form'));
        
        // New input widgets
        expect(WidgetTypes.numberField, equals('numberfield'));
        expect(WidgetTypes.colorPicker, equals('colorpicker'));
        expect(WidgetTypes.radioGroup, equals('radiogroup'));
        expect(WidgetTypes.checkboxGroup, equals('checkboxgroup'));
        expect(WidgetTypes.segmentedControl, equals('segmentedcontrol'));
        expect(WidgetTypes.dateField, equals('datefield'));
        expect(WidgetTypes.timeField, equals('timefield'));
        expect(WidgetTypes.dateRangePicker, equals('daterangepicker'));
      });

      test('should have all list widget types', () {
        expect(WidgetTypes.listView, equals('listview'));
        expect(WidgetTypes.gridView, equals('gridview'));
        expect(WidgetTypes.listTile, equals('listtile'));
      });

      test('should have all navigation widget types', () {
        expect(WidgetTypes.appBar, equals('appbar'));
        expect(WidgetTypes.tabBar, equals('tabbar'));
        expect(WidgetTypes.tabBarView, equals('tabbarview'));
        expect(WidgetTypes.drawer, equals('drawer'));
        expect(WidgetTypes.bottomNavigationBar, equals('bottomnavigationbar'));
        expect(WidgetTypes.navigationRail, equals('navigationrail'));
        expect(WidgetTypes.floatingActionButton, equals('floatingactionbutton'));
      });

      test('should have all scroll widget types', () {
        expect(WidgetTypes.singleChildScrollView, equals('singlechildscrollview'));
        expect(WidgetTypes.scrollBar, equals('scrollbar'));
        expect(WidgetTypes.scrollView, equals('scrollview'));
      });

      test('should have all animation widget types', () {
        expect(WidgetTypes.animatedContainer, equals('animatedcontainer'));
      });

      test('should have all interactive widget types', () {
        expect(WidgetTypes.gestureDetector, equals('gesturedetector'));
        expect(WidgetTypes.inkWell, equals('inkwell'));
        expect(WidgetTypes.draggable, equals('draggable'));
        expect(WidgetTypes.dragTarget, equals('dragtarget'));
      });

      test('should have all dialog widget types', () {
        expect(WidgetTypes.alertDialog, equals('alertdialog'));
        expect(WidgetTypes.snackBar, equals('snackbar'));
        expect(WidgetTypes.bottomSheet, equals('bottomsheet'));
      });
    });

    group('Widget Categories', () {
      test('should categorize layout widgets correctly', () {
        final layoutWidgets = WidgetTypes.categories['layout']!;
        expect(layoutWidgets.length, equals(20));
        expect(layoutWidgets, contains('column'));
        expect(layoutWidgets, contains('row'));
        expect(layoutWidgets, contains('container'));
        expect(layoutWidgets, contains('conditional'));
      });

      test('should categorize display widgets correctly', () {
        final displayWidgets = WidgetTypes.categories['display']!;
        expect(displayWidgets.length, equals(16));
        expect(displayWidgets, contains('text'));
        expect(displayWidgets, contains('image'));
        expect(displayWidgets, contains('badge'));
        expect(displayWidgets, contains('decoration'));
      });

      test('should categorize input widgets correctly', () {
        final inputWidgets = WidgetTypes.categories['input']!;
        expect(inputWidgets.length, equals(20));
        expect(inputWidgets, contains('button'));
        expect(inputWidgets, contains('textfield'));
        // New widgets
        expect(inputWidgets, contains('numberfield'));
        expect(inputWidgets, contains('colorpicker'));
        expect(inputWidgets, contains('radiogroup'));
        expect(inputWidgets, contains('checkboxgroup'));
        expect(inputWidgets, contains('segmentedcontrol'));
        expect(inputWidgets, contains('datefield'));
        expect(inputWidgets, contains('timefield'));
        expect(inputWidgets, contains('daterangepicker'));
      });

      test('should categorize list widgets correctly', () {
        final listWidgets = WidgetTypes.categories['list']!;
        expect(listWidgets.length, equals(3));
        expect(listWidgets, contains('listview'));
        expect(listWidgets, contains('gridview'));
        expect(listWidgets, contains('listtile'));
      });

      test('should categorize navigation widgets correctly', () {
        final navWidgets = WidgetTypes.categories['navigation']!;
        expect(navWidgets.length, equals(7));
        expect(navWidgets, contains('appbar'));
        expect(navWidgets, contains('drawer'));
        expect(navWidgets, contains('floatingactionbutton'));
      });

      test('should categorize scroll widgets correctly', () {
        final scrollWidgets = WidgetTypes.categories['scroll']!;
        expect(scrollWidgets.length, equals(3));
        expect(scrollWidgets, contains('singlechildscrollview'));
        expect(scrollWidgets, contains('scrollbar'));
        expect(scrollWidgets, contains('scrollview'));
      });

      test('should categorize animation widgets correctly', () {
        final animationWidgets = WidgetTypes.categories['animation']!;
        expect(animationWidgets.length, equals(1));
        expect(animationWidgets, contains('animatedcontainer'));
      });

      test('should categorize interactive widgets correctly', () {
        final interactiveWidgets = WidgetTypes.categories['interactive']!;
        expect(interactiveWidgets.length, equals(4));
        expect(interactiveWidgets, contains('gesturedetector'));
        expect(interactiveWidgets, contains('inkwell'));
        expect(interactiveWidgets, contains('draggable'));
        expect(interactiveWidgets, contains('dragtarget'));
      });

      test('should categorize dialog widgets correctly', () {
        final dialogWidgets = WidgetTypes.categories['dialog']!;
        expect(dialogWidgets.length, equals(3));
        expect(dialogWidgets, contains('alertdialog'));
        expect(dialogWidgets, contains('snackbar'));
        expect(dialogWidgets, contains('bottomsheet'));
      });
    });

    group('Widget Type Methods', () {
      test('allTypes should return all widget types', () {
        final allTypes = WidgetTypes.allTypes;
        expect(allTypes.length, equals(77)); // Total count of all widgets
        expect(allTypes, contains('column'));
        expect(allTypes, contains('button'));
        expect(allTypes, contains('listview'));
        expect(allTypes, contains('numberfield'));
        expect(allTypes, contains('daterangepicker'));
      });

      test('getCategoryForType should return correct category', () {
        expect(WidgetTypes.getCategoryForType('column'), equals('layout'));
        expect(WidgetTypes.getCategoryForType('text'), equals('display'));
        expect(WidgetTypes.getCategoryForType('button'), equals('input'));
        expect(WidgetTypes.getCategoryForType('numberfield'), equals('input'));
        expect(WidgetTypes.getCategoryForType('colorpicker'), equals('input'));
        expect(WidgetTypes.getCategoryForType('listview'), equals('list'));
        expect(WidgetTypes.getCategoryForType('appbar'), equals('navigation'));
        expect(WidgetTypes.getCategoryForType('scrollview'), equals('scroll'));
        expect(WidgetTypes.getCategoryForType('animatedcontainer'), equals('animation'));
        expect(WidgetTypes.getCategoryForType('draggable'), equals('interactive'));
        expect(WidgetTypes.getCategoryForType('alertdialog'), equals('dialog'));
        expect(WidgetTypes.getCategoryForType('unknown'), isNull);
      });

      test('isValidType should validate widget types', () {
        // Valid types
        expect(WidgetTypes.isValidType('column'), isTrue);
        expect(WidgetTypes.isValidType('text'), isTrue);
        expect(WidgetTypes.isValidType('button'), isTrue);
        expect(WidgetTypes.isValidType('numberfield'), isTrue);
        expect(WidgetTypes.isValidType('colorpicker'), isTrue);
        expect(WidgetTypes.isValidType('radiogroup'), isTrue);
        expect(WidgetTypes.isValidType('checkboxgroup'), isTrue);
        expect(WidgetTypes.isValidType('segmentedcontrol'), isTrue);
        expect(WidgetTypes.isValidType('datefield'), isTrue);
        expect(WidgetTypes.isValidType('timefield'), isTrue);
        expect(WidgetTypes.isValidType('daterangepicker'), isTrue);
        expect(WidgetTypes.isValidType('scrollview'), isTrue);
        expect(WidgetTypes.isValidType('draggable'), isTrue);
        expect(WidgetTypes.isValidType('dragtarget'), isTrue);
        expect(WidgetTypes.isValidType('conditional'), isTrue);
        
        // Invalid types
        expect(WidgetTypes.isValidType('invalid'), isFalse);
        expect(WidgetTypes.isValidType('unknown'), isFalse);
        expect(WidgetTypes.isValidType(''), isFalse);
      });

      test('getTypesByCategory should return correct widget types', () {
        expect(WidgetTypes.getTypesByCategory('layout'), 
            equals(WidgetTypes.categories['layout']));
        expect(WidgetTypes.getTypesByCategory('display'), 
            equals(WidgetTypes.categories['display']));
        expect(WidgetTypes.getTypesByCategory('input'), 
            equals(WidgetTypes.categories['input']));
        expect(WidgetTypes.getTypesByCategory('unknown'), equals([]));
      });
    });

    group('Widget Count Verification', () {
      test('should have correct total widget count', () {
        int totalCount = 0;
        for (final category in WidgetTypes.categories.values) {
          totalCount += category.length;
        }
        expect(totalCount, equals(77));
        expect(WidgetTypes.allTypes.length, equals(totalCount));
      });

      test('should have no duplicate widget types', () {
        final allTypes = WidgetTypes.allTypes;
        final uniqueTypes = allTypes.toSet();
        expect(uniqueTypes.length, equals(allTypes.length));
      });

      test('every widget type should belong to exactly one category', () {
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