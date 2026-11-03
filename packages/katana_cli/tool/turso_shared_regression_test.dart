import "dart:convert";
import "dart:io";

import "package:katana_cli/action/cloudflare/turso.dart";
import "package:katana_cli/action/cloudflare/turso_shared.dart";
import "package:katana_cli/katana_cli.dart";

/// 共用TursoDB（region Worker）と個別TursoDB（edge Worker）併用の回帰テスト。
Future<void> main() async {
  _testConfigDefaultsAndValidation();
  _testSchemaSplit();
  _testRegionSourceUpdate();
  _testEdgeReservedDatabases();
  final server = await _FakeTursoPlatformApi.start();
  try {
    await _testActionRequiresRegionWorker(server);
    await _testActionAppliesSharedDatabase(server);
    await _testExistingDatabaseInAnotherGroup(server);
  } finally {
    await server.close();
  }
  stdout.writeln("Turso shared regression checks passed");
}

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

/// 既定値はpubspec名から導出し、dev/prodの同一DBや不正な名前を拒否する。
void _testConfigDefaultsAndValidation() {
  final config = resolveTursoSharedConfig(
    shared: {"enable": true, "logical_name": "shared"},
    appName: "my_app",
  );
  _check(config.logicalName == "shared", "logical_name must default.");
  _check(
      config.bindings["dev"]!.database == "my-app-dev-shared" &&
          config.bindings["dev"]!.group == "my-app-dev" &&
          config.bindings["prod"]!.database == "my-app-shared" &&
          config.bindings["prod"]!.group == "my-app-us",
      "Defaults must be derived from the pubspec name: ${config.databaseBindingsJson()}");
  final explicit = resolveTursoSharedConfig(
    shared: {
      "logical_name": "common",
      "database": {"dev": "a-dev", "prod": "a-prod"},
      "group": "a-group",
    },
    appName: "",
  );
  _check(
      jsonEncode(explicit.databaseBindingsJson()) ==
          jsonEncode({
            "dev": {
              "common": {"database": "a-dev", "group": "a-group"}
            },
            "prod": {
              "common": {"database": "a-prod", "group": "a-group"}
            },
          }),
      "Explicit values must be used: ${explicit.databaseBindingsJson()}");
  for (final invalid in <Map<String, Object?>>[
    {"database": "same"},
    {"logical_name": "bad name"},
    {
      "database": {"dev": "Upper_Case", "prod": "ok"}
    },
  ]) {
    try {
      resolveTursoSharedConfig(shared: invalid, appName: "app");
      throw StateError("Invalid shared config must fail: $invalid");
    } on FormatException {
      // expected
    }
  }
  try {
    resolveTursoSharedConfig(shared: const {}, appName: "");
    throw StateError("Defaults without a pubspec name must fail.");
  } on FormatException {
    // expected
  }
}

const _schema = {
  "version": "1",
  "sourceHash": "hash-1",
  "tables": [
    {
      "database": "shared",
      "table": "ranking",
      "columns": [
        {"name": "score", "sqlType": "INTEGER"},
      ],
    },
    {
      "database": "main",
      "table": "profile",
      "columns": [
        {"name": "embedding", "sqlType": "VECTOR(3)", "vectorMetric": "cosine"},
      ],
    },
  ],
};

/// 論理名sharedのテーブルだけをregion用manifestへ、それ以外をedge用へ振り分ける。
void _testSchemaSplit() {
  final edge = tursoCompatibleSchemaManifest(
    _schema,
    columnType: tursoNativeColumnType,
    include: (database) => database != "shared",
  );
  final shared = tursoCompatibleSchemaManifest(
    _schema,
    columnType: tursoNativeColumnType,
    include: (database) => database == "shared",
  );
  _check((edge["tables"] as Map).keys.join(",") == "main\u0000profile",
      "The edge manifest must exclude shared tables: ${edge["tables"]}");
  _check((shared["tables"] as Map).keys.join(",") == "shared\u0000ranking",
      "The shared manifest must contain only shared tables.");
  _check(
      ((edge["tables"] as Map)["main\u0000profile"]["columns"] as List)
              .single["type"] ==
          "F32_BLOB(3)",
      "Vector columns must be converted.");
  _check(edge["version"] == "hash-1", "The source hash must be the version.");
  // 変換済みmanifestもdatabaseで振り分けられる。
  final again = tursoCompatibleSchemaManifest(
    edge,
    columnType: tursoNativeColumnType,
    include: (database) => database == "shared",
  );
  _check((again["tables"] as Map).isEmpty,
      "A compatible manifest must be filtered by database.");
}

const _regionSource = """
import * as m from "@mathrunet/masamune_cloudflare";
export default m.deploy([
    turso.Functions.tursoToken({ autoCreateDatabase: true }),
], { type: "region" });
""";

TursoSharedConfig _config() => resolveTursoSharedConfig(
      shared: {
        "database": {"dev": "app-dev-shared", "prod": "app-shared"},
        "group": {"dev": "app-dev", "prod": "app-us"},
      },
      appName: "app",
    );

/// region.tsへ固定DBのturso関数を登録し、tursoTokenを除去し、再適用で変化しない。
void _testRegionSourceUpdate() {
  final first = updateTursoSharedRegionSource(
    _regionSource,
    config: _config(),
    useSchemaManifest: true,
  )!;
  _check(
      first.contains(
          'import * as turso from "@mathrunet/masamune_cloudflare_turso";'),
      "The turso import must be added: $first");
  _check(
      first.contains(
          'import tursoSharedSchemaManifest from "./turso_shared_schema_manifest.json";'),
      "The shared manifest import must be added.");
  _check(!first.contains("tursoToken"),
      "tursoToken must not be registered on the region Worker: $first");
  _check(
      first.contains(
              'dev: { "shared": { database: "app-dev-shared", group: "app-dev" } },') &&
          first.contains(
              'prod: { "shared": { database: "app-shared", group: "app-us" } },'),
      "databaseBindings must contain both environments: $first");
  _check(
      first.contains(
          "schemaManifest: tursoSharedSchemaManifest as turso.TursoSchemaManifest"),
      "The shared manifest must be used.");
  _check(!first.contains("reservedDatabases"),
      "The region Worker must not reserve the shared name.");
  final second = updateTursoSharedRegionSource(
    first,
    config: _config(),
    useSchemaManifest: true,
  )!;
  _check(second == first, "Re-applying must be idempotent:\n$second");
  // アプリ側のオプションは保持し、管理対象のキーだけを更新する。
  final custom = first.replaceFirst("        databaseBindings: {",
      "        autoCreateTable: false,\n        databaseBindings: {");
  final changed = updateTursoSharedRegionSource(
    custom,
    config: resolveTursoSharedConfig(
      shared: {
        "database": {"dev": "next-dev", "prod": "next-prod"},
        "group": "next",
      },
      appName: "app",
    ),
    useSchemaManifest: true,
  )!;
  _check(
      changed.contains("autoCreateTable: false,") &&
          changed.contains('database: "next-prod"') &&
          !changed.contains("app-shared") &&
          RegExp(r"databaseBindings").allMatches(changed).length == 1,
      "Custom options must be kept while bindings are replaced: $changed");
  _check(
      updateTursoSharedRegionSource(
            "export default {};",
            config: _config(),
            useSchemaManifest: false,
          ) ==
          null,
      "A missing deploy array must be reported.");
}

/// edgeのturso/tursoTokenにreservedDatabasesを追加し、既存の値に重複追加しない。
void _testEdgeReservedDatabases() {
  const action = CloudflareTursoCliAction();
  const source = """
import * as m from "@mathrunet/masamune_cloudflare";
export default m.deploy([
    turso.Functions.turso({ autoCreateDatabase: true, rules }),
    turso.Functions.tursoToken({
        autoCreateDatabase: true,
        reservedDatabases: ["other"],
    }),
], { type: "edge" });
""";
  final updated = action.updateTursoFunctions(
    source,
    useSchemaManifest: false,
    reservedDatabase: "shared",
  )!;
  _check(
      updated.contains('reservedDatabases: ["shared"]') &&
          updated.contains('reservedDatabases: ["other","shared"]') &&
          updated.contains("rules"),
      "reservedDatabases must be added to both edge functions: $updated");
  final again = action.updateTursoFunctions(
    updated,
    useSchemaManifest: false,
    reservedDatabase: "shared",
  )!;
  _check(again == updated, "Re-applying must not duplicate reserved names.");
  final inserted = action.updateTursoFunctions(
    'import * as m from "@mathrunet/masamune_cloudflare";\nexport default m.deploy([\n], { type: "edge" });\n',
    useSchemaManifest: false,
    reservedDatabase: "shared",
  )!;
  _check(
      RegExp(r'reservedDatabases: \["shared"\]').allMatches(inserted).length ==
          2,
      "New edge functions must reserve the shared name: $inserted");
  final disabled = action.updateTursoFunctions(
    source,
    useSchemaManifest: false,
  )!;
  _check(!disabled.contains('"shared"'),
      "Without the shared database nothing must be reserved.");
}

class _Workspace {
  _Workspace(this.directory, this.server);

  final Directory directory;
  final _FakeTursoPlatformApi server;
  late final String marker = "${directory.path}/wrangler-calls";
  late final String wrangler = "${directory.path}/fake-wrangler.sh";

  static Future<_Workspace> create(_FakeTursoPlatformApi server) async {
    final directory =
        Directory.systemTemp.createTempSync("katana-turso-shared-");
    final workspace = _Workspace(directory, server);
    Directory.current = directory;
    Directory("cloudflare/src").createSync(recursive: true);
    File("cloudflare/src/edge.ts").writeAsStringSync("""
import * as m from "@mathrunet/masamune_cloudflare";
export default m.deploy([
], { type: "edge" });
""");
    File("cloudflare/src/region.ts").writeAsStringSync(_regionSource);
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{\n  "name": "app",\n  "main": "src/edge.ts"\n}\n');
    File("cloudflare/wrangler.region.jsonc").writeAsStringSync(
        '{\n  "name": "app-region",\n  "main": "src/region.ts"\n}\n');
    File("cloudflare/.gitignore").writeAsStringSync("node_modules\n");
    Directory("tidb/schema").createSync(recursive: true);
    File("tidb/schema/schema.json").writeAsStringSync(jsonEncode(_schema));
    File("pubspec.yaml").writeAsStringSync(
        "name: my_app\ndependencies:\n  masamune_model_turso: ^3.9.0\n");
    File("cloudflare/package.json").writeAsStringSync(jsonEncode({
      "dependencies": {"@mathrunet/masamune_cloudflare_turso": "test"}
    }));
    // 引数と標準入力（secret値）を記録する。
    File(workspace.wrangler).writeAsStringSync(
        "#!/bin/sh\nprintf '%s|' \"\$*\" >> ${workspace.marker}\ncat >> ${workspace.marker}\n");
    await Process.run("chmod", ["+x", workspace.wrangler]);
    return workspace;
  }

  List<String> get calls => File(marker).existsSync()
      ? File(marker)
          .readAsLinesSync()
          .where((line) => line.trim().isNotEmpty)
          .toList()
      : const [];

  ExecContext context({
    required String flavor,
    bool regionEnabled = true,
    Map<String, Object?> secrets = const {},
  }) {
    final yaml = {
      "bin": {"wrangler": wrangler},
      "cloudflare": {
        "project_id": "app",
        "workers": {
          "enable": true,
          "region": {"enable": regionEnabled},
        },
        "turso": {
          "enable": true,
          "organization": "test-org",
          "group": {"dev": "app-dev", "prod": "app-us"},
          "platform_api_token": "test-token",
          "shared": {
            "enable": true,
            "logical_name": "shared",
            "database": {"dev": null, "prod": null},
            "group": {"dev": null, "prod": null},
          },
        },
      },
    };
    final args = ["apply", "--flavor", flavor];
    final resolved =
        FlavorContext.resolve(yaml: yaml, secrets: secrets, arguments: args);
    return ExecContext(
      yaml: resolved.yaml,
      secrets: resolved.secrets,
      args: args,
      flavorContext: resolved,
    );
  }
}

/// region Workerが無効な場合は何も書き換えずにエラーにする。
Future<void> _testActionRequiresRegionWorker(
    _FakeTursoPlatformApi server) async {
  final previous = Directory.current;
  final workspace = await _Workspace.create(server);
  try {
    server.reset();
    final edgeBefore = File("cloudflare/src/edge.ts").readAsStringSync();
    final action =
        CloudflareTursoCliAction(platformApiBaseUrl: server.baseUrl.toString());
    await action.exec(workspace.context(flavor: "dev", regionEnabled: false));
    _check(File("cloudflare/src/edge.ts").readAsStringSync() == edgeBefore,
        "edge.ts must not change when the region Worker is disabled.");
    _check(File("cloudflare/src/region.ts").readAsStringSync() == _regionSource,
        "region.ts must not change when the region Worker is disabled.");
    _check(workspace.calls.isEmpty, "No secret must be put.");
    _check(server.requests.isEmpty, "No Platform API call must be made.");
  } finally {
    Directory.current = previous;
    workspace.directory.deleteSync(recursive: true);
  }
}

/// 共用DBの作成・region登録・edgeの予約・vars同期・secret投入を行い、再適用で冪等になる。
Future<void> _testActionAppliesSharedDatabase(
    _FakeTursoPlatformApi server) async {
  final previous = Directory.current;
  final workspace = await _Workspace.create(server);
  try {
    server.reset();
    final action =
        CloudflareTursoCliAction(platformApiBaseUrl: server.baseUrl.toString());
    await action.exec(workspace.context(flavor: "dev"));
    _check(
        server.databasePosts.length == 1 &&
            server.databasePosts.single["name"] == "my-app-dev-shared" &&
            server.databasePosts.single["group"] == "my-app-dev" &&
            server.databasePosts.single["use_tursodb"] == true,
        "The dev shared database must be created: ${server.databasePosts}");
    final region = File("cloudflare/src/region.ts").readAsStringSync();
    _check(
        region.contains(
                'dev: { "shared": { database: "my-app-dev-shared", group: "my-app-dev" } },') &&
            region.contains(
                'prod: { "shared": { database: "my-app-shared", group: "my-app-us" } },') &&
            !region.contains("tursoToken"),
        "region.ts must register the shared database: $region");
    final edge = File("cloudflare/src/edge.ts").readAsStringSync();
    _check(
        RegExp(r'reservedDatabases: \["shared"\]').allMatches(edge).length == 2,
        "edge.ts must reserve the shared name: $edge");
    final edgeManifest = jsonDecode(
        File("cloudflare/src/turso_schema_manifest.json").readAsStringSync());
    final sharedManifest =
        jsonDecode(File(tursoSharedSchemaManifestPath).readAsStringSync());
    _check(
        (edgeManifest["tables"] as Map).keys.join(",") == "main\u0000profile" &&
            (sharedManifest["tables"] as Map).keys.join(",") ==
                "shared\u0000ranking",
        "The schema manifests must be split by logical name.");
    final regionWrangler =
        File("cloudflare/wrangler.region.jsonc").readAsStringSync();
    _check(
        regionWrangler.contains('"TURSO_ORGANIZATION": "test-org"') &&
            regionWrangler.contains('"TURSO_DATABASE_BINDINGS"') &&
            regionWrangler.contains('"FLAVOR": "dev"') &&
            !regionWrangler.contains("TURSO_GROUP"),
        "wrangler.region.jsonc must contain the shared vars: $regionWrangler");
    final bindings =
        RegExp(r'"TURSO_DATABASE_BINDINGS"\s*:\s*("(?:[^"\\]|\\.)*")')
            .firstMatch(regionWrangler)!
            .group(1)!;
    _check(
        jsonEncode(jsonDecode(jsonDecode(bindings) as String)) ==
            jsonEncode({
              "dev": {
                "shared": {
                  "database": "my-app-dev-shared",
                  "group": "my-app-dev"
                }
              }
            }),
        "TURSO_DATABASE_BINDINGS must contain only the current flavor: $bindings");
    final calls = workspace.calls;
    _check(
        calls.any((call) =>
            call.startsWith(
                "secret put TURSO_PLATFORM_API_TOKEN --env dev -c wrangler.region.jsonc|") &&
            call.endsWith("test-token")),
        "The Platform API token must be put to the region Worker: $calls");
    final tokenCall = calls.firstWhere(
        (call) => call.startsWith(
            "secret put TURSO_SERVER_ACCESS_TOKEN --env dev -c wrangler.region.jsonc|"),
        orElse: () => "");
    final token = tokenCall.split("|").last;
    _check(
        token.length >= 32, "A random server access token must be put: $calls");
    _check(
        calls.any((call) =>
            call.startsWith("secret put TURSO_PLATFORM_API_TOKEN --env dev|")),
        "The edge Platform API token must still be put.");
    _check(
        File(tursoManagedStatePath).readAsStringSync().contains(token) &&
            File("cloudflare/.gitignore")
                .readAsLinesSync()
                .contains("turso.yaml"),
        "The generated token must be stored in a git-ignored file.");

    // 再適用：DBは既存、tokenは再利用、ソースは変化しない。
    File(workspace.marker).deleteSync();
    server.databasePosts.clear();
    await action.exec(workspace.context(flavor: "dev"));
    _check(server.databasePosts.isEmpty,
        "Re-applying must not create the database again.");
    _check(File("cloudflare/src/region.ts").readAsStringSync() == region,
        "Re-applying must not change region.ts.");
    _check(File("cloudflare/src/edge.ts").readAsStringSync() == edge,
        "Re-applying must not change edge.ts.");
    _check(
        workspace.calls.any((call) =>
            call.startsWith("secret put TURSO_SERVER_ACCESS_TOKEN") &&
            call.endsWith("|$token")),
        "The stored server access token must be reused.");

    // katana_secrets.yamlの値が優先される。
    File(workspace.marker).deleteSync();
    await action.exec(workspace.context(flavor: "dev", secrets: {
      "cloudflare": {
        "turso": {
          "shared": {
            "server_access_token": {"dev": "configured-token", "prod": "x"}
          }
        }
      }
    }));
    _check(
        workspace.calls.any((call) =>
            call.startsWith("secret put TURSO_SERVER_ACCESS_TOKEN") &&
            call.endsWith("|configured-token")),
        "The configured server access token must take precedence.");
  } finally {
    Directory.current = previous;
    workspace.directory.deleteSync(recursive: true);
  }
}

/// 既存DBが別groupにある場合はsecret投入前に停止する。
Future<void> _testExistingDatabaseInAnotherGroup(
    _FakeTursoPlatformApi server) async {
  final previous = Directory.current;
  final workspace = await _Workspace.create(server);
  try {
    server.reset(existing: {"my-app-shared": "other-group"});
    final action =
        CloudflareTursoCliAction(platformApiBaseUrl: server.baseUrl.toString());
    try {
      await action.exec(workspace.context(flavor: "prod"));
      throw StateError("A database in another group must fail.");
    } on StateError catch (e) {
      _check(e.message.contains("other-group"),
          "The error must name the existing group: ${e.message}");
    }
    _check(server.databasePosts.isEmpty, "No database must be created.");
    _check(
        !workspace.calls
            .any((call) => call.contains("TURSO_SERVER_ACCESS_TOKEN")),
        "No server token must be put after the failure.");
  } finally {
    Directory.current = previous;
    workspace.directory.deleteSync(recursive: true);
  }
}

/// ループバックで動くfake Turso Platform API（databases API）。
class _FakeTursoPlatformApi {
  _FakeTursoPlatformApi._(this._server) {
    _server.listen(_handle);
  }

  static Future<_FakeTursoPlatformApi> start() async {
    return _FakeTursoPlatformApi._(
        await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
  }

  final HttpServer _server;
  final requests = <String>[];
  final databasePosts = <Map<String, dynamic>>[];
  var _existing = <String, String>{};

  Uri get baseUrl => Uri.parse("http://127.0.0.1:${_server.port}");

  void reset({Map<String, String> existing = const {}}) {
    requests.clear();
    databasePosts.clear();
    _existing = Map.of(existing);
  }

  Future<void> _handle(HttpRequest request) async {
    requests.add("${request.method} ${request.uri.path}");
    final response = request.response;
    response.headers.contentType = ContentType.json;
    const prefix = "/v1/organizations/test-org/databases";
    if (request.headers.value(HttpHeaders.authorizationHeader) !=
        "Bearer test-token") {
      response.statusCode = HttpStatus.unauthorized;
    } else if (request.method == "GET" &&
        request.uri.path.startsWith("$prefix/")) {
      final name = request.uri.pathSegments.last;
      final group = _existing[name];
      if (group == null) {
        response.statusCode = HttpStatus.notFound;
        response.write('{"error":"not found"}');
      } else {
        response.write(jsonEncode({
          "database": {
            "Name": name,
            "group": group,
            "Hostname": "$name.turso.io"
          }
        }));
      }
    } else if (request.method == "POST" && request.uri.path == prefix) {
      final body = jsonDecode(await utf8.decoder.bind(request).join()) as Map;
      databasePosts.add(Map<String, dynamic>.from(body));
      _existing[body["name"] as String] = body["group"] as String;
      response.write(jsonEncode({
        "database": {"Name": body["name"]}
      }));
    } else {
      response.statusCode = HttpStatus.notFound;
    }
    await response.close();
  }

  Future<void> close() => _server.close(force: true);
}
