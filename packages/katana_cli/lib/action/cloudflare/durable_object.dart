// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/action/cloudflare/d1.dart";
import "package:katana_cli/katana_cli.dart";

/// build_runnerが管理するfragmentを統合する。未変更モデルも含め、削除済み入力は除く。
void finalizeDurableObjectSchema(
    {String root = ".", String outputPath = "do/schema/schema.json"}) {
  final lib = Directory("$root/lib");
  if (!lib.existsSync()) {
    return;
  }
  final tables = <Map<String, dynamic>>[];
  final seen = <String>{};
  final expectedDirectory = outputPath.replaceAll("\\", "/").split("/")
    ..removeLast();
  for (final entry in lib.listSync(recursive: true, followLinks: false)) {
    if (entry is! File || !entry.path.endsWith(".do_schema")) {
      continue;
    }
    final source =
        File(entry.path.replaceFirst(RegExp(r"\.do_schema$"), ".dart"));
    if (!source.existsSync()) {
      continue;
    }
    final fragment = jsonDecode(entry.readAsStringSync()) as Map;
    if (fragment["schemaDirPath"] != expectedDirectory.join("/")) {
      throw StateError(
          "DurableObjectSchema.schemaDirPathとcloudflare.do.schemaを一致させてください。");
    }
    for (final raw in (fragment["schema"] as Map)["tables"] as List) {
      final table = Map<String, dynamic>.from(raw as Map);
      if (!seen.add("${table["database"]}\u0000${table["table"]}")) {
        throw StateError("DurableObject schemaのtable定義が重複しています。");
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

/// DOのSQL承認履歴を管理する。class配備後、各DOが承認済み履歴を適用する。
class DurableObjectMigrateCliCommand extends CliCommand {
  /// DO migrationの入口。
  const DurableObjectMigrateCliCommand();
  @override
  String get description => "DOのmigration生成・承認・個別状態確認。";
  @override
  String get example =>
      "katana migrate generate --backend do --flavor dev --version 日時_名前";
  @override
  Future<void> exec(ExecContext context) async {
    final args = context.args;
    if (context.flavorContext?.explicit != true || args.length < 2) {
      error(example);
      return;
    }
    final values = <String, String>{};
    var apply = false;
    for (var i = 2; i < args.length; i++) {
      if (args[i] == "--apply" && !apply) {
        apply = true;
        continue;
      }
      if (args[i].startsWith("--flavor=")) {
        continue;
      }
      if (!{"--version", "--endpoint", "--user-id", "--flavor"}
              .contains(args[i]) ||
          i + 1 >= args.length ||
          values.containsKey(args[i])) {
        error("引数が不正です。");
        return;
      }
      values[args[i]] = args[++i];
    }
    final config =
        context.yaml.getAsMap("cloudflare").getAsMap("durable_object");
    final input = {
      "command": args[1],
      "root": Directory.current.path,
      "schemaPath": config.get("schema", "do/schema/schema.json"),
      "directory": config.get(
          "migrations", "do/migrations/${context.flavorContext!.flavor.name}"),
      "approvedPath":
          config.get("approved", "cloudflare/src/do_revisions.json"),
      "database": config.get("database", ""),
      "environment": context.flavorContext!.flavor.name,
      "version": values["--version"],
      "apply": apply,
      "endpoint": values["--endpoint"],
      "userId": values["--user-id"]
    };
    final process = await Process.start(
        context.yaml.getAsMap("bin").get("node", "node"),
        [
          "-e",
          '''const {runMigrate}=require("@mathrunet/masamune_cloudflare_do/dist/migrate.js");let s="";process.stdin.setEncoding("utf8");process.stdin.on("data",c=>s+=c);process.stdin.on("end",async()=>{try{console.log(JSON.stringify(await runMigrate(JSON.parse(s))));}catch(e){console.error(e.message);process.exitCode=1;}});'''
        ],
        workingDirectory: "cloudflare");
    final output = process.stdout.transform(utf8.decoder).join();
    final failure = process.stderr.transform(utf8.decoder).join();
    process.stdin.write(jsonEncode(input));
    await process.stdin.close();
    if (await process.exitCode != 0) {
      throw StateError(await failure);
    }
    label(await output);
  }
}

/// DO bindingとclass migrationを環境内に追加する。既存設定は保持する。
String updateDurableObjectBindings(String source,
    {required String binding,
    required String className,
    required String coordinatorBinding,
    required String coordinatorClass,
    required String tag}) {
  for (final name in [
    binding,
    className,
    coordinatorBinding,
    coordinatorClass
  ]) {
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(name)) {
      throw ArgumentError("DO識別子が不正です。");
    }
  }
  final objectPattern = RegExp(
      r'"durable_objects"\s*:\s*\{\s*"bindings"\s*:\s*(\[[\s\S]*?\])\s*\}');
  final existing = objectPattern.firstMatch(source);
  if (source.contains('"durable_objects"') && existing == null) {
    throw StateError("既存DO設定の構造を解釈できません。");
  }
  final entries =
      existing == null ? <dynamic>[] : jsonDecode(existing.group(1)!) as List;
  for (final pair in [
    [binding, className],
    [coordinatorBinding, coordinatorClass]
  ]) {
    final old = entries.where((e) => e["name"] == pair[0]);
    if (old.isNotEmpty &&
        old.any(
            (e) => e["class_name"] != pair[1] || e["script_name"] != null)) {
      throw StateError("既存DO bindingの接続先が異なります。");
    }
    if (old.isEmpty) {
      entries.add({"name": pair[0], "class_name": pair[1]});
    }
  }
  final property = '"durable_objects":{"bindings":${jsonEncode(entries)}}';
  source = existing == null
      ? source.replaceFirst("{", "{$property,")
      : source.replaceRange(existing.start, existing.end, property);
  final found = _doArrayProperty(source, "migrations");
  final migrations = found == null ? <dynamic>[] : found.value;
  final desired = {
    "tag": tag,
    "new_sqlite_classes": [className, coordinatorClass]
  };
  final same = migrations.where((m) => m["tag"] == tag);
  if (same.isNotEmpty &&
      same.any((m) => jsonEncode(m) != jsonEncode(desired))) {
    throw StateError("migration tagが競合しています。");
  }
  if (same.isEmpty) {
    if (migrations.any((m) => (m["new_sqlite_classes"] as List? ?? [])
        .any([className, coordinatorClass].contains))) {
      throw StateError("classは別tagで登録済みです。");
    }
    migrations.add(desired);
  }
  final migrationProperty = '"migrations":${jsonEncode(migrations)}';
  return found == null
      ? source.replaceFirst("{", "{$migrationProperty,")
      : source.replaceRange(found.start, found.end, migrationProperty);
}

/// 共有hubだけを新しいmigrationで追加し、既存データDOの履歴を維持する。
String updateSharedHubBinding(String source,
    {required String binding, required String tag}) {
  if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(binding) || tag.isEmpty) {
    throw ArgumentError("共有hubのbinding/tagが不正です。");
  }
  final pattern = RegExp(
      r'"durable_objects"\s*:\s*\{\s*"bindings"\s*:\s*(\[[\s\S]*?\])\s*\}');
  final match = pattern.firstMatch(source);
  if (match == null) {
    throw StateError("先にDO bindingを生成してください。");
  }
  final bindings = jsonDecode(match.group(1)!) as List;
  final existing = bindings.where((e) => e["name"] == binding);
  if (existing.any((e) =>
      e["class_name"] != "MasamuneSharedHub" || e["script_name"] != null)) {
    throw StateError("共有hubのbindingが競合しています。");
  }
  if (existing.isEmpty) {
    bindings.add({"name": binding, "class_name": "MasamuneSharedHub"});
  }
  source = source.replaceRange(match.start, match.end,
      '"durable_objects":{"bindings":${jsonEncode(bindings)}}');
  final found = _doArrayProperty(source, "migrations");
  final migrations = found?.value ?? <dynamic>[];
  final desired = {
    "tag": tag,
    "new_sqlite_classes": ["MasamuneSharedHub"]
  };
  final same = migrations.where((e) => e["tag"] == tag);
  if (same.any((e) => jsonEncode(e) != jsonEncode(desired))) {
    throw StateError("共有hub migration tagが競合しています。");
  }
  if (same.isEmpty) {
    if (migrations.any((e) => (e["new_sqlite_classes"] as List? ?? [])
        .contains("MasamuneSharedHub"))) {
      throw StateError("共有hub classは別tagで登録済みです。");
    }
    migrations.add(desired);
  }
  final property = '"migrations":${jsonEncode(migrations)}';
  return found == null
      ? source.replaceFirst("{", "{$property,")
      : source.replaceRange(found.start, found.end, property);
}

/// 配備設定を生成する。DBのSQL承認はmigrateで別途行う。
class CloudflareDurableObjectCliAction extends CliCommand with CliActionMixin {
  /// DO設定。
  const CloudflareDurableObjectCliAction();
  @override
  String get description => "Durable Objectsのbinding・classを設定します。";
  @override
  bool checkEnabled(ExecContext context) => context.yaml
      .getAsMap("cloudflare")
      .getAsMap("durable_object")
      .get("enable", false);
  @override
  Future<void> exec(ExecContext context) async {
    if (context.flavorContext?.explicit != true) {
      throw StateError("--flavorを指定してください。");
    }
    final config =
        context.yaml.getAsMap("cloudflare").getAsMap("durable_object");
    final manifest = jsonDecode(
        File(config.get("schema", "do/schema/schema.json")).readAsStringSync());
    final binding = config.get("binding", "MASAMUNE_DO").toString();
    final coordinator =
        config.get("coordinator_binding", "MASAMUNE_QUEUE").toString();
    final file = File("cloudflare/wrangler.jsonc");
    if (!file.existsSync()) {
      throw StateError("先にCloudflare Workerを作成してください。");
    }
    var source = WranglerEnvironmentSynchronizer.transformEnvironment(
        WranglerEnvironmentSynchronizer.synchronize(file.readAsStringSync(),
            flavor: context.flavorContext!.flavor.name,
            workerName: context.yaml
                .getAsMap("cloudflare")
                .get("project_id", "")
                .toString()),
        flavor: context.flavorContext!.flavor.name,
        transform: (s) => updateDurableObjectBindings(s,
            binding: binding,
            className: "MasamuneUserDatabase",
            coordinatorBinding: coordinator,
            coordinatorClass: "MasamuneQueueCoordinator",
            tag: config
                .get("class_migration_tag", "masamune-do-v1")
                .toString()));
    final sharedConfig = config.getAsMap("shared_hub");
    final sharedEnabled = sharedConfig.get("enable", false);
    final sharedBinding =
        sharedConfig.get("binding", "MASAMUNE_SHARED_HUB").toString();
    final dynamic sharedShards = sharedConfig["shards"] ?? 4;
    final sharedGeneration = sharedConfig.get("generation", "v1").toString();
    if (sharedEnabled &&
        (sharedShards is! int ||
            sharedShards < 1 ||
            sharedShards > 32 ||
            !RegExp(r"^[A-Za-z0-9_-]{1,64}$").hasMatch(sharedGeneration))) {
      throw StateError("共有hubは1〜32 shards、有効なgenerationを指定してください。");
    }
    if (!sharedEnabled && source.contains('"MasamuneSharedHub"')) {
      throw StateError("既存共有hubの無効化にはclass lifecycleの明示的な移行が必要です。");
    }
    if (sharedEnabled) {
      source = WranglerEnvironmentSynchronizer.transformEnvironment(source,
          flavor: context.flavorContext!.flavor.name,
          transform: (s) => updateSharedHubBinding(s,
              binding: sharedBinding,
              tag: sharedConfig
                  .get("class_migration_tag", "masamune-shared-hub-v1")
                  .toString()));
    }
    final sharedJson = jsonEncode({
      "binding": sharedBinding,
      "shards": sharedShards,
      "generation": sharedGeneration
    });
    final vectorSpecs = <String, Map<String, dynamic>>{};
    for (final table in manifest["tables"] as List) {
      for (final raw in (table["vectors"] as List? ?? const [])) {
        final vector = Map<String, dynamic>.from(raw as Map);
        final bindingName = vector["binding"] as String;
        final previous = vectorSpecs[bindingName];
        if (previous != null &&
            (previous["dimensions"] != vector["dimensions"] ||
                previous["metric"] != vector["metric"])) {
          throw StateError("同じVectorize bindingの次元・距離指標が一致しません。");
        }
        vectorSpecs[bindingName] = vector;
      }
    }
    if (vectorSpecs.isNotEmpty) {
      final cloudflare = context.yaml.getAsMap("cloudflare");
      final flavor = context.flavorContext!.flavor.name;
      final nameConfig = config.getAsMap("vectorize").getAsMap(flavor);
      source = await ensureCloudflareVectorizeBindings(
        source: source,
        wrangler: context.yaml.getAsMap("bin").get("wrangler", "wrangler"),
        account: config.get("account_id", cloudflare.get("account_id", "")),
        flavor: flavor,
        specs: vectorSpecs,
        names: {
          for (final bindingName in vectorSpecs.keys)
            bindingName: nameConfig.get(bindingName, "").toString(),
        },
      );
    }
    await file.writeAsString(source);
    await File("cloudflare/src/do_schema.json")
        .writeAsString(jsonEncode(manifest));
    final approved =
        File(config.get("approved", "cloudflare/src/do_revisions.json"));
    if (!approved.existsSync()) {
      await approved.parent.create(recursive: true);
      await approved.writeAsString("[]\n");
    }
    if (approved.path != "cloudflare/src/do_revisions.json") {
      throw StateError("approvedはcloudflare/src/do_revisions.jsonを指定してください。");
    }
    final generated = File("cloudflare/src/masamune_do.ts");
    await generated.writeAsString('''
// Katana CLI生成。Hibernation handlersは基底クラスが提供する。
// 移行元の設定はindex.tsからsetDoSourceへ登録する。
import { DurableObjectDatabase, QueueCoordinator, type DoConfig${sharedEnabled ? ", SharedHub, type SharedHubOptions" : ""} } from "@mathrunet/masamune_cloudflare_do";
import manifest from "./do_schema.json";
import revisions from "./do_revisions.json";
let sourceFactory: ((env: unknown) => DoConfig["source"]) | undefined;
export function setDoSource(factory: (env: unknown) => DoConfig["source"]) { sourceFactory = factory; }
export class MasamuneUserDatabase extends DurableObjectDatabase {
  constructor(ctx: any, env: any) { super(ctx, env, {schemaManifest: manifest, revisions, source: sourceFactory?.(env)${sharedEnabled ? ", shared: $sharedJson" : ""}} as DoConfig); }
}
export class MasamuneQueueCoordinator extends QueueCoordinator {}
${sharedEnabled ? """
export class MasamuneSharedHub extends SharedHub {}
let sharedAuthorize: SharedHubOptions["authorize"] = () => false;
export function setSharedHubAuthorize(authorize: SharedHubOptions["authorize"]) { sharedAuthorize = authorize; }
export const sharedHubOptions: SharedHubOptions = {...$sharedJson, authorize: (context, scope) => sharedAuthorize(context, scope)};
""" : ""}
''');
    final index = File("cloudflare/src/index.ts");
    var text = index.readAsStringSync();
    final exports =
        'export { MasamuneUserDatabase, MasamuneQueueCoordinator${sharedEnabled ? ", MasamuneSharedHub" : ""} } from "./masamune_do";';
    final exportPattern = RegExp(
        r'''export\s*\{\s*MasamuneUserDatabase\s*,\s*MasamuneQueueCoordinator\s*(?:,\s*MasamuneSharedHub\s*)?\}\s*from\s*["']\./masamune_do["'];?\r?\n?''');
    text = "$exports\n${text.replaceAll(exportPattern, "")}";
    final importPattern = RegExp(
        r'''import\s*\*\s*as\s+durableObject\s+from\s*["']@mathrunet/masamune_cloudflare_do["'];?\r?\n?''');
    if (importPattern.hasMatch(text)) {
      text =
          'import * as durableObject from "@mathrunet/masamune_cloudflare_do";\n${text.replaceAll(importPattern, "")}';
    }
    final sharedImport = RegExp(
        r"""import\s*\{\s*sharedHubOptions\s*\}\s*from\s*["']\./masamune_do["'];?\r?\n?""");
    text = text.replaceAll(sharedImport, "");
    if (sharedEnabled) {
      text = 'import { sharedHubOptions } from "./masamune_do";\n$text';
    }
    await index.writeAsString(text);
    final databases =
        (manifest["tables"] as List).map((t) => t["database"]).toSet().toList();
    if (!await applyCloudflareWorkersFunctions(
        alias: "durableObject",
        package: "@mathrunet/masamune_cloudflare_do",
        functions: {
          "durableObject.Functions.durableObjectSockets":
              "durableObject.Functions.durableObjectSockets({ binding: ${jsonEncode(binding)}, databases: ${jsonEncode(databases)}${sharedEnabled ? ", shared: sharedHubOptions" : ""} }),",
          "durableObject.Functions.durableObject":
              "durableObject.Functions.durableObject({ binding: ${jsonEncode(binding)}, databases: ${jsonEncode(databases)}${sharedEnabled ? ", shared: sharedHubOptions" : ""} }),"
        })) {
      throw StateError("Worker登録位置がありません。");
    }
    label("DO設定完了。migrateで承認後、Workerをdeployしてください。");
  }
}

({int start, int end, List<dynamic> value})? _doArrayProperty(
    String source, String property) {
  final match = RegExp('"$property"\\s*:\\s*\\[').firstMatch(source);
  if (match == null) {
    return null;
  }
  final begin = source.indexOf("[", match.start);
  var depth = 0;
  var quoted = false;
  var escaped = false;
  for (var i = begin; i < source.length; i++) {
    final c = source[i];
    if (quoted) {
      if (escaped) {
        escaped = false;
      } else if (c == r"\") {
        escaped = true;
      } else if (c == '"') {
        quoted = false;
      }
      continue;
    }
    if (c == '"') {
      quoted = true;
    } else if (c == "[") {
      depth++;
    } else if (c == "]" && --depth == 0) {
      return (
        start: match.start,
        end: i + 1,
        value: jsonDecode(source.substring(begin, i + 1)) as List
      );
    }
  }
  throw StateError("JSON配列が閉じていません。");
}
