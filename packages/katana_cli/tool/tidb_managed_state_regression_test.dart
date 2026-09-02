import "dart:io";

import "package:katana_cli/action/cloudflare/tidb_state.dart";
import "package:katana_cli/katana.dart";

Future<void> main() async {
  _verifyMinimalTemplates();
  _verifyCompletedCutoverRepairsDataSourceFirst();
  _verifySchemaBootstrapUsesTemporaryTableEndpoints();
  _verifyManagementRateLimitRetry();
  final original = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_tidb_managed_state_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare").create();
    await File("cloudflare/.gitignore").writeAsString("node_modules\n");
    final secrets = <String, dynamic>{
      "cloudflare": {
        "tidb": {
          "connection_url": "mysql://obsolete",
          "management_api": {
            "public_key": "management-public",
            "private_key": "management-private",
          },
          "data_service": {
            "app_id": "app-1",
            "api_key_id": "key-1",
            "region": "ap-northeast-1",
            "public_key": "data-public",
            "private_key": "data-private",
          },
          "cutover": {
            "manifest_hash": "abc123",
            "state": "prepared",
          },
        },
      },
    };

    final migrated = await loadAndMigrateTidbManagedState(
      secrets,
      environment: "prod",
    );
    _expect(migrated.secretsChanged, "legacy secrets must be migrated");
    _expect(migrated.stateChanged, "a new managed state must be written");
    final tidbSecrets =
        ((secrets["cloudflare"] as Map)["tidb"] as Map<String, dynamic>);
    _expect(
      tidbSecrets.keys.toSet().length == 1 &&
          tidbSecrets.containsKey("management_api"),
      "only user-managed TiDB secrets must remain",
    );
    _expect(
      ((migrated.state["data_service"] as Map)["private_key"]) ==
          "data-private",
      "the generated Data API private key must move to managed state",
    );

    await saveTidbManagedState(migrated.state, environment: "prod");
    await ensureTidbManagedStateIsGitIgnored();
    await ensureTidbManagedStateIsGitIgnored();
    final ignored = await File("cloudflare/.gitignore").readAsLines();
    _expect(
      ignored.where((line) => line == "tidb.yaml").length == 1,
      "tidb.yaml must be ignored exactly once",
    );
    final persisted = await File(
      tidbManagedStatePathFor("prod"),
    ).readAsString();
    _expect(
      persisted.contains("data-private") &&
          !persisted.contains("management-private"),
      "managed state must contain generated secrets only",
    );

    final dev = await loadAndMigrateTidbManagedState(
      <String, dynamic>{},
      environment: "dev",
    );
    _expect(
      (dev.state["data_service"] as Map).isEmpty &&
          (dev.state["cutover"] as Map).isEmpty,
      "dev must not reuse the production Data App or cutover state",
    );
    await saveTidbManagedState(dev.state, environment: "dev");
    _expect(
      tidbManagedStatePathFor("dev") != tidbManagedStatePathFor("prod") &&
          File(tidbManagedStatePathFor("dev")).existsSync(),
      "each flavor must persist an independent managed state file",
    );

    final matchingPartialSecrets = <String, dynamic>{
      "cloudflare": {
        "tidb": {
          "data_service": {"app_id": "app-1"},
        },
      },
    };
    final matching = await loadAndMigrateTidbManagedState(
      matchingPartialSecrets,
      environment: "prod",
    );
    _expect(
      matching.secretsChanged &&
          ((matching.state["data_service"] as Map)["private_key"]) ==
              "data-private",
      "matching partial legacy state must merge without losing generated keys",
    );

    final conflictingSecrets = <String, dynamic>{
      "cloudflare": {
        "tidb": {
          "data_service": {"app_id": "different-app"},
        },
      },
    };
    try {
      await loadAndMigrateTidbManagedState(
        conflictingSecrets,
        environment: "prod",
      );
    } on StateError catch (exception) {
      _expect(
        exception.message.toString().contains("differs"),
        "a state conflict must explain the mismatch",
      );
      stdout.writeln("All TiDB managed state checks passed.");
      return;
    }
    throw StateError("conflicting TiDB managed state was accepted");
  } finally {
    Directory.current = original;
    await temporary.delete(recursive: true);
  }
}

void _verifyCompletedCutoverRepairsDataSourceFirst() {
  final source = File("lib/action/cloudflare/tidb.dart").readAsStringSync();
  final completed = _section(
    source,
    'if (restrictMysql && state == "complete"',
    'if (restrictMysql && state == "prepared"',
  );
  final ensure = completed.indexOf("await _ensureDataSource(");
  final synchronize = completed.indexOf("_generatedEndpointsAreSynchronized(");
  _expect(
    ensure >= 0 && synchronize >= 0 && ensure < synchronize,
    "completed cutover must ensure the cluster is a Data Source before syncing endpoints",
  );
}

void _verifySchemaBootstrapUsesTemporaryTableEndpoints() {
  final source = File("lib/action/cloudflare/tidb.dart").readAsStringSync();
  final bootstrap = _section(
    source,
    "Future<void> _applyAdditiveSchema(",
    "Future<TidbEndpointOwnershipState> _upsertManagedEndpoints(",
  );
  _expect(
    source.contains("splitTidbAdditiveSchemaMigrations(") &&
        bootstrap.contains("_createManagedEndpoint(") &&
        bootstrap.contains("/__masamune/bootstrap_") &&
        bootstrap.contains("_deployAndWait(") &&
        bootstrap.contains("deleteTidbDataServiceEndpointAndWait(") &&
        bootstrap.contains("retryTidbDataEndpointUntilDeployed(") &&
        bootstrap.contains("callTidbDataEndpoint(") &&
        !bootstrap.contains("/system/query"),
    "schema bootstrap must use temporary per-table endpoints",
  );
}

void _verifyManagementRateLimitRetry() {
  final source = File(
    "lib/action/cloudflare/tidb_data_service_api.dart",
  ).readAsStringSync();
  _expect(
    source.contains("response.statusCode == HttpStatus.tooManyRequests") &&
        source.contains("HttpHeaders.retryAfterHeader"),
    "the TiDB management client must honor API rate-limit responses",
  );
}

void _verifyMinimalTemplates() {
  final template = katanaYamlCode(true);
  final secrets = katanaSecretsYamlCode();
  final tidb = _section(template, "  tidb:", "\n  kv:");
  final turso = _section(template, "  turso:", "\n  tidb:");
  final storage = _section(template, "  storage:", "\n\n  # Enable Firebase");
  final tidbSecrets = _section(
    secrets,
    "  tidb:",
    "\n\n# Describe purchase",
  );
  _expect(
    tidb.contains(
          "    enable: false\n"
          "    project_id:\n"
          "    cluster_id:\n"
          "      dev:\n"
          "      prod:",
        ) &&
        !tidb.contains("mode:") &&
        !tidb.contains("connection_url:") &&
        !tidb.contains("app_id:"),
    "the TiDB template must expose only user-managed Data Service settings",
  );
  _expect(
    turso.contains(
          "    enable: false\n"
          "    organization:\n"
          "    group:\n"
          "      dev:\n"
          "      prod:",
        ) &&
        !turso.contains("server_token_ttl:") &&
        !turso.contains("rotate_legacy_tokens:"),
    "the Turso template must omit default and secret values",
  );
  _expect(
    storage.contains(
          "    enable: false\n"
          "    bucket_name:\n"
          "    public_base_url:\n"
          "    backup:\n"
          "      enable: false\n"
          "      bucket_name:",
        ) &&
        !storage.contains("binding:"),
    "the Storage template must omit generated binding values",
  );
  _expect(
    tidbSecrets.contains("    management_api:") &&
        !tidbSecrets.contains("connection_url:") &&
        !tidbSecrets.contains("cutover:") &&
        !tidbSecrets.contains("data_service:"),
    "katana_secrets.yaml must contain only user-managed TiDB credentials",
  );
}

String _section(String source, String start, String end) {
  final startIndex = source.indexOf(start);
  final endIndex = source.indexOf(end, startIndex);
  if (startIndex < 0 || endIndex < 0) {
    throw StateError("template section was not found: $start");
  }
  return source.substring(startIndex, endIndex);
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
