import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

/// Comprehensive test suite that validates EVERY aspect of MCP UI DSL v1.0 specification
/// This ensures 100% spec compliance
void main() {
  group('MCP UI DSL v1.0 Specification Compliance Tests', () {
    group('1. Application Structure (Section 1.1)', () {
      test('Application with all required fields only', () {
        final app = {
          "type": "application",
          "title": "My MCP Application",
          "version": "1.0.0",
          "routes": {
            "/": "ui://pages/home"
          }
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue, reason: 'Minimal valid application must pass');
        expect(result.errors, isEmpty);
      });
      
      test('Application with initialRoute', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "initialRoute": "/dashboard",
          "routes": {
            "/dashboard": "ui://pages/dashboard",
            "/home": "ui://pages/home"
          }
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue);
      });
      
      test('Application with complete theme', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "theme": {
            "mode": "light",
            "colors": {
              "primary": "#2196F3",
              "secondary": "#FFFF4081",    // 8-digit
              "background": "#FFFFFFFF",   // 8-digit
              "surface": "#F5F5F5",        // 6-digit
              "error": "#F44336",
              "textOnPrimary": "#FFFFFF",
              "textOnSecondary": "#FF000000",
              "textOnBackground": "#000000",
              "textOnSurface": "#000000",
              "textOnError": "#FFFFFF",
              "onPrimary": "#FFFFFF",
              "onSecondary": "#000000",
              "onBackground": "#000000",
              "onSurface": "#000000",
              "onError": "#FFFFFF"
            },
            "typography": {
              "h1": {"fontSize": 32, "fontWeight": "bold", "letterSpacing": -1.5},
              "h2": {"fontSize": 28, "fontWeight": "bold", "letterSpacing": -0.5},
              "h3": {"fontSize": 24, "fontWeight": "bold", "letterSpacing": 0},
              "h4": {"fontSize": 20, "fontWeight": "bold", "letterSpacing": 0.25},
              "h5": {"fontSize": 18, "fontWeight": "bold", "letterSpacing": 0},
              "h6": {"fontSize": 16, "fontWeight": "bold", "letterSpacing": 0.15},
              "body1": {"fontSize": 16, "fontWeight": "normal", "letterSpacing": 0.5},
              "body2": {"fontSize": 14, "fontWeight": "normal", "letterSpacing": 0.25},
              "caption": {"fontSize": 12, "fontWeight": "normal", "letterSpacing": 0.4},
              "button": {"fontSize": 14, "fontWeight": "medium", "letterSpacing": 1.25, "textTransform": "uppercase"}
            },
            "spacing": {
              "xs": 4, "sm": 8, "md": 16, "lg": 24, "xl": 32, "xxl": 48
            },
            "borderRadius": {
              "sm": 4, "md": 8, "lg": 16, "xl": 24, "round": 9999
            },
            "elevation": {
              "none": 0, "sm": 2, "md": 4, "lg": 8, "xl": 16
            }
          },
          "routes": {
            "/": "ui://pages/home"
          }
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });
      
      test('Application with state.initial', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "state": {
            "initial": {
              "user": {
                "name": "Guest",
                "isAuthenticated": false
              },
              "themeMode": "light",
              "language": "en"
            }
          },
          "routes": {
            "/": "ui://pages/home"
          }
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue);
      });
      
      test('Application with navigation.drawer', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "initialRoute": "/dashboard",
          "navigation": {
            "type": "drawer",
            "items": [
              {"title": "Dashboard", "route": "/dashboard", "icon": "dashboard"},
              {"title": "Settings", "route": "/settings", "icon": "settings"},
              {"title": "Profile", "route": "/profile", "icon": "person"}
            ]
          },
          "routes": {
            "/dashboard": "ui://pages/dashboard",
            "/settings": "ui://pages/settings",
            "/profile": "ui://pages/profile"
          }
        };
        
        final result = UIValidator.validateJson(app);
        if (!result.isValid) {
          print('Navigation drawer validation errors:');
          for (final error in result.errors) {
            print('  - ${error.message} (${error.path})');
          }
        }
        expect(result.isValid, isTrue);
      });
      
      test('Application with navigation.tabs', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "navigation": {
            "type": "tabs",
            "items": [
              {"title": "Home", "route": "/home"},
              {"title": "Search", "route": "/search"}
            ]
          },
          "initialRoute": "/home",
          "routes": {
            "/home": "ui://pages/home",
            "/search": "ui://pages/search"
          }
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue);
      });
      
      test('Application with navigation.bottom', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "navigation": {
            "type": "bottom",
            "items": [
              {"title": "Home", "route": "/", "icon": "home"},
              {"title": "Profile", "route": "/profile", "icon": "person"}
            ]
          },
          "routes": {
            "/": "ui://pages/home",
            "/profile": "ui://pages/profile"
          }
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue);
      });
      
      test('Application with route parameters', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "routes": {
            "/": "ui://pages/home",
            "/users/:id": "ui://pages/user-detail",
            "/posts/:postId/comments/:commentId": "ui://pages/comment-detail"
          }
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue);
      });
      
      test('Application without required title fails', () {
        final app = {
          "type": "application",
          "version": "1.0.0",
          "routes": {"/": "ui://pages/home"}
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.path == 'title'), isTrue);
      });
      
      test('Application without required version fails', () {
        final app = {
          "type": "application",
          "title": "My App",
          "routes": {"/": "ui://pages/home"}
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.path == 'version'), isTrue);
      });
      
      test('Application without required routes fails', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0"
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.path == 'routes'), isTrue);
      });
      
      test('Application with empty routes fails', () {
        final app = {
          "type": "application",
          "title": "My App",
          "version": "1.0.0",
          "routes": {}
        };
        
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.path == 'routes'), isTrue);
      });
    });
    
    group('2. Page Structure (Section 1.2)', () {
      test('Page with minimal required fields', () {
        final page = {
          "type": "page",
          "content": {
            "type": "text",
            "content": "Hello World"
          }
        };
        
        final result = UIValidator.validateJson(page);
        expect(result.isValid, isTrue);
      });
      
      test('Page with title and route', () {
        final page = {
          "type": "page",
          "title": "Dashboard",
          "route": "/dashboard",
          "content": {
            "type": "linear",
            "direction": "vertical",
            "children": []
          }
        };
        
        final result = UIValidator.validateJson(page);
        expect(result.isValid, isTrue);
      });
      
      test('Page with themeOverride', () {
        final page = {
          "type": "page",
          "themeOverride": {
            "colors": {
              "primary": "#4CAF50"
            }
          },
          "content": {
            "type": "text",
            "content": "Themed page"
          }
        };
        
        final result = UIValidator.validateJson(page);
        expect(result.isValid, isTrue);
      });
      
      test('Page without required content fails', () {
        final page = {
          "type": "page",
          "title": "Invalid Page"
        };
        
        final result = UIValidator.validateJson(page);
        expect(result.isValid, isFalse);
      });
    });
    
    group('3. Theme System (Section 1.3)', () {
      test('Theme mode: light', () {
        final theme = {
          "mode": "light",
          "colors": _getCompleteColors()
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('Theme mode: dark', () {
        final theme = {
          "mode": "dark",
          "colors": _getCompleteColors()
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('Theme mode: system', () {
        final theme = {
          "mode": "system",
          "colors": _getCompleteColors()
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('Invalid theme mode fails', () {
        final theme = {
          "mode": "invalid",
          "colors": _getCompleteColors()
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.any((e) => e.message.contains('light, dark, system')), isTrue);
      });
      
      test('6-digit color format', () {
        final theme = {
          "colors": {
            "primary": "#2196F3",
            "secondary": "#FF4081",
            "background": "#FFFFFF",
            "surface": "#F5F5F5",
            "error": "#F44336",
            "textOnPrimary": "#FFFFFF",
            "textOnSecondary": "#000000",
            "textOnBackground": "#000000",
            "textOnSurface": "#000000",
            "textOnError": "#FFFFFF"
          }
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('8-digit color format', () {
        final theme = {
          "colors": {
            "primary": "#FF2196F3",
            "secondary": "#FFFF4081",
            "background": "#FFFFFFFF",
            "surface": "#FFF5F5F5",
            "error": "#FFF44336",
            "textOnPrimary": "#FFFFFFFF",
            "textOnSecondary": "#FF000000",
            "textOnBackground": "#FF000000",
            "textOnSurface": "#FF000000",
            "textOnError": "#FFFFFFFF"
          }
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('Semi-transparent colors (8-digit)', () {
        final theme = {
          "colors": {
            "primary": "#802196F3",      // 50% opacity
            "secondary": "#CCFF4081",    // 80% opacity
            "background": "#00FFFFFF",   // Fully transparent
            "surface": "#FFF5F5F5",
            "error": "#FFF44336",
            "textOnPrimary": "#FFFFFFFF",
            "textOnSecondary": "#FF000000",
            "textOnBackground": "#FF000000",
            "textOnSurface": "#FF000000",
            "textOnError": "#FFFFFFFF"
          }
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('Invalid color format fails', () {
        final theme = {
          "colors": {
            "primary": "blue",           // Invalid
            "secondary": "#FF40",        // Too short
            "background": "#FFFFFFGG",   // Invalid hex
            "surface": "rgb(245,245,245)", // Wrong format
            "error": "#F44336",
            "textOnPrimary": "#FFFFFF",
            "textOnSecondary": "#000000",
            "textOnBackground": "#000000",
            "textOnSurface": "#000000",
            "textOnError": "#FFFFFF"
          }
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.length, greaterThan(0));
      });
      
      test('Separate light/dark themes', () {
        final theme = {
          "mode": "system",
          "light": {
            "colors": _getCompleteColors()
          },
          "dark": {
            "colors": _getDarkColors()
          }
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('Typography validation', () {
        final theme = {
          "typography": {
            "h1": {"fontSize": 32, "fontWeight": "bold", "letterSpacing": -1.5},
            "h2": {"fontSize": 28, "fontWeight": "bold", "letterSpacing": -0.5},
            "h3": {"fontSize": 24, "fontWeight": "bold", "letterSpacing": 0},
            "h4": {"fontSize": 20, "fontWeight": "bold", "letterSpacing": 0.25},
            "h5": {"fontSize": 18, "fontWeight": "bold", "letterSpacing": 0},
            "h6": {"fontSize": 16, "fontWeight": "bold", "letterSpacing": 0.15},
            "body1": {"fontSize": 16, "fontWeight": "normal", "letterSpacing": 0.5},
            "body2": {"fontSize": 14, "fontWeight": "normal", "letterSpacing": 0.25},
            "caption": {"fontSize": 12, "fontWeight": "normal", "letterSpacing": 0.4},
            "button": {"fontSize": 14, "fontWeight": "medium", "letterSpacing": 1.25, "textTransform": "uppercase"}
          }
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.isValid, isTrue);
      });
      
      test('Invalid typography fails', () {
        final theme = {
          "typography": {
            "h1": {"fontSize": "large"},  // Should be number
            "body1": {"fontWeight": "extra-bold"}  // Invalid weight
          }
        };
        
        final result = UIValidator.validateTheme(theme);
        expect(result.errors.length, greaterThan(0));
      });
    });
    
    group('4. Widget Catalog - Layout Widgets', () {
      test('linear widget', () {
        final widget = {
          "type": "linear",
          "direction": "vertical",
          "alignment": "center",
          "distribution": "space-between",
          "gap": 16,
          "children": []
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('stack widget', () {
        final widget = {
          "type": "stack",
          "alignment": "center",
          "fit": "expand",
          "children": []
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('box widget', () {
        final widget = {
          "type": "box",
          "width": 200,
          "height": 100,
          "padding": {"all": 16},
          "margin": {"vertical": 8, "horizontal": 16},
          "decoration": {
            "color": "#F5F5F5",
            "borderRadius": 8,
            "border": {
              "color": "#E0E0E0",
              "width": 1
            }
          },
          "child": {
            "type": "text",
            "content": "Box content"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('center widget', () {
        final widget = {
          "type": "center",
          "child": {
            "type": "text",
            "content": "Centered"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('padding widget', () {
        final widget = {
          "type": "padding",
          "padding": {"all": 16},
          "child": {
            "type": "text",
            "content": "Padded"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('sizedBox widget', () {
        final widget = {
          "type": "sizedBox",
          "width": 100,
          "height": 50
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('expanded widget', () {
        final widget = {
          "type": "expanded",
          "flex": 2,
          "child": {
            "type": "text",
            "content": "Expanded"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('flexible widget', () {
        final widget = {
          "type": "flexible",
          "flex": 1,
          "fit": "loose",
          "child": {
            "type": "text",
            "content": "Flexible"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('conditional widget', () {
        final widget = {
          "type": "conditional",
          "condition": "{{isLoggedIn}}",
          "then": {
            "type": "text",
            "content": "Welcome back!"
          },
          "else": {
            "type": "text",
            "content": "Please log in"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
    });
    
    group('5. Widget Catalog - Display Widgets', () {
      test('text widget', () {
        final widget = {
          "type": "text",
          "content": "Hello World",
          "style": {
            "fontSize": 16,
            "fontWeight": "bold",
            "color": "#000000",
            "textAlign": "center"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('richText widget', () {
        final widget = {
          "type": "richText",
          "spans": [
            {"text": "Hello ", "style": {"fontWeight": "normal"}},
            {"text": "World", "style": {"fontWeight": "bold", "color": "#2196F3"}}
          ]
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('image widget', () {
        final widget = {
          "type": "image",
          "src": "https://example.com/image.png",
          "width": 200,
          "height": 150,
          "fit": "cover"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('icon widget', () {
        final widget = {
          "type": "icon",
          "icon": "home",
          "size": 24,
          "color": "#2196F3"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('card widget', () {
        final widget = {
          "type": "card",
          "elevation": 4,
          "shape": "rounded",
          "child": {
            "type": "padding",
            "padding": {"all": 16},
            "child": {
              "type": "text",
              "content": "Card content"
            }
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('badge widget', () {
        final widget = {
          "type": "badge",
          "count": 5,
          "color": "#F44336"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('loadingIndicator widget', () {
        final widget = {
          "type": "loadingIndicator",
          "indicatorType": "circular",
          "size": 48
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('divider widget', () {
        final widget = {
          "type": "divider",
          "thickness": 1,
          "color": "#E0E0E0"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
    });
    
    group('6. Widget Catalog - Input Widgets', () {
      test('button widget', () {
        final widget = {
          "type": "button",
          "label": "Click Me",
          "style": "elevated",
          "disabled": false,
          "click": {
            "type": "tool",
            "tool": "submitForm"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('textInput widget', () {
        final widget = {
          "type": "textInput",
          "label": "Email",
          "placeholder": "Enter your email",
          "value": "{{email}}",
          "keyboardType": "email",
          "maxLength": 100,
          "change": {
            "type": "state",
            "action": "set",
            "binding": "email",
            "value": "{{event.value}}"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('select widget', () {
        final widget = {
          "type": "select",
          "label": "Country",
          "options": [
            {"label": "United States", "value": "US"},
            {"label": "Canada", "value": "CA"},
            {"label": "Mexico", "value": "MX"}
          ],
          "value": "{{selectedCountry}}",
          "change": {
            "type": "state",
            "action": "set",
            "binding": "selectedCountry",
            "value": "{{event.value}}"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('toggle widget', () {
        final widget = {
          "type": "toggle",
          "label": "Enable notifications",
          "value": "{{notificationsEnabled}}",
          "change": {
            "type": "state",
            "action": "set",
            "binding": "notificationsEnabled",
            "value": "{{event.value}}"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('slider widget', () {
        final widget = {
          "type": "slider",
          "min": 0,
          "max": 100,
          "value": "{{volume}}",
          "divisions": 10,
          "change": {
            "type": "state",
            "action": "set",
            "binding": "volume",
            "value": "{{event.value}}"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('checkbox widget', () {
        final widget = {
          "type": "checkbox",
          "label": "I agree to terms",
          "value": "{{agreedToTerms}}",
          "change": {
            "type": "state",
            "action": "set",
            "binding": "agreedToTerms",
            "value": "{{event.value}}"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('radio widget', () {
        final widget = {
          "type": "radio",
          "label": "Option A",
          "value": "a",
          "groupValue": "{{selectedOption}}",
          "change": {
            "type": "state",
            "action": "set",
            "binding": "selectedOption",
            "value": "{{event.value}}"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('numberField widget', () {
        final widget = {
          "type": "numberField",
          "label": "Age",
          "value": "{{age}}",
          "min": 0,
          "max": 150,
          "step": 1,
          "format": "integer"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('colorPicker widget', () {
        final widget = {
          "type": "colorPicker",
          "value": "{{selectedColor}}",
          "showAlpha": true
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('dateField widget', () {
        final widget = {
          "type": "dateField",
          "label": "Birth Date",
          "value": "{{birthDate}}",
          "format": "yyyy-MM-dd",
          "firstDate": "1900-01-01",
          "lastDate": "2024-12-31"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('timeField widget', () {
        final widget = {
          "type": "timeField",
          "label": "Appointment Time",
          "value": "{{appointmentTime}}",
          "format": "HH:mm",
          "use24HourFormat": true
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('radioGroup widget', () {
        final widget = {
          "type": "radioGroup",
          "label": "Select Size",
          "value": "{{size}}",
          "options": [
            {"label": "Small", "value": "S"},
            {"label": "Medium", "value": "M"},
            {"label": "Large", "value": "L"}
          ],
          "orientation": "horizontal"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('checkboxGroup widget', () {
        final widget = {
          "type": "checkboxGroup",
          "label": "Select Toppings",
          "value": "{{selectedToppings}}",
          "options": [
            {"label": "Cheese", "value": "cheese"},
            {"label": "Pepperoni", "value": "pepperoni"},
            {"label": "Mushrooms", "value": "mushrooms"}
          ],
          "orientation": "vertical"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
    });
    
    group('7. Widget Catalog - Navigation Widgets', () {
      test('headerBar widget', () {
        final widget = {
          "type": "headerBar",
          "title": "My App",
          "actions": [
            {
              "type": "iconButton",
              "icon": "search",
              "click": {"type": "navigation", "action": "push", "route": "/search"}
            }
          ]
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('bottomNavigation widget', () {
        final widget = {
          "type": "bottomNavigation",
          "items": [
            {"icon": "home", "label": "Home"},
            {"icon": "search", "label": "Search"},
            {"icon": "person", "label": "Profile"}
          ],
          "currentIndex": 0
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('drawer widget', () {
        final widget = {
          "type": "drawer",
          "items": [
            {"title": "Home", "icon": "home", "route": "/"},
            {"title": "Settings", "icon": "settings", "route": "/settings"}
          ]
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('tabBar widget', () {
        final widget = {
          "type": "tabBar",
          "tabs": [
            {"label": "Tab 1"},
            {"label": "Tab 2"},
            {"label": "Tab 3"}
          ],
          "controller": "{{tabController}}"
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
    });
    
    group('8. Widget Catalog - List Widgets', () {
      test('list widget', () {
        final widget = {
          "type": "list",
          "items": "{{users}}",
          "itemTemplate": {
            "type": "listTile",
            "title": "{{item.name}}",
            "subtitle": "{{item.email}}"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('grid widget', () {
        final widget = {
          "type": "grid",
          "columns": 2,
          "items": "{{products}}",
          "itemTemplate": {
            "type": "card",
            "child": {
              "type": "text",
              "content": "{{item.name}}"
            }
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('listTile widget', () {
        final widget = {
          "type": "listTile",
          "title": "Title",
          "subtitle": "Subtitle",
          "leading": {
            "type": "icon",
            "icon": "folder"
          },
          "trailing": {
            "type": "icon",
            "icon": "arrow_forward"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
    });
    
    group('9. Widget Catalog - Advanced Widgets', () {
      test('scrollView widget', () {
        final widget = {
          "type": "scrollView",
          "direction": "vertical",
          "child": {
            "type": "linear",
            "direction": "vertical",
            "children": []
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('chart widget', () {
        final widget = {
          "type": "chart",
          "chartType": "line",
          "data": {
            "labels": ["Jan", "Feb", "Mar"],
            "datasets": [
              {
                "label": "Sales",
                "data": [100, 150, 200]
              }
            ]
          },
          "options": {
            "responsive": true
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('map widget', () {
        final widget = {
          "type": "map",
          "center": {"lat": 37.7749, "lng": -122.4194},
          "zoom": 12,
          "markers": [
            {"position": {"lat": 37.7749, "lng": -122.4194}, "title": "San Francisco"}
          ]
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('mediaPlayer widget', () {
        final widget = {
          "type": "mediaPlayer",
          "source": "https://example.com/video.mp4",
          "controls": true
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('draggable widget', () {
        final widget = {
          "type": "draggable",
          "data": {"id": "item1"},
          "feedback": {
            "type": "text",
            "content": "Dragging..."
          },
          "child": {
            "type": "text",
            "content": "Drag me"
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('dragTarget widget', () {
        final widget = {
          "type": "dragTarget",
          "drop": {
            "type": "state",
            "action": "append",
            "binding": "droppedItems",
            "value": "{{event.data}}"
          },
          "builder": {
            "type": "box",
            "padding": {"all": 16},
            "decoration": {
              "border": {"color": "#E0E0E0", "width": 2, "style": "dashed"}
            },
            "child": {
              "type": "text",
              "content": "Drop here"
            }
          }
        };
        
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
    });
    
    group('10. Actions', () {
      test('state action - set', () {
        final action = {
          "type": "state",
          "action": "set",
          "binding": "counter",
          "value": 10
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('state action - increment', () {
        final action = {
          "type": "state",
          "action": "increment",
          "binding": "counter",
          "value": 1
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('state action - decrement', () {
        final action = {
          "type": "state",
          "action": "decrement",
          "binding": "counter",
          "value": 1
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('state action - toggle', () {
        final action = {
          "type": "state",
          "action": "toggle",
          "binding": "isEnabled"
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('state action - append', () {
        final action = {
          "type": "state",
          "action": "append",
          "binding": "items",
          "value": {"id": 1, "name": "New Item"}
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('state action - remove', () {
        final action = {
          "type": "state",
          "action": "remove",
          "binding": "items",
          "value": 0  // index
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('tool action', () {
        final action = {
          "type": "tool",
          "tool": "saveData",
          "params": {
            "data": "{{formData}}"
          },
          "onSuccess": {
            "type": "notification",
            "message": "Saved successfully!"
          },
          "onError": {
            "type": "notification",
            "message": "Error: {{event.message}}"
          }
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('navigation action - push', () {
        final action = {
          "type": "navigation",
          "action": "push",
          "route": "/detail",
          "params": {
            "id": "{{item.id}}"
          }
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('navigation action - replace', () {
        final action = {
          "type": "navigation",
          "action": "replace",
          "route": "/home"
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('navigation action - pop', () {
        final action = {
          "type": "navigation",
          "action": "pop"
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('navigation action - popToRoot', () {
        final action = {
          "type": "navigation",
          "action": "popToRoot"
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('resource action - subscribe', () {
        final action = {
          "type": "resource",
          "action": "subscribe",
          "uri": "ui://sensors/temperature",
          "binding": "temperature"
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('resource action - unsubscribe', () {
        final action = {
          "type": "resource",
          "action": "unsubscribe",
          "uri": "ui://sensors/temperature"
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('batch action', () {
        final action = {
          "type": "batch",
          "actions": [
            {"type": "state", "action": "set", "binding": "loading", "value": true},
            {"type": "tool", "tool": "fetchData"},
            {"type": "state", "action": "set", "binding": "loading", "value": false}
          ]
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
      
      test('conditional action', () {
        final action = {
          "type": "conditional",
          "condition": "{{isValid}}",
          "then": {"type": "tool", "tool": "submit"},
          "else": {"type": "notification", "message": "Please check your input"}
        };
        
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isTrue);
      });
    });
    
    group('11. Bindings', () {
      test('simple binding', () {
        final binding = "{{username}}";
        final result = BindingConfig.fromExpression(binding);
        expect(result.isValidExpression, isTrue);
        expect(result.path, equals('username'));
      });
      
      test('nested binding', () {
        final binding = "{{user.profile.name}}";
        final result = BindingConfig.fromExpression(binding);
        expect(result.isValidExpression, isTrue);
        expect(result.path, equals('user.profile.name'));
      });
      
      test('array binding', () {
        final binding = "{{items[0]}}";
        final result = BindingConfig.fromExpression(binding);
        expect(result.isValidExpression, isTrue);
      });
      
      test('complex array binding', () {
        final binding = "{{users[2].addresses[0].city}}";
        final result = BindingConfig.fromExpression(binding);
        expect(result.isValidExpression, isTrue);
      });
      
      test('theme binding', () {
        final binding = "{{theme.colors.primary}}";
        final result = BindingConfig.fromExpression(binding);
        expect(result.isValidExpression, isTrue);
      });
      
      test('event binding', () {
        final binding = "{{event.value}}";
        final result = BindingConfig.fromExpression(binding);
        expect(result.isValidExpression, isTrue);
      });
      
      test('ternary expression', () {
        final binding = "{{isLoggedIn ? 'Welcome' : 'Please login'}}";
        final result = BindingConfig.fromExpression(binding);
        expect(result.isValidExpression, isTrue);
      });
    });
    
    group('12. Edge Cases and Error Handling', () {
      test('Empty JSON object fails', () {
        final Map<String, dynamic> json = {};
        final result = UIValidator.validateJson(json);
        expect(result.isValid, isFalse);
      });
      
      test('JSON without type field fails', () {
        final json = {
          "title": "No Type",
          "content": {"type": "text", "content": "Hello"}
        };
        final result = UIValidator.validateJson(json);
        expect(result.isValid, isFalse);
      });
      
      test('Unknown type fails', () {
        final json = {
          "type": "unknown_type",
          "data": "test"
        };
        final result = UIValidator.validateJson(json);
        expect(result.isValid, isFalse);
      });
      
      test('Invalid widget type in content fails', () {
        final page = {
          "type": "page",
          "content": {
            "type": "invalid_widget",
            "data": "test"
          }
        };
        final result = UIValidator.validateJson(page);
        expect(result.isValid, isFalse);
      });
      
      test('Missing required action fields fails', () {
        final action = {
          "type": "state"
          // Missing action and binding
        };
        final result = UIValidator.validateAction(ActionConfig.fromJson(action));
        expect(result.isValid, isFalse);
      });
      
      test('Invalid navigation type fails', () {
        final app = {
          "type": "application",
          "title": "App",
          "version": "1.0.0",
          "navigation": {
            "type": "invalid_nav_type",
            "items": []
          },
          "routes": {"/": "ui://pages/home"}
        };
        final result = UIValidator.validateJson(app);
        expect(result.errors.any((e) => e.message.contains('drawer, tabs, bottom')), isTrue);
      });
    });
    
    group('13. Non-existent widgets should fail', () {
      test('column is not a valid widget', () {
        final widget = {"type": "column", "children": []};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
      
      test('row is not a valid widget', () {
        final widget = {"type": "row", "children": []};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
      
      test('container is a valid widget (legacy alias for box)', () {
        final widget = {"type": "container", "child": {"type": "text", "content": "Hello"}};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isTrue);
      });
      
      test('textfield is not a valid widget', () {
        final widget = {"type": "textfield", "label": "Input"};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
      
      test('scaffold is not a valid widget', () {
        final widget = {"type": "scaffold", "body": {"type": "text", "content": "Hello"}};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
      
      test('appbar is not a valid widget', () {
        final widget = {"type": "appbar", "title": "App"};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
      
      test('listview is not a valid widget', () {
        final widget = {"type": "listview", "children": []};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
      
      test('gridview is not a valid widget', () {
        final widget = {"type": "gridview", "children": []};
        final result = UIValidator.validateJson(widget);
        expect(result.isValid, isFalse);
        expect(result.errors.any((e) => e.message.contains('Unknown widget type')), isTrue);
      });
    });
    
    group('14. Field does not exist in spec', () {
      test('layout field does not exist', () {
        final json = {
          "layout": {
            "type": "linear",
            "children": []
          }
        };
        // This should fail because 'layout' is not a valid top-level structure
        final result = UIValidator.validateJson(json);
        expect(result.isValid, isFalse);
      });
      
      test('dslVersion field does not exist', () {
        final app = {
          "type": "application",
          "title": "App",
          "version": "1.0.0",
          "dslVersion": "1.0",  // This field doesn't exist in spec
          "routes": {"/": "ui://pages/home"}
        };
        // Should still be valid but might have warning
        final result = UIValidator.validateJson(app);
        expect(result.isValid, isTrue);  // Extra fields don't invalidate
      });
    });
  });
}

Map<String, dynamic> _getCompleteColors() {
  return {
    "primary": "#2196F3",
    "secondary": "#FF4081",
    "background": "#FFFFFF",
    "surface": "#F5F5F5",
    "error": "#F44336",
    "textOnPrimary": "#FFFFFF",
    "textOnSecondary": "#000000",
    "textOnBackground": "#000000",
    "textOnSurface": "#000000",
    "textOnError": "#FFFFFF"
  };
}

Map<String, dynamic> _getDarkColors() {
  return {
    "primary": "#1976D2",
    "secondary": "#FF4081",
    "background": "#121212",
    "surface": "#1E1E1E",
    "error": "#CF6679",
    "textOnPrimary": "#FFFFFF",
    "textOnSecondary": "#000000",
    "textOnBackground": "#FFFFFF",
    "textOnSurface": "#FFFFFF",
    "textOnError": "#000000"
  };
}