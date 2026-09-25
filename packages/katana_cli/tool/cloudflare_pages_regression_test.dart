import "dart:convert";
import "dart:io";

import "package:katana_cli/action/cloudflare/deploy.dart";
import "package:katana_cli/action/cloudflare/pages.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  await _testApplyCreatesProjectAndDomain();
  await _testApplyCreatesCnameForPendingDomain();
  await _testApplyWarnsOnForbidden();
  await _testApplyUsesWranglerCredentials();
  await _testApplyCreatesPublicDir();
  await _testDeployPagesOnly();
  await _testDeployWorkersThenPages();
  stdout.writeln("Cloudflare Pages regression checks passed");
}

/// applyはPagesプロジェクトとカスタムドメイン（Cloudflare API）を存在しない場合だけ作成する。
Future<void> _testApplyCreatesProjectAndDomain() async {
  final server = await _FakeCloudflareApi.start();
  try {
    await _inTemporaryProject("katana-pages-apply-", (root) async {
      Directory("cloudflare").createSync();
      final wrangler = _writeFakeWrangler(root);
      final yaml = _yaml(wrangler, workers: false, accountId: "acc-1");
      final action = server.action();
      _check(
        action.checkEnabled(_context(yaml, "dev")),
        "Pages must be enabled by [cloudflare]->[pages]->[enable].",
      );
      server.newDomainStatus = "active";
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      final calls = _calls(root);
      _check(
        calls
                .where((call) =>
                    call ==
                    "pages project create app-dev --production-branch main")
                .length ==
            1,
        "The dev project must be created once: $calls",
      );
      _check(
        !calls.any((call) => call.startsWith("pages domain")) &&
            !calls.any((call) => call.startsWith("auth")),
        "Wrangler must not be used for domains or tokens with api_token: $calls",
      );
      final posts = server.requests
          .where((r) =>
              r.method == "POST" &&
              r.path == "/accounts/acc-1/pages/projects/app-dev/domains")
          .toList();
      _check(
        posts.length == 1 &&
            posts.single.body?["name"] == "dev.example.com" &&
            server.requests.every((r) => r.authorization == "Bearer secret"),
        "The domain must be attached once with the secret token: ${server.requests}",
      );
      _check(
        !server.requests.any((r) => r.path.contains("dns_records")),
        "An active domain must not touch DNS: ${server.requests}",
      );
      // prodはproject_nameが空ならproject_idを使う。
      server.requests.clear();
      await action.exec(_context(yaml, "prod", secrets: _secrets));
      _check(
        server.requests.any((r) =>
            r.method == "POST" &&
            r.path == "/accounts/acc-1/pages/projects/app/domains" &&
            r.body?["name"] == "example.com"),
        "The prod project must use project_id: ${server.requests}",
      );
      // custom_domainが空ならAPIを呼ばない。
      server.requests.clear();
      ((yaml["cloudflare"] as Map)["pages"] as Map)["custom_domain"] = null;
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      _check(
        server.requests.isEmpty,
        "No API request must be sent without custom_domain: ${server.requests}",
      );
    });
  } finally {
    await server.close();
  }
}

/// pending（CNAME未設定）のドメインは、同じアカウントのzoneにproxiedなCNAMEを1回だけ作る。
Future<void> _testApplyCreatesCnameForPendingDomain() async {
  final server = await _FakeCloudflareApi.start();
  try {
    await _inTemporaryProject("katana-pages-cname-", (root) async {
      Directory("cloudflare").createSync();
      final wrangler = _writeFakeWrangler(root);
      final yaml = _yaml(
        wrangler,
        workers: false,
        accountId: "acc-1",
        zoneId: "zone-1",
      );
      final action = server.action();
      server.domains["dev.example.com"] = "pending";
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      final creates = server.requests
          .where((r) =>
              r.method == "POST" && r.path == "/zones/zone-1/dns_records")
          .toList();
      _check(
        creates.length == 1 &&
            creates.single.body?["type"] == "CNAME" &&
            creates.single.body?["name"] == "dev.example.com" &&
            creates.single.body?["content"] == "app-dev-abc.pages.dev" &&
            creates.single.body?["proxied"] == true,
        "A pending domain must get one proxied CNAME to the pages.dev subdomain: ${server.requests}",
      );
      _check(
        !server.requests.any((r) =>
            r.method == "POST" &&
            r.path.endsWith("/pages/projects/app-dev/domains")),
        "An existing domain must not be attached again: ${server.requests}",
      );
      // 別アカウントのzoneにはCNAMEを作らない（警告のみ）。
      server.requests.clear();
      server.dnsRecords.clear();
      server.zoneAccountId = "other";
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      _check(
        !server.requests.any((r) => r.method == "POST"),
        "A zone of another account must not be modified: ${server.requests}",
      );
    });
  } finally {
    await server.close();
  }
}

/// 403では停止せず警告にとどめる（ドメイン接続・CNAME作成とも）。
Future<void> _testApplyWarnsOnForbidden() async {
  final server = await _FakeCloudflareApi.start();
  try {
    await _inTemporaryProject("katana-pages-forbidden-", (root) async {
      Directory("cloudflare").createSync();
      final wrangler = _writeFakeWrangler(root);
      final yaml = _yaml(
        wrangler,
        workers: false,
        accountId: "acc-1",
        zoneId: "zone-1",
      );
      final action = server.action();
      server.forbidden
          .add("GET /accounts/acc-1/pages/projects/app-dev/domains");
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      _check(
        !server.requests.any((r) => r.method == "POST"),
        "A forbidden domain list must stop only the domain step: ${server.requests}",
      );
      server.forbidden.clear();
      server.requests.clear();
      server.domains["dev.example.com"] = "pending";
      server.forbidden.add("POST /zones/zone-1/dns_records");
      await action.exec(_context(yaml, "dev", secrets: _secrets));
      _check(
        server.requests.any((r) =>
                r.method == "POST" && r.path == "/zones/zone-1/dns_records") &&
            server.dnsRecords.isEmpty,
        "A forbidden CNAME creation must only warn: ${server.requests}",
      );
      // 403以外（500）は従来どおり例外で止める。
      server.forbidden.clear();
      server.failures.add("GET /accounts/acc-1/pages/projects/app-dev/domains");
      var failed = false;
      try {
        await action.exec(_context(yaml, "dev", secrets: _secrets));
      } on Exception {
        failed = true;
      }
      _check(failed, "A server error must still stop apply.");
    });
  } finally {
    await server.close();
  }
}

/// api_tokenとaccount_idが無ければ`wrangler auth token`と`wrangler whoami`を使う。
Future<void> _testApplyUsesWranglerCredentials() async {
  final server = await _FakeCloudflareApi.start();
  try {
    await _inTemporaryProject("katana-pages-wrangler-auth-", (root) async {
      Directory("cloudflare").createSync();
      final wrangler = _writeFakeWrangler(root);
      final yaml = _yaml(wrangler, workers: false);
      server.newDomainStatus = "active";
      await server.action(environment: const {}).exec(_context(yaml, "dev"));
      _check(
        _calls(root).contains("auth token --json") &&
            _calls(root).contains("whoami --json"),
        "Wrangler credentials must be used as a fallback: ${_calls(root)}",
      );
      _check(
        server.requests.isNotEmpty &&
            server.requests
                .every((r) => r.authorization == "Bearer oauth-token") &&
            server.requests.any((r) =>
                r.method == "POST" &&
                r.path == "/accounts/acc-1/pages/projects/app-dev/domains"),
        "The wrangler token and account must be used: ${server.requests}",
      );
      // 環境変数CLOUDFLARE_API_TOKENはwranglerより優先する。
      server.requests.clear();
      _clearCalls(root);
      await server.action(environment: const {
        "CLOUDFLARE_API_TOKEN": "env-token",
        "CLOUDFLARE_ACCOUNT_ID": "acc-1",
      }).exec(_context(yaml, "dev"));
      _check(
        !_calls(root).contains("auth token --json") &&
            server.requests.every((r) => r.authorization == "Bearer env-token"),
        "CLOUDFLARE_API_TOKEN must take precedence: ${server.requests}",
      );
    });
  } finally {
    await server.close();
  }
}

const _secrets = <String, Object?>{
  "cloudflare": {"api_token": "secret"},
};

/// applyは公開ディレクトリが無い場合だけ最小のindex.htmlを含めて作成し、既存の内容は変更しない。
Future<void> _testApplyCreatesPublicDir() async {
  await _inTemporaryProject("katana-pages-public-", (root) async {
    Directory("cloudflare").createSync();
    final wrangler = _writeFakeWrangler(root);
    final yaml = _yaml(wrangler, workers: false);
    // 実際のCloudflare APIを呼ばないようにカスタムドメインを外す。
    ((yaml["cloudflare"] as Map)["pages"] as Map)["custom_domain"] = null;
    const action = CloudflarePagesCliAction(environment: {});
    await action.exec(_context(yaml, "dev"));
    final index = File("cloudflare/pages/index.html");
    _check(
      index.existsSync() && index.readAsStringSync().contains("<html"),
      "apply must create the default public directory with index.html.",
    );
    index.writeAsStringSync("custom");
    File("cloudflare/pages/_headers").writeAsStringSync("/*\n");
    await action.exec(_context(yaml, "dev"));
    _check(
      index.readAsStringSync() == "custom" &&
          File("cloudflare/pages/_headers").existsSync(),
      "apply must not overwrite an existing public directory.",
    );
    // public_dirを指定した場合はそのディレクトリを作成する。
    ((yaml["cloudflare"] as Map)["pages"] as Map)["public_dir"] = "web_public";
    await action.exec(_context(yaml, "dev"));
    _check(
      File("web_public/index.html").existsSync(),
      "apply must create the configured public_dir.",
    );
    _check(
      !_calls(root).any((call) => call.startsWith("flutter")),
      "apply must never build Flutter web: ${_calls(root)}",
    );
  });
}

/// Workers無効・Pages有効ならWorkersをデプロイせず、ビルドせずに公開ディレクトリだけデプロイする。
Future<void> _testDeployPagesOnly() async {
  await _inTemporaryProject("katana-pages-deploy-", (root) async {
    Directory("cloudflare").createSync();
    Directory("dart_defines").createSync();
    File("dart_defines/dev.env").writeAsStringSync("FLAVOR=dev\n");
    final wrangler = _writeFakeWrangler(root);
    final flutter = _writeFakeFlutter(root);
    final yaml = _yaml(wrangler, workers: false, flutter: flutter);
    const action = CloudflareDeployCliAction();
    _check(
      action.checkEnabled(_context(yaml, "dev")),
      "Deploy must be enabled when only Pages is enabled.",
    );
    // 公開ディレクトリが無い場合はデプロイせずに停止する。
    var failed = false;
    try {
      await action.exec(_context(yaml, "dev"));
    } on StateError catch (e) {
      failed = e.message.contains("cloudflare/pages");
    }
    _check(
      failed && _calls(root).isEmpty,
      "A missing public directory must stop before any command: ${_calls(root)}",
    );
    // 空の公開ディレクトリでもデプロイせずに停止する。
    Directory("cloudflare/pages/.well-known").createSync(recursive: true);
    failed = false;
    try {
      await action.exec(_context(yaml, "dev"));
    } on StateError {
      failed = true;
    }
    _check(
      failed && _calls(root).isEmpty,
      "An empty public directory must stop before any command: ${_calls(root)}",
    );
    // 静的ファイルだけでもそのままデプロイする。
    File("cloudflare/pages/.well-known/apple-app-site-association")
        .writeAsStringSync("{}");
    await action.exec(_context(yaml, "dev"));
    _check(
      _calls(root).join("\n") ==
          "pages deploy cloudflare/pages --project-name app-dev --branch main --commit-dirty=true",
      "Pages-only deploy must deploy the public directory without building: ${_calls(root)}",
    );
    _clearCalls(root);
    await action.exec(_context(yaml, "prod"));
    _check(
      _calls(root).join("\n") ==
          "pages deploy cloudflare/pages --project-name app --branch main --commit-dirty=true",
      "Prod deploy must use project_id without building: ${_calls(root)}",
    );
    // public_dirを指定した場合はそのディレクトリをデプロイする。
    _clearCalls(root);
    Directory("custom_public").createSync();
    File("custom_public/index.html").writeAsStringSync("<html></html>");
    ((yaml["cloudflare"] as Map)["pages"] as Map)["public_dir"] =
        "custom_public";
    await action.exec(_context(yaml, "dev"));
    _check(
      _calls(root).join("\n") ==
          "pages deploy custom_public --project-name app-dev --branch main --commit-dirty=true",
      "Deploy must use the configured public_dir: ${_calls(root)}",
    );
  });
}

/// Workers有効ならedge Workerをデプロイした後にPagesをデプロイする。
Future<void> _testDeployWorkersThenPages() async {
  await _inTemporaryProject("katana-pages-deploy-workers-", (root) async {
    Directory("cloudflare/src").createSync(recursive: true);
    File("cloudflare/src/edge.ts").writeAsStringSync(
      'import * as m from "@mathrunet/masamune_cloudflare";\nexport default m.deploy([], { type: "edge" });\n',
    );
    File("cloudflare/wrangler.jsonc").writeAsStringSync("""
{
  "name": "app",
  "main": "src/edge.ts",
  ${WranglerEnvironmentSynchronizer.beginMarker}
  "env": {
    "dev": { "name": "app-dev", "vars": { "FLAVOR": "dev" } }
  },
  ${WranglerEnvironmentSynchronizer.endMarker}
}
""");
    Directory("cloudflare/pages").createSync();
    File("cloudflare/pages/index.html").writeAsStringSync("<html></html>");
    final wrangler = _writeFakeWrangler(root);
    final flutter = _writeFakeFlutter(root);
    final yaml = _yaml(wrangler, workers: true, flutter: flutter);
    await const CloudflareDeployCliAction().exec(_context(yaml, "dev"));
    final calls = _calls(root);
    _check(
      calls.join("\n") ==
          [
            "deployments list --json --env dev",
            "deploy --env dev",
            "pages deploy cloudflare/pages --project-name app-dev --branch main --commit-dirty=true",
          ].join("\n"),
      "Workers must be deployed before Pages: $calls",
    );
  });
}

Map<String, Object> _yaml(
  File wrangler, {
  required bool workers,
  File? flutter,
  String? accountId,
  String? zoneId,
}) {
  return {
    "bin": {
      "wrangler": wrangler.path,
      if (flutter != null) "flutter": flutter.path,
    },
    "cloudflare": {
      "project_id": {"dev": "app-dev", "prod": "app"},
      if (accountId != null) "account_id": accountId,
      if (zoneId != null) "zone_id": zoneId,
      "workers": {"enable": workers},
      "pages": <String, Object?>{
        "enable": true,
        "project_name": <String, Object?>{"dev": "app-dev", "prod": null},
        "custom_domain": <String, Object?>{
          "dev": "dev.example.com",
          "prod": "example.com",
        },
      },
    },
  };
}

/// 呼び出しを記録するfake wrangler。Pagesのprojectは状態ファイルで管理する。
File _writeFakeWrangler(Directory root) {
  final wrangler = File("${root.path}/fake-wrangler.sh");
  final calls = "${root.path}/wrangler-calls.txt";
  final projects = "${root.path}/projects.txt";
  wrangler.writeAsStringSync("""
#!/bin/sh
printf '%s\\n' "\$*" >> "$calls"
case "\$*" in
  "pages project list")
    printf '┌──────────────┬───────────────┐\\n│ Project Name │ Project Domain│\\n'
    if [ -f "$projects" ]; then
      while IFS= read -r name; do printf '│ %s │ %s.pages.dev │\\n' "\$name" "\$name"; done < "$projects"
    fi
    exit 0 ;;
  "pages project create "*) echo "\$4" >> "$projects"; exit 0 ;;
  "auth token --json") printf '{"type":"oauth","token":"oauth-token"}'; exit 0 ;;
  "whoami --json") printf '{"loggedIn":true,"accounts":[{"id":"acc-1","name":"a"}]}'; exit 0 ;;
esac
exit 0
""");
  Process.runSync("chmod", ["+x", wrangler.path]);
  return wrangler;
}

/// 呼び出しを記録するfake flutter。deploy/applyから呼ばれないことの検証に使う。
File _writeFakeFlutter(Directory root) {
  final flutter = File("${root.path}/fake-flutter.sh");
  final calls = "${root.path}/wrangler-calls.txt";
  flutter.writeAsStringSync("""
#!/bin/sh
printf 'flutter %s\\n' "\$*" >> "$calls"
exit 0
""");
  Process.runSync("chmod", ["+x", flutter.path]);
  return flutter;
}

ExecContext _context(
  Map<String, Object> yaml,
  String flavor, {
  Map<String, Object?> secrets = const {},
}) {
  final args = ["apply", "--flavor", flavor];
  final resolved = FlavorContext.resolve(
    yaml: yaml,
    secrets: secrets,
    arguments: args,
  );
  return ExecContext(
    yaml: resolved.yaml,
    secrets: resolved.secrets,
    args: args,
    flavorContext: resolved,
  );
}

Future<void> _inTemporaryProject(
  String prefix,
  Future<void> Function(Directory root) body,
) async {
  final previous = Directory.current;
  final root = Directory.systemTemp.createTempSync(prefix);
  try {
    Directory.current = root;
    await body(root);
  } finally {
    Directory.current = previous;
    root.deleteSync(recursive: true);
  }
}

List<String> _calls(Directory root) {
  final file = File("${root.path}/wrangler-calls.txt");
  return file.existsSync() ? file.readAsLinesSync() : const [];
}

void _clearCalls(Directory root) {
  final file = File("${root.path}/wrangler-calls.txt");
  if (file.existsSync()) {
    file.deleteSync();
  }
}

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

/// Cloudflare APIのfake（ループバックHTTPサーバー）。
class _FakeCloudflareApi {
  _FakeCloudflareApi._(this._server) {
    _server.listen(_handle);
  }

  static Future<_FakeCloudflareApi> start() async {
    return _FakeCloudflareApi._(
        await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
  }

  final HttpServer _server;
  final requests = <_Request>[];
  final domains = <String, String>{};
  final dnsRecords = <Map<String, Object?>>[];
  final forbidden = <String>{};
  final failures = <String>{};
  String newDomainStatus = "initializing";
  String zoneAccountId = "acc-1";

  CloudflarePagesCliAction action({Map<String, String>? environment}) {
    return CloudflarePagesCliAction(
      apiBaseUrl: "http://127.0.0.1:${_server.port}/client/v4",
      environment: environment ?? const {},
    );
  }

  Future<void> close() => _server.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    final content = await utf8.decoder.bind(request).join();
    final path = request.uri.path.replaceFirst("/client/v4", "");
    final body = content.isEmpty ? null : jsonDecode(content) as Map;
    requests.add(_Request(
      request.method,
      path,
      request.headers.value(HttpHeaders.authorizationHeader),
      body,
    ));
    final key = "${request.method} $path";
    final response = request.response;
    response.headers.contentType = ContentType.json;
    Object? result;
    if (forbidden.contains(key)) {
      response.statusCode = HttpStatus.forbidden;
      response.write(jsonEncode({
        "success": false,
        "errors": [
          {"code": 10000, "message": "Authentication error"}
        ],
      }));
      await response.close();
      return;
    }
    if (failures.contains(key)) {
      response.statusCode = HttpStatus.internalServerError;
      response.write('{"success":false}');
      await response.close();
      return;
    }
    final domainsPath =
        RegExp(r"^/accounts/([^/]+)/pages/projects/([^/]+)/domains$");
    final projectPath = RegExp(r"^/accounts/([^/]+)/pages/projects/([^/]+)$");
    if (domainsPath.hasMatch(path) && request.method == "GET") {
      result = domains.entries
          .map((e) => {
                "name": e.key,
                "status": e.value,
                if (e.value == "pending")
                  "verification_data": {
                    "status": "pending",
                    "error_message": "CNAME record not set",
                  },
              })
          .toList();
    } else if (domainsPath.hasMatch(path) && request.method == "POST") {
      final name = body!["name"] as String;
      domains[name] = newDomainStatus;
      result = {"name": name, "status": newDomainStatus};
    } else if (projectPath.hasMatch(path)) {
      result = {
        "subdomain": "${projectPath.firstMatch(path)!.group(2)}-abc.pages.dev"
      };
    } else if (path == "/zones/zone-1" && request.method == "GET") {
      result = {
        "name": "example.com",
        "account": {"id": zoneAccountId},
      };
    } else if (path == "/zones/zone-1/dns_records" && request.method == "GET") {
      final name = request.uri.queryParameters["name"];
      result = dnsRecords.where((e) => e["name"] == name).toList();
    } else if (path == "/zones/zone-1/dns_records" &&
        request.method == "POST") {
      dnsRecords.add(Map<String, Object?>.from(body!));
      result = body;
    } else {
      response.statusCode = HttpStatus.notFound;
      response.write('{"success":false}');
      await response.close();
      return;
    }
    response.write(jsonEncode({"success": true, "result": result}));
    await response.close();
  }
}

class _Request {
  const _Request(this.method, this.path, this.authorization, this.body);

  final String method;
  final String path;
  final String? authorization;
  final Map? body;

  @override
  String toString() => "$method $path";
}
