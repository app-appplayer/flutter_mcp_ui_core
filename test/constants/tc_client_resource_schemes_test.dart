// TC-080: ClientResourceSchemes Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-080: ClientResourceSchemes constants (v1.1)
  // =========================================================================
  group('TC-080: ClientResourceSchemes constants', () {
    test('Normal: all 5 scheme constants defined', () {
      expect(ClientResourceSchemes.protocol, equals('client://'));
      expect(ClientResourceSchemes.file, equals('client://file'));
      expect(ClientResourceSchemes.workspace, equals('client://workspace'));
      expect(ClientResourceSchemes.temp, equals('client://temp'));
      expect(ClientResourceSchemes.cache, equals('client://cache'));
    });

    test('Boundary: scheme values do NOT include trailing slashes', () {
      expect(ClientResourceSchemes.file.endsWith('/'), isFalse);
      expect(ClientResourceSchemes.workspace.endsWith('/'), isFalse);
      expect(ClientResourceSchemes.temp.endsWith('/'), isFalse);
      expect(ClientResourceSchemes.cache.endsWith('/'), isFalse);
    });

    test('Boundary: allSchemes list contains all 4 non-protocol schemes', () {
      expect(ClientResourceSchemes.allSchemes, hasLength(4));
      expect(ClientResourceSchemes.allSchemes, contains(ClientResourceSchemes.file));
      expect(ClientResourceSchemes.allSchemes, contains(ClientResourceSchemes.workspace));
      expect(ClientResourceSchemes.allSchemes, contains(ClientResourceSchemes.temp));
      expect(ClientResourceSchemes.allSchemes, contains(ClientResourceSchemes.cache));
    });

    test('Normal: isClientUri detects client URIs', () {
      expect(ClientResourceSchemes.isClientUri('client://file/path.txt'), isTrue);
      expect(ClientResourceSchemes.isClientUri('https://example.com'), isFalse);
    });

    test('Normal: getScheme returns correct scheme', () {
      expect(ClientResourceSchemes.getScheme('client://file/path.txt'),
          equals('client://file'));
      expect(ClientResourceSchemes.getScheme('client://workspace/src/main.dart'),
          equals('client://workspace'));
      expect(ClientResourceSchemes.getScheme('https://example.com'), isNull);
    });

    test('Normal: getPath extracts path component', () {
      expect(ClientResourceSchemes.getPath('client://file/path/to/file.txt'),
          equals('path/to/file.txt'));
      expect(ClientResourceSchemes.getPath('https://example.com'), isNull);
    });
  });
}
