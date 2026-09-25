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

Future<void> _runTidbRuntimeProvision({
  required ExecContext context,
  required String environment,
  required String cluster,
  required String host,
  required String database,
  required Map<String, dynamic> state,
  required List<Map<String, String>> tables,
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
  try { console.log(JSON.stringify(await migration.provisionRuntimeUser(JSON.parse(input)))); }
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
    "credentialState": credentials.state,
    "tables": tables,
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
    final schemaPath =
        config.get("schema", "tidb/schema/schema.json").toString();
    if (schemaPath.startsWith("/") ||
        schemaPath.replaceAll("\\", "/").split("/").contains("..")) {
      error("schemaはproject内の相対パスで指定してください。");
      return;
    }
    final schema = File(schemaPath);
    if (!schema.existsSync()) {
      error("共通schemaがありません。katana code generateを実行してください。");
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
    // package・登録位置の不備でruntime userを作成しないよう先に検査する。
    final package = File(
        "cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist/worker.js");
    if (!package.existsSync()) {
      error("直結対応のmasamune_cloudflare_tidbが未導入です。承認済みのpackage導入後に再実行してください。");
      return;
    }
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
    final stored = credentialState
        .getAsMap("cloudflare")
        .getAsMap("tidb")
        .getAsMap("runtime_users")
        .getAsMap(environment);
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
      username = _tidbSecretValue(secrets, "username", environment);
      password = _tidbSecretValue(secrets, "password", environment);
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
        final provisioned = credentialState
            .getAsMap("cloudflare")
            .getAsMap("tidb")
            .getAsMap("runtime_users")
            .getAsMap(environment);
        username = provisioned.get("username", "").toString();
        password = provisioned.get("password", "").toString();
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
