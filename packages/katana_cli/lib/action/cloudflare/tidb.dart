// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
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
    final secrets = context.secrets.getAsMap("cloudflare").getAsMap("tidb");
    final input = {
      "command": command,
      "root": Directory.current.path,
      "schemaPath": config.get("schema", "tidb/schema/schema.json"),
      "directory": config.get("migrations", "tidb/migrations"),
      "target": {
        "environment": context.flavorContext!.flavor.name,
        "cluster": config.get("cluster_id", "").toString(),
        "host": config.get("host", "").toString(),
        "database": config.get("database", "").toString(),
        "principal": secrets.get("migration_username", "").toString(),
      },
      "version": version,
      "apply": apply,
      "username": secrets.get("migration_username", ""),
      "password": secrets.get("migration_password", ""),
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

/// WorkerへTiDB接続設定と共通manifestを反映する。DDLは実行しない。
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
    await _applyDirect(context,
        wrangler: context.yaml.getAsMap("bin").get("wrangler", "wrangler"),
        environment: context.flavorContext?.flavor.name ?? "prod");
  }

  bool _validateCloudflareFiles() {
    if (!Directory("cloudflare").existsSync()) {
      error(
        "The directory `cloudflare` does not exist. Enable Cloudflare Workers and execute `katana apply` first.",
      );
      return false;
    }
    if (!File("cloudflare/src/index.ts").existsSync()) {
      error("The file `cloudflare/src/index.ts` does not exist.");
      return false;
    }
    return true;
  }

  Future<void> _applyDirect(
    ExecContext context, {
    required String wrangler,
    required String environment,
  }) async {
    if (!_validateCloudflareFiles()) {
      return;
    }
    final config = context.yaml.getAsMap("cloudflare").getAsMap("tidb");
    final secrets = context.secrets.getAsMap("cloudflare").getAsMap("tidb");
    final host = config.get("host", "").toString();
    final username = secrets.get("username", "").toString();
    final password = secrets.get("password", "").toString();
    if (host.isEmpty || username.isEmpty || password.isEmpty) {
      error("TiDB直結のhost、Worker用username/passwordが必要です。migration用資格情報は流用しません。");
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
    final package = File(
        "cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist/worker.js");
    if (!package.existsSync()) {
      error("直結対応のmasamune_cloudflare_tidbが未導入です。承認済みのpackage導入後に再実行してください。");
      return;
    }
    final index = File("cloudflare/src/index.ts");
    var source = await index.readAsString();
    const statement = 'import tidbSchemaManifest from "./tidb_schema.json";';
    if (!source.contains(statement)) {
      source = "$statement\n$source";
    }
    source = source.replaceAll(
        RegExp(
            r'^import tidbDataServiceManifest from "./tidb_data_service_manifest.json";\r?\n',
            multiLine: true),
        "");
    // 設定生成とsecret投入だけを行い、DBのDDLはmigrateへ分離する。
    await File("cloudflare/src/tidb_schema.json").writeAsString(manifestText);
    await index.writeAsString(source);
    final updated = await applyCloudflareWorkersFunctions(
      alias: "tidb",
      package: "@mathrunet/masamune_cloudflare_tidb",
      functions: {
        "tidb.Functions.tidb":
            "tidb.Functions.tidb({ schemaManifest: tidbSchemaManifest as tidb.SchemaManifest })"
      },
    );
    if (!updated) {
      error("WorkerへのTiDB登録位置を特定できません。");
      return;
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
          value: entry.value);
    }
    label("TiDB直結設定を反映しました。DB適用はkatana migrate、Worker公開はdeployで実行してください。");
  }
}
