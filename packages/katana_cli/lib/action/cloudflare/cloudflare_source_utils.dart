// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Path of the edge Worker entrypoint (no placement; Turso, KV, R2, D1, DO, auth, etc.).
///
/// edge Worker（placementなし。Turso・KV・R2・D1・DO・認証など）のエントリファイルのパス。
const cloudflareEdgeEntryPath = "cloudflare/src/edge.ts";

/// Path of the region Worker entrypoint (fixed placement; TiDB, etc.).
///
/// region Worker（placement固定。TiDBなど）のエントリファイルのパス。
const cloudflareRegionEntryPath = "cloudflare/src/region.ts";

/// Legacy Worker entrypoint path used before the edge/region split.
///
/// edge/region分割前に使われていた旧Workerエントリファイルのパス。
const cloudflareLegacyEntryPath = "cloudflare/src/index.ts";

/// Wrangler configuration file name of the region Worker (relative to `cloudflare/`).
///
/// region WorkerのWrangler設定ファイル名（`cloudflare/`からの相対パス）。
const cloudflareRegionWranglerConfig = "wrangler.region.jsonc";

/// Returns true if the region Worker is enabled in [yaml] (`cloudflare.workers.region.enable`).
///
/// [yaml]でregion Worker（`cloudflare.workers.region.enable`）が有効な場合trueを返します。
bool isCloudflareRegionWorkerEnabled(Map yaml) {
  final cloudflare = yaml["cloudflare"];
  if (cloudflare is! Map) {
    return false;
  }
  final workers = cloudflare["workers"];
  if (workers is! Map || workers["enable"] != true) {
    return false;
  }
  final region = workers["region"];
  return region is Map && region["enable"] == true;
}

/// Utilities for editing Cloudflare Worker entrypoints such as `cloudflare/src/edge.ts`.
///
/// `cloudflare/src/edge.ts`などのCloudflare Workerエントリファイルを編集するためのユーティリティ。
class CloudflareSourceUtils {
  CloudflareSourceUtils._();

  /// Ensure the import statement of [package] with [alias] exists in [source].
  ///
  /// [source]に[alias]付きの[package]のimport文が存在することを保証します。
  static String ensureImport(
    String source, {
    required String alias,
    required String package,
  }) {
    final import = 'import * as $alias from "$package";';
    final existingImport = RegExp(
      '^import \\* as \\w+ from "${RegExp.escape(package)}";\$',
      multiLine: true,
    ).firstMatch(source);
    if (existingImport != null) {
      return source.replaceRange(
        existingImport.start,
        existingImport.end,
        import,
      );
    }
    final imports = RegExp(r"^import .+;$", multiLine: true).allMatches(source);
    if (imports.isEmpty) {
      return "$import\n$source";
    }
    final lastImport = imports.last;
    return source.replaceRange(
      lastImport.end,
      lastImport.end,
      "\n$import",
    );
  }

  /// Ensure a named import of [name] from [from] exists in [source].
  ///
  /// Does nothing if a named import from [from] already contains [name].
  /// If a named import from [from] exists without [name], [name] is added to it.
  /// Otherwise a new import is added after the last import.
  /// When [from] starts with `./workers/` and existing `./workers/` imports use
  /// the `.js` extension, the extension is added to [from] as well.
  ///
  /// [source]に[from]からの[name]の名前付きimportが存在することを保証します。
  ///
  /// [from]からの名前付きimportに[name]が既にあれば何もしません。
  /// [name]を含まない[from]からの名前付きimportがあればそこへ[name]を追加し、
  /// なければ最後のimportの後に新しいimportを追加します。
  /// [from]が`./workers/`で始まり、既存の`./workers/`のimportが`.js`付きの場合は[from]にも`.js`を付けます。
  static String ensureNamedImport(
    String source, {
    required String name,
    required String from,
  }) {
    final base =
        from.endsWith(".js") ? from.substring(0, from.length - 3) : from;
    var target = from;
    if (base.startsWith("./workers/") &&
        !from.endsWith(".js") &&
        RegExp(r"""from\s+["']\./workers/[^"']+\.js["']""").hasMatch(source)) {
      target = "$base.js";
    }
    final named = RegExp(
      "import\\s*(type\\s+)?\\{([^}]*)\\}\\s*from\\s*[\"'](${RegExp.escape(base)}(?:\\.js)?)[\"']\\s*;?",
    );
    final matches =
        named.allMatches(source).where((m) => m.group(1) == null).toList();
    for (final match in matches) {
      final names = match
          .group(2)!
          .split(",")
          .map((e) => e.trim().split(RegExp(r"\s+as\s+")).first.trim())
          .where((e) => e.isNotEmpty);
      if (names.contains(name)) {
        return source;
      }
    }
    if (matches.isNotEmpty) {
      final match = matches.first;
      var names = match.group(2)!.trim();
      if (names.endsWith(",")) {
        names = names.substring(0, names.length - 1).trim();
      }
      return source.replaceRange(
        match.start,
        match.end,
        'import { ${names.isEmpty ? name : "$names, $name"} } from "${match.group(3)}";',
      );
    }
    final import = 'import { $name } from "$target";';
    final imports =
        RegExp(r"^import\s[^;]*;", multiLine: true).allMatches(source);
    if (imports.isEmpty) {
      return "$import\n$source";
    }
    final lastImport = imports.last;
    return source.replaceRange(
      lastImport.end,
      lastImport.end,
      "\n$import",
    );
  }

  /// Returns true if [source] contains a call to [functionName].
  ///
  /// [source]に[functionName]の呼び出しが含まれている場合はtrueを返します。
  static bool containsFunctionCall(String source, String functionName) {
    return source.contains("$functionName(");
  }

  /// Rejects a Worker entrypoint pinned to a different Firebase project.
  ///
  /// Runtime expressions such as `resolveFirebaseProjectId(env)` remain valid.
  static void validateFirebaseProjectId(
    String source,
    String projectId, {
    String path = cloudflareEdgeEntryPath,
  }) {
    for (final functionName in [
      "m.FirebaseAuthAdapter",
      "auth.Functions.deleteUser",
    ]) {
      final pattern = RegExp(
        "${RegExp.escape(functionName)}\\s*\\(\\s*\\{\\s*projectId\\s*:\\s*['\"]([^'\"]+)['\"]",
      );
      for (final match in pattern.allMatches(source)) {
        if (match.group(1) != projectId) {
          throw StateError(
            "$path pins $functionName to a different Firebase project. "
            "Use a runtime environment-based project ID before applying or deploying this flavor.",
          );
        }
      }
    }
  }

  /// 既存の関数呼び出しの引数を取得し、認可などの設定を保持する。
  static String? functionArguments(String source, String functionName) {
    final start = source.indexOf("$functionName(");
    if (start < 0) {
      return null;
    }
    final open = start + functionName.length;
    final close = _findClosing(source, open, "(", ")");
    if (close < 0) {
      throw const FormatException("Workerの関数呼び出しを解析できません。");
    }
    return source.substring(open + 1, close).trim();
  }

  /// Replace all calls to [functionName] in [source] with [replacement].
  ///
  /// [source]内の[functionName]の呼び出しをすべて[replacement]に置き換えます。
  static String replaceFunctionCall(
    String source,
    String functionName,
    String replacement,
  ) {
    var updated = source;
    var searchStart = 0;
    var replaced = false;
    while (true) {
      final range = _findFunctionCall(updated, functionName, searchStart);
      if (range == null) {
        break;
      }
      final next = replaced ? "" : replacement;
      updated = updated.replaceRange(range.start, range.end, next);
      searchStart = range.start + next.length;
      replaced = true;
    }
    return updated;
  }

  /// Insert [functions] into the `m.deploy([...])` array in [source].
  ///
  /// Returns null if the deploy array cannot be found.
  ///
  /// [source]内の`m.deploy([...])`配列に[functions]を挿入します。
  ///
  /// deploy配列が見つからない場合はnullを返します。
  static String? insertDeployFunctions(
    String source,
    List<String> functions,
  ) {
    if (functions.isEmpty) {
      return source;
    }
    final deployFunctions = _findDeployFunctions(source);
    if (deployFunctions == null) {
      return null;
    }
    final insert =
        "${_needsLeadingComma(source, deployFunctions) ? "," : ""}\n${functions.join("\n")}";
    return source.replaceRange(
      deployFunctions.end,
      deployFunctions.end,
      insert,
    );
  }

  static _SourceRange? _findDeployFunctions(String source) {
    // 既存ファイルが使う名前空間を保持してdeploy配列を探します。
    final namespace = RegExp(
          r'''import\s+\*\s+as\s+(\w+)\s+from\s+["']@mathrunet/masamune_cloudflare["']''',
        ).firstMatch(source)?.group(1) ??
        "m";
    final deploy = RegExp(
      "${RegExp.escape(namespace)}\\s*\\.\\s*deploy\\s*\\(\\s*\\[",
    ).firstMatch(source);
    if (deploy == null) {
      return null;
    }
    final functionsStart = deploy.end - 1;
    final functionsEnd = _findClosing(source, functionsStart, "[", "]");
    if (functionsEnd < 0) {
      return null;
    }
    return _SourceRange(functionsStart + 1, functionsEnd);
  }

  static bool _needsLeadingComma(String source, _SourceRange range) {
    for (var i = range.end - 1; i >= range.start; i--) {
      final char = source[i];
      if (char.trim().isEmpty) {
        continue;
      }
      return char != ",";
    }
    return false;
  }

  static _SourceRange? _findFunctionCall(
    String source,
    String functionName,
    int searchStart,
  ) {
    final start = source.indexOf("$functionName(", searchStart);
    if (start < 0) {
      return null;
    }
    final open = start + functionName.length;
    final close = _findClosing(source, open, "(", ")");
    if (close < 0) {
      return null;
    }
    var end = close + 1;
    while (end < source.length && source[end].trim().isEmpty) {
      end++;
    }
    if (end < source.length && source[end] == ",") {
      end++;
    }
    return _SourceRange(start, end);
  }

  static int _findClosing(
    String source,
    int openIndex,
    String openChar,
    String closeChar,
  ) {
    var depth = 0;
    String? quote;
    var escaped = false;
    for (var i = openIndex; i < source.length; i++) {
      final char = source[i];
      if (quote != null) {
        if (escaped) {
          escaped = false;
          continue;
        }
        if (char == "\\") {
          escaped = true;
          continue;
        }
        if (char == quote) {
          quote = null;
        }
        continue;
      }
      if (char == '"' || char == "'" || char == "`") {
        quote = char;
        continue;
      }
      if (char == openChar) {
        depth++;
        continue;
      }
      if (char == closeChar) {
        depth--;
        if (depth == 0) {
          return i;
        }
      }
    }
    return -1;
  }
}

/// Apply Cloudflare Workers functions to the Worker entrypoint [entry]
/// (defaults to `cloudflare/src/edge.ts`).
///
/// Ensures the import of [package] with [alias], and inserts each entry of
/// [functions] (a map of function name to the code to insert) into
/// `m.deploy([...])` if it does not already exist. Existing calls are replaced.
///
/// Workerのエントリファイル[entry]（既定は`cloudflare/src/edge.ts`）にCloudflare WorkersのFunctionを適用します。
///
/// [alias]付きの[package]のimportを保証し、[functions]（関数名から挿入コードへのマップ)の
/// 各エントリーが存在しない場合は`m.deploy([...])`に挿入します。既存の呼び出しは置き換えられます。
Future<bool> applyCloudflareWorkersFunctions({
  required String alias,
  required String package,
  required Map<String, String> functions,
  bool replaceExisting = true,
  String entry = cloudflareEdgeEntryPath,
}) async {
  final indexFile = File(entry);
  if (!indexFile.existsSync()) {
    error(
      "The file `$entry` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
    );
    return false;
  }
  var source = await indexFile.readAsString();
  source = CloudflareSourceUtils.ensureImport(
    source,
    alias: alias,
    package: package,
  );
  final inserts = <String>[];
  for (final entry in functions.entries) {
    if (replaceExisting) {
      source = CloudflareSourceUtils.replaceFunctionCall(
        source,
        entry.key,
        entry.value,
      );
    }
    if (!CloudflareSourceUtils.containsFunctionCall(source, entry.key)) {
      inserts.add(entry.value);
    }
  }
  final updated = CloudflareSourceUtils.insertDeployFunctions(source, inserts);
  if (updated == null) {
    error(
      "Could not find the Cloudflare deploy array in `$entry`. Please check the namespace import and Workers entrypoint.",
    );
    return false;
  }
  await indexFile.writeAsString(updated);
  return true;
}

/// Register a generated Worker class [className] in the Worker entrypoint [entry].
///
/// Ensures the named import of [className] from [importPath] and inserts
/// `new [className]()` into `m.deploy([...])` if it is not registered yet.
/// Shows a warning if the other entrypoint (edge/region) also registers it.
/// Returns false if [entry] does not exist or the deploy array cannot be found.
///
/// 生成したWorkerクラス[className]をWorkerのエントリファイル[entry]に登録します。
///
/// [importPath]からの[className]の名前付きimportを保証し、未登録の場合は
/// `m.deploy([...])`に`new [className]()`を挿入します。
/// もう一方のエントリファイル（edge/region）にも登録されている場合は警告を表示します。
/// [entry]が存在しない場合やdeploy配列が見つからない場合はfalseを返します。
Future<bool> registerCloudflareWorker({
  required String entry,
  required String className,
  required String importPath,
}) async {
  final file = File(entry);
  if (!file.existsSync()) {
    error(
      "The file `$entry` does not exist. Run `katana apply` to initialize Cloudflare Workers first. `$entry`が存在しません。先に`katana apply`でCloudflare Workersを初期化してください。",
    );
    return false;
  }
  final original = await file.readAsString();
  var source = original;
  if (!CloudflareSourceUtils.containsFunctionCall(source, "new $className")) {
    final updated = CloudflareSourceUtils.insertDeployFunctions(
      source,
      ["    new $className(),"],
    );
    if (updated == null) {
      error(
        "Could not find the Cloudflare deploy array in `$entry`. Please register `new $className()` manually. `$entry`のdeploy配列が見つかりません。`new $className()`を手動で登録してください。",
      );
      return false;
    }
    source = updated;
  }
  source = CloudflareSourceUtils.ensureNamedImport(
    source,
    name: className,
    from: importPath,
  );
  if (source != original) {
    await file.writeAsString(source);
    label("Registered `$className` in `$entry`.");
  }
  final other = entry == cloudflareRegionEntryPath
      ? cloudflareEdgeEntryPath
      : cloudflareRegionEntryPath;
  final otherFile = File(other);
  if (otherFile.existsSync() &&
      CloudflareSourceUtils.containsFunctionCall(
        otherFile.readAsStringSync(),
        "new $className",
      )) {
    label(
      "WARNING: `$className` is also registered in `$other`. Remove it from either entrypoint if it is not intended. `$className`は`$other`にも登録されています。意図しない場合はどちらかから削除してください。",
    );
  }
  return true;
}

/// Returns the files that use TiDB from the edge Worker [entry].
///
/// Follows relative imports of [entry] recursively within `cloudflare/src`
/// and lists files containing `@mathrunet/masamune_cloudflare_tidb`,
/// `TidbDirectClient` or `TIDB_HOST`.
///
/// edge Worker[entry]からTiDBを使用しているファイルを返します。
///
/// [entry]の相対importを`cloudflare/src`内で再帰的に辿り、
/// `@mathrunet/masamune_cloudflare_tidb`・`TidbDirectClient`・`TIDB_HOST`を含むファイルを列挙します。
List<String> findEdgeTidbUsages({String entry = cloudflareEdgeEntryPath}) {
  const root = "cloudflare/src";
  const markers = [
    "@mathrunet/masamune_cloudflare_tidb",
    "TidbDirectClient",
    "TIDB_HOST",
  ];
  final importPattern = RegExp(
    r"""(?:import|export)\s+(?:[^'";]*?\s+from\s+)?["'](\.{1,2}/[^"']+)["']""",
  );
  final visited = <String>{};
  final usages = <String>[];
  final queue = <String>[_normalizeCloudflarePath(entry)];
  while (queue.isNotEmpty) {
    final path = queue.removeAt(0);
    if (!visited.add(path)) {
      continue;
    }
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }
    final source = file.readAsStringSync();
    if (markers.any(source.contains)) {
      usages.add(path);
    }
    final directory =
        path.contains("/") ? path.substring(0, path.lastIndexOf("/")) : "";
    for (final match in importPattern.allMatches(source)) {
      final resolved = _resolveCloudflareImport(directory, match.group(1)!);
      if (resolved != null &&
          resolved.startsWith("$root/") &&
          !visited.contains(resolved)) {
        queue.add(resolved);
      }
    }
  }
  return usages;
}

String? _resolveCloudflareImport(String directory, String specifier) {
  final base = _normalizeCloudflarePath("$directory/$specifier");
  final stem = RegExp(r"\.(js|mjs|ts)$").hasMatch(base)
      ? base.substring(0, base.lastIndexOf("."))
      : base;
  for (final candidate in [
    base,
    "$stem.ts",
    "$stem.tsx",
    "$stem.js",
    "$stem/index.ts",
    "$stem/index.js",
  ]) {
    if (File(candidate).existsSync()) {
      return candidate;
    }
  }
  return null;
}

String _normalizeCloudflarePath(String path) {
  final segments = <String>[];
  for (final segment in path.split("/")) {
    if (segment.isEmpty || segment == ".") {
      continue;
    }
    if (segment == "..") {
      if (segments.isNotEmpty) {
        segments.removeLast();
      }
      continue;
    }
    segments.add(segment);
  }
  return segments.join("/");
}

/// ローカル適用に必要な宣言・lock・実体を、依存を変更せず検証します。
void validateLocalCloudflarePackages(Iterable<String> packages) {
  final manifest =
      jsonDecode(File("cloudflare/package.json").readAsStringSync()) as Map;
  final lock =
      jsonDecode(File("cloudflare/package-lock.json").readAsStringSync())
          as Map;
  final declared = <String, dynamic>{
    ...Map<String, dynamic>.from(manifest["dependencies"] as Map? ?? {}),
    ...Map<String, dynamic>.from(manifest["devDependencies"] as Map? ?? {}),
  };
  final locked = lock["packages"] as Map? ?? {};
  for (final name in packages) {
    final installed = File("cloudflare/node_modules/$name/package.json");
    final entry = locked["node_modules/$name"];
    if (!declared.containsKey(name) ||
        entry is! Map ||
        !installed.existsSync()) {
      throw StateError("ローカル適用に必要な Cloudflare npm 依存が未導入です: $name");
    }
    final actual = jsonDecode(installed.readAsStringSync()) as Map;
    if (entry["version"] == null || actual["version"] != entry["version"]) {
      throw StateError("Cloudflare npm 依存の実体とlockが一致しません: $name");
    }
  }
}

/// Installs only Node packages that are not already declared.
///
/// Reinstalling a declared package without a version can rewrite an exact
/// dependency to npm's configured save prefix, even when nothing changed.
Future<void> installMissingCloudflarePackages({
  required String npm,
  required Iterable<String> packages,
}) async {
  if (isLocalApply) {
    validateLocalCloudflarePackages(packages);
    return;
  }
  final packageJson = File("cloudflare/package.json");
  final declared = <String>{};
  if (packageJson.existsSync()) {
    final decoded = jsonDecode(await packageJson.readAsString());
    if (decoded is Map) {
      for (final section in ["dependencies", "devDependencies"]) {
        final values = decoded[section];
        if (values is Map) {
          declared.addAll(values.keys.map((key) => key.toString()));
        }
      }
    }
  }
  final missing = packages.where((package) => !declared.contains(package));
  if (missing.isEmpty) {
    return;
  }
  await command(
    "Package installation.",
    [npm, "install", ...missing],
    workingDirectory: "cloudflare",
    runInShell: true,
  );
}

/// Set a Cloudflare Workers secret with `wrangler secret put`.
///
/// If [config] is specified, `-c <config>` is passed to target another Wrangler configuration
/// (e.g. `wrangler.region.jsonc`).
///
/// `wrangler secret put`でCloudflare Workersのシークレットを設定します。
///
/// [config]を指定すると`-c <config>`を渡し、別のWrangler設定（例：`wrangler.region.jsonc`）を対象にします。
Future<void> putWranglerSecret({
  required String wrangler,
  required String environment,
  required String name,
  required String value,
  String workingDirectory = "cloudflare",
  String? config,
}) async {
  if (isLocalApply) {
    throw StateError("--local ではCloudflare secretを更新できません。");
  }
  label("Set Cloudflare Workers secret: $name");
  final process = await Process.start(
    wrangler,
    [
      "secret",
      "put",
      name,
      "--env",
      environment,
      if (config != null) ...["-c", config],
    ],
    workingDirectory: workingDirectory,
    runInShell: true,
  );
  unawaited(stdout.addStream(process.stdout));
  unawaited(stderr.addStream(process.stderr));
  process.stdin.writeln(value);
  await process.stdin.close();
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception(
      "An error has occurred. Please check the log above for details.",
    );
  }
}

class _SourceRange {
  const _SourceRange(this.start, this.end);

  final int start;

  final int end;
}
