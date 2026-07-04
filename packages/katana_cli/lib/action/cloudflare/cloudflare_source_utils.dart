// Dart imports:
import "dart:async";
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
    final deployStart = source.indexOf("m.deploy(");
    if (deployStart < 0) {
      return null;
    }
    final functionsStart = source.indexOf("[", deployStart);
    if (functionsStart < 0) {
      return null;
    }
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
      "Could not find `m.deploy([` in `cloudflare/src/index.ts`. Please check the Cloudflare Workers entrypoint.",
    );
    return false;
  }
  await indexFile.writeAsString(updated);
  return true;
}

/// Set a Cloudflare Workers secret with `wrangler secret put`.
///
/// `wrangler secret put`でCloudflare Workersのシークレットを設定します。
Future<void> putWranglerSecret({
  required String wrangler,
  required String name,
  required String value,
  String workingDirectory = "cloudflare",
}) async {
  label("Set Cloudflare Workers secret: $name");
  final process = await Process.start(
    wrangler,
    [
      "secret",
      "put",
      name,
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
