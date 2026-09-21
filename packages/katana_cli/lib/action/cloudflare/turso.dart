// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process for Turso.
///
/// Cloudflare用のTursoのデプロイ処理を行います。
class CloudflareTursoCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for Turso.
  ///
  /// Cloudflare用のTursoのデプロイ処理を行います。
  const CloudflareTursoCliAction();

  @override
  String get description =>
      "Deploy TursoDB (MVCC) with Cloudflare. Enable Concurrent Writes in Turso Dashboard Settings > General, then prepare an organization, group, and API token. Cloudflare用のTursoDB（MVCC）をデプロイします。Turso DashboardのSettings > GeneralでConcurrent Writesを有効化し、組織・グループ・APIトークンを準備してください。既存のSQLite型DBは利用できません。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final turso = cloudflare.getAsMap("turso");
    final enableTurso = turso.get("enable", false);
    return enableTurso;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final turso = cloudflare.getAsMap("turso");
    final secretTurso =
        context.secrets.getAsMap("cloudflare").getAsMap("turso");
    final organization = turso.get("organization", "");
    final group = turso.get("group", "");
    final groups = parseTursoGroups(turso["groups"]);
    final secretPlatformApiToken = secretTurso.get("platform_api_token", "");
    final platformApiToken = secretPlatformApiToken.isNotEmpty
        ? secretPlatformApiToken
        : turso.get("platform_api_token", "");
    final serverTokenTtl = turso.get("server_token_ttl", 3600);
    final schemaManifestPath = turso.get(
      "schema_manifest",
      "tidb/schema/schema.json",
    );
    final rotateLegacyTokens = turso.get("rotate_legacy_tokens", false);
    if (organization.isEmpty) {
      error(
        "If [cloudflare]->[turso]->[enable] is enabled, please include [cloudflare]->[turso]->[organization].",
      );
      return;
    }
    if (group.isEmpty && groups.isEmpty) {
      error(
        "If [cloudflare]->[turso]->[enable] is enabled, please include [cloudflare]->[turso]->[group] or [groups].",
      );
      return;
    }
    if (groups.isNotEmpty &&
        group.isNotEmpty &&
        !groups.any((item) => item["name"] == group)) {
      throw const FormatException("既定groupはgroupsに含めてください。");
    }
    if (platformApiToken.isEmpty) {
      error(
        "If [cloudflare]->[turso]->[enable] is enabled, please include [cloudflare]->[turso]->[platform_api_token] in `katana_secrets.yaml` or `katana.yaml`.",
      );
      return;
    }
    if (serverTokenTtl <= 60) {
      error(
        "[cloudflare]->[turso]->[server_token_ttl] must be an integer greater than 60.",
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
      error("The file `cloudflare/wrangler.jsonc` does not exist.");
      return;
    }
    final wranglerSource = WranglerEnvironmentSynchronizer.ensureEnvironment(
      await wranglerFile.readAsString(),
      flavor: flavor,
      workerName: cloudflare.get("project_id", ""),
    );
    await wranglerFile.writeAsString(
      WranglerEnvironmentSynchronizer.upsertVariables(
        wranglerSource,
        flavor: flavor,
        values: {
          "TURSO_ORGANIZATION": organization,
          "TURSO_GROUP": group,
          "TURSO_GROUPS": groups.isEmpty ? "" : jsonEncode(groups),
          "TURSO_SERVER_TOKEN_TTL_SECONDS": serverTokenTtl.toString(),
        },
      ),
    );
    await addFlutterImport(
      [
        "masamune_model_turso",
      ],
    );
    label(
      "Use the TursoDB engine. Existing SQLite databases with the same name must be migrated first.",
    );
    label("Add Cloudflare Workers functions");
    final schemaManifest = File(schemaManifestPath);
    final useSchemaManifest = schemaManifest.existsSync();
    if (useSchemaManifest) {
      final schema = jsonDecode(await schemaManifest.readAsString()) as Map;
      final tables = schema["tables"];
      final compatible = tables is List
          ? {
              "version": schema["sourceHash"] ?? schema["version"],
              "tables": {
                for (final table in tables)
                  "${table["database"]}\u0000${table["table"]}": {
                    "database": table["database"],
                    "table": table["table"],
                    "columns": [
                      for (final column in table["columns"])
                        {
                          "name": column["name"],
                          "type": tursoNativeColumnType(
                              column["sqlType"] as String),
                          if (column["vectorMetric"] != null)
                            "vectorMetric": column["vectorMetric"]
                        }
                    ],
                  }
              },
            }
          : schema;
      await File("cloudflare/src/turso_schema_manifest.json")
          .writeAsString(jsonEncode(compatible));
    } else {
      label(
        "Turso schema manifest was not found at `$schemaManifestPath`; runtime value inference remains enabled.",
      );
    }
    final source = await indexFile.readAsString();
    final updated = updateTursoFunctions(
      source,
      useSchemaManifest: useSchemaManifest,
    );
    if (updated == null) {
      return;
    }
    await indexFile.writeAsString(updated);
    await installMissingCloudflarePackages(
      npm: npm,
      packages: const ["@mathrunet/masamune_cloudflare_turso"],
    );
    await putWranglerSecret(
      wrangler: wrangler,
      environment: flavor,
      name: "TURSO_PLATFORM_API_TOKEN",
      value: platformApiToken,
    );
    if (rotateLegacyTokens) {
      for (final name in groups.isEmpty
          ? [group]
          : groups.map((item) => item["name"] as String)) {
        await _rotateLegacyTokens(
          organization: organization,
          group: name,
          platformApiToken: platformApiToken,
        );
      }
    }
  }

  /// 既存のオプション・resolverを保持してTurso関数を追加します。
  String? updateTursoFunctions(
    String source, {
    required bool useSchemaManifest,
  }) {
    final tursoFunction = _tursoFunction(
      "turso",
      useSchemaManifest: useSchemaManifest,
    );
    final tursoTokenFunction = _tursoFunction(
      "tursoToken",
      useSchemaManifest: useSchemaManifest,
    );
    var updated = _ensureTursoImport(source);
    if (useSchemaManifest) {
      updated = _ensureSchemaManifestImport(updated);
    }
    updated = _replaceFunction(updated, "turso.Functions.turso", tursoFunction);
    updated = _replaceFunction(
      updated,
      "turso.Functions.tursoToken",
      tursoTokenFunction,
    );
    final functions = <String>[
      if (!updated.contains("turso.Functions.turso(")) tursoFunction,
      if (!updated.contains("turso.Functions.tursoToken(")) tursoTokenFunction,
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

  String _ensureTursoImport(String source) {
    const package = "@mathrunet/masamune_cloudflare_turso";
    const import = 'import * as turso from "$package";';
    final tursoImport = RegExp(
      r'^import \* as \w+ from "@mathrunet/masamune_cloudflare_turso";$',
      multiLine: true,
    ).firstMatch(source);
    if (tursoImport != null) {
      return source.replaceRange(tursoImport.start, tursoImport.end, import);
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

  String _ensureSchemaManifestImport(String source) {
    const statement =
        'import tursoSchemaManifest from "./turso_schema_manifest.json";';
    if (source.contains(statement)) {
      return source;
    }
    final imports = RegExp(r"^import .+;$", multiLine: true).allMatches(source);
    if (imports.isEmpty) {
      return "$statement\n$source";
    }
    return source.replaceRange(
      imports.last.end,
      imports.last.end,
      "\n$statement",
    );
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
      // ユーザーのgroups/resolverや共通設定への参照を削除しません。
      final call = updated.substring(range.start, range.end);
      final next = replaced ? "" : _mergeFunctionDefaults(call, replacement);
      updated = updated.replaceRange(range.start, range.end, next);
      searchStart = range.start + next.length;
      replaced = true;
    }
    return updated;
  }

  String _mergeFunctionDefaults(String call, String replacement) {
    final open = call.indexOf("(");
    final close = _findClosing(call, open, "(", ")");
    final argument = call.substring(open + 1, close).trim();
    if (argument.isEmpty) {
      return replacement;
    }
    // 共通設定オブジェクトへの参照はアプリ側が所有します。
    if (!argument.startsWith("{") ||
        _findClosing(argument, 0, "{", "}") != argument.length - 1) {
      return call;
    }
    final additions = <String>[];
    for (final property in ["autoCreateDatabase", "schemaManifest"]) {
      if (RegExp("\\b$property\\b").hasMatch(argument)) {
        continue;
      }
      final match = RegExp("$property: ([^\\n]+),").firstMatch(replacement);
      if (match != null) {
        additions.add("        $property: ${match[1]},");
      }
    }
    if (additions.isEmpty) {
      return call;
    }
    final objectStart = call.indexOf("{", open);
    return call.replaceRange(
        objectStart + 1, objectStart + 1, "\n${additions.join("\n")}\n");
  }

  /// katana.yamlのグループ定義を検証します。名前の順序がfallback順です。
  static List<Map<String, dynamic>> parseTursoGroups(Object? value) {
    if (value == null) {
      return const [];
    }
    if (value is! List) {
      throw const FormatException("turso.groupsは配列で指定してください。");
    }
    final names = <String>{};
    final countryCodes = <String>{};
    final continentCodes = <String>{};
    return value.map((item) {
      if (item is! Map ||
          item["name"] is! String ||
          !RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(item["name"] as String) ||
          !names.add(item["name"] as String)) {
        throw const FormatException("turso.groupsのnameは重複しない識別子が必要です。");
      }
      final result = <String, dynamic>{"name": item["name"]};
      for (final key in ["countries", "continents"]) {
        final codes = item[key];
        if (codes == null) {
          continue;
        }
        final seen = key == "countries" ? countryCodes : continentCodes;
        if (codes is! List ||
            codes.any((code) =>
                code is! String ||
                !RegExp(r"^[A-Z]{2}$").hasMatch(code) ||
                (key == "continents" &&
                    !const ["AF", "AN", "AS", "EU", "NA", "OC", "SA"]
                        .contains(code)))) {
          throw FormatException("turso.groups.$keyは大文字の地域コード配列が必要です。");
        }
        for (final code in codes.cast<String>()) {
          if (!seen.add(code)) {
            throw FormatException("turso.groups.$keyが重複しています: $code");
          }
        }
        result[key] = codes.cast<String>().toList();
      }
      return result;
    }).toList();
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
    while (true) {
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

  String _tursoFunction(
    String name, {
    required bool useSchemaManifest,
  }) {
    return """
    turso.Functions.$name({
        autoCreateDatabase: true,
${useSchemaManifest ? "        schemaManifest: tursoSchemaManifest as turso.TursoSchemaManifest,\n" : ""}    }),""";
  }

  Future<void> _rotateLegacyTokens({
    required String organization,
    required String group,
    required String platformApiToken,
  }) async {
    label("Rotate legacy Turso group tokens.");
    final client = HttpClient();
    final request = await client.postUrl(
      Uri.parse(
        "https://api.turso.tech/v1/organizations/"
        "${Uri.encodeComponent(organization)}/groups/"
        "${Uri.encodeComponent(group)}/auth/rotate",
      ),
    );
    request.headers
      ..set(HttpHeaders.authorizationHeader, "Bearer $platformApiToken")
      ..set(HttpHeaders.contentTypeHeader, "application/json");
    request.write("{}");
    final response = await request.close();
    await response.drain<void>();
    client.close();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        "Failed to rotate Turso legacy tokens: ${response.statusCode}.",
      );
    }
  }
}

class _SourceRange {
  const _SourceRange(this.start, this.end);

  final int start;

  final int end;
}

/// 共通schemaのVECTOR列をTursoDBのnative vector列へ対応付ける。
String tursoNativeColumnType(String type) {
  final normalized = type.trim().toUpperCase();
  final match = RegExp(r"^VECTOR\(([1-9][0-9]*)\)$").firstMatch(normalized);
  if (match == null) {
    return type;
  }
  if (int.parse(match.group(1)!) > 16383) {
    throw ArgumentError("VECTOR dimensionsは1〜16383です。");
  }
  return normalized.replaceFirst("VECTOR", "F32_BLOB");
}
