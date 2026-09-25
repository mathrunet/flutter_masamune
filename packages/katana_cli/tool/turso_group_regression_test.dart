import "dart:convert";
import "dart:io";

import "package:katana_cli/action/cloudflare/turso.dart";
import "package:katana_cli/action/cloudflare/turso_platform_api.dart";
import "package:katana_cli/katana_cli.dart";

/// Turso group自動作成（Platform API）の回帰テスト。
Future<void> main() async {
  final server = await _FakeTursoPlatformApi.start();
  try {
    await _testCreatesOnlyMissingGroups(server);
    await _testConflictIsSuccess(server);
    await _testUnauthorized(server);
    await _testOtherFailure(server);
    await _testActionCreatesGroupsBeforeSecret(server);
  } finally {
    await server.close();
  }
  stdout.writeln("Turso group regression checks passed");
}

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

const _groups = [
  {
    "name": "prod-apac",
    "location": "aws-ap-northeast-1",
    "continents": ["AS", "OC"],
  },
  {
    "name": "prod-us",
    "location": "aws-us-east-1",
    "continents": ["NA", "SA"],
  },
  {
    "name": "prod-eu",
    "location": "aws-eu-west-1",
    "continents": ["EU", "AF"],
  },
  // locationがないgroupは既存groupとして扱い、作成しない。
  {"name": "legacy"},
];

TursoPlatformApi _api(_FakeTursoPlatformApi server) => TursoPlatformApi(
      token: "test-token",
      baseUrl: server.baseUrl,
    );

/// 存在しないgroupだけPOSTし、2回目はPOSTしない。
Future<void> _testCreatesOnlyMissingGroups(_FakeTursoPlatformApi server) async {
  server.reset(existing: {"prod-apac": "aws-ap-northeast-1"});
  final groups = CloudflareTursoCliAction.parseTursoGroups(_groups);
  _check(groups.first["location"] == "aws-ap-northeast-1",
      "parseTursoGroups must keep location.");
  _check(!groups.last.containsKey("location"),
      "A group without location must not get one.");
  final api = _api(server);
  try {
    final created = await ensureTursoGroups(
      api: api,
      organization: "test-org",
      groups: groups,
    );
    _check(created.join(",") == "prod-us,prod-eu",
        "Only missing groups with location must be created: $created");
    _check(
        server.posts
                .map((post) => "${post["name"]}@${post["location"]}")
                .join(",") ==
            "prod-us@aws-us-east-1,prod-eu@aws-eu-west-1",
        "POST bodies are wrong: ${server.posts}");
    _check(
        server.requests.every((request) =>
            request.authorization == "Bearer test-token" &&
            request.path == "/v1/organizations/test-org/groups"),
        "Requests must use the Bearer token and the groups endpoint.");
    _check(!server.posts.any((post) => post["name"] == "legacy"),
        "A group without location must not be created.");
    server.requests.clear();
    server.posts.clear();
    final second = await ensureTursoGroups(
      api: api,
      organization: "test-org",
      groups: groups,
    );
    _check(second.isEmpty && server.posts.isEmpty,
        "The second run must not POST: ${server.posts}");
    _check(
        server.requests.length == 1 && server.requests.single.method == "GET",
        "The second run must only list groups.");
    // primaryが異なる既存groupは警告のみで変更しない。
    server.reset(existing: {
      "prod-apac": "aws-us-west-2",
      "prod-us": "aws-us-east-1",
      "prod-eu": "aws-eu-west-1",
    });
    final mismatch = await ensureTursoGroups(
      api: api,
      organization: "test-org",
      groups: groups,
    );
    _check(mismatch.isEmpty && server.posts.isEmpty,
        "An existing group with another primary must not be modified.");
  } finally {
    api.close();
  }
}

/// 409は成功扱い。
Future<void> _testConflictIsSuccess(_FakeTursoPlatformApi server) async {
  server
      .reset(existing: {}, conflictNames: {"prod-us", "prod-apac", "prod-eu"});
  final api = _api(server);
  try {
    final created = await ensureTursoGroups(
      api: api,
      organization: "test-org",
      groups: CloudflareTursoCliAction.parseTursoGroups(_groups),
    );
    _check(created.isEmpty && server.posts.length == 3,
        "HTTP 409 must be treated as success without creation.");
  } finally {
    api.close();
  }
}

/// 401/403はorganization全体のtokenが必要な旨を明示する。
Future<void> _testUnauthorized(_FakeTursoPlatformApi server) async {
  for (final target in ["list", "create"]) {
    server.reset(
      existing: {},
      listStatus: target == "list" ? 403 : null,
      createStatus: target == "create" ? 401 : null,
    );
    final api = _api(server);
    try {
      await ensureTursoGroups(
        api: api,
        organization: "test-org",
        groups: CloudflareTursoCliAction.parseTursoGroups(_groups),
      );
      throw StateError("An unauthorized token must fail ($target).");
    } on StateError catch (e) {
      _check(
          e.message.contains("organization-wide") &&
              e.message.contains("organization全体"),
          "The unauthorized error must explain the token scope: ${e.message}");
    } finally {
      api.close();
    }
  }
}

/// その他の失敗はレスポンス本文とプランの案内を含めて停止する。
Future<void> _testOtherFailure(_FakeTursoPlatformApi server) async {
  server.reset(existing: {}, createStatus: 400);
  final api = _api(server);
  try {
    await ensureTursoGroups(
      api: api,
      organization: "test-org",
      groups: CloudflareTursoCliAction.parseTursoGroups(_groups),
    );
    throw StateError("A failed group creation must stop.");
  } on StateError catch (e) {
    _check(
        e.message.contains("fixture-failure-body") &&
            e.message.contains("HTTP 400") &&
            e.message.contains("Scaler"),
        "The failure must include the body and the plan hint: ${e.message}");
    _check(
        server.posts.length == 1, "Creation must stop at the first failure.");
  } finally {
    api.close();
  }
}

/// actionはsecret putの前にgroupを作成し、TURSO_GROUPSからlocationを除く。
Future<void> _testActionCreatesGroupsBeforeSecret(
    _FakeTursoPlatformApi server) async {
  final previous = Directory.current;
  final temp = Directory.systemTemp.createTempSync("katana-turso-groups-");
  try {
    Directory.current = temp;
    Directory("cloudflare/src").createSync(recursive: true);
    File("cloudflare/src/edge.ts").writeAsStringSync("""
import * as m from "@mathrunet/masamune_cloudflare";
export default m.deploy([
], { type: "edge" });
""");
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{\n  "name": "app",\n  "main": "src/edge.ts"\n}\n');
    File("pubspec.yaml").writeAsStringSync(
        "name: test_app\ndependencies:\n  masamune_model_turso: ^3.9.0\n");
    File("cloudflare/package.json").writeAsStringSync(jsonEncode({
      "dependencies": {"@mathrunet/masamune_cloudflare_turso": "test"}
    }));
    final secretMarker = "${temp.path}/secret-called";
    final fake = File("${temp.path}/fake-wrangler.sh");
    fake.writeAsStringSync(
        "#!/bin/sh\ncat >/dev/null\nprintf '%s\\n' \"\$*\" >> $secretMarker\n");
    await Process.run("chmod", ["+x", fake.path]);
    server.reset(existing: {"prod-apac": "aws-ap-northeast-1"});
    server.onPost = () {
      _check(!File(secretMarker).existsSync(),
          "Groups must be created before the secret is put.");
    };
    final action =
        CloudflareTursoCliAction(platformApiBaseUrl: server.baseUrl.toString());
    final context = ExecContext(yaml: {
      "bin": {"wrangler": fake.path},
      "cloudflare": {
        "project_id": "app",
        "turso": {
          "enable": true,
          "organization": "test-org",
          "group": "prod-apac",
          "groups": _groups,
          "platform_api_token": "test-token",
        }
      },
    }, args: const []);
    await action.exec(context);
    _check(
        server.posts.map((post) => post["name"]).join(",") == "prod-us,prod-eu",
        "The action must create only missing groups: ${server.posts}");
    _check(
        File(secretMarker)
            .readAsStringSync()
            .contains("secret put TURSO_PLATFORM_API_TOKEN"),
        "The Platform API token secret must be put.");
    final wrangler = File("cloudflare/wrangler.jsonc").readAsStringSync();
    final encoded = RegExp(r'"TURSO_GROUPS"\s*:\s*("(?:[^"\\]|\\.)*")')
        .firstMatch(wrangler)
        ?.group(1);
    _check(encoded != null, "TURSO_GROUPS must be written: $wrangler");
    final groups = jsonDecode(jsonDecode(encoded!) as String) as List;
    _check(
        groups.length == 4 &&
            groups.every((group) => !(group as Map).containsKey("location")) &&
            (groups.first as Map)["continents"].join(",") == "AS,OC",
        "TURSO_GROUPS must not contain location: $groups");
    server.onPost = null;
    server.posts.clear();
    await action.exec(context);
    _check(server.posts.isEmpty, "Re-applying must not create groups again.");
  } finally {
    Directory.current = previous;
    temp.deleteSync(recursive: true);
  }
}

class _Request {
  _Request(this.method, this.path, this.authorization);

  final String method;
  final String path;
  final String? authorization;
}

/// ループバックで動くfake Turso Platform API。
class _FakeTursoPlatformApi {
  _FakeTursoPlatformApi._(this._server) {
    _server.listen(_handle);
  }

  static Future<_FakeTursoPlatformApi> start() async {
    return _FakeTursoPlatformApi._(
        await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
  }

  final HttpServer _server;
  final requests = <_Request>[];
  final posts = <Map<String, dynamic>>[];
  var _existing = <String, String>{};
  var _conflictNames = <String>{};
  int? _listStatus;
  int? _createStatus;
  void Function()? onPost;

  Uri get baseUrl => Uri.parse("http://127.0.0.1:${_server.port}");

  void reset({
    required Map<String, String> existing,
    Set<String> conflictNames = const {},
    int? listStatus,
    int? createStatus,
  }) {
    requests.clear();
    posts.clear();
    _existing = Map.of(existing);
    _conflictNames = Set.of(conflictNames);
    _listStatus = listStatus;
    _createStatus = createStatus;
  }

  Future<void> _handle(HttpRequest request) async {
    requests.add(_Request(
      request.method,
      request.uri.path,
      request.headers.value(HttpHeaders.authorizationHeader),
    ));
    final response = request.response;
    response.headers.contentType = ContentType.json;
    if (request.method == "GET") {
      if (_listStatus != null) {
        response.statusCode = _listStatus!;
        response.write('{"error":"fixture-list-failure"}');
      } else {
        response.write(jsonEncode({
          "groups": [
            for (final entry in _existing.entries)
              {
                "name": entry.key,
                "primary": entry.value,
                "locations": [entry.value],
              }
          ],
        }));
      }
    } else if (request.method == "POST") {
      final body = jsonDecode(await utf8.decoder.bind(request).join()) as Map;
      posts.add(Map<String, dynamic>.from(body));
      try {
        onPost?.call();
      } on Object catch (e) {
        response.statusCode = 500;
        response.write(jsonEncode({"error": e.toString()}));
        await response.close();
        return;
      }
      final name = body["name"] as String;
      if (_createStatus != null) {
        response.statusCode = _createStatus!;
        response.write('{"error":"fixture-failure-body"}');
      } else if (_conflictNames.contains(name) || _existing.containsKey(name)) {
        response.statusCode = HttpStatus.conflict;
        response.write('{"error":"group already exists"}');
      } else {
        _existing[name] = body["location"] as String;
        response.write(jsonEncode({
          "group": {"name": name, "primary": body["location"]}
        }));
      }
    } else {
      response.statusCode = HttpStatus.methodNotAllowed;
    }
    await response.close();
  }

  Future<void> close() => _server.close(force: true);
}
