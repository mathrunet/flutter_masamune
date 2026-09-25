// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/action/cloudflare/durable_object.dart";
import "package:katana_cli/action/cloudflare/tidb.dart";
import "package:katana_cli/katana_cli.dart";

/// build_runnerが管理するfragmentを統合する。未変更モデルも含め、削除済み入力は除く。
void finalizeD1Schema(
    {String root = ".", String outputPath = "d1/schema/schema.json"}) {
  final lib = Directory("$root/lib");
  if (!lib.existsSync()) {
    return;
  }
  final tables = <Map<String, dynamic>>[];
  final seen = <String>{};
  final expectedDirectory = outputPath.replaceAll("\\", "/").split("/")
    ..removeLast();
  for (final entry in lib.listSync(recursive: true, followLinks: false)) {
    if (entry is! File || !entry.path.endsWith(".d1_schema")) {
      continue;
    }
    final source =
        File(entry.path.replaceFirst(RegExp(r"\.d1_schema$"), ".dart"));
    if (!source.existsSync()) {
      continue;
    }
    final fragment = jsonDecode(entry.readAsStringSync()) as Map;
    if (fragment["schemaDirPath"] != expectedDirectory.join("/")) {
      throw StateError(
          "D1Schema.schemaDirPathとcloudflare.d1.schemaを一致させてください。");
    }
    for (final raw in (fragment["schema"] as Map)["tables"] as List) {
      final table = Map<String, dynamic>.from(raw as Map);
      if (!seen.add("${table["database"]}\u0000${table["table"]}")) {
        throw StateError("D1 schemaのtable定義が重複しています。");
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
  final schema = <String, dynamic>{
    "version": "1",
    "dialect": "sqlite",
    "tables": tables
  };
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

/// TiDB/D1のmigrationを振り分ける。
class ModelMigrateCliCommand extends CliCommand {
  /// migrationの入口。
  const ModelMigrateCliCommand();
  @override
  String get description =>
      "schema差分と適用。--backend d1|do|tidb。apply/markは既定でdry-runです。";
  @override
  String get example =>
      "katana migrate <status|diff|generate|apply|mark> --backend d1 --flavor dev [--version 日時_名前] [--local] [--apply]";
  @override
  Future<void> exec(ExecContext context) async {
    final args = context.args.toList();
    var backend = "tidb";
    final index = args.indexOf("--backend");
    if (index >= 0) {
      if (index + 1 >= args.length) {
        error(example);
        return;
      }
      backend = args[index + 1];
      args.removeRange(index, index + 2);
    }
    if (backend == "do") {
      await const DurableObjectMigrateCliCommand().exec(ExecContext(
          yaml: context.yaml,
          secrets: context.secrets,
          args: args,
          flavorContext: context.flavorContext));
      return;
    }
    if (backend == "tidb") {
      await const TidbMigrateCliCommand().exec(ExecContext(
          yaml: context.yaml,
          secrets: context.secrets,
          args: args,
          flavorContext: context.flavorContext));
      return;
    }
    if (backend != "d1" ||
        context.flavorContext?.explicit != true ||
        args.length < 2 ||
        !{"status", "diff", "generate", "apply", "mark"}.contains(args[1])) {
      error(example);
      return;
    }
    var apply = false;
    var local = false;
    String? version;
    for (var i = 2; i < args.length; i++) {
      if (args[i] == "--apply" && !apply) {
        apply = true;
      } else if (args[i] == "--local" && !local) {
        local = true;
      } else if (args[i] == "--version" &&
          version == null &&
          i + 1 < args.length) {
        version = args[++i];
      } else if (args[i] == "--flavor" && i + 1 < args.length) {
        i++;
      } else if (args[i].startsWith("--flavor=")) {
        continue;
      } else {
        error("不正または重複した引数です。");
        return;
      }
    }
    final config = context.yaml.getAsMap("cloudflare").getAsMap("d1");
    final input = {
      "command": args[1],
      "root": Directory.current.path,
      "schemaPath": config.get("schema", "d1/schema/schema.json"),
      "directory": config.get(
          "migrations", "d1/migrations/${context.flavorContext!.flavor.name}"),
      "target": {
        "accountId": config.get("account_id", ""),
        "databaseId": config.get("database_id", ""),
        "database": config.get("database", ""),
        "environment": context.flavorContext!.flavor.name
      },
      "version": version,
      "apply": apply,
      "local": local,
      "wrangler": context.yaml.getAsMap("bin").get("wrangler", "wrangler")
    };
    final process = await Process.start(
        context.yaml.getAsMap("bin").get("node", "node"),
        [
          "-e",
          '''
const {runMigrate} = require("@mathrunet/masamune_cloudflare_d1/dist/migrate.js");
let input="";process.stdin.setEncoding("utf8");process.stdin.on("data",c=>input+=c);
process.stdin.on("end",async()=>{try{console.log(JSON.stringify(await runMigrate(JSON.parse(input))));}catch(e){console.error(e.message);process.exitCode=1;}});
'''
        ],
        workingDirectory: "cloudflare");
    final output = process.stdout.transform(utf8.decoder).join();
    final failure = process.stderr.transform(utf8.decoder).join();
    process.stdin.write(jsonEncode(input));
    await process.stdin.close();
    if (await process.exitCode != 0) {
      error((await failure).trim());
    } else {
      stdout.write(await output);
    }
  }
}

/// D1資源とbindingの設定。DDLは実行しない。
class CloudflareD1CliAction extends CliCommand with CliActionMixin {
  /// D1設定。
  const CloudflareD1CliAction();
  @override
  String get description => "D1の環境別bindingとWorker登録を設定します。";
  @override
  bool checkEnabled(ExecContext context) =>
      context.yaml.getAsMap("cloudflare").getAsMap("d1").get("enable", false);
  @override
  Future<void> exec(ExecContext context) async {
    if (context.flavorContext?.explicit != true) {
      error("D1設定は--flavorを明示してください。");
      return;
    }
    final config = context.yaml.getAsMap("cloudflare").getAsMap("d1");
    final account = config.get("account_id", "").toString();
    final database = config.get("database", "").toString();
    final binding = config.get("binding", "MASAMUNE_D1").toString();
    final name = config.get("database_name", "").toString();
    var id = config.get("database_id", "").toString();
    if (!RegExp(r"^[a-f0-9]{32}$").hasMatch(account) ||
        !RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(database) ||
        !RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(binding) ||
        name.isEmpty) {
      error("D1のaccount_id、database、database_name、bindingを指定してください。");
      return;
    }
    final selectedFlavor = context.flavorContext!.flavor.name;
    if ((selectedFlavor == "dev") != database.startsWith("dev_")) {
      error("D1 databaseとflavor境界が一致しません。");
      return;
    }
    final schemaPath = config.get("schema", "d1/schema/schema.json").toString();
    if (schemaPath.startsWith("/") || schemaPath.split("/").contains("..")) {
      error("schemaはproject内の相対パスにしてください。");
      return;
    }
    final schemaFile = File(schemaPath);
    final wranglerFile = File("cloudflare/wrangler.jsonc");
    final indexFile = File(cloudflareEdgeEntryPath);
    if (!schemaFile.existsSync() ||
        !wranglerFile.existsSync() ||
        !indexFile.existsSync() ||
        !File("cloudflare/node_modules/@mathrunet/masamune_cloudflare_d1/dist/worker.js")
            .existsSync()) {
      error("D1 package、生成schema、初期化済みWorkerが必要です。");
      return;
    }
    final manifest = jsonDecode(schemaFile.readAsStringSync()) as Map;
    if (manifest["dialect"] != "sqlite" ||
        !(manifest["tables"] as List).any((t) => t["database"] == database)) {
      error("対象DBのD1 schemaがありません。");
      return;
    }
    var source = wranglerFile.readAsStringSync();
    final accountMatch =
        RegExp(r'"account_id"\s*:\s*"([^"]+)"').firstMatch(source);
    if (accountMatch != null && accountMatch.group(1) != account) {
      error("WranglerとD1のaccount_idが一致しません。");
      return;
    }
    if (accountMatch == null) {
      source =
          source.replaceFirst("{", '{"account_id":${jsonEncode(account)},');
    }
    final wrangler = context.yaml.getAsMap("bin").get("wrangler", "wrangler");
    // アカウントを明示し、同名の資源を再利用する。
    final list = await Process.run(wrangler, ["d1", "list", "--json"],
        environment: {"CLOUDFLARE_ACCOUNT_ID": account});
    if (list.exitCode != 0) {
      error("D1資源一覧を取得できません。");
      return;
    }
    var matches = (jsonDecode(list.stdout.toString()) as List)
        .where((e) => id.isEmpty ? e["name"] == name : e["uuid"] == id)
        .toList();
    if (matches.isEmpty && id.isEmpty) {
      final created = await Process.run(
          wrangler, ["d1", "create", name, "--no-update-config"],
          environment: {"CLOUDFLARE_ACCOUNT_ID": account});
      if (created.exitCode != 0) {
        error("D1資源を作成できません。");
        return;
      }
      final listed = await Process.run(wrangler, ["d1", "list", "--json"],
          environment: {"CLOUDFLARE_ACCOUNT_ID": account});
      if (listed.exitCode != 0) {
        error("作成後のD1資源を確認できません。");
        return;
      }
      matches = (jsonDecode(listed.stdout.toString()) as List)
          .where((e) => e["name"] == name)
          .toList();
    }
    if (matches.length != 1 || matches.single["name"] != name) {
      error("D1のIDと名前が一致しません。");
      return;
    }
    id = matches.single["uuid"].toString();
    final flavor = context.flavorContext!.flavor.name;
    source = WranglerEnvironmentSynchronizer.transformEnvironment(
        WranglerEnvironmentSynchronizer.ensureEnvironment(source,
            flavor: flavor,
            workerName:
                context.yaml.getAsMap("cloudflare").get("project_id", "")),
        flavor: flavor,
        transform: (environment) =>
            updateD1Binding(environment, binding: binding, id: id, name: name));
    final vectorSpecs = <String, Map>{};
    for (final table in manifest["tables"] as List) {
      if (table["database"] != database) {
        continue;
      }
      for (final vector in (table["vectors"] as List? ?? [])) {
        final old = vectorSpecs[vector["binding"]];
        if (old != null &&
            (old["dimensions"] != vector["dimensions"] ||
                old["metric"] != vector["metric"])) {
          throw StateError("同じVectorize bindingの次元・距離指標が一致しません。");
        }
        vectorSpecs[vector["binding"] as String] = vector as Map;
      }
    }
    if (vectorSpecs.isNotEmpty) {
      final names = config.getAsMap("vectorize").getAsMap(flavor);
      final listed = await Process.run(
          wrangler, ["vectorize", "list", "--json"],
          environment: {"CLOUDFLARE_ACCOUNT_ID": account});
      if (listed.exitCode != 0) {
        throw StateError("Vectorize一覧を取得できません。");
      }
      final indexes = jsonDecode(listed.stdout.toString()) as List;
      for (final entry in vectorSpecs.entries) {
        final indexName = names.get(entry.key, "").toString();
        if (!RegExp(r"^[a-z0-9][a-z0-9-]{0,63}$").hasMatch(indexName)) {
          throw StateError("vectorize.$flavor.${entry.key}にindex名を指定してください。");
        }
        if (!indexes.any((i) => i["name"] == indexName)) {
          final created = await Process.run(wrangler, [
            "vectorize",
            "create",
            indexName,
            "--dimensions",
            entry.value["dimensions"].toString(),
            "--metric",
            entry.value["metric"].toString(),
            "--json",
            "--no-update-config"
          ], environment: {
            "CLOUDFLARE_ACCOUNT_ID": account
          });
          if (created.exitCode != 0) {
            throw StateError("Vectorizeを作成できません。");
          }
        }
        final fetched = await Process.run(
            wrangler, ["vectorize", "get", indexName, "--json"],
            environment: {"CLOUDFLARE_ACCOUNT_ID": account});
        if (fetched.exitCode != 0) {
          throw StateError("Vectorize設定を取得できません。");
        }
        final actual = jsonDecode(fetched.stdout.toString()) as Map;
        if (actual["config"]["dimensions"] != entry.value["dimensions"] ||
            actual["config"]["metric"] != entry.value["metric"]) {
          throw StateError("Vectorizeの次元・距離指標が一致しません。");
        }
        source = WranglerEnvironmentSynchronizer.transformEnvironment(source,
            flavor: flavor,
            transform: (environment) => updateD1VectorBinding(environment,
                binding: entry.key, name: indexName));
      }
    }
    await wranglerFile.writeAsString(source);
    await File("cloudflare/src/d1_schema.json")
        .writeAsString(jsonEncode(manifest));
    var indexSource = indexFile.readAsStringSync();
    const statement = 'import d1SchemaManifest from "./d1_schema.json";';
    if (!indexSource.contains(statement)) {
      indexSource = "$statement\n$indexSource";
    }
    await indexFile.writeAsString(indexSource);
    // 環境のDB名はFLAVORで解決するためdev/prodの論理名を同じbindingへ対応させる。
    final logical = flavor == "dev" && database.startsWith("dev_")
        ? database.substring(4)
        : database;
    final bindings = {logical: binding, "dev_$logical": binding};
    if (!await applyCloudflareWorkersFunctions(
        alias: "d1",
        package: "@mathrunet/masamune_cloudflare_d1",
        functions: {
          "d1.Functions.d1":
              "d1.Functions.d1({ schemaManifest: d1SchemaManifest as d1.SchemaManifest, bindings: ${jsonEncode(bindings)} }),",
          if (vectorSpecs.isNotEmpty)
            "new d1.D1VectorSchedule":
                "new d1.D1VectorSchedule({ schemaManifest: d1SchemaManifest as d1.SchemaManifest, bindings: ${jsonEncode(bindings)} }),"
        })) {
      error("Worker登録位置がありません。");
      return;
    }
    await File("d1-resource-$flavor.json").writeAsString(jsonEncode(
        {"account_id": account, "database_id": id, "database_name": name}));
    label("D1設定完了。database_id=$id をkatana.yamlへ設定し、migrateでDDLを適用してください。");
  }
}

/// 対象bindingだけを更新し、既存の別bindingを保持する。
String updateD1Binding(String source,
    {required String binding, required String id, required String name}) {
  final pattern = RegExp(r'"d1_databases"\s*:\s*(\[[\s\S]*?\])');
  final match = pattern.firstMatch(source);
  final entries =
      match == null ? <dynamic>[] : jsonDecode(match.group(1)!) as List;
  entries.removeWhere((e) => e["binding"] == binding);
  entries.add({"binding": binding, "database_id": id, "database_name": name});
  final property = '"d1_databases":${jsonEncode(entries)}';
  if (match != null) {
    return source.replaceRange(match.start, match.end, property);
  }
  return source.replaceFirst("{", "{$property,");
}

/// 環境別bindingとcronを追加する。既存cronは保持する。
String updateD1VectorBinding(String source,
    {required String binding, required String name}) {
  final pattern = RegExp(r'"vectorize"\s*:\s*(\[[\s\S]*?\])');
  final match = pattern.firstMatch(source);
  final entries =
      match == null ? <dynamic>[] : jsonDecode(match.group(1)!) as List;
  entries.removeWhere((e) => e["binding"] == binding);
  entries.add({"binding": binding, "index_name": name});
  final property = '"vectorize":${jsonEncode(entries)}';
  source = match == null
      ? source.replaceFirst("{", "{$property,")
      : source.replaceRange(match.start, match.end, property);
  final triggers = RegExp(r'"triggers"\s*:\s*(\{[^}]*\})').firstMatch(source);
  final value = triggers == null
      ? <String, dynamic>{}
      : Map<String, dynamic>.from(jsonDecode(triggers.group(1)!) as Map);
  final crons = List<String>.from(value["crons"] as List? ?? []);
  if (!crons.contains("* * * * *")) {
    crons.add("* * * * *");
  }
  value["crons"] = crons;
  final triggerProperty = '"triggers":${jsonEncode(value)}';
  return triggers == null
      ? source.replaceFirst("{", "{$triggerProperty,")
      : source.replaceRange(triggers.start, triggers.end, triggerProperty);
}

/// Vectorize indexを環境別に作成・検証し、bindingをwranglerへ追加する。
Future<String> ensureCloudflareVectorizeBindings({
  required String source,
  required String wrangler,
  required String account,
  required String flavor,
  required Map<String, Map<String, dynamic>> specs,
  required Map<String, String> names,
}) async {
  if (specs.isEmpty) {
    return source;
  }
  final listed = await Process.run(wrangler, ["vectorize", "list", "--json"],
      environment: {"CLOUDFLARE_ACCOUNT_ID": account});
  if (listed.exitCode != 0) {
    throw StateError("Vectorize一覧を取得できません。");
  }
  final indexes = jsonDecode(listed.stdout.toString()) as List;
  for (final entry in specs.entries) {
    final indexName = names[entry.key] ?? "";
    if (!RegExp(r"^[a-z0-9][a-z0-9-]{0,63}$").hasMatch(indexName)) {
      throw StateError("vectorize.$flavor.${entry.key}にindex名を指定してください。");
    }
    if (!indexes.any((index) => index["name"] == indexName)) {
      final created = await Process.run(wrangler, [
        "vectorize",
        "create",
        indexName,
        "--dimensions",
        entry.value["dimensions"].toString(),
        "--metric",
        entry.value["metric"].toString(),
        "--json",
        "--no-update-config"
      ], environment: {
        "CLOUDFLARE_ACCOUNT_ID": account
      });
      if (created.exitCode != 0) {
        throw StateError("Vectorizeを作成できません。");
      }
    }
    final fetched = await Process.run(
        wrangler, ["vectorize", "get", indexName, "--json"],
        environment: {"CLOUDFLARE_ACCOUNT_ID": account});
    if (fetched.exitCode != 0) {
      throw StateError("Vectorize設定を取得できません。");
    }
    final actual = jsonDecode(fetched.stdout.toString()) as Map;
    if (actual["config"]["dimensions"] != entry.value["dimensions"] ||
        actual["config"]["metric"] != entry.value["metric"]) {
      throw StateError("Vectorizeの次元・距離指標が一致しません。");
    }
    source = updateD1VectorBinding(source, binding: entry.key, name: indexName);
  }
  return source;
}
