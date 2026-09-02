/// Supported Katana deployment environments.
enum KatanaFlavor {
  /// Development environment.
  dev,

  /// Production environment.
  prod;

  /// Parses a flavor name.
  static KatanaFlavor parse(String value) {
    return switch (value.trim()) {
      "dev" => KatanaFlavor.dev,
      "prod" => KatanaFlavor.prod,
      _ => throw ArgumentError.value(
          value,
          "flavor",
          "Flavor must be dev or prod.",
        ),
    };
  }
}

/// Resolves environment-aware values in Katana configuration files.
class FlavorContext {
  FlavorContext._({
    required this.flavor,
    required this.yaml,
    required this.secrets,
    required this.explicit,
    required Map<dynamic, dynamic> sourceYaml,
  }) : _sourceYaml = sourceYaml;

  /// Selected environment.
  final KatanaFlavor flavor;

  /// Configuration with recognized environment maps resolved to scalar values.
  final Map<dynamic, dynamic> yaml;

  /// Secret configuration with recognized environment maps resolved.
  final Map<dynamic, dynamic> secrets;

  /// Whether the flavor was explicitly specified on the command line.
  final bool explicit;

  final Map<dynamic, dynamic> _sourceYaml;

  /// Reads an unresolved YAML value for a specific environment.
  Object? yamlValue(
    List<String> path, {
    KatanaFlavor? flavor,
  }) {
    final value = _readPath(_sourceYaml, path);
    if (!_isEnvironmentMap(value)) {
      return _deepCopy(value);
    }
    return _deepCopy((value! as Map)[(flavor ?? this.flavor).name]);
  }

  /// Resolves flavor and environment-aware leaf values.
  factory FlavorContext.resolve({
    required Map<dynamic, dynamic> yaml,
    required Map<dynamic, dynamic> secrets,
    required List<String> arguments,
  }) {
    final explicitFlavor = _readExplicitFlavor(arguments);
    final hasEnvironmentMap = [
      ..._yamlEnvironmentPaths.map((path) => _readPath(yaml, path)),
      ..._secretEnvironmentPaths.map((path) => _readPath(secrets, path)),
    ].any(_isEnvironmentMap);
    final flavor = explicitFlavor ??
        (hasEnvironmentMap ? KatanaFlavor.dev : KatanaFlavor.prod);
    final resolvedYaml = _deepCopyMap(yaml);
    final resolvedSecrets = _deepCopyMap(secrets);
    for (final path in _yamlEnvironmentPaths) {
      _resolvePath(resolvedYaml, path, flavor);
    }
    for (final path in _secretEnvironmentPaths) {
      _resolvePath(resolvedSecrets, path, flavor);
    }
    return FlavorContext._(
      flavor: flavor,
      yaml: resolvedYaml,
      secrets: resolvedSecrets,
      explicit: explicitFlavor != null,
      sourceYaml: _deepCopyMap(yaml),
    );
  }

  static KatanaFlavor? _readExplicitFlavor(List<String> arguments) {
    String? value;
    for (var i = 0; i < arguments.length; i++) {
      final argument = arguments[i];
      if (argument.startsWith("--flavor=")) {
        if (value != null) {
          throw ArgumentError("Flavor was specified more than once.");
        }
        value = argument.substring("--flavor=".length);
      } else if (argument == "--flavor") {
        if (value != null || i + 1 >= arguments.length) {
          throw ArgumentError("--flavor requires one value.");
        }
        value = arguments[++i];
      }
    }
    return value == null ? null : KatanaFlavor.parse(value);
  }

  static bool _isEnvironmentMap(Object? value) {
    if (value is! Map) {
      return false;
    }
    return value.keys.any((key) => key == "dev" || key == "prod");
  }

  static void _resolvePath(
    Map<dynamic, dynamic> root,
    List<String> path,
    KatanaFlavor flavor,
  ) {
    var current = root;
    for (var i = 0; i < path.length - 1; i++) {
      final next = current[path[i]];
      if (next is! Map) {
        return;
      }
      current = next;
    }
    final key = path.last;
    final value = current[key];
    if (!_isEnvironmentMap(value)) {
      return;
    }
    final environmentMap = value! as Map;
    final unknownKeys = environmentMap.keys
        .map((key) => key.toString())
        .where((key) => key != "dev" && key != "prod")
        .toList();
    if (unknownKeys.isNotEmpty) {
      throw FormatException(
        "Unknown environment keys at ${path.join(".")}: "
        "${unknownKeys.join(", ")}",
      );
    }
    if (!environmentMap.containsKey(flavor.name)) {
      throw FormatException(
        "Missing ${flavor.name} value at ${path.join(".")}.",
      );
    }
    final selected = environmentMap[flavor.name];
    current[key] = _deepCopy(selected);
  }

  static Object? _readPath(Map<dynamic, dynamic> root, List<String> path) {
    Object? current = root;
    for (final key in path) {
      if (current is! Map) {
        return null;
      }
      current = current[key];
    }
    return current;
  }

  static Map<dynamic, dynamic> _deepCopyMap(Map<dynamic, dynamic> source) {
    return source.map((key, value) => MapEntry(key, _deepCopy(value)));
  }

  static Object? _deepCopy(Object? value) {
    if (value is Map) {
      return _deepCopyMap(value);
    }
    if (value is List) {
      return value.map(_deepCopy).toList();
    }
    return value;
  }
}

const _yamlEnvironmentPaths = <List<String>>[
  ["firebase", "project_id"],
  ["cloudflare", "project_id"],
  ["cloudflare", "turso", "organization"],
  ["cloudflare", "turso", "group"],
  ["cloudflare", "turso", "server_token_ttl"],
  ["cloudflare", "tidb", "project_id"],
  ["cloudflare", "tidb", "cluster_id"],
  ["cloudflare", "tidb", "app_name"],
  ["cloudflare", "tidb", "region"],
  ["cloudflare", "tidb", "database_prefix"],
  ["cloudflare", "turso", "database_prefix"],
  ["cloudflare", "kv", "binding"],
  ["cloudflare", "kv", "namespace_id"],
  ["cloudflare", "kv", "preview_id"],
  ["cloudflare", "storage", "binding"],
  ["cloudflare", "storage", "bucket_name"],
  ["cloudflare", "storage", "preview_bucket_name"],
  ["cloudflare", "storage", "public_base_url"],
  ["cloudflare", "storage", "backup", "binding"],
  ["cloudflare", "storage", "backup", "bucket_name"],
  ["cloudflare", "storage", "backup", "preview_bucket_name"],
  ["cloudflare", "storage", "backup", "queue_name"],
  ["cloudflare", "storage", "backup", "dead_letter_queue"],
];

const _secretEnvironmentPaths = <List<String>>[
  ["cloudflare", "turso", "platform_api_token"],
  ["cloudflare", "tidb", "connection_url"],
  ["cloudflare", "tidb", "management_api", "public_key"],
  ["cloudflare", "tidb", "management_api", "private_key"],
  ["cloudflare", "tidb", "data_service", "app_id"],
  ["cloudflare", "tidb", "data_service", "api_key_id"],
  ["cloudflare", "tidb", "data_service", "region"],
  ["cloudflare", "tidb", "data_service", "public_key"],
  ["cloudflare", "tidb", "data_service", "private_key"],
];
