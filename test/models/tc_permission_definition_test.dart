// TC-074 ~ TC-077: PermissionDefinition Tests per core-models.md spec
import 'package:test/test.dart';
import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';

void main() {
  // =========================================================================
  // TC-074: PermissionDefinition.fromJson (v1.1)
  // =========================================================================
  group('TC-074: PermissionDefinition.fromJson', () {
    test('Normal: parse complete permission config', () {
      final json = {
        'file': {
          'read': {'paths': ['./data'], 'extensions': ['json', 'txt']},
          'write': {'paths': ['./output'], 'maxSize': '10MB'},
        },
        'network': {
          'http': {'domains': ['api.example.com']},
          'websocket': {'domains': ['ws.example.com']},
        },
        'system': {
          'info': ['platform', 'memory'],
          'exec': {'commands': ['ls', 'cat']},
          'clipboard': true,
        },
      };

      final perm = PermissionDefinition.fromJson(json);
      expect(perm.file, isNotNull);
      expect(perm.file!.read, isNotNull);
      expect(perm.file!.write, isNotNull);
      expect(perm.network, isNotNull);
      expect(perm.network!.http, isNotNull);
      expect(perm.network!.websocket, isNotNull);
      expect(perm.system, isNotNull);
      expect(perm.system!.info, equals(['platform', 'memory']));
      expect(perm.system!.exec, isNotNull);
      expect(perm.system!.clipboard, isTrue);
    });

    test('Boundary: simplified form - file as list of strings', () {
      final json = {
        'file': ['read', 'write'],
      };

      final perm = PermissionDefinition.fromJson(json);
      expect(perm.file, isNotNull);
      expect(perm.file!.read, isNotNull);
      expect(perm.file!.write, isNotNull);
    });

    test('Boundary: simplified form - network as list', () {
      final json = {
        'network': ['http', 'websocket'],
      };

      final perm = PermissionDefinition.fromJson(json);
      expect(perm.network, isNotNull);
      expect(perm.network!.http, isNotNull);
      expect(perm.network!.websocket, isNotNull);
    });

    test('Error: unknown permission category ignored', () {
      final json = {
        'file': ['read'],
        'unknownCategory': true,
      };
      // Should parse without exception - unknownCategory is ignored
      final perm = PermissionDefinition.fromJson(json);
      expect(perm.file, isNotNull);
    });
  });

  // =========================================================================
  // TC-075: FilePermission detailed parsing
  // =========================================================================
  group('TC-075: FilePermission detailed parsing', () {
    test('Normal: parse read with all fields', () {
      final json = {
        'read': {
          'paths': ['./config', './data'],
          'extensions': ['json', 'txt'],
          'excludePaths': ['./config/secrets'],
          'maxSize': '10MB',
        },
      };

      final fp = FilePermission.fromJson(json);
      expect(fp.read, isNotNull);
      expect(fp.read!.paths, equals(['./config', './data']));
      expect(fp.read!.extensions, equals(['json', 'txt']));
      expect(fp.read!.excludePaths, equals(['./config/secrets']));
      expect(fp.read!.maxSize, equals('10MB'));
    });

    test('Normal: parse write with all fields', () {
      final json = {
        'write': {
          'paths': ['./output'],
          'extensions': ['json'],
          'maxSize': '5MB',
          'excludePaths': ['./output/readonly'],
          'createDirectories': true,
          'overwritePolicy': 'prompt',
        },
      };

      final fp = FilePermission.fromJson(json);
      expect(fp.write, isNotNull);
      expect(fp.write!.paths, equals(['./output']));
      expect(fp.write!.createDirectories, isTrue);
      expect(fp.write!.overwritePolicy, equals('prompt'));
    });

    test('Boundary: overwritePolicy values', () {
      for (final policy in ['allow', 'prompt', 'deny']) {
        final json = {
          'write': {'overwritePolicy': policy},
        };
        final fp = FilePermission.fromJson(json);
        expect(fp.write!.overwritePolicy, equals(policy));
      }
    });

    test('Boundary: createDirectories defaults to null (not set)', () {
      final json = {
        'write': {'paths': ['./output']},
      };
      final fp = FilePermission.fromJson(json);
      expect(fp.write!.createDirectories, isNull);
    });
  });

  // =========================================================================
  // TC-076: NetworkPermission parsing
  // =========================================================================
  group('TC-076: NetworkPermission parsing', () {
    test('Normal: parse http and websocket domains with wildcards', () {
      final json = {
        'http': {
          'domains': ['api.example.com', '*.mydomain.com'],
        },
        'websocket': {
          'domains': ['ws.example.com'],
        },
      };

      final np = NetworkPermission.fromJson(json);
      expect(np.http, isNotNull);
      expect(np.http!.domains, contains('*.mydomain.com'));
      expect(np.websocket, isNotNull);
      expect(np.websocket!.domains, equals(['ws.example.com']));
    });

    test('Boundary: empty domains list', () {
      final json = {
        'http': {'domains': <String>[]},
      };
      final np = NetworkPermission.fromJson(json);
      expect(np.http!.domains, isEmpty);
    });
  });

  // =========================================================================
  // TC-077: SystemPermission parsing
  // =========================================================================
  group('TC-077: SystemPermission parsing', () {
    test('Normal: parse info, exec, clipboard', () {
      final json = {
        'info': ['platform', 'memory', 'cpus'],
        'exec': {
          'commands': ['ls', 'cat', 'echo'],
        },
        'clipboard': true,
      };

      final sp = SystemPermission.fromJson(json);
      expect(sp.info, equals(['platform', 'memory', 'cpus']));
      expect(sp.exec, isNotNull);
      expect(sp.exec!.commands, equals(['ls', 'cat', 'echo']));
      expect(sp.clipboard, isTrue);
    });

    test('Boundary: clipboard defaults to null when not set', () {
      final sp = SystemPermission.fromJson({'info': ['platform']});
      expect(sp.clipboard, isNull);
    });

    test('Boundary: simplified system form', () {
      final sp = SystemPermission.fromJson(['info', 'exec', 'clipboard']);
      expect(sp.info, isNotNull);
      expect(sp.exec, isNotNull);
      expect(sp.clipboard, isTrue);
    });
  });
}
