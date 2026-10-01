import "dart:io";
import "dart:convert";

import "package:katana_cli/action/cloudflare/tidb_migration_credentials.dart";

class FakeSqlUserApi extends TidbCloudSqlUserApi {
  FakeSqlUserApi() : super("fixture-public", "fixture-private");

  final Map<String, List<Map<String, dynamic>>> users = {
    "dev-cluster": [
      {"userName": "abc.root", "builtinRole": "role_admin"}
    ],
    "prod-cluster": [
      {"userName": "xyz.root", "builtinRole": "role_admin"}
    ],
    "new-dev-cluster": [
      {"userName": "new.root", "builtinRole": "role_admin"}
    ],
    "long-cluster": [],
  };
  int created = 0;

  @override
  Future<String> clusterPrefix(String cluster) async => cluster == "dev-cluster"
      ? "abc"
      : cluster == "new-dev-cluster"
          ? "new"
          : cluster == "long-cluster"
              ? "abcdefghijklmnop"
              : "xyz";

  @override
  Future<List<Map<String, dynamic>>> list(String cluster) async =>
      users[cluster]!;

  @override
  Future<String> create(
      String cluster, String shortName, String password) async {
    final prefix = await clusterPrefix(cluster);
    final name = "$prefix.$shortName";
    if (users[cluster]!.any((user) => user["userName"] == name)) {
      throw StateError("existing user conflict");
    }
    created++;
    users[cluster]!.add({"userName": name, "builtinRole": "role_admin"});
    return name;
  }
}

Future<void> main(List<String> arguments) async {
  if (arguments.length == 2 && arguments.first == "--live-read-only-oauth") {
    final api = await TidbCloudSqlUserApi.fromTicloudProfile("default");
    try {
      final users = await api.list(arguments[1]);
      stdout.writeln(
          "TiDB Cloud SQL Users OAuth read-only probe: ${users.length} users");
    } finally {
      api.close();
    }
    return;
  }
  if (arguments.length == 2 && arguments.first == "--live-read-only") {
    final publicKey = Platform.environment["TIDBCLOUD_PUBLIC_KEY"] ?? "";
    final privateKey = Platform.environment["TIDBCLOUD_PRIVATE_KEY"] ?? "";
    if (publicKey.isEmpty || privateKey.isEmpty) {
      throw StateError("TiDB Cloud management API credentials are unavailable");
    }
    final api = TidbCloudSqlUserApi(publicKey, privateKey);
    try {
      final users = await api.list(arguments[1]);
      stdout.writeln(
          "TiDB Cloud SQL Users API read-only probe: ${users.length} users");
    } finally {
      api.close();
    }
    return;
  }
  final before = Directory.current;
  final temporary =
      await Directory.systemTemp.createTemp("tidb-migration-test-");
  try {
    Directory.current = temporary;
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    var authenticatedPosts = 0;
    final serving = server.forEach((request) async {
      if (!(request.headers.value(HttpHeaders.authorizationHeader) ?? "")
          .startsWith("Digest ")) {
        request.response.statusCode = HttpStatus.unauthorized;
        request.response.headers.set(HttpHeaders.wwwAuthenticateHeader,
            'Digest realm="fixture", nonce="fixture-nonce", qop="auth", algorithm=MD5');
        await request.response.close();
        return;
      }
      if (request.method == "POST") {
        final input =
            jsonDecode(await utf8.decoder.bind(request).join()) as Map;
        check(input["password"] == "secret-body-only", "HTTP body password");
        check(
            input["userName"] == "test" &&
                input["autoPrefix"] == true &&
                input["builtinRole"] == "role_admin" &&
                !input.containsKey("customRoles"),
            "create-only request body");
        authenticatedPosts++;
        request.response.write('{"userName":"abc.test"}');
      } else if (request.uri.path.endsWith("/dev-cluster")) {
        request.response
            .write('{"clusterId":"dev-cluster","userPrefix":"abc"}');
      } else {
        request.response
            .write('{"sqlUsers":[{"userName":"abc.root"}],"nextPageToken":""}');
      }
      await request.response.close();
    });
    final httpApi = TidbCloudSqlUserApi("public", "private",
        baseUrl: Uri.parse("http://127.0.0.1:${server.port}"));
    check(await httpApi.clusterPrefix("dev-cluster") == "abc",
        "Digest cluster metadata must authenticate");
    check((await httpApi.list("dev-cluster")).length == 1,
        "Digest GET must authenticate");
    check(
        await httpApi.create("dev-cluster", "test", "secret-body-only") ==
            "abc.test",
        "Digest POST must authenticate");
    check(authenticatedPosts == 1, "POST must be sent once with the body");
    httpApi.close();
    await server.close(force: true);
    await serving;

    final api = FakeSqlUserApi();
    var probes = 0;
    Future<void> probe(String host, String database, String username,
        String password, String node) async {
      if (password.isEmpty || !username.contains(".")) {
        throw StateError("identity or password mismatch");
      }
      probes++;
    }

    Future<TidbMigrationCredentials> resolve(String environment,
            {Map<String, dynamic> legacy = const {},
            Future<void> Function(Map<String, dynamic>)? save}) =>
        resolveTidbMigrationCredentials(
          environment: environment,
          cluster: "$environment-cluster",
          host: "fixture.invalid",
          database: "main",
          node: "node",
          legacySecrets: legacy,
          publicKey: "fixture-public",
          privateKey: "fixture-private",
          api: api,
          probe: probe,
          save: save,
        );

    await rejects(
        () => resolveTidbMigrationCredentials(
              environment: "dev",
              cluster: "dev-cluster",
              host: "fixture.invalid",
              database: "main",
              node: "node",
              legacySecrets: const {},
              publicKey: "fixture-public",
              privateKey: "fixture-private",
              allowProvision: false,
              api: api,
              probe: probe,
            ),
        "migrate dry-run must not create an SQL user");
    check(api.created == 0, "dry-run had a management API side effect");

    final first = await resolve("dev");
    check(first.username == "abc.migrate_dev", "initial user");
    check(
        first.password.length == 32 &&
            RegExp(r"^[A-Za-z0-9]+$").hasMatch(first.password),
        "new SQL password must match TiDB CLI character and length contract");
    check(api.created == 1, "initial create count");
    check((await File("cloudflare/tidb.yaml").stat()).mode & 0x1ff == 0x180,
        "credential file must be mode 0600");
    final second = await resolve("dev");
    check(second.password == first.password && api.created == 1,
        "reapply must not rotate credentials");
    Future<TidbMigrationCredentials> resolveNewDev(
            {bool allowProvision = true}) =>
        resolveTidbMigrationCredentials(
          environment: "dev",
          cluster: "new-dev-cluster",
          host: "fixture.invalid",
          database: "main",
          node: "node",
          legacySecrets: const {},
          publicKey: "fixture-public",
          privateKey: "fixture-private",
          allowProvision: allowProvision,
          api: api,
          probe: probe,
        );
    await rejects(() => resolveNewDev(allowProvision: false),
        "dry-run must not provision a new cluster");
    check(api.created == 1, "dry-run changed the new cluster");
    final rebound = await resolveNewDev();
    check(rebound.username == "new.migrate_dev" && api.created == 2,
        "new dev cluster must get its own migration user");
    final reboundAgain = await resolveNewDev();
    check(reboundAgain.password == rebound.password && api.created == 2,
        "new dev cluster must reuse its saved migration user");
    final reboundState = await loadTidbCredentialState();
    check(
        reboundState["cloudflare"]["tidb"]["migration_users"]["dev"]
                    ["password"] ==
                first.password &&
            reboundState["cloudflare"]["tidb"]["migration_users_by_cluster"]
                    ["dev"]["new-dev-cluster"]["password"] ==
                rebound.password,
        "old and new cluster credentials must remain separate");
    await resolve("prod");
    check(api.created == 3, "prod and dev must use separate users");
    check(
        (await loadTidbCredentialState())["cloudflare"]["tidb"]
                ["migration_users"]["dev"]["password"] ==
            first.password,
        "dev credentials changed when prod was added");

    final inherited =
        await Directory.systemTemp.createTemp("tidb-legacy-test-");
    Directory.current = inherited;
    final legacy = await resolve("dev", legacy: {
      "migration_username": "abc.existing_migration",
      "migration_password": "existing-secret"
    });
    check(legacy.username == "abc.existing_migration" && api.created == 3,
        "legacy credentials must take precedence");
    await inherited.delete(recursive: true);
    api.users["dev-cluster"]!
        .removeWhere((user) => user["userName"] == "abc.migrate_dev");

    final collision =
        await Directory.systemTemp.createTemp("tidb-collision-test-");
    Directory.current = collision;
    api.users["dev-cluster"]!.add({"userName": "abc.migrate_dev"});
    await rejects(() => resolve("dev"), "unknown same-name user must block");
    api.users["dev-cluster"]!.removeLast();
    await collision.delete(recursive: true);

    final hiddenRoot =
        await Directory.systemTemp.createTemp("tidb-hidden-root-test-");
    Directory.current = hiddenRoot;
    api.users["dev-cluster"]!.clear();
    final hidden = await resolve("dev");
    check(hidden.username == "abc.migrate_dev" && api.created == 4,
        "cluster metadata must allow create when IAM list hides root");
    await hiddenRoot.delete(recursive: true);
    api.users["dev-cluster"]!.clear();

    final interrupted =
        await Directory.systemTemp.createTemp("tidb-recovery-test-");
    Directory.current = interrupted;
    var saves = 0;
    await rejects(
        () => resolve("dev", save: (state) async {
              saves++;
              if (saves == 2) {
                throw StateError("disk failure after create");
              }
              await saveTidbCredentialState(state);
            }),
        "final-save failure must surface");
    check(api.created == 5, "interrupted creation count");
    final pending = await loadTidbCredentialState();
    check(
        pending["cloudflare"]["tidb"]["migration_users"]["dev"]["status"] ==
            "pending",
        "pending record must survive");
    final resumed = await resolve("dev");
    check(api.created == 5 && resumed.username == "abc.migrate_dev",
        "pending user must resume without rotation");
    await interrupted.delete(recursive: true);

    final denied = await Directory.systemTemp.createTemp("tidb-denied-test-");
    Directory.current = denied;
    api.users["dev-cluster"]!
        .removeWhere((user) => user["userName"] == "abc.migrate_dev");
    await rejects(
        () => resolveTidbMigrationCredentials(
              environment: "dev",
              cluster: "dev-cluster",
              host: "fixture.invalid",
              database: "main",
              node: "node",
              legacySecrets: const {},
              publicKey: "fixture-public",
              privateKey: "fixture-private",
              api: api,
              probe: (host, database, username, password, node) =>
                  Future.error(StateError("insufficient SQL privilege")),
            ),
        "insufficient SQL privilege must block");
    check(
        (await loadTidbCredentialState())["cloudflare"]["tidb"]
                ["migration_users"]["dev"]["status"] ==
            "pending",
        "privilege failure must preserve resumable credentials");
    await denied.delete(recursive: true);

    final noWrite = await Directory.systemTemp.createTemp("tidb-nowrite-test-");
    Directory.current = noWrite;
    final beforeCreate = api.created;
    api.users["dev-cluster"]!
        .removeWhere((user) => user["userName"] == "abc.migrate_dev");
    await rejects(
        () => resolve("dev",
            save: (state) =>
                Future.error(StateError("cannot save pending credential"))),
        "failed pending save must block before API mutation");
    check(api.created == beforeCreate, "API changed before pending save");
    await noWrite.delete(recursive: true);

    final oldPending =
        await Directory.systemTemp.createTemp("tidb-old-pending-test-");
    Directory.current = oldPending;
    await saveTidbCredentialState({
      "cloudflare": {
        "tidb": {
          "migration_users": {
            "dev": {
              "username": "abcdefghijklmnop.masamune_dev_migration",
              "password": "preserved-pending-secret",
              "cluster_id": "long-cluster",
              "requested_name": "masamune_dev_migration",
              "owner": "katana-cloudflare-tidb-migration-v1",
              "status": "pending",
            }
          }
        }
      }
    });
    final beforeRecovery = api.created;
    final recovered = await resolveTidbMigrationCredentials(
      environment: "dev",
      cluster: "long-cluster",
      host: "fixture.invalid",
      database: "main",
      node: "node",
      legacySecrets: const {},
      publicKey: "fixture-public",
      privateKey: "fixture-private",
      api: api,
      probe: (host, database, username, password, node) async {
        if (username.endsWith(".masamune_dev_migration")) {
          throw StateError("old name was never created");
        }
      },
    );
    check(
        recovered.username == "abcdefghijklmnop.migrate_dev" &&
            recovered.password == "preserved-pending-secret" &&
            api.created == beforeRecovery + 1,
        "overlong pending name must recover without password rotation");
    await oldPending.delete(recursive: true);

    final oldPassword =
        await Directory.systemTemp.createTemp("tidb-old-password-test-");
    Directory.current = oldPassword;
    await saveTidbCredentialState({
      "cloudflare": {
        "tidb": {
          "migration_users": {
            "dev": {
              "username": "abc.migrate_dev",
              "password": List.filled(43, "a").join(),
              "cluster_id": "dev-cluster",
              "requested_name": "migrate_dev",
              "owner": "katana-cloudflare-tidb-migration-v1",
              "status": "pending",
            }
          }
        }
      }
    });
    final rotated = await resolveTidbMigrationCredentials(
      environment: "dev",
      cluster: "dev-cluster",
      host: "fixture.invalid",
      database: "main",
      node: "node",
      legacySecrets: const {},
      publicKey: "fixture-public",
      privateKey: "fixture-private",
      api: api,
      probe: (host, database, username, password, node) async {
        if (password.length != 32) {
          throw StateError("old SQL password is invalid");
        }
      },
    );
    check(
        rotated.password.length == 32 &&
            RegExp(r"^[A-Za-z0-9]+$").hasMatch(rotated.password),
        "pending user absent remotely must get a compliant password");
    await oldPassword.delete(recursive: true);

    // Active records are only read. The returned state is forwarded to
    // provisionRuntimeUser as credentialState and compared with the file on
    // disk, so resolving must not add empty containers such as
    // migration_users_by_cluster.<env> = {}.
    for (final layout in <Map<String, dynamic>>[
      {
        "runtime_users": {"dev": <String, dynamic>{}},
        "migration_users": {
          "dev": {
            "username": "abc.migrate_dev",
            "password": "active-legacy-secret",
            "cluster_id": "dev-cluster",
            "owner": "katana-cloudflare-tidb-migration-v1",
            "status": "active",
          }
        },
      },
      {
        "migration_users_by_cluster": {
          "dev": {
            "dev-cluster": {
              "username": "abc.migrate_dev",
              "password": "active-cluster-secret",
              "cluster_id": "dev-cluster",
              "owner": "katana-cloudflare-tidb-migration-v1",
              "status": "active",
            }
          }
        },
      },
    ]) {
      final activeRoot =
          await Directory.systemTemp.createTemp("tidb-active-readonly-test-");
      Directory.current = activeRoot;
      await saveTidbCredentialState({
        "cloudflare": {"tidb": layout}
      });
      final diskText = await File("cloudflare/tidb.yaml").readAsString();
      final beforeActive = api.created;
      var activeSaves = 0;
      final active = await resolve("dev", save: (state) async {
        activeSaves++;
        await saveTidbCredentialState(state);
      });
      check(activeSaves == 0 && api.created == beforeActive,
          "active credentials must be resolved without writes");
      check(await File("cloudflare/tidb.yaml").readAsString() == diskText,
          "active resolution must not rewrite cloudflare/tidb.yaml");
      check(stableJson(active.state) == stableJson(jsonDecode(diskText)),
          "resolved credentialState must equal cloudflare/tidb.yaml");
      Directory.current = temporary;
      await activeRoot.delete(recursive: true);
    }

    check(probes >= 5, "SQL identity probe must run before success");
    stdout.writeln("TiDB migration credentials regression: PASS");
  } finally {
    Directory.current = before;
    await temporary.delete(recursive: true);
  }
}

/// Canonical JSON with sorted object keys, matching migration.stableJson.
String stableJson(Object? value) {
  Object? normalize(Object? item) {
    if (item is Map) {
      final keys = item.keys.map((key) => key.toString()).toList()..sort();
      return {for (final key in keys) key: normalize(item[key])};
    }
    if (item is List) {
      return item.map(normalize).toList();
    }
    return item;
  }

  return jsonEncode(normalize(value));
}

void check(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

Future<void> rejects(Future<Object?> Function() action, String message) async {
  try {
    await action();
  } catch (_) {
    return;
  }
  throw StateError(message);
}
