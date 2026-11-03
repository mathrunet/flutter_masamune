// Dart imports:
import "dart:convert";
import "dart:io";
import "dart:math";

// Package imports:
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Path of the Turso state managed by Katana (git-ignored).
///
/// Katanaが管理するTursoの状態ファイルのパス（git管理外）。
const tursoManagedStatePath = "cloudflare/turso.yaml";

/// Path of the schema manifest served by the region Worker for the shared Turso database.
///
/// region Workerが共用Turso DB用に使うschema manifestのパス。
const tursoSharedSchemaManifestPath =
    "cloudflare/src/turso_shared_schema_manifest.json";

/// Name of the region Worker secret that marks trusted server requests.
///
/// 信頼できるサーバーリクエストを示すregion Workerのsecret名。
const tursoServerAccessTokenSecret = "TURSO_SERVER_ACCESS_TOKEN";

const _tursoSharedManagedKeys = {"schemaManifest", "databaseBindings"};

/// Physical database and group of the shared Turso database for one environment.
///
/// 1環境分の共用Turso DBの物理DB名とgroup。
class TursoSharedBinding {
  /// Physical database and group of the shared Turso database for one environment.
  ///
  /// 1環境分の共用Turso DBの物理DB名とgroup。
  const TursoSharedBinding({required this.database, required this.group});

  /// Physical Turso database name.
  ///
  /// Tursoの物理DB名。
  final String database;

  /// Turso group of the database.
  ///
  /// DBの所属group。
  final String group;

  /// JSON representation used by `databaseBindings`.
  ///
  /// `databaseBindings`で使うJSON表現。
  Map<String, String> toJson() => {"database": database, "group": group};
}

/// Resolved `cloudflare.turso.shared` configuration.
///
/// 解決済みの`cloudflare.turso.shared`設定。
class TursoSharedConfig {
  /// Resolved `cloudflare.turso.shared` configuration.
  ///
  /// 解決済みの`cloudflare.turso.shared`設定。
  const TursoSharedConfig({
    required this.logicalName,
    required this.bindings,
  });

  /// Logical database name used in model paths (`database/<logicalName>/...`).
  ///
  /// モデルのパスで使う論理DB名（`database/<logicalName>/...`）。
  final String logicalName;

  /// Bindings per environment (`dev` / `prod`).
  ///
  /// 環境（`dev` / `prod`）ごとの対応表。
  final Map<String, TursoSharedBinding> bindings;

  /// `databaseBindings` for [flavors] as JSON.
  ///
  /// [flavors]の`databaseBindings`をJSONで返します。
  Map<String, dynamic> databaseBindingsJson([
    Iterable<String> flavors = const ["dev", "prod"],
  ]) {
    return {
      for (final flavor in flavors)
        if (bindings[flavor] != null)
          flavor: {logicalName: bindings[flavor]!.toJson()},
    };
  }
}

/// Resolves `cloudflare.turso.shared` from [shared].
///
/// Values may be a `{dev:, prod:}` map or a single value. Empty values use the defaults
/// (`<app>-dev-shared` / `<app>-shared`, groups `<app>-dev` / `<app>-us`) where `<app>`
/// is [appName] (the pubspec name with `_` replaced by `-`).
/// Throws [FormatException] for invalid values.
///
/// [shared]から`cloudflare.turso.shared`を解決します。
///
/// 値は`{dev:, prod:}`形式または単一値で指定できます。空の場合は既定値
/// （`<app>-dev-shared` / `<app>-shared`、group `<app>-dev` / `<app>-us`）を使います。
/// `<app>`は[appName]（pubspecのnameの`_`を`-`に置換したもの）です。
/// 不正な値は[FormatException]を投げます。
TursoSharedConfig resolveTursoSharedConfig({
  required Map shared,
  required String appName,
  FlavorContext? flavorContext,
}) {
  final logicalName = shared["logical_name"]?.toString().trim() ?? "";
  final resolvedLogicalName = logicalName.isEmpty ? "shared" : logicalName;
  if (!RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(resolvedLogicalName)) {
    throw FormatException(
      "[cloudflare]->[turso]->[shared]->[logical_name] must match [A-Za-z0-9_-]+: $resolvedLogicalName",
    );
  }
  final app = appName.trim().toLowerCase().replaceAll("_", "-");
  String value(String key, String flavor) {
    final Object? raw = flavorContext != null
        ? flavorContext.yamlValue(
            ["cloudflare", "turso", "shared", key],
            flavor: KatanaFlavor.parse(flavor),
          )
        : shared[key] is Map
            ? (shared[key] as Map)[flavor]
            : shared[key];
    return raw?.toString().trim() ?? "";
  }

  String fallback(String suffix) {
    if (app.isEmpty) {
      throw const FormatException(
        "The pubspec name could not be read. Set [cloudflare]->[turso]->[shared]->[database] and [group] explicitly.",
      );
    }
    return "$app-$suffix";
  }

  final bindings = <String, TursoSharedBinding>{};
  for (final flavor in const ["dev", "prod"]) {
    var database = value("database", flavor);
    var group = value("group", flavor);
    if (database.isEmpty) {
      database = fallback(flavor == "dev" ? "dev-shared" : "shared");
    }
    if (group.isEmpty) {
      group = fallback(flavor == "dev" ? "dev" : "us");
    }
    if (!RegExp(r"^[a-z0-9-]{1,56}$").hasMatch(database)) {
      throw FormatException(
        "[cloudflare]->[turso]->[shared]->[database] ($flavor) must match [a-z0-9-]{1,56}: $database",
      );
    }
    if (!RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(group)) {
      throw FormatException(
        "[cloudflare]->[turso]->[shared]->[group] ($flavor) must match [A-Za-z0-9_-]+: $group",
      );
    }
    bindings[flavor] = TursoSharedBinding(database: database, group: group);
  }
  if (bindings["dev"]!.database == bindings["prod"]!.database) {
    throw const FormatException(
      "[cloudflare]->[turso]->[shared]->[database] must differ between dev and prod.",
    );
  }
  return TursoSharedConfig(
    logicalName: resolvedLogicalName,
    bindings: bindings,
  );
}

/// Reads the package name from `pubspec.yaml` in the current directory.
///
/// カレントディレクトリの`pubspec.yaml`からパッケージ名を読み取ります。
String readTursoSharedAppName() {
  final pubspec = File("pubspec.yaml");
  if (!pubspec.existsSync()) {
    return "";
  }
  final match = RegExp(r"^name:\s*([A-Za-z0-9_]+)\s*$", multiLine: true)
      .firstMatch(pubspec.readAsStringSync());
  return match?.group(1) ?? "";
}

/// Converts the common schema [schema] into the Turso schema manifest format,
/// keeping only the tables whose database satisfies [include].
///
/// 共通schema [schema]をTursoのschema manifest形式に変換し、
/// databaseが[include]を満たすテーブルだけを残します。
Map<String, dynamic> tursoCompatibleSchemaManifest(
  Map schema, {
  required String Function(String type) columnType,
  bool Function(String database)? include,
}) {
  bool accepts(Object? database) =>
      include == null || include(database?.toString() ?? "");
  final tables = schema["tables"];
  if (tables is List) {
    return {
      "version": schema["sourceHash"] ?? schema["version"],
      "tables": {
        for (final table in tables)
          if (table is Map && accepts(table["database"]))
            "${table["database"]}\u0000${table["table"]}": {
              "database": table["database"],
              "table": table["table"],
              "columns": [
                for (final column in table["columns"])
                  {
                    "name": column["name"],
                    "type": columnType(column["sqlType"] as String),
                    if (column["vectorMetric"] != null)
                      "vectorMetric": column["vectorMetric"]
                  }
              ],
            }
      },
    };
  }
  if (tables is Map) {
    return {
      ...schema.map((key, value) => MapEntry(key.toString(), value)),
      "tables": {
        for (final entry in tables.entries)
          if (entry.value is Map && accepts((entry.value as Map)["database"]))
            entry.key.toString(): entry.value,
      },
    };
  }
  return schema.map((key, value) => MapEntry(key.toString(), value));
}

/// Registers `turso.Functions.turso` for the shared database in the region Worker [source].
///
/// Options other than `schemaManifest` and `databaseBindings` are kept.
/// `turso.Functions.tursoToken` is removed because a direct connection token would grant
/// access to the whole shared database. Returns null if the deploy array is not found.
///
/// region Workerの[source]に共用DB用の`turso.Functions.turso`を登録します。
///
/// `schemaManifest`と`databaseBindings`以外のオプションは保持します。
/// 直接接続トークンは共用DB全体の権限になるため`turso.Functions.tursoToken`は削除します。
/// deploy配列が見つからない場合はnullを返します。
String? updateTursoSharedRegionSource(
  String source, {
  required TursoSharedConfig config,
  required bool useSchemaManifest,
}) {
  const functionName = "turso.Functions.turso";
  var updated = CloudflareSourceUtils.ensureImport(
    source,
    alias: "turso",
    package: "@mathrunet/masamune_cloudflare_turso",
  );
  const manifestImport =
      'import tursoSharedSchemaManifest from "./turso_shared_schema_manifest.json";';
  if (useSchemaManifest && !updated.contains(manifestImport)) {
    final imports =
        RegExp(r"^import .+;$", multiLine: true).allMatches(updated).toList();
    updated = imports.isEmpty
        ? "$manifestImport\n$updated"
        : updated.replaceRange(
            imports.last.end, imports.last.end, "\n$manifestImport");
  }
  updated = _removeFunctionCallLines(updated, "turso.Functions.tursoToken");
  final arguments =
      CloudflareSourceUtils.functionArguments(updated, functionName);
  final preserved = <String>[];
  if (arguments != null && arguments.isNotEmpty) {
    final trimmed = arguments.replaceFirst(RegExp(r",\s*$"), "");
    final properties = _objectLiteralProperties(trimmed);
    if (properties == null) {
      preserved.add("...($trimmed)");
    } else {
      for (final property in properties) {
        final key = RegExp(r'''^["']?([A-Za-z_$][\w$]*)["']?\s*:''')
            .firstMatch(property)
            ?.group(1);
        if (key != null && _tursoSharedManagedKeys.contains(key)) {
          continue;
        }
        preserved.add(property);
      }
    }
  }
  final bindings = config.databaseBindingsJson().entries.map((entry) {
    final binding = (entry.value as Map)[config.logicalName] as Map;
    return "            ${entry.key}: { ${jsonEncode(config.logicalName)}: "
        "{ database: ${jsonEncode(binding["database"])}, group: ${jsonEncode(binding["group"])} } },";
  }).join("\n");
  final replacement = """
    turso.Functions.turso({
${useSchemaManifest ? "        schemaManifest: tursoSharedSchemaManifest as turso.TursoSchemaManifest,\n" : ""}        databaseBindings: {
$bindings
        },
${preserved.map((property) => "        $property,\n").join()}    }),""";
  if (arguments != null) {
    return CloudflareSourceUtils.replaceFunctionCall(
        updated, functionName, replacement.trimLeft());
  }
  return CloudflareSourceUtils.insertDeployFunctions(
      updated, ["$replacement\n"]);
}

/// Removes every call to [functionName] together with its own lines.
String _removeFunctionCallLines(String source, String functionName) {
  var updated = source;
  while (true) {
    final start = updated.indexOf("$functionName(");
    if (start < 0) {
      return updated;
    }
    final withoutCall = CloudflareSourceUtils.replaceFunctionCall(
      updated.substring(start),
      functionName,
      "",
    );
    var before = updated.substring(0, start);
    var after = withoutCall;
    final lineStart = before.lastIndexOf("\n") + 1;
    final newline = after.indexOf("\n");
    if (before.substring(lineStart).trim().isEmpty &&
        newline >= 0 &&
        after.substring(0, newline).trim().isEmpty) {
      before = before.substring(0, lineStart);
      after = after.substring(newline + 1);
    }
    updated = "$before$after";
  }
}

/// Returns the top-level properties of the object literal [source], or null if
/// [source] is not a single object literal.
List<String>? _objectLiteralProperties(String source) {
  final text = source.trim();
  if (!text.startsWith("{") || !text.endsWith("}")) {
    return null;
  }
  final properties = <String>[];
  var depth = 0;
  String? quote;
  var escaped = false;
  var start = 1;
  for (var i = 0; i < text.length; i++) {
    final char = text[i];
    if (quote != null) {
      if (escaped) {
        escaped = false;
      } else if (char == "\\") {
        escaped = true;
      } else if (char == quote) {
        quote = null;
      }
      continue;
    }
    if (char == "/" && i + 1 < text.length && text[i + 1] == "/") {
      final end = text.indexOf("\n", i);
      if (end < 0) {
        return null;
      }
      i = end;
      continue;
    }
    if (char == "/" && i + 1 < text.length && text[i + 1] == "*") {
      final end = text.indexOf("*/", i + 2);
      if (end < 0) {
        return null;
      }
      i = end + 1;
      continue;
    }
    if (char == '"' || char == "'" || char == "`") {
      quote = char;
      continue;
    }
    if (char == "{" || char == "(" || char == "[") {
      depth++;
      continue;
    }
    if (char == "}" || char == ")" || char == "]") {
      depth--;
      if (depth == 0) {
        if (i != text.length - 1) {
          return null;
        }
        final last = _stripComments(text.substring(start, i)).trim();
        if (last.isNotEmpty) {
          properties.add(last);
        }
      }
      continue;
    }
    if (char == "," && depth == 1) {
      final property = _stripComments(text.substring(start, i)).trim();
      if (property.isNotEmpty) {
        properties.add(property);
      }
      start = i + 1;
    }
  }
  return depth == 0 ? properties : null;
}

String _stripComments(String source) {
  return source
      .split("\n")
      .where((line) => !line.trim().startsWith("//"))
      .join("\n");
}

/// Adds [logicalName] to `reservedDatabases` of a `turso.Functions.turso` /
/// `turso.Functions.tursoToken` call [call] (whose argument is an object literal).
///
/// [call]（引数がオブジェクトリテラルの`turso.Functions.turso` /
/// `turso.Functions.tursoToken`呼び出し）の`reservedDatabases`に[logicalName]を追加します。
String addTursoReservedDatabase(String call, String logicalName) {
  final existing =
      RegExp(r"reservedDatabases\s*:\s*\[([^\]]*)\]").firstMatch(call);
  if (existing != null) {
    final names = RegExp(r'''["']([^"']+)["']''')
        .allMatches(existing.group(1)!)
        .map((match) => match.group(1)!)
        .toList();
    if (names.contains(logicalName)) {
      return call;
    }
    final value = "reservedDatabases: ${jsonEncode([...names, logicalName])}";
    return call.replaceRange(existing.start, existing.end, value);
  }
  if (RegExp(r"\breservedDatabases\b").hasMatch(call)) {
    // A non-literal value is owned by the application.
    return call;
  }
  final open = call.indexOf("(");
  final objectStart = call.indexOf("{", open);
  if (objectStart < 0) {
    return call;
  }
  return call.replaceRange(objectStart + 1, objectStart + 1,
      "\n        reservedDatabases: ${jsonEncode([logicalName])},");
}

/// Loads or generates the server access token of the shared Turso database for [flavor].
///
/// A non-empty `cloudflare.turso.shared.server_access_token` in `katana_secrets.yaml`
/// (a single value or a `{dev:, prod:}` map) takes precedence. Otherwise the value
/// stored in [tursoManagedStatePath] is reused, or a new random token is generated and
/// saved there. The state file is added to `cloudflare/.gitignore`.
///
/// [flavor]用の共用Turso DBのサーバーアクセストークンを読み込むか生成します。
///
/// `katana_secrets.yaml`の`cloudflare.turso.shared.server_access_token`（単一値または
/// `{dev:, prod:}`形式）が空でなければ優先します。それ以外は[tursoManagedStatePath]の値を
/// 再利用し、なければランダムなトークンを生成して保存します。状態ファイルは
/// `cloudflare/.gitignore`に追加します。
Future<String> loadOrCreateTursoServerAccessToken({
  required Map secrets,
  required String flavor,
  String Function()? generate,
}) async {
  final configured = secrets
      .getAsMap("cloudflare")
      .getAsMap("turso")
      .getAsMap("shared")["server_access_token"];
  final configuredValue = configured is Map
      ? configured[flavor]?.toString().trim() ?? ""
      : configured?.toString().trim() ?? "";
  if (configuredValue.isNotEmpty) {
    return configuredValue;
  }
  await _ensureTursoManagedStateIsGitIgnored();
  final file = File(tursoManagedStatePath);
  final state = file.existsSync()
      ? Map<String, dynamic>.from(
          modifize(loadYaml(await file.readAsString())) as Map? ?? {},
        )
      : <String, dynamic>{};
  final tokens = state["shared_server_access_token"] is Map
      ? Map<String, dynamic>.from(state["shared_server_access_token"] as Map)
      : <String, dynamic>{};
  final stored = tokens[flavor]?.toString() ?? "";
  if (stored.isNotEmpty) {
    return stored;
  }
  final token = (generate ?? _generateTursoServerAccessToken)();
  tokens[flavor] = token;
  state["version"] = 1;
  state["shared_server_access_token"] = tokens;
  await file.parent.create(recursive: true);
  await file.writeAsString(YamlWriter().write(state));
  label(
    "Generated $tursoServerAccessTokenSecret ($flavor) and stored it in `$tursoManagedStatePath` (git-ignored).",
  );
  return token;
}

Future<void> _ensureTursoManagedStateIsGitIgnored() async {
  final file = File("cloudflare/.gitignore");
  final lines = file.existsSync() ? await file.readAsLines() : <String>[];
  if (lines.any((line) => line.trim() == "turso.yaml")) {
    return;
  }
  lines.add("turso.yaml");
  await file.writeAsString("${lines.join("\n")}\n");
}

String _generateTursoServerAccessToken() {
  final random = Random.secure();
  return base64UrlEncode(List<int>.generate(32, (_) => random.nextInt(256)))
      .replaceAll("=", "");
}
