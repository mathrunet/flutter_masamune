// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:math";

// Package imports:
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process for R2 Storage.
///
/// Cloudflare用のR2 Storageのデプロイ処理を行います。
class CloudflareStorageCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for R2 Storage.
  ///
  /// Cloudflare用のR2 Storageのデプロイ処理を行います。
  const CloudflareStorageCliAction();

  @override
  String get description =>
      "We will perform the deployment process for Cloudflare R2 Storage. Please create an R2 bucket and set [cloudflare]->[storage]->[bucket_name]. Cloudflare R2 Storageのデプロイ処理を行います。予めR2 bucketを作成し、[cloudflare]->[storage]->[bucket_name]を設定してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final storage = cloudflare.getAsMap("storage");
    return storage.get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final storage = cloudflare.getAsMap("storage");
    final binding = storage.get("binding", "R2_BUCKET");
    final bucketName = storage.get("bucket_name", "");
    final previewBucketName = storage.get("preview_bucket_name", "");
    final publicBaseUrl = storage.get("public_base_url", "");
    final configuredDownloadUrlSecret = storage.get("download_url_secret", "");
    if (binding.isEmpty) {
      error(
        "If [cloudflare]->[storage]->[enable] is enabled, please include [cloudflare]->[storage]->[binding].",
      );
      return;
    }
    if (bucketName.isEmpty) {
      error(
        "If [cloudflare]->[storage]->[enable] is enabled, please include [cloudflare]->[storage]->[bucket_name]. Create it with `wrangler r2 bucket create <bucket_name>`.",
      );
      return;
    }
    if (publicBaseUrl.isEmpty) {
      error(
        "If [cloudflare]->[storage]->[enable] is enabled, please include [cloudflare]->[storage]->[public_base_url].",
      );
      return;
    }
    final downloadUrlSecret =
        await _loadOrCreateDownloadUrlSecret(configuredDownloadUrlSecret);
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

    label("Add Cloudflare Workers functions");
    final source = await indexFile.readAsString();
    final updated = _updateStorageFunctions(
      source,
      binding: binding,
      publicBaseUrl: publicBaseUrl,
    );
    if (updated == null) {
      return;
    }
    await indexFile.writeAsString(updated);
    label("Add Cloudflare R2 bucket binding");
    await wranglerFile.writeAsString(_updateWranglerR2Bucket(
      await wranglerFile.readAsString(),
      binding: binding,
      bucketName: bucketName,
      previewBucketName: previewBucketName,
    ));
    await command(
      "Package installation.",
      [
        npm,
        "install",
        "@mathrunet/masamune_cloudflare_storage",
      ],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    await addFlutterImport(
      [
        "masamune_storage_cloudflare",
      ],
    );
    await _putWranglerSecret(
      wrangler: wrangler,
      key: "STORAGE_DOWNLOAD_URL_SECRET",
      value: downloadUrlSecret,
    );
  }

  Future<String> _loadOrCreateDownloadUrlSecret(String configuredSecret) async {
    final file = File("katana_secrets.yaml");
    final root = file.existsSync()
        ? Map<String, dynamic>.from(
            modifize(loadYaml(await file.readAsString())) as Map? ?? {},
          )
        : <String, dynamic>{};
    final cloudflare = _map(root, "cloudflare");
    final storage = _map(cloudflare, "storage");
    final storedSecret = storage["download_url_secret"];
    final secret = configuredSecret.isNotEmpty
        ? configuredSecret
        : storedSecret is String && storedSecret.isNotEmpty
            ? storedSecret
            : _generateDownloadUrlSecret();
    storage["download_url_secret"] = secret;
    await file.writeAsString(YamlWriter().write(root));
    return secret;
  }

  Map<String, dynamic> _map(Map<String, dynamic> parent, String key) {
    final value = parent[key];
    if (value is Map) {
      return parent[key] = Map<String, dynamic>.from(value);
    }
    return parent[key] = <String, dynamic>{};
  }

  String _generateDownloadUrlSecret() {
    final random = Random.secure();
    final bytes = List<int>.generate(48, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String? _updateStorageFunctions(
    String source, {
    required String binding,
    required String publicBaseUrl,
  }) {
    final storageFunction = """
    storage.Functions.storageCloudflare({
        bucketBindingName: "$binding",
        publicBaseUrl: "$publicBaseUrl",
    }),""";
    var updated = _ensureStorageImport(source);
    updated = _replaceFunction(
      updated,
      "storage.Functions.storageCloudflare",
      storageFunction,
    );
    if (updated.contains("storage.Functions.storageCloudflare(")) {
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
        "${_needsLeadingComma(updated, deployFunctions) ? "," : ""}\n$storageFunction";
    return updated.replaceRange(
      deployFunctions.end,
      deployFunctions.end,
      insert,
    );
  }

  String _ensureStorageImport(String source) {
    const package = "@mathrunet/masamune_cloudflare_storage";
    const import = 'import * as storage from "$package";';
    final storageImport = RegExp(
      r'^import \* as \w+ from "@mathrunet/masamune_cloudflare_storage";$',
      multiLine: true,
    ).firstMatch(source);
    if (storageImport != null) {
      return source.replaceRange(
          storageImport.start, storageImport.end, import);
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

  String _updateWranglerR2Bucket(
    String source, {
    required String binding,
    required String bucketName,
    required String previewBucketName,
  }) {
    final bucket = _r2Bucket(
      binding: binding,
      bucketName: bucketName,
      previewBucketName: previewBucketName,
    );
    final r2Buckets = """
\t"r2_buckets": [
$bucket
\t],""";
    final r2Pattern = RegExp(
      r'"r2_buckets"\s*:\s*\[[\s\S]*?\],?',
      multiLine: true,
    );
    if (r2Pattern.hasMatch(source)) {
      return source.replaceFirst(r2Pattern, r2Buckets);
    }
    final uploadSourceMaps = RegExp(r'"upload_source_maps"\s*:\s*true,?');
    if (uploadSourceMaps.hasMatch(source)) {
      return source.replaceFirstMapped(uploadSourceMaps, (match) {
        return '${match.group(0)!.replaceAll(RegExp(r",$"), "")},\n$r2Buckets';
      });
    }
    final lastBrace = source.lastIndexOf("}");
    if (lastBrace < 0) {
      return source;
    }
    return source.replaceRange(
      lastBrace,
      lastBrace,
      "\t,\n$r2Buckets\n",
    );
  }

  String _r2Bucket({
    required String binding,
    required String bucketName,
    required String previewBucketName,
  }) {
    return """
\t\t{
\t\t\t"binding": "$binding",
\t\t\t"bucket_name": "$bucketName"${previewBucketName.isEmpty ? "" : ","}
${previewBucketName.isEmpty ? "" : '\t\t\t"preview_bucket_name": "$previewBucketName"'}
\t\t}""";
  }

  Future<void> _putWranglerSecret({
    required String wrangler,
    required String key,
    required String value,
  }) async {
    label("Set Cloudflare Workers secrets.");
    final process = await Process.start(
      wrangler,
      ["secret", "put", key],
      workingDirectory: "cloudflare",
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
}

class _SourceRange {
  const _SourceRange(this.start, this.end);

  final int start;
  final int end;
}
