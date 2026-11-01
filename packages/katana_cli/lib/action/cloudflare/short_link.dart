// Dart imports:
import "dart:convert";
import "dart:io";
import "dart:math";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process for short links.
///
/// Cloudflare用の短縮URLのデプロイ処理を行います。
class CloudflareShortLinkCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for short links.
  ///
  /// Cloudflare用の短縮URLのデプロイ処理を行います。
  const CloudflareShortLinkCliAction();

  @override
  String get description =>
      "We will perform the deployment process for short links with campaign parameters on Cloudflare Workers and KV. Please create a KV namespace and set [cloudflare]->[short_link]->[namespace_id]. キャンペーンパラメータ付き短縮URLのCloudflare Workers・KVへのデプロイ処理を行います。予めKV namespaceを作成し、[cloudflare]->[short_link]->[namespace_id]を設定してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final shortLink = cloudflare.getAsMap("short_link");
    return shortLink.get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final shortLink = cloudflare.getAsMap("short_link");
    final binding = shortLink.get("binding", "SHORT_LINK_KV");
    final namespaceId = shortLink.get("namespace_id", "");
    final path = shortLink.get("path", "s").replaceAll(RegExp(r"^/+|/+$"), "");
    final adminPath = shortLink
        .get("admin_path", "short_link")
        .replaceAll(RegExp(r"^/+|/+$"), "");
    final notFoundUrl = shortLink.get("not_found_url", "");
    final allowedHosts = _stringList(shortLink["allowed_hosts"]);
    final routeHosts = _stringList(shortLink["routes"]);
    final resolveDestination = shortLink.getAsMap("resolve_destination");
    final resolveDestinationName = resolveDestination.get("name", "").trim();
    final resolveDestinationFrom = resolveDestination.get("from", "").trim();
    if (resolveDestinationName.isNotEmpty &&
        (!RegExp(r"^[A-Za-z_$][A-Za-z0-9_$]*$")
                .hasMatch(resolveDestinationName) ||
            !resolveDestinationFrom.startsWith("./"))) {
      error(
        "[cloudflare]->[short_link]->[resolve_destination] requires [name] (an exported function name) and [from] (a path relative to `cloudflare/src` starting with `./`).",
      );
      return;
    }
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(binding)) {
      error(
        "If [cloudflare]->[short_link]->[enable] is enabled, please include a valid [cloudflare]->[short_link]->[binding].",
      );
      return;
    }
    if (namespaceId.isEmpty) {
      error(
        "If [cloudflare]->[short_link]->[enable] is enabled, please include [cloudflare]->[short_link]->[namespace_id]. Create it with `wrangler kv namespace create $binding`.",
      );
      return;
    }
    if (path.isEmpty || adminPath.isEmpty || path == adminPath) {
      error(
        "[cloudflare]->[short_link]->[path] and [admin_path] must be different non-empty paths.",
      );
      return;
    }
    if (allowedHosts.isEmpty) {
      label(
        "Warning: [cloudflare]->[short_link]->[allowed_hosts] is empty. Every https host can be used as a destination.",
      );
    }
    final wranglerFile = File("cloudflare/wrangler.jsonc");
    if (!wranglerFile.existsSync()) {
      error(
        "The file `cloudflare/wrangler.jsonc` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }

    label("Add Cloudflare Workers functions");
    final options = buildCloudflareShortLinkOptions(
      binding: binding,
      allowedHosts: allowedHosts,
      notFoundUrl: notFoundUrl,
    );
    final applied = await applyCloudflareWorkersFunctions(
      alias: "shortLink",
      package: "@mathrunet/masamune_cloudflare_short_link",
      functions: {
        "shortLink.Functions.shortLink":
            "    shortLink.Functions.shortLink(${_withResolveDestination(_withPath(options, path, "s"), resolveDestinationName)}),",
        "shortLink.Functions.shortLinkAdmin":
            "    shortLink.Functions.shortLinkAdmin(${_withPath(options, adminPath, "short_link")}),",
      },
    );
    if (!applied) {
      return;
    }
    if (resolveDestinationName.isNotEmpty) {
      final entry = File(cloudflareEdgeEntryPath);
      await entry.writeAsString(
        CloudflareSourceUtils.ensureNamedImport(
          await entry.readAsString(),
          name: resolveDestinationName,
          from: resolveDestinationFrom,
        ),
      );
    }

    label("Add Cloudflare KV namespace binding and routes");
    var wranglerSource = WranglerEnvironmentSynchronizer.ensureEnvironment(
      await wranglerFile.readAsString(),
      flavor: flavor,
      workerName: cloudflare.get("project_id", ""),
    );
    wranglerSource = WranglerEnvironmentSynchronizer.transformEnvironment(
      wranglerSource,
      flavor: flavor,
      transform: (environment) => upsertCloudflareKvNamespace(
        environment,
        binding: binding,
        namespaceId: namespaceId,
      ),
    );
    wranglerSource = WranglerEnvironmentSynchronizer.addZoneRoutes(
      wranglerSource,
      flavor: flavor,
      patterns: {
        for (final host in routeHosts)
          "https://$host/$path/*": _zoneName(host, cloudflare),
      },
    );
    await wranglerFile.writeAsString(wranglerSource);

    await installMissingCloudflarePackages(
      npm: npm,
      packages: const ["@mathrunet/masamune_cloudflare_short_link"],
    );
    if (!isLocalApply) {
      await _ensureAdminToken(wrangler: wrangler, flavor: flavor);
    }
  }

  Future<void> _ensureAdminToken({
    required String wrangler,
    required String flavor,
  }) async {
    const name = "SHORT_LINK_ADMIN_TOKEN";
    final result = await Process.run(
      wrangler,
      ["secret", "list", "--env", flavor, "--format", "json"],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    if (result.exitCode == 0) {
      try {
        final secrets = jsonDecode(result.stdout.toString()) as List;
        if (secrets.any((secret) => secret is Map && secret["name"] == name)) {
          return;
        }
      } catch (_) {
        // Fall through and create the token.
      }
    } else {
      label(
        "Warning: Could not list Cloudflare Workers secrets. Set `$name` manually with `wrangler secret put $name --env $flavor`.",
      );
      return;
    }
    final random = Random.secure();
    final token = base64UrlEncode(
      List<int>.generate(32, (_) => random.nextInt(256)),
    ).replaceAll("=", "");
    await putWranglerSecret(
      wrangler: wrangler,
      environment: flavor,
      name: name,
      value: token,
    );
    // ignore: avoid_print
    print(
      "\n$name ($flavor) has been generated. Store it in a password manager now; it will not be shown again.\n$token\n",
    );
  }

  String _zoneName(String host, Map cloudflare) {
    final configured =
        cloudflare.getAsMap("short_link").get("zone_name", "").trim();
    if (configured.isNotEmpty) {
      return configured;
    }
    final parts = host.split(".");
    return parts.length <= 2 ? host : parts.sublist(parts.length - 2).join(".");
  }

  String _withResolveDestination(String options, String name) {
    if (name.isEmpty) {
      return options;
    }
    return options.replaceFirst(
        RegExp(r" }$"), ", resolveDestination: $name }");
  }

  String _withPath(String options, String path, String defaultPath) {
    if (path == defaultPath) {
      return options;
    }
    return options.replaceFirst("{ ", "{ path: ${jsonEncode(path)}, ");
  }

  List<String> _stringList(Object? value) {
    if (value is List) {
      return value
          .map((e) => e?.toString().trim() ?? "")
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }
    return const [];
  }
}

/// Build the options object literal of `shortLink.Functions.*`.
///
/// `shortLink.Functions.*`のオプションのオブジェクトリテラルを作成します。
String buildCloudflareShortLinkOptions({
  required String binding,
  required List<String> allowedHosts,
  required String notFoundUrl,
}) {
  return "{ bindingName: ${jsonEncode(binding)}"
      "${allowedHosts.isEmpty ? "" : ", allowedHosts: ${jsonEncode(allowedHosts)}"}"
      "${notFoundUrl.isEmpty ? "" : ", notFoundUrl: ${jsonEncode(notFoundUrl)}"} }";
}

/// Add or update the KV namespace [binding] in `"kv_namespaces"` of the Wrangler
/// environment object [source], preserving the other bindings.
///
/// Wrangler環境オブジェクト[source]の`"kv_namespaces"`に[binding]のKV namespaceを
/// 追加または更新します。他のバインディングは保持します。
String upsertCloudflareKvNamespace(
  String source, {
  required String binding,
  required String namespaceId,
}) {
  final entry = {"binding": binding, "id": namespaceId};
  final match = RegExp(r'"kv_namespaces"\s*:\s*\[').firstMatch(source);
  if (match == null) {
    final close = source.lastIndexOf("}");
    if (close < 0) {
      return source;
    }
    final before = source.substring(0, close).trimRight();
    final comma = before.endsWith(",") || before.endsWith("{") ? "" : ",";
    return "$before$comma\n"
        '      "kv_namespaces": [${jsonEncode(entry)}]\n'
        "    ${source.substring(close)}";
  }
  final open = source.indexOf("[", match.start);
  var depth = 0;
  var close = -1;
  String? quote;
  for (var i = open; i < source.length; i++) {
    final char = source[i];
    if (quote != null) {
      if (char == quote && source[i - 1] != r"\") {
        quote = null;
      }
      continue;
    }
    if (char == '"') {
      quote = char;
    } else if (char == "[") {
      depth++;
    } else if (char == "]" && --depth == 0) {
      close = i;
      break;
    }
  }
  if (close < 0) {
    throw const FormatException("Wrangler kv_namespaces array is malformed.");
  }
  final current = jsonDecode(source.substring(open, close + 1)) as List;
  final namespaces = [
    for (final value in current)
      if (value is! Map || value["binding"] != binding) value,
    entry,
  ];
  return source.replaceRange(open, close + 1, jsonEncode(namespaces));
}
