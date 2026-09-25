import "dart:io";

import "package:katana_cli/action/cloudflare/deploy.dart";
import "package:katana_cli/action/cloudflare/pages.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  await _testApplyCreatesProjectAndDomain();
  await _testApplyCreatesPublicDir();
  await _testDeployPagesOnly();
  await _testDeployWorkersThenPages();
  stdout.writeln("Cloudflare Pages regression checks passed");
}

/// applyはPagesプロジェクトとカスタムドメインを存在しない場合だけ作成する。
Future<void> _testApplyCreatesProjectAndDomain() async {
  await _inTemporaryProject("katana-pages-apply-", (root) async {
    Directory("cloudflare").createSync();
    final wrangler = _writeFakeWrangler(root);
    final yaml = _yaml(wrangler, workers: false);
    const action = CloudflarePagesCliAction();
    _check(
      action.checkEnabled(_context(yaml, "dev")),
      "Pages must be enabled by [cloudflare]->[pages]->[enable].",
    );
    await action.exec(_context(yaml, "dev"));
    await action.exec(_context(yaml, "dev"));
    var calls = _calls(root);
    _check(
      calls
                  .where((call) =>
                      call ==
                      "pages project create app-dev --production-branch main")
                  .length ==
              1 &&
          calls
                  .where((call) =>
                      call ==
                      "pages domain add dev.example.com --project-name app-dev")
                  .length ==
              1 &&
          calls.indexOf(
                  "pages project create app-dev --production-branch main") <
              calls.indexOf(
                  "pages domain add dev.example.com --project-name app-dev"),
      "The dev project and domain must be created once in order: $calls",
    );
    _clearCalls(root);
    await action.exec(_context(yaml, "prod"));
    calls = _calls(root);
    _check(
      calls.contains("pages project create app --production-branch main") &&
          calls.contains("pages domain add example.com --project-name app"),
      "The prod project must use project_id when project_name is empty: $calls",
    );
    // custom_domainが空ならdomainを操作しない。
    _clearCalls(root);
    ((yaml["cloudflare"] as Map)["pages"] as Map)["custom_domain"] = null;
    await action.exec(_context(yaml, "dev"));
    _check(
      !_calls(root).any((call) => call.startsWith("pages domain")),
      "No domain command must run without custom_domain: ${_calls(root)}",
    );
  });
}

/// applyは公開ディレクトリが無い場合だけ最小のindex.htmlを含めて作成し、既存の内容は変更しない。
Future<void> _testApplyCreatesPublicDir() async {
  await _inTemporaryProject("katana-pages-public-", (root) async {
    Directory("cloudflare").createSync();
    final wrangler = _writeFakeWrangler(root);
    final yaml = _yaml(wrangler, workers: false);
    const action = CloudflarePagesCliAction();
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

Map<String, Object> _yaml(File wrangler,
    {required bool workers, File? flutter}) {
  return {
    "bin": {
      "wrangler": wrangler.path,
      if (flutter != null) "flutter": flutter.path,
    },
    "cloudflare": {
      "project_id": {"dev": "app-dev", "prod": "app"},
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

/// 呼び出しを記録するfake wrangler。Pagesのprojectとdomainは状態ファイルで管理する。
File _writeFakeWrangler(Directory root) {
  final wrangler = File("${root.path}/fake-wrangler.sh");
  final calls = "${root.path}/wrangler-calls.txt";
  final projects = "${root.path}/projects.txt";
  final domains = "${root.path}/domains.txt";
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
  "pages domain list "*)
    if [ -f "$domains" ]; then
      while IFS= read -r line; do printf '│ %s │ active │\\n' "\$line"; done < "$domains"
    fi
    exit 0 ;;
  "pages domain add "*) echo "\$4" >> "$domains"; exit 0 ;;
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

ExecContext _context(Map<String, Object> yaml, String flavor) {
  final args = ["apply", "--flavor", flavor];
  final resolved = FlavorContext.resolve(
    yaml: yaml,
    secrets: const {},
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
