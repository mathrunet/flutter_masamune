// Dart imports:
import "dart:convert";
import "dart:io";

// Package imports:
import "package:yaml/yaml.dart";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/action/cloudflare/tidb_migration_credentials.dart";
import "package:katana_cli/katana_cli.dart";

/// build_runnerが管理するfragmentを統合する。未変更モデルも含め、削除済み入力は除く。
void finalizeTidbSchema(
    {String root = ".", String outputPath = "tidb/schema/schema.json"}) {
  final lib = Directory("$root/lib");
  if (!lib.existsSync()) {
    return;
  }
  final tables = <Map<String, dynamic>>[];
  final seen = <String>{};
  final expectedDirectory = outputPath.replaceAll("\\", "/").split("/")
    ..removeLast();
  for (final entry in lib.listSync(recursive: true, followLinks: false)) {
    if (entry is! File || !entry.path.endsWith(".tidb_schema")) {
      continue;
    }
    final source =
        File(entry.path.replaceFirst(RegExp(r"\.tidb_schema$"), ".dart"));
    if (!source.existsSync()) {
      continue;
    }
    final fragment = jsonDecode(entry.readAsStringSync()) as Map;
    if (fragment["schemaDirPath"] != expectedDirectory.join("/")) {
      throw StateError(
          "TidbSchema.schemaDirPathとcloudflare.tidb.schemaを一致させてください。");
    }
    for (final raw in (fragment["schema"] as Map)["tables"] as List) {
      final table = Map<String, dynamic>.from(raw as Map);
      if (!seen.add("${table["database"]}\u0000${table["table"]}")) {
        throw StateError("TiDB schemaのtable定義が重複しています。");
      }
      tables.add(table);
    }
  }
  final normalized = outputPath.replaceAll("\\", "/");
  if (normalized.startsWith("/") || normalized.split("/").contains("..")) {
    throw ArgumentError("schemaはproject内の相対パスで指定してください。");
  }
  final file = File("$root/$normalized");
  if (tables.isEmpty && !file.existsSync()) {
    return;
  }
  tables.sort((a, b) => "${a["database"]}\u0000${a["table"]}"
      .compareTo("${b["database"]}\u0000${b["table"]}"));
  final schema = <String, dynamic>{"version": "1", "tables": tables};
  var hash = BigInt.parse("cbf29ce484222325", radix: 16);
  for (final byte in utf8.encode(jsonEncode(schema))) {
    hash =
        ((hash ^ BigInt.from(byte)) * BigInt.parse("100000001b3", radix: 16)) &
            BigInt.parse("ffffffffffffffff", radix: 16);
  }
  schema["sourceHash"] = "fnv1a64:${hash.toRadixString(16).padLeft(16, "0")}";
  file.parent.createSync(recursive: true);
  final temporary = File("${file.path}.tmp");
  temporary.writeAsStringSync(
      "${const JsonEncoder.withIndent("  ").convert(schema)}\n");
  temporary.renameSync(file.path);
}

/// TiDBのschema差分と適用を管理する。katana applyからDBを変更しない。
class TidbMigrateCliCommand extends CliCommand {
  /// migrationコマンド。
  const TidbMigrateCliCommand();

  @override
  String get description =>
      "TiDB migrationのstatus/diff/generate/apply/mark。applyとmarkは既定でdry-runです。";

  @override
  String get example =>
      "katana migrate <status|diff|generate|apply|mark> --flavor <dev|prod> [--version 日時_名前] [--apply]";

  @override
  Future<void> exec(ExecContext context) async {
    final arguments = context.args.skip(1).toList();
    if (arguments.isEmpty ||
        !{"status", "diff", "generate", "apply", "mark"}
            .contains(arguments.first)) {
      error(example);
      return;
    }
    final command = arguments.first;
    String? version;
    var apply = false;
    for (var i = 1; i < arguments.length; i++) {
      final argument = arguments[i];
      if (argument == "--apply" && !apply) {
        apply = true;
      } else if (argument == "--version" &&
          version == null &&
          i + 1 < arguments.length) {
        version = arguments[++i];
      } else if (argument.startsWith("--version=") && version == null) {
        version = argument.substring("--version=".length);
      } else if (argument == "--flavor" && i + 1 < arguments.length) {
        i++;
      } else if (argument.startsWith("--flavor=")) {
        continue;
      } else {
        error("不正または重複したmigration引数です。");
        return;
      }
    }
    if (context.flavorContext?.explicit != true) {
      error("migrationには--flavorの明示が必要です。");
      return;
    }
    final config = context.yaml.getAsMap("cloudflare").getAsMap("tidb");
    if (config.isEmpty) {
      error(
          "katana.yamlの[cloudflare]->[tidb]が見つかりません。プロジェクトルートでkatana migrateを実行してください。");
      return;
    }
    final secrets = context.secrets.getAsMap("cloudflare").getAsMap("tidb");
    final environment = context.flavorContext!.flavor.name;
    final rawHost = (config["host"] ?? "");
    final host = rawHost is Map
        ? rawHost[environment]?.toString() ?? ""
        : rawHost.toString();
    final rawCluster = (config["cluster_id"] ?? "");
    final cluster = rawCluster is Map
        ? rawCluster[environment]?.toString() ?? ""
        : rawCluster.toString();
    final rawDatabase = (config["database"] ?? "");
    final database = rawDatabase is Map
        ? rawDatabase[environment]?.toString() ?? ""
        : rawDatabase.toString();
    if (!_reportTidbEnvironmentLayout(context)) {
      return;
    }
    final credentials = await resolveTidbMigrationCredentials(
      environment: environment,
      cluster: cluster,
      host: host,
      database: database,
      node: context.yaml.getAsMap("bin").get("node", "node").toString(),
      legacySecrets: Map<String, dynamic>.from(secrets),
      publicKey: Platform.environment["TIDBCLOUD_PUBLIC_KEY"] ??
          _tidbApiKeyValue(
              Map<String, dynamic>.from(secrets), "public_key", environment),
      privateKey: Platform.environment["TIDBCLOUD_PRIVATE_KEY"] ??
          _tidbApiKeyValue(
              Map<String, dynamic>.from(secrets), "private_key", environment),
      authMode: _tidbEnvironmentSetting(config, "migration_auth", environment,
          fallback: "api_key"),
      oauthProfile: _tidbEnvironmentSetting(
          config, "migration_auth_profile", environment,
          fallback: "default"),
      allowProvision: false,
    );
    final input = {
      "command": command,
      "root": Directory.current.path,
      "schemaPath": config.get("schema", "tidb/schema/schema.json"),
      "directory": config.get("migrations", "tidb/migrations"),
      "target": {
        "environment": environment,
        "cluster": cluster,
        "host": host,
        "database": database,
        "principal": credentials.username,
      },
      "version": version,
      "apply": apply,
      "username": credentials.username,
      "password": credentials.password,
    };
    // node_modulesの既存packageを使い、暗黙のinstallやnpx取得をしない。
    final node = context.yaml.getAsMap("bin").get("node", "node");
    const script =
        'require(require.resolve("@mathrunet/masamune_cloudflare_tidb/dist/migrate.js"))';
    // requireだけではmainが起動しないためrunMigrateを明示呼び出しする。
    final process = await Process.start(
        node,
        [
          "-e",
          '''
const migration = $script;
let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", chunk => { input += chunk; });
process.stdin.on("end", async () => {
  try { console.log(JSON.stringify(await migration.runMigrate(JSON.parse(input)))); }
  catch (error) { console.error(error.message); process.exitCode = 1; }
});
'''
        ],
        workingDirectory: "cloudflare");
    final output = process.stdout.transform(utf8.decoder).join();
    final failure = process.stderr.transform(utf8.decoder).join();
    process.stdin.write(jsonEncode(input));
    await process.stdin.close();
    final status = await process.exitCode;
    final outputText = await output;
    final failureText = await failure;
    if (status != 0) {
      error(failureText.trim());
      return;
    }
    stdout.write(outputText);
  }
}

Map<String, dynamic> _tidbPlainMap(Map value) => value.map(
      (key, value) => MapEntry(key.toString(), _tidbPlainValue(value)),
    );

Object? _tidbPlainValue(Object? value) {
  if (value is Map) {
    return _tidbPlainMap(value);
  }
  if (value is List) {
    return value.map(_tidbPlainValue).toList();
  }
  return value;
}

String _tidbSecretValue(
    Map<String, dynamic> secrets, String key, String environment) {
  final value = secrets[key] ?? "";
  if (value is Map) {
    return value[environment]?.toString() ?? "";
  }
  return value.toString();
}

/// 管理APIキーは[cloudflare]->[tidb]直下を正とし、旧テンプレの[management_api]配下も読む。
String _tidbApiKeyValue(
    Map<String, dynamic> secrets, String key, String environment) {
  final direct = _tidbSecretValue(secrets, key, environment);
  if (direct.isNotEmpty) {
    return direct;
  }
  final legacy = secrets["management_api"];
  if (legacy is Map) {
    return _tidbSecretValue(
        Map<String, dynamic>.from(legacy), key, environment);
  }
  return "";
}

String _tidbEnvironmentSetting(
    Map<String, dynamic> config, String key, String environment,
    {required String fallback}) {
  final value = config[key] ?? fallback;
  if (value is Map) {
    return value[environment]?.toString() ?? fallback;
  }
  return value.toString();
}

/// dev/prodのTiDB配置を検査した結果。
class TidbEnvironmentLayoutResult {
  /// 検査結果を作成する。
  const TidbEnvironmentLayoutResult({
    this.warnings = const [],
    this.error,
  });

  /// 処理は続行するが利用者へ知らせる内容。
  final List<String> warnings;

  /// 処理を止める内容。
  final String? error;
}

/// dev/prodが1つのclusterを共有し、databaseを`dev_<db>` / `<db>`で分ける標準構成かを検査する。
///
/// 別clusterの既存構成は警告に留め、同一clusterで同じdatabaseを使う構成だけを拒否する。
TidbEnvironmentLayoutResult validateTidbEnvironmentLayout({
  required String devCluster,
  required String prodCluster,
  required String devDatabase,
  required String prodDatabase,
}) {
  if (devCluster.isEmpty || prodCluster.isEmpty) {
    return const TidbEnvironmentLayoutResult();
  }
  if (devCluster != prodCluster) {
    return const TidbEnvironmentLayoutResult(warnings: [
      "Warning: TiDBのdevとprodが別のclusterです。標準構成は1つのclusterを共有し、 "
          "databaseを`dev_<db>` / `<db>`で分ける形です。既存の構成はそのまま動作します。",
    ]);
  }
  if (devDatabase.isEmpty || prodDatabase.isEmpty) {
    return const TidbEnvironmentLayoutResult();
  }
  if (devDatabase == prodDatabase) {
    return TidbEnvironmentLayoutResult(
      error: "TiDBのdevとprodが同じcluster・同じdatabase `$prodDatabase` を指しています。 "
          "devのdatabaseを`dev_$prodDatabase`にしてください。",
    );
  }
  if (devDatabase != "dev_$prodDatabase") {
    return TidbEnvironmentLayoutResult(warnings: [
      "Warning: TiDBのdev database `$devDatabase` が`dev_$prodDatabase`ではありません。 "
          "Workerは`FLAVOR=dev`で`dev_`を付けるため、schemaのdatabase名と一致するか確認してください。",
    ]);
  }
  return const TidbEnvironmentLayoutResult();
}

TidbEnvironmentLayoutResult _checkTidbEnvironmentLayout(ExecContext context) {
  final config = context.yaml.getAsMap("cloudflare").getAsMap("tidb");
  // 単一値のcluster_idは両環境で共有、単一値のdatabaseは環境を分けない設定として扱う。
  String read(String key, KatanaFlavor flavor, {required bool scalarShared}) {
    final flavorContext = context.flavorContext;
    final isEnvironmentMap = flavorContext != null
        ? flavorContext.hasEnvironmentMap(["cloudflare", "tidb", key])
        : config[key] is Map;
    if (!isEnvironmentMap && !scalarShared) {
      return "";
    }
    final value = flavorContext != null
        ? flavorContext.yamlValue(["cloudflare", "tidb", key], flavor: flavor)
        : config[key];
    if (value is Map) {
      return value[flavor.name]?.toString() ?? "";
    }
    return value?.toString() ?? "";
  }

  return validateTidbEnvironmentLayout(
    devCluster: read("cluster_id", KatanaFlavor.dev, scalarShared: true),
    prodCluster: read("cluster_id", KatanaFlavor.prod, scalarShared: true),
    devDatabase: read("database", KatanaFlavor.dev, scalarShared: false),
    prodDatabase: read("database", KatanaFlavor.prod, scalarShared: false),
  );
}

/// TiDB配置の警告を表示し、処理を止める必要があればエラーを表示して`false`を返す。
bool _reportTidbEnvironmentLayout(ExecContext context) {
  final result = _checkTidbEnvironmentLayout(context);
  for (final warning in result.warnings) {
    label(warning);
  }
  if (result.error != null) {
    error(result.error!);
    return false;
  }
  return true;
}

Future<Map<String, dynamic>> _loadTidbCredentialState() async {
  final file = File("cloudflare/tidb.yaml");
  if (!await file.exists()) {
    return <String, dynamic>{};
  }
  final value = loadYaml(await file.readAsString());
  if (value is! Map) {
    throw const FormatException("cloudflare/tidb.yamlの形式が不正です。");
  }
  return _tidbPlainMap(value);
}

/// Selects only the runtime identity for the requested cluster.
Map<String, dynamic> selectTidbRuntimeCredentials(
    Map<String, dynamic> state, String environment, String cluster) {
  final tidb = state.getAsMap("cloudflare").getAsMap("tidb");
  final legacyCluster = tidb
      .getAsMap("migration_users")
      .getAsMap(environment)
      .get("cluster_id", "")
      .toString();
  final clusterCredentials = tidb
      .getAsMap("runtime_users_by_cluster")
      .getAsMap(environment)
      .getAsMap(cluster);
  if (clusterCredentials.isNotEmpty ||
      (legacyCluster.isNotEmpty && legacyCluster != cluster)) {
    return clusterCredentials;
  }
  return tidb.getAsMap("runtime_users").getAsMap(environment);
}

const _tidbRuntimeTablePrivileges = ["SELECT", "INSERT", "UPDATE", "DELETE"];
final _tidbIdentifierPattern = RegExp(r"^[A-Za-z_][A-Za-z0-9_]{0,63}$");

/// Resolves `cloudflare.tidb.additional_grants` in `katana.yaml` for [environment].
///
/// Each entry grants the runtime SQL user exactly `privileges` (a non-empty subset of
/// SELECT/INSERT/UPDATE/DELETE) on `table`, a table outside the schema manifest.
/// `database` is optional and accepts a string or a `dev`/`prod` map; when omitted it resolves
/// to [database], the database of the current environment. The whole list may also be a
/// `dev`/`prod` map of lists. Tables already in [manifestTables] are rejected.
/// Throws a [FormatException] when the declaration is invalid.
///
/// `katana.yaml`の`cloudflare.tidb.additional_grants`を[environment]向けに解決します。
/// 各要素はschema manifest外の`table`へ、runtime SQL userが持つ権限`privileges`
/// （SELECT/INSERT/UPDATE/DELETEから選ぶ空でない集合）を宣言します。
/// `database`は省略可能で、文字列または`dev`/`prod`のmapで指定します。省略時は[database]を使います。
List<Map<String, Object>> resolveTidbAdditionalGrants(
  Object? raw, {
  required String environment,
  required String database,
  Iterable<Map<String, String>> manifestTables = const [],
}) {
  var value = raw;
  if (value is Map && (value.containsKey("dev") || value.containsKey("prod"))) {
    value = value[environment];
  }
  if (value == null) {
    return const [];
  }
  if (value is! List) {
    throw const FormatException(
        "[cloudflare]->[tidb]->[additional_grants]はtable・privilegesを持つ要素のリストで指定してください。");
  }
  final manifestKeys = manifestTables
      .map((table) =>
          "${table["database"]}\u0000${table["table"]}".toLowerCase())
      .toSet();
  final seen = <String>{};
  final grants = <Map<String, Object>>[];
  for (final entry in value) {
    if (entry is! Map) {
      throw const FormatException(
          "[cloudflare]->[tidb]->[additional_grants]の要素はtable・privilegesを持つmapで指定してください。");
    }
    final unknownKeys = entry.keys
        .map((key) => key.toString())
        .where(
            (key) => !const {"table", "database", "privileges"}.contains(key))
        .toList();
    if (unknownKeys.isNotEmpty) {
      throw FormatException(
          "[cloudflare]->[tidb]->[additional_grants]に未対応のキーがあります: ${unknownKeys.join(", ")}");
    }
    final table = entry["table"]?.toString() ?? "";
    final rawDatabase = entry["database"];
    final resolvedDatabase = rawDatabase == null
        ? database
        : rawDatabase is Map
            ? rawDatabase[environment]?.toString() ?? ""
            : rawDatabase.toString();
    if (!_tidbIdentifierPattern.hasMatch(table) ||
        !_tidbIdentifierPattern.hasMatch(resolvedDatabase)) {
      throw FormatException(
          "[cloudflare]->[tidb]->[additional_grants]のdatabase/tableが不正です: $resolvedDatabase.$table");
    }
    final name = "$resolvedDatabase.$table";
    final rawPrivileges = entry["privileges"];
    if (rawPrivileges is! List ||
        rawPrivileges.isEmpty ||
        rawPrivileges.any((privilege) => privilege is! String)) {
      throw FormatException(
          "[cloudflare]->[tidb]->[additional_grants]のprivilegesは空でないリストで指定してください: $name");
    }
    final requested = rawPrivileges
        .map((privilege) => privilege.toString().trim().toUpperCase())
        .toSet();
    if (!requested.every(_tidbRuntimeTablePrivileges.contains)) {
      throw FormatException(
          "[cloudflare]->[tidb]->[additional_grants]のprivilegesはSELECT/INSERT/UPDATE/DELETEから指定してください: $name");
    }
    final key = "$resolvedDatabase\u0000$table".toLowerCase();
    if (manifestKeys.contains(key)) {
      throw FormatException(
          "[cloudflare]->[tidb]->[additional_grants]にschema manifestのtableは指定できません: $name");
    }
    if (!seen.add(key)) {
      throw FormatException(
          "[cloudflare]->[tidb]->[additional_grants]のtableが重複しています: $name");
    }
    grants.add({
      "database": resolvedDatabase,
      "table": table,
      "privileges":
          _tidbRuntimeTablePrivileges.where(requested.contains).toList(),
    });
  }
  return grants;
}

Future<void> _runTidbRuntimeProvision({
  required ExecContext context,
  required String environment,
  required String cluster,
  required String host,
  required String database,
  required Map<String, dynamic> state,
  required List<Map<String, String>> tables,
  required List<Map<String, Object>> additionalGrants,
  required Map<String, dynamic> secrets,
  required Map<String, dynamic> existing,
  required String authMode,
  required String oauthProfile,
}) async {
  final node = context.yaml.getAsMap("bin").get("node", "node").toString();
  final credentials = await resolveTidbMigrationCredentials(
    environment: environment,
    cluster: cluster,
    host: host,
    database: database,
    node: node,
    legacySecrets: secrets,
    publicKey: Platform.environment["TIDBCLOUD_PUBLIC_KEY"] ??
        _tidbApiKeyValue(secrets, "public_key", environment),
    privateKey: Platform.environment["TIDBCLOUD_PRIVATE_KEY"] ??
        _tidbApiKeyValue(secrets, "private_key", environment),
    authMode: authMode,
    oauthProfile: oauthProfile,
  );
  const script =
      'require(require.resolve("@mathrunet/masamune_cloudflare_tidb/dist/migrate.js"))';
  final process = await Process.start(
    node,
    [
      "-e",
      '''
const migration = $script;
let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", chunk => { input += chunk; if (input.length > 1048576) process.exit(2); });
process.stdin.on("end", async () => {
  try {
    const request = JSON.parse(input);
    if (request.additionalGrants && migration.supportsRuntimeUserAdditionalGrants !== true) {
      throw new Error("additional_grantsには新しい@mathrunet/masamune_cloudflare_tidbが必要です。cloudflareでpackageを更新してください。");
    }
    console.log(JSON.stringify(await migration.provisionRuntimeUser(request)));
  }
  catch (error) { console.error(error instanceof Error ? error.message : "TiDB runtime userの準備に失敗しました。"); process.exitCode = 1; }
});
'''
    ],
    workingDirectory: "cloudflare",
  );
  final output = process.stdout.transform(utf8.decoder).join();
  final failure = process.stderr.transform(utf8.decoder).join();
  process.stdin.write(jsonEncode({
    "root": Directory.current.path,
    "host": host,
    "database": database,
    "migrationUsername": credentials.username,
    "migrationPassword": credentials.password,
    "runtimeUsername": existing.get("username", "").toString(),
    "runtimePassword": existing.get("password", "").toString(),
    "runtimeRole": existing.get("role", "").toString(),
    "environment": environment,
    "cluster": cluster,
    "credentialState": credentials.state,
    "tables": tables,
    if (additionalGrants.isNotEmpty) "additionalGrants": additionalGrants,
  }));
  await process.stdin.close();
  final status = await process.exitCode;
  final failureText = await failure;
  if (status != 0) {
    throw StateError(failureText.trim().isEmpty
        ? "TiDB runtime userの準備に失敗しました。"
        : failureText.trim());
  }
  // stdoutには非秘密の状態だけが返るため、内容はログへ出さず破棄する。
  await output;
}

/// Removes the TiDB function registration and its now-unused imports from a Worker entrypoint [source].
///
/// Workerエントリ[source]からTiDB関数の登録と、不要になったimportを除去します。
String removeTidbFromCloudflareEntry(String source) {
  var updated = CloudflareSourceUtils.replaceFunctionCall(
      source, "tidb.Functions.tidb", "");
  final manifestImport = RegExp(
      r'^import tidbSchemaManifest from "[^"]+";[ \t]*\r?\n?',
      multiLine: true);
  if (!updated.replaceAll(manifestImport, "").contains("tidbSchemaManifest")) {
    updated = updated.replaceAll(manifestImport, "");
  }
  final tidbImport = RegExp(
      r'^import \* as tidb from "@mathrunet/masamune_cloudflare_tidb";[ \t]*\r?\n?',
      multiLine: true);
  if (!updated.replaceAll(tidbImport, "").contains("tidb.")) {
    updated = updated.replaceAll(tidbImport, "");
  }
  return updated;
}

/// WorkerへTiDB接続設定と共通manifestを反映する。DDLはmigrateへ分離する。
class CloudflareTidbCliAction extends CliCommand with CliActionMixin {
  /// TiDB接続設定。
  const CloudflareTidbCliAction();
  @override
  String get description => "Cloudflare WorkersのTiDB直結設定を構成します。";
  @override
  bool checkEnabled(ExecContext context) =>
      context.yaml.getAsMap("cloudflare").getAsMap("tidb").get("enable", false);
  @override
  Future<void> exec(ExecContext context) async {
    final config = context.yaml.getAsMap("cloudflare").getAsMap("tidb");
    final configuredDatabase = config["database"];
    final configuredHost = config["host"];
    final configuredCluster = config["cluster_id"];
    if ((configuredDatabase is Map ||
            configuredHost is Map ||
            configuredCluster is Map) &&
        context.flavorContext?.explicit != true) {
      error(
          "TiDBのdatabaseが環境別設定です。対象を明示して katana apply --flavor <dev|prod> を実行してください。");
      return;
    }
    await _applyDirect(context,
        wrangler: context.yaml.getAsMap("bin").get("wrangler", "wrangler"),
        environment: context.flavorContext?.flavor.name ?? "prod");
  }

  bool _validateCloudflareFiles({required bool regionEnabled}) {
    if (!Directory("cloudflare").existsSync()) {
      error(
        "The directory `cloudflare` does not exist. Enable Cloudflare Workers and execute `katana apply` first.",
      );
      return false;
    }
    final entry =
        regionEnabled ? cloudflareRegionEntryPath : cloudflareEdgeEntryPath;
    if (!File(entry).existsSync()) {
      error(regionEnabled
          ? "The file `$entry` does not exist. Run `katana apply` with [cloudflare]->[workers]->[region]->[enable] set to `true` to generate the region Worker."
          : "The file `$entry` does not exist.");
      return false;
    }
    if (regionEnabled &&
        !File("cloudflare/$cloudflareRegionWranglerConfig").existsSync()) {
      error(
          "The file `cloudflare/$cloudflareRegionWranglerConfig` does not exist. Run `katana apply` to generate the region Worker.");
      return false;
    }
    return true;
  }

  Future<void> _applyDirect(
    ExecContext context, {
    required String wrangler,
    required String environment,
  }) async {
    // TiDB runs on the region Worker when it is enabled, otherwise on the edge Worker.
    final regionEnabled = isCloudflareRegionWorkerEnabled(context.yaml);
    if (!_validateCloudflareFiles(regionEnabled: regionEnabled)) {
      return;
    }
    final config = context.yaml.getAsMap("cloudflare").getAsMap("tidb");
    final secrets = context.secrets.getAsMap("cloudflare").getAsMap("tidb");
    final rawHost = (config["host"] ?? "");
    final rawDatabase = (config["database"] ?? "");
    if (environment != "dev" &&
        environment != "prod" &&
        (rawHost is Map || rawDatabase is Map)) {
      label("TiDBの環境別設定はdev/prodのみです。$environmentではTiDB secretsを変更しません。");
      return;
    }
    final host = rawHost is Map
        ? rawHost[environment]?.toString() ?? ""
        : rawHost.toString();
    final database = rawDatabase is Map
        ? rawDatabase[environment]?.toString() ?? ""
        : rawDatabase.toString();
    final rawCluster = (config["cluster_id"] ?? "");
    final cluster = rawCluster is Map
        ? rawCluster[environment]?.toString() ?? ""
        : rawCluster.toString();
    if (host.isEmpty || database.isEmpty) {
      error("TiDB直結のhostとdatabaseが必要です。");
      return;
    }
    if (!_reportTidbEnvironmentLayout(context)) {
      return;
    }
    final schemaPath =
        config.get("schema", "tidb/schema/schema.json").toString();
    if (schemaPath.startsWith("/") ||
        schemaPath.replaceAll("\\", "/").split("/").contains("..")) {
      error("schemaはproject内の相対パスで指定してください。");
      return;
    }
    // 最初のapplyではModelとschemaが未生成でも、生成に必要な依存だけを導入する。
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter").toString();
    await addFlutterImport(
      const ["masamune_model_tidb", "masamune_model_tidb_annotation"],
      flutterCommand: flutter,
    );
    await addFlutterImport(
      const ["masamune_model_tidb_builder"],
      development: true,
      flutterCommand: flutter,
    );
    await installMissingCloudflarePackages(
      npm: bin.get("npm", "npm").toString(),
      packages: const ["@mathrunet/masamune_cloudflare_tidb"],
    );
    final workerModule = File(
        "cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist/worker.js");
    if (!workerModule.existsSync()) {
      await command(
        "Install TiDB Workers direct adapter.",
        [
          bin.get("npm", "npm").toString(),
          "install",
          "@mathrunet/masamune_cloudflare_tidb@^3.7.5"
        ],
        workingDirectory: "cloudflare",
        catchError: true,
        failOnStderr: false,
      );
      if (!workerModule.existsSync()) {
        throw StateError(
            "TiDB直結対応のmasamune_cloudflare_tidb（3.7.5以上）のworker.jsがありません。package-lockと導入実体を確認してください。");
      }
    }
    final schema = File(schemaPath);
    if (!schema.existsSync()) {
      label(
          "TiDBの依存を反映しました。Modelを定義してkatana code generateで共通schemaを生成後、再度katana apply --only tidbを実行してください。");
      return;
    }
    final manifestText = await schema.readAsString();
    final manifest = jsonDecode(manifestText);
    if (manifest is! Map ||
        manifest["version"] != "1" ||
        manifest["tables"] is! List) {
      error("共通schemaの形式が不正です。");
      return;
    }
    final tablesByKey = <String, Map<String, String>>{};
    for (final raw in manifest["tables"] as List) {
      if (raw is! Map ||
          raw["database"] is! String ||
          raw["table"] is! String) {
        error("共通schemaのtable定義が不正です。");
        return;
      }
      if (raw["database"] == database) {
        final table = <String, String>{
          "database": raw["database"].toString(),
          "table": raw["table"].toString(),
        };
        tablesByKey["${table["database"]}\u0000${table["table"]}"] = table;
      }
    }
    if (tablesByKey.isEmpty) {
      error(
          "共通schemaに対象databaseのtableがありません。katana code generateとkatana migrate generateを確認してください。");
      return;
    }
    // Validate extra table grants before creating SQL users or touching Worker files.
    final List<Map<String, Object>> additionalGrants;
    try {
      additionalGrants = resolveTidbAdditionalGrants(
        config["additional_grants"],
        environment: environment,
        database: database,
        manifestTables: tablesByKey.values,
      );
    } on FormatException catch (e) {
      error(e.message);
      return;
    }
    // package・登録位置の不備でruntime userを作成しないよう先に検査する。
    final index = File(
        regionEnabled ? cloudflareRegionEntryPath : cloudflareEdgeEntryPath);
    var source = await index.readAsString();
    const statement = 'import tidbSchemaManifest from "./tidb_schema.json";';
    // 既存の`tidbSchemaManifest` importは参照先だけを生成物へ差し替え、重複宣言を作らない。
    final existingManifestImport = RegExp(
      r'^import tidbSchemaManifest from "[^"]+";[ \t]*$',
      multiLine: true,
    ).firstMatch(source);
    if (existingManifestImport != null) {
      source = source.replaceRange(
          existingManifestImport.start, existingManifestImport.end, statement);
    } else if (!source.contains(statement)) {
      source = "$statement\n$source";
    }
    source = CloudflareSourceUtils.ensureImport(source,
        alias: "tidb", package: "@mathrunet/masamune_cloudflare_tidb");
    const functionName = "tidb.Functions.tidb";
    final arguments =
        CloudflareSourceUtils.functionArguments(source, functionName)
            ?.replaceFirst(RegExp(r",\s*$"), "");
    const schemaOption =
        "schemaManifest: tidbSchemaManifest as tidb.SchemaManifest";
    // 既存のrules・prefixなどを保持し、manifestだけを生成物へ同期する。
    final hasSchemaOption = RegExp(
            r"schemaManifest\s*:\s*tidbSchemaManifest\s+as\s+tidb\.SchemaManifest")
        .hasMatch(arguments ?? "");
    final options = arguments == null || arguments.isEmpty
        ? "{ $schemaOption }"
        : hasSchemaOption
            ? arguments
            : "{ ...($arguments), $schemaOption }";
    final replacement = "$functionName($options),";
    final hasCall = arguments != null;
    source = CloudflareSourceUtils.replaceFunctionCall(
        source, functionName, replacement);
    final preparedSource = CloudflareSourceUtils.insertDeployFunctions(
        source, hasCall ? const [] : [replacement]);
    if (preparedSource == null) {
      error("WorkerへのTiDB登録位置を特定できません。");
      return;
    }
    Map<String, dynamic> credentialState;
    try {
      credentialState = await _loadTidbCredentialState();
    } on FormatException catch (e) {
      error(e.message);
      return;
    }
    final stored =
        selectTidbRuntimeCredentials(credentialState, environment, cluster);
    var username = stored.get("username", "").toString();
    var password = stored.get("password", "").toString();
    final role = stored.get("role", "").toString();
    if (username.isNotEmpty && password.isNotEmpty && role.isNotEmpty) {
      try {
        await _runTidbRuntimeProvision(
          context: context,
          environment: environment,
          cluster: cluster,
          host: host,
          database: database,
          state: credentialState,
          tables: tablesByKey.values.toList(),
          additionalGrants: additionalGrants,
          secrets: secrets,
          existing: stored,
          authMode: _tidbEnvironmentSetting(
              config, "migration_auth", environment,
              fallback: "api_key"),
          oauthProfile: _tidbEnvironmentSetting(
              config, "migration_auth_profile", environment,
              fallback: "default"),
        );
      } on StateError catch (e) {
        error(e.message);
        return;
      }
    } else {
      // Backward compatibility: keep using an already provisioned credentials pair from katana_secrets.yaml.
      final legacyCluster = credentialState
          .getAsMap("cloudflare")
          .getAsMap("tidb")
          .getAsMap("migration_users")
          .getAsMap(environment)
          .get("cluster_id", "")
          .toString();
      final useLegacySecrets =
          legacyCluster.isEmpty || legacyCluster == cluster;
      username = useLegacySecrets
          ? _tidbSecretValue(secrets, "username", environment)
          : "";
      password = useLegacySecrets
          ? _tidbSecretValue(secrets, "password", environment)
          : "";
      if (username.isEmpty || password.isEmpty) {
        try {
          await _runTidbRuntimeProvision(
            context: context,
            environment: environment,
            cluster: cluster,
            host: host,
            database: database,
            state: credentialState,
            tables: tablesByKey.values.toList(),
            additionalGrants: additionalGrants,
            secrets: secrets,
            existing: const <String, dynamic>{},
            authMode: _tidbEnvironmentSetting(
                config, "migration_auth", environment,
                fallback: "api_key"),
            oauthProfile: _tidbEnvironmentSetting(
                config, "migration_auth_profile", environment,
                fallback: "default"),
          );
          credentialState = await _loadTidbCredentialState();
        } on StateError catch (e) {
          error(e.message);
          return;
        } on FormatException catch (e) {
          error(e.message);
          return;
        }
        final provisioned =
            selectTidbRuntimeCredentials(credentialState, environment, cluster);
        username = provisioned.get("username", "").toString();
        password = provisioned.get("password", "").toString();
      } else if (additionalGrants.isNotEmpty) {
        label(
            "Warning: katana_secrets.yamlの互換用TiDB資格情報を使うため、[additional_grants]は適用されません。権限は手動で付与してください。");
      }
    }
    if (username.isEmpty || password.isEmpty) {
      error(
          "cloudflare/tidb.yamlまたは互換用katana_secrets.yamlからruntime user資格情報を取得できません。");
      return;
    }
    // ローカルの前提がすべて揃った後で、準備済みの設定を書き込む。
    await File("cloudflare/src/tidb_schema.json").writeAsString(manifestText);
    await index.writeAsString(preparedSource);
    if (regionEnabled) {
      // Move the TiDB registration from the edge Worker to the region Worker.
      final edge = File(cloudflareEdgeEntryPath);
      if (edge.existsSync()) {
        final edgeSource = await edge.readAsString();
        if (CloudflareSourceUtils.containsFunctionCall(
            edgeSource, functionName)) {
          await edge.writeAsString(removeTidbFromCloudflareEntry(edgeSource));
          label(
              "Removed `$functionName` from `$cloudflareEdgeEntryPath` because TiDB is registered in `$cloudflareRegionEntryPath`.");
        }
      }
    }
    for (final entry in {
      "TIDB_HOST": host,
      "TIDB_USERNAME": username,
      "TIDB_PASSWORD": password
    }.entries) {
      await putWranglerSecret(
          wrangler: wrangler,
          environment: environment,
          name: entry.key,
          value: entry.value,
          config: regionEnabled ? cloudflareRegionWranglerConfig : null);
    }
    if (regionEnabled && !isLocalApply) {
      await _checkEdgeTidbSecrets(wrangler: wrangler, environment: environment);
    }
    label("TiDB直結設定を反映しました。DB適用はkatana migrate、Worker公開はdeployで実行してください。");
  }

  /// Shows guidance when TiDB secrets remain in the edge Worker after moving TiDB to the region Worker.
  ///
  /// TiDBをregion Workerへ移した後、edge WorkerにTiDBのsecretが残っている場合に案内を表示します。
  Future<void> _checkEdgeTidbSecrets({
    required String wrangler,
    required String environment,
  }) async {
    try {
      final result = await Process.run(
        wrangler,
        ["secret", "list", "--env", environment],
        workingDirectory: "cloudflare",
        runInShell: true,
      );
      if (result.exitCode != 0) {
        return;
      }
      final names = RegExp(r"\bTIDB_[A-Z0-9_]+\b")
          .allMatches(result.stdout.toString())
          .map((match) => match.group(0)!)
          .toSet()
          .toList()
        ..sort();
      if (names.isEmpty) {
        return;
      }
      final usages = findEdgeTidbUsages();
      if (usages.isEmpty) {
        label(
          "The edge Worker still has TiDB secrets (${names.join(", ")}) that are no longer used. Remove them with `wrangler secret delete <NAME> --env $environment` in `cloudflare`. edge Workerに使用されなくなったTiDBのsecret（${names.join(", ")}）が残っています。`cloudflare`で`wrangler secret delete <NAME> --env $environment`を実行して削除してください。",
        );
      } else {
        label(
          "WARNING: The edge Worker still has TiDB secrets (${names.join(", ")}) and custom Workers in the edge Worker still use TiDB (${usages.join(", ")}). Keep the secrets until they are moved to `$cloudflareRegionEntryPath`. edge WorkerにTiDBのsecret（${names.join(", ")}）が残っており、edgeの独自Workerがまだ使用中です（${usages.join(", ")}）。`$cloudflareRegionEntryPath`へ移すまでsecretは削除しないでください。",
        );
      }
    } catch (_) {
      // The check is informational only and must not change the result.
    }
  }
}
