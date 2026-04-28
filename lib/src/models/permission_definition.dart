import 'package:meta/meta.dart';

/// v1.1: Strongly-typed permission definition for client resource access
///
/// Declares required client permissions at screen/page level.
/// Supports both simplified form (list of strings) and detailed form
/// (object with path/extension/domain restrictions).
@immutable
class PermissionDefinition {
  /// File access permissions
  final FilePermission? file;

  /// Network access permissions
  final NetworkPermission? network;

  /// System access permissions
  final SystemPermission? system;

  const PermissionDefinition({
    this.file,
    this.network,
    this.system,
  });

  /// Create from JSON
  ///
  /// Supports both simplified and detailed formats:
  /// ```json
  /// // Simplified: {"file": ["read", "write"], "network": ["http"]}
  /// // Detailed: {"file": {"read": {"paths": [...]}}, "network": {"http": {"domains": [...]}}}
  /// ```
  factory PermissionDefinition.fromJson(Map<String, dynamic> json) {
    return PermissionDefinition(
      file: json['file'] != null ? FilePermission.fromJson(json['file']) : null,
      network: json['network'] != null
          ? NetworkPermission.fromJson(json['network'])
          : null,
      system: json['system'] != null
          ? SystemPermission.fromJson(json['system'])
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (file != null) 'file': file!.toJson(),
      if (network != null) 'network': network!.toJson(),
      if (system != null) 'system': system!.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionDefinition &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          network == other.network &&
          system == other.system;

  @override
  int get hashCode => file.hashCode ^ network.hashCode ^ system.hashCode;

  @override
  String toString() =>
      'PermissionDefinition(file: $file, network: $network, system: $system)';
}

/// File access permission definition
@immutable
class FilePermission {
  /// Read permission details
  final FileReadPermission? read;

  /// Write permission details
  final FileWritePermission? write;

  const FilePermission({this.read, this.write});

  /// Parse from JSON, supporting both simplified and detailed forms
  factory FilePermission.fromJson(dynamic json) {
    if (json is List) {
      // Simplified form: ["read", "write"]
      return FilePermission(
        read: json.contains('read') ? const FileReadPermission() : null,
        write: json.contains('write') ? const FileWritePermission() : null,
      );
    }

    if (json is Map<String, dynamic>) {
      return FilePermission(
        read: json['read'] != null
            ? FileReadPermission.fromJson(json['read'])
            : null,
        write: json['write'] != null
            ? FileWritePermission.fromJson(json['write'])
            : null,
      );
    }

    return const FilePermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (read != null) 'read': read!.toJson(),
      if (write != null) 'write': write!.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilePermission &&
          runtimeType == other.runtimeType &&
          read == other.read &&
          write == other.write;

  @override
  int get hashCode => read.hashCode ^ write.hashCode;

  @override
  String toString() => 'FilePermission(read: $read, write: $write)';
}

/// File read permission with optional path/extension restrictions
@immutable
class FileReadPermission {
  /// Allowed paths (e.g., ["./config", "./data"])
  final List<String>? paths;

  /// Allowed file extensions (e.g., ["json", "txt"])
  final List<String>? extensions;

  /// Excluded paths (e.g., ["./config/secrets"])
  final List<String>? excludePaths;

  /// Maximum file size (e.g., "10MB")
  final String? maxSize;

  const FileReadPermission({
    this.paths,
    this.extensions,
    this.excludePaths,
    this.maxSize,
  });

  factory FileReadPermission.fromJson(dynamic json) {
    if (json is bool) {
      return const FileReadPermission();
    }
    if (json is Map<String, dynamic>) {
      return FileReadPermission(
        paths: (json['paths'] as List<dynamic>?)?.cast<String>(),
        extensions: (json['extensions'] as List<dynamic>?)?.cast<String>(),
        excludePaths: (json['excludePaths'] as List<dynamic>?)?.cast<String>(),
        maxSize: json['maxSize'] as String?,
      );
    }
    return const FileReadPermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (paths != null) 'paths': paths,
      if (extensions != null) 'extensions': extensions,
      if (excludePaths != null) 'excludePaths': excludePaths,
      if (maxSize != null) 'maxSize': maxSize,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileReadPermission &&
          runtimeType == other.runtimeType &&
          _listEquals(paths, other.paths) &&
          _listEquals(extensions, other.extensions) &&
          _listEquals(excludePaths, other.excludePaths) &&
          maxSize == other.maxSize;

  @override
  int get hashCode =>
      paths.hashCode ^ extensions.hashCode ^ excludePaths.hashCode ^ maxSize.hashCode;

  @override
  String toString() =>
      'FileReadPermission(paths: $paths, extensions: $extensions)';
}

/// File write permission with optional path/size restrictions
@immutable
class FileWritePermission {
  /// Allowed write paths (e.g., ["./output"])
  final List<String>? paths;

  /// Maximum file size (e.g., "10MB")
  final String? maxSize;

  /// Allowed file extensions (e.g., ["json", "txt"])
  final List<String>? extensions;

  /// Excluded paths
  final List<String>? excludePaths;

  /// Whether to allow creating directories
  final bool? createDirectories;

  /// Overwrite policy: 'allow', 'deny', 'prompt'
  final String? overwritePolicy;

  const FileWritePermission({
    this.paths,
    this.maxSize,
    this.extensions,
    this.excludePaths,
    this.createDirectories,
    this.overwritePolicy,
  });

  factory FileWritePermission.fromJson(dynamic json) {
    if (json is bool) {
      return const FileWritePermission();
    }
    if (json is Map<String, dynamic>) {
      return FileWritePermission(
        paths: (json['paths'] as List<dynamic>?)?.cast<String>(),
        maxSize: json['maxSize'] as String?,
        extensions: (json['extensions'] as List<dynamic>?)?.cast<String>(),
        excludePaths: (json['excludePaths'] as List<dynamic>?)?.cast<String>(),
        createDirectories: json['createDirectories'] as bool?,
        overwritePolicy: json['overwritePolicy'] as String?,
      );
    }
    return const FileWritePermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (paths != null) 'paths': paths,
      if (maxSize != null) 'maxSize': maxSize,
      if (extensions != null) 'extensions': extensions,
      if (excludePaths != null) 'excludePaths': excludePaths,
      if (createDirectories != null) 'createDirectories': createDirectories,
      if (overwritePolicy != null) 'overwritePolicy': overwritePolicy,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileWritePermission &&
          runtimeType == other.runtimeType &&
          _listEquals(paths, other.paths) &&
          maxSize == other.maxSize &&
          _listEquals(extensions, other.extensions) &&
          _listEquals(excludePaths, other.excludePaths) &&
          createDirectories == other.createDirectories &&
          overwritePolicy == other.overwritePolicy;

  @override
  int get hashCode =>
      paths.hashCode ^ maxSize.hashCode ^ extensions.hashCode ^
      excludePaths.hashCode ^ createDirectories.hashCode ^ overwritePolicy.hashCode;

  @override
  String toString() => 'FileWritePermission(paths: $paths, maxSize: $maxSize)';
}

/// Network access permission definition
@immutable
class NetworkPermission {
  /// HTTP request permission
  final NetworkHttpPermission? http;

  /// WebSocket permission
  final NetworkWebSocketPermission? websocket;

  const NetworkPermission({this.http, this.websocket});

  factory NetworkPermission.fromJson(dynamic json) {
    if (json is List) {
      // Simplified form: ["http", "websocket"]
      return NetworkPermission(
        http:
            json.contains('http') ? const NetworkHttpPermission() : null,
        websocket: json.contains('websocket')
            ? const NetworkWebSocketPermission()
            : null,
      );
    }

    if (json is Map<String, dynamic>) {
      return NetworkPermission(
        http: json['http'] != null
            ? NetworkHttpPermission.fromJson(json['http'])
            : null,
        websocket: json['websocket'] != null
            ? NetworkWebSocketPermission.fromJson(json['websocket'])
            : null,
      );
    }

    return const NetworkPermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (http != null) 'http': http!.toJson(),
      if (websocket != null) 'websocket': websocket!.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkPermission &&
          runtimeType == other.runtimeType &&
          http == other.http &&
          websocket == other.websocket;

  @override
  int get hashCode => http.hashCode ^ websocket.hashCode;

  @override
  String toString() =>
      'NetworkPermission(http: $http, websocket: $websocket)';
}

/// HTTP permission with optional domain restrictions
@immutable
class NetworkHttpPermission {
  /// Allowed domains (e.g., ["api.example.com", "*.mydomain.com"])
  final List<String>? domains;

  const NetworkHttpPermission({this.domains});

  factory NetworkHttpPermission.fromJson(dynamic json) {
    if (json is bool) {
      return const NetworkHttpPermission();
    }
    if (json is Map<String, dynamic>) {
      return NetworkHttpPermission(
        domains: (json['domains'] as List<dynamic>?)?.cast<String>(),
      );
    }
    return const NetworkHttpPermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (domains != null) 'domains': domains,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkHttpPermission &&
          runtimeType == other.runtimeType &&
          _listEquals(domains, other.domains);

  @override
  int get hashCode => domains.hashCode;

  @override
  String toString() => 'NetworkHttpPermission(domains: $domains)';
}

/// WebSocket permission with optional domain restrictions
@immutable
class NetworkWebSocketPermission {
  /// Allowed WebSocket domains
  final List<String>? domains;

  const NetworkWebSocketPermission({this.domains});

  factory NetworkWebSocketPermission.fromJson(dynamic json) {
    if (json is bool) {
      return const NetworkWebSocketPermission();
    }
    if (json is Map<String, dynamic>) {
      return NetworkWebSocketPermission(
        domains: (json['domains'] as List<dynamic>?)?.cast<String>(),
      );
    }
    return const NetworkWebSocketPermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (domains != null) 'domains': domains,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkWebSocketPermission &&
          runtimeType == other.runtimeType &&
          _listEquals(domains, other.domains);

  @override
  int get hashCode => domains.hashCode;

  @override
  String toString() => 'NetworkWebSocketPermission(domains: $domains)';
}

/// System access permission definition
@immutable
class SystemPermission {
  /// Allowed system info properties (e.g., ["platform", "memory"])
  final List<String>? info;

  /// Shell command execution permission
  final SystemExecPermission? exec;

  /// Whether clipboard access is permitted
  final bool? clipboard;

  const SystemPermission({this.info, this.exec, this.clipboard});

  factory SystemPermission.fromJson(dynamic json) {
    if (json is List) {
      // Simplified form: ["info", "exec", "clipboard"]
      return SystemPermission(
        info: json.contains('info') ? const <String>[] : null,
        exec: json.contains('exec') ? const SystemExecPermission() : null,
        clipboard: json.contains('clipboard') ? true : null,
      );
    }

    if (json is Map<String, dynamic>) {
      return SystemPermission(
        info: (json['info'] as List<dynamic>?)?.cast<String>(),
        exec: json['exec'] != null
            ? SystemExecPermission.fromJson(json['exec'])
            : null,
        clipboard: json['clipboard'] as bool?,
      );
    }

    return const SystemPermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (info != null) 'info': info,
      if (exec != null) 'exec': exec!.toJson(),
      if (clipboard != null) 'clipboard': clipboard,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemPermission &&
          runtimeType == other.runtimeType &&
          _listEquals(info, other.info) &&
          exec == other.exec &&
          clipboard == other.clipboard;

  @override
  int get hashCode => info.hashCode ^ exec.hashCode ^ clipboard.hashCode;

  @override
  String toString() => 'SystemPermission(info: $info, exec: $exec, clipboard: $clipboard)';
}

/// Shell command execution permission with command allowlist
@immutable
class SystemExecPermission {
  /// Allowed commands (e.g., ["ls", "cat", "echo"])
  final List<String>? commands;

  const SystemExecPermission({this.commands});

  factory SystemExecPermission.fromJson(dynamic json) {
    if (json is bool) {
      return const SystemExecPermission();
    }
    if (json is Map<String, dynamic>) {
      return SystemExecPermission(
        commands: (json['commands'] as List<dynamic>?)?.cast<String>(),
      );
    }
    return const SystemExecPermission();
  }

  Map<String, dynamic> toJson() {
    return {
      if (commands != null) 'commands': commands,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemExecPermission &&
          runtimeType == other.runtimeType &&
          _listEquals(commands, other.commands);

  @override
  int get hashCode => commands.hashCode;

  @override
  String toString() => 'SystemExecPermission(commands: $commands)';
}

/// Compare two nullable lists for equality
bool _listEquals(List<String>? a, List<String>? b) {
  if (identical(a, b)) return true;
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
