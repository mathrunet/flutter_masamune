import "dart:convert";

import "package:katana_cli/action/cloudflare/short_link.dart";
import "package:katana_cli/katana_cli.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

const _wrangler = """
{
  "name": "app",
  // KATANA ENVIRONMENTS BEGIN
  "env": {
    "dev": {
      "name": "app-dev",
      "routes": [
        { "pattern": "api-dev.example.com", "custom_domain": true }
      ]
    },
    "prod": {
      "name": "app",
      "routes": [
        { "pattern": "api.example.com", "custom_domain": true },
        // Share pages.
        { "pattern": "https://example.com/track/*", "zone_name": "example.com" },
        "example.com/legacy/*"
      ],
      "kv_namespaces": [{ "binding": "OTHER_KV", "id": "other" }]
    }
  }
  // KATANA ENVIRONMENTS END
}
""";

void main() {
  // Custom domain sync keeps zone routes.
  final upserted = WranglerEnvironmentSynchronizer.upsertRoutes(
    _wrangler,
    flavor: "prod",
    customDomains: ["api2.example.com"],
  );
  _check(upserted.contains('"api2.example.com"'), "new custom domain");
  _check(!upserted.contains('"api.example.com"'), "old custom domain removed");
  _check(
    upserted.contains("https://example.com/track/*"),
    "zone route kept on upsert",
  );
  _check(
    upserted.contains('"example.com/legacy/*"'),
    "string route kept on upsert",
  );
  _check(upserted.contains("api-dev.example.com"), "dev untouched");

  final removed = WranglerEnvironmentSynchronizer.removeRoutes(
    _wrangler,
    flavor: "prod",
  );
  _check(!removed.contains('"api.example.com"'), "custom domain removed");
  _check(
    removed.contains("https://example.com/track/*"),
    "zone route kept on remove",
  );
  final removedDev = WranglerEnvironmentSynchronizer.removeRoutes(
    _wrangler,
    flavor: "dev",
  );
  _check(!removedDev.contains("api-dev.example.com"), "dev routes removed");

  // Zone routes are added idempotently.
  final patterns = {"https://example.com/s/*": "example.com"};
  final added = WranglerEnvironmentSynchronizer.addZoneRoutes(
    _wrangler,
    flavor: "prod",
    patterns: patterns,
  );
  _check(added.contains('"https://example.com/s/*"'), "short link route");
  _check(added.contains("https://example.com/track/*"), "existing route kept");
  _check(added.contains('"api.example.com"'), "custom domain kept");
  final addedTwice = WranglerEnvironmentSynchronizer.addZoneRoutes(
    added,
    flavor: "prod",
    patterns: patterns,
  );
  _check(addedTwice == added, "addZoneRoutes is idempotent");
  final addedDev = WranglerEnvironmentSynchronizer.addZoneRoutes(
    _wrangler,
    flavor: "dev",
    patterns: {"https://dev.example.com/s/*": "example.com"},
  );
  _check(
    addedDev.contains("https://dev.example.com/s/*") &&
        !addedDev.contains('"https://example.com/s/*"'),
    "dev route only",
  );

  // KV namespaces are merged by binding.
  final kvAdded = WranglerEnvironmentSynchronizer.transformEnvironment(
    _wrangler,
    flavor: "prod",
    transform: (environment) => upsertCloudflareKvNamespace(
      environment,
      binding: "SHORT_LINK_KV",
      namespaceId: "abc",
    ),
  );
  _check(kvAdded.contains('"OTHER_KV"'), "other KV kept");
  _check(
      kvAdded.contains('{"binding":"SHORT_LINK_KV","id":"abc"}'), "KV added");
  final kvUpdated = WranglerEnvironmentSynchronizer.transformEnvironment(
    kvAdded,
    flavor: "prod",
    transform: (environment) => upsertCloudflareKvNamespace(
      environment,
      binding: "SHORT_LINK_KV",
      namespaceId: "def",
    ),
  );
  _check(!kvUpdated.contains('"abc"'), "KV id replaced");
  _check(
    RegExp("SHORT_LINK_KV").allMatches(kvUpdated).length == 1,
    "KV not duplicated",
  );
  final kvDev = WranglerEnvironmentSynchronizer.transformEnvironment(
    _wrangler,
    flavor: "dev",
    transform: (environment) => upsertCloudflareKvNamespace(
      environment,
      binding: "SHORT_LINK_KV",
      namespaceId: "dev-id",
    ),
  );
  _check(kvDev.contains('"kv_namespaces": [{"binding":"SHORT_LINK_KV"'),
      "KV array created");

  // Options literal.
  final options = buildCloudflareShortLinkOptions(
    binding: "SHORT_LINK_KV",
    allowedHosts: ["example.com"],
    notFoundUrl: "https://example.com/",
  );
  _check(
    options ==
        '{ bindingName: "SHORT_LINK_KV", allowedHosts: ${jsonEncode([
              "example.com"
            ])}, notFoundUrl: "https://example.com/" }',
    "options literal",
  );
  // ignore: avoid_print
  print("short_link_cloudflare_test: OK");
}
