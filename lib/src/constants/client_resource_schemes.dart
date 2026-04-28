/// Client resource URI scheme constants for MCP UI DSL v1.1
///
/// Defines well-known URI schemes for client-side resource access.
/// These schemes are used in resource actions and bindings to reference
/// files, workspace paths, temporary directories, and cache locations.
class ClientResourceSchemes {
  /// Base protocol prefix for all client resource URIs
  static const String protocol = 'client://';

  /// Absolute file path scheme
  /// Example: client://file/path/to/file.txt
  static const String file = 'client://file';

  /// Workspace-relative path scheme
  /// Example: client://workspace/src/main.dart
  static const String workspace = 'client://workspace';

  /// Temporary directory scheme
  /// Example: client://temp/session-data.json
  static const String temp = 'client://temp';

  /// Cache directory scheme
  /// Example: client://cache/images/logo.png
  static const String cache = 'client://cache';

  /// All supported schemes
  static const List<String> allSchemes = [
    file,
    workspace,
    temp,
    cache,
  ];

  /// Check if a URI string uses a client resource scheme
  static bool isClientUri(String uri) {
    return uri.startsWith(protocol);
  }

  /// Get the scheme portion of a client URI
  /// Returns null if the URI is not a valid client resource URI
  static String? getScheme(String uri) {
    if (!isClientUri(uri)) return null;
    for (final scheme in allSchemes) {
      if (uri.startsWith(scheme)) return scheme;
    }
    return null;
  }

  /// Extract the path portion from a client URI
  /// Returns null if the URI is not a valid client resource URI
  static String? getPath(String uri) {
    final scheme = getScheme(uri);
    if (scheme == null) return null;
    final path = uri.substring(scheme.length);
    // Remove leading slash if present
    if (path.startsWith('/')) return path.substring(1);
    return path;
  }
}
