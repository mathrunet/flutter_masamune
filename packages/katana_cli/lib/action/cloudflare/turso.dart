// Dart imports:
import "dart:async";
import "dart:io";

// Project imports:
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
      "We will perform the deployment process for TursoDB with Cloudflare. Please register with Turso (https://turso.tech/) in advance, and create an organization, a group, and an API token. Cloudflare用のTursoDBのデプロイ処理を行います。予めTruso（https://turso.tech/）に登録し、組織とグループ、APIトークンを作成してください。";

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
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final turso = cloudflare.getAsMap("turso");
    final organization = turso.get("organization", "");
    final group = turso.get("group", "");
    final platformApiToken = turso.get("platform_api_token", "");
    if (organization.isEmpty) {
      error(
        "If [cloudflare]->[turso]->[enable] is enabled, please include [cloudflare]->[turso]->[organization].",
      );
      return;
    }
    if (group.isEmpty) {
      error(
        "If [cloudflare]->[turso]->[enable] is enabled, please include [cloudflare]->[turso]->[group].",
      );
      return;
    }
    if (platformApiToken.isEmpty) {
      error(
        "If [cloudflare]->[turso]->[enable] is enabled, please include [cloudflare]->[turso]->[platform_api_token].",
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
    label("Add Cloudflare Workers functions");
    final source = await indexFile.readAsString();
    final updated = _updateTursoFunctions(
      source,
      organization: organization,
      group: group,
    );
    if (updated == null) {
      return;
    }
    await indexFile.writeAsString(updated);
    await command(
      "Package installation.",
      [
        npm,
        "install",
        "@mathrunet/masamune_cloudflare_turso",
      ],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    await _putWranglerSecret(
      wrangler: wrangler,
      platformApiToken: platformApiToken,
    );
  }

  String? _updateTursoFunctions(
    String source, {
    required String organization,
    required String group,
  }) {
    final tursoFunction = _tursoFunction(
      "turso",
      organization: organization,
      group: group,
    );
    final tursoTokenFunction = _tursoFunction(
      "tursoToken",
      organization: organization,
      group: group,
    );
    var updated = _ensureTursoImport(source);
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
    required String organization,
    required String group,
  }) {
    return """
    turso.Functions.$name({
        organization: "$organization",
        group: "$group",
    }),""";
  }

  Future<void> _putWranglerSecret({
    required String wrangler,
    required String platformApiToken,
  }) async {
    label("Set Cloudflare Workers secret.");
    final process = await Process.start(
      wrangler,
      [
        "secret",
        "put",
        "TURSO_PLATFORM_API_TOKEN",
      ],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    unawaited(stdout.addStream(process.stdout));
    unawaited(stderr.addStream(process.stderr));
    process.stdin.writeln(platformApiToken);
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
