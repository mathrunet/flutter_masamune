// Dart imports:
import "dart:convert";
import "dart:io";

// Package imports:
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Path of the legacy, flavor-independent TiDB state managed by Katana.
const tidbLegacyManagedStatePath = "cloudflare/tidb.yaml";

/// Returns the path of the flavor-specific TiDB state managed by Katana.
String tidbManagedStatePathFor(String environment) {
  final normalized = environment.trim();
  if (normalized.isEmpty || !RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(normalized)) {
    throw ArgumentError.value(environment, "environment", "Invalid flavor");
  }
  return "cloudflare/tidb.$normalized.yaml";
}

/// Result of loading and migrating the TiDB managed state.
class TidbManagedStateLoadResult {
  /// Creates a result of loading and migrating the TiDB managed state.
  const TidbManagedStateLoadResult({
    required this.state,
    required this.secretsChanged,
    required this.stateChanged,
  });

  /// Flavor-specific TiDB state stored under `cloudflare/`.
  final Map<String, dynamic> state;

  /// Whether `katana_secrets.yaml` was changed by migration.
  final bool secretsChanged;

  /// Whether the flavor-specific state must be persisted.
  final bool stateChanged;
}

/// Loads TiDB state and migrates legacy automatically managed secrets.
Future<TidbManagedStateLoadResult> loadAndMigrateTidbManagedState(
    Map<String, dynamic> secrets,
    {String environment = "prod"}) async {
  final statePath = tidbManagedStatePathFor(environment);
  final file = File(statePath);
  final legacyFile = File(tidbLegacyManagedStatePath);
  final source = file.existsSync()
      ? file
      : environment == "prod" && legacyFile.existsSync()
          ? legacyFile
          : null;
  final loaded = source != null
      ? Map<String, dynamic>.from(
          modifize(loadYaml(await source.readAsString())) as Map? ?? {},
        )
      : <String, dynamic>{};
  final state = _stringMap(loaded);
  final cloudflare = _nested(secrets, ["cloudflare"]);
  final tidbSecrets = _nested(cloudflare, ["tidb"]);
  var secretsChanged = false;
  var stateChanged = !file.existsSync();

  for (final key in const ["data_service", "cutover"]) {
    final legacy = environment == "prod"
        ? _meaningfulMap(tidbSecrets[key])
        : <String, dynamic>{};
    final current = _meaningfulMap(state[key]);
    if (legacy.isNotEmpty) {
      final merged = _mergeManagedState(
        current,
        legacy,
        key,
        statePath,
      );
      if (!_deepEqual(current, merged)) {
        state[key] = merged;
        stateChanged = true;
      }
    } else if (current.isNotEmpty) {
      state[key] = current;
    }
    if (environment == "prod" && tidbSecrets.containsKey(key)) {
      tidbSecrets.remove(key);
      secretsChanged = true;
    }
  }
  if (tidbSecrets.containsKey("connection_url")) {
    tidbSecrets.remove("connection_url");
    secretsChanged = true;
  }
  if (state["version"] != 1) {
    state["version"] = 1;
    stateChanged = true;
  }
  for (final key in const ["data_service", "cutover"]) {
    if (!state.containsKey(key)) {
      state[key] = <String, dynamic>{};
      stateChanged = true;
    }
  }
  return TidbManagedStateLoadResult(
    state: state,
    secretsChanged: secretsChanged,
    stateChanged: stateChanged,
  );
}

/// Saves TiDB managed state without writing secrets into Worker sources.
Future<void> saveTidbManagedState(
  Map<String, dynamic> state, {
  String environment = "prod",
}) async {
  final file = File(tidbManagedStatePathFor(environment));
  await file.parent.create(recursive: true);
  final temporary = File("${file.path}.tmp");
  await temporary.writeAsString(YamlWriter().write(state));
  try {
    await temporary.rename(file.path);
  } on FileSystemException {
    await file.writeAsString(await temporary.readAsString());
    await temporary.delete();
  }
}

/// Ensures that TiDB managed state containing private keys is ignored by Git.
Future<void> ensureTidbManagedStateIsGitIgnored() async {
  final file = File("cloudflare/.gitignore");
  if (!file.existsSync()) {
    throw StateError(
      "The file `cloudflare/.gitignore` does not exist. Initialize "
      "Cloudflare Workers before enabling TiDB.",
    );
  }
  final lines = await file.readAsLines();
  var changed = false;
  for (final pattern in const ["tidb.yaml", "tidb.*.yaml"]) {
    if (!lines.any((line) => line.trim() == pattern)) {
      lines.add(pattern);
      changed = true;
    }
  }
  if (changed) {
    await file.writeAsString("${lines.join("\n")}\n");
  }
}

Map<String, dynamic> _nested(
  Map<String, dynamic> root,
  List<String> path,
) {
  var current = root;
  for (final key in path) {
    final value = current[key];
    current = value is Map
        ? current[key] = _stringMap(value)
        : current[key] = <String, dynamic>{};
  }
  return current;
}

Map<String, dynamic> _meaningfulMap(Object? value) {
  final normalized = _normalize(value);
  return normalized is Map<String, dynamic> ? normalized : <String, dynamic>{};
}

Object? _normalize(Object? value) {
  if (value == null || value == "") {
    return null;
  }
  if (value is Map) {
    final result = <String, dynamic>{};
    final entries = value.entries.toList()
      ..sort(
          (left, right) => left.key.toString().compareTo(right.key.toString()));
    for (final entry in entries) {
      final key = entry.key.toString();
      final normalized = _normalize(entry.value);
      if (normalized == null ||
          normalized is Map && normalized.isEmpty ||
          normalized is List && normalized.isEmpty) {
        continue;
      }
      result[key] = normalized;
    }
    return result;
  }
  if (value is List) {
    return value.map(_normalize).where((item) => item != null).toList();
  }
  return value;
}

Map<String, dynamic> _stringMap(Map<dynamic, dynamic> value) =>
    value.map((key, item) => MapEntry(key.toString(), item));

bool _deepEqual(Object? left, Object? right) =>
    jsonEncode(_normalize(left)) == jsonEncode(_normalize(right));

Map<String, dynamic> _mergeManagedState(
  Map<String, dynamic> current,
  Map<String, dynamic> legacy,
  String path,
  String statePath,
) {
  final merged = Map<String, dynamic>.from(current);
  for (final entry in legacy.entries) {
    final existing = merged[entry.key];
    if (existing == null || existing == "") {
      merged[entry.key] = entry.value;
      continue;
    }
    if (existing is Map && entry.value is Map) {
      merged[entry.key] = _mergeManagedState(
        _meaningfulMap(existing),
        _meaningfulMap(entry.value),
        "$path.${entry.key}",
        statePath,
      );
      continue;
    }
    if (!_deepEqual(existing, entry.value)) {
      throw StateError(
        "TiDB managed state differs between `katana_secrets.yaml` and "
        "`$statePath` at `$path.${entry.key}`. Resolve the "
        "conflict before running `katana apply` again.",
      );
    }
  }
  return merged;
}
