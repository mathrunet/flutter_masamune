// Dart imports:
import "dart:async";
import "dart:io";
import "dart:math";

// Package imports:
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process for TiDB.
///
/// Cloudflare用のTiDBのデプロイ処理を行います。
class CloudflareTidbCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for TiDB.
  ///
  /// Cloudflare用のTiDBのデプロイ処理を行います。
  const CloudflareTidbCliAction();

  @override
  String get description =>
      "We will perform the deployment process for TiDB with Cloudflare. Please create a TiDB Cloud database and set [cloudflare]->[tidb]->[connection_url]. Cloudflare用のTiDBのデプロイ処理を行います。予めTiDB Cloudのデータベースを作成し、[cloudflare]->[tidb]->[connection_url]を設定してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final tidb = cloudflare.getAsMap("tidb");
    return tidb.get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final tidb = cloudflare.getAsMap("tidb");
    final connectionUrl = tidb.get("connection_url", "");
    if (connectionUrl.isEmpty) {
      error(
        "If [cloudflare]->[tidb]->[enable] is enabled, please include [cloudflare]->[tidb]->[connection_url].",
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

    final secrets = await _loadOrCreateSecrets(context, connectionUrl);
    await addFlutterImport(["masamune_model_tidb"]);
    label("Add Cloudflare Workers functions");
    final source = await indexFile.readAsString();
    final updated = _updateTidbFunctions(source);
    if (updated == null) {
      return;
    }
    await indexFile.writeAsString(updated);
    await command(
      "Package installation.",
      [
        npm,
        "install",
        "@mathrunet/masamune_cloudflare_tidb",
      ],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    await addFlutterImport(
      [
        "masamune_model_tidb",
      ],
    );
    await _putWranglerSecrets(wrangler: wrangler, secrets: secrets);
  }

  Future<Map<String, String>> _loadOrCreateSecrets(
    ExecContext context,
    String connectionUrl,
  ) async {
    final file = File("katana_secrets.yaml");
    final root = file.existsSync()
        ? Map<String, dynamic>.from(
            modifize(loadYaml(await file.readAsString())) as Map? ?? {},
          )
        : <String, dynamic>{};
    final cloudflare = _map(root, "cloudflare");
    final tidb = _map(cloudflare, "tidb");
    final projectId = _projectId(context);
    tidb["connection_url"] = connectionUrl;
    tidb["jwt_issuer"] = _string(tidb["jwt_issuer"]) ?? "$projectId-tidb-auth";
    tidb["jwt_kid"] = _string(tidb["jwt_kid"]) ??
        "tidb-key-${DateTime.now().toIso8601String().substring(0, 10).replaceAll("-", "")}-${_randomToken(6)}";
    tidb["jwt_private_key_pem"] =
        _string(tidb["jwt_private_key_pem"]) ?? await _generatePrivateKeyPem();
    final usernamePrefix = _tidbCloudUsernamePrefix(connectionUrl);
    tidb["direct_read_username"] = _applyTidbCloudUsernamePrefix(
      _string(tidb["direct_read_username"]) ?? "${projectId}_tidb_read",
      usernamePrefix,
    );
    tidb["direct_write_username"] = _applyTidbCloudUsernamePrefix(
      _string(tidb["direct_write_username"]) ?? "${projectId}_tidb_write",
      usernamePrefix,
    );
    tidb["direct_read_write_username"] = _applyTidbCloudUsernamePrefix(
      _string(tidb["direct_read_write_username"]) ??
          "${projectId}_tidb_read_write",
      usernamePrefix,
    );
    await file.writeAsString(YamlWriter().write(root));
    return {
      "TIDB_CONNECTION_URL": tidb["connection_url"] as String,
      "TIDB_JWT_ISSUER": tidb["jwt_issuer"] as String,
      "TIDB_JWT_KID": tidb["jwt_kid"] as String,
      "TIDB_JWT_PRIVATE_KEY_PEM": tidb["jwt_private_key_pem"] as String,
      "TIDB_DIRECT_READ_USERNAME": tidb["direct_read_username"] as String,
      "TIDB_DIRECT_WRITE_USERNAME": tidb["direct_write_username"] as String,
      "TIDB_DIRECT_READ_WRITE_USERNAME":
          tidb["direct_read_write_username"] as String,
    };
  }

  Map<String, dynamic> _map(Map<String, dynamic> parent, String key) {
    final value = parent[key];
    if (value is Map) {
      return parent[key] = Map<String, dynamic>.from(value);
    }
    return parent[key] = <String, dynamic>{};
  }

  String? _string(Object? value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  String _projectId(ExecContext context) {
    final firebaseProjectId =
        context.yaml.getAsMap("firebase").get("project_id", "");
    final base = firebaseProjectId.isNotEmpty
        ? firebaseProjectId
        : Directory.current.path.split(Platform.pathSeparator).last;
    return base
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9_]+"), "_")
        .replaceAll(RegExp(r"_+"), "_")
        .trimString("_");
  }

  String? _tidbCloudUsernamePrefix(String connectionUrl) {
    final uri = Uri.tryParse(connectionUrl);
    final userInfo = uri?.userInfo;
    if (userInfo == null || userInfo.isEmpty) {
      return null;
    }
    final username = Uri.decodeComponent(userInfo.split(":").first);
    final separator = username.indexOf(".");
    if (separator <= 0) {
      return null;
    }
    return username.substring(0, separator);
  }

  String _applyTidbCloudUsernamePrefix(String username, String? prefix) {
    if (prefix == null || prefix.isEmpty || username.contains(".")) {
      return username;
    }
    return "$prefix.$username";
  }

  String _randomToken(int length) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    final random = Random.secure();
    return String.fromCharCodes(
      List.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  Future<String> _generatePrivateKeyPem() async {
    final result = await Process.run(
      "openssl",
      ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048"],
      runInShell: true,
    );
    if (result.exitCode != 0) {
      throw Exception(
        "Failed to generate TiDB JWT private key. Please install openssl.",
      );
    }
    return (result.stdout as String).trim();
  }

  String? _updateTidbFunctions(String source) {
    const tidbFunction = """
    tidb.Functions.tidb(),""";
    const tidbTokenFunction = """
    tidb.Functions.tidbToken(),""";
    var updated = _ensureTidbImport(source);
    updated = _replaceFunction(updated, "tidb.Functions.tidb", tidbFunction);
    updated = _replaceFunction(
      updated,
      "tidb.Functions.tidbToken",
      tidbTokenFunction,
    );
    final functions = <String>[
      if (!updated.contains("tidb.Functions.tidb(")) tidbFunction,
      if (!updated.contains("tidb.Functions.tidbToken(")) tidbTokenFunction,
    ];
    if (functions.isEmpty) {
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
        "${_needsLeadingComma(updated, deployFunctions) ? "," : ""}\n${functions.join("\n")}";
    return updated.replaceRange(
      deployFunctions.end,
      deployFunctions.end,
      insert,
    );
  }

  String _ensureTidbImport(String source) {
    const package = "@mathrunet/masamune_cloudflare_tidb";
    const import = 'import * as tidb from "$package";';
    final tidbImport = RegExp(
      r'^import \* as \w+ from "@mathrunet/masamune_cloudflare_tidb";$',
      multiLine: true,
    ).firstMatch(source);
    if (tidbImport != null) {
      return source.replaceRange(tidbImport.start, tidbImport.end, import);
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

  Future<void> _putWranglerSecrets({
    required String wrangler,
    required Map<String, String> secrets,
  }) async {
    label("Set Cloudflare Workers secrets.");
    for (final entry in secrets.entries) {
      final process = await Process.start(
        wrangler,
        ["secret", "put", entry.key],
        workingDirectory: "cloudflare",
        runInShell: true,
      );
      unawaited(stdout.addStream(process.stdout));
      unawaited(stderr.addStream(process.stderr));
      process.stdin.writeln(entry.value);
      await process.stdin.close();
      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        throw Exception(
          "An error has occurred. Please check the log above for details.",
        );
      }
    }
  }
}

class _SourceRange {
  const _SourceRange(this.start, this.end);

  final int start;

  final int end;
}
