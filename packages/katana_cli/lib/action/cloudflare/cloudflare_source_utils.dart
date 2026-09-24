// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Utilities for editing `cloudflare/src/index.ts`.
///
/// `cloudflare/src/index.ts`を編集するためのユーティリティ。
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

  /// Returns true if [source] contains a call to [functionName].
  ///
  /// [source]に[functionName]の呼び出しが含まれている場合はtrueを返します。
  static bool containsFunctionCall(String source, String functionName) {
    return source.contains("$functionName(");
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

/// Apply Cloudflare Workers functions to `cloudflare/src/index.ts`.
///
/// Ensures the import of [package] with [alias], and inserts each entry of
/// [functions] (a map of function name to the code to insert) into
/// `m.deploy([...])` if it does not already exist. Existing calls are replaced.
///
/// `cloudflare/src/index.ts`にCloudflare WorkersのFunctionを適用します。
///
/// [alias]付きの[package]のimportを保証し、[functions]（関数名から挿入コードへのマップ)の
/// 各エントリーが存在しない場合は`m.deploy([...])`に挿入します。既存の呼び出しは置き換えられます。
Future<bool> applyCloudflareWorkersFunctions({
  required String alias,
  required String package,
  required Map<String, String> functions,
}) async {
  final indexFile = File("cloudflare/src/index.ts");
  if (!indexFile.existsSync()) {
    error(
      "The file `cloudflare/src/index.ts` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
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
    source = CloudflareSourceUtils.replaceFunctionCall(
      source,
      entry.key,
      entry.value,
    );
    if (!CloudflareSourceUtils.containsFunctionCall(source, entry.key)) {
      inserts.add(entry.value);
    }
  }
  final updated = CloudflareSourceUtils.insertDeployFunctions(source, inserts);
  if (updated == null) {
    error(
      "Could not find the Cloudflare deploy array in `cloudflare/src/index.ts`. Please check the namespace import and Workers entrypoint.",
    );
    return false;
  }
  await indexFile.writeAsString(updated);
  return true;
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
/// `wrangler secret put`でCloudflare Workersのシークレットを設定します。
Future<void> putWranglerSecret({
  required String wrangler,
  required String environment,
  required String name,
  required String value,
  String workingDirectory = "cloudflare",
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
