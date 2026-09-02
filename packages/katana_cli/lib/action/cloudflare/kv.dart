// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process for KV.
///
/// Cloudflare用のKVのデプロイ処理を行います。
class CloudflareKvCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for KV.
  ///
  /// Cloudflare用のKVのデプロイ処理を行います。
  const CloudflareKvCliAction();

  @override
  String get description =>
      "We will perform the deployment process for Cloudflare KV. Please create a KV namespace and set [cloudflare]->[kv]->[namespace_id]. Cloudflare KVのデプロイ処理を行います。予めKV namespaceを作成し、[cloudflare]->[kv]->[namespace_id]を設定してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final kv = cloudflare.getAsMap("kv");
    return kv.get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final kv = cloudflare.getAsMap("kv");
    final binding = kv.get("binding", "MASAMUNE_KV");
    final namespaceId = kv.get("namespace_id", "");
    final previewId = kv.get("preview_id", "");
    if (binding.isEmpty) {
      error(
        "If [cloudflare]->[kv]->[enable] is enabled, please include [cloudflare]->[kv]->[binding].",
      );
      return;
    }
    if (namespaceId.isEmpty) {
      error(
        "If [cloudflare]->[kv]->[enable] is enabled, please include [cloudflare]->[kv]->[namespace_id]. Create it with `wrangler kv namespace create $binding`.",
      );
      return;
    }
    final cloudflareDir = Directory("cloudflare");
    if (!cloudflareDir.existsSync()) {
      error(
        "The directory `cloudflare` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }
    final indexFile = File("cloudflare/src/index.ts");
    if (!indexFile.existsSync()) {
      error(
        "The file `cloudflare/src/index.ts` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }
    final wranglerFile = File("cloudflare/wrangler.jsonc");
    if (!wranglerFile.existsSync()) {
      error(
        "The file `cloudflare/wrangler.jsonc` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }

    await addFlutterImport(["masamune_model_cloudflare_kv"]);
    label("Add Cloudflare Workers functions");
    final source = await indexFile.readAsString();
    final updated = _updateKvFunctions(source, binding: binding);
    if (updated == null) {
      return;
    }
    await indexFile.writeAsString(updated);
    label("Add Cloudflare KV namespace binding");
    await wranglerFile.writeAsString(
      WranglerEnvironmentSynchronizer.transformEnvironment(
        WranglerEnvironmentSynchronizer.ensureEnvironment(
          await wranglerFile.readAsString(),
          flavor: flavor,
          workerName: cloudflare.get("project_id", ""),
        ),
        flavor: flavor,
        transform: (environment) => _updateWranglerKvNamespace(
          environment,
          binding: binding,
          namespaceId: namespaceId,
          previewId: previewId,
        ),
      ),
    );
    await installMissingCloudflarePackages(
      npm: npm,
      packages: const ["@mathrunet/masamune_cloudflare_kv"],
    );
    await addFlutterImport(
      [
        "masamune_model_cloudflare_kv",
      ],
    );
  }

  String? _updateKvFunctions(String source, {required String binding}) {
    final kvFunction = """
    kv.Functions.kv({ bindingName: "$binding" }),""";
    var updated = _ensureKvImport(source);
    updated = _replaceFunction(updated, "kv.Functions.kv", kvFunction);
    if (updated.contains("kv.Functions.kv(")) {
      return updated;
    }
    final deployFunctions = _findDeployFunctions(updated);
    if (deployFunctions == null) {
      error(
        "Could not find `m.deploy([` in `cloudflare/src/index.ts`. Please check the Cloudflare Workers entrypoint.",
      );
      return null;
    }
    final insert =
        "${_needsLeadingComma(updated, deployFunctions) ? "," : ""}\n$kvFunction";
    return updated.replaceRange(
      deployFunctions.end,
      deployFunctions.end,
      insert,
    );
  }

  String _ensureKvImport(String source) {
    const package = "@mathrunet/masamune_cloudflare_kv";
    const import = 'import * as kv from "$package";';
    final kvImport = RegExp(
      r'^import \* as \w+ from "@mathrunet/masamune_cloudflare_kv";$',
      multiLine: true,
    ).firstMatch(source);
    if (kvImport != null) {
      return source.replaceRange(kvImport.start, kvImport.end, import);
    }
    final imports = RegExp(r"^import .+;$", multiLine: true).allMatches(source);
    if (imports.isEmpty) {
      return "$import\n$source";
    }
    final lastImport = imports.last;
    return source.replaceRange(lastImport.end, lastImport.end, "\n$import");
  }

  String _replaceFunction(
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

  _SourceRange? _findDeployFunctions(String source) {
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

  bool _needsLeadingComma(String source, _SourceRange range) {
    for (var i = range.end - 1; i >= range.start; i--) {
      final char = source[i];
      if (char.trim().isEmpty) {
        continue;
      }
      return char != ",";
    }
    return false;
  }

  _SourceRange? _findFunctionCall(
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

  int _findClosing(
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

  String _updateWranglerKvNamespace(
    String source, {
    required String binding,
    required String namespaceId,
    required String previewId,
  }) {
    final namespace = _kvNamespace(
      binding: binding,
      namespaceId: namespaceId,
      previewId: previewId,
    );
    final kvNamespaces = """
\t"kv_namespaces": [
$namespace
\t],""";
    final kvPattern = RegExp(
      r'"kv_namespaces"\s*:\s*\[[\s\S]*?\],?',
      multiLine: true,
    );
    if (kvPattern.hasMatch(source)) {
      return source.replaceFirst(kvPattern, kvNamespaces);
    }
    final uploadSourceMaps = RegExp(r'"upload_source_maps"\s*:\s*true,?');
    if (uploadSourceMaps.hasMatch(source)) {
      return source.replaceFirstMapped(uploadSourceMaps, (match) {
        return '${match.group(0)!.replaceAll(RegExp(r",$"), "")},\n$kvNamespaces';
      });
    }
    final lastBrace = source.lastIndexOf("}");
    if (lastBrace < 0) {
      return source;
    }
    return source.replaceRange(
      lastBrace,
      lastBrace,
      "\t,\n$kvNamespaces\n",
    );
  }

  String _kvNamespace({
    required String binding,
    required String namespaceId,
    required String previewId,
  }) {
    return """
\t\t{
\t\t\t"binding": "$binding",
\t\t\t"id": "$namespaceId"${previewId.isEmpty ? "" : ","}
${previewId.isEmpty ? "" : '\t\t\t"preview_id": "$previewId"'}
\t\t}""";
  }
}

class _SourceRange {
  const _SourceRange(this.start, this.end);

  final int start;
  final int end;
}
