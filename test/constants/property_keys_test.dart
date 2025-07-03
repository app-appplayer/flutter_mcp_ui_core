import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  group('PropertyKeys', () {
    group('Core Properties', () {
      test('should have core property keys', () {
        expect(PropertyKeys.type, equals('type'));
        expect(PropertyKeys.children, equals('children'));
      });
    });

    group('Layout Properties', () {
      test('should have modern layout property keys', () {
        // Modern properties
        expect(PropertyKeys.distribution, equals('distribution'));
        expect(PropertyKeys.alignment, equals('alignment'));
        expect(PropertyKeys.direction, equals('direction'));
        expect(PropertyKeys.gap, equals('gap'));
        expect(PropertyKeys.wrap, equals('wrap'));
        
        // Common properties
        expect(PropertyKeys.width, equals('width'));
        expect(PropertyKeys.height, equals('height'));
        expect(PropertyKeys.padding, equals('padding'));
        expect(PropertyKeys.margin, equals('margin'));
      });
      
      test('should have legacy Flutter layout properties for backward compatibility', () {
        expect(PropertyKeys.mainAxisAlignment, equals('mainAxisAlignment'));
        expect(PropertyKeys.crossAxisAlignment, equals('crossAxisAlignment'));
        expect(PropertyKeys.mainAxisSize, equals('mainAxisSize'));
      });
    });

    group('Content Properties', () {
      test('should have modern content property keys', () {
        // Modern content property
        expect(PropertyKeys.content, equals('content'));
        
        // Other content properties
        expect(PropertyKeys.text, equals('text'));
        expect(PropertyKeys.label, equals('label'));
        expect(PropertyKeys.title, equals('title'));
        expect(PropertyKeys.subtitle, equals('subtitle'));
        expect(PropertyKeys.value, equals('value'));
        expect(PropertyKeys.hint, equals('hint'));
        expect(PropertyKeys.hintText, equals('hintText'));
        expect(PropertyKeys.placeholder, equals('placeholder'));
      });
    });

    group('Interaction Properties', () {
      test('should have modern event property keys with CamelCase notation', () {
        // Modern event names - MCP UI DSL v1.0 spec uses CamelCase
        expect(PropertyKeys.click, equals('click'));
        expect(PropertyKeys.doubleClick, equals('doubleClick')); // CamelCase
        expect(PropertyKeys.rightClick, equals('rightClick')); // CamelCase
        expect(PropertyKeys.longPress, equals('longPress')); // CamelCase
        expect(PropertyKeys.change, equals('change'));
        expect(PropertyKeys.focus, equals('focus'));
        expect(PropertyKeys.blur, equals('blur'));
        expect(PropertyKeys.hover, equals('hover'));
        expect(PropertyKeys.submit, equals('submit'));
      });
      
      test('should have legacy Flutter event names for backward compatibility', () {
        expect(PropertyKeys.onTap, equals('onTap'));
        expect(PropertyKeys.onPressed, equals('onPressed'));
        expect(PropertyKeys.onChanged, equals('onChanged')); // Legacy compatibility
        expect(PropertyKeys.onSubmitted, equals('onSubmitted'));
      });
      
      test('should have other interaction properties', () {
        expect(PropertyKeys.enabled, equals('enabled'));
        expect(PropertyKeys.disabled, equals('disabled'));
      });
    });

    group('Style Properties', () {
      test('should have style property keys', () {
        expect(PropertyKeys.style, equals('style'));
        expect(PropertyKeys.color, equals('color'));
        expect(PropertyKeys.backgroundColor, equals('backgroundColor'));
        expect(PropertyKeys.foregroundColor, equals('foregroundColor'));
        expect(PropertyKeys.fontSize, equals('fontSize'));
        expect(PropertyKeys.fontWeight, equals('fontWeight'));
        expect(PropertyKeys.fontFamily, equals('fontFamily'));
        expect(PropertyKeys.textAlign, equals('textAlign'));
        expect(PropertyKeys.decoration, equals('decoration'));
        expect(PropertyKeys.border, equals('border'));
        expect(PropertyKeys.borderRadius, equals('borderRadius'));
        expect(PropertyKeys.shadow, equals('shadow'));
        expect(PropertyKeys.elevation, equals('elevation'));
      });
    });

    group('Form Properties', () {
      test('should have form property keys', () {
        expect(PropertyKeys.validator, equals('validator'));
        expect(PropertyKeys.required, equals('required'));
        expect(PropertyKeys.obscureText, equals('obscureText'));
        expect(PropertyKeys.keyboardType, equals('keyboardType'));
        expect(PropertyKeys.maxLength, equals('maxLength'));
        expect(PropertyKeys.maxLines, equals('maxLines'));
      });
    });

    group('List Properties', () {
      test('should have list property keys', () {
        expect(PropertyKeys.items, equals('items'));
        expect(PropertyKeys.itemTemplate, equals('itemTemplate'));
        expect(PropertyKeys.itemBuilder, equals('itemBuilder'));
        expect(PropertyKeys.itemCount, equals('itemCount'));
      });
    });

    group('State Properties', () {
      test('should have state property keys', () {
        expect(PropertyKeys.bindTo, equals('bindTo'));
        expect(PropertyKeys.selected, equals('selected'));
        expect(PropertyKeys.checked, equals('checked'));
        expect(PropertyKeys.visible, equals('visible'));
      });
    });

    group('Image Properties', () {
      test('should have image property keys', () {
        expect(PropertyKeys.src, equals('src'));
        expect(PropertyKeys.image, equals('image'));
        expect(PropertyKeys.fit, equals('fit'));
        expect(PropertyKeys.aspectRatio, equals('aspectRatio'));
      });
    });

    group('Icon Properties', () {
      test('should have icon property keys', () {
        expect(PropertyKeys.icon, equals('icon'));
        expect(PropertyKeys.iconSize, equals('iconSize'));
        expect(PropertyKeys.iconColor, equals('iconColor'));
      });
    });

  });
}